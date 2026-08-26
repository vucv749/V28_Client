-- 玩家血条积分UI
--
local g_unifiedposistion
local g_istimerset			= 0
local g_ui_list				= {}		-- ui集合
local g_memcount_max		= 12		-- 队员总数
local g_teammem_max			= 6			-- 单队伍最大人数
local g_btimerset			= 0			-- 是否设置过倒计时
local g_othercolor			= {			-- 其他状态颜色
	lose = "#ccccccc",					-- 掉线
	die = "#cff0000",					-- 死亡
}
local g_scene_res_id		= 607

local g_menpaiinfo			= {
	[0]  ={name="#{WCBZ_180128_59}",color="#cff6600"},	-- 少林
	[1]  ={name="#{WCBZ_180128_65}",color="#cffcc00"},	-- 明教
	[2]  ={name="#{WCBZ_180128_67}",color="#c00ff00"},	-- 丐帮
	[3]  ={name="#{WCBZ_180128_61}",color="#c0000ff"},	-- 武当
	[4]  ={name="#{WCBZ_180128_68}",color="#cff99cc"},	-- 峨嵋
	[5]  ={name="#{WCBZ_180128_66}",color="#c007700"},	-- 星宿
	[6]  ={name="#{WCBZ_180128_60}",color="#cffff00"},	-- 天龙
	[7]  ={name="#{WCBZ_180128_63}",color="#cffffff"},	-- 天山
	[8]  ={name="#{WCBZ_180128_64}",color="#c7700ff"},	-- 逍遥
	[9]  ={name="#{WCBZ_180128_57}",color="#c999999"},	-- 无门派
	[10] ={name="#{WCBZ_180128_62}",color="#cffffb3"},	-- 曼陀
}
local g_battle_type			= {
	fstblood_A = 1,						-- 队伍A一血
	fstblood_B = 2,						-- 队伍B一血
}

local g_teampost = {
	[0] = {show = 0, icon = "",},									-- 成员
	[1] = {show = 1, icon = "set:Union1 image:Union_MemberIcon_L",},-- 副队长
	[2] = {show = 1, icon = "set:Union1 image:Union_LeaderIcon_L",},-- 副队长
}

local g_duanweiinfo			= {
	[1] = "#{HSSC_191009_37}",
	[2] = "#{HSSC_191009_38}",
	[3] = "#{HSSC_191009_39}",
	[4] = "#{HSSC_191009_40}",
	[5] = "#{HSSC_191009_41}",
	[6] = "#{HSSC_191009_42}",
}
function HuaShanLunJian_Score_PreLoad()
	this:RegisterEvent("BWTROOPS_COPYDATA_FULL_INFO")
	this:RegisterEvent("BWTROOPS_COPYDATA_FIRST_TIME")
	this:RegisterEvent("BWTROOPS_COPYDATA_REFRESH",false)
	this:RegisterEvent("BWTROOPS_RESULT_SHOW",false)
	this:RegisterEvent("BWTROOPS_COPYDATA_SYNC_TIME",false)
	this:RegisterEvent("BWTROOPS_UPDATE_STATE",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function HuaShanLunJian_Score_OnLoad()

	local _prefix_l = "HuaShanLunJian_Score_Left_"
	local _prefix_r = "HuaShanLunJian_Score_Right_"
	local makeGroup = function(prefix,name,mp,leader,lv,hp,dw)
		return {
			["name"] = _G[prefix..name],
			["mp"] = _G[prefix..mp],
			["lv"] = _G[prefix..lv],
			["leader"] = _G[prefix..leader],
			["hp"] = _G[prefix..hp],
			["dw"] = _G[prefix..dw],
		}
	end
	-- 队伍信息控件列表初始化
	g_ui_list = {
		makeGroup(_prefix_l, "1_name","1_Career","1_Icon","1_Level","PlayerHP1","1_Rank"),
		makeGroup(_prefix_l, "2_name","2_Career","2_Icon","2_Level","PlayerHP2","2_Rank"),
		makeGroup(_prefix_l, "3_name","3_Career","3_Icon","3_Level","PlayerHP3","3_Rank"),
		makeGroup(_prefix_l, "4_name","4_Career","4_Icon","4_Level","PlayerHP4","4_Rank"),
		makeGroup(_prefix_l, "5_name","5_Career","5_Icon","5_Level","PlayerHP5","5_Rank"),
		makeGroup(_prefix_l, "6_name","6_Career","6_Icon","6_Level","PlayerHP6","6_Rank"),

		makeGroup(_prefix_r, "1_name","1_Career","1_Icon","1_Level","PlayerHP1","1_Rank"),
		makeGroup(_prefix_r, "2_name","2_Career","2_Icon","2_Level","PlayerHP2","2_Rank"),
		makeGroup(_prefix_r, "3_name","3_Career","3_Icon","3_Level","PlayerHP3","3_Rank"),
		makeGroup(_prefix_r, "4_name","4_Career","4_Icon","4_Level","PlayerHP4","4_Rank"),
		makeGroup(_prefix_r, "5_name","5_Career","5_Icon","5_Level","PlayerHP5","5_Rank"),
		makeGroup(_prefix_r, "6_name","6_Career","6_Icon","6_Level","PlayerHP6","6_Rank"),
	}

	g_unifiedposistion	= HuaShanLunJian_Score_Frame:GetProperty("UnifiedPosition")
end

function HuaShanLunJian_Score_OnEvent(event)
	if event == "BWTROOPS_COPYDATA_FULL_INFO" then
		HuaShanLunJian_Score_OnShow()
	elseif event == "BWTROOPS_COPYDATA_FIRST_TIME" then
		HuaShanLunJian_Score_OnShow()
	elseif event == "BWTROOPS_COPYDATA_REFRESH" then
		HuaShanLunJian_Score_RefreshUI()
	elseif event == "BWTROOPS_COPYDATA_SYNC_TIME" then
		g_btimerset = 0
		HuaShanLunJian_Score_RefreshUI()
	elseif event == "BWTROOPS_RESULT_SHOW" then
		HuaShanLunJian_ScoreFrame_HideWindow()
	elseif event == "ADJEST_UI_POS" then
		HuaShanLunJian_Score_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		HuaShanLunJian_Score_ResetPos()
	elseif event == "SCENE_TRANSED" then
		if g_scene_res_id ~= GetSceneID() then
			HuaShanLunJian_ScoreFrame_HideWindow()
		end
	end
end

--================================================
-- 显示信息
--================================================
function HuaShanLunJian_Score_OnShow()
	if(IsWindowShow("HuaShanLunJian_Score_Tiny")) then
		return
	end

	HuaShanLunJian_Score_InitData()
	HuaShanLunJian_Score_InitOtherUI()
	HuaShanLunJian_Score_RefreshUI()
	this:Show()
end

function HuaShanLunJian_Score_InitOtherUI()
	HuaShanLunJian_Score_Team_Left:SetText("")
	HuaShanLunJian_Score_Team_Right:SetText("")
	HuaShanLunJian_Score_Team1FirstKill:Hide()
	HuaShanLunJian_Score_Team2FirstKill:Hide()
	HuaShanLunJian_Score_TimeText:SetText("")
	HuaShanLunJian_Score_TimeWatch:Hide()
	HuaShanLunJian_Score_WatchText:SetText("")
	HuaShanLunJian_Score_WatchText:Hide()
end

function HuaShanLunJian_Score_InitData()
	g_btimerset = 0
end

--================================================
-- 刷一遍信息
--================================================
function HuaShanLunJian_Score_RefreshUI()
	HuaShanLunJian_Score_RefreshTeamUI()
	HuaShanLunJian_Score_RefreshMemberUI()
end

--================================================
-- 刷一遍队伍信息
--================================================
function HuaShanLunJian_Score_RefreshTeamUI()
	local teamid_a,zoneid_a,teamname_a = XBW:GetTeamBattleInfo(0)
	local teamid_b,zoneid_b,teamname_b = XBW:GetTeamBattleInfo(1)
	if teamid_a < 0 or teamid_b < 0 then
		HuaShanLunJian_Score_InitOtherUI()
	else
		-- 名字
		HuaShanLunJian_Score_Team_Left:SetText(teamname_a)
		HuaShanLunJian_Score_Team_Right:SetText(teamname_b)
		-- 一血
		local fstblood = XBW:GetCopySceneBWFirstKillerType()
		HuaShanLunJian_Score_Team1FirstKill:Hide()
		HuaShanLunJian_Score_Team2FirstKill:Hide()
		if fstblood == g_battle_type.fstblood_A then
			HuaShanLunJian_Score_Team1FirstKill:Show()
		elseif fstblood == g_battle_type.fstblood_B then
			HuaShanLunJian_Score_Team2FirstKill:Show()
		end

		local lefttime = XBW:GetBWTroopsPK_LeftTimes()
		if g_btimerset == 0 then
			-- 倒计时
			g_btimerset = 1

			HuaShanLunJian_Score_TimeWatch:SetProperty("Timer", tostring(lefttime))
			HuaShanLunJian_Score_TimeWatch:Show()
		end
		if lefttime > 0 then
			HuaShanLunJian_Score_TimeText:SetText("#{WCBZ_220809_86}")
		else
			HuaShanLunJian_Score_TimeText:SetText("")
		end
	end
end

--================================================
-- 刷一遍成员信息
--================================================
function HuaShanLunJian_Score_RefreshMemberUI()
	for i=1, g_memcount_max do
		if g_ui_list[i] ~= nil then
			local data = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
			-- 说明当前索引玩家不存在
			if data == nil or type(data) ~= "table" or data.name == "" then
				g_ui_list[i].name:SetText("")
				g_ui_list[i].mp:SetText("")
				g_ui_list[i].lv:SetText("")
				g_ui_list[i].leader:Hide()
				g_ui_list[i].hp:SetProgress(0,100)
				g_ui_list[i].dw:SetText("")
			else
				-- 名字
				local szname = HuaShanLunJian_Score_TransformName(data.name, i-1)
				g_ui_list[i].name:SetText(szname)
				-- 等级
				g_ui_list[i].lv:SetText(tostring(data.level))
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
				-- 血量
				g_ui_list[i].hp:SetProgress(data.hp,100)
				-- 段位
				if g_duanweiinfo[data.dw] ~= nil then
					g_ui_list[i].dw:SetText(g_duanweiinfo[data.dw])
				else
					g_ui_list[i].dw:SetText(g_duanweiinfo[1])
				end
			end
		end
	end
end

--================================================
-- 转换名字
--================================================
function HuaShanLunJian_Score_TransformName(name, idx)
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
function HuaShanLunJian_Score_ResetPos()
	HuaShanLunJian_Score_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function HuaShanLunJian_Score_OnTimer()
	HuaShanLunJian_Score_TimeWatch:Hide()
	HuaShanLunJian_Score_WatchText:SetText("#{WCBZ_180128_253}")
	HuaShanLunJian_Score_WatchText:Show()
	HuaShanLunJian_Score_TimeText:SetText("")
end

--================================================
-- 选中目标
--================================================
function HuaShanLunJian_Score_Member_Click(idx)
	if idx < 1 or idx > g_memcount_max then
		return
	end
	local data = XBW:GetCopySceneBWPlayerInfoByIdx(idx-1)
	if data == nil or type(data) ~= "table" then
		return
	end

	XBW:SetBMMainTargetByUIIdx(idx)
end

--================================================
-- 关闭界面
--================================================
function HuaShanLunJian_ScoreFrame_CloseWindow()
	HuaShanLunJian_ScoreFrame_HideWindow()
	PushEvent( "BWTROOPS_SHOW_MINI_BOX" )
end

function HuaShanLunJian_ScoreFrame_HideWindow()
	this:Hide()
end
