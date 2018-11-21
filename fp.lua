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
