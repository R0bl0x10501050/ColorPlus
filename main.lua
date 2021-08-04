local base16_inverted = {
	['0'] = 'F',
	['1'] = 'E',
	['2'] = 'D',
	['3'] = 'C',
	['4'] = 'B',
	['5'] = 'A',
	['6'] = '9',
	['7'] = '8',
	['8'] = '7',
	['9'] = '6',
	['A'] = '5',
	['B'] = '4',
	['C'] = '3',
	['D'] = '2',
	['E'] = '1',
	['F'] = '0',
}

local padZero = function(input)
	input = tostring(input)
	if #input:split("") ~= 1 then return input end
	return "0"..input
end

--

local ColorPlus = {}
local Functions = {}

function Functions.Add(color1, color2)
	assert(typeof(color1) == "Color3", "[ColorPlus.Add] Parameter \"color1\" must be of class \"Color3\"!")
	assert(typeof(color2) == "Color3", "[ColorPlus.Add] Parameter \"color2\" must be of class \"Color3\"!")
	return Color3.new(color1.R+color2.R, color1.G+color2.G, color1.B+color2.B)
end

function Functions.Subtract(color1, color2)
	assert(typeof(color1) == "Color3", "[ColorPlus.Subtract] Parameter \"color1\" must be of class \"Color3\"!")
	assert(typeof(color2) == "Color3", "[ColorPlus.Subtract] Parameter \"color2\" must be of class \"Color3\"!")
	return Color3.new(color1.R-color2.R, color1.G-color2.G, color1.B-color2.B)
end

function Functions.Multiply(color1, color2)
	assert(typeof(color1) == "Color3", "[ColorPlus.Multiply] Parameter \"color1\" must be of class \"Color3\"!")
	assert(typeof(color2) == "Color3", "[ColorPlus.Multiply] Parameter \"color2\" must be of class \"Color3\"!")
	return Color3.new(color1.R*color2.R, color1.G*color2.G, color1.B*color2.B)
end

function Functions.Divide(color1, color2)
	assert(typeof(color1) == "Color3", "[ColorPlus.Divide] Parameter \"color1\" must be of class \"Color3\"!")
	assert(typeof(color2) == "Color3", "[ColorPlus.Divide] Parameter \"color2\" must be of class \"Color3\"!")
	return Color3.new(color1.R/color2.R, color1.G/color2.G, color1.B/color2.B)
end

function Functions.Pow(color1, color2)
	assert(typeof(color1) == "Color3", "[ColorPlus.Divide] Parameter \"color1\" must be of class \"Color3\"!")
	assert(typeof(color2) == "Color3", "[ColorPlus.Divide] Parameter \"color2\" must be of class \"Color3\"!")
	return Color3.new(color1.R^color2.R, color1.G^color2.G, color1.B^color2.B)
end

function Functions.ToBW(color)
	assert(typeof(color) == "Color3", "[ColorPlus.ToBW] Parameter \"color\" must be of class \"Color3\"!")
	if (color.R * 0.299 + color.G * 0.587 + color.B * 0.114) > 186 then
		return Color3.new(0,0,0)
	else
		return Color3.new(1,1,1)
	end
end

function Functions.HexToRGB(hex)
	assert(typeof(hex) == "string", "[ColorPlus.RGBToHex] Parameter \"hex\" must be of type \"string\"!")
	
	hex = hex:gsub("#", "")
	
	-- Convert 3 to 6
	if (hex:len() == 3) then
		local one, two, three = hex:split("")[1], hex:split("")[2], hex:split("")[3]
		hex = one .. one .. two .. two .. three .. three
	end
	
	-- Error if invalid
	if (hex:len() ~= 6) then
		error('Invalid HEX color!')
	end
	
	-- Get RGB components from HEX
	local r = tonumber(hex:split("")[1]..hex:split("")[2], 16)
	local g = tonumber(hex:split("")[3]..hex:split("")[4], 16)
	local b = tonumber(hex:split("")[5]..hex:split("")[6], 16)
	
	return Color3.fromRGB(r, g, b)
end

function Functions.RGBToHex(rgb)
	assert(typeof(rgb) == "Color3", "[ColorPlus.RGBToHex] Parameter \"rgb\" must be of class \"Color3\"!")
	
	-- Get RGB components from Color3
	local r, g, b = rgb.R*255, rgb.G*255, rgb.B*255
	
	-- Check RGB components
	if not ((r >= 0 and r <= 255) and (g >= 0 and g <= 255) and (b >= 0 and b <= 255)) then error("[ColorPlus.RGBToHex] Invalid Color3!") end
	
	-- Convert RGB components to HEX
	return "#"..padZero(string.format("%X", r))..padZero(string.format("%X", g))..padZero(string.format("%X", b))
end

function Functions.Invert(color, bw)
	-- Check if RGB or HEX
	if type(color) == 'string' then
		-- Remove # symbol
		local hex = color:gsub("#", "")
		
		-- Convert 3 to 6
		if (hex:len() == 3) then
			local one, two, three = hex:split("")[1], hex:split("")[2], hex:split("")[3]
			hex = one .. one .. two .. two .. three .. three
		end
		
		-- Error if invalid
		if (hex:len() ~= 6) then
			error('Invalid HEX color!')
		end
		
		-- Reverse HEX
		local split = hex:split("")
		local newHex = ''
		local newRGB = ''
		table.foreachi(split, function(_,v)
			newHex = newHex .. base16_inverted[string.upper(tostring(v))]
		end)
		
		-- Get RGB components from HEX
		local r = tonumber(newHex:split("")[1]..newHex:split("")[2], 16)
		local g = tonumber(newHex:split("")[3]..newHex:split("")[4], 16)
		local b = tonumber(newHex:split("")[5]..newHex:split("")[6], 16)
		
		-- Check black/white color
		if (bw) then
			if (r * 0.299 + g * 0.587 + b * 0.114) > 186 then
				return Color3.new(1,1,1)
			else
				return Color3.new(0,0,0)
			end
		end
		
		return Color3.fromRGB(r, g, b)
	elseif typeof(color) == 'Color3' then
		-- Get RGB components
		local r, g, b = color.R*255, color.G*255, color.B*255
		
		-- Invert RGB components
		local invertedRed, invertedGreen, invertedBlue = math.round(255 - r), math.round(255 - g), math.round(255 - b)
		
		-- Check black/white color
		if (bw) then
			if (invertedRed * 0.299 + invertedGreen * 0.587 + invertedBlue * 0.114) > 186 then
				return Color3.new(1,1,1)
			else
				return Color3.new(0,0,0)
			end
		end
		
		return Color3.fromRGB(invertedRed, invertedGreen, invertedBlue)
	else
		error("[ColorPlus.Invert] Parameter \"color\" must be of type \"string\" or class \"Color3\"!")
	end
end

-- Add Normal, UPPERCASE, & lowercase versions of methods to ColorPlus
for k, v in pairs(Functions) do
	ColorPlus[k] = v
	ColorPlus[k:upper()] = v
	ColorPlus[k:lower()] = v
end

return ColorPlus
