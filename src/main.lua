require("universe")

function love.load()
    universe = Universe:new()
end

function love.draw()
    love.graphics.print("hello world!", 400, 300)
    love.graphics.clear()
    universe:draw()
end
