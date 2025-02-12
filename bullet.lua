bullets = {}
bulletSprite = love.graphics.newImage("sprites/bullet.png")
bulletSpeed = 1000

function bulletUpdate(dt)
    -- Move bullet
    for _, b in ipairs(bullets) do
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end

    -- Check collision with crates
    for i, c in ipairs(crates) do
        checkCollision(c, c.width/2)
    end

    removeBullets()
end

function bulletDraw()
    for i, b in ipairs(bullets) do
        love.graphics.draw(b.sprite, b.x, b.y, nil, nil, nil, 8, 8)
    end
end

function checkCollision(other, threshold)
    for i, b in ipairs(bullets) do
        if distanceBetween(b.x, b.y, other:getX(), other:getY()) < threshold then
            b.dead = true
            if other.collision_class == "Crate" then
                other.dead = true
            end
        end
    end
end

function createBullet(x, y)
    if #bullets < 3 then
        local bullet = {}
        bullet.x = x
        bullet.y = y
        bullet.speed = bulletSpeed
        bullet.sprite = bulletSprite
        bullet.direction = playerMouseAngle()
        bullet.dead = false
    
        table.insert(bullets, bullet)
    end
end

function removeBullets()
    -- Loop through bullets backwards to avoid loop issues when removing elements
    -- table.remove() re-organises the table to remove gaps after removal
    -- so we need to move backwards through the table!
    for i = #bullets, 1, -1 do
        if bullets[i].x < -20 or bullets[i].x > love.graphics.getWidth() + 20 then
            bullets[i].dead = true
        elseif bullets[i].y < -20 or bullets[i].y > love.graphics.getHeight() + 20 then
            bullets[i].dead = true
        end

        -- Will also remove bullets that were set to dead from the function checkCollision()
        if bullets[i].dead then
            table.remove(bullets, i)
        end
    end
end