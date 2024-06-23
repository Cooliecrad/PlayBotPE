---返回文件basename的开始下标
---@param path string
---@return integer|nil index 如果是无效名称，返回nil
local function cut_basename(path)
    local tmp = string.find(path, "[^/\\]+$") -- 只要一个
    return tmp
end

---返回文件后缀名分割点的开始下标
---@param basename string
---@return integer|nil index 如果没有后缀名，就返回nil
local function cut_suffix_dot(basename)
    local index = string.find(basename, "[^.]+$")-1
    if (index ~= nil and index > 1) then
        return index
    else
        return nil
    end
end

---返回文件basename
---@example src/test/a.tar.gz -> a.tar.gz
---@param path string 
---@return string|nil index 如果是无效名称，返回nil
local function basename(path)
    return string.match(path, "[^/\\]+$")
end

---返回文件后缀名
---@example src/test/a.tar.gz -> gz
---@example src/test/.a -> nil
---@param path string 文件路径
---@return string|nil index 如果没有后缀名，返回nil
local function suffix_name(path)
    local bname = basename(path)
    if (bname == nil) then
        return nil
    end
    local index = cut_suffix_dot(bname)
    if (index ~= nil) then
        return string.sub(bname, index+1, #path)
    else
        return nil
    end
end

---返回文件前缀名
---@example src/test/a.tar.gz -> a.tar
---@example src/test/.a -> .a
---@param path string 文件路径
---@return string|nil index 如果是无效名称，返回nil
local function prefix_name(path)
    local bname = basename(path)
    if (bname == nil) then
        return nil
    end
    local index = cut_suffix_dot(bname)
    if (index == nil) then
        return bname
    else
        return string.sub(bname, 1, index-1)
    end
end

---返回路径名
---@param path string
---@return string
local function dirname(path)
    return string.sub(path, 1, cut_basename(path)-2)
end

return {
    cut_basename = cut_basename,
    cut_suffix_dot = cut_suffix_dot,
    basename = basename,
    suffix_name = suffix_name,
    prefix_name = prefix_name,
    dirname = dirname
}