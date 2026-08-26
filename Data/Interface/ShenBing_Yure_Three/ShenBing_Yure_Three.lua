-- ShenBing_Yure_Three 神兵预热 任务3 2023-7-21 lishilong
-- !!!reloadscript =ShenBing_Yure_Three
--

local g_ShenBing_Yure_Three_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 0
local bCaredObj 			= 1
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

local g_nUICommandID		= 79110301
local g_tCanInputItemID		= 
{	
	40005131,
	40005132,
	40005133,
}

local g_cActionButton		= {}
local g_cFinishMask			= {}

-- 参数
local g_nNPCScriptID		= -1
local g_tFinishFlags		= {0,0,0}

-- 变量
local g_nInputItemBagPos	= -1
-- 现在全部赋值为1
local g_nInputButtonIndex	= -1

--=========================================================
-- PreLoad
--=========================================================
function ShenBing_Yure_Three_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("YURE_MISSION3_DRAP_INPUT_ITEM")
	this:RegisterEvent("YURE_MISSION3_RCLICK_INPUT_ITEM")
	if 1 == bCaredItem then
		this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	end
	if 1 == bCaredMoney then
		this:RegisterEvent("UNIT_MONEY")
		this:RegisterEvent("MONEYJZ_CHANGE")
	end
	if 1 == bCaredYuanBao then
		this:RegisterEvent("UPDATE_YUANBAO")
	end
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function ShenBing_Yure_Three_OnLoad()
	g_ShenBing_Yure_Three_Frame_UnifiedPosition = ShenBing_Yure_Three_Frame:GetProperty("UnifiedPosition")

	-- ShenBing_Yure_Three_OK_Button : SetEvent("Clicked", "ShenBing_Yure_Three_ConfirmClick()")

	-- g_cActionButton[1] 	= ShenBing_Yure_Three_Item1_Icon
	-- g_cActionButton[2] 	= ShenBing_Yure_Three_Item2_Icon
	-- g_cActionButton[3] 	= ShenBing_Yure_Three_Item3_Icon

	g_cActionButton[1] 	= ShenBing_Yure_Three_Item2_Icon

	-- g_cFinishMask[1] 	= ShenBing_Yure_Three_Item1_Icon_Get
	-- g_cFinishMask[2] 	= ShenBing_Yure_Three_Item2_Icon_Get
	-- g_cFinishMask[3] 	= ShenBing_Yure_Three_Item3_Icon_Get

	g_cFinishMask[1] 	= ShenBing_Yure_Three_Item2_Icon_Get
end

--=========================================================
-- OnEvent
--=========================================================
function ShenBing_Yure_Three_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 关睜, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关睜界面
		if 0 == nOpType then	
			if this:IsVisible() then
				ShenBing_Yure_Three_OnClose()
			end
		end

		-- 打开界面
		if 1 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						ShenBing_Yure_Three_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_ShenBing_Yure_Three()
			end

			-- 显示界面
			-- 为了解决界面被犣挡的问题，先把界面关了
			-- if this:IsVisible() then
			-- 	ShenBing_Yure_Three_OnClose()
			-- end
			ShenBing_Yure_Three_Reset()
			ShenBing_Yure_Three_Frame_On_ResetPos()
			-- 打开背包
			-- OpenWindow("Packet")
			this:Show()
			ShenBing_Yure_Three_ParamInit()
			ShenBing_Yure_Three_MoneyUpdate()
			ShenBing_Yure_Three_YuanBaoUpdate()
			ShenBing_Yure_Three_Update(1)
		end
			
		-- 刷新界面
		if 2 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						ShenBing_Yure_Three_OnClose()
					end
				end
			end
			if this:IsVisible() then
				ShenBing_Yure_Three_ParamInit()
				ShenBing_Yure_Three_Update(0)
			end
		end

		-- 二次确认框
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("ShenBing_Yure_Three_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end

	-- ============================================
	-- 通用逻辑
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关睜界面
			ShenBing_Yure_Three_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			ShenBing_Yure_Three_Update(0)
		end
		
	-- 右键背包道具放入
	elseif event == "YURE_MISSION3_RCLICK_INPUT_ITEM" and this:IsVisible() then
		local nItemBagPos = tonumber(arg0)
		-- PushDebugMessage("YURE_MISSION3_RCLICK_INPUT_ITEM")
		ShenBing_Yure_Three_OnRClickBagItem(nItemBagPos)

	-- 道具拖拽放入
	elseif event == "YURE_MISSION3_DRAP_INPUT_ITEM" and this:IsVisible() then
		local nItemBagPos = tonumber(arg0)
		local nDragButtonIndex = tonumber(arg1)
		-- PushDebugMessage("YURE_MISSION3_DRAP_INPUT_ITEM")
		ShenBing_Yure_Three_OnDragInputItem(nItemBagPos, nDragButtonIndex)

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		ShenBing_Yure_Three_MoneyUpdate()

	-- 元宝改变
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		ShenBing_Yure_Three_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ShenBing_Yure_Three_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		ShenBing_Yure_Three_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenBing_Yure_Three_Frame_On_ResetPos()
	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function ShenBing_Yure_Three_ParamInit()
	g_nNPCScriptID = Get_XParam_INT(2)
	for i = 1, table.getn(g_tFinishFlags) do
		g_tFinishFlags[i] = Get_XParam_INT(2 + i)
	end
end

--=========================================================
-- 道具拖拽放入
--=========================================================
function ShenBing_Yure_Three_OnRClickBagItem(nItemBagPos)
	-- PushDebugMessage("ShenBing_Yure_Three_OnDragInputItem"..",nItemBagPos:"..nItemBagPos..",nDragButtonIndex:"..nDragButtonIndex)

	local nItemTableIndex = PlayerPackage : GetItemTableIndex( nItemBagPos )
	local bCanInputItem = 0
	for i = 1, table.getn(g_tCanInputItemID) do
		if g_tCanInputItemID[i] == nItemTableIndex then
			bCanInputItem = 1
		end
	end
	if 1 ~= bCanInputItem then
		PushDebugMessage("#{SBYR_230707_266}")
		return
	end

	if g_nInputItemBagPos >= 0 then
		LifeAbility : Lock_Packet_Item(g_nInputItemBagPos, 0)
	end

	g_nInputItemBagPos = nItemBagPos
	g_nInputButtonIndex = 1
	LifeAbility : Lock_Packet_Item(g_nInputItemBagPos, 1)

	ShenBing_Yure_Three_Update(0)
end

--=========================================================
-- 道具拖拽放入
--=========================================================
function ShenBing_Yure_Three_OnDragInputItem(nItemBagPos, nDragButtonIndex)
	-- PushDebugMessage("ShenBing_Yure_Three_OnDragInputItem"..",nItemBagPos:"..nItemBagPos..",nDragButtonIndex:"..nDragButtonIndex)

	local nItemTableIndex = PlayerPackage : GetItemTableIndex( nItemBagPos )
	local bCanInputItem = 0
	for i = 1, table.getn(g_tCanInputItemID) do
		if g_tCanInputItemID[i] == nItemTableIndex then
			bCanInputItem = 1
		end
	end
	if 1 ~= bCanInputItem then
		PushDebugMessage("#{SBYR_230707_266}")
		return
	end

	if g_nInputItemBagPos >= 0 then
		LifeAbility : Lock_Packet_Item(g_nInputItemBagPos, 0)
	end

	g_nInputItemBagPos = nItemBagPos
	g_nInputButtonIndex = 1
	LifeAbility : Lock_Packet_Item(g_nInputItemBagPos, 1)

	ShenBing_Yure_Three_Update(0)
end

--=========================================================
-- 右键界面ActionButton
--=========================================================
function ShenBing_Yure_Three_OnRClickActionButton(nButtonIndex)
	ShenBing_Yure_Three_Reset()
	ShenBing_Yure_Three_Update(0)
end

--=========================================================
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
--=========================================================
function ShenBing_Yure_Three_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- 界面更新
--=========================================================
-- !!!reloadscript =ShenBing_Yure_Three
function ShenBing_Yure_Three_Update(bOpen)
	-- 完成控件
	-- for i = 1, table.getn(g_tFinishFlags) do
	-- 	if 1 == g_tFinishFlags[i] then
	-- 		g_cFinishMask[i] : Show()
	-- 	else
	-- 		g_cFinishMask[i] : Hide()
	-- 	end	
	-- end

	-- 清繝所有ActionButton
	for i = 1, table.getn(g_cActionButton) do
		g_cActionButton[i] : SetActionItem(-1)
	end

	-- 显示ActionButton
	if g_nInputButtonIndex > 0 and g_nInputItemBagPos >= 0 then
		local nItemTableIndex = PlayerPackage : GetItemTableIndex( g_nInputItemBagPos )
		local theAction = DataPool : CreateActionItemForShow(nItemTableIndex, 1)
		if nil ~= theAction and 0 ~= theAction:GetID() then
			g_cActionButton[g_nInputButtonIndex] : SetActionItem(theAction:GetID())
		end
	end
end

--=========================================================
-- 重置界面
--=========================================================
function ShenBing_Yure_Three_Reset()
	if g_nInputItemBagPos >= 0 then
		LifeAbility : Lock_Packet_Item(g_nInputItemBagPos, 0)
	end

	g_nInputItemBagPos	= -1
	g_nInputButtonIndex	= -1
end

--=========================================================
-- 界面确认按钮
--=========================================================
function ShenBing_Yure_Three_ConfirmClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnExChangeItemFromClient" )
		Set_XSCRIPT_ScriptID(791103)
		Set_XSCRIPT_Parameter(0, g_nServerObjID)					
		Set_XSCRIPT_Parameter(1, g_nNPCScriptID)				
		Set_XSCRIPT_Parameter(2, g_nInputItemBagPos)				
		Set_XSCRIPT_Parameter(3, g_nInputButtonIndex)				
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--=========================================================
-- 关睜界面
--=========================================================
function ShenBing_Yure_Three_OnClose()	
	this:Hide()
	StopCareObject_ShenBing_Yure_Three()
	-- 重置
	ShenBing_Yure_Three_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="ShenBing_Yure_Three_OnHidden();" />
--=========================================================
function ShenBing_Yure_Three_OnHidden()
	StopCareObject_ShenBing_Yure_Three()
	-- 重置
	ShenBing_Yure_Three_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_ShenBing_Yure_Three()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "ShenBing_Yure_Three")
end

function StopCareObject_ShenBing_Yure_Three()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "ShenBing_Yure_Three")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function ShenBing_Yure_Three_MoneyUpdate()
	-- ShenBing_Yure_Three_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- ShenBing_Yure_Three_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function ShenBing_Yure_Three_YuanBaoUpdate()
	-- ShenBing_Yure_Three_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function ShenBing_Yure_Three_Frame_On_ResetPos()
	ShenBing_Yure_Three_Frame:SetProperty("UnifiedPosition", g_ShenBing_Yure_Three_Frame_UnifiedPosition)
end
