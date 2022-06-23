function dump(o)
	if type(o) ~= "table" then
		return tostring(o)
	end

	local s = "{ "
	for k, v in pairs(o) do
		if type(k) ~= "number" then
			k = '"' .. k .. '"'
		end
		s = s .. "[" .. k .. "] = " .. dump(v) .. ","
	end
	return s .. "} "
end
