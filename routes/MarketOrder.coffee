mongoose = require('mongoose')
MarketOrderList = mongoose.model('MarketOrderList')
MarketOrder = mongoose.model('MarketOrder')

module.exports = (app) ->
  app.route('/marketorder')
  .get((req, res, next) ->
    console.log("recieved MarketOrderList get " + JSON.stringify(req.body))
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
        return next(err)
      res.json(orders)
      return
    )
  )

  .post((req,res,next) ->
    console.log("recieved MarketOrderList post " + JSON.stringify(req.body))
    MarketList = new MarketOrderList(req.body)

    if (MarketList == null)
      res.status(500)
      res.render('no market data posted')
      return

    if (MarketList.item <= 0)
      res.status(500)
      res.render('error: invalid item number')
      return

    MarketList.save( (err,post) ->
      if (err)
        return next(err)
      res.json(MarketList)
      return
    )

    console.log("added new item: " + NewMarketOrderList.item)
  )

  .put((req,res,next) ->
    res.render('not implimented yet')
  )

  console.log("Market routes loaded")
