mongoose = require('mongoose')

MarketOrders = require('./models/MarketOrder')
MarketOrder = MarketOrders.order
MarketList = MarketOrders.list

mongoose.connect('mongodb://192.168.11.160/ffxivmc')
db = mongoose.connection

console.log('connected to db')

List = {
  "timestamp": 1440656164,
  "orders": [
    {
      "item": 1752,
      "price": 200,
      "quantity": 1,
      "hq": false,
      "total": 200,
      "marketcode": 60881,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 200,
      "quantity": 1,
      "hq": false,
      "total": 200,
      "marketcode": 60882,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 250,
      "quantity": 1,
      "hq": false,
      "total": 250,
      "marketcode": 60881,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 400,
      "quantity": 1,
      "hq": false,
      "total": 400,
      "marketcode": 60881,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 500,
      "quantity": 1,
      "hq": true,
      "total": 500,
      "marketcode": 60882,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 980,
      "quantity": 1,
      "hq": false,
      "total": 980,
      "marketcode": 60882,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 1000,
      "quantity": 1,
      "hq": false,
      "total": 1000,
      "marketcode": 60881,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 1000,
      "quantity": 1,
      "hq": false,
      "total": 1000,
      "marketcode": 60883,
      "retainer": null
    },
    {
      "item": 1752,
      "price": 3000,
      "quantity": 1,
      "hq": true,
      "total": 3000,
      "marketcode": 60882,
      "retainer": null
    }
  ],
  "item": 1752
}

console.log('creating new list')
list = new MarketList(List)
console.log('list created')
console.log(list)
