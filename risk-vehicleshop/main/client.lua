local ESX = nil

local currentFramework = nil

local currentJob = "unemployed"

local currentJobGrade = 0

local uiOpen = false

local previewVehicle = nil

local previewCam = nil

local previewHeading = nil

local testDriveVehicle = nil

local selectedVehicleSpawnName = nil

local selectedVehicleDisplayName = nil

local testDriveActive = false

local testDriveTimeLeft = 0

local currentPrimaryColor = {r = 255, g = 255, b = 255}

local currentSecondaryColor = {r = 255, g = 255, b = 255}

local currentZoomDistance = 0.0

local targetZoomDistance = 0.0

local skipAnimation = true

local activeShopIndex = nil

local spawnedNPCs = {}

local shopBlips = {}

local testDriveShopIndex = nil

local lastCatIndex = 0

local lastVehIndex = 0

local spawnInProgress = false

local TEST_DRIVE_DIMENSION = 8282

local lastPreviewSpawnTime = 0

local previewSpawnInProgress = false

local gtaColours = {

    {r = 255, g = 255, b = 246, id = 111}, {r = 13, g = 17, b = 22, id = 0},

    {r = 29, g = 33, b = 41, id = 11}, {r = 218, g = 25, b = 24, id = 28},

    {r = 242, g = 31, b = 153, id = 135}, {r = 223, g = 88, b = 145, id = 137},

    {r = 98, g = 18, b = 118, id = 145}, {r = 47, g = 45, b = 82, id = 71},

    {r = 35, g = 84, b = 161, id = 73}, {r = 34, g = 46, b = 70, id = 61},

    {r = 18, g = 56, b = 60, id = 51}, {r = 152, g = 210, b = 35, id = 92},

    {r = 194, g = 148, b = 79, id = 37}, {r = 247, g = 134, b = 22, id = 38},

    {r = 253, g = 214, b = 205, id = 136}, {r = 212, g = 74, b = 23, id = 36},

    {r = 251, g = 226, b = 18, id = 89}, {r = 58, g = 42, b = 27, id = 108}

}

local function rgbToId(r, g, b)

    local bestId, bestDiff = 0, 1e9

    for _, c in ipairs(gtaColours) do

        local d = (r - c.r) ^ 2 + (g - c.g) ^ 2 + (b - c.b) ^ 2

        if d < bestDiff then

            bestDiff = d

            bestId = c.id

        end

    end

    return bestId

end

local function ApplyVehicleLivery(veh, idx)

    SetVehicleModKit(veh, 0)

    local countNative = GetVehicleLiveryCount(veh) or -1

    if countNative and countNative > 0 and idx < countNative then

        SetVehicleLivery(veh, idx)

        if Config.Debug then

            print("debug: applied native livery " .. idx .. " / total " ..

                      countNative)

        end

        return true

    end

    local modCount = GetNumVehicleMods(veh, 48) or 0

    if modCount and modCount > 0 then

        local modIndex = idx

        if modIndex >= modCount then modIndex = modCount - 1 end

        SetVehicleMod(veh, 48, modIndex, false)

        if Config.Debug then

            print("debug: applied mod48 livery " .. modIndex .. " / total " ..

                      modCount)

        end

        return true

    end

    if Config.Debug then

        print("debug: no livery available (native -1/0 and mod48 0)")

    end

    return false

end

function RecheckJobFramework()

    local prevJob = currentJob

    local prevGrade = currentJobGrade

    if currentFramework == "qbcore" then

        local c = exports['qb-core']:GetCoreObject()

        local d = c.Functions.GetPlayerData()

        if d and d.job then

            currentJob = d.job.name

            if d.job.grade then

                currentJobGrade = d.job.grade.level or 0

            end

            if Config.Debug then

                print("debug: re-check job -> " .. currentJob .. " grade -> " ..

                          tostring(currentJobGrade))

            end

        end

    elseif currentFramework == "esx" then

        if ESX and ESX.GetPlayerData then

            ESX.PlayerData = ESX.GetPlayerData()

            if ESX.PlayerData and ESX.PlayerData.job then

                currentJob = ESX.PlayerData.job.name

                currentJobGrade = ESX.PlayerData.job.grade or 0

                if Config.Debug then

                    print("debug: re-check job -> " .. currentJob ..

                              " grade -> " .. tostring(currentJobGrade))

                end

            end

        end

    end

    if (prevJob ~= currentJob or prevGrade ~= currentJobGrade) and currentJob then

        if Config.Debug then

            print("debug: job changed on re-check -> respawn shops/blips")

        end

        RespawnAllShopEntities()

    end

end

AddEventHandler("onResourceStart", function(res)

    if res == GetCurrentResourceName() then

        if Config.Debug then

            print("debug: resource start -> re-check job and respawn")

        end

        RecheckJobFramework()

        Wait(5000)

        RecheckJobFramework()

        Wait(3000)

        RespawnAllShopEntities()

        Wait(3000)

        RespawnAllShopEntities()

    end

end)

CreateThread(function()

    Wait(500)

    if GetResourceState("qb-core") == "started" then

        currentFramework = "qbcore"

        if Config.Debug then print("debug: qbcore found on client") end

        local core = exports['qb-core']:GetCoreObject()

        if core then

            local pData = core.Functions.GetPlayerData()

            if pData and pData.job then

                currentJob = pData.job.name

                if pData.job.grade then

                    currentJobGrade = pData.job.grade.level or 0

                end

                if Config.Debug then

                    print("debug: job init -> " .. currentJob .. " grade -> " ..

                              tostring(currentJobGrade))

                end

                RespawnAllShopEntities()

            end

        end

        AddEventHandler('QBCore:Client:OnPlayerLoaded', function()

            Wait(1000)

            local c = exports['qb-core']:GetCoreObject()

            local d = c.Functions.GetPlayerData()

            if d and d.job then

                currentJob = d.job.name

                if d.job.grade then

                    currentJobGrade = d.job.grade.level or 0

                end

                if Config.Debug then

                    print("debug: qb OnPlayerLoaded -> " .. currentJob ..

                              " grade -> " .. tostring(currentJobGrade))

                end

                RespawnAllShopEntities()

            end

        end)

        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)

            Wait(2000)

            currentJob = job.name

            if job.grade then currentJobGrade = job.grade.level or 0 end

            if Config.Debug then

                print(

                    "debug: qb job updated -> " .. currentJob .. " grade -> " ..

                        tostring(currentJobGrade))

            end

            RespawnAllShopEntities()

        end)

    elseif GetResourceState("es_extended") == "started" then

        currentFramework = "esx"

        if Config.Debug then print("debug: esx found on client") end

        ESX = exports["es_extended"]:getSharedObject()

        CreateThread(function()

            Wait(1500)

            if ESX and ESX.PlayerData and ESX.PlayerData.job then

                currentJob = ESX.PlayerData.job.name

                currentJobGrade = ESX.PlayerData.job.grade or 0

                if Config.Debug then

                    print("debug: esx initial job -> " .. currentJob ..

                              " grade -> " .. tostring(currentJobGrade))

                end

                RespawnAllShopEntities()

            end

        end)

        RegisterNetEvent('esx:playerLoaded', function(xPlayer)

            ESX.PlayerData = xPlayer

            if xPlayer.job then

                currentJob = xPlayer.job.name

                currentJobGrade = xPlayer.job.grade or 0

                if Config.Debug then

                    print("debug: esx playerLoaded -> " .. currentJob ..

                              " grade -> " .. tostring(currentJobGrade))

                end

                RespawnAllShopEntities()

            end

        end)

        RegisterNetEvent('esx:setJob', function(job)

            Wait(2000)

            if ESX.PlayerData then ESX.PlayerData.job = job end

            currentJob = job.name

            currentJobGrade = job.grade or 0

            if Config.Debug then

                print(

                    "debug: esx job updated -> " .. currentJob .. " grade -> " ..

                        tostring(currentJobGrade))

            end

            RespawnAllShopEntities()

        end)

    else

        if Config.Debug then print("debug: no framework found on client") end

    end

end)

CreateThread(function()

    while true do

        Wait(60000)

        RecheckJobFramework()

    end

end)

function HasClientJobAccess(jobTable)

    if not jobTable or #jobTable == 0 then return false end

    if jobTable[1] == "all" then return true end

    for _, v in ipairs(jobTable) do if v == currentJob then return true end end

    return false

end

function RespawnAllShopEntities()

    for _, npc in pairs(spawnedNPCs) do

        if DoesEntityExist(npc) then DeleteEntity(npc) end

    end

    spawnedNPCs = {}

    for _, blip in pairs(shopBlips) do RemoveBlip(blip) end

    shopBlips = {}

    CreateThread(function()

        Wait(500)

        SpawnAllNPCsAndBlips()

    end)

end

function SpawnAllNPCsAndBlips()

    if spawnInProgress then return end

    spawnInProgress = true

    local ok, err = pcall(function()

        for i, shop in pairs(Config.Shops) do

            if HasClientJobAccess(shop.jobs) then

                if shop.useNPC then

                    local hash = GetHashKey(shop.npcModel)

                    RequestModel(hash)

                    local t = 0

                    while not HasModelLoaded(hash) and t < 600 do

                        Wait(10)

                        t = t + 1

                    end

                    if not HasModelLoaded(hash) then

                        print("debug: model " .. shop.npcModel ..

                                  " failed, fallback")

                        hash = GetHashKey("a_m_m_business_01")

                        RequestModel(hash)

                        while not HasModelLoaded(hash) do

                            Wait(5)

                        end

                    end

                    local success, groundZ =

                        GetGroundZFor_3dCoord(shop.coords.x, shop.coords.y,

                                              shop.coords.z, 0)

                    if not success then

                        groundZ = shop.coords.z - 1.0

                    end

                    local ped = CreatePed(4, hash, shop.coords.x, shop.coords.y,

                                          groundZ, shop.coords.w, false, true)

                    SetBlockingOfNonTemporaryEvents(ped, true)

                    SetEntityInvincible(ped, true)

                    FreezeEntityPosition(ped, true)

                    spawnedNPCs[#spawnedNPCs + 1] = ped

                    if Config.Debug then

                        print("debug: npc spawned for " .. shop.label)

                    end

                end

                if shop.useBlip then

                    local blip = AddBlipForCoord(shop.coords.x, shop.coords.y,

                                                 shop.coords.z)

                    SetBlipSprite(blip, shop.blip.sprite)

                    SetBlipScale(blip, shop.blip.scale)

                    SetBlipColour(blip, shop.blip.color)

                    SetBlipAsShortRange(blip, true)

                    BeginTextCommandSetBlipName("STRING")

                    AddTextComponentString(shop.label)

                    EndTextCommandSetBlipName(blip)

                    shopBlips[#shopBlips + 1] = blip

                    if Config.Debug then

                        print("debug: blip created for " .. shop.label)

                    end

                end

            end

        end

    end)

    spawnInProgress = false

    if not ok then

        print("debug: SpawnAllNPCsAndBlips error -> " .. tostring(err))

    end

end

CreateThread(function()

    while true do

        local sleep = 1000

        local ped = PlayerPedId()

        local coords = GetEntityCoords(ped)

        if not uiOpen then

            for i, shop in pairs(Config.Shops) do

                if HasClientJobAccess(shop.jobs) then

                    local dist = #(coords -

                                     vector3(shop.coords.x, shop.coords.y,

                                             shop.coords.z))

                    if dist < 20.0 then

                        if shop.useMarker then

                            sleep = 0

                            DrawMarker(shop.markerType or 2, shop.coords.x,

                                       shop.coords.y, shop.coords.z, 0.0, 0.0,

                                       0.0, 0.0, 0.0, 0.0, shop.markerScale.x,

                                       shop.markerScale.y, shop.markerScale.z,

                                       shop.markerColor.r, shop.markerColor.g,

                                       shop.markerColor.b, shop.markerColor.a,

                                       false, false, 2, true, nil, nil, false)

                        end

                        if dist < 2.0 then

                            if not IsPedInAnyVehicle(ped, false) then

                                sleep = 0

                                DisplayHelpText(

                                    GetLocaleText('pressE') .. " " .. shop.label,

                                    "E")

                                if IsControlJustReleased(0, 38) then

                                    activeShopIndex = i

                                    OpenVehicleShop(i)

                                end

                            else

                                sleep = 0

                                DisplayHelpText(GetLocaleText('exitVehicle'),

                                                nil)

                            end

                        end

                    end

                end

            end

        end

        if uiOpen then

            sleep = 0

            DisableAllControlActions(0)
            SetPauseMenuActive(false)

            for i = 0, 22 do HideHudComponentThisFrame(i) end

            DisplayRadar(false)

            HideHudAndRadarThisFrame()

            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            if activeShopIndex then

                local shopCoords = vector3(

                                       Config.Shops[activeShopIndex].coords.x,

                                       Config.Shops[activeShopIndex].coords.y,

                                       Config.Shops[activeShopIndex].coords.z)

                local dist = #(coords - shopCoords)

                if dist > 3.0 then CloseVehicleShop() end

            end

            EngineSoundPreview()

            UpdateCameraZoom()

        end

        Wait(sleep)

    end

end)

RegisterNUICallback("uiWheel", function(data, cb)

    if activeShopIndex then

        local step = 0.5

        local delta = tonumber(data.delta) or 0

        if delta > 0 then

            targetZoomDistance = targetZoomDistance + step

        else

            targetZoomDistance = targetZoomDistance - step

        end

        local minZ = Config.Shops[activeShopIndex].minZoomDistance or 5.0

        local maxZ = Config.Shops[activeShopIndex].maxZoomDistance or 25.0

        if targetZoomDistance < minZ then targetZoomDistance = minZ end

        if targetZoomDistance > maxZ then targetZoomDistance = maxZ end

    end

    cb("ok")

end)

RegisterNUICallback("uiRotate", function(data, cb)

    if previewVehicle then

        local dx = tonumber(data.dx) or 0

        previewHeading = previewHeading + (dx * 0.15)
        SetEntityHeading(previewVehicle, previewHeading)

    end

    cb("ok")

end)

RegisterNUICallback("close", function(data, cb)

    CloseVehicleShop()

    cb("ok")

end)

RegisterNUICallback("null", function(data, cb)

    if data.vehIndex ~= nil and data.catIndex ~= nil then

        lastCatIndex = data.catIndex

        lastVehIndex = data.vehIndex

        SpawnPreviewVehicle(data.catIndex, data.vehIndex)

    end

    cb("ok")

end)

RegisterNUICallback("testDrive", function(data, cb)

    StartTestDrive()

    cb("ok")

end)

RegisterNUICallback("setColor", function(data, cb)

    if previewVehicle and DoesEntityExist(previewVehicle) then

        local r = tonumber(data.r) or 255

        local g = tonumber(data.g) or 255

        local b = tonumber(data.b) or 255

        ClearVehicleCustomPrimaryColour(previewVehicle)

        ClearVehicleCustomSecondaryColour(previewVehicle)

        local pid, sid = GetVehicleColours(previewVehicle)

        if data.type == "primary" then

            pid = rgbToId(r, g, b)

            currentPrimaryColor = {r = r, g = g, b = b}

        elseif data.type == "secondary" then

            sid = rgbToId(r, g, b)

            currentSecondaryColor = {r = r, g = g, b = b}

        end

        SetVehicleColours(previewVehicle, pid, sid)

        if Config.Debug then

            print("debug: setColor " .. data.type .. " -> " .. tostring(pid) ..

                      "/" .. tostring(sid))

        end

    end

    cb("ok")

end)

RegisterNUICallback("buyVehicle", function(data, cb)

    data.shopIndex = activeShopIndex

    data.catIndex = lastCatIndex

    data.vehIndex = lastVehIndex

    local model = GetHashKey(data.spawnName)

    local vehClass = GetVehicleClassFromName(model)

    if vehClass == 14 then

        data.vehicleType = "boat"

    elseif vehClass == 15 or vehClass == 16 then

        data.vehicleType = "plane"

    else

        data.vehicleType = "car"

    end

    TriggerServerEvent("risk-vehicleshop:buyVehicle", data)

    CloseVehicleShop()

    cb("ok")

end)

function OpenVehicleShop(shopIndex)

    local shop = Config.Shops[shopIndex]

    if not shop or not shop.previewCoords or not shop.cameraCoords or not shop.cameraRot then

        if Config.Debug then

            print("debug: invalid shop preview config at index " .. tostring(shopIndex))

        end

        return

    end

    uiOpen = true

    skipAnimation = true

    DisplayRadar(false)

    if Config.HideHudEvent and Config.HideHudEvent ~= "" then

        TriggerEvent(Config.HideHudEvent, true)

        if Config.Debug then

            print("debug: triggered " .. Config.HideHudEvent .. " -> true")

        end

    end

    SetNuiFocus(true, true)

    Wait(0)

    SetNuiFocusKeepInput(false)

    if Config.Debug then

        print("debug: vehicle shop ui opened -> " ..

                  shop.label)

    end

    SetupCamera(shopIndex)

    previewHeading = shop.previewCoords.w

    currentZoomDistance = shop.defaultZoomDistance or 7.0

    targetZoomDistance = shop.defaultZoomDistance or 7.0

    SendNUIMessage({

        action = "openUI",

        categories = shop.categories

    })

    if #shop.categories > 0 then

        if #shop.categories[1].vehicles > 0 then

            lastCatIndex = 0

            lastVehIndex = 0

            CreateThread(function()

                Wait(0)

                SpawnPreviewVehicle(0, 0)

            end)

        end

    end

end

function CloseVehicleShop()

    uiOpen = false

    DisplayRadar(true)

    if Config.HideHudEvent and Config.HideHudEvent ~= "" then

        TriggerEvent(Config.HideHudEvent, false)

        if Config.Debug then

            print("debug: triggered " .. Config.HideHudEvent .. " -> false")

        end

    end

    SetNuiFocus(false, false)

    SetNuiFocusKeepInput(false)

    SendNUIMessage({action = "closeUI"})

    if Config.Debug then print("debug: vehicle shop ui closed") end

    if previewVehicle then

        DeleteEntity(previewVehicle)

        previewVehicle = nil

    end

    if previewCam then

        RenderScriptCams(false, false, 0, true, false)

        DestroyCam(previewCam, false)

        previewCam = nil

    end

    activeShopIndex = nil

end

function SetupCamera(shopIndex)

    local shop = Config.Shops[shopIndex]

    if not shop or not shop.cameraCoords or not shop.cameraRot then

        if Config.Debug then

            print("debug: invalid camera config for shop " .. tostring(shopIndex))

        end

        return

    end

    if not previewCam then

        previewCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetCamCoord(previewCam, shop.cameraCoords.x,

                    shop.cameraCoords.y,

                    shop.cameraCoords.z)

        SetCamRot(previewCam, shop.cameraRot.x,

                  shop.cameraRot.y,

                  shop.cameraRot.z, 2)

        SetCamActive(previewCam, true)

        RenderScriptCams(true, false, 0, true, false)

        if Config.Debug then

            print("debug: camera created for shop " ..

                      shop.label)

        end

    end

end

function UpdateCameraZoom()

    if previewCam and activeShopIndex then

        local shop = Config.Shops[activeShopIndex]

        if not shop or not shop.previewCoords or not shop.cameraCoords then return end

        currentZoomDistance = currentZoomDistance +

                                  (targetZoomDistance - currentZoomDistance) *

                                  0.12

        local sx, sy, sz = shop.previewCoords.x,

                           shop.previewCoords.y,

                           shop.previewCoords.z

        local camDir = vector3(

                           sx - shop.cameraCoords.x,

                           sy - shop.cameraCoords.y,

                           sz - shop.cameraCoords.z)

        local length = #(camDir)

        if length > 0 then camDir = camDir / length end

        local newCamPos = vector3(sx - camDir.x * currentZoomDistance,

                                  sy - camDir.y * currentZoomDistance,

                                  sz - camDir.z * currentZoomDistance)

        SetCamCoord(previewCam, newCamPos.x, newCamPos.y, newCamPos.z)

    end

end

local function IsLikelyElectric(vehicle)

    local tank = GetVehicleHandlingFloat(vehicle, "CHandlingData",

                                         "fPetrolTankVolume") or 0.0

    local gears = GetVehicleHandlingInt(vehicle, "CHandlingData",

                                        "nInitialDriveGears") or 5

    if tank <= 0.1 and gears <= 1 then return true end

    return false

end

function SpawnPreviewVehicle(catIndex, vehIndex)

    if not activeShopIndex or previewSpawnInProgress then return end

    local shop = Config.Shops[activeShopIndex]

    if not shop or not shop.previewCoords then return end

    local now = GetGameTimer()

    if now - lastPreviewSpawnTime < 500 then return end

    lastPreviewSpawnTime = now

    previewSpawnInProgress = true

    if previewVehicle and DoesEntityExist(previewVehicle) then

        SetEntityAsMissionEntity(previewVehicle, true, true)

        DeleteVehicle(previewVehicle)

        while DoesEntityExist(previewVehicle) do Wait(0) end

        previewVehicle = nil

        Wait(0)

    end

    local cat = shop.categories[catIndex + 1]

    if not cat then

        previewSpawnInProgress = false

        return

    end

    local vehData = cat.vehicles[vehIndex + 1]

    if not vehData then

        previewSpawnInProgress = false

        return

    end

    local model = GetHashKey(vehData.spawnName)

    RequestModel(model)

    local c = 0

    while not HasModelLoaded(model) and c < 300 do

        Wait(5)

        c = c + 1

    end

    previewVehicle = CreateVehicle(model, shop.previewCoords.x,

                                   shop.previewCoords.y,

                                   shop.previewCoords.z,

                                   previewHeading, false, false)

    SetEntityAsMissionEntity(previewVehicle, true, true)

    FreezeEntityPosition(previewVehicle, true)

    SetVehicleOnGroundProperly(previewVehicle)

    SetEntityInvincible(previewVehicle, true)

    SetVehicleDoorsLocked(previewVehicle, 2)

    SetVehicleEngineOn(previewVehicle, true, true, false)

    if Config.CustomPlateText and Config.CustomPlateText ~= "" then

        SetVehicleNumberPlateText(previewVehicle, Config.CustomPlateText)

    else

        SetVehicleNumberPlateText(previewVehicle, "SHOPCAR")

    end

    if Config.SpawnClean then SetVehicleDirtLevel(previewVehicle, 0.0) end

    if Config.SpawnFullFuel then SetVehicleFuelLevel(previewVehicle, 100.0) end

    if vehData.livery ~= nil and vehData.livery >= 0 then

        ApplyVehicleLivery(previewVehicle, vehData.livery)

    end

    selectedVehicleSpawnName = vehData.spawnName

    selectedVehicleDisplayName = vehData.displayName

    Wait(50)

    SendVehicleStatsToUI(previewVehicle, vehData)

    previewSpawnInProgress = false

end

function SendVehicleStatsToUI(vehicle, vehData)

    if not DoesEntityExist(vehicle) then return end

    local model = GetEntityModel(vehicle)

    local modelMaxSpeed = GetVehicleModelMaxSpeed(model) or 0.0

    local topSpeed = 0

    local speedUnit = ""

    if Config.SpeedUnit == "KM/H" then

        topSpeed = math.floor(modelMaxSpeed * 3.6)

        speedUnit = "KM/H"

    else

        topSpeed = math.floor(modelMaxSpeed * 2.236936)

        speedUnit = "MP/H"

    end

    local mass = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fMass") or

                     0.0

    local massValue = 0

    local massUnit = ""

    if Config.WeightUnit == "KG" then

        massValue = math.floor(mass)

        massUnit = "KG"

    else

        massValue = math.floor(mass * 2.2046226218)

        massUnit = "LB"

    end

    local brakeForce = GetVehicleHandlingFloat(vehicle, "CHandlingData",

                                               "fBrakeForce") or 0.0

    local seats = GetVehicleMaxNumberOfPassengers(vehicle) + 1

    local braking = math.floor(brakeForce * 100)

    local fuelType = "Gasoline"

    if vehData.isElectric == true then

        fuelType = "Electric"

    elseif vehData.isElectric == false then

        fuelType = "Gasoline"

    else

        if IsLikelyElectric(vehicle) then fuelType = "Electric" end

    end

    local speedPercent = (topSpeed / Config.MaxStats.Speed) * 100

    if speedPercent > 100 then speedPercent = 100 end

    local weightPercent = (massValue / Config.MaxStats.Weight) * 100

    if weightPercent > 100 then weightPercent = 100 end

    local brakePercent = (braking / Config.MaxStats.Braking) * 100

    if brakePercent > 100 then brakePercent = 100 end

    local seatsPercent = (seats / Config.MaxStats.Seats) * 100

    if seatsPercent > 100 then seatsPercent = 100 end

    if Config.Debug then

        print(

            "debug: speed=" .. topSpeed .. speedUnit .. " mass=" .. massValue ..

                massUnit .. " brake=" .. braking .. " seats=" .. seats ..

                " fuel=" .. fuelType)

    end

    SendNUIMessage({

        action = "updateStats",

        speed = topSpeed,

        mass = massValue,

        brake = braking,

        seats = seats,

        fuelType = fuelType,

        speedPercent = speedPercent,

        weightPercent = weightPercent,

        brakePercent = brakePercent,

        seatsPercent = seatsPercent,

        speedUnit = speedUnit,

        massUnit = massUnit,

        skipAnimation = skipAnimation

    })

    skipAnimation = false

end

function RotatePreviewVehicle() end

function EngineSoundPreview()

    if previewVehicle then

        if IsDisabledControlPressed(0, 71) then

            SetVehicleCurrentRpm(previewVehicle, 0.8)

        elseif IsDisabledControlPressed(0, 72) then

            SetVehicleCurrentRpm(previewVehicle, 0.4)

        else

            SetVehicleCurrentRpm(previewVehicle, 0.0)

        end

    end

end

function StartTestDrive()

    if not activeShopIndex then return end

    testDriveShopIndex = activeShopIndex

    if Config.Debug then print("debug: test drive started") end

    CloseVehicleShop()

    TriggerServerEvent("risk-vehicleshop:setTestDriveDimension",

                       TEST_DRIVE_DIMENSION)

    local ped = PlayerPedId()

    local shop = Config.Shops[testDriveShopIndex]

    local cat = shop.categories[lastCatIndex + 1]

    if not cat then

        if Config.Debug then print("debug: no cat found for test drive") end

        return

    end

    local vehData = cat.vehicles[lastVehIndex + 1]

    if not vehData then

        if Config.Debug then print("debug: no veh found for test drive") end

        return

    end

    local vehicleHash = GetHashKey(vehData.spawnName or "adder")

    RequestModel(vehicleHash)

    local c = 0

    while not HasModelLoaded(vehicleHash) and c < 200 do

        Wait(10)

        c = c + 1

    end

    testDriveVehicle = CreateVehicle(vehicleHash, shop.testDriveCoords.x,

                                     shop.testDriveCoords.y,

                                     shop.testDriveCoords.z,

                                     shop.testDriveCoords.w, true, true)

    NetworkRegisterEntityAsNetworked(testDriveVehicle)

    local netId = NetworkGetNetworkIdFromEntity(testDriveVehicle)

    if Config.Debug then

        print("debug: created testDriveVehicle netId=" .. tostring(netId))

    end

    TriggerServerEvent("risk-vehicleshop:setVehicleDimension", netId,

                       TEST_DRIVE_DIMENSION)

    SetEntityAsMissionEntity(testDriveVehicle, true, true)

    local plateToUse = "TESTDRIVE"

    if Config.CustomPlateText and Config.CustomPlateText ~= "" then

        plateToUse = Config.CustomPlateText

    end

    SetVehicleNumberPlateText(testDriveVehicle, plateToUse)

    local pid = rgbToId(currentPrimaryColor.r, currentPrimaryColor.g,

                        currentPrimaryColor.b)

    local sid = rgbToId(currentSecondaryColor.r, currentSecondaryColor.g,

                        currentSecondaryColor.b)

    ClearVehicleCustomPrimaryColour(testDriveVehicle)

    ClearVehicleCustomSecondaryColour(testDriveVehicle)

    SetVehicleColours(testDriveVehicle, pid, sid)

    if Config.SpawnClean then SetVehicleDirtLevel(testDriveVehicle, 0.0) end

    if Config.SpawnFullFuel then SetVehicleFuelLevel(testDriveVehicle, 100.0) end

    if vehData.livery ~= nil and vehData.livery >= 0 then

        ApplyVehicleLivery(testDriveVehicle, vehData.livery)

    end

    TaskWarpPedIntoVehicle(ped, testDriveVehicle, -1)

    Wait(50)

    SetVehicleEngineOn(testDriveVehicle, true, true, false)

    local plate = GetVehicleNumberPlateText(testDriveVehicle)

    if Config.GiveKey and Config.GiveKey.enabled then

        TriggerServerEvent("risk-vehicleshop:testDriveGiveKey", plate,

                           vehData.spawnName or nil, netId)

    else

        if currentFramework == "qbcore" then

            TriggerEvent("vehiclekeys:client:SetOwner", plate)

        elseif currentFramework == "esx" then

            TriggerEvent("vehiclekeys:client:SetOwner", plate)

        end

    end

    local countdown = 60

    testDriveActive = true

    testDriveTimeLeft = countdown

    SendNUIMessage({

        action = "showTestDriveUI",

        vehicleName = selectedVehicleDisplayName

    })

    SendNUIMessage({action = "testDriveTimer", timeLeft = countdown})

    CreateThread(function()

        while countdown > 0 and testDriveActive do

            Wait(1000)

            countdown = countdown - 1

            testDriveTimeLeft = countdown

            SendNUIMessage({action = "testDriveTimer", timeLeft = countdown})

        end

        if testDriveActive then EndTestDrive() end

    end)

    CreateThread(function()

        while testDriveActive do

            Wait(500)

            local pedCheck = PlayerPedId()

            if not testDriveVehicle or not DoesEntityExist(testDriveVehicle) then

                EndTestDrive()

                break

            end

            if not IsPedInVehicle(pedCheck, testDriveVehicle, false) then

                EndTestDrive()

                break

            end

        end

    end)

end

function EndTestDrive()

    if Config.Debug then print("debug: test drive ended") end

    testDriveActive = false

    local ped = PlayerPedId()

    if testDriveVehicle then

        local plate = GetVehicleNumberPlateText(testDriveVehicle)

        local netId = NetworkGetNetworkIdFromEntity(testDriveVehicle)

        if Config.GiveKey and Config.GiveKey.enabled then

            TriggerServerEvent("risk-vehicleshop:testDriveRemoveKey", plate,

                               nil, netId)

        else

            if currentFramework == "qbcore" then

                TriggerEvent("vehiclekeys:client:RemoveKey", plate)

            elseif currentFramework == "esx" then

                TriggerEvent("vehiclekeys:client:RemoveKey", plate)

            end

        end

        DeleteEntity(testDriveVehicle)

        testDriveVehicle = nil

    end

    TriggerServerEvent("risk-vehicleshop:setTestDriveDimension", 0)

    if testDriveShopIndex then

        local s = Config.Shops[testDriveShopIndex]

        SetEntityCoords(ped, s.returnCoords.x, s.returnCoords.y,

                        s.returnCoords.z, false, false, false, true)

        SetEntityHeading(ped, s.returnCoords.w)

    end

    SendNUIMessage({action = "hideTestDriveUI"})

    testDriveShopIndex = nil

end

function DisplayHelpText(msg, key)

    if Config.UseCustomHelpNotify and Config.Functions and

        Config.Functions.helpnotify then

        Config.Functions.helpnotify(key or "", msg)

        return

    end

    BeginTextCommandDisplayHelp("STRING")

    AddTextComponentSubstringPlayerName(msg)

    EndTextCommandDisplayHelp(0, 0, 1, -1)

end

function GetLocaleText(key)

    local loc = Config.Language

    if not Locales or not Locales[loc] then return key end

    return Locales[loc][key] or key

end

RegisterNetEvent("risk-vehicleshop:notify", function(payload)

    local ntype, title, text, time = "info", "Info", "", 8000

    if type(payload) == "table" then

        ntype = payload.type or ntype

        title = payload.title or title

        text = payload.text or ""

        time = payload.time or time

        if text == "" and payload.msgKey then

            text = GetLocaleText(payload.msgKey)

        end

    else

        text = GetLocaleText(payload)

    end

    if Config.UseCustomNotify and Config.Functions and Config.Functions.notify then

        Config.Functions.notify(ntype, title, text, time)

        return

    end

    AddTextEntry("RISK_NOTIFY", text)

    BeginTextCommandThefeedPost("RISK_NOTIFY")

    EndTextCommandThefeedPostTicker(true, true)

end)

RegisterNetEvent("risk-vehicleshop:spawnPurchasedVehicle",

                 function(spawnName, plate, livery, shopIndex)

    if Config.Debug then

        print("debug: spawnPurchasedVehicle called", spawnName, plate, livery,

              shopIndex)

    end

    local ped = PlayerPedId()

    local hash = GetHashKey(spawnName)

    RequestModel(hash)

    while not HasModelLoaded(hash) do Wait(10) end

    local x, y, z, h

    if shopIndex and Config.Shops[shopIndex] and

        Config.Shops[shopIndex].purchaseSpawnCoords then

        x = Config.Shops[shopIndex].purchaseSpawnCoords.x

        y = Config.Shops[shopIndex].purchaseSpawnCoords.y

        z = Config.Shops[shopIndex].purchaseSpawnCoords.z

        h = Config.Shops[shopIndex].purchaseSpawnCoords.w

    else

        x = 0.0

        y = 0.0

        z = 72.0

        h = 0.0

        if Config.Debug then

            print("debug: fallback coords because shopIndex invalid")

        end

    end

    local veh = CreateVehicle(hash, x, y, z, h, true, true)

    local netId = NetworkGetNetworkIdFromEntity(veh)

    SetNetworkIdCanMigrate(netId, true)

    SetEntityAsMissionEntity(veh, true, true)

    if plate and plate ~= "" then

        SetVehicleNumberPlateText(veh, plate)

    else

        SetVehicleNumberPlateText(veh, "BOUGHT")

    end

    if Config.SpawnClean then SetVehicleDirtLevel(veh, 0.0) end

    if Config.SpawnFullFuel then SetVehicleFuelLevel(veh, 100.0) end

    local pid = rgbToId(currentPrimaryColor.r, currentPrimaryColor.g,

                        currentPrimaryColor.b)

    local sid = rgbToId(currentSecondaryColor.r, currentSecondaryColor.g,

                        currentSecondaryColor.b)

    ClearVehicleCustomPrimaryColour(veh)

    ClearVehicleCustomSecondaryColour(veh)

    SetVehicleColours(veh, pid, sid)

    if livery ~= nil and livery >= 0 then ApplyVehicleLivery(veh, livery) end

    TaskWarpPedIntoVehicle(ped, veh, -1)

    SetVehicleEngineOn(veh, true, true, false)

    if Config.Debug then

        print("debug: purchased vehicle spawned to player with chosen color")

    end

end)

RegisterNetEvent('risk_weather:apply')

AddEventHandler('risk_weather:apply', function()

    Citizen.CreateThread(function()

        while true do

            Citizen.Wait(1000)

            SetWeatherTypePersist("EXTRASUNNY")

            SetWeatherTypeNowPersist("EXTRASUNNY")

            SetWeatherTypeNow("EXTRASUNNY")

            NetworkOverrideClockTime(12, 0, 0)

            PauseClock(true)

        end

    end)

end)
