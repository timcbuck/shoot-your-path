playerStartX = 100
playerStartY = 100

player = world:newRectangleCollider(playerStartX, playerStartY, 32, 32, {collision_class = "Player"})
player:setFixedRotation(true)
player.speed = 240
player.jumpStrength = -900 
player.isMoving = false
player.grounded = true
player.sprite = love.graphics.newImage("sprites/player.png")

function playerUpdate(dt)
    player.isMoving = false
    playerMovement(dt)
end

function playerDraw()
    love.graphics.draw(player.sprite, player:getX(), player:getY(), nil, nil, nil, 16, 16)
end

function playerMovement(dt)
    local px, py = player:getPosition() -- get player x and y position
    -- Move player right
    if love.keyboard.isDown("d") then
        player:setX(px + player.speed * dt)
        player.isMoving = true
    end
    -- Move player left
    if love.keyboard.isDown("a") then
        player:setX(px - player.speed * dt)
        player.isMoving = true
    end
    -- Prevent player from going offscreen
    if player:getX() < 0 + 16 then
        player:setX(16)
    elseif player:getX() > love.graphics.getWidth() - 16 then
        player:setX(love.graphics.getWidth() - 16)
    end
end

function love.keypressed(key)
    if key == "space" then
        player:applyLinearImpulse(0, player.jumpStrength)
    end
end

