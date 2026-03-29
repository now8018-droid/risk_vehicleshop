ESX = nil

local currentFramework = nil
local generatedPlateCache = {}
local generatedPlateOrder = {}
local generatedPlateCacheLimit = 2000

CreateThread(function()

    math.randomseed(GetGameTimer() + os.time())

    Wait(500)

    if GetResourceState("qb-core") == "started" then

        currentFramework = "qbcore"

        if Config.Debug then print("debug: qbcore found on server") end

        local obj = exports['qb-core']:GetCoreObject()

        if Config.Debug then print(obj and "debug: qbCore object acquired" or "debug: qbCore object is nil") end

    elseif GetResourceState("es_extended") == "started" then

        ESX = exports["es_extended"]:getSharedObject()

        currentFramework = "esx"

        if Config.Debug then print("debug: esx found on server") end

    else

        if Config.Debug then print("debug: no framework found on server") end

    end

end)

local function strlower(s) return (s and type(s)=="string") and string.lower(s) or s end

local function rememberGeneratedPlate(plate)

    if generatedPlateCache[plate] then return end

    generatedPlateCache[plate] = true
    generatedPlateOrder[#generatedPlateOrder + 1] = plate

    if #generatedPlateOrder > generatedPlateCacheLimit then
        local oldest = table.remove(generatedPlateOrder, 1)
        if oldest then generatedPlateCache[oldest] = nil end
    end

end

function GeneratePlate()

    if Config.PlateOptions.useCustomPlateText then

        if Config.Debug then print("debug: using custom plate text") end

        return Config.PlateOptions.customPlateText

    else

        if Config.Debug then print("debug: using random plate") end

        local letters, nums = "", ""

        for i = 1, 3 do letters = letters .. string.char(math.random(65, 90)) end

        for i = 1, 3 do nums = nums .. tostring(math.random(0, 9)) end

        -- GTA plate text has an 8-char limit; adding one leading space helps
        -- visually center the 7-char pattern "XXX 123" on the plate.
        local plate = " " .. letters .. " " .. nums

        -- Reduce short-term collisions without expensive DB checks by keeping
        -- a rolling in-memory cache of recently generated plates.
        local tries = 0
        while generatedPlateCache[plate] and tries < 20 do
            tries = tries + 1
            letters, nums = "", ""
            for i = 1, 3 do letters = letters .. string.char(math.random(65, 90)) end
            for i = 1, 3 do nums = nums .. tostring(math.random(0, 9)) end
            plate = " " .. letters .. " " .. nums
        end

        rememberGeneratedPlate(plate)
        return plate

    end

end

function DetermineVehicleType(spawnName)

    local model = GetHashKey(spawnName)

    local class = GetVehicleClassFromName(model)

    if class == 14 then return "boat"

    elseif class == 15 or class == 16 then return "plane"

    else return "car" end

end

function HasJobAccessOnServer(src, shopIndex)

    if not shopIndex then if Config.Debug then print("debug: shopIndex not provided") end return false end

    local shop = Config.Shops[shopIndex]

    if not shop or not shop.jobs then if Config.Debug then print("debug: invalid shopIndex or no jobs table") end return false end

    if #shop.jobs == 0 then if Config.Debug then print("debug: job table is empty") end return false end

    if shop.jobs[1] == "all" then return true end

    if currentFramework == "qbcore" then

        local QBCore = exports['qb-core']:GetCoreObject()

        local Player = QBCore.Functions.GetPlayer(src)

        if not Player then if Config.Debug then print("debug: qbcore player not found") end return false end

        local jobName = Player.PlayerData.job.name

        for _, j in ipairs(shop.jobs) do if j == jobName then return true end end

        if Config.Debug then print("debug: job mismatch -> " .. jobName) end

        return false

    elseif currentFramework == "esx" then

        local xPlayer = ESX.GetPlayerFromId(src)

        if not xPlayer then if Config.Debug then print("debug: esx player not found") end return false end

        local jobName = xPlayer.job.name

        for _, j in ipairs(shop.jobs) do if j == jobName then return true end end

        if Config.Debug then print("debug: job mismatch -> " .. jobName) end

        return false

    else

        if Config.Debug then print("debug: no framework found -> no job check") end

        return false

    end

end

function HasGradeRangeAccess(src, shopIndex, catIndex)

    local shop = Config.Shops[shopIndex]

    if not shop then if Config.Debug then print("debug: invalid shopIndex") end return true end

    local category = shop.categories[catIndex + 1]

    if not category then if Config.Debug then print("debug: invalid catIndex for grade check") end return true end

    if not category.gradeRange then return true end

    local minGrade = category.gradeRange[1] or 0

    local maxGrade = category.gradeRange[2] or 99

    if currentFramework == "qbcore" then

        local QBCore = exports['qb-core']:GetCoreObject()

        local Player = QBCore.Functions.GetPlayer(src)

        if not Player then if Config.Debug then print("debug: qbcore player not found for grade check") end return false end

        local grade = Player.PlayerData.job.grade.level or 0

        if grade >= minGrade and grade <= maxGrade then return true end

        if Config.Debug then print("debug: grade mismatch -> " .. tostring(grade)) end

        return false

    elseif currentFramework == "esx" then

        local xPlayer = ESX.GetPlayerFromId(src)

        if not xPlayer then if Config.Debug then print("debug: esx player not found for grade check") end return false end

        local grade = xPlayer.job.grade or 0

        if grade >= minGrade and grade <= maxGrade then return true end

        if Config.Debug then print("debug: grade mismatch -> " .. tostring(grade)) end

        return false

    else

        return true

    end

end

local function sendVehicleShopWebhook(src, spawnName, price)

    if not ConfigDC or not ConfigDC.enable or not ConfigDC.log_purchase then return end

    local discord, license = "unknown", "unknown"

    for _, id in ipairs(GetPlayerIdentifiers(src)) do

        if string.sub(id, 1, 8) == "discord:" then

            discord = "<@" .. string.sub(id, 9) .. ">"

        elseif string.sub(id, 1, 8) == "license:" then

            license = string.sub(id, 9)

        end

    end

    local embed = {{

        title = "🚗 Vehicle Purchased",

        color = ConfigDC.color,

        fields = {

            {name="👤 Player",  value=GetPlayerName(src).." [ID: "..src.."]", inline=true},

            {name="🆔 Discord", value=discord, inline=true},

            {name="🔑 License", value="`"..license.."`", inline=false},

            {name="🚘 Vehicle", value=spawnName, inline=true},

            {name="💰 Price",   value="$"..price, inline=true},

            {name="⏰ Time",    value=os.date("%d.%m.%Y %H:%M:%S"), inline=true},

            {name="📌 Status",  value="Purchased", inline=true}

        },

        footer = {text = "RISK SCRIPTS WEBHOOKS • "..os.date("%d.%m.%Y %H:%M Uhr")}

    }}

    PerformHttpRequest(

        ConfigDC.webhook,

        function() end,

        "POST",

        json.encode({username = ConfigDC.username, avatar_url = ConfigDC.avatar, embeds = embed}),

        {["Content-Type"] = "application/json"}

    )

end

RegisterNetEvent("risk-vehicleshop:buyVehicle", function(data)

    local src       = source

    local spawnName = strlower(data.spawnName)
    local price     = data.price

    local payType   = data.payType

    local shopIndex = data.shopIndex

    local catIndex  = data.catIndex

    local vehIndex  = data.vehIndex

    local modsJSON  = data.mods or "{}"

    if not spawnName or not price or not payType then

        if Config.Debug then print("debug: buyVehicle missing data") end

        return

    end

    if not HasJobAccessOnServer(src, shopIndex) then

        TriggerClientEvent("risk-vehicleshop:notify", src, "notAllowed")

        return

    end

    if not HasGradeRangeAccess(src, shopIndex, catIndex) then

        TriggerClientEvent("risk-vehicleshop:notify", src, "rankTooLow")

        return

    end

    local shop = Config.Shops[shopIndex]

    local cat  = shop and shop.categories[catIndex + 1] or nil

    if not cat then if Config.Debug then print("debug: server catIndex invalid") end return end

    local vehData = cat.vehicles[vehIndex + 1]

    if not vehData then if Config.Debug then print("debug: server vehIndex invalid") end return end

    local chosenLivery = (vehData.livery ~= nil) and vehData.livery or nil

    local vehicleType  = data.vehicleType or DetermineVehicleType(spawnName)

    local assignedJob = nil

    if shop and shop.jobs and #shop.jobs > 0 and shop.jobs[1] ~= "all" then

        assignedJob = shop.jobs[1]

    end

    if currentFramework == "qbcore" then

        local QBCore = exports['qb-core']:GetCoreObject()

        local Player = QBCore.Functions.GetPlayer(src)

        if not Player then if Config.Debug then print("debug: qbcore player not found") end return end

        if payType == "cash" then

            if Player.PlayerData.money['cash'] < price then

                TriggerClientEvent("risk-vehicleshop:notify", src, "notEnoughMoney") return

            end

            Player.Functions.RemoveMoney('cash', price, "risk-vehicleshop-purchase")

        elseif payType == "bank" then

            if Player.PlayerData.money['bank'] < price then

                TriggerClientEvent("risk-vehicleshop:notify", src, "notEnoughMoney") return

            end

            Player.Functions.RemoveMoney('bank', price, "risk-vehicleshop-purchase")

        else

            if Config.Debug then print("debug: invalid payType qbcore") end

            return

        end

        if Config.SaveVehicleToDatabase then

            local plate      = GeneratePlate()

            local licenseVal = Player.PlayerData.license

            local citizenVal = Player.PlayerData.citizenid

            if Config.UseOxmysql then

                exports.oxmysql:insert(

                    "INSERT INTO player_vehicles (license, citizenid, plate, vehicle, mods, type, job) VALUES (?, ?, ?, ?, ?, ?, ?)",

                    {licenseVal, citizenVal, plate, spawnName, modsJSON, vehicleType, assignedJob},

                    function(id) if Config.Debug then print("debug: qb vehicle inserted id="..tostring(id).." job="..tostring(assignedJob)) end end

                )

            else

                MySQL.Async.execute(

                    "INSERT INTO player_vehicles (license, citizenid, plate, vehicle, mods, type, job) VALUES (@license, @citizenid, @plate, @veh, @mods, @type, @job)",

                    {["@license"]=licenseVal, ["@citizenid"]=citizenVal, ["@plate"]=plate, ["@veh"]=spawnName, ["@mods"]=modsJSON, ["@type"]=vehicleType, ["@job"]=assignedJob},

                    function(rows) if Config.Debug then print("debug: qb vehicle inserted rows="..rows.." job="..tostring(assignedJob)) end end

                )

            end

            TriggerClientEvent("risk-vehicleshop:notify", src, "purchasedVehicle")

            sendVehicleShopWebhook(src, spawnName, price)

            if Config.SpawnVehicleOnPurchase then

                TriggerClientEvent("risk-vehicleshop:spawnPurchasedVehicle", src, spawnName, plate, chosenLivery, shopIndex)

                Wait(500)

                if Config.GiveKey and Config.GiveKey.enabled and Config.GiveKey.give then

                    Config.GiveKey.give(plate, spawnName, vehData.model or nil, nil, src)

                else

                    TriggerClientEvent("vehiclekeys:client:SetOwner", src, plate)

                end

            end

        else

            TriggerClientEvent("risk-vehicleshop:notify", src, "purchasedVehicle")

            sendVehicleShopWebhook(src, spawnName, price)

            if Config.SpawnVehicleOnPurchase then

                TriggerClientEvent("risk-vehicleshop:spawnPurchasedVehicle", src, spawnName, nil, chosenLivery, shopIndex)

            end

        end

    elseif currentFramework == "esx" then

        local xPlayer = ESX.GetPlayerFromId(src)

        if not xPlayer then if Config.Debug then print("debug: esx player not found") end return end

        if payType == "cash" then

            if xPlayer.getMoney() < price then TriggerClientEvent("risk-vehicleshop:notify", src, "notEnoughMoney") return end

            xPlayer.removeMoney(price)

        elseif payType == "bank" then

            if xPlayer.getAccount('bank').money < price then TriggerClientEvent("risk-vehicleshop:notify", src, "notEnoughMoney") return end

            xPlayer.removeAccountMoney('bank', price)

        else

            if Config.Debug then print("debug: invalid payType esx") end

            return

        end

        if Config.SaveVehicleToDatabase then

            local plate      = GeneratePlate()

            local licenseVal = xPlayer.identifier

            local vehicleDataTable = { model = GetHashKey(spawnName), plate = plate }

            local parsedMods = json.decode(modsJSON)

            if parsedMods then vehicleDataTable.mods = parsedMods end

            local vehicleData = json.encode(vehicleDataTable)

            if Config.UseOxmysql then

                exports.oxmysql:insert(

                    "INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, spawnname) VALUES (?, ?, ?, ?, ?, ?)",

                    {licenseVal, plate, vehicleData, vehicleType, assignedJob, spawnName},

                    function(rows) if Config.Debug then print("debug: esx vehicle inserted rows="..tostring(rows).." job="..tostring(assignedJob).." spawn="..spawnName) end end

                )

            else

                MySQL.Async.execute(

                    "INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, spawnname) VALUES (@owner, @plate, @veh, @type, @job, @spawn)",

                    {["@owner"]=licenseVal, ["@plate"]=plate, ["@veh"]=vehicleData, ["@type"]=vehicleType, ["@job"]=assignedJob, ["@spawn"]=spawnName},

                    function(rows) if Config.Debug then print("debug: esx vehicle inserted rows="..rows.." job="..tostring(assignedJob).." spawn="..spawnName) end end

                )

            end

            TriggerClientEvent("risk-vehicleshop:notify", src, "purchasedVehicle")

            sendVehicleShopWebhook(src, spawnName, price)

            if Config.SpawnVehicleOnPurchase then

                TriggerClientEvent("risk-vehicleshop:spawnPurchasedVehicle", src, spawnName, plate, chosenLivery, shopIndex)

                if Config.GiveKey and Config.GiveKey.enabled and Config.GiveKey.give then

                    Config.GiveKey.give(plate, spawnName, vehData.model or nil, nil, src)

                else

                    TriggerClientEvent("vehiclekeys:client:SetOwner", src, plate)

                end

            end

        else

            TriggerClientEvent("risk-vehicleshop:notify", src, "purchasedVehicle")

            sendVehicleShopWebhook(src, spawnName, price)

            if Config.SpawnVehicleOnPurchase then

                TriggerClientEvent("risk-vehicleshop:spawnPurchasedVehicle", src, spawnName, nil, chosenLivery, shopIndex)

            end

        end

    else

        if Config.Debug then print("debug: no framework found on buyVehicle") end

    end

end)

RegisterNetEvent("risk-vehicleshop:setTestDriveDimension", function(dim)

    local src = source

    if Config.Debug then print("debug: setting dimension for player "..tostring(src).." to "..tostring(dim)) end

    SetPlayerRoutingBucket(src, dim)

end)

RegisterNetEvent("risk-vehicleshop:setVehicleDimension", function(netId, dim)

    local ent = NetworkGetEntityFromNetworkId(netId)

    if DoesEntityExist(ent) then

        if Config.Debug then print("debug: setting dimension for entity "..tostring(netId).." to "..tostring(dim)) end

        SetEntityRoutingBucket(ent, dim)

    end

end)

RegisterNetEvent("risk-vehicleshop:testDriveGiveKey", function(plate, model, netId)

    local src = source

    if Config.GiveKey and Config.GiveKey.enabled and Config.GiveKey.give then

        Config.GiveKey.give(plate, model, nil, netId, src)

    else

        TriggerClientEvent("vehiclekeys:client:SetOwner", src, plate)

    end

end)

RegisterNetEvent("risk-vehicleshop:testDriveRemoveKey", function(plate, model, netId)

    local src = source

    if Config.GiveKey and Config.GiveKey.enabled and Config.GiveKey.remove then

        Config.GiveKey.remove(plate, model, nil, netId, src)

    else

        TriggerClientEvent("vehiclekeys:client:RemoveKey", src, plate)

    end

end)

