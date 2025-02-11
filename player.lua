playerStartX = 100
playerStartY = 100

player = world:newRectangleCollider(playerStartX, playerStartY, 32, 32, {collision_class = "Player"})
player:setFixedRotation(true)
player.speed = 240
player.isMoving = false
player.grounded = true
player.sprite = love.graphics.newImage("sprites/player.png")

function playerUpdate(dt)
    playerMovement(dt)
end

function playerDraw()
    love.graphics.draw(player.sprite, player:getX(), player:getY())
end

function playerMovement(dt)
    local px, py = player:getPosition() -- get player x and y position
    if love.keyboard.isDown("d") then
        player:setX(px + player.speed * dt)
        player.isMoving = true
    end
    if love.keyboard.isDown("a") then
        player:setX(px - player.speed * dt)
        player.isMoving = true
    end
end