mongoose = require('mongoose')

MarketOrderSchema = new mongoose.Schema({
  item: Number
  Price: Number
  Quantity: Number
  HQ: Boolean
  MarketCode: Number
  Retainer: Number
  })
