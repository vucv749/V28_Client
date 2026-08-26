local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Biwuzhaoqin_Lover_TargetId = -1

local g_Biwuzhaoqin_Lover_listctrl = {}

local g_Biwuzhaoqin_Lover_ButtonLastTime = 0
local g_Biwuzhaoqin_Lover_ButtonCDTime = 3000 --3s

local g_Biwuzhaoqin_Lover_LoveGUID = -1
local g_Biwuzhaoqin_Lover_Select = 0

function Biwuzhaoqin_Lover_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SCENE_TRANSED",false)

end

function Biwuzhaoqin_Lover_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Biwuzhaoqin_Lover_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Biwuzhaoqin_Lover_Frame:GetProperty("UnifiedYPosition");
end

function Biwuzhaoqin_Lover_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Biwuzhaoqin_Lover_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		Biwuzhaoqin_Lover_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 79210801) then
		local finalpk = Get_XParam_INT(0)
		local lovername = Get_XParam_STR(0)
		local winnername = Get_XParam_STR(1)
		Biwuzhaoqin_Lover_Text3:SetText("#cfff263"..lovername)
		Biwuzhaoqin_Lover_Text4:SetText("#cfff263"..winnername)
		if finalpk == 1 then
			Biwuzhaoqin_Lover_Text5:SetText("#{BWZQ_20230329_372}")
		else
			Biwuzhaoqin_Lover_Text5:SetText("#{BWZQ_20230329_371}")
		end
		Biwuzhaoqin_Lover_Watch:SetProperty("Timer", 10)
		this:Show()
	elseif( event == "SCENE_TRANSED" ) then		
		Biwuzhaoqin_Lover_OnClose()
	end
end

function Biwuzhaoqin_Lover_OnTimerEnd()
	Biwuzhaoqin_Lover_OnClose()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_Lover_ResetPos()
	Biwuzhaoqin_Lover_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Biwuzhaoqin_Lover_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function Biwuzhaoqin_Lover_OnClose()
	this:Hide()
end

function Biwuzhaoqin_Lover_CloseClicked()
	this:Hide()
end
