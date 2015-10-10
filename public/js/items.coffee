displayError = (err) ->
  console.log(err)

refreshStaleItems = () ->
  staleItemTable = document.getElementById("staleItemBody")

  #ignore if the page doesn't have a stale item list
  if (staleItemTable == null)
    return

  #retrieve desired items and display some of them
  $.get("/desiredorders", (data) ->
    if (data.length < 0)
      return displayError("Could not retrieve item information")

    displayList = data.slice(0,25)

    #clear out table
    staleItemTable.innerHTML = ""

    displayList.forEach((item) ->
        staleItemTable.innerHTML += "<tr><td>" + item + "</td></tr>"
      )
    setTimeout(refreshStaleItems,10000)
    )



refreshProfitableItems = () ->
  profitItemTable = document.getElementById("ProfitableItemBody")

  #ignore if the page doesn't have a profitable items list
  if (profitItemTable == null)
    return


  return
  $.get("/bestcrafts", (data) ->

    setTimeout(refreshProfitableItems,10000)
    )

window.onload = () ->

  refreshStaleItems()
  refreshProfitableItems()
