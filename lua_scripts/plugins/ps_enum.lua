-- 严格的下标规则，如果存在非法下标直接报错
local function strict_index(table, index)
    assert(false, string.format("Invalid enum-index '%s' in table", index))
end

---构建字符串枚举类型。产生的枚举表的键和值都是传入的枚举值。枚举类型采用严格的下标检查
---不会产生nil值
---@param src table 传入的枚举值
---@return table enum 枚举表
---@example local tab = string_enum{"state1", "state2", "state3"}
---@example print(tab.state1) -- 输出"state1"
local function string_enum(src)
    local tmp = {}
    for k, v in ipairs(src) do
        tmp[v] = v
    end

    setmetatable(tmp, {__index = strict_index})
    return tmp
end

---构建整型枚举类型。产生的枚举表，键是传入的枚举值，值是整型数值。数值由枚举的下标和
---用户传入的起始值组成，默认起始值为0。
---@param src table 传入的枚举值
---@param start integer? 起始值，默认为0
---@return table enum 枚举表
---@example local tab = int_enum({"state1", "state2"}, 15)
---@example print(tab.state2) -- 输出17 (15+2)
local function int_enum(src, start)
    if (start == nil) then
        start = 0
    end

    local tmp = {}
    for k, v in ipairs(src) do
        tmp[v] = k+start
    end

    setmetatable(tmp, {__index = strict_index})
    return tmp
end

return {
    string_enum = string_enum,
    int_enum = int_enum
}