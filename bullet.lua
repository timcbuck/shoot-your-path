bullets = {}
bulletSprite = love.graphics.newImage("sprites/bullet.png")
bulletSpeed = 1000

function bulletUpdate(dt)
    for i, b in ipairs(bullets) do
        b:setX(b:getX() + b.speed * dt)
    end
end

function bulletDraw()
    for i, b in ipairs(bullets) do
        love.graphics.draw(b.sprite, b:getX(), b:getY(), nil, nil, nil, 8, 8)
    end
end

function bulletCollision()
    for i, b in ipairs(bullets) do
        if b:enter("Crate") then
            b:destroy()
        end
    end
end

function createBullet(x, y)
    -- todo: may want to use the logic from the shooter game instead of windfield physics for bullets!
    local bullet = world:newRectangleCollider(x, y, 16, 16, {collision_class = "Bullet"})
    bullet:setType("static")
    bullet.sprite = bulletSprite
    bullet.speed = bulletSpeed
    table.insert(bullets, bullet)
end