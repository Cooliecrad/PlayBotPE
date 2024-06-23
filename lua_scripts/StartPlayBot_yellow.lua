package.path = package.path .. ";./lua_scripts/?.lua"

-- 加载PlayBot脚本
local PlayBot = require("PlayBot")
PlayBot.play_bot_init("./lua_scripts/config_yellow.json")