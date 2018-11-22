MainMenu = {
    images = {
        title = love.graphics.newImage("asset/image/main_menu/title.png")
    }
}
MainMenu.__index = MainMenu

function MainMenu:new()
    local mainmenu = {}
    setmetatable(mainmenu, self)

    mainmenu.t = 0

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

    -- draw cool title effect
    love.graphics.push()
    local cooltitletrans = love.math.newTransform()
    cooltitletrans:translate(love.graphics.getWidth()/2, 100)
    cooltitletrans:rotate((saw(self.t/2)-0.5)*0.1)
    cooltitletrans:scale(1 + 0.1*saw(self.t/2.1))
    love.graphics.applyTransform(cooltitletrans)
    love.graphics.draw(self.images.title, self.x, self.y, 0, 0.5, 0.5, self.images.title:getWidth()/2, self.images.title:getHeight()/2)
    love.graphics.pop()
end

function MainMenu:keyboard_input()
end

function MainMenu:tick(dt)
    self.t = self.t + dt
end
