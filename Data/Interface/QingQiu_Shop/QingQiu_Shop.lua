local g_QingQiu_Shop_Frame_UnifiedXPosition;
local g_QingQiu_Shop_Frame_UnifiedYPosition;  

local g_QingQiu_Curpage = 1
local g_QingQiu_TotalPage= 0
local g_QingQiu_PerPage =12
local g_QingQiu_itemctl = {}
local g_QingQiu_Type = 1
local g_QingQiu_DaiBi= 0
local g_QingQiu_TargetID = 0
local g_QingQiu_NpcId=0
local g_QingQiu_Title = {
    [1] = "#{QQSD_220801_15}",
    [2] = "#{QQSD_220801_21}",
}
local g_QingQiu_Money = {
    [1] = "#{QQSD_220801_18}",
    [2] = "#{QQSD_220801_23}",
}
function QingQiu_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
	this:RegisterEvent("UPDATE_DOUBLE_EXP") 
end

function QingQiu_Shop_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		QingQiu_Shop_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		QingQiu_Shop_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		QingQiu_Shop_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		QingQiu_Shop_Close()
    elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89306001 ) then	        	  
        if ( IsWindowShow( "QingQiu_Shop" ) == true ) then 
            QingQiu_Shop_Close()    
        end 
        g_QingQiu_TargetID = Get_XParam_INT( 0 );
        g_QingQiu_Type     = Get_XParam_INT( 1 );
        g_QingQiu_DaiBi    = Get_XParam_INT( 2 );
        QingQiu_Shop_OnShown()  
		g_QingQiu_NpcId = DataPool : GetNPCIDByServerID(g_QingQiu_TargetID)
		if g_QingQiu_NpcId == -1 then
			QingQiu_Shop_Close()
			return
		end
        this : CareObject( g_QingQiu_NpcId, 1, "QingQiu_Shop" )
    elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89306002 ) then	        	  
        if ( IsWindowShow( "QingQiu_Shop" ) == false ) then 
            return
        end 
        local daibinum = Get_XParam_INT( 0 );
        QingQiu_Shop_Total_Text:SetText(ScriptGlobal_Format(g_QingQiu_Money[g_QingQiu_Type], daibinum))
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_QingQiu_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			QingQiu_Shop_Close()
		end
	end
end

function QingQiu_Shop_OnLoad()  
	-- 保存界面的默认相对位置
	g_QingQiu_Shop_Frame_UnifiedXPosition	= QingQiu_Shop_Frame:GetProperty("UnifiedXPosition");
    g_QingQiu_Shop_Frame_UnifiedYPosition	= QingQiu_Shop_Frame:GetProperty("UnifiedYPosition");  
    for i = 1, g_QingQiu_PerPage do
        g_QingQiu_itemctl[i] = {}
        g_QingQiu_itemctl[i].act  = _G["QingQiu_Shop_Item"..i]
        g_QingQiu_itemctl[i].name = _G[string.format("QingQiu_Shop_ItemInfo%d_Text",i)] 
        g_QingQiu_itemctl[i].money= _G[string.format("QingQiu_Shop_ItemInfo%d_GB",i)]  
    end 
end 

function QingQiu_Shop_OnShown()
    
    for i = 1, table.getn(g_QingQiu_itemctl) do
        g_QingQiu_itemctl[i].name:SetText("") 
        g_QingQiu_itemctl[i].money:SetText("")
        g_QingQiu_itemctl[i].act:SetActionItem(-1)
    end

    QingQiu_Shop_Text:SetText(g_QingQiu_Title[g_QingQiu_Type])
    QingQiu_Shop_Total_Text:SetText(ScriptGlobal_Format(g_QingQiu_Money[g_QingQiu_Type], g_QingQiu_DaiBi)) 
    
    if g_QingQiu_Type == 1 then
        local check  = tonumber(NpcShop:GetQingQiuDirectly()) 
        if check >= 1 then
            QingQiu_Shop_querengoumai:SetCheck(0)
        else
            QingQiu_Shop_querengoumai:SetCheck(1)
        end
    else
        local check  = tonumber(NpcShop:GetXinYeDirectly()) 
        if check >= 1 then
            QingQiu_Shop_querengoumai:SetCheck(0)
        else
            QingQiu_Shop_querengoumai:SetCheck(1)
        end
    end
            
    local tblinfo= GetQingQiuShopData(g_QingQiu_Type, g_QingQiu_Curpage, g_QingQiu_PerPage)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if table.getn(tblinfo) > table.getn(g_QingQiu_itemctl) then
        PushDebugMessage("data over size")
        return
    end

    for i = 1, table.getn(tblinfo) do
        local itemname = DataPool:LuaFnGetItemNameByTableIndex(tblinfo[i].itemid)
        g_QingQiu_itemctl[i].name:SetText(itemname) 
        if g_QingQiu_Type == 1 then 
            g_QingQiu_itemctl[i].money:SetText(ScriptGlobal_Format("#{QQSD_220801_20}",tblinfo[i].daibinum) )
        else
            g_QingQiu_itemctl[i].money:SetText(ScriptGlobal_Format("#{QQSD_220801_24}",tblinfo[i].daibinum) )
        end
        local id = tblinfo[i].itemid
        local num= tblinfo[i].itemnum
        local theAction = DataPool:CreateBindActionItemForShow(id, num)
	    if theAction:GetID() ~= 0 then
	    	g_QingQiu_itemctl[i].act:SetActionItem(theAction:GetID())
        end        
    end

    if g_QingQiu_Curpage == 1 then
        QingQiu_Shop_UpPage:Disable()
    else
        QingQiu_Shop_UpPage:Enable()
    end
    
    if g_QingQiu_Curpage*g_QingQiu_PerPage >= GetQingQiuShopTotalCount(g_QingQiu_Type) then
        QingQiu_Shop_DownPage:Disable()
    else
        QingQiu_Shop_DownPage:Enable()
    end

    local npagecount = 0
    if GetQingQiuShopTotalCount(g_QingQiu_Type) <= g_QingQiu_PerPage then
        npagecount = 1
    elseif math.mod(GetQingQiuShopTotalCount(g_QingQiu_Type), g_QingQiu_PerPage) == 0  then
        npagecount = math.floor(GetQingQiuShopTotalCount(g_QingQiu_Type)/g_QingQiu_PerPage)
    else
        npagecount = math.floor(GetQingQiuShopTotalCount(g_QingQiu_Type)/g_QingQiu_PerPage) + 1
    end
    QingQiu_Shop_CurrentlyPage:SetText( ScriptGlobal_Format("#{QQSD_220801_17}",g_QingQiu_Curpage, npagecount) )

	this:Show();
end 

--================================================
-- 界面的默认相对位置
--================================================
function QingQiu_Shop_ResetPos()
	QingQiu_Shop_Frame:SetProperty("UnifiedXPosition", g_QingQiu_Shop_Frame_UnifiedXPosition);
	QingQiu_Shop_Frame:SetProperty("UnifiedYPosition", g_QingQiu_Shop_Frame_UnifiedYPosition); 
end 

function QingQiu_Shop_Close() 
    g_QingQiu_Curpage = 1
	this:Hide();
end
 

function QingQiu_Shop_Btn_Clicked(index)  
    local tblinfo= GetQingQiuShopData(g_QingQiu_Type, g_QingQiu_Curpage, g_QingQiu_PerPage)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if tblinfo[index] == nil or tblinfo[index].itemid <= 0 then
        return
    end

    local isconfirm = QingQiu_Shop_querengoumai:GetCheck()
    if isconfirm == 0 then
        Clear_XSCRIPT()
            Set_XSCRIPT_Function_Name("buyitem")
            Set_XSCRIPT_ScriptID( 893060 )
            Set_XSCRIPT_Parameter( 0, g_QingQiu_TargetID ); 
            Set_XSCRIPT_Parameter( 1, g_QingQiu_Type ); 
            Set_XSCRIPT_Parameter( 2, tblinfo[index].tbidx ); 
            Set_XSCRIPT_ParamCount( 3 ); 
        Send_XSCRIPT() 
    else
        PushEvent("QINGQIU_BUY_ITEM_CONFIRM", tblinfo[index].itemid, tblinfo[index].daibinum, g_QingQiu_TargetID, g_QingQiu_Type, tblinfo[index].tbidx)
    end
end

function QingQiu_Shop_PageDown()
    if g_QingQiu_Curpage*g_QingQiu_PerPage < GetQingQiuShopTotalCount(g_QingQiu_Type) then
        g_QingQiu_Curpage = g_QingQiu_Curpage + 1
        QingQiu_Shop_OnShown()
    end
end


function QingQiu_Shop_PageUp()
    if g_QingQiu_Curpage > 1 then
        g_QingQiu_Curpage = g_QingQiu_Curpage - 1
        QingQiu_Shop_OnShown()
    end
end

function QingQiu_Shop_Help_Click()
    if g_QingQiu_Type == 1 then
        PushEvent("CCSHOP_HELP", 8)
    else
        PushEvent("CCSHOP_HELP", 9)        
    end
end

function QingQiu_Shop_querengoumai_Clicked() 
    if g_QingQiu_Type == 1 then
        if(NpcShop:GetQingQiuDirectly() == 0)then
            QingQiu_Shop_querengoumai:SetCheck(0)
            NpcShop:SetQingQiuDirectly(1)
        else
            QingQiu_Shop_querengoumai:SetCheck(1)
            NpcShop:SetQingQiuDirectly(0)
        end
    else
        if(NpcShop:GetXinYeDirectly() == 0)then
            QingQiu_Shop_querengoumai:SetCheck(0)
            NpcShop:SetXinYeDirectly(1)
        else
            QingQiu_Shop_querengoumai:SetCheck(1)
            NpcShop:SetXinYeDirectly(0)
        end
    end

end