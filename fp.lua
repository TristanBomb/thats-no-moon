function map(f,a)
    local out = {}
    for i,v in ipairs(a) do
        out[i] = f(v)
    end
    return out
end

function foreach(f,a)
    for i,v in ipairs(a) do
        f(v)
    end
end

function quadsum(x,y)
    return math.sqrt(math.pow(x, 2) + math.pow(y, 2))
end

function unitvector(a1, a2)
    local norm = quadsum(a1, a2)
    return a1 / norm, a2 / norm
end

function dot(a1, a2, b1, b2)
    return a1 * b1 + a2 * b2
end

function addvector(a1, a2, b1, b2)
    return a1 + b1, a2 + b2
end

function subvector(a1, a2, b1, b2)
    return a1 - b1, a2 - b2
end

-- {a1,a2} is the vector getting projected
-- {b1,b2} is the vector being projected onto
-- proj_b(a)
function vectorproj(a1, a2, b1, b2)
    local unit1, unit2 = unitvector(b1, b2)
    local scalarproj = dot(a1, a2, unit1, unit2)
    return unit1 * scalarproj, unit2 * scalarproj
end

function bool2num(b)
    if b then
        return 1
    else
        return 0
    end
end

function num2bool(n)
    if n == 0 then
        return false
    else
        return true
    end
end

function clamp(x,lim)
    return math.min(math.max(x, -lim), lim)
end

function clamp2(x,llim,ulim)
    return math.min(math.max(x, llim), ulim)
end
