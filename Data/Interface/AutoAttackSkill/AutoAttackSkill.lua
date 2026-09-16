-- ×Ô¶¯ ½¶·ÉèÖÃ
-- Ñ©ÎèÌí¼Ó×Ô¶¯Éý¼¶¹¦ÄÜ
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
-- ÐÄ·¨
local g_uixfskillactions = {}
-- ×Ó¼¼ÄÜ×éºÏ
local g_uiskillactions = {}
-- Ñ¡Ïî×éºÏ
local g_uiskilloptions = {}
-- »Ø¸´½ÚÄÜÌØÊâÒ³Ç©×éºÏ
local g_uirrskilloptions = {}
-- ÇÐ»»Ò³Ç©°´Å¥
local g_uipageactions = {}
-- ×ÓÑ¡Ïî×éºÏ
local g_uioptionsactions = {}
-- ÆäËûui
local g_uicommoninfo = {}

-- »Øµ÷ÄÚÈÝ¼¯ºÏ
local g_recoverInfo = {}
local g_recoverSkills = {}
local g_petSkills = {}

--==================================ÏÂÃæÎª¹Ì¶¨³£Á¿===============================================
-- µ±Ç°Ò³Ç©ºÅ
local g_curpage = 5
-- ÎÞÃÅÅÉ
local g_invalidmenpai = 9
-- ¶ëÃ¼ID
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
-- ±»½ûÖ¹È¡ÏûµÄÆ Í¨¹¥»÷¼¼ÄÜ,Ã¿¸öÃÅÅÉÒ»¸ö£¬ÌØÐ´°É£¬±íÀïËäÈ»°´Ë³ÐòÐ´µÄ£¬µ«ÊÇÒ»µ©¸Ä±äË³Ðò¾ÍGGÁË¡£
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
-- ³èÎï¼¼ÄÜÅäÖÃ¡£ ÂÌÉ«Å²¹ýÀ´µÄÃ²ËÆ²»ÄÜÍ¨ÓÃ£¬Ð´ËÀ°É
local g_recoverpetskill = {
	{ 686, 687, },	-- ??, ????
	{ 696, 697, },	-- ??, ????
}

local g_specialrecoverskill = 3 -- ???????

-- ½ü ½ÃÅÅÉ ÉÙÁÖ Ã÷½Ì Ø¤°ï ÌìÉ½
local g_autoattackskill_melee_mp = {
	0,1,2,7,
}

-- °´Å¥Î»ÖÃµ÷ û 
local g_autoattackskill_nofightpos = {
	new = "{{0.000000,40.000000},{0.000000,408.000000}}",
	old = "{{0.000000,8.000000},{0.000000,408.000000}}",
	btnnew = "{{1.000000,-150.000000},{1.000000,-40.000000}}",
	btnold = "{{1.000000,-105.000000},{1.000000,-40.000000}}",
}
--===================================¹Ì¶¨³£Á¿END==========================================================


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
	-- ½øÐÐUIÄÚÈÝ×éºÏ
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

--================= localº¯Êý =====================
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

	-- ¶ÔÐÂµÄÊýÖµ½øÐÐÐÞ ý
	local valuedata = g_configdata.usepotionc[g_rateautodef.happiness]
	if valuedata ~= nil then
		if valuedata >= 60 and valuedata <= 62 then
			-- ¶Ô³èÎï¶ÔÓ¦µÄ¿ìÀÖ¶È½øÐÐÊýÖµÐÞ ý
			g_configdata.usepotionc[g_rateautodef.happiness] = g_ratevaluehappiness[1]
		end
	end
end

--================= ¶ÔÊýÖµ½øÐÐÐÞ ý =====================
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
--================= ¶ÔÐ¡btn½øÐÐ´¦Àí =====================
-- h£º ºáÏòid  l£º×ÝÏòid
local function uibtnoptionupdate(l,h)
	local uill = g_uiskilloptions[h]
	if uill ~= nil then
		local cnt = table.getn(uill.btnlist or {})
		for i=1, cnt do
			-- ÏÈ½øÐÐuiÄÚÈÝÏÔÊ¾
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
			-- ÏÈ½øÐÐuiÄÚÈÝÏÔÊ¾
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

-- h£º ºáÏòid  l£º×ÝÏòid »Ø¸´Ò³Ç©ÓÃ
local function uibtnrroptionupdate(l,h)
	local uill = g_uirrskilloptions[h]
	if uill ~= nil then
		local cnt = table.getn(uill.btnlist or {})
		for i=1, cnt do
			-- ÏÈ½øÐÐuiÄÚÈÝÏÔÊ¾
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


-- ¸ù¾ÝË÷Òý£¬ Òµ½¶ÔÓ¦ÐÄ·¨¼¼ÄÜ¶ÔÓÃskillÅäÖÃµÄÎ»ÖÃ
local function getskillbyxf(xfid,idx)
	local skillaction = g_uiskillactions[idx]
	if skillaction ~= nil then
		local sumskill,index,skillid = GetActionNum("skill"), 1, -1
		for i=1, sumskill do
			local skillaction = EnumAction(i-1, "skill")
			if skillaction:GetID() ~= -1 and skillaction:GetOwnerXinfa() == xfid then
				if idx == index then
					skillid = LifeAbility : GetLifeAbility_Number(skillaction:GetID())
					-- ¿ÉÊ¹ÓÃµÄ¼¼ÄÜIDÌáÈ¡³öÀ´
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

--================= ÊÇ·ñ¿ÉÒÔÊ¹ÓÃµÄ¼¼ÄÜ =====================
local function isusefulskill(skillid)
	local islearn,isrequire = Player:GetSkillInfo(skillid,"learn"),Player:GetSkillInfo(skillid,"isequirement")
	if islearn and isrequire then
		return 1
	end

	return 0
end


--================ ÊÇ·ñ´ïµ½µÀ¾ßÊ¹ÓÃÏÞÖÆ =====================
local function iscanuseitem(itemid)
	local cnt = PlayerPackage:CountAvailableItemByIDTable( itemid )
	if cnt > 0 then
		-- ÊÇ·ñ¿ÉÒÔÊ¹ÓÃ
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

--================= ÊÇ·ñÊÇ±ØÐëÊ¹ÓÃµÄ¼¼ÄÜ =====================
local function isnobanskill(skillid)
	for i, v in ipairs(g_nobanskill) do
		if v == skillid then
			return 1
		end
	end
	return 0
end

--================= ÊÇ·ñ¿ÉÒÔ¹¥»÷Íæ¼Ò =====================
local function isbanattackplayer()
	if g_configdata.useSwitch[1] > 0 then
		return 0
	end

	return 1
end

--================= ÊÇ·ñ¿ÉÒÔ¹¥»÷Íæ¼Ò =====================
local function autoattackskill_ismeleemp()
	local mpid = Player : GetData("MEMPAI")
	for i, v in ipairs(g_autoattackskill_melee_mp) do
		if v == mpid then
			return 1
		end
	end

	return 0
end

--================= localº¯Êý End=====================
--------------------------------------------------------------------------------------

--================= ³õÊ¼»¯Ò³ÃæÊý¾Ý =====================
function AutoAttackSkill_InitData()
	datareset()
	initconfigdata()

end
--================= ÏÔÊ¾UIÄÚÈÝ =====================
function AutoAttackSkill__OnShowUI()
	AutoAttackSkill_UpdateBaseUI()
	AutoAttackSkill_UpdateSkillUI()
	AutoAttackSkill_UpdateOptionUI()
	
	-- Ä¬ÈÏÑ¡ÖÐµÚÒ»¸öÐÄ·¨
	AutoAttackSkill_XinFa_Clicked(1)
	this:Show()
end

--================= ÏÔÊ¾Ò»Ð©»ù´¡ÄÚÈÝ =====================
function AutoAttackSkill_UpdateBaseUI()
	-- ´¦Àí×Ô¶¯ ½¶·°´Å¥
	local isworking = BattleAssist:IsWorking()
	if isworking then
		g_uicommoninfo.fight:SetText("#{ZDZD_200724_28}")
	else
		g_uicommoninfo.fight:SetText("#{ZDZD_200724_27}")
	end
	-- ÉèÖÃÒ³Ç©°´Å¥Ñ¡ÖÐ×´Ì¬
	local pagecnt = table.getn(g_uipageactions)
	for i=1, pagecnt do
		g_uipageactions[i]:SetCheck(0)
	end
	if g_curpage <= pagecnt then
		g_uipageactions[g_curpage]:SetCheck(1)
	end

	-- ÉèÖÃÒ³Ç©Ãû×Ö
	g_uicommoninfo.title:SetText("#{ZDZD_200724_09}")

	-- ÉèÖÃÊÇ·ñ¹¥»÷Íæ¼Ò
	local isbanattack = isbanattackplayer()
	g_uicommoninfo.noattackhm:SetCheck(isbanattack)

	-- ÉèÖÃÊÇ·ñÊ¹ÓÃÔ¶³Ì¹¥»÷
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

	-- ÉèÖÃÎ»ÖÃ
	if not this:IsVisible() then
		local pos = Variable:GetVariable("SkillUnionPos")
		if pos ~= nil then
			AutoAttackSkill_Frame:SetProperty("UnifiedPosition", pos)
		end
	end
end

--================= ¶Ô¼¼ÄÜUI½øÐÐÄÚÈÝ¸üÐÂ =====================
function AutoAttackSkill_UpdateSkillUI()
	local mpid = Player:GetData("MEMPAI")

	local xfcnt,skillcnt = table.getn(g_uixfskillactions), table.getn(g_uiskillactions)
	-- ÎÞÃÅÅÉ
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
		-- ´¦ÀíÊôÐÔÌáÊ¾
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
--================= ¸ù¾ÝÐÄ·¨¶ÔÓ¦µÃ¾ßÌå¼¼ÄÜUI½øÐÐÄÚÈÝ¸üÐÂ =====================
-- notice : g_data.curxfid ÐèÒª½øÐÐÌáÇ°½øÐÐ¼ÆËã¸³Öµ
function AutoAttackSkill_UpdateSkillUIByXF()

	-- ¿ÉÊ¹ÓÃµÄ¼¼ÄÜIDÌáÈ¡³öÀ´
	local skilldata,unlocklist = BattleAssist:Farm_GetSkillIds(),{}
	for i, v in ipairs(skilldata) do
		local id = v[1]
		unlocklist[id] = i
	end

	-- ´¦Àíµ±Ç°¼¼ÄÜaction
	local skillcnt = table.getn(g_uiskillactions)
	for i=1, skillcnt do
		g_uiskillactions[i].action:SetActionItem(-1)
		g_uiskillactions[i].lockp:Hide()
	end

	-- 10TLÂß¼­£¬  °á
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

	-- ´¦ÀíÍ¼±ê×´Ì¬
	for i=1, skillcnt do
		-- ¸Ã¼¼ÄÜÊÇ´æÔÚµÄ
		local id = ownlist[i]
		if id ~= nil then
			-- ÅÐ¶Ï¼¼ÄÜÊÇ·ñ½ûÓÃ¸Ã¼¼ÄÜ, Æ ¹¦¼¼ÄÜÒ²»á±»½ûÓÃ
			if unlocklist[id] == nil then
				g_uiskillactions[i].lock:Hide()
				g_uiskillactions[i].ban:Show()
				g_uiskillactions[i].unlock:Hide()
			else
				-- ¿ªÊ¼¶ÁÈ¡ÅäÖÃ
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
			-- ÏÔÊ¾×´Ì¬
			g_uiskillactions[i].lockp:Show()
		else
			-- Òþ²ØËùÓÐ×´Ì¬UI
			g_uiskillactions[i].lockp:Hide()
		end
	end

end

--================= Ë¢ÐÂÑ¡ÏîUIÄÚÈÝ =====================
function AutoAttackSkill_UpdateOptionBaseUI()
	-- ÏÈ½øÐÐÑ¡Ïî°´Å¥¸üÐÂ
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
	-- ´¦ÀíÒ©Æ·½çÃæÐÅÏ¢
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
			--  âÀï×î¶à¾Í3¸ö£¬³¬³öÀ´»áÓÐÏÔÊ¾ÎÊÌâ
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

--================= ´¦Àí×Ô¶¯ ½¶·µÄ¸÷¸öÊ±¼ä =====================
function AutoAttackSkill_AttackEvent(event)
	--PushDebugMessage("AutoAttackSkill_AttackEvent Chu¦n b¸ m·"..event)
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
		-- ±£³ÖÔ­ÓÐ×´Ì¬
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

--================= Ò©Æ·ÉèÖÃ =====================
function AutoAttackSkill_MakeRecoverInfo( i )
	local texts = { "#{ZDZD_200724_13}", "#{ZDZD_200724_21}", "#{ZDZD_200724_22}", "#{ZDZD_230815_1}" }
	local potions = BattleAssist:Farm_GetPotionIds(i)
	local delegate = {
		["updatecombo"] = function( self, select )
			g_uiskilloptions[i].combo:ResetList()
			-- »áÄ¬ÈÏÌí¼ÓÒ»¸ö²»Ê¹ÓÃµÄÑ¡Ïî
			g_uiskilloptions[i].combo:AddTextItem("#{ZDZD_200724_52}",0)
			
			local potionscnt = table.getn(potions or {})
			for j=1, potionscnt do
				local data = potions[j]
				local desc,cnt = PlayerPackage:GetItemName(data[1]),PlayerPackage:CountAvailableItemByIDTable( data[1] )
				if cnt > 0 then
					-- ÓµÓÐÊýÁ¿´óÓÚ0£¬ÐèÒª±ä»»ÎÄ×ÖÏÔÊ¾
					desc = ScriptGlobal_Format("#{ZDZD_200724_14}",desc,tostring(cnt))
				end
				g_uiskilloptions[i].combo:AddTextItem(desc,j)
			end
			-- µ±Ç°ÓÐÄ¬ÈÏÑ¡ÖÐ

			g_uiskilloptions[i].combo:SetCurrentSelect(select)
			g_uiskilloptions[i].parent:Show()
		end,
		["updatetext"] = function( self )
			local btnidx,rate = getmodifyvalue_new(g_configdata.usepotionc[i], i)
			g_uiskilloptions[i].name:SetText(ScriptGlobal_Format(texts[i], rate))
		end,
		["update"] = function( self )
			-- »ñÈ¡µ±Ç°ÎÒÊ¹ÓÃµÄµÀ¾ß
			local cur,potionscnt = 0, table.getn(potions or {})
			-- ´¦ÀíUI
			g_uiskilloptions[i].combo:ResetList()
			if g_configdata.usepotion[i] == 0 then
				cur = 0 
			else
				--if p ~= nil then
					cur = g_configdata.usepotiont[i]
				--end
			end
			self:updatecombo(cur)
			-- ¿ªÊ¼´¦Àí°´Å¥Ñ¡ÖÐ
			local btnidx,rate = getmodifyvalue_new(g_configdata.usepotionc[i], i)
			g_uiskilloptions[i].name:SetText(ScriptGlobal_Format(texts[i], rate))
			-- ½øÐÐ°´Å¥ÄÚÈÝÑ¡ÖÐ
			uibtnoptionupdate_new(btnidx,i)
		end,
		["onPosChange"] = function( self, select )
			-- »ñµÃµ±Ç°Ñ¡ÖÐµÄ´óÐ¡
			g_configdata.usepotionc[i] = getoptiondatabyid_new(select, i)
			-- Ë¢ÐÂÑ¡ÖÐ°´Å¥
			uibtnoptionupdate_new(select,i)
			-- ´æ´¢ÅäÖÃ
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
			-- Ë¢ÐÂÑ¡ÖÐ°´Å¥
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
			-- ´¦ÀíUI
			local max = table.getn(g_uiskilloptions)
			if i > max then
				PushDebugMessage("g_uiskilloptions: Table is error")
				return
			end

			-- »ñµÃÎÒµ±Ç°µÄ¼¼ÄÜID
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
			-- ½øÐÐ°´Å¥ÄÚÈÝÑ¡ÖÐ
			uibtnrroptionupdate(btnidx,i)

			--local isusing = g_configdata.useskill[skillIdx]
		end,
		["onPosChange"] = function( self, select )
			-- Ä¬ÈÏÑ¡ÖÐ50
			g_configdata.useRecoverSkill[i] = getoptiondatabyid(select)
			-- Ë¢ÐÂÑ¡ÖÐ°´Å¥
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
			-- »áÄ¬ÈÏÌí¼ÓÒ»¸ö²»Ê¹ÓÃµÄÑ¡Ïî
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

---------------------------------------µã»÷ÊÂ¼þ-----------------------------------------------------
function AutoAttackSkill_XinFa_Clicked(idx)
	local mpid = Player:GetData("MEMPAI")
	local xfcnt = table.getn(g_uixfskillactions)
	-- µãÃ»µã¶¼»á½øÐÐ×´Ì¬»¹Ô­
	for i=1, xfcnt do
		g_uixfskillactions[i].check:SetPushed(0)
	end

	-- ÎÞÃÅÅÉ
	if mpid == g_invalidmenpai then
		return
	else
		if idx > 0 and idx <= xfcnt then
			local action = EnumAction(idx-1, "xinfa")
			g_data.curxfid = action:GetID()
			AutoAttackSkill_UpdateSkillUIByXF()
			
			g_uixfskillactions[idx].check:SetPushed(1)
			
			-- µÈÓÚÄ¬ÈÏµã»÷ÁËµÚÒ»¸ö¼¼ÄÜÀ¸£¬¿´ÁËÏÂ£¬Ô­°æÃÅÅÉ¼¼ÄÜÀ¸Ã»ÓÐ½øÐÐÄ¬ÈÏÑ¡ÖÐ
			--AutoAttackSkill_Skill_Clicked(1)
		end
	end
end

function AutoAttackSkill_Skill_Clicked(idx)
	local xfcnt = table.getn(g_uiskillactions)
	-- µãÃ»µã¶¼»á½øÐÐ×´Ì¬»¹Ô­
	for i=1, xfcnt do
		g_uiskillactions[i].action:SetPushed(0)
	end
	if idx > 0 and idx <= xfcnt then
		g_uiskillactions[idx].action:SetPushed(1)
	end
end

function AutoAttackSkill_SkillLock_Clicked(idx)
	local mpid = Player:GetData("MEMPAI")
	-- ÎÞÃÅÅÉ
	if mpid == g_invalidmenpai then
		return
	else
		local n,skillid = getskillbyxf(g_data.curxfid,idx)
		if n < 0 then
			return
		end
		-- Æ ¹¥¼¼ÄÜ,½ûÖ¹µã»÷È¡Ïû
		if isnobanskill(skillid) > 0 then
			PushDebugMessage("#{ZDZD_200724_53}")
			g_uiskillactions[idx].unlock:SetCheck(1)
			return
		end
		-- ÅÐ¶Ï¼¼ÄÜÊÇ·ñÑ§»á £¬ÏÖ½×¶ÎÄ¬ÈÏÊ¹ÓÃµÄ¼¼ÄÜÒ²¿ÉÒÔÉèÖÃ£¬Ö»²»¹ýÏÔÊ¾½âËø¶øÒÑ
		-- ÇÐ»»×´Ì¬
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

	-- ÐèÒª¸ù¾ÝÃÅÅÉ½øÐÐÄÚÈÝÌØÊâ´¦Àí, ¶ëÃ¼Ã»ÓÐµÚ¶þÑ¡Ïî
	local mpid = Player:GetData("MEMPAI")
	if mpid == g_menpai_emei then
		-- ¶ëÃ¼±È½ÏÌØÊâÓÐÈý¸öÑ¡Ïî,²»×ö´¦Àí
	else
		-- Æ Í¨Çé¿ö£¬Ö»ÓÐÁ½¸öÑ¡Ïî, 2¸öÑ¡Ïî»áÄ¬ÈÏ½øÐÐµÝÔöÑ¡Ôñ
		if idx == g_optionbtnattr.normal.num then
			idx = g_optionbtnattr.special.num
		end
	end

	g_data.option = idx

	AutoAttackSkill_UpdateOptionUI()
end

--================= °Ù·Ö±ÈÇé¿ö =====================
-- i: ×ÝÏòË÷Òý idx£ººáÏòË÷Òý
function AutoAttackSkill_OptionPercent_Click(i, idx)
	if g_data.option == g_optionpagedef.recoverinfo then
		AutoAttackSkill_CallCb( i, "onPosChange", idx )
	elseif g_data.option == g_optionpagedef.petskill then
		AutoAttackSkill_CallCb3( i, "onPosChange", idx  )
	end
end

--================= »Ø¸´¼¼ÄÜµã»÷Çé¿ö =====================
function AutoAttackSkill_RecoverOptionPercent_Click(i, idx)
	if g_data.option == g_optionpagedef.recoverskill then
		AutoAttackSkill_CallCb2( i, "onPosChange", idx  )
	end
end

--================= ÏÂÀ­Ìõ±ä»¯ =====================
function AutoAttackSkill_ComboListSelectChanged(i)
	-- ½øÐÐ³õÊ¼Ìõ¼þÅÐ¶Ï
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
--================= ¿ªÊ¼¹¤×÷ =====================
function AutoAttackSkill_OnStartClick()
	local isworking = BattleAssist:IsWorking()
	if isworking then
		PushEvent("TRIGGER_ZIDONGZHANDOU","stop")
	else
		PushEvent("TRIGGER_ZIDONGZHANDOU","start")
	end	

	-- Ê¼Ö Ò»¸ö×´Ì¬
	g_uicommoninfo.fight:SetCheck(0)
end

--================= ÊÇ·ñ¿ÉÒÔ¹¥»÷Íæ¼Ò =====================
function AutoAttackSkill_OnAttackHumanClick()
	-- ÉèÖÃÊÇ·ñ¹¥»÷Íæ¼Ò
	if g_configdata.useSwitch[1] > 0 then
		g_configdata.useSwitch[1] = 0
	else
		g_configdata.useSwitch[1] = 1
	end
	
	-- ÅäÖÃ´æ´¢
	BattleAssist:Farm_UpdateConfig(makecfgstr())
	BattleAssist:Farm_SetConfigData( g_configdata )

	local isattackplayer = isbanattackplayer()
	g_uicommoninfo.noattackhm:SetCheck(isattackplayer)
end

--================= ÊÇ·ñ¿ÉÒÔ¹¥»÷Íæ¼Ò =====================
function AutoAttackSkill_OnUseLongRangeSkillClick()
	-- ÉèÖÃÊÇ·ñ¹¥»÷Íæ¼Ò
	if g_configdata.useSwitch[2] > 0 then
		g_configdata.useSwitch[2] = 0
	else
		g_configdata.useSwitch[2] = 1
	end
	
	-- ÅäÖÃ´æ´¢
	BattleAssist:Farm_UpdateConfig(makecfgstr())
	BattleAssist:Farm_SetConfigData( g_configdata )

	local check = 1 
	if g_configdata.useSwitch[2] > 0 then
		check = 0
	end

	g_uicommoninfo.longfight:SetCheck(check)
end

--================= ÇÐ»»Ò³Ç© =====================
function AutoAttackSkill_Page_Switch(page)
	if page >= g_curpage or page < 0 then
		return
	end

	-- ¹Ø± 
	AutoAttackSkill_OnClose()
	-- ´ò¿ª¸÷¸ö½çÃæ
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
		-- ÊÇ·ñÓÐÉí·Ý YCGZ_231225_02
		if Player:GetData("IBIDENTITYID") <= 0 then
			PushDebugMessage("#{YCGZ_231225_02}")
			return
		end		
		OpenShenFenPage()
	end
end

function AutoAttackSkill_OnClose()
	-- ¹Ø± ½çÃæµÄÊ±ºòÐèÒª±£´æÏà¶ÔÎ»ÖÃ
	local unifiedpos = AutoAttackSkill_Frame:GetProperty("UnifiedPosition")
	Variable:SetVariable("SkillUnionPos", unifiedpos, 1)

	this:Hide()
end

--====================»Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ=========================
function AutoAttackSkill_OnResetPos()
	AutoAttackSkill_Frame:SetProperty("UnifiedPosition",g_unifiedposistion)
end

--×Ô¶¯Éý¼¶°´Å¥
function AutoAttackSkill_AutoLevelUpBtn_Click()
    local newState =  tonumber(AutoAttackSkill_AutoLevelUpBtn:GetCheck())
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AutoLevelUpLimit");
		Set_XSCRIPT_ScriptID(891330);
		Set_XSCRIPT_Parameter(0, newState);  -- ????
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();
end
