require("fp")

Ship = {
    -- Graphics constants
    images = {
        love.graphics.newImage("asset/image/ship/ship_azure.png"),
        love.graphics.newImage("asset/image/ship/ship_lilac.png"),
        love.graphics.newImage("asset/image/ship/ship_lime.png"),
        love.graphics.newImage("asset/image/ship/ship_magenta.png"),
        love.graphics.newImage("asset/image/ship/ship_orange.png"),
        love.graphics.newImage("asset/image/ship/ship_turqoise.png")
    },
    -- Movement Constants
    thrust = 3000,
    drag = 0.05,
    vtheta = 0.75*2*math.pi,
    wrapmargin = 64,
    -- Combat Constants
    cooldown = 0.3 -- seconds
}
Ship.__index = Ship
function Ship:new(universe)
    local ship = {}
    setmetatable(ship, self)

    -- Movement and control
    ship.x = 100
    ship.y = 100
    ship.vx = 0
    ship.vy = 0
    ship.theta = 0
    ship.inputs = {
        up = 0,
        down = 0,
        left = 0,
        right = 0,
        fire = false
    }
    -- Rendering
    ship.defaultimage = self.images[math.random(#self.images)]
    -- Firing moons
    ship.timesincefire = 0
    ship.universe = universe

    return ship
end

function Ship:draw()
    love.graphics.draw(self.defaultimage, self.x, self.y, self.theta + math.pi/2, 0.1, 0.1, self.defaultimage:getWidth()/2, self.defaultimage:getHeight()/2)
end

function Ship:tick(dt)
    -- Ship thrust
    local thrust_mod = self.inputs.up - self.inputs.down
    local thrust_x = self.thrust * thrust_mod * math.cos(self.theta)
    local thrust_y = self.thrust * thrust_mod * math.sin(self.theta)
    -- Total force
    local Fx = thrust_x
    local Fy = thrust_y
    -- Drag (for the lack of a beter calculation)
    self.vx = self.vx * math.pow(self.drag, dt)
    self.vy = self.vy * math.pow(self.drag, dt)
    -- Update velocity
    self.vx = self.vx + dt * Fx
    self.vy = self.vy + dt * Fy
    -- Update position
    self.x = self.x + dt * self.vx
    self.y = self.y + dt * self.vy
    -- Update rotation
    local rotation_mod = self.inputs.right - self.inputs.left
    self.theta = self.theta + self.vtheta * rotation_mod * dt
    -- Wrap position
    self.x = ((self.x + self.wrapmargin) % (love.graphics.getWidth() + 2*self.wrapmargin)) - self.wrapmargin
    self.y = ((self.y + self.wrapmargin) % (love.graphics.getHeight() + 2*self.wrapmargin)) - self.wrapmargin
    -- Fire moons if the moon button is down
    self.timesincefire = self.timesincefire + dt
    if (self.timesincefire > self.cooldown and self.inputs.fire) then
        local fire_x = math.cos(self.theta) * 500 + self.vx
        local fire_y = math.sin(self.theta) * 500 + self.vy
        self.universe.moons:fire(self.x, self.y, fire_x, fire_y, self.vtheta * rotation_mod)
        self.timesincefire = 0
    end
end

-- this function converts its boolean arguments to
-- numbers to store in the ship data
function Ship:input(up, down, left, right, fire)
    self.inputs.up = bool2num(up)
    self.inputs.down = bool2num(down)
    self.inputs.left = bool2num(left)
    self.inputs.right = bool2num(right)
    self.inputs.fire = fire
end
