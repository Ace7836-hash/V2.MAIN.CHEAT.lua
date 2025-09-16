--// ✅ FULL DRAGGABLE KEY SYSTEM + LOADING SCREEN + SAFE REMOTE LOADER
-- CONFIG
local CORRECT_KEY = "1KMI$TRAL-MAINCHEAT" -- 🔑 palitan kung gusto mo
local IMAGE_ID = "rbxassetid://70881478666974" -- loading/key image
local REMOTE_SCRIPT_URL = "https://raw.githubusercontent.com/Ace7836-hash/Mk/refs/heads/main/script.lua.lua"
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- util: trim
local function trim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

-- Remove any previous UI
if PlayerGui:FindFirstChild("KeySystemUI") then
    PlayerGui.KeySystemUI:Destroy()
end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "KeySystemUI"
gui.Parent = PlayerGui
gui.ResetOnSpawn = false

-- Main draggable frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 230)
frame.Position = UDim2.new(0.5, -210, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- draggable
frame.Parent = gui
Instance.new("UICorner", frame)

-- Background image (subtle)
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1,0,1,0)
bg.Position = UDim2.new(0,0,0,0)
bg.BackgroundTransparency = 1
bg.Image = IMAGE_ID
bg.ImageTransparency = 0.15
bg.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 42)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "1KMI$TRAL KEY SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Key TextBox
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.85, 0, 0, 44)
box.Position = UDim2.new(0.075, 0, 0.45, 0)
box.PlaceholderText = "Enter Key Here"
box.Text = ""
box.Font = Enum.Font.Gotham
box.TextSize = 18
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.fromRGB(255,255,255)
box.ClearTextOnFocus = false
Instance.new("UICorner", box)
box.Parent = frame

-- Submit Button
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.85,0,0,44)
btn.Position = UDim2.new(0.075,0,0.7,0)
btn.Text = "Submit"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 20
btn.BackgroundColor3 = Color3.fromRGB(40,120,40)
btn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", btn)
btn.Parent = frame

-- Status label
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 24)
status.Position = UDim2.new(0, 10, 1, -28)
status.BackgroundTransparency = 1
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 16
status.TextColor3 = Color3.fromRGB(255,200,0)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

-- helper: show status (auto clear optional)
local function setStatus(text, color, timeout)
    status.Text = text or ""
    if color then status.TextColor3 = color end
    if timeout and timeout > 0 then
        spawn(function()
            wait(timeout)
            if status then status.Text = "" end
        end)
    end
end

-- function to load remote script safely
local function loadRemoteScript()
    -- small wait to ensure UI destroyed
    wait(0.08)
    local ok, err = pcall(function()
        -- try to fetch & run remote script
        local code = game:HttpGet(REMOTE_SCRIPT_URL)
        local fn = loadstring(code)
        if type(fn) == "function" then
            fn()
        else
            error("loadstring returned non-function")
        end
    end)
    if not ok then
        warn("[KeyLoader] Failed to load remote script:", err)
        setStatus("Failed to load menu: "..tostring(err), Color3.fromRGB(255,80,80))
    end
end

-- show loading screen (centered small card)
local function showLoadingAndThenLoad()
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingUI"
    loadingGui.Parent = PlayerGui
    loadingGui.ResetOnSpawn = false

    local lFrame = Instance.new("Frame")
    lFrame.Size = UDim2.new(0, 360, 0, 240)
    lFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
    lFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
    lFrame.BorderSizePixel = 0
    Instance.new("UICorner", lFrame)
    lFrame.Parent = loadingGui

    local lImg = Instance.new("ImageLabel")
    lImg.Size = UDim2.new(0.9,0,0.75,0)
    lImg.Position = UDim2.new(0.05,0,0.05,0)
    lImg.BackgroundTransparency = 1
    lImg.Image = IMAGE_ID
    lImg.Parent = lFrame

    local lTxt = Instance.new("TextLabel")
    lTxt.Size = UDim2.new(1,0,0,36)
    lTxt.Position = UDim2.new(0,0,0.82,0)
    lTxt.BackgroundTransparency = 1
    lTxt.Text = "ROI LOADER... BY ACE"
    lTxt.Font = Enum.Font.GothamBold
    lTxt.TextColor3 = Color3.fromRGB(255,255,255)
    lTxt.TextSize = 20
    lTxt.Parent = lFrame

    -- optional fade-in tween
    pcall(function()
        TweenService:Create(lFrame, TweenInfo.new(0.35, Enum.EasingStyle.Sine), {BackgroundTransparency = 0}):Play()
    end)

    -- show for a few seconds then destroy and load remote
    spawn(function()
        wait(2.5)
        pcall(function() loadingGui:Destroy() end)
        loadRemoteScript()
    end)
end

-- Submission logic
local function submitKey(k)
    local key = trim(k or box.Text or "")
    if key == "" then
        setStatus("Walang nilagay na key.", Color3.fromRGB(255,140,0), 2)
        return
    end

    if key == CORRECT_KEY then
        setStatus("✅ Correct key! Preparing menu...", Color3.fromRGB(100,220,120))
        -- small animation: fade out frame
        pcall(function()
            TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
            TweenService:Create(bg, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {ImageTransparency = 1}):Play()
        end)
        wait(0.6)
        pcall(function() gui:Destroy() end)
        showLoadingAndThenLoad()
    else
        setStatus("❌ Invalid key, try again.", Color3.fromRGB(255,80,80), 2)
        box.Text = ""
        box.PlaceholderText = "Try Again"
    end
end

-- Connect submit button and Enter key
btn.MouseButton1Click:Connect(function() submitKey(box.Text) end)
box.FocusLost:Connect(function(enterPressed)
    if enterPressed then submitKey(box.Text) end
end)

-- initial focus
spawn(function()
    wait(0.1)
    pcall(function() box:CaptureFocus() end)
end)

print("[KeySystem] Loaded. Waiting for key.")