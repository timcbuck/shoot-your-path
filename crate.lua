crates = {}

function createCrate(x, y)
    local crate = world:newRectangleCollider(x, y, 64, 64, {collision_class = "Crate"})
    crate:setType("static")
    crate.sprite = love.graphics.newImage("sprites/crate.png")
    table.insert(crates, crate)
end

function crateUpdate(dt)
end

function crateDraw()
    local i = #crates
    print("Number of crates: " .. i)
    while i > -1 do
        if crates[i] ~= nil then
            local cx, cy = crates[i]:getPosition()
            love.graphics.draw(crates[i].sprite, cx, cy, nil, nil, nil, 32, 32)
        end
        i = i - 1
    end
end