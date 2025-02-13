crates = {}

crateSprite = love.graphics.newImage("sprites/crate.png")

function createCrates()
    for i, c in pairs(level.layers["Crate"].objects) do
        createCrate(c.x, c.y, c.width, c.height)
    end
end

function createCrate(x, y, width, height)
    local crate = world:newRectangleCollider(x, y, width, height, {collision_class = "Crate"})
    crate:setType("static")
    crate.sprite = crateSprite
    crate.width = width
    crate.height = height
    crate.dead = false
    table.insert(crates, crate)
end

function crateUpdate(dt)
    removeCrates()
end

function crateDraw()
    for i, c in ipairs(crates) do
        love.graphics.draw(c.sprite, c:getX(), c:getY(), nil, nil, nil, c.width/2, c.height/2)
    end
end

function removeCrates()
    for i = #crates, 1, -1 do
        if crates[i].dead then -- will be set to true in bullet checkCollision
            crates[i]:destroy()
            table.remove(crates, i)
        end
    end
end