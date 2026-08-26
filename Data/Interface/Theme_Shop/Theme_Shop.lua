local Theme_shop_btns  = {}
local Theme_shop_names = {}
local Theme_shop_yuanbao = {}
local Theme_shop_Frame_UnifiedXPosition = 0
local Theme_shop_Frame_UnifiedYPosition = 0 
local Theme_shop_NeedItem = 38002868
local Theme_shop_NeedItem_HaveNum = 0
local Theme_shop_Iteminfo = {
    [1] = {id=10124570, num=1, needitemnum=1, yuanbaonum=8888,},
    [2] = {id=10141267, num=1, needitemnum=1, yuanbaonum=51888,},
    [3] = {id=10124868, num=1, needitemnum=1, yuanbaonum=16888,},
    [4] = {id=10142125, num=1, needitemnum=1, yuanbaonum=68888,},
    [5] = {id=38002616, num=1, needitemnum=1, yuanbaonum=16888,},
    [6] = {id=30310038, num=1, needitemnum=1, yuanbaonum=15888,},
}

--*********************************
-- PreLoad
--*********************************
function Theme_Shop_PreLoad()
	this : RegisterEvent( "UI_COMMAND" );					-- UI_COMMAND  
	this : RegisterEvent(" ADJEST_UI_POS",false)
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- 游戏分辨率发生了变化
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- 选择人物
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景
	this : RegisterEvent( "UPDATE_YUANBAO" );
end

--*********************************
-- OnLoad
--*********************************
function Theme_Shop_OnLoad()
    for i = 1, 12 do        
        Theme_shop_btns[i]        =  _G[string.format("Theme_Shop_Item%d",i)]
        Theme_shop_names[i]       =  _G[string.format("Theme_Shop_ItemInfo%d_Text",i)]
        Theme_shop_yuanbao[i]     =  _G[string.format("Theme_Shop_ItemInfo%d_GB",i)] 
    end 
    -- 保存界面的默认相对位置
	Theme_shop_Frame_UnifiedXPosition	= Theme_Shop_Frame:GetProperty("UnifiedXPosition");
	Theme_shop_Frame_UnifiedYPosition	= Theme_Shop_Frame:GetProperty("UnifiedYPosition"); 
end

--================================================
-- 界面的默认相对位置
--================================================
function Theme_Shop_ResetPos()
	Theme_Shop_Frame:SetProperty("UnifiedXPosition", Theme_shop_Frame_UnifiedXPosition);
	Theme_Shop_Frame:SetProperty("UnifiedYPosition", Theme_shop_Frame_UnifiedYPosition); 
end 

--**********************************
-- ONEvent
--**********************************
function Theme_Shop_OnEvent( event ) 
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99838701 ) then
        Theme_shop_NeedItem_HaveNum = Get_XParam_INT(0) 
        Theme_Shop_Open()   
        this:Show()
    elseif event == "VIEW_RESOLUTION_CHANGED" then
		Theme_Shop_ResetPos() 
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Theme_Shop_Close()   
	elseif event == "ADJEST_UI_POS" then
        Theme_Shop_ResetPos() 	
    elseif (event == "UPDATE_YUANBAO" and this:IsVisible() ) then
        Theme_Shop_Yuanbao:SetText(ScriptGlobal_Format("#{ZTFC_20230620_21}",Player:GetData("YUANBAO")))
    elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99838704 ) then
        Theme_shop_NeedItem_HaveNum = Get_XParam_INT(0) 
        Theme_Shop_NUM:SetText(ScriptGlobal_Format("#{ZTFC_20230620_9}",Theme_shop_NeedItem_HaveNum))
    end
end

--===============================================
-- Button_Clicked
--===============================================
function Theme_Shop_Clicked(nIndex)
	if(nIndex < 1 or nIndex > 12) then
		return;
	end
    Theme_shop_btns[nIndex]:DoAction();     
end

--
--===============================================
-- 试穿
--===============================================
function Theme_Shop_OpenFitting()
	if IsIdleLogic() ~= 1 and IsMoveLogic() ~= 1 then
		SetNotifyTip("#{YBSD_081225_100}");
		return 0;
    end
    
    if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
    end 
    
    if(IsWindowShow("PetJian")) then
		CloseWindow("PetJian", true);
    end 

	StopMove(); 
	RestoreShopFitting();
	this:Show();
	MouseCmd_ShopFittingSet();
	SetNotifyTip("#{YBSD_081225_099}");
end

--===============================================
-- Close
--===============================================
function Theme_Shop_Close()  
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
    end 
    
    if(IsWindowShow("PetJian")) then
		CloseWindow("PetJian", true);
    end 

    DataPool:Lua_ClearFanChangItemInfo()
	SetDefaultMouse();  
	RestoreShopFitting();
	this:Hide();
end

--===============================================
-- open
--===============================================
function Theme_Shop_Open()   
    for key, value in pairs(Theme_shop_Iteminfo) do
        DataPool:Lua_SetFanChangItemInfo(key-1, value.id)
    end 
    
    Theme_Shop_NUM:SetText(ScriptGlobal_Format("#{ZTFC_20230620_9}",Theme_shop_NeedItem_HaveNum))
    Theme_Shop_Yuanbao:SetText(ScriptGlobal_Format("#{ZTFC_20230620_21}",Player:GetData("YUANBAO")))
    for key, value in pairs(Theme_shop_Iteminfo) do 
        local id        = value.id
        local num       = value.num
        local yuanbao   = value.yuanbaonum
        local theAction = EnumAction(key-1, "fanchangshop_item"); 
        if theAction:GetID() ~= 0 then
            Theme_shop_btns[key]:SetActionItem(theAction:GetID())
            local itemName = theAction:GetName()
            Theme_shop_btns[key]:Show()
            Theme_shop_names[key]:SetText(itemName)
        end  
        Theme_shop_yuanbao[key]:SetText(yuanbao)
    end  
end