if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer

local STATE = {
    Enabled = true,
    CurrentWave = 1,
    LastHeal = 0,
    LastCollect = 0,
    LastRespawnTeleport = 0,
    LastAttack = 0
}

-- ====================== قائمة الأعداء (محدثة) ======================
local enemyNames = {
    "Laser Strider", "Astro Tech", "Infected Big CCTV", "Zombie UTTV", "Quad Sword",
    "Infected CCTV", "Astro Detainer", "Huge Acid Bomber", "Shielded Laser", "Normal Gun T",
    "Mutant Failure", "Mutant Huge Zombie T", "Astro Assailant", "G-T v3", "Oven Car",
    "Lieutenant T", "Strider Penta Laser", "Black Head Rocket", "Bathtub MJT", "Destructor",
    "Snow Shooter", "Bomb Dropper", "Rocket Soldier", "Large Mutant", "Rocket Car",
    "Astro Entrapper", "Flying T", "G-T v2.5", "Snow Explosive Jumper", "Zombie UPG",
    "Titan Amplifier", "Christmas Wraith", "Malware", "G-coy", "UPG DJT", "Cargo T",
    "Strider T", "Big Quad Laser", "Glasses", "Large Glasses", "Giant Astro",
    "Obliterator", "DJT", "Snow-T", "Normal V3", "Acid Arm", "Helicopter", "Giant T",
    "Creep T", "Astro Trooper", "Normal Helicopter", "Huge T", "Scavenger T",
    "Real Professor-T", "Giant Spinning Blade", "Giant Magnet", "Mini Bomber",
    "Infected Large Amplifier", "Infected Amplifier", "Zombie Astro Detainer",
    "Zombie Tentacle Arm", "Large Explosive Jumper", "Zombie Fast CCTV", "Triple Rocket Heli",
    "Zombie Vacuum", "Big T", "Saint T", "Astro Specialist (Gun)", "Big Police",
    "Elite Astro Obliterator", "Hexa Rocket", "Acid Rocket T", "Armored Helicopter",
    "Big Strider", "Astro Impactor", "Zombie Gun Strider", "Glasses Normal Gun",
    "Big Strider Infected", "Titan Amplifier Astro", "Interceptor", "Geeky Jesus T",
    "Rocket Giant Robber", "Laser Soldier T", "Quad Laser", "G-T Upg", "Mai T",
    "Jumper Failure Mutant", "Flame Thrower", "Giant Astro Rocketeer", "Zombie Dual Buzzsaw",
    "Rocket Military T", "Dual Buzzsaw", "Quad Saw Glasses", "Huge Zombie", "Large T",
    "S Bomber", "Octa Rocket", "Flying Spawner", "Giant-DJ", "Subject 0",
    "Infected UPG Titan Amplifier", "Glasses Big Catapult", "Snow-T Twinkle",
    "Little Crawler", "Quad Rocket Big Gun T", "Frontline Guard T", "G-T v2",
    "Triplet T Glasses", "Jetpack Vanguard", "Snow-T Armed Helicopter",
    "Infected Watch Titan", "Jolly Berserker", "Snow-T [Huge V2]", "Acid Skull",
    "G-Clone Rocket Astro (Head)", "Interceptor Transmitter T", "Heavy Soldier TV2",
    "Astro Specialist (Sword)", "Snow-T [Normal V2]", "Laser Strider Rocket Strider T",
    "G-Clone Saw", "Infected Upg Titan CCTV", "Snow Rocket Soldier", "Speaker Snow-T",
    "Zombie CCTV", "Giant Robber Big Magnet", "Helicopter Loud Speaker",
    "Helicopter Police T", "Vacuum T", "L Bomber", "Heavy Soldier T V1",
    "Zombie Professor T", "Glasses Helicopter Snow", "Large Jumper Gun Rocket Heli",
    "Zombie Jumper CCTV Agent", "Mutant G-Clone Laser", "Giant Sweeper T",
    "Saw Car Gun Rocket Helicopter", "Subject 3", "Explosive Jumper Camo T",
    "Zombie T Normal Professor T", "Snow-T [Normal V1]", "Small Bomber",
    "Snow-T [Big V2]", "Astro High Impactor", "Rocket T Astro Strider",
    "Fast Failure Mutant", "Explosive Plane", "Jetpack T", "Laser Strider Legged T",
    "Flying Jet", "Fe Buzzsaw Jetpack", "Creep G-T TV4", "Axe Soldier Mutant E",
    "Snow Burner Saw Soldier", "Mutant Swat Mutant", "Quad Rocket Helicopter",
    "Zombie Big Strider", "Small Large Gun TT", "Snow-T [Huge V1]",
    "Armored Rocket Soldier", "Snow-T [Big V1]", "Warhead Bomber", "Military T Rocket",
    "Laser Strider Magnet Helicopter", "Kamikaze Crawler", "Buff Mutant", "Big Acid Bomber",
    "toilet", "jetpack", "dj", "infected", "skbidi",

    -- الإضافات الجديدة من الصورة
    "Agent Mutant", "Axe Soldier Mutant", "Buff Mutant", "Failure Mutant",
    "Fast Failure Mutant", "Jumper Mutant", "Large Mutant", "Mutant old",
    "Saw Mutant", "Saw Soldier Mutant", "Swat Mutant"
}

local exceptions = {
    "upgrade large tv man", "upgraded large tv man", "large tv man shop", "large tv man",
    "camera helicopter", "utcm", "dark speaker", "enginner", "the head captain",
    "leg toilet", "weld toilet2", "astro camera toilet", "Zombieverse"
}

local enemySet = {}
for _, name in ipairs(enemyNames) do enemySet[name:lower()] = true end

local exceptionSet = {}
for _, name in ipairs(exceptions) do exceptionSet[name:lower()] = true end

-- ====================== GUI (مصغرة) ======================
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 220)
main.Position = UDim2.new(0, 15, 0, 15)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255,70,100)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "🩸 STBB Auto Farm"
title.TextColor3 = Color3.fromRGB(255,90,90)
title.TextSize = 20
title.Font = Enum.Font.GothamBold

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1,-16,0,70)
status.Position = UDim2.new(0,8,0,45)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(220,220,220)
status.TextSize = 15
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Text = "Farm: ON\nWave: 0\nTargets: 0"

-- ====================== ESP ======================
local ESP = {}
local nameTags = {}

local function createESP(model)
    if ESP[model] then return end
    local h = Instance.new("Highlight", model)
    h.FillColor = Color3.fromRGB(255,60,60)
    h.OutlineColor = Color3.fromRGB(255,255,100)
    h.FillTransparency = 0.4
    ESP[model] = h

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if hrp then
        local bg = Instance.new("BillboardGui", model)
        bg.Adornee = hrp
        bg.Size = UDim2.new(0,180,0,40)
        bg.StudsOffset = Vector3.new(0,3.5,0)
        bg.AlwaysOnTop = true

        local txt = Instance.new("TextLabel", bg)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Text = model.Name
        txt.TextColor3 = Color3.fromRGB(255,110,110)
        txt.TextStrokeTransparency = 0
        txt.TextStrokeColor3 = Color3.new(0,0,0)
        txt.TextSize = 13
        txt.Font = Enum.Font.GothamBold
        nameTags[model] = bg
    end
end

-- ====================== الدوال ======================
local function getWave()
    for _, v in pairs(game.CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:lower():find("wave") then
            local n = tonumber(v.Text:match("%d+"))
            if n then return n end
        end
    end
    return 1
end

local function getTargets()
    local targets = {}
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model ~= lp.Character then
            local nameLower = model.Name:lower()
            local isEnemy = false
            for en, _ in pairs(enemySet) do
                if nameLower:find(en) then isEnemy = true break end
            end
            if isEnemy then
                local isException = false
                for ex, _ in pairs(exceptionSet) do
                    if nameLower:find(ex) then isException = true break end
                end
                if not isException then
                    local hum = model:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        table.insert(targets, model)
                        createESP(model)
                    end
                end
            end
        end
    end
    return targets
end

local function getClosest(targets)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, math.huge end
    local root = char.HumanoidRootPart
    local best, dist = nil, math.huge
    for _, t in pairs(targets) do
        local hrp = t:FindFirstChild("HumanoidRootPart")
        if hrp then
            local d = (hrp.Position - root.Position).Magnitude
            if d < dist then dist = d best = t end
        end
    end
    return best, dist
end

local function faceTarget(target)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not target then return end
    local root = char.HumanoidRootPart
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if hrp then
        root.CFrame = CFrame.new(root.Position, Vector3.new(hrp.Position.X, root.Position.Y, hrp.Position.Z))
    end
end

local function teleportTo(target)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not target then return end
    local root = char.HumanoidRootPart
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if hrp then
        local size = hrp.Size.Magnitude / 2 + 2
        local distance = 2 + size
        local offset = hrp.CFrame.LookVector * -distance
        local pos = hrp.Position + offset + Vector3.new(0, 6, 0)
        root.CFrame = CFrame.new(pos, hrp.Position)
    end
end

local function attack()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait(0.06)
    VirtualUser:Button1Up(Vector2.new(0,0))
end

local abilities = {Enum.KeyCode.Q,Enum.KeyCode.E,Enum.KeyCode.R,Enum.KeyCode.T,Enum.KeyCode.Y,Enum.KeyCode.U,Enum.KeyCode.G,Enum.KeyCode.H,Enum.KeyCode.J,Enum.KeyCode.Z,Enum.KeyCode.X,Enum.KeyCode.C,Enum.KeyCode.V,Enum.KeyCode.B}

local lastAbility = 0
local function autoAbilities()
    if tick() - lastAbility < 0.28 then return end
    lastAbility = tick()
    for _, k in ipairs(abilities) do
        VIM:SendKeyEvent(true, k, false, game)
        task.wait(0.07)
        VIM:SendKeyEvent(false, k, false, game)
        task.wait(0.05)
    end
end

local function buyHealth()
    if tick() - STATE.LastHeal < 10 then return end
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            local txt = (p.ActionText or p.ObjectText or ""):lower()
            if txt:find("heal") or txt:find("health") then
                fireproximityprompt(p)
                STATE.LastHeal = tick()
                return
            end
        end
    end
end

local function autoCollectDrops()
    if tick() - STATE.LastCollect < 0.35 then return end
    STATE.LastCollect = tick()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local closest, minD = nil, math.huge
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency < 1 and not obj.CanCollide then
            local n = obj.Name:lower()
            if n:find("coin") or n:find("cash") or n:find("xp") or n:find("orb") or n:find("drop") or n:find("gem") then
                local d = (obj.Position - root.Position).Magnitude
                if d < minD and d < 40 then minD = d closest = obj end
            end
        end
    end
    if closest then
        root.CFrame = CFrame.new(closest.Position + Vector3.new(0,5,0))
        for _, pr in pairs(closest:GetDescendants()) do
            if pr:IsA("ProximityPrompt") then fireproximityprompt(pr) break end
        end
    end
end

local function handleRespawn()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local p1 = Vector3.new(611, -468, 529)
    if (root.Position - p1).Magnitude < 30 and tick() - STATE.LastRespawnTeleport > 8 then
        STATE.LastRespawnTeleport = tick()
        root.CFrame = CFrame.new(p1)
        task.wait(1)
        root.CFrame = CFrame.new(593, -468, 466)
        task.wait(5)
        root.CFrame = CFrame.new(560, -468, 466)
    end
end

RunService.Heartbeat:Connect(function()
    for m, t in pairs(nameTags) do if not m or not m.Parent then if t then t:Destroy() end nameTags[m] = nil end end
    for m, h in pairs(ESP) do if not m or not m.Parent then if h then h:Destroy() end ESP[m] = nil end end
end)

-- ====================== Main Loop ======================
RunService.RenderStepped:Connect(function()
    if not STATE.Enabled then return end

    STATE.CurrentWave = getWave()
    local targets = getTargets()

    status.Text = string.format("Wave: %d\nTargets: %d\nStatus: %s", 
        STATE.CurrentWave, #targets, #targets > 0 and "Farming..." or "Collecting...")

    handleRespawn()

    if #targets == 0 then
        buyHealth()
        autoCollectDrops()
        return
    end

    local target, dist = getClosest(targets)
    if not target then return end

    if dist > 13 then
        teleportTo(target)
    else
        faceTarget(target)
    end

    if tick() - STATE.LastAttack >= 0.25 then
        attack()
        STATE.LastAttack = tick()
    end

    autoAbilities()
    autoCollectDrops()
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        STATE.Enabled = not STATE.Enabled
        main.Visible = STATE.Enabled
        print(STATE.Enabled and "✅ ON" or "⛔ OFF")
    end
end)

print("✅ تم إضافة كل الـ Mutants الجديدة!")
print("   • Agent Mutant, Axe Soldier Mutant, Buff Mutant, Swat Mutant, إلخ...")
print("اضغط P للتشغيل/الإيقاف")