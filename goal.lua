goals = {}


function createGoal(x, y)
    local goal = world:newRectangleCollider(x, y, 64, 64)
    goal:setType("static")
    table.insert(goals, goal)
end