dofile("./lua_scripts/opponent/"..PlayConfig.OPPONENT_NAME..".lua")
function RunRefPlay(name)
    if PlayConfig.IS_TEST_MODE then
		gNotExtYet = false
	    if name == "gameStop" then
		    --print("IN GAME STOP")
			gFnishRefPlay = false
	        local filename = "./lua_scripts/play/Ref/"..name..".lua"
			dofile(filename)
		else
		    gCurrentPlay = PlayConfig.gTestPlay
		end
    else
        if name == "gameStop"  then
        	gFirstField = ""
        	local filename = "./lua_scripts/play/Ref/"..name..".lua"
			dofile(filename)
		else
			if name == "theirIndirectKick" or name == "gameHalt" or name == "gameOver" or name == "ourIndirectKick" or name == "ourKickOff" or 
				name == "ourPenaltyKick" or name == "ourTimeout" or name == "theirKickOff" or name == "theirPenaltyKick" or name == "ourPlaceBall" or name == "theirPlaceBall" then 
				local filename = "./lua_scripts/play/Ref/"..name..".lua"
				dofile(filename)
				--print("filename"..filename)
				--printTable(gCurrentPlay)
			else
				local filename = "./lua_scripts/play/Package/"..name..".lua"
				dofile(filename)
			end
        end
	end
end

function SelectRefPlay()
	local curRefMsg = CGetRefMsg()
	--print("@START cur msg: "..curRefMsg)
	if curRefMsg == "" then
		return false
	end
	RunRefPlay(curRefMsg)
	--print("****after dofile "..gCurrentPlay)
	return true
end

if SelectRefPlay() and not gFnishRefPlay  then
	 --print("****TRUE do ref "..gCurrentPlay)
else
	if PlayConfig.IS_TEST_MODE then
			if gNotExtYet then
				local filename = "./lua_scripts/play/Ref/gameStop.lua"
				dofile(filename)
			else
				gCurrentPlay = PlayConfig.gTestPlay
			end
	else
	    if gFnishRefPlay then
			gCurrentPlay = PlayConfig.gNormalPlay
		else
			if gLastPlay == "" then
				--print("Point1")
			    gCurrentPlay = PlayConfig.gNormalPlay
			else
				--print("Point2")
			    gCurrentPlay = gLastPlay
			end
		end
	end
end

Run_Play(gCurrentPlay)
--print("cur play: "..gCurrentPlay)