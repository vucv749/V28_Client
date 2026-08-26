-- GM内部工具 V4 - 打造页

local g_GameTools4_Frame_UnifiedPosition
local WuYi = {"血攻修","力","灵","体","定","攻击修","防御修","命中修","闪避修","平衡修"}
local TianJi = {
	"天机Ⅰ","天机Ⅱ","天机Ⅲ","天机Ⅳ","天机Ⅴ","天机Ⅵ","天机Ⅶ","天机Ⅷ","天机Ⅸ","天机Ⅹ",
	"天上Ⅰ","天上Ⅱ","天上Ⅲ","天上Ⅳ","天上Ⅴ","天上Ⅵ","天上Ⅶ","天上Ⅷ","天上Ⅸ","天上Ⅹ",
	"宝石Ⅰ","宝石Ⅱ","宝石Ⅲ","其他Ⅰ"
}
local XiuLianTypes = {"力量","灵气","体力","定力","身法","外攻","内攻","外防","内防","命中","闪避"}

local XiuLainId = -1
local WuYiId = -1
local TianJiId = -1
local TargetID

function GameTools4_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_NOTIFY")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("MAINTARGET_CHANGED")
end

function GameTools4_OnLoad()
	g_GameTools4_Frame_UnifiedPosition = GameTools4_Frame:GetProperty("UnifiedPosition")
end

function GameTools4_OnEvent(event)
	if event == "UI_COMMAND" and arg0 == "202004274" then
		GameTools4_Init()
		GameTools4_FenYe4:SetCheck(1)
		this:Show()
	elseif event == "MAINTARGET_CHANGED" then
		TargetID = tonumber(arg0)
	elseif event == "ADJEST_UI_POS" then
		GameTools4_Frame_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		GameTools4_Frame_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
end

function GameTools4_Init()
	GameTools4_XiuLainEdix:ResetList()
	for i = 1, table.getn(XiuLianTypes) do
		GameTools4_XiuLainEdix:AddTextItem(XiuLianTypes[i], i)
	end

	GameTools4_WuYiEdix:ResetList()
	for i = 1, table.getn(WuYi) do
		GameTools4_WuYiEdix:AddTextItem(WuYi[i], i)
	end

	GameTools4_TianJiEdix:ResetList()
	for i = 1, table.getn(TianJi) do
		GameTools4_TianJiEdix:AddTextItem(TianJi[i], i)
	end
end

function GameTools4_XiuLain_ListBox_Selected()
	local str
	str, XiuLainId = GameTools4_XiuLainEdix:GetCurrentSelect()
end

function GameTools4_WuYi_ListBox_Selected()
	local str
	str, WuYiId = GameTools4_WuYiEdix:GetCurrentSelect()
end

function GameTools4_TianJi_ListBox_Selected()
	local str
	str, TianJiId = GameTools4_TianJiEdix:GetCurrentSelect()
end

-- 修炼操作: 1=全满 2=清空 3=设置指定秘籍等级
function GameTools4_XiuLain_Fun(index)
	if TargetID == nil then
		PushDebugMessage("请先选中目标头像")
		TargetID = 0
	end
	local nLevel = 0
	if index == 3 then
		-- 设置指定秘籍等级
		if XiuLainId == nil or XiuLainId < 0 then
			PushDebugMessage("请先从下拉框选择秘籍")
			return
		end
		local levelText = GameTools4_XiuLainLevelEdix:GetText()
		if levelText == nil or levelText == "" then
			PushDebugMessage("请输入要设置的等级")
			return
		end
		nLevel = tonumber(levelText)
		if nLevel == nil or nLevel < 0 or nLevel > 150 then
			PushDebugMessage("等级范围: 0~150")
			return
		end
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GMToolTypeThree")
		Set_XSCRIPT_ScriptID(666666)
		Set_XSCRIPT_Parameter(0, 101)
		Set_XSCRIPT_Parameter(1, index)
		Set_XSCRIPT_Parameter(2, tonumber(XiuLainId))
		Set_XSCRIPT_Parameter(3, TargetID)
		Set_XSCRIPT_Parameter(4, nLevel)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end

-- 全满/清空武意
function GameTools4_WuYi_Fun(index)
	if TargetID == nil then
		PushDebugMessage("请先选中目标头像")
		TargetID = 0
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GMToolTypeThree")
		Set_XSCRIPT_ScriptID(666666)
		Set_XSCRIPT_Parameter(0, 102)
		Set_XSCRIPT_Parameter(1, index)
		Set_XSCRIPT_Parameter(2, tonumber(WuYiId))
		Set_XSCRIPT_Parameter(3, TargetID)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

-- 清空经脉
function GameTools4_QingKongJingMai()
	if TargetID == nil then
		PushDebugMessage("请先选中目标头像")
		TargetID = 0
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GMToolTypeThree")
		Set_XSCRIPT_ScriptID(666666)
		Set_XSCRIPT_Parameter(0, 103)
		Set_XSCRIPT_Parameter(1, 1)
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_Parameter(3, TargetID)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

-- 清空栏位/MD/MDEX/FLAG/状态
function GameTools4_QingKong(index)
	if TargetID == nil then
		PushDebugMessage("请先选中目标头像")
		TargetID = 0
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GMToolTypeThree")
		Set_XSCRIPT_ScriptID(666666)
		Set_XSCRIPT_Parameter(0, 104)
		Set_XSCRIPT_Parameter(1, index)
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_Parameter(3, TargetID)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

-- 清空天机
function GameTools4_QingKongTianJi()
	if TargetID == nil then
		PushDebugMessage("请先选中目标头像")
		TargetID = 0
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GMToolTypeThree")
		Set_XSCRIPT_ScriptID(666666)
		Set_XSCRIPT_Parameter(0, 105)
		Set_XSCRIPT_Parameter(1, 1)
		Set_XSCRIPT_Parameter(2, tonumber(TianJiId))
		Set_XSCRIPT_Parameter(3, TargetID)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function GameTools4_Frame_On_ResetPos()
	GameTools4_Frame:SetProperty("UnifiedPosition", g_GameTools4_Frame_UnifiedPosition)
end

-- TAB分页切换
function GameTools4_ChangeTabIndex(nIndex)
	local nUI = 0
	if 1 == nIndex then
		nUI = 20200427
	elseif 2 == nIndex then
		nUI = 202004272
	elseif 3 == nIndex then
		nUI = 202004273
	elseif 4 == nIndex then
		return
	elseif 5 == nIndex then
		nUI = 202004275
	elseif 6 == nIndex then
		nUI = 202004276
	elseif 7 == nIndex then
		nUI = 316022021
	end
	if nUI ~= 0 then
		PushEvent("UI_COMMAND", nUI)
		this:Hide()
	end
end