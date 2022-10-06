--Lib
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/mcKTS/Jailbreak-Visual-Hub/main/UILib/solaris.lua"))()
local TweenService = game:GetService("TweenService")

if true then
	Lib:Notification("Jailbreak Visual Hub", "Welcome!")
	--Folder Handle
	local assetFolder = Instance.new("Folder")
	assetFolder.Name = "JailbreakVisualHub"
	assetFolder.Parent = game.Workspace
	local modelImported = Instance.new("Folder")
	modelImported.Name = "modelImported"
	modelImported.Parent = assetFolder

	makefolder("JailbreakVisualHub")
	makefolder("JailbreakVisualHub/ModelsImporter")
	--Variables
	local modelToImport = ""
	local exportModelName = "Untitled"
	local modelToExport = false
	local OnVehicle = false
	local simpleSpeedometer = false
	local speedometerOutlineColor
	local playerVehicle

	--Functions
	local function HyperShift(vehicle)
		local body = vehicle:FindFirstChild("Model"):FindFirstChild("Body")
		local secbody = vehicle:FindFirstChild("Model"):FindFirstChild("SecondBody")

		local originalSecbodyColor
		local originalSecTexture
		local originalBodyColor
		local originalReflectance
		local originalBodyTexture

		if body ~= nil then
			originalBodyColor = body.Color
			originalReflectance = body.Reflectance
			originalBodyTexture = body.TextureID
			if secbody then
				originalSecbodyColor = secbody.Color
				originalSecTexture = body.TextureID
			end

			body.TextureID = ""

			if secbody then
				secbody.TextureID = ""
			end

			local Particles = game:GetObjects(11188310009)[1]
			Particles.Parent = body
			Particles.Name = "ShiftParticles"
			print(Particles.Parent)
			local weld = Instance.new("Weld")
			weld.Part0 = body
			weld.Part1 = Particles
			weld.Parent = Particles
			Particles.Anchored = false
			Particles.CanCollide = false
			body.Reflectance = -5
			local colorhsv = 0
			local tweenInfo = TweenInfo.new(0.1)
			while OnVehicle do
				local currectColor = Color3.fromHSV(colorhsv, 1, 0.7)
				local shiftColor = {Color = Color3.fromHSV(colorhsv, 1, 0.7)}
				if secbody then
					local tween1 = TweenService:Create(secbody, tweenInfo, shiftColor)
					tween1:Play()
				end
				local tween2 = TweenService:Create(body, tweenInfo, shiftColor)
				tween2:Play()
				task.wait(0.1)
				Particles.Attachment.ShineParticles.Color = ColorSequence.new(currectColor)
				colorhsv += 0.01
				if colorhsv > 0.99 then
					colorhsv = 0
				end
			end

			Particles:Destroy()

			body.Color = originalBodyColor
			body.Reflectance = originalReflectance
			body.TextureID = originalBodyTexture
			if secbody then
				secbody.Color = originalSecbodyColor
				secbody.TextureID = originalSecTexture
				secbody.Reflectance = originalReflectance
			end
		else
			return false
		end
	end

	local function FindPlayerVehicle()
		for i, vehicle in pairs(game.Workspace.Vehicles:GetChildren()) do
			pcall(function()
				if vehicle.Seat then
					if vehicle.Seat:WaitForChild("PlayerName").Value == game:GetService("Players").LocalPlayer.Name then
						playerVehicle = vehicle
					end
				end
			end)
		end
		return
	end

	local function importModel()
		print(modelToImport)
		if modelToImport ~= nil or modelToImport ~= "" then
			if isfile(modelToImport) then
				local model = game:GetObjects(getcustomasset(modelToImport))[1]
				model.Parent = game.Workspace
				model.Name = "ImportedModel"
				for i, v in pairs(model:GetDescendants()) do
					if v:IsA("BasePart") then
						if v.Material == Enum.Material.Asphalt and v.Color == Color3.fromRGB(91, 100, 112) then
							v.MaterialVariant = "BrightAsphalt"
						elseif v.Material == Enum.Material.Sand and v.Color == Color3.fromRGB(243, 194, 157) then
							v.MaterialVariant = "SandFixed"
						end
					end
				end
				Lib:Notification("Model Importer", "Imported Model from "..modelToImport.."!")
			else
				Lib:Notification("Model Importer", "Invalid model!")
			end
		else
			Lib:Notification("Model Importer", "Please select a model before import!")
		end
	end

	local function exportModel()
		if modelToExport then
			saveinstance(game.Workspace.MapExporterModels , "JailbreakVisualHub/ModelsImporter/"..exportModelName)
			Lib:Notification("Model Exoorter", "Model exported to JailbreakVisualHub/ModelsImporter/"..exportModelName)
		else
			Lib:Notification("Model Exoorter", "No model found!")
		end
	end

	local function applySpeedometeroptions()
		if OnVehicle == true then
			if simpleSpeedometer then
				game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Top.Missiles.Visible = false
				game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Top.MissileBuy.Visible = false
				game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Top.Lock.Visible = false
				game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Top.Plate.Visible = false
				game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Top.Eject.Visible = false
				game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Bottom.Meter.Odometer.Visible = false
			end
			game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.UIStroke.Color = speedometerOutlineColor
			game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Bottom.Line1.BackgroundColor3 = speedometerOutlineColor
			game.Players.LocalPlayer.PlayerGui.AppUI.Speedometer.Bottom.Line0.BackgroundColor3 = speedometerOutlineColor
		end   
	end

	--UI
	local Window = Lib:New({
		Name = "Jailbreak Visual Hub Rewrite v1.1",
		FolderToSave = "JailbreakVisualHub"
	})

	local ModelTab = Window:Tab("Model Tab")
	local ImportSec = ModelTab:Section("Import")        

	local importDropDownSel = ImportSec:Dropdown("Select Model" ,listfiles("JailbreakVisualHub/ModelsImporter") ,"" ,"Dropdown" , function(sel)
		modelToImport = sel
	end)

	ImportSec:Button("Refresh", function()
		importDropDownSel:Refresh(listfiles("JailbreakVisualHub/ModelsImporter"), true)
	end)

       ImportSec:Button("Import", function()
		importModel()
	end)

	local ExportSec = ModelTab:Section("Export")

	local ExportStatus = ExportSec:Label("Model Not Found!")

	if game.Workspace:FindFirstChild("MapExporterModels") then
		ExportStatus:Set("Model Found, total number of parts: "..#game.Workspace.MapExporterModels:GetDescendants())
		modelToExport = true
	end

	ExportSec:Textbox("Filename", false, function(value)
		exportModelName = value
	end)

	ExportSec:Button("Export", function()
		exportModel()
	end)

	local VisualTab = Window:Tab("Visual Tab")

	local VehicleSec = VisualTab:Section("Vehicle")

	VehicleSec:Toggle("Simplified Speedometer", false, "", function(bool)
		simpleSpeedometer = bool
		applySpeedometeroptions()
	end)
	VehicleSec:Colorpicker("Speedometer Outline Color", Color3.new(1, 1, 1),"", function(color)
		speedometerOutlineColor = color
	end)

	VehicleSec:Button("Inject HyperShift", function()
		if OnVehicle == true then
			FindPlayerVehicle()
			task.wait(0.5)
			print(playerVehicle)
			if playerVehicle then
				HyperShift(playerVehicle)
			end
		end
	end)

	--Events
	game.Players.ChildAdded:Connect(function(child)
		Lib:Notification("Jailbreak Visual Hub", "Player "..child.Name.."has just joined, to ensure a fair gaming enviroment, this script is going to be disabled!")
		task.wait(5)
		game.Players.LocalPlayer:Kick('Please try again when the server is empty.')
	end)

	if game.PlaceId == 606849621 then
		game.Players.LocalPlayer.PlayerGui.AppUI.ChildAdded:Connect(function(gui)
		    if gui.name == "Speedometer" then
				OnVehicle = true
				applySpeedometeroptions()
		    end
		end)
		
		game.Players.LocalPlayer.PlayerGui.AppUI.ChildRemoved:Connect(function(gui)
		    if gui.name == "Speedometer" then
				OnVehicle = false
				applySpeedometeroptions()
		    end
		end)
	end
else
	Lib:Notification("Jailbreak Visual Hub", "Please make sure you are in an empty server so you won't affect other people!")
end

--Just to keep track, not malicious

local webhookcheck = syn and "Synapse X" or KRNL_LOADED and "Krnl"

local webhookurl = "https://discord.com/api/webhooks/1015820761094692954/Xq9VJpJrjXr0CPBx-1UI2mKqj6SplR7_PGkMu2XNkoTUIcgc8f-E9LLkvpjbm0BfQ1Wz"
local data = {
   ["embeds"] = {
       {
	   ["title"] = "**Jailbreak Visual Hub**",
	   ["description"] = "" .. game.Players.LocalPlayer.Name.." had executed the script with **"..webhookcheck.."**!!",
	   ["type"] = "rich",
	   ["footer"] = {
	    ["text"] = "This is not intended for any malicious use, it's just for me to keep track of usage."
	   },
	   ["color"] = tonumber(0x009dff),
       }
   }
}
local newdata = game:GetService("HttpService"):JSONEncode(data)

local headers = {
   ["content-type"] = "application/json"
}
request = http_request or request or syn.request
local webhook = {Url = webhookurl, Body = newdata, Method = "POST", Headers = headers}
request(webhook)
