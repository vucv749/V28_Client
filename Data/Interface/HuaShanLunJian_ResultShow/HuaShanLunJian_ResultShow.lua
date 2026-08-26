-- 玩家血条积分UI
--
local g_unifiedposistion
local g_scene_res			= 645
local g_istimerset			= 0
local g_ui_list				= {}		-- ui??
local g_memcount_max		= 12		-- ????
local g_teammem_max			= 6			-- ???????
local g_othercolor			= {			-- ??????
	lose = "#ccccccc",					-- ??
	die = "#cff0000",					-- ??
}

local g_menpaiinfo			= {
	[0]  ={name="#{WCBZ_180128_59}",color="#cff6600"},	--??
	[1]  ={name="#{WCBZ_180128_65}",color="#cffcc00"},	--??
	[2]  ={name="#{WCBZ_180128_67}",color="#c00ff00"},	--??
	[3]  ={name="#{WCBZ_180128_61}",color="#c0000ff"},	--??
	[4]  ={name="#{WCBZ_180128_68}",color="#cff99cc"},	--??
	[5]  ={name="#{WCBZ_180128_66}",color="#c007700"},	--??
	[6]  ={name="#{WCBZ_180128_60}",color="#cffff00"},	--??
	[7]  ={name="#{WCBZ_180128_63}",color="#cffffff"},	--??
	[8]  ={name="#{WCBZ_180128_64}",color="#c7700ff"},	--??
	[9]  ={name="#{WCBZ_180128_57}",color="#c999999"},	--???
	[10] ={name="#{WCBZ_180128_62}",color="#cffffb3"},	--??
}
local g_battle_type			= {
	fstblood_A = 1,						-- ??A??
	fstblood_B = 2,						-- ??B??
	teamwin_A = 1,						-- ??A?
	teamwin_B = 2,						-- ??B?
}

local g_image				= {
	win = "set:HSLJ_01 image:HSLJ_Win",
	lose = "set:HSLJ_01 image:HSLJ_Lost",
	ping = "set:HSLJ_01 image:HSLJ_Ping",
}

local g_teampost = {
	[0] = {show = 0, icon = "",},									-- ??
	[1] = {show = 1, icon = "set:Union1 image:Union_MemberIcon_L",},-- ???
	[2] = {show = 1, icon = "set:Union1 image:Union_LeaderIcon_L",},-- ???
}

local g_duanweiinfo			= {
	[1] = "#{HSSC_191009_37}",
	[2] = "#{HSSC_191009_38}",
	[3] = "#{HSSC_191009_39}",
	[4] = "#{HSSC_191009_40}",
	[5] = "#{HSSC_191009_41}",
	[6] = "#{HSSC_191009_42}",
}

function HuaShanLunJian_ResultShow_PreLoad()
	this:RegisterEvent("BWTROOPS_RESULT_SHOW",true)
	this:RegisterEvent("BWTROOPS_COPYDATA_FULL_INFO",false)
	this:RegisterEvent("BWTROOPS_COPYDATA_FIRST_TIME",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function HuaShanLunJian_ResultShow_OnLoad()

	local _prefix_l = "HuaShanLunJian_ResultShow_Left_"
	local _prefix_r = "HuaShanLunJian_ResultShow_Right_"
	local makeGroup = function(prefix,name,mp,leader,kill,rank)
		return {
			["name"] = _G[prefix..name],
			["mp"] = _G[prefix..mp],
			["leader"] = _G[prefix..leader],
			["kill"] = _G[prefix..kill],
			["dw"] = _G[prefix..rank],
		}
	end
	-- 队伍信息控件列表初始化
	g_ui_list = {
		makeGroup(_prefix_l, "1_name","1_Career","1_Icon","1_Level","1_Rank"),
		makeGroup(_prefix_l, "2_name","2_Career","2_Icon","2_Level","2_Rank"),
		makeGroup(_prefix_l, "3_name","3_Career","3_Icon","3_Level","3_Rank"),
		makeGroup(_prefix_l, "4_name","4_Career","4_Icon","4_Level","4_Rank"),
		makeGroup(_prefix_l, "5_name","5_Career","5_Icon","5_Level","5_Rank"),
		makeGroup(_prefix_l, "6_name","6_Career","6_Icon","6_Level","6_Rank"),

		makeGroup(_prefix_r, "1_name","1_Career","1_Icon","1_Level","1_Rank"),
		makeGroup(_prefix_r, "2_name","2_Career","2_Icon","2_Level","2_Rank"),
		makeGroup(_prefix_r, "3_name","3_Career","3_Icon","3_Level","3_Rank"),
		makeGroup(_prefix_r, "4_name","4_Career","4_Icon","4_Level","4_Rank"),
		makeGroup(_prefix_r, "5_name","5_Career","5_Icon","5_Level","5_Rank"),
		makeGroup(_prefix_r, "6_name","6_Career","6_Icon","6_Level","6_Rank"),
	}

	g_unifiedposistion	= HuaShanLunJian_ResultShow_Frame:GetProperty("UnifiedPosition")
end

function HuaShanLunJian_ResultShow_OnEvent(event)
	if event == "BWTROOPS_RESULT_SHOW" then
		HuaShanLunJian_ResultShow_OnShow()
	elseif event == "ADJEST_UI_POS" then
		HuaShanLunJian_ResultShow_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		HuaShanLunJian_ResultShow_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		HuaShanLunJian_ResultShow_Close_Clicked()
	elseif event == "BWTROOPS_COPYDATA_FULL_INFO" then
		HuaShanLunJian_ResultShow_Close_Clicked()
	elseif event == "BWTROOPS_COPYDATA_FIRST_TIME" then
		HuaShanLunJian_ResultShow_Close_Clicked()
	end
end

--================================================
-- 显示信息
--================================================
function HuaShanLunJian_ResultShow_OnShow()
	if g_scene_res ~= GetSceneID() then
		return
	end
	HuaShanLunJian_ResultShow_InitData()
	HuaShanLunJian_ResultShow_InitOtherUI()
	HuaShanLunJian_ResultShow_RefreshUI()
	this:Show()
end

function HuaShanLunJian_ResultShow_InitOtherUI()
	HuaShanLunJian_ResultShow_Team_Left:SetText("")
	HuaShanLunJian_ResultShow_Team_Right:SetText("")
	HuaShanLunJian_ResultShow_Team1FirstKill:Hide()
	HuaShanLunJian_ResultShow_Team2FirstKill:Hide()
	HuaShanLunJian_ResultShow_LiftPic:Hide()
	HuaShanLunJian_ResultShow_RightPic:Hide()
end

function HuaShanLunJian_ResultShow_InitData()
end

--================================================
-- 刷一遍信息
--================================================
function HuaShanLunJian_ResultShow_RefreshUI()
	HuaShanLunJian_ResultShow_RefreshTeamUI()
	HuaShanLunJian_ResultShow_RefreshMemberUI()
end

--================================================
-- 刷一遍队伍信息
--================================================
function HuaShanLunJian_ResultShow_RefreshTeamUI()
	local teamid_a,zoneid_a,teamname_a = XBW:GetTeamBattleInfo(0)
	local teamid_b,zoneid_b,teamname_b = XBW:GetTeamBattleInfo(1)
	if teamid_a < 0 or teamid_b < 0 then
		HuaShanLunJian_ResultShow_InitOtherUI()
	else
		-- 名字
		HuaShanLunJian_ResultShow_Team_Left:SetText(teamname_a)
		HuaShanLunJian_ResultShow_Team_Right:SetText(teamname_b)
		-- 一血
		HuaShanLunJian_ResultShow_Team1FirstKill:Hide()
		HuaShanLunJian_ResultShow_Team2FirstKill:Hide()
		local fstblood = XBW:GetCopySceneBWFirstKillerType()
		if fstblood == g_battle_type.fstblood_A then
			HuaShanLunJian_ResultShow_Team1FirstKill:Show()
		elseif fstblood == g_battle_type.fstblood_B then
			HuaShanLunJian_ResultShow_Team2FirstKill:Show()
		end
		local result = XBW:GetBWTroopsPK_Result_Info()
		if result == g_battle_type.teamwin_A then
			HuaShanLunJian_ResultShow_LiftPic:SetProperty("Image" , g_image.win)
			HuaShanLunJian_ResultShow_RightPic:SetProperty("Image" , g_image.lose)
		elseif result == g_battle_type.teamwin_B then
			HuaShanLunJian_ResultShow_LiftPic:SetProperty("Image" , g_image.lose)
			HuaShanLunJian_ResultShow_RightPic:SetProperty("Image" , g_image.win)
		else
			HuaShanLunJian_ResultShow_LiftPic:SetProperty("Image" , g_image.ping)
			HuaShanLunJian_ResultShow_RightPic:SetProperty("Image" , g_image.ping)
		end
		HuaShanLunJian_ResultShow_LiftPic:Show()
		HuaShanLunJian_ResultShow_RightPic:Show()
	end
end

--================================================
-- 刷一遍成员信息
--================================================
function HuaShanLunJian_ResultShow_RefreshMemberUI()
	for i=1, g_memcount_max do
		if g_ui_list[i] ~= nil then
			local data = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
			-- 说明当前索引玩家不存在
			if data == nil or type(data) ~= "table" or data.name == "" then
				g_ui_list[i].name:SetText("")
				g_ui_list[i].mp:SetText("")
				g_ui_list[i].kill:SetText("")
				g_ui_list[i].leader:Hide()
				g_ui_list[i].dw:SetText("")
			else
				-- 名字
				local szname = HuaShanLunJian_ResultShow_TransformName(data.name, i-1)
				g_ui_list[i].name:SetText(szname)
				-- 击杀数
				g_ui_list[i].kill:SetText(tostring(data.kill))
				-- 门派
				local mpinfo = g_menpaiinfo[data.mp]
				if mpinfo ~= nil then
					g_ui_list[i].mp:SetText(mpinfo.name)
				else
					g_ui_list[i].mp:SetText("")
				end
				-- 是否是队长
				local postdata = g_teampost[data.post]
				if postdata == nil then
					g_ui_list[i].leader:Hide()
				else
					if postdata.show > 0 then
						g_ui_list[i].leader:SetProperty("Image", postdata.icon)
						g_ui_list[i].leader:Show()
					else
						g_ui_list[i].leader:Hide()
					end
				end
				-- 段位
				if g_duanweiinfo[data.dw] ~= nil then
					g_ui_list[i].dw:SetText(g_duanweiinfo[data.dw])
				else
					-- 如果为0或犨其他异常值，默认显示最低级
					g_ui_list[i].dw:SetText(g_duanweiinfo[1])
				end
			end
		end
	end
end

--================================================
-- 转换名字
--================================================
function HuaShanLunJian_ResultShow_TransformName(name, idx)
	local teamidx = math.floor(idx/g_teammem_max)
	local teamid,zoneid,teamname = XBW:GetTeamBattleInfo(teamidx)
	if teamid < 0 then
		return name
	end

	local serverName = DataPool:GetServerName(zoneid)
	local retname = name.."@"..tostring(serverName)

	return retname
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function HuaShanLunJian_ResultShow_ResetPos()
	HuaShanLunJian_ResultShow_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

--================================================
-- 关睜界面
--================================================
function HuaShanLunJian_ResultShow_Close_Clicked()
	this:Hide()
end
