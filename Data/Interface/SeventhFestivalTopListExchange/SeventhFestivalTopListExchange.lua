
local g_SeventhFestivalExchange_Point = 0;

local g_SeventhFestivalExchange_UnifiedPosition;

function SeventhFestivalTopListExchange_PreLoad()

	this:RegisterEvent("UI_COMMAND")	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	
end

function SeventhFestivalTopListExchange_OnLoad()

	g_SeventhFestivalExchange_UnifiedPosition = SeventhFestivalTopListExchange_Frame:GetProperty("UnifiedPosition");
	
end

function SeventhFestivalTopListExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89139603 ) then
		if this:IsVisible() then
			SeventhFestivalTopListExchange_Close();
			return
		end
		
		if Get_XParam_INT(0) ~= 1 then
			return
		end
			
		g_SeventhFestivalExchange_Point = Get_XParam_INT(1)
			
		SeventhFestivalTopListExchange_Moral_Value:SetProperty("DefaultEditBox", "True")
		SeventhFestivalTopListExchange_Moral_Value:SetSelected( 0, -1 )
		
		SeventhFestivalTopListExchange_Clear();
		
		SeventhFestivalTopListExchange_OnShown()
		this:Show()			
		
	elseif event == "HIDE_ON_SCENE_TRANSED" or event == "PLAYER_LEAVE_WORLD" then
		SeventhFestivalTopListExchange_Close()
		
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		SeventhFestivalTopListExchange_ResetPos()
		
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SeventhFestivalTopListExchange_ResetPos()
		
	end

end

function SeventhFestivalTopListExchange_OnShown()

	local str = ScriptGlobal_Format("#{QXHB_20230711_5}", g_SeventhFestivalExchange_Point)
	SeventhFestivalTopListExchange_Text1:SetText( str )
	
end

function SeventhFestivalTopListExchange_Clear()

	SeventhFestivalTopListExchange_Text1:SetText("")
	SeventhFestivalTopListExchange_Moral_Value:SetText("")
	SeventhFestivalTopListExchange_Text1:SetToolTip("")
	
end

function SeventhFestivalTopListExchange_OK_Clicked()

	local str = SeventhFestivalTopListExchange_Moral_Value : GetText();

	if str == nil or str == "" then
		return
	end

	if tonumber(str) > g_SeventhFestivalExchange_Point then
		PushDebugMessage("#{QXHB_20230711_11}")
		return
	end
	
	if( tonumber(str) <= 0 ) then
		PushDebugMessage("#{QXHB_20230711_10}")
		return
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("SeventhFestivalDoDuiHuan");
		Set_XSCRIPT_ScriptID(891396);
		Set_XSCRIPT_Parameter(0, tonumber(str));
		Set_XSCRIPT_Parameter(1, 1);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
		
end

function SeventhFestivalTopListExchange_Close()
	SeventhFestivalTopListExchange_OnHiden();
	this:Hide()
end

function SeventhFestivalTopListExchange_Cancel_Clicked()
	SeventhFestivalTopListExchange_Close();
	return;
end

function SeventhFestivalTopListExchange_OnHiden()
	SeventhFestivalTopListExchange_Clear()
	g_SeventhFestivalExchange_Point = 0;
	return
end

function SeventhFestivalTopListExchange_Count_Change()

	local str = SeventhFestivalTopListExchange_Moral_Value:GetText();
	local strNumber = 0;

	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	if strNumber > g_SeventhFestivalExchange_Point then
		strNumber = g_SeventhFestivalExchange_Point
	end
	str = tostring( strNumber );
	SeventhFestivalTopListExchange_Moral_Value:SetTextOriginal( str );
	
end

function SeventhFestivalTopListExchange_Max_Clicked()

	local maxDaiBi = g_SeventhFestivalExchange_Point;
	SeventhFestivalTopListExchange_Moral_Value:SetProperty("ClearOffset", "True");
	SeventhFestivalTopListExchange_Moral_Value:SetText(tostring(maxDaiBi));
	SeventhFestivalTopListExchange_Moral_Value:SetProperty("CaratIndex", 1024);
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function SeventhFestivalTopListExchange_ResetPos()

  SeventhFestivalTopListExchange_Frame:SetProperty("UnifiedPosition", g_SeventhFestivalExchange_UnifiedPosition);
  
end

