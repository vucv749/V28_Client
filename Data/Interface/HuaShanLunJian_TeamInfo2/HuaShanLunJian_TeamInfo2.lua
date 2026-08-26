-- 新6v6 战队信息查看

local HuaShanLunJian_TeamInfo2_UndefinedPos = nil
local HuaShanLunJian_TeamInfo2_SelectIndex = -1
local HuaShanLunJian_TeamInfo2_SelectDataIndex = -1
local HuaShanLunJian_TeamInfo2_SelectTeamIndex = -1
local HuaShanLunJian_TeamInfo2_MemberCount = 0
local HuaShanLunJian_TeamInfo2_TransName = 0			-- 转换名字
local HuaShanLunJian_TeamInfo2_BaJianDuanWei = 6		-- 霸剑段位id

local HuaShanLunJian_TeamInfo2_BarList = {}

local HuaShanLunJian_TeamInfo2_MenPaiName =
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
} -- end HuaShanLunJian_TeamInfo2_MenPaiName

local HuaShanLunJian_TeamInfo2_TeamPost =
{
	[0] = {show = 0, icon = "",},										-- 成员
	[1] = {show = 1, icon = "set:Union1 image:Union_MemberIcon_L",},	-- 副队长
	[2] = {show = 1, icon = "set:Union1 image:Union_LeaderIcon_L",},	-- 队长
} -- end HuaShanLunJian_TeamInfo2_TeamPost

local HuaShanLunJian_TeamInfo2_DuanWeiStr =
{
	[1] = "#{HSLJ_190919_145}",
	[2] = "#{HSLJ_190919_146}",
	[3] = "#{HSLJ_190919_147}",
	[4] = "#{HSLJ_190919_148}",
	[5] = "#{HSLJ_190919_149}",
	[6] = "#{HSLJ_190919_157}",
} -- end HuaShanLunJian_TeamInfo2_DuanWeiStr

local HuaShanLunJian_TeamInfo2_DuanWei2Str =
{
	[1] = "#{HSLJ_190919_154}",
	[2] = "#{HSLJ_190919_153}",
	[3] = "#{HSLJ_190919_152}",
	[4] = "#{HSLJ_190919_151}",
	[5] = "#{HSLJ_190919_150}",
} -- end HuaShanLunJian_TeamInfo2_DuanWei2Str


function HuaShanLunJian_TeamInfo2_PreLoad()
	this:RegisterEvent("XBW_TEAMRANK_OPENTEAMUI")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end -- end func HuaShanLunJian_TeamInfo2_PreLoad()

function HuaShanLunJian_TeamInfo2_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_TeamInfo2_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		HuaShanLunJian_TeamInfo2_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED")	 then
		HuaShanLunJian_TeamInfo2_CloseClicked()
	elseif(event == "XBW_TEAMRANK_OPENTEAMUI") then
		HuaShanLunJian_TeamInfo2_OnShow(tonumber(arg0), tonumber(arg1))
	end
end -- end func HuaShanLunJian_TeamInfo2_OnEvent()

function HuaShanLunJian_TeamInfo2_OnLoad()
	-- 保存界面的默认相对位置
	HuaShanLunJian_TeamInfo2_UndefinedPos = HuaShanLunJian_TeamInfo2_Frame:GetProperty("UnifiedPosition")
end -- end func HuaShanLunJian_TeamInfo2_OnLoad()

function HuaShanLunJian_TeamInfo2_ResetPos()
	HuaShanLunJian_TeamInfo2_Frame:SetProperty("UnifiedPosition", HuaShanLunJian_TeamInfo2_UndefinedPos)
end -- end func HuaShanLunJian_TeamInfo2_ResetPos()

--初始化控件数据
function HuaShanLunJian_TeamInfo2_InitUIData(idx, trans)

	HuaShanLunJian_TeamInfo2_part1:SetText("")
	local text = ScriptGlobal_Format("#{JZGN_20230710_29}", 0)
	HuaShanLunJian_TeamInfo2_part2:SetText("#{JZGN_20230710_28}" .. text)

	HuaShanLunJian_TeamInfo2_SelectIndex = -1
	HuaShanLunJian_TeamInfo2_SelectDataIndex = -1
	HuaShanLunJian_TeamInfo2_SelectTeamIndex = idx
	HuaShanLunJian_TeamInfo2_TransName = trans

	-- HuaShanLunJian_TeamInfo2_BarList
	for i = 1, table.getn(HuaShanLunJian_TeamInfo2_BarList) do 
		if HuaShanLunJian_TeamInfo2_BarList[i] ~= nil then
			HuaShanLunJian_TeamInfo2_BarList[i] = nil
		end
	end
	
	HuaShanLunJian_TeamInfo2_ListClient:Clear()
end -- end func HuaShanLunJian_TeamInfo2_InitUIData()

-- 关闭按钮事件
function HuaShanLunJian_TeamInfo2_CloseClicked()
	this:Hide()
end -- end func HuaShanLunJian_TeamInfo2_CloseClicked()

-- 成员列表点击事件
function HuaShanLunJian_TeamInfo2_Clicked(index, dataidx)

	local bar = HuaShanLunJian_TeamInfo2_BarList[index]
	if not bar then
    	return
	end
	
	HuaShanLunJian_TeamInfo2_SelectIndex = index
	HuaShanLunJian_TeamInfo2_SelectDataIndex = dataidx

end -- end func HuaShanLunJian_TeamInfo2_Clicked()

function HuaShanLunJian_TeamInfo2_TransformName(name, zoneid)
	if zoneid < 0 then
		return name
	end

	local retname = name
	if HuaShanLunJian_TeamInfo2_TransName > 0 then
		local selfzoneid = DataPool:GetSelfZoneWorldID()
		if selfzoneid ~= zoneid then
			local serverName = DataPool:GetServerName( zoneid )
			retname = name.."@"..tostring(serverName)
		end
	end

	return retname
end -- end func HuaShanLunJian_TeamInfo2_TransformName()

function HuaShanLunJian_TeamInfo2_OnShow(idx, targetId)

	-- 先初始化一下
	HuaShanLunJian_TeamInfo2_InitUIData(idx, 1)
	-- 填充战队信息
	if 1 == HuaShanLunJian_TeamInfo2_InitMemberListData() then
		this:Show()
	end
	HuaShanLunJian_TeamInfo2_Frame:SetForce()
end -- end func HuaShanLunJian_TeamInfo2_OnShow()

function HuaShanLunJian_TeamInfo2_InitMemberListData()

	local data = NewXBW:GetRankTeamInfo(HuaShanLunJian_TeamInfo2_SelectTeamIndex-1)
	if data == nil or type(data) ~= "table" then
		return -1
	end
	
	local zoneid = data.worldid
	local teamname = data.name
	local memcnt = data.count
	
	local szteamname = ScriptGlobal_Format("#{JZGN_20230710_131}", HuaShanLunJian_TeamInfo2_TransformName(teamname, zoneid))
	HuaShanLunJian_TeamInfo2_part1:SetText("#{JZGN_20230710_162}" .. szteamname)
	

	local szMemTips = ScriptGlobal_Format("#{JZGN_20230710_29}", memcnt)
	HuaShanLunJian_TeamInfo2_part2:SetText("#{JZGN_20230710_28}" .. szMemTips)

	HuaShanLunJian_TeamInfo2_MemberCount = 0
	local memmax = NewXBW:GetTeamMemberCountMax()
	for i=1, memmax, 1 do
		HuaShanLunJian_TeamInfo2_AddMemberItem(HuaShanLunJian_TeamInfo2_SelectTeamIndex, i, zoneid)
	end -- end for

	return 1
end -- end func HuaShanLunJian_TeamInfo2_InitMemberListData()

-- 增加一个成员
function HuaShanLunJian_TeamInfo2_AddMemberItem(teamidx, index, zoneid)
	local data = NewXBW:GetRankMemberInfo(teamidx-1, index-1)
	if data == nil or type(data) ~= "table" then
		return -1
	end
	
	if data.guid <= 0 then
		return -2
	end
	
	local guid = data.guid
	local level = data.level
	local menpai = data.menpai
	local post = data.post
	local duanwei1 = data.dw1
	local duanwei2 = data.dw2
	local dunawei3 = data.dw3
	local name = data.name

	local bar = HuaShanLunJian_TeamInfo2_ListClient:AddChild("HuaShanLunJian_TeamInfo2_List_Frame")
	if not bar then
		return
	end
	-- 成员加上
	HuaShanLunJian_TeamInfo2_MemberCount = HuaShanLunJian_TeamInfo2_MemberCount + 1

	-- 名字
	bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_1"):SetText("#cfff263"..HuaShanLunJian_TeamInfo2_TransformName(name, zoneid))
	
	local leaderButton = bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_Pic")
	local postdata = HuaShanLunJian_TeamInfo2_TeamPost[post]
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
	
	if (HuaShanLunJian_TeamInfo2_MenPaiName[menpai] ~= nil) then
		bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_2"):SetText("#cfff263"..HuaShanLunJian_TeamInfo2_MenPaiName[menpai])
	else
		bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_2"):SetText("")
	end

	if level > 0 then
		bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_3"):SetText("#cfff263"..tostring(level))
	else
		bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_3"):SetText("")
	end
	bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_4"):SetText("")
	if (duanwei1 > 0) then
		if (duanwei1 >= HuaShanLunJian_TeamInfo2_BaJianDuanWei) then
			local duanweiStr = HuaShanLunJian_TeamInfo2_DuanWeiStr[duanwei1]
			if (duanweiStr ~= nil) then
				local xingjieStr = ScriptGlobal_Format("#{HSLJ_190919_389}", dunawei3)
				local str = duanweiStr .. xingjieStr
				bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_4"):SetText(str)
			end
		else
			-- 非霸剑段位 显示段位·阶数
			local duanweiStr = HuaShanLunJian_TeamInfo2_DuanWeiStr[duanwei1]
			local jieshuStr = HuaShanLunJian_TeamInfo2_DuanWei2Str[duanwei2]
			if (duanweiStr ~= nil and jieshuStr ~= nil) then
				local dwText = ScriptGlobal_Format("#{HSLJ_190919_23}", duanweiStr, jieshuStr)
				bar:GetSubItem("HuaShanLunJian_TeamInfo2_List1_4"):SetText(dwText)
			end
		end
	end
	
	bar:SetEvent("MouseLClick", string.format("HuaShanLunJian_TeamInfo2_Clicked(%d, %d)", HuaShanLunJian_TeamInfo2_MemberCount, index))
	
	HuaShanLunJian_TeamInfo2_BarList[HuaShanLunJian_TeamInfo2_MemberCount] = bar
end -- end func HuaShanLunJian_TeamInfo2_AddMemberItem()