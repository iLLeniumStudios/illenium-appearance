Locales = {}

function _L(key)
    local value = Locales[GetConvar("illenium-appearance:locale", "en")]
    for k in key:gmatch("[^.]+") do
        value = value[k]
        if not value then
            print("Missing locale for: " .. key)
            return ""
        end
    end
    return value
end
