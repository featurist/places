app = require '../app'
needle = require 'needle'
http = require 'http'
createClient = require './client'
db = require '../db'
fs = require 'fs'
fcmp = require 'fcmp'
MemoryStream = require 'memorystream'

require 'chai'.should ()

describe 'server'
    cleanupTasks = []
    server = nil
    port = 5000
    url (path) = "http://localhost:#(port)#(path)"
    client = nil

    beforeEach
        server := http.createServer (app)
        server.listen (port)!
        client := createClient (url '/')

        db ().clear ()

    afterEach
        server.close()!

    afterEach
        [task <- cleanupTasks, task()!]
        cleanupTasks := []

    describe 'places'

        describe 'nearest places'
            it 'can find the nearest 3 places, in proximity order'
                [n <- [1, 2, 3], client.createPlace! {
                    location = {
                        lat = "#(n)"
                        long = '0'
                    }
                    description "place #(n)"
                }]

                placesResponse = needle.get (url '/places/nearest?lat=1.9&long=1')!
                placesResponse.statusCode.should.equal 200

                descriptions = [p <- placesResponse.body, p.description]
                descriptions.should.eql ['place 2', 'place 1', 'place 3']

                queryPlace2 = placesResponse.body.0

                place2 = needle.get (url (queryPlace2.href))!.body
                place2.description.should.equal 'place 2'

        it 'returns 404 on unknown place'
            response = needle.get (url '/places/unknown')!
            response.statusCode.should.equal 404

        it 'can store and retrieve a place'
            createResponse = needle.post (url '/places', json: true)! {
                location = {
                    lat = '1'
                    long = '0'
                }
                description 'a lovely place'
            }

            createResponse.statusCode.should.equal 201
            createResponse.headers.'content-type'.should.equal 'application/json; charset=utf-8'
            placePath = createResponse.headers.location
            createResponse.body.href.should.equal (placePath)

            retreiveResponse = needle.get (url (placePath))!
            retreiveResponse.statusCode.should.equal 200
            console.log (retreiveResponse.body)
            retreiveResponse.body.href.should.equal (placePath)

            place = retreiveResponse.body

            place.location.lat.should.equal '1'
            place.location.long.should.equal '0'
            place.description.should.equal 'a lovely place'

        describe 'images'
            place = nil

            beforeEach
                place := client.createPlace! {
                    location = {
                        lat = '1'
                        long = '1'
                    }
                    description "place with image"
                }

            it 'can store an image for a place'
                kitten = "#(__dirname)/kitten.jpg"
                kittenStream = fs.createReadStream (kitten)
                putResponse = needle.put (url (place.image), kittenStream, stream: true, headers: {"content-type" = "image/jpeg"})!

                putResponse.statusCode.should.equal 201

                kittenCopy = "#(__dirname)/kitten-copy.jpg"
                getResponse = needle.get (url (place.image), output: kittenCopy)!
                getResponse.statusCode.should.equal 200
                getResponse.headers."content-type".should.equal "image/jpeg"

                fcmp.compare (kitten, kittenCopy)!.should.be.true

                cleanupTasks.push
                    fs.unlink (kittenCopy)!

            it 'cannot store content that is not an image'
                kitten = "#(__dirname)/kitten.jpg"
                kittenStream = fs.createReadStream (kitten)
                putResponse = needle.put (url (place.image), kittenStream, stream: true, headers: {"content-type" = "application/pdf"})!

                putResponse.statusCode.should.equal 400

            context "large images"
                streamOf (size) bytes =
                    filename = "#(__dirname)/largeImage.jpeg"
                    stream = fs.createWriteStream (filename)

                    stream.write (@new Buffer (size))
                    stream.end()

                    cleanupTasks.push @{
                        fs.unlink (filename)!
                    }

                    fs.createReadStream (filename)

                it 'cannot store images larger than 2MB' @(done)
                    @{
                        largeImage = streamOf (3 * 1024 * 1024) bytes

                        try
                            needle.put (url (place.image), largeImage, stream: true, headers: {"content-type" = "image/jpeg"})!
                            done (@new Error "could place entire image")
                        catch (e)
                            console.log (e)
                            done ()
                    }?
