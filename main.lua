local love = require "love"
local sti = require "libraries/Simple-Tiled-Implementation/sti"

debug = false

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
    levelId = 1
    maxLevel = 2
    loadLevel("level" .. levelId)
end

function love.update(dt)
    world:update(dt) -- turn on physics
    playerUpdate(dt)
    bulletUpdate(dt)
    crateUpdate(dt)
    goalUpdate()
end

function love.draw()
    level:drawLayer(level.layers["Tile Layer 1"])
    playerDraw()
    bulletDraw()
    crateDraw()
    if debug then
        world:draw()
    end
end

function loadLevel(fileName)
    destroyAll()
    

    level = sti("levels/" .. fileName .. ".lua") -- load the level .lua file

    resetPlayer()

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
        platform.width = width
        platform.height = height
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

function destroyAll()
    local i = #platforms
    while i > -1 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms, i)
        i = i - 1
    end

    local i = #goals
    while i > -1 do
        if goals[i] ~= nil then
            goals[i]:destroy()
        end
        table.remove(goals, i)
        i = i - 1
    end

    local i = #crates
    while i > -1 do
        if crates[i] ~= nil then
            crates[i]:destroy()
        end
        table.remove(crates, i)
        i = i - 1
    end
end

function loadNextLevel()
    levelId = levelId + 1
    if levelId > maxLevel then
        levelId = 1
    end
    loadLevel("level" .. levelId)    
end