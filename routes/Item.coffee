mongoose = require('mongoose')
Item = mongoose.model('Item')

module.exports = (app) ->
  app.route('/item')
  .get((req, res, next) ->
    if (req.query.id == undefined && req.query.name == undefined)
      Item.find((err,items) ->
        if (err)
          console.log(err)
          return next(err)
        itemIds = new Array()
        for item in items
          item.Ids.push({id: item.id,name: item.name})
        itemIds.sort((a,b) -> a.id-b.id)
        res.send(itemIds)
        )
      return

    if (req.query.id != undefined && req.query.id <= 0)
      res.status(500)
      res.render('error: invalid item number')
      return
    if (req.query.id != undefined)
      Item.findOne({item: req.query.id},(err,orders) ->
        if (err)
          console.log(err)
          return next(err)
        res.send(orders)
        return
      )
    else
      Item.findOne({name: req.query.name},(err,orders) ->
        if (err)
          console.log(err)
          return next(err)
        res.send(orders)
        return
      )
  )
