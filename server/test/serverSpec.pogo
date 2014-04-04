app = require '../app'
needle = require 'needle'
http = require 'http'
createClient = require './client'

require 'chai'.should ()

describe 'server'
    server = nil
    port = 5000
    url (path) = "http://localhost:#(port)#(path)"
    client = nil

    beforeEach
        server := http.createServer (app)
        server.listen (port)!
        client := createClient (url '/')

    afterEach
        server.close()!

    it 'can find the nearest 3 places, in proximity order'
        places = [n <- [1, 2, 3], client.createPlace! {
            location = {
                lat = "#(n)"
                long = '0'
            }
            description "place #(n)"
        }]

        placesResponse = needle.get (url '/places/nearest?lat=1.9&long=1')!
        placesResponse.statusCode.should.equal 200

        descriptions = [p <- placesResponse.body, p.description]
        descriptions.should.equal ['place 2', 'place 1', 'place 3']

    it 'returns 404 on unkown place'
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

        retreiveResponse = needle.get (url (placePath))!
        retreiveResponse.statusCode.should.equal 200

        place = retreiveResponse.body

        place.location.lat.should.equal '1'
        place.location.long.should.equal '0'
        place.description.should.equal 'a lovely place'
