local logger = require("ps_log").make_log()

---备用车号定义，只有无法定位到车号配置文件的时候应该使用它。平时不用手动配置他。
local role_id_alt_def = {
    Kicker      = 1,
    Receiver    = 2,
    Middle      = 3,
    Tier        = 4,
    Defender    = 5,
    Goalie      = 6
}

local role_def = {
    Kicker      = "Kicker",   --前锋
    Receiver    = "Receiver", --中场
    Middle      = "Middle",   --
    Tier        = "Tier",     --
    Defender    = "Defender", --后卫
    Goalie      = "Goalie",   --守门员
    Name        = {},         --球员名称集合
    ID          = {}          --球员车号定义
}

local function warn_func(table, key)
    assert(false, "Invalid key '"..key.."' in table.")
end

---配置角色对应关系，会删去role_def和role_id_def中没有启用的角色，并处理role_id_def
---的车号对应关系
---@param config_table table 角色-车号对应表
local function load_role_table(config_table)
    -- 处理role_def
    for name, value in pairs(role_def)
    do
        if (config_table[name] ~= nil) -- 有上场
        then
            role_def.Name[name] = name
            role_def.ID[name] = config_table[name] - 1 --车号减一
        elseif (name ~= "ID" and name ~= "Name") -- 没有上场
        then
            role_def[name] = nil
        end
    end

    -- 设置元表
    -- setmetatable(role_def, {__index = warn_func})
    -- setmetatable(role_def.ID, {__index = warn_func})
    -- setmetatable(role_def.Name, {__index = warn_func})
end


-- 获取用户配置的车号
if (PlayConfig and type(PlayConfig.gRoleFixNum) == "table") -- PBP² version
then
    logger.info("Loading 'PlayConfig.gRoleFix' configure(PBP² Version).")
    load_role_table(PlayConfig.gRoleFixNum)
elseif (json and type(json.gRoleFix) == "table")
then
    logger.info("Loading 'json.gRoleFix' configure(vanilla Version).")
else
    logger.warn("Missing configure file(config_blue.json/config_yellow.json), using alternative role define(see 'ps_role.lua').")
    load_role_table(role_id_alt_def)
end

return role_def