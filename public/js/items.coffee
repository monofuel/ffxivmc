#string function pair for filling item data
itemModalInfo = {}

displayError = (err) ->
  alertBubble = document.getElementById("errorAlert")

  alertBubble.innerHTML = '<div class="alert alert-danger fade in">' +
    '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' +
    err + '</div>'

refreshGatherItems = (interval) ->
  gatherItemTable = document.getElementById("gatherItemBody")

  #ignore if the page doesn't have a stale item list
  if (gatherItemTable == null)
    return

  setTimeout(refreshGatherItems,5000) if !interval
  #retrieve desired items and display some of them
  $.get("/ffxivmc/gatherorders", (data) ->

    if (data.length < 0)
      return displayError("Could not retrieve item information")

    displayList = data.slice(0,100)

    table = ""
    displayList.forEach((item) ->
        table += "<tr>"
        table += "<td>" + item.name + "</td>"
        table += "<td>" + item.market_sell_price + "</td>"
        table += "<td>" + item.gather_class + "</td>"
        table += "<td>" + item.level + "</td>"
        table += "<td>" + item.stars + "</td>"

        showInfo = () ->
          itemModal = "<div>"
          itemModal += '<p>Node Locations</p>'
          itemModal += '<table class="table table-condensed table-striped">'
          itemModal += '<thead>'
          itemModal += '<tr>'
          itemModal += '<th>Zone</th>'
          itemModal += '<th>Area</th>'
          itemModal += '<th>Level</th>'
          itemModal += '</tr>'
          itemModal += '</thead>'
          itemModal += '<tbody>'

          item.location.forEach((loc) ->
            itemModal += "<tr>"
            itemModal += "<td>" + loc.zone + "</td>"
            itemModal += "<td>" + loc.area + "</td>"
            itemModal += "<td>" + loc.level + "</td>"
            itemModal += "</tr>"
            )

          itemModal += '</tbody>'
          itemModal += '</table>'
          itemModal += '</div>'

          document.getElementById("itemModalTitle").innerHTML = item.name
          document.getElementById("itemModalBody").innerHTML = itemModal

        itemModalInfo[item.name] = showInfo
        table += '<td><button type="button" class="btn btn-info" data-toggle="modal" data-target="#itemModal" onclick="itemModalInfo[\'' + item.name + '\']()">Info</button></td>'
        table += "</tr>"


      )
    gatherItemTable.innerHTML = table

    )

refreshStaleItems = (interval) ->
  staleItemTable = document.getElementById("staleItemBody")

  #ignore if the page doesn't have a stale item list
  if (staleItemTable == null)
    return

  setTimeout(refreshStaleItems,5000) if !interval
  #retrieve desired items and display some of them
  $.get("/ffxivmc/desiredorders", (data) ->
    staleCounter = document.getElementById("staleItemCounter")

    if (data.length < 0)
      return displayError("Could not retrieve item information")

    displayList = data.slice(0,400)

    table = ""
    displayList.forEach((item) ->
        table += "<tr><td>" + item + "</td></tr>"
      )
    staleItemTable.innerHTML = table
    staleCounter.innerHTML = data.length

    )



refreshProfitableItems = (interval) ->
  profitItemTable = document.getElementById("ProfitableItemBody")

  #ignore if the page doesn't have a profitable items list
  if (profitItemTable == null)
    return

  setTimeout(refreshProfitableItems,5000) if !interval
  $.get("/ffxivmc/bestcrafts", (data) ->
    if (data.length == 0)
      return displayError("Item crafting prices are being generated, please wait.")

    #displayList = data.slice(0,25)
    displayList = data

    table = ""
    displayList.forEach((item) ->
      table += "<tr>"
      table += "<td>" + item.name + "</td>"
      table += "<td>" + (100 * item.market_sell_price / item.actual_price.price) + "% </td>"
      table += "<td>" + (item.market_sell_price - item.actual_price.price) + "</td>"
      table += "<td>" + item.market_sell_price + "</td>"
      table += "<td>" + item.actual_price.price + "</td>"
      table += "<td>" + item.actual_price.source + "</td>"



      showInfo = () ->
        console.log("show Info clicked")
        itemModal = "<div>"
        itemModal += '<p>Source: ' + item.actual_price.source + '</p>'
        itemModal += '<p>Individual Price: ' + item.actual_price.price + '</p>'
        itemModal += '<p>Last known price on market: ' + item.market_sell_price + '</p>'
        itemModal += '<h2>Materials Required:</h2>'
        itemModal += '<table class="table table-condensed table-striped">'
        itemModal += '<thead>'
        itemModal += '<tr>'
        itemModal += '<th>Item</th>'
        itemModal += '<th>Quantity</th>'
        itemModal += '<th>Best Source</th>'
        itemModal += '<th>Price</th>'
        itemModal += '</thead>'
        itemModal += '<tbody>'
        item.mats.forEach((mat) ->
          itemModal += "<tr>"
          itemModal += "<td>" + mat.name + "</td>"
          itemModal += "<td>" + mat.quantity + "</td>"
          itemModal += "<td>" + mat.actual_price.source + "</td>"
          itemModal += "<td>" + mat.actual_price.price + "</td>"
          itemModal += "</tr>"
          )
        itemModal += '</body>'
        itemModal += '</table>'
        itemModal += "</div>"

        document.getElementById("itemModalTitle").innerHTML = item.name
        document.getElementById("itemModalBody").innerHTML = itemModal

      itemModalInfo[item.name] = showInfo
      table += '<td><button type="button" class="btn btn-info" data-toggle="modal" data-target="#itemModal" onclick="itemModalInfo[\'' + item.name + '\']()">Info</button></td>'
      table += "</tr>"
      )
    profitItemTable.innerHTML = table

    )

window.onload = () ->

  refreshStaleItems()
  refreshProfitableItems()
  refreshGatherItems()
