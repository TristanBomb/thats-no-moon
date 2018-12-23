ParticleSystem = {}
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

function ParticleSystem:create_emitter(x, y, v, amountpertick, ticks)
    self.emitters[#self.emitters + 1] = {
        size = size,
        x = x,
        y = y,
        v = v,
        amountpertick = amountpertick,
        ticksleft = ticks
    }
end

function ParticleSystem:tick(dt)
    -- Spawn particles from emitters
    for i, emitter in ipairs(self.emitters) do
        local randomdir = math.random() * math.pi * 2
        for _ = 0, emitter.amountpertick do
            self:create_particle(emitter.x, emitter.y, math.sin(randomdir) * emitter.v, math.cos(randomdir) * emitter.v, 5, 0.5)
        end
        emitter.ticksleft = emitter.ticksleft - 1
    end
    -- Remove old emitters
    for i, emitter in ipairs(self.emitters) do
        if emitter.ticksleft <= 0 then
            table.remove(self.emitters, i)
        end
    end
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
