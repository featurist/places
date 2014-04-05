express = require 'express'
db = require './db'
respond = require './respond'

app = express()

app.use (express.json())

app.get '/' @(req, res)
    res.send 'hello'

app.post '/places' (respond @(req, res)
    id = db ().createPlace (req.body)!

    res.location "/places/#(id)"
    res.send (201, { ok = true })
)

app.get '/places/nearest' (respond @(req, res)
    lat = req.param 'lat'
    long = req.param 'long'

    places = db ().placesNearestTo { lat = lat, long = long }!

    res.send (200, places)
)

app.get '/places/:place' (respond @(req, res)
    placeId = parseInt (req.param 'place')

    if (placeId)
        place = db ().place (placeId)!

        if (place)
            res.send (200, place)
        else
            res.send 404
    else
        res.send 404
)

module.exports = app
