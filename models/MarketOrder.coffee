mongoose = require('mongoose')

MarketOrderSchema = new mongoose.Schema({
  price: Number
  quantity: Number
  hq: Boolean
  marketcode: Number
  retainer: String
  })

mongoose.model('MarketOrder',MarketOrderSchema)

MarketOrderListSchema = new mongoose.Schema({
  item: Number
  timestamp: Number
  orders: [MarketOrderSchema]
  })

mongoose.model('MarketOrderList',MarketOrderListSchema)
