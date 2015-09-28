mongoose = require('mongoose')

MarketOrderListSchema = new mongoose.Schema({
  item: Number
  timestamp: Number
  orders: [
    price: Number
    quantity: Number
    hq: Boolean
    marketcode: Number
    retainer: String
    ]
  })

mongoose.model('MarketOrderList',MarketOrderListSchema)
