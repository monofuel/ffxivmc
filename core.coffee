mongoose = require('mongoose')

require('./models/MarketOrder')
require('./models/Item')

module.exports = (app) ->
  mongoose.connect('mongodb://localhost/ffxivmc')
  db = mongoose.connection

  console.log('connected to db')


  require('./routes/MarketOrder')(app)
  require('./routes/Item')(app)
