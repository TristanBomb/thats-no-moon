math.randomseed(os.time())
local subtitles = {
    "That's No Sun, Either",
    "Gravity Extravaganza",
    "Shoot Your Friends",
    "Punch Your Friends",
    "Send Help",
    "Don't Get Bopped"
}

function love.conf(t)
    t.window.width = 1366
    t.window.height = 768
    t.window.icon = "asset/image/icon/icon.png"
    t.window.title = string.format("That's No Moon: %s", subtitles[math.random(#subtitles)])
    t.window.msaa = 16
end

love.ticks_per_frame = 5
