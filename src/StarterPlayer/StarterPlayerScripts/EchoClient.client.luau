-- ECHO-19 / Alpha 0.1 | HUD adaptada a Android
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local signal=RS:WaitForChild("ECHO19_Remotes"):WaitForChild("Signal")
local ui=Instance.new("ScreenGui")
ui.Name="ECHO19_HUD"
ui.ResetOnSpawn=false
ui.Parent=player:WaitForChild("PlayerGui")
local function label(parent,content,pos,size,scale)
    local t=Instance.new("TextLabel")
    t.Text=content
    t.Position=pos
    t.Size=size
    t.BackgroundTransparency=1
    t.TextColor3=Color3.fromRGB(195,224,210)
    t.Font=Enum.Font.Code
    t.TextSize=scale
    t.TextWrapped=true
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.Parent=parent
    return t
end
local objectivePanel=Instance.new("Frame")
objectivePanel.Name="Objetivo"
objectivePanel.Position=UDim2.fromOffset(14,16)
objectivePanel.Size=UDim2.new(.6,0,0,78)
objectivePanel.BackgroundColor3=Color3.fromRGB(14,23,24)
objectivePanel.BackgroundTransparency=.2
objectivePanel.BorderSizePixel=0
objectivePanel.Parent=ui
label(objectivePanel,"ECHO-19 / DIRETIVA",UDim2.fromOffset(10,4),UDim2.new(1,-20,0,24),14)
local objective=label(objectivePanel,"Aguardando sinal...",UDim2.fromOffset(10,28),UDim2.new(1,-20,0,42),13)
local recorder=Instance.new("TextButton")
recorder.Name="Gravador"
recorder.AnchorPoint=Vector2.new(1,1)
recorder.Position=UDim2.new(1,-17,1,-90)
recorder.Size=UDim2.fromOffset(148,52)
recorder.BackgroundColor3=Color3.fromRGB(18,44,43)
recorder.TextColor3=Color3.fromRGB(175,246,211)
recorder.Text="EMITIR ECO"
recorder.TextSize=17
recorder.Font=Enum.Font.Code
recorder.Visible=false
recorder.Parent=ui
recorder.Activated:Connect(function()
    signal:FireServer("emit_echo")
    recorder.Text="TRANSMITINDO"
    task.delay(1.3,function()if recorder.Parent then recorder.Text="EMITIR ECO" end end)
end)
local toast=label(ui,"",UDim2.new(.08,0,1,-86),UDim2.new(.84,0,0,56),16)
toast.BackgroundColor3=Color3.fromRGB(8,22,21)
toast.BackgroundTransparency=.08
toast.Visible=false
local serial=0
local function message(content)
    serial+=1
    local id=serial
    toast.Text=content
    toast.Visible=true
    task.delay(4.5,function()if id==serial then toast.Visible=false end end)
end
local note=Instance.new("Frame")
note.AnchorPoint=Vector2.new(.5,.5)
note.Position=UDim2.fromScale(.5,.5)
note.Size=UDim2.new(.88,0,.5,0)
note.BackgroundColor3=Color3.fromRGB(13,24,25)
note.Visible=false
note.Parent=ui
label(note,"ARQUIVO RECUPERADO",UDim2.fromOffset(12,11),UDim2.new(1,-22,0,29),19)
local noteBody=label(note,"",UDim2.fromOffset(15,48),UDim2.new(1,-30,1,-83),17)
noteBody.TextYAlignment=Enum.TextYAlignment.Top
local close=Instance.new("TextButton")
close.AnchorPoint=Vector2.new(1,1)
close.Position=UDim2.new(1,-10,1,-9)
close.Size=UDim2.fromOffset(108,35)
close.Text="FECHAR"
close.Font=Enum.Font.Code
close.TextSize=16
close.TextColor3=Color3.fromRGB(220,236,226)
close.BackgroundColor3=Color3.fromRGB(48,70,63)
close.Parent=note
close.Activated:Connect(function()note.Visible=false end)
local intro=Instance.new("Frame")
intro.Size=UDim2.fromScale(1,1)
intro.BackgroundColor3=Color3.fromRGB(0,0,0)
intro.ZIndex=20
intro.Parent=ui
local title=label(intro,"E C H O - 1 9",UDim2.fromScale(.05,.39),UDim2.fromScale(.9,.14),29)
title.TextXAlignment=Enum.TextXAlignment.Center
title.ZIndex=21
local subtitle=label(intro,"1998 // COMPLEXO DESATIVADO",UDim2.fromScale(.05,.52),UDim2.fromScale(.9,.07),15)
subtitle.TextXAlignment=Enum.TextXAlignment.Center
subtitle.ZIndex=21
task.delay(3.5,function()
    TS:Create(intro,TweenInfo.new(1.6),{BackgroundTransparency=1}):Play()
    TS:Create(title,TweenInfo.new(1.1),{TextTransparency=1}):Play()
    TS:Create(subtitle,TweenInfo.new(1.1),{TextTransparency=1}):Play()
    task.delay(1.8,function()if intro.Parent then intro:Destroy() end end)
end)
signal.OnClientEvent:Connect(function(kind,payload)
    if kind=="objective" then
        objective.Text=tostring(payload)
    elseif kind=="note" then
        noteBody.Text=tostring(payload)
        note.Visible=true
    elseif kind=="message" then
        message(tostring(payload))
    elseif kind=="recorder" then
        recorder.Visible=payload==true
    end
end)
UIS.InputBegan:Connect(function(input,blocked)
    if not blocked and input.KeyCode==Enum.KeyCode.R and recorder.Visible then
        signal:FireServer("emit_echo")
    end
end)
