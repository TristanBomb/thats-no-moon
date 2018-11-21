require("fp")

Moon = {
    images = {
        love.graphics.newImage("asset/image/moon/moon_1.png"),
        love.graphics.newImage("asset/image/moon/moon_2.png"),
        love.graphics.newImage("asset/image/moon/moon_3.png")
    }
}
Moon.__index = Moon
function Moon:new()
    local moon = {}
    setmetatable(moon, self)

    moon.x = 0
    moon.y = 0
    moon.vx = 0
    moon.vy = 0
    moon.defaultimage = self.images[math.random(#self.images)]

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
    foreach(function (moon) love.graphics.draw(moon.defaultimage, self.x, self.y, self.theta + math.pi/2, 0.1) end, self.moonlist)
end

function Moons:fire()
end

function Moons:tick(dt)
end
