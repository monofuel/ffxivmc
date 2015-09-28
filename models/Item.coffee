mongoose = require('mongoose')

ItemSchema = new mongoose.Schema({
  id: Number
  name: String
  level: Number
  ilevel: Number
  npc_price: Number
  repair_class: String
  craft_class: String
  gather_class: String
  craft_mats: [
    item: Number
    quantity: Number
    ]
  craft_yield: Number
  min_gathering: Number
  min_perception: Number
  min_craftmanship: Number
  min_control: Number
  vendors: [String]
  monsters: [String]
  locations: [
    x: Number
    y: Number
    area: String
    ]
  unspoiled: Boolean
  time: [
    hour: Number
    minute: Number
    ]
  duration: Number
  })

mongoose.model('Item',ItemSchema)
