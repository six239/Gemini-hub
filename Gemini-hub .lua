local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Gemini-hub | Blox Fruits",
   LoadingTitle = "Gemini-hub loading...",
   LoadingSubtitle = "Powered by AI (Mobile Optimized)",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GeminiHubConfig",
      FileName = "BloxFruits"
   },
   Icon = "rbxassetid://10180628714", 
   Keybind = Enum.KeyCode.RightControl -- კომპიუტერისთვის რჩება, მობილურზე კი ღილაკი დაემატება ქვემოთ
})

-- მობილურის ჩაკეცვის მცურავი ღილაკის შექმნა (Floating Button)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "GeminiToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0) -- ეკრანის მარცხენა ზედა მხარეს
ToggleButton.Size = UDim2.new(0, 60, 0, 60)        -- ღილაკის ზომა
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Gemini"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14.00

UICorner.CornerRadius = UDim.new(0, 30) -- მრგვალი ფორმა
UICorner.Parent = ToggleButton

-- ფუნქცია, რომელიც თითის დაჭერისას მენიუს მალავს ან აჩენს
ToggleButton.MouseButton1Click:Connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

local FruitTab = Window:CreateTab("Fruit Finder", 4483362458)

-- 1. Fruit Notifier
FruitTab:CreateButton({
   Name = "Scan for Spawned Fruits",
   Callback = function()
      local found = false
      for _, v in pairs(workspace:GetChildren()) do
         if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            Rayfield:Notify({
               Title = "Fruit Found!",
               Content = "A " .. v.Name .. " is currently spawned on the map!",
               Duration = 5,
               Image = 4483362458,
            })
            found = true
         end
      end
      if not found then
         Rayfield:Notify({
            Title = "No Fruits",
            Content = "There are currently no spawned fruits on the map.",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})

-- 2. Teleport to Fruit
FruitTab:CreateButton({
   Name = "Teleport to Spawned Fruit",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local targetFruit = nil
      for _, v in pairs(workspace:GetChildren()) do
         if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            targetFruit = v
            break
         end
      end
      
      if targetFruit then
         humanoidRootPart.CFrame = targetFruit.Handle.CFrame
         Rayfield:Notify({
            Title = "Success",
            Content = "Teleported to " .. targetFruit.Name,
            Duration = 3,
            Image = 4483362458,
         })
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "No fruit found to teleport to.",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})

-- 3. Auto Store Fruit
FruitTab:CreateButton({
   Name = "Auto-Store Held Fruit",
   Callback = function()
      local storeRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
      if storeRemote then
         storeRemote:InvokeServer("StoreFruit")
         Rayfield:Notify({
            Title = "Inventory",
            Content = "Attempted to store your held fruit.",
            Duration = 3,
            Image = 4483362458,
         })
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Could not locate storage remote.",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})
