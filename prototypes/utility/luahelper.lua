function luahelper_get_table_length(table)
	local count = 0
	for k,v in pairs(table) do
		 count = count + 1
	end
	return count
end

function luahelper_get_table_non_nil_length(table)
	local count = 0
	for k,v in pairs(table) do
		if v ~= nil then
			count = count + 1
		end
	end
	return count
end

function luahelper_get_max_key(table)
	local max_key = 0
	for k, v in pairs(table) do
		if k > max_key then
			max_key = k
		end
	end
	return max_key
end

function luahelper_duplicate_shallow_table(oldtable, newtable)
	for k,v in pairs(oldtable) do
		newtable[k] = v
	end
end

function luahelper_empty_table(table)
	for k,v in pairs(table) do 
		table[k]=nil
	end
end

function luahelper_duplicate_deep_table(orig)
	local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[luahelper_duplicate_deep_table(orig_key)] = luahelper_duplicate_deep_table(orig_value)
        end
        setmetatable(copy, luahelper_duplicate_deep_table(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function luahelper_new_merged_tables(t1, t2)
	local new_table = {}
	for k,v in ipairs(t1) do
		table.insert(new_table, v)
	end
	for k,v in ipairs(t2) do
		table.insert(new_table, v)
	end
	return new_table
end

function luahelper_merge_tables(t1, t2)
	for k,v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end