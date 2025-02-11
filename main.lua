local love = require "love"
local sti = require "libraries/Simple-Tiled-Implementation/sti"

debug = true

function love.load()
    -- Create world using windfield library for physics
    wf = require "libraries/windfield/windfield"
    world = wf.newWorld(0, 1000, false) -- xgravity, ygravity, sleep
    world:setQueryDebugDrawing(debug)
    -- Add collision classes
    world:addCollisionClass("Platform")
    world:addCollisionClass("Player")
    world:addCollisionClass("Crate")
    -- Require objects (other files)
    require "player"
    require "crate"
    -- Initalise tables
    platforms = {}
    -- Load first level
    loadLevel("level1.lua")
end

function love.update(dt)
    world:update(dt) -- turn on gravity
    playerUpdate(dt)
    crateUpdate(dt)
end

function love.draw()
    playerDraw()
    --crateDraw()
    if debug then
        world:draw()
    end
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
    for i, obj in pairs(level.layers["Platform"].objects) do
        createRectPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    -- Create crates
    if level.layers["Crate"].objects then
        for i, obj in pairs(level.layers["Crate"].objects) do
            createCrate(obj.x, obj.y)
        end
    end
end

function createRectPlatform(x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "Platform"})
        platform:setType("static")
        table.insert(platforms, platform)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- Shoot bullet in direction of clicked location
    end
end