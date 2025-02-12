local love = require "love"
local sti = require "libraries/Simple-Tiled-Implementation/sti"

debug = true

function love.load()
    -- Create world using windfield library for physics
    wf = require "libraries/windfield/windfield"
    world = wf.newWorld(0, 2000, false) -- xgravity, ygravity, sleep
    world:setQueryDebugDrawing(debug)
    -- Add collision classes
    world:addCollisionClass("Platform")
    world:addCollisionClass("Player")
    world:addCollisionClass("Crate")
    world:addCollisionClass("Bullet")
    -- Require objects (other files)
    require "player"
    require "crate"
    require "bullet"
    require "goal"
    -- Initalise tables
    platforms = {}
    -- Load first level
    loadLevel("level1")
end

function love.update(dt)
    world:update(dt) -- turn on gravity
    playerUpdate(dt)
    bulletUpdate(dt)
    crateUpdate(dt)
end

function love.draw()
    playerDraw()
    bulletDraw()
    crateDraw()
    if debug then
        world:draw()
    end
end

function loadLevel(level)
    level = sti("levels/" .. level .. ".lua") -- load the level .lua file

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

    -- Create goal
    for i, obj in pairs(level.layers["Goal"].objects) do
        createGoal(obj.x, obj.y)
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
        createBullet(player:getX(), player:getY())
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

function playerMouseAngle()
    -- atan2 is a function that can find the angle between two points (x1, y1) and (x2, y2)
    return math.atan2(love.mouse.getY() - player:getY(), love.mouse.getX() - player:getX()) -- returns angle in radians
end