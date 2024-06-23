---@brief 发送参数的函数名称
local LOAD_FUNC = "load"
local SEND_FUNC = "send"
local EXT_FUNC = "extract"

local logger = require("ps_log").make_log()

-- BetterSkills支持的类型，从Lua到C++的映射关系，键是C++类型，值是Lua类型
local BetterSkills_c_lua_type = {
    ["bool"]    = "boolean",
    ["int"]     = "number",
    ["int64_t"] = "number",
    ["char *"]  = "string",
    ["char*"]   = "string",
    ["string"]  = "string",
    ["float"]   = "number",
    ["double"]  = "number,",
    ["void"]    = "nil"
}


---函数调用，BS.Skill 会直接调用对应的函数
local ret_table = {}
---成功被调入的函数包
local loaded_pkg = {}

---加载经过BetterSKills_wrapper.h包装过的Skill包文件(xx.dll)到BetterSkills中
---每一个载入的Skill包在lua中作为一个table表现，以包'PsLib'为例
--- _G[PsLib] : type
--- PsLib = { [LOAD_FUNC] : function,
---           [SEND_FUNC] : function,
---           [EXT_FUNC]  : function,
---           arg_typev   : table }
---@param path string 存放dll文件的文件夹路径
---@param ... any 需要导入的dll文件名称
function ret_table.load_skills(path, ...)
    package.cpath = package.cpath .. ";".. path .."/?.dll"
    for i = 1, select("#", ...)
    do
        -----------------------------------------------------------------------
        -- 检测Skill包
        local pkg_name = select(i, ...)
        assert(type(pkg_name) == "string",
               string.format("Type error, got '%s'", pkg_name))
        require(pkg_name)
        -- 检查是否有三个函数，如果没有，报错
        local func_t = type(_G[pkg_name][LOAD_FUNC])
        assert(func_t == "function",
               string.format("Package error, %s.%s expect function (got '%s')",
                             pkg_name, LOAD_FUNC, func_t))
        func_t = type(_G[pkg_name][SEND_FUNC])
        assert(func_t == "function",
            string.format("Package error, %s.%s expect function (got '%s')",
                          pkg_name, SEND_FUNC, func_t))
        func_t = type(_G[pkg_name][EXT_FUNC])
        assert(func_t == "function",
            string.format("Package error, %s.%s expect function (got '%s')",
                          pkg_name, EXT_FUNC, func_t))

        -----------------------------------------------------------------------
        -- 检测Skill包的identifier
        local pkg_identi = _G[pkg_name][LOAD_FUNC]()
        assert(type(pkg_identi) == "string",
               string.format("%s.%s ret-val type error, expect string (got '%s')",
                             pkg_name, LOAD_FUNC, type(pkg_identi)))
        -- 保存解析的参数
        _G[pkg_name].arg_typev = {}
        local count = 1
        for arg in string.gmatch(pkg_identi, "[^_]+")
        do
            local lua_arg = BetterSkills_c_lua_type[arg]
            assert(lua_arg, string.format("Unsupported c/c++ type define '%s'",
                                          arg))
            _G[pkg_name].arg_typev[count] = lua_arg
            count = count + 1
        end

        -----------------------------------------------------------------------
        -- Skill包完成装载，加入到loaded_pkg中
        loaded_pkg[pkg_name] = function (role, ...)
            package.loaded[pkg_name][SEND_FUNC](...)
            _G["C"..role.."_Skill"](pkg_name)
        end
    end
end

-------------------------------------------------------------------------------
-- BetterSkills调用Skill包的实现

---返回特定Skill的调用函数，如果有回调函数，将回调函数封装进过程
---@param pkg_name string 库名
---@param callback function|nil 回调函数，当skill执行完毕时触发
---@return function|nil call 包装完毕的函数
function ret_table.get_skill(pkg_name, callback)
    -- 检测是否被装载
    if (loaded_pkg[pkg_name] == nil)
    then
        logger.error("Invalid package '%s', package may not exist or load failed.", pkg_name)
    end

    -- 没有回调，不需要包装
    if (callback == nil) then return loaded_pkg[pkg_name] end
    -- 有回调
    return function (role, ...)
        loaded_pkg[pkg_name](role, ...)
        callback(pkg_name, role, _G[pkg_name][EXT_FUNC]())
    end
end

return ret_table