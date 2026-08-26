local YearEndBonus_Preview_Frame_UnifiedXPosition = 0
local YearEndBonus_Preview_Frame_UnifiedYPosition = 0    
local g_YearEndBonus_Preview_listitem ={}
local g_YearEndBonus_Preview_ItemType =3
local g_YearEndBonus_Preview_DaiBiName =
{
    [1] = "#{HKCJ_241127_104}",
    [2] = "#{HKCJ_241127_105}",
    [3] = "#{HKCJ_241127_106}", 
} 
local g_YearEndBonus_Preview_NameColor =
{
    [1] = "#{HKCJ_241127_112}",
    [2] = "#{HKCJ_241127_113}",
    [3] = "#{HKCJ_241127_114}", 
    [4] = "#{HKCJ_241127_115}", 
} 
local g_YearEndBonus_Preview_DaiBiImg =
{ 
    [1] = "set:YearEndBonus image:Icon_ZBL",
    [2] = "set:YearEndBonus image:Icon_QZL",
    [3] = "set:YearEndBonus image:Icon_WHL", 
} 

--*********************************
-- PreLoad
--*********************************
function YearEndBonus_Preview_PreLoad()
	this : RegisterEvent( "HKCJ_JIANGCHI_SHOW" );					--   
	this : RegisterEvent(" ADJEST_UI_POS",false)
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- ??????????
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- ????
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- ???? 
end

--*********************************
-- OnLoad
--*********************************
function YearEndBonus_Preview_OnLoad() 
    -- 保存界面的默认相对位置
	YearEndBonus_Preview_Frame_UnifiedXPosition	= YearEndBonus_Preview_Frame:GetProperty("UnifiedXPosition");
    YearEndBonus_Preview_Frame_UnifiedYPosition	= YearEndBonus_Preview_Frame:GetProperty("UnifiedYPosition"); 
end

--================================================
-- 界面的默认相对位置
--================================================
function YearEndBonus_Preview_ResetPos()
	YearEndBonus_Preview_Frame:SetProperty("UnifiedXPosition", YearEndBonus_Preview_Frame_UnifiedXPosition);
	YearEndBonus_Preview_Frame:SetProperty("UnifiedYPosition", YearEndBonus_Preview_Frame_UnifiedYPosition); 
end 

--**********************************
-- ONEvent
--**********************************
function YearEndBonus_Preview_OnEvent( event ) 
    if ( event == "HKCJ_JIANGCHI_SHOW" ) then  
        g_YearEndBonus_Preview_ItemType = 1  
        YearEndBonus_Preview_PageBtn3:SetCheck(1) 
        YearEndBonus_Preview_Open() 
        this:Show()   
    elseif event == "VIEW_RESOLUTION_CHANGED" then
		YearEndBonus_Preview_ResetPos() 
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		YearEndBonus_Preview_Close()   
	elseif event == "ADJEST_UI_POS" then
        YearEndBonus_Preview_ResetPos() 	 
    end
end
--**********************************
-- 关睜
--**********************************
function YearEndBonus_Preview_Close()  
    this:Hide()
end 
function YearEndBonus_Preview_OnHiden() 
    YearEndBonus_Preview_Close()
end 
--**********************************
-- 打开界面
--**********************************
function YearEndBonus_Preview_Open()    
    local hkcj_gift = Lua_GetHKCJGiftInfo()
    if type(hkcj_gift) ~= "table" then
        return
    end 
    for i = 1, table.getn(g_YearEndBonus_Preview_listitem) do
		if g_YearEndBonus_Preview_listitem[i] ~= nil then
			g_YearEndBonus_Preview_listitem[i] = nil
		end
    end 
    YearEndBonus_Preview_Award_List:Clear()  
    local idx = 1 
    for jlid, jlvalue in ipairs(hkcj_gift[g_YearEndBonus_Preview_ItemType]) do
        if jlvalue.inGiftShow == 1 then
            local bar1 = YearEndBonus_Preview_Award_List:AddChild("YearEndBonus_Preview_Award_ItemBK")
			if not bar1 then
			   break
            end    
            if jlvalue.IsPreView == 1 then
                bar1:GetSubItem("YearEndBonus_Preview_Award_IconEye"):Show()
            else
                bar1:GetSubItem("YearEndBonus_Preview_Award_IconEye"):Hide()
            end 
            local id  = jlvalue.ItemID
            local num = jlvalue.ItemNum
            local name= jlvalue.ItemName
            local Itemlevel=jlvalue.ItemType 
            local theAction = DataPool:CreateBindActionItemForShow(id, num)
		    if theAction:GetID() ~= 0 then
                bar1:GetSubItem("YearEndBonus_Preview_Award_Icon"):SetActionItem(theAction:GetID()); 
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemName"):SetText(ScriptGlobal_Format(g_YearEndBonus_Preview_NameColor[Itemlevel],name))
            end 
            bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPrice"):SetText(jlvalue.SelDaiBi)
            bar1:GetSubItem("YearEndBonus_Preview_Award_IconEye"):SetEvent("MouseLClick", string.format("YearEndBonus_Preview_Incom_Eye(%d,%d)", g_YearEndBonus_Preview_ItemType, jlvalue.TabID))   
            bar1:GetSubItem("YearEndBonus_Preview_Award_ItemYB"):SetText(ScriptGlobal_Format("#{HKCJ_241127_14}",jlvalue.YuanBao)) 
            bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPrice"):SetText(ScriptGlobal_Format("#{HKCJ_241127_99}",g_YearEndBonus_Preview_DaiBiName[g_YearEndBonus_Preview_ItemType],jlvalue.SelDaiBi)) 
            if jlvalue.SelDaiBi > 0 then                  
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPriceTtile"):SetText("#{HKCJ_241127_99}")               
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPrice"):SetText(ScriptGlobal_Format("#{HKCJ_241127_140}",jlvalue.SelDaiBi)) 
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPrice"):Show()
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPriceIcon"):Show()
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPriceIcon"):SetProperty("Image", g_YearEndBonus_Preview_DaiBiImg[g_YearEndBonus_Preview_ItemType]);
            else                
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPriceTtile"):SetText("#{HKCJ_241127_137}") 
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPrice"):Hide()
                bar1:GetSubItem("YearEndBonus_Preview_Award_ItemPriceIcon"):Hide()
            end
            g_YearEndBonus_Preview_listitem[idx] = bar1 
            idx = idx + 1
        end
    end   
    
end 

--预览
function YearEndBonus_Preview_Incom_Eye(shopid,tabid)
    local hkcj_gift = Lua_GetHKCJGiftInfo()
    if type(hkcj_gift) ~= "table" then
        return
    end  
    local itemid = hkcj_gift[shopid][tabid].ItemID
    if itemid >=10140000 then
        local nExteriorRideId = Exterior:LuaFnGetExteriorIdByItem(itemid)
        PushEvent("OPEN_RIDE_PREVIEW", nExteriorRideId)
    else
        local FACEID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
        local HAIRID, HAIRIDIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
        PushEvent("OPEN_DRESSPREVIEW", itemid, HAIRID, FACEID)  --??\??\?? 
    end 
end   
function YearEndBonus_Preview_PageClicked(itemtype)
    g_YearEndBonus_Preview_ItemType = itemtype
    YearEndBonus_Preview_Open()
end
