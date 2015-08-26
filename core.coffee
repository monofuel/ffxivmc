mongoose = require('mongoose')

require('./models/MarketOrder')

module.exports = (app) ->
  mongoose.connect('mongodb://192.168.11.160/ffxivmc')
  db = mongoose.connection

  console.log('connected to db')


  require('./routes/MarketOrder')(app)
