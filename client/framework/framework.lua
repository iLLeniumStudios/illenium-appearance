function Framework.GetGender(isNew)
    if isNew or not Config.GenderBasedOnPed then
        return Framework.GetPlayerGender()
    end

    local model = client.getPedModel(PlayerPedId())
    if model == "mp_f_freemode_01" then
        return "Female"
    end
    return "Male"
end
