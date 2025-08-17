--test
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

-- Variables principales (déplacées au début)
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
local CmdSettings = {}

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

-- Table des setups (déplacée avant les fonctions)
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

-- Locations de bring
local BringLocations = {
	["bank"] = CFrame.new(-396.988922, 21.7570763, -293.929779, -0.102468058, -1.9584887e-09, -0.994736314, 7.23731564e-09, 1, -2.71436984e-09, 0.994736314, -7.47735651e-09, -0.102468058),
	["admin"] = CFrame.new(-872.453674, -32.6421318, -532.476379, 0.999682248, -1.36019978e-08, 0.0252073351, 1.33811247e-08, 1, 8.93094043e-09, -0.0252073351, -8.59080007e-09, 0.999682248),
	["klub"] = CFrame.new(-264.434479, 0.0355005264, -430.854736, -0.999828756, 9.58909574e-09, -0.0185054261, 9.92017934e-09, 1, -1.77993904e-08, 0.0185054261, -1.79799198e-08, -0.999828756),	
	["vault"] = CFrame.new(-495.485901, 23.1428547, -284.661713, -0.0313318223, -4.10440322e-08, 0.999509037, 2.18453966e-08, 1, 4.17489829e-08, -0.999509037, 2.31427428e-08, -0.0313318223),
	["train"] = CFrame.new(591.396118, 34.5070686, -146.159561, 0.0698467195, -4.91725913e-08, -0.997557759, 5.03374231e-08, 1, -4.57684664e-08, 0.997557759, -4.70177071e-08, 0.0698467195),	
}

local CurrAnim

-- Fonctions principales (toutes déplacées avant ProcessCommand)

-- Fonction Drop améliorée (15k au lieu de 10k)
local function Drop(Type)
	if Type == true and CmdSettings["Dropping"] == nil then
		CmdSettings["Dropping"] = true
		while CmdSettings["Dropping"] do
			local args = {
				[1] = "DropMoney",
				[2] = "15000"
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

-- Fonction Setup (CORRIGÉE)
local function Setup(Type, Debugmode)
	print("Setup function called with type:", Type) -- Debug
	
	if not Variables["Player"].Character or not Variables["Player"].Character:FindFirstChild("HumanoidRootPart") then
		print("Character or HumanoidRootPart not found!")
		return
	end
	
	local Table = SetupsTable[Type]
	if not Table then
		print("Setup table not found for type:", Type)
		return
	end
	
	print("Using setup table for:", Type)
	print("Origin:", Table["Origin"])
	print("PointInTable:", getgenv().PointInTable)
	
	if Debugmode then
		for PointInTable = 1, 40 do
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

		local newCFrame = Table["Origin"] * CFrame.new(XAxis, 0, ZAxis)
		print("Moving to position:", newCFrame)
		Variables["Player"].Character.HumanoidRootPart.CFrame = newCFrame
		print("Position set successfully!")
	end
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

-- FONCTION PROCESSCOMMAND GLOBALE (corrigée et simplifiée)
local function ProcessCommand(Message)
	print("=== PROCESSING COMMAND ===")
	print("Message received:", Message)
	
	local Args = string.split(Message, " ")
	print("Args:", table.concat(Args, ", "))
	
	-- Vérifications de base simplifiées
	if not Variables["Player"].Character then
		print("No character found!")
		return
	end
	
	if not Variables["Player"].Character:FindFirstChild("HumanoidRootPart") then
		print("No HumanoidRootPart found!")
		return
	end
	
	print("Basic checks passed, processing command...")
	
	-- Commande ?drop (15k)
	if Args[1] == "?drop" then
		print("Executing drop command")
		Drop(true)
		
	elseif Args[1] == "?stop" then
		print("Stopping drop")
		Drop(false)
		
	-- Commande ?reset
	elseif Args[1] == "?reset" then
		print("Executing reset command")
		if Variables["Player"].Character then
			local FULLY_LOADED_CHAR = Variables["Player"].Character:FindFirstChild("FULLY_LOADED_CHAR")
			if FULLY_LOADED_CHAR then
				FULLY_LOADED_CHAR.Parent = Services["RP"]
				FULLY_LOADED_CHAR:Destroy()
			end
			Variables["Player"].Character:Destroy()
		end
		
	-- Commandes airlock
	elseif Args[1] == "?airlock" then
		print("Executing airlock command")
		AirLock(true)
		
	elseif Args[1] == "?stopairlock" then
		print("Stopping airlock")
		AirLock(false)
		
	-- Commandes bring
	elseif Message == "?bring" then
		print("Executing bring command")
		if Host and Host.Character and Host.Character:FindFirstChild("HumanoidRootPart") then
			Variables["Player"].Character.HumanoidRootPart.CFrame = Host.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
		end
		
	-- Commandes setup (CORRIGÉES)
	elseif Message == "?setup bank" or Message == "?setup bk" then
		print("=== EXECUTING SETUP BANK ===")
		Setup("Bank")
		
	elseif Message == "?setup admin" or Message == "?setup ad" then
		print("=== EXECUTING SETUP ADMIN ===")
		Setup("Admin")
		
	elseif Message == "?setup klub" or Message == "?setup kl" then
		print("=== EXECUTING SETUP KLUB ===")
		Setup("Klub")
		
	elseif Message == "?setup vault" or Message == "?setup vt" then
		print("=== EXECUTING SETUP VAULT ===")
		Setup("Vault")
		
	elseif Message == "?setup train" or Message == "?setup tr" then
		print("=== EXECUTING SETUP TRAIN ===")
		Setup("Train")
		
	-- Commandes wallet
	elseif Message == "?wallet on" then
		print("Showing wallet")
		ShowWallet()
		
	elseif Message == "?wallet off" then
		print("Removing wallet")
		RemoveWallet()
		
	-- Commandes d'animation
	elseif Message == "?dolphin" then
		print("Executing dolphin animation")
		if CurrAnim and CurrAnim.IsPlaying then
			CurrAnim:Stop()
		end
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "http://www.roblox.com/asset/?id=5918726674"
		CurrAnim = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(Anim)
		CurrAnim:Play()
		CurrAnim:AdjustSpeed()
		
	elseif Message == "?stopdance" then
		print("Stopping dance")
		if CurrAnim and CurrAnim.IsPlaying then
			CurrAnim:Stop()
		end
		
	else
		print("Unknown command:", Message)
	end
	
	print("=== COMMAND PROCESSING COMPLETE ===")
end

-- Attendre le host
if not Host then
	print("Host is not here waiting for him to join!")
	Services["Players"]:WaitForChild(Variables["HostUser"], 9e9)
	Host = Services["Players"]:FindFirstChild(Variables["HostUser"])
end

print("Script loaded!")

-- Fonction d'initialisation simplifiée
local function Initiate()
	print("=== INITIATING SCRIPT ===")
	
	CurrAnim = nil
	for Index, Var in pairs(CmdSettings) do
		CmdSettings[Index] = nil
	end
	CmdSettings = {}
	
	for Index, Connection in pairs(Connections) do
		if Connection then
			Connection:Disconnect()
		end
	end
	Connections = {}
	
	-- Mettre à jour l'UI quand le host rejoint
	if game.CoreGui:FindFirstChild("AltStatusUI") then
		local ui = game.CoreGui.AltStatusUI.Frame
		ui.InfoLabel.Text = "Connected! Ready for commands\nPrefix: ?"
		ui.InfoLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
	end
	
	print("=== SCRIPT INITIATED ===")
end

-- Connexion simplifiée au chat du host
if Host then
	print("Host found in server, connecting to chat...")
	
	-- Connexion directe au chat du host
	Host.Chatted:Connect(function(message)
		print("HOST CHAT RECEIVED:", message)
		ProcessCommand(string.lower(message))
	end)
	
	Initiate()
else
	print("Host not found, waiting...")
end

-- Écouter l'arrivée du host
Services["Players"].PlayerAdded:Connect(function(Player)
	if Player.Name == Variables["HostUser"] then
		print("Host joined the server!")
		Host = Player
		
		-- Attendre que le host soit complètement chargé
		Player.CharacterAdded:Connect(function()
			wait(2) -- Attendre un peu plus
			Player.Chatted:Connect(function(message)
				print("NEW HOST CHAT RECEIVED:", message)
				ProcessCommand(string.lower(message))
			end)
		end)
		
		-- Connexion immédiate aussi
		Player.Chatted:Connect(function(message)
			print("IMMEDIATE HOST CHAT RECEIVED:", message)
			ProcessCommand(string.lower(message))
		end)
		
		Initiate()
	end
end)
