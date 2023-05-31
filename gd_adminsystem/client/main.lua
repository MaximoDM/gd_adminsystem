CreateThread(function()
    TriggerServerEvent('getfig')
end)

AdminSystem = {}
AdminSystem.call = {}
local Callid = 1;
local duty = false

function getGroupGD(s)
    return true
end

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = { handle = iter, destructor = disposeFunc }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

AdminSystem.Callback = function(name, cb, ...)
    AdminSystem.call[Callid] = cb

    TriggerServerEvent('gd_admin:call', name, Callid, ...)

    if Callid < 65535 then
        Callid = Callid + 1
    else
        Callid = 0
    end
end

RegisterNetEvent('gd_admin:call')
AddEventHandler('gd_admin:call', function(id, ...)
    AdminSystem.call[id](...)
    AdminSystem.call[id] = nil
end)


function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

---------------
--  USERS T  --
---------------

RegisterNetEvent('gd:vlock')
AddEventHandler('gd:vlock', function()
    local _source = source
    if getGroupGD(_source) then
        local veh   = Core.Game.GetClosestVehicle()
        local lock  = GetVehicleDoorLockStatus(veh)
        local plate = string.gsub(GetVehicleNumberPlateText(veh), "^%s*(.-)%s*$", "%1")
        local name  = GetPlayerName(PlayerId())
        if lock == 1 or lock == 0 then
            SetVehicleDoorShut(veh, 0, true)
            SetVehicleDoorShut(veh, 1, true)
            SetVehicleDoorShut(veh, 2, true)
            SetVehicleDoorShut(veh, 3, true)
            SetVehicleDoorShut(veh, 4, true)
            SetVehicleDoorShut(veh, 5, true)
            SetVehicleDoorShut(veh, 6, true)
            SetVehicleDoorsLocked(veh, 2)
            Core.showNotification('Vehiculo cerrado [~y~' .. plate .. '~s~].')
            TriggerServerEvent('gd:discordlog', '[LOCK] **' .. name .. '** ha cerrado el vehiculo ' .. plate)
        else
            Core.showNotification('Vehiculo actualmente cerrado [~y~' .. plate .. '~s~].')
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent('gd:vunlock')
AddEventHandler('gd:vunlock', function()
    local _source = source
    if getGroupGD(_source) then
        local veh   = Core.Game.GetClosestVehicle()
        local lock  = GetVehicleDoorLockStatus(veh)
        local plate = string.gsub(GetVehicleNumberPlateText(veh), "^%s*(.-)%s*$", "%1")
        local name  = GetPlayerName(PlayerId())
        if lock == 2 then
            SetVehicleDoorsLocked(veh, 1)
            Core.showNotification('Vehiculo abierto [~y~' .. plate .. '~s~].')
            TriggerServerEvent('gd:discordlog', '[UNLOCK] **' .. name .. '** ha abierto el vehiculo ' .. plate)
        else
            Core.showNotification('Vehiculo actualmente abierto [~y~' .. plate .. '~s~].')
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent('gd:sfuel')
AddEventHandler('gd:sfuel', function(cantidad)
    local _source = source
    cantidad = tonumber(cantidad)
    if getGroupGD(_source) then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local name = GetPlayerName(PlayerId())
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if cantidad > 100 then cantidad = tonumber(100) end
            SetVehicleFuelLevel(veh, tonumber(cantidad) + 0.0)
            TriggerEvent('chatMessage', '^8[FUEL TOTAL]:^0 ' .. GetVehicleFuelLevel(veh))
            TriggerServerEvent('gd:discordlog', '[FUEL] **' ..
                name .. '** ha establecido el fuel del vehiculo a ' .. cantidad)
        else
            TriggerEvent('chatMessage', "^8ERROR:^0 no se ha encontrado el vehiculo.")
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent('gd:fix')
AddEventHandler('gd:fix', function()
    local _source = source
    if getGroupGD(_source) then
        local veh = GetVehiclePedIsIn(PlayerPedId())
        local name = GetPlayerName(PlayerId())
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            SetVehicleEngineHealth(veh, 1000)
            SetVehicleEngineOn(veh, true, true)
            SetVehicleFixed(veh)
            Core.showNotification('~g~Vehiculo reparado')
            TriggerServerEvent('gd:discordlog', '[FIX] **' .. name .. '** ha reparado un vehiculo.')
        else
            TriggerEvent('chatMessage', "^8ERROR:^0 no se ha encontrado el vehiculo.")
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

---------------
-- PERSONAJE --
---------------


RegisterNetEvent('gd:sv')
AddEventHandler('gd:sv', function(cantidad, admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        cantidad = tonumber(cantidad)
        if cantidad > 100 then cantidad = 100 end
        local Ped = PlayerPedId()
        SetEntityHealth(Ped, cantidad + 100)
        ClearPedBloodDamage(Ped)
        ResetPedVisibleDamage(Ped)
        ClearPedLastWeaponDamage(Ped)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent('gd:se')
AddEventHandler('gd:se', function(cantidad)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        SetPedArmour(PlayerPedId(), cantidad)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent('gd:muerte')
AddEventHandler('gd:muerte', function(admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        SetEntityHealth(PlayerPedId(), 0)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent("gd:congelar")
AddEventHandler("gd:congelar", function(admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        acongelar()
        FreezeEntityPosition(PlayerPedId(), true)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

function acongelar()
    if not congelado then
        congelado = true;
        if noclip then terminarnoclip(); end
        CreateThread(function()
            while congelado do
                Wait(0)
                DisablePlayerFiring(PlayerId(), true)
                FreezeEntityPosition(PlayerPedId(), true)
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
                end
            end
        end)
    end
end

RegisterNetEvent("gd:descongelar")
AddEventHandler("gd:descongelar", function(admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        congelado = false
        Wait(100)
        DisablePlayerFiring(PlayerId(), false)
        FreezeEntityPosition(PlayerPedId(), false)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent("gd:invisible")
AddEventHandler("gd:invisible", function(admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        TriggerServerEvent('gd:bchat', 0, true)
        SetEntityVisible(PlayerPedId(), false)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent("gd:visible")
AddEventHandler("gd:visible", function(admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        TriggerServerEvent('gd:bchat', 0, false)
        SetEntityVisible(PlayerPedId(), true)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

local invencible = false

RegisterNetEvent("gd:invencible")
AddEventHandler("gd:invencible", function(admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        ainvencible()
        SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

function ainvencible()
    if not invencible then
        invencible = true;
        CreateThread(function()
            while invencible do
                Wait(0)
                drawTxt(1.3, 1.43, 1.0, 1.0, 0.6, "INVENCIBLE", 255, 102, 255, 255)
            end
        end)
    end
end

RegisterNetEvent("gd:noinvencible")
AddEventHandler("gd:noinvencible", function(admin)
    local _source = source
    local _admin = admin
    if getGroupGD(_admin) then
        invencible = false
        SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

---------------
-- ADMIN UTI --
---------------

function deleteCar(entity)
    InvokeNative(0xEA386986E786A54F, PointerValueIntInitialized(entity))
end

function cleanPlayer()
    local playerPed = PlayerPedId()
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

function ApplySkin(clothe)
    local playerPed = PlayerPedId()

    if clothe['ears_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 2, clothe['ears_1'],
            clothe['ears_2'], 2)
    end

    SetPedComponentVariation(playerPed, 8, clothe['tshirt_1'], clothe['tshirt_2'], 2)  -- Tshirt
    SetPedComponentVariation(playerPed, 11, clothe['torso_1'], clothe['torso_2'], 2)   -- torso parts
    SetPedComponentVariation(playerPed, 3, clothe['arms'], clothe['arms_2'], 2)        -- Amrs
    SetPedComponentVariation(playerPed, 10, clothe['decals_1'], clothe['decals_2'], 2) -- decals
    SetPedComponentVariation(playerPed, 4, clothe['pants_1'], clothe['pants_2'], 2)    -- pants
    SetPedComponentVariation(playerPed, 6, clothe['shoes_1'], clothe['shoes_2'], 2)    -- shoes
    SetPedComponentVariation(playerPed, 1, clothe['mask_1'], clothe['mask_2'], 2)      -- mask
    SetPedComponentVariation(playerPed, 9, clothe['bproof_1'], clothe['bproof_2'], 2)  -- bulletproof
    SetPedComponentVariation(playerPed, 7, clothe['chain_1'], clothe['chain_2'], 2)    -- chain
    SetPedComponentVariation(playerPed, 5, clothe['bags_1'], clothe['bags_2'], 2)      -- Bag


    if clothe['ears_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 2, clothe['ears_1'],
            clothe['ears_2'], 2)
    end
    if clothe['helmet_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 0, clothe['helmet_1'],
            clothe['helmet_2'], 2)
    end
    if clothe['glasses_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 1, clothe['glasses_1'],
            clothe['glasses_2'], 2)
    end
    if clothe['watches_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 6, clothe['watches_1'],
            clothe['watches_2'], 2)
    end
    if clothe['bracelets_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 7,
            clothe['bracelets_1'], clothe['bracelets_2'], 2)
    end
end

local skin = {};

function LastSkin()
    if (not skin['model']) then return end
    local playerPed = PlayerPedId();

    if GetEntityModel(playerPed) ~= skin['model'] then
        RequestModel(skin['model'])

        CreateThread(function()
            while not HasModelLoaded(skin['model']) do
                RequestModel(skin['model'])
                Wait(0)
            end

            if IsModelInCdimage(skin['model']) and IsModelValid(skin['model']) then
                SetPlayerModel(PlayerId(), skin['model'])
                SetPedDefaultComponentVariation(playerPed)
            end

            SetModelAsNoLongerNeeded(skin['model'])
        end)
    end

    for a, b in pairs(skin['face']) do
        SetPedFaceFeature(playerPed, a, b + 0.0)
    end

    for a, b in pairs(skin['component']) do
        print(a, b)
        SetPedComponentVariation(playerPed, a, b[1], b[2], 2)
    end

    SetPedHairColor(playerPed, skin['Hair'], 0)

    for a, b in pairs(skin['prop']) do
        if b[1] ~= -1 then
            SetPedPropIndex(playerPed, a, b[1], b[2], 2)
        else
            ClearPedProp(playerPed, a)
        end
    end

    cleanPlayer()
end

function GetSkin()
    local playerPed = PlayerPedId();
    skin['model'] = GetEntityModel(playerPed);
    skin['face'] = {};
    skin['Hair'] = GetPedHairColor(playerPed);
    skin['component'] = {}
    skin['prop'] = {};

    for i = 0, 19, 1 do
        skin['face'][i] = GetPedFaceFeature(playerPed, i);
    end


    for i = 0, 11, 1 do
        skin['component'][i] = {};
        skin['component'][i][1] = GetPedDrawableVariation(playerPed, i);
        skin['component'][i][2] = GetPedTextureVariation(playerPed, i);
    end


    skin['prop'][0] = { [1] = GetPedPropIndex(playerPed, 0),[2] = GetPedPropTextureIndex(playerPed, 0) };
    skin['prop'][1] = { [1] = GetPedPropIndex(playerPed, 1),[2] = GetPedPropTextureIndex(playerPed, 1) };
    skin['prop'][2] = { [1] = GetPedPropIndex(playerPed, 2),[2] = GetPedPropTextureIndex(playerPed, 2) };
    skin['prop'][6] = { [1] = GetPedPropIndex(playerPed, 6),[2] = GetPedPropTextureIndex(playerPed, 6) };
    skin['prop'][7] = { [1] = GetPedPropIndex(playerPed, 7),[2] = GetPedPropTextureIndex(playerPed, 7) };
end

function setUniform(rank, nm)
    local model = GetEntityModel(PlayerPedId());
    if nm ~= 'f' then
        if model == GetHashKey('mp_m_freemode_01') or GetHashKey('a_m_y_hipster_01') or nm == 'm' then
            GetSkin();
            if model ~= GetHashKey('mp_m_freemode_01') then
                while not HasModelLoaded(GetHashKey('mp_m_freemode_01')) do
                    RequestModel(GetHashKey('mp_m_freemode_01'))
                    Wait(0)
                end

                if IsModelInCdimage(GetHashKey('mp_m_freemode_01')) and IsModelValid(GetHashKey('mp_m_freemode_01')) then
                    SetPlayerModel(PlayerId(), GetHashKey('mp_m_freemode_01'))
                    SetPedDefaultComponentVariation(playerPed)
                end

                SetModelAsNoLongerNeeded(GetHashKey('mp_m_freemode_01'))

                SetPedMaxHealth(PlayerPedId(), 200)
                SetEntityHealth(PlayerPedId(), 200)
            end
            ApplySkin(Config.Uniforme.admin[rank].male)
            cleanPlayer()
        else
            GetSkin();
            if model ~= GetHashKey('mp_f_freemode_01') then
                while not HasModelLoaded(GetHashKey('mp_f_freemode_01')) do
                    RequestModel(GetHashKey('mp_f_freemode_01'))
                    Wait(0)
                end

                if IsModelInCdimage(GetHashKey('mp_f_freemode_01')) and IsModelValid(GetHashKey('mp_f_freemode_01')) then
                    SetPlayerModel(PlayerId(), GetHashKey('mp_f_freemode_01'))
                    SetPedDefaultComponentVariation(playerPed)
                end

                SetModelAsNoLongerNeeded(GetHashKey('mp_f_freemode_01'))

                SetPedMaxHealth(PlayerPedId(), 200)
                SetEntityHealth(PlayerPedId(), 200)
            end

            ApplySkin(Config.Uniforme.admin[rank].female)
            cleanPlayer()
        end
    else
        GetSkin();
        if model ~= GetHashKey('mp_f_freemode_01') then
            while not HasModelLoaded(GetHashKey('mp_f_freemode_01')) do
                RequestModel(GetHashKey('mp_f_freemode_01'))
                Wait(0)
            end

            if IsModelInCdimage(GetHashKey('mp_f_freemode_01')) and IsModelValid(GetHashKey('mp_f_freemode_01')) then
                SetPlayerModel(PlayerId(), GetHashKey('mp_f_freemode_01'))
                SetPedDefaultComponentVariation(playerPed)
            end

            SetModelAsNoLongerNeeded(GetHashKey('mp_f_freemode_01'))

            SetPedMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), 200)
        end

        ApplySkin(Config.Uniforme.admin[rank].female)
        cleanPlayer()
    end
end

RegisterNetEvent("gd:tpm")
AddEventHandler("gd:tpm", function()
    local _source = source
    if getGroupGD(_source) then
        local WaypointHandle = GetFirstBlipInfoId(8)
        if DoesBlipExist(WaypointHandle) then
            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                if foundGround then
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                    break
                end
                Wait(5)
            end
        else
            Core.showNotification('Marca el punto en el mapa.')
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent('gd:scoche')
AddEventHandler('gd:scoche', function(asiento)
    local _source = source
    if getGroupGD(_source) then
        local playerPed = PlayerPedId()
        local vehicle = Core.Game.GetClosestVehicle()

        if DoesEntityExist(vehicle) then
            TaskWarpPedIntoVehicle(playerPed, vehicle, asiento)
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)

RegisterNetEvent('gd:dvbeta2')
AddEventHandler('gd:dvbeta2', function()
    local _source = source
    if getGroupGD(_source) then
        local playerPed = PlayerPedId()
        local veh       = Core.Game.GetClosestVehicle()
        SetEntityAsMissionEntity(veh, true, true)
        while not NetworkHasControlOfEntity(veh) do
            NetworkRequestControlOfEntity(veh)
            Wait(0)
        end

        if DoesEntityExist(veh) and NetworkHasControlOfEntity(veh) then
            SetEntityAsMissionEntity(veh, true, true)
            ExplodeVehicle(veh, false, true)
            DeleteVehicle(veh)
            deleteCar(veh)
            DeleteEntity(veh)
        end

        if DoesEntityExist(veh) then
            SetEntityAsMissionEntity(veh, true, true)
            NetworkExplodeVehicle(veh, false, false, true)
            ExplodeVehicle(veh, false, true)
            DeleteVehicle(veh)
            deleteCar(veh)
            DeleteEntity(veh)
        end

        SetEntityAsMissionEntity(veh, true, true)
        NetworkExplodeVehicle(veh, false, false, true)
        ExplodeVehicle(veh, false, true)
        DeleteVehicle(veh)
        deleteCar(veh)
        DeleteEntity(veh)

        Wait(3000)

        while not NetworkHasControlOfEntity(veh) do
            NetworkRequestControlOfEntity(veh)
            Wait(0)
        end

        if DoesEntityExist(veh) and NetworkHasControlOfEntity(veh) then
            SetEntityAsMissionEntity(veh, true, true)
            ExplodeVehicle(veh, false, true)
            DeleteVehicle(veh)
            deleteCar(veh)
            DeleteEntity(veh)
        end

        if DoesEntityExist(veh) then
            SetEntityAsMissionEntity(veh, true, true)
            NetworkExplodeVehicle(veh, false, false, true)
            ExplodeVehicle(veh, false, true)
            DeleteVehicle(veh)
            deleteCar(veh)
            DeleteEntity(veh)
        end

        SetEntityAsMissionEntity(veh, true, true)
        NetworkExplodeVehicle(veh, false, false, true)
        ExplodeVehicle(veh, false, true)
        DeleteVehicle(veh)
        deleteCar(veh)
        DeleteEntity(veh)
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)




RegisterNetEvent("gd:toggleDuty")
AddEventHandler("gd:toggleDuty", function(rank, duty, sex)
    local _source = source
    local playerPed = PlayerPedId()
    local _source = source
    if getGroupGD(_source) then
        if duty then
            TriggerEvent("chatMessage",
                "🤖^7» ^8AdminDuty ^7| Estas de servicio como staff. Usa ^8 /aduty ^7 para finalizar.")
            setUniform(rank, sex)
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), true)
        else
            TriggerEvent("chatMessage",
                "🤖^7» ^8AdminDuty ^7| Ya no estas de servicio. Utiliza ^8 /aduty ^7 para volver a entrar.")
            LastSkin();
            SetPlayerInvincibleKeepRagdollEnabled(PlayerId(), false)
        end
    else
        TriggerScriptEvent('gd_admin:banUser')
    end
end)


RegisterNetEvent("gd_admin:borrarcoches")
AddEventHandler("gd_admin:borrarcoches", function()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
            SetVehicleHasBeenOwnedByPlayer(vehicle, false)
            SetEntityAsMissionEntity(vehicle, false, false)
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then
                DeleteVehicle(vehicle)
            end
        end
    end
    -- TriggerEvent('chatMessage', '', { 255, 255, 255 }, "^1Borrado de vehículos completado!")
end)

RegisterNetEvent("gd_admin:borrarcochesarea")
AddEventHandler("gd_admin:borrarcochesarea", function(coordenadas, radio)
    for vehicle in EnumerateVehicles() do
        local distance = #(GetEntityCoords(PlayerPedId()) - coordenadas)
        if distance ~= nil and distance ~= -1 and distance < (radio or 20.0) then
            if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
                SetVehicleHasBeenOwnedByPlayer(vehicle, false)
                SetEntityAsMissionEntity(vehicle, false, false)
                DeleteVehicle(vehicle)
                if (DoesEntityExist(vehicle)) then
                    DeleteVehicle(vehicle)
                end
            end
        end
    end
    -- TriggerEvent('chatMessage', '', { 255, 255, 255 }, "^1Borrado de vehículos completado!")
end)

RegisterNetEvent("gd_admin:borrarpeds")
AddEventHandler("gd_admin:borrarpeds", function()
    for ped in EnumeratePeds() do
        if (not IsPedAPlayer(ped)) then
            SetEntityAsMissionEntity(ped, false, false)
            DeleteEntity(ped)
            if (DoesEntityExist(ped)) then
                DeleteEntity(ped)
            end
        end
    end
end)

RegisterNetEvent("gd_admin:borrarpedsarea")
AddEventHandler("gd_admin:borrarpedsarea", function(coordenadas, radio)
    for ped in EnumeratePeds() do
        if (not IsPedAPlayer(ped)) then
            local distance = #(GetEntityCoords(ped) - coordenadas)
            if distance ~= nil and distance ~= -1 and distance < (radio or 20.0) then
                SetEntityAsMissionEntity(ped, false, false)
                DeleteEntity(ped)
                if (DoesEntityExist(ped)) then
                    DeleteEntity(ped)
                end
            end
        end
    end
end)


RegisterNetEvent("gd_admin:borrarentityarea")
AddEventHandler("gd_admin:borrarentityarea", function(coordenadas, radio)
    for object in EnumerateObjects() do
        local distance = #(GetEntityCoords(object) - coordenadas)
        if distance ~= nil and distance ~= -1 and distance < (radio or 20.0) then
            local time = 0

            while not NetworkHasControlOfEntity(object) and time < 50 and DoesEntityExist(object) do
                Wait(0)
                NetworkRequestControlOfEntity(object)
                time = time + 1
            end

            if DoesEntityExist(object) and NetworkHasControlOfEntity(object) then
                SetEntityAsMissionEntity(object, false, true)
                DeleteEntity(object)
            end

            if DoesEntityExist(object) then
                NetworkRequestControlOfEntity(object)
                local time2 = 2000
                while time2 > 0 and not NetworkHasControlOfEntity(object) do
                    Wait(100)
                    time2 = time2 - 100
                end
                DeleteEntity(object)
            end
        end
    end
end)

RegisterNetEvent("gd_admin:borrarentity")
AddEventHandler("gd_admin:borrarentity", function()
    local obj = 0
    for object in EnumerateObjects() do
        obj = obj + 1
        DeleteEntity(object)
    end
end)
