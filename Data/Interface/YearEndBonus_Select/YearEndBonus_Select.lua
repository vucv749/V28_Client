local YearEndBonus_Select_Frame_UnifiedXPosition = 0
local YearEndBonus_Select_Frame_UnifiedYPosition = 0   
local g_YearEndBonus_Select_Ctl = {}
local g_YearEndBonus_Select_Shopid = -1
local g_YearEndBonus_Select_tabid  = -1 
local g_YearEndBonus_Select_Curid  = -1 
local g_YearEndBonus_listitem ={}
local g_YearEndBonus_Select_ShopName =
{
    [1] = "#{HKCJ_241127_10}",
    [2] = "#{HKCJ_241127_11}",
    [3] = "#{HKCJ_241127_12}", 
}
local g_YearEndBonus_Select_DaiBiName =
{
    [1] = "#{HKCJ_241127_104}",
    [2] = "#{HKCJ_241127_105}",
    [3] = "#{HKCJ_241127_106}", 
} 
local g_YearEndBonus_Select_DaiBiImg =
{
    [1] = "set:YearEndBonus image:Icon_ZBL",
    [2] = "set:YearEndBonus image:Icon_QZL",
    [3] = "set:YearEndBonus image:Icon_WHL", 
} 
local g_YearEndBonus_Select_ShopNameTitle =
{
    [1] = "#{HKCJ_241127_60}",
    [2] = "#{HKCJ_241127_61}",
    [3] = "#{HKCJ_241127_62}", 
}
local g_YearEndBonus_Select_NameColor =
{
    [1] = "#{HKCJ_241127_112}",
    [2] = "#{HKCJ_241127_113}",
    [3] = "#{HKCJ_241127_114}", 
    [4] = "#{HKCJ_241127_115}", 
} 

--*********************************
-- PreLoad
--*********************************
function YearEndBonus_Select_PreLoad()
	this : RegisterEvent( "HKCJ_ZIXUAN" );					--   
	this : RegisterEvent( "UPDATE_HKCJ_INFO" );					--  
	this : RegisterEvent( "UI_COMMAND" );		 
	this : RegisterEvent(" ADJEST_UI_POS",false)
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- 游戏分辨率发生了变化
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- 选择人物
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景 
end

--*********************************
-- OnLoad
--*********************************
function YearEndBonus_Select_OnLoad() 
    -- 保存界面的默认相对位置
	YearEndBonus_Select_Frame_UnifiedXPosition	= YearEndBonus_Select_Frame:GetProperty("UnifiedXPosition");
    YearEndBonus_Select_Frame_UnifiedYPosition	= YearEndBonus_Select_Frame:GetProperty("UnifiedYPosition"); 
end

--================================================
-- 界面的默认相对位置
--================================================
function YearEndBonus_Select_ResetPos()
	YearEndBonus_Select_Frame:SetProperty("UnifiedXPosition", YearEndBonus_Select_Frame_UnifiedXPosition);
	YearEndBonus_Select_Frame:SetProperty("UnifiedYPosition", YearEndBonus_Select_Frame_UnifiedYPosition); 
end 

--**********************************
-- ONEvent
--**********************************
function YearEndBonus_Select_OnEvent( event ) 
    if ( event == "HKCJ_ZIXUAN" ) then  
        g_YearEndBonus_Select_Shopid = tonumber(arg0) 
        g_YearEndBonus_Select_tabid  = tonumber(arg1) 
        g_YearEndBonus_Select_Curid  = -1 
        YearEndBonus_Select_Open() 
        this:Show()   
    elseif ( event == "UPDATE_HKCJ_INFO" ) then 
        if this:IsVisible() then
            local hkcj_data = Lua_GetHKCJShopData()
            if type(hkcj_data) ~= "table" then
                return
            end
            YearEndBonus_Select_BalanceText:SetText(ScriptGlobal_Format("#{HKCJ_241127_81}",g_YearEndBonus_Select_DaiBiName[g_YearEndBonus_Select_Shopid], hkcj_data[g_YearEndBonus_Select_Shopid].DaiBiNum)) 
        end
    elseif ( event == "UI_COMMAND" and tonumber(arg0) == 50101506 ) then 
        if this:IsVisible() then
            YearEndBonus_Select_Close()   
        end 
    elseif event == "VIEW_RESOLUTION_CHANGED" then
		YearEndBonus_Select_ResetPos() 
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		YearEndBonus_Select_Close()   
	elseif event == "ADJEST_UI_POS" then
        YearEndBonus_Select_ResetPos() 	 
    end
end
--**********************************
-- 关闭
--**********************************
function YearEndBonus_Select_Close() 
    g_YearEndBonus_Select_Shopid = -1
    g_YearEndBonus_Select_tabid  = -1
    g_YearEndBonus_Select_Curid  = -1 
    this:Hide()
end 
function YearEndBonus_Select_OnHiden() 
    YearEndBonus_Select_Close()
end 
--**********************************
-- 打开界面
--**********************************
function YearEndBonus_Select_Open()  
    YearEndBonus_Select_DragTitle:SetText(g_YearEndBonus_Select_ShopNameTitle[g_YearEndBonus_Select_Shopid])
    local hkcj_gift = Lua_GetHKCJGiftInfo()
    if type(hkcj_gift) ~= "table" then
        return
    end 
    local hkcj_data = Lua_GetHKCJShopData()
    if type(hkcj_data) ~= "table" then
        return
    end
    
    for i = 1, table.getn(g_YearEndBonus_listitem) do
		if g_YearEndBonus_listitem[i] ~= nil then
			g_YearEndBonus_listitem[i] = nil
		end
    end
    YearEndBonus_Select_Award_List:Clear()
    YearEndBonus_Select_CostText:Hide()
    YearEndBonus_Select_BalanceText:SetText(ScriptGlobal_Format("#{HKCJ_241127_81}",g_YearEndBonus_Select_DaiBiName[g_YearEndBonus_Select_Shopid], hkcj_data[g_YearEndBonus_Select_Shopid].DaiBiNum)) 
    YearEndBonus_Select_BalanceIcon:SetProperty("Image", g_YearEndBonus_Select_DaiBiImg[g_YearEndBonus_Select_Shopid]);     
    for jlid, jlvalue in ipairs(hkcj_gift[g_YearEndBonus_Select_Shopid]) do
        if jlvalue.isSel == 1 then
            local bar1 = YearEndBonus_Select_Award_List:AddChild("YearEndBonus_Select_Award_ItemBK")
			if not bar1 then
			   break
            end    
            bar1:SetEvent("MouseLClick", string.format("YearEndBonus_Select_Incom_Select(%d)", jlvalue.TabID))   
            if jlvalue.IsPreView == 1 then
                bar1:GetSubItem("YearEndBonus_Select_Award_IconEye"):Show()
            else
                bar1:GetSubItem("YearEndBonus_Select_Award_IconEye"):Hide()
            end
            bar1:GetSubItem("YearEndBonus_Select_Award_Icon_Mask"):Hide() 
            local id  = jlvalue.ItemID
            local num = jlvalue.ItemNum
            local itemname = jlvalue.ItemName
            local Itemlevel=jlvalue.ItemType
            local theAction = DataPool:CreateBindActionItemForShow(id, num)
		    if theAction:GetID() ~= 0 then
                bar1:GetSubItem("YearEndBonus_Select_Award_Icon"):SetActionItem(theAction:GetID()); 
                bar1:GetSubItem("YearEndBonus_Select_Award_ItemName"):SetText(ScriptGlobal_Format(g_YearEndBonus_Select_NameColor[Itemlevel],itemname))
            end  
            bar1:GetSubItem("YearEndBonus_Select_Award_IconEye"):SetEvent("MouseLClick", string.format("YearEndBonus_Select_Incom_Eye(%d)", jlvalue.TabID))   
            bar1:GetSubItem("YearEndBonus_Select_Award_Icon"):SetEvent("MouseLClick", string.format("YearEndBonus_Select_Incom_Select(%d)", jlvalue.TabID))   
            bar1:GetSubItem("YearEndBonus_Select_Award_ItemYB"):SetText(ScriptGlobal_Format("#{HKCJ_241127_14}",jlvalue.YuanBao) )
            if jlvalue.SelDaiBi > 0 then
                bar1:GetSubItem("YearEndBonus_Select_Award_ItemPrice"):SetText(ScriptGlobal_Format("#{HKCJ_241127_140}",jlvalue.SelDaiBi) ) 
                bar1:GetSubItem("YearEndBonus_Select_Award_ItemPrice"):Show()  
                bar1:GetSubItem("YearEndBonus_Select_Award_ItemPriceIcon"):SetProperty("Image", g_YearEndBonus_Select_DaiBiImg[g_YearEndBonus_Select_Shopid]);     
            else                
                bar1:GetSubItem("YearEndBonus_Select_Award_ItemPrice"):Hide()
            end
            
            g_YearEndBonus_listitem[jlvalue.TabID] = bar1 
        end
    end  
end 

--预览
function YearEndBonus_Select_Incom_Eye(yuid)
    local hkcj_gift = Lua_GetHKCJGiftInfo()
    if type(hkcj_gift) ~= "table" then
        return
    end
    local itemid = hkcj_gift[g_YearEndBonus_Select_Shopid][yuid].ItemID
    if itemid >=10140000 then
        local nExteriorRideId = Exterior:LuaFnGetExteriorIdByItem(itemid)
        PushEvent("OPEN_RIDE_PREVIEW", nExteriorRideId)
    else
        local FACEID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
        local HAIRID, HAIRIDIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
        PushEvent("OPEN_DRESSPREVIEW", itemid, HAIRID, FACEID)  --时装\发型\脸型
    end 
end 

--自选
function YearEndBonus_Select_Incom_Select(selid)
    if selid == g_YearEndBonus_Select_Curid then
        g_YearEndBonus_listitem[g_YearEndBonus_Select_Curid]:GetSubItem("YearEndBonus_Select_Award_Icon_Mask"):Hide() 
        g_YearEndBonus_Select_Curid = -1
        YearEndBonus_Select_CostText:Hide()
        return
    end
    
    if g_YearEndBonus_Select_Curid ~= -1 then
        g_YearEndBonus_listitem[g_YearEndBonus_Select_Curid]:GetSubItem("YearEndBonus_Select_Award_Icon_Mask"):Hide() 
        g_YearEndBonus_Select_Curid = -1
        YearEndBonus_Select_CostText:Hide()
    end
    
    local hkcj_gift = Lua_GetHKCJGiftInfo()
    if type(hkcj_gift) ~= "table" then
        return
    end 
    g_YearEndBonus_listitem[selid]:GetSubItem("YearEndBonus_Select_Award_Icon_Mask"):Show()
    g_YearEndBonus_Select_Curid = selid 
end 
--Ok
function YearEndBonus_Select_OK_Clicked() 
    if g_YearEndBonus_Select_Curid == -1 then
        PushDebugMessage("#{HKCJ_241127_67}")
        return
    end
    local hkcj_gift = Lua_GetHKCJGiftInfo()
    if type(hkcj_gift) ~= "table" then
        return
    end 
    if g_YearEndBonus_Select_Curid <= 0 then
        PushDebugMessage("#{HKCJ_241127_67}")
        return
    end
    local hkcj_data = Lua_GetHKCJShopData()
    if type(hkcj_data) ~= "table" then
        return
    end

    local TabID = hkcj_gift[g_YearEndBonus_Select_Shopid][g_YearEndBonus_Select_Curid].TabID 
    if hkcj_gift[g_YearEndBonus_Select_Shopid][g_YearEndBonus_Select_Curid].SelDaiBi > hkcj_data[g_YearEndBonus_Select_Shopid].DaiBiNum then
        PushDebugMessage(ScriptGlobal_Format("#{HKCJ_241127_69}",g_YearEndBonus_Select_DaiBiName[g_YearEndBonus_Select_Shopid])) 
        return
    end
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("Select")
        Set_XSCRIPT_ScriptID( 501015 )
        Set_XSCRIPT_Parameter( 0, g_YearEndBonus_Select_Shopid ); 
        Set_XSCRIPT_Parameter( 1, g_YearEndBonus_Select_tabid ); 
        Set_XSCRIPT_Parameter( 2, TabID ); 
        Set_XSCRIPT_Parameter( 3, 0 ); 
        Set_XSCRIPT_ParamCount( 4 ); 
    Send_XSCRIPT()  
end 