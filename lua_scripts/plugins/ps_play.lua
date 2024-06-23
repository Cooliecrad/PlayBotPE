-- @brief ps_play : Ptil0psis's CreatePlay without PlayBotFix
-- 通过ps_play构建的Play，可以有效避免原先Play.lua中的switch重复调用问题
-- 没有修改原先的Play.lua函数

local Role = require("ps_role")
local Functional = require("ps_functional")
local logger = require("ps_log").make_log()


-------------------------------------------------------------------------------
---
---@class RawState : table 原始的状态表，还没有封装对应的特性。是状态机中一个状态，
---                        包含状态的转移和动作
---@field transition function 状态转移的检测函数，用来检测状态是否需要转移。函数
---                           第一个参数是发起调用的表，即self
---@field action function 动作函数，用来检测事件并分发任务给球员。函数第一个参数是
---                       发起调用的表，即self
---@note 关于函数的self究竟是谁：
---发起函数调用的self不是RawState类型，事实上，传入的参数是StateMetaTable类型，但是
---一切对自身的操作都是和对RawState操作等效的

-------------------------------------------------------------------------------
---
---@class StateTable : table 状态表，用来给 Play.lua:89 调用，保存多个角色的action
---

-------------------------------------------------------------------------------
---
---@class StateMetaTable : table StateTable的元表
---@field __property StateTable 指向自己所属的StateTable
---@field transition function 指向原来的构建时的RawState中的transition函数 
---@field action function 指向原来的构建时的RawState中的action函数

-------------------------------------------------------------------------------
---
---@class PsPlay : table Ptil0psis's Play 改进版的Play
---@field name string Play名，必须和文件名相同（无后缀名）
---@field firstState string Play的初始状态
---@field switch function 全局switch函数

-------------------------------------------------------------------------------


---@param self StateMetaTable
---@param key string
---@param value nil
local function StateMetaTable_newindex(self, key, value)
    ---------------------------------------------------------------------------
    -- 如果不是角色
    local value_t = type(value)
    if (rawget(Role.Name, key) == nil)
    then
        rawset(self, key, value) -- 直接设置值

    ---------------------------------------------------------------------------
    -- 是角色的情况
    elseif (value_t == "function" or value_t == "nil") --如果值是function或者nil
    then
        self.__property[key] = value -- 设置到state_table
    elseif (value_t == "table")
    then -- 如果是table，是新的语法糖
        local func = value[1]
        if (type(func) == "function") then
            value[1] = key -- 把第一个去掉，然后把调用者作为第一个参数
            self.__property[key] = Functional.partial_table(func, value)
        else
            logger.error("Specific table's first value expect function, got '%s'", type(func))
        end
    else
        logger.error("State-table's role attribute expect function, nil or specific-type table, got '%s'", value_t) 
    end
end

---@param self StateMetaTable
---@param key string
---@return any
local function StateMetaTable_index(self, key)
    if (rawget(Role.Name, key) ~= nil) -- 角色要到self.__property去找
    then
        return self.__property[key]
    end
    return nil -- 不是角色那还是没法找
end

---构建一个StateTable
---@param raw_table table 用来构建一个状态的表，表定义参考ps_play.lua的注释@class RawState 
---@return StateTable # 构建好的StateTable。StateTable定义参考@class StateTable
local function makeStateTable(raw_table)
    -- 将raw_table的一些函数搬到state_metatable
    local state_metatable = {__property = raw_table,
                             transition = raw_table.transition,
                             action     = raw_table.action}
    raw_table.transition = nil
    raw_table.action = nil
    setmetatable(state_metatable, {__newindex = StateMetaTable_newindex,
                                   __index    = StateMetaTable_index})
    setmetatable(raw_table, state_metatable)

    -- 检查所有Role，处理语法糖
    for k, v in pairs(raw_table) do
        StateMetaTable_newindex(state_metatable, k, v)
    end

    return raw_table
end

---@param self PsPlay
---RawState采用transition和action两个函数来区分转移和动作。根据Play.lua的架构，
---我们可以定义一个整个Play统一使用的switch函数。
---我们用一个switch函数来处理transition和action的调用，这样可以避免每一个
---StateTable定义一个switch带来的action的滞后问题
local function global_switch(self)
    -- 执行
    local state = getmetatable(self[gLastState]):transition() -- 状态转移
    if (state ~= nil)
    then  -- 有状态
        getmetatable(self[state]):action()
        return state
    else -- 无状态
        getmetatable(self[gLastState]):action()
        return gLastState
    end
end

---构建一个PsPlay
---@param raw_play table 用来构建Play的表，必须填入name（和文件名一致，不带后缀）和firstState（初始状态）
---@return PsPlay play 构建好的play，事实上已经自动调用gPlayTable.CreatePlay了
local function makePlay(raw_play)


    raw_play.switch = global_switch

    gPlayTable.CreatePlay(raw_play)
    return raw_play
end

return {
    makeStateTable = makeStateTable,
    makePlay = makePlay
}