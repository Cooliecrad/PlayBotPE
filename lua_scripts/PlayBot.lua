---@name PBP²: PlayBot Ptil0psis's Patch

package.path = package.path .. ";./lua_scripts/skill/?.lua"
                            .. ";./lua_scripts/plugins/?.lua" -- 拓展的插件
							.. ";./lua_scripts/play/?.lua"
							.. ";./lua_scripts/worldmodel/?.lua"
							.. ";./lua_scripts/opponent/?.lua"

-------------------------------------------------------------------------------
-- 有固定含义的全局变量
gCurrentPlay = ""
gLastPlay = ""
gLastState = ""
gFnishRefPlay = false
gFirstField = ""
gNotExtYet = true
gPlayTable = {}
USING_PBP2 = true

-- 函数没必要全局，只使用一次
local ret_table = {}

-- 加载PlayBot配置
function ret_table.play_bot_init(config_path)
	---------------------------------------------------------------------------
	-- 导入模块
	local pbpe = require("PBPE") -- Power by PlayBot Ptil0psis's Extension
	pbpe.stand_alone_mod() -- PlayBot的文件使用了一些PBPE的基础功能
	local Skill = require("Skill")
	local Play = require("Play")
	require("task")
	math.randomseed(os.time())

	-- 导入配置文件
	PlayConfig = require("PlayConfig").load_config(config_path)
	-- 导入战术包
	require(PlayConfig.OPPONENT_NAME)

	-- 加载原版技能
	Skill.load_skills("", PlayConfig.gSkill)
	Skill.load_skills("PlayBotSkill/", PlayConfig.gPlayBotSkill)
	-- 加载原版Play
	Play.load_plays("", PlayConfig.gBayesPlayTable)
	Play.load_plays("", PlayConfig.gRefPlayTable)

	-- 加载PlayBot增强模块
	pbpe.extension_mod()

	-- 加载用户的Play
	Play.load_plays("", PlayConfig.gTestPlayTable)
end


return ret_table