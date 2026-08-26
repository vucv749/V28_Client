local g_FanLiShop_Frame_UnifiedXPosition;
local g_FanLiShop_Frame_UnifiedYPosition;  

local g_FanLiShop_Curpage = 1
local g_FanLiShop_TotalPage= 0
local g_FanLiShop_PerPage =12
local g_FanLiShop_itemctl = {}  
local g_FanLiShop_TargetID = 0
local g_FanLiShop_NpcId=0  

function FanLiShop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT")  
	this:RegisterEvent("UPDATE_LANGYUTIANGE_SHOP") 
end

function FanLiShop_OnEvent(event) 
    if event == "UPDATE_LANGYUTIANGE_SHOP" then   
        if not this:IsVisible() then
            FanLiShop_querengoumai:SetCheck(1)      
        end         
        g_FanLiShop_TargetID = tonumber(arg0) 
        objCared = DataPool : GetNPCIDByServerID(g_FanLiShop_TargetID)
        this:CareObject(objCared, 1, "FanLiShop");	
        FanLiShop_OnShown(g_FanLiShop_Curpage)
        this:Show()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		FanLiShop_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		FanLiShop_Close()
	elseif event == "ADJEST_UI_POS" then
        FanLiShop_ResetPos() 	
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			--取消关心
			this:CareObject(objCared, 0, "FanLiShop");
		end	
	end

end

function FanLiShop_OnLoad()  
	-- 保存界面的默认相对位置
	g_FanLiShop_Frame_UnifiedXPosition	= FanLiShop_Frame:GetProperty("UnifiedXPosition");
    g_FanLiShop_Frame_UnifiedYPosition	= FanLiShop_Frame:GetProperty("UnifiedYPosition");  
    for i = 1, g_FanLiShop_PerPage do
        g_FanLiShop_itemctl[i] = {}
        g_FanLiShop_itemctl[i].act  = _G["FanLiShop_Item"..i]
        g_FanLiShop_itemctl[i].name = _G[string.format("FanLiShop_ItemInfo%d_Text",i)] 
        g_FanLiShop_itemctl[i].money= _G[string.format("FanLiShop_ItemInfo%d_GB",i)]   
        g_FanLiShop_itemctl[i].price= _G[string.format("FanLiShop_ItemInfo%d_Price",i)]   
    end 
end 

function FanLiShop_OnShown()
    
    for i = 1, table.getn(g_FanLiShop_itemctl) do
        g_FanLiShop_itemctl[i].name:SetText("") 
        g_FanLiShop_itemctl[i].money:SetText("")
        g_FanLiShop_itemctl[i].act:SetActionItem(-1)
        g_FanLiShop_itemctl[i].price:Hide()
    end
  
    local check  = tonumber(NpcShop:GetJiYuanDirectly()) 
    if check >= 1 then
        FanLiShop_querengoumai:SetCheck(0)
    else
        FanLiShop_querengoumai:SetCheck(1)
    end

    local tblinfo= Lua_GetLangYuTianGeShopData(g_FanLiShop_Curpage, g_FanLiShop_PerPage)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if table.getn(tblinfo) > table.getn(g_FanLiShop_itemctl) then
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
        local isshowunbind  = tblinfo[i].isshowunbind

        local itemname = DataPool:LuaFnGetItemNameByTableIndex(itemid)
        g_FanLiShop_itemctl[i].name:SetText(itemname) 
        g_FanLiShop_itemctl[i].money:SetText("元宝:"..yuanbaonum ) 
       
        local theAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
	    if theAction:GetID() ~= 0 then
            g_FanLiShop_itemctl[i].act:SetActionItem(theAction:GetID())
        end  
        if limitweek <= 0 then 
        else 
            g_FanLiShop_itemctl[i].act:SetProperty("CornerChar","BotRight "..limitweek_self )
            if limitweek_self <= 0 then
                g_FanLiShop_itemctl[i].act:Disable()
            else
                g_FanLiShop_itemctl[i].act:Enable()
            end
        end   
        if limitday <= 0 then 
        else 
            g_FanLiShop_itemctl[i].act:SetProperty("CornerChar","BotRight "..limitday_self )
            if limitday_self <= 0 then
                g_FanLiShop_itemctl[i].act:Disable()
            else
                g_FanLiShop_itemctl[i].act:Enable()
            end
        end      
    end
    if g_FanLiShop_Curpage == 1 then
        FanLiShop_UpPage:Disable()
    else
        FanLiShop_UpPage:Enable()
    end
    
    if g_FanLiShop_Curpage*g_FanLiShop_PerPage >= Lua_GetLangYuTianGeShopTotalCount() then
        FanLiShop_DownPage:Disable()
    else
        FanLiShop_DownPage:Enable()
    end

    local npagecount = 0
    if Lua_GetLangYuTianGeShopTotalCount() <= g_FanLiShop_PerPage then
        npagecount = 1
    elseif math.mod(GetFanLiShopShopTotalCount(), g_FanLiShop_PerPage) == 0  then
        npagecount = math.floor(GetFanLiShopShopTotalCount()/g_FanLiShop_PerPage)
    else
        npagecount = math.floor(GetFanLiShopShopTotalCount()/g_FanLiShop_PerPage) + 1
    end
    FanLiShop_CurrentlyPage:SetText( ScriptGlobal_Format("#{QQSD_220801_17}",g_FanLiShop_Curpage, npagecount) )


	this:Show();
end 

--================================================
-- 界面的默认相对位置
--================================================
function FanLiShop_ResetPos()
	FanLiShop_Frame:SetProperty("UnifiedXPosition", g_FanLiShop_Frame_UnifiedXPosition);
	FanLiShop_Frame:SetProperty("UnifiedYPosition", g_FanLiShop_Frame_UnifiedYPosition); 
end 

function FanLiShop_Close() 
    g_FanLiShop_Curpage = 1
	this:Hide();
end
 

function FanLiShop_Btn_Clicked(index)  
    local tblinfo= Lua_GetLangYuTianGeShopData(g_FanLiShop_Curpage, g_FanLiShop_PerPage)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if tblinfo[index] == nil or tblinfo[index].itemid <= 0 then
        return
    end

    local isconfirm = FanLiShop_querengoumai:GetCheck()
    if isconfirm == 0 then
        Clear_XSCRIPT()
            Set_XSCRIPT_Function_Name("buyitem")
            Set_XSCRIPT_ScriptID( 181000 )
            Set_XSCRIPT_Parameter( 0, g_FanLiShop_TargetID ); 
            Set_XSCRIPT_Parameter( 1, tblinfo[index].itemid );  
            Set_XSCRIPT_ParamCount( 2 );  
        Send_XSCRIPT() 
    else
        PushEvent("FANLI_BUY_ITEM_CONFIRM", "open", tblinfo[index].itemid, tblinfo[index].yuanbaonum, g_FanLiShop_TargetID)
    end
end

function FanLiShop_PageDown()
    if g_FanLiShop_Curpage*g_FanLiShop_PerPage < Lua_GetLangYuTianGeShopTotalCount() then
        g_FanLiShop_Curpage = g_FanLiShop_Curpage + 1
        FanLiShop_OnShown()
    end
end


function FanLiShop_PageUp()
    if g_FanLiShop_Curpage > 1 then
        g_FanLiShop_Curpage = g_FanLiShop_Curpage - 1
        FanLiShop_OnShown()
    end
end

function FanLiShop_querengoumai_Clicked() 
    if(NpcShop:GetJiYuanDirectly() == 0)then
        FanLiShop_querengoumai:SetCheck(0)
        NpcShop:SetJiYuanDirectly(1)
    else
        FanLiShop_querengoumai:SetCheck(1)
        NpcShop:SetJiYuanDirectly(0)
    end

end