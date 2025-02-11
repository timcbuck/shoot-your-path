local love = require "love"

debug = true

function love.load()
    -- Create world using windfield library for physics
    wf = require "libraries/windfield/windfield"
    world = wf.newWorld(0, 1000, false) -- xgravity, ygravity, sleep
    world:setQueryDebugDrawing(debug)

    -- Require player object (requires world to be imported first (above))
    require "player"

    -- Initalise tables
    platforms = {}

    loadLevel("level1.lua")
end

function love.update(dt)
    world:update(dt) -- turn on gravity
    playerUpdate(dt)
end

function love.draw()
    playerDraw()
end

function loadLevel(level)
    level = sti("levels/" .. level)

    -- Set player start position
    for i, obj in pairs(level.layers["Spawn"].objects) do
        playerStartX = obj.x
        playerStartY = obj.y
    end
    player:setPosition(playerStartX, playerStartY)

    -- Create platforms
    -- They are polygon shapes so need to loop through all x, y points...
    for i, obj in pairs(level.layers["Platform"].objects) do
        for i, pol in pairs(obj.polygon) do
            print(pol.x)
        end
        --createPlatform(obj.x, obj.y, obj.width, obj.height)
    end
end

function createPlatform(x, y , width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "Platform"})
        platform:setType("static")
        table.insert(platforms, platform)
    end
end