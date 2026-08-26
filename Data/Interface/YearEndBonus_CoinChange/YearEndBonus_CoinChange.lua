local YearEndBonus_CoinChange_Frame_UnifiedXPosition = 0
local YearEndBonus_CoinChange_Frame_UnifiedYPosition = 0     
local g_YearEndBonus_CoinChange_DaiBiName =
{
    [1] = "#{HKCJ_241127_104}",
    [2] = "#{HKCJ_241127_105}",
    [3] = "#{HKCJ_241127_106}", 
}  

--*********************************
-- PreLoad
--*********************************
function YearEndBonus_CoinChange_PreLoad()
    this : RegisterEvent( "HKCJ_JZ" );	
    this : RegisterEvent( "UPDATE_HKCJ_INFO" );				 
	this : RegisterEvent( "HKCJ_JIANGCHI_SHOW" );					--   
	this : RegisterEvent(" ADJEST_UI_POS",false)
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- 游戏分辨率发生了变化
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- 选择人物
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景 
end

--*********************************
-- OnLoad
--*********************************
function YearEndBonus_CoinChange_OnLoad() 
    -- 保存界面的默认相对位置
	YearEndBonus_CoinChange_Frame_UnifiedXPosition	= YearEndBonus_CoinChange_Frame:GetProperty("UnifiedXPosition");
    YearEndBonus_CoinChange_Frame_UnifiedYPosition	= YearEndBonus_CoinChange_Frame:GetProperty("UnifiedYPosition"); 
end

--================================================
-- 界面的默认相对位置
--================================================
function YearEndBonus_CoinChange_ResetPos()
	YearEndBonus_CoinChange_Frame:SetProperty("UnifiedXPosition", YearEndBonus_CoinChange_Frame_UnifiedXPosition);
	YearEndBonus_CoinChange_Frame:SetProperty("UnifiedYPosition", YearEndBonus_CoinChange_Frame_UnifiedYPosition); 
end 

--**********************************
-- ONEvent
--**********************************
function YearEndBonus_CoinChange_OnEvent( event ) 
    if ( event == "HKCJ_JZ" ) then   
        YearEndBonus_CoinChange_Open() 
        this:Show()   
    elseif ( event == "UPDATE_HKCJ_INFO" ) then   
        YearEndBonus_CoinChange_Open()      
    elseif event == "VIEW_RESOLUTION_CHANGED" then
		YearEndBonus_CoinChange_ResetPos() 
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		YearEndBonus_CoinChange_Close()   
	elseif event == "ADJEST_UI_POS" then
        YearEndBonus_CoinChange_ResetPos() 	 
    end
end
--**********************************
-- 关闭
--**********************************
function YearEndBonus_CoinChange_Close()  
    this:Hide()
end 
function YearEndBonus_CoinChange_OnHiden() 
    YearEndBonus_CoinChange_Close()
end 
--**********************************
-- 打开界面
--**********************************
function YearEndBonus_CoinChange_Open()   
    local hkcj_data = Lua_GetHKCJShopData()
    if type(hkcj_data) ~= "table" then
        return
    end
    
    YearEndBonus_CoinChange_ChangeText1:SetText(ScriptGlobal_Format("#{HKCJ_241127_130}",hkcj_data[1].DaiBiNum))
    YearEndBonus_CoinChange_ChangeText2:SetText(ScriptGlobal_Format("#{HKCJ_241127_131}",hkcj_data[2].DaiBiNum))
    YearEndBonus_CoinChange_ChangeText3:SetText(ScriptGlobal_Format("#{HKCJ_241127_132}",hkcj_data[3].DaiBiNum))
end 
 
function YearEndBonus_CoinChange_PageClicked(itemtype)
    g_YearEndBonus_CoinChange_ItemType = itemtype
    YearEndBonus_CoinChange_Open()
end

function YearEndBonus_CoinChange_ChangeClicked(shopid)
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("DuiHuanJZ")
        Set_XSCRIPT_ScriptID( 501015 )
        Set_XSCRIPT_Parameter( 0, shopid ); 
        Set_XSCRIPT_Parameter( 1, 0 ); 
        Set_XSCRIPT_ParamCount( 2 ); 
    Send_XSCRIPT() 
end