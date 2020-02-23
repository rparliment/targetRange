local targetRangeFrame = CreateFrame("Frame", "targetRange", UIParent)
targetRangeFrame:SetSize(65, 30)
targetRangeFrame:SetClampedToScreen(true)

targetRangeFrame:RegisterForDrag("LeftButton")
targetRangeFrame:SetScript("OnDragStart", targetRangeFrame.StartMoving)
targetRangeFrame:SetScript("OnDragStop", targetRangeFrame.StopMovingOrSizing)

targetRangeFrame.Texture = targetRangeFrame:CreateTexture("rangeFrameTexture", "BACKGROUND")
targetRangeFrame.Texture:SetAllPoints()
    
targetRangeFrame.Text = targetRangeFrame:CreateFontString("rangeFrameText", "OVERLAY", "GameFontNormal")
targetRangeFrame.Text:SetPoint("CENTER", targetRangeFrame, "CENTER", 0, 0)

--addon init
local targetRangeInit = CreateFrame("FRAME")
targetRangeInit:RegisterEvent("PLAYER_ENTERING_WORLD")

local function initTargetRange(self)
    if rangeLock == nil then
        rangeLock = 0
        targetRangeFrame:SetPoint("CENTER")
        targetRangeFrame.Texture:SetColorTexture(0.8, 0.8, 0.8, 0.25)
        targetRangeFrame:SetMovable(true)
        targetRangeFrame:EnableMouse(true)
        local trPrev = 0
    elseif rangeLock == 0 then
        targetRangeFrame:SetMovable(true)
        targetRangeFrame:EnableMouse(true)
        targetRangeFrame.Texture:SetColorTexture(0.8, 0.8, 0.8, 0.25)
    elseif rangeLock == 1 then
        targetRangeFrame:SetMovable(false)
        targetRangeFrame:EnableMouse(false)
        targetRangeFrame.Texture:SetColorTexture(0.8, 0.8, 0.8, 0.0)
    end
    local trPrev = 0
    print('targetRange loaded! enter /tr for details')
    targetRangeFrame:SetPoint(trPoint, "UIParent", trRelativePoint, trxOfs, tryOfs)
end
targetRangeInit:SetScript("OnEvent", initTargetRange)

--chat commands
local function TRCommands(msg, editbox)
    if msg == 'lock' then
        targetRangeFrame:SetMovable(false)
        targetRangeFrame:EnableMouse(false)
        targetRangeFrame.Texture:SetColorTexture(0.8, 0.8, 0.8, 0.0)
        trPoint, trRelativeTo, trRelativePoint, trxOfs, tryOfs = targetRangeFrame:GetPoint()
        rangeLock = 1
        print('targetRange frame |cFFFF0000LOCKED|r')
    elseif msg == 'unlock' then
        targetRangeFrame:SetMovable(true)
        targetRangeFrame:EnableMouse(true)
        targetRangeFrame.Texture:SetColorTexture(0.8, 0.8, 0.8, 0.25)
        rangeLock = 0
        print('targetRange frame |cFF00FF00UNLOCKED|r')
    else
        if rangeLock == 1 then
			print('targetRange frame |cFFFF0000LOCKED|r')
		elseif rangeLock == 0 then
			print('targetRange frame |cFF00FF00UNLOCKED|r')
		end
        print('to lock targetRange frame enter /tr lock')
        print('to unlock targetRange frame enter /tr unlock')
    end
end
SLASH_TR1 = "/tr"
SlashCmdList["TR"] = TRCommands

--targetRange start
local targetRangeCheck = CreateFrame("FRAME")

local function rangeCheck(self)
    if IsSpellInRange("Fire Blast","Target") ~= nil then
        if (CheckInteractDistance("Target", 3) == true and trPrev ~= 1) then
            targetRangeFrame.Text:SetText("|cFFFF0000< 7 yd|r")
            trPrev = 1
        elseif (CheckInteractDistance("Target", 2) == true and CheckInteractDistance("Target", 3) ~= true and trPrev ~= 2) then
            targetRangeFrame.Text:SetText("|cFFFF00007–8 yd|r")
            trPrev = 2
        elseif (IsSpellInRange("Fire Blast","Target") == 1 and CheckInteractDistance("Target", 2) ~= true and trPrev ~= 3) then
            targetRangeFrame.Text:SetText("|cFFFF00008–20 yd|r")
            trPrev = 3
        elseif (CheckInteractDistance("Target", 4) == true and IsSpellInRange("Fire Blast","Target") ~= 1 and trPrev ~= 4) then
            targetRangeFrame.Text:SetText("20–28 yd")
            trPrev = 4           
        elseif (IsSpellInRange("Polymorph","Target") == 1 and CheckInteractDistance("Target", 4) ~= true and trPrev ~= 5) then
            targetRangeFrame.Text:SetText("|cFFFFA50028–30 yd|r")
            trPrev = 5
        elseif (IsSpellInRange("Fireball","Target") == 1 and IsSpellInRange("Polymorph","Target") ~= 1 and trPrev ~= 6) then
            targetRangeFrame.Text:SetText("|cFF00FF0030–35 yd|r")
            trPrev = 6
        elseif (IsSpellInRange("Frostbolt","Target") == 1 and IsSpellInRange("Fireball","Target") ~= 1 and trPrev ~= 7) then
            targetRangeFrame.Text:SetText("|cFF00FF0035-36 yd|r")
            trPrev = 7
        elseif (IsSpellInRange("Detect Magic","Target") == 1 and IsSpellInRange("Frostbolt","Target") ~= 1 and trPrev ~= 8) then
            targetRangeFrame.Text:SetText("|cFFFF000036–40 yd|r")
            trPrev = 8
        elseif (IsSpellInRange("Detect Magic","Target") ~= 1 and trPrev ~=9) then
            targetRangeFrame.Text:SetText("|cFFFF0000> 40 yd|r")
            trPrev = 9
        end
    else
        trPrev = 0
        if rangeLock == 0 then
            targetRangeFrame.Text:SetText("targetRange")
        else
        targetRangeFrame.Text:SetText("")
        end
    end
end
targetRangeCheck:SetScript("OnUpdate", rangeCheck)