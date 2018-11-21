math.randomseed(os.time())
local subtitles = {
    "That's No Sun, Either",
    "Gravity Extravaganza",
    "Punch Your Friends",
    "Send Help"
}

function love.conf(t)
    t.window.width = 1366
    t.window.height = 768

    t.window.title = string.format("That's No Moon: %s", subtitles[math.random(#subtitles)])
end
