mongoose = require('mongoose')
MarketList = mongoose.model('MarketOrderList')
Item = mongoose.model('Item')
Recipe = mongoose.model('Recipe')

get_item_id = (itemIds,name) ->
  for item in itemIds
    if (item.name == name)
      return item.id
  console.log("item not found: " + name)
  return ""

get_item_name = (itemIds,id) ->
  for item in itemIds
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

module.exports = (app) ->
  app.route('/marketorder')
  .get((req, res, next) ->
    #console.log("recieved MarketOrderList get " + JSON.stringify(req.body))
    if (req.query.item == undefined)
      MarketList.find((err,orders) ->
        if (err)
          console.log(err)
          return next(err)
        itemIds = new Array()
        for order in orders
          if (itemIds.indexOf(order.item) == -1)
            itemIds.push(order.item)
        itemIds.sort((a,b) -> a-b)
        res.send(itemIds)
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
      #items in recipes not in database
      UnknownItems = new Array()
      Recipe.distinct("craft_mats.item", (err,craft_mats) ->
        res.status(200)
        MarketList.distinct("id", (err,order_mats) ->
          craft_mats.forEach((item) ->
            if (order_mats.indexOf(item) == -1)
              UnknownItems.push(item)
            )

          ItemNames = new Array()
          UnknownItems.forEach((item_id) ->
            ItemNames.push(get_item_name(itemArray,item_id))
            )
          res.send(ItemNames)
          )
        )
      )

    )


  console.log("Market routes loaded")
