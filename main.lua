require("universe")
require("gamestateenum")
require("mainmenu")

function love.load()
    universe = Universe:new()
    mainmenu = MainMenu:new()
    stateenum = GameState.Universe
    fpsinv = 1
end

function love.draw()
    love.graphics.clear()
    love.graphics.print("FPS: " .. tostring(math.floor(1/fpsinv), 10, 10))
    if stateenum == GameState.MainMenu then
        mainmenu:draw()
    elseif stateenum == GameState.Universe then
        universe:draw()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if stateenum == GameState.MainMenu then
        mainmenu:keyboard_input()
    elseif stateenum == GameState.Universe then
        universe:keyboard_input()
    end
end

function love.keyreleased(key, scancode, isrepeat)
    if stateenum == GameState.MainMenu then
    elseif stateenum == GameState.Universe then
        universe:keyboard_input()
    end
end

function love.update(dt)
    local tick_len = dt / love.ticks_per_frame
    if stateenum == GameState.MainMenu then
        for _ = 1, love.ticks_per_frame do
            mainmenu:tick(tick_len)
        end
    elseif stateenum == GameState.Universe then
        for _ = 1, love.ticks_per_frame do
            universe:tick(tick_len)
        end
    end
end
