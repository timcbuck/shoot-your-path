goals = {}


function goalUpdate()
    goalEntered()
end

function createGoals()
    for _, c in pairs(level.layers["Goal"].objects) do
        createGoal(c.x, c.y, c.width, c.height)
    end
end

function createGoal(x, y, width, height)
    local goal = world:newRectangleCollider(x, y, width, height)
    goal:setType("static")
    table.insert(goals, goal)
end

function goalEntered()
    for _, g in ipairs(goals) do
        if g:enter("Player") then
            loadNextLevel()
        end
    end 
end