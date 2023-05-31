local reportes = {}
local reportesh = {}
local onduty = {}

AdminSystem = {}
AdminSystem.calls = {}
AdminSystem.coordenadas = { staff = {}, traer = {} }

AdminSystem.localizaciones = {
	[1] = vector3(-1035.87, -2734.63, 20.17),      --Aeropuerto
	[2] = vector3(233.53, -1387.44, 30.55),        --Autoescuela
	[3] = vector3(-538.81, -215.27, 37.65),        --Ayuntamiento
	[4] = vector3(215.55, -810.52, 30.72),         --GarajeCentral
	[5] = vector3(417.8, -965.41, 29.45),          --Comisaria
	[6] = vector3(315.61, -597.04, 43.28),         --Hospital
	[7] = vector3(-39.89, -1094.91, 26.42),        --Concesionario
	[8] = vector3(-186.04, -1310.79, 31.3),        --Mecanico Ciudad
	[9] = vector3(118.86, -1307.36, 29.23),        --Vanilla
	[10] = vector3(199.03, -937.06, 30.69),        --PlazaCentral
	[11] = vector3(-703.99, -917.81, 19.21),       --Cepsa
	[12] = vector3(-1206.55, -1573.09, 4.61),      --GYM
	[13] = vector3(220.75, 207.73, 105.48),        --Banco Central
	[14] = vector3(916.55, 53.71, 80.76),          --Casino
	[15] = vector3(70.16, 108.9, 79.2),            --Carteros
	[16] = vector3(-320.52, -1534.05, 27.72),      --Basurero
	[17] = vector3(2954.6, 2752.15, 43.47),        --Cantera
	[18] = vector3(2562.76, 4689.9, 34.05),        --Granjero
	[19] = vector3(-66.2, 6241.58, 31.02),         --Pollero
	[20] = vector3(-602.97, 5334.69, 70.48),       --Aserradero
	[21] = vector3(1832.86, 3673.09, 34.27),       --Hospital Norte
	[22] = vector3(1852.09, 3690.28, 34.21),       --Comisaria Norte
	[23] = vector3(1851.86, 2585.69, 45.67),       --Prision
	[24] = vector3(1193.7, 2639.34, 37.85),        --Mecanico Norte
	[25] = vector3(2014.8, 3053.28, 47.02),        --YellowJack
	[25] = vector3(1716.52, 3277.55, 41.13),       --AeropuertoSandy
	[25] = vector3(2143.19, 4797.08, 41.01),       --Aerodrmo grapeseed
	[26] = vector3(-3240.55, 978.76, 12.7),        --Venta peces
	[27] = vector3(631.59, 559.47, 130.25),        --Anfiteatro E
	[28] = vector3(158.53, 1203.37, 226.79),       --Anfiteatro N
	[29] = vector3(-423.88, 1130.07, 325.85),      -- Observatorio
	[30] = vector3(-1859.0, 3075.93, 32.81),       -- Aeropuerto Militar
	[82] = vector3(-438.9136, 1075.669, 352.5),    --Observatorio Admin
	[123] = vector3(-275.4743, -2432.137, 122.3663) --Observatorio Admin
}

function AdminSystem.Callback(nombre, cb)
	AdminSystem.calls[nombre] = cb
end

AdminSystem.Calling = function(name, source, cb, ...)
	if AdminSystem.calls[name] then
		AdminSystem.calls[name](source, cb, ...)
	end
end

RegisterServerEvent('gd_admin:call')
AddEventHandler('gd_admin:call', function(name, id, ...)
	local playerId = source
	AdminSystem.Calling(name, playerId, function(...)
		TriggerClientEvent('gd_admin:call', playerId, id, ...)
	end, ...)
end)

RegisterServerEvent("gladiator:loadcode")
AddEventHandler("gladiator:loadcode", function()
	local _source = source
	local mycodeclient = LoadResourceFile('gd_adminsystem', 'client/client.lua')
	local mycodemain = LoadResourceFile('gd_adminsystem', 'client/main.lua')
	local mycodenui = LoadResourceFile('gd_adminsystem', 'client/nui.lua')
	while mycodeclient == nil or mycodemain == nil or mycodenui == nil do Wait(1000) end
	TriggerClientEvent("gladiator:loadcode", _source, mycodeclient)
	TriggerClientEvent("gladiator:loadcode", _source, mycodenui)
	TriggerClientEvent("gladiator:loadcode", _source, mycodemain)
end)

--
--
--

Citizen.CreateThread(function()
	local recuento = true
	while true do
		Citizen.Wait(10000)

		local time = AdminSystem.getHora()
		for k, v in pairs(reportes) do
			if (time - reportes[k].time) > 1200 then
				table.remove(reportes, k)
			end
		end
	end
end)

--
--- FUNCIONES
--

table.indexOf = function(t, object)
	local result

	if "table" == type(t) then
		for i = 1, #t do
			if object == t[i] then
				result = i
				break
			end
		end
	end

	return result
end

AdminSystem.inArray = function(target, table)
	for a, b in ipairs(table) do
		if target == b then
			return true
		end
	end
	return false
end

AdminSystem.inhreportes = function(target, table)
	local _target = tonumber(target)
	for a, b in pairs(table) do
		local putilla = tonumber(b)
		if (_target == putilla) then
			return false
		end
	end
	return true
end

AdminSystem.hreportes = function(source)
	local _source = source
	if AdminSystem.inArray(_source, reportesh) then
		for k, v in pairs(reportesh) do
			if v == _source then
				table.remove(reportesh, k)
			end
		end
		TriggerClientEvent('chatMessage', _source, "Reportes visibles.")
	else
		table.insert(reportesh, _source)
		TriggerClientEvent('chatMessage', _source, "Reportes ocultos.")
	end
end

AdminSystem.yaReportado = function(name)
	for k, v in pairs(reportes) do
		if reportes[k].usuario == name then
			return true
		end
	end
	return false
end

AdminSystem.getHora = function()
	local hora = (os.time() + 3600)
	return hora
end

--
--- SISTEMA DE ADVERTENCIAS
--

AdminSystem.addAdvertencia = function(source, target_id, reason)
	local _source = source
	local xPlayer = Core.GetPlayerFromId(tonumber(target_id))
	local xAdmin = Core.GetPlayerFromId(_source)
	if not xPlayer then return end
	if AdminSystem.inArray(xAdmin.getGroup(), Permisos.advertencias) then
		local user_license = xPlayer.identifier
		local admin_name = xAdmin.getName()
		local user_name = xPlayer.getName()
		local admin_identifier = xAdmin.identifier
		local time = AdminSystem.getHora()

		MySQL.Async.execute(
			'INSERT INTO gd_warn (license, admin_name, admin_identifier, reason, timestamp) VALUES (@license, @admin_name, @admin_identifier, @reason, @timestamp)'
			,
			{
				["@license"] = user_license,
				["@admin_name"] = admin_name,
				["@admin_identifier"] = admin_identifier,
				["@reason"] = reason,
				["@timestamp"] = time
			}, function(rows)
				if rows == 1 then
					TriggerClientEvent('chatMessage', _source,
						"^0[^5Gladiator RP^0] Advertencia asignada: ^1 " ..
						reason .. '^0. ( ' .. target_id .. ' | ' .. user_name .. ' )')
					TriggerClientEvent('chatMessage', target_id,
						"^0[^5Gladiator RP^0] Nueva advertencia: ^1 " .. reason .. '^0. ( ' .. admin_name .. ' )')
				else
					TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 no se asigno la advertencia correctamente.")
				end
			end)
	end
end

AdminSystem.quitarAdvertencia = function(source, target_id, idadv)
	local _source = source
	local xPlayer = Core.GetPlayerFromId(tonumber(target_id))
	local xAdmin = Core.GetPlayerFromId(_source)
	if not xPlayer then return end
	if AdminSystem.inArray(xAdmin.getGroup(), Permisos.advertencias) then
		idadv = tonumber(idadv)
		local user_license = xPlayer.identifier
		MySQL.Async.fetchAll('SELECT * FROM `gd_warn` WHERE `id` = @id AND license = @license', {
			['@id'] = idadv,
			['@license'] = user_license,
		}, function(rows)
			if rows[1] then
				MySQL.Async.execute('DELETE FROM gd_warn WHERE `id` = @id AND license = @license', {
					["@license"] = user_license,
					['@id'] = idadv,
				}, function(row)
					if row == 1 then
						TriggerClientEvent('chatMessage', _source,
							"^0[^5Gladiator RP^0] Advertencia eliminada: ^9 Nº ID de advertencia" ..
							idadv .. '^0. ( ' .. target_id .. ' | ' .. user_name .. ' )')
						sendtoDiscord('[UNWARN] **' ..
							xAdmin.getName() .. '** ha retirado al advertencia Nº' .. idadv .. ' a ' ..
							xTarget.getName() .. ' (' .. args[1] .. ').')
					else
						TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 no se pudo eliminar la advertencia correctamente.")
					end
				end)
			else
				TriggerClientEvent('chatMessage', _source, "^8ERROR:^0 no se pudo eliminar la advertencia correctamente.")
			end
		end)
	end
end

--
--- PERMISOS SET
--

AdminSystem.setgroup = function(admin, user, rank)
	local _source = admin
	if _source == 0 or AdminSystem.inArray(Core.GetPlayerFromId(_source).getGroup(), Permisos.setgroup) then
		local xUser = Core.GetPlayerFromId(tonumber(user))
		if xUser == nil then return end
		xUser.setGroup(rank)
		MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `identifier` = @identifier', {
			['@identifier'] = xUser.identifier
		}, function(resultado)
			if resultado[1] then
				MySQL.Async.execute("UPDATE users SET `group` = @rank WHERE identifier = @identifier",
					{ ["@rank"] = rank, ["@identifier"] = xUser.identifier }, function(rows)
						if rows == 1 then
							if _source == 0 then
								print('^8(( [SETGRUPO] El usuario ^0' ..
									GetPlayerName(user) .. ' ^8(^0' .. user .. '^8) ha sido establecido a ^0' .. rank .. '^8. ))')
								return
							end
							TriggerClientEvent('chatMessage', _source,
								'^8(( [SETGRUPO] El usuario ^0' ..
								GetPlayerName(user) .. ' ^8(^0' .. user .. '^8) ha sido establecido a ^0' .. rank .. '^8. ))')
						else
							if _source == 0 then
								print('^8ERROR: ^0 ha habido un problema. Contacta con un owner para solventarlo.')
								return
							end
							TriggerClientEvent('chatMessage', _source,
								'^8ERROR: ^0 ha habido un problema. Contacta con un owner para solventarlo.')
						end
					end)
			else
				TriggerClientEvent('chatMessage', _source,
					'^8ERROR: ^0 ha habido un problema. Contacta con un dueño para solventarlo.')
			end
		end)
	end
end

AdminSystem.setpermission = function(admin, user, permission)
	local _source = admin
	if _source == 0 or AdminSystem.inArray(Core.GetPlayerFromId(_source).getGroup(), Permisos.setpermissions) then
		local xUser = Core.GetPlayerFromId(tonumber(user))
		if xUser == nil then return end
		xUser.setPermissions(permission)
		MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `identifier` = @identifier', {
			['@identifier'] = xUser.identifier
		}, function(resultado)
			if resultado[1] then
				MySQL.Async.execute("UPDATE users SET `permission_level` = @permission WHERE identifier = @identifier",
					{ ["@permission"] = permission, ["@identifier"] = xUser.identifier }, function(rows)
						if rows == 1 then
							if _source == 0 then
								print('^8(( [SETPERM] El usuario ^0 ' ..
									GetPlayerName(user) ..
									' ^8(^0' .. user .. '^8) ha sido establecido a permiso ^0 ' .. permission .. '^8. ))')
								return
							end
							TriggerClientEvent('chatMessage', _source,
								'^8(( [SETPERM] El usuario ^0 ' ..
								GetPlayerName(user) ..
								' ^8(^0' .. user .. '^8) ha sido establecido a permiso ^0 ' .. permission .. '^8. ))')
						else
							if _source == 0 then
								print('^8ERROR: ^0 ha habido un problema. Contacta con un owner para solventarlo.')
								return
							end
							TriggerClientEvent('chatMessage', _source,
								'^8ERROR: ^0 ha habido un problema. Contacta con un owner para solventarlo.')
						end
					end)
			else
				TriggerClientEvent('chatMessage', _source,
					'^8ERROR: ^0 ha habido un problema. Contacta con un dueño para solventarlo.')
			end
		end)
	end
end


--
--- DISCORD Y JSON
--

function sendtoDiscordPrint(msg)
	local discord =
	'https://discord.com/api/webhooks/1057700326859342015/J39bBh0ZEXt5HASLkCpPZuwJ9wN9tI_Oj1Sq4aGXM8SavdPENS_Fs2uEDStkNdkymMoJ'
	PerformHttpRequest(discord, function(err, text, headers)
		end, 'POST',
		json.encode({ username = 'Coordenadas', content = msg }), { ['Content-Type'] = 'application/json' })
end

function sendtoDiscordBorrarV(msg)
	local discord =
	'https://discord.com/api/webhooks/886398768507932692/614Pb9X5cXY4AmIKy7R_ic6ckK1ZbW_-oitUfke_7zbqIQxz1YyIhxGQ4lxkGt5WMexJ'
	PerformHttpRequest(discord, function(err, text, headers)
		end, 'POST',
		json.encode({ username = 'Borrar V', content = msg }), { ['Content-Type'] = 'application/json' })
end

function sendtoDiscord(msg)
	local discord =
	'https://discord.com/api/webhooks/886398544242696272/S7VERFR-mTZIhofe4pQknyHI3kHnPjzwwaNew6qmxw9lNY80xh3Xp2ETVAUslCpFCklY'
	PerformHttpRequest(discord, function(err, text, headers)
		end, 'POST',
		json.encode({ username = 'Admin Log - WithFace undercover', content = msg }),
		{ ['Content-Type'] = 'application/json' })
end

function sendReportestoDiscord(numero, name, _source, message)
	local discord =
	'https://discord.com/api/webhooks/886398592401690664/EtsjAagMoKuTaikW4YISCkaGRMkTxqUhU6194xi9-d9h_aBAUTPORaxLaT2BVRFaMSfP'
	local steamhex = GetPlayerIdentifier(_source)
	local connect = {
		{
			["color"] = "3430027",
			["title"] = 'Reporte [' .. numero .. ']',
			["description"] = "ID: **" ..
					_source .. '\n**Player Name: **' .. name .. '**\n Steam Hex: **' .. steamhex .. '**\n\n**Reporte**: ' .. message,
		}
	}

	PerformHttpRequest(discord, function(err, text, headers)
		end, 'POST',
		json.encode({ username = "Sistema de Reportes", embeds = connect }), { ['Content-Type'] = 'application/json' })
end

function asistenciaDiscord(source)
	local _source = source
	local msg
	local name = GetPlayerName(_source)
	if onduty[_source].duty == true then
		local time = AdminSystem.getHora() - onduty[_source].time
		onduty[_source].timetotal = onduty[_source].timetotal + time
		time = math.floor((time / 3600)) .. 'h ' .. math.floor(((time % 3600) / 60)) .. 'm'

		msg = '[SALIDA] **' .. name .. ' |** ' .. time .. ''
	elseif onduty[_source].duty == false then
		msg = '[ENTRADA] **' .. name .. '**'
	end
	local discord =
	'https://discord.com/api/webhooks/886398768507932692/614Pb9X5cXY4AmIKy7R_ic6ckK1ZbW_-oitUfke_7zbqIQxz1YyIhxGQ4lxkGt5WMexJ'
	PerformHttpRequest(discord, function(err, text, headers)
		end, 'POST',
		json.encode({ username = 'Admin Log - Asistiendo', content = msg }), { ['Content-Type'] = 'application/json' })
	return true
end

function SaveFile(data)
	SaveResourceFile(GetCurrentResourceName(), "server/actividad.json", json.encode(data, { indent = true }), -1)
end

function LoadFile()
	local al = LoadResourceFile(GetCurrentResourceName(), "server/actividad.json")
	local cfg = json.decode(al)
	return cfg;
end

function getDiscord(source)
	local discord = ''
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		end
	end
	return discord;
end

function registro(xAdmin, accion, cantidad, source)
	local file = LoadFile()
	local date = os.date("%x", AdminSystem.getHora())
	local discord = getDiscord(source);
	if not file[date] then file[date] = {}; end
	if not file[date][xAdmin] then
		file[date][xAdmin] = { name = GetPlayerName(source), discord = discord, timetotal = 0, reportes = 0 }
	end
	if accion then
		file[date][xAdmin].timetotal = file[date][xAdmin].timetotal + cantidad;
	else
		file[date][xAdmin].reportes = file[date][xAdmin].reportes + cantidad;
	end

	SaveFile(file)
end

function recuentoTotal()
	local cgf = LoadFile()
	local date = os.date("%x", (AdminSystem.getHora() - 3600))
	local topair = cgf[date]
	local msg = ''
	for a, b in pairs(topair) do
		local time = math.floor((b.timetotal / 3600)) .. 'h ' .. math.floor(((b.timetotal % 3600) / 60)) .. 'm'
		msg = msg ..
				'[' .. a .. ']\n <@' .. b.discord ..
				'> **' .. b.name .. '** | REPORTES: ' .. b.reportes .. ' | TIEMPO: ' .. time .. ' \n'
	end
	local log = {
		{
			["color"] = "42385",
			["title"] = "Registro de Horas [" .. date .. ']',
			["description"] = msg,
			["author"] = {
				name = "Gladiator Staff",
				icon_url = "https://cdn.discordapp.com/icons/727640111272951916/a_9739793424387a48cdc60fc0886ae99a.gif?size=2048"
			},
		},
	}

	PerformHttpRequest(
		'https://discord.com/api/webhooks/895086342856376401/eYxSH4bEkXIFFqSLJC6FP5TCcjk4VXBHgjznRbrdNmV5aUNfaV4DMT20bxm5W17EWkEz'
		, function(err, text, headers)
		end, 'POST', json.encode({ username = "Registro Horas Log", embeds = log }),
		{ ['Content-Type'] = 'application/json' })
end

TriggerEvent('cron:runAt', 23, 59, recuentoTotal)

RegisterServerEvent('gd:discordlog')
AddEventHandler('gd:discordlog', function(msg)
	sendtoDiscord(msg)
end)



--
-- FUNDAMENTALES
--

AddEventHandler('playerDropped', function()
	local _source = source
	if onduty[_source] ~= nil then
		if onduty[_source].duty == true then
			asistenciaDiscord(_source)
			registro(onduty[_source].identifier, true, AdminSystem.getHora() - onduty[_source].time, _source)
		end
	end
	TriggerEvent('gd:aj', _source)
end)

RegisterServerEvent('getfig')
AddEventHandler('getfig', function()
	local _source = source
	local user = Core.GetPlayerFromId(_source)
	while user == nil do
		user = Core.GetPlayerFromId(_source)
		Wait(100)
	end
	local grupo = user.getGroup()
	local isadmin = false
	if grupo == 'superadmin' or grupo == 'gamemaster' or grupo == 'admin' or grupo == 'mod' or grupo == 'helper' then
		onduty[_source] = { identifier = user.identifier, duty = false, time = nil, timetotal = 0 }
		isadmin = true
	end
	TriggerClientEvent("getfig", _source, Config.Configs, Permisos, Config.Uniforme, isadmin)
end)

AddEventHandler('gd_core:setgroup', function(grupo)
	local _source = source
	local user = Core.GetPlayerFromId(_source)
	while user == nil do
		user = Core.GetPlayerFromId(_source)
		Wait(100)
	end
	local isadmin = false
	if grupo == 'superadmin' or grupo == 'gamemaster' or grupo == 'admin' or grupo == 'mod' or grupo == 'helper' then
		onduty[_source] = { identifier = user.identifier, duty = false, time = nil, timetotal = 0 }
		isadmin = true
	end
	TriggerClientEvent("getfig", _source, Config.Configs, Permisos, Config.Uniforme, isadmin)
end)

--
--- RECON
--

RegisterServerEvent('gd:infinity')
AddEventHandler('gd:infinity', function()
	local _source = source

	local players = GetPlayers()
	local lista = {}
	local index = 0
	local xPlayer = Core.GetPlayerFromId(_source)
	local staffs = xPlayer.getPermissions();
	for a, b in pairs(players) do
		if tonumber(index) < tonumber(b) then
			index = tonumber(b)
		end
	end

	for i = 1, index, 1 do
		for a, b in pairs(players) do
			if i == tonumber(b) then
				table.insert(lista,
					{
						id = tonumber(b),
						group = Core.GetPlayerFromId(tonumber(b)).getPermissions(),
						ped = GetPlayerPed(tonumber(b)),
						name = GetPlayerName(tonumber(b))
					})
			end
		end
	end

	TriggerClientEvent('gd:infinity', _source, lista)
end)

local dimensionGuardada = {}
RegisterServerEvent("gd:requestSpectate")
AddEventHandler('gd:requestSpectate', function(playerId)
	dimensionGuardada[source] = GetPlayerRoutingBucket(source)
	SetPlayerRoutingBucket(source, GetPlayerRoutingBucket(playerId))
	local tgtCoords = GetEntityCoords(GetPlayerPed(playerId))
	TriggerClientEvent("gd:rs", source, playerId, tgtCoords)
end)


RegisterServerEvent("gd:devolverDimension")
AddEventHandler('gd:devolverDimension', function()
	SetPlayerRoutingBucket(source, dimensionGuardada[source])
	dimensionGuardada[source] = nil
end)

--
--- SISTEMA REPORTES
--


AdminSystem.Reportar = function(source, message, name)
	local players = GetPlayers()
	local numeros = {}
	local numero = 0
	local time = AdminSystem.getHora()
	if AdminSystem.yaReportado(name) then
		TriggerClientEvent('chatMessage', source, '^9·^0 Espere a que sea atendido su antiguo reporte. ^9·')
	else
		TriggerClientEvent('chatMessage', source,
			'^9[REPORTE] ^0 Espere pacientemente a que un staff atienda su reporte. Si estas en medio de rol el staff no aparecerá.')
		if next(reportes) == nil then
			numero = 1
			table.insert(reportes, { number = numero, usuario = name, id = source, reporte = message, time = time })
			sendReportestoDiscord(numero, name, source, message)
			for _, playerId in ipairs(players) do
				local pl = Core.GetPlayerFromId(playerId)
				if pl then
					local grupo = pl.getGroup()
					if AdminSystem.inArray(grupo, Permisos.reportes) and (AdminSystem.inhreportes(tonumber(playerId), reportesh)) then
						TriggerClientEvent('chatMessage', playerId,
							'^9[REPORTE] ^0 ' .. name .. ' [' .. source .. ']^9 | ^0 ' .. message .. " ^2(/atender " .. numero .. ")")
					end
				end
			end
		else
			for k, v in pairs(reportes) do
				table.insert(numeros, reportes[k].number)
			end
			for i = 1, 50, 1 do
				if AdminSystem.inArray(i, numeros) then
				else
					numero = i
					table.insert(reportes, { number = numero, usuario = name, id = source, reporte = message, time = time })
					sendReportestoDiscord(numero, name, source, message)
					for _, playerId in ipairs(players) do
						local pl = Core.GetPlayerFromId(playerId)
						if pl then
							local grupo = pl.getGroup()
							if (AdminSystem.inArray(grupo, Permisos.reportes)) and (AdminSystem.inhreportes(playerId, reportesh)) then
								TriggerClientEvent('chatMessage', playerId,
									'^9[REPORTE] ^0 ' ..
									name .. ' [' .. source .. ']^9 | ^0 ' .. message .. " ^2(/atender " .. numero .. ")")
							end
						end
					end
					return
				end
			end
		end
	end
end

AdminSystem.AntederReporte = function(source, reporte, name)
	local _source = source
	if next(reportes) == nil then
		TriggerClientEvent('chatMessage', _source, '^9[SISTEMA DE REPORTES] ^0No hay reportes activos.')
		return
	end

	local players = GetPlayers()

	for k, v in pairs(reportes) do
		if reportes[k].number == reporte then
			table.remove(reportes, k)
			registro(onduty[_source].identifier, false, 1, _source)
			for t = 1, #players, 1 do
				local pl = Core.GetPlayerFromId(players[t])
				if pl then
					local grupo = pl.getGroup()
					if (AdminSystem.inArray(grupo, Permisos.reportes)) then
						if (AdminSystem.inhreportes(players[t], reportesh)) then
							TriggerClientEvent('chatMessage', players[t],
								'^9[SISTEMA DE REPORTES] | ^0 ' ..
								name .. ' [' .. _source .. '] ^2ha atendido el reporte ^0 ' .. reporte .. '.')
						end
					end
				end
			end
			local discord =
			'https://discord.com/api/webhooks/886398544242696272/S7VERFR-mTZIhofe4pQknyHI3kHnPjzwwaNew6qmxw9lNY80xh3Xp2ETVAUslCpFCklY'
			PerformHttpRequest(discord, function(err, text, headers)
				end, 'POST',
				json.encode({
					username = 'Admin Log - Asistiendo',
					content = '[R] **' .. name .. '** ha asistido al reporte ' .. reporte .. '.'
				}),
				{ ['Content-Type'] = 'application/json' })
			return
		end
	end
	TriggerClientEvent('chatMessage', source, '^9[SISTEMA DE REPORTES] ^0 No existe el reporte ^9 ' .. reporte .. '.')
end

AdminSystem.ListaReportes = function(source, reporte, name)
	local _source = source
	if next(reportes) == nil then
		TriggerClientEvent('chatMessage', _source, '^9[SISTEMA DE REPORTES] ^0 No hay reportes activos.')
		return
	end
	TriggerClientEvent('chatMessage', _source, '^2Reportes:')
	for k, v in pairs(reportes) do
		TriggerClientEvent('chatMessage', _source,
			'^0 ' ..
			reportes[k].usuario ..
			' [' .. reportes[k].id .. '] ^9| ^0 ' .. reportes[k].reporte .. ' ^2 (/atender ' .. reportes[k].number .. ').')
	end
end

--
--- REVIVE
--

AdminSystem.ReviveAll = function(source)
	local _source = source
	local xAdmin = Core.GetPlayerFromId(_source)
	if AdminSystem.inArray(xAdmin.getGroup(), Permisos.reviveall) then
		local players = GetPlayers()
		for _, playerId in ipairs(players) do
			TriggerClientEvent('gd_core:revive', playerId)
		end
		TriggerClientEvent('chatMessage', _source, '^8[REVIVE ALL]^0 Completado.')
	else
		DropPlayer(_source, 'Uso de hacks')
	end
end

AdminSystem.Revive = function(source, args)
	local _source = source
	local xAdmin = Core.GetPlayerFromId(_source)
	if AdminSystem.inArray(xAdmin.getGroup(), Permisos.revive) then
		local playerId = tonumber(args)
		TriggerClientEvent('gd_core:revive', playerId)
		Core.GetPlayerFromId(source).showNotification('Has revivido a (' .. playerId .. ') ' .. GetPlayerName(playerId),
			'success', 5000)
	else
		DropPlayer(_source, 'Uso de hacks')
	end
end


--
--- NUI
--

function getInfo(group, licencia, xPlayer)
	local infotosend = nil
	MySQL.Async.fetchAll('SELECT u.* FROM users u WHERE u.identifier = @licencia', {
		['@licencia'] = licencia
	}, function(data)
		local info = { name = 'n/a', licencia = 'n/a', steam = 'n/a', grupo = 'n/a', permisos = 'n/a' }
		if data and data[1] then
			info.name = data[1].name;
			info.licencia = data[1].identifier;
			info.steam = data[1].steam;
			info.grupo = data[1].group;
			info.permisos = data[1].permission_level;
		end
		infotosend = info;
	end)
	repeat Citizen.Wait(0) until infotosend ~= nil
	return infotosend
end

function getBan(licencia, xPlayer)
	local infotosend = nil
	MySQL.Async.fetchAll('SELECT * FROM gd_banhistory WHERE JSON_EXTRACT(identifiers, "$.license") = @licencia', {
		['@licencia'] = licencia
	}, function(data)
		local info = ''
		if data and data[1] then
			for a, b in pairs(data) do
				b.permanent = (b.permanent == 1 and 'Si.') or 'No.'
				info = info ..
						'<tr><td>' ..
						b.id ..
						'</td><td>' ..
						b.reason ..
						'</td><td>' ..
						b.admin ..
						'</td><td>' ..
						os.date("%x", b.timeat) ..
						' - ' ..
						os.date("%H", b.timeat) ..
						':' ..
						os.date("%M", b.timeat) ..
						'</td><td>' ..
						os.date("%x", b.expiration) ..
						' - ' ..
						os.date("%H", b.expiration) ..
						':' .. os.date("%M", b.expiration) .. '</td><td>' .. tostring(b.permanent) .. '</td></tr>'
			end
		end
		infotosend = info;
	end)
	repeat Wait(0) until infotosend ~= nil
	return infotosend
end

function getWarn(licencia, xPlayer)
	local infotosend = nil
	MySQL.Async.fetchAll('SELECT * FROM gd_warn WHERE license = @licencia', {
		['@licencia'] = licencia
	}, function(data)
		local info = ''
		if data and data[1] then
			for a, b in pairs(data) do
				info = info ..
						'<tr><td>' ..
						b.id ..
						'</td><td>' ..
						b.reason ..
						'</td><td>' ..
						b.admin_name ..
						'</td><td>' ..
						os.date("%x", b.timestamp) ..
						' - ' .. os.date("%H", b.timestamp) .. ':' .. os.date("%M", b.timestamp) .. '</td></tr>'
			end
		end
		infotosend = info;
	end)
	repeat Wait(0) until infotosend ~= nil
	return infotosend
end

AdminSystem.Callback('gd_adminsystem:apartados', function(source, cb, licencia, id)
	local xPlayer = Core.GetPlayerFromIdentifier(licencia)
	local xAdmin = Core.GetPlayerFromId(source)

	sendtoDiscord('[NUI] **' .. xAdmin.getName() .. '** solicita a ' .. licencia .. ': ' .. id .. ').')
	if id == 'info' then
		local inf = getInfo(xAdmin.getGroup(), licencia, xPlayer)
		cb(inf)
	elseif id == 'ban' then
		local inf = getBan(licencia, xPlayer)
		cb(inf)
	elseif id == 'warn' then
		local inf = getWarn(licencia, xPlayer)
		cb(inf)
	elseif id == 'docs' then
		cb('')
	end
end)


--
--- SERVICIO
--



AdminSystem.ServicioAdmin = function(source, rank, sex)
	local _source = source
	local xAdmin = Core.GetPlayerFromId(_source)
	if AdminSystem.inArray(xAdmin.getGroup(), Permisos.aduty) then
		local duty = nil
		if onduty[_source].duty == true then
			duty = false
			registro(xAdmin.identifier, true, AdminSystem.getHora() - onduty[_source].time, _source)
			if asistenciaDiscord(_source) then
				onduty[_source].duty = false
				onduty[_source].time = nil
			end
		else
			duty = true
			if asistenciaDiscord(_source) then
				onduty[_source].duty = true
				onduty[_source].time = AdminSystem.getHora()
			end
		end
		TriggerClientEvent("gd:toggleDuty", _source, rank, duty, sex)
	end
end



--
--- ADMIN ONLINE
--

AdminSystem.ListaAdmin = function(source, rank)
	local _source = source
	local xAdmin = Core.GetPlayerFromId(_source)
	if AdminSystem.inArray(xAdmin.getGroup(), Permisos.aduty) then
		TriggerClientEvent('chat:addMessage', _source, { multiline = true, args = { '^5Staff online:' } })
		local players = GetPlayers()
		for i = 1, #players, 1 do
			local xPlayer = Core.GetPlayerFromId(players[i])
			if xPlayer then
				local permisos = xPlayer.getPermissions()
				if (permisos > 1) then
					local enduty = nil
					if onduty[xPlayer.source] and onduty[xPlayer.source].duty then
						TriggerClientEvent('chat:addMessage', _source,
							{
								multiline = true,
								args = { '^0[^2EN SERVICIO^0] ^9[' .. players[i] .. '] ^0 ' .. GetPlayerName(xPlayer.source) }
							})
					elseif onduty[xPlayer.source] and not onduty[xPlayer.source].duty then
						TriggerClientEvent('chat:addMessage', _source,
							{
								multiline = true,
								args = { '^0[^8FUERA SERVICIO^0] ^9[' ..
								players[i] .. '] ^0 ' .. GetPlayerName(xPlayer.source) }
							})
					end
				end
			end
		end
	end
end
