playerStartX = 100
playerStartY = 100
playerWidth = 32
playerHeight = 32

player = world:newRectangleCollider(playerStartX, playerStartY, playerWidth, playerHeight, {collision_class = "Player"})
player:setFixedRotation(true)
player.speed = 240
player.jumpStrength = -1200
player.isMoving = false
player.grounded = true
player.sprite = love.graphics.newImage("sprites/player.png")

function playerUpdate(dt)
    player.isMoving = false
    isPlayerGrounded()
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
    if key == "w" and player.grounded then
        player:applyLinearImpulse(0, player.jumpStrength)
    end
end

function isPlayerGrounded()
    local px, py = player:getPosition()
    local colliders = world:queryRectangleArea(px - playerWidth/2, py + playerHeight/2, playerWidth, 1, {"Platform", "Crate"})
    print(#colliders)
    if #colliders == 0 then
        player.grounded = false
    else
        player.grounded = true
    end
end

function resetPlayer()
    player:applyLinearImpulse(0, 0)
    -- Set player start position
    for i, obj in pairs(level.layers["Spawn"].objects) do
        playerStartX = obj.x
        playerStartY = obj.y
    end
    player:setPosition(playerStartX, playerStartY)
end