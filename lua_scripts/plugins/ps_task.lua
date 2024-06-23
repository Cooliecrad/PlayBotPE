local Role = require("ps_role")
local logger = require("ps_log").make_log()

local ret_table = {}
-------------------------------------------------------------------------------
-- 函数装饰，Task.Wrap.Skill 返回的是函数Skill，需要手动调用
ret_table.Wrap = {}
---返回任务函数。任务函数实现朝向某个角色拿球，如果第一个和第二个参数相同,则为朝向球门
--拿球。
---@param executor string 执行者的角色名
---@param recvier string 朝向球员的角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.GetBall(executor, recvier)
    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
    end

    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, recvier = "..recvier)
        return nil
    end

    return function ()
        return CGetBall(executor, recvier)
    end
end

---返回任务函数。任务函数实现守门，根据场上的球状态(进攻或者防守),做相应的守门策略
---@return function task 包装好的任务函数
function ret_table.Wrap.Goalie()
    return CGoalie
end

---返回任务函数。任务函数去接球点，接球点的位置是按照场上球的位置做相应逻辑获得的
---@param executor string 执行者的角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.GoRecePos(executor)
	if (rawget(Role.Name, executor) == nil)
    then
        logger.warn(("[%s]Invalid argument, executor = %s")..executor)
        return nil
	end

    return function ()
        return CGoReceivePos(executor)
    end
end

---返回任务函数。急停，立即停止，车保持原地不动
---@param executor string 执行者的角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.RobotHalt(executor)
	if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
	end

    return function ()
        return CHalt(executor)
    end
end

---返回任务函数。普通状态下防守。防守是按照球的位置决定防守点。
---@param executor string 执行者的角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.NormalDef(executor)
	if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
	end

    return function ()
        return CNormalDef(executor)
    end
end

---返回任务函数。任务函数完成朝向某个角色传球
---@param executor string 执行者的角色名
---@param recvier string 被传球者角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.PassBall(executor, recvier)
    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
    end

    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, recvier = "..recvier)
        return nil
    end

    return function ()
        return CPassBall(executor, recvier)
    end
end

---返回任务函数。任务函数完成接球，接球点的位置是按照场上球的位置做相应的逻辑获得的
---@param executor string 执行者的角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.ReceiveBall(executor)
	if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
	end

    return function ()
        return CReceiveBall(executor)
    end
end

---返回任务函数。停止
---@param executor string 执行者角色名
---@param role number 分为1、2、3、4、5、6共计6种情况，根据不用角色停球位置不同。（1代表前锋，离球50cm；2代表前腰；3代表中场；4代表后腰；5代表后卫；6代表守门员）
---@return function|nil task
function ret_table.Wrap.Stop(executor, role)
    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
    end

    return function ()
        return CRobotStop(executor, role)
    end
end

---返回任务函数。任务函数实现射门，朝向位置是按照场上球门的位置做相应的逻辑获得的
---@param executor string 执行者角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.Shoot(executor)
    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
    end

    -- 实际上CShoot接受三个参数，具体可以参考task.lua的实现，但是在task.lu中，另外
    -- 两个参数并没有实际生效
    return function ()
        return CShoot(executor)
    end
end

---返回任务函数。任务函数实现裁判盒状态下防守，接收到裁判指令后的防守策略
---@param executor string 执行者角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.RefDef(executor)
    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
    end

    return function ()
        return CRefDef(executor)
    end
end

---返回任务函数。任务函数实现去某个点，球员跑位到某点后，并朝向某一角度
---@param executor string 为执行者角色名
---@param x number|function 点的x轴坐标 / 返回坐标的函数(单位：cm)
---@param y number|function 点的y轴坐标 / 返回坐标的函数(单位：cm)
---@param dir number|function 机器人朝向 / 返回朝向的函数（单位：角度）
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.GotoPos(executor, x, y, dir)
    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
    end

    local tmp = type(x)
    if (tmp == "function")
    then
        x = x()
	elseif (tmp ~= "number")
    then
        logger.warn("Type error, argument 'x' (function or number expected, got '%s')", tmp)
        return nil
    end

    tmp = type(y)
    if (tmp == "function")
    then
        y = y()
	elseif (tmp ~= "number")
    then
        logger.warn("Type error, argument 'y' (function or number expected, got '%s')", tmp)
        return nil
    end

    tmp = type(dir)
    if (tmp == "function")
    then
        dir = dir()
	elseif (tmp ~= "number")
    then
        logger.warn("Type error, argument 'dir' (function or number expected, got '%s')", tmp)
        return nil
    end

    return function ()
        return CGotoPos(executor, x, y, dir)
    end
end

---返回任务函数。任务函数实现点球防守，在接收到裁判盒点球命令后执行防守
---@return function task 包装好的任务函数
function ret_table.Wrap.PenaltyDef()
    return CPenaltyDef
end

---返回任务函数。任务函数实现罚点球，在接收到罚点球命令后执行点球
---@param executor string 为执行者角色名
---@return function|nil task 包装好的任务函数
function ret_table.Wrap.PenaltyKick(executor)
    if (rawget(Role.Name, executor) == nil)
    then
        logger.warn("Invalid argument, executor = "..executor)
        return nil
    end

    return function ()
        return CPenaltyKick(executor)
    end
end


-------------------------------------------------------------------------------
-- 函数调用，Task.Exec.Skill 会直接调用对应的函数Skill
ret_table.Exec = {}
---朝向某个角色拿球。两个参数，没有参数检查。第一个参数为执行者的角色名，第二个参数为
---朝向球员的角色名。如果第一个和第二个参数相同，则为朝向球门拿球。
ret_table.Exec.GetBall = CGetBall

---守门，根据场上的球状态(进攻或者防守),做相应的守门策略。无参数。
ret_table.Exec.Goalie = CGoalie

---去接球点，接球点的位置是按照场上球的位置做相应逻辑获得的。一个参数，没有参数检查。
---第一个参数为执行者的角色名。
ret_table.Exec.GoRecePos = CGoReceivePos

---急停，立即停止，车保持原地不动。一个参数，没有参数检查。第一个参数为执行者的角色名。
ret_table.Exec.RobotHalt = CHalt

---普通状态下防守。防守是按照球的位置决定防守点。
---一个参数，没有参数检查。第一个参数为执行者的角色名。
ret_table.Exec.NormalDef = CNormalDef

---完成朝向某个角色传球。两个参数，没有参数检查。第一个参数为执行者的角色名，第二个参数为
---传球球员的角色名。
ret_table.Exec.PassBall = CPassBall

---完成接球，接球点的位置是按照场上球的位置做相应的逻辑获得的。一个参数，没有参数检查。
---第一个参数为执行者的角色名。
ret_table.Exec.ReceiveBall = CReceiveBall

---停止。两个参数，没有参数检查。第一个参数为执行者的角色名，第二个参数
---分为1、2、3、4、5、6共计6种情况，根据不用角色停球位置不同。
---（1代表前锋，离球50cm；2代表前腰；3代表中场；4代表后腰；5代表后卫；6代表守门员）
ret_table.Exec.Stop = CRobotStop

---射门，朝向位置是按照场上球门的位置做相应的逻辑获得的。一个参数，没有参数检查。
---第一个参数为执行者的角色名。
ret_table.Exec.Shoot = CShoot

---裁判盒状态下防守，接收到裁判指令后的防守策略。一个参数，没有参数检查。第一个参数
---为执行者的角色名。
ret_table.Exec.RefDef = CRefDef

---去某个点，球员跑位到某点后，并朝向某一角度。四个参数，没有参数检查。第一个参数为
---执行者的角色名，第二第三第四个参数为number类型，代表点位和朝向
ret_table.Exec.GotoPos = CGotoPos

---点球防守，在接收到裁判盒点球命令后执行防守。无参数
ret_table.Exec.PenaltyDef = CPenaltyDef

---罚点球，在接收到罚点球命令后执行点球。一个参数，没有参数检查。第一个参数
---为执行者的角色名。
ret_table.Exec.PenaltyKick = CPenaltyKick

-------------------------------------------------------------------------------
return ret_table