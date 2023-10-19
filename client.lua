loadstring(exports["MahLib"]:getFunctions())()
loadstring(exports["MahLib"]:getFunctions("guiCreateWindow"))()

local screenW, screenH = guiGetScreenSize()
panel = guiCreateWindow((screenW - 582) / 2, (screenH - 331) / 2, 582, 331, "Komutan Panel", false)
guiWindowSetSizable(panel, false)


oyuncuGrid = guiCreateGridList(10, 50, 157, 230, false, panel)
local playerColumn = guiGridListAddColumn(oyuncuGrid, "Oyuncular", 0.9)
oyuncuAraEdit = guiCreateEdit(10, 25, 155, 20, "Oyuncu İsmi Buraya..", false, panel)
TabpanelOffical = guiCreateTabPanel(173, 24, 399, 298, false, panel)

TabSilah = guiCreateTab("Silah", TabpanelOffical)

gridlistweapon = guiCreateGridList(8, 10, 381, 113, false, TabSilah)
weaponColumn = guiGridListAddColumn(gridlistweapon, "Silahlar", 0.9)
guiGridListAddRow(gridlistweapon)

givebutton = guiCreateButton(10, 135, 179, 24, "Seçili Silahı Ver", false, TabSilah)
guiSetProperty(givebutton, "NormalTextColour", "FFFFFFFF")

elkoy = guiCreateButton(210, 135, 179, 24, "Silahlarına El Koy", false, TabSilah)
guiSetProperty(elkoy, "NormalTextColour", "FFFFFFFF")

muteButton = guiCreateButton(10, 283, 50, 20, "Mute", false, panel)
guiSetProperty(muteButton, "NormalTextColour", "FFFFFFFF")


muteacButton = guiCreateButton(65, 283, 50, 20, "Mute Aç", false, panel)
guiSetProperty(muteacButton, "NormalTextColour", "FFFFFFFF")

freezeButton = guiCreateButton(118, 283, 50, 20, "Freeze", false, panel)
guiSetProperty(freezeButton, "NormalTextColour", "FFFFFFFF")

git = guiCreateButton(65, 305, 50, 20, "Git", false, panel)
guiSetProperty(git, "NormalTextColour", "FFFFFFFF")

kick = guiCreateButton(118, 305, 50, 20, "Kick", false, panel)
guiSetProperty(kick, "NormalTextColour", "FFFFFFFF")

cek = guiCreateButton(10, 305, 50, 20, "Çek", false, panel)
guiSetProperty(cek, "NormalTextColour", "FFFFFFFF")

kapat = guiCreateButton(37, 239, 325, 24, "Paneli Kapat", false, TabSilah)
guiSetProperty(kapat, "NormalTextColour", "FFFF0000")
guiSetVisible(panel, false)

-- Görev Tabı oluşturuluyor
TabGorev = guiCreateTab("Oyuncu", TabpanelOffical)


-- İşlemler sekmesindeki etiket (label) oluşturma
oyuncuInfoLabel = guiCreateLabel(10, 10, 500, 400, "Lütfen Oyuncu Seçiniz", false, TabGorev)
guiLabelSetHorizontalAlign(oyuncuInfoLabel, "left", true)
guiSetFont(oyuncuInfoLabel, "Font1.ttf")

addEventHandler("onClientGUIClick", oyuncuGrid, function(button, state)
    if button == "left" and state == "up" then
        local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)
        
        if selectedPlayerRow ~= -1 then
            local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)
            local selectedPlayer = guiGridListGetItemData(oyuncuGrid, selectedPlayerRow, playerColumn)
            
            if isElement(selectedPlayer) then
                local playerHealth = getElementHealth(selectedPlayer)
                local playerArmor = getPedArmor(selectedPlayer)
                local playerTeam = getPlayerTeam(selectedPlayer) and getTeamName(getPlayerTeam(selectedPlayer)) or "N/A"
                local x, y, z = getElementPosition(selectedPlayer)
                local playerVehicle = getPedOccupiedVehicle(selectedPlayer)
                local vehicleID = playerVehicle and getElementModel(playerVehicle) or "N/A"
                local vehicleName = playerVehicle and getVehicleNameFromModel(vehicleID) or "N/A"
                local playerMoney = getPlayerMoney(selectedPlayer)
                
                local playerInfoText = string.format("Oyuncu İsmi: %s\n\nCan: %.2f\n\nZırh: %.2f\n\nBirlik: %s\n\nKonum: %.2f, %.2f, %.2f\n\nAraç ID: %s\n\nAraç Adı: %s\n\nPara: %d", 
                                                    playerName, playerHealth, playerArmor, playerTeam, x, y, z, vehicleID, vehicleName, playerMoney)
                
                -- Yazı tipini ve boyutunu ayarla
                local newFont = guiCreateFont("Font1.ttf", 10) -- varsayılan font yerine kendi fontunuzu ekleyin
                guiSetFont(oyuncuInfoLabel, newFont)
                guiLabelSetVerticalAlign(oyuncuInfoLabel, "top")
                guiSetText(oyuncuInfoLabel, playerInfoText)
            else
                -- Seçili oyuncu geçerli bir element değilse, bilgileri temizle
                guiSetText(oyuncuInfoLabel, "Lütfen Oyuncu Seçiniz")
            end
        else
            guiSetText(oyuncuInfoLabel, "Lütfen Oyuncu Seçiniz")
        end
    end
end, false)



local weapons = {"M4", "AK-47", "Sniper", "Deagle", "MP5"}
for _, weapon in ipairs(weapons) do
    guiGridListAddRow(gridlistweapon, weapon)
end

addEventHandler("onClientGUIClick", oyuncuAraEdit, function(button, state)
    if button == "left" and state == "up" then
        local yazi = guiGetText(oyuncuAraEdit)
        if yazi == "Oyuncu İsmi Buraya.." then
            guiSetText(oyuncuAraEdit, "")
            listeyeEkle("") -- Boşlukla arama yaparak tüm oyuncuları listele
        end
    end
end, false)



-- Oyuncu seçildiğinde bu fonksiyon çağrılır
function onPlayerSelected()
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)
    
    if selectedPlayerRow ~= -1 then
        local selectedPlayer = guiGridListGetItemData(oyuncuGrid, selectedPlayerRow, 1)
        showPlayerInfo(selectedPlayer)
    else
        showPlayerInfo(nil)
    end
end

function gridYenile(eski, yeni)
    if eventName == "onClientPlayerJoin" then
        local row = guiGridListAddRow(oyuncuGrid)
        local name = getPlayerName(source) 
        guiGridListSetItemText(oyuncuGrid, row, playerColumn, name:gsub('#%x%x%x%x%x%x', ''), false, false)
        guiGridListSetItemData(oyuncuGrid, row, playerColumn, source)
    elseif eventName == "onClientPlayerQuit" then
        local row = getGridListRowIndexFromData(oyuncuGrid, source, playerColumn)
        if row then
            guiGridListRemoveRow(oyuncuGrid, row)
        end 
    elseif eventName == "onClientPlayerChangeNick" then
        local row = getGridListRowIndexFromData(oyuncuGrid, source, playerColumn)
        if row then
            guiGridListSetItemText(oyuncuGrid, row, playerColumn, yeni:gsub('#%x%x%x%x%x%x', ''), false, false)
            guiGridListSetItemData(oyuncuGrid, row, playerColumn, source)
        end 
    end 
end 

addEventHandler("onClientPlayerJoin", root, gridYenile) 
addEventHandler("onClientPlayerQuit", root, gridYenile) 
addEventHandler("onClientPlayerChangeNick", root, gridYenile)

function getGridListRowIndexFromData(gridList, data, column)
    for i = 0, guiGridListGetRowCount(gridList) - 1 do
        if guiGridListGetItemData(gridList, i, column) == data then
            return i
        end
    end
    return false
end

function listeyeEkle(deger)
    guiGridListClear(oyuncuGrid)
    if not deger then deger = "" end
    for i, oyuncu in pairs(getElementsByType("player")) do
        local isim = getPlayerName(oyuncu)
        if string.find(isim:lower(), deger:lower()) then 
            local row = guiGridListAddRow(oyuncuGrid)
            guiGridListSetItemText(oyuncuGrid, row, playerColumn, isim:gsub('#%x%x%x%x%x%x', ''), false, false)
            guiGridListSetItemData(oyuncuGrid, row, playerColumn, oyuncu)
        end 
    end
end

addEventHandler("onClientGUIChanged", root, function() 
    if source == oyuncuAraEdit then
        listeyeEkle(guiGetText(oyuncuAraEdit))
    end 
end)

function seciliKisi()
    local row, col = guiGridListGetSelectedItem(oyuncuGrid) 
    if row ~= -1 and col ~= -1 then
        local secilenKisi = guiGridListGetItemData(oyuncuGrid, row, playerColumn)
        return secilenKisi
    else
        return false
    end
end


addEventHandler("onClientGUIClick", oyuncuAraEdit, function()
    local yazi = guiGetText(oyuncuAraEdit)
    if yazi == "Oyuncu İsmi Buraya.." then
        guiSetText(oyuncuAraEdit, "")
    end	
end, false)



    addEventHandler("onClientGUIClick", root, function()
        local oyuncu = seciliKisi()
        if source == git and oyuncu then
        triggerServerEvent("ck_cek", localPlayer, oyuncu)
        elseif source == cek and oyuncu then
        triggerServerEvent("ck_isinlan", localPlayer, oyuncu)
        end
        end)
    

    addEventHandler("onClientGUIClick", root, function()
        if source == kapat then
        guiSetVisible(panel, false)
        showCursor(false)
        end
        end)    



addEventHandler("onClientGUIClick", givebutton, function()
    
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)
    local selectedWeaponRow = guiGridListGetSelectedItem(gridlistweapon)

    if selectedPlayerRow and selectedWeaponRow then

        local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)

        local weaponName = guiGridListGetItemText(gridlistweapon, selectedWeaponRow, weaponColumn)

        triggerServerEvent("givePlayerWeapon", localPlayer, playerName, weaponName)
    else
        
    end
end, false)

-- "Mute"
addEventHandler("onClientGUIClick", muteButton, function()
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)
    
    if selectedPlayerRow then
        local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)
        triggerServerEvent("mutePlayerForDuration", localPlayer, playerName, 10 * 60) -- 10 dakika (saniye cinsinden)
    end
end, false)

-- "Mute Aç" 
addEventHandler("onClientGUIClick", muteacButton, function()
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)
    
    if selectedPlayerRow then
        local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)
        triggerServerEvent("unmutePlayer", localPlayer, playerName)
    end
end, false)




-- Freeze/Unfreeze
local isPlayerFrozen = false

addEventHandler("onClientGUIClick", freezeButton, function()
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)
    
    if selectedPlayerRow then
        local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)
        local selectedPlayer = getPlayerFromName(playerName)
        
        if selectedPlayer then
            if isPlayerFrozen then
                triggerServerEvent("unfreezePlayer", resourceRoot, selectedPlayer)
                outputChatBox(playerName .. " adlı oyuncunun freezini kaldırdınız.", 255, 255, 0)
            else
                triggerServerEvent("freezePlayer", resourceRoot, selectedPlayer)
                outputChatBox(playerName .. " adlı oyuncuyu freezlediniz.", 255, 0, 0)
            end
            isPlayerFrozen = not isPlayerFrozen
        end
    end
end, false)

-- Freeze tarafındaki Hali
addEvent("onClientPlayerFrozen", true)
addEventHandler("onClientPlayerFrozen", localPlayer, function(frozen)
    if frozen then
        outputChatBox("Oyuncu ismi freezlendi", 255, 0, 0)
    else
        outputChatBox("Oyuncu ismi freeze kaldırıldı", 0, 255, 0)
    end
end)


-- Silah


addEventHandler("onClientGUIClick", elkoy, function()
  
    local selectedPlayerRow = guiGridListGetSelectedItem(oyuncuGrid)

    if selectedPlayerRow then
       
        local playerName = guiGridListGetItemText(oyuncuGrid, selectedPlayerRow, playerColumn)

        triggerServerEvent("takeAllWeapons", localPlayer, playerName)
    end
end, false)



addEvent("DpanelSistemi:PanelAçma", true)
addEventHandler("DpanelSistemi:PanelAçma", root, function()
if guiGetVisible(panel) == false then
	guiSetVisible(panel,true)
	showCursor(true)   
	else
	guiSetVisible(panel,false)
	showCursor(false)
	end
end)