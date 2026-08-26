-- 比武招亲
--
local g_unifiedposistion
local g_Init = 0


function Biwuzhaoqin_Watch_Mini_PreLoad()
	this:RegisterEvent("BWZQ_BATTLE_LIVEINFO",true)
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("BWZQ_BATTLE_LIVEINFO_MIN",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("CLOSE_BATTLELIVE_WINDOWS",false)

end

function Biwuzhaoqin_Watch_Mini_OnLoad()
	g_unifiedposistion	= Biwuzhaoqin_Watch_Mini_Frame:GetProperty("UnifiedPosition")
end

function Biwuzhaoqin_Watch_Mini_OnEvent(event)
	if event == "BWZQ_BATTLE_LIVEINFO" then
			if (IsWindowShow("Biwuzhaoqin_Watch")) then
			else
					if g_Init == 0 then
							BWZQ:SetSpecialSceneFlag()
							g_Init  = 1
					end
					Biwuzhaoqin_Watch_Mini_OnShow()
			end
	elseif event == "BWZQ_BATTLE_LIVEINFO_MIN" then
			Biwuzhaoqin_Watch_Mini_OnShow()
			BWZQ:SetPlayerWatchPosDirection(3,0,0)
	elseif event =="OPEN_WINDOW" and arg0 == "Biwuzhaoqin_Watch_Mini" then
			Biwuzhaoqin_Watch_Mini_OnShow()
	elseif event == "ADJEST_UI_POS" then
			Biwuzhaoqin_Watch_Mini_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
			Biwuzhaoqin_Watch_Mini_ResetPos()
	elseif event == "SCENE_TRANSED" then
			Biwuzhaoqin_Watch_MiniFrame_HideWindow()
			BWZQ:SetPlayerWatchPosDirection(3,0,0)
	elseif event == "CLOSE_BATTLELIVE_WINDOWS" then
			Biwuzhaoqin_Watch_MiniFrame_HideWindow()
			BWZQ:SetPlayerWatchPosDirection(3,0,0)
	end
end

--================================================
-- 显示信息
--================================================
function Biwuzhaoqin_Watch_Mini_OnShow()
	this:Show()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_Watch_Mini_ResetPos()
	Biwuzhaoqin_Watch_Mini_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

--================================================
-- 关闭界面
--================================================
function Biwuzhaoqin_Watch_MiniFrame_HideWindow()
	this:Hide()
	g_Init = 0
end

function Biwuzhaoqin_Watch_Mini_OnShowNormalUI()
	this:Hide()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskBattleLiveInfo" )
		Set_XSCRIPT_ScriptID(792108)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
	PushEvent("BWZQ_BATTLE_LIVEINFO_BIG")
end
