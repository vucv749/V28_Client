local g_ZhouChangShop_Frame_UnifiedXPosition;
local g_ZhouChangShop_Frame_UnifiedYPosition;  

local g_ZhouChang_Curpage = 1
local g_ZhouChang_TotalPage= 0
local g_ZhouChang_PerPage =12
local g_ZhouChang_itemctl = {}
local g_ZhouChang_Tabctl = {}
local g_ZhouChang_Type = 1
local g_ZhouChang_DaiBi= 0
local g_ZhouChang_TargetID = 0
local g_ZhouChang_NpcId=0
local g_ZhouChang_curtab=0
local g_ZhouChang_Title = {
    [1] = "#{ZCSD_220802_16}",
    [2] = "#{ZCSD_220802_22}",
}
local g_ZhouChang_Money = {
    [1] = "#{ZCSD_220802_19}",
    [2] = "#{ZCSD_220802_24}",
}
function ZhouChangShop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT")  
	this:RegisterEvent("UPDATE_WEEKLY_SHOP_H")  
	this:RegisterEvent("UPDATE_WEEKLY_SHOP_L")  
end

function ZhouChangShop_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		ZhouChangShop_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ZhouChangShop_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ZhouChangShop_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		ZhouChangShop_Close()
    elseif event == "UPDATE_WEEKLY_SHOP_H" then  
        if not this:IsVisible() then
            ZhouChangShop_querengoumai:SetCheck(1)      
        end 
        if g_ZhouChang_Type ~= 1 then
            ZhouChangShop_querengoumai:SetCheck(1)    
            g_ZhouChang_Curpage = 1
        end
        g_ZhouChang_Type = 1
        g_ZhouChang_TargetID = tonumber(arg0) 
        Lua_TDU_Log("g_ZhouChang_TargetID"..g_ZhouChang_TargetID);
        g_ZhouChang_DaiBi = tonumber(arg1) 
        objCared = DataPool : GetNPCIDByServerID(g_ZhouChang_TargetID)
        this:CareObject(objCared, 1, "ZhouChangShop");	 
        ZhouChangShop_OnShown(Lua_GetWeeklyShopCurWeek())
    elseif event == "UPDATE_WEEKLY_SHOP_L" then 
        if not this:IsVisible() then
            ZhouChangShop_querengoumai:SetCheck(1)          
        end 
        if g_ZhouChang_Type ~= 2 then
            g_ZhouChang_Curpage = 1            
            ZhouChangShop_querengoumai:SetCheck(1)     
        end  
        g_ZhouChang_Type = 2 
        g_ZhouChang_TargetID = tonumber(arg0) 
        g_ZhouChang_DaiBi = tonumber(arg1) 
        objCared = DataPool : GetNPCIDByServerID(g_ZhouChang_TargetID)
        this:CareObject(objCared, 1, "ZhouChangShop");	         
		ZhouChangShop_OnShown(Lua_GetWeeklyShopCurWeek()) 
    elseif (event == "OBJECT_CARED_EVENT") then
        Lua_TDU_Log("OBJECT_CARED_EVENT");
		if(tonumber(arg0) ~= objCared) then
			return;
		end 
        
		Lua_TDU_Log("OBJECT_CARED_EVENT tonumber(arg2):"..tonumber(arg2));
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			ZhouChangShop_Close()
		end
	end
end

function ZhouChangShop_OnLoad()  
	-- 保存界面的默认相对位置
	g_ZhouChangShop_Frame_UnifiedXPosition	= ZhouChangShop_Frame:GetProperty("UnifiedXPosition");
    g_ZhouChangShop_Frame_UnifiedYPosition	= ZhouChangShop_Frame:GetProperty("UnifiedYPosition");  
    for i = 1, g_ZhouChang_PerPage do
        g_ZhouChang_itemctl[i] = {}
        g_ZhouChang_itemctl[i].act  = _G["ZhouChangShop_Item"..i]
        g_ZhouChang_itemctl[i].name = _G[string.format("ZhouChangShop_ItemInfo%d_Text",i)] 
        g_ZhouChang_itemctl[i].money= _G[string.format("ZhouChangShop_ItemInfo%d_GB",i)]  
        g_ZhouChang_itemctl[i].limit= _G[string.format("ZhouChangShop_Item_Amount%d",i)]   
    end 
    g_ZhouChang_Tabctl[1] = ZhouChangShop_CheckBox1
    g_ZhouChang_Tabctl[2] = ZhouChangShop_CheckBox2
    g_ZhouChang_Tabctl[3] = ZhouChangShop_CheckBox3
    g_ZhouChang_Tabctl[4] = ZhouChangShop_CheckBox4
end 

function ZhouChangShop_OnShown(tabweek)
    g_ZhouChang_curtab = tabweek
    local ncurweek = Lua_GetWeeklyShopCurWeek()
    g_ZhouChang_Tabctl[ncurweek+1]:SetCheck(1)
    for i = 1, table.getn(g_ZhouChang_itemctl) do
        g_ZhouChang_itemctl[i].name:SetText("") 
        g_ZhouChang_itemctl[i].money:SetText("")
        g_ZhouChang_itemctl[i].limit:SetText("")
        g_ZhouChang_itemctl[i].act:SetActionItem(-1)
    end

    ZhouChangShop_Text:SetText(g_ZhouChang_Title[g_ZhouChang_Type])
    ZhouChangShop_Total_Text:SetText(ScriptGlobal_Format(g_ZhouChang_Money[g_ZhouChang_Type], g_ZhouChang_DaiBi)) 
       
    local tblinfo= Lua_GetWeeklyShopData(g_ZhouChang_Type, g_ZhouChang_Curpage, g_ZhouChang_PerPage, g_ZhouChang_curtab)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if table.getn(tblinfo) > table.getn(g_ZhouChang_itemctl) then
        PushDebugMessage("data over size")
        return
    end

    for i = 1, table.getn(tblinfo) do
        local itemname = DataPool:LuaFnGetItemNameByTableIndex(tblinfo[i].itemid)
        g_ZhouChang_itemctl[i].name:SetText(itemname) 
        if g_ZhouChang_Type == 1 then 
            g_ZhouChang_itemctl[i].money:SetText(ScriptGlobal_Format("#{ZCSD_220802_21}",tblinfo[i].daibinum) )
        else
            g_ZhouChang_itemctl[i].money:SetText(ScriptGlobal_Format("#{ZCSD_220802_25}",tblinfo[i].daibinum) )
        end
        local id = tblinfo[i].itemid
        local num= tblinfo[i].itemnum
        local limitweek= tblinfo[i].limitweek
        local limitweek_self= tblinfo[i].limitweek_self
        
        if ncurweek ~= tabweek then
            limitweek_self = limitweek
        end

        local theAction = DataPool:CreateBindActionItemForShow(id, num)
	    if theAction:GetID() ~= 0 then
	    	g_ZhouChang_itemctl[i].act:SetActionItem(theAction:GetID())
        end    
        if limitweek <= 0 then
            g_ZhouChang_itemctl[i].limit:Hide() 
        else
            g_ZhouChang_itemctl[i].limit:Hide()
            g_ZhouChang_itemctl[i].act:SetProperty("CornerChar","TopLeft "..limitweek_self )
            if limitweek_self <= 0 then
                g_ZhouChang_itemctl[i].act:Disable()
            else
                g_ZhouChang_itemctl[i].act:Enable()
            end
        end   
        
        if ncurweek ~= tabweek then
            g_ZhouChang_itemctl[i].act:Disable()
        end
    end

    if g_ZhouChang_Curpage == 1 then
        ZhouChangShop_UpPage:Disable()
    else
        ZhouChangShop_UpPage:Enable()
    end
    
    if g_ZhouChang_Curpage*g_ZhouChang_PerPage >= Lua_GetWeeklyShopTotalCount(g_ZhouChang_Type, tabweek) then
        ZhouChangShop_DownPage:Disable()
    else
        ZhouChangShop_DownPage:Enable()
    end

    local npagecount = 0
    if Lua_GetWeeklyShopTotalCount(g_ZhouChang_Type, tabweek) <= g_ZhouChang_PerPage then
        npagecount = 1
    elseif math.mod(Lua_GetWeeklyShopTotalCount(g_ZhouChang_Type, tabweek), g_ZhouChang_PerPage) == 0  then
        npagecount = math.floor(Lua_GetWeeklyShopTotalCount(g_ZhouChang_Type, tabweek)/g_ZhouChang_PerPage)
    else
        npagecount = math.floor(Lua_GetWeeklyShopTotalCount(g_ZhouChang_Type, tabweek)/g_ZhouChang_PerPage) + 1
    end
    ZhouChangShop_CurrentlyPage:SetText( ScriptGlobal_Format("#{QQSD_220801_17}",g_ZhouChang_Curpage, npagecount) )

	this:Show();
end 

--================================================
-- 界面的默认相对位置
--================================================
function ZhouChangShop_ResetPos()
	ZhouChangShop_Frame:SetProperty("UnifiedXPosition", g_ZhouChangShop_Frame_UnifiedXPosition);
	ZhouChangShop_Frame:SetProperty("UnifiedYPosition", g_ZhouChangShop_Frame_UnifiedYPosition); 
end 

function ZhouChangShop_Close() 
    g_ZhouChang_Curpage = 1
	this:Hide();
end
 

function ZhouChangShop_Btn_Clicked(index)  
    local tblinfo= Lua_GetWeeklyShopData(g_ZhouChang_Type, g_ZhouChang_Curpage, g_ZhouChang_PerPage, Lua_GetWeeklyShopCurWeek())	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if tblinfo[index] == nil or tblinfo[index].itemid <= 0 then
        return
    end

    local isconfirm = ZhouChangShop_querengoumai:GetCheck()
    if isconfirm == 0 then
        Clear_XSCRIPT()
            Set_XSCRIPT_Function_Name("buyitem")
            Set_XSCRIPT_ScriptID( 893129 )
            Set_XSCRIPT_Parameter( 0, g_ZhouChang_TargetID ); 
            Set_XSCRIPT_Parameter( 1, g_ZhouChang_Type ); 
            Set_XSCRIPT_Parameter( 2, tblinfo[index].itemid ); 
            Set_XSCRIPT_Parameter( 3, Lua_GetWeeklyShopCurWeek() ); 
            Set_XSCRIPT_ParamCount( 4 ); 
        Send_XSCRIPT() 
    else
        PushEvent("ZHOUCHANG_BUY_ITEM_CONFIRM", tblinfo[index].itemid, tblinfo[index].daibinum, g_ZhouChang_TargetID, g_ZhouChang_Type)
    end
end

function ZhouChangShop_PageDown()
    if g_ZhouChang_Curpage*g_ZhouChang_PerPage < Lua_GetWeeklyShopTotalCount(g_ZhouChang_Type, g_ZhouChang_curtab) then
        g_ZhouChang_Curpage = g_ZhouChang_Curpage + 1
        ZhouChangShop_OnShown(g_ZhouChang_curtab)
    end
end


function ZhouChangShop_PageUp()
    if g_ZhouChang_Curpage > 1 then
        g_ZhouChang_Curpage = g_ZhouChang_Curpage - 1
        ZhouChangShop_OnShown(g_ZhouChang_curtab)
    end
end

function ZhouChangShop_Help_Click()
    if g_ZhouChang_Type == 1 then
        PushEvent("CCSHOP_HELP", 10)
    else
        PushEvent("CCSHOP_HELP", 11)        
    end
end

function ZhouChangShop_querengoumai_Clicked() 

end
