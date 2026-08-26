-- 新6v6 战队信息查看

local HuaShanLunJian_TeamInfo_UndefinedPos = nil
local HuaShanLunJian_TeamInfo_SelectIndex = -1
local HuaShanLunJian_TeamInfo_SelectDataIndex = -1
local HuaShanLunJian_TeamInfo_SelectTeamIndex = -1
local HuaShanLunJian_TeamInfo_MemberCount = 0
local HuaShanLunJian_TeamInfo_TransName = 0			-- 转换名字
local HuaShanLunJian_TeamInfo_BaJianDuanWei = 6		-- 霸剑段位id

local HuaShanLunJian_TeamInfo_BarList = {}

local HuaShanLunJian_TeamInfo_MenPaiName =
{
	[0] = "#{XQ_MP_1}",    	--少林
	[1] = "#{XQ_MP_2}",    	--明教
	[2] = "#{XQ_MP_3}",    	--丐帮
	[3] = "#{XQ_MP_4}",    	--武当
	[4] = "#{XQ_MP_5}",    	--峨眉
	[5] = "#{XQ_MP_6}",    	--星宿
	[6] = "#{XQ_MP_7}",    	--天龙
	[7] = "#{XQ_MP_8}",    	--天山
	[8] = "#{XQ_MP_9}",    	--逍遥
	[9] = "#{JZGN_20230710_138}",	--无门派
	[10] = "#{WCBZ_220809_53}",		--曼陀山庄 
} -- end HuaShanLunJian_TeamInfo_MenPaiName

local HuaShanLunJian_TeamInfo_TeamPost =
{
	[0] = {show = 0, icon = "",},										-- 成员
	[1] = {show = 1, icon = "set:Union1 image:Union_MemberIcon_L",},	-- 副队长
	[2] = {show = 1, icon = "set:Union1 image:Union_LeaderIcon_L",},	-- 队长
} -- end HuaShanLunJian_TeamInfo_TeamPost

local HuaShanLunJian_TeamInfo_DuanWei1Str =
{
	[1] = "#{HSLJ_190919_145}",
	[2] = "#{HSLJ_190919_146}",
	[3] = "#{HSLJ_190919_147}",
	[4] = "#{HSLJ_190919_148}",
	[5] = "#{HSLJ_190919_149}",
	[6] = "#{HSLJ_190919_157}",
} -- end HuaShanLunJian_TeamInfo_DuanWei1Str

local HuaShanLunJian_TeamInfo_DuanWei2Str =
{
	[1] = "#{HSLJ_190919_154}",
	[2] = "#{HSLJ_190919_153}",
	[3] = "#{HSLJ_190919_152}",
	[4] = "#{HSLJ_190919_151}",
	[5] = "#{HSLJ_190919_150}",
} -- end HuaShanLunJian_TeamInfo_DuanWei2Str



function HuaShanLunJian_TeamInfo_PreLoad()
	this:RegisterEvent("XBW_VIEWTEAMINFO_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end -- end func HuaShanLunJian_TeamInfo_PreLoad()

function HuaShanLunJian_TeamInfo_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_TeamInfo_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		HuaShanLunJian_TeamInfo_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED")	 then
		HuaShanLunJian_TeamInfo_CloseClicked()
	elseif(event == "XBW_VIEWTEAMINFO_SHOW") then
		HuaShanLunJian_TeamInfo_OnShow(tonumber(arg0), tonumber(arg1))
	end
end -- end func HuaShanLunJian_TeamInfo_OnEvent()

function HuaShanLunJian_TeamInfo_OnLoad()
	-- 保存界面的默认相对位置
	HuaShanLunJian_TeamInfo_UndefinedPos = HuaShanLunJian_TeamInfo_Frame:GetProperty("UnifiedPosition")
end -- end func HuaShanLunJian_TeamInfo_OnLoad()

function HuaShanLunJian_TeamInfo_ResetPos()
	HuaShanLunJian_TeamInfo_Frame:SetProperty("UnifiedPosition", HuaShanLunJian_TeamInfo_UndefinedPos)
end -- end func HuaShanLunJian_TeamInfo_ResetPos()

--初始化控件数据
function HuaShanLunJian_TeamInfo_InitUIData(idx, trans)

	HuaShanLunJian_TeamInfo_part1:SetText("")
	local text = ScriptGlobal_Format("#{JZGN_20230710_29}", 0)
	HuaShanLunJian_TeamInfo_part2:SetText("#{JZGN_20230710_28}" .. text)

	HuaShanLunJian_TeamInfo_SelectIndex = -1
	HuaShanLunJian_TeamInfo_SelectDataIndex = -1
	HuaShanLunJian_TeamInfo_SelectTeamIndex = idx
	HuaShanLunJian_TeamInfo_TransName = trans

	-- HuaShanLunJian_TeamInfo_BarList
	for i = 1, table.getn(HuaShanLunJian_TeamInfo_BarList) do 
		if HuaShanLunJian_TeamInfo_BarList[i] ~= nil then
			HuaShanLunJian_TeamInfo_BarList[i] = nil
		end
	end
	
	HuaShanLunJian_TeamInfo_ListClient:Clear()
end -- end func HuaShanLunJian_TeamInfo_InitUIData()

-- 关闭按钮事件
function HuaShanLunJian_TeamInfo_CloseClicked()
	this:Hide()
end -- end func HuaShanLunJian_TeamInfo_CloseClicked()

-- 设为私聊按钮事件
function HuaShanLunJian_TeamInfo_PrivateChat_Clicked()
	if HuaShanLunJian_TeamInfo_SelectDataIndex < 0 then
		return
	end

	local level, menpai, post, duanwei1, duanwei2, dunawei3, name = NewXBW:GetViewTeamMemberInfo(HuaShanLunJian_TeamInfo_SelectTeamIndex, HuaShanLunJian_TeamInfo_SelectDataIndex-1)
	if post == nil or level <= 0 then
		return --没有数据
	end

	
	Talk:ContexMenuTalk(name)
end -- end func HuaShanLunJian_TeamInfo_PrivateChat_Clicked()

-- 查看资料按钮事件
function HuaShanLunJian_TeamInfo_ViewInfo_Clicked()
	if HuaShanLunJian_TeamInfo_SelectDataIndex < 0 then
		return
	end

	local level, menpai, post, duanwei1, duanwei2, dunawei3, name = NewXBW:GetViewTeamMemberInfo(HuaShanLunJian_TeamInfo_SelectTeamIndex, HuaShanLunJian_TeamInfo_SelectDataIndex-1)
	if post == nil or level <= 0 then
		return --没有数据
	end
	
	if Friend:IsPlayerIsFriend(name) == 1  then
		DataPool:ShowFriendInfo(name)
	else
		DataPool:ShowChatInfo(name)
	end
end -- end func HuaShanLunJian_TeamInfo_ViewInfo_Clicked()

-- 成员列表点击事件
function HuaShanLunJian_TeamInfo_Clicked(index, dataidx)

	local bar = HuaShanLunJian_TeamInfo_BarList[index]
	if not bar then
    	return
	end
	
	HuaShanLunJian_TeamInfo_SelectIndex = index
	HuaShanLunJian_TeamInfo_SelectDataIndex = dataidx

	if HuaShanLunJian_TeamInfo_SelectIndex >= 0 then
		HuaShanLunJian_TeamInfo_Look:Enable()
    	HuaShanLunJian_TeamInfo_Talk:Enable()
	end
end -- end func HuaShanLunJian_TeamInfo_Clicked()

function HuaShanLunJian_TeamInfo_TransformName(name, zoneid)
	if zoneid < 0 then
		return name
	end

	local retname = name
	if HuaShanLunJian_TeamInfo_TransName > 0 then
		local selfzoneid = DataPool:GetSelfZoneWorldID()
		if selfzoneid ~= zoneid then
			local serverName = DataPool:GetServerName( zoneid )
			retname = name.."@"..tostring(serverName)
		end
	end

	return retname
end -- end func HuaShanLunJian_TeamInfo_TransformName()

function HuaShanLunJian_TeamInfo_OnShow(idx, trans)
	-- local debugMsg = string.format("debug, TeamInfo, %d, %d", idx, trans)
	-- PushDebugMessage(debugMsg)

	-- 先初始化一下
	HuaShanLunJian_TeamInfo_InitUIData(idx, trans)
	-- 填充战队信息
	if 1 == HuaShanLunJian_TeamInfo_InitMemberListData() then
		this:Show()
	end
end -- end func HuaShanLunJian_TeamInfo_OnShow()

function HuaShanLunJian_TeamInfo_InitMemberListData()
	local teamid, memcnt, zoneid, teamname, teamleadername = NewXBW:GetTeamListInfo(HuaShanLunJian_TeamInfo_SelectTeamIndex)
	if teamid == nil or teamid < 0 then
		return -1
	end

	local szteamname = ScriptGlobal_Format("#{JZGN_20230710_131}", HuaShanLunJian_TeamInfo_TransformName(teamname, zoneid))
	HuaShanLunJian_TeamInfo_part1:SetText("#{JZGN_20230710_162}" .. szteamname)
	

	local szMemTips = ScriptGlobal_Format("#{JZGN_20230710_29}", memcnt)
	HuaShanLunJian_TeamInfo_part2:SetText("#{JZGN_20230710_28}" .. szMemTips)

	HuaShanLunJian_TeamInfo_MemberCount = 0
	local memmax = NewXBW:GetTeamMemberCountMax()
	for i=1, memmax, 1 do
		HuaShanLunJian_TeamInfo_AddMemberItem(HuaShanLunJian_TeamInfo_SelectTeamIndex, i, zoneid)
	end -- end for

	--控制显示操作按钮
	if HuaShanLunJian_TeamInfo_SelectIndex < 0 then
		HuaShanLunJian_TeamInfo_Look:Disable()
    	HuaShanLunJian_TeamInfo_Talk:Disable()
	end

	return 1
end -- end func HuaShanLunJian_TeamInfo_InitMemberListData()

-- 增加一个成员
function HuaShanLunJian_TeamInfo_AddMemberItem(teamidx, index, zoneid)
	local level, menpai, post, duanwei1, duanwei2, dunawei3, name = NewXBW:GetViewTeamMemberInfo(teamidx, index-1)
	if post == nil or level <= 0 then
		return -- 没有数据
	end
	
	local bar = HuaShanLunJian_TeamInfo_ListClient:AddChild("HuaShanLunJian_TeamInfo_List_Frame")
	if not bar then
    	return
	end
	-- 成员加上
	HuaShanLunJian_TeamInfo_MemberCount = HuaShanLunJian_TeamInfo_MemberCount + 1

	-- 名字
	bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_1"):SetText("#cfff263" .. HuaShanLunJian_TeamInfo_TransformName(name, zoneid))
	
	local leaderButton = bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_Pic")
	local postdata = HuaShanLunJian_TeamInfo_TeamPost[post]
	if postdata == nil then
		leaderButton:Hide()
	else
		if postdata.show > 0 then
			leaderButton:SetProperty("Image", postdata.icon)
			leaderButton:Show()
		else
			leaderButton:Hide()
		end
	end
	
	if (HuaShanLunJian_TeamInfo_MenPaiName[menpai] ~= nil) then
		bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_2"):SetText("#cfff263" .. HuaShanLunJian_TeamInfo_MenPaiName[menpai])
	else
		bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_2"):SetText("")
	end
	bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_3"):SetText("#cfff263" .. tostring(level))

	bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_4"):SetText("")
	if (duanwei1 > 0) then
		if (duanwei1 >= HuaShanLunJian_TeamInfo_BaJianDuanWei) then
			-- 霸剑段位 显示霸剑·星数	
			local duanweiStr = HuaShanLunJian_TeamInfo_DuanWei1Str[duanwei1]
			if (duanweiStr ~= nil) then
				local xingjieStr = ScriptGlobal_Format("#{HSLJ_190919_389}", dunawei3)
				local str = "#cfff263" .. duanweiStr .. xingjieStr
				bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_4"):SetText(str)
			end
		else
			-- 非霸剑段位 显示段位·阶数
			local duanweiStr = HuaShanLunJian_TeamInfo_DuanWei1Str[duanwei1]
			local jieshuStr = HuaShanLunJian_TeamInfo_DuanWei2Str[duanwei2]
			if (duanweiStr ~= nil and jieshuStr ~= nil) then
				local dwText = ScriptGlobal_Format("#{HSLJ_190919_23}", duanweiStr, jieshuStr)
				bar:GetSubItem("HuaShanLunJian_TeamInfo_List1_4"):SetText(dwText)
			end
		end
	end
	
	bar:SetEvent("MouseLClick", string.format("HuaShanLunJian_TeamInfo_Clicked(%d, %d)", HuaShanLunJian_TeamInfo_MemberCount, index))
	
	HuaShanLunJian_TeamInfo_BarList[HuaShanLunJian_TeamInfo_MemberCount] = bar
end -- end func HuaShanLunJian_TeamInfo_AddMemberItem()