local log_metatable = {}
log_metatable.__index = {}

local level_define = {
    debug = 1,
    info = 2,
    warn = 3,
    error = 4
}

local log_module = {}
-- 全局log等级，作为make_log的缺省值。不应该随意更改，且更改只对新创建的logger生效
log_module.level = 1
-- 全局log输出的文件名，作为make_log的缺省值。
log_module.filename = "pslua_log.txt"
-- 已经打开文件的指针。将指针保存在这里，让程序退出再释放指针，避免意外的覆盖
local open_fp = {}

---@class Logger : table
---@field debug function
---@field info function
---@field warn function
---@field error function

---创建log句柄
---@param level number? log等级，默认为全局等级(Log.level)。定义: Debug = 1, Info = 2, Warn = 3, Error = 4
---@param tag string? log使用的tag，默认值为当前文件的文件名
---@param filename string? 输出文件名，默认值为全局文件名(Log.filename)
---@return Logger # log句柄
function log_module.make_log(level, tag, filename)
    -- 补全参数
    if (tag == nil)
    then
        tag = string.match(debug.getinfo(2, "S").short_src, "[^/\\]+$")
    end
    if (filename == nil)
    then
        filename = log_module.filename
    end
    if (level == nil)
    then
        level = log_module.level
    end

    -- 打开文件
    local fp = open_fp[filename]
    if (fp == nil) -- 没有打开过
    then
        fp = io.open(filename, "w")
        open_fp[filename] = fp
    end
    if (fp == nil) then return {} end

    -- 包装函数
    local function log_debug(format, ...)
        fp:write(string.format("[ Debug | %s:%d ] "..format.."\n",
                               tag,
                               debug.getinfo(2, "l").currentline,
                               ...))
        fp:flush()
    end
    local function log_info(format, ...)
        fp:write(string.format("[ Info | %s:%d ] "..format.."\n",
                               tag,
                               debug.getinfo(2, "l").currentline,
                               ...))
        fp:flush()
    end
    local function log_warn(format, ...)
        fp:write(string.format("[ Warn | %s:%d ] "..format.."\n",
                               tag,
                               debug.getinfo(2, "l").currentline,
                               ...))
        fp:flush()
    end
    ---打印错误信息，包括堆栈
    local function log_error(format, ...)
        if (format == nil) then format = "" end
        fp:write(debug.traceback(string.format("[Error | %s:%d ]"..format,
                                               tag,
                                               debug.getinfo(2, "l").currentline,
                                               ...),
                                 2).."\n")
        assert(false, string.format("[Error | %s:%d ]"..format,
                                    tag,
                                    debug.getinfo(2, "l").currentline,
                                    ...))

        fp:flush()
    end

    --log等级。等级定义: Debug = 1, Info = 2, Warn = 3, Error = 4
    local ret_table = {
        debug = log_debug,
        info  = log_info,
        warn  = log_warn,
        error = log_error
    }

    --按照实际的log等级来废除函数
    if (level > level_define.debug)
    then
        ret_table.debug = function () end
        if (level > level_define.info)
        then
            ret_table.info = function () end
            if (level > level_define.warn)
            then
                ret_table.warn = function () end
                if (level > level_define.error)
                then
                    ret_table.error = function () end
                end
            end
        end
    end

    return ret_table
end

---打印Table
---@param table table
---@param message string? 在Table前面的信息
---@param indent number? 已有的缩进量（单位：空格）
---@param indent_len number? 单次缩进的长度（单位：空格）
---@return string
function log_module.table_to_string(table, message, indent, indent_len)
    -- 参数检查
    if (type(message) ~= "string") then message = "" end
    if (type(indent) ~= "number") then indent = 0 end
    if (type(indent_len) ~= "number") then indent_len = 2 end
    indent = indent + indent_len
    local indent_base = string.rep(" ", indent)

    -- 第一行
    message = message.."{\n"

    -- 内容，任何元素结束都得换行
    local flag = true
    for k,v in pairs(table) do
        if type(v) == "table"
        then
            if (flag)
            then
                message = string.format("%s%s%s = ", message, indent_base, tostring(k))
                flag = false
            else
                message = string.format("%s,\n%s%s = ", message, indent_base, tostring(k))
            end
            message = log_module.table_to_string(v, message, indent, indent_len)
        else
            if (flag)
            then
                message = string.format("%s%s%s = %s",
                                        message,        indent_base,
                                        tostring(k),    tostring(v))
                flag = false
            else
                message = string.format("%s,\n%s%s = %s",
                                        message,        indent_base,
                                        tostring(k),    tostring(v))
            end
        end
    end

    -- 去掉最后一个逗号，关闭括号，加上逗号换行
    return string.format("%s\n%s}", message, string.rep(" ", indent-indent_len))
end

return log_module