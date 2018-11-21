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
