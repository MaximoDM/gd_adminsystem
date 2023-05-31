local drawInfo, coordenadasplayer, youareadmin = false, nil, false
local cam, empezar = nil, false
noclip = false
local draw, drawdistance = false, 100
local visiblePlayers = {}
local onMenuCd = true
local players = nil

local assert = assert
local MenuV = assert(MenuV)

local position = GetResourceKvpString('position') or 'topcenter'
local menu = MenuV:CreateMenu(false, '¿Te apetece reconear un rato?', position, 153, 51, 255, 'size-125',
	'templatevergas', 'menuv', 'reconeando')

function missionTextDisplay(text, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(text)
	DrawSubtitleTimed(time, 1)
end

RegisterNetEvent('getfig')
AddEventHandler('getfig', function(configs, permiso, uniformes, isadmin)
	Config = configs
	Permisos = permiso
	Config.Uniforme = uniformes
	if isadmin == true then youareadmin = true; end
	if youareadmin then onMenuCd = true end
end)
menu:OpenWith('keyboard', 'F5', onMenuCd)

RegisterNetEvent('gd_core:playerLoaded')
AddEventHandler('gd_core:playerLoaded', function()
	if not first then
		TriggerServerEvent("gd:verificarJ")
		TriggerServerEvent("getfig")
		while Config == nil do
			TriggerServerEvent("getfig")
			Wait(5000)
		end
		first = true
	end
end)

RegisterCommand("cargarconfig", function(source)
	TriggerServerEvent("getfig")
	while Config == nil do
		TriggerServerEvent("getfig")
		Wait(5000)
	end
end)


RegisterNetEvent('gd:infinity')
AddEventHandler('gd:infinity', function(lista)
	players = lista
end)


function drawTimeText(total, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")

	local text = string.format('Te quedan ' .. tonumber(total) .. ' segundos para cumplir tu condena.')

	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

--
--- RECON
--

function timer(s)
	local isOnLoop = true
	CreateThread(function()
		while isOnLoop do
			Wait(0)
			if onMenuCd then
				onMenuCd = false
				Wait(s)
				onMenuCd = true
				isOnLoop = false
			end
		end
	end)
end

menu:On('open', function(m)
	m:ClearItems()
	if onMenuCd or youareadmin then
		players = nil
		TriggerServerEvent('gd:infinity')
		while players == nil do
			Wait(10)
		end

		local total = 0
		for _, k in ipairs(players) do
			total = _
		end
		print(total)
		local menu_button = menu:AddButton({
			icon = '✅',
			label = 'Jugadores Online: ' .. total,
		})

		Wait(10)


		for _, k in ipairs(players) do
			if (k.group == 10) then
				local button = m:AddButton({
					icon = k.id,
					label = "" .. k.name .. " [STAFF]",
					value = k,
				})
			end
		end

		Wait(10)

		if youareadmin then
			for _, k in ipairs(players) do
				if not (k.group == 10) then
					print(k.id)
					local button = m:AddButton({
						icon = k.id,
						label = k.name,
						value = k,
						select = function(i)
							TriggerServerEvent('gd:requestSpectate', k.id)
						end
					})
				end
			end
		else
			for _, k in ipairs(players) do
				if not (k.group == 10) then
					local button = m:AddButton({
						icon = k.id,
						label = k.name,
						value = k,
					})
				end
			end
		end



		Wait(10)
		local slider = menu:AddSlider({
			icon = '❤️',
			label = 'Posición',
			value = 'demo',
			values = {
				{ label = 'Arriba - Izquierda', value = 'topleft' },
				{ label = 'Arriba - Centro',    value = 'topcenter' },
				{ label = 'Arriba - Derecha',   value = 'topright' },
				{ label = 'Centro - Izquierda', value = 'centerleft' },
				{ label = 'Centro - Centro',    value = 'center' },
				{ label = 'Centro - Derecha',   value = 'centerright' },
				{ label = 'Abajo - Izquierda',  value = 'bottomleft' },
				{ label = 'Abajo - Centro',     value = 'bottomcenter' },
				{ label = 'Abajo - Derecha',    value = 'bottomright' }
			}
		})

		slider:On('select', function(item, value)
			menu.Position = value
			SetResourceKvp('position', value)
		end)
		timer(3000)
	else
		Core.ShowNotification("No puedes spammear este comando", "error", 3000)
	end
end)

function spectatePlayer(targetPed, name, id)
	local playerPed = PlayerPedId()
	enable = true

	if targetPed == playerPed then enable = false end

	if (enable) then
		NetworkSetInSpectatorMode(true, targetPed)
		SetEntityInvincible(playerPed, true)
		SetEntityVisible(playerPed, false, 0)
		SetEveryoneIgnorePlayer(playerPed, true)
		SetEntityCollision(playerPed, false, false)
		DrawPlayerInfo(targetPed)
		TriggerEvent('chatMessage', 'Reconeando a ' .. name .. ' [' .. id .. ']')
		TriggerServerEvent('gd:discordlog',
			'[RECON] **' .. GetPlayerName(PlayerId()) .. '** esta reconeando a ' .. name .. ' (' .. id .. ').')
	else
		StopDrawPlayerInfo();

		NetworkSetInSpectatorMode(false, targetPed);
		SetEntityInvincible(playerPed, false);
		SetEntityVisible(playerPed, true, 0);
		SetEveryoneIgnorePlayer(playerPed, false);
		SetEntityCollision(playerPed, true, true);

		if coordenadasplayer then
			SetEntityCoords(playerPed, coordenadasplayer.x, coordenadasplayer.y, coordenadasplayer.z, 0, 0, 0, false)
			coordenadasplayer = nil;
		end
	end
end

function DrawPlayerInfo(targetPed)
	local drawTarget = targetPed
	drawInfo = true

	CreateThread(function()
		while drawInfo do
			Wait(0)
			local text = {}
			local targetPed = drawTarget
			local targetGod = GetPlayerInvincible(drawTarget)

			if targetGod then
				table.insert(text, 'Inmortalidad: ~r~Detectado~w~')
			else
				table.insert(text, 'Inmortalidad: ~r~No detectado~w~')
			end

			if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and
					(GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and
					not IsPedInParachuteFreeFall(targetPed) then
				table.insert(text, '~r~Anti-Ragdoll~w~')
			end

			table.insert(text, 'Vida' .. ": " .. GetEntityHealth(targetPed) .. "/" .. GetEntityMaxHealth(targetPed))
			table.insert(text, 'Escudo' .. ": " .. GetPedArmour(targetPed))

			for i, theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7 + (i / 30))
			end

			local coord = GetEntityCoords(targetPed)
			SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z - 10.0, 0, 0, 0, false)

			if IsControlJustPressed(0, 38) then
				spectatePlayer(PlayerPedId(), GetPlayerName(PlayerId()), PlayerId())
				TriggerServerEvent('gd:devolverDimension') --dimension guardada
				TriggerEvent('chatMessage', 'Parastes de reconear al jugador.')
				print('Parastes de reconear al jugador.')
			end
		end
	end)
end

function StopDrawPlayerInfo()
	drawInfo = false
end

RegisterNetEvent('gd:rs')
AddEventHandler('gd:rs', function(playerServerId, tgtCoords)
	local playerServerId = tonumber(playerServerId)
	local localPlayerPed = PlayerPedId()

	spectatePlayer(localPlayerPed)
	if ((not tgtCoords) or (tgtCoords.z == 0.0)) then
		tgtCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerServerId)))
	end

	if playerServerId == GetPlayerServerId(PlayerId()) then
		if coordenadasplayer then
			RequestCollisionAtCoord(coordenadasplayer.x, coordenadasplayer.y, coordenadasplayer.z)
			Wait(500)
			SetEntityCoords(playerPed, coordenadasplayer.x, coordenadasplayer.y, coordenadasplayer.z, 0, 0, 0, false)
			coordenadasplayer = nil
			spectatePlayer(GetPlayerPed(PlayerId()), PlayerId(), GetPlayerName(PlayerId()), PlayerId())
		end
	else
		if not coordenadasplayer then
			coordenadasplayer = GetEntityCoords(PlayerPedId())
		end
	end

	SetEntityCoords(localPlayerPed, tgtCoords.x, tgtCoords.y, tgtCoords.z - 10.0, 0, 0, 0, false)

	local playerId = GetPlayerFromServerId(playerServerId)
	repeat
		Wait(200)
		playerId = GetPlayerFromServerId(playerServerId)
	until ((GetPlayerPed(playerId) > 0) and (playerId ~= -1))

	spectatePlayer(GetPlayerPed(playerId), GetPlayerName(playerId), playerServerId)
end)

RegisterNetEvent('gd:rsoff')
AddEventHandler('gd:rsoff', function()
	local _source = source
	if getGroupGD(_source) then
		spectatePlayer(PlayerPedId(), 'Admin Off', 0)
		TriggerServerEvent('gd:devolverDimension') --dimension guardada
		TriggerEvent('chatMessage', 'Parastes de reconear al jugador.')
	end
end)

--
--- NOCLIP
--

RegisterNetEvent('gd:npt')
AddEventHandler('gd:npt', function()
	local _source = source
	if congelado then
		TriggerEvent('chatMessage', 'No puedes usar el noclip mientras estes congelado.')
		return
	end
	local name = GetPlayerName(PlayerId())
	if noclip then
		terminarnoclip()
	else
		empezarnoclip()
	end
end)

function empezarnoclip()
	local playerPed = PlayerPedId()
	local heading = GetEntityHeading(playerPed)
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(cam, true)
	RenderScriptCams(true, false, 0, true, true)

	local coords = GetEntityCoords(playerPed)

	SetCamCoord(cam, coords.x, coords.y, coords.z)
	SetCamRot(cam, 0.0, 0.0, tonumber(heading))
	SetEntityCollision(playerPed, false, false)
	SetEntityVisible(playerPed, false)
	local veh = GetVehiclePedIsIn(PlayerPedId())
	if veh then
		SetEntityVisible(veh, false)
	end
	noclip = true
end

function terminarnoclip()
	local playerPed = PlayerPedId()
	local camCoords = GetCamCoord(cam)

	SetCamActive(cam, false)
	RenderScriptCams(false, false, 0, true, true)
	SetEntityCollision(playerPed, true, true)
	SetEntityVisible(playerPed, true)
	local veh = GetVehiclePedIsIn(PlayerPedId())
	if veh then
		SetEntityVisible(veh, true)
	end
	SetPedCoordsKeepVehicle(playerPed, camCoords.x, camCoords.y, camCoords.z)

	noclip = false
end

function HandleFreeCamThisFrame()
	local camCoords              = GetCamCoord(cam)
	local right, forward, up, at = GetCamMatrix(cam)
	local speedMultiplier        = nil

	if IsControlPressed(0, 21) then
		speedMultiplier = 8.0
	elseif IsControlPressed(0, 19) then
		speedMultiplier = 0.025
	else
		speedMultiplier = 0.25
	end

	if IsControlPressed(0, 32) then
		local newCamPos = camCoords + forward * speedMultiplier
		SetCamCoord(cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 8) then
		local newCamPos = camCoords + forward * -speedMultiplier
		SetCamCoord(cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 34) then
		local newCamPos = camCoords + right * -speedMultiplier
		SetCamCoord(cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 9) then
		local newCamPos = camCoords + right * speedMultiplier
		SetCamCoord(cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	local xMagnitude = GetDisabledControlNormal(0, 1);
	local yMagnitude = GetDisabledControlNormal(0, 2);
	local camRot     = GetCamRot(cam)

	local x          = camRot.x - yMagnitude * 10
	local y          = camRot.y
	local z          = camRot.z - xMagnitude * 10

	if x < -75.0 then
		x = -75.0
	end

	if x > 100.0 then
		x = 100.0
	end

	SetCamRot(cam, x, y, z)
end

CreateThread(function()
	while true do
		Wait(10)
		if noclip then
			local playerPed = PlayerPedId()

			for i = 0, 32, 1 do
				if i ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(i)
					SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
				end
			end

			DisableControlAction(0, 30, true) -- MoveLeftRight
			DisableControlAction(0, 31, true) -- MoveUpDown
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 25, true) -- Input Aim
			DisableControlAction(0, 106, true) -- Vehicle Mouse Control Override

			DisableControlAction(0, 24, true) -- Input Attack
			DisableControlAction(0, 140, true) -- Melee Attack Alternate
			DisableControlAction(0, 141, true) -- Melee Attack Alternate
			DisableControlAction(0, 142, true) -- Melee Attack Alternate
			DisableControlAction(0, 257, true) -- Input Attack 2
			DisableControlAction(0, 263, true) -- Input Melee Attack
			DisableControlAction(0, 264, true) -- Input Melee Attack 2

			DisableControlAction(0, 12, true) -- Weapon Wheel Up Down
			DisableControlAction(0, 14, true) -- Weapon Wheel Next
			DisableControlAction(0, 15, true) -- Weapon Wheel Prev
			DisableControlAction(0, 16, true) -- Select Next Weapon
			DisableControlAction(0, 17, true) -- Select Prev Weapon

			local camCoords = GetCamCoord(cam)
			SetPedCoordsKeepVehicle(playerPed, camCoords.x, camCoords.y, camCoords.z)

			HandleFreeCamThisFrame()
		else
			Wait(1000)
		end
	end
end)

--
--- DRAWPLAYERNAME
--

function draw3DText(pos, text, options)
	options               = options or {}
	local color           = options.color or { r = 255, g = 255, b = 255, a = 255 }
	local scaleOption     = options.size or 0.8

	local camCoords       = GetGameplayCamCoords()
	local dist            = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(pos.x, pos.y, pos.z))
	local scale           = (scaleOption / dist) * 2
	local fov             = (1 / GetGameplayCamFov()) * 100
	local scaleMultiplier = scale * fov
	SetDrawOrigin(pos.x, pos.y, pos.z, 0);
	SetTextProportional(0)
	SetTextScale(0.0 * scaleMultiplier, 0.55 * scaleMultiplier)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

CreateThread(function()
	while true do
		Wait(500)
		if draw then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local allPlayers = GetActivePlayers()
			for _, v in pairs(allPlayers) do
				local targetPed = GetPlayerPed(v)
				if targetPed ~= nil and targetPed ~= -1 then
					local targetCoords = GetEntityCoords(targetPed)
					if #(coords - targetCoords) <= drawdistance then
						visiblePlayers[v] = v
					end
				end
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(5)
		if draw then
			local currentCoords = GetEntityCoords(GetPlayerPed(PlayerId()))
			for _, v in pairs(visiblePlayers) do
				local ped = GetPlayerPed(v)
				local cords = GetEntityCoords(ped)
				if #(cords - currentCoords) < drawdistance then
					local sizes
					if (#(cords - currentCoords) / 10) > 1 then
						sizes = 1.2 * (#(cords - currentCoords) / 10)
					else
						sizes = 1.2
					end
					draw3DText(cords, GetPlayerName(v) .. ' [' .. GetPlayerServerId(v) .. ']', {
						size = sizes
					})
				end
			end
		else
			Wait(1000)
		end
	end
end)

RegisterNetEvent('gd:tagsjugadores')
AddEventHandler('gd:tagsjugadores', function()
	if draw then
		draw = false
		TriggerEvent('chatMessage', 'Tags Desactivado')
	else
		draw = true
		TriggerEvent('chatMessage', 'Tags Activado')
	end
end)

RegisterNetEvent('gd:jtagdistance')
AddEventHandler('gd:jtagdistance', function(distance)
	drawdistance = distance
	if distance >= 300 then
		TriggerEvent('chatMessage', "^3(( ID-DISTANCE establecido a ^0 " .. distance .. '^3. ^2MUY EXCESIVO!^3 ))')
	elseif distance >= 150 then
		TriggerEvent('chatMessage', "^3(( ID-DISTANCE establecido a ^0 " .. distance .. '^3. ^2EXCESIVO!^3 ))')
	else
		TriggerEvent('chatMessage', "^3(( ID-DISTANCE establecido a ^0 " .. distance .. '^3.))')
	end
end)
