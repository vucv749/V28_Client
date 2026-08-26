
--飞凰礼 二选一界面
local g_Anniversary_PickOne_UnifiedPosition

local g_Anniversary_PickOne_Left = 0
local g_Anniversary_PickOne_Right = 0

function Anniversary_PickOne_PreLoad()

	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent( "OPEN_YUANBAOSHOP" )
	
	this:RegisterEvent( "VIEW_RESOLUTION_CHANGED" )
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" )	--进场景关闭界面
	this:RegisterEvent( "ADJEST_UI_POS" )
	
end

function Anniversary_PickOne_OnLoad()

	g_Anniversary_PickOne_UnifiedPosition = Anniversary_PickOne_Frame:GetProperty("UnifiedPosition")

end

function Anniversary_PickOne_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 99859601) then
		if Get_XParam_INT(0) == 0 then
			Anniversary_PickOne_OnClose()
			return
		end
		
		g_Anniversary_PickOne_Left = Get_XParam_INT(1)
		g_Anniversary_PickOne_Right = Get_XParam_INT(2)
		
		Anniversary_PickOne_Open()
		this:Show()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Anniversary_PickOne_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		Anniversary_PickOne_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Anniversary_PickOne_OnClose()
	elseif event == "OPEN_YUANBAOSHOP" then
		Anniversary_PickOne_OnClose()
	end
	
end

function Anniversary_PickOne_Open()

	local theAction1 = DataPool:CreateActionItemForShow(g_Anniversary_PickOne_Left, 1) 
	if (theAction1:GetID() ~= 0) then
		Anniversary_PickOne_Gift1_Icon:SetActionItem(theAction1:GetID())  
	end 
	
	local theAction2 = DataPool:CreateActionItemForShow(g_Anniversary_PickOne_Right, 1) 
	if (theAction2:GetID() ~= 0) then
		Anniversary_PickOne_Gift2_Icon:SetActionItem(theAction2:GetID())  
	end 

end

function Anniversary_PickOne_On_ResetPos()

	Anniversary_PickOne_Frame:SetProperty("UnifiedPosition", g_Anniversary_PickOne_UnifiedPosition)

end

function Anniversary_PickOne_OnClose()
	Anniversary_PickOne_Gift1_Icon:SetActionItem( -1 ) 
	Anniversary_PickOne_Gift2_Icon:SetActionItem( -1 ) 
	this:Hide()
end

--点击左边
function Anniversary_PickOne_Left()
	Clear_XSCRIPT();		
		Set_XSCRIPT_Function_Name("OnChooseLeft")
		Set_XSCRIPT_ScriptID(998596);
		Set_XSCRIPT_Parameter(0, 1);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

--点击右边
function Anniversary_PickOne_Right()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnChooseRight")
		Set_XSCRIPT_ScriptID(998596);
		Set_XSCRIPT_Parameter(0, 1);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end
