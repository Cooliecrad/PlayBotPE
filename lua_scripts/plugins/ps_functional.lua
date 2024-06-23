---偏函数，类似于python中的partial
---@param func any
---@param ... unknown
---@return function
local function partial(func, ...)
    local parg = arg
    if (select("#", parg) == 0)
    then -- 偏函数无参数的情况，简化调用
        return function (...)
            return func(...)
        end
    else -- 偏函数有参数的情况
        return function(...)
            for i, v in ipairs(arg) do
                table.insert(parg, v)
            end
            return func(unpack(parg))
        end
    end
end

local function partial_table(func, table)
    return function ()
        return func(unpack(table))
    end
end

return {
    partial = partial,
    partial_table = partial_table
}