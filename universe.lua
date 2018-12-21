require("ship")
require("moons")
require("particles")
require("fp")

Universe = {
    padding = 15
}
Universe.__index = Universe
function Universe:new()
    local universe = {}
    setmetatable(universe, self)

    universe.moons = Moons:new(universe)
    universe.ships = {Ship:new(universe), Ship:new(universe)}
    universe.particle_system = ParticleSystem:new(universe)

    return universe
end

function Universe:keyboard_input()
    self.ships[1]:input(
        love.keyboard.isDown("w"),
        love.keyboard.isDown("s"),
        love.keyboard.isDown("a"),
        love.keyboard.isDown("d"),
        love.keyboard.isDown("lshift") or love.keyboard.isDown("lctrl") or love.keyboard.isDown("space")
    )
    self.ships[2]:input(
        love.keyboard.isDown("up"),
        love.keyboard.isDown("down"),
        love.keyboard.isDown("left"),
        love.keyboard.isDown("right"),
        love.keyboard.isDown("rshift") or love.keyboard.isDown("rctrl") or love.keyboard.isDown("kp0")
    )
end

function Universe:draw()
    -- draw background
    love.graphics.push("all")
    love.graphics.setColor(22/256, 22/256, 80/256)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    -- draw padding
    love.graphics.setColor(94/256, 0, 1)
    love.graphics.rectangle("fill", 0, 0, self.padding, love.graphics.getHeight())
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), self.padding)
    love.graphics.rectangle("fill", love.graphics.getWidth() - self.padding, 0, self.padding, love.graphics.getHeight())
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - self.padding, love.graphics.getWidth(), self.padding)
    love.graphics.pop()
    -- draw ships
    foreach(function(ship) ship:draw() end, self.ships)
    -- draw moons
    self.moons:draw()
    -- draw particles
    self.particle_system:draw()
end

function Universe:tick(dt)
    foreach(function(ship) ship:tick(dt) end, self.ships)
    self.moons:tick(dt)
    self.particle_system:tick(dt)
end
