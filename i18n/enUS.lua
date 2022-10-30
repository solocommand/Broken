
local addonName, addon = ...

local L = {}

L.Broken = 'Broken'

L.showMinimapIcon = 'Show minimap button'
L.showMinimapIconDescription = 'Show the Broken minimap button'
L.showAll = 'Show all durability'
L.showAllDescription = 'Show both equipped and inventory durability in the data text'

L.showCost = 'Show repair cost'
L.showCostDescription = 'Show the total repair cost for equipped items in the data text'
L.showPercent = 'Show percentage'
L.showPercentDescription = 'Show the percentage of damaged items in the data text'
L.showValues = 'Show values'
L.showValuesDescription = 'Show the min/max values of damaged items in the data text'

L.showCostAlways = 'Always show repair cost'
L.showCostAlwaysDescription = 'Always show the repair cost in the data text, even when nothing.'

addon.L = L
