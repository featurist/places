child_process = require 'child_process'
ps = require 'qo-ps'
db = require './db'
pg = require 'pg'
needle = require 'needle'
fs = require 'fs'

task 'test'
    ps.spawn ('mocha test/serverSpec.pogo'.split ' ', ...)!

task 'run'
    ps.spawn 'pogo' 'server.pogo'!

withDatabase(block, url: 'postgis://localhost/postgis')! =
    client = @new pg.Client(url)
    client.connect!

    try
        block(client)!
    finally
        client.end()

task 'db.create' @(opts)
    name = opts.name @or 'places'
    withDatabase(url: "postgres://localhost/postgres") @(db)!
        db.query "create database #(name);"!

    withDatabase(url: "postgres://localhost/#(name)") @(db)!
        db.query "create extension postgis;"!

task 'db.drop' @(opts)
    name = opts.name @or 'places'
    withDatabase(url: "postgres://localhost/postgres") @(db)!
        db.query "drop database #(name);"!

task 'db.locations' @(opts)
    name = opts.name @or 'places'
    withDatabase(url: "postgres://localhost/#(name)") @(db)!
        console.log (db.query "select * from locations"!)

task 'db.seed' @(opts)
    name = opts.name @or 'places'

    places = [
        {
            image = 'essert.JPG'
            place = {
                description = 'Essert'
                location = {
                    lat = '46.3508701'
                    long = '6.3071750'
                }
            }
        }
        {
            image = 'messery.JPG'
            place = {
                description = 'Messery'
                location = {
                    lat = '46.3510775'
                    long = '6.2940215'
                }
            }
        }
        {
            image = 'yvoire.JPG'
            place = {
                description = 'Yvoire'
                location = {
                    lat = '46.3717104'
                    long = '6.3271494'
                }
            }
        }
    ]

    [
        place <- places
        @(place) @{
            console.log "posting #(place.place.description)"
            placeJson = needle.post ('http://localhost:4000/places', place.place, json: true)!.body
            console.log "putting #(place.place.description), #(place.image) => #(placeJson.href)"
            needle.put ("http://localhost:4000#(placeJson.image)", fs.createReadStream (place.image), headers: {"content-type" = "image/jpeg"})!
        }(place)
    ]
