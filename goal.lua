goals = {}


function goalUpdate()
    goalEntered()
end

function createGoal(x, y)
    local goal = world:newRectangleCollider(x, y, 64, 64)
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