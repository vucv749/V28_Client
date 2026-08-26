-- 自动牻斗设置
-- 雪舞添加自动升级功能
local g_unifiedposistion = nil
local MD_AUTO_LEVELUP_LIMIT = 359		--????????
local g_configdata = {
	useskill = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, },
	usepotiont = { 0, 0, 0, 0, },
	usepotion =  { 1,  1,  1, 1, },
	usepotionc = { 50, 50, 50, 80, },

	useRecoverSkill = { 50, 50, 50, },
	usePetSkill = { 1, 1 },
	usePetSkillc = { 50, 50 },
	usePetSkillt = { 0, 0 },

	useSwitch = {1,1},

	valid = 0,
	ticktime = 1,
}

local g_data = {
	xfselect = 1,	-- ??????
	curxfid = 1,	-- ???
	option = 1,		-- ?????
}
-- 心法
local g_uixfskillactions = {}
-- 子技能组合
local g_uiskillactions = {}
-- 选项组合
local g_uiskilloptions = {}
-- 回复节能特殊页签组合
local g_uirrskilloptions = {}
-- 切换页签按钮
local g_uipageactions = {}
-- 子选项组合
local g_uioptionsactions = {}
-- 其他ui
local g_uicommoninfo = {}

-- 回调内容集合
local g_recoverInfo = {}
local g_recoverSkills = {}
local g_petSkills = {}

--==================================下面为固定常量===============================================
-- 当前页签号
local g_curpage = 5
-- 无门派
local g_invalidmenpai = 9
-- 峨眉ID
local g_menpai_emei = 4

local g_menpaiattr = {
	[0] = {image = "set:Menpaishuxing image:Shuxing_Dark", tooltip = "#{MPZSX_20071221_13}", },			--??
	[1] = {image = "set:Menpaishuxing image:Shuxing_Fire", tooltip = "#{MPZSX_20071221_12}",},				--??
	[2] = {image = "set:Menpaishuxing image:Shuxing_PoisonFire", tooltip = "#{MPZSX_20071221_15}",},		--??
	[3] = {image = "set:Menpaishuxing image:Shuxing_DarkIce", tooltip = "#{MPZSX_20071221_16}",},			--??
	[4] = {image = "set:Menpaishuxing image:Shuxing_IceDark", tooltip = "#{MPZSX_20071221_17}",},			--??
	[5] = {image = "set:Menpaishuxing image:Shuxing_Poison", tooltip = "#{MPZSX_20071221_14}",},			--??
	[6] = {image = "set:Menpaishuxing image:Shuxing_FIPD", tooltip = "#{MPZSX_20071221_18}",},				--??
	[7] = {image = "set:Menpaishuxing image:Shuxing_Ice", tooltip = "#{MPZSX_20071221_11}",},				--??
	[8] = {image = "set:Menpaishuxing image:Shuxing_FirePoison", tooltip = "#{MPZSX_20071221_19}",},		--??
	[9] = {image = "", tooltip = "#{ZDZD_200724_46}",},													--???
	[10]= {image = "set:CommonFrame38 image:Shuxing_ManTuoDarkPoison", tooltip = "#{MPZSX_20071221_20}", },			--mtsz
}
-- 被禁止取消的茽通攻击技能,每个门派一个，特写吧，表里虽然按顺序写的，但是一旦改变顺序就GG了。
local g_nobanskill = {
	281,311,341,371,401,431,461,491,521,760
}
local g_optionbtnattr = {
	special = {num=3, text={"#{ZDZD_200724_10}","#{ZDZD_200724_11}","#{ZDZD_200724_12}"},},
	normal = {num=2, text={"#{ZDZD_200724_10}","#{ZDZD_200724_12}"},},
}

local g_configdef = {
	useskill = 17,
	usepotion = 4,
	userecover = 4,
	usepet = 2,
	useswitch = 2,
}

local g_optionpagedef = {
	recoverinfo = 1,	-- ??
	recoverskill = 2,	-- ????
	petskill = 3,		-- ????
}

local g_rateautodef = {
	select = 2,
	happiness = 4,
}

local g_ratevalue = {
	30,50,70,
}
local g_ratevaluehappiness = {
	75,80,90,
}
-- 宠物技能配置。 绿色挪过来的貌似不能通用，写死吧
local g_recoverpetskill = {
	{ 686, 687, },	-- ??, ????
	{ 696, 697, },	-- ??, ????
}

local g_specialrecoverskill = 3 -- ???????

-- 近牻门派 少林 明教 丐帮 天山
local g_autoattackskill_melee_mp = {
	0,1,2,7,
}

-- 按钮位置调狖 
local g_autoattackskill_nofightpos = {
	new = "{{0.000000,40.000000},{0.000000,408.000000}}",
	old = "{{0.000000,8.000000},{0.000000,408.000000}}",
	btnnew = "{{1.000000,-150.000000},{1.000000,-40.000000}}",
	btnold = "{{1.000000,-105.000000},{1.000000,-40.000000}}",
}
--===================================固定常量END==========================================================


local g_AutoAttackSkill_sectskill = 
{
	787,
	3294,
	3295,
	3828,
	3829,
}


function AutoAttackSkill_IsSectSkill(id)
	for i,v in pairs(g_AutoAttackSkill_sectskill) do
		if v == id then
			return 1
		end
	end

	return 0
end

function AutoAttackSkill_PreLoad()
	this:RegisterEvent("TRIGGER_ZIDONGZHANDOU")
	this:RegisterEvent("BATTLE_ASSIST_EVENT")
	this:RegisterEvent("TOGLE_LIFE_PAGE")
	this:RegisterEvent("TOGLE_SKILL_BOOK")
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE")
	this:RegisterEvent("SKILL_UPDATE")
	this:RegisterEvent("CHANGE_PETSKILL_BAR")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")

	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function AutoAttackSkill_OnLoad()
	-- 进行UI内容组合
	local _prefix = "AutoAttackSkill_"
	local makeGroup = function(action)
		return _G[_prefix..action]
	end
	local makeSkillGroup = function(check,lockp,lock,ban,unlock,action)
		return {
			["check"] = _G[_prefix..check],
			["lockp"] = _G[_prefix..lockp],
			["lock"] = _G[_prefix..lock],
			["ban"] = _G[_prefix..ban],
			["unlock"] = _G[_prefix..unlock],
			["action"] = _G[_prefix..action],
		}
	end
	local makeXinfaGroup = function(check, action)
		return {
			["check"] = _G[_prefix..check],
			["action"] = _G[_prefix..action],
		}
	end
	local makeoptionsGroup = function(_prefix2,name,combo,btn,btntext,btn1,btntext1,btn2,btntext2)
		return {
			["parent"] = _G[_prefix.._prefix2],
			["name"] = _G[_prefix.._prefix2..name],
			["combo"] = _G[_prefix.._prefix2..combo],
			["btnlist"] = {
				_G[_prefix.._prefix2..btn],
				_G[_prefix.._prefix2..btntext],
				_G[_prefix.._prefix2..btn1],
				_G[_prefix.._prefix2..btntext1],
				_G[_prefix.._prefix2..btn2],
				_G[_prefix.._prefix2..btntext2],
			}
		}
	end
	g_uiskillactions = {
		makeSkillGroup("Zhaoshi1", "Background1", "lock1", "Jin1", "OK1", "Zhaoshi1"),
		makeSkillGroup("Zhaoshi2", "Background2", "lock2", "Jin2", "OK2", "Zhaoshi2"),
		makeSkillGroup("Zhaoshi3", "Background3", "lock3", "Jin3", "OK3", "Zhaoshi3"),
		makeSkillGroup("Zhaoshi4", "Background4", "lock4", "Jin4", "OK4", "Zhaoshi4"),
		makeSkillGroup("Zhaoshi5", "Background5", "lock5", "Jin5", "OK5", "Zhaoshi5"),
	}
	g_uixfskillactions = {
		makeXinfaGroup("Xinfa1", "Xinfa1"),
		makeXinfaGroup("Xinfa2", "Xinfa2"),
		makeXinfaGroup("Xinfa3", "Xinfa3"),
		makeXinfaGroup("Xinfa4", "Xinfa4"),
		makeXinfaGroup("Xinfa5", "Xinfa5"),
		makeXinfaGroup("Xinfa6", "Xinfa6"),
		makeXinfaGroup("Xinfa7", "Xinfa7"),
	}
	g_uiskilloptions = {
		makeoptionsGroup("Explain1","_Blood","_BloodHuiFu",
		"_Blood30","_Blood30Text","_Blood50","_Blood50Text","_Blood70","_Blood70Text") ,
		makeoptionsGroup("Explain2","_Blood","_BloodHuiFu",
		"_Blood30","_Blood30Text","_Blood50","_Blood50Text","_Blood70","_Blood70Text") ,
		makeoptionsGroup("Explain3","_Blood","_BloodHuiFu",
		"_Blood30","_Blood30Text","_Blood50","_Blood50Text","_Blood70","_Blood70Text") ,
		makeoptionsGroup("Explain4","_Happy","_HappyHuiFu",
		"_Happy61","_Happy61Text","_Happy80","_Happy80Text","_Happy90","_Happy90Text") ,
	}
	g_uirrskilloptions = {
		makeoptionsGroup("Skill1","_Blood","_Blood",
		"_Blood30","_Blood30Text","_Blood50","_Blood50Text","_Blood70","_Blood70Text") ,
		makeoptionsGroup("Skill2","_Blood","_Blood",
		"_Blood30","_Blood30Text","_Blood50","_Blood50Text","_Blood70","_Blood70Text") ,
		makeoptionsGroup("Skill3","_Blood","_Blood",
		"_Blood30","_Blood30Text","_Blood50","_Blood50Text","_Blood70","_Blood70Text") ,
	}
	g_uipageactions = {
		makeGroup("CommonlySkill"),
		makeGroup("AutoAttackSkill"),
		makeGroup("LifeSkill"),
		makeGroup("ShenFenSkill"),
		makeGroup("AutoAttack"),
	}
	g_uioptionsactions = {
		makeGroup("Setting1"),
		makeGroup("Setting2"),
		makeGroup("Setting3"),
	}
	g_uicommoninfo = {
		mpicon = makeGroup("MenPai_ICON"),
		atbdesc = makeGroup("MenPai_Attr_Intro"),
		fight = makeGroup("Fight"),
		title = makeGroup("Frame_Title"),
		skill = makeGroup("Skill_Bk"),
		explain = makeGroup("Explain_Bk"),
		noattackhm = makeGroup("NoFightBtn"),
		longfight = makeGroup("LongFightBtn"),
		fightbg = makeGroup("LongFight_Button"),
		nofightbg = makeGroup("NoFight_Button"),
	}
	g_unifiedposistion = AutoAttackSkill_Frame:GetProperty("UnifiedPosition")
end

function AutoAttackSkill_OnEvent(event)
	if event == "TRIGGER_ZIDONGZHANDOU" then
		if DataPool:GetPlayerMission_DataRound(MD_AUTO_LEVELUP_LIMIT) == 0 then
			AutoAttackSkill_AutoLevelUpBtn:SetCheck(0);	
		else
			AutoAttackSkill_AutoLevelUpBtn:SetCheck(1);	
		end	
		AutoAttackSkill_AttackEvent(arg0)
	elseif event == "BATTLE_ASSIST_EVENT"  then
		AutoAttackSkill_UpdateBaseUI()
	elseif event == "SKILL_UPDATE" and this:IsVisible() then
		AutoAttackSkill_UpdateSkillUI()
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if g_data.option == g_optionpagedef.recoverinfo then
			AutoAttackSkill_UpdateOptionUI()
		end
	elseif event == "ADJEST_UI_POS"  then
		AutoAttackSkill_OnResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		AutoAttackSkill_OnResetPos()
	elseif  event == "TOGLE_SKILL_BOOK" or
		event == "TOGLE_LIFE_PAGE" or
		event == "TOGLE_COMMONSKILL_PAGE" or 
		event == "OPEN_SHENFEN_PAGE" or 
		event == "PLAYER_LEAVE_WORLD" then
		AutoAttackSkill_OnClose()
	end
end

--================= local函数 =====================
----------------------------------------------------------------------------------------------------

local function datareset()
	g_data.xfselect = 1
	g_data.curxfid = 1
	g_data.option = 1
end

local function getpetskill()
	return g_recoverpetskill
end

local function getlongrangeskillvalue()
	if g_configdata.useSwitch[2] > 0 then
		return 0
	else
		return 1
	end
end

local function makecfgstr()
	local skillbuffer = ""
	for i=1,17 do
		skillbuffer = skillbuffer..g_configdata.useskill[i]
	end
	local ret = ""
	ret = ret..string.format("useskill=%s;", skillbuffer )
	ret = ret..string.format("usepotiont=%d,%d,%d,%d;", g_configdata.usepotiont[1], g_configdata.usepotiont[2], g_configdata.usepotiont[3], g_configdata.usepotiont[4] )
	ret = ret..string.format("usepotion=%d%d%d%d;", g_configdata.usepotion[1], g_configdata.usepotion[2], g_configdata.usepotion[3], g_configdata.usepotion[4] )
	ret = ret..string.format("usepotionc=%.3f,%.3f,%.3f,%.3f;",g_configdata.usepotionc[1]/100.0,g_configdata.usepotionc[2]/100.0,g_configdata.usepotionc[3]/100.0,g_configdata.usepotionc[4]/100.0)
	ret = ret..string.format("users=%.3f,%.3f,%.3f;",g_configdata.useRecoverSkill[1]/100.0,g_configdata.useRecoverSkill[2]/100.0,g_configdata.useRecoverSkill[3]/100.0)
	ret = ret..string.format("useps=%d,%d;",g_configdata.usePetSkill[1],g_configdata.usePetSkill[2])
	ret = ret..string.format("usepsc=%.3f,%.3f;",g_configdata.usePetSkillc[1],g_configdata.usePetSkillc[2])
	ret = ret..string.format("usepst=%d,%d;",g_configdata.usePetSkillt[1],g_configdata.usePetSkillt[2])
	ret = ret..string.format("EnableAttachHuman=%d;",g_configdata.useSwitch[1])
	ret = ret..string.format("EnableLongRangeSkill=%d;",getlongrangeskillvalue())
	ret = ret..string.format("TickTime=%d;",g_configdata.ticktime)
	return ret
end

local function initconfigdata()
	local us, upt, up, upc, urs, ps, ush = BattleAssist:Farm_GetConfigData()
	if not us then
		g_configdata.valid = 0
		return
	end

	for i=1, g_configdef.useskill do
		g_configdata.useskill[i] = tonumber(us[i])
	end
	for i=1, g_configdef.usepotion do
		g_configdata.usepotiont[i] = tonumber(upt[i])
		g_configdata.usepotion[i] = tonumber(up[i])
		g_configdata.usepotionc[i] = tonumber(upc[i])
	end
	for i=1, g_configdef.userecover do
		g_configdata.useRecoverSkill[i] = tonumber(urs[i])
	end
	for i=1,g_configdef.usepet do
		g_configdata.usePetSkill[i] = tonumber( ps[i] )
		g_configdata.usePetSkillc[i] = tonumber( ps[2+i] )
		g_configdata.usePetSkillt[i] = tonumber( ps[4+i] )
	end
	for i=1,g_configdef.useswitch do
		g_configdata.useSwitch[i] = tonumber( ush[i] )
	end

	g_configdata.valid = 1

	-- 对新的数值进行修狚
	local valuedata = g_configdata.usepotionc[g_rateautodef.happiness]
	if valuedata ~= nil then
		if valuedata >= 60 and valuedata <= 62 then
			-- 对宠物对应的快乐度进行数值修狚
			g_configdata.usepotionc[g_rateautodef.happiness] = g_ratevaluehappiness[1]
		end
	end
end

--================= 对数值进行修狚 =====================
local function getmodifyvalue(data)
	if data >= 0 then
		local cnt = table.getn(g_ratevalue or {})
		for i=1, cnt do
			if g_ratevalue[i] >= data then
				return i, g_ratevalue[i]
			end
		end
	end

	return g_rateautodef.select, g_ratevalue[g_rateautodef.select]
end

local function getmodifyvalue_new(data, subtype)
	if subtype == g_rateautodef.happiness then
		if data >= 0 then
			local cnt = table.getn(g_ratevaluehappiness or {})
			for i=1, cnt do
				if g_ratevaluehappiness[i] >= data then
					return i, g_ratevaluehappiness[i]
				end
			end
		end
	
		return g_rateautodef.select, g_ratevaluehappiness[g_rateautodef.select]
	else
		return getmodifyvalue(data)
	end
end

local function getoptionbasevalue()
	local ret = g_ratevalue[g_rateautodef.select]
	return ret, g_rateautodef.select
end

local function getoptionbasevalue_happiness()
	local ret = g_ratevaluehappiness[g_rateautodef.select]
	return ret, g_rateautodef.select
end

local function getoptiondatabyid(id)
	if g_ratevalue[id] ~= nil then
		return g_ratevalue[id]
	else
		return getoptionbasevalue()
	end
end

local function getoptiondatabyid_new(id, subtype)
	if subtype == g_rateautodef.happiness then
		if g_ratevaluehappiness[id] ~= nil then
			return g_ratevaluehappiness[id]
		else
			return getoptionbasevalue_happiness()
		end
	else
		return getoptiondatabyid(id)
	end
end
--================= 对小btn进行处理 =====================
-- h： 横向id  l：纵向id
local function uibtnoptionupdate(l,h)
	local uill = g_uiskilloptions[h]
	if uill ~= nil then
		local cnt = table.getn(uill.btnlist or {})
		for i=1, cnt do
			-- 先进行ui内容显示
			if math.mod(i,2) == 0 then
				local id = math.floor( i/2 )
				uill.btnlist[i]:SetText(getoptiondatabyid(id))
			else
				uill.btnlist[i]:SetCheck(0)
			end
		end
		if l > 0 and l <= cnt then
			uill.btnlist[l*2 - 1]:SetCheck(1)
		end
	end
end

local function uibtnoptionupdate_new(l,h)
	local uill = g_uiskilloptions[h]
	if uill ~= nil then
		local cnt = table.getn(uill.btnlist or {})
		for i=1, cnt do
			-- 先进行ui内容显示
			if math.mod(i,2) == 0 then
				local id = math.floor( i/2 )
				uill.btnlist[i]:SetText(getoptiondatabyid_new(id, h))
			else
				uill.btnlist[i]:SetCheck(0)
			end
		end
		if l > 0 and l <= cnt then
			uill.btnlist[l*2 - 1]:SetCheck(1)
		end
	end
end

-- h： 横向id  l：纵向id 回复页签用
local function uibtnrroptionupdate(l,h)
	local uill = g_uirrskilloptions[h]
	if uill ~= nil then
		local cnt = table.getn(uill.btnlist or {})
		for i=1, cnt do
			-- 先进行ui内容显示
			if math.mod(i,2) == 0 then
				local id = math.floor( i/2 )
				uill.btnlist[i]:SetText(getoptiondatabyid(id))
			else
				uill.btnlist[i]:SetCheck(0)
			end
		end
		if l > 0 and l <= cnt then
			uill.btnlist[l*2 - 1]:SetCheck(1)
		end
	end
end


-- 根据索引，犚到对应心法技能对用skill配置的位置
local function getskillbyxf(xfid,idx)
	local skillaction = g_uiskillactions[idx]
	if skillaction ~= nil then
		local sumskill,index,skillid = GetActionNum("skill"), 1, -1
		for i=1, sumskill do
			local skillaction = EnumAction(i-1, "skill")
			if skillaction:GetID() ~= -1 and skillaction:GetOwnerXinfa() == xfid then
				if idx == index then
					skillid = LifeAbility : GetLifeAbility_Number(skillaction:GetID())
					-- 可使用的技能ID提取出来
					local skilldata,unlocklist = BattleAssist:Farm_GetSkillIds(),{}
					for i, v in ipairs(skilldata) do
						local id = v[1]
						if skillid == id then
							return i, skillid
						end
					end
				end
				index = index+1
			end
		end
	end
	return -1,-1
end

--================= 是否可以使用的技能 =====================
local function isusefulskill(skillid)
	local islearn,isrequire = Player:GetSkillInfo(skillid,"learn"),Player:GetSkillInfo(skillid,"isequirement")
	if islearn and isrequire then
		return 1
	end

	return 0
end


--================ 是否达到道具使用限制 =====================
local function iscanuseitem(itemid)
	local cnt = PlayerPackage:CountAvailableItemByIDTable( itemid )
	if cnt > 0 then
		-- 是否可以使用
		local needlv = PlayerPackage : GetItemNeedLvByIndex(itemid)
		local myLevel = Player:GetData("LEVEL")
		if needlv ~= nil and needlv <= myLevel then
			return 1
		else
			PushDebugMessage("#{ZDZD_200724_16}")
			return 0
		end
	else
		PushDebugMessage("#{ZDZD_200724_15}")
		return 0
	end
end

--================= 是否是必须使用的技能 =====================
local function isnobanskill(skillid)
	for i, v in ipairs(g_nobanskill) do
		if v == skillid then
			return 1
		end
	end
	return 0
end

--================= 是否可以攻击玩家 =====================
local function isbanattackplayer()
	if g_configdata.useSwitch[1] > 0 then
		return 0
	end

	return 1
end

--================= 是否可以攻击玩家 =====================
local function autoattackskill_ismeleemp()
	local mpid = Player : GetData("MEMPAI")
	for i, v in ipairs(g_autoattackskill_melee_mp) do
		if v == mpid then
			return 1
		end
	end

	return 0
end

--================= local函数 End=====================
--------------------------------------------------------------------------------------

--================= 初始化页面数据 =====================
function AutoAttackSkill_InitData()
	datareset()
	initconfigdata()

end
--================= 显示UI内容 =====================
function AutoAttackSkill__OnShowUI()
	AutoAttackSkill_UpdateBaseUI()
	AutoAttackSkill_UpdateSkillUI()
	AutoAttackSkill_UpdateOptionUI()
	
	-- 默认选中第一个心法
	AutoAttackSkill_XinFa_Clicked(1)
	this:Show()
end

--================= 显示一些基础内容 =====================
function AutoAttackSkill_UpdateBaseUI()
	-- 处理自动牻斗按钮
	local isworking = BattleAssist:IsWorking()
	if isworking then
		g_uicommoninfo.fight:SetText("#{ZDZD_200724_28}")
	else
		g_uicommoninfo.fight:SetText("#{ZDZD_200724_27}")
	end
	-- 设置页签按钮选中状态
	local pagecnt = table.getn(g_uipageactions)
	for i=1, pagecnt do
		g_uipageactions[i]:SetCheck(0)
	end
	if g_curpage <= pagecnt then
		g_uipageactions[g_curpage]:SetCheck(1)
	end

	-- 设置页签名字
	g_uicommoninfo.title:SetText("#{ZDZD_200724_09}")

	-- 设置是否攻击玩家
	local isbanattack = isbanattackplayer()
	g_uicommoninfo.noattackhm:SetCheck(isbanattack)

	-- 设置是否使用远程攻击
	local check = 1
	if g_configdata.useSwitch[2] > 0 then
		check = 0
	end
	g_uicommoninfo.longfight:SetCheck(check)
	
	local meleeshow = autoattackskill_ismeleemp()
	if meleeshow > 0 then
		g_uicommoninfo.fightbg:Show()
		g_uicommoninfo.nofightbg:SetProperty("UnifiedPosition", g_autoattackskill_nofightpos.old)
		g_uicommoninfo.fight:SetProperty("UnifiedPosition", g_autoattackskill_nofightpos.btnold)
	else
		g_uicommoninfo.fightbg:Hide()
		g_uicommoninfo.nofightbg:SetProperty("UnifiedPosition", g_autoattackskill_nofightpos.new)
		g_uicommoninfo.fight:SetProperty("UnifiedPosition", g_autoattackskill_nofightpos.btnnew)
	end

	-- 设置位置
	if not this:IsVisible() then
		local pos = Variable:GetVariable("SkillUnionPos")
		if pos ~= nil then
			AutoAttackSkill_Frame:SetProperty("UnifiedPosition", pos)
		end
	end
end

--================= 对技能UI进行内容更新 =====================
function AutoAttackSkill_UpdateSkillUI()
	local mpid = Player:GetData("MEMPAI")

	local xfcnt,skillcnt = table.getn(g_uixfskillactions), table.getn(g_uiskillactions)
	-- 无门派
	if mpid == g_invalidmenpai then
		for i=1, xfcnt do
			g_uixfskillactions[i].action:SetActionItem(-1)
		end
		for i=1, skillcnt do
			g_uiskillactions[i].action:SetActionItem(-1)
			g_uiskillactions[i].lockp:Hide()
		end

		g_uicommoninfo.atbdesc:Hide()
		g_uicommoninfo.mpicon:Hide()
	else
		-- 处理属性提示
		g_uicommoninfo.mpicon:SetToolTip(g_menpaiattr[mpid].tooltip)
		g_uicommoninfo.mpicon:SetProperty("Image",g_menpaiattr[mpid].image)
		local str = GetDictionaryString( "MPZSX_20071221_0" .. (mpid +1) )
		g_uicommoninfo.atbdesc:SetText("#Y" .. str)
		g_uicommoninfo.atbdesc:Show()
		g_uicommoninfo.mpicon:Show()
		for i=1, xfcnt do
			local action = EnumAction(i-1, "xinfa")
			if action:GetID() ~= 0 then
				g_uixfskillactions[i].action:SetActionItem(action:GetID())
			end
		end
		
		AutoAttackSkill_UpdateSkillUIByXF()
	end

end
--================= 根据心法对应得具体技能UI进行内容更新 =====================
-- notice : g_data.curxfid 需要进行提前进行计算赋值
function AutoAttackSkill_UpdateSkillUIByXF()

	-- 可使用的技能ID提取出来
	local skilldata,unlocklist = BattleAssist:Farm_GetSkillIds(),{}
	for i, v in ipairs(skilldata) do
		local id = v[1]
		unlocklist[id] = i
	end

	-- 处理当前技能action
	local skillcnt = table.getn(g_uiskillactions)
	for i=1, skillcnt do
		g_uiskillactions[i].action:SetActionItem(-1)
		g_uiskillactions[i].lockp:Hide()
	end

	-- 10TL逻辑，牋搬
	local sumskill,idx,ownlist = GetActionNum("skill"), 1, {}
	for i=1, sumskill do
		local skillaction = EnumAction(i-1, "skill")
		if skillaction:GetOwnerXinfa() == g_data.curxfid and AutoAttackSkill_IsSectSkill(skillaction:GetDefineID()) == 0 then
			local actionid = skillaction:GetID()
			g_uiskillactions[idx].action:SetActionItem(actionid)
			ownlist[idx] = LifeAbility : GetLifeAbility_Number(actionid)
			idx = idx+1
		end
	end

	-- 处理图标状态
	for i=1, skillcnt do
		-- 该技能是存在的
		local id = ownlist[i]
		if id ~= nil then
			-- 判断技能是否禁用该技能, 茽功技能也会被禁用
			if unlocklist[id] == nil then
				g_uiskillactions[i].lock:Hide()
				g_uiskillactions[i].ban:Show()
				g_uiskillactions[i].unlock:Hide()
			else
				-- 开始读取配置
				local isuseful = isusefulskill(id)
				if isuseful > 0 then
					g_uiskillactions[i].lock:Hide()
					g_uiskillactions[i].ban:Hide()
					g_uiskillactions[i].unlock:Show()
					local isusing = g_configdata.useskill[unlocklist[id]]
					g_uiskillactions[i].unlock:SetCheck(isusing)
				else
					g_uiskillactions[i].lock:Show()
					g_uiskillactions[i].ban:Hide()
					g_uiskillactions[i].unlock:Hide()
				end
			end
			-- 显示状态
			g_uiskillactions[i].lockp:Show()
		else
			-- 隐藏所有状态UI
			g_uiskillactions[i].lockp:Hide()
		end
	end

end

--================= 刷新选项UI内容 =====================
function AutoAttackSkill_UpdateOptionBaseUI()
	-- 先进行选项按钮更新
	local mpid,cnt,btnnum,list = Player:GetData("MEMPAI"),table.getn(g_uioptionsactions),2,{}
	if mpid == g_menpai_emei then
		btnnum = g_optionbtnattr.special.num
		list = g_optionbtnattr.special.text
	else
		btnnum = g_optionbtnattr.normal.num
		list = g_optionbtnattr.normal.text
	end

	for i=1, cnt do
		if i <= btnnum then
			g_uioptionsactions[i]:SetText(list[i])
			g_uioptionsactions[i]:Show()
		else
			g_uioptionsactions[i]:Hide()
		end
	end

	if g_data.option == g_optionpagedef.recoverskill then
		g_uicommoninfo.skill:Show()
		g_uicommoninfo.explain:Hide()
	else
		g_uicommoninfo.skill:Hide()
		g_uicommoninfo.explain:Show()

		local optionscnt = table.getn(g_uiskilloptions or {})
		for i=1, optionscnt do
			g_uiskilloptions[i].parent:Hide()
		end
	end
end

function AutoAttackSkill_UpdateOptionUI()

	AutoAttackSkill_UpdateOptionBaseUI()
	-- 处理药品界面信息
	if g_data.option == g_optionpagedef.recoverinfo then
		local cnt = table.getn(g_recoverInfo)
		if cnt > 0 then
			for i=1,cnt do
				g_recoverInfo[i]:update()
			end
		else
			g_recoverInfo = {}
			for i=1,4 do
				AutoAttackSkill_MakeRecoverInfo(i)
			end
		end
	elseif g_data.option == g_optionpagedef.recoverskill then
		local cnt = table.getn(g_recoverSkills)
		if cnt > 0 then
			for i=1,cnt do
				g_recoverSkills[i]:update()
			end
		else
			local recoverSkills = {}
			for i, v in ipairs(BattleAssist:Farm_GetSkillIds()) do
				if v[2] == 5 then
					table.insert( recoverSkills, { v, i } )
				end
			end
			g_recoverSkills = {}
			-- 犫里最多就3个，超出来会有显示问题
			for i,v in ipairs(recoverSkills) do
				AutoAttackSkill_MakeRecoverSkillInfo( i, v[1], v[2] )
			end
		end
	elseif g_data.option == g_optionpagedef.petskill then
		local cnt,petskills = table.getn(g_petSkills),getpetskill()
		if cnt > 0 then
			for i=1,cnt do
				g_petSkills[i]:update(petskills[i])
			end
		else
			g_petSkills = {}
			for i,v in ipairs(petskills) do
				AutoAttackSkill_MakePetSkill(i,v)
			end
		end
	end

end

function AutoAttackSkill_DispatchCall( fn, ... )
	if not fn then
		return
	end
	fn( unpack(arg) )
end

function AutoAttackSkill_CallCb( i, key, ... )
	local inst = g_recoverInfo[i]
	if inst then
		AutoAttackSkill_DispatchCall( inst[key], inst, unpack(arg) )
	end
end

function AutoAttackSkill_CallCb2( i, key, ... )
	local inst = g_recoverSkills[i]
	if inst then
		AutoAttackSkill_DispatchCall( inst[key], inst, unpack(arg) )
	end
end

function AutoAttackSkill_CallCb3( i, key, ... )
	local inst = g_petSkills[i]
	if inst then
		AutoAttackSkill_DispatchCall( inst[key], inst, unpack(arg) )
	end
end

--================= 处理自动牻斗的各个时间 =====================
function AutoAttackSkill_AttackEvent(event)
	--PushDebugMessage("AutoAttackSkill_AttackEvent 我要打开了"..event)
	if event == "config_update" then
		--AutoAttackSkill_InitData()
		initconfigdata()
		BattleAssist:Farm_UpdateConfig(makecfgstr())
	elseif event == "config" then
		AutoAttackSkill_InitData()
		BattleAssist:Farm_UpdateConfig(makecfgstr())
		if g_configdata.valid == 0 then
			return
		end
		AutoAttackSkill__OnShowUI()
	elseif event == "start" then
		--AutoAttackSkill_InitData()
		-- 保持原有状态
		initconfigdata()
		if g_configdata.valid == 0 then
			return
		else
			BattleAssist:Start("Farm",makecfgstr())
		end
	elseif event == "stop" then
		BattleAssist:Stop()
	end
end

--================= 药品设置 =====================
function AutoAttackSkill_MakeRecoverInfo( i )
	local texts = { "#{ZDZD_200724_13}", "#{ZDZD_200724_21}", "#{ZDZD_200724_22}", "#{ZDZD_230815_1}" }
	local potions = BattleAssist:Farm_GetPotionIds(i)
	local delegate = {
		["updatecombo"] = function( self, select )
			g_uiskilloptions[i].combo:ResetList()
			-- 会默认添加一个不使用的选项
			g_uiskilloptions[i].combo:AddTextItem("#{ZDZD_200724_52}",0)
			
			local potionscnt = table.getn(potions or {})
			for j=1, potionscnt do
				local data = potions[j]
				local desc,cnt = PlayerPackage:GetItemName(data[1]),PlayerPackage:CountAvailableItemByIDTable( data[1] )
				if cnt > 0 then
					-- 拥有数量大于0，需要变换文字显示
					desc = ScriptGlobal_Format("#{ZDZD_200724_14}",desc,tostring(cnt))
				end
				g_uiskilloptions[i].combo:AddTextItem(desc,j)
			end
			-- 当前有默认选中

			g_uiskilloptions[i].combo:SetCurrentSelect(select)
			g_uiskilloptions[i].parent:Show()
		end,
		["updatetext"] = function( self )
			local btnidx,rate = getmodifyvalue_new(g_configdata.usepotionc[i], i)
			g_uiskilloptions[i].name:SetText(ScriptGlobal_Format(texts[i], rate))
		end,
		["update"] = function( self )
			-- 获取当前我使用的道具
			local cur,potionscnt = 0, table.getn(potions or {})
			-- 处理UI
			g_uiskilloptions[i].combo:ResetList()
			if g_configdata.usepotion[i] == 0 then
				cur = 0 
			else
				--if p ~= nil then
					cur = g_configdata.usepotiont[i]
				--end
			end
			self:updatecombo(cur)
			-- 开始处理按钮选中
			local btnidx,rate = getmodifyvalue_new(g_configdata.usepotionc[i], i)
			g_uiskilloptions[i].name:SetText(ScriptGlobal_Format(texts[i], rate))
			-- 进行按钮内容选中
			uibtnoptionupdate_new(btnidx,i)
		end,
		["onPosChange"] = function( self, select )
			-- 获得当前选中的大小
			g_configdata.usepotionc[i] = getoptiondatabyid_new(select, i)
			-- 刷新选中按钮
			uibtnoptionupdate_new(select,i)
			-- 存储配置
			BattleAssist:Farm_UpdateConfig(makecfgstr())
			BattleAssist:Farm_SetConfigData( g_configdata )
			AutoAttackSkill_CallCb( i, "updatetext" )
		end,
		["onSetPotionOk"] = function( self, typei )
			if g_configdata.usepotion[i] == 0 then
				if typei == 0 then
					return
				end
			elseif g_configdata.usepotiont[i] == typei then
				return
			end
			--PushDebugMessage("potionok="..typei.." i="..i)
			if typei == 0 then
				g_configdata.usepotion[i] = 0 
			else
				local data,select = potions[typei],0
				if iscanuseitem(data[1]) <= 0 then
					if g_configdata.usepotion[i] ~= 0 then
						select = g_configdata.usepotiont[i]
					end
					g_uiskilloptions[i].combo:SetCurrentSelect(select)
					return
				end
				g_configdata.usepotion[i] = 1
				g_configdata.usepotiont[i] = typei
			end
			--g_configdata.usepotionc[i] = getoptionbasevalue()

			BattleAssist:Farm_UpdateConfig(makecfgstr())
			BattleAssist:Farm_SetConfigData( g_configdata )
			-- 刷新选中按钮
			AutoAttackSkill_CallCb( i, "updatetext" )
		end,
	}
	g_recoverInfo[i] = delegate
	delegate:update()
end


function AutoAttackSkill_MakeRecoverSkillInfo( i, skillinfo, skillIdx )
	local texts = { "#{ZDZD_200724_47}","#{ZDZD_200724_48}","#{ZDZD_200724_50}",  }
	local delegate = {
		["update"] = function( self )
			-- 处理UI
			local max = table.getn(g_uiskilloptions)
			if i > max then
				PushDebugMessage("g_uiskilloptions: Table is error")
				return
			end

			-- 获得我当前的技能ID
			local id = skillinfo[1]
			local btnidx,rate = getmodifyvalue(g_configdata.useRecoverSkill[i])
			local text = ScriptGlobal_Format(texts[i], rate)
			if i == g_specialrecoverskill then
				local islearn = Player:GetSkillInfo(id,"learn")
				if not islearn then
					text = ScriptGlobal_Format("#{ZDZD_200724_49}", rate)
				end
			end
			g_uirrskilloptions[i].name:SetText(text)
			-- 进行按钮内容选中
			uibtnrroptionupdate(btnidx,i)

			--local isusing = g_configdata.useskill[skillIdx]
		end,
		["onPosChange"] = function( self, select )
			-- 默认选中50
			g_configdata.useRecoverSkill[i] = getoptiondatabyid(select)
			-- 刷新选中按钮
			AutoAttackSkill_CallCb2( i, "update" )
			BattleAssist:Farm_UpdateConfig(makecfgstr())
			BattleAssist:Farm_SetConfigData( g_configdata )
		end,
	}	
	g_recoverSkills[i] = delegate
	delegate:update()
end

function AutoAttackSkill_MakePetSkill( i, info )
	local delegate = {
		["info"] = { -1, -1, -1, -1 },
		["updateText"] = function(self)
			local text = ""
			if i == 1 then
				text = ScriptGlobal_Format( "#{ZDZD_200724_13}", ""..g_configdata.usePetSkillc[i]  )
			elseif i == 2 then
				text = ScriptGlobal_Format( "#{ZDZD_200724_21}", ""..g_configdata.usePetSkillc[i]  )
			end
			g_uiskilloptions[i].name:SetText(text)

			local btnidx,rate = getmodifyvalue(g_configdata.usePetSkillc[i])
			uibtnoptionupdate(btnidx,i)
		end,
		["update"] = function( self, newinfo )
			self.info = newinfo
			
			g_uiskilloptions[i].combo:ResetList()
			-- 会默认添加一个不使用的选项
			g_uiskilloptions[i].combo:AddTextItem("#{ZDZD_200724_52}",0)
			local cnt,cur = table.getn(self.info),0
			for j=1, cnt do
				local name = Player:GetSkillInfo(self.info[j],"name")
				g_uiskilloptions[i].combo:AddTextItem(name,j)
				--if g_configdata.usePetSkillt[i] == self.info[j] then
				--end
			end
			cur = g_configdata.usePetSkillt[i] + 1
			if g_configdata.usePetSkill[i] == 0 then
				cur = 0 
			end

			g_uiskilloptions[i].combo:SetCurrentSelect(cur)
			g_uiskilloptions[i].parent:Show()
			self:updateText()
		end,
		["onPosChange"] = function( self ,select )
			g_configdata.usePetSkillc[i] = getoptiondatabyid(select)
			BattleAssist:Farm_UpdateConfig(makecfgstr())
			BattleAssist:Farm_SetConfigData( g_configdata )
			self:updateText()
		end,
		["onSetPotionOk"] = function( self, typei )
			if g_configdata.usePetSkill[i] == 0 then
				if typei == 0 then
					return
				end
			elseif g_configdata.usePetSkillt[i] + 1 == typei then
				return
			end

			local realtypei = typei - 1
			if typei == 0 then
				g_configdata.usePetSkill[i] = 0
			else
				g_configdata.usePetSkill[i] = 1
				g_configdata.usePetSkillt[i] = realtypei
			end
			--g_configdata.usePetSkillc[i] = getoptionbasevalue()
			BattleAssist:Farm_UpdateConfig(makecfgstr())
			BattleAssist:Farm_SetConfigData( g_configdata )

			AutoAttackSkill_CallCb3( i, "updateText" )
		end,
	}
	g_petSkills[i] = delegate
	delegate:update(info)
end

---------------------------------------点击事件-----------------------------------------------------
function AutoAttackSkill_XinFa_Clicked(idx)
	local mpid = Player:GetData("MEMPAI")
	local xfcnt = table.getn(g_uixfskillactions)
	-- 点没点都会进行状态还原
	for i=1, xfcnt do
		g_uixfskillactions[i].check:SetPushed(0)
	end

	-- 无门派
	if mpid == g_invalidmenpai then
		return
	else
		if idx > 0 and idx <= xfcnt then
			local action = EnumAction(idx-1, "xinfa")
			g_data.curxfid = action:GetID()
			AutoAttackSkill_UpdateSkillUIByXF()
			
			g_uixfskillactions[idx].check:SetPushed(1)
			
			-- 等于默认点击了第一个技能栏，看了下，原版门派技能栏没有进行默认选中
			--AutoAttackSkill_Skill_Clicked(1)
		end
	end
end

function AutoAttackSkill_Skill_Clicked(idx)
	local xfcnt = table.getn(g_uiskillactions)
	-- 点没点都会进行状态还原
	for i=1, xfcnt do
		g_uiskillactions[i].action:SetPushed(0)
	end
	if idx > 0 and idx <= xfcnt then
		g_uiskillactions[idx].action:SetPushed(1)
	end
end

function AutoAttackSkill_SkillLock_Clicked(idx)
	local mpid = Player:GetData("MEMPAI")
	-- 无门派
	if mpid == g_invalidmenpai then
		return
	else
		local n,skillid = getskillbyxf(g_data.curxfid,idx)
		if n < 0 then
			return
		end
		-- 茽攻技能,禁止点击取消
		if isnobanskill(skillid) > 0 then
			PushDebugMessage("#{ZDZD_200724_53}")
			g_uiskillactions[idx].unlock:SetCheck(1)
			return
		end
		-- 判断技能是否学会 ，现阶段默认使用的技能也可以设置，只不过显示解锁而已
		-- 切换状态
		if g_configdata.useskill[n] == 1 then
			g_configdata.useskill[n] = 0
		else
			g_configdata.useskill[n] = 1
		end

		BattleAssist:Farm_UpdateConfig(makecfgstr())
		BattleAssist:Farm_SetConfigData( g_configdata )

		AutoAttackSkill_UpdateSkillUIByXF()
	end
end

function AutoAttackSkill_Option_Click(idx)

	-- 需要根据门派进行内容特殊处理, 峨眉没有第二选项
	local mpid = Player:GetData("MEMPAI")
	if mpid == g_menpai_emei then
		-- 峨眉比较特殊有三个选项,不做处理
	else
		-- 茽通情况，只有两个选项, 2个选项会默认进行递增选择
		if idx == g_optionbtnattr.normal.num then
			idx = g_optionbtnattr.special.num
		end
	end

	g_data.option = idx

	AutoAttackSkill_UpdateOptionUI()
end

--================= 百分比情况 =====================
-- i: 纵向索引 idx：横向索引
function AutoAttackSkill_OptionPercent_Click(i, idx)
	if g_data.option == g_optionpagedef.recoverinfo then
		AutoAttackSkill_CallCb( i, "onPosChange", idx )
	elseif g_data.option == g_optionpagedef.petskill then
		AutoAttackSkill_CallCb3( i, "onPosChange", idx  )
	end
end

--================= 回复技能点击情况 =====================
function AutoAttackSkill_RecoverOptionPercent_Click(i, idx)
	if g_data.option == g_optionpagedef.recoverskill then
		AutoAttackSkill_CallCb2( i, "onPosChange", idx  )
	end
end

--================= 下拉条变化 =====================
function AutoAttackSkill_ComboListSelectChanged(i)
	-- 进行初始条件判断
	if g_uiskilloptions[i] == nil then
		return
	end
	local szname, idx = g_uiskilloptions[i].combo:GetCurrentSelect()
	if idx == nil or idx == -1  then
		return
	end

	if g_data.option == g_optionpagedef.recoverinfo then
		AutoAttackSkill_CallCb( i, "onSetPotionOk", idx )
	elseif g_data.option == g_optionpagedef.petskill then
		AutoAttackSkill_CallCb3( i, "onSetPotionOk", idx  )
	end
end
--================= 开始工作 =====================
function AutoAttackSkill_OnStartClick()
	local isworking = BattleAssist:IsWorking()
	if isworking then
		PushEvent("TRIGGER_ZIDONGZHANDOU","stop")
	else
		PushEvent("TRIGGER_ZIDONGZHANDOU","start")
	end	

	-- 始譅一个状态
	g_uicommoninfo.fight:SetCheck(0)
end

--================= 是否可以攻击玩家 =====================
function AutoAttackSkill_OnAttackHumanClick()
	-- 设置是否攻击玩家
	if g_configdata.useSwitch[1] > 0 then
		g_configdata.useSwitch[1] = 0
	else
		g_configdata.useSwitch[1] = 1
	end
	
	-- 配置存储
	BattleAssist:Farm_UpdateConfig(makecfgstr())
	BattleAssist:Farm_SetConfigData( g_configdata )

	local isattackplayer = isbanattackplayer()
	g_uicommoninfo.noattackhm:SetCheck(isattackplayer)
end

--================= 是否可以攻击玩家 =====================
function AutoAttackSkill_OnUseLongRangeSkillClick()
	-- 设置是否攻击玩家
	if g_configdata.useSwitch[2] > 0 then
		g_configdata.useSwitch[2] = 0
	else
		g_configdata.useSwitch[2] = 1
	end
	
	-- 配置存储
	BattleAssist:Farm_UpdateConfig(makecfgstr())
	BattleAssist:Farm_SetConfigData( g_configdata )

	local check = 1 
	if g_configdata.useSwitch[2] > 0 then
		check = 0
	end

	g_uicommoninfo.longfight:SetCheck(check)
end

--================= 切换页签 =====================
function AutoAttackSkill_Page_Switch(page)
	if page >= g_curpage or page < 0 then
		return
	end

	-- 关睜
	AutoAttackSkill_OnClose()
	-- 打开各个界面
	if page == 1 then
		OpenCommonSkillPage()
	elseif page == 2 then
		local menpai = Player:GetData("MEMPAI")
		if menpai == g_invalidmenpai then 
			PushDebugMessage("#{ZDZD_200724_45}")
			return
		end
		OpenSkillBook()
	elseif page == 3 then
		OpenLifePage()
	elseif page == 4 then
		local myLevel = Player:GetData("LEVEL")
		if myLevel < 50 then
			PushDebugMessage("#{YCGZ_231225_01}")
			return
		end		
		-- 是否有身份 YCGZ_231225_02
		if Player:GetData("IBIDENTITYID") <= 0 then
			PushDebugMessage("#{YCGZ_231225_02}")
			return
		end		
		OpenShenFenPage()
	end
end

function AutoAttackSkill_OnClose()
	-- 关睜界面的时候需要保存相对位置
	local unifiedpos = AutoAttackSkill_Frame:GetProperty("UnifiedPosition")
	Variable:SetVariable("SkillUnionPos", unifiedpos, 1)

	this:Hide()
end

--====================恢复界面的默认相对位置=========================
function AutoAttackSkill_OnResetPos()
	AutoAttackSkill_Frame:SetProperty("UnifiedPosition",g_unifiedposistion)
end

--自动升级按钮
function AutoAttackSkill_AutoLevelUpBtn_Click()
    local newState =  tonumber(AutoAttackSkill_AutoLevelUpBtn:GetCheck())
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AutoLevelUpLimit");
		Set_XSCRIPT_ScriptID(891330);
		Set_XSCRIPT_Parameter(0, newState);  -- ????
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();
end
