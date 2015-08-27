mongoose = require('mongoose')
MarketList = mongoose.model('MarketOrderList')
MarketOrder = mongoose.model('MarketOrder')

module.exports = (app) ->
  app.route('/marketorder')
  .get((req, res, next) ->
    #console.log("recieved MarketOrderList get " + JSON.stringify(req.body))
    if (req.body == null)
      res.status(500)
      res.render("error: no body attached")
      return

    if (req.body.item <= 0)
      res.status(500)
      res.render('error: invalid item number')
      return

    MarketOrderList.find((err,orders) ->
      if (err)
        console.log(err)
        return next(err)
      res.json(orders)
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

  .put((req,res,next) ->
    res.render('not implimented yet')
  )

  console.log("Market routes loaded")
