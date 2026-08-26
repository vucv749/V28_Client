-- 战队信息查看
local g_unifiedposistion
local g_BarList = {}
local g_SelectIndex = -1
local g_selectdataidx = -1
local g_selectTeamIdx = -1
local g_memcount = 0
local g_trasname = 0			-- 转换名字
local g_MenPaiNameList =
{
	[0]  ="#{WCBZ_180128_59}",	--少林
	[1]  ="#{WCBZ_180128_65}",	--明教
	[2]  ="#{WCBZ_180128_67}",	--丐帮
	[3]  ="#{WCBZ_180128_61}",	--武当
	[4]  ="#{WCBZ_180128_68}",	--峨嵋
	[5]  ="#{WCBZ_180128_66}",	--星宿
	[6]  ="#{WCBZ_180128_60}",	--天龙
	[7]  ="#{WCBZ_180128_63}",	--天山
	[8]  ="#{WCBZ_180128_64}",	--逍遥
	[9]  ="#{WCBZ_180128_57}",	--无门派
	[10] ="#{WCBZ_180128_62}",	--慕容
}

local g_teampost = {
	[0] = {show = 0, icon = "",},									-- 成员
	[1] = {show = 1, icon = "set:Union1 image:Union_MemberIcon_L",},-- 副队长
	[2] = {show = 1, icon = "set:Union1 image:Union_LeaderIcon_L",},-- 副队长
}

function NoDiffMatch_TeamInfo_PreLoad()
	this:RegisterEvent("ZBS_VIEWTEAMINFO_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function NoDiffMatch_TeamInfo_OnLoad()
	-- 保存界面的默认相对位置
	g_unifiedposistion = NoDiffMatch_TeamInfo_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_TeamInfo_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		NoDiffMatch_TeamInfo_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		NoDiffMatch_TeamInfo_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED")	 then
		NoDiffMatch_TeamInfo_CloseClicked()
	elseif(event == "ZBS_VIEWTEAMINFO_SHOW") then
		NoDiffMatch_TeamInfo_OnShow(tonumber(arg0), tonumber(arg1))
	end

end

function NoDiffMatch_TeamInfo_OnShow(idx, trans)
	--先初始化一下
	NoDiffMatch_TeamInfo_InitUIData(idx, trans)
	--填充战队信息
	if 1 == NoDiffMatch_TeamInfo_InitMemberListData() then
		this:Show()
	end
end

--初始化控件数据
function NoDiffMatch_TeamInfo_InitUIData(idx, trans)

	NoDiffMatch_TeamInfo_part1:SetText("")
	local text = ScriptGlobal_Format("#{WCBZ_180128_515}", 0 )
	NoDiffMatch_TeamInfo_part2:SetText(text)

	g_SelectIndex = -1
	g_selectdataidx = -1
	g_selectTeamIdx = idx
	g_trasname = trans

	--g_BarList
	for i = 1, table.getn(g_BarList) do 
		if g_BarList[i] ~= nil then
			g_BarList[i] = nil
		end
	end
	
	NoDiffMatch_TeamInfo_ListClient:Clear()
end

--!!!reloadscript =NoDiffMatch_TeamInfo
function NoDiffMatch_TeamInfo_InitMemberListData()

	local teamid, teamname, teamleadername, memcnt, zoneid = ZBS:GetTeamListInfo(g_selectTeamIdx)
	if teamid == nil or teamid < 0 then
		return -1
	end

	
	local szteamname = ScriptGlobal_Format("#{WCBZ_180128_514}", NoDiffMatch_TeamInfo_TransformName(teamname, zoneid) )
	NoDiffMatch_TeamInfo_part1:SetText( szteamname )
	

	local szMemTips = ScriptGlobal_Format("#{WCBZ_180128_515}", memcnt )
	NoDiffMatch_TeamInfo_part2:SetText(szMemTips)

	g_memcount = 0
	local memmax = ZBS:GetTeamMemberCountMax()
	for i=1, memmax do
		NoDiffMatch_TeamInfo_AddMemberItem( g_selectTeamIdx, i, zoneid )
	end

	--控制显示操作按钮
	if g_SelectIndex < 0 then
		NoDiffMatch_TeamInfo_Look:Disable()
    	NoDiffMatch_TeamInfo_Talk:Disable()
	end

	return 1
end

--增加一个成员
function NoDiffMatch_TeamInfo_AddMemberItem( teamidx, index, zoneid )
	local level, menpai, post, name = ZBS:GetViewTeamInfo(teamidx, index-1)
	if post == nil or level <= 0 then
		return --没有数据
	end
	
	local bar = NoDiffMatch_TeamInfo_ListClient:AddChild("NoDiffMatch_TeamInfo_List_Frame")
	if not bar then
    	return
	end
	-- 成员加上
	g_memcount = g_memcount + 1

	--名字
	bar:GetSubItem("NoDiffMatch_TeamInfo_List1_1"):SetText(NoDiffMatch_TeamInfo_TransformName(name, zoneid))
	
	local leaderButton = bar:GetSubItem("NoDiffMatch_TeamInfo_List1_Pic")
	local postdata = g_teampost[post]
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
			
	bar:GetSubItem("NoDiffMatch_TeamInfo_List1_2"):SetText(g_MenPaiNameList[menpai])
	bar:GetSubItem("NoDiffMatch_TeamInfo_List1_3"):SetText(tostring(level))
	
	bar:SetEvent("MouseLClick", string.format("NoDiffMatch_TeamInfo_Clicked(%d, %d)", g_memcount, index))
	
	g_BarList[g_memcount] = bar
end

function NoDiffMatch_TeamInfo_Clicked(index, dataidx)

	local bar = g_BarList[index]
	if not bar then
    	return
	end
	
	g_SelectIndex = index
	g_selectdataidx = dataidx

	if g_SelectIndex >= 0 then
		NoDiffMatch_TeamInfo_Look:Enable()
    	NoDiffMatch_TeamInfo_Talk:Enable()
	end
end

function NoDiffMatch_TeamInfo_PrivateChat_Clicked()
	if g_selectdataidx < 0 then
		return
	end

	local level, menpai, post, name = ZBS:GetViewTeamInfo(g_selectTeamIdx, g_selectdataidx-1)
	if post == nil or level <= 0 then
		return --没有数据
	end

	
	Talk:ContexMenuTalk(name)
end

function NoDiffMatch_TeamInfo_ViewInfo_Clicked()
	if g_selectdataidx < 0 then
		return
	end

	local level, menpai, post, name = ZBS:GetViewTeamInfo(g_selectTeamIdx, g_selectdataidx-1)
	if post == nil or level <= 0 then
		return --没有数据
	end
	
	if Friend:IsPlayerIsFriend(name) == 1  then
		DataPool:ShowFriendInfo(name)
	else
		DataPool:ShowChatInfo(name)
	end
end

function NoDiffMatch_TeamInfo_TransformName(name, zoneid)
	if zoneid < 0 then
		return name
	end

	local retname = name
	if g_trasname > 0 then
		local selfzoneid = DataPool:GetSelfZoneWorldID()
		if selfzoneid ~= zoneid then
			local serverName = DataPool:GetServerName( zoneid )
			retname = name.."@"..tostring(serverName)
		end
	end

	return retname
end

--================================================
--关闭
--================================================
function NoDiffMatch_TeamInfo_CloseClicked()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_TeamInfo_ResetPos()
	NoDiffMatch_TeamInfo_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

