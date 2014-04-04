express = require 'express'

app = express()

app.use (express.json())

app.get '/' @(req, res)
    res.send 'hello'

places = []

app.post '/places' @(req, res)
    places.push (req.body)

    res.location "/places/#(places.length)"
    res.send (201, { ok = true })

app.get '/places/nearest' @(req, res)
    res.send (200, places)

app.get '/places/:place' @(req, res)
    placeId = parseInt (req.params.place)

    place = places.(placeId - 1)

    if (place)
        res.send (200, place)
    else
        res.send 404

module.exports = app
