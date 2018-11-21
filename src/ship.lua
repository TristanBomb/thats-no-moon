Ship = {}
Ship.__index = Ship
function Ship:new()
    local ship = {}
    setmetatable(ship, self)

    ship.x = 100
    ship.y = 100
    ship.vx = 0
    ship.vy = 0
    ship.theta = 0
    ship.inputs = {
        up = false,
        down = false,
        left = false,
        right = false,
        fire = false
    }
    ship.defaultimage = love.graphics.newImage("asset/image/ship/ship_azure.png")
    return ship
end

function Ship:draw()
    love.graphics.draw(self.defaultimage, self.x, self.y, self.theta)
end

function Ship:tick(dt)
end

--all arguments are booleans
function Ship:input(up, down, left, right, fire)
    self.inputs.up = up
    self.inputs.down = down
    self.inputs.left = left
    self.inputs.right = right
    self.inputs.fire = fire
end
