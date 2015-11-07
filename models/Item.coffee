mongoose = require('mongoose')

ItemSchema = new mongoose.Schema({
  id: { type: Number, required: true, index: true, unique: true }
  name: { type: String, required: true, unique: true}
  level: Number
  ilevel: Number
  class: String
  npc_price: Number
  craft_class: String
  repair_level: Number
  repair_material: Number
  physical_damage: Number
  auto_attack: Number
  delay: Number
  strength: Number
  dexterity: Number
  vitality: Number
  intelligence: Number
  mind: Number
  piety: Number
  spell_speed: Number
  skill_speed: Number
  parry: Number
  crit: Number
  convert: Boolean
  projectable: Boolean
  desynthesizable: Boolean
  dyeable: Boolean
  crest: Boolean
  tradeable: Boolean
  lodestone_code: String
  })

RecipeSchema = new mongoose.Schema({
  id: { type: Number, required: true, index: true, unique: true }
  yield: Number
  min_craftsmanship: Number
  min_control: Number
  difficulty: Number
  durability: Number
  max_quality: Number
  quick_synth: Boolean
  lodestone_code: String
  hq_possible: Boolean
  craft_mats: [
    item: Number
    quantity: Number
    ]
  })

GatherSchema = new mongoose.Schema({
  id: { type: Number, required: true, index: true, unique: true }
  gather_class: String
  stars: Number
  level: Number
  min_gathering: Number
  min_perception: Number
  locations: [
    x: Number
    y: Number
    zone: String
    area: String
    level: Number
    ]
  unspoiled: Boolean
  time: {
    hour: Number
    minute: Number
    }
  duration: {
    hour: Number
    minute: Number
    }
  lodestone_code: String
  })

VendorSchema = new mongoose.Schema({
  name: String
  location: {
    x: Number
    y: Number
    area: String
  }
  items: [
    item: Number
    price: Number
    ]

  })

mongoose.model('Item',ItemSchema)
mongoose.model('Recipe',RecipeSchema)
mongoose.model('Gather',GatherSchema)
mongoose.model('Vendor',VendorSchema)
