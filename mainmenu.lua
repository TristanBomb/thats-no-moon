MainMenu = {
    images = {
        title = love.graphics.newImage("asset/image/main_menu/title.png"),
        moons = {
            love.graphics.newImage("asset/image/moon/moon_1.png"),
            love.graphics.newImage("asset/image/moon/moon_2.png"),
            love.graphics.newImage("asset/image/moon/moon_3.png")
        }
    }
}
MainMenu.__index = MainMenu
function MainMenu:new()
    local mainmenu = {}
    setmetatable(mainmenu, self)

    mainmenu.t = 0
    mainmenu.particles = {}

    return mainmenu
end

function MainMenu:draw()
    function saw(t)
        t = math.abs(math.fmod(t, 1))
        if t < 0.5 then
            return 2*t
        else
            return -2*t + 2
        end
    end

    -- draw background
    --love.graphics.setBackgroundColor(22/256, 22/256, 80/256)
    love.graphics.push("all")
    love.graphics.setColor(22/256, 22/256, 80/256)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.pop()

    -- draw cool title effect
    love.graphics.push()
    local cooltitletrans = love.math.newTransform()
    cooltitletrans:translate(love.graphics.getWidth()/2, 100)
    cooltitletrans:rotate((saw(self.t/2)-0.5)*0.1)
    cooltitletrans:scale(1 + 0.1*saw(self.t/2.1))
    love.graphics.applyTransform(cooltitletrans)
    love.graphics.draw(self.images.title, self.x, self.y, 0, 0.5, 0.5, self.images.title:getWidth()/2, self.images.title:getHeight()/2)
    love.graphics.pop()

    -- draw particles
    foreach(function (particle)
        love.graphics.push("all")
        love.graphics.setColor(255, 255, 255, particle.opacity)
        love.graphics.draw(particle.image, particle.x, particle.y, particle.theta, particle.size)
        love.graphics.pop()
    end, self.particles)
end

function MainMenu:keyboard_input()
end

function MainMenu:new_particle()
    size = math.random() / 3 + 0.3
    image = self.images.moons[math.random(#self.images.moons)]
    table.insert(self.particles, {
        size = size,
        image = image,
        x = love.graphics.getWidth() + image:getWidth() * size + 50,
        -- don't spawn at the _very_ top
        y = math.random(love.graphics.getHeight() - 200) + 200,
        vx = -math.random(5),
        vy = 0,
        theta = math.random() * 6.28,
        opacity = 0.5
    })
end

function MainMenu:tick(dt)
    -- increase time variable for animations
    self.t = self.t + dt

    -- simulate particle physics
    for i, v in ipairs(self.particles) do
        v.x = v.x + v.vx
        v.y = v.y + v.vy
        v.vy = v.vy + 0.01
        if v.y > love.graphics.getHeight() + (v.image:getWidth() * v.size) + 50 then
            table.remove(self.particles, i)
        end
        -- make particles fade out
        v.opacity = v.opacity * math.pow(0.8, dt)
    end
    -- spawn new particles
    if math.random() > 0.95 then
        self:new_particle()
    end
end
