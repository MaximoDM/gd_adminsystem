local display = false

function visualizandoDisplay()
    Citizen.CreateThread(function()
        while display do
            Citizen.Wait(10)
            DisableControlAction(0, 1, display) -- LookLeftRight
            DisableControlAction(0, 2, display) -- LookUpDown
            DisableControlAction(0, 142, display) -- MeleeAttackAlternate
            DisableControlAction(0, 18, display) -- Enter
            DisableControlAction(0, 322, display) -- ESC
            DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
        end
    end)
end

RegisterNUICallback("exit", function(data)
    display = false;
    SendNUIMessage({close = true})
    SetNuiFocus(false, false)
end)

RegisterNUICallback("apartado", function(data, cb)
    AdminSystem.Callback('gd_adminsystem:apartados', function(exportado)
        cb(exportado)
    end, data.ident, data.id)
end)

RegisterNetEvent('gd:abrirmenu')
AddEventHandler('gd:abrirmenu', function(user, licencia, inicial)
    local _source = source
    if getGroupGD(_source) then
        display = not display
        if display then
            visualizandoDisplay()
            SetNuiFocus(true, true)
            SendNUIMessage({nombreuser = user, licencia = licencia, info = inicial})
        else
            SendNUIMessage({close = true})
            SetNuiFocus(false, false)
        end
    end
end)