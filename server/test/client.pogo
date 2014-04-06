needle = require 'needle'
urlutils = require 'url'

module.exports (baseUrl) =
    url (path) = urlutils.resolve (baseUrl, path)

    response (response) exception (message) =
        error = @new Error (message)

        error.statusCode = response.statusCode
        error.response = response.body

        @throw error

    {

        createPlace (place) =
            response = needle.post (url '/places', place, json: true)!
            if (response.statusCode != 201)
                response (response) exception "could not create place"

            response.body

        place (path) =
            retreiveResponse = needle.get (url (path))!
            
            if (response.statusCode != 200)
                response (response) exception "could not get place"

            response.body
    }
