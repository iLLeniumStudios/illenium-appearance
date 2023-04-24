if not Radial.IsQB() then return end

function Radial.Add(title, event)
    exports["qbx-radialmenu"]:AddOption({
        id = Radial.MenuID,
        title = title,
        icon = "shirt",
        type = "client",
        event = event,
        shouldClose = true
    }, Radial.MenuID)
end

function Radial.Remove()
    exports["qbx-radialmenu"]:RemoveOption(Radial.MenuID)
end
