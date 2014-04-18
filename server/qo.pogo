child_process = require 'child_process'
ps = require 'qo-ps'

task 'test'
    ps.spawn ('mocha test/serverSpec.pogo'.split ' ', ...)!

task 'run'
    ps.spawn 'pogo' 'server.pogo'!
