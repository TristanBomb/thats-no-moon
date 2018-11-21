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
end

function Universe:draw()
    foreach(function(ship) ship:draw() end, self.ships)
    foreach(function(moons) moons:draw() end, self.moons)
end
