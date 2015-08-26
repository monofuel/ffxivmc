mongoose = require('mongoose')

MarketOrderSchema = new mongoose.Schema({
  Price: Number
  Quantity: Number
  HQ: Boolean
  MarketCode: Number
  Retainer: String
  })

mongoose.model('MarketOrder',MarketOrderSchema)

MarketOrderListSchema = new mongoose.Schema({
  item: Number
  timestamp: Number
  orders: [MarketOrderSchema]
  })

mongoose.model('MarketOrderList',MarketOrderListSchema)
