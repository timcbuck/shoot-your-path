local love = require "love"

debug = true

function love.load()
    -- Create world using windfield library for physics
    wf = require "libraries/windfield/windfield"
    world = wf.newWorld(0, 1000, false) -- xgravity, ygravity, sleep
    world:setQueryDebugDrawing(debug)

    -- require player object (requires world to be imported first (above))
    require "player"
end

function love.update(dt)
    world:update(dt) -- turn on gravity
    playerUpdate(dt)
end

function love.draw()
    playerDraw()
end