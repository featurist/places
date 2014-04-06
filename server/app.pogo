express = require 'express'
db = require './db'
respond = require './respond'
fs = require 'fs'
mime = require 'mime'
mkdirp = require 'mkdirp'
path = require 'path'
limit = require './limit'

app = express()

app.use (express.json())
//app.use (limit '2mb')

app.get '/' @(req, res)
    res.send 'hello'

addLinksToPlace (place) =
    place.href = "/places/#(place.id)"
    place.image = "/places/#(place.id)/image"
    place

app.post '/places' (respond @(req, res)
    place = req.body

    id = db ().createPlace (place)!

    place.id = id
    addLinksToPlace (place)

    res.location (place.href)
    res.send (201, place)
)

app.get '/places/nearest' (respond @(req, res)
    lat = req.param 'lat'
    long = req.param 'long'

    places = [p <- db ().placesNearestTo { lat = lat, long = long }!, addLinksToPlace (p)]

    res.send (200, places)
)

app.get '/places/:place' (respond @(req, res)
    placeId = parseInt (req.param 'place')

    if (placeId)
        place = db ().place (placeId)!

        if (place)
            addLinksToPlace (place)
            res.send (200, place)
        else
            res.send 404
    else
        res.send 404
)

mimeType (mimeType) isImage =
    r/image\/.*/.test (mimeType)

app.put '/places/:place/image' (respond @(req, res)
    placeId = parseInt (req.param 'place')

    mimeType = req.header 'content-type'

    if (mimeType (mimeType) isImage)
        imageFilename = prepareFileNameForPlaceId (placeId, mimeType: mimeType)!
        fs.exists (imageFilename) @(alreadyExists)
            stream = req.pipe (fs.createWriteStream (imageFilename))

            stream.on 'finish'
                res.send (
                    if (alreadyExists)
                        200
                    else
                        201
                )
    else
        res.send (400, { error = "mime-type #(mimeType) is not an image" })
)

prepareFileNameForPlaceId (placeId, mimeType: nil)! =
    imageFilename = "#(__dirname)/images/#(placeId)/image.#(mime.extension (mimeType))"
    mkdirp (path.dirname (imageFilename))!
    imageFilename

findImageForPlaceId (placeId)! =
    dir = "#(__dirname)/images/#(placeId)"
    filename = fs.readdir (dir)!.0

    "#(dir)/#(filename)"

app.get '/places/:place/image' (respond @(req, res)
    placeId = parseInt (req.param 'place')

    imageFilename = findImageForPlaceId (placeId)!
    fs.exists (imageFilename) @(exists)
        if (exists)
            res.header 'content-type' 'image/jpeg'
            res.status 200
            stream = fs.createReadStream (imageFilename).pipe (res)
        else
            res.send 404
)

module.exports = app
