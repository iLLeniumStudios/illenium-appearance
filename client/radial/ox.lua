if not Radial.IsOX() then return end

function Radial.Add(title, event)
    lib.addRadialItem({
        id = Radial.MenuID,
        icon = "shirt",
        label = title,
        event = event,
        onSelect = function()
            TriggerEvent(event)
        end
    })
end

function Radial.Remove()
    lib.removeRadialItem(Radial.MenuID)
end
