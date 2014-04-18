pg = require 'pg'

module.exports (url: 'postgres://localhost/places') =
    placeFromRow (row) =
        {
            description = row.description
            location = {
                lat = row.lat
                long = row.long
            }
            id = row.id
        }

    {
        withDatabase (block)! =
            pg.connect (url) @(err, client, done)
                if (err)
                    done (err)
                    continuation (err)
                else
                    block (client) @(err, result)
                        done (err)
                        continuation (err, result)

        createPlace (place)! =
            self.withDatabase @(db)!
                result = db.query ("insert into locations (description, lat, long, position) values ($1, $2, $3, ST_SetSRID(ST_MakePoint($4, $5), 4326)) returning id;", [place.description, place.location.lat, place.location.long, place.location.lat, place.location.long])!
                result.rows.0.id

        placesNearestTo (location, limit: 10)! =
            self.withDatabase @(db)!
                result = db.query "select *, position <-> ST_SetSRID(ST_MakePoint($1, $2), 4326) as distance
                                   from locations 
                                   order by distance
                                   limit $3;" [location.lat, location.long, limit]!

                [row <- result.rows, placeFromRow (row)]

        place (id)! =
            self.withDatabase @(db)!
                result = db.query ("select * from locations where id = $1", [id])!

                row = result.rows.0

                if (row)
                    placeFromRow (row)

        clear ()! =
            self.withDatabase @(db)!
                db.query "delete from locations;"!
    }
