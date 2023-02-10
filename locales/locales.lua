Locales = {}

function _L(key)
    local value = Locales[GetConvar("illenium-appearance:locale", "en")]
    for k in key:gmatch("[^.]+") do
        value = value[k]
        if not value then
            return ""
        end
    end
    return value
end
