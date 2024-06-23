gSkillTable = {}

function gSkillTable.CreateSkill(spec)
	assert(type(spec.name) == "string")
	print("Init Skill: "..spec.name)
	gSkillTable[spec.name] = spec
	return spec
end

---加载技能到gSkillTable
---@param dirname string 加载路径。采用相对路径，以./Team/lua_scripts/skill为基址
---@param basename_table table|string 文件名称的序列。不需要带后缀名
function gSkillTable.load_skills(dirname, basename_table)
	if (type(basename_table) == "string")
	then
		basename_table = {basename_table}
	end

	for _, basename in ipairs(basename_table)
	do
		if (basename ~= "")
		then
			local filename = "./lua_scripts/skill/"..dirname..basename..".lua"
			dofile(filename)
		end
	end
end

return gSkillTable