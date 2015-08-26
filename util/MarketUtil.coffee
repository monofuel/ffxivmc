
exports.getMarketName = (code) ->
  switch code
    when 60881 then return "Limsa"
    when 60882 then return "Gridania"
    when 60883 then return "Ul'Dah"
    when 60884 then return "Foundation"
    else return "Unknown Market"
