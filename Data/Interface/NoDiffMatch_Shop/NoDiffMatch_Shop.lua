--NoDiffMatch_Shop

local g_NoDiffMatch_Shop_Frame_UnifiedXPosition;
local g_NoDiffMatch_Shop_Frame_UnifiedYPosition;  
local MAX_OBJ_DISTANCE = 5.0;

local g_NoDiffMatch_Curpage = 1
local g_NoDiffMatch_TotalPage= 0
local g_NoDiffMatch_PerPage =12
local g_NoDiffMatch_itemctl = {}
local g_NoDiffMatch_Tabctl = {}
local g_NoDiffMatch_Type = 1
local g_NoDiffMatch_TargetID = 0
local g_NoDiffMatch_NpcId=0
local g_NoDiffMatch_LimitData = {0}


function NoDiffMatch_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT")  
    this:RegisterEvent("PLAYER_LEAVE_WORLD") 
end

function NoDiffMatch_Shop_OnEvent(event) 
    if ( event == "UI_COMMAND" and tonumber(arg0) == 99949101 ) then
        local paramcount = Get_XParam_INT_Count()
        local operator = Get_XParam_INT(0)
        g_NoDiffMatch_TargetID = Get_XParam_INT(1)
        g_NoDiffMatch_Type = Get_XParam_INT(2)
        g_NoDiffMatch_Curpage = Get_XParam_INT(3)
        
        NoDiffMatch_Shop_CleanUp()
        for i = 4, paramcount-1 do
            local data = Get_XParam_INT(i)
            g_NoDiffMatch_LimitData[i-3] = data
        end
	 
		if operator == 1 then
            local objCared = DataPool : GetNPCIDByServerID(g_NoDiffMatch_TargetID)
            this:CareObject(objCared, 1, "NoDiffMatch_Shop");
            NoDiffMatch_Shop_OnShown()
            OpenWindow("Packet")
		elseif operator == 2 and this:IsVisible() then
            NoDiffMatch_Shop_OnShown()
		end    
	elseif( event == "ADJEST_UI_POS" ) then
		NoDiffMatch_Shop_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		NoDiffMatch_Shop_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		NoDiffMatch_Shop_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		NoDiffMatch_Shop_Close()
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end 
        --如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			NoDiffMatch_Shop_Close()
		end
	end
end

function NoDiffMatch_Shop_OnLoad()  
	-- 保存界面的默认相对位置
	g_NoDiffMatch_Shop_Frame_UnifiedXPosition	= NoDiffMatch_Shop_Frame:GetProperty("UnifiedXPosition");
    g_NoDiffMatch_Shop_Frame_UnifiedYPosition	= NoDiffMatch_Shop_Frame:GetProperty("UnifiedYPosition");  
    for i = 1, g_NoDiffMatch_PerPage do
        g_NoDiffMatch_itemctl[i] = {}
        g_NoDiffMatch_itemctl[i].act  = _G["NoDiffMatch_Shop_Item"..i]
        g_NoDiffMatch_itemctl[i].name = _G["NoDiffMatch_Shop_ItemInfo"..i.."_Text"] 
        g_NoDiffMatch_itemctl[i].money= _G["NoDiffMatch_Shop_ItemInfo"..i.."_GB"]  
        g_NoDiffMatch_itemctl[i].limit= _G["NoDiffMatch_Shop_Item_Amount"..i]   
    end 
    g_NoDiffMatch_Tabctl[1] = NoDiffMatch_Shop_CheckBox1
    g_NoDiffMatch_Tabctl[2] = NoDiffMatch_Shop_CheckBox2
    g_NoDiffMatch_Tabctl[3] = NoDiffMatch_Shop_CheckBox3
end 

function NoDiffMatch_Shop_CleanUp()
    for i = 1, g_NoDiffMatch_PerPage do
        g_NoDiffMatch_LimitData[i] = 0
    end
end

function NoDiffMatch_Shop_OnShown()
    
    g_NoDiffMatch_Tabctl[g_NoDiffMatch_Type]:SetCheck(1)
    for i = 1, table.getn(g_NoDiffMatch_itemctl) do
        g_NoDiffMatch_itemctl[i].name:SetText("") 
        g_NoDiffMatch_itemctl[i].money:Hide()
        g_NoDiffMatch_itemctl[i].limit:SetText("")
        g_NoDiffMatch_itemctl[i].act:SetActionItem(-1)
    end


    local tblinfo= Lua_GetZBSShopData(g_NoDiffMatch_Type, g_NoDiffMatch_Curpage, g_NoDiffMatch_PerPage)	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end 
    
    if table.getn(tblinfo) > table.getn(g_NoDiffMatch_itemctl) then
        PushDebugMessage("data over size")
        return
    end
    
    local plimit = 0
    for i = 1, table.getn(tblinfo) do
        local itemname = DataPool:LuaFnGetItemNameByTableIndex(tblinfo[i].itemid)
        g_NoDiffMatch_itemctl[i].name:SetText(itemname) 
        g_NoDiffMatch_itemctl[i].money:Show()
        g_NoDiffMatch_itemctl[i].money:SetProperty("MoneyNumber", tostring(tblinfo[i].JZnum))
        local id = tblinfo[i].itemid
        local num= tblinfo[i].itemnum
        local limitday = tblinfo[i].limitday
       
        
        local theAction = DataPool:CreateBindActionItemForShow(id, num)
	    if theAction:GetID() ~= 0 then
	    	g_NoDiffMatch_itemctl[i].act:SetActionItem(theAction:GetID())
        end    
        if limitday <= 0 then
            g_NoDiffMatch_itemctl[i].limit:Hide() 
        else
            plimit = plimit + 1
            local limitweek_self = limitday - g_NoDiffMatch_LimitData[plimit]
            g_NoDiffMatch_itemctl[i].limit:Hide()          
            if limitweek_self <= 0 then
                g_NoDiffMatch_itemctl[i].act:Disable()
            else
                g_NoDiffMatch_itemctl[i].act:SetProperty("CornerChar","TopLeft "..limitweek_self )
                g_NoDiffMatch_itemctl[i].act:Enable()
            end
        end   
    end

    if g_NoDiffMatch_Curpage == 1 then
        NoDiffMatch_Shop_UpPage:Disable()
    else
        NoDiffMatch_Shop_UpPage:Enable()
    end
    
    if g_NoDiffMatch_Curpage*g_NoDiffMatch_PerPage >= tonumber(Lua_GetZBSShopTotalCount(g_NoDiffMatch_Type)) then
        NoDiffMatch_Shop_DownPage:Disable()
    else
        NoDiffMatch_Shop_DownPage:Enable()
    end
    
    local npagecount = 0
    if Lua_GetZBSShopTotalCount(g_NoDiffMatch_Type) <= g_NoDiffMatch_PerPage then
        npagecount = 1
    elseif math.mod(Lua_GetZBSShopTotalCount(g_NoDiffMatch_Type), g_NoDiffMatch_PerPage) == 0  then
        npagecount = math.floor(Lua_GetZBSShopTotalCount(g_NoDiffMatch_Type)/g_NoDiffMatch_PerPage)
    else
        npagecount = math.floor(Lua_GetZBSShopTotalCount(g_NoDiffMatch_Type)/g_NoDiffMatch_PerPage) + 1
    end
    NoDiffMatch_Shop_CurrentlyPage:SetText( ScriptGlobal_Format("#{QQSD_220801_17}",g_NoDiffMatch_Curpage, npagecount) )


  	this:Show();
end 

--================================================
-- 界面的默认相对位置
--================================================
function NoDiffMatch_Shop_ResetPos()
	NoDiffMatch_Shop_Frame:SetProperty("UnifiedXPosition", g_NoDiffMatch_Shop_Frame_UnifiedXPosition);
	NoDiffMatch_Shop_Frame:SetProperty("UnifiedYPosition", g_NoDiffMatch_Shop_Frame_UnifiedYPosition); 
end 

function NoDiffMatch_Shop_Close() 
    g_NoDiffMatch_Curpage = 1
	this:Hide();
end
 
function NoDiffMatch_Shop_Btn_Clicked(index)  
    if index < 1 or index > g_NoDiffMatch_PerPage then
        return
    end

    local tblinfo= Lua_GetZBSShopData(g_NoDiffMatch_Type, g_NoDiffMatch_Curpage, g_NoDiffMatch_PerPage)	
	if type(tblinfo) ~= "table" then
		return
    end 
    
    if table.getn(tblinfo) < index then
        return
    end
    
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("buyitem")
        Set_XSCRIPT_ScriptID( 999491 )
        Set_XSCRIPT_Parameter( 0, g_NoDiffMatch_TargetID ); 
        Set_XSCRIPT_Parameter( 1, g_NoDiffMatch_Type ); 
        Set_XSCRIPT_Parameter( 2, g_NoDiffMatch_Curpage ); 
        Set_XSCRIPT_Parameter( 3, index ); 
        Set_XSCRIPT_ParamCount( 4 ); 
    Send_XSCRIPT() 

end

function NoDiffMatch_Shop_PageDown()
    if g_NoDiffMatch_Curpage*g_NoDiffMatch_PerPage < Lua_GetZBSShopTotalCount(g_NoDiffMatch_Type) then
        g_NoDiffMatch_Curpage = g_NoDiffMatch_Curpage + 1
        NoDiffMatch_Shop_Update()
    end
end


function NoDiffMatch_Shop_PageUp()
    if g_NoDiffMatch_Curpage > 1 then
        g_NoDiffMatch_Curpage = g_NoDiffMatch_Curpage - 1
        NoDiffMatch_Shop_Update()
    end
end

function NoDiffMatch_Shop_FenYe(nIndex)
    if nIndex < 1 or nIndex > 3 then
        return
    end
    g_NoDiffMatch_Type = nIndex
    g_NoDiffMatch_Curpage = 1
    NoDiffMatch_Shop_Update()
end

function NoDiffMatch_Shop_Update()
    if g_NoDiffMatch_Type < 1 or g_NoDiffMatch_Type > 3 then
        return
    end
    
    Clear_XSCRIPT()
       Set_XSCRIPT_Function_Name("RefreshUI")
       Set_XSCRIPT_ScriptID( 999491 )
       Set_XSCRIPT_Parameter( 0, g_NoDiffMatch_TargetID ); 
       Set_XSCRIPT_Parameter( 1, g_NoDiffMatch_Type ); 
       Set_XSCRIPT_Parameter( 2, g_NoDiffMatch_Curpage ); 
       Set_XSCRIPT_Parameter( 3, 2 ); 
       Set_XSCRIPT_ParamCount( 4 ); 
    Send_XSCRIPT() 
end
