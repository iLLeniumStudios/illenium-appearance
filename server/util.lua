math.randomseed(os.time())

local urlAlphabet = "useandom-26T198340PX75pxJACKVERYMINDBUSHWOLF_GQZbfghjklqvwyzrict"

function GenerateNanoID(size)
    local id = ""
    for _ = 1, size do
        local randomIndex = math.random(64)
        id = id .. urlAlphabet:sub(randomIndex,randomIndex)
    end
    return id
end
