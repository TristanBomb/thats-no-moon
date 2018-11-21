require("fp")

Moon = {}
Moon.__index = Moon
function Moon:new()
    local moon = {}
    setmetatable(moon, self)

    moon.x = 0
    moon.y = 0
    moon.dx = 0
    moon.dy = 0

    return moon
end



Moons = {}
Moons.__index = Moons
function Moons:new()
    local moons = {}
    setmetatable(moons, self)

    moons.moonlist = {}

    return moons
end

function Moons:draw()
    foreach(function (moon) love.graphics.print("moon!", moon.x, moon.y) end, self.moonlist)
end

function Moons:fire()
end

function Moons:tick()
end
