// Generated by CoffeeScript 1.9.1
var displayError, refreshProfitableItems, refreshStaleItems;

displayError = function(err) {
  var alertBubble;
  alertBubble = document.getElementById("errorAlert");
  return alertBubble.innerHTML = '<div class="alert alert-danger fade in">' + '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + err + '</div>';
};

refreshStaleItems = function() {
  var staleItemTable;
  staleItemTable = document.getElementById("staleItemBody");
  if (staleItemTable === null) {
    return;
  }
  return $.get("/desiredorders", function(data) {
    var displayList, table;
    if (data.length < 0) {
      return displayError("Could not retrieve item information");
    }
    displayList = data.slice(0, 25);
    table = "";
    displayList.forEach(function(item) {
      return table += "<tr><td>" + item + "</td></tr>";
    });
    staleItemTable.innerHTML = table;
    return setTimeout(refreshStaleItems, 10000);
  });
};

refreshProfitableItems = function() {
  var profitItemTable;
  profitItemTable = document.getElementById("ProfitableItemBody");
  if (profitItemTable === null) {
    return;
  }
  return $.get("/bestcrafts", function(data) {
    var displayList, table;
    if (data.length < 0) {
      return displayError("Could not retrieve item information");
    }
    displayList = data;
    table = "";
    displayList.forEach(function(item) {
      table += "<a onclick='itemInfo()'>";
      table += "<tr>";
      table += "<td>" + item.name + "</td>";
      table += "<td>" + (item.market_sell_price - item.actual_price.price) + "</td>";
      table += "<td>" + item.market_sell_price + "</td>";
      table += "<td>" + item.actual_price.price + "</td>";
      table += "<td>" + item.actual_price.source + "</td>";
      table += "</tr>";
      return table += "</a>";
    });
    profitItemTable.innerHTML = table;
    return setTimeout(refreshProfitableItems, 10000);
  });
};

window.onload = function() {
  refreshStaleItems();
  refreshProfitableItems();
  return displayError("demo");
};
