crates = {}

crateSprite = love.graphics.newImage("sprites/crate.png")
crateWidth = crateSprite:getWidth()
crateHeight = crateSprite:getHeight()

function createCrate(x, y)
    local crate = world:newRectangleCollider(x, y, crateWidth, crateHeight, {collision_class = "Crate"})
    crate:setType("static")
    crate.sprite = crateSprite
    crate.width = crateWidth
    crate.height = crateHeight
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