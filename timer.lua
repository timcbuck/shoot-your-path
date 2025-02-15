-- Meta class
local Timer = {}

function Timer:new(seconds, cb, looping)
    -- According to ChatGPT: 'self' refers to the metatable that is acting as the class (in this case 'Card').
    -- We need to make sure __index points to self to allow accessing methods from the 'Card' class.
    -- We initialise the properties (value, suit, name) directly in the new function on the table 'o' (the instance)!
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.seconds = seconds
    o.remainingSeconds = seconds
    o.cb = cb
    o.running = false
    o.looping = looping or false
    return o
end

function Timer:start()
    self.running = true
end

function Timer:update(dt)
    if self.running then
        if self.remainingSeconds < 0 then
            self:expired()
        end
        self.remainingSeconds = self.remainingSeconds - 1 * dt
    end
end

function Timer:draw()
    love.graphics.printf(self.remainingSeconds, 10, 10, love.graphics.getWidth(), "center")
end

function Timer:expired()
    if self.looping then
        self.remainingSeconds = self.seconds
    else
        self:stop()
    end
    self:cb()
end

function Timer:stop()
    self.running = false
end

return Timer