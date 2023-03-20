repeat task.wait(0.25) until game:IsLoaded()

local player = game.Players.LocalPlayer :: Player
local character = player.Character or player.CharacterAdded:Wait()

local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid"):: Humanoid
local Animator = humanoid:WaitForChild("Animator"):: Animator
local Animate = character:WaitForChild("Animate")

local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local camera = workspace.CurrentCamera :: Camera
--local Trigger = game.ReplicatedStorage.Public.Trigger :: RemoteEvent

local wTapped = false
local oldWalkspeed = 12

local locked = false
local enemyLocked = nil


local Animations = {
    Roll = Animator:LoadAnimation(Animate.RollAnimation.roll)
}

local lastRollTick = tick()

function IsPressingWASD()
    return UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A) 
        or UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D)
end

local UIS_Actions = {
    [Enum.KeyCode.W] = function()
        if not wTapped then
            wTapped = true
            task.delay(0.1, function()
                wTapped = false
            end)
        else
            wTapped = false
            humanoid:SetAttribute("Running", true)
            humanoid.WalkSpeed = 20
        end
    end,
}

local RollDelay = 1.5

function getClosestEnemy()
    local dist = math.huge 
    local closestEnemy

    for i,enemy in ipairs(game.Workspace.Enemies:GetChildren()) do
        local diff = (enemy.PrimaryPart.CFrame.Position - humanoidRootPart.CFrame.Position).Magnitude
        
        if diff <= dist then
            dist = diff
            closestEnemy = enemy
        end
    end

    return closestEnemy
end

local shoulderPosition = Vector3.new(3, 2, 7.5)
local shoulderName = "Right"

local mouse = player:GetMouse()
local oldZoomDistance


local CAS_Actions = {
    ["LockOnEnemy"] = function(inputState, _inputObject)
        if inputState ~= Enum.UserInputState.Begin then return end

        local lockStatus = {
            [false] = function()
                local closestEnemy = getClosestEnemy()
                enemyLocked = closestEnemy
                locked = true

                humanoid.AutoRotate = false

                TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FieldOfView = 65}):Play()
                local highLight = Instance.new("Highlight")
                highLight.FillTransparency = 0.8
                highLight.FillColor = Color3.fromRGB(255,0,0)
                highLight.OutlineColor = Color3.fromRGB(238,0,0)
                highLight.OutlineTransparency = 0.15
                highLight.DepthMode = Enum.HighlightDepthMode.Occluded
                highLight.Name = "LockHighlight"
                highLight.Parent = closestEnemy

                camera.CameraType = Enum.CameraType.Scriptable

                RunService:BindToRenderStep("lockCameraRenderStep", Enum.RenderPriority.Last.Value, function()
                    humanoid.CameraOffset = humanoid.CameraOffset:Lerp(shoulderPosition, 0.25)
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, (closestEnemy.HumanoidRootPart.Position * Vector3.new(1,0,1)) + Vector3.new(0,humanoidRootPart.Position.Y,0))
                    --camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closestEnemy.Head.CFrame.Position)
                    camera.CFrame = camera.CFrame:Lerp(character.PrimaryPart.CFrame * CFrame.new(shoulderPosition), 0.25)
                    camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, closestEnemy.Head.CFrame.Position), 0.25)
                    task.wait()
                end)


            end,

            [true] = function()
                locked = false
                enemyLocked.LockHighlight:Destroy()
                enemyLocked = nil
                
                camera.CameraType = Enum.CameraType.Custom

                humanoid.AutoRotate = true
                humanoid.CameraOffset = Vector3.new(0,0,0)
                TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FieldOfView = 70}):Play()

                RunService:UnbindFromRenderStep("lockCameraRenderStep")
            end,
        }

        lockStatus[locked]()
    end,

    ["ChangeShoulder"] = function(inputState, _inputObject)
        if inputState ~= Enum.UserInputState.Begin then return end

        local shoulders = {
            ["Right"] = function()
                shoulderName = "Left"
                shoulderPosition = Vector3.new(-3, 2, 7.5)
            end,

            ["Left"] = function()
                shoulderName = "Right"
                shoulderPosition = Vector3.new(3, 2, 7.5)
            end
        }

        shoulders[shoulderName]()
        humanoid:SetAttribute("CurrentShoulder", shoulderName)
    end,

    ["Roll"] = function(inputState, _inputObject)
        if inputState ~= Enum.UserInputState.Begin then return end
        if (tick() - lastRollTick) < RollDelay then return end 
        lastRollTick = tick()

        Animations.Roll:Play()
        if not IsPressingWASD() then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "Roll_BodyVelocity"
            bodyVelocity.MaxForce = Vector3.new(1,0,1) * 15000
            bodyVelocity.Parent = humanoidRootPart
            Debris:AddItem(bodyVelocity, 0.5)

            local VelocityMultiplier = 85

            while VelocityMultiplier > 10 do
                print("Yield")
                VelocityMultiplier = VelocityMultiplier / 1.35
                bodyVelocity.Velocity = -humanoidRootPart.CFrame.LookVector * VelocityMultiplier
                task.wait(0.1)
            end

            return
        end

        oldWalkspeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 40

        task.delay(.5, function()
            humanoid.WalkSpeed = oldWalkspeed
        end)
  
    end,



    ["ChangeStance"] = function(inputState, _inputObject)
        local inputStates = {
            [Enum.UserInputState.Begin] = function()
                local screenSize = camera.ViewportSize
                local screenCenter = (screenSize * 0.5)


                RunService:BindToRenderStep("ChangeStanceBind", Enum.RenderPriority.Last.Value, function()
                    local mouseX, mouseY = mouse.X, mouse.Y
                    local mouseV2 = Vector2.new(mouseX, mouseY)
                    local vectorDiff = mouseV2 - screenCenter

                    local angle = math.deg(math.atan2(vectorDiff.X, -vectorDiff.Y))
                    print(angle)        
                end)
            end,    
            [Enum.UserInputState.End] = function()
                RunService:UnbindFromRenderStep("ChangeStanceBind")
            end
        }

        if inputStates[inputState] then
            inputStates[inputState]()
        end
    end,

}

function KeyReleased()
    if humanoid:GetAttribute("Running") then
        if not IsPressingWASD() then
            humanoid:SetAttribute("Running", false)
            humanoid.WalkSpeed = 12
        end
    end
end




UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if UIS_Actions[input.KeyCode] then
        UIS_Actions[input.KeyCode]()
    end
end)

UIS.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    KeyReleased()
    if UIS_Actions[input.KeyCode] then
        UIS_Actions[input.KeyCode]()
    end
end)


function CAS_Connector(actionName, inputState, _inputObject)
    if actionName == nil then return end
    if CAS_Actions[actionName] then
        CAS_Actions[actionName](inputState, _inputObject)
    end
end

CAS:BindAction("ChangeStance", CAS_Connector, false, Enum.KeyCode.LeftAlt)
CAS:BindAction("LockOnEnemy", CAS_Connector, false, Enum.KeyCode.L) 
CAS:BindAction("Roll", CAS_Connector, false, Enum.KeyCode.Q) 
CAS:BindAction("ChangeShoulder", CAS_Connector, false, Enum.KeyCode.T) 