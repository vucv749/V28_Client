-- 玩家血条积分UI
--
local g_unifiedposistion
local g_istimerset			= 0
local g_ui_list				= {}		-- ui集合
local g_data_list			= {}		-- 数据集合，每次一清
local g_memcount_max		= 12		-- 队员总数
local g_teammem_max			= 6			-- 单队伍最大人数
local g_othercolor			= {			-- 其他状态颜色
	lose = "#ccccccc",					-- 掉线
	die = "#cff0000",					-- 死亡
}

local g_menpaiinfo			= {
	[0]  ={name="#{WCBZ_180128_59}",color="#cff6600"},	--少林
	[1]  ={name="#{WCBZ_180128_65}",color="#cffcc00"},	--明教
	[2]  ={name="#{WCBZ_180128_67}",color="#c00ff00"},	--丐帮
	[3]  ={name="#{WCBZ_180128_61}",color="#c0000ff"},	--武当
	[4]  ={name="#{WCBZ_180128_68}",color="#cff99cc"},	--峨嵋
	[5]  ={name="#{WCBZ_180128_66}",color="#c007700"},	--星宿
	[6]  ={name="#{WCBZ_180128_60}",color="#cffff00"},	--天龙
	[7]  ={name="#{WCBZ_180128_63}",color="#cffffff"},	--天山
	[8]  ={name="#{WCBZ_180128_64}",color="#c7700ff"},	--逍遥
	[9]  ={name="#{WCBZ_180128_57}",color="#c999999"},	--无门派
	[10] ={name="#{WCBZ_180128_62}",color="#cffffb3"},	--曼陀
}
local g_battle_type			= {
	fstblood_A = 1,						-- 队伍A一血
	fstblood_B = 2,						-- 队伍B一血
	teamwin_none = 0,					-- 无结果
	teamwin_A = 1,						-- 队伍A赢
	teamwin_B = 2,						-- 队伍B赢
	battle_final = 3,					-- 比赛类型
}

local g_image				= {
	win = "set:Wangzhe1 image:Wangzhe_sheng",
	lose = "set:Wangzhe2 image:Wangzhe_fu",
	score = {
		[1] = "set:OB image:+1",
		[2] = "set:OB image:+2",
	},
}

local g_teampost = {
	[0] = {show = 0, icon = "",},									-- 成员
	[1] = {show = 1, icon = "set:Union1 image:Union_MemberIcon_L",},-- 副队长
	[2] = {show = 1, icon = "set:Union1 image:Union_LeaderIcon_L",},-- 副队长
}

function NoDiffMatch_ResultShow_PreLoad()
	this:RegisterEvent("ZBS_BATTLE_RESULT",true)
	this:RegisterEvent("ZBS_BATTLE_SCORE",false)
	this:RegisterEvent("ZBS_BATTLE_CLOSEUI",false)
	this:RegisterEvent("ZBS_BATTLE_SHOW",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function NoDiffMatch_ResultShow_OnLoad()

	local _prefix_l = "NoDiffMatch_ResultShow_Left_"
	local _prefix_r = "NoDiffMatch_ResultShow_Right_"
	local makeGroup = function(prefix,name,mp,leader,kill)
		return {
			["name"] = _G[prefix..name],
			["mp"] = _G[prefix..mp],
			["leader"] = _G[prefix..leader],
			["kill"] = _G[prefix..kill],
		}
	end
	-- 队伍信息控件列表初始化
	g_ui_list = {
		makeGroup(_prefix_l, "1_name","1_Career","1_Icon","1_Level"),
		makeGroup(_prefix_l, "2_name","2_Career","2_Icon","2_Level"),
		makeGroup(_prefix_l, "3_name","3_Career","3_Icon","3_Level"),
		makeGroup(_prefix_l, "4_name","4_Career","4_Icon","4_Level"),
		makeGroup(_prefix_l, "5_name","5_Career","5_Icon","5_Level"),
		makeGroup(_prefix_l, "6_name","6_Career","6_Icon","6_Level"),

		makeGroup(_prefix_r, "1_name","1_Career","1_Icon","1_Level"),
		makeGroup(_prefix_r, "2_name","2_Career","2_Icon","2_Level"),
		makeGroup(_prefix_r, "3_name","3_Career","3_Icon","3_Level"),
		makeGroup(_prefix_r, "4_name","4_Career","4_Icon","4_Level"),
		makeGroup(_prefix_r, "5_name","5_Career","5_Icon","5_Level"),
		makeGroup(_prefix_r, "6_name","6_Career","6_Icon","6_Level"),
	}

	g_unifiedposistion	= NoDiffMatch_ResultShow_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_ResultShow_OnEvent(event)
	if event == "ZBS_BATTLE_RESULT" then
		NoDiffMatch_ResultShow_OnShow()
	elseif event == "ZBS_BATTLE_SCORE" then
		NoDiffMatch_ResultShow_RefreshScoreUI()
	elseif event == "ADJEST_UI_POS" then
		NoDiffMatch_ResultShow_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NoDiffMatch_ResultShow_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		NoDiffMatch_ResultShow_Close_Clicked()
	elseif event == "ZBS_BATTLE_SHOW" then
		NoDiffMatch_ResultShow_Close_Clicked()
	elseif event == "ZBS_BATTLE_CLOSEUI" then
		NoDiffMatch_ResultShow_Close_Clicked()
	end
end

--================================================
-- 显示信息
--================================================
function NoDiffMatch_ResultShow_OnShow()
	if GMVisible:LuaFnGetViewType() > 0 then
		return
	end
	NoDiffMatch_ResultShow_InitData()
	NoDiffMatch_ResultShow_InitOtherUI()
	NoDiffMatch_ResultShow_RefreshUI()
	this:Show()
end

function NoDiffMatch_ResultShow_InitOtherUI()
	NoDiffMatch_ResultShow_Team_Left:SetText("")
	NoDiffMatch_ResultShow_Team_Right:SetText("")
	NoDiffMatch_ResultShow_Team1FirstKill:Hide()
	NoDiffMatch_ResultShow_Team2FirstKill:Hide()
	NoDiffMatch_ResultShow_LiftPic:Hide()
	NoDiffMatch_ResultShow_RightPic:Hide()
	NoDiffMatch_ResultShow_TitleBK:Hide()
	NoDiffMatch_ResultShow_TitleBK1:Hide()
end

function NoDiffMatch_ResultShow_InitData()
	g_data_list = {}
	for i=1, g_memcount_max do
		g_data_list[i] = {}
		g_data_list[i].name = ""
		g_data_list[i].mp = 9
		g_data_list[i].lv = -1
		g_data_list[i].hp = 1
		g_data_list[i].guid = -1
	end
end

--================================================
-- 刷一遍信息
--================================================
function NoDiffMatch_ResultShow_RefreshUI()
	NoDiffMatch_ResultShow_RefreshTeamUI()
	NoDiffMatch_ResultShow_RefreshMemberUI()
	NoDiffMatch_ResultShow_RefreshScoreUI()
end

--================================================
-- 刷一遍队伍信息
--================================================
function NoDiffMatch_ResultShow_RefreshTeamUI()
	local fstblood,lefttime,result,teamname_a,teamname_b = ZBS:GetBattleTeamInfo()
	if fstblood < 0 then
		NoDiffMatch_ResultShow_InitOtherUI()
	else
		-- 名字
		NoDiffMatch_ResultShow_Team_Left:SetText(teamname_a)
		NoDiffMatch_ResultShow_Team_Right:SetText(teamname_b)
		-- 一血
		NoDiffMatch_ResultShow_Team1FirstKill:Hide()
		NoDiffMatch_ResultShow_Team2FirstKill:Hide()
		if fstblood == g_battle_type.fstblood_A then
			NoDiffMatch_ResultShow_Team1FirstKill:Show()
		elseif fstblood == g_battle_type.fstblood_B then
			NoDiffMatch_ResultShow_Team2FirstKill:Show()
		end
		if result == g_battle_type.teamwin_A then
			NoDiffMatch_ResultShow_LiftPic:SetProperty("Image" , g_image.win)
			NoDiffMatch_ResultShow_RightPic:SetProperty("Image" , g_image.lose)
		elseif result == g_battle_type.teamwin_B then
			NoDiffMatch_ResultShow_LiftPic:SetProperty("Image" , g_image.lose)
			NoDiffMatch_ResultShow_RightPic:SetProperty("Image" , g_image.win)
		elseif result == g_battle_type.teamwin_none then
			NoDiffMatch_ResultShow_LiftPic:SetProperty("Image" , g_image.lose)
			NoDiffMatch_ResultShow_RightPic:SetProperty("Image" , g_image.lose)
		end
		
		NoDiffMatch_ResultShow_LiftPic:Show()
		NoDiffMatch_ResultShow_RightPic:Show()
	end
end

--================================================
-- 刷一遍成员信息
--================================================
function NoDiffMatch_ResultShow_RefreshMemberUI()
	for i=1, g_memcount_max do
		if g_ui_list[i] ~= nil then
			local lv,hp,mp,killnum,post,name = ZBS:GetBattleMemberInfo(i-1)
			-- 说明当前索引玩家不存在
			if lv <= 0 then
				g_ui_list[i].name:SetText("")
				g_ui_list[i].mp:SetText("")
				g_ui_list[i].kill:SetText("")
				g_ui_list[i].leader:Hide()
			else
				-- 名字
				local szname = NoDiffMatch_ResultShow_TransformName(name, i-1)
				g_ui_list[i].name:SetText(szname)
				-- 击杀数
				g_ui_list[i].kill:SetText(tostring(killnum))
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
			end
		end
	end
end

--================================================
-- 刷一遍比赛分数
--================================================
function NoDiffMatch_ResultShow_RefreshScoreUI()
	local battletype = ZBS:GetBattleType()
	if battletype ~= nil and battletype == g_battle_type.battle_final then
		local data = ZBS:GetTeamScore()
		if data ~= nil and type(data) == "table" then
			if data.add_a ~= nil and g_image.score[data.add_a] ~= nil then
				NoDiffMatch_ResultShow_TitleBK:SetProperty("Image", g_image.score[data.add_a])
				NoDiffMatch_ResultShow_TitleBK:Show()
			else
				NoDiffMatch_ResultShow_TitleBK:Hide()
			end
			if data.add_b ~= nil and g_image.score[data.add_b] ~= nil then
				NoDiffMatch_ResultShow_TitleBK1:SetProperty("Image", g_image.score[data.add_b])
				NoDiffMatch_ResultShow_TitleBK1:Show()
			else
				NoDiffMatch_ResultShow_TitleBK1:Hide()
			end
			local scoreStr = "#cfff263"..tostring(data.score_a)..":"..tostring(data.score_b)
			NoDiffMatch_ResultShow_Team_TitleBK:SetText(scoreStr)
			NoDiffMatch_ResultShow_Team_TitleBK:Show()
			NoDiffMatch_ResultShow_Team_VS:Hide()
		else
			NoDiffMatch_ResultShow_TitleBK:Hide()
			NoDiffMatch_ResultShow_TitleBK1:Hide()
			NoDiffMatch_ResultShow_Team_TitleBK:Hide()
			NoDiffMatch_ResultShow_Team_VS:Show()
		end
	else
		NoDiffMatch_ResultShow_TitleBK:Hide()
		NoDiffMatch_ResultShow_TitleBK1:Hide()
		NoDiffMatch_ResultShow_Team_VS:Show()
		NoDiffMatch_ResultShow_Team_TitleBK:Hide()
	end
end

--================================================
-- 转换名字
--================================================
function NoDiffMatch_ResultShow_TransformName(name, idx)
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
function NoDiffMatch_ResultShow_ResetPos()
	NoDiffMatch_ResultShow_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

--================================================
-- 关闭界面
--================================================
function NoDiffMatch_ResultShow_Close_Clicked()
	this:Hide()
end