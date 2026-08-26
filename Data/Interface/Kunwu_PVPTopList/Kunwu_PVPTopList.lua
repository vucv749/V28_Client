-- 雪人大作战，个人榜单界面
local g_unifiedposistion

local g_ui_list = {}

local g_camp_info = 
{
	{name="#{ZSYC_241211_146}",},
	{name="#{ZSYC_241211_147}",},
	{name="#{ZSYC_241211_148}",},
	{name="#{ZSYC_241211_146}",},
}
function Kunwu_PVPTopList_PreLoad()
	this:RegisterEvent("PETPVP_UI_BATTLERANK_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function Kunwu_PVPTopList_OnLoad()

	g_ui_list = {}
	-- 保存界面的默认相对位置
	g_unifiedposistion = Kunwu_PVPTopList_Frame:GetProperty("UnifiedPosition")
end

function Kunwu_PVPTopList_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		Kunwu_PVPTopList_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Kunwu_PVPTopList_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED")	 then
		Kunwu_PVPTopList_CloseClick()
	elseif (event == "PETPVP_UI_BATTLERANK_SHOW") then
		Kunwu_PVPTopList_OnShow()
	end
end

function Kunwu_PVPTopList_OnShow()

	local ret = Kunwu_PVPTopList_InitUIData()
	if ret > 0 then
		this:Show()
	else
		this:Hide()
	end
end

-- 初始化控件数据
function Kunwu_PVPTopList_InitUIData()

	Kunwu_PVPTopList_List:RemoveAllItem()

	local playerindex = PETPVP:GetBattlePlayerRankInfo("myindex")
	local playerData = PETPVP:GetBattlePlayerRankInfo("info", playerindex)
	if playerData == nil or type(playerData) ~= "table" then
		this:Hide()
		return -1
	end

	local strKill = ScriptGlobal_Format("#{BXDZ_240918_255}", playerData.kill)
	Kunwu_PVPTopList_My:SetText(strKill)
	
	-- 刷新榜单信息
	local playerCount = PETPVP:GetBattlePlayerRankInfo("num")
	if (playerCount > 0) then
		local listIndex = 0
		for i=1, playerCount, 1 do
			local data = PETPVP:GetBattlePlayerRankInfo("info", listIndex)
			if data ~= nil and type(data) == "table" then
				local strName = Kunwu_PVPTopList_TransformName(data.name, data.world)
				local strCamp = Kunwu_PVPTopList_GetCampName(data.team+1)
				Kunwu_PVPTopList_List:AddNewItem("#cfff263"..tostring(listIndex+1), 0, listIndex)
				Kunwu_PVPTopList_List:AddNewItem("#cfff263"..strName, 1, listIndex)
				Kunwu_PVPTopList_List:AddNewItem("#cfff263"..strCamp, 2, listIndex)
				Kunwu_PVPTopList_List:AddNewItem("#cfff263"..tostring(data.kill), 3, listIndex)

				listIndex = listIndex + 1
			end
		end
	end
	
	return 1
end

function Kunwu_PVPTopList_TransformName(name, zoneid)
	if zoneid < 0 then
		return name
	end

	local retname = name
	if zoneid > 0 then
		local serverName = DataPool:GetServerName( zoneid )
		retname = name.."@"..tostring(serverName)
	end

	return retname
end


function Kunwu_PVPTopList_GetCampName(campIndex)
	local data = g_camp_info[campIndex]
	if data == nil then
		return "???"
	end
	
	return data.name
end

--================================================
-- 关闭
--================================================
function Kunwu_PVPTopList_CloseClick()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Kunwu_PVPTopList_ResetPos()
	Kunwu_PVPTopList_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end