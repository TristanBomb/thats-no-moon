ParticleSystem = {
    baseparticle = {
        size = 5,
        color = {1, 1, 1, 1},
        x = 0,
        y = 0,
        vx = 0,
        vy = 0,
        timeleft = 0.5
    },
    baseemitter = {
        position = {0, 0},
        amountpertick = 5,
        ticksleft = 100
    }
}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:new(universe)
    local particle_system = {}
    setmetatable(particle_system, self)

    particle_system.particles = {}
    particle_system.emitters = {}
    particle_system.universe = universe

    return particle_system
end

function ParticleSystem:create_particle(x, y, vx, vy, size, time)
    self.particles[#self.particles + 1] = {
        size = size,
        color = {1, 1, 1, 1},
        x = x,
        y = y,
        vx = vx,
        vy = vy,
        timeleft = time
    }
end

function ParticleSystem:create_emitter(x, y, amountpertick, ticks)

end

function ParticleSystem:tick(dt)
    --TODO
    self:create_particle(0, 0, 10, 10, 5, 1)
    -- todo
    -- Tick the particles
    for i, particle in ipairs(self.particles) do
        particle.x = particle.x + particle.vx * dt
        particle.y = particle.y + particle.vy * dt
        particle.timeleft = particle.timeleft - dt
    end
    -- Remove particles that are old
    for i, particle in ipairs(self.particles) do
        if particle.timeleft <= 0 then
            table.remove(self.particles, i)
        end
    end
end

function ParticleSystem:draw()
    for i, particle in ipairs(self.particles) do
        love.graphics.push()
        love.graphics.setColor(particle.color)
        love.graphics.rectangle("fill", particle.x, particle.y, particle.size, particle.size)
        love.graphics.pop()
    end
end
