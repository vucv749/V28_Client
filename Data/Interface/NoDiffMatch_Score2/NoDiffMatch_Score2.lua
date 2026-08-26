-- 玩家血条积分UI
--
local g_unifiedposistion
local g_istimerset			= 0
local g_ui_list				= {}		-- ui??
local g_data_list			= {}		-- ????,????
local g_memcount_max		= 12		-- ????
local g_teammem_max			= 6			-- ???????
local g_btimerset			= 0			-- ????????
local g_othercolor			= {			-- ??????
	lose = "#ccccccc",					-- ??
	die = "#cff0000",					-- ??
}
local g_scene_res_id		= 607
local g_scene_fbres_id		= 612

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
	[11] ={name="#{GMGameInterface_Script_DataPool_Info_ERenGu}",color="#c656ab4"},	--menpai11
}
local g_battle_type			= {
	fstblood_A = 1,						-- ??A??
	fstblood_B = 2,						-- ??B??
}

local g_teampost = {
	[0] = {show = 0, icon = "",},									-- ??
	[1] = {show = 1, icon = "set:Union1 image:Union_MemberIcon_L",},-- ???
	[2] = {show = 1, icon = "set:Union1 image:Union_LeaderIcon_L",},-- ???
}

function NoDiffMatch_Score2_PreLoad()
	this:RegisterEvent("ZBS_BATTLE_FINAL_SHOW",true)
	this:RegisterEvent("ZBS_BATTLE_FINAL_CLOSEUI",false)
	this:RegisterEvent("ZBS_BATTLE_FINAL_REFRESH",false)
	this:RegisterEvent("ZBS_BATTLE_FINAL_RESULT",false)
	this:RegisterEvent("ZBS_BATTLE_TIME_FINAL_RFRESH",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function NoDiffMatch_Score2_OnLoad()

	local _prefix_l = "NoDiffMatch_Score2_Left_"
	local _prefix_r = "NoDiffMatch_Score2_Right_"
	local makeGroup = function(prefix,name,mp,leader,lv,hp,damage)
		return {
			["name"] = _G[prefix..name],
			["mp"] = _G[prefix..mp],
			["lv"] = _G[prefix..lv],
			["leader"] = _G[prefix..leader],
			["hp"] = _G[prefix..hp],
			["damage"] = _G[prefix..damage],
		}
	end
	-- 队伍信息控件列表初始化
	g_ui_list = {
		makeGroup(_prefix_l, "1_name","1_Career","1_Icon","1_Level","PlayerHP1","1_Hurt"),
		makeGroup(_prefix_l, "2_name","2_Career","2_Icon","2_Level","PlayerHP2","2_Hurt"),
		makeGroup(_prefix_l, "3_name","3_Career","3_Icon","3_Level","PlayerHP3","3_Hurt"),
		makeGroup(_prefix_l, "4_name","4_Career","4_Icon","4_Level","PlayerHP4","4_Hurt"),
		makeGroup(_prefix_l, "5_name","5_Career","5_Icon","5_Level","PlayerHP5","5_Hurt"),
		makeGroup(_prefix_l, "6_name","6_Career","6_Icon","6_Level","PlayerHP6","6_Hurt"),

		makeGroup(_prefix_r, "1_name","1_Career","1_Icon","1_Level","PlayerHP1","1_Hurt"),
		makeGroup(_prefix_r, "2_name","2_Career","2_Icon","2_Level","PlayerHP2","2_Hurt"),
		makeGroup(_prefix_r, "3_name","3_Career","3_Icon","3_Level","PlayerHP3","3_Hurt"),
		makeGroup(_prefix_r, "4_name","4_Career","4_Icon","4_Level","PlayerHP4","4_Hurt"),
		makeGroup(_prefix_r, "5_name","5_Career","5_Icon","5_Level","PlayerHP5","5_Hurt"),
		makeGroup(_prefix_r, "6_name","6_Career","6_Icon","6_Level","PlayerHP6","6_Hurt"),
	}

	g_unifiedposistion	= NoDiffMatch_Score2_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_Score2_OnEvent(event)
	if event == "ZBS_BATTLE_FINAL_SHOW" then
		NoDiffMatch_Score2_OnShow()
	elseif event == "ZBS_BATTLE_FINAL_REFRESH" then
		NoDiffMatch_Score2_RefreshUI()
	elseif event == "ZBS_BATTLE_TIME_FINAL_RFRESH" then
		g_btimerset = 0
		NoDiffMatch_Score2_RefreshUI()
	elseif event == "ZBS_BATTLE_FINAL_RESULT" then
		NoDiffMatch_Score2Frame_HideWindow()
	elseif event == "ZBS_BATTLE_FINAL_CLOSEUI" then
		NoDiffMatch_Score2Frame_HideWindow()
	elseif event == "ADJEST_UI_POS" then
		NoDiffMatch_Score2_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NoDiffMatch_Score2_ResetPos()
	elseif event == "SCENE_TRANSED" then
		if g_scene_res_id ~= GetSceneID() and g_scene_fbres_id ~= GetSceneID() then
			NoDiffMatch_Score2Frame_HideWindow()
		end
	end
end

--================================================
-- 显示信息
--================================================
function NoDiffMatch_Score2_OnShow()
	if(IsWindowShow("NoDiffMatch_Score2_Tiny")) then
		return
	end
	if GMVisible:LuaFnGetViewType() > 0 then
		return
	end
	NoDiffMatch_Score2_InitData()
	NoDiffMatch_Score2_InitOtherUI()
	NoDiffMatch_Score2_RefreshUI()
	this:Show()
end

function NoDiffMatch_Score2_InitOtherUI()
	NoDiffMatch_Score2_Team_Left:SetText("")
	NoDiffMatch_Score2_Team_Right:SetText("")
	NoDiffMatch_Score2_Team1FirstKill:Hide()
	NoDiffMatch_Score2_Team2FirstKill:Hide()
	NoDiffMatch_Score2_TimeText:SetText("")
	NoDiffMatch_Score2_TimeWatch:Hide()
	NoDiffMatch_Score2_WatchText:SetText("")
	NoDiffMatch_Score2_WatchText:Hide()
end

function NoDiffMatch_Score2_InitData()
	g_data_list = {}
	for i=1, g_memcount_max do
		g_data_list[i] = {}
		g_data_list[i].name = ""
		g_data_list[i].mp = 9
		g_data_list[i].lv = -1
		g_data_list[i].hp = 1
		g_data_list[i].guid = -1
	end

	g_btimerset = 0
end

--================================================
-- 刷一遍信息
--================================================
function NoDiffMatch_Score2_RefreshUI()
	NoDiffMatch_Score2_RefreshTeamUI()
	NoDiffMatch_Score2_RefreshMemberUI()
end

--================================================
-- 刷一遍队伍信息
--================================================
function NoDiffMatch_Score2_RefreshTeamUI()
	local fstblood,lefttime,result,teamname_a,teamname_b = ZBS:GetBattleTeamInfo()
	if fstblood < 0 then
		NoDiffMatch_Score2_InitOtherUI()
	else
		-- 名字
		NoDiffMatch_Score2_Team_Left:SetText(teamname_a)
		NoDiffMatch_Score2_Team_Right:SetText(teamname_b)
		-- 一血
		NoDiffMatch_Score2_Team1FirstKill:Hide()
		NoDiffMatch_Score2_Team2FirstKill:Hide()
		if fstblood == g_battle_type.fstblood_A then
			NoDiffMatch_Score2_Team1FirstKill:Show()
		elseif fstblood == g_battle_type.fstblood_B then
			NoDiffMatch_Score2_Team2FirstKill:Show()
		end
		if g_btimerset == 0 then
			-- 倒计时
			g_btimerset = 1

			NoDiffMatch_Score2_TimeWatch:SetProperty("Timer", tostring(lefttime))
			NoDiffMatch_Score2_TimeWatch:Show()
		end
		if lefttime > 0 then
			NoDiffMatch_Score2_TimeText:SetText("#{WCBZ_220809_86}")
		else
			NoDiffMatch_Score2_TimeText:SetText("")
		end
	end
end

--================================================
-- 刷一遍成员信息
--================================================
function NoDiffMatch_Score2_RefreshMemberUI()
	for i=1, g_memcount_max do
		if g_ui_list[i] ~= nil then
			local lv,hp,mp,killnum,post,name,damage = ZBS:GetBattleMemberInfo(i-1)
			-- 说明当前索引玩家不存在
			if lv <= 0 then
				g_ui_list[i].name:SetText("")
				g_ui_list[i].mp:SetText("")
				g_ui_list[i].lv:SetText("")
				g_ui_list[i].leader:Hide()
				g_ui_list[i].hp:SetProgress(0,100)
				g_ui_list[i].damage:SetText("")
			else
				-- 名字
				local szname = NoDiffMatch_Score2_TransformName(name, i-1)
				g_ui_list[i].name:SetText(szname)
				-- 等级
				g_ui_list[i].lv:SetText(tostring(lv))
				-- 门派
				local mpinfo = g_menpaiinfo[mp]
				if mpinfo ~= nil then
					g_ui_list[i].mp:SetText(mpinfo.name)
				else
					g_ui_list[i].mp:SetText("")
				end
				-- 是否是队长
				local postdata = g_teampost[post]
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
				-- 血量
				g_ui_list[i].hp:SetProgress(hp,100)
				g_ui_list[i].damage:SetText(damage)
			end
		end
	end
end

--================================================
-- 转换名字
--================================================
function NoDiffMatch_Score2_TransformName(name, idx)
	local zoneid = ZBS:GetBattleMemberZoneID(idx)
	if zoneid < 0 then
		return name
	end

	local retname = name
	local battletype = ZBS:GetBattleType()
	if battletype > 1 then
		local selfzoneid = DataPool:GetSelfZoneWorldID()
		if selfzoneid ~= zoneid then
			local serverName = DataPool:GetServerName( zoneid )
			retname = name.."@"..tostring(serverName)
		end
	end

	return retname
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_Score2_ResetPos()
	NoDiffMatch_Score2_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function NoDiffMatch_Score2_OnTimer()
	NoDiffMatch_Score2_TimeWatch:Hide()
	NoDiffMatch_Score2_WatchText:SetText("#{WCBZ_180128_253}")
	NoDiffMatch_Score2_WatchText:Show()
	NoDiffMatch_Score2_TimeText:SetText("")
end

--================================================
-- 选中目标
--================================================
function NoDiffMatch_Score2_Member_Click(idx)
	if idx < 1 or idx > g_memcount_max then
		return
	end
	local lv,hp,mp,killnum,post,name,_ = ZBS:GetBattleMemberInfo(idx-1)
	if lv <= 0 then
		return
	end

	ZBS:SetBattleMainTargetByIdx(idx-1)
end

--================================================
-- 关睜界面
--================================================
function NoDiffMatch_Score2Frame_CloseWindow()
	NoDiffMatch_Score2Frame_HideWindow()
	PushEvent( "ZBS_BATTLE_TINYSHOW" )
end

function NoDiffMatch_Score2Frame_HideWindow()
	this:Hide()
end
