mongoose = require('mongoose')
Item = mongoose.model('Item')
Recipe = mongoose.model('Recipe')
Gather = mongoose.model('Gather')

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
          itemIds.push({id: item.id,name: item.name})
        itemIds.sort((a,b) -> a.id-b.id)
        res.send(itemIds)
        )
      return

    if (req.query.id != undefined && req.query.id <= 0)
      res.status(500)
      res.render('error: invalid item number')
      return
    if (req.query.id != undefined)
      Item.findOne({id: req.query.id},(err,orders) ->
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


  app.route('/recipe')
  .get((req, res, next) ->
    if (req.query.id == undefined)
      res.status(500)
      res.render('error: Please give a valid item number')
      return
    if (isNaN(parseInt(req.query.id)) || req.query.name != undefined)
      res.status(500)
      res.render('error: item names are not supported (yet)')
      return
    if (req.query.id != undefined && parseInt(req.query.id) <= 0)
      res.status(500)
      res.render('error: invalid item number')
      return

    Recipe.findOne({id: req.query.id},(err,recipe) ->
      if (err)
        console.log(err)
        return next(err)
      res.send(recipe)
      return
      )
    )
  .post((req,res,next) ->
    NewRecipe = new Recipe(req.body)

    res.status(500)
    res.render('Disabled')
    return

    if (NewRecipe == null)
      res.status(500)
      res.render('no recipe posted')
      console.log('recieved recipe without data')
      return

    if (NewRecipe.id <= 0)
      res.status(500)
      res.render('error: invalid item number')
      console.log('recieved recipe with invalid item number')
      return

    NewRecipe.save( (err) ->
      if (err)
        console.log(err)
        return next(err)
    )
  )
