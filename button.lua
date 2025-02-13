buttons = {}

function createButtons()
    for _, b in pairs(level.layers["Button"].objects) do
        createButton(b.x, b.y, b.width, b.height)
    end
end

function createButton(x, y, width, height)
    local button = world:newRectangleCollider(x, y, width, height, {collision_class = "Button"})
    button:setType("static")
    table.insert(buttons, button)
end