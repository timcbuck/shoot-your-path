local Timer = require "timer"

spikes = {}

spikeSprite = love.graphics.newImage("sprites/spikes.png")

function createSpikes()
    for _, s in pairs(level.layers["Spike"].objects) do
        createSpike(s.x, s.y, s.width, s.height)
    end
end

function createSpike(x, y, width, height)
    local spike = world:newRectangleCollider(x, y, width, height, {collision_class = "Danger"})
    spike:setType("static")
    spike.width = width
    spike.height = height
    spike.sprite = spikeSprite
    spike.on = true
    table.insert(spikes, spike)
end

function spikeDraw()
    for _, s in pairs(spikes) do
        if s.on then
            love.graphics.draw(s.sprite, s:getX(), s:getY(), nil, nil, nil, s.width/2, s.height/2)
        end
    end
end

function toggleSpikes()
    for _, s in pairs(spikes) do
        s.on = not s.on
    end
end
