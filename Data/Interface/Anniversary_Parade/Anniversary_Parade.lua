
--车锦绣界面
local g_Anniversary_Parade_UnifiedPosition

local g_Anniversary_Parade_Left = 0
local g_Anniversary_Parade_Right = 0

function Anniversary_Parade_PreLoad()

	this:RegisterEvent( "UI_COMMAND" )

	this:RegisterEvent( "VIEW_RESOLUTION_CHANGED" )
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" )	--进场景关闭界面
	this:RegisterEvent( "ADJEST_UI_POS" )
	
end

function Anniversary_Parade_OnLoad()

	g_Anniversary_Parade_UnifiedPosition = Anniversary_Parade_Frame:GetProperty("UnifiedPosition")

end

function Anniversary_Parade_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 89105901) then
		
		Anniversary_Parade_Open()
		this:Show()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Anniversary_Parade_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		Anniversary_Parade_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Anniversary_Parade_OnClose()
	end
	
end

function Anniversary_Parade_Open()

end

function Anniversary_Parade_On_ResetPos()

	Anniversary_Parade_Frame:SetProperty("UnifiedPosition", g_Anniversary_Parade_UnifiedPosition)

end

function Anniversary_Parade_OnClose()
	this:Hide()
end

function Anniversary_Parade_OnHide()
	this:Hide()
end

function Anniversary_Parade_ShowHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenHelplUI" ) 	
		Set_XSCRIPT_ScriptID( 891059 )						-- 脚本编号
		Set_XSCRIPT_ParamCount( 0 )						    -- 参数个数
	Send_XSCRIPT()
end