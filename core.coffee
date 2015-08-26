mongoose = require('mongoose')
require('./models/MarketOrder')

mongoose.connect('mongodb://localhost/ffxivmc')
db = mongoose.connection
