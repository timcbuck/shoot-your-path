local love = require "love"
local sti = require "libraries/Simple-Tiled-Implementation/sti"
local Timer = require "timer"

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
    require "button"
    require "door"
    require "spike"
    -- Initalise tables
    platforms = {}
    -- Load first level
    levelId = 3
    maxLevel = 3
    loadLevel("level" .. levelId)
    -- Timer example
    --timer = Timer:new(5, testTimer, true)
    --timer:start()
end

function love.update(dt)
    world:update(dt) -- turn on physics
    playerUpdate(dt)
    bulletUpdate(dt)
    crateUpdate(dt)
    goalUpdate()
    if spikesTimer then
        spikesTimer:update(dt)
    end

    if debug then
        --printMousePosition()
    end
end

function love.draw()
    level:drawLayer(level.layers["Tile Layer 1"])
    playerDraw()
    bulletDraw()
    crateDraw()
    spikeDraw()
    if spikesTimer then
        spikesTimer:draw()
    end

    if debug then
        world:draw()
    end
end

function loadLevel(fileName)
    destroyAll()
    
    level = sti("levels/" .. fileName .. ".lua") -- load the level .lua file

    resetPlayer()

    -- Create level objects
    for i, obj in pairs(level.layers["Platform"].objects) do
        createRectPlatform(obj.x, obj.y, obj.width, obj.height)
    end
    if level.layers["Crate"] then createCrates() end
    if level.layers["Goal"] then createGoals() end
    if level.layers["Button"] then createButtons() end
    if level.layers["Door"] then createDoors() end
    if level.layers["Spike"] then
        createSpikes()
        spikesTimer = Timer:new(1.5, toggleSpikes, true)
        spikesTimer:start()
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

    local i = #spikes
    while i > -1 do
        if spikes[i] ~= nil then
            spikes[i]:destroy()
        end
        table.remove(spikes, i)
        i = i -1
    end
end

function loadNextLevel()
    levelId = levelId + 1
    if levelId > maxLevel then
        levelId = 1
    end
    loadLevel("level" .. levelId)    
end

function printMousePosition()
    local mousex = love.mouse:getX()
    local mousey = love.mouse:getY()
    print("(" .. mousex .. ", " .. mousey .. ")")
end