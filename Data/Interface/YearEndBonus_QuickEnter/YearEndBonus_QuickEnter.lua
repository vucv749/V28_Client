local YearEndBonus_QuickEnter_Frame_UnifiedXPosition = 0
local YearEndBonus_QuickEnter_Frame_UnifiedYPosition = 0    
local g_YearEndBonus_QuickEnter_Refresh = 50101505
local g_YearEndBonus_QuickEnter_Show = 0
local g_YearEndBonus_QuickEnter_Tips = 0
--*********************************
-- PreLoad
--*********************************
function YearEndBonus_QuickEnter_PreLoad() 				--
    this:RegisterEvent("UI_COMMAND", true) 
	this : RegisterEvent("ADJEST_UI_POS",false)
	this : RegisterEvent("SCENE_TRANSED")
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- 游戏分辨率发生了变化
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- 选择人物
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景 
end

--*********************************
-- OnLoad
--*********************************
function YearEndBonus_QuickEnter_OnLoad() 
    -- 保存界面的默认相对位置
	YearEndBonus_QuickEnter_Frame_UnifiedXPosition	= YearEndBonus_QuickEnter_Frame:GetProperty("UnifiedXPosition");
    YearEndBonus_QuickEnter_Frame_UnifiedYPosition	= YearEndBonus_QuickEnter_Frame:GetProperty("UnifiedYPosition"); 
end

--================================================
-- 界面的默认相对位置
--================================================
function YearEndBonus_QuickEnter_ResetPos()
	YearEndBonus_QuickEnter_Frame:SetProperty("UnifiedXPosition", YearEndBonus_QuickEnter_Frame_UnifiedXPosition);
	YearEndBonus_QuickEnter_Frame:SetProperty("UnifiedYPosition", YearEndBonus_QuickEnter_Frame_UnifiedYPosition); 
end 

--**********************************
-- ONEvent
--**********************************
function YearEndBonus_QuickEnter_OnEvent( event ) 
    if event == "UI_COMMAND" and tonumber(arg0) == g_YearEndBonus_QuickEnter_Refresh then
		g_YearEndBonus_QuickEnter_Show     = Get_XParam_INT(0)
        g_YearEndBonus_QuickEnter_Tips = Get_XParam_INT(1)
        if g_YearEndBonus_QuickEnter_Show == 1 then
            this:Show()
            if g_YearEndBonus_QuickEnter_Tips == 1 then
                YearEndBonus_QuickEnter_Tips:Show()
            else
                YearEndBonus_QuickEnter_Tips:Hide()
            end
            --日期
            YearEndBonus_QuickEnter_Icon:SetToolTip("#{HKCJ_241127_01}")
            this:Show()
        else
            YearEndBonus_QuickEnter_Close() 
        end 
    elseif event == "VIEW_RESOLUTION_CHANGED" then
		YearEndBonus_QuickEnter_ResetPos()  
	elseif event == "ADJEST_UI_POS" then
        YearEndBonus_QuickEnter_ResetPos() 	 
    end
end 
function YearEndBonus_QuickEnter_Close()
    this:Hide()
end
function YearEndBonus_QuickEnter_OnClick()    
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("ShowClientUI")
        Set_XSCRIPT_ScriptID( 501015 ) 
        Set_XSCRIPT_ParamCount( 0 ); 
    Send_XSCRIPT() 
end 
 