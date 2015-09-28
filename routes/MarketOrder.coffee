mongoose = require('mongoose')
MarketList = mongoose.model('MarketOrderList')

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

    if (req.query == undefined)
      res.status(500)
      res.render('error: invalid item number')
      return

    MarketList.remove({item: req.query.item},(err,order) ->
        if (err)
          console.log(err);
          res.send(err);
      )
    return

  )

  app.route('/marketorder/:list_id')
  .put((req,res,enext) ->
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
    MarketList.remove({_id: req.params.list_id},(err,order) ->
        if (err)
          console.log(err);
          res.send(err);
      )


    )

  console.log("Market routes loaded")
