parseSize (size) =
    match = r/(\d+)\s*(b|kb|mb|gb|tb)/i.exec(size)

    bytes = parseInt (match.1)

    unit = {
        'b' = 1
        'kb' = 1024
        'mb' = 1024 * 1024
        'gb' = 1024 * 1024 * 1024
        'tb' = 1024 * 1024 * 1024 * 1024
    }.(match.2) @or 1

    bytes * unit

module.exports (size) =
    @(req, res, next)
        received = 0
        maxSize = parseSize (size)

        req.on 'data' @(data)
            received := received + data.length

            if (received > maxSize)
                req.socket.end ()

        next ()
