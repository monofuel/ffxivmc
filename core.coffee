mongoose = require('mongoose')

require('./models/MarketOrder')
require('./models/Item')

serverAddress = 'mongodb://localhost/ffxivmc'

module.exports = (app) ->
  mongoose.connect(serverAddress)
  db = mongoose.connection

  console.log('connected to db at serverAddress')


  require('./routes/MarketOrder')(app)
  require('./routes/Item')(app)
