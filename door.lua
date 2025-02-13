doors = {}

function createDoors()
    for _, d in pairs(level.layers["Door"].objects) do
        createDoor(d.x, d.y, d.width, d.height)
    end
end

function createDoor(x, y, width, height)
    local door = world:newRectangleCollider(x, y, width, height, {collider_class = "Platform"})
    door:setType("static")
    table.insert(doors, door)
end