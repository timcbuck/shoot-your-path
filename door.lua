doors = {}

function createDoors()
    for _, d in pairs(level.layers["Door"].objects) do
        createDoor(d.x, d.y, d.width, d.height)
    end
end

function createDoor(x, y, width, height)
    local door = world:newRectangleCollider(x, y, width, height, {collider_class = "Platform"})
    door:setType("static")
    door.width = width
    door.height = height
    door.id = id
    table.insert(doors, door)
end

function destroyDoors()
    print("destroy doors")
    local i = #doors
    while i > -1 do
        if doors[i] ~= nil then
            doors[i]:destroy()
        end
        table.remove(doors, i)
        i = i - 1
    end
end