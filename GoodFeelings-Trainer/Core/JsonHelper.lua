local JsonHelper = {}
local Logger = require("Core/Logger")

---Read and decode a JSON file  
---@param path string Path to the JSON file  
---@return table|nil data Parsed JSON table, or nil on failure  
---@return string|nil err Error message if failed  
function JsonHelper.Read(path)
    local file, err = io.open(path, "r")
    if not file then
        Logger.Log("Failed to open for read: " .. tostring(path) .. " (" .. tostring(err) .. ")")
        return nil, "Could not open file: " .. path
    end

    local content = file:read("*a")
    file:close()

    local ok, result = pcall(json.decode, content)
    if not ok then
        Logger.Log("Invalid JSON format in: " .. tostring(path))
        return nil, "Invalid JSON format in: " .. path
    end

    return result, nil
end

---Encode and write a table to a JSON file  
---@param path string Path to the file to write  
---@param data table Table to serialize into JSON  
---@return boolean ok True if written successfully  
---@return string|nil err Error message if failed  
function JsonHelper.Write(path, data)
    local file, err = io.open(path, "w")
    if not file then
        Logger.Log("Failed to open for write: " .. tostring(path) .. " (" .. tostring(err) .. ")")
        return false, "Could not open file for writing: " .. path
    end

    local ok, content = pcall(json.encode, data)
    if not ok then
        Logger.Log("Failed to encode JSON for: " .. tostring(path))
        return false, "Failed to encode JSON"
    end

    file:write(content)
    file:close()

    return true
end

---Update a JSON file with new key-value pairs  
---Merges newData into existing JSON contents  
---@param path string Path to the JSON file  
---@param newData table New key-value pairs to merge  
---@return boolean ok True if saved successfully  
---@return string|nil err Error message if failed  
function JsonHelper.Update(path, newData)
    local existing, _ = JsonHelper.Read(path)
    if type(existing) ~= "table" then
        existing = {}
    end

    for k, v in pairs(newData) do
        existing[k] = v
    end

    return JsonHelper.Write(path, existing)
end

---Delete a key from a JSON file  
---@param path string Path to the JSON file  
---@param key string Key to remove  
---@return boolean ok True if saved successfully  
---@return string|nil err Error message if failed  
function JsonHelper.DeleteKey(path, key)
    local data, err = JsonHelper.Read(path)
    if not data then
        Logger.Log("DeleteKey failed (read error): " .. tostring(err))
        return false, err
    end

    data[key] = nil
    return JsonHelper.Write(path, data)
end

return JsonHelper
