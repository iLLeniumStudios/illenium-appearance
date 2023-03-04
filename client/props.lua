lib.onCache('ped', function(value)
    if Config.AlwaysKeepProps then
        SetPedCanLosePropsOnDamage(value, false, 0)
    end
end)