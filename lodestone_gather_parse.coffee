mongoose = require('mongoose')
request = require('request')
cheerio = require('cheerio')
fs = require('fs')
require('./models/Item')
Gather = mongoose.model('Gather')
Recipe = mongoose.model('Recipe')
Item = mongoose.model('Item')
mongoose.connect('mongodb://localhost/ffxivmc')
db = mongoose.connection
console.log('connected to db')

itemIds = new Array()

headers = {
  'user-agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36' +
  ' (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36'
}

ItemList = new Array()

get_item_id = (name) ->
  for item in itemIds
    if (item.name == name)
      return item.id
  console.log("item not found: " + name)
  return ""

get_item_name = (id) ->
  for item in itemIds
    if (item.id == id)
      return item.name
  console.log("item not found: " + id)
  return ""

scrape_loop = (i) ->
  if (i > 11)
    return
  console.log("page " + i)
  setTimeout(() ->
    url = "http://na.finalfantasyxiv.com/lodestone/playguide/db/gathering/?page="+i
    request({url:url, headers: headers},
    (error,response,html) ->
      if (!error && response.statusCode == 200)
        $ = cheerio.load(html)
        $(" tr .col_left .ic_link_txt a").each((index,element) ->
          link = $(element).attr("href")
          if (link.indexOf("category") != -1)
            return
          process_gather(link)
          )
      )
    scrape_loop(i+1)
  ,1000)

process_gather = (url) ->
  console.log("http://na.finalfantasyxiv.com" + url)
  request({url:"http://na.finalfantasyxiv.com" + url, headers:headers},
  (error,response,html) ->
    if (!error && response.statusCode == 200)
      gather = {}
      $ = cheerio.load(html)
      item_name = $(".clearfix h2").eq(0).text().trim()
      gather.level = parseInt($(".star_level span").text().trim())
      gather.gather_class = $(".clearfix .job_name").text().trim()
      gather.id = get_item_id(item_name)
      gather.locations = new Array()
      $(".even .gathering_data").each((index,element) ->
        loc = {}
        loc.x = 0
        loc.y = 0
        loc.zone = $(element).find("dt").text().trim()
        areaLine = $(element).find("dd").text().trim().split("\t")

        loc.area = areaLine[areaLine.length-1]
        areaLine.forEach((text) ->
          if (text.indexOf("Lv. ") != -1)
            loc.level = parseInt(text.split(" ")[1])
          )

        gather.stars = $(".star_level .ic_star_01").length

        gather.locations.push(loc)
        )
      gather.lodestone_code = url.split("/")[5]
      console.log(JSON.stringify(gather))


      Gather.findOne({id: gather.id},(err,item) ->
        if (item == undefined || item == null)
          NewGather = new Gather(gather)
          NewGather.save((err,doc) ->
            if (err)
              console.log(err)

            )
          return
        console.log("appending locations to existing item")
        gather.locations.forEach((loc) ->
          if (item.locations.indexOf(loc) == -1)
            item.locations.push(loc)
          )
        item.save()
        )
  )

Item.find((err,items) ->
  if (err)
    console.log(err)
    return next(err)
  for item in items
    itemIds.push({id: item.id,name: item.name})
  scrape_loop(1)
  )
