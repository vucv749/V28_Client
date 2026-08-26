local g_WeeklyShop_Frame_UnifiedXPosition;
local g_WeeklyShop_Frame_UnifiedYPosition;  

local g_WeeklyShop_Curpage = 1
local g_WeeklyShop_TotalPage= 0
local g_WeeklyShop_PerPage =12
local g_WeeklyShop_itemctl = {}  
local g_WeeklyShop_TargetID = 0
local g_WeeklyShop_NpcId=0  

function WeeklyShop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT")  
	this:RegisterEvent("UPDATE_JIYUAN_SHOP") 
end

function WeeklyShop_OnEvent(event) 
    if event == "UPDATE_JIYUAN_SHOP" then   
        g_WeeklyShop_TargetID = tonumber(arg0) 
        objCared = DataPool : GetNPCIDByServerID(g_WeeklyShop_TargetID)
        this:CareObject(objCared, 1, "WeeklyShop");	
        WeeklyShop_OnShown(g_WeeklyShop_Curpage)
        this:Show()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		WeeklyShop_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		WeeklyShop_Close()
	elseif event == "ADJEST_UI_POS" then
        WeeklyShop_ResetPos() 	
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			--取消关心
			this:CareObject(objCared, 0, "WeeklyShop");
		end	
	end

end

function WeeklyShop_OnLoad()  
	-- 保存界面的默认相对位置
	g_WeeklyShop_Frame_UnifiedXPosition	= WeeklyShop_Frame:GetProperty("UnifiedXPosition");
    g_WeeklyShop_Frame_UnifiedYPosition	= WeeklyShop_Frame:GetProperty("UnifiedYPosition");  
    for i = 1, g_WeeklyShop_PerPage do
        g_WeeklyShop_itemctl[i] = {}
        g_WeeklyShop_itemctl[i].act  = _G["WeeklyShop_Item"..i]
        g_WeeklyShop_itemctl[i].name = _G[string.format("WeeklyShop_ItemInfo%d_Text",i)] 
        g_WeeklyShop_itemctl[i].money= _G[string.format("WeeklyShop_ItemInfo%d_GB",i)]  
        g_WeeklyShop_itemctl[i].limit= _G[string.format("WeeklyShop_Item_Amount%d",i)]  
        g_WeeklyShop_itemctl[i].discount= _G[string.format("WeeklyShop_Item_Amount%d_Discount",i)]  

    end 
end 

function WeeklyShop_OnShown()
    
    for i = 1, table.getn(g_WeeklyShop_itemctl) do
        g_WeeklyShop_itemctl[i].name:SetText("") 
        g_WeeklyShop_itemctl[i].money:SetText("")
        g_WeeklyShop_itemctl[i].act:SetActionItem(-1)
        g_WeeklyShop_itemctl[i].discount:Hide()
    end
  
    local check  = tonumber(NpcShop:GetJiYuanDirectly()) 
    if check >= 1 then
        WeeklyShop_Buy:SetCheck(0)
    else
        WeeklyShop_Buy:SetCheck(1)
    end

    local tblinfo= Lua_GetJiYuanShopData(g_WeeklyShop_Curpage, g_WeeklyShop_PerPage)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if table.getn(tblinfo) > table.getn(g_WeeklyShop_itemctl) then
        PushDebugMessage("data over size")
        return
    end

    for i = 1, table.getn(tblinfo) do
        local itemid 	    = tblinfo[i].itemid
		local itemnum 	    = tblinfo[i].itemnum 
		local yuanbaonum    = tblinfo[i].yuanbaonum
		local limitday      = tblinfo[i].limitday
		local limitday_self = tblinfo[i].limitday_self
		local limitweek     = tblinfo[i].limitweek
		local limitweek_self= tblinfo[i].limitweek_self
		local limitmonth    = tblinfo[i].limitmonth
		local limitmonth_self= tblinfo[i].limitmonth_self
		local limitfov      = tblinfo[i].limitfov
		local limitfov_self = tblinfo[i].limitfov_self 
        local huoyueweek    = tblinfo[i].huoyueweek
        local isshowdiscount= tblinfo[i].isshowunbind

        local itemname = DataPool:LuaFnGetItemNameByTableIndex(itemid)
        g_WeeklyShop_itemctl[i].name:SetText(itemname) 
        g_WeeklyShop_itemctl[i].money:SetText("元宝:"..yuanbaonum ) 
       
        local theAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
	    if theAction:GetID() ~= 0 then
            g_WeeklyShop_itemctl[i].act:SetActionItem(theAction:GetID())
        end  
        if limitweek <= 0 then
            g_WeeklyShop_itemctl[i].limit:Hide() 
        else
            g_WeeklyShop_itemctl[i].limit:Show()
            g_WeeklyShop_itemctl[i].limit:SetText(limitweek_self)  
            if limitweek_self <= 0 then
                g_WeeklyShop_itemctl[i].act:Disable()
            else
                g_WeeklyShop_itemctl[i].act:Enable()
            end
        end   
        if isshowdiscount == 1 then
            g_WeeklyShop_itemctl[i].discount:Show()
        else
            g_WeeklyShop_itemctl[i].discount:Hide()
        end
    end
	this:Show();
end 

--================================================
-- 界面的默认相对位置
--================================================
function WeeklyShop_ResetPos()
	WeeklyShop_Frame:SetProperty("UnifiedXPosition", g_WeeklyShop_Frame_UnifiedXPosition);
	WeeklyShop_Frame:SetProperty("UnifiedYPosition", g_WeeklyShop_Frame_UnifiedYPosition); 
end 

function WeeklyShop_Close() 
    g_WeeklyShop_Curpage = 1
	this:Hide();
end
 

function WeeklyShop_Btn_Clicked(index)  
    local tblinfo= Lua_GetJiYuanShopData(g_WeeklyShop_Curpage, g_WeeklyShop_PerPage)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if tblinfo[index] == nil or tblinfo[index].itemid <= 0 then
        return
    end

    local isconfirm = WeeklyShop_Buy:GetCheck()
    if isconfirm == 0 then
        Clear_XSCRIPT()
            Set_XSCRIPT_Function_Name("buyitem")
            Set_XSCRIPT_ScriptID( 893113 )
            Set_XSCRIPT_Parameter( 0, g_WeeklyShop_TargetID ); 
            Set_XSCRIPT_Parameter( 1, tblinfo[index].itemid );  
            Set_XSCRIPT_ParamCount( 2 ); 
        Send_XSCRIPT() 
    else
        PushEvent("JIYUAN_BUY_ITEM_CONFIRM", "open", tblinfo[index].itemid, tblinfo[index].yuanbaonum, g_WeeklyShop_TargetID)
    end
end

function WeeklyShop_querengoumai_Clicked() 
    if(NpcShop:GetJiYuanDirectly() == 0)then
        WeeklyShop_Buy:SetCheck(0)
        NpcShop:SetJiYuanDirectly(1)
    else
        WeeklyShop_Buy:SetCheck(1)
        NpcShop:SetJiYuanDirectly(0)
    end

end