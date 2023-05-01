if not Radial.IsQBX() and not Radial.IsQB() then return end

function Radial.Add(title, event)
    exports[Radial.ResourceName]:AddOption({
        id = Radial.MenuID,
        title = title,
        icon = "shirt",
        type = "client",
        event = event,
        shouldClose = true
    }, Radial.MenuID)
end

function Radial.Remove()
    exports[Radial.ResourceName]:RemoveOption(Radial.MenuID)
end
