-- GMÄÚ²¿¹¤¾ß V4 - ´òÔìÒ³

local g_GameTools4_Frame_UnifiedPosition
local WuYi = {"Huyªt Công Tu","Lñc","Linh","Th¬","Ð¸nh","Công kích Tu","Phòng ngñ Tu","M®nh Trung Tu","Thi¬m T¸ Tu","Cân b¢ng Tu"}
local TianJi = {
	"Thiên c½ ?","Thiên c½ ?","Thiên c½ ?","Thiên c½ ?","Thiên c½ ?","Thiên c½ ?","Thiên c½ ?","Thiên c½ ?","Thiên c½ ?","Thiên c½ ?",
	"B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?","B¥u tr¶i ?",
	"Bäo thÕch ?","Bäo thÕch ?","Bäo thÕch ?","M£t khác ?"
}
local XiuLianTypes = {"Lñc lßþng","Nµi Lñc","Th¬ lñc","Ð¸nh lñc","Thân pháp","NgoÕi Công","Nµi Công","NgoÕi Thü","Nµi Thü","Chính xác","Thi¬m T¸"}

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

-- ÐÞÁ¶²Ù×÷: 1=È«Âú 2=Çå¿  3=ÉèÖÃÖ¸¶¨ÃØ¼®µÈ¼¶
function GameTools4_XiuLain_Fun(index)
	if TargetID == nil then
		PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u")
		TargetID = 0
	end
	local nLevel = 0
	if index == 3 then
		-- ÉèÖÃÖ¸¶¨ÃØ¼®µÈ¼¶
		if XiuLainId == nil or XiuLainId < 0 then
			PushDebugMessage("Thïnh Tiên t× dß¾i LÕp Khuông lña ch÷n bí t¸ch")
			return
		end
		local levelText = GameTools4_XiuLainLevelEdix:GetText()
		if levelText == nil or levelText == "" then
			PushDebugMessage("Thïnh ðßa vào Yêu thiªt trí Ðích c¤p b§c")
			return
		end
		nLevel = tonumber(levelText)
		if nLevel == nil or nLevel < 0 or nLevel > 150 then
			PushDebugMessage("C¤p b§c phÕm vi: 0~150")
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

-- È«Âú/Çå¿ ÎäÒâ
function GameTools4_WuYi_Fun(index)
	if TargetID == nil then
		PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u")
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

-- Çå¿ ¾­Âö
function GameTools4_QingKongJingMai()
	if TargetID == nil then
		PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u")
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

-- Çå¿ À¸Î»/MD/MDEX/FLAG/×´Ì¬
function GameTools4_QingKong(index)
	if TargetID == nil then
		PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u")
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

-- Çå¿ Ìì»ú
function GameTools4_QingKongTianJi()
	if TargetID == nil then
		PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u")
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

-- TAB·ÖÒ³ÇÐ»»
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
