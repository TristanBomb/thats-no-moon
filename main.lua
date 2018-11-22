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
    fpsinv = dt
    if stateenum == GameState.MainMenu then
        mainmenu:tick(dt)
    elseif stateenum == GameState.Universe then
        universe:tick(dt)
    end
end
