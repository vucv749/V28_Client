
local g_LoverTimeTopListExchange_Point = 0;

local g_LoverTimeTopListExchange_UnifiedPosition;

function LoverTimeTopListExchange_PreLoad()

	this:RegisterEvent("UI_COMMAND")	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	
end

function LoverTimeTopListExchange_OnLoad()

	g_LoverTimeTopListExchange_UnifiedPosition = LoverTimeTopListExchange_Frame:GetProperty("UnifiedPosition");
	
end

function LoverTimeTopListExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89297403 ) then
		if this:IsVisible() then
			LoverTimeTopListExchange_Close();
			return
		end
		
		if Get_XParam_INT(0) ~= 1 then
			return
		end
			
		g_LoverTimeTopListExchange_Point = Get_XParam_INT(1)
			
		LoverTimeTopListExchange_Moral_Value:SetProperty("DefaultEditBox", "True")
		LoverTimeTopListExchange_Moral_Value:SetSelected( 0, -1 )
		
		LoverTimeTopListExchange_Clear();
		
		LoverTimeTopListExchange_OnShown()
		this:Show()			
		
	elseif event == "HIDE_ON_SCENE_TRANSED" or event == "PLAYER_LEAVE_WORLD" then
		LoverTimeTopListExchange_Close()
		
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		LoverTimeTopListExchange_ResetPos()
		
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		LoverTimeTopListExchange_ResetPos()
		
	end

end

function LoverTimeTopListExchange_OnShown()

	local str = ScriptGlobal_Format("#{QRZM_231017_6}", g_LoverTimeTopListExchange_Point)
	LoverTimeTopListExchange_Text1:SetText( str )
	
end

function LoverTimeTopListExchange_Clear()

	LoverTimeTopListExchange_Text1:SetText("")
	LoverTimeTopListExchange_Moral_Value:SetText("")
	LoverTimeTopListExchange_Text1:SetToolTip("")
	
end

function LoverTimeTopListExchange_OK_Clicked()

	local str = LoverTimeTopListExchange_Moral_Value : GetText();

	if str == nil or str == "" then
		return
	end

	if tonumber(str) > g_LoverTimeTopListExchange_Point then
		PushDebugMessage("#{QRZM_231017_11}")
		return
	end
	
	if( tonumber(str) <= 0 ) then
		PushDebugMessage("#{QRZM_231017_10}")
		return
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("QingRenJieDoDuiHuan");
		Set_XSCRIPT_ScriptID(892974);
		Set_XSCRIPT_Parameter(0, tonumber(str));
		Set_XSCRIPT_Parameter(1, 1);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
		
end

function LoverTimeTopListExchange_Close()
	LoverTimeTopListExchange_OnHiden();
	this:Hide()
end

function LoverTimeTopListExchange_Cancel_Clicked()
	LoverTimeTopListExchange_Close();
	return;
end

function LoverTimeTopListExchange_OnHiden()
	LoverTimeTopListExchange_Clear()
	g_LoverTimeTopListExchange_Point = 0;
	return
end

function LoverTimeTopListExchange_Count_Change()

	local str = LoverTimeTopListExchange_Moral_Value:GetText();
	local strNumber = 0;

	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	if strNumber > g_LoverTimeTopListExchange_Point then
		strNumber = g_LoverTimeTopListExchange_Point
	end
	str = tostring( strNumber );
	LoverTimeTopListExchange_Moral_Value:SetTextOriginal( str );
	
end

function LoverTimeTopListExchange_Max_Clicked()

	local maxDaiBi = g_LoverTimeTopListExchange_Point;
	LoverTimeTopListExchange_Moral_Value:SetProperty("ClearOffset", "True");
	LoverTimeTopListExchange_Moral_Value:SetText(tostring(maxDaiBi));
	LoverTimeTopListExchange_Moral_Value:SetProperty("CaratIndex", 1024);
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function LoverTimeTopListExchange_ResetPos()

	LoverTimeTopListExchange_Frame:SetProperty("UnifiedPosition", g_LoverTimeTopListExchange_UnifiedPosition);
  
end

