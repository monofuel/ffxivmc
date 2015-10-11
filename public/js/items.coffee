displayError = (err) ->
  alertBubble = document.getElementById("errorAlert")

  alertBubble.innerHTML = '<div class="alert alert-danger fade in">' +
    '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' +
    err + '</div>'

refreshStaleItems = (interval) ->
  staleItemTable = document.getElementById("staleItemBody")

  #ignore if the page doesn't have a stale item list
  if (staleItemTable == null)
    return

  #retrieve desired items and display some of them
  $.get("/desiredorders", (data) ->
    if (data.length < 0)
      return displayError("Could not retrieve item information")

    displayList = data.slice(0,25)

    table = ""
    displayList.forEach((item) ->
        table += "<tr><td>" + item + "</td></tr>"
      )
    staleItemTable.innerHTML = table

    setTimeout(refreshStaleItems,10000) if interval
    )



refreshProfitableItems = (interval) ->
  profitItemTable = document.getElementById("ProfitableItemBody")

  #ignore if the page doesn't have a profitable items list
  if (profitItemTable == null)
    return

  $.get("/bestcrafts", (data) ->
    if (data.length < 0)
      return displayError("Could not retrieve item information")

    #displayList = data.slice(0,25)
    displayList = data

    table = ""
    displayList.forEach((item) ->
      table += "<a onclick='itemInfo()'>"
      table += "<tr>"
      table += "<td>" + item.name + "</td>"
      table += "<td>" + (item.market_sell_price - item.actual_price.price) + "</td>"
      table += "<td>" + item.market_sell_price + "</td>"
      table += "<td>" + item.actual_price.price + "</td>"
      table += "<td>" + item.actual_price.source + "</td>"

      table += "</tr>"

      table += "</a>"
      )
    profitItemTable.innerHTML = table

    setTimeout(refreshProfitableItems,10000) if interval
    )

window.onload = () ->

  refreshStaleItems(true)
  refreshProfitableItems(true)
