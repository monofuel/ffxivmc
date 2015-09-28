mongoose = require('mongoose')

MarketOrders = require('./models/MarketOrder')

MarketList = mongoose.model('MarketOrderList')

mongoose.connect('mongodb://192.168.11.160/ffxivmc')
db = mongoose.connection

console.log('connected to db')

MarketList.find((err,list) ->
  if (err)
    console.log(err)
    return
  marketCodes = new Array()
  for orders in list
    for order in orders.orders
      if (marketCodes.indexOf(order.marketcode) == -1)
        marketCodes.push(order.marketcode)
  marketCodes.sort((a,b) -> a-b)
  console.log(marketCodes)
)

MarketList.find((err,list) ->
  if (err)
    console.log(err)
    return
  for orders in list
    for order in orders.orders
      if (order.marketcode > 4)
        switch (order.marketcode)
          when 60881 then order.marketcode = 1
          when 60882 then order.marketcode = 2
          when 60883 then order.marketcode = 3
          when 60884 then order.marketcode = 4
      order._id = undefined
      order.save((err) ->
        if (err)
          console.log(err)
        )
    orders.save((err) ->
      if (err)
        console.log(err)
    )
  console.log("Done updating")
)
