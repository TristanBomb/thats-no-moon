Ship = {}
Ship.__index = Ship
function Ship:new()
    local ship = {}
    setmetatable(ship, self)

    ship.x = 100
    ship.y = 100
    ship.theta = 0
    ship.vel = 0

    return ship
end

function Ship:draw()
    love.graphics.print("ship!", self.x, self.y)
end

function Ship:tick()
end

--all arguments are booleans
function Ship:input(up, down, left, right, fire)
end
