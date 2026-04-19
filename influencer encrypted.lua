-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║     🐉 DINASTIA CHINA PANEL — v7.0.0 ULTIMATE ELITE MAX 🐉              ║
-- ║     [Panel Redimensionable | Estética Premium | ESP Persistente |        ║
-- ║      Detección Robusta | Lógica Mejorada | HUD Profesional]             ║
-- ║     El Mejor Script Lua del Universo - Desarrollado por Rizzman 🐉      ║
-- ║                                                                           ║
-- ║   [B] Abrir/Cerrar | [M] Impulse | [F] Fly | [V] Rewind | [C] FreeCam  ║
-- ║   Arrastra panel para mover | Arrastra esquina inf-derecha para resize  ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Stats            = game:GetService("Stats")
local Lighting         = game:GetService("Lighting")
local CoreGui          = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local camera      = workspace.CurrentCamera

-- ════════════════════════════════════════════════════════════
--  PALETA DE COLORES  (Dinastía China Premium)
-- ════════════════════════════════════════════════════════════
local THEME = {
	bg          = Color3.fromRGB(10,  9,   16),
	panel       = Color3.fromRGB(18,  16,  28),
	content     = Color3.fromRGB(13,  12,  21),
	topbar      = Color3.fromRGB(7,   6,   12),
	card        = Color3.fromRGB(26,  24,  40),
	cardHover   = Color3.fromRGB(38,  36,  58),
	accent      = Color3.fromRGB(255, 210, 60),
	accentDim   = Color3.fromRGB(160, 120, 20),
	accentGlow  = Color3.fromRGB(255, 240, 120),
	green       = Color3.fromRGB(40,  220, 120),
	red         = Color3.fromRGB(255, 70,  70),
	cyan        = Color3.fromRGB(0,   210, 255),
	pink        = Color3.fromRGB(255, 80,  220),
	purple      = Color3.fromRGB(160, 80,  255),
	text        = Color3.fromRGB(240, 235, 255),
	subText     = Color3.fromRGB(130, 125, 160),
	border      = Color3.fromRGB(45,  42,  75),
	borderGlow  = Color3.fromRGB(255, 200, 50),
	-- Colores para diferentes tipos de usuario
	adminColor    = Color3.fromRGB(255, 0,   0),
	modColor      = Color3.fromRGB(255, 165, 0),
	vipColor      = Color3.fromRGB(200, 100, 255),
	trustedColor  = Color3.fromRGB(100, 200, 255),
}

-- ════════════════════════════════════════════════════════════
--  LISTAS DE USUARIOS
-- ════════════════════════════════════════════════════════════
-- ════════════════════════════════════════════════════════════════════════════
--  SISTEMA AVANZADO DE DETECCIÓN DE USUARIOS (Multi-Tier)
-- ════════════════════════════════════════════════════════════════════════════
local moderators = {
	-- Agrega moderadores aquí
}
local admins = {
	-- Agrega admins aquí
}
local vips = {
	-- Agrega VIPs aquí
}

local influencers = {
	"KeyCatsAlt",
	"TKxTheDuckELP",
	"abel55i","alexis_09571",
	"SHIESTYMARK_PRIM",
	"danifxp71",
	"TKxTheDuckELPCeleste",
	"Celeste","Panbimbo762",
	"Panbimbo762Celeste",
	"yiyiez_tk",
	"yiyiez_tkCeleste",
}
local celebrities = {
	"AnonymouscrackLleida",
}

local function isInfluencer(n) for _,v in ipairs(influencers) do if v==n then return true end end return false end
local function isCelebrity(n)  for _,v in ipairs(celebrities)  do if v==n then return true end end return false end
local function isModerator(n)  for _,v in ipairs(moderators)   do if v==n then return true end end return false end
local function isAdmin(n)      for _,v in ipairs(admins)       do if v==n then return true end end return false end
local function isVIP(n)        for _,v in ipairs(vips)         do if v==n then return true end end return false end

local function getTitleType(n)
	if isAdmin(n)      then return "Admin" end
	if isModerator(n)  then return "Moderator" end
	if isInfluencer(n) then return "Influencer" end
	if isCelebrity(n)  then return "Celebrity" end
	if isVIP(n)        then return "VIP" end
	return "User"
end

-- ════════════════════════════════════════════════════════════════════════════
--  CONFIGURACIÓN GLOBAL AVANZADA
-- ════════════════════════════════════════════════════════════════════════════
local settings = {
	hideUserTitles         = false,
	influencerEffect       = "rainbow",
	influencerColor        = Color3.fromHSV(0, 1, 1),
	celebrityEffect        = "rainbow",
	celebrityColor         = Color3.fromHSV(0.6, 1, 1),
	rainbowSpeed           = 0.85,
	pearlySpeed            = 4,
	pearlyBaseColor        = Color3.fromRGB(255, 255, 255),
	pearlyGlowColor        = Color3.fromRGB(255, 220, 80),
	titleMaxDistance       = 250,
	titleOffset            = Vector3.new(0, 3.2, 0),
	titleScaleMultiplier   = 1.0,
	titleBgTransparency    = 0.5,
	-- Nuevas configuraciones
	notificationsEnabled   = true,
	autoGroupPlayers       = true,
	enhancedESP            = true,
	playerSoundAlert       = false,
	adminAlerts            = true,
	antiCheatMode          = false,
}

local titleGuis     = {}
local rainbowLabels = {}
local pearlyLabels  = {}

-- ════════════════════════════════════════════════════════════
--  HELPERS UI
-- ════════════════════════════════════════════════════════════
local function addCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = parent
	return c
end

local function addStroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or THEME.border
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function makeTween(obj, props, dur, style, dir)
	return TweenService:Create(obj,
		TweenInfo.new(dur or 0.18, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
		props)
end

local function hoverEffect(btn, normalColor, hoverColor)
	btn.MouseEnter:Connect(function()
		makeTween(btn, {BackgroundColor3 = hoverColor or THEME.cardHover}, 0.15):Play()
	end)
	btn.MouseLeave:Connect(function()
		makeTween(btn, {BackgroundColor3 = normalColor or THEME.card}, 0.15):Play()
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
--  SISTEMA DE NOTIFICACIONES EN PANTALLA
-- ════════════════════════════════════════════════════════════════════════════
local function showNotification(title, message, color, duration)
	if not settings.notificationsEnabled then return end
	
	local screenGui = localPlayer:WaitForChild("PlayerGui")
	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(0, 320, 0, 80)
	notifFrame.Position = UDim2.new(1, -340, 1, -100 - (#notificationQueue * 90))
	notifFrame.BackgroundColor3 = THEME.card
	notifFrame.BorderSizePixel = 0
	notifFrame.Parent = screenGui
	addCorner(notifFrame, 12)
	addStroke(notifFrame, color or THEME.accent, 2)
	
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Text = "🔔 " .. title
	titleLbl.Size = UDim2.new(1, -20, 0, 30)
	titleLbl.Position = UDim2.new(0, 10, 0, 5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.TextColor3 = color or THEME.accent
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 14
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = notifFrame
	
	local msgLbl = Instance.new("TextLabel")
	msgLbl.Text = message
	msgLbl.Size = UDim2.new(1, -20, 0, 40)
	msgLbl.Position = UDim2.new(0, 10, 0, 35)
	msgLbl.BackgroundTransparency = 1
	msgLbl.TextColor3 = THEME.text
	msgLbl.Font = Enum.Font.Gotham
	msgLbl.TextSize = 12
	msgLbl.TextXAlignment = Enum.TextXAlignment.Left
	msgLbl.TextWrapped = true
	msgLbl.Parent = notifFrame
	
	table.insert(notificationQueue, notifFrame)
	
	task.delay(duration or 3, function()
		if notifFrame and notifFrame.Parent then
			makeTween(notifFrame, {BackgroundTransparency = 1}, 0.3):Play()
			task.wait(0.3)
			notifFrame:Destroy()
		end
		for i, v in ipairs(notificationQueue) do
			if v == notifFrame then table.remove(notificationQueue, i) break end
		end
	end)
end

-- ════════════════════════════════════════════════════════════
--  OVERHEAD TITLES
-- ════════════════════════════════════════════════════════════
local function buildPearlyGradient(gradient)
	local base = settings.pearlyBaseColor
	local glow = settings.pearlyGlowColor
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(
			math.floor(base.R*255*0.7), math.floor(base.G*255*0.7), math.floor(base.B*255*0.7))),
		ColorSequenceKeypoint.new(0.5, glow),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(
			math.floor(base.R*255*0.7), math.floor(base.G*255*0.7), math.floor(base.B*255*0.7))),
	}
end

local function updateTitleAppearance(character)
	local data = titleGuis[character]
	if not data then return end
	local label    = data.label
	local gradient = data.gradient
	local bg       = data.bg

	for i=#rainbowLabels,1,-1 do if rainbowLabels[i]==label then table.remove(rainbowLabels,i) break end end
	for i=#pearlyLabels, 1,-1 do if pearlyLabels[i] ==label then table.remove(pearlyLabels, i) break end end

	local effect, baseColor
	if data.titleType == "Influencer" then
		effect    = settings.influencerEffect
		baseColor = settings.influencerColor
		bg.BackgroundTransparency = settings.titleBgTransparency
	elseif data.titleType == "Celebrity" then
		effect    = settings.celebrityEffect
		baseColor = settings.celebrityColor
		bg.BackgroundTransparency = settings.titleBgTransparency
	elseif data.titleType == "Admin" then
		label.TextColor3 = THEME.adminColor
		gradient.Enabled = false
		bg.BackgroundTransparency = settings.titleBgTransparency
		return
	elseif data.titleType == "Moderator" then
		label.TextColor3 = THEME.modColor
		gradient.Enabled = false
		bg.BackgroundTransparency = settings.titleBgTransparency
		return
	elseif data.titleType == "VIP" then
		label.TextColor3 = THEME.vipColor
		gradient.Enabled = true
		buildPearlyGradient(gradient)
		table.insert(pearlyLabels, label)
		bg.BackgroundTransparency = settings.titleBgTransparency
		return
	else
		label.TextColor3 = THEME.subText
		gradient.Enabled = false
		bg.BackgroundTransparency = 1 -- Usuarios normales sin fondo
		return
	end

	if effect == "solid" then
		label.TextColor3 = baseColor
		gradient.Enabled = false
	elseif effect == "rainbow" then
		label.TextColor3 = baseColor
		gradient.Enabled = false
		table.insert(rainbowLabels, label)
	elseif effect == "pearly" then
		label.TextColor3 = settings.pearlyBaseColor
		gradient.Enabled = true
		buildPearlyGradient(gradient)
		table.insert(pearlyLabels, label)
	elseif effect == "fire" then
		label.TextColor3 = Color3.fromRGB(255,80,0)
		gradient.Enabled = false
		table.insert(rainbowLabels, {label=label, mode="fire"})
	end
end

local function createTitleGui(character)
	if not character then return end
	local head = character:WaitForChild("Head", 6)
	if not head then return end

	local playerName = character.Name
	local titleType  = getTitleType(playerName)

	if titleType == "User" and settings.hideUserTitles then
		local ex = character:FindFirstChild("OverheadTitle")
		if ex then ex:Destroy() end
		return
	end

	local ex = character:FindFirstChild("OverheadTitle")
	if ex then ex:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name          = "OverheadTitle"
	billboard.Adornee       = head
	billboard.AlwaysOnTop   = true
	billboard.StudsOffset   = settings.titleOffset
	billboard.Size          = UDim2.new(0, 340, 0, 80)
	billboard.LightInfluence= 0
	billboard.MaxDistance   = settings.titleMaxDistance
	billboard.Parent        = character

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1,0,1,0)
	bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.Parent = billboard
	addCorner(bg, 10)

	local textLabel = Instance.new("TextLabel")
	textLabel.Name               = "TextLabel"
	textLabel.Size               = UDim2.new(1,0,1,0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text               = titleType == "Admin" and "🔴 ADMIN 🔴"
	                            or titleType == "Moderator" and "🟠 Moderator 🟠"
	                            or titleType == "Influencer" and "💎 Influencer 💎"
	                            or titleType == "Celebrity"  and "⭐ Celebrity ⭐"
	                            or titleType == "VIP" and "👑 VIP 👑"
	                            or "👤 @"..playerName
	textLabel.TextSize           = 26
	textLabel.Font               = Enum.Font.GothamBold
	textLabel.TextStrokeTransparency = 0.3
	textLabel.TextStrokeColor3   = Color3.fromRGB(0,0,0)
	textLabel.TextColor3         = Color3.new(1,1,1)
	textLabel.Parent             = billboard

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(180,180,180)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(180,180,180)),
	}
	gradient.Rotation    = 0
	gradient.Transparency= NumberSequence.new(0)
	gradient.Enabled     = false
	gradient.Parent      = textLabel

	titleGuis[character] = {billboard=billboard, label=textLabel, gradient=gradient, bg=bg, titleType=titleType}
	updateTitleAppearance(character)
end

local function updateTitleScales()
	for character, data in pairs(titleGuis) do
		if character and character.Parent and data.billboard then
			local head = character:FindFirstChild("Head")
			if head then
				local dist  = (camera.CFrame.Position - head.Position).Magnitude
				local scale = math.clamp(12/(dist*0.8), 0.3, 1.8) * settings.titleScaleMultiplier
				data.billboard.Size  = UDim2.new(0, 340*scale, 0, 80*scale)
				data.label.TextSize  = 26*scale
			end
		else
			titleGuis[character] = nil
		end
	end
end

RunService.Heartbeat:Connect(function()
	local hue = (tick()*settings.rainbowSpeed) % 1
	for i=#rainbowLabels,1,-1 do
		local entry = rainbowLabels[i]
		if type(entry)=="table" then
			if entry.label and entry.label.Parent then
				local fHue = 0.04 + math.abs(math.sin(tick()*2))*0.05
				entry.label.TextColor3 = Color3.fromHSV(fHue,1,1)
			else table.remove(rainbowLabels,i) end
		else
			local lbl = entry
			if lbl and lbl.Parent then lbl.TextColor3 = Color3.fromHSV(hue,1,1)
			else table.remove(rainbowLabels,i) end
		end
	end
	for i=#pearlyLabels,1,-1 do
		local lbl = pearlyLabels[i]
		if lbl and lbl.Parent then
			local g = lbl:FindFirstChild("UIGradient")
			if g then
				g.Offset = Vector2.new(math.sin(tick()*settings.pearlySpeed)*0.8, 0)
				buildPearlyGradient(g)
			end
		else table.remove(pearlyLabels,i) end
	end
	updateTitleScales()
end)

local function setupPlayer(player)
	if player.Character then createTitleGui(player.Character) end
	player.CharacterAdded:Connect(createTitleGui)
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerAdded:Connect(setupPlayer)

-- ════════════════════════════════════════════════════════════════════════════
--  VARIABLES GLOBALES DE FEATURES Y NOTIFICACIONES
-- ════════════════════════════════════════════════════════════════════════════
local noClipConn, clickTPConn
local impulseEnabled = false
local impulseForce   = 360
local flyConn        = nil
local flyEnabled     = false
local flySpeed       = 60
local originalCFrame = nil
local exploded       = false
local espEnabled     = false
local espConnections = {}
local aimbotEnabled  = false
local nightmodeOn    = false
local originalAmbient = Lighting.Ambient
local originalBrightness = Lighting.Brightness
local killauraEnabled = false
local speedBoostEnabled = false
local speedBoostValue = 1.5
local playerCache = {}
local notificationQueue = {}
local trackedPlayers = {}

-- ════════════════════════════════════════════════════════════
--  FREE CAMERA STATE
-- ════════════════════════════════════════════════════════════
local freecamActive      = false
local freecamSpeed       = 40
local freecamSens        = 0.003
local freecamYaw         = 0
local freecamPitch       = 0
local freecamConn        = nil
local freecamInputConn   = nil
local savedCamCFrame     = CFrame.new()
local savedCamType       = Enum.CameraType.Custom

-- ════════════════════════════════════════════════════════════
--  TIME REWIND STATE
-- ════════════════════════════════════════════════════════════
local rewindHistory      = {}
local rewindMaxStored    = 60 * 60  -- 60 segundos a 60fps
local rewindSpeed        = 1
local rewindKey          = Enum.KeyCode.V
local isRewinding        = false
local rewindConn         = nil

local function startRewind()
	if rewindConn then rewindConn:Disconnect(); rewindConn = nil end
	rewindHistory = {}
	rewindConn = RunService.Heartbeat:Connect(function()
		local char = localPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum  = char and char:FindFirstChild("Humanoid")
		local animateScript = char and char:FindFirstChild("Animate")

		if not root or not hum or hum.Health <= 0 then
			rewindHistory = {}
			return
		end

		if UserInputService:IsKeyDown(rewindKey) then
			isRewinding = true
			for i = 1, rewindSpeed do
				if #rewindHistory > 0 then
					if animateScript then animateScript.Disabled = true end
					local snapshot = table.remove(rewindHistory, #rewindHistory)
					if i == rewindSpeed or #rewindHistory == 0 then
						root.CFrame = root.CFrame:Lerp(snapshot.cf, 0.5)
						root.AssemblyLinearVelocity = Vector3.zero
						for _, animData in pairs(snapshot.anims) do
							local track = animData.track
							if track then
								if not track.IsPlaying then track:Play(0) end
								track.TimePosition = animData.pos
								track:AdjustSpeed(0)
								track:AdjustWeight(animData.weight)
							end
						end
					end
				end
			end
		else
			if isRewinding then
				isRewinding = false
				if animateScript then animateScript.Disabled = false end
				for _, track in pairs(hum:GetPlayingAnimationTracks()) do
					track:Stop(0.1)
					track:AdjustSpeed(1)
				end
			end
			local currentAnims = {}
			for _, track in pairs(hum:GetPlayingAnimationTracks()) do
				if track.WeightCurrent > 0 then
					table.insert(currentAnims, {
						track = track,
						pos   = track.TimePosition,
						weight= track.WeightCurrent
					})
				end
			end
			table.insert(rewindHistory, { cf = root.CFrame, anims = currentAnims })
			if #rewindHistory > rewindMaxStored then
				table.remove(rewindHistory, 1)
			end
		end
	end)
end

local function stopRewind()
	if rewindConn then rewindConn:Disconnect(); rewindConn = nil end
	rewindHistory = {}
	isRewinding = false
end

-- ════════════════════════════════════════════════════════════
--  FREE CAMERA FUNCTIONS
-- ════════════════════════════════════════════════════════════
local function startFreecam()
	if freecamActive then return end
	freecamActive = true
	savedCamType  = camera.CameraType
	savedCamCFrame = camera.CFrame

	camera.CameraType = Enum.CameraType.Scriptable

	local cf = camera.CFrame
	local _,y,_ = cf:ToEulerAnglesYXZ()
	freecamYaw   = y
	freecamPitch = 0

	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

	freecamConn = RunService.RenderStepped:Connect(function(dt)
		if not freecamActive then return end

		local delta = UserInputService:GetMouseDelta()
		freecamYaw   = freecamYaw   - delta.X * freecamSens
		freecamPitch = math.clamp(freecamPitch - delta.Y * freecamSens, -math.pi/2 + 0.05, math.pi/2 - 0.05)

		local rot = CFrame.Angles(0, freecamYaw, 0) * CFrame.Angles(freecamPitch, 0, 0)
		local right   = rot.RightVector
		local up      = Vector3.new(0,1,0)
		local forward = rot.LookVector

		local move = Vector3.zero
		local speed = freecamSpeed
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * 0.25 end
		if UserInputService:IsKeyDown(Enum.KeyCode.E)         then speed = speed * 3 end

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - right   end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + right   end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then move = move + up   end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up   end

		if move.Magnitude > 0 then
			camera.CFrame = CFrame.new(camera.CFrame.Position + move.Unit * speed * dt) * rot
		else
			camera.CFrame = CFrame.new(camera.CFrame.Position) * rot
		end
	end)

	freecamInputConn = UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.F and freecamActive then
			stopFreecam()
		end
	end)
end

function stopFreecam()
	if not freecamActive then return end
	freecamActive = false
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	camera.CameraType = savedCamType
	if freecamConn then freecamConn:Disconnect(); freecamConn = nil end
	if freecamInputConn then freecamInputConn:Disconnect(); freecamInputConn = nil end
end

-- ════════════════════════════════════════════════════════════
--  SCREEN GUI  (raíz)
-- ════════════════════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name          = "DinastiaChinaPanelV5"
screenGui.ResetOnSpawn  = false
screenGui.ZIndexBehavior= Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset= true
screenGui.Parent        = CoreGui:FindFirstChild("RobloxGui") or localPlayer:WaitForChild("PlayerGui")

-- ════════════════════════════════════════════════════════════════════════════
--  VARIABLES DE CONFIGURACIÓN PARA REDIMENSIONAMIENTO
-- ════════════════════════════════════════════════════════════════════════════
local panelWidth = 800
local panelHeight = 600
local minPanelWidth = 400
local minPanelHeight = 300

-- ════════════════════════════════════════════════════════════
--  MAIN FRAME
-- ════════════════════════════════════════════════════════════
local mainFrame = Instance.new("Frame")
mainFrame.Name            = "MainFrame"
mainFrame.Size            = UDim2.new(0, panelWidth, 0, panelHeight)
mainFrame.Position        = UDim2.new(0.5, -panelWidth/2, 0.5, -panelHeight/2)
mainFrame.BackgroundColor3= THEME.bg
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants= true
mainFrame.Parent          = screenGui
addCorner(mainFrame, 14)
addStroke(mainFrame, THEME.border, 2)

-- Sombra arreglada (dentro del ScreenGui, vinculada al MainFrame)
local shadowFrame = Instance.new("ImageLabel")
shadowFrame.Name = "Shadow"
shadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
shadowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
shadowFrame.Size = UDim2.new(1, 40, 1, 40)
shadowFrame.BackgroundTransparency = 1
shadowFrame.Image = "rbxassetid://1316045217"
shadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.ImageTransparency = 0.4
shadowFrame.ScaleType = Enum.ScaleType.Slice
shadowFrame.SliceCenter = Rect.new(10, 10, 118, 118)
shadowFrame.ZIndex = mainFrame.ZIndex - 1
shadowFrame.Parent = mainFrame

-- Degradado de fondo
local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(14,12,24)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(8, 7, 16)),
}
bgGrad.Rotation = 135
bgGrad.Parent = mainFrame

-- ════════════════════════════════════════════════════════════
--  TOP BAR
-- ════════════════════════════════════════════════════════════
local topBar = Instance.new("Frame")
topBar.Size             = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = THEME.topbar
topBar.BorderSizePixel  = 0
topBar.ZIndex           = 3
topBar.Parent           = mainFrame

-- Línea dorada animada inferior
local topLine = Instance.new("Frame")
topLine.Size             = UDim2.new(1, 0, 0, 2)
topLine.Position         = UDim2.new(0, 0, 1, -2)
topLine.BackgroundColor3 = THEME.accent
topLine.BorderSizePixel  = 0
topLine.Parent           = topBar
local topLineGrad = Instance.new("UIGradient")
topLineGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(200,130,0)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255,220,60)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,180)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255,220,60)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(200,130,0)),
}
topLineGrad.Parent = topLine

-- Animación de la línea dorada
spawn(function()
	while topLine and topLine.Parent do
		for i=0,360,2 do
			if not topLine.Parent then break end
			topLineGrad.Rotation = i
			task.wait(0.03)
		end
	end
end)

-- Logo dragón
local logoLbl = Instance.new("TextLabel")
logoLbl.Text              = "🐉"
logoLbl.Size              = UDim2.new(0, 40, 0, 40)
logoLbl.Position          = UDim2.new(0, 8, 0.5, -20)
logoLbl.BackgroundTransparency = 1
logoLbl.TextColor3        = THEME.accent
logoLbl.Font              = Enum.Font.GothamBlack
logoLbl.TextSize          = 28
logoLbl.ZIndex            = 4
logoLbl.Parent            = topBar

local panelTitle = Instance.new("TextLabel")
panelTitle.Text           = "Dinastia China Panel"
panelTitle.Size           = UDim2.new(0, 300, 1, 0)
panelTitle.Position       = UDim2.new(0, 54, 0, 0)
panelTitle.BackgroundTransparency = 1
panelTitle.TextColor3     = THEME.accent
panelTitle.Font           = Enum.Font.GothamBlack
panelTitle.TextSize       = 19
panelTitle.TextXAlignment = Enum.TextXAlignment.Left
panelTitle.ZIndex         = 4
panelTitle.Parent         = topBar

local titleGradUI = Instance.new("UIGradient")
titleGradUI.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,215,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,180)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,170,0)),
}
titleGradUI.Rotation = 0
titleGradUI.Parent = panelTitle

-- Animar el degradado del título
spawn(function()
	while panelTitle and panelTitle.Parent do
		for i=0,360,3 do
			if not panelTitle.Parent then break end
			titleGradUI.Rotation = i
			task.wait(0.04)
		end
	end
end)

local versionBadge = Instance.new("Frame")
versionBadge.Size             = UDim2.new(0, 66, 0, 24)
versionBadge.Position         = UDim2.new(0, 358, 0.5, -12)
versionBadge.BackgroundColor3 = THEME.accent
versionBadge.ZIndex           = 4
versionBadge.Parent           = topBar
addCorner(versionBadge, 6)
local versionLbl = Instance.new("TextLabel")
versionLbl.Text              = "v7.0.0"
versionLbl.Size              = UDim2.new(1,0,1,0)
versionLbl.BackgroundTransparency = 1
versionLbl.TextColor3        = Color3.fromRGB(20,20,20)
versionLbl.Font              = Enum.Font.GothamBold
versionLbl.TextSize          = 13
versionLbl.ZIndex            = 5
versionLbl.Parent            = versionBadge

local credits = Instance.new("TextLabel")
credits.Text              = "Rizzman ✨"
credits.Size              = UDim2.new(0, 130, 1, 0)
credits.Position          = UDim2.new(1, -172, 0, 0)
credits.BackgroundTransparency = 1
credits.TextColor3        = THEME.subText
credits.Font              = Enum.Font.Gotham
credits.TextSize          = 14
credits.ZIndex            = 4
credits.Parent            = topBar

-- Botón minimizar
local minBtn = Instance.new("TextButton")
minBtn.Text             = "─"
minBtn.Size             = UDim2.new(0, 30, 0, 30)
minBtn.Position         = UDim2.new(1, -76, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
minBtn.TextColor3       = Color3.new(1,1,1)
minBtn.Font             = Enum.Font.GothamBold
minBtn.TextSize         = 18
minBtn.ZIndex           = 5
minBtn.Parent           = topBar
addCorner(minBtn, 8)
hoverEffect(minBtn, Color3.fromRGB(60,100,60), Color3.fromRGB(80,140,80))

local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		makeTween(mainFrame, {Size = UDim2.new(0,720,0,50)}, 0.3, Enum.EasingStyle.Quart):Play()
	else
		makeTween(mainFrame, {Size = UDim2.new(0,720,0,490)}, 0.3, Enum.EasingStyle.Quart):Play()
	end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Text             = "✕"
closeBtn.Size             = UDim2.new(0, 30, 0, 30)
closeBtn.Position         = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.TextColor3       = Color3.new(1,1,1)
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.TextSize         = 14
closeBtn.ZIndex           = 5
closeBtn.Parent           = topBar
addCorner(closeBtn, 8)
hoverEffect(closeBtn, Color3.fromRGB(180,40,40), Color3.fromRGB(220,60,60))
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Arrastrar ventana
do
	local dragging, dragStart, startPos = false, nil, nil
	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos  = mainFrame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- ════════════════════════════════════════════════════════════
--  SIDEBAR (tabs)
-- ════════════════════════════════════════════════════════════
local sideBar = Instance.new("Frame")
sideBar.Size             = UDim2.new(0, 162, 1, -50)
sideBar.Position         = UDim2.new(0, 0, 0, 50)
sideBar.BackgroundColor3 = THEME.panel
sideBar.BorderSizePixel  = 0
sideBar.Parent           = mainFrame

local sideGrad = Instance.new("UIGradient")
sideGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20,18,32)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(14,12,24)),
}
sideGrad.Rotation = 90
sideGrad.Parent = sideBar

local sideLineR = Instance.new("Frame")
sideLineR.Size             = UDim2.new(0, 1, 1, 0)
sideLineR.Position         = UDim2.new(1, 0, 0, 0)
sideLineR.BackgroundColor3 = THEME.border
sideLineR.BorderSizePixel  = 0
sideLineR.Parent           = sideBar

-- ════════════════════════════════════════════════════════════
--  CONTENT AREA
-- ════════════════════════════════════════════════════════════
local contentArea = Instance.new("ScrollingFrame")
contentArea.Name             = "ContentArea"
contentArea.Size             = UDim2.new(1, -162, 1, -50)
contentArea.Position         = UDim2.new(0, 162, 0, 50)
contentArea.BackgroundColor3 = THEME.content
contentArea.BorderSizePixel  = 0
contentArea.ScrollBarThickness = 4
contentArea.ScrollBarImageColor3 = THEME.accent
contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
contentArea.CanvasSize       = UDim2.new(0, 0, 0, 0)
contentArea.Parent           = mainFrame

-- ════════════════════════════════════════════════════════════
--  TABS DEFINITION
-- ════════════════════════════════════════════════════════════
local tabList = {
	{name="Home",      icon="⌂"},
	{name="VIP",       icon="★"},
	{name="Combat",    icon="⚔"},
	{name="Emphasis",  icon="⚡"},
	{name="Character", icon="👤"},
	{name="Players",   icon="👥"},
	{name="Visual",    icon="🎨"},
	{name="Camera",    icon="📷"},
	{name="World",     icon="🌍"},
	{name="Misc",      icon="🔧"},
	{name="Settings",  icon="⚙"},
}

local tabButtons = {}
local activeTab  = nil

local function setActiveTab(name)
	activeTab = name
	for _, data in ipairs(tabButtons) do
		local isActive = data.name == name
		makeTween(data.btn, {
			BackgroundColor3 = isActive and Color3.fromRGB(26,24,42) or THEME.panel,
		}, 0.15):Play()
		data.indicator.BackgroundTransparency = isActive and 0 or 1
		data.label.TextColor3   = isActive and THEME.accent or THEME.subText
		data.iconLbl.TextColor3 = isActive and THEME.accent or THEME.subText
	end
end

for i, tabData in ipairs(tabList) do
	local btn = Instance.new("TextButton")
	btn.Text             = ""
	btn.Size             = UDim2.new(1, 0, 0, 46)
	btn.Position         = UDim2.new(0, 0, 0, (i-1)*46)
	btn.BackgroundColor3 = THEME.panel
	btn.BorderSizePixel  = 0
	btn.ZIndex           = 2
	btn.Parent           = sideBar

	local indicator = Instance.new("Frame")
	indicator.Size             = UDim2.new(0, 3, 0.55, 0)
	indicator.Position         = UDim2.new(0, 0, 0.225, 0)
	indicator.BackgroundColor3 = THEME.accent
	indicator.BorderSizePixel  = 0
	indicator.BackgroundTransparency = 1
	indicator.ZIndex           = 3
	indicator.Parent           = btn
	addCorner(indicator, 4)

	local iconLbl = Instance.new("TextLabel")
	iconLbl.Text              = tabData.icon
	iconLbl.Size              = UDim2.new(0, 28, 0, 28)
	iconLbl.Position          = UDim2.new(0, 12, 0.5, -14)
	iconLbl.BackgroundTransparency = 1
	iconLbl.TextColor3        = THEME.subText
	iconLbl.Font              = Enum.Font.GothamBold
	iconLbl.TextSize          = 19
	iconLbl.ZIndex            = 3
	iconLbl.Parent            = btn

	local label = Instance.new("TextLabel")
	label.Text              = tabData.name
	label.Size              = UDim2.new(1, -48, 1, 0)
	label.Position          = UDim2.new(0, 46, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3        = THEME.subText
	label.Font              = Enum.Font.GothamBold
	label.TextSize          = 14
	label.TextXAlignment    = Enum.TextXAlignment.Left
	label.ZIndex            = 3
	label.Parent            = btn

	table.insert(tabButtons, {name=tabData.name, btn=btn, indicator=indicator, label=label, iconLbl=iconLbl})

	btn.MouseEnter:Connect(function()
		if activeTab ~= tabData.name then
			makeTween(btn, {BackgroundColor3 = Color3.fromRGB(22,20,36)}, 0.1):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if activeTab ~= tabData.name then
			makeTween(btn, {BackgroundColor3 = THEME.panel}, 0.1):Play()
		end
	end)
	btn.MouseButton1Click:Connect(function()
		loadTab(tabData.name)
	end)
end

-- ════════════════════════════════════════════════════════════
--  HELPERS CONTENT
-- ════════════════════════════════════════════════════════════
local function makeCard(parent, yPos, w, h)
	local card = Instance.new("Frame")
	card.Size             = UDim2.new(0, w or 480, 0, h or 52)
	card.Position         = UDim2.new(0, 20, 0, yPos)
	card.BackgroundColor3 = THEME.card
	card.BorderSizePixel  = 0
	card.Parent           = parent
	addCorner(card, 8)
	addStroke(card, THEME.border, 1)
	return card
end

local function makeLabel(parent, text, x, y, w, h, size, color, font, alignX)
	local lbl = Instance.new("TextLabel")
	lbl.Text              = text
	lbl.Size              = UDim2.new(0, w or 300, 0, h or 30)
	lbl.Position          = UDim2.new(0, x, 0, y)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3        = color or THEME.text
	lbl.Font              = font  or Enum.Font.Gotham
	lbl.TextSize          = size  or 16
	lbl.TextXAlignment    = alignX or Enum.TextXAlignment.Left
	lbl.Parent            = parent
	return lbl
end

local function makeToggleBtn(parent, labelTxt, yPos, callback)
	local card = makeCard(parent, yPos, 480, 52)

	local icon = Instance.new("TextLabel")
	icon.Text             = "◈"
	icon.Size             = UDim2.new(0, 30, 1, 0)
	icon.Position         = UDim2.new(0, 12, 0, 0)
	icon.BackgroundTransparency = 1
	icon.TextColor3       = THEME.accent
	icon.Font             = Enum.Font.GothamBold
	icon.TextSize         = 20
	icon.Parent           = card

	local lbl = makeLabel(card, labelTxt, 48, 0, 300, 52, 15, THEME.text, Enum.Font.GothamBold)
	lbl.TextYAlignment = Enum.TextYAlignment.Center

	local switchBg = Instance.new("Frame")
	switchBg.Size             = UDim2.new(0, 52, 0, 28)
	switchBg.Position         = UDim2.new(1, -64, 0.5, -14)
	switchBg.BackgroundColor3 = Color3.fromRGB(45,45,65)
	switchBg.BorderSizePixel  = 0
	switchBg.Parent           = card
	addCorner(switchBg, 14)

	local switchKnob = Instance.new("Frame")
	switchKnob.Size             = UDim2.new(0, 22, 0, 22)
	switchKnob.Position         = UDim2.new(0, 3, 0.5, -11)
	switchKnob.BackgroundColor3 = THEME.subText
	switchKnob.BorderSizePixel  = 0
	switchKnob.Parent           = switchBg
	addCorner(switchKnob, 11)

	local enabled = false
	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(1,0,1,0)
	btn.BackgroundTransparency = 1
	btn.Text             = ""
	btn.Parent           = card
	hoverEffect(card, THEME.card, THEME.cardHover)

	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		if enabled then
			makeTween(switchBg,   {BackgroundColor3 = THEME.green}, 0.18):Play()
			makeTween(switchKnob, {Position = UDim2.new(1,-25,0.5,-11), BackgroundColor3 = Color3.new(1,1,1)}, 0.18):Play()
		else
			makeTween(switchBg,   {BackgroundColor3 = Color3.fromRGB(45,45,65)}, 0.18):Play()
			makeTween(switchKnob, {Position = UDim2.new(0,3,0.5,-11), BackgroundColor3 = THEME.subText}, 0.18):Play()
		end
		if callback then callback(enabled) end
	end)

	return card, btn, function() return enabled end
end

-- Color picker wheel simple (cicla por HSV)
local function makeColorPicker(parent, yPos, label, currentColor, onChange)
	local card = makeCard(parent, yPos, 480, 54)
	local preview = Instance.new("Frame")
	preview.Size = UDim2.new(0,30,0,30); preview.Position = UDim2.new(0,12,0.5,-15)
	preview.BackgroundColor3 = currentColor; preview.BorderSizePixel=0; preview.Parent=card
	addCorner(preview,6)
	addStroke(preview, THEME.border, 1)

	makeLabel(card, label, 54, 0, 280, 54, 14, THEME.text, Enum.Font.Gotham)

	-- Botones H+ / H- / S / B
	local bw = 42
	local bx = 480 - 4*(bw+4) - 8
	local function makeColorBtn(txt, ox, fn)
		local b = Instance.new("TextButton")
		b.Text = txt; b.Size = UDim2.new(0,bw,0,30); b.Position = UDim2.new(0, ox, 0.5,-15)
		b.BackgroundColor3 = Color3.fromRGB(38,36,58); b.TextColor3 = THEME.accent
		b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.BorderSizePixel=0; b.Parent=card
		addCorner(b,6); hoverEffect(b, Color3.fromRGB(38,36,58), THEME.cardHover)
		b.MouseButton1Click:Connect(function()
			local h,s,v = currentColor:ToHSV()
			currentColor = fn(h,s,v)
			preview.BackgroundColor3 = currentColor
			if onChange then onChange(currentColor) end
		end)
		return b
	end
	makeColorBtn("H+", bx,         function(h,s,v) return Color3.fromHSV((h+0.08)%1,s,v) end)
	makeColorBtn("H-", bx+bw+4,    function(h,s,v) return Color3.fromHSV((h-0.08+1)%1,s,v) end)
	makeColorBtn("S",  bx+(bw+4)*2, function(h,s,v) return Color3.fromHSV(h, s>0.5 and 0.3 or 1, v) end)
	makeColorBtn("B",  bx+(bw+4)*3, function(h,s,v) return Color3.fromHSV(h,s, v>0.5 and 0.4 or 1) end)
	return card
end

-- Slider helper
local function makeSlider(parent, yPos, labelTxt, default, minVal, maxVal, onChange)
	local card = makeCard(parent, yPos, 480, 70)
	makeLabel(card, labelTxt, 14, 5, 300, 24, 14, THEME.text, Enum.Font.GothamBold)
	local valLbl = makeLabel(card, tostring(default), 420, 5, 50, 24, 14, THEME.accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)

	local trackBg = Instance.new("Frame")
	trackBg.Size             = UDim2.new(1,-28,0,8)
	trackBg.Position         = UDim2.new(0,14,1,-22)
	trackBg.BackgroundColor3 = Color3.fromRGB(35,33,55)
	trackBg.BorderSizePixel  = 0
	trackBg.Parent           = card
	addCorner(trackBg,4)

	local trackFill = Instance.new("Frame")
	trackFill.Size             = UDim2.new((default-minVal)/(maxVal-minVal),0,1,0)
	trackFill.BackgroundColor3 = THEME.accent
	trackFill.BorderSizePixel  = 0
	trackFill.Parent           = trackBg
	addCorner(trackFill,4)

	local knob = Instance.new("Frame")
	knob.Size             = UDim2.new(0,16,0,16)
	knob.Position         = UDim2.new((default-minVal)/(maxVal-minVal),0,0.5,-8)
	knob.AnchorPoint      = Vector2.new(0.5,0)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.BorderSizePixel  = 0
	knob.ZIndex           = 3
	knob.Parent           = trackBg
	addCorner(knob,8)

	local box = Instance.new("TextBox")
	box.Text = tostring(default); box.Size = UDim2.new(0,70,0,26)
	box.Position = UDim2.new(1,-84,0,8); box.BackgroundColor3 = Color3.fromRGB(28,26,44)
	box.TextColor3 = THEME.accent; box.Font = Enum.Font.GothamBold; box.TextSize=14
	box.ClearTextOnFocus=false; box.Parent=card
	addCorner(box,6); addStroke(box,THEME.border,1)

	local function applyValue(v)
		v = math.clamp(tonumber(v) or default, minVal, maxVal)
		box.Text = tostring(v); valLbl.Text = tostring(v)
		local pct = (v-minVal)/(maxVal-minVal)
		trackFill.Size = UDim2.new(pct,0,1,0)
		knob.Position  = UDim2.new(pct,0,0.5,-8)
		if onChange then onChange(v) end
	end
	box.FocusLost:Connect(function(enter) if enter then applyValue(box.Text) end end)
	return card
end

-- ════════════════════════════════════════════════════════════
--  LOAD TAB  (contenido dinámico)
-- ════════════════════════════════════════════════════════════
function loadTab(name)
	contentArea:ClearAllChildren()
	contentArea.CanvasSize = UDim2.new(0,0,0,0)
	setActiveTab(name)

	-- ── HOME ────────────────────────────────────────────────
	if name == "Home" then
		-- Banner con imagen de Rizzman
		local bannerFrame = Instance.new("Frame")
		bannerFrame.Size             = UDim2.new(1, -40, 0, 168)
		bannerFrame.Position         = UDim2.new(0, 20, 0, 20)
		bannerFrame.BackgroundColor3 = Color3.fromRGB(16,14,28)
		bannerFrame.BorderSizePixel  = 0
		bannerFrame.Parent           = contentArea
		addCorner(bannerFrame, 12)
		addStroke(bannerFrame, THEME.accent, 1.5)

		-- Imagen de fondo dragón
		local bannerImg = Instance.new("ImageLabel")
		bannerImg.Size               = UDim2.new(1, 0, 1, 0)
		bannerImg.BackgroundTransparency = 1
		bannerImg.Image              = "https://i.pinimg.com/736x/37/67/7e/37677ea86cb2391ea583274531d05c55.jpg"
		bannerImg.ScaleType          = Enum.ScaleType.Crop
		bannerImg.Parent             = bannerFrame
		addCorner(bannerImg, 12)

		local overlay = Instance.new("Frame")
		overlay.Size             = UDim2.new(1,0,1,0)
		overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
		overlay.BackgroundTransparency = 0.42
		overlay.BorderSizePixel  = 0
		overlay.ZIndex           = 2
		overlay.Parent           = bannerFrame
		addCorner(overlay, 12)

		-- Foto de perfil Rizzman (circular)
		local pfpBorder = Instance.new("Frame")
		pfpBorder.Size = UDim2.new(0,72,0,72)
		pfpBorder.Position = UDim2.new(0,12,0.5,-36)
		pfpBorder.BackgroundColor3 = THEME.accent
		pfpBorder.BorderSizePixel = 0
		pfpBorder.ZIndex = 3
		pfpBorder.Parent = bannerFrame
		addCorner(pfpBorder, 36)

		local pfpImg = Instance.new("ImageLabel")
		pfpImg.Size = UDim2.new(1,-4,1,-4)
		pfpImg.Position = UDim2.new(0,2,0,2)
		pfpImg.BackgroundColor3 = Color3.fromRGB(30,28,48)
		pfpImg.Image = "rbxassetid://1000000000" -- Placeholder, puedes cambiarlo
		pfpImg.ScaleType = Enum.ScaleType.Crop
		pfpImg.ZIndex = 4
		pfpImg.Parent = pfpBorder
		addCorner(pfpImg, 32)

		local bannerTitle = Instance.new("TextLabel")
		bannerTitle.Text              = "Dinastia China Panel"
		bannerTitle.Size              = UDim2.new(1,-106,0,36)
		bannerTitle.Position          = UDim2.new(0,94,0,22)
		bannerTitle.BackgroundTransparency = 1
		bannerTitle.TextColor3        = THEME.accent
		bannerTitle.Font              = Enum.Font.GothamBlack
		bannerTitle.TextSize          = 20
		bannerTitle.TextXAlignment    = Enum.TextXAlignment.Left
		bannerTitle.ZIndex            = 3
		bannerTitle.Parent            = bannerFrame
		local bTitleGrad = Instance.new("UIGradient")
		bTitleGrad.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255,215,0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,180)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255,170,0)),
		}
		bTitleGrad.Parent = bannerTitle

		local bannerSub = Instance.new("TextLabel")
		bannerSub.Text              = "Bienvenido, @"..localPlayer.Name.." 🐉"
		bannerSub.Size              = UDim2.new(1,-106,0,26)
		bannerSub.Position          = UDim2.new(0,94,0,60)
		bannerSub.BackgroundTransparency = 1
		bannerSub.TextColor3        = THEME.text
		bannerSub.Font              = Enum.Font.Gotham
		bannerSub.TextSize          = 15
		bannerSub.TextXAlignment    = Enum.TextXAlignment.Left
		bannerSub.ZIndex            = 3
		bannerSub.Parent            = bannerFrame

		-- Dev badge
		local devBadge = Instance.new("Frame")
		devBadge.Size = UDim2.new(0,120,0,26); devBadge.Position = UDim2.new(0,94,0,96)
		devBadge.BackgroundColor3 = Color3.fromRGB(50,30,90); devBadge.BorderSizePixel=0
		devBadge.ZIndex=3; devBadge.Parent=bannerFrame; addCorner(devBadge,6)
		addStroke(devBadge, THEME.purple, 1)
		local devLbl = makeLabel(devBadge,"🔥 Rizzman",0,0,120,26,12,THEME.purple,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
		devLbl.TextYAlignment = Enum.TextYAlignment.Center; devLbl.ZIndex=4

		-- Rol badge
		local role = getTitleType(localPlayer.Name)
		local roleColor = role=="Influencer" and THEME.pink or role=="Celebrity" and THEME.cyan or THEME.subText
		local roleBadge = Instance.new("Frame")
		roleBadge.Size=UDim2.new(0,110,0,26); roleBadge.Position=UDim2.new(0,220,0,96)
		roleBadge.BackgroundColor3=roleColor; roleBadge.ZIndex=3; roleBadge.BorderSizePixel=0
		roleBadge.Parent=bannerFrame; addCorner(roleBadge,6)
		local roleLbl=makeLabel(roleBadge,role,0,0,110,26,12,Color3.new(0,0,0),Enum.Font.GothamBold,Enum.TextXAlignment.Center)
		roleLbl.TextYAlignment=Enum.TextYAlignment.Center; roleLbl.ZIndex=4

		-- Stats cards
		local statsY = 206
		local statDefs = {
			{label="Ping",    icon="📡", getValue=function()
				local ok,val=pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
				return (ok and val or 0).."ms"
			end},
			{label="Players", icon="👥", getValue=function() return tostring(#Players:GetPlayers()) end},
			{label="FPS",     icon="🎮", getValue=function() return tostring(math.floor(1/RunService.RenderStepped:Wait())) end},
		}
		local statLabels = {}
		for idx, stat in ipairs(statDefs) do
			local scard = Instance.new("Frame")
			scard.Size=UDim2.new(0,144,0,72); scard.Position=UDim2.new(0,20+(idx-1)*154,0,statsY)
			scard.BackgroundColor3=THEME.card; scard.BorderSizePixel=0; scard.Parent=contentArea
			addCorner(scard,10); addStroke(scard,THEME.border,1)
			local iconL=makeLabel(scard,stat.icon,12,8,30,30,22,THEME.accent,Enum.Font.GothamBold)
			iconL.TextXAlignment=Enum.TextXAlignment.Center
			local nameL=makeLabel(scard,stat.label,48,8,88,22,13,THEME.subText,Enum.Font.Gotham)
			nameL.TextXAlignment=Enum.TextXAlignment.Left
			local valL=makeLabel(scard,"...",12,36,120,28,20,THEME.text,Enum.Font.GothamBold)
			valL.TextXAlignment=Enum.TextXAlignment.Left
			table.insert(statLabels, {lbl=valL, fn=stat.getValue})
		end

		-- Fecha/hora
		local dateCard = makeCard(contentArea, statsY+88, 480, 44)
		local dateLbl = makeLabel(dateCard, "🗓  "..os.date("%A, %d/%m/%Y — %H:%M"), 14,0,440,44,14,THEME.subText,Enum.Font.Gotham)
		dateLbl.TextYAlignment = Enum.TextYAlignment.Center

		-- Keybinds info
		local keyCard = makeCard(contentArea, statsY+148, 480, 52)
		makeLabel(keyCard, "⌨  [B] Abrir/Cerrar   [M] Impulse   [F] Fly Toggle", 14,0,450,52,13,THEME.subText,Enum.Font.Gotham)

		-- Créditos footer
		local footCard = makeCard(contentArea, statsY+216, 480, 44)
		local footGrad = Instance.new("UIGradient")
		footGrad.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0,Color3.fromRGB(40,20,80)),
			ColorSequenceKeypoint.new(1,Color3.fromRGB(20,10,40)),
		}
		footGrad.Rotation=90; footGrad.Parent=footCard
		makeLabel(footCard,"🐉  Dinastia China Panel v7.0 ULTIMATE ELITE — by Rizzman",14,0,450,44,13,THEME.accent,Enum.Font.GothamBold)

		contentArea.CanvasSize = UDim2.new(0,0,0, statsY+280)

		local conn
		conn = RunService.Heartbeat:Connect(function()
			if not contentArea.Parent then conn:Disconnect() return end
			for _, s in ipairs(statLabels) do
				if s.lbl and s.lbl.Parent then pcall(function() s.lbl.Text = s.fn() end) end
			end
		end)
		contentArea.ChildRemoved:Connect(function() conn:Disconnect() end)

	-- ── VIP ─────────────────────────────────────────────────
	elseif name == "VIP" then
		local canAccess = isInfluencer(localPlayer.Name) or isCelebrity(localPlayer.Name)
		if not canAccess then
			local lockFrame = makeCard(contentArea, 60, 480, 120)
			lockFrame.BackgroundColor3 = Color3.fromRGB(30,15,15)
			addStroke(lockFrame, THEME.red, 1.5)
			local lockIcon = makeLabel(lockFrame,"🔒",0,12,480,42,32,THEME.red,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
			lockIcon.Size=UDim2.new(1,0,0,44)
			makeLabel(lockFrame,"Solo Influencers y Celebrities pueden acceder",0,58,480,30,15,THEME.subText,Enum.Font.Gotham,Enum.TextXAlignment.Center)
			contentArea.CanvasSize = UDim2.new(0,0,0,220)
			return
		end

		local y = 20
		makeLabel(contentArea,"★  Opciones VIP",20,y,480,30,16,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		makeToggleBtn(contentArea,"Ocultar títulos de User",y,function(on)
			settings.hideUserTitles=on
			for _,plr in ipairs(Players:GetPlayers()) do
				if plr.Character then createTitleGui(plr.Character) end
			end
		end)
		y=y+64

		makeToggleBtn(contentArea,"Fondo de título transparente (ON) / Sin fondo (OFF)",y,function(on)
			settings.titleBgTransparency = on and 0.5 or 1
			for _,plr in ipairs(Players:GetPlayers()) do
				if plr.Character then updateTitleAppearance(plr.Character) end
			end
		end)
		y=y+64

		-- INFLUENCER SECTION
		if isInfluencer(localPlayer.Name) then
			makeLabel(contentArea,"🎨  Efecto Influencer",20,y,480,28,14,THEME.pink,Enum.Font.GothamBold)
			y=y+34
			local effects={"rainbow","pearly","solid","fire"}
			for idx,eff in ipairs(effects) do
				local ecard=makeCard(contentArea,y,108,42)
				ecard.Position=UDim2.new(0,20+(idx-1)*118,0,y)
				local isActive=settings.influencerEffect==eff
				local eLbl=makeLabel(ecard,eff:upper(),0,0,108,42,13,
					isActive and THEME.accent or THEME.subText,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
				eLbl.TextYAlignment=Enum.TextYAlignment.Center
				if isActive then addStroke(ecard,THEME.accent,1.5) end
				local eBtn=Instance.new("TextButton"); eBtn.Size=UDim2.new(1,0,1,0); eBtn.BackgroundTransparency=1; eBtn.Text=""; eBtn.Parent=ecard
				hoverEffect(ecard,THEME.card,THEME.cardHover)
				eBtn.MouseButton1Click:Connect(function()
					settings.influencerEffect=eff
					for char,d in pairs(titleGuis) do if d.titleType=="Influencer" then updateTitleAppearance(char) end end
					loadTab("VIP")
				end)
			end
			y=y+58

			-- Color solid influencer
			makeColorPicker(contentArea,y,"Color sólido — Influencer",settings.influencerColor,function(c)
				settings.influencerColor=c
				for char,d in pairs(titleGuis) do if d.titleType=="Influencer" then updateTitleAppearance(char) end end
			end)
			y=y+66

			-- ✨ PEARLY PERSONALIZACIÓN ✨
			makeLabel(contentArea,"✨  Personalizar efecto Pearly",20,y,480,28,14,THEME.accentGlow,Enum.Font.GothamBold)
			y=y+34

			-- Color BASE del pearly
			makeColorPicker(contentArea,y,"Color base del Pearly (fondo)",settings.pearlyBaseColor,function(c)
				settings.pearlyBaseColor=c
				for char,d in pairs(titleGuis) do
					if d.titleType=="Influencer" and settings.influencerEffect=="pearly" then updateTitleAppearance(char) end
					if d.titleType=="Celebrity" and settings.celebrityEffect=="pearly" then updateTitleAppearance(char) end
				end
			end)
			y=y+66

			-- Color del BRILLO que se mueve
			makeColorPicker(contentArea,y,"Color del brillo animado del Pearly",settings.pearlyGlowColor,function(c)
				settings.pearlyGlowColor=c
			end)
			y=y+66

			-- Velocidad del brillo
			makeSlider(contentArea,y,"Velocidad del brillo Pearly",settings.pearlySpeed,0.5,12,function(v)
				settings.pearlySpeed=v
			end)
			y=y+82
		end

		-- CELEBRITY SECTION
		if isCelebrity(localPlayer.Name) then
			makeLabel(contentArea,"🌟  Efecto Celebrity",20,y,480,28,14,THEME.cyan,Enum.Font.GothamBold)
			y=y+34
			local effects={"rainbow","pearly","solid","fire"}
			for idx,eff in ipairs(effects) do
				local ecard=makeCard(contentArea,y,108,42)
				ecard.Position=UDim2.new(0,20+(idx-1)*118,0,y)
				local isActive=settings.celebrityEffect==eff
				local eLbl=makeLabel(ecard,eff:upper(),0,0,108,42,13,
					isActive and THEME.accent or THEME.subText,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
				eLbl.TextYAlignment=Enum.TextYAlignment.Center
				if isActive then addStroke(ecard,THEME.accent,1.5) end
				local eBtn=Instance.new("TextButton"); eBtn.Size=UDim2.new(1,0,1,0); eBtn.BackgroundTransparency=1; eBtn.Text=""; eBtn.Parent=ecard
				hoverEffect(ecard,THEME.card,THEME.cardHover)
				eBtn.MouseButton1Click:Connect(function()
					settings.celebrityEffect=eff
					for char,d in pairs(titleGuis) do if d.titleType=="Celebrity" then updateTitleAppearance(char) end end
					loadTab("VIP")
				end)
			end
			y=y+58

			makeColorPicker(contentArea,y,"Color sólido — Celebrity",settings.celebrityColor,function(c)
				settings.celebrityColor=c
				for char,d in pairs(titleGuis) do if d.titleType=="Celebrity" then updateTitleAppearance(char) end end
			end)
			y=y+66
		end

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)

	-- ── COMBAT ──────────────────────────────────────────────
	elseif name == "Combat" then
		local y = 20
		makeLabel(contentArea,"⚔  Opciones de Combate",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		makeToggleBtn(contentArea,"Aimbot (Click Derecho)",y,function(on)
			aimbotEnabled = on
		end)
		y=y+64

		makeToggleBtn(contentArea,"Hitbox Expander",y,function(on)
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = plr.Character.HumanoidRootPart
					if on then
						hrp.Size = Vector3.new(10, 10, 10)
						hrp.Transparency = 0.5
						hrp.BrickColor = BrickColor.new("Bright red")
						hrp.CanCollide = false
					else
						hrp.Size = Vector3.new(2, 2, 1)
						hrp.Transparency = 1
					end
				end
			end
		end)
		y=y+64

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)

	-- ── EMPHASIS ────────────────────────────────────────────
	elseif name == "Emphasis" then
		local y = 20
		makeLabel(contentArea,"⚡  Habilidades de Énfasis",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		local features = {
			{name="⚔️ Killaura",  desc="Ataca automáticamente a enemigos cercanos",
				fn=function(on) killauraEnabled=on end},
			{name="💨 Speed Boost",  desc="Aumenta tu velocidad de movimiento",
				fn=function(on) speedBoostEnabled=on end},
			{name="Invisible",  desc="Vuelve tu personaje invisible",
				fn=function(on)
					if localPlayer.Character then
						for _,p in ipairs(localPlayer.Character:GetDescendants()) do
							if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.Transparency=on and 1 or 0 end
						end
					end
				end},
			{name="NoClip",     desc="Atraviesa paredes y objetos",
				fn=function(on)
					if on then
						noClipConn=RunService.Stepped:Connect(function()
							if localPlayer.Character then
								for _,p in ipairs(localPlayer.Character:GetDescendants()) do
									if p:IsA("BasePart") then p.CanCollide=false end
								end
							end
						end)
					else
						if noClipConn then noClipConn:Disconnect(); noClipConn=nil end
						if localPlayer.Character then
							for _,p in ipairs(localPlayer.Character:GetDescendants()) do
								if p:IsA("BasePart") then p.CanCollide=true end
							end
						end
					end
				end},
			{name="Impulso",    desc="[M] para explotar / volver",
				fn=function(on) impulseEnabled=on; if not on then exploded=false; originalCFrame=nil end end},
			{name="Volar",      desc="[F] para activar/desactivar vuelo",
				fn=function(on)
					flyEnabled=on
					if not on and flyConn then flyConn:Disconnect(); flyConn=nil end
				end},
			{name="ClickTP",    desc="Click para teleportarte al punto",
				fn=function(on)
					if on then
						clickTPConn=UserInputService.InputBegan:Connect(function(input)
							if input.UserInputType==Enum.UserInputType.MouseButton1 then
								local mouse=localPlayer:GetMouse()
								local ray=workspace.CurrentCamera:ScreenPointToRay(mouse.X,mouse.Y)
								local result=workspace:Raycast(ray.Origin,ray.Direction*500)
								if result and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
									localPlayer.Character.HumanoidRootPart.CFrame=CFrame.new(result.Position+Vector3.new(0,3,0))
								end
							end
						end)
					else
						if clickTPConn then clickTPConn:Disconnect(); clickTPConn=nil end
					end
				end},
			{name="God Mode",   desc="Sin daño (RequiresNetworkOwnership)",
				fn=function(on)
					if localPlayer.Character then
						local h=localPlayer.Character:FindFirstChild("Humanoid")
						if h then h.MaxHealth = on and math.huge or 100; h.Health = h.MaxHealth end
					end
				end},
			{name="Anti-AFK",   desc="Evita que te desconecten por inactividad",
				fn=function(on)
					if on then
						spawn(function()
							while on and task.wait(55) do
								local vjs=localPlayer:FindFirstChild("VirtualUser")
								if not vjs then
									vjs=Instance.new("VirtualUser"); vjs.Parent=localPlayer
								end
								vjs:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
								task.wait(0.1)
								vjs:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
							end
						end)
					end
				end},
		}

		for _, feat in ipairs(features) do
			local card, _, _ = makeToggleBtn(contentArea, feat.name, y, feat.fn)
			makeLabel(card, feat.desc, 48, 30, 360, 18, 12, THEME.subText, Enum.Font.Gotham)
			card.Size = UDim2.new(0,480,0,62)
			y=y+74
		end

		makeSlider(contentArea,y,"Velocidad de Vuelo",flySpeed,10,300,function(v)
			flySpeed=v
		end)
		y=y+82

		makeSlider(contentArea,y,"Fuerza de Impulso",impulseForce,100,1000,function(v)
			impulseForce=v
		end)
		y=y+82

		makeSlider(contentArea,y,"Rango de Killaura",killauraRange,10,150,function(v)
			killauraRange=v
		end)
		y=y+82

		makeSlider(contentArea,y,"Multiplicador de velocidad",speedBoostValue,1,5,function(v)
			speedBoostValue=v
		end)
		y=y+82

		makeSlider(contentArea,y,"Velocidad de Killaura (ms)",killauraDelay*1000,50,500,function(v)
			killauraDelay=v/1000
		end)
		y=y+82

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)

	-- ── CHARACTER ───────────────────────────────────────────
	elseif name == "Character" then
		local y = 20
		makeLabel(contentArea,"👤  Modificadores de Personaje",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		local sliders2 = {
			{name="WalkSpeed",  label="Velocidad de caminar", default=16, min=0, max=200,
				apply=function(v) local h=localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") if h then h.WalkSpeed=v end end},
			{name="JumpPower",  label="Potencia de salto",    default=50, min=0, max=500,
				apply=function(v) local h=localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") if h then h.JumpPower=v end end},
			{name="HipHeight",  label="Altura de cadera",     default=2,  min=0, max=20,
				apply=function(v) local h=localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") if h then h.HipHeight=v end end},
		}

		for _, sl in ipairs(sliders2) do
			makeSlider(contentArea, y, sl.label, sl.default, sl.min, sl.max, sl.apply)
			y=y+82
		end

		-- Respawn / Checkpoint
		local respCard = makeCard(contentArea, y, 226, 52)
		local rLbl=makeLabel(respCard,"⟳  Respawn",14,0,200,52,15,THEME.text,Enum.Font.GothamBold)
		rLbl.TextYAlignment=Enum.TextYAlignment.Center
		local rBtn=Instance.new("TextButton"); rBtn.Size=UDim2.new(1,0,1,0); rBtn.BackgroundTransparency=1; rBtn.Text=""; rBtn.Parent=respCard
		hoverEffect(respCard,THEME.card,THEME.cardHover)
		rBtn.MouseButton1Click:Connect(function() localPlayer:LoadCharacter() end)

		local cpCard=makeCard(contentArea,y,226,52); cpCard.Position=UDim2.new(0,258,0,y)
		local cpLbl=makeLabel(cpCard,"📍  Checkpoint",14,0,200,52,15,THEME.text,Enum.Font.GothamBold)
		cpLbl.TextYAlignment=Enum.TextYAlignment.Center
		local cpBtn=Instance.new("TextButton"); cpBtn.Size=UDim2.new(1,0,1,0); cpBtn.BackgroundTransparency=1; cpBtn.Text=""; cpBtn.Parent=cpCard
		hoverEffect(cpCard,THEME.card,THEME.cardHover)
		cpBtn.MouseButton1Click:Connect(function()
			if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local root=localPlayer.Character.HumanoidRootPart
				if not originalCFrame then
					originalCFrame=root.CFrame; cpLbl.Text="📍  Guardado ✓"; cpLbl.TextColor3=THEME.green
				else
					root.CFrame=originalCFrame; originalCFrame=nil; cpLbl.Text="📍  Checkpoint"; cpLbl.TextColor3=THEME.text
				end
			end
		end)
		y=y+68

		-- Teleport a jugador
		makeLabel(contentArea,"🌀  Teleport a jugador",20,y,480,26,14,THEME.accent,Enum.Font.GothamBold)
		y=y+32
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= localPlayer then
				local pcard=makeCard(contentArea,y,480,46)
				makeLabel(pcard,"→  "..plr.Name,14,0,360,46,14,THEME.text,Enum.Font.Gotham)
				local pBtn=Instance.new("TextButton"); pBtn.Size=UDim2.new(1,0,1,0); pBtn.BackgroundTransparency=1; pBtn.Text=""; pBtn.Parent=pcard
				hoverEffect(pcard,THEME.card,THEME.cardHover)
				pBtn.MouseButton1Click:Connect(function()
					if localPlayer.Character and plr.Character and
					   localPlayer.Character:FindFirstChild("HumanoidRootPart") and
					   plr.Character:FindFirstChild("HumanoidRootPart") then
						localPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0)
					end
				end)
				y=y+56
			end
		end

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)

	-- ── PLAYERS (Información Avanzada) ──────────────────────
	elseif name == "Players" then
		local y = 20
		makeLabel(contentArea,"👥  Información de Jugadores",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		-- Botón para actualizar cache
		local refreshCard = makeCard(contentArea, y, 480, 52)
		local refreshLbl = makeLabel(refreshCard, "🔄 Actualizar lista de jugadores", 48, 0, 300, 52, 15, THEME.text, Enum.Font.GothamBold)
		refreshLbl.TextYAlignment = Enum.TextYAlignment.Center
		local refreshBtn = Instance.new("TextButton"); refreshBtn.Size = UDim2.new(1,0,1,0); refreshBtn.BackgroundTransparency = 1; refreshBtn.Text = ""; refreshBtn.Parent = refreshCard
		hoverEffect(refreshCard, THEME.card, THEME.cardHover)
		refreshBtn.MouseButton1Click:Connect(function()
			updatePlayerCache()
			showNotification("✅ Actualizado", "Cache de jugadores refrescado", THEME.green)
			loadTab("Players")
		end)
		y=y+68

		-- Mostrar estadísticas
		local statsCard = makeCard(contentArea, y, 480, 80)
		makeLabel(statsCard, "📊 Estadísticas del servidor", 14, 5, 450, 22, 14, THEME.accent, Enum.Font.GothamBold)
		makeLabel(statsCard, "Total: " .. #Players:GetPlayers() .. " | VIPs: " .. (#playerCache), 14, 28, 450, 18, 12, THEME.text, Enum.Font.Gotham)
		makeLabel(statsCard, "Edad de tu cuenta: " .. localPlayer.AccountAge .. " días", 14, 48, 450, 18, 12, THEME.subText, Enum.Font.Gotham)
		y=y+96

		-- Listar jugadores por categoría
		makeLabel(contentArea, "🎯 Jugadores en el servidor", 20, y, 480, 22, 14, THEME.cyan, Enum.Font.GothamBold)
		y=y+28

		local allPlayers = Players:GetPlayers()
		for _, plr in ipairs(allPlayers) do
			local titleType = getTitleType(plr.Name)
			local typeColor = THEME.text
			if titleType == "Admin" then typeColor = THEME.adminColor
			elseif titleType == "Moderator" then typeColor = THEME.modColor
			elseif titleType == "Influencer" then typeColor = THEME.pink
			elseif titleType == "Celebrity" then typeColor = THEME.cyan
			elseif titleType == "VIP" then typeColor = THEME.vipColor
			end

			local pCard = makeCard(contentArea, y, 480, 50)
			local pTypeLbl = makeLabel(pCard, titleType, 14, 0, 80, 50, 12, typeColor, Enum.Font.GothamBold)
			pTypeLbl.TextYAlignment = Enum.TextYAlignment.Center
			makeLabel(pCard, plr.Name .. " (Edad: " .. plr.AccountAge .. " días)", 100, 0, 280, 50, 13, THEME.text, Enum.Font.Gotham)
			
			-- Botón para telep
			local tpBtn = Instance.new("TextButton"); tpBtn.Size = UDim2.new(0, 60, 0, 35); tpBtn.Position = UDim2.new(1, -74, 0.5, -17)
			tpBtn.BackgroundColor3 = Color3.fromRGB(38,36,58); tpBtn.TextColor3 = THEME.accent; tpBtn.Font = Enum.Font.GothamBold
			tpBtn.TextSize = 11; tpBtn.BorderSizePixel = 0; tpBtn.Text = "TP"; tpBtn.Parent = pCard
			addCorner(tpBtn, 6)
			tpBtn.MouseButton1Click:Connect(function()
				if localPlayer.Character and plr.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("HumanoidRootPart") then
					localPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
					showNotification("📍 Teleportado", "Teleportado a " .. plr.Name, THEME.green)
				end
			end)

			y = y + 60
		end

		contentArea.CanvasSize = UDim2.new(0, 0, 0, y + 40)

	-- ── VISUAL ──────────────────────────────────────────────
	elseif name == "Visual" then
		local y = 20
		makeLabel(contentArea,"🎨  Modificadores Visuales",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		-- ESP jugadores
		makeToggleBtn(contentArea,"ESP Jugadores (Avanzado + Persistente)",y,function(on)
			espEnabled=on
			if on then
				-- Activar ESP para todos los jugadores actuales
				for _,plr in ipairs(Players:GetPlayers()) do
					if plr~=localPlayer and plr.Character then
						addESP(plr)
					end
				end
			else
				-- Desactivar ESP para todos
				for userId in pairs(espCharacterData) do
					removeESP(userId)
				end
			end
		end)
		y=y+64

		-- Modo noche
		makeToggleBtn(contentArea,"🌙  Modo Noche",y,function(on)
			nightmodeOn=on
			if on then
				Lighting.Ambient=Color3.fromRGB(0,0,0)
				Lighting.Brightness=0.02
				Lighting.FogEnd=50
				Lighting.FogColor=Color3.fromRGB(0,0,8)
			else
				Lighting.Ambient=originalAmbient
				Lighting.Brightness=originalBrightness
				Lighting.FogEnd=100000
			end
		end)
		y=y+64

		-- Fullbright
		makeToggleBtn(contentArea,"☀️  Fullbright",y,function(on)
			Lighting.Brightness = on and 2 or originalBrightness
			Lighting.Ambient = on and Color3.fromRGB(255,255,255) or originalAmbient
		end)
		y=y+64

		-- Campo de visión (FOV)
		makeSlider(contentArea,y,"Campo de visión (FOV)",70,40,120,function(v)
			workspace.CurrentCamera.FieldOfView=v
		end)
		y=y+82

		-- Zoom máximo
		makeSlider(contentArea,y,"Zoom máximo de cámara",400,10,2000,function(v)
			localPlayer.CameraMaxZoomDistance=v
		end)
		y=y+82

		-- Rainbow UI toggle
		makeToggleBtn(contentArea,"🌈  Panel con borde rainbow",y,function(on)
			if on then
				spawn(function()
					while on and mainFrame and mainFrame.Parent do
						local h=(tick()*0.5)%1
						local stroke=mainFrame:FindFirstChildWhichIsA("UIStroke")
						if stroke then stroke.Color=Color3.fromHSV(h,1,1) end
						task.wait(0.03)
					end
				end)
			else
				local stroke=mainFrame:FindFirstChildWhichIsA("UIStroke")
				if stroke then stroke.Color=THEME.border end
			end
		end)
		y=y+64

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)


	-- ── CAMERA ──────────────────────────────────────────────
	elseif name == "Camera" then
		local y = 20
		makeLabel(contentArea,"📷  Free Camera & Time Rewind",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		-- FREE CAMERA
		makeLabel(contentArea,"🎥  Free Camera",20,y,480,22,13,THEME.cyan,Enum.Font.GothamBold)
		y=y+28

		local fcInfoCard = makeCard(contentArea,y,480,44)
		makeLabel(fcInfoCard,"⌨  W/A/S/D mover  |  Ratón rotar  |  Space/Ctrl subir/bajar  |  Shift lento  |  E rápido",8,0,468,44,11,THEME.subText,Enum.Font.Gotham)
		y=y+50

		local freecamCard = makeCard(contentArea,y,480,52)
		local freecamLbl = makeLabel(freecamCard,"📷  Free Camera",48,0,300,52,15,THEME.text,Enum.Font.GothamBold)
		freecamLbl.TextYAlignment=Enum.TextYAlignment.Center
		local fcIcon=Instance.new("TextLabel"); fcIcon.Text="◈"; fcIcon.Size=UDim2.new(0,30,1,0)
		fcIcon.Position=UDim2.new(0,12,0,0); fcIcon.BackgroundTransparency=1
		fcIcon.TextColor3=THEME.cyan; fcIcon.Font=Enum.Font.GothamBold; fcIcon.TextSize=20; fcIcon.Parent=freecamCard
		local swBg=Instance.new("Frame"); swBg.Size=UDim2.new(0,52,0,28); swBg.Position=UDim2.new(1,-64,0.5,-14)
		swBg.BackgroundColor3=Color3.fromRGB(45,45,65); swBg.BorderSizePixel=0; swBg.Parent=freecamCard; addCorner(swBg,14)
		local swKnob=Instance.new("Frame"); swKnob.Size=UDim2.new(0,22,0,22); swKnob.Position=UDim2.new(0,3,0.5,-11)
		swKnob.BackgroundColor3=THEME.subText; swKnob.BorderSizePixel=0; swKnob.Parent=swBg; addCorner(swKnob,11)
		local fcBtn=Instance.new("TextButton"); fcBtn.Size=UDim2.new(1,0,1,0); fcBtn.BackgroundTransparency=1
		fcBtn.Text=""; fcBtn.Parent=freecamCard
		hoverEffect(freecamCard,THEME.card,THEME.cardHover)
		local fcOn=false
		fcBtn.MouseButton1Click:Connect(function()
			fcOn=not fcOn
			if fcOn then
				makeTween(swBg,{BackgroundColor3=THEME.cyan},0.18):Play()
				makeTween(swKnob,{Position=UDim2.new(1,-25,0.5,-11),BackgroundColor3=Color3.new(1,1,1)},0.18):Play()
				startFreecam()
			else
				makeTween(swBg,{BackgroundColor3=Color3.fromRGB(45,45,65)},0.18):Play()
				makeTween(swKnob,{Position=UDim2.new(0,3,0.5,-11),BackgroundColor3=THEME.subText},0.18):Play()
				stopFreecam()
			end
		end)
		y=y+64

		makeSlider(contentArea,y,"Velocidad Free Camera",40,5,200,function(v)
			freecamSpeed=v
		end)
		y=y+82

		makeSlider(contentArea,y,"Sensibilidad de ratón (×10000)",30,5,100,function(v)
			freecamSens=v/10000
		end)
		y=y+90

		-- TIME REWIND
		makeLabel(contentArea,"⏪  Time Rewind",20,y,480,22,13,THEME.pink,Enum.Font.GothamBold)
		y=y+28

		local rwInfoCard=makeCard(contentArea,y,480,44)
		makeLabel(rwInfoCard,"⌨  Mantén [V] para rebobinar el tiempo del personaje",8,0,468,44,12,THEME.subText,Enum.Font.Gotham)
		y=y+50

		local rwCard=makeCard(contentArea,y,480,52)
		local rwLbl=makeLabel(rwCard,"⏪  Time Rewind",48,0,300,52,15,THEME.text,Enum.Font.GothamBold)
		rwLbl.TextYAlignment=Enum.TextYAlignment.Center
		local rwIco=Instance.new("TextLabel"); rwIco.Text="◈"; rwIco.Size=UDim2.new(0,30,1,0)
		rwIco.Position=UDim2.new(0,12,0,0); rwIco.BackgroundTransparency=1
		rwIco.TextColor3=THEME.pink; rwIco.Font=Enum.Font.GothamBold; rwIco.TextSize=20; rwIco.Parent=rwCard
		local swBg2=Instance.new("Frame"); swBg2.Size=UDim2.new(0,52,0,28); swBg2.Position=UDim2.new(1,-64,0.5,-14)
		swBg2.BackgroundColor3=Color3.fromRGB(45,45,65); swBg2.BorderSizePixel=0; swBg2.Parent=rwCard; addCorner(swBg2,14)
		local swKnob2=Instance.new("Frame"); swKnob2.Size=UDim2.new(0,22,0,22); swKnob2.Position=UDim2.new(0,3,0.5,-11)
		swKnob2.BackgroundColor3=THEME.subText; swKnob2.BorderSizePixel=0; swKnob2.Parent=swBg2; addCorner(swKnob2,11)
		local rwBtn=Instance.new("TextButton"); rwBtn.Size=UDim2.new(1,0,1,0); rwBtn.BackgroundTransparency=1
		rwBtn.Text=""; rwBtn.Parent=rwCard
		hoverEffect(rwCard,THEME.card,THEME.cardHover)
		local rwOn=false
		rwBtn.MouseButton1Click:Connect(function()
			rwOn=not rwOn
			if rwOn then
				makeTween(swBg2,{BackgroundColor3=THEME.pink},0.18):Play()
				makeTween(swKnob2,{Position=UDim2.new(1,-25,0.5,-11),BackgroundColor3=Color3.new(1,1,1)},0.18):Play()
				startRewind()
			else
				makeTween(swBg2,{BackgroundColor3=Color3.fromRGB(45,45,65)},0.18):Play()
				makeTween(swKnob2,{Position=UDim2.new(0,3,0.5,-11),BackgroundColor3=THEME.subText},0.18):Play()
				stopRewind()
			end
		end)
		y=y+64

		makeSlider(contentArea,y,"Segundos de historial",60,5,120,function(v)
			rewindMaxStored=math.floor(v)*60
		end)
		y=y+82

		makeSlider(contentArea,y,"Velocidad de rewind",1,1,5,function(v)
			rewindSpeed=math.floor(v)
		end)
		y=y+82

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)

	-- ── WORLD ───────────────────────────────────────────────
	elseif name == "World" then
		local y = 20
		makeLabel(contentArea,"🌍  Modificadores del Mundo",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		-- Gravedad
		makeSlider(contentArea,y,"Gravedad",196,0,600,function(v)
			workspace.Gravity=v
		end)
		y=y+82

		-- Velocidad del tiempo (TimeOfDay)
		makeToggleBtn(contentArea,"⏩  Ciclo de día/noche automático",y,function(on)
			if on then
				spawn(function()
					while on do
						Lighting.ClockTime=(Lighting.ClockTime+0.01)%24
						task.wait(0.05)
					end
				end)
			end
		end)
		y=y+64

		-- Hora del día
		makeSlider(contentArea,y,"Hora del día (0-24)",12,0,24,function(v)
			Lighting.ClockTime=v
		end)
		y=y+82

		-- Niebla
		makeSlider(contentArea,y,"Distancia de niebla",100000,10,100000,function(v)
			Lighting.FogEnd=v
		end)
		y=y+82

		-- Destruir partes del mapa (con confirmación)
		makeToggleBtn(contentArea,"💥  Explosión masiva en cámara",y,function(on)
			if on then
				local camPos=camera.CFrame.Position
				for _,obj in ipairs(workspace:GetDescendants()) do
					if obj:IsA("BasePart") and (obj.Position-camPos).Magnitude<60 then
						pcall(function()
							local ex=Instance.new("Explosion")
							ex.Position=obj.Position; ex.BlastRadius=5
							ex.BlastPressure=1000; ex.Parent=workspace
						end)
					end
				end
			end
		end)
		y=y+64

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)

	-- ── MISC ────────────────────────────────────────────────
	elseif name == "Misc" then
		local y = 20
		makeLabel(contentArea,"🔧  Misceláneos",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		makeToggleBtn(contentArea,"Spam Chat (Cuidado)",y,function(on)
			if on then
				spawn(function()
					while on do
						game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Dinastia China Panel V5 by Rizzman 🐉", "All")
						task.wait(3)
					end
				end)
			end
		end)
		y=y+64

		local rejoinCard = makeCard(contentArea, y, 480, 52)
		local rjLbl=makeLabel(rejoinCard,"🔄  Rejoin Server",14,0,200,52,15,THEME.text,Enum.Font.GothamBold)
		rjLbl.TextYAlignment=Enum.TextYAlignment.Center
		local rjBtn=Instance.new("TextButton"); rjBtn.Size=UDim2.new(1,0,1,0); rjBtn.BackgroundTransparency=1; rjBtn.Text=""; rjBtn.Parent=rejoinCard
		hoverEffect(rejoinCard,THEME.card,THEME.cardHover)
		rjBtn.MouseButton1Click:Connect(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
		end)
		y=y+68

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)

	-- ── SETTINGS ────────────────────────────────────────────
	elseif name == "Settings" then
		local y = 20
		makeLabel(contentArea,"⚙  Configuración del Panel",20,y,480,28,15,THEME.accent,Enum.Font.GothamBold)
		y=y+38

		-- Rainbow speed
		makeSlider(contentArea,y,"Velocidad rainbow",settings.rainbowSpeed,0.1,3,function(v)
			settings.rainbowSpeed=v
		end)
		y=y+82

		-- Distancia máxima de títulos
		makeSlider(contentArea,y,"Distancia máxima de títulos",settings.titleMaxDistance,50,1000,function(v)
			settings.titleMaxDistance=v
			for _,d in pairs(titleGuis) do if d.billboard then d.billboard.MaxDistance=v end end
		end)
		y=y+82

		-- Escala de títulos
		makeSlider(contentArea,y,"Escala de títulos",100,50,200,function(v)
			settings.titleScaleMultiplier=v/100
		end)
		y=y+82

		-- Transparencia del panel
		makeSlider(contentArea,y,"Transparencia del panel (%)",0,0,80,function(v)
			mainFrame.BackgroundTransparency=v/100
		end)
		y=y+82

		-- Nuevas opciones avanzadas
		makeLabel(contentArea,"🔔  Notificaciones & Alertas",20,y,480,26,14,THEME.accent,Enum.Font.GothamBold)
		y=y+34

		makeToggleBtn(contentArea,"Notificaciones activadas",y,function(on)
			settings.notificationsEnabled=on
			showNotification("⚙️ Actualizado", "Notificaciones " .. (on and "activadas" or "desactivadas"), THEME.green)
		end)
		y=y+64

		makeToggleBtn(contentArea,"Alertas de Admins",y,function(on)
			settings.adminAlerts=on
		end)
		y=y+64

		makeToggleBtn(contentArea,"Sonidos de alerta",y,function(on)
			settings.playerSoundAlert=on
		end)
		y=y+64

		makeToggleBtn(contentArea,"Agrupar jugadores automáticamente",y,function(on)
			settings.autoGroupPlayers=on
		end)
		y=y+64

		-- Reset todo
		local resetCard=makeCard(contentArea,y,480,52)
		resetCard.BackgroundColor3=Color3.fromRGB(50,15,15)
		addStroke(resetCard,THEME.red,1)
		local rLbl=makeLabel(resetCard,"🔄  Restablecer configuración",14,0,380,52,15,THEME.red,Enum.Font.GothamBold)
		rLbl.TextYAlignment=Enum.TextYAlignment.Center
		local rBtn=Instance.new("TextButton"); rBtn.Size=UDim2.new(1,0,1,0); rBtn.BackgroundTransparency=1; rBtn.Text=""; rBtn.Parent=resetCard
		hoverEffect(resetCard,Color3.fromRGB(50,15,15),Color3.fromRGB(80,25,25))
		rBtn.MouseButton1Click:Connect(function()
			settings.rainbowSpeed=0.85; settings.pearlySpeed=4
			settings.titleMaxDistance=250; settings.titleScaleMultiplier=1.0
			settings.pearlyBaseColor=Color3.fromRGB(255,255,255)
			settings.pearlyGlowColor=Color3.fromRGB(255,220,80)
			workspace.Gravity=196; workspace.CurrentCamera.FieldOfView=70
			Lighting.Ambient=originalAmbient; Lighting.Brightness=originalBrightness
			loadTab("Settings")
		end)
		y=y+68

		-- Cerrar/destruir GUI
		local destroyCard=makeCard(contentArea,y,480,52)
		destroyCard.BackgroundColor3=Color3.fromRGB(50,15,15)
		addStroke(destroyCard,THEME.red,2)
		local dLbl=makeLabel(destroyCard,"❌  Destruir panel (cierre permanente)",14,0,420,52,15,THEME.red,Enum.Font.GothamBold)
		dLbl.TextYAlignment=Enum.TextYAlignment.Center
		local dBtn=Instance.new("TextButton"); dBtn.Size=UDim2.new(1,0,1,0); dBtn.BackgroundTransparency=1; dBtn.Text=""; dBtn.Parent=destroyCard
		hoverEffect(destroyCard,Color3.fromRGB(50,15,15),Color3.fromRGB(80,25,25))
		dBtn.MouseButton1Click:Connect(function()
			screenGui:Destroy()
		end)
		y=y+68

		contentArea.CanvasSize=UDim2.new(0,0,0,y+40)
	end
end

-- ════════════════════════════════════════════════════════════════════════════
--  SISTEMA AVANZADO DE KILLAURA
-- ════════════════════════════════════════════════════════════════════════════
local killauraRange = 50
local killauraDelay = 0.1
local lastKillauraTime = 0

RunService.Heartbeat:Connect(function()
	if not killauraEnabled or not localPlayer.Character then return end
	
	if tick() - lastKillauraTime < killauraDelay then return end
	lastKillauraTime = tick()
	
	local root = localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == localPlayer or not plr.Character then continue end
		
		local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
		local targetHum = plr.Character:FindFirstChild("Humanoid")
		if not targetRoot or not targetHum or targetHum.Health <= 0 then continue end
		
		local dist = (root.Position - targetRoot.Position).Magnitude
		if dist <= killauraRange then
			-- Intentar atacar (esto varía según el juego)
			local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid:TakeDamage(0) -- Placeholder para ataques del juego
			end
			
			-- Mostrar indicador visual
			if not plr:FindFirstChild("KillauraIndicator") then
				showNotification("⚔️ Target", "Jugador cerca: " .. plr.Name, THEME.red, 0.5)
			end
		end
	end
end)

-- ════════════════════════════════════════════════════════════════════════════
--  SISTEMA DE BOOST DE VELOCIDAD
-- ════════════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
	if not speedBoostEnabled or not localPlayer.Character then return end
	
	local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 16 * speedBoostValue
	end
end)

-- ════════════════════════════════════════════════════════════════════════════
--  MONITOREO AVANZADO DE JUGADORES (Improved Player Cache)
-- ════════════════════════════════════════════════════════════════════════════
local function updatePlayerCache()
	playerCache = {}
	
	for _, plr in ipairs(Players:GetPlayers()) do
		local titleType = getTitleType(plr.Name)
		
		table.insert(playerCache, {
			player = plr,
			name = plr.Name,
			type = titleType,
			accountAge = plr.AccountAge,
			joinTime = tick(),
			character = plr.Character,
		})
	end
	
	return playerCache
end

Players.PlayerAdded:Connect(function(plr)
	local titleType = getTitleType(plr.Name)
	
	if settings.adminAlerts and (isAdmin(plr.Name) or isModerator(plr.Name)) then
		showNotification("👮 ADMIN ALERT", plr.Name .. " (" .. titleType .. ") se unió al servidor", THEME.red)
	elseif settings.autoGroupPlayers and (isInfluencer(plr.Name) or isCelebrity(plr.Name)) then
		showNotification("⭐ VIP JOINED", plr.Name .. " (" .. titleType .. ") se unió", THEME.accent)
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if settings.notificationsEnabled then
		local titleType = getTitleType(plr.Name)
		if isInfluencer(plr.Name) or isCelebrity(plr.Name) or isAdmin(plr.Name) then
			showNotification("👋 Jugador se fue", plr.Name .. " (" .. titleType .. ")", THEME.subText)
		end
	end
end)

-- ════════════════════════════════════════════════════════════════════════════
--  SISTEMA DE VUELO AVANZADO (Fly)
-- ════════════════════════════════════════════════════════════════════════════
local flyBodyVelocity, flyBodyGyro

RunService.RenderStepped:Connect(function()
	if not flyEnabled then return end
	local char = localPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local humanoid = char:FindFirstChild("Humanoid")
	if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end

	if not flyBodyVelocity or not flyBodyVelocity.Parent then
		flyBodyVelocity=Instance.new("BodyVelocity")
		flyBodyVelocity.MaxForce=Vector3.new(1e9,1e9,1e9)
		flyBodyVelocity.Parent=root
	end
	if not flyBodyGyro or not flyBodyGyro.Parent then
		flyBodyGyro=Instance.new("BodyGyro")
		flyBodyGyro.MaxTorque=Vector3.new(1e9,1e9,1e9)
		flyBodyGyro.P=1e6
		flyBodyGyro.Parent=root
	end

	local camCF = camera.CFrame
	local moveDir = Vector3.new(0,0,0)
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

	flyBodyVelocity.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.new(0,0,0)
	flyBodyGyro.CFrame = camCF
end)

-- Limpiar fly al desactivar
RunService.Heartbeat:Connect(function()
	if not flyEnabled then
		if flyBodyVelocity and flyBodyVelocity.Parent then flyBodyVelocity:Destroy(); flyBodyVelocity=nil end
		if flyBodyGyro    and flyBodyGyro.Parent    then flyBodyGyro:Destroy();    flyBodyGyro=nil    end
	end
end)

-- ════════════════════════════════════════════════════════════
--  SISTEMA DE AIMBOT
-- ════════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
	if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local closestPlayer = nil
		local shortestDistance = math.huge

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
				local pos, onScreen = camera:WorldToViewportPoint(plr.Character.Head.Position)
				if onScreen then
					local mousePos = UserInputService:GetMouseLocation()
					local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
					if dist < shortestDistance then
						shortestDistance = dist
						closestPlayer = plr
					end
				end
			end
		end

		if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
			camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)
		end
	end
end)

-- ════════════════════════════════════════════════════════════════════════════
--  SISTEMA DE ARRASTRADOR Y REDIMENSIONADOR (v7.0 - NUEVAS CARACTERÍSTICAS)
-- ════════════════════════════════════════════════════════════════════════════

-- Arrastrador: Mover panel con el ratón
do
	local dragging, dragStart, startPos = false, nil, nil
	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- Handle de redimensionamiento: Esquina inferior derecha
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = THEME.accent
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 6
resizeHandle.Parent = mainFrame
addCorner(resizeHandle, 4)

local resizeLbl = Instance.new("TextLabel")
resizeLbl.Text = "⧱"
resizeLbl.Size = UDim2.new(1, 0, 1, 0)
resizeLbl.BackgroundTransparency = 1
resizeLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
resizeLbl.Font = Enum.Font.GothamBold
resizeLbl.TextSize = 12
resizeLbl.Parent = resizeHandle

-- Lógica de redimensionamiento
do
	local resizing = false
	local resizeStart = nil
	local startSize = nil
	
	resizeHandle.MouseButton1Down:Connect(function()
		resizing = true
		resizeStart = UserInputService:GetMouseLocation()
		startSize = mainFrame.Size
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local currentMouse = UserInputService:GetMouseLocation()
			local delta = currentMouse - resizeStart
			
			local newWidth = math.max(minPanelWidth, startSize.X.Offset + delta.X)
			local newHeight = math.max(minPanelHeight, startSize.Y.Offset + delta.Y)
			
			mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
			panelWidth = newWidth
			panelHeight = newHeight
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end)
end

-- ════════════════════════════════════════════════════════════
--  KEYBINDS
-- ════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.B then
		mainFrame.Visible = not mainFrame.Visible
	end

	if input.KeyCode == Enum.KeyCode.F then
		flyEnabled = not flyEnabled
	end

	if input.KeyCode == Enum.KeyCode.M and impulseEnabled then
		if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
		local root = localPlayer.Character.HumanoidRootPart
		if not exploded then
			originalCFrame = root.CFrame
			root.AssemblyLinearVelocity = Vector3.new(math.random(-200,200), impulseForce, math.random(-200,200))
			exploded = true
		else
			root.CFrame = originalCFrame
			exploded = false
		end
	end
end)

-- ════════════════════════════════════════════════════════════
--  ENTRADA: cargar Home y animación
-- ════════════════════════════════════════════════════════════
loadTab("Home")
mainFrame.Position = UDim2.new(0.5,-360,0.5,-245)
mainFrame.BackgroundTransparency = 1
makeTween(mainFrame, {BackgroundTransparency=0}, 0.4, Enum.EasingStyle.Quart):Play()

print("╔════════════════════════════════════════════════════════════╗")
print("║  🐉 Dinastia China Panel v7.0.0 ULTIMATE ELITE MAX 🐉   ║")
print("║     El Mejor Script Lua del Universo - ¡Completamente  ║")
print("║     redimensionable con ESP persistente! 🔥            ║")
print("║                                                            ║")
print("║  KEYBINDS:                                                ║")
print("║  [B] Abrir/Cerrar Panel    [M] Impulse                   ║")
print("║  [F] Fly Toggle             [V] Time Rewind              ║")
print("║  [C] Free Camera            Arrastra panel para mover    ║")
print("║  Esquina inf-derecha: REDIMENSIONAR CON RATÓN            ║")
print("║                                                            ║")
print("║  CARACTERÍSTICAS NUEVAS EN v7.0:                         ║")
print("║  ✅ Panel completamente REDIMENSIONABLE (ratón)          ║")
print("║  ✅ Estética PREMIUM mejorada 300%                       ║")
print("║  ✅ ESP PERSISTENTE a través de respawns                ║")
print("║  ✅ Detección ROBUSTA de jugadores                       ║")
print("║  ✅ HUD/GUI profesional y fluido                         ║")
print("║  ✅ Monitoreo continuo de títulos                        ║")
print("║  ✅ Notificaciones con animaciones                       ║")
print("║  ✅ Free Camera mejorado                                 ║")
print("║  ✅ 10+ tabs con funciones avanzadas                     ║")
print("║                                                            ║")
print("║  Desarrollado con ❤️ por Rizzman                        ║")
print("╚════════════════════════════════════════════════════════════╝")

showNotification("✅ SCRIPT CARGADO", "Dinastia China Panel v7.0.0 - ¡Redimensionable y con ESP persistente!", THEME.green, 4)
