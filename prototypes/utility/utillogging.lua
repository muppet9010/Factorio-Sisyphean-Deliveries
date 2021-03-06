function utillogging_position_to_string(position)
	return "(" .. position.x .. ", " .. position.y ..")"
end

tables_logged = {}
function utillogging_table_contents_to_string(target_table, name, indent, stop_traversing)
	indent = indent or 1
	local indentstring = string.rep(" ", (indent * 4))
	local table_id = string.gsub(tostring(target_table), "table: ", "")
	tables_logged[table_id] = "logged"
	local table_contents = ""
	if luahelper_get_table_length(target_table) > 0 then
		for k,v in pairs(target_table) do
			local key, value = "", ""
			if type(k) == "string" or type(k) == "number" or type(k) == "boolean" then
				key = '"' ..tostring(k) .. '"'
			elseif type(k) == "nil" then
				key = '"nil"'
			elseif type(k) == "table" then
				local sub_table_id = string.gsub(tostring(k), "table: ", "")
				if stop_traversing == true then 
					key = '"CIRCULAR LOOP TABLE'
				else
					local sub_stop_traversing = nil
					if tables_logged[sub_table_id] ~= nil then
						sub_stop_traversing = true
					end
					key = '{\r\n' .. utillogging_table_contents_to_string(k, name, indent + 1, sub_stop_traversing) .. '\r\n' .. indentstring .. '}'
				end
			elseif type(k) == "function" then
				key = '"' .. tostring(k) .. '"'
			else
				key = '"unhandled type: ' .. type(k) .. '"'
			end
			if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
				value = '"' .. tostring(v) .. '"'
			elseif type(v) == "nil" then
				value = '"nil"'
			elseif type(v) == "table" then
				local sub_table_id = string.gsub(tostring(v), "table: ", "")
				if stop_traversing == true then 
					value = '"CIRCULAR LOOP TABLE'
				else
					local sub_stop_traversing = nil
					if tables_logged[sub_table_id] ~= nil then
						sub_stop_traversing = true
					end
					value = '{\r\n' .. utillogging_table_contents_to_string(v, name, indent + 1, sub_stop_traversing) .. '\r\n' .. indentstring .. '}'
				end
			elseif type(v) == "function" then
				value = '"' .. tostring(v) .. '"'
			else
				value = '"unhandled type: ' .. type(v) .. '"'
			end
			if table_contents ~= "" then table_contents = table_contents .. ',' .. '\r\n' end
			table_contents = table_contents .. indentstring .. key .. ':' .. value
		end
	else
		table_contents = indentstring .. '"empty"'
	end
	if indent == 1 then
		tables_logged = {}
		return '"' .. name .. '":{' .. '\r\n' .. table_contents .. '\r\n' .. '}'
	else
		return table_contents
	end
end

function utillogging_log(text)
	if game ~= nil then
		game.write_file("SisypheanDeliveries_logOutput.txt", tostring(text) .. "\r\n", true)
	end
end

function utillogging_log_print(text)
	if game ~= nil then
		game.print(tostring(text))
	end
	utillogging_log(text)
end

function utillogging_add_to_log_string(logtext, newtext)
	return logtext .. newtext .. "\r\n"
end