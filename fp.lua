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
