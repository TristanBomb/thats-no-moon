require("fp")

Moon = {
    images = {
        love.graphics.newImage("asset/image/moon/moon_1.png"),
        love.graphics.newImage("asset/image/moon/moon_2.png"),
        love.graphics.newImage("asset/image/moon/moon_3.png")
    },
    mass = 1,
    G = 10000,
    maxgravityforce = 0.1
}
Moon.__index = Moon
function Moon:new(copy)
    local moon = {}
    if copy then
        moon.x = copy.x
        moon.y = copy.y
        moon.vx = copy.vx
        moon.vy = copy.vy
        moon.defaultimage = copy.defaultimage
    else
        moon.x = 0
        moon.y = 0
        moon.vx = 0
        moon.vy = 0
        moon.defaultimage = self.images[math.random(#self.images)]
    end

    setmetatable(moon, self)

    return moon
end
function Moon:projected_field(x, y)
    local dx = x - self.x
    local dy = y - self.y
    local r = quadsum(dx,dy)
    if r == 0 then
        return 0, 0
    else
        local g = self.G*self.mass/math.pow(r, 2)
        local gx = g * dx / r
        local gy = g * dy / r
        return gx, gy
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
    foreach(function (moon) love.graphics.draw(moon.defaultimage, moon.x, moon.y, 0, 0.1) end, self.moonlist)
end

function Moons:fire(x, y, theta, velocity)
    local newmoon = Moon:new()
    newmoon.x = x
    newmoon.y = y
    newmoon.vx = math.cos(theta) * velocity
    newmoon.vy = math.sin(theta) * velocity
    table.insert(self.moonlist, newmoon)
end

function Moons:tick(dt)
    -- this works because tables are stored as pointers
    -- simple, easy hack to mutate the moon tables
    foreach(function (moon)
        Gfx, Gfy = self:get_field(moon.x, moon.y)
        -- this calculation is VERY BROKEN
        -- it continually just sends moons to the top left corner
        -- TODO: please fix this tristan :^)
        moon.vx = moon.vx - math.min(math.abs(Gfx) / moon.mass, moon.maxgravityforce)
        moon.vy = moon.vy - math.min(math.abs(Gfy) / moon.mass, moon.maxgravityforce)
        moon.x = moon.x + moon.vx
        moon.y = moon.y + moon.vy
        return moon
    end, self.moonlist)
    -- remove moons that are off the edge
    for i,v in ipairs(self.moonlist)  do
        if v.x < 0 or v.x > love.graphics.getWidth() or v.y < 0 or v.y > love.graphics.getHeight() then
            table.remove(self.moonlist, i)
        end
    end
end

function Moons:get_field(x,y)
    local total_field = {0, 0}
    for i, v in ipairs(self.moonlist) do
        field_x, field_y = v:projected_field(x, y)
        total_field[1] = total_field[1] + field_x
        total_field[2] = total_field[2] + field_y
    end
    return unpack(total_field)
end
