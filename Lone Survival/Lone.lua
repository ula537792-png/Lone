local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

if getgenv().InveriumLoneSurvival_Connections then
    for _, conn in ipairs(getgenv().InveriumLoneSurvival_Connections) do
        pcall(function() conn:Disconnect() end)
    end
end
getgenv().InveriumLoneSurvival_Connections = {}

if getgenv().InveriumLoneSurvival_Drawings then
    for _, obj in pairs(getgenv().InveriumLoneSurvival_Drawings) do
        pcall(function() obj:Remove() end)
    end
end
getgenv().InveriumLoneSurvival_Drawings = {}

for _, child in ipairs(CoreGui:GetChildren()) do
    if child.Name == "InveriumLoneSurvival" or child.Name == "InveriumKeybinds" or child.Name == "InveriumTeamHUD" then
        pcall(function() child:Destroy() end)
    end
end

local ESP_SETTINGS = {
    Enabled = false,
    Chams = false,
    Boxes = false,
    Names = false,
    Health = false,
    Tracers = false,
    LookDirection = false,
    VisibleCheck = false,
    MaxDistance = 1500,
    BaseColor = Color3.fromRGB(130, 80, 220)
}

local CRATES_SETTINGS = {
    Airdrop = false,
    FoodCrate = false,
    LargeCrate = false,
    Medbag = false,
    MilitaryCrate = false,
    SNTechCrate = false,
    ToolBox = false,
    Vault = false,
    DieselBarrel = false,
    LockedCrate = false,
    Names = true,
    Chams = true,
    MaxDistance = 3000,
    Colors = {
        Airdrop = Color3.fromRGB(245, 90, 90),
        FoodCrate = Color3.fromRGB(90, 220, 130),
        LargeCrate = Color3.fromRGB(235, 160, 70),
        Medbag = Color3.fromRGB(240, 120, 180),
        MilitaryCrate = Color3.fromRGB(120, 130, 145),
        SNTechCrate = Color3.fromRGB(70, 210, 235),
        ToolBox = Color3.fromRGB(235, 215, 80),
        Vault = Color3.fromRGB(155, 90, 230),
        DieselBarrel = Color3.fromRGB(200, 110, 50),
        LockedCrate = Color3.fromRGB(255, 120, 50)
    }
}

local RAIDS_SETTINGS = {
    XRayEnabled = false,
    Transparency = 0.5,
    Key = Enum.KeyCode.X
}

local DIED_ESP_SETTINGS = {
    Enabled = false,
    Chams = true,
    Names = true,
    MaxDistance = 5000,
    Color = Color3.fromRGB(235, 215, 80)
}

local RESOURCES_SETTINGS = {
    BrimstoneOre = false,
    IronOre = false,
    StoneOre = false,
    ClothPlant = false,
    Names = true,
    Chams = true,
    MaxDistance = 3000,
    Colors = {
        BrimstoneOre = Color3.fromRGB(240, 210, 70),
        IronOre = Color3.fromRGB(220, 135, 75),
        StoneOre = Color3.fromRGB(140, 150, 165),
        ClothPlant = Color3.fromRGB(80, 210, 140)
    }
}

local AIM_SETTINGS = {
    Enabled = false,
    Smoothness = 0.05,
    ShowFOV = false,
    FOVRadius = 250,
    Range = 2000,
    VisibleCheck = false,
    NoBulletDrop = false,
    Key = Enum.UserInputType.MouseButton2,
    VisibleCheckKey = Enum.KeyCode.F,
    HoldMode = false,
    TargetPart = "UpperTorso",
    BaseColor = Color3.fromRGB(130, 80, 220)
}

local HITBOX_SETTINGS = {
    Enabled = false,
    Size = 3,
    HeadSizeMultiplier = 2.5,
    Transparency = 0.7,
    TargetPart = "HumanoidRootPart",
    SwitchKey = Enum.KeyCode.Q
}

local PLAYER_SETTINGS = {
    FullBright = false,
    AntiFog = false,
    RTXGraphics = false,
    EnableFOV = false,
    FOV = 70
}

local MENU_SETTINGS = {
    BindManagerTransparency = 0.35,
    TeamHUDTransparency = 0.4,
    BindManagerVisible = true,
    TeamHUDVisible = true
}

local TEAM_MEMBERS = {}

local isAiming = false
local lockedTarget = nil

local connAimBegin = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and AIM_SETTINGS.Enabled then
        if input.UserInputType == AIM_SETTINGS.Key or input.KeyCode == AIM_SETTINGS.Key then
            if AIM_SETTINGS.HoldMode then
                isAiming = true
            else
                isAiming = not isAiming
                if not isAiming then
                    lockedTarget = nil
                end
            end
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connAimBegin)

local connAimEnd = UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if AIM_SETTINGS.Enabled and AIM_SETTINGS.HoldMode then
        if input.UserInputType == AIM_SETTINGS.Key or input.KeyCode == AIM_SETTINGS.Key then
            isAiming = false
            lockedTarget = nil
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connAimEnd)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InveriumLoneSurvival"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 460)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Inverium Lone Survival"
TitleLabel.TextColor3 = Color3.fromRGB(130, 70, 180)
TitleLabel.TextSize = 14
TitleLabel.Parent = MainFrame

local DragTopBar = Instance.new("Frame")
DragTopBar.Size = UDim2.new(1, 0, 0, 35)
DragTopBar.BackgroundTransparency = 1
DragTopBar.Parent = MainFrame

local dragging, dragInput, dragStart, startPos
local conn1 = DragTopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, conn1)

local conn2 = DragTopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, conn2)

local conn3 = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, conn3)

local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 55, 1, -35)
SideBar.Position = UDim2.new(0, 0, 0, 35)
SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local icons = {"⚙", "👁", "📦", "⛏", "💣", "🎯", "👤", "👥"}

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -75, 1, -85)
ContentContainer.Position = UDim2.new(0, 65, 0, 75)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local TabsBar = Instance.new("Frame")
TabsBar.Size = UDim2.new(1, -70, 0, 30)
TabsBar.Position = UDim2.new(0, 65, 0, 40)
TabsBar.BackgroundTransparency = 1
TabsBar.Parent = MainFrame

local function updateTabs(tabName)
    for _, child in ipairs(TabsBar:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = (child.Name == tabName)
        end
    end
end

local function createTabButton(name, text, xPos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.TextSize = 11
    btn.Visible = false
    btn.Parent = TabsBar

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(170, 80, 255)
    line.BorderSizePixel = 0
    line.Parent = btn

    return btn
end

local btnSettingsTab = createTabButton("SettingsTabBtn", "SETTINGS", 0)
local btnVisuals = createTabButton("VisualsTabBtn", "VISUALS", 0)
local btnCrates = createTabButton("CratesTabBtn", "CRATES", 0)
local btnResources = createTabButton("ResourcesTabBtn", "RESOURCES", 0)
local btnRaids = createTabButton("RaidsTabBtn", "RAIDS", 0)
local btnAim = createTabButton("AimTabBtn", "AIM", 0)
local btnPlayer = createTabButton("PlayerTabBtn", "PLAYER", 0)
local btnTeam = createTabButton("TeamTabBtn", "TEAMS", 0)

local function createCategoryBox(parent, name, posX, posY, sizeX, sizeY)
    local box = Instance.new("ScrollingFrame")
    box.Size = UDim2.new(0, sizeX, 0, sizeY)
    box.Position = UDim2.new(0, posX, 0, posY)
    box.BackgroundColor3 = Color3.fromRGB(30, 26, 42)
    box.BorderSizePixel = 0
    box.CanvasSize = UDim2.new(0, 0, 2.2, 0)
    box.ScrollBarThickness = 3
    box.ScrollBarImageColor3 = Color3.fromRGB(120, 60, 180)
    box.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 12, 0, 5)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = Color3.fromRGB(180, 130, 230)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = box

    return box
end

local SettingsContainer = Instance.new("Frame")
SettingsContainer.Size = UDim2.new(1, 0, 1, 0)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.Parent = ContentContainer

local SettingsLeftBox = createCategoryBox(SettingsContainer, "Interface & Settings", 10, 10, 300, 360)
local SettingsRightBox = createCategoryBox(SettingsContainer, "Visual Enhancements", 320, 10, 310, 360)

local VisualsContainer = Instance.new("Frame")
VisualsContainer.Size = UDim2.new(1, 0, 1, 0)
VisualsContainer.BackgroundTransparency = 1
VisualsContainer.Visible = false
VisualsContainer.Parent = ContentContainer

local LeftBox = createCategoryBox(VisualsContainer, "ESP Visuals", 10, 10, 300, 360)
local RightBox = createCategoryBox(VisualsContainer, "Settings & Colors", 320, 10, 310, 360)

local CratesContainer = Instance.new("Frame")
CratesContainer.Size = UDim2.new(1, 0, 1, 0)
CratesContainer.BackgroundTransparency = 1
CratesContainer.Visible = false
CratesContainer.Parent = ContentContainer

local CratesLeftBox = createCategoryBox(CratesContainer, "Crates & Airdrop ESP", 10, 10, 300, 360)
local CratesRightBox = createCategoryBox(CratesContainer, "Crates Settings", 320, 10, 310, 360)

local ResourcesContainer = Instance.new("Frame")
ResourcesContainer.Size = UDim2.new(1, 0, 1, 0)
ResourcesContainer.BackgroundTransparency = 1
ResourcesContainer.Visible = false
ResourcesContainer.Parent = ContentContainer

local ResourcesLeftBox = createCategoryBox(ResourcesContainer, "Resources ESP (Ores & Plants)", 10, 10, 300, 360)
local ResourcesRightBox = createCategoryBox(ResourcesContainer, "Resources Settings", 320, 10, 310, 360)

local RaidsContainer = Instance.new("Frame")
RaidsContainer.Size = UDim2.new(1, 0, 1, 0)
RaidsContainer.BackgroundTransparency = 1
RaidsContainer.Visible = false
RaidsContainer.Parent = ContentContainer

local RaidsLeftBox = createCategoryBox(RaidsContainer, "Raids X-Ray (BuiltObjects)", 10, 10, 300, 360)
local RaidsRightBox = createCategoryBox(RaidsContainer, "Raids Settings", 320, 10, 310, 360)

local AimContainer = Instance.new("Frame")
AimContainer.Size = UDim2.new(1, 0, 1, 0)
AimContainer.BackgroundTransparency = 1
AimContainer.Visible = false
AimContainer.Parent = ContentContainer

local AimLeftBox = createCategoryBox(AimContainer, "Aimbot Settings", 10, 10, 300, 360)
local AimRightBox = createCategoryBox(AimContainer, "FOV & Hitboxes", 320, 10, 310, 360)

local PlayerContainer = Instance.new("Frame")
PlayerContainer.Size = UDim2.new(1, 0, 1, 0)
PlayerContainer.BackgroundTransparency = 1
PlayerContainer.Visible = false
PlayerContainer.Parent = ContentContainer

local PlayerLeftBox = createCategoryBox(PlayerContainer, "Player Settings", 10, 10, 300, 360)

local TeamContainer = Instance.new("Frame")
TeamContainer.Size = UDim2.new(1, 0, 1, 0)
TeamContainer.BackgroundTransparency = 1
TeamContainer.Visible = false
TeamContainer.Parent = ContentContainer

local TeamMainBox = createCategoryBox(TeamContainer, "Team Manager (Players / Friends)", 10, 10, 620, 360)
TeamMainBox.CanvasSize = UDim2.new(0, 0, 0, 0)

local TeamHUDGui = Instance.new("ScreenGui")
TeamHUDGui.Name = "InveriumTeamHUD"
TeamHUDGui.Parent = CoreGui
TeamHUDGui.ResetOnSpawn = false

local TeamHUDFrame = Instance.new("Frame")
TeamHUDFrame.Size = UDim2.new(0, 180, 0, 120)
TeamHUDFrame.Position = UDim2.new(0, 10, 0, 10)
TeamHUDFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
TeamHUDFrame.BackgroundTransparency = MENU_SETTINGS.TeamHUDTransparency
TeamHUDFrame.BorderSizePixel = 0
TeamHUDFrame.Parent = TeamHUDGui

local HUDCorner = Instance.new("UICorner")
HUDCorner.CornerRadius = UDim.new(0, 6)
HUDCorner.Parent = TeamHUDFrame

local HUDTitle = Instance.new("TextLabel")
HUDTitle.Size = UDim2.new(1, -10, 0, 25)
HUDTitle.Position = UDim2.new(0, 10, 0, 5)
HUDTitle.BackgroundTransparency = 1
HUDTitle.Font = Enum.Font.GothamBold
HUDTitle.Text = "TEAM"
HUDTitle.TextColor3 = Color3.fromRGB(50, 255, 50)
HUDTitle.TextSize = 12
HUDTitle.TextXAlignment = Enum.TextXAlignment.Left
HUDTitle.Parent = TeamHUDFrame

local HUDListContainer = Instance.new("ScrollingFrame")
HUDListContainer.Size = UDim2.new(1, -10, 1, -35)
HUDListContainer.Position = UDim2.new(0, 5, 0, 30)
HUDListContainer.BackgroundTransparency = 1
HUDListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
HUDListContainer.ScrollBarThickness = 2
HUDListContainer.Parent = TeamHUDFrame

local function updateTeamHUD()
    for _, child in ipairs(HUDListContainer:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local yOffset = 0
    for _, playerName in ipairs(TEAM_MEMBERS) do
        local memberLbl = Instance.new("TextLabel")
        memberLbl.Size = UDim2.new(1, 0, 0, 20)
        memberLbl.Position = UDim2.new(0, 5, 0, yOffset)
        memberLbl.BackgroundTransparency = 1
        memberLbl.Font = Enum.Font.GothamMedium
        memberLbl.Text = "• " .. playerName
        memberLbl.TextColor3 = Color3.fromRGB(50, 255, 50)
        memberLbl.TextSize = 11
        memberLbl.TextXAlignment = Enum.TextXAlignment.Left
        memberLbl.Parent = HUDListContainer
        
        yOffset = yOffset + 20
    end
    HUDListContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

local searchBoxInput = ""
local teamButtonsList = {}

local searchInputBar = Instance.new("TextBox")
searchInputBar.Size = UDim2.new(1, -24, 0, 30)
searchInputBar.Position = UDim2.new(0, 12, 0, 38)
searchInputBar.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
searchInputBar.Font = Enum.Font.Gotham
searchInputBar.PlaceholderText = "Search by player name..."
searchInputBar.Text = ""
searchInputBar.TextColor3 = Color3.fromRGB(255, 255, 255)
searchInputBar.PlaceholderColor3 = Color3.fromRGB(150, 140, 170)
searchInputBar.TextSize = 12
searchInputBar.Parent = TeamMainBox

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 4)
searchCorner.Parent = searchInputBar

local playerListContainer = Instance.new("ScrollingFrame")
playerListContainer.Size = UDim2.new(1, -24, 1, -85)
playerListContainer.Position = UDim2.new(0, 12, 0, 78)
playerListContainer.BackgroundTransparency = 1
playerListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListContainer.ScrollBarThickness = 3
playerListContainer.Parent = TeamMainBox

local function refreshTeamPlayerList()
    for _, btn in pairs(teamButtonsList) do
        if btn and btn.Parent then
            btn:Destroy()
        end
    end
    teamButtonsList = {}

    local allPlayers = Players:GetPlayers()
    table.sort(allPlayers, function(a, b)
        local aFriend = pcall(function() return a:IsFriendsWith(LocalPlayer.UserId) end) and a:IsFriendsWith(LocalPlayer.UserId) or false
        local bFriend = pcall(function() return b:IsFriendsWith(LocalPlayer.UserId) end) and b:IsFriendsWith(LocalPlayer.UserId) or false
        if aFriend and not bFriend then return true end
        if not aFriend and bFriend then return false end
        return a.Name < b.Name
    end)

    local yPos = 0
    for _, plr in ipairs(allPlayers) do
        if plr ~= LocalPlayer then
            local isMatch = true
            if searchBoxInput ~= "" then
                if not string.find(plr.Name:lower(), searchBoxInput:lower()) and not string.find(plr.DisplayName:lower(), searchBoxInput:lower()) then
                    isMatch = false
                end
            end

            if isMatch then
                local isFriend = false
                pcall(function()
                    isFriend = plr:IsFriendsWith(LocalPlayer.UserId)
                end)

                local inTeam = false
                for _, nameInTeam in ipairs(TEAM_MEMBERS) do
                    if nameInTeam == plr.Name then
                        inTeam = true
                        break
                    end
                end

                local pBtn = Instance.new("TextButton")
                pBtn.Size = UDim2.new(1, 0, 0, 32)
                pBtn.Position = UDim2.new(0, 0, 0, yPos)
                pBtn.BackgroundColor3 = inTeam and Color3.fromRGB(30, 60, 35) or Color3.fromRGB(40, 35, 55)
                pBtn.Font = Enum.Font.GothamMedium
                pBtn.Text = "  " .. plr.Name .. (isFriend and " [FRIEND]" or "") .. (inTeam and " [IN TEAM]" or "")
                pBtn.TextColor3 = inTeam and Color3.fromRGB(50, 255, 50) or (isFriend and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(200, 200, 210))
                pBtn.TextSize = 12
                pBtn.TextXAlignment = Enum.TextXAlignment.Left
                pBtn.Parent = playerListContainer

                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(0, 4)
                pCorner.Parent = pBtn

                local connClick = pBtn.MouseButton1Click:Connect(function()
                    local foundIdx = nil
                    for idx, nameInTeam in ipairs(TEAM_MEMBERS) do
                        if nameInTeam == plr.Name then
                            foundIdx = idx
                            break
                        end
                    end

                    if foundIdx then
                        table.remove(TEAM_MEMBERS, foundIdx)
                    else
                        table.insert(TEAM_MEMBERS, plr.Name)
                    end
                    refreshTeamPlayerList()
                    updateTeamHUD()
                end)
                table.insert(getgenv().InveriumLoneSurvival_Connections, connClick)
                table.insert(teamButtonsList, pBtn)

                yPos = yPos + 38
            end
        end
    end
    playerListContainer.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

local connSearch = searchInputBar:GetPropertyChangedSignal("Text"):Connect(function()
    searchBoxInput = searchInputBar.Text
    refreshTeamPlayerList()
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connSearch)

refreshTeamPlayerList()

local iconButtons = {}
for i, icon in ipairs(icons) do
    local iconBtn = Instance.new("TextButton")
    iconBtn.Size = UDim2.new(0, 40, 0, 40)
    iconBtn.Position = UDim2.new(0, 7, 0, (i-1) * 45 + 10)
    iconBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(45, 25, 70) or Color3.fromRGB(24, 24, 30)
    iconBtn.Font = Enum.Font.GothamBold
    iconBtn.Text = icon
    iconBtn.TextColor3 = (i == 1) and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(120, 120, 140)
    iconBtn.TextSize = 16
    iconBtn.Parent = SideBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = iconBtn

    iconButtons[i] = iconBtn

    local connBtn = iconBtn.MouseButton1Click:Connect(function()
        for _, btnObj in ipairs(iconButtons) do
            btnObj.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
            btnObj.TextColor3 = Color3.fromRGB(120, 120, 140)
        end
        iconBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
        iconBtn.TextColor3 = Color3.fromRGB(180, 100, 255)
        
        TabsBar.Visible = true
        SettingsContainer.Visible = false
        VisualsContainer.Visible = false
        CratesContainer.Visible = false
        ResourcesContainer.Visible = false
        RaidsContainer.Visible = false
        AimContainer.Visible = false
        PlayerContainer.Visible = false
        TeamContainer.Visible = false

        if i == 1 then
            SettingsContainer.Visible = true
            updateTabs("SettingsTabBtn")
        elseif i == 2 then
            VisualsContainer.Visible = true
            updateTabs("VisualsTabBtn")
        elseif i == 3 then
            CratesContainer.Visible = true
            updateTabs("CratesTabBtn")
        elseif i == 4 then
            ResourcesContainer.Visible = true
            updateTabs("ResourcesTabBtn")
        elseif i == 5 then
            RaidsContainer.Visible = true
            updateTabs("RaidsTabBtn")
        elseif i == 6 then
            AimContainer.Visible = true
            updateTabs("AimTabBtn")
        elseif i == 7 then
            PlayerContainer.Visible = true
            updateTabs("PlayerTabBtn")
        elseif i == 8 then
            TeamContainer.Visible = true
            updateTabs("TeamTabBtn")
            refreshTeamPlayerList()
        else
            TabsBar.Visible = false
        end
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connBtn)
end

updateTabs("SettingsTabBtn")
SettingsContainer.Visible = true
VisualsContainer.Visible = false
CratesContainer.Visible = false
ResourcesContainer.Visible = false
RaidsContainer.Visible = false
AimContainer.Visible = false
PlayerContainer.Visible = false
TeamContainer.Visible = false

local KeybindsGui = Instance.new("ScreenGui")
KeybindsGui.Name = "InveriumKeybinds"
KeybindsGui.Parent = CoreGui
KeybindsGui.ResetOnSpawn = false

local KeybindsMenu = Instance.new("Frame")
KeybindsMenu.Size = UDim2.new(0, 220, 0, 135)
KeybindsMenu.Position = UDim2.new(0, 10, 1, -155)
KeybindsMenu.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
KeybindsMenu.BackgroundTransparency = MENU_SETTINGS.BindManagerTransparency
KeybindsMenu.BorderSizePixel = 0
KeybindsMenu.Parent = KeybindsGui

local KeybindsCorner = Instance.new("UICorner")
KeybindsCorner.CornerRadius = UDim.new(0, 6)
KeybindsCorner.Parent = KeybindsMenu

local KBTitle = Instance.new("TextLabel")
KBTitle.Size = UDim2.new(1, -15, 0, 25)
KBTitle.Position = UDim2.new(0, 10, 0, 5)
KBTitle.BackgroundTransparency = 1
KBTitle.Font = Enum.Font.GothamBold
KBTitle.Text = "Bind Manager"
KBTitle.TextColor3 = Color3.fromRGB(180, 130, 230)
KBTitle.TextSize = 11
KBTitle.TextXAlignment = Enum.TextXAlignment.Left
KBTitle.Parent = KeybindsMenu

local function createStatusRow(parent, name, yPos)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 22)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lblName = Instance.new("TextLabel")
    lblName.Size = UDim2.new(0.65, 0, 1, 0)
    lblName.BackgroundTransparency = 1
    lblName.Font = Enum.Font.Gotham
    lblName.Text = name
    lblName.TextColor3 = Color3.fromRGB(200, 200, 210)
    lblName.TextSize = 11
    lblName.TextXAlignment = Enum.TextXAlignment.Left
    lblName.Parent = row

    local lblStatus = Instance.new("TextLabel")
    lblStatus.Size = UDim2.new(0.35, 0, 1, 0)
    lblStatus.Position = UDim2.new(0.65, 0, 0, 0)
    lblStatus.BackgroundTransparency = 1
    lblStatus.Font = Enum.Font.GothamBold
    lblStatus.Text = "OFF"
    lblStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    lblStatus.TextSize = 11
    lblStatus.TextXAlignment = Enum.TextXAlignment.Right
    lblStatus.Parent = row

    return lblStatus
end

local statusAim = createStatusRow(KeybindsMenu, "Aimbot [Active]:", 32)
local statusVisCheck = createStatusRow(KeybindsMenu, "Visible Check:", 57)
local statusAimKey = createStatusRow(KeybindsMenu, "Aiming State:", 82)
local statusHitboxPart = createStatusRow(KeybindsMenu, "Hitbox Bone:", 107)

local connStatusUpdate = RunService.RenderStepped:Connect(function()
    statusAim.Text = AIM_SETTINGS.Enabled and "ON" or "OFF"
    statusAim.TextColor3 = AIM_SETTINGS.Enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    statusVisCheck.Text = AIM_SETTINGS.VisibleCheck and "ON" or "OFF"
    statusVisCheck.TextColor3 = AIM_SETTINGS.VisibleCheck and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    statusAimKey.Text = isAiming and "ACTIVE" or "IDLE"
    statusAimKey.TextColor3 = isAiming and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(140, 140, 160)

    statusHitboxPart.Text = tostring(HITBOX_SETTINGS.TargetPart)
    statusHitboxPart.TextColor3 = Color3.fromRGB(200, 150, 255)

    KeybindsMenu.Visible = MENU_SETTINGS.BindManagerVisible
    TeamHUDFrame.Visible = MENU_SETTINGS.TeamHUDVisible
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connStatusUpdate)

local function createToggle(parent, name, yPos, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 20)
    btn.Position = UDim2.new(1, -40, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    btn.Text = ""
    btn.Parent = toggleFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(150, 140, 170)
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local enabled = false
    local connToggle = btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.Position = UDim2.new(1, -18, 0.5, -8)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
            circle.BackgroundColor3 = Color3.fromRGB(150, 140, 170)
            circle.Position = UDim2.new(0, 2, 0.5, -8)
        end
        callback(enabled)
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connToggle)
end

local function createDropdown(parent, name, yPos, options, defaultOption, callback)
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, -20, 0, 35)
    dropFrame.Position = UDim2.new(0, 10, 0, yPos)
    dropFrame.BackgroundTransparency = 1
    dropFrame.ZIndex = 5
    dropFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = dropFrame

    local currentIdx = 1
    for i, opt in ipairs(options) do
        if opt == defaultOption then
            currentIdx = i
            break
        end
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 0, 24)
    btn.Position = UDim2.new(1, -95, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = options[currentIdx]
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.TextSize = 11
    btn.ZIndex = 5
    btn.Parent = dropFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn

    local connDrop = btn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #options then
            currentIdx = 1
        end
        local chosen = options[currentIdx]
        btn.Text = chosen
        callback(chosen)
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connDrop)
end

local function createKeybind(parent, name, yPos, defaultKey, isMouseKey, callback)
    local bindFrame = Instance.new("Frame")
    bindFrame.Size = UDim2.new(1, -20, 0, 35)
    bindFrame.Position = UDim2.new(0, 10, 0, yPos)
    bindFrame.BackgroundTransparency = 1
    bindFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bindFrame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 24)
    btn.Position = UDim2.new(1, -80, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    btn.Font = Enum.Font.GothamMedium
    local defStr = isMouseKey and "RMB" or tostring(defaultKey):gsub("Enum.KeyCode.", "")
    if tostring(defaultKey):find("MouseButton") then
        defStr = tostring(defaultKey):gsub("Enum.UserInputType.", "")
    elseif tostring(defaultKey):find("Enum.KeyCode.") then
        defStr = tostring(defaultKey):gsub("Enum.KeyCode.", "")
    end
    btn.Text = defStr
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.TextSize = 11
    btn.Parent = bindFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn

    local binding = false
    local connBind = btn.MouseButton1Click:Connect(function()
        binding = true
        btn.Text = "..."
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connBind)

    local connInput = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if binding then
            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
                local nameStr = tostring(key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
                if nameStr == "MouseButton2" then nameStr = "RMB"
                elseif nameStr == "MouseButton1" then nameStr = "LMB" end
                
                btn.Text = nameStr
                btn.TextColor3 = Color3.fromRGB(200, 150, 255)
                binding = false
                callback(key)
            end
        end
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connInput)
end

local function createSlider(parent, name, yPos, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 45)
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    bar.AutoButtonColor = false
    bar.Text = ""
    bar.Parent = sliderFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local draggingSlider = false
    local connDown = bar.MouseButton1Down:Connect(function()
        draggingSlider = true
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connDown)

    local connEnd = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connEnd)

    local connChanged = UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = min + (max - min) * pos
            label.Text = name .. ": " .. string.format("%.2f", val)
            callback(val)
        end
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connChanged)
end

local function createIntSlider(parent, name, yPos, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 45)
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    bar.AutoButtonColor = false
    bar.Text = ""
    bar.Parent = sliderFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local draggingSlider = false
    local connDown = bar.MouseButton1Down:Connect(function()
        draggingSlider = true
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connDown)

    local connEnd = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connEnd)

    local connChanged = UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            label.Text = name .. ": " .. val
            callback(val)
        end
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connChanged)
end

createSlider(SettingsLeftBox, "Bind Manager Transparency", 40, 0, 1, 0.35, function(v)
    MENU_SETTINGS.BindManagerTransparency = v
    KeybindsMenu.BackgroundTransparency = v
end)

createSlider(SettingsLeftBox, "Team HUD Transparency", 95, 0, 1, 0.4, function(v)
    MENU_SETTINGS.TeamHUDTransparency = v
    TeamHUDFrame.BackgroundTransparency = v
end)

createToggle(SettingsLeftBox, "Visible Bind Manager", 150, function(v)
    MENU_SETTINGS.BindManagerVisible = v
    KeybindsMenu.Visible = v
end)

createToggle(SettingsLeftBox, "Visible Team HUD", 195, function(v)
    MENU_SETTINGS.TeamHUDVisible = v
    TeamHUDFrame.Visible = v
end)

createToggle(SettingsRightBox, "FullBright", 40, function(v)
    PLAYER_SETTINGS.FullBright = v
end)

createToggle(SettingsRightBox, "Anti-Fog", 85, function(v)
    PLAYER_SETTINGS.AntiFog = v
    if not v then
        Lighting.FogEnd = 100000
    end
end)

createToggle(SettingsRightBox, "RTX Mod (Cinematic)", 130, function(v)
    PLAYER_SETTINGS.RTXGraphics = v
    pcall(function()
        if v then
            Lighting.GlobalShadows = true
            Lighting.Technology = Enum.Technology.Future

            local cc = Lighting:FindFirstChild("InveriumRTXCC")
            if not cc then
                cc = Instance.new("ColorCorrectionEffect")
                cc.Name = "InveriumRTXCC"
                cc.Parent = Lighting
            end
            cc.Brightness = 0.03
            cc.Contrast = 0.35
            cc.Saturation = 0.15
            cc.TintColor = Color3.fromRGB(250, 243, 235)

            local bloom = Lighting:FindFirstChild("InveriumRTXBloom")
            if not bloom then
                bloom = Instance.new("BloomEffect")
                bloom.Name = "InveriumRTXBloom"
                bloom.Parent = Lighting
            end
            bloom.Intensity = 0.22
            bloom.Size = 24
            bloom.Threshold = 0.8

            local rays = Lighting:FindFirstChild("InveriumRTXRays")
            if not rays then
                rays = Instance.new("SunRaysEffect")
                rays.Name = "InveriumRTXRays"
                rays.Parent = Lighting
            end
            rays.Intensity = 0.25
            rays.Spread = 0.95

            local depth = Lighting:FindFirstChild("InveriumRTXDepth")
            if not depth then
                depth = Instance.new("DepthOfFieldEffect")
                depth.Name = "InveriumRTXDepth"
                depth.Parent = Lighting
            end
            depth.FarIntensity = 0.1
            depth.FocusDistance = 35
            depth.InFocusRadius = 25
            depth.NearIntensity = 0.05
        else
            local cc = Lighting:FindFirstChild("InveriumRTXCC")
            if cc then cc:Destroy() end
            local bloom = Lighting:FindFirstChild("InveriumRTXBloom")
            if bloom then bloom:Destroy() end
            local rays = Lighting:FindFirstChild("InveriumRTXRays")
            if rays then rays:Destroy() end
            local depth = Lighting:FindFirstChild("InveriumRTXDepth")
            if depth then depth:Destroy() end
        end
    end)
end)

createToggle(LeftBox, "ESP Master Toggle", 40, function(v) ESP_SETTINGS.Enabled = v end)
createToggle(LeftBox, "Chams", 85, function(v) ESP_SETTINGS.Chams = v end)
createToggle(LeftBox, "Boxes", 130, function(v) ESP_SETTINGS.Boxes = v end)
createToggle(LeftBox, "Player Names", 175, function(v) ESP_SETTINGS.Names = v end)
createToggle(LeftBox, "Health Bar", 220, function(v) ESP_SETTINGS.Health = v end)
createToggle(LeftBox, "Tracers", 265, function(v) ESP_SETTINGS.Tracers = v end)
createToggle(LeftBox, "Look Direction", 310, function(v) ESP_SETTINGS.LookDirection = v end)
createToggle(LeftBox, "Visible Check (Red/Blue)", 355, function(v) ESP_SETTINGS.VisibleCheck = v end)

local diedEspHeader = Instance.new("TextLabel")
diedEspHeader.Size = UDim2.new(1, -20, 0, 25)
diedEspHeader.Position = UDim2.new(0, 10, 0, 180)
diedEspHeader.BackgroundTransparency = 1
diedEspHeader.Font = Enum.Font.GothamBold
diedEspHeader.Text = "Died ESP (Backpack)"
diedEspHeader.TextColor3 = Color3.fromRGB(235, 215, 80)
diedEspHeader.TextSize = 12
diedEspHeader.TextXAlignment = Enum.TextXAlignment.Left
diedEspHeader.Parent = RightBox

createToggle(RightBox, "Died ESP Enable", 210, function(v) DIED_ESP_SETTINGS.Enabled = v end)
createToggle(RightBox, "Died ESP Chams", 255, function(v) DIED_ESP_SETTINGS.Chams = v end)
createToggle(RightBox, "Died ESP Names", 300, function(v) DIED_ESP_SETTINGS.Names = v end)

createIntSlider(RightBox, "Max Distance", 40, 100, 5000, 1500, function(v)
    ESP_SETTINGS.MaxDistance = v
end)

local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, -20, 0, 20)
colorLabel.Position = UDim2.new(0, 10, 0, 100)
colorLabel.BackgroundTransparency = 1
colorLabel.Font = Enum.Font.Gotham
colorLabel.Text = "ESP Color Palette:"
colorLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
colorLabel.TextSize = 12
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Parent = RightBox

local colors = {
    {"Soft Red", Color3.fromRGB(245, 90, 90)},
    {"Soft Green", Color3.fromRGB(90, 220, 130)},
    {"Soft Blue", Color3.fromRGB(90, 160, 245)},
    {"Soft Purple", Color3.fromRGB(155, 90, 230)},
    {"Soft Yellow", Color3.fromRGB(235, 215, 80)}
}

for i, colData in ipairs(colors) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 45, 0, 30)
    cBtn.Position = UDim2.new(0, 10 + (i-1) * 52, 0, 130)
    cBtn.BackgroundColor3 = colData[2]
    cBtn.Text = ""
    cBtn.Parent = RightBox

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 4)
    cCorner.Parent = cBtn

    local connCol = cBtn.MouseButton1Click:Connect(function()
        ESP_SETTINGS.BaseColor = colData[2]
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connCol)
end

createToggle(CratesLeftBox, "Airdrop ESP", 40, function(v) CRATES_SETTINGS.Airdrop = v end)
createToggle(CratesLeftBox, "Food Crate", 85, function(v) CRATES_SETTINGS.FoodCrate = v end)
createToggle(CratesLeftBox, "Large Crate", 130, function(v) CRATES_SETTINGS.LargeCrate = v end)
createToggle(CratesLeftBox, "Medbag", 175, function(v) CRATES_SETTINGS.Medbag = v end)
createToggle(CratesLeftBox, "Military Crate", 220, function(v) CRATES_SETTINGS.MilitaryCrate = v end)
createToggle(CratesLeftBox, "SNTech Crate", 265, function(v) CRATES_SETTINGS.SNTechCrate = v end)
createToggle(CratesLeftBox, "Tool Box", 310, function(v) CRATES_SETTINGS.ToolBox = v end)
createToggle(CratesLeftBox, "Vault", 355, function(v) CRATES_SETTINGS.Vault = v end)
createToggle(CratesLeftBox, "Diesel Barrel", 400, function(v) CRATES_SETTINGS.DieselBarrel = v end)
createToggle(CratesLeftBox, "Locked Crate", 445, function(v) CRATES_SETTINGS.LockedCrate = v end)

createToggle(CratesRightBox, "Crates Names & Distance", 40, function(v) CRATES_SETTINGS.Names = v end)
createToggle(CratesRightBox, "Crates Chams", 85, function(v) CRATES_SETTINGS.Chams = v end)

createIntSlider(CratesRightBox, "Crates Max Distance", 130, 500, 10000, 3000, function(v)
    CRATES_SETTINGS.MaxDistance = v
end)

createToggle(ResourcesLeftBox, "Brimstone Ore", 40, function(v) RESOURCES_SETTINGS.BrimstoneOre = v end)
createToggle(ResourcesLeftBox, "Iron Ore", 85, function(v) RESOURCES_SETTINGS.IronOre = v end)
createToggle(ResourcesLeftBox, "Stone Ore", 130, function(v) RESOURCES_SETTINGS.StoneOre = v end)
createToggle(ResourcesLeftBox, "Cloth Plant", 175, function(v) RESOURCES_SETTINGS.ClothPlant = v end)

createToggle(ResourcesRightBox, "Resources Names & Distance", 40, function(v) RESOURCES_SETTINGS.Names = v end)
createToggle(ResourcesRightBox, "Resources Chams", 85, function(v) RESOURCES_SETTINGS.Chams = v end)

createIntSlider(ResourcesRightBox, "Resources Max Distance", 130, 500, 10000, 3000, function(v)
    RESOURCES_SETTINGS.MaxDistance = v
end)

createToggle(RaidsLeftBox, "BuiltObjects X-Ray", 40, function(v)
    RAIDS_SETTINGS.XRayEnabled = v
end)

createKeybind(RaidsLeftBox, "X-Ray Toggle Key", 85, Enum.KeyCode.X, false, function(v)
    RAIDS_SETTINGS.Key = v
end)

createSlider(RaidsRightBox, "X-Ray Transparency", 40, 0, 1, 0.5, function(v)
    RAIDS_SETTINGS.Transparency = v
end)

createToggle(AimLeftBox, "Aimbot Enable", 40, function(v) AIM_SETTINGS.Enabled = v end)
createKeybind(AimLeftBox, "Aim Key", 85, Enum.UserInputType.MouseButton2, true, function(v) AIM_SETTINGS.Key = v end)
createToggle(AimLeftBox, "Aim Hold Mode", 130, function(v) AIM_SETTINGS.HoldMode = v end)
createSlider(AimLeftBox, "Smoothness (0-1)", 175, 0, 1, 0.05, function(v) AIM_SETTINGS.Smoothness = v end)

createDropdown(AimLeftBox, "Aim Target Bone", 230, {"UpperTorso", "Head", "HumanoidRootPart"}, "UpperTorso", function(v)
    AIM_SETTINGS.TargetPart = v
end)

createToggle(AimLeftBox, "Visible Check", 275, function(v) AIM_SETTINGS.VisibleCheck = v end)
createKeybind(AimLeftBox, "Visible Check Key", 320, Enum.KeyCode.F, false, function(v) AIM_SETTINGS.VisibleCheckKey = v end)
createIntSlider(AimLeftBox, "Aim Range", 365, 100, 5000, 2000, function(v) AIM_SETTINGS.Range = v end)

createToggle(AimLeftBox, "No Bullet Drop", 420, function(v) AIM_SETTINGS.NoBulletDrop = v end)

createToggle(AimRightBox, "Show FOV", 40, function(v) AIM_SETTINGS.ShowFOV = v end)
createIntSlider(AimRightBox, "FOV Radius", 85, 20, 600, 250, function(v) AIM_SETTINGS.FOVRadius = v end)

createToggle(AimRightBox, "Big Hitboxes", 150, function(v) HITBOX_SETTINGS.Enabled = v end)
createIntSlider(AimRightBox, "Hitbox Size", 195, 1, 250, 3, function(v) HITBOX_SETTINGS.Size = v end)

createDropdown(AimRightBox, "Hitbox Target Bone", 250, {"HumanoidRootPart", "Head"}, "HumanoidRootPart", function(v)
    HITBOX_SETTINGS.TargetPart = v
end)

createKeybind(AimRightBox, "Hitbox Switch Key", 295, Enum.KeyCode.Q, false, function(v)
    HITBOX_SETTINGS.SwitchKey = v
end)

local aimColorLabel = Instance.new("TextLabel")
aimColorLabel.Size = UDim2.new(1, -20, 0, 20)
aimColorLabel.Position = UDim2.new(0, 10, 0, 345)
aimColorLabel.BackgroundTransparency = 1
aimColorLabel.Font = Enum.Font.Gotham
aimColorLabel.Text = "FOV Color Palette:"
aimColorLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
aimColorLabel.TextSize = 12
aimColorLabel.TextXAlignment = Enum.TextXAlignment.Left
aimColorLabel.Parent = AimRightBox

for i, colData in ipairs(colors) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 45, 0, 30)
    cBtn.Position = UDim2.new(0, 10 + (i-1) * 52, 0, 375)
    cBtn.BackgroundColor3 = colData[2]
    cBtn.Text = ""
    cBtn.Parent = AimRightBox

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 4)
    cCorner.Parent = cBtn

    local connAimCol = cBtn.MouseButton1Click:Connect(function()
        AIM_SETTINGS.BaseColor = colData[2]
    end)
    table.insert(getgenv().InveriumLoneSurvival_Connections, connAimCol)
end

createToggle(PlayerLeftBox, "Enable Custom FOV", 40, function(v)
    PLAYER_SETTINGS.EnableFOV = v
    if not v and Workspace.CurrentCamera then
        Workspace.CurrentCamera.FieldOfView = 70
    end
end)

createIntSlider(PlayerLeftBox, "Field of View (FOV)", 85, 50, 120, 70, function(v)
    PLAYER_SETTINGS.FOV = v
end)

local connPlayerLoop = RunService.RenderStepped:Connect(function()
    if PLAYER_SETTINGS.FullBright then
        if not PLAYER_SETTINGS.RTXGraphics then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = 2.4
            Lighting.ClockTime = 14.5
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(160, 165, 180)
            Lighting.Ambient = Color3.fromRGB(75, 75, 90)
        end
    end

    if PLAYER_SETTINGS.AntiFog then
        Lighting.FogEnd = 999999
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") or obj:IsA("Fog") then
                obj.Parent = nil
            end
        end
    end

    if PLAYER_SETTINGS.RTXGraphics and not PLAYER_SETTINGS.FullBright then
        pcall(function()
            Lighting.ExposureCompensation = 0.15
            Lighting.OutdoorAmbient = Color3.fromRGB(115, 120, 130)
            Lighting.Ambient = Color3.fromRGB(50, 50, 60)
        end)
    end

    local camera = Workspace.CurrentCamera
    if camera then
        if PLAYER_SETTINGS.EnableFOV then
            if camera.FieldOfView ~= PLAYER_SETTINGS.FOV then
                camera.FieldOfView = PLAYER_SETTINGS.FOV
            end
        else
            if camera.FieldOfView ~= 70 then
                camera.FieldOfView = 70
            end
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connPlayerLoop)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Filled = false
table.insert(getgenv().InveriumLoneSurvival_Drawings, fovCircle)

local function isTargetVisible(targetPart)
    local camera = Workspace.CurrentCamera
    if not camera or not targetPart then return false end

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin
    local rayResult = Workspace:Raycast(origin, direction, rayParams)

    if rayResult then
        local hitInstance = rayResult.Instance
        if hitInstance:IsDescendantOf(targetPart.Parent) then
            return true
        end
        return false
    end
    return true
end

local function getNoBulletDropPosition(cameraPos, targetPart)
    local basePos = targetPart.Position
    if not AIM_SETTINGS.NoBulletDrop then
        return basePos
    end

    local distance = (cameraPos - basePos).Magnitude
    local correction = math.clamp(distance * 0.03, 0, 4)

    return basePos + Vector3.new(0, correction, 0)
end

local cachedModelsForHitbox = {}
local lastHitboxUpdate = 0

local connHitboxKey = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        local targetKey = HITBOX_SETTINGS.SwitchKey
        local isMatched = false
        if typeof(targetKey) == "EnumItem" then
            if targetKey.EnumType == Enum.KeyCode and input.KeyCode == targetKey then
                isMatched = true
            elseif targetKey.EnumType == Enum.UserInputType and input.UserInputType == targetKey then
                isMatched = true
            end
        end

        if isMatched then
            for _, data in ipairs(cachedModelsForHitbox) do
                if data.Character then
                    local hrp = data.Character:FindFirstChild("HumanoidRootPart")
                    local head = data.Character:FindFirstChild("Head")
                    if hrp then hrp.Size = Vector3.new(2, 2, 1) hrp.Transparency = 1 end
                    if head then head.Size = Vector3.new(1, 1, 1) head.Transparency = 0 end
                end
            end

            if HITBOX_SETTINGS.TargetPart == "HumanoidRootPart" then
                HITBOX_SETTINGS.TargetPart = "Head"
            else
                HITBOX_SETTINGS.TargetPart = "HumanoidRootPart"
            end
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connHitboxKey)

local connHitboxes = RunService.Heartbeat:Connect(function()
    local currentTime = os.clock()
    if currentTime - lastHitboxUpdate > 1.0 then
        lastHitboxUpdate = currentTime
        cachedModelsForHitbox = {}

        local searchFolders = {
            Players,
            Workspace:FindFirstChild("Players"),
            Workspace:FindFirstChild("OfflinePlayers"),
            Workspace:FindFirstChild("AI"),
            Workspace:FindFirstChild("Enemies"),
            Workspace:FindFirstChild("Monsters")
        }

        for _, folder in ipairs(searchFolders) do
            if folder then
                local items = (folder == Players) and folder:GetPlayers() or folder:GetChildren()
                for _, item in ipairs(items) do
                    local character = (folder == Players) and item.Character or item
                    if character and character:IsA("Model") and character ~= LocalPlayer.Character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        local rootPart = character:FindFirstChild("HumanoidRootPart") 
                            or character:FindFirstChild("UpperTorso") 
                            or character:FindFirstChild("Torso")

                        if humanoid and rootPart then
                            table.insert(cachedModelsForHitbox, {Character = character, Humanoid = humanoid, RootPart = rootPart, Name = item.Name})
                        end
                    end
                end
            end
        end
    end

    for _, data in ipairs(cachedModelsForHitbox) do
        local character = data.Character
        local humanoid = data.Humanoid
        
        local isTeamMember = false
        for _, nameInTeam in ipairs(TEAM_MEMBERS) do
            if nameInTeam == data.Name then
                isTeamMember = true
                break
            end
        end

        if character and character.Parent and humanoid and humanoid.Health > 0 then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local targetHitboxPart = character:FindFirstChild(HITBOX_SETTINGS.TargetPart) or data.RootPart

            if HITBOX_SETTINGS.Enabled and not isTeamMember then
                if hrp and HITBOX_SETTINGS.TargetPart ~= "HumanoidRootPart" then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                end
                if head and HITBOX_SETTINGS.TargetPart ~= "Head" then
                    head.Size = Vector3.new(1, 1, 1)
                    head.Transparency = 0
                end

                if targetHitboxPart then
                    targetHitboxPart.Transparency = HITBOX_SETTINGS.Transparency
                    local multiplier = (targetHitboxPart == head) and 1.5 or 2
                    local desiredSize = Vector3.new(HITBOX_SETTINGS.Size * multiplier, HITBOX_SETTINGS.Size * multiplier, HITBOX_SETTINGS.Size * multiplier)
                    
                    if targetHitboxPart.Size ~= desiredSize then
                        targetHitboxPart.Size = desiredSize
                    end
                    
                    targetHitboxPart.CanCollide = false
                end
            else
                if hrp then
                    hrp.Transparency = 1
                    if hrp.Size ~= Vector3.new(2, 2, 1) then hrp.Size = Vector3.new(2, 2, 1) end
                    hrp.CanCollide = true
                end
                if head then
                    head.Transparency = 0
                    if head.Size ~= Vector3.new(1, 1, 1) then head.Size = Vector3.new(1, 1, 1) end
                end
            end
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connHitboxes)

local connRender = RunService.Heartbeat:Connect(function()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    if AIM_SETTINGS.ShowFOV then
        fovCircle.Visible = true
        fovCircle.Radius = AIM_SETTINGS.FOVRadius
        fovCircle.Position = UserInputService:GetMouseLocation()
        fovCircle.Color = AIM_SETTINGS.BaseColor
    else
        fovCircle.Visible = false
    end

    if AIM_SETTINGS.Enabled and isAiming then
        local mousePos = UserInputService:GetMouseLocation()
        
        if lockedTarget and lockedTarget.Parent then
            local humanoid = lockedTarget.Parent:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                lockedTarget = nil
            end
        else
            lockedTarget = nil
        end

        if not lockedTarget then
            local shortestDist = AIM_SETTINGS.FOVRadius
            
            for _, data in ipairs(cachedModelsForHitbox) do
                local character = data.Character
                local humanoid = data.Humanoid
                
                local isTeamMember = false
                for _, nameInTeam in ipairs(TEAM_MEMBERS) do
                    if nameInTeam == data.Name then
                        isTeamMember = true
                        break
                    end
                end

                if character and humanoid and humanoid.Health > 0 and not isTeamMember then
                    local targetPart = character:FindFirstChild(AIM_SETTINGS.TargetPart) 
                        or character:FindFirstChild("UpperTorso") 
                        or data.RootPart
                        
                    if targetPart then
                        local passesVisibility = true
                        if AIM_SETTINGS.VisibleCheck then
                            passesVisibility = isTargetVisible(targetPart)
                        end
                        
                        if passesVisibility then
                            local distance = (camera.CFrame.Position - targetPart.Position).Magnitude
                            if distance <= AIM_SETTINGS.Range then
                                local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                                if onScreen then
                                    local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                    if magnitude <= shortestDist then
                                        shortestDist = magnitude
                                        lockedTarget = targetPart
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if lockedTarget then
            local targetPos = getNoBulletDropPosition(camera.CFrame.Position, lockedTarget)
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
            local smoothness = math.clamp(AIM_SETTINGS.Smoothness, 0, 0.999)
            
            if smoothness <= 0.001 then
                camera.CFrame = targetCFrame
            else
                camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 - smoothness)
            end
        end
    else
        lockedTarget = nil
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connRender)

local connBindCheck = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == AIM_SETTINGS.VisibleCheckKey or input.UserInputType == AIM_SETTINGS.VisibleCheckKey then
            AIM_SETTINGS.VisibleCheck = not AIM_SETTINGS.VisibleCheck
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connBindCheck)

local connInsert = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connInsert)

local activeEspCache = {}

local function removeEspCache(model)
    if activeEspCache[model] then
        pcall(function()
            if activeEspCache[model].Box then activeEspCache[model].Box:Remove() end
            if activeEspCache[model].NameText then activeEspCache[model].NameText:Remove() end
            if activeEspCache[model].HpText then activeEspCache[model].HpText:Remove() end
            if activeEspCache[model].Tracer then activeEspCache[model].Tracer:Remove() end
            if activeEspCache[model].LookLine then activeEspCache[model].LookLine:Remove() end
            if activeEspCache[model].Highlight then activeEspCache[model].Highlight:Destroy() end
        end)
        activeEspCache[model] = nil
    end
end

local connUniversalESP = RunService.RenderStepped:Connect(function()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    local currentModels = {}

    if ESP_SETTINGS.Enabled then
        for _, data in ipairs(cachedModelsForHitbox) do
            if data.Character and data.Character ~= LocalPlayer.Character and data.Humanoid.Health > 0 then
                currentModels[data.Character] = {
                    Humanoid = data.Humanoid,
                    RootPart = data.RootPart,
                    Name = data.Name,
                    Character = data.Character
                }
            end
        end
    end

    for model, data in pairs(currentModels) do
        local cache = activeEspCache[model]
        if not cache then
            cache = {
                Box = Drawing.new("Square"),
                NameText = Drawing.new("Text"),
                HpText = Drawing.new("Text"),
                Tracer = Drawing.new("Line"),
                LookLine = Drawing.new("Line"),
                Highlight = Instance.new("Highlight")
            }
            cache.Box.Visible = false
            cache.Box.Thickness = 1
            cache.Box.Filled = false

            cache.NameText.Visible = false
            cache.NameText.Size = 13
            cache.NameText.Center = true
            cache.NameText.Outline = true

            cache.HpText.Visible = false
            cache.HpText.Size = 12
            cache.HpText.Center = true
            cache.HpText.Outline = true

            cache.Tracer.Visible = false
            cache.Tracer.Thickness = 1

            cache.LookLine.Visible = false
            cache.LookLine.Thickness = 1

            cache.Highlight.FillTransparency = 0.5
            cache.Highlight.OutlineTransparency = 1
            cache.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            cache.Highlight.Adornee = model
            cache.Highlight.Parent = model

            activeEspCache[model] = cache
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.Box)
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.NameText)
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.HpText)
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.Tracer)
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.LookLine)
        end

        local rootPart = data.RootPart
        local humanoid = data.Humanoid
        local dist = (camera.CFrame.Position - rootPart.Position).Magnitude

        local isTeamMember = false
        for _, nameInTeam in ipairs(TEAM_MEMBERS) do
            if nameInTeam == data.Name then
                isTeamMember = true
                break
            end
        end

        if dist <= ESP_SETTINGS.MaxDistance then
            local isVisible = false
            if ESP_SETTINGS.VisibleCheck then
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character, model}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local rayResult = Workspace:Raycast(camera.CFrame.Position, rootPart.Position - camera.CFrame.Position, rayParams)
                if not rayResult then isVisible = true end
            end

            local currentColor = ESP_SETTINGS.BaseColor
            if isTeamMember then
                currentColor = Color3.fromRGB(90, 220, 130)
            elseif ESP_SETTINGS.VisibleCheck then
                currentColor = isVisible and Color3.fromRGB(90, 160, 245) or Color3.fromRGB(245, 90, 90)
            end

            cache.Highlight.Enabled = ESP_SETTINGS.Chams
            cache.Highlight.FillColor = currentColor
            if cache.Highlight.Adornee ~= model then
                cache.Highlight.Adornee = model
            end

            local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local scaleFactor = math.clamp(2500 / pos.Z, 20, 500)
                local w = scaleFactor / 2
                local h = scaleFactor

                if ESP_SETTINGS.Boxes then
                    cache.Box.Size = Vector2.new(w, h)
                    cache.Box.Position = Vector2.new(pos.X - w / 2, pos.Y - h / 2)
                    cache.Box.Color = currentColor
                    cache.Box.Visible = true
                else
                    cache.Box.Visible = false
                end

                if ESP_SETTINGS.Names then
                    cache.NameText.Text = data.Name .. (isTeamMember and " [TEAM]" or "")
                    cache.NameText.Position = Vector2.new(pos.X, pos.Y - h / 2 - 18)
                    cache.NameText.Color = currentColor
                    cache.NameText.Visible = true
                else
                    cache.NameText.Visible = false
                end

                if ESP_SETTINGS.Health then
                    cache.HpText.Text = "HP: " .. math.floor(humanoid.Health) .. " [" .. math.floor(dist) .. "m]"
                    cache.HpText.Position = Vector2.new(pos.X, pos.Y + h / 2 + 4)
                    cache.HpText.Color = currentColor
                    cache.HpText.Visible = true
                else
                    cache.HpText.Visible = false
                end

                if ESP_SETTINGS.Tracers then
                    local viewportSize = camera.ViewportSize
                    cache.Tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                    cache.Tracer.To = Vector2.new(pos.X, pos.Y + h / 2)
                    cache.Tracer.Color = currentColor
                    cache.Tracer.Visible = true
                else
                    cache.Tracer.Visible = false
                end

                if ESP_SETTINGS.LookDirection then
                    local head = data.Character:FindFirstChild("Head") or rootPart
                    local lookEndPos = head.Position + (head.CFrame.LookVector * 10)
                    local headScreenPos, headOnScreen = camera:WorldToViewportPoint(head.Position)
                    local lookScreenPos, lookOnScreen = camera:WorldToViewportPoint(lookEndPos)

                    if headOnScreen and lookOnScreen then
                        cache.LookLine.From = Vector2.new(headScreenPos.X, headScreenPos.Y)
                        cache.LookLine.To = Vector2.new(lookScreenPos.X, lookScreenPos.Y)
                        cache.LookLine.Color = Color3.fromRGB(90, 220, 130)
                        cache.LookLine.Visible = true
                    else
                        cache.LookLine.Visible = false
                    end
                else
                    cache.LookLine.Visible = false
                end
            else
                cache.Box.Visible = false
                cache.NameText.Visible = false
                cache.HpText.Visible = false
                cache.Tracer.Visible = false
                cache.LookLine.Visible = false
            end
        else
            cache.Box.Visible = false
            cache.Highlight.Enabled = false
            cache.NameText.Visible = false
            cache.HpText.Visible = false
            cache.Tracer.Visible = false
            cache.LookLine.Visible = false
        end
    end

    for model, _ in pairs(activeEspCache) do
        if not currentModels[model] or not model.Parent or not model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildOfClass("Humanoid").Health <= 0 then
            removeEspCache(model)
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connUniversalESP)

local activeDiedEspCache = {}

local function removeDiedEspCache(obj)
    if activeDiedEspCache[obj] then
        pcall(function()
            if activeDiedEspCache[obj].Text then activeDiedEspCache[obj].Text:Remove() end
            if activeDiedEspCache[obj].Highlight then activeDiedEspCache[obj].Highlight:Destroy() end
        end)
        activeDiedEspCache[obj] = nil
    end
end

local connDiedESP = RunService.RenderStepped:Connect(function()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    local droppedPacksFolder = Workspace:FindFirstChild("DroppedPacks")
    local currentPacks = {}

    if DIED_ESP_SETTINGS.Enabled and droppedPacksFolder then
        for _, obj in ipairs(droppedPacksFolder:GetChildren()) do
            if obj.Name == "Backpack" then
                local primaryPart = obj.PrimaryPart or obj:FindFirstChild("Cube") or obj:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    currentPacks[obj] = {
                        Object = obj,
                        Part = primaryPart
                    }
                end
            end
        end
    end

    for obj, data in pairs(currentPacks) do
        local cache = activeDiedEspCache[obj]
        if not cache then
            cache = {
                Text = Drawing.new("Text"),
                Highlight = Instance.new("Highlight")
            }
            cache.Text.Visible = false
            cache.Text.Size = 13
            cache.Text.Center = true
            cache.Text.Outline = true

            cache.Highlight.FillTransparency = 0.5
            cache.Highlight.OutlineTransparency = 1
            cache.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            cache.Highlight.Adornee = data.Object
            cache.Highlight.Parent = data.Object

            activeDiedEspCache[obj] = cache
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.Text)
        end

        local part = data.Part
        if part and part.Parent then
            local dist = (camera.CFrame.Position - part.Position).Magnitude

            if dist <= DIED_ESP_SETTINGS.MaxDistance then
                cache.Highlight.Enabled = DIED_ESP_SETTINGS.Chams
                cache.Highlight.FillColor = DIED_ESP_SETTINGS.Color
                if cache.Highlight.Adornee ~= data.Object then
                    cache.Highlight.Adornee = data.Object
                end

                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    if DIED_ESP_SETTINGS.Names then
                        cache.Text.Text = "[Backpack] (" .. math.floor(dist) .. "m)"
                        cache.Text.Position = Vector2.new(pos.X, pos.Y - 10)
                        cache.Text.Color = DIED_ESP_SETTINGS.Color
                        cache.Text.Visible = true
                    else
                        cache.Text.Visible = false
                    end
                else
                    cache.Text.Visible = false
                end
            else
                cache.Text.Visible = false
                cache.Highlight.Enabled = false
            end
        else
            removeDiedEspCache(obj)
        end
    end

    for obj, _ in pairs(activeDiedEspCache) do
        if not currentPacks[obj] or not obj.Parent then
            removeDiedEspCache(obj)
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connDiedESP)

local activeCratesCache = {}

local function removeCrateCache(obj)
    if activeCratesCache[obj] then
        pcall(function()
            if activeCratesCache[obj].Text then activeCratesCache[obj].Text:Remove() end
            if activeCratesCache[obj].Highlight then activeCratesCache[obj].Highlight:Destroy() end
        end)
        activeCratesCache[obj] = nil
    end
end

local lastCratesScan = 0
local cachedValidCrates = {}

local connCratesESP = RunService.RenderStepped:Connect(function()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    local currentTime = os.clock()
    if currentTime - lastCratesScan > 1.5 then
        lastCratesScan = currentTime
        cachedValidCrates = {}

        local function scanContainer(parent, nameKey, enabled)
            if not enabled or not parent then return end
            for _, obj in ipairs(parent:GetChildren()) do
                if obj and obj.Parent then
                    local targetModel = nil
                    if obj:IsA("Model") then
                        local innerModel = obj:FindFirstChildOfClass("Model")
                        if innerModel then
                            targetModel = innerModel
                        else
                            targetModel = obj
                        end
                    end
                    
                    if targetModel then
                        local primaryPart = targetModel.PrimaryPart or targetModel:FindFirstChild("HumanoidRootPart") or targetModel:FindFirstChild("Part") or targetModel:FindFirstChildWhichIsA("BasePart")
                        if primaryPart then
                            cachedValidCrates[obj] = {
                                Object = targetModel,
                                Part = primaryPart,
                                Name = nameKey,
                                Color = CRATES_SETTINGS.Colors[nameKey] or Color3.fromRGB(255, 255, 255)
                            }
                        end
                    end
                end
            end
        end

        if CRATES_SETTINGS.Airdrop then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("airdrop") then
                    local targetModel = nil
                    if obj:IsA("Model") then
                        local innerModel = obj:FindFirstChildOfClass("Model")
                        if innerModel then
                            targetModel = innerModel
                        else
                            targetModel = obj
                        end
                    end
                    
                    if targetModel then
                        local primaryPart = targetModel.PrimaryPart or targetModel:FindFirstChild("HumanoidRootPart") or targetModel:FindFirstChild("Part") or targetModel:FindFirstChildWhichIsA("BasePart")
                        if primaryPart then
                            cachedValidCrates[obj] = {Object = targetModel, Part = primaryPart, Name = "Airdrop", Color = CRATES_SETTINGS.Colors.Airdrop}
                        end
                    end
                end
            end
        end

        if CRATES_SETTINGS.LockedCrate then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name == "LockedCrate" then
                    local targetModel = obj:FindFirstChild("LockedCrate") or obj
                    local primaryPart = targetModel.PrimaryPart or targetModel:FindFirstChild("PrimaryPart") or targetModel:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        cachedValidCrates[obj] = {Object = targetModel, Part = primaryPart, Name = "LockedCrate", Color = CRATES_SETTINGS.Colors.LockedCrate}
                    end
                end
            end
        end

        if CRATES_SETTINGS.DieselBarrel then
            local dieselFolder = Workspace:FindFirstChild("DieselBarrels")
            if dieselFolder then
                scanContainer(dieselFolder, "DieselBarrel", true)
            end
        end

        local lootFolder = Workspace:FindFirstChild("LootCrates")
        if lootFolder then
            for _, obj in ipairs(lootFolder:GetChildren()) do
                local objName = obj.Name
                if objName == "Food Crate" then
                    scanContainer(obj, "FoodCrate", CRATES_SETTINGS.FoodCrate)
                elseif objName == "Large Crate" then
                    scanContainer(obj, "LargeCrate", CRATES_SETTINGS.LargeCrate)
                elseif objName == "Medbag" then
                    scanContainer(obj, "Medbag", CRATES_SETTINGS.Medbag)
                elseif objName == "Military Crate" then
                    scanContainer(obj, "MilitaryCrate", CRATES_SETTINGS.MilitaryCrate)
                elseif objName == "SNTech Crate" then
                    scanContainer(obj, "SNTechCrate", CRATES_SETTINGS.SNTechCrate)
                elseif objName == "Tool Box" then
                    scanContainer(obj, "ToolBox", CRATES_SETTINGS.ToolBox)
                elseif objName == "Vault" then
                    scanContainer(obj, "Vault", CRATES_SETTINGS.Vault)
                end
            end
        end
    end

    for obj, data in pairs(cachedValidCrates) do
        local cache = activeCratesCache[obj]
        if not cache then
            cache = {
                Text = Drawing.new("Text"),
                Highlight = Instance.new("Highlight")
            }
            cache.Text.Visible = false
            cache.Text.Size = 13
            cache.Text.Center = true
            cache.Text.Outline = true

            cache.Highlight.FillTransparency = 0.5
            cache.Highlight.OutlineTransparency = 1
            cache.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            cache.Highlight.Adornee = data.Object
            cache.Highlight.Parent = data.Object

            activeCratesCache[obj] = cache
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.Text)
        end

        local part = data.Part
        if part and part.Parent then
            local dist = (camera.CFrame.Position - part.Position).Magnitude

            if dist <= CRATES_SETTINGS.MaxDistance then
                cache.Highlight.Enabled = CRATES_SETTINGS.Chams
                cache.Highlight.FillColor = data.Color
                if cache.Highlight.Adornee ~= data.Object then
                    cache.Highlight.Adornee = data.Object
                end

                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    if CRATES_SETTINGS.Names then
                        cache.Text.Text = "[" .. data.Name .. "] (" .. math.floor(dist) .. "m)"
                        cache.Text.Position = Vector2.new(pos.X, pos.Y - 10)
                        cache.Text.Color = data.Color
                        cache.Text.Visible = true
                    else
                        cache.Text.Visible = false
                    end
                else
                    cache.Text.Visible = false
                end
            else
                cache.Text.Visible = false
                cache.Highlight.Enabled = false
            end
        else
            removeCrateCache(obj)
        end
    end

    for obj, _ in pairs(activeCratesCache) do
        if not cachedValidCrates[obj] or not obj.Parent then
            removeCrateCache(obj)
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connCratesESP)

local activeResourcesCache = {}
local cachedValidResources = {}
local lastResourcesScan = 0

local connResourcesESP = RunService.RenderStepped:Connect(function()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    local currentTime = os.clock()
    
    if currentTime - lastResourcesScan > 2.0 then
        lastResourcesScan = currentTime
        cachedValidResources = {}

        local function scanFolder(folder)
            if not folder then return end
            for _, obj in ipairs(folder:GetChildren()) do
                if obj:IsA("Model") then
                    local name = obj.Name
                    local nameKey = nil
                    local isEnabled = false

                    if name:find("Brimstone") then
                        nameKey = "BrimstoneOre"
                        isEnabled = RESOURCES_SETTINGS.BrimstoneOre
                    elseif name:find("Iron") then
                        nameKey = "IronOre"
                        isEnabled = RESOURCES_SETTINGS.IronOre
                    elseif name:find("Stone") then
                        nameKey = "StoneOre"
                        isEnabled = RESOURCES_SETTINGS.StoneOre
                    elseif name:find("Cloth") or name:find("Plant") then
                        nameKey = "ClothPlant"
                        isEnabled = RESOURCES_SETTINGS.ClothPlant
                    end

                    if isEnabled and nameKey then
                        local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if primaryPart then
                            cachedValidResources[obj] = {
                                Object = obj,
                                Part = primaryPart,
                                Name = nameKey,
                                Color = RESOURCES_SETTINGS.Colors[nameKey] or Color3.fromRGB(255, 255, 255)
                            }
                        end
                    end
                end
            end
        end

        scanFolder(Workspace:FindFirstChild("Resources"))
        scanFolder(Workspace:FindFirstChild("ClothPlants"))
    end

    for obj, cache in pairs(activeResourcesCache) do
        if not cachedValidResources[obj] or not obj.Parent then
            cache.Text.Visible = false
            cache.Highlight.Enabled = false
        end
    end

    for obj, data in pairs(cachedValidResources) do
        local cache = activeResourcesCache[obj]
        
        if not cache then
            cache = {
                Text = Drawing.new("Text"),
                Highlight = Instance.new("Highlight")
            }
            cache.Text.Size = 13
            cache.Text.Center = true
            cache.Text.Outline = true

            cache.Highlight.FillTransparency = 0.5
            cache.Highlight.OutlineTransparency = 1
            cache.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            cache.Highlight.Adornee = data.Object
            cache.Highlight.Parent = data.Object

            activeResourcesCache[obj] = cache
            table.insert(getgenv().InveriumLoneSurvival_Drawings, cache.Text)
        end

        local part = data.Part
        if part and part.Parent then
            local dist = (camera.CFrame.Position - part.Position).Magnitude

            if dist <= RESOURCES_SETTINGS.MaxDistance then
                cache.Highlight.Enabled = RESOURCES_SETTINGS.Chams
                cache.Highlight.FillColor = data.Color
                if cache.Highlight.Adornee ~= data.Object then
                    cache.Highlight.Adornee = data.Object
                end

                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen and RESOURCES_SETTINGS.Names then
                    cache.Text.Text = "[" .. data.Name .. "] (" .. math.floor(dist) .. "m)"
                    cache.Text.Position = Vector2.new(pos.X, pos.Y - 10)
                    cache.Text.Color = data.Color
                    cache.Text.Visible = true
                else
                    cache.Text.Visible = false
                end
            else
                cache.Text.Visible = false
                cache.Highlight.Enabled = false
            end
        else
            cache.Text.Visible = false
            cache.Highlight.Enabled = false
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connResourcesESP)

local originalTransparencyMap = {}
local cachedXRayParts = {}
local lastXRayUpdate = 0
local lastXRayState = false

local function refreshXRayCache()
    cachedXRayParts = {}
    local builtObjects = Workspace:FindFirstChild("BuiltObjects")
    if not builtObjects then return end

    local function collectParts(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(cachedXRayParts, child)
            elseif child:IsA("Model") or child:IsA("Folder") then
                collectParts(child)
            end
        end
    end
    collectParts(builtObjects)
end

local function restoreTransparency()
    for _, part in ipairs(cachedXRayParts) do
        if part and part.Parent then
            local origTrans = originalTransparencyMap[part]
            if origTrans ~= nil then
                part.Transparency = origTrans
            end
        end
    end
    originalTransparencyMap = {}
    cachedXRayParts = {}
end

local connRaysToggleKey = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        local targetKey = RAIDS_SETTINGS.Key
        local isMatched = false
        if typeof(targetKey) == "EnumItem" then
            if targetKey.EnumType == Enum.KeyCode and input.KeyCode == targetKey then
                isMatched = true
            elseif targetKey.EnumType == Enum.UserInputType and input.UserInputType == targetKey then
                isMatched = true
            end
        end

        if isMatched then
            RAIDS_SETTINGS.XRayEnabled = not RAIDS_SETTINGS.XRayEnabled
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connRaysToggleKey)

local connRaidsXRayLoop = RunService.Heartbeat:Connect(function()
    if RAIDS_SETTINGS.XRayEnabled then
        lastXRayState = true
        local currentTime = os.clock()
        
        if currentTime - lastXRayUpdate > 1.0 or #cachedXRayParts == 0 then
            lastXRayUpdate = currentTime
            refreshXRayCache()
        end

        local targetTransparency = RAIDS_SETTINGS.Transparency
        for _, part in ipairs(cachedXRayParts) do
            if part and part.Parent then
                if not originalTransparencyMap[part] then
                    originalTransparencyMap[part] = part.Transparency
                end
                
                local origTrans = originalTransparencyMap[part]
                local desiredTrans = math.clamp(math.max(origTrans, targetTransparency), 0, 1)
                if part.Transparency ~= desiredTrans then
                    part.Transparency = desiredTrans
                end
            end
        end
    else
        if lastXRayState then
            lastXRayState = false
            restoreTransparency()
        end
    end
end)
table.insert(getgenv().InveriumLoneSurvival_Connections, connRaidsXRayLoop)
