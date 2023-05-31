-- core=nil
--TriggerEvent('gd_core:datos', function(obj) Core = obj end, false)

local anunciospermanentes = {}
local hideAdmin = {}

--Activar Noclip
RegisterCommand('noclip', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.noclip) then
        if args[1] and tonumber(args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('gd:npt', tonumber(args[1]))
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        elseif not args[1] then
            TriggerClientEvent('gd:npt', _source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /noclip <ID>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)


-- RegisterCommand('clearall', function(args, showError)
--     local xAdmin = Core.GetPlayerFromId(source)
--     if AdminSystem.inArray(xAdmin.getGroup(), Permisos.noclip) then
--      TriggerClientEvent('chat:clear', -1)
--     else
--       TriggerClientEvent('chat:addMessage', "No tienes suficientes permisos")
--     end
-- end)
local dimensionGuardada = {}

--Activar Recon Usuario
RegisterCommand('recon', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.recon) then
        if args[1] and tonumber(args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                local target, coords, name = tonumber(args[1]), GetEntityCoords(GetPlayerPed(tonumber(args[1]))),
                    GetPlayerName(tonumber(args[1]))
                TriggerClientEvent('gd:rs', _source, target, coords)
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        elseif args[1] == 'off' then
            TriggerClientEvent('gd:rsoff', _source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /recon [ID]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Ir a jugador
RegisterCommand('ira', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.ira) then
        if args[1] and tonumber(args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                local tcoords = GetEntityCoords(GetPlayerPed(args[1]))
                AdminSystem.coordenadas['staff'][_source] = GetEntityCoords(GetPlayerPed(_source));
                dimensionGuardada[source] = GetPlayerRoutingBucket(source)
                SetPlayerRoutingBucket(source, GetPlayerRoutingBucket(args[1]))
                SetEntityCoords(GetPlayerPed(_source), tcoords)
                sendtoDiscord('[IRA] **' ..
                    xAdmin.getName() .. '** se ha teletransportado a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /ira [ID]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Ir a jugador
RegisterCommand('atras', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.atras) then
        if not args[1] then
            if AdminSystem.coordenadas['staff'][_source] then
                SetPlayerRoutingBucket(source, dimensionGuardada[source])
                dimensionGuardada[source] = nil
                SetEntityCoords(GetPlayerPed(_source), AdminSystem.coordenadas['staff'][_source])
                sendtoDiscord('[ATRAS] **' .. xAdmin.getName() .. '** ha vuelto a su coordenada anterior.')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 no tienes coordenadas guardadas.")
            end
        elseif (args[1] and not args[2]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                if AdminSystem.coordenadas['traer'][_source] then
                    SetPlayerRoutingBucket(args[1],
                        dimensionGuardada[args[1]])
                    dimensionGuardada[args[1]] = nil
                    SetEntityCoords(GetPlayerPed(tonumber(args[1])), AdminSystem.coordenadas['traer'][_source])
                    xTarget.showNotification('Has sido devuelto por un miembro del staff a tu coordenada anterior.',
                        'success', 5000)
                    xAdmin.showNotification('Has devuelto a ' .. xTarget.getName() .. ' a su coordenada anterior.',
                        'success',
                        5000)
                    sendtoDiscord('[ATRASPLAYER] **' ..
                        xAdmin.getName() ..
                        '** ha devuelto a ' .. xTarget.getName() .. ' (' .. args[1] .. ') a su coordenada anterior.')
                else
                    TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 el usuario no tiene coordenadas guardadas.")
                end
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /atras <ID>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--TraerJugador
RegisterCommand('traer', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.traer) then
        if args[1] and tonumber(args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                dimensionGuardada[args[1]] = GetPlayerRoutingBucket(args[1])
                SetPlayerRoutingBucket(args[1], GetPlayerRoutingBucket(source))
                local tcoords = GetEntityCoords(GetPlayerPed(_source))
                AdminSystem.coordenadas['traer'][_source] = GetEntityCoords(GetPlayerPed(args[1]))
                SetEntityCoords(GetPlayerPed(tonumber(args[1])), tcoords)
                xTarget.showNotification('Has sido traído por el staff: ' .. xAdmin.getName() .. '.', 'success', 5000)
                sendtoDiscord('[TRAER] **' ..
                    xAdmin.getName() .. '** ha traido a ' .. xTarget.getName() .. ' (' .. args[1] .. ') a su posición.')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /traer [ID]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('setvida', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.setvida) then
        if args[1] and tonumber(args[1]) and not args[2] then
            TriggerClientEvent('gd:sv', _source, args[1], _source)
            sendtoDiscord('[VIDA] **' .. xAdmin.getName() .. '** se ha establecido ' .. args[1] .. ' de vida.')
        elseif (args[1] and tonumber(args[1]) and args[2]) and tonumber(args[2]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('gd:sv', args[1], args[2], _source)
                sendtoDiscord('[VIDA] **' ..
                    xAdmin.getName() ..
                    '** ha establecido ' .. args[1] .. ' de vida a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /setvida <ID>/[CANTIDAD] <CANTIDAD>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Establecer valor de escudo.
RegisterCommand('setescudo', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.setescudo) then
        if args[1] and tonumber(args[1]) and not args[2] then
            local cantidad = tonumber(args[1])
            TriggerClientEvent('gd:se', _source, cantidad, _source)
            sendtoDiscord('[ESCUDO] **' .. xAdmin.getName() .. '** se ha establecido ' .. args[1] .. ' de escudo.')
        elseif (args[1] and tonumber(args[1]) and args[2] and tonumber(args[2])) then
            local xTarget = Core.GetPlayerFromId(args[1])
            local cantidad = tonumber(args[2])
            if xTarget then
                TriggerClientEvent('gd:se', args[1], cantidad, _source)
                sendtoDiscord('[ESCUDO] **' ..
                    xAdmin.getName() ..
                    '** ha establecido ' .. args[1] .. ' de escudo a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /setescudo <ID>/[CANTIDAD] <CANTIDAD>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Matar jugador
RegisterCommand('muerte', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.muerte) then
        if not args[1] then
            TriggerClientEvent('gd:muerte', _source, _source)
            sendtoDiscord('[MUERTE] **' .. xAdmin.getName() .. '** se ha matado.')
        elseif args[1] and tonumber(args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('gd:muerte', args[1], _source)
                sendtoDiscord('[MUERTE] **' ..
                    xAdmin.getName() .. '** ha matado a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /muerte <ID>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Ir a localizacion
RegisterCommand('ir', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.ir) then
        if args[1] and tonumber(args[1]) then
            if AdminSystem.localizaciones[tonumber(args[1])] then
                SetEntityCoords(GetPlayerPed(_source), AdminSystem.localizaciones[tonumber(args[1])])
                sendtoDiscord('[IR] **' .. xAdmin.getName() .. '** ha ido al punto ' .. tonumber(args[1]))
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 No se encontro la localizacion.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /ir [IDLOC]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Sacar info usuario (Id y Steam ID)
RegisterCommand('id', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.id) then
        if tonumber(args[1]) ~= nil then
            for _, playerId in ipairs(GetPlayers()) do
                if args[1] == playerId then
                    TriggerClientEvent('chatMessage', _source,
                        '[INFO] ID: ^5 ' ..
                        playerId ..
                        ' ^0NOMBRE: ^5 ' .. GetPlayerName(playerId) .. ' ^0(PING: ^5 ' .. GetPlayerPing(playerId) ..
                        '^0)')
                    return
                end
            end
            if string.len(table.concat(args, " ")) >= 3 then
                local p = 0
                for _, playerId in ipairs(GetPlayers()) do
                    if string.match(GetPlayerName(playerId):lower(), table.concat(args, " "):lower()) then
                        p = p + 1
                        TriggerClientEvent('chatMessage', _source,
                            '[INFO] ID: ^5 ' ..
                            playerId ..
                            ' ^0NOMBRE: ^5 ' .. GetPlayerName(playerId) ..
                            ' ^0(PING: ^5 ' .. GetPlayerPing(playerId) .. '^0)')
                    end
                end
                if p > 0 then
                    return
                end
            end
        elseif args[1] then
            if string.len(table.concat(args, " ")) >= 3 then
                local p = 0
                for _, playerId in ipairs(GetPlayers()) do
                    if string.match(GetPlayerName(playerId):lower(), table.concat(args, " "):lower()) then
                        p = p + 1
                        TriggerClientEvent('chatMessage', _source,
                            '[INFO] ID: ^5 ' ..
                            playerId ..
                            ' ^0NOMBRE: ^5 ' .. GetPlayerName(playerId) ..
                            ' ^0(PING: ^5 ' .. GetPlayerPing(playerId) .. '^0)')
                    end
                end
                if p > 0 then
                    return
                end
            else
                TriggerClientEvent('chatMessage', _source,
                    '^8ERROR:^0 Caracteres Insuficientes para realizar la busqueda.')
                return
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /id [ID]/[PARTE NOMBRE]")
            return
        end
        TriggerClientEvent('chatMessage', _source, '^8ERROR:^0 Sin resultado.')
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Crear anuncios permanentes
RegisterCommand('panuncio', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.panuncio) then
        if args[1] then
            local name = GetPlayerName(_source)
            local msg = table.concat(args, " ")
            TriggerClientEvent('chat:addMessage', -1, {
                template =
                '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(179, 0, 0, 1); border-radius: 4px;"><b>{0}</b>{1}</div>',
                args = { "Anuncio Administrativo:", "^0  " .. table.concat(args, " ") }
            })
            table.insert(anunciospermanentes, { mensaje = msg })
            sendtoDiscord('[PANUNCIO] **' ..
                xAdmin.getName() .. '** ha establecido un nuevo anuncio permanente: **' .. table.concat(args, " ") ..
                '**')
        else
            TriggerClientEvent('chatMessage', _source, "USO: /panuncio [ANUNCIO]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Crear anuncios permanentes
RegisterCommand('canuncio', function(source, args, RawCommand)
    local _source = source
    if _source == 0 then
        if args[1] then
            local msg = table.concat(args, " ")
            TriggerClientEvent('chat:addMessage', -1, {
                template =
                '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(179, 0, 0, 1); border-radius: 4px;"><b>{0}</b>{1}</div>',
                args = { "Anuncio Administrativo:", "^0  " .. table.concat(args, " ") }
            })
        end
    end
end, false)

RegisterCommand('anuncios', function(source, args, RawCommand)
    local _source = source
    if next(anunciospermanentes) == nil then
        TriggerClientEvent('chatMessage', _source, "No hay anuncios publicados.")
    else
        TriggerClientEvent('chatMessage', _source, " ^5Anuncios:")
        for i = 1, #anunciospermanentes, 1 do
            TriggerClientEvent('chatMessage', _source,
                "^8[" ..
                table.indexOf(anunciospermanentes, anunciospermanentes[i]) .. "] ^0|   " ..
                anunciospermanentes[i].mensaje)
        end
    end
end, false)

--Canal de charla staff
RegisterCommand('staff', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.chatstaff) then
        if args[1] then
            local xPlayers = Core.GetPlayers()
            local name = GetPlayerName(_source)
            sendtoDiscord('[CHAT-STAFF] **' .. xAdmin.getName() .. '** : ' .. table.concat(args, " "))
            for i = 1, #xPlayers, 1 do
                local xPlayer = Core.GetPlayerFromId(xPlayers[i])
                local group = xPlayer.getGroup()
                if (
                    group == 'admin' or group == 'superadmin' or group == 'gamemaster' or group == 'mod' or
                    group == 'helper') and (not AdminSystem.inArray(xPlayers[i], hideAdmin)) then
                    TriggerClientEvent('chatMessage', xPlayers[i],
                        '[^3STAFF^0] | ^4' .. name .. ' ^0| ^2 ' .. tostring(_source) .. ' ^0| ' ..
                        table.concat(args, " "))
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Congelar jugador.
RegisterCommand('congelar', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.congelar) then
        local xTarget = Core.GetPlayerFromId(args[1])
        if args[1] then
            if xTarget then
                TriggerClientEvent('gd:congelar', args[1], _source)
                sendtoDiscord('[CONGELAR] **' ..
                    xAdmin.getName() .. '** ha congelado a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /congelar [ID]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Descongelar jugador.
RegisterCommand('descongelar', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.descongelar) then
        local xTarget = Core.GetPlayerFromId(args[1])
        if args[1] then
            if xTarget then
                TriggerClientEvent('gd:descongelar', args[1], _source)
                sendtoDiscord('[DESCONGELAR] **' ..
                    xAdmin.getName() .. '** ha descongelado a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /descongelar [ID]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Kick a jugador
RegisterCommand('kick', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if xAdmin and AdminSystem.inArray(xAdmin.getGroup(), Permisos.kick) then
        if args[1] and tonumber(args[1]) and args[2] then
            local xPlayer = Core.GetPlayerFromId(tonumber(args[1]))
            local reason = ""
            for i, theArg in pairs(args) do
                if i ~= 1 then
                    reason = reason .. " " .. theArg
                end
            end
            sendtoDiscord('[KICK] **' ..
                xAdmin.getName() .. '** ha kickeado a ' .. xPlayer.getName() .. ' (' .. args[1] .. '). Por: ' .. reason)
            DropPlayer(tonumber(args[1]), reason)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /kick [ID] [REASON]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Poner jugador visible
RegisterCommand('visible', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.visible) then
        if not args[1] then
            TriggerClientEvent('gd:visible', _source, _source)
            sendtoDiscord('[VISIBLE] **' .. xAdmin.getName() .. '** se ha hecho visible.')
        elseif args[1] then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('gd:visible', args[1], _source)
                sendtoDiscord('[VISIBLE] **' ..
                    xAdmin.getName() .. '** ha hecho visible a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /visible <ID>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Poner jugador invisible
RegisterCommand('invisible', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.invisible) then
        if (not args[1]) then
            TriggerClientEvent('gd:invisible', _source, _source)
            sendtoDiscord('[INVISBLE] **' .. xAdmin.getName() .. '** se ha hecho invisible.')
        elseif (args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('gd:invisible', args[1], _source)
                sendtoDiscord('[INVISBLE] **' ..
                    xAdmin.getName() .. '** ha hecho invisible a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /invisible <ID>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Poner jugador no invencible
RegisterCommand('noinvencible', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.noinvencible) then
        if (not args[1]) then
            TriggerClientEvent('gd:noinvencible', _source, _source)
            sendtoDiscord('[NOINVENCIBLE] **' .. xAdmin.getName() .. '** se ha hecho noinvencible.')
        elseif (args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('gd:noinvencible', args[1], _source)
                sendtoDiscord('[NOINVENCIBLE] **' ..
                    xAdmin.getName() .. '** ha hecho noinvencible a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /noinvencible <ID>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Poner jugador invencible
RegisterCommand('invencible', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.invencible) then
        if (not args[1]) then
            TriggerClientEvent('gd:invencible', _source, _source)
            sendtoDiscord('[INVENCIBLE] **' .. xAdmin.getName() .. '** se ha hecho invencible.')
        elseif (args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('gd:invencible', args[1], _source)
                sendtoDiscord('[INVENCIBLE] **' ..
                    xAdmin.getName() .. '** ha hecho invencible a ' .. xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /invencible <ID>")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Ocultar Chat de admin
RegisterCommand('hadmin', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.chatstaff) then
        if not args[1] then
            if AdminSystem.inArray(_source, hideAdmin) then
                for k, v in pairs(hideAdmin) do
                    if v == _source then
                        table.remove(hideAdmin, k)
                    end
                end
                TriggerClientEvent('chatMessage', _source, "Chat administrativo visible.")
            else
                table.insert(hideAdmin, _source)
                TriggerClientEvent('chatMessage', _source, "Chat administrativo oculto.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /hadmin")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Ocultar chat de reportes
RegisterCommand('hreportes', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.reportes) then
        if (not args[1]) then
            AdminSystem.hreportes(_source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /hreportes")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

-- Arreglar coche
RegisterCommand('fix', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    -- local xAdmin = Core.GetPlayerFromId(_source)
    -- if AdminSystem.inArray(xAdmin.getGroup(), Permisos.fix) then
    TriggerClientEvent('gd:fix', _source)
    --else
    --  TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    -- end
end, false)

-- Limpiar coche
RegisterCommand('clean', function(source, args, RawCommand)
    local _source = source
    -- local xAdmin = Core.GetPlayerFromId(_source)
    -- if AdminSystem.inArray(xAdmin.getGroup(), Permisos.clean) then
    local veh = GetVehiclePedIsIn(GetPlayerPed(_source))
    if veh ~= 0 then
        SetVehicleDirtLevel(veh, 0)
        --  xAdmin.showNotification("~g~Vehiculo limpiado")
        --  sendtoDiscord('[CLEAN] **'..xAdmin.name..'** ha limpiado un vehiculo.')
    else
        TriggerEvent('chatMessage', "^8ERROR:^0 no se ha encontrado el vehiculo.")
    end
    -- else
    --     TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    -- end
end, false)

-- Poner valor de fuel
-- RegisterCommand('setfuel', function(source, args, RawCommand) -- CLIENTE
--     local _source = source
--     local xAdmin = Core.GetPlayerFromId(_source)
--     if AdminSystem.inArray(xAdmin.getGroup(), Permisos.setfuel) then
--         if args[1] then
--             local cantidad = tonumber(args[1])
--             TriggerClientEvent('gd:sfuel', _source, cantidad)
--         else
--             TriggerClientEvent('chatMessage', _source, "USO: /setfuel [CANTIDAD]")
--         end
--     else
--         TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
--     end
-- end, false)

--Anuncios administrativos
RegisterCommand('admin', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.admin) then
        if args[1] then
            local name = GetPlayerName(_source)
            TriggerClientEvent('chat:addMessage', -1, {
                template =
                '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(179, 0, 0, 1); border-radius: 4px;"><b>{0}</b>{1}</div>',
                args = { "Aviso Administrativo | " .. name .. " : ", "^0  " .. table.concat(args, " ") }
            })
            sendtoDiscord('[ANUNCIO] **' .. xAdmin.getName() .. '** ha publicado un anuncio: ' .. table.concat(args, " "))
        else
            TriggerClientEvent('chatMessage', _source, "USO: /admin [ANUNCIO]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Bloquear coche
RegisterCommand('lockcoche', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.lockcoche) then
        TriggerClientEvent('gd:vlock', _source)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Desbloquear coche
RegisterCommand('unlockcoche', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.unlockcoche) then
        TriggerClientEvent('gd:vunlock', _source)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

--Coordenadas actuales
RegisterCommand('coordenadas', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.coordenadas) then
        if not args[1] then
            print(GetEntityCoords(GetPlayerPed(_source)) .. 'H: ' .. GetEntityHeading(GetPlayerPed(_source)))
            sendtoDiscordPrint(GetEntityCoords(GetPlayerPed(_source)) .. 'H: ' .. GetEntityHeading(GetPlayerPed(_source)))
        else
            TriggerClientEvent('chatMessage', _source, "USO: /coordenadas")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('tpm', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.tpm) then
        if not args[1] then
            TriggerClientEvent('gd:tpm', _source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /tpm")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('report', function(source, args, RawCommand)
    local _source = source
    local reason = table.concat(args, " ")
    local playerName = GetPlayerName(_source)
    if reason == "" or not reason then
        TriggerClientEvent("chat:addMessage", source,
            { color = { 255, 0, 0 }, multiline = false, args = { "GLADIATOR", "Especifica una razón." } });
    else
        AdminSystem.Reportar(_source, reason, playerName)
    end
end, false)

RegisterCommand('atender', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.reportes) then
        if args[1] and tonumber(args[1]) then
            local playerName = GetPlayerName(_source)
            AdminSystem.AntederReporte(_source, tonumber(args[1]), playerName)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /atender [id-reporte]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('reportes', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.reportes) then
        if not args[1] then
            AdminSystem.ListaReportes(_source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /reportes")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('dv2', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.dvbeta2) then
        if not args[1] then
            TriggerClientEvent('gd:dvbeta2', source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /dv2")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('dv', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.dvbeta2) then
        if not args[1] then
            TriggerClientEvent('gd:dvbeta2', source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /dv")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('entrarcoche', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.seatcoche) then
        if not args[2] then
            local asiento = -1
            if args[1] and tonumber(args[1]) then asiento = tonumber(args[1]) end
            TriggerClientEvent('gd:scoche', source, asiento)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /entrarcoche")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

local usuario = nil

RegisterCommand('si', function(source, RawCommand, args)
    local _source = source
    usuario = _source
    usuario = tonumber(usuario)
    Wait(2000)
    usuario = nil
end)

RegisterCommand('revivemasivo', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.reviveall) then
        if not args[1] then
            TriggerClientEvent('chatMessage', _source, '^8Utiliza el comando /si para aceptar la peticion.')
            local time = 8
            while usuario == nil or usuario < _source or usuario > _source do
                Wait(1000)
                time = time - 1
                if time < 0 then
                    TriggerClientEvent('chatMessage', _source, '^8Lo ziento, comando caducado.')
                    return
                end
            end
            if usuario == _source then
                usuario = nil
                AdminSystem.ReviveAll(_source)
                sendtoDiscord('[REVIVEALL] **' .. xAdmin.getName() .. '** ha revivido a todo quisqui.')
            end
            usuario = nil
        else
            TriggerClientEvent('chatMessage', _source, "USO: /reviveall")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)


RegisterCommand('arevive', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.revive) then
        if args[1] then
            AdminSystem.Revive(_source, args[1])
        else
            TriggerClientEvent('chatMessage', _source, "USO: /arevive [id]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)


RegisterCommand('ha', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.ha) then
        if args[1] and tonumber(args[1]) then
            local xTarget = Core.GetPlayerFromId(args[1])
            if xTarget then
                local inc = ' USUARIO: <span>' .. xTarget.getName() .. '</span><br> ID: ' .. args[1]
                local inf = getInfo(xAdmin.getGroup(), xTarget.identifier, xTarget)
                TriggerClientEvent('gd:abrirmenu', _source, inc, xTarget.identifier, inf)
                sendtoDiscord('[HA] **' ..
                    xAdmin.getName() .. '** esta revisando el historial de ' .. xTarget.getName() .. ' (' ..
                    args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /ha [ID]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)


-- ADVERTENCIAS

RegisterCommand('warn', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.advertencias) then
        local xTarget = Core.GetPlayerFromId(tonumber(args[1]))
        if args[1] and tonumber(args[1]) and args[2] then
            if xTarget then
                local reason = ""
                for i, theArg in pairs(args) do
                    if i ~= 1 then
                        reason = reason .. " " .. theArg
                    end
                end
                AdminSystem.addAdvertencia(_source, tonumber(args[1]), reason)
                sendtoDiscord('[WARN] **' ..
                    xAdmin.getName() .. '** ha añadido una nueva advertencia a ' ..
                    xTarget.getName() .. ' (' .. args[1] .. ').')
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /warn [ID] [REASON]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('unwarn', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.advertencias) then
        local xTarget = Core.GetPlayerFromId(tonumber(args[1]))
        if args[1] and tonumber(args[1]) and args[2] and tonumber(args[2]) then
            if xTarget then
                AdminSystem.quitarAdvertencia(_source, tonumber(args[1]), tonumber(args[2]))
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Jugador no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /unwarn [IDUSER] [IDADVERTENCIA]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('aduty', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.aduty) then
        AdminSystem.ServicioAdmin(_source, xAdmin.getGroup(), args[1])
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('aonline', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.aonline) then
        if (not args[1]) then
            AdminSystem.ListaAdmin(_source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /aonline")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('responder', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.id) then
        if args[1] and tonumber(args[1]) and args[2] then
            local xUser = Core.GetPlayerFromId(args[1])
            if xUser then
                local reason = ""
                for i, theArg in pairs(args) do
                    if i ~= 1 then
                        reason = reason .. " " .. theArg
                    end
                end
                TriggerClientEvent('chatMessage', args[1], '^3[RESPUESTA STAFF]^7 ' .. reason .. ' ^3(/mp ' ..
                    source .. ')')
                TriggerClientEvent('chatMessage', _source, '^3[RESPUESTA A ' .. args[1] .. ']^7 ' .. reason)
                sendtoDiscord('[RESPONDER] **' ..
                    xAdmin.getName() .. '** ha respondido a ' .. xUser.getName() .. ' (' ..
                    args[1] .. '). Mensaje: ' .. reason)
            else
                TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 usuario no encontrado.")
            end
        else
            TriggerClientEvent('chatMessage', _source, "USO: /responder [ID] [RESPUESTA]")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('mp', function(source, args, RawCommand)
    local _source = source
    local xPlayer = Core.GetPlayerFromId(_source)
    if args[1] and tonumber(args[1]) and args[2] then
        local xUser = Core.GetPlayerFromId(args[1])
        if xUser then
            local reason = ""
            for i, theArg in pairs(args) do
                if i ~= 1 then
                    reason = reason .. " " .. theArg
                end
            end
            TriggerClientEvent('chat:addMessage', args[1], {
                template = '<div style="text-decoration: underline #3ab3cf;"><b>{0}</b></div>',
                args = { '^35[MP de ID: ^35 ' .. _source .. ' (' .. xPlayer.name .. ')^35]^0 ' .. reason }
            })

            TriggerClientEvent('chat:addMessage', _source, {
                ttemplate = '<div style="text-decoration: underline #3ab3cf;"><b>{0}</b></div>',
                args = { '^35[MP enviado a ID: ^35 ' .. args[1] .. '^35]^0 ' .. reason }
            })
        else
            TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 usuario no encontrado.")
        end
    else
        TriggerClientEvent('chatMessage', _source, "USO: /mp [ID] [MENSAJE]")
    end
end, false)

RegisterCommand('setgroup', function(source, args, RawCommand)
    local _source = source
    if _source == 0 or AdminSystem.inArray(Core.GetPlayerFromId(_source).getGroup(), Permisos.setgroup) then
        if args[1] and tonumber(args[1]) and args[2] and not args[3] then
            local xUser = Core.GetPlayerFromId(args[1])
            if xUser then
                if args[2] == 'admin' or args[2] == 'helper' or args[2] == 'superadmin' or args[2] == 'gamemaster' or
                    args[2] == 'mod' or args[2] == 'user' then
                    AdminSystem.setgroup(_source, args[1], args[2])
                    sendtoDiscord('[SETGROUP] **' ..
                        (_source == 0 and 'Console' or Core.GetPlayerFromId(_source).getName()) ..
                        '** ha establecido permisos de ' .. args[1] .. ' a ' .. xUser.getName() .. ' (' .. args[1] ..
                        ').')
                else
                    if _source == 0 then
                        print("^8ERROR:^0 ese rango no existe.")
                        return
                    end
                    TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 ese rango no existe.")
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('setpermission', function(source, args, RawCommand)
    local _source = source
    if _source == 0 or AdminSystem.inArray(Core.GetPlayerFromId(_source).getGroup(), Permisos.setpermissions) then
        if args[1] and tonumber(args[1]) and args[2] and tonumber(args[2]) and not args[3] then
            local xUser = Core.GetPlayerFromId(args[1])
            if xUser then
                AdminSystem.setpermission(_source, tonumber(args[1]), tonumber(args[2]))
                sendtoDiscord('[SETPERMISSION] **' ..
                    (_source == 0 and 'Console' or Core.GetPlayerFromId(_source).getName()) ..
                    '** ha establecido permisos de ' .. args[1] .. ' a ' .. xUser.getName() .. ' (' .. args[1] .. ').')
            end
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('jtag', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        if not args[1] then
            TriggerClientEvent('gd:tagsjugadores', _source)
        else
            TriggerClientEvent('chatMessage', _source, "USO: /jtag")
        end
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)


RegisterCommand('settagdistance', function(source, args, RawCommand)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        local distance = 100
        if args[1] and tonumber(args[1]) then distance = tonumber(args[1]) end
        TriggerClientEvent('gd:jtagdistance', _source, distance)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)



local cancelarBorrado = false
local borrado = false


function borradoCoches(minuto)
    TriggerClientEvent('chat:addMessage', -1, {
        template =
        '<div style="padding: 0.1vw; margin: 0.2vw; font-weight: 100; border-radius: 0.2vw; width: max-content; text-shadow: 1.2px 1.2px #000; background-color: rgba(255, 204, 0, 0.5); border: solid 1.5px #ffaa00;"><b>{0}</b>{1}<span style="text-shadow: 0.0px 0.0px #000; color:black;">{2}</span></div>',
        -- template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: #ffaa00; border-radius: 4px;"><b>{0}</b>{1}<span style="color:black;">{2}</span></div>',
        args = { "[BORRADO COCHES] | ", '^0Borrado de coches en  ', minuto .. '  minutos^0.' }
    })
end

RegisterCommand('borrarv', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        local _input = tonumber(args[1])
        sendtoDiscordBorrarV('[BORRARV] **' ..
            xAdmin.getName() .. '** ha ejecutado el comando /borrarv con el tiempo de ' ..
            _input .. ' minutos.')
        if not _input or _input ~= 0 and _input > 0 then
            if not borrado then borrado = true else return end
            local minutosBorrado = _input or 2
            local time = (minutosBorrado * 60)
            borradoCoches(tonumber(minutosBorrado))

            while time > 0 do
                time = time - 1
                Wait(1000)
                if cancelarBorrado then
                    cancelarBorrado = false
                    borrado = false
                    print("^Borrarv cancelado.")
                    TriggerClientEvent('chat:addMessage', -1, {
                        template =
                        '<div style="padding: 0.1vw; margin: 0.2vw; font-weight: 100; border-radius: 0.2vw; width: max-content; text-shadow: 1.2px 1.2px #000; background-color: rgba(204, 163, 0, 0.8); border: solid 1.5px #ffaa00;"><b>{0}</b><span style="text-shadow: 0.0px 0.0px #000; color:black;">{1}</span></div>',
                        args = { "[BORRADO COCHES] | ", '^0El borrado de coches ha sido cancelado!' }
                    })

                    cancelarBorrado = false
                    borrado = false
                    return
                end

                if (
                    time == (30 * 60) or time == (20 * 60) or time == (15 * 60) or time == (10 * 60) or time == (5 * 60)
                    or time == (2 * 60) or time == (1 * 60)) and time ~= (minutosBorrado * 60) then
                    local lacuenta = math.floor(tonumber(time / 60))
                    borradoCoches(lacuenta)
                end
            end
        end
        TriggerClientEvent("gd_admin:borrarcoches", -1)
        borrado = false
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)


RegisterCommand('cancelborrarv', function(source, args, showError)
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        cancelarBorrado = true
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end)

RegisterCommand('borrarvarea', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        local radio = args[1] or nil;
        TriggerClientEvent('gd_admin:borrarcochesarea', -1, GetEntityCoords(GetPlayerPed(_source)), radio)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('borraro', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        TriggerClientEvent('gd_admin:borrarentity', -1)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('borraroarea', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        local radio = args[1] or nil;
        TriggerClientEvent('gd_admin:borrarentityarea', -1, GetEntityCoords(GetPlayerPed(_source)), radio)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('borrarp', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        TriggerClientEvent('gd_admin:borrarpeds', -1)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)

RegisterCommand('borrarparea', function(source, args, RawCommand) -- CLIENTE
    local _source = source
    local xAdmin = Core.GetPlayerFromId(_source)
    if AdminSystem.inArray(xAdmin.getGroup(), Permisos.jtag) then
        local radio = args[1] or nil;
        TriggerClientEvent('gd_admin:borrarpedsarea', -1, GetEntityCoords(GetPlayerPed(_source)), radio)
    else
        TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 Sin permisos suficientes.")
    end
end, false)
