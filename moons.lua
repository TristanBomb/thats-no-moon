require("fp")

Moon = {
    images = {
        nodamage = {
            love.graphics.newImage("asset/image/moon/moon_1.png"),
            love.graphics.newImage("asset/image/moon/moon_2.png"),
            love.graphics.newImage("asset/image/moon/moon_3.png")
        },
        damage = {
            love.graphics.newImage("asset/image/moon/moon_1_dmg.png"),
            love.graphics.newImage("asset/image/moon/moon_2_dmg.png"),
            love.graphics.newImage("asset/image/moon/moon_3_dmg.png")
        }
    },
    mass = 1,
    G = 1000000,
    maxgravityforce = 50,
    radius = 25
}
Moon.__index = Moon
function Moon:new(copy)
    local moon = {}
    setmetatable(moon, self)

    moon.x = 0
    moon.y = 0
    moon.vx = 0
    moon.vy = 0
    moon.theta = 2 * math.pi * math.random()
    moon.vtheta = 0

    moon.damage = 0

    moon.imageindex = math.random(#self.images)
    moon.image = self.images.nodamage[moon.imageindex]

    return moon
end

function Moon:draw()
    love.graphics.draw(self.image, self.x, self.y, self.theta, 0.07, 0.07, self.image:getWidth()/2, self.image:getHeight()/2)
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
    foreach(function (moon) moon:draw() end, self.moonlist)
end

function Moons:fire(x, y, vx, vy, vtheta)
    local newmoon = Moon:new()
    newmoon.x = x
    newmoon.y = y
    newmoon.vx = vx
    newmoon.vy = vy
    newmoon.vtheta = vtheta + love.math.randomNormal(3, 0)
    table.insert(self.moonlist, newmoon)
end

function Moons:tick(dt)
    -- this works because tables are stored as pointers
    -- simple, easy hack to mutate the moon tables
    foreach(function (moon)
        local Gfx, Gfy = self:get_field(moon.x, moon.y)
        Gfx = clamp(Gfx,moon.maxgravityforce)
        Gfy = clamp(Gfy,moon.maxgravityforce)
        moon.vx = moon.vx - Gfx / moon.mass
        moon.vy = moon.vy - Gfy / moon.mass
        moon.x = moon.x + moon.vx * dt
        moon.y = moon.y + moon.vy * dt
        moon.theta = moon.theta + moon.vtheta * dt
        return moon
    end, self.moonlist)
    -- remove moons that are off the edge
    for i,v in ipairs(self.moonlist)  do
        if v.x < 0 or v.x > love.graphics.getWidth() or v.y < 0 or v.y > love.graphics.getHeight() then
            table.remove(self.moonlist, i)
        end
    end
    -- damage and remove moons that bop each other
    for i,v in ipairs(self.moonlist) do
        for j = 1, (i - 1) do
            local u = self.moonlist[j]
            if v == nil or u == nil then
                -- If either of the moons have been removed since the loop started, just break
                goto continue
            end
            local dist = quadsum(u.x - v.x, u.y - v.y)
            if dist < Moon.radius then
                for _, currmoon in ipairs({i, j}) do
                    if self.moonlist[currmoon].damage > 1 then
                        self.moonlist[currmoon] = nil
                    else
                        self.moonlist[currmoon].damage = self.moonlist[currmoon].damage + 1
                        self.moonlist[currmoon].image = self.moonlist[currmoon].images.damage[self.moonlist[currmoon].imageindex]
                    end
                end
            end
            ::continue::
        end
    end
    -- finish the removal process by pruning the list of nils
    for i = 1, #self.moonlist do
        if self.moonlist[i] == nil then
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
