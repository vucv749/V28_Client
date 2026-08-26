local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_NeedShow = 0

function PaoShangQuickly_PreLoad()

	this:RegisterEvent("CLOSE_PAOSHANGWINDOWS",true)
	this:RegisterEvent("RESET_ALLUI")
	this:RegisterEvent("SHOW_PAOSHANGQUICKLY")
	this:RegisterEvent("SYN_PAOSHANG_LEFTTIME",false)
	this:RegisterEvent("CHANGEUI_PAOSHANG")
end

function PaoShangQuickly_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= PaoShangQuickly_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= PaoShangQuickly_Frame:GetProperty("UnifiedYPosition");	
end

function PaoShangQuickly_OnEvent(event)

	if( event == "SHOW_PAOSHANGQUICKLY") then
		g_LeftTime	= tonumber(arg0)			
		if g_LeftTime > 0 then
			PaoShangQuickly_StopWatch:Show()
			PaoShangQuickly_StopWatch:SetProperty("Timer", tostring(g_LeftTime));
		else
			PaoShangQuickly_StopWatch:Hide()
		end	
		g_NeedShow = 1
		this:Show()
	elseif( event == "CLOSE_PAOSHANGWINDOWS" ) then	
			PaoShangQuickly_OnClose();
			g_NeedShow = 0
	elseif( event == "SYN_PAOSHANG_LEFTTIME") then
		g_LeftTime	= tonumber(arg0)		
		if g_LeftTime > 0 then
			PaoShangQuickly_StopWatch:Show()
			PaoShangQuickly_StopWatch:SetProperty("Timer", tostring(g_LeftTime));
		else
			PaoShangQuickly_StopWatch:Hide()
		end		
	elseif event == "RESET_ALLUI" then
		this:Hide()
		g_NeedShow = 0
	elseif event == "CHANGEUI_PAOSHANG" then
		if tonumber(arg0) == 1 and g_NeedShow == 1 then
			this:Show()
		end
	end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function PaoShangQuickly_ResetPos()
	--PaoShangQuickly_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	--PaoShangQuickly_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function PaoShangQuickly_OnClose()
	this:Hide()
end

function PaoShangQuickly_ShowDetail()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenPaoShangScene" )
		Set_XSCRIPT_ScriptID(892760)
		Set_XSCRIPT_Parameter(0,0)
		Set_XSCRIPT_Parameter(1,2)		
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
	PaoShangQuickly_OnClose()
end

