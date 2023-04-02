function Framework.GetGender(isNew)
    if isNew or not Config.GenderBasedOnPed then
        return Framework.GetPlayerGender()
    end

    local model = client.getPedModel(cache.ped)
    return model == "mp_f_freemode_01" and "Female" or "Male"
end
