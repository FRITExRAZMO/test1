--update
local Testing = false

-- Vérification des alts
if table.find(getgenv().Alts, game.Players.LocalPlayer.UserId) then
	getgenv().PointInTable = table.find(getgenv().Alts, game.Players.LocalPlayer.UserId)
else
	return
end

if game.Players.LocalPlayer.Name == getgenv().HostUser or getgenv().Executed then
	return
end

-- Configuration initiale
UserSettings().GameSettings.MasterVolume = 0
local Crashed = false

if Testing == false then
	-- Interface utilisateur simple et compatible
	local main = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local TitleLabel = Instance.new("TextLabel")
	local StatusLabel = Instance.new("TextLabel")
	local HostLabel = Instance.new("TextLabel")
	local InfoLabel = Instance.new("TextLabel")

	main.Name = "AltStatusUI"
	main.Parent = game.CoreGui
	main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Frame.Parent = main
	Frame.AnchorPoint = Vector2.new(0, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	Frame.BorderColor3 = Color3.fromRGB(0, 255, 127)
	Frame.BorderSizePixel = 2
	Frame.Position = UDim2.new(0, 20, 0, 20)
	Frame.Size = UDim2.new(0, 350, 0, 150)

	TitleLabel.Parent = Frame
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 15, 0, 10)
	TitleLabel.Size = UDim2.new(1, -30, 0, 30)
	TitleLabel.Font = Enum.Font.Gotham
	TitleLabel.Text = "ALT SYSTEM ACTIVE"
	TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	StatusLabel.Parent = Frame
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Position = UDim2.new(0, 15, 0, 45)
	StatusLabel.Size = UDim2.new(1, -30, 0, 20)
	StatusLabel.Font = Enum.Font.Gotham
	StatusLabel.Text = "Alt: " .. game.Players.LocalPlayer.Name
	StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	StatusLabel.TextSize = 14
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

	HostLabel.Parent = Frame
	HostLabel.BackgroundTransparency = 1
	HostLabel.Position = UDim2.new(0, 15, 0, 70)
	HostLabel.Size = UDim2.new(1, -30, 0, 20)
	HostLabel.Font = Enum.Font.Gotham
	HostLabel.Text = "Host: " .. getgenv().HostUser
	HostLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	HostLabel.TextSize = 14
	HostLabel.TextXAlignment = Enum.TextXAlignment.Left

	InfoLabel.Parent = Frame
	InfoLabel.BackgroundTransparency = 1
	InfoLabel.Position = UDim2.new(0, 15, 0, 95)
	InfoLabel.Size = UDim2.new(1, -30, 0, 40)
	InfoLabel.Font = Enum.Font.Gotham
	InfoLabel.Text = "Waiting for commands...\nPrefix: ?"
	InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	InfoLabel.TextSize = 12
	InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
	InfoLabel.TextYAlignment = Enum.TextYAlignment.Top

	-- Animation de clignotement pour la bordure
	spawn(function()
		while true do
			Frame.BorderColor3 = Color3.fromRGB(0, 255, 127)
			wait(1)
			Frame.BorderColor3 = Color3.fromRGB(0, 200, 100)
			wait(1)
		end
	end)

	-- Attendre le chargement complet du jeu
	if not game:IsLoaded() then
		repeat wait(.1) until game:IsLoaded() 
	end

	-- Anti-AFK
	local vu = game:GetService("VirtualUser")
	game:GetService("Players").LocalPlayer.Idled:connect(function()
		vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end)

	-- Optimisation des performances (mais garde le rendu 3D actif)
	setfpscap(30)
end

-- Chargement de l'anti-cheat bypass
loadstring(game:HttpGet("https://raw.githubusercontent.com/MsorkyScripts/OpenSourceAntiCheat/main/AntiCheatBypass.txt"))()
getgenv().Executed = true

--// Variables principales --//
local Connections = {}
local Services = {
	["RP"] = game:GetService("ReplicatedStorage"),
	["Players"] = game:GetService("Players"),
}

local Variables = {
	HostUser = getgenv().HostUser,
	Player = game.Players.LocalPlayer,
}

local Host = Services["Players"]:FindFirstChild(Variables["HostUser"])

if not Host then
	print("Host is not here waiting for him to join!")
	Services["Players"]:WaitForChild(Variables["HostUser"], 9e9)
	Host = Services["Players"]:FindFirstChild(Variables["HostUser"])
end

print("Script loaded!")
local CmdSettings = {}

--// Fonctions principales --//

-- Fonction Drop améliorée (15k au lieu de 10k)
local function Drop(Type)
	if Type == true and CmdSettings["Dropping"] == nil then
		CmdSettings["Dropping"] = true
		while CmdSettings["Dropping"] do
			local args = {
				[1] = "DropMoney",
				[2] = "15000"  -- Changé de 10000 à 15000
			}
			game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
			wait(2.5)
		end
	elseif Type == false then
		CmdSettings["Dropping"] = nil
	end
end

-- Fonction AirLock
local function AirLock(Type)
	if CmdSettings["AirLock"] == nil and Type == true then
		local BP = Variables["Player"].Character.HumanoidRootPart:FindFirstChild("AirLockBP")
		if BP then
			BP:Destroy()
		end
		CmdSettings["AirLock"] = true
		Variables["Player"].Character.HumanoidRootPart.CFrame = Variables["Player"].Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
		local BP = Instance.new("BodyPosition", Variables["Player"].Character.HumanoidRootPart)
		BP.Name = "AirLockBP"
		BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BP.Position = Variables["Player"].Character.HumanoidRootPart.Position
	elseif CmdSettings["AirLock"] == true and Type == false then
		CmdSettings["AirLock"] = nil
		local BP = Variables["Player"].Character.HumanoidRootPart:FindFirstChild("AirLockBP")
		if BP then
			BP:Destroy()
		end
	end
end

-- Fonction pour trouver un joueur par nom
local function GetPlayerFromString(str, ignore)
	for i, Targ in pairs(game.Players:GetPlayers()) do 
		if not ignore and Targ == Variables["Player"] then
			continue
		end
		if Targ.Name:lower():sub(1, #str) == str:lower() or Targ.DisplayName:lower():sub(1, #str) == str:lower() then
			return Targ
		end
	end
	return nil
end

-- Fonction BringPlr améliorée
local function BringPlr(Target, POS)
	if getgenv().PointInTable == 1 and Target.Character and Target.Character:FindFirstChild("Humanoid") then
		local TargetPlr = Target
		local c = game.Players.LocalPlayer.Character
		local Root = c.HumanoidRootPart
		local PrevCF = Root.CFrame
		local TargetChar = TargetPlr.Character
		
		if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") and 
		   not (not c or not c:FindFirstChild("BodyEffects") or not c.BodyEffects:FindFirstChild("K.O") or 
		        not c.BodyEffects:FindFirstChild("Grabbed") or c.BodyEffects["K.O"].Value == true or 
		        c.BodyEffects.Grabbed.Value ~= nil or not TargetChar or not TargetChar:FindFirstChild("BodyEffects") or 
		        not TargetChar.BodyEffects:FindFirstChild("K.O") or TargetChar.BodyEffects["K.O"].Value == true) then
			
			CmdSettings["IsLocking"] = true
			c.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			Root.CFrame = CFrame.new(TargetChar.HumanoidRootPart.Position) * CFrame.new(0, 0, 1)

			repeat wait()
				Root.CFrame = CFrame.new(TargetChar.HumanoidRootPart.Position) * CFrame.new(0, 0, 1)
				if not c:FindFirstChild("Combat") then
					c.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Combat)     
				end
				c.Combat:Activate()
			until not TargetPlr or not TargetChar or not c or not c:FindFirstChild("BodyEffects") or 
			      not c.BodyEffects:FindFirstChild("K.O") or not c.BodyEffects:FindFirstChild("Grabbed") or 
			      c.BodyEffects["K.O"].Value == true or c.BodyEffects.Grabbed.Value ~= nil or 
			      not TargetChar or not TargetChar:FindFirstChild("BodyEffects") or 
			      not TargetChar.BodyEffects:FindFirstChild("K.O") or TargetChar.BodyEffects["K.O"].Value == true

			Root.CFrame = CFrame.new(TargetChar.LowerTorso.Position) * CFrame.new(0, 3, 0)
			
			if c.BodyEffects.Grabbed.Value ~= nil then
				-- Logique de grab
			else
				if not (not TargetPlr or not TargetChar or not c or not c:FindFirstChild("BodyEffects") or 
				        not c.BodyEffects:FindFirstChild("K.O") or not c.BodyEffects:FindFirstChild("Grabbed") or 
				        c.BodyEffects["K.O"].Value == true or c.BodyEffects.Grabbed.Value ~= nil or 
				        not TargetChar or not TargetChar:FindFirstChild("BodyEffects") or 
				        not TargetChar.BodyEffects:FindFirstChild("K.O") or TargetChar.BodyEffects["K.O"].Value == false) then
					local args = {
						[1] = "Grabbing",
						[2] = false
					}
					game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
				end
			end

			repeat wait(0.35)
				if not (not TargetPlr or not TargetChar or not c or not c:FindFirstChild("BodyEffects") or 
				        not c.BodyEffects:FindFirstChild("K.O") or not c.BodyEffects:FindFirstChild("Grabbed") or 
				        c.BodyEffects["K.O"].Value == true or c.BodyEffects.Grabbed.Value ~= nil or 
				        not TargetChar or not TargetChar:FindFirstChild("BodyEffects") or 
				        not TargetChar.BodyEffects:FindFirstChild("K.O") or TargetChar.BodyEffects["K.O"].Value == false) then
					Root.CFrame = CFrame.new(TargetChar.LowerTorso.Position) * CFrame.new(0, 3, 0)
					if c.BodyEffects.Grabbed.Value ~= nil then
						-- Logique de grab
					else
						if not (not TargetPlr or not TargetChar or not c or not c:FindFirstChild("BodyEffects") or 
						        c.BodyEffects["K.O"].Value == true or c.BodyEffects.Grabbed.Value ~= nil or 
						        not TargetChar or not TargetChar:FindFirstChild("BodyEffects") or 
						        TargetChar.BodyEffects["K.O"].Value == false) then
							local args = {
								[1] = "Grabbing",
								[2] = false
							}
							game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
						end
					end
				end
			until not TargetPlr or not TargetChar or not c or not c:FindFirstChild("BodyEffects") or 
			      not c.BodyEffects:FindFirstChild("K.O") or not c.BodyEffects:FindFirstChild("Grabbed") or 
			      c.BodyEffects["K.O"].Value == true or c.BodyEffects.Grabbed.Value ~= nil or 
			      not TargetChar or not TargetChar:FindFirstChild("BodyEffects") or 
			      not TargetChar.BodyEffects:FindFirstChild("K.O") or TargetChar.BodyEffects["K.O"].Value == false

			if POS == nil then
				Root.CFrame = Host.Character.HumanoidRootPart.CFrame
			else
				Root.CFrame = POS
			end
			
			CmdSettings["IsLocking"] = nil
			wait(1.5)
			
			local args = {
				[1] = "Grabbing",
				[2] = false
			}
			game:GetService("ReplicatedStorage").MainEvent:FireServer(unpack(args))
		end
	end
end

-- Locations de bring
local BringLocations = {
	["bank"] = CFrame.new(-396.988922, 21.7570763, -293.929779, -0.102468058, -1.9584887e-09, -0.994736314, 7.23731564e-09, 1, -2.71436984e-09, 0.994736314, -7.47735651e-09, -0.102468058),
	["admin"] = CFrame.new(-872.453674, -32.6421318, -532.476379, 0.999682248, -1.36019978e-08, 0.0252073351, 1.33811247e-08, 1, 8.93094043e-09, -0.0252073351, -8.59080007e-09, 0.999682248),
	["klub"] = CFrame.new(-264.434479, 0.0355005264, -430.854736, -0.999828756, 9.58909574e-09, -0.0185054261, 9.92017934e-09, 1, -1.77993904e-08, 0.0185054261, -1.79799198e-08, -0.999828756),	
	["vault"] = CFrame.new(-495.485901, 23.1428547, -284.661713, -0.0313318223, -4.10440322e-08, 0.999509037, 2.18453966e-08, 1, 4.17489829e-08, -0.999509037, 2.31427428e-08, -0.0313318223),
	["train"] = CFrame.new(591.396118, 34.5070686, -146.159561, 0.0698467195, -4.91725913e-08, -0.997557759, 5.03374231e-08, 1, -4.57684664e-08, 0.997557759, -4.70177071e-08, 0.0698467195),	
}

-- Table des setups
local SetupsTable = {
	Bank = {
		Origin = CFrame.new(-386.826202, 21.2503242, -325.340912, 0.998742342, 0, -0.0501373149, 0, 1, 0, 0.0501373149, 0, 0.998742342) * CFrame.new(0, 0, -3),
		ZMultiplier = 3,
		XMultiplier = 8,
		PerRow = 10,
		Rows = 4,
	},
	Admin = {
		Origin = CFrame.new(-884.12915, -38.3972931, -545.291809, -0.99998939, 2.69316498e-08, -0.00460755778, 2.6944301e-08, 1, -2.68358624e-09, 0.00460755778, -2.80770518e-09, -0.99998939),
		ZMultiplier = 3,
		XMultiplier = 8,
		PerRow = 10,
		Rows = 4,
	},
	Klub = {
		Origin = CFrame.new(-237.016571, -4.87585974, -411.940063, 0.994918466, -1.5840282e-08, -0.100683607, 6.8329018e-09, 1, -8.9807088e-08, 0.100683607, 8.86627731e-08, 0.994918466),
		ZMultiplier = 6,
		XMultiplier = -12,
		PerRow = 10,
		Rows = 4,
	},
	Vault = {
		Origin = CFrame.new(-519.201355, 23.1994667, -292.362, -0.0597927198, 6.70288927e-08, -0.998210788, 2.96872589e-08, 1, 6.53707701e-08, 0.998210788, -2.57254467e-08, -0.0597927198),
		ZMultiplier = -2.5,
		XMultiplier = 4,
		PerRow = 10,
		Rows = 4,
	},
	Train = {
		Origin = CFrame.new(606.527588, 34.5070801, -159.083542, 0.0376962014, -7.60452892e-08, 0.999289274, 6.54496404e-08, 1, 7.36304173e-08, -0.999289274, 6.26275352e-08, 0.0376962014),
		ZMultiplier = 5,
		XMultiplier = -7,
		PerRow = 10,
		Rows = 4,
	}
}

-- Fonction Setup
local function Setup(Type, Debugmode)
	if Debugmode then
		for PointInTable = 1, 40 do
			local Table = SetupsTable[Type]
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Table["Origin"]

			local XAxis 
			local ZAxis
			local i 
			if PointInTable <= 10 then
				i = 1
			elseif PointInTable <= 20 then
				i = 2
			elseif PointInTable <= 30 then
				i = 3
			elseif PointInTable <= 40 then
				i = 4
			end

			if i == 1 then
				if PointInTable <= Table["PerRow"] then
					XAxis = 0
					if PointInTable == 1 then
						ZAxis = 0
					else
						ZAxis = (PointInTable - 1) * Table["ZMultiplier"]
					end
				end
			else
				local index = i * Table["PerRow"]
				if (Table["PerRow"] * i) >= PointInTable then
					XAxis = (i - 1) * Table["XMultiplier"]
					ZAxis = (i * Table["PerRow"] - PointInTable) * Table["ZMultiplier"]
				end
			end

			game.Players.LocalPlayer.Character.Archivable = true
			local clone = game.Players.LocalPlayer.Character:Clone()
			clone.Parent = workspace
			clone.HumanoidRootPart.CFrame = Table["Origin"] * CFrame.new(XAxis, 0, ZAxis)
		end
	else
		local Table = SetupsTable[Type]
		local PointInTable = getgenv().PointInTable
		local XAxis 
		local ZAxis
		local i

		if PointInTable <= 10 then
			i = 1
		elseif PointInTable <= 20 then
			i = 2
		elseif PointInTable <= 30 then
			i = 3
		elseif PointInTable <= 40 then
			i = 4
		end

		if i == 1 then
			if PointInTable <= Table["PerRow"] then
				XAxis = 0
				if PointInTable == 1 then
					ZAxis = 0
				else
					ZAxis = (PointInTable - 1) * Table["ZMultiplier"]
				end
			end
		else
			local index = i * Table["PerRow"]
			if (Table["PerRow"] * i) >= PointInTable then
				XAxis = (i - 1) * Table["XMultiplier"]
				ZAxis = (i * Table["PerRow"] - PointInTable) * Table["ZMultiplier"]
			end
		end

		Variables["Player"].Character.HumanoidRootPart.CFrame = Table["Origin"] * CFrame.new(XAxis, 0, ZAxis)
	end
end

-- Fonctions wallet
local function ShowWallet()
	local Player = game.Players.LocalPlayer
	if Player.Backpack:FindFirstChild("Wallet") then
		Player.Character.Humanoid:EquipTool(Player.Backpack.Wallet)
	end
end

local function RemoveWallet()
	local Player = game.Players.LocalPlayer
	if Player.Character:FindFirstChild("Wallet") then
		Player.Character.Humanoid:UnequipTools()
	end
end

local CurrAnim

-- Fonction d'initialisation
local function Initiate()
	CurrAnim = nil
	for Index, Var in pairs(CmdSettings) do
		CmdSettings[Var] = nil
	end
	CmdSettings = {}
	for Index, Connection in pairs(Connections) do
		Index[Connection] = nil
		Connection:Disconnect()
	end
	
	-- Mettre à jour l'UI quand le host rejoint
	if game.CoreGui:FindFirstChild("AltStatusUI") then
		local ui = game.CoreGui.AltStatusUI.Frame
		ui.InfoLabel.Text = "Connected! Ready for commands\nPrefix: ?"
		ui.InfoLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
	end
	
	-- Gestionnaire de commandes de chat (version améliorée)
	local function SetupChatListener()
		-- Essayer plusieurs méthodes de capture du chat
		local success1 = pcall(function()
			Connections["OnChat"] = game.ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
				local Message = data.Message
				local plr = game:service"Players"[data.FromSpeaker]
				if plr and plr.Name == getgenv().HostUser then
					print("Command received from host: " .. Message) -- Debug
					ProcessCommand(Message:lower())
				end
			end)
		end)
		
		-- Méthode alternative si la première échoue
		if not success1 then
			print("Trying alternative chat method...")
			local success2 = pcall(function()
				-- Méthode alternative pour le chat
				game.Players.PlayerChatted:Connect(function(chatType, player, message)
					if player.Name == getgenv().HostUser then
						print("Command received from host (alt method): " .. message) -- Debug
						ProcessCommand(message:lower())
					end
				end)
			end)
		end
		
		-- Méthode de secours avec StarterPlayer
		spawn(function()
			wait(2)
			pcall(function()
				for _, player in pairs(game.Players:GetPlayers()) do
					if player.Name == getgenv().HostUser then
						player.Chatted:Connect(function(message)
							print("Command received from host (backup method): " .. message) -- Debug
							ProcessCommand(message:lower())
						end)
					end
				end
			end)
		end)
	end
	
	-- Fonction pour traiter les commandes
	local function ProcessCommand(Message)
		local Args = string.split(Message, " ")
		print("Processing command:", Message) -- Debug
		
		if Host and not Crashed and Variables["Player"].Character and Variables["Player"].Character:FindFirstChild("HumanoidRootPart") and Variables["Player"].Character:FindFirstChild("Humanoid") and Variables["Player"].Character.Humanoid.Health > 0 then
			-- Commande ?drop (15k)
			if Args[1] == "?drop" then
				Drop(true)
			elseif Args[1] == "?stop" then
				Drop(false)
			-- Commande ?reset
			elseif Args[1] == "?reset" then
				if Variables["Player"].Character then
					local FULLY_LOADED_CHAR = Variables["Player"].Character:FindFirstChild("FULLY_LOADED_CHAR")
					if FULLY_LOADED_CHAR then
						FULLY_LOADED_CHAR.Parent = Services["RP"]
						FULLY_LOADED_CHAR:Destroy()
					end
					Variables["Player"].Character:Destroy()
				end
				Initiate()
			-- Commandes airlock
			elseif Args[1] == "?airlock" then
				AirLock(true)
			elseif Args[1] == "?stopairlock" then
				AirLock(false)
			-- Commandes bring
			elseif Message == "?bring" then
				if Host and Host.Character and Host.Character:FindFirstChild("HumanoidRootPart") then
					Variables["Player"].Character.HumanoidRootPart.CFrame = Host.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
				end
			elseif Args[1] == "?bring" and Args[2] == "host" and BringLocations[string.lower(Args[3])] then
				BringPlr(Host, BringLocations[string.lower(Args[3])])
			elseif Args[1] == "?bring" and BringLocations[string.lower(Args[3])] then
				local FoundPlayer = GetPlayerFromString(Args[2])
				if FoundPlayer then
					BringPlr(FoundPlayer, BringLocations[string.lower(Args[3])])
				end
			elseif Args[1] == "?bring" and Args[3] == "host" then
				local FoundPlayer = GetPlayerFromString(Args[2])
				if FoundPlayer then
					BringPlr(FoundPlayer, nil)
				end
			-- Commandes setup (avec alias)
			elseif Message == "?setup bank" or Message == "?setup bk" then
				Setup("Bank")
			elseif Message == "?setup admin" or Message == "?setup ad" then
				Setup("Admin")
			elseif Message == "?setup klub" or Message == "?setup kl" then
				Setup("Klub")
			elseif Message == "?setup vault" or Message == "?setup vt" then
				Setup("Vault")
			elseif Message == "?setup train" or Message == "?setup tr" then
				Setup("Train")
			-- Commandes circle host
			elseif Message == "?circle host" and Host and Host.Character and Host.Character:FindFirstChild("Humanoid") and Host.Character.Humanoid.Health > 0 then
				local angle = 0
				local cfr = Host.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
				local PointInTable = getgenv().PointInTable
				local ZAxis
				
				if PointInTable <= 10 then
					ZAxis = 2
					angle = (10 - PointInTable)
				elseif PointInTable <= 20 then
					ZAxis = -1
					angle = (20 - PointInTable)
				elseif PointInTable <= 30 then
					ZAxis = -4
					angle = (30 - PointInTable)
				elseif PointInTable <= 40 then
					ZAxis = -8
					angle = (40 - PointInTable)
				end
				
				angle = angle * 36
				local Clone = game.Players.LocalPlayer.Character
				Clone.HumanoidRootPart.CFrame = cfr * CFrame.fromEulerAnglesXYZ(0, math.rad(angle), 0) * CFrame.new(0, -3, -10)
				Clone.HumanoidRootPart.CFrame = Clone.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
				Clone.HumanoidRootPart.CFrame = Clone.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
			-- Commandes wallet
			elseif Message == "?wallet on" then
				ShowWallet()
			elseif Message == "?wallet off" then
				RemoveWallet()
			-- Commandes d'animation
			elseif Message == "?dolphin" then
				if CurrAnim and CurrAnim.IsPlaying then
					CurrAnim:Stop()
				end
				local Anim = Instance.new("Animation")
				Anim.AnimationId = "http://www.roblox.com/asset/?id=5918726674"
				CurrAnim = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(Anim)
				CurrAnim:Play()
				CurrAnim:AdjustSpeed()
			elseif Message == "?monkey" then
				if CurrAnim and CurrAnim.IsPlaying then
					CurrAnim:Stop()
				end
				local Anim = Instance.new("Animation")
				Anim.AnimationId = "http://www.roblox.com/asset/?id=3333499508"
				CurrAnim = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(Anim)
				CurrAnim:Play()
				CurrAnim:AdjustSpeed()
			elseif Message == "?floss" then
				if CurrAnim and CurrAnim.IsPlaying then
					CurrAnim:Stop()
				end
				local Anim = Instance.new("Animation")
				Anim.AnimationId = "http://www.roblox.com/asset/?id=5917459365"
				CurrAnim = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(Anim)
				CurrAnim:Play()
				CurrAnim:AdjustSpeed()
			elseif Message == "?shuffle" then
				if CurrAnim and CurrAnim.IsPlaying then
					CurrAnim:Stop()
				end
				local Anim = Instance.new("Animation")
				Anim.AnimationId = "http://www.roblox.com/asset/?id=4349242221"
				CurrAnim = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(Anim)
				CurrAnim:Play()
				CurrAnim:AdjustSpeed()
			elseif Message == "?stopdance" then
				if CurrAnim and CurrAnim.IsPlaying then
					CurrAnim:Stop()
				end
			-- Commandes masque
			elseif Message == "?maskon" then
				local plr = game.Players.LocalPlayer
				local c = plr.Character
				local Root = c.PrimaryPart
				local OldCF = Root.CFrame

				local Tries = 0 
				repeat 
					wait(0.1) 
					Tries += 1
					Root.CFrame = workspace.Ignored.Shop["[Surgeon Mask] - $25"].Head.CFrame * CFrame.new(math.random(-1, 1), 0, math.random(-1, 1))
					fireclickdetector(workspace.Ignored.Shop["[Surgeon Mask] - $25"].ClickDetector)
				until Tries >= 50 or not c or not c:FindFirstChild("Humanoid") or c:FindFirstChild"Mask" or plr.Backpack:FindFirstChild"Mask"
				
				wait(0.5)
				if plr.Backpack:FindFirstChild("Mask") then
					c.Humanoid:EquipTool(plr.Backpack.Mask)
					c.Mask:Activate()
				elseif c:FindFirstChild("Mask") then
					c.Mask:Activate()
				end
				Root.CFrame = OldCF
			elseif Message == "?maskoff" then
				local plr = game.Players.LocalPlayer
				local c = plr.Character

				if plr.Backpack:FindFirstChild("Mask") then
					c.Humanoid:EquipTool(plr.Backpack.Mask)
					c.Mask:Activate()
				elseif c:FindFirstChild("Mask") then
					c.Mask:Activate()
				end
			end
		end
	end
	
	-- Démarrer le listener de chat
	SetupChatListener()
	
	-- Écouter les nouveaux joueurs (incluant le host qui rejoint)
	game.Players.PlayerAdded:Connect(function(player)
		if player.Name == getgenv().HostUser then
			wait(1) -- Attendre que le joueur soit complètement chargé
			player.Chatted:Connect(function(message)
				print("Command from host (new player): " .. message) -- Debug
				ProcessCommand(message:lower())
			end)
		end
	end)
end

-- Écouter l'arrivée du host
Services["Players"].PlayerAdded:Connect(function(Player)
	if Player.Name == Variables["HostUser"] then
		print("Host joined the server!")
		Initiate()
	end
end)

-- Connexion immédiate pour le host s'il est déjà là
if Host then
	print("Host found in server, connecting...")
	Host.Chatted:Connect(function(message)
		print("Direct host chat: " .. message) -- Debug
		if Host and not Crashed and Variables["Player"].Character and Variables["Player"].Character:FindFirstChild("HumanoidRootPart") and Variables["Player"].Character:FindFirstChild("Humanoid") and Variables["Player"].Character.Humanoid.Health > 0 then
			-- Traiter directement la commande
			local Message = string.lower(message)
			local Args = string.split(Message, " ")
			
			-- Copier toute la logique de commande ici aussi
			if Args[1] == "?drop" then
				print("Executing drop command")
				Drop(true)
			elseif Args[1] == "?stop" then
				Drop(false)
			elseif Args[1] == "?reset" then
				if Variables["Player"].Character then
					local FULLY_LOADED_CHAR = Variables["Player"].Character:FindFirstChild("FULLY_LOADED_CHAR")
					if FULLY_LOADED_CHAR then
						FULLY_LOADED_CHAR.Parent = Services["RP"]
						FULLY_LOADED_CHAR:Destroy()
					end
					Variables["Player"].Character:Destroy()
				end
				Initiate()
			elseif Args[1] == "?bring" and #Args == 1 then
				if Host and Host.Character and Host.Character:FindFirstChild("HumanoidRootPart") then
					Variables["Player"].Character.HumanoidRootPart.CFrame = Host.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
				end
			end
		end
	end)
	Initiate()
end
