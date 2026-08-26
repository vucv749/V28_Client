
-- 精灵球 自动寻路

local g_Kunwu_JLMap_Frame_UnifiedPosition;

local g_Kunwu_JLMap_IconList = {}
local g_Kunwu_JLMap_ButtonList = {}
local g_Kunwu_JLMap_ButtonParam = 1

function Kunwu_JLMap_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function Kunwu_JLMap_OnLoad()

	g_Kunwu_JLMap_Frame_UnifiedPosition = Kunwu_JLMap_Frame:GetProperty("UnifiedPosition");
	
	g_Kunwu_JLMap_IconList[1] = Kunwu_JLMap_Rongyan_Client --????
	g_Kunwu_JLMap_IconList[2] = Kunwu_JLMap_Milin_Client --????
	g_Kunwu_JLMap_IconList[3] = Kunwu_JLMap_Qinghu_Client --????
	g_Kunwu_JLMap_IconList[4] = Kunwu_JLMap_Fanlin_Client --???
	g_Kunwu_JLMap_IconList[5] = Kunwu_JLMap_Dihuo_Client --???
	g_Kunwu_JLMap_IconList[6] = Kunwu_JLMap_Chenyue_Client --???

	g_Kunwu_JLMap_ButtonList[1] = Kunwu_JLMap_Change_Rongyan --????
	g_Kunwu_JLMap_ButtonList[2] = Kunwu_JLMap_Change_Milin --????
	g_Kunwu_JLMap_ButtonList[3] = Kunwu_JLMap_Change_Qinghu --????
	g_Kunwu_JLMap_ButtonList[4] = Kunwu_JLMap_Change_Fanlin --???
	g_Kunwu_JLMap_ButtonList[5] = Kunwu_JLMap_Change_Dihuo --???
	g_Kunwu_JLMap_ButtonList[6] = Kunwu_JLMap_Change_Chenyue --???

end

-- OnEvent
function Kunwu_JLMap_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99963101 ) then 
		local nParam = Get_XParam_INT(0)
		local nUseNum = Get_XParam_INT(1)
		Kunwu_JLMap_OnShow(nParam)
		Kunwu_JLMap_DailyInfo1:SetText(ScriptGlobal_Format("#{JLZH_241209_140}", nUseNum))
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99963102 ) then 
		local PosX = Get_XParam_INT(0)
		local PosZ = Get_XParam_INT(1)
		local nsceneId = Get_XParam_INT(2)
		AutoRunToTargetEx(PosX, PosZ, nsceneId)
		Kunwu_JLMap_OnHiden()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		Kunwu_JLMap_OnHiden()
	elseif (event == "ADJEST_UI_POS" ) then
		Kunwu_JLMap_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Kunwu_JLMap_ResetPos()
	end

end

function Kunwu_JLMap_OnShow(nParam)
	for i=1,6 do
		if i == nParam then
			g_Kunwu_JLMap_IconList[i]:Show()
			g_Kunwu_JLMap_ButtonParam = i
			g_Kunwu_JLMap_ButtonList[i]:SetCheck(1);
		else
			g_Kunwu_JLMap_IconList[i]:Hide()
			g_Kunwu_JLMap_ButtonList[i]:SetCheck(0);
		end
	end
	
	this:Show()
end



function Kunwu_JLMap_OnHiden()
	g_Kunwu_JLMap_ButtonParam = 1
	this:Hide()
end

function Kunwu_JLMap_ResetPos()
  Kunwu_JLMap_Frame:SetProperty("UnifiedPosition", g_Kunwu_JLMap_Frame_UnifiedPosition);
end

function Kunwu_JLMap_Goto_Clicked(idx)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetPosByIdx")
		Set_XSCRIPT_ScriptID(999631)
		Set_XSCRIPT_Parameter(0, idx)
		Set_XSCRIPT_Parameter(1, g_Kunwu_JLMap_ButtonParam)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end

function Kunwu_JLMap_Clear()
	Kunwu_JLMap_OnHiden()
end

function Kunwu_JLMap_OnClose()
	Kunwu_JLMap_OnHiden()
end

function Kunwu_JLMap_Change_Clicked(nParam)
	Kunwu_JLMap_OnShow(nParam)
end
