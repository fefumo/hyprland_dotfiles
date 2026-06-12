local MAX_ZOOM = 5
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
local function zoom(offset)
	local current = hl.get_config("cursor.zoom_factor")
	if offset ~= nil then
		current = current + offset
	elseif current ~= MIN_ZOOM then
		current = MIN_ZOOM
	else
		current = ZOOM_TOGGLE_FACTOR
	end
	current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
	hl.config({ cursor = { zoom_factor = current } })
end

local toggle = false

-- i know it's dirty, but I'm too lazy to rewrite the zoom func itself
hl.bind("SUPER + Z", function()
	if not toggle then
		zoom(MAX_ZOOM)
		toggle = true
	else
		zoom()
		toggle = false
	end
end)
