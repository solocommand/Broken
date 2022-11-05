local addonName, addon = ...
local L = addon.L
local ldbi = LibStub('LibDBIcon-1.0', true)

local function build()
  local t = {
    name = "Broken",
    handler = Broken,
    type = 'group',
    args = {
      showMinimapIcon = {
        type = 'toggle',
        name = L.showMinimapIcon,
        desc = L.showMinimapIconDescription,
        order = 0,
        get = function(info) return not addon.db.minimap.hide end,
        set = function(info, value)
          local config = addon.db.minimap
          config.hide = not value
          addon:setDB("minimap", config)
          ldbi:Refresh(addonName)
        end,
      },
      showValues = {
        type = 'toggle',
        order = 1,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
        name = L.showValues,
        desc = L.showValuesDescription,
      },
      showValuesAlways = {
        type = 'toggle',
        order = 1,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
        name = L.showValuesAlways,
        desc = L.showValuesAlwaysDescription,
      },
      showPercent = {
        type = 'toggle',
        order = 1,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
        name = L.showPercent,
        desc = L.showPercentDescription,
      },
      showCost = {
        type = 'toggle',
        order = 1,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
        name = L.showCost,
        desc = L.showCostDescription,
      },
      showCostAlways = {
        type = 'toggle',
        order = 1,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
        name = L.showCostAlways,
        desc = L.showCostAlwaysDescription,
      },
    }
  }
  -- return our new table
  return t
end

LibStub("AceConfig-3.0"):RegisterOptionsTable("Broken", build, nil)
addon.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "Broken")
