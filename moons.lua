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
    radius = 35,
    invulntime = 0.5
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
    moon.invulntimeleft = 0

    moon.imageindex = math.random(#self.images)
    moon.image = self.images.nodamage[moon.imageindex]

    return moon
end

function Moon:draw()
    love.graphics.draw(self.image, self.x, self.y, self.theta, 0.07, 0.07, self.image:getWidth()/2, self.image:getHeight()/2)
end

function Moon:do_damage()
    if self.invulntimeleft <= 0 then
        self.damage = self.damage + 1
        if self.damage > 0 then
            self.image = self.images.damage[self.imageindex]
        end
    end
    self.invulntimeleft = self.invulntime
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
function Moons:new(universe)
    local moons = {}
    setmetatable(moons, self)

    moons.moonlist = {}
    moons.universe = universe

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

function Moons:do_damage(moonindex)
    -- do the damage itself by calling Moon:do_damage
    self.moonlist[moonindex]:do_damage()
end

-- this MUST be called after calling Moons:do_damage()
function Moons:damage_finalizer()
    -- finish the damaging process by pruning the list of dead moons
    for i, v in ipairs(self.moonlist) do
        if v.damage > 1 then
            table.remove(self.moonlist, i)
        end
    end
end

function Moons:tick(dt)
    -- this works because tables are stored as pointers
    -- simple, easy hack to mutate the moon tables
    foreach(function (moon)
        -- update the invuln timer
        if moon.invulntimeleft > 0 then
            moon.invulntimeleft = moon.invulntimeleft - dt
        end
        local Gfx, Gfy = self:get_field(moon.x, moon.y)
        Gfx = clamp(Gfx,moon.maxgravityforce)
        Gfy = clamp(Gfy,moon.maxgravityforce)
        -- euler integration
        -- moon.vx = moon.vx - Gfx / moon.mass
        -- moon.vy = moon.vy - Gfy / moon.mass
        moon.x = moon.x + moon.vx * dt
        moon.y = moon.y + moon.vy * dt
        moon.theta = moon.theta + moon.vtheta * dt
        -- bounce the moons off the edge
        if moon.x <= universe.padding + moon.radius and moon.vx < 0 then
            moon.vx = -moon.vx
            moon:do_damage()
        elseif moon.y <= universe.padding + moon.radius and moon.vy < 0 then
            moon.vy = -moon.vy
            moon:do_damage()
        elseif moon.x >= love.graphics.getWidth() - universe.padding - moon.radius and moon.vx > 0 then
            moon.vx = -moon.vx
            moon:do_damage()
        elseif moon.y >= love.graphics.getHeight() - universe.padding - moon.radius and moon.vy > 0 then
            moon.vy = -moon.vy
            moon:do_damage()
        end
        return moon
    end, self.moonlist)
    self:damage_finalizer()
    -- bounce, damage, and remove moons that bop each other
    -- this for loop runs on every pair of moons
    for i,moon1 in ipairs(self.moonlist) do
        for j = 1, (i - 1) do
            local moon2 = self.moonlist[j]
            if moon1 == nil or moon2 == nil then
                -- If either of the moons have been removed since the loop started, just break
                goto continue
            end
            local dist = quadsum(moon2.x - moon1.x, moon2.y - moon1.y)
            if dist < Moon.radius then
                for _, currindex in ipairs({i, j}) do
                    -- deal the damage to the moons
                    self:do_damage(currindex)
                end
                -- bounce the moons
                -- big math warning :(
                local old1vx, old1vy = moon1.vx, moon1.vy
                -- bounce moon1
                local norm1, norm2 = subvector(moon2.x, moon2.y, -moon1.x, -moon1.y)
                local velovernorm1, velovernorm2 = vectorproj(moon1.vx, moon1.vy, norm1, norm2)
                -- local velovernorm1T, velovernorm2T = subvector(moon1.vx, moon1.vy, velovernorm1, velovernorm2)
                -- moon1.vx, moon1.vy = addvector(-velovernorm1, -velovernorm2, velovernorm1T, velovernorm2T)
                moon1.vx, moon1.vy = addvector(moon1.vx, moon1.vy, -2 * velovernorm1, -2 * velovernorm2)
                -- conservation of momentum
                local moonunit1, moonunit2 = unitvector(moon1.vx, moon1.vy)
                local othermag = quadsum(moon2.vx, moon2.vy)
                moon1.vx, moon1.vy = moonunit1 * othermag, moonunit2 * othermag
                -- bounce moon2
                local norm1, norm2 = addvector(moon1.x, moon1.y, -moon2.x, -moon2.y)
                local velovernorm1, velovernorm2 = vectorproj(moon2.vx, moon2.vy, norm1, norm2)
                -- local velovernorm1T, velovernorm2T = subvector(moon2.vx, moon2.vy, velovernorm1, velovernorm2)
                -- moon2.vx, moon2.vy = addvector(-velovernorm1, -velovernorm2, velovernorm1T, velovernorm2T)
                moon2.vx, moon2.vy = addvector(moon2.vx, moon2.vy, -2 * velovernorm1, -2 * velovernorm2)
                -- conservation of momentum
                local moonunit1, moonunit2 = unitvector(moon2.vx, moon2.vy)
                local othermag = quadsum(old1vx, old1vy)
                moon2.vx, moon2.vy = moonunit1 * othermag, moonunit2 * othermag
            end
            ::continue::
        end
    end
    self:damage_finalizer()
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
