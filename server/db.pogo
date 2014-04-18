pg = require 'pg'

module.exports () =
    withDatabase (block, cb) =
        pg.connect 'postgres://localhost/places' @(err, client, done)
            if (err)
                done (err)
                cb (err)
            else
                block (client) @(err, result)
                    done (err)
                    cb (err, result)

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
        createPlace (place)! =
            withDatabase @(db)!
                result = db.query ("insert into locations (description, lat, long, position) values ($1, $2, $3, ST_SetSRID(ST_MakePoint($4, $5), 4326)) returning id;", [place.description, place.location.lat, place.location.long, place.location.lat, place.location.long])!
                result.rows.0.id

        placesNearestTo (location, limit: 10)! =
            withDatabase @(db)!
                result = db.query "select *, position <-> ST_SetSRID(ST_MakePoint($1, $2), 4326) as distance
                                   from locations 
                                   order by distance
                                   limit $3;" [location.lat, location.long, limit]!

                [row <- result.rows, placeFromRow (row)]

        place (id)! =
            withDatabase @(db)!
                result = db.query ("select * from locations where id = $1", [id])!

                row = result.rows.0

                if (row)
                    placeFromRow (row)

        clear ()! =
            withDatabase @(db)!
                db.query "delete from locations;"!
    }
