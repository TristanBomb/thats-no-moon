require("universe")

function love.load()
    universe = Universe:new()
end

function love.draw()
    love.graphics.clear()
    universe:draw()
end

function love.keypressed(key, scancode, isrepeat)
    universe:keyboard_input()
end

function love.keyreleased(key, scancode, isrepeat)
    universe:keyboard_input()
end

function love.update(dt)
    universe:tick(dt)
end
