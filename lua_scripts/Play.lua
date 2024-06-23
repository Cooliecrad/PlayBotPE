local logger = PLog.make_log()

function gPlayTable.CreatePlay(playmetatable)
	gPlayTable[playmetatable.name] = playmetatable
	--local ta = string.format("%s",tostring(playmetatable))
	--print(ta)
end

---加载Play到gPlayTable
---@param dirname string 加载路径。采用相对路径，以./Team/lua_scripts/play为基址
---@param basename_table table|string 文件名称的序列。不需要带后缀名
function gPlayTable.load_plays(dirname, basename_table)
	if (type(basename_table) == "string")
	then
		basename_table = {basename_table}
	end
	for _, basename in ipairs(basename_table)
	do
		if (basename ~= "")
		then
			local filename = "./lua_scripts/play/"..dirname..basename..".lua"
			dofile(filename)
		end
	end
end

function Run_Play(play_name)
	local cur_play = gPlayTable[play_name]
	--print("Run_Play: " ..play_name)
	--if cur_play ~=nil then
		--PrintTable(cur_play)
	--end
	if cur_play ~= nil
	then
		-- 新的play，加载初态
		if play_name ~= gLastPlay then
			if cur_play.firstState ~= nil then
				logger.info("Play enter first-state '%s'.", cur_play.firstState)
				gLastState = cur_play.firstState
				CISStateSwitch(true)
				CGetLuaState(play_name, gLastState)
			else
				logger.error("Play '%s' missing first-state.", play_name)
			end
		end
		gLastPlay = play_name

		-----------------------------------------------------------------------
		-- 处理状态转移
		local current_state = nil
		-- 如果有全局switch函数，执行全局switch函数。否则执行状态的switch函数
		if cur_play.switch ~= nil then
			current_state = cur_play:switch()
		elseif cur_play[gLastState].switch ~=nil then
			current_state = cur_play[gLastState]:switch()
		else
			logger.warn("Missing function 'switch'(expect global switch or '%s.switch').", gLastState)
		end
		-- 处理返回值
		if (current_state ~= nil and current_state ~= gLastState) -- 状态改变
		then
			logger.info("Play-state transit to '%s'.", current_state)
			CISStateSwitch(true)
			CGetLuaState(play_name, current_state)
			if gCurrentPlay == "finish" -- 如果进入finish状态，认为完成
			then
				logger.info("Play '%s' has finished.", play_name)
				gFnishRefPlay = true
			else
				gFnishRefPlay = false
			end
		else -- 不变
			current_state = gLastState
			CISStateSwitch(false)
		end

		-----------------------------------------------------------------------
		-- 执行task
		--警告：如果是exit或finish状态，则执行前一态的task
		local action_state
		if current_state == "exit" or current_state == "finish"
		then
			action_state = gLastState
		else
			action_state = current_state
		end
		-- 执行
		for role,v in pairs(cur_play[action_state])do
			local task = cur_play[action_state][role]
			if task ~= nil then
				task()
			else -- 这里除非修改了table的metatable.__index函数，否则不会被执行
				logger.error("'%s.%s' is a nil value(expect 'function').", action_state, role)
			end
		end

		gLastState = current_state
	else
		logger.warn("Play '%s' load failed, got 'nil'!", play_name)
	end
end

function Play_Exit(play_name)
	if(gPlayTable[play_name] ~= nil) then
		if current_state == "finish" or current_state == " exit" then
			return true
		else
			return false
		end
	else
		print("skill error")
	end
end

return gPlayTable