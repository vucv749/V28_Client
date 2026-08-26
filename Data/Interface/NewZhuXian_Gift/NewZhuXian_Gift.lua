-- NewZhuXian_Gift 

local g_NewZhuXian_Gift_Frame_UnifiedPosition

local g_nComfirmParam1		= 0

local g_nUICommandID		= 89017401
local g_nUIComfirmCommandID	= 89017402

local g_nUseItemBagPos		= -1
local g_nUseTime = 0
-- 礼包奖励内容
local g_tableRewardInfo	=
{
	[1] = {nGiveItemID = 20600000, nGiveItemNum = 4, },
	[2] = {nGiveItemID = 20600001, nGiveItemNum = 4, },
	[3] = {nGiveItemID = 20600002, nGiveItemNum = 4, },
	[4] = {nGiveItemID = 20600003, nGiveItemNum = 4, },
}
local g_contorlActionButton		= {}

-- 界面选择最大值
local g_nMaxSelectedIndex		= 4

--=========================================================
-- PreLoad
--=========================================================
function NewZhuXian_Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function NewZhuXian_Gift_OnLoad()
	g_NewZhuXian_Gift_Frame_UnifiedPosition = NewZhuXian_Gift_Frame:GetProperty("UnifiedPosition")


	g_contorlActionButton[1] = NewZhuXian_Gift_Gift1_Icon
	g_contorlActionButton[2] = NewZhuXian_Gift_Gift2_Icon
	g_contorlActionButton[3] = NewZhuXian_Gift_Gift3_Icon
	g_contorlActionButton[4] = NewZhuXian_Gift_Gift4_Icon

end

--=========================================================
-- OnEvent
--=========================================================
function NewZhuXian_Gift_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 关闭, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关闭界面
		if 0 == nOpType then	
			if this:IsVisible() then
				NewZhuXian_Gift_OnClose()
			end
		end

		-- 打开界面
		if 1 == nOpType then

			NewZhuXian_Gift_Reset()
			NewZhuXian_Gift_Frame_On_ResetPos()
			this:Show()
			NewZhuXian_Gift_ParamInit()

			NewZhuXian_Gift_Update(1)
		end
			
		-- 刷新界面
		if 2 == nOpType then

			if this:IsVisible() then
				NewZhuXian_Gift_ParamInit()
				NewZhuXian_Gift_Update(0)
			end
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		NewZhuXian_Gift_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		NewZhuXian_Gift_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		NewZhuXian_Gift_Frame_On_ResetPos()
	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function NewZhuXian_Gift_ParamInit()
	g_nUseItemBagPos = Get_XParam_INT(1)
	g_nUseTime = Get_XParam_INT(2)
end


--=========================================================
-- 界面更新
--=========================================================
-- !!!reloadscript =NewZhuXian_Gift
function NewZhuXian_Gift_Update(bOpen)
	if g_nUseItemBagPos < 0 then
		return
	end
	
	LifeAbility:Lock_Packet_Item(g_nUseItemBagPos, 1)
	
	for i = 1, g_nMaxSelectedIndex do

		local tRewardInfo = g_tableRewardInfo[i]
		local nGiveItemID = tRewardInfo.nGiveItemID
		local nGiveItemNum = tRewardInfo.nGiveItemNum

		local theAction = DataPool:CreateBindActionItemForShow(nGiveItemID, nGiveItemNum)
		g_contorlActionButton[i] : SetActionItem(theAction:GetID())

	end
	NewZhuXian_Gift_Info2:SetText(ScriptGlobal_Format( "#{ZXJQ_221225_581}", 5-g_nUseTime))
end

--=========================================================
-- 重置界面
--=========================================================
function NewZhuXian_Gift_Reset()
	if g_nUseItemBagPos >= 0 then
		LifeAbility:Lock_Packet_Item(g_nUseItemBagPos, 0)
	end
	g_nUseItemBagPos = -1
	g_nUseTime = 0
end

--=========================================================
-- 界面确认按钮
--=========================================================
function NewZhuXian_Gift_ConfirmClick(nSelectedIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIClickCallBack" )
		Set_XSCRIPT_ScriptID(890174)
		Set_XSCRIPT_Parameter(0, g_nUseItemBagPos)					
		Set_XSCRIPT_Parameter(1, nSelectedIndex)				
		Set_XSCRIPT_Parameter(2, 0)				
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--=========================================================
-- 关闭界面
--=========================================================
function NewZhuXian_Gift_OnClose()	
	this:Hide()
	-- 重置
	NewZhuXian_Gift_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="NewZhuXian_Gift_OnHiden();" />
--=========================================================
function NewZhuXian_Gift_OnHiden()
	-- 重置
	NewZhuXian_Gift_Reset()
end

--=========================================================
-- 界面位置
--=========================================================
function NewZhuXian_Gift_Frame_On_ResetPos()
	NewZhuXian_Gift_Frame:SetProperty("UnifiedPosition", g_NewZhuXian_Gift_Frame_UnifiedPosition)
end