--卡级服 废品回薁 
--!!!reloadscript =Kunwu_JLZH_Progress
local g_Kunwu_JLZH_Progress_Frame_UnifiedPosition = 0

local MAX_OBJ_DISTANCE = 7
local g_Kunwu_JLZH_Progress_NpcId = -1;
local g_Kunwu_JLZH_Progress_TargetId = -1
local g_Kunwu_JLZH_Progress_Tick = -1
local g_Kunwu_JLZH_Progress_nAllTime = 0
local g_Kunwu_JLZH_Progress_nTime = 0

--===============================================
-- PreLoad()
--===============================================
function Kunwu_JLZH_Progress_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)		--????
	this:RegisterEvent("ADJEST_UI_POS",false)				-- ???????????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	-- ??????????
	this:RegisterEvent("OBJECT_CARED_EVENT",false);           --????????????,????NPC???????
end

--===============================================
-- OnLoad()
--===============================================
function Kunwu_JLZH_Progress_OnLoad()	
	g_Kunwu_JLZH_Progress_Frame_UnifiedPosition = Kunwu_JLZH_Progress_Frame:GetProperty("UnifiedPosition")

end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_JLZH_Progress_OnEvent(event)
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible()then
		Kunwu_JLZH_Progress_OnHidden()
	elseif event == "ADJEST_UI_POS" and this:IsVisible()then
		Kunwu_JLZH_Progress_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" and this:IsVisible()then
		Kunwu_JLZH_Progress_On_ResetPos()
	end
	if event == "OBJECT_CARED_EVENT" then
		if(tonumber(arg0) ~= g_Kunwu_JLZH_Progress_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			Kunwu_JLZH_Progress_OnClose()
		end
	
		return
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 99963202 then
		local updateOrOpen = Get_XParam_INT(0)
		if(updateOrOpen == 0)then
			g_Kunwu_JLZH_Progress_TargetId = Get_XParam_INT( 1 )
			g_Kunwu_JLZH_Progress_nTime =  Get_XParam_INT( 2 )
			g_Kunwu_JLZH_Progress_nAllTime = Get_XParam_INT( 3 )
			Kunwu_JLZH_Progress_BeginCareObject( g_Kunwu_JLZH_Progress_TargetId )
			Kunwu_JLZH_Progress_Open(g_Kunwu_JLZH_Progress_nAllTime, g_Kunwu_JLZH_Progress_nTime)
		elseif(updateOrOpen == 1)then
			Kunwu_JLZH_Progress_AnimateNormal:Hide()
			Kunwu_JLZH_Progress_AnimateFinish:Show()
			Kunwu_JLZH_Progress_OnHidden()
		end
	end
end

function Kunwu_JLZH_Progress_Open(g_Kunwu_JLZH_Progress_nAllTime, g_Kunwu_JLZH_Progress_nTime)
	Kunwu_JLZH_Progress_AnimateNormal:Show()
	Kunwu_JLZH_Progress_AnimateFinish:Hide()
	Kunwu_JLZH_Progress_UpdateItem(g_Kunwu_JLZH_Progress_nAllTime, g_Kunwu_JLZH_Progress_nTime)
	this:Show()
end

--DragAcceptName G202
function Kunwu_JLZH_Progress_UpdateItem(nAllTime,nTime)
	if nAllTime <= 0 or nTime < 0 or nTime > nAllTime then
		return
	end
	Kunwu_JLZH_Progress_EXPInfo:SetText(ScriptGlobal_Format("#{JLZH_241209_119}",nTime));
	Kunwu_JLZH_Progress_EXP:SetProgress(nTime,nAllTime)
end

function Kunwu_JLZH_Progress_Stop_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 999632 )
		Set_XSCRIPT_Function_Name( "StopRand" )
		Set_XSCRIPT_Parameter(0, g_Kunwu_JLZH_Progress_TargetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Kunwu_JLZH_Progress_OnClose()
	Kunwu_JLZH_Progress_OnHidden()
end

function Kunwu_JLZH_Progress_OnHidden()
	Kunwu_JLZH_Progress_UpdateItem(-1,-1)
	Kunwu_JLZH_Progress_StopCareObject()
    this:Hide();
end

--=========================================================
-- 界面位置
--=========================================================
function Kunwu_JLZH_Progress_On_ResetPos()
	Kunwu_JLZH_Progress_Frame:SetProperty("UnifiedPosition", g_Kunwu_JLZH_Progress_Frame_UnifiedPosition)
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定犫个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function Kunwu_JLZH_Progress_BeginCareObject( objCaredId )
	g_Kunwu_JLZH_Progress_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_Kunwu_JLZH_Progress_NpcId == -1 then
		this : Hide()
		return
	end
	this : CareObject( g_Kunwu_JLZH_Progress_NpcId, 1, "Kunwu_JLZH_Progress" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function Kunwu_JLZH_Progress_StopCareObject()
	this : CareObject( g_Kunwu_JLZH_Progress_NpcId, 0, "Kunwu_JLZH_Progress" )
	g_Kunwu_JLZH_Progress_NpcId = -1
end

function Kunwu_JLZH_Progress_Clear()
	Kunwu_JLZH_Progress_OnHidden()
end

function Kunwu_JLZH_Progress_Cancel_Clicked()
	Kunwu_JLZH_Progress_OnHidden()
end
