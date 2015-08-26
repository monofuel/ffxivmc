mongoose = require('mongoose')

init = () ->
  mongoose.connect('mongodb://localhost/ffxivmc')
  db = mongoose.connection
  db.on('error',console.error.bind(console,'mongo connection error: '))

  db.once('open',(callback) ->
    Ready = true )

init()
