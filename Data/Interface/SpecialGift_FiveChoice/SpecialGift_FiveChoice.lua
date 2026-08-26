-- !!!reloadscript =SpecialGift_FiveChoice
local m_Frame_UnifiedXPosition
local m_Frame_UnifiedYPosition

local m_itemId = 0
local m_bagIndex = -1

local m_nSelectIndex = -1

local m_uiTitle;
local m_uiInfo;
local m_uiActionButton = {}
local m_uiActionButtonMask = {}
local m_uiActionText = {}



local m_itemIdList= {}

m_itemIdList[38002676] =  --荒兽魂玉礼盒
{
	Title="#{MJXZ_210510_213}",
	Info="#{MJXZ_210510_214}",
	SelectTips="#{MJXZ_210510_222}",
	ItemData={ [1] = {ItemID=38002520, ItemName="#{MJXZ_210510_215}"}, [2] = {ItemID=38002521, ItemName="#{MJXZ_210510_216}"},
				[3] = {ItemID=38002522, ItemName="#{MJXZ_210510_217}"}, [4] = {ItemID=38002523, ItemName="#{MJXZ_210510_218}"},
				[5] = {ItemID=38002524, ItemName="#{MJXZ_210510_219}"},
			},
}

m_itemIdList[38002677] =  --灵兽魂玉礼盒
{
	Title="#{MJXZ_210510_224}",
	Info="#{MJXZ_210510_225}",
	SelectTips="#{MJXZ_210510_231}",
	ItemData={ [1] = {ItemID=38002525, ItemName="#{MJXZ_210510_226}"}, [2] = {ItemID=38002526, ItemName="#{MJXZ_210510_227}"},
				[3] = {ItemID=38002527, ItemName="#{MJXZ_210510_228}"}, [4] = {ItemID=38002528, ItemName="#{MJXZ_210510_229}"},
				[5] = {ItemID=38002529, ItemName="#{MJXZ_210510_230}"},
			},
}



--预加载函数，可以而且只能在这里注册脚本关心的事件
function SpecialGift_FiveChoice_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function SpecialGift_FiveChoice_OnLoad()
	-- 保存界面的默认相对位置
	m_Frame_UnifiedXPosition	= SpecialGift_FiveChoice_Frame:GetProperty("UnifiedXPosition");
	m_Frame_UnifiedYPosition	= SpecialGift_FiveChoice_Frame:GetProperty("UnifiedYPosition");

	m_uiTitle = SpecialGift_FiveChoice_DragTitle
	m_uiInfo = SpecialGift_FiveChoice_Info
	m_uiActionButton[1] = SpecialGift_FiveChoice_Gift1_Icon
	m_uiActionButton[2] = SpecialGift_FiveChoice_Gift2_Icon
	m_uiActionButton[3] = SpecialGift_FiveChoice_Gift3_Icon
	m_uiActionButton[4] = SpecialGift_FiveChoice_Gift4_Icon
	m_uiActionButton[5] = SpecialGift_FiveChoice_Gift5_Icon
	m_uiActionButtonMask[1] = SpecialGift_FiveChoice_Gift1_Icon_Mask
	m_uiActionButtonMask[2] = SpecialGift_FiveChoice_Gift2_Icon_Mask
	m_uiActionButtonMask[3] = SpecialGift_FiveChoice_Gift3_Icon_Mask
	m_uiActionButtonMask[4] = SpecialGift_FiveChoice_Gift4_Icon_Mask
	m_uiActionButtonMask[5] = SpecialGift_FiveChoice_Gift5_Icon_Mask
	m_uiActionText[1] = SpecialGift_FiveChoice_Gift1_Text
	m_uiActionText[2] = SpecialGift_FiveChoice_Gift2_Text
	m_uiActionText[3] = SpecialGift_FiveChoice_Gift3_Text
	m_uiActionText[4] = SpecialGift_FiveChoice_Gift4_Text
	m_uiActionText[5] = SpecialGift_FiveChoice_Gift5_Text
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function SpecialGift_FiveChoice_ResetPos()
	SpecialGift_FiveChoice_Frame:SetProperty("UnifiedXPosition", m_Frame_UnifiedXPosition);
	SpecialGift_FiveChoice_Frame:SetProperty("UnifiedYPosition", m_Frame_UnifiedYPosition);
end


--响应事件的函数，当注册的事件发生时会调用的函数
function SpecialGift_FiveChoice_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == 89338101) then--
		if m_bagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(m_bagIndex,0)
		end
		local opType = Get_XParam_INT(0)
		if opType == 1 then
			local itemID = Get_XParam_INT(1)
			local bagIndex = Get_XParam_INT(2)
			if (this:IsVisible()) then
				m_itemId = itemID
				m_bagIndex = bagIndex
				SpecialGift_FiveChoice_Update()
				return
			end
			SpecialGift_FiveChoice_Show()
			m_itemId = itemID
			m_bagIndex = bagIndex
			SpecialGift_FiveChoice_Update()
		else
			SpecialGift_FiveChoice_Hide()
		end
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		SpecialGift_FiveChoice_Hide()
	elseif event == "ADJEST_UI_POS" then
		SpecialGift_FiveChoice_ResetPos()
	end
end

--显示UI
function SpecialGift_FiveChoice_Show()
	SpecialGift_FiveChoice_ClearData()
	this:Show()
	
end
--隐藏UI
function SpecialGift_FiveChoice_Hide()

	LifeAbility : Lock_Packet_Item(m_bagIndex,0)
	
	SpecialGift_FiveChoice_ClearData()

	this:Hide()
end

--清除数据
function SpecialGift_FiveChoice_ClearData()
	m_itemId = 0
	m_bagIndex = -1
	m_nSelectIndex = -1
end
--更新
function SpecialGift_FiveChoice_Update()
	if nil == m_itemIdList[m_itemId] then
		return
	end
	LifeAbility : Lock_Packet_Item(m_bagIndex,1)

	local ItemData = m_itemIdList[m_itemId].ItemData
	for index = 1, table.getn(m_uiActionButton) do
		
		local theAction = DataPool:CreateActionItemForShow(ItemData[index].ItemID, 1)
		if theAction:GetID() ~= 0 then
			m_uiActionButton[index]:SetActionItem(theAction:GetID())
			m_uiActionButton[index]:Show()
			m_uiActionText[index]:SetText(ItemData[index].ItemName)
		else
			m_uiActionButton[index]:SetActionItem(-1);
			m_uiActionButton[index]:Hide()
			m_uiActionText[index]:SetText("")
		end
	end
	m_uiTitle:SetText(m_itemIdList[m_itemId].Title)
	m_uiInfo:SetText(m_itemIdList[m_itemId].Info)

	SpecialGift_FiveChoice_UpdateSelectState(0)
end
function SpecialGift_FiveChoice_UpdateSelectState(selectIndex)
	if m_nSelectIndex == selectIndex then
		return
	end
	for index = 1, table.getn(m_uiActionButton) do
		m_uiActionButton[index]:SetPushed(0)
		m_uiActionButtonMask[index]:Hide()
	end
	if selectIndex <= 0 then
		return
	end
	m_uiActionButton[selectIndex]:SetPushed(1)
	m_uiActionButtonMask[selectIndex]:Show()
	m_nSelectIndex = selectIndex
end
--##############点击事件##############
function SpecialGift_FiveChoice_OnClose()
	SpecialGift_FiveChoice_Hide()
end
function SpecialGift_FiveChoice_1_Select(selectIndex)
	SpecialGift_FiveChoice_UpdateSelectState(selectIndex)
end
function SpecialGift_FiveChoice_Confirm()
	if nil == m_itemIdList[m_itemId] then
		return
	end
	if m_bagIndex < 0 then
		PushDebugMessage(m_itemIdList[m_itemId].SelectTips)
		return
	end
	if m_nSelectIndex <= 0 then
		PushDebugMessage(m_itemIdList[m_itemId].SelectTips)
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnItemUse" )
		Set_XSCRIPT_ScriptID( 893381 )
		Set_XSCRIPT_Parameter( 0, m_itemId )
		Set_XSCRIPT_Parameter( 1, m_bagIndex )
		Set_XSCRIPT_Parameter( 2, m_nSelectIndex )
		Set_XSCRIPT_ParamCount( 3 )
	Send_XSCRIPT()
end
--####################################