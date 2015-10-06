
mongoose = require('mongoose')
MarketList = mongoose.model('MarketOrderList')
Item = mongoose.model('Item')
Recipe = mongoose.model('Recipe')
Vendor = mongoose.model('Vendor')
async = require('async')

itemIds = {}

get_item_id = (name) ->
  for item in itemIds
    if (item == undefined)
      continue
    if (item.name == name)
      return item.id
  console.log("item not found: " + name)
  return ""

get_item_name = (id) ->
  for item in itemIds
    if (item == undefined)
      continue
    if (item.id == id)
      return item.name
  console.log("item not found: " + id)
  return ""

fetch_item_list = (callback) ->
  Item.find((err,items) ->
    if (err)
      console.log(err)
      return next(err)
    itemArray = new Array()
    for item in items
      itemArray.push({id: item.id,name: item.name})
    callback(itemArray)

    )

fetch_item_price = (id,callback) ->
  async.parallel(
    market_price: (cb) ->
      MarketList.find({item: id}, (err,result) ->
        if (result == null)
          cb(err,
            id: id
            source: "market"
            price: NaN
            )
          return

        result.sort((a,b) ->
          return a.timestamp - b.timestamp
          )

        final_order_list = new Array()

        latest_timestamp = result[0].timestamp
        for i in [0..result.length-1]

          if (result[i].timestamp - latest_timestamp > - 7)
            result[i].orders.forEach((order) ->
              final_order_list.push(order)
              )

        final_order_list.sort((a,b) ->
          return a.price - b.price
          )

        result_item =
          id: id
          source: "market"
          price: final_order_list[0].price

        #console.log("Market price for " + get_item_name(id)+": " + result_item.price)
        cb(err,result_item)
        )
    vendor_price: (cb) ->
      Vendor.findOne({'items.item': id}, (err, result) ->
        if (result == null)
          cb(err,
            id: id
            source: "vendor"
            price: NaN
            )
          return
        result_item =
          id: id
          source: "vendor"
          price: 0

        result.items.forEach((item) ->
          if (item.item == id)
            result_item.price = item.price
          )
        #console.log("Vendor price for "  + get_item_name(id)+": " + result_item.price)
        cb(err,result_item)
        )
    , callback
    )

calculate_price = (id,callback) ->
  #console.log("fetching " + id)
  if (id == null || id == undefined)
    console.trace("id is null")
    return callback("id of null")
  MarketList.find({item: id}, (err,result) ->
    if (result.length == 0)
      return callback("No market data found")

    result.sort((a,b) ->
      return a.timestamp - b.timestamp
      )

    final_order_list = new Array()

    latest_timestamp = result[0].timestamp
    for i in [0..result.length-1]

      if (result[i].timestamp - latest_timestamp > - 7)
        result[i].orders.forEach((order) ->
          final_order_list.push(order)
          )

    final_order_list.sort((a,b) ->
      return a.price - b.price
      )



    result_info =
      id: id
      name:  get_item_name(id)
      market_sell_price: final_order_list[0].price
      actual_price:
        source: ""
        price: 0
      mats: []

    Recipe.findOne({id: id}, (err,result) ->
      if (result == null)
        fetch_item_price(id,(err,result) ->
          lowest = {}
          if (result.vendor_price.price < result.market_price.price)
            lowest = result.vendor_price
          else
            lowest = result.market_price

          result_info.actual_price = lowest
          #console.log("no recipe: " + JSON.stringify(result_info))
          callback(err,result_info)
          )
        return
      async_array = new Array()
      craft_mats = result.craft_mats
      #console.log("craft mats for " + id + ": " + JSON.stringify(result.craft_mats))
      craft_mats.forEach( (mat) ->
        async_array.push(
            (cb) ->
              calculate_price(mat.item,cb)
          )
        )
      async.parallel(async_array,(err,async_result) ->
        result_info.mats = async_result
        result_info.actual_price.source = "crafted"
        #console.log("async result: " +JSON.stringify(async_result))
        async_result.forEach((mat_result) ->
          if (mat_result == undefined)
            return
          result.craft_mats.forEach((mat) ->
            if (mat_result.id == mat.item)
              result_info.actual_price.price += (mat_result.actual_price.price * mat.quantity)
            )
          )
        callback(err,result_info)
        )
      )
    )


module.exports = (app) ->
  app.route('/marketorder')
  .get((req, res, next) ->
    #console.log("recieved MarketOrderList get " + JSON.stringify(req.body))
    if (req.query.item == undefined)
      MarketList.find((err,orders) ->
        if (err)
          console.log(err)
          return next(err)
        all_itemIds = new Array()
        for order in orders
          if (all_itemIds.indexOf(order.item) == -1)
            all_itemIds.push(order.item)
        all_itemIds.sort((a,b) -> a-b)
        res.send(all_itemIds)
        )
      return

    if (req.query.item <= 0)
      res.status(500)
      res.render('error: invalid item number')
      return

    MarketList.findOne({item: req.query.item},(err,orders) ->
      if (err)
        console.log(err)
        return next(err)
      res.send(orders)
      return
    )
  )

  .post((req,res,next) ->
    #console.log("recieved MarketOrderList post " + JSON.stringify(req.body))
    List = new MarketList(req.body)

    if (List == null)
      res.status(500)
      res.render('no market data posted')
      console.log('recieved post without data')
      return

    if (List.item <= 0)
      res.status(500)
      res.render('error: invalid item number')
      console.log('recieved post with invalid item number')
      return

    List.save( (err) ->
      if (err)
        console.log(err)
        return next(err)
    )

    console.log("added new item: " + List.item + " with"
                + List.orders.length + " orders.")
  )
  .delete((req,res,next) ->
    #temp disabled
    res.status(500)
    res.render('Disabled')
    return

    if (req.query == undefined)
      res.status(500)
      res.render('error: invalid item number')
      return

    MarketList.remove({item: req.query.item},(err,order) ->
      if (err)
        console.log(err)
        res.send(err)
      )
    return

  )

  app.route('/marketorder/:list_id')
  .put((req,res,next) ->
    #temp disabled
    res.status(500)
    res.render('Disabled')
    return
    MarketOrder = MarketList.findById(req.params.list_id,(err,order) ->
      order.item = req.body.item
      order.timestamp = req.body.timestamp
      order.orders = req.body.orders
      order.save((err) ->
        if(err)
          console.log(err)
          return next(err)
        console.log("updated " + req.params.list_id)
        return res.send(order)
        )
      )
    )

  .delete((req,res,next) ->
    #temp disabled
    res.status(500)
    res.render('Disabled')
    return


    MarketList.remove({_id: req.params.list_id},(err,order) ->
      if (err)
        console.log(err)
        res.send(err)
      )


    )

  app.route('/desiredorders')
  .get((req, res, next) ->
    fetch_item_list((itemArray) ->
      itemIds = itemArray
      #items in recipes not in database
      Recipe.distinct("craft_mats.item", (err,craft_mats) ->
        Recipe.distinct("id", (err,crafted_items) ->
          craft_mats = craft_mats.concat(crafted_items)
          #filter unique
          craft_mats = craft_mats.filter((value,index,self) ->
            return self.indexOf(value) == index
            )

          MarketList.distinct("item", (err,order_mats) ->
            craft_mats = craft_mats.filter( (e) ->
              return order_mats.indexOf(e) == -1
              )
            ItemNames = new Array()
            craft_mats.forEach((item_id) ->
              ItemNames.push(get_item_name(item_id))
              )
            ItemNames.sort((a,b) ->
              if (a < b)
                return -1
              if (b < a)
                return 1
              return 0
              )
            res.status(200)
            res.send(ItemNames)
            )
          )
        )
      )
    )
  app.route('/bestcrafts')
  .get((req, res, next) ->
    fetch_item_list((itemArray) ->
      itemIds = itemArray
      ###
      calculate_price(4315,(err,result_info) ->
        console.log(get_item_name(4315) +
          " crafting info: " + JSON.stringify(result_info) )
        )
      return
      ###

      recipe_price_list = new Array()
      Recipe.find( (err,allRecipes) ->
        async_all_recipes = new Array()
        allRecipes.forEach( (recipe) ->
          async_all_recipes.push( (cb) ->
            calculate_price(recipe.id,(err,result_info) ->
              if (result_info == null || result_info == undefined)
                return cb()
              #console.log(recipe.id + "crafting info: " + result_info)
              if (result_info.actual_price.price == 0 ||
                result_info.market_sell_price == 0)
                  return cb()

              recipe_price_list.push(
                name: result_info.name
                actual_price: result_info.actual_price
                id: result_info.id
                market_sell_price: result_info.market_sell_price

                )
              cb()
              )
            )
          )

        async.parallel(async_all_recipes,(err) ->
          recipe_price_list.sort((a,b) ->
            a_profit = a.actual_price.price - a.market_sell_price
            b_profit = b.actual_price.price - b.market_sell_price
            return a_profit - b_profit
            )
          res.status(200)
          res.send(recipe_price_list.slice(0,9))
          )
        )
      )
    )

  console.log("Market routes loaded")
