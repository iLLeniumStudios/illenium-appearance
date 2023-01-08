function Framework.GetGender()
    if Config.GenderBasedOnPed then
        local model = client.getPedModel(PlayerPedId())
        if model == "mp_f_freemode_01" then
            return "Female"
        end
        return "Male"
    end
    return Framework.GetPlayerGender()
end
