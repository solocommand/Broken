local addonName, addon = ...
local L = addon.L
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local ldbi = LibStub:GetLibrary('LibDBIcon-1.0')
local enabled = false;

local function showConfig()
  InterfaceOptionsFrame_OpenToCategory(addonName)
  InterfaceOptionsFrame_OpenToCategory(addonName)
end

local function red(text)
  if not text then return "" end
  return RED_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE;
end

local function yellow(text)
  if not text then return "" end
  return YELLOW_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE;
end

local function green(text)
  if not text then return "" end
  return GREEN_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE;
end

-- Init & config panel
do
  local eventFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
  eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon ~= addonName then return end
    self:UnregisterEvent("ADDON_LOADED")

    if type(BrokenSettings) ~= "table" then BrokenSettings = {gold={},minimap={hide=false}} end
    local sv = BrokenSettings
    if type(sv.minimap) ~= "table" then sv.minimap = {hide=false} end
    if type(sv.showCost) ~= "boolean" then sv.showCost = true end
    if type(sv.showCostAlways) ~= "boolean" then sv.showCostAlways = false end
    if type(sv.showValuesAlways) ~= "boolean" then sv.showValuesAlways = false end
    if type(sv.showValues) ~= "boolean" then sv.showValues = false end
    if type(sv.showPercent) ~= "boolean" then sv.showPercent = true end
    addon.db = sv

    ldbi:Register(addonName, addon.dataobj, addon.db.minimap)
      self:SetScript("OnEvent", nil)
  end)
  eventFrame:RegisterEvent("ADDON_LOADED")
  addon.frame = eventFrame
end

-- data text
do
  local f = CreateFrame("frame")
  local text = "..loading.."
  local tooltip = ""
  local dataobj = ldb:NewDataObject("Broken", {
    type = "data source",
    icon = "Interface\\AddOns\\Broken\\Broken",
    text = text,
    OnEnter = function(frame)
      GameTooltip:SetOwner(frame, "ANCHOR_NONE")
      GameTooltip:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
      GameTooltip:ClearLines()
      addon:updateTooltip(frame)
      GameTooltip:Show()
    end,
    OnLeave = function()
      GameTooltip:Hide()
    end,
    OnClick = function(self, button)
      showConfig()
    end,
  })

  addon.dataobj = dataobj

  local function getColoredText(text, pct)
    if (pct <= 0.25) then
      return red(text)
    elseif (pct < 0.75) then
      return yellow(text)
    elseif (pct < 1.0) then
      return green(text)
    end
    return text
  end

  local function getDurability()
    local totalCurr = 0
    local totalMax = 0
    local equipped = 0
    local cost = 0
    for i = 1, 18 do
      if GetInventoryItemDurability(i) ~= nil then
        local currDurability, maxDurability = GetInventoryItemDurability(i)
        local _, _, repairCost = GameTooltip:SetInventoryItem("player", i)
        totalCurr = totalCurr + currDurability
        totalMax = totalMax + maxDurability
        cost = cost + repairCost
      end
    end
    local pct = totalCurr / totalMax;
    local percentage = (" %.f%%"):format(math.floor(pct * 100));
    return totalCurr, totalMax, percentage, cost
  end

  local function GetMoneyString(money)
    local goldString, silverString, copperString;
    local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
    local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
    local copper = mod(money, COPPER_PER_SILVER);
    local SILVER_AMOUNT_TEXTURE = "%02d\124TInterface\\MoneyFrame\\UI-SilverIcon:%d:%d:2:0\124t";
    local COPPER_AMOUNT_TEXTURE = "%02d\124TInterface\\MoneyFrame\\UI-CopperIcon:%d:%d:2:0\124t";

    goldString = ("|cFFFFFF00%s|r%s"):format(FormatLargeNumber(gold), GOLD_AMOUNT_SYMBOL)
    silverString = ("|cFFCCCCCC%02d|r%s"):format(silver, SILVER_AMOUNT_SYMBOL)
    copperString = ("|cFFFF6600%02d|r%s"):format(silver, COPPER_AMOUNT_SYMBOL)
  	return ('%s %s %s'):format(goldString, silverString, copperString)
  end

  local function updateText()
    local current, total, percentage, cost = getDurability();
    local pct = current / total
    local text = "";

    if (addon.db.showValues) then 
      if (cost > 0 or addon.db.showValuesAlways) then
        text = text .. (' %s/%s'):format(getColoredText(current, pct), total)
      end
    end
    if (addon.db.showPercent) then text = text .. getColoredText(percentage, pct) end
    if (addon.db.showCost) then
      if (cost > 0 or addon.db.showCostAlways) then
        text = text .. (" %s"):format(GetMoneyString(cost))
      end
    end

    dataobj.text = text
  end

  function addon:setDB(key, value)
    addon.db[key] = value
    updateText()
  end

  function addon:updateTooltip()
    GameTooltip:AddLine(L["Broken"])
    GameTooltip:AddLine("busted items here...")
  end

  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("PLAYER_DEAD")
  f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
  f:RegisterEvent("LOADING_SCREEN_DISABLED")
  f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
  f:SetScript("OnEvent", function(self, event)
    if (event == "PLAYER_ENTERING_WORLD") then enabled = true end
    if (enabled) then updateText() end
  end)
end
