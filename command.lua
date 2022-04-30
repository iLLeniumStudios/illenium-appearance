RegisterCommand('customization', function()
    local config = {
      ped = true,
      headBlend = true,
      faceFeatures = true,
      headOverlays = true,
      components = true,
      props = true,
      tattoos = true,
    }
  
    exports['fivem-appearance']:startPlayerCustomization(function (appearance)
      if (appearance) then
        print('Saved')
      else
        print('Canceled')
      end
    end, config)
  end, false)
