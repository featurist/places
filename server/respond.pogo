module.exports (block) =
    @(req, res, next)
        block (req, res, next) @(error)
            if (error)
                console.log (error)
                res.send (500, error)
