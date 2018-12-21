ParticleSystem = {
    baseparticle = {
        size = 5,
        color = {1, 1, 1, 1},
        position = {0, 0},
        velocity = {0, 0},
        timeleft = 0.5
    },
    baseemitter = {
        position = {0, 0},
        amountpertick = 5,
        ticksleft = 100
    }
}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:new()
    local particle_system = {}
    setmetatable(particle_system, self)

    particle_system.particles = {}
    particle_system.emitters = {}

    return particle_system
end

function ParticleSystem:create_particle(x, y, vx, vy, size, time)

end

function ParticleSystem:create_emitter(x, y, amountpertick, ticks)

end

function ParticleSystem:tick(dt)
    -- todo
end

function ParticleSystem:draw()
    for i, particle in ipairs(self.particles) do
        love.graphics.push()
        love.graphics.setColor(particle.color)
        love.graphics.rectangle(love.graphics.DrawMode.fill, particle.position[1], particle.position[2], particle.size, particle.size)
        love.graphics.pop()
    end
end
