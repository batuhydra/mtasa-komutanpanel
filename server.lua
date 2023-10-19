addCommandHandler(panel_komut, function(oyuncu)
    for i, v in pairs(acl) do 
        local hesap = getAccountName(getPlayerAccount(oyuncu))
        if isObjectInACLGroup("user."..hesap, aclGetGroup(v)) then
            triggerClientEvent(oyuncu, "DpanelSistemi:PanelAçma", oyuncu)
            break
        end
    end
end)

    --Gerekli kodlar.
addEvent("ck_cek", true)
addEventHandler("ck_cek", root, function(oyuncu)
local oyuncuAd = getPlayerName(oyuncu):gsub("#%x%x%x%x%x%x", "")
local yetkiliAd = getPlayerName(source):gsub("#%x%x%x%x%x%x", "")
local x, y, z = getElementPosition(oyuncu)
if not isPedInVehicle(source) == true then
setElementPosition(source, x+1, y+1, z+2)
outputChatBox("#00FF00[!]" ..oyuncuAd.." #ffffffAdlı oyuncuya ışınlandınız.", source, 190, 190, 190, true)
outputChatBox("#00FF00[!]" ..yetkiliAd.." #ffffffAdlı komutan size ışınlandı.", oyuncu, 190, 190, 190, true)
if isPedInVehicle(oyuncu) and not isPedInVehicle(source) then warpPedIntoVehicle(source, getPedOccupiedVehicle(oyuncu), 1) end
else
outputChatBox("#FF0000[!] Işınlanmak için lütfen araçtan inin", source, 190, 190, 190, true)
end
end)

function yolla(source, type, oyuncu, yetkiliAd, oyuncuAd, x, y,z)
setElementPosition(type, x+1, y+1, z+2)
outputChatBox("#00FF00[!] #ffffff" ..oyuncuAd.." #ffffffAdlı oyuncuyu yanınıza çektiniz.", source, 0, 255, 0, true)
outputChatBox("#00FF00[!] #ffffff" ..yetkiliAd.." #ffffffAdlı komutan sizi yanına çekti.", oyuncu, 0, 255, 0 , true)
end
    
addEvent("ck_isinlan", true)
addEventHandler("ck_isinlan", root, function(oyuncu)
local oyuncuAd = getPlayerName(oyuncu):gsub("#%x%x%x%x%x%x", "")
local yetkiliAd = getPlayerName(source):gsub("#%x%x%x%x%x%x", "")
local x, y, z = getElementPosition(source)
local arac = getPedOccupiedVehicle(oyuncu)
if isPedInVehicle(source) and not isPedInVehicle(oyuncu) then warpPedIntoVehicle(oyuncu, getPedOccupiedVehicle(source), 1) end
if arac then
yolla(source, arac, oyuncu, yetkiliAd, oyuncuAd, x, y,z)
setTimer(destroyElement, 100, 1, arac)
else
yolla(source, oyuncu, oyuncu, yetkiliAd, oyuncuAd, x, y,z)
end
end)
  -------------------------------------------------------------------------------------------------------------------------  
    --
    addEvent("kickPlayerFromServer", true)
addEventHandler("kickPlayerFromServer", root, function(playerName)
    local player = getPlayerFromName(playerName)
    
    if player then
        kickPlayer(player, "KomutanPanel (Kullanılarak Sunucudan Atıldınız.)")
    end
end)


-- Mute
addEvent("mutePlayerForDuration", true)
addEventHandler("mutePlayerForDuration", root, function(playerName, durationInSeconds)
    local playerToMute = getPlayerFromName(playerName)
    
    if playerToMute then
        -- Mute işlemi yapılır
        setPlayerMuted(playerToMute, true)
        outputChatBox(playerName .. " adlı oyuncu 10 dakika boyunca mutelendi.", root, 255, 0, 0)

        -- Belirtilen süre sonunda mute kaldırılır
        setTimer(function()
            setPlayerMuted(playerToMute, false)
            outputChatBox(playerName .. " adlı oyuncunun mutesi kaldırıldı.", root, 0, 255, 0)
        end, durationInSeconds * 1000, 1) -- Süreyi saniye cinsinden milisaniyeye çevir
    else
        outputChatBox(playerName .. " adında bir oyuncu bulunamadı.", root, 255, 0, 0)
    end
end)

-- Mute Aç
addEvent("unmutePlayer", true)
addEventHandler("unmutePlayer", root, function(playerName)
    local playerToUnmute = getPlayerFromName(playerName)
    
    if playerToUnmute then
        if isPlayerMuted(playerToUnmute) then
            -- Mute kaldırılır
            setPlayerMuted(playerToUnmute, false)
            outputChatBox(playerName .. " adlı oyuncunun mutesi kaldırıldı.", root, 0, 255, 0)
        else
            outputChatBox(playerName .. " adlı oyuncunun zaten mute durumu kapalı.", root, 255, 0, 0)
        end
    else
        outputChatBox(playerName .. " adında bir oyuncu bulunamadı.", root, 255, 0, 0)
    end
end)

-- Oyuncuyu dondurma
addEvent("freezePlayer", true)
addEventHandler("freezePlayer", root, function(targetPlayer)
    if isElement(targetPlayer) then
        setElementFrozen(targetPlayer, true)
        triggerClientEvent(targetPlayer, "onClientPlayerFrozen", resourceRoot, true)
    end
end)

-- Oyuncunun dondurmasını kaldırma
addEvent("unfreezePlayer", true)
addEventHandler("unfreezePlayer", root, function(targetPlayer)
    if isElement(targetPlayer) then
        setElementFrozen(targetPlayer, false)
        triggerClientEvent(targetPlayer, "onClientPlayerFrozen", resourceRoot, false)
    end
end)




-- Oyuncu seçilmediyse görev verme butonunu devre dışı bırak
addEventHandler("onClientGUIClick", givebutton, function()
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)
    local selectedWeaponRow = guiGridListGetSelectedItem(gridlistweapon)

    if selectedPlayerRow and selectedWeaponRow then
        local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)
        local weaponName = guiGridListGetItemText(gridlistweapon, selectedWeaponRow, weaponColumn)

        triggerServerEvent("givePlayerWeapon", localPlayer, playerName, weaponName)
    else
        outputChatBox("Lütfen bir oyuncu seçin ve silahı seçin.")
    end
end, false)

addEventHandler("onClientGUIClick", elkoy, function()
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)

    if selectedPlayerRow then
        local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)
        triggerServerEvent("takeAllWeapons", localPlayer, playerName)
    else
        outputChatBox("Lütfen bir oyuncu seçin.")
    end
end, false)


--
addEvent("giveRewardToPlayer", true)
addEventHandler("giveRewardToPlayer", resourceRoot, function(player, rewardAmount)
    if player and isElement(player) and rewardAmount and type(rewardAmount) == "number" then
        doPlayerGiveMoney(player, rewardAmount)
    end
end)
triggerEvent("giveRewardToPlayer", player, 10) -- Burada "player" oyuncu nesnesi ve "10" ödül miktarıdır
--
    addEvent("givePlayerWeapon", true)
    addEventHandler("givePlayerWeapon", root, function(playerName, weaponName)
        
        local player = getPlayerFromName(playerName)
    
        if player then
            
            giveWeapon(player, getWeaponIDFromName(weaponName), silah_mermi)

            outputChatBox("[!] " .. playerName .. " Adlı Oyuncuya Silahı Verdin.",source, 0, 255, 0)

            outputChatBox("[!] " .. getPlayerName(source) .. " Adlı komutan Tarafından Sana Silah Verildi.", player, 0, 255, 0)
        end
    end)
    

    -- Tüm silahları al işlemini gerçekleştir
    addEvent("takeAllWeapons", true)
    addEventHandler("takeAllWeapons", root, function(playerName)

        local player = getPlayerFromName(playerName)
    
        
        if player then

            takeAllWeapons(player)

            outputChatBox("[!] " .. getPlayerName(source) .. " Adlı komutan Tarafından Silahlarınıza El Konuldu.", player, 190, 190, 190)
    
            outputChatBox("[!] ".. playerName .. " Adlı Oyuncunun Silahlarına El Koydun",source, 0, 255, 0)
    
        end
    end)