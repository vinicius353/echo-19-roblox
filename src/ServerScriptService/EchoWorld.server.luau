-- ECHO-19 / Alpha 0.1 | Mundo subterraneo procedural
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local map = Instance.new("Folder")
map.Name = "ECHO19_Map"
map.Parent = workspace
local folder = Instance.new("Folder")
folder.Name = "ECHO19_Remotes"
folder.Parent = RS
local signal = Instance.new("RemoteEvent")
signal.Name = "Signal"
signal.Parent = folder
local states = {}
local C = { wall=Color3.fromRGB(52,60,61),floor=Color3.fromRGB(38,43,45),
    steel=Color3.fromRGB(80,90,91),lamp=Color3.fromRGB(151,193,177) }
Lighting.ClockTime=0
Lighting.Brightness=1
Lighting.Ambient=Color3.fromRGB(31,39,40)
Lighting.OutdoorAmbient=Color3.fromRGB(19,27,29)
Lighting.FogColor=Color3.fromRGB(23,32,34)
Lighting.FogStart=28
Lighting.FogEnd=170

local function part(name,size,position,color,material,parent)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.Position=position
    p.Anchored=true
    p.TopSurface=Enum.SurfaceType.Smooth
    p.BottomSurface=Enum.SurfaceType.Smooth
    p.Color=color or C.wall
    p.Material=material or Enum.Material.Concrete
    p.Parent=parent or map
    return p
end

local function room(name,z,w,d,north,south)
    local group=Instance.new("Folder")
    group.Name=name
    group.Parent=map
    part("Piso",Vector3.new(w,2,d),Vector3.new(0,-1,z),C.floor,nil,group)
    part("Teto",Vector3.new(w,1,d),Vector3.new(0,21,z),C.wall,nil,group)
    for _,x in ipairs({-w/2,w/2}) do
        part("Parede",Vector3.new(1,21,d),Vector3.new(x,10,z),C.wall,nil,group)
    end
    local function endWall(zz,open)
        if not open then
            part("Parede final",Vector3.new(w,21,1),Vector3.new(0,10,zz),C.wall,nil,group)
        else
            local flank=(w-10)/2
            if flank>0 then
                for _,x in ipairs({-(10+flank)/2,(10+flank)/2}) do
                    part("Parede passagem",Vector3.new(flank,21,1),Vector3.new(x,10,zz),C.wall,nil,group)
                end
            end
            part("Viga",Vector3.new(10,7,1),Vector3.new(0,17,zz),C.wall,nil,group)
        end
    end
    endWall(z+d/2,north)
    endWall(z-d/2,south)
end
room("Elevador",0,24,24,false,true)
room("Corredor_A",-27,10,30,true,true)
room("Atrio",-63,44,42,true,true)
room("Corredor_B",-99,10,30,true,true)
room("Manutencao",-131,32,34,true,false)

for _,z in ipairs({0,-22,-36,-48,-63,-77,-94,-110,-125,-140}) do
    part("Luminaria",Vector3.new(4.4,.3,1.6),Vector3.new(0,20.3,z),C.steel,Enum.Material.Metal)
    local col=z==-110 and Color3.fromRGB(150,59,56) or C.lamp
    local panel=part("Painel luminoso",Vector3.new(4,.12,1.2),Vector3.new(0,20.08,z),col,Enum.Material.Neon)
    panel.CanCollide=false
    local light=Instance.new("PointLight")
    light.Range=25
    light.Brightness=1.15
    light.Color=col
    light.Shadows=false
    light.Parent=panel
end

for _,x in ipairs({-14,14}) do
    for _,z in ipairs({-53,-73}) do
        part("Pilar",Vector3.new(2.3,21,2.3),Vector3.new(x,10,z),C.steel,Enum.Material.Metal)
    end
end
local function sign(z,content)
    local p=part("Placa",Vector3.new(13,2.4,.3),Vector3.new(0,14,z),C.steel,Enum.Material.Metal)
    local ui=Instance.new("SurfaceGui")
    ui.Face=Enum.NormalId.Front
    ui.Parent=p
    local label=Instance.new("TextLabel")
    label.Size=UDim2.fromScale(1,1)
    label.BackgroundTransparency=1
    label.Font=Enum.Font.Code
    label.TextScaled=true
    label.Text=content
    label.TextColor3=C.lamp
    label.Parent=ui
end
sign(-42.65,"SETOR 01 / ATRIO")
sign(-114.65,"MANUTENCAO")
local spawn=Instance.new("SpawnLocation")
spawn.Name="Entrada_ECHO19"
spawn.Size=Vector3.new(6,1,6)
spawn.Position=Vector3.new(0,1,3)
spawn.Anchored=true
spawn.Transparency=1
spawn.CanCollide=false
spawn.Neutral=true
spawn.Duration=0
spawn.Parent=map

local function state(player)
    if not states[player] then states[player]={log=false,door=false,lastEcho=0} end
    return states[player]
end
local function notify(player,kind,msg)
    if player.Parent==Players then signal:FireClient(player,kind,msg) end
end
local function prompt(target,action,description)
    local p=Instance.new("ProximityPrompt")
    p.ActionText=action
    p.ObjectText=description
    p.MaxActivationDistance=10
    p.RequiresLineOfSight=false
    p.HoldDuration=.25
    p.Parent=target
    return p
end
local terminal=part("Terminal de arquivos",Vector3.new(4,4,2),Vector3.new(-15,2,-58),C.steel,Enum.Material.Metal)
local screen=part("Tela terminal",Vector3.new(3.4,2,.12),Vector3.new(-15,3.1,-56.9),Color3.fromRGB(79,169,136),Enum.Material.Neon)
screen.CanCollide=false
prompt(terminal,"Consultar","ARQUIVO 001").Triggered:Connect(function(player)
    local st=state(player)
    st.log=true
    notify(player,"note","ARQUIVO 001: A frequencia de acesso e 19. Nao confie em relatorios que levam a sua assinatura.")
    notify(player,"objective","Aproxime-se da porta da manutencao e emita ECO-19.")
    notify(player,"recorder",true)
end)
local door=part("Porta blindada",Vector3.new(9.2,14,1.2),Vector3.new(0,7,-84),C.steel,Enum.Material.Metal)
local doorPrompt=prompt(door,"Inspecionar","ACESSO MANUTENCAO")
doorPrompt.Triggered:Connect(function(player)
    if state(player).log then
        notify(player,"message","A porta aguarda ECO-19. Emita a frequencia pelo gravador.")
    else
        notify(player,"message","ACESSO NEGADO. Consulte o terminal do atrio.")
    end
end)
local maintenanceLog=part("Registro de manutencao",Vector3.new(4,3,2),Vector3.new(-9,1.6,-131),C.steel,Enum.Material.Metal)
local hasEntity=false
prompt(maintenanceLog,"Ler","REGISTRO 019").Triggered:Connect(function(player)
    notify(player,"note","REGISTRO 019: Nenhum resgate foi autorizado. A instalacao copia rotinas de pessoas que nunca trabalharam aqui.")
    notify(player,"objective","PROLOGO CONCLUIDO. Outros setores chegarao em atualizacoes.")
    if hasEntity then return end
    hasEntity=true
    local entity=Instance.new("Model")
    entity.Name="Observador_placeholder"
    entity.Parent=map
    local body=part("Silhueta",Vector3.new(2.1,6,1.7),Vector3.new(0,3,-141),Color3.fromRGB(14,17,18),Enum.Material.SmoothPlastic,entity)
    local head=part("Cabeca",Vector3.new(2.1,2.1,2.1),Vector3.new(0,7,-141),Color3.fromRGB(13,16,17),Enum.Material.SmoothPlastic,entity)
    body.CanCollide=false
    head.CanCollide=false
    task.delay(12,function()if entity.Parent then entity:Destroy() end end)
end)
signal.OnServerEvent:Connect(function(player,action)
    if action~="emit_echo" then return end
    local st=state(player)
    if not st.log then return end
    if os.clock()-st.lastEcho<2 then return end
    st.lastEcho=os.clock()
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position-door.Position).Magnitude>22 then
        notify(player,"message","ECO-19 emitido. Nenhum receptor respondeu.")
        return
    end
    if st.door then return end
    st.door=true
    doorPrompt.Enabled=false
    notify(player,"message","FREQUENCIA ACEITA // ABRINDO ACESSO")
    notify(player,"objective","Investigue o registro ao final da manutencao.")
    local tween=TS:Create(door,TweenInfo.new(2),{CFrame=door.CFrame*CFrame.new(10,0,0)})
    tween:Play()
    tween.Completed:Connect(function()door.CanCollide=false end)
end)
Players.PlayerAdded:Connect(function(player)
    state(player)
    task.delay(2,function()notify(player,"objective","Encontre o terminal de arquivos no atrio.") end)
end)
Players.PlayerRemoving:Connect(function(player)states[player]=nil end)
