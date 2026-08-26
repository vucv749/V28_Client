local YearEndBonus_Frame_UnifiedXPosition = 0
local YearEndBonus_Frame_UnifiedYPosition = 0   
local g_YearEndBonus_Ctl = {} 
local g_YearEndBonus_ButtonLastTime = 0
local g_YearEndBonus_Item =
{
    [1] = 38003408,
    [2] = 38003409,
    [3] = 38003410,
    [4] = 38003411,
    [5] = 38003412,
    [6] = 38003413, 
} 
local g_YearEndBonus_ShopName =
{
    [1] = "#{HKCJ_241127_10}",
    [2] = "#{HKCJ_241127_11}",
    [3] = "#{HKCJ_241127_12}", 
}
local g_YearEndBonus_DaiBiName =
{
    [1] = "#{HKCJ_241127_104}",
    [2] = "#{HKCJ_241127_105}",
    [3] = "#{HKCJ_241127_106}", 
}
local g_YearEndBonus_buttontips = 
{
}
local g_YearEndBonus_NameColor =
{
    [1] = "#{HKCJ_241127_112}",
    [2] = "#{HKCJ_241127_113}",
    [3] = "#{HKCJ_241127_114}", 
    [4] = "#{HKCJ_241127_115}", 
} 
local g_YearEndBonus_ChouJiangInfo     = {
    [1] = {      
        CJYuanBao=188,    --??????  
    },
    [2] = {   
        CJYuanBao=388,    --??????  
    },
    [3] = {  
        CJYuanBao=788,    --??????  
    },
}
--*********************************
-- PreLoad
--*********************************
function YearEndBonus_PreLoad()
	this : RegisterEvent( "UPDATE_HKCJ_INFO" );					--   
	this : RegisterEvent(" ADJEST_UI_POS",false)
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- ??????????
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- ????
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- ???? 
end

--*********************************
-- OnLoad
--*********************************
function YearEndBonus_OnLoad() 
    -- 保存界面的默认相对位置
	YearEndBonus_Frame_UnifiedXPosition	= YearEndBonus_FrameBK:GetProperty("UnifiedXPosition");
    YearEndBonus_Frame_UnifiedYPosition	= YearEndBonus_FrameBK:GetProperty("UnifiedYPosition"); 
    g_YearEndBonus_Ctl.Shop   = {}
    g_YearEndBonus_Ctl.Shop[1]= {}
    g_YearEndBonus_Ctl.Shop[2]= {}
    g_YearEndBonus_Ctl.Shop[3]= {}
    g_YearEndBonus_Ctl.Shop[1].Tab    = {}
    g_YearEndBonus_Ctl.Shop[1].Tab[1] = {}
    g_YearEndBonus_Ctl.Shop[1].Tab[1].Action    = YearEndBonus_Box1_Goods1_Item
    g_YearEndBonus_Ctl.Shop[1].Tab[1].Red       = YearEndBonus_Box1_Goods1_Item_Red
    g_YearEndBonus_Ctl.Shop[1].Tab[1].Lock      = YearEndBonus_Box1_Goods1_Item_Lock
    g_YearEndBonus_Ctl.Shop[1].Tab[1].Preview   = YearEndBonus_Box1_Goods1_Item_Eye
    g_YearEndBonus_Ctl.Shop[1].Tab[1].Price     = YearEndBonus_Box1_Goods1_ItemPrice
    g_YearEndBonus_Ctl.Shop[1].Tab[1].NeedDaiBi = YearEndBonus_Box1_Goods1_SelectText
    g_YearEndBonus_Ctl.Shop[1].Tab[1].itemname  = YearEndBonus_Box1_Goods1_NameText
    g_YearEndBonus_Ctl.Shop[1].Tab[1].SelBtn    = YearEndBonus_Box1_Goods1_SelectBtn
    g_YearEndBonus_Ctl.Shop[1].Tab[1].LockBtn   = YearEndBonus_Box1_Goods1_LockBtn
    g_YearEndBonus_Ctl.Shop[1].Tab[1].BuyBtn    = YearEndBonus_Box1_Goods1_BuyBtn
    g_YearEndBonus_Ctl.Shop[1].Tab[2] = {}
    g_YearEndBonus_Ctl.Shop[1].Tab[2].Action    = YearEndBonus_Box1_Goods2_Item
    g_YearEndBonus_Ctl.Shop[1].Tab[2].Red       = YearEndBonus_Box1_Goods2_Item_Red
    g_YearEndBonus_Ctl.Shop[1].Tab[2].Lock      = YearEndBonus_Box1_Goods2_Item_Lock
    g_YearEndBonus_Ctl.Shop[1].Tab[2].Preview   = YearEndBonus_Box1_Goods2_Item_Eye
    g_YearEndBonus_Ctl.Shop[1].Tab[2].Price     = YearEndBonus_Box1_Goods2_ItemPrice
    g_YearEndBonus_Ctl.Shop[1].Tab[2].NeedDaiBi = YearEndBonus_Box1_Goods2_SelectText
    g_YearEndBonus_Ctl.Shop[1].Tab[2].itemname  = YearEndBonus_Box1_Goods2_NameText
    g_YearEndBonus_Ctl.Shop[1].Tab[2].SelBtn    = YearEndBonus_Box1_Goods2_SelectBtn
    g_YearEndBonus_Ctl.Shop[1].Tab[2].LockBtn   = YearEndBonus_Box1_Goods2_LockBtn
    g_YearEndBonus_Ctl.Shop[1].Tab[2].BuyBtn    = YearEndBonus_Box1_Goods2_BuyBtn
    g_YearEndBonus_Ctl.Shop[1].FreeNum          = YearEndBonus_Box1_RefreshText
    g_YearEndBonus_Ctl.Shop[1].HaveDaiBi        = YearEndBonus_Box1_CoinAText
    g_YearEndBonus_Ctl.Shop[1].ChouJianBtn      = YearEndBonus_Box1_RefreshBtn
    g_YearEndBonus_Ctl.Shop[1].YBBtn            = YearEndBonus_Box1_YBRefreshBtn
    g_YearEndBonus_Ctl.Shop[1].DaiBiIcon        = YearEndBonus_Box1_CoinATextIcon 
    g_YearEndBonus_Ctl.Shop[1].SellOut          = YearEndBonus_Box1_SoldOutText   
    g_YearEndBonus_Ctl.Shop[1].YBText           = YearEndBonus_Box1_YBRefreshText  
    g_YearEndBonus_Ctl.Shop[1].BK               = YearEndBonus_Shop1BKImage  
    g_YearEndBonus_Ctl.Shop[2].Tab    = {}
    g_YearEndBonus_Ctl.Shop[2].Tab[1] = {}
    g_YearEndBonus_Ctl.Shop[2].Tab[1].Action    = YearEndBonus_Box2_Goods1_Item
    g_YearEndBonus_Ctl.Shop[2].Tab[1].Red       = YearEndBonus_Box2_Goods1_Item_Red
    g_YearEndBonus_Ctl.Shop[2].Tab[1].Lock      = YearEndBonus_Box2_Goods1_Item_Lock
    g_YearEndBonus_Ctl.Shop[2].Tab[1].Preview   = YearEndBonus_Box2_Goods1_Item_Eye
    g_YearEndBonus_Ctl.Shop[2].Tab[1].Price     = YearEndBonus_Box2_Goods1_ItemPrice
    g_YearEndBonus_Ctl.Shop[2].Tab[1].NeedDaiBi = YearEndBonus_Box2_Goods1_SelectText
    g_YearEndBonus_Ctl.Shop[2].Tab[1].itemname  = YearEndBonus_Box2_Goods1_NameText
    g_YearEndBonus_Ctl.Shop[2].Tab[1].SelBtn    = YearEndBonus_Box2_Goods1_SelectBtn
    g_YearEndBonus_Ctl.Shop[2].Tab[1].LockBtn   = YearEndBonus_Box2_Goods1_LockBtn
    g_YearEndBonus_Ctl.Shop[2].Tab[1].BuyBtn    = YearEndBonus_Box2_Goods1_BuyBtn
    g_YearEndBonus_Ctl.Shop[2].Tab[2] = {}
    g_YearEndBonus_Ctl.Shop[2].Tab[2].Action    = YearEndBonus_Box2_Goods2_Item
    g_YearEndBonus_Ctl.Shop[2].Tab[2].Red       = YearEndBonus_Box2_Goods2_Item_Red
    g_YearEndBonus_Ctl.Shop[2].Tab[2].Lock      = YearEndBonus_Box2_Goods2_Item_Lock
    g_YearEndBonus_Ctl.Shop[2].Tab[2].Preview   = YearEndBonus_Box2_Goods2_Item_Eye
    g_YearEndBonus_Ctl.Shop[2].Tab[2].Price     = YearEndBonus_Box2_Goods2_ItemPrice
    g_YearEndBonus_Ctl.Shop[2].Tab[2].NeedDaiBi = YearEndBonus_Box2_Goods2_SelectText
    g_YearEndBonus_Ctl.Shop[2].Tab[2].itemname  = YearEndBonus_Box2_Goods2_NameText
    g_YearEndBonus_Ctl.Shop[2].Tab[2].SelBtn    = YearEndBonus_Box2_Goods2_SelectBtn
    g_YearEndBonus_Ctl.Shop[2].Tab[2].LockBtn   = YearEndBonus_Box2_Goods2_LockBtn
    g_YearEndBonus_Ctl.Shop[2].Tab[2].BuyBtn    = YearEndBonus_Box2_Goods2_BuyBtn
    g_YearEndBonus_Ctl.Shop[2].FreeNum          = YearEndBonus_Box2_RefreshText
    g_YearEndBonus_Ctl.Shop[2].HaveDaiBi        = YearEndBonus_Box2_CoinAText 
    g_YearEndBonus_Ctl.Shop[2].ChouJianBtn      = YearEndBonus_Box2_RefreshBtn
    g_YearEndBonus_Ctl.Shop[2].YBBtn            = YearEndBonus_Box2_YBRefreshBtn
    g_YearEndBonus_Ctl.Shop[2].DaiBiIcon        = YearEndBonus_Box2_CoinATextIcon 
    g_YearEndBonus_Ctl.Shop[2].SellOut          = YearEndBonus_Box2_SoldOutText  
    g_YearEndBonus_Ctl.Shop[2].YBText           = YearEndBonus_Box2_YBRefreshText  
    g_YearEndBonus_Ctl.Shop[2].BK               = YearEndBonus_Shop2BKImage
    g_YearEndBonus_Ctl.Shop[3].Tab    = {}
    g_YearEndBonus_Ctl.Shop[3].Tab[1] = {}
    g_YearEndBonus_Ctl.Shop[3].Tab[1].Action    = YearEndBonus_Box3_Goods1_Item
    g_YearEndBonus_Ctl.Shop[3].Tab[1].Red       = YearEndBonus_Box3_Goods1_Item_Red
    g_YearEndBonus_Ctl.Shop[3].Tab[1].Lock      = YearEndBonus_Box3_Goods1_Item_Lock
    g_YearEndBonus_Ctl.Shop[3].Tab[1].Preview   = YearEndBonus_Box3_Goods1_Item_Eye
    g_YearEndBonus_Ctl.Shop[3].Tab[1].Price     = YearEndBonus_Box3_Goods1_ItemPrice
    g_YearEndBonus_Ctl.Shop[3].Tab[1].NeedDaiBi = YearEndBonus_Box3_Goods1_SelectText
    g_YearEndBonus_Ctl.Shop[3].Tab[1].itemname  = YearEndBonus_Box3_Goods1_NameText
    g_YearEndBonus_Ctl.Shop[3].Tab[1].SelBtn    = YearEndBonus_Box3_Goods1_SelectBtn
    g_YearEndBonus_Ctl.Shop[3].Tab[1].LockBtn   = YearEndBonus_Box3_Goods1_LockBtn
    g_YearEndBonus_Ctl.Shop[3].Tab[1].BuyBtn    = YearEndBonus_Box3_Goods1_BuyBtn
    g_YearEndBonus_Ctl.Shop[3].Tab[2] = {}
    g_YearEndBonus_Ctl.Shop[3].Tab[2].Action    = YearEndBonus_Box3_Goods2_Item
    g_YearEndBonus_Ctl.Shop[3].Tab[2].Red       = YearEndBonus_Box3_Goods2_Item_Red
    g_YearEndBonus_Ctl.Shop[3].Tab[2].Lock      = YearEndBonus_Box3_Goods2_Item_Lock
    g_YearEndBonus_Ctl.Shop[3].Tab[2].Preview   = YearEndBonus_Box3_Goods2_Item_Eye
    g_YearEndBonus_Ctl.Shop[3].Tab[2].Price     = YearEndBonus_Box3_Goods2_ItemPrice
    g_YearEndBonus_Ctl.Shop[3].Tab[2].NeedDaiBi = YearEndBonus_Box3_Goods2_SelectText
    g_YearEndBonus_Ctl.Shop[3].Tab[2].itemname  = YearEndBonus_Box3_Goods2_NameText
    g_YearEndBonus_Ctl.Shop[3].Tab[2].SelBtn    = YearEndBonus_Box3_Goods2_SelectBtn
    g_YearEndBonus_Ctl.Shop[3].Tab[2].LockBtn   = YearEndBonus_Box3_Goods2_LockBtn
    g_YearEndBonus_Ctl.Shop[3].Tab[2].BuyBtn    = YearEndBonus_Box3_Goods2_BuyBtn
    g_YearEndBonus_Ctl.Shop[3].FreeNum          = YearEndBonus_Box3_RefreshText
    g_YearEndBonus_Ctl.Shop[3].HaveDaiBi        = YearEndBonus_Box3_CoinAText 
    g_YearEndBonus_Ctl.Shop[3].ChouJianBtn      = YearEndBonus_Box3_RefreshBtn
    g_YearEndBonus_Ctl.Shop[3].YBBtn            = YearEndBonus_Box3_YBRefreshBtn
    g_YearEndBonus_Ctl.Shop[3].DaiBiIcon        = YearEndBonus_Box3_CoinATextIcon 
    g_YearEndBonus_Ctl.Shop[3].SellOut          = YearEndBonus_Box3_SoldOutText  
    g_YearEndBonus_Ctl.Shop[3].YBText           = YearEndBonus_Box3_YBRefreshText  
    g_YearEndBonus_Ctl.Shop[3].BK               = YearEndBonus_Shop3BKImage
    g_YearEndBonus_buttontips[1] = YearEndBonus_Box1_RefreshBtn_Tips
    g_YearEndBonus_buttontips[2] = YearEndBonus_Box2_RefreshBtn_Tips
    g_YearEndBonus_buttontips[3] = YearEndBonus_Box3_RefreshBtn_Tips
end

--================================================
-- 界面的默认相对位置
--================================================
function YearEndBonus_ResetPos()
	YearEndBonus_FrameBK:SetProperty("UnifiedXPosition", YearEndBonus_Frame_UnifiedXPosition);
	YearEndBonus_FrameBK:SetProperty("UnifiedYPosition", YearEndBonus_Frame_UnifiedYPosition); 
end 

--**********************************
-- ONEvent
--**********************************
function YearEndBonus_OnEvent( event ) 
    if ( event == "UPDATE_HKCJ_INFO" ) then 
        local isshow = tonumber(arg0)
        if isshow == 1 then
            this:Show()
        end
        YearEndBonus_Open()    
    elseif event == "VIEW_RESOLUTION_CHANGED" then
		YearEndBonus_ResetPos() 
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		YearEndBonus_Close()   
	elseif event == "ADJEST_UI_POS" then
        YearEndBonus_ResetPos() 	 
    end
end
--**********************************
-- 关睜
--**********************************
function YearEndBonus_Close() 
    if ( IsWindowShow( "YearEndBonus_Select" ) ) then
        CloseWindow( "YearEndBonus_Select", true ); 
    end
    if ( IsWindowShow( "YearEndBonus_Preview" ) ) then
        CloseWindow( "YearEndBonus_Preview", true ); 
    end 
    if ( IsWindowShow( "YearEndBonus_CoinChange" ) ) then
        CloseWindow( "YearEndBonus_CoinChange", true );
    end
    this:Hide()
end 
function YearEndBonus_OnHiden() 
    YearEndBonus_Close()
end 
--**********************************
-- 打开界面24121719
--**********************************
function YearEndBonus_Open() 
    local xftype   = Lua_GetHKCJXiaoFeiType()
    local nEndTime = Lua_GetHKCJEndTime()
    local year = 2000 + math.floor(nEndTime/1000000)
    local month= math.mod(math.floor(nEndTime/10000),100)
    local day  = math.mod(math.floor(nEndTime/100),100)
    local hour = math.mod(nEndTime,100)
    if xftype > 0 then 
        local itemName = DataPool:LuaFnGetItemNameByTableIndex(g_YearEndBonus_Item[xftype])
        YearEndBonus_ActiveText:SetText(ScriptGlobal_Format("#{HKCJ_241127_88}", itemName) )
        YearEndBonus_ActiveTimeText:SetText(ScriptGlobal_Format("#{HKCJ_241127_86}", year, month, day, hour) )
        YearEndBonus_ActiveTimeText:Show()
    else
        YearEndBonus_ActiveText:SetText(ScriptGlobal_Format("#{HKCJ_241127_87}", xftype) )
        YearEndBonus_ActiveTimeText:Hide()
    end
    local check  = tonumber(NpcShop:GetHKCJDirectly()) 
    if check >= 1 then
        YearEndBonus_YuanBaoCheck_Btn:SetCheck(0)
    else
        YearEndBonus_YuanBaoCheck_Btn:SetCheck(1)
    end

    local hkcj_data = Lua_GetHKCJShopData()
    if type(hkcj_data) ~= "table" then
        return
    end
    local hkcj_gift = Lua_GetHKCJGiftInfo()
    if type(hkcj_gift) ~= "table" then
        return
    end
    for index, value in ipairs(hkcj_data) do
        g_YearEndBonus_Ctl.Shop[index].YBText:SetText(ScriptGlobal_Format("#{HKCJ_241127_116}",g_YearEndBonus_ChouJiangInfo[index].CJYuanBao))
        if value.OpenState == 0 then 
            for tabidx = 1, 2 do
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Action:SetActionItem(-1)
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].itemname:SetText("")
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Red:Hide()
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Lock:Hide() 
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Price:Hide() 
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Preview:Hide()  
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].SelBtn:Disable()  
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:Disable()  
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].BuyBtn:Disable()   
                g_YearEndBonus_buttontips[index]:Hide()
            end
            g_YearEndBonus_Ctl.Shop[index].FreeNum:SetText(ScriptGlobal_Format("#{HKCJ_241127_82}",value.FreeNum)) 
            g_YearEndBonus_Ctl.Shop[index].FreeNum:SetToolTip("#{HKCJ_241127_118}")
            g_YearEndBonus_Ctl.Shop[index].HaveDaiBi:SetText(ScriptGlobal_Format("#{HKCJ_241127_81}",g_YearEndBonus_DaiBiName[index], value.DaiBiNum)) 
            g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:Show()    
            g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:Disable() 
            g_YearEndBonus_Ctl.Shop[index].YBBtn:Show()    
            g_YearEndBonus_Ctl.Shop[index].YBBtn:Disable()    
            g_YearEndBonus_Ctl.Shop[index].HaveDaiBi:Show()
            g_YearEndBonus_Ctl.Shop[index].FreeNum:Show()
            g_YearEndBonus_Ctl.Shop[index].SellOut:Hide()
            g_YearEndBonus_Ctl.Shop[index].YBText:Show() 
            g_YearEndBonus_Ctl.Shop[index].BK:Hide()
        end
        if value.OpenState == 1 then 
            local allsellout = 0
            for tabidx = 1, 2 do
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Red:Hide()
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Lock:Hide() 
                g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Price:Hide() 
                local lockstatus = value.tabinfo[tabidx].LockStatus 
                local jcid       = value.tabinfo[tabidx].JCID 
                local itemname
                if jcid >= 1 then
                    local itemid     = hkcj_gift[index][jcid].ItemID
                    itemname         = hkcj_gift[index][jcid].ItemName
                    local num        = hkcj_gift[index][jcid].ItemNum
                    local yuanbao    = hkcj_gift[index][jcid].YuanBao
                    local IsPreView    = hkcj_gift[index][jcid].IsPreView
                    local Itemlevel    = hkcj_gift[index][jcid].ItemType
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Price:Show()
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Price:SetText(ScriptGlobal_Format("#{HKCJ_241127_14}", yuanbao)) 
                    if IsPreView == 1 then
                        g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Preview:Show()
                    else
                        g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Preview:Hide()
                    end
                    local theAction = DataPool:CreateBindActionItemForShow(itemid, num) 
                    if theAction:GetID() ~= 0 then
                        g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Action:SetActionItem(theAction:GetID())
                        g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].itemname:SetText(ScriptGlobal_Format(g_YearEndBonus_NameColor[Itemlevel],itemname))   
                    end   
                    --g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].NeedDaiBi:SetText(ScriptGlobal_Format("#{HKCJ_241127_80}", needdaibi, "代币名字"))    
                else                  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Action:SetActionItem(-1)
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].SelBtn:Disable()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:Disable()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].BuyBtn:Disable() 
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Preview:Hide()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].itemname:SetText("")
                end 
                if lockstatus == 0 and jcid >= 1 then --??  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].SelBtn:Enable()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].SelBtn:SetToolTip(ScriptGlobal_Format("#{HKCJ_241127_19}",g_YearEndBonus_DaiBiName[index]))	
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("PushedImage",   "set:YearEndBonus image:Unlock_Pushed");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("NormalImage",   "set:YearEndBonus image:Unlock_Normal");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("HoverImage",    "set:YearEndBonus image:Unlock_Hover");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("DisabledImage", "set:YearEndBonus image:Unlock_Disabled");	 
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:Enable()                         
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].BuyBtn:Enable()   
                end 
                if lockstatus == 1 then --??
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Lock:Show() 
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Red:Hide()   
                    local IsPreView    = hkcj_gift[index][jcid].IsPreView
                    if IsPreView == 1 then
                        g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Preview:Show()
                    else
                        g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Preview:Hide()
                    end 
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].SelBtn:Disable()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("PushedImage",   "set:YearEndBonus image:Lock_Pushed");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("NormalImage",   "set:YearEndBonus image:Lock_Normal");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("HoverImage",    "set:YearEndBonus image:Lock_Hover");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("DisabledImage", "set:YearEndBonus image:Lock_Disabled");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:Enable()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].BuyBtn:Enable()   
                end 
                if lockstatus == 2  then --??
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Lock:Hide() 
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Red:Show() 
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Red:SetToolTip(ScriptGlobal_Format("#{HKCJ_241127_27}",itemname))		
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].Preview:Hide() 
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].SelBtn:Disable()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("PushedImage",   "set:YearEndBonus image:Lock_Pushed");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("NormalImage",   "set:YearEndBonus image:Lock_Normal");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("HoverImage",    "set:YearEndBonus image:Lock_Hover");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:SetProperty("DisabledImage", "set:YearEndBonus image:Lock_Disabled");
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].LockBtn:Disable()  
                    g_YearEndBonus_Ctl.Shop[index].Tab[tabidx].BuyBtn:Disable()  
                    allsellout = allsellout + 1 
                end 
            end
            if value.FreeNum > 0  then
                g_YearEndBonus_Ctl.Shop[index].FreeNum:SetText(ScriptGlobal_Format("#{HKCJ_241127_82}",value.FreeNum))  
                g_YearEndBonus_Ctl.Shop[index].FreeNum:SetToolTip("#{HKCJ_241127_118}")
            else
                g_YearEndBonus_Ctl.Shop[index].FreeNum:SetText("#{HKCJ_241127_139}")       
                g_YearEndBonus_Ctl.Shop[index].FreeNum:SetToolTip("")
            end
            g_YearEndBonus_Ctl.Shop[index].HaveDaiBi:SetText(ScriptGlobal_Format("#{HKCJ_241127_81}",g_YearEndBonus_DaiBiName[index], value.DaiBiNum)) 
            if value.FreeNum >= 1 then
                --g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:SetText("#{HKCJ_241127_15}") 
                g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:Enable()
                g_YearEndBonus_buttontips[index]:Show()
            else
                --g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:SetText("#{HKCJ_241127_89}")
                g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:Disable()
                g_YearEndBonus_buttontips[index]:Hide()
            end 
            if allsellout == 2 then
                g_YearEndBonus_buttontips[index]:Hide()
                g_YearEndBonus_Ctl.Shop[index].FreeNum:Hide()
                g_YearEndBonus_Ctl.Shop[index].YBText:Hide()  
                g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:Hide()
                g_YearEndBonus_Ctl.Shop[index].YBBtn:Hide()
                g_YearEndBonus_Ctl.Shop[index].SellOut:Show()
            else 
                g_YearEndBonus_Ctl.Shop[index].FreeNum:Show()
                g_YearEndBonus_Ctl.Shop[index].YBText:Show()  
                g_YearEndBonus_Ctl.Shop[index].ChouJianBtn:Show()
                g_YearEndBonus_Ctl.Shop[index].YBBtn:Show()
                g_YearEndBonus_Ctl.Shop[index].SellOut:Hide()
            end  
            g_YearEndBonus_Ctl.Shop[index].YBBtn:Enable()
            g_YearEndBonus_Ctl.Shop[index].BK:Show()
        end 
    end
end 

--预览
function YearEndBonus_Incom_Eye(shopid, tabid) 
    local hkcj_data = Lua_GetHKCJShopData()
    if type(hkcj_data) ~= "table" then
        return
    end
    local jcid = hkcj_data[shopid].tabinfo[tabid].JCID  
    if hkcj_data[shopid].tabinfo[tabid].ItemID <= 0 or jcid < 1 then
        PushDebugMessage("#{HKCJ_241127_50}")
        return
    end
    local itemid = hkcj_data[shopid].tabinfo[tabid].ItemID
    if itemid >=10140000 then
        local nExteriorRideId = Exterior:LuaFnGetExteriorIdByItem(itemid)
        PushEvent("OPEN_RIDE_PREVIEW", nExteriorRideId)
    else
        local FACEID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
        local HAIRID, HAIRIDIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
        PushEvent("OPEN_DRESSPREVIEW", itemid, HAIRID, FACEID)  --??\??\??
    end
end
--上锁解锁
function YearEndBonus_Lock(shopid, tabid)
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("Lock")
        Set_XSCRIPT_ScriptID( 501015 )
        Set_XSCRIPT_Parameter( 0, shopid ); 
        Set_XSCRIPT_Parameter( 1, tabid ); 
        Set_XSCRIPT_ParamCount( 2 ); 
    Send_XSCRIPT() 
end
--购买
function YearEndBonus_Buy(shopid, tabid)  
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("Buy")
        Set_XSCRIPT_ScriptID( 501015 )
        Set_XSCRIPT_Parameter( 0, shopid ); 
        Set_XSCRIPT_Parameter( 1, tabid ); 
        Set_XSCRIPT_Parameter( 2, 0 ); 
        Set_XSCRIPT_ParamCount( 3 ); 
    Send_XSCRIPT() 
end
--自选
function YearEndBonus_Select(shopid, tabid)
    local hkcj_data = Lua_GetHKCJShopData()
    if type(hkcj_data) ~= "table" then
        return
    end
    
    if hkcj_data[shopid].tabinfo[tabid].ItemID <= 0 then
        PushDebugMessage("#{HKCJ_241127_50}")
        return
    end

    if hkcj_data[shopid].tabinfo[tabid].LockStatus ~= 0 then
        PushDebugMessage("#{HKCJ_241127_79}")
        return
    end
    PushEvent("HKCJ_ZIXUAN",shopid, tabid)
end
--查看奖池
function YearEndBonus_JiangChi()
    PushEvent("HKCJ_JIANGCHI_SHOW")
end
--自选
function YearEndBonus_ChouJiang(shopid, isyb) 
    if ( IsWindowShow( "YearEndBonus_CoinChange" ) ) then
        CloseWindow( "YearEndBonus_CoinChange", true ); 
    end
    local curTime = OSAPI:GetTickCount();
	if ( curTime - g_YearEndBonus_ButtonLastTime < 1 * 500) then 
        PushDebugMessage("#{HKCJ_241127_31}"); --??????,?????????
		return
	end
	g_YearEndBonus_ButtonLastTime = curTime; 
    local isconfirm = 0
    if YearEndBonus_YuanBaoCheck_Btn:GetCheck() == 0 then
        isconfirm = 1
    end    
    
    local hkcj_data = Lua_GetHKCJShopData()
    if type(hkcj_data) ~= "table" then
        return
    end
    local allsellout = 0 
    if hkcj_data[shopid].OpenState == 1 then  
        for tabidx = 1, 2 do 
            local lockstatus = hkcj_data[shopid].tabinfo[tabidx].LockStatus 
            if lockstatus == 2  then --?? 
                allsellout = allsellout + 1 
            end 
        end  
    end  

    if allsellout == 2 then
        PushDebugMessage("#{HKCJ_241127_111}")
        return
    end 

    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("ChouJiang")
        Set_XSCRIPT_ScriptID( 501015 )
        Set_XSCRIPT_Parameter( 0, shopid ); 
        Set_XSCRIPT_Parameter( 1, 0 ); 
        Set_XSCRIPT_Parameter( 2, isconfirm ); 
        Set_XSCRIPT_Parameter( 3, isyb ); 
        Set_XSCRIPT_ParamCount( 4 ); 
    Send_XSCRIPT() 
end

function YearEndBonus_YuanBaoCheck_Click()
    if(NpcShop:GetHKCJDirectly() == 0)then
        YearEndBonus_YuanBaoCheck_Btn:SetCheck(0)
        NpcShop:SetHKCJDirectly(1)
    else
        YearEndBonus_YuanBaoCheck_Btn:SetCheck(1)
        NpcShop:SetHKCJDirectly(0)
    end
end

function YearEndBonus_OnClickHelp()    
	PushEvent("CCSHOP_HELP", 36)
end

function YearEndBonus_JZ()
    PushEvent("HKCJ_JZ") 
end
