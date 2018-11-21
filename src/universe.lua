require("ship")
require("moons")
require("fp")

Universe = {}
Universe.__index = Universe
function Universe:new()
    local universe = {}
    setmetatable(universe, self)

    universe.moons = Moons.new()
    universe.ships = {Ship:new(), Ship:new()}

    return universe
end

function Universe:keyboard_input()
    ships[1]:input(
        love.keyboard.isDown("w"),
        love.keyboard.isDown("s"),
        love.keyboard.isDown("a"),
        love.keyboard.isDown("d"),
        love.keyboard.isDown("lshift") or love.keyboard.isDown("lctrl") or love.keyboard.isDown("space")
    )
    ships[2]:input(
        love.keyboard.isDown("up"),
        love.keyboard.isDown("down"),
        love.keyboard.isDown("left"),
        love.keyboard.isDown("right"),
        love.keyboard.isDown("rshift") or love.keyboard.isDown("rctrl") or love.keyboard.isDown("kp0")
    )
end

function Universe:draw()
    foreach(function(ship) ship:draw() end, self.ships)
    foreach(function(moons) moons:draw() end, self.moons)
end
