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

    moon.mass = 1
    moon.G = 1
    moon.x = 0
    moon.y = 0
    moon.vx = 0
    moon.vy = 0
    moon.defaultimage = self.images[math.random(#self.images)]

    return moon
end

function Moon:projected_field(x, y)
    dx = x - self.x
    dy = y - self.y
    r = quadsum(dx,dy)
    if r == 0 then
        return {0, 0}
    else
        g = G*self.mass/math.pow(r, 2)
        gx = F * dx / r
        gy = F * dy / r
        return {gx, gy}
    end
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

function Moons:get_field(x,y)
    total_field = {0, 0}
    for i, v in ipairs(self.moonlist) do
        this_field = v.projected_field(x, y)
        total_field[1] = total_field[1] + this_field[1]
        total_field[2] = total_field[2] + this_field[2]
    end
end
