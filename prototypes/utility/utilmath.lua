function luamath_round(num, numDecimalPlaces)
	local result
	if numDecimalPlaces and numDecimalPlaces > 0 then
		local mult = 10 ^ numDecimalPlaces
		result =  math.floor(num * mult + 0.5) / mult
	else
		result = math.floor(num + 0.5)
	end
	if result == "nan" then
		result = 0
	end
	return result
end