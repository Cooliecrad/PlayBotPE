---@name PlayBot Ptil0psis's Extension

local function stand_alone_mod()
    PLog        = require("ps_log")         --日志库
    PEnum       = require("ps_enum")        --枚举类型库
    PFunctional = require("ps_functional")  --仿函数库
    POsPath     = require("ps_path")        --路径操作库
    BS          = require("ps_skill")       --对Skill层进行改进的库
end

local function extension_mod()
    PRole       = require("ps_role")        --球员定义
    PSkill      = require("ps_task")        --对官方task.lua进行改进的库
    PPlay       = require("ps_play")        --对Play层进行改进的库
end

if USING_PBP2
then
    return {
        stand_alone_mod = stand_alone_mod,
        extension_mod = extension_mod
    }
else
    stand_alone_mod()
    extension_mod()
end