-- 2023Q2版本稳活-束脩之礼
-- 二选一礼盒界面
-- !!!reloadscript =ShuYou_DressBox

local g_UnifiedPosition = nil
local g_ItemId1 = 10125147
local g_ItemId2 = 10125150

--===============================================
-- PreLoad()
--===============================================
function ShuYou_DressBox_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function ShuYou_DressBox_OnLoad()
	g_UnifiedPosition = ShuYou_DressBox_Frame_BK:GetProperty("UnifiedPosition")	
end

--===============================================
-- OnEvent()
--===============================================
function ShuYou_DressBox_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99827001) then
		local flag = Get_XParam_INT(0)
		if flag == nil or flag <= 0 then
			-- 关界面	
			if this:IsVisible() then
				ShuYou_DressBox_Close()
			end
		else
			-- 开界面
			this:Show()
			ShuYou_DressBox_Open()
		end
	elseif (event == "ADJEST_UI_POS") then
		ShuYou_DressBox_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShuYou_DressBox_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShuYou_DressBox_Close()
	end
end

--===============================================
-- 重置
--===============================================
function ShuYou_DressBox_ResetPos()
	ShuYou_DressBox_Frame_BK:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- 清数据
--===============================================
function ShuYou_DressBox_OnHidden()
end

--===============================================
-- 关界面
--===============================================
function ShuYou_DressBox_Close()
	--数据清繝
	ShuYou_DressBox_OnHidden()
	--隐藏界面
	this:Hide()
end

--===============================================
-- 开界面
--===============================================
function ShuYou_DressBox_Open()
	local theAction1 = DataPool:CreateBindActionItemForShow(g_ItemId1, 1)
	if theAction1:GetID() ~= 0 then
		ShuYou_DressBox_Item1:SetActionItem(theAction1:GetID())
	end	
	local theAction2 = DataPool:CreateBindActionItemForShow(g_ItemId2, 1)
	if theAction2:GetID() ~= 0 then
		ShuYou_DressBox_Item2:SetActionItem(theAction2:GetID())
	end
end

--===============================================
-- 领奖
--===============================================
function ShuYou_DressBox_ItemGet_Clicked(nIndex)
	if nIndex == nil or nIndex < 1 or nIndex > 2 then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetPrize")
		Set_XSCRIPT_ScriptID(998270)
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_Parameter(1,0)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--===============================================
-- 小问号
--===============================================
function ShuYou_DressBox_Help()
	PushEvent("CCSHOP_HELP", 15)
end
