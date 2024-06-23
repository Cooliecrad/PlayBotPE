local config_tab = {}

---@class StrategyPkg
---@field IS_TEST_MODE 		boolean 		是否为测试模式
---@field OPPONENT_NAME 	string 			战术包名称
---@field gBayesPlayTable 	table|string
---@field gNormalPlay 		string
---@field gPlayBotSkill 	table  			内建每一个角色都可以使用的通用技能
---@field gRefPlayTable 	table	
---@field gRoleFixNum 		table 			角色与车号的对应
---@field gSkill 			table			内建的角色技能路径。相对路径，基址为./Team/lua_scripts/skill
---@field gTestPlay 		string  		正在测试的脚本名称
---@field gTestPlayTable    table|string	正在测试的脚本路径。相对路径，基址为./Team/lua_scripts/play

---加载战术包cfg并注册角色
---@param config_path string 战术包路径，采用json格式
---@return StrategyPkg
function config_tab.load_config(config_path)
	local cjson = require("json")
	-- 加载文件到内存
	local file = io.open(config_path, "r")
	if (file == nil) then error("File '"..config_path.."' not found.") end
	local cfg_json = cjson.decode(file:read("*a"))
	file:close()

	-- 注册角色和车号，配置的车号和实际车号相差1
	for	role,id in pairs(cfg_json.gRoleFixNum)
	do
		CRegisterRole(role, id - 1)
	end

	return cfg_json;
end

return config_tab