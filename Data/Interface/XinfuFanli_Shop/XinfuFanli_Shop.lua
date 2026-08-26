local g_XinfuFanli_Shop_Frame_UnifiedXPosition;
local g_XinfuFanli_Shop_Frame_UnifiedYPosition;  

local g_XinfuFanli_Shop_Curpage = 2
local g_XinfuFanli_Shop_TotalPage= 0
local g_XinfuFanli_Shop_PerPage =12
local g_XinfuFanli_Shop_itemctl = {}  
local g_XinfuFanli_Shop_TargetID = 0
local g_XinfuFanli_Shop_NpcId=0  
local g_XinfuFanli_Shop_listitem = {} 
local g_XinfuFanli_MainDian_listitem = {}
local g_XinfuFanli_MainDian_info = { 
    [1] = {     --周活跃
        cxid   = 1,     --埋点索引
        target = 400,   --周活跃400
        fanli  = 20,    --返利值 
        maxcount= 0,    --周最大值
        isauto = 1,     --是否自动给奖
        title       =   "#{XFFL_250522_21}",
        targettext  =   "#{XFFL_250522_23}",
        jingdu      =   "#{XFFL_250522_25}",
        image       = "set:Huodong_19 image:Huodong_19_13",
        yilingqu    = "#{XFFL_250522_39}",
        weiwancheng = "#{XFFL_250522_40}"
    },
    [2] = {     --周活跃
        cxid   = 2,
        target = 800,   --周活跃800
        fanli  = 30, 
        maxcount= 0,
        isauto = 1,     --是否自动给奖
        title  = "#{XFFL_250522_22}",
        targettext="#{XFFL_250522_23}",
        jingdu = "#{XFFL_250522_25}",
        image       = "set:Huodong_19 image:Huodong_19_13",
        yilingqu    = "#{XFFL_250522_39}",
        weiwancheng = "#{XFFL_250522_40}"
    },
    [3] = {     --神工值
        cxid    = 3,
        target  = 200,
        fanli   = 20, 
        maxcount= 0,
        isauto  = 1,     --是否自动给奖
        title   = "#{XFFL_250522_28}",
        targettext="#{XFFL_250522_29}",
        jingdu  = "#{XFFL_250522_25}",
        image       = "set:Huodong_19 image:Huodong_19_14",
        yilingqu    = "#{XFFL_250522_39}",
        weiwancheng = "#{XFFL_250522_40}"
    },
    [4] = {     --
        cxid   = 4,
        target = 4,
        fanli  = 20, 
        maxcount= 0,
        isauto = 1,     --是否自动给奖
        title   = "#{XFFL_250522_32}",
        targettext="#{XFFL_250522_33}",
        jingdu  = "#{XFFL_250522_25}",
        image       = "set:CircularTaskTool13 image:CircularTaskTool13_1",
        yilingqu    = "#{XFFL_250522_39}",
        weiwancheng = "#{XFFL_250522_40}"
    },
    
    [5] = {
        cxid   = 5,
        target = 4,
        fanli  = 10, 
        maxcount= 0,
        isauto = 1,     --是否自动给奖
        title   = "#{XFFL_250522_34}",
        targettext="#{XFFL_250522_35}",
        jingdu  = "#{XFFL_250522_25}",
        image       = "set:Huodong_4 image:Huodong_4_6",
        yilingqu    = "#{XFFL_250522_39}", 
        weiwancheng = "#{XFFL_250522_40}"
    },
    [6] = {
        cxid   = 6,
        target = 350,   --日活跃350
        fanli  = 0, 
        maxcount= 4,
        itemidx = 1,
        isauto = 0,     --是否自动给奖
        title   = "#{XFFL_250522_44}",
        targettext="#{XFFL_250522_43}",
        jingdu  = "#{XFFL_250522_25}",
        image       = "set:Huodong_19 image:Huodong_19_13",
        wancheng    = "#{XFFL_250522_47}",
        yilingqu    = "#{XFFL_250522_55}",
        weiwancheng = "#{XFFL_250522_56}"
    },
}
function XinfuFanli_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT")  
	this:RegisterEvent("UPDATE_XFFL_SHOP") 
end

function XinfuFanli_Shop_OnEvent(event) 
    if event == "UPDATE_XFFL_SHOP" then  
        if tonumber(arg0) == 1 then
            this:Show()
        end  
        XinfuFanli_Shop_OnShown(g_XinfuFanli_Shop_Curpage)
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		XinfuFanli_Shop_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		XinfuFanli_Shop_Close()
	elseif event == "ADJEST_UI_POS" then
        XinfuFanli_Shop_ResetPos() 	 
	end
end

function XinfuFanli_Shop_OnLoad()  
	-- 保存界面的默认相对位置
	g_XinfuFanli_Shop_Frame_UnifiedXPosition	= XinfuFanli_Shop_Frame:GetProperty("UnifiedXPosition");
    g_XinfuFanli_Shop_Frame_UnifiedYPosition	= XinfuFanli_Shop_Frame:GetProperty("UnifiedYPosition");  
end 

function XinfuFanli_Shop_OnShown(tabtype) 
    if tabtype == 1 then
        g_XinfuFanli_Shop_Curpage = 1
        XinfuFanLi_Shop_UpdateShop()   
        XinfuFanli_Shop_ItemClient:Show() 
        XinfuFanli_Shop_TaskClient:Hide()   
        XinfuFanli_Shop_Task2BK:Hide()
        XinfuFanli_Shop_YQ1:SetCheck(1)
        XinfuFanli_Shop_YQ2:SetCheck(0)
    else 
        g_XinfuFanli_Shop_Curpage = 2
        XinfuFanLi_Shop_UpdateMainDian() 
        XinfuFanli_Shop_ItemClient:Hide()    
        XinfuFanli_Shop_TaskClient:Show()  
        XinfuFanli_Shop_Task2BK:Show()
        XinfuFanli_Shop_YQ1:SetCheck(0)
        XinfuFanli_Shop_YQ2:SetCheck(1)
    end 
    XinfuFanli_RefreshTips()
end 
--更新商店界面
function XinfuFanLi_Shop_UpdateShop()
    for i = 1, table.getn(g_XinfuFanli_Shop_listitem) do
		if g_XinfuFanli_Shop_listitem[i] ~= nil then
			g_XinfuFanli_Shop_listitem[i] = nil
		end
    end
    local g_ShopTbl_info     = Lua_GetNewSvrFanLiShopTableInfo() 
    local g_SelfData_info    = Lua_GetNewSvrFanLiDataInfo()
    local selfdaibi          = g_SelfData_info.Daibi
    local showredtips        = 0
    XinfuFanli_Shop_ItemList:Clear()  
    for i=1,table.getn(g_ShopTbl_info) do
		--第一列
		local bar1 = XinfuFanli_Shop_ItemList:AddChild("XinfuFanli_Shop_Item1BK")
        if not bar1 then
            PushDebugMessage("bar1 nil")
    	    break
        end
        local cxid    = g_ShopTbl_info[i].CXID
        local itemid  = g_ShopTbl_info[i].ItemID 
        local itemnum = g_ShopTbl_info[i].ItemNum
        local daibi   = g_ShopTbl_info[i].Price 
        local limitnum= g_ShopTbl_info[i].LimitNum
        if g_ShopTbl_info[i].LimitNum > 0 then
            limitnum = g_ShopTbl_info[i].LimitNum - g_SelfData_info.BuyNum[cxid]
        else
            limitnum = 0
        end 
        -- 道具展示区域
	    local theAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
	    if theAction:GetID() ~= 0 then
            bar1:GetSubItem("XinfuFanli_Shop_Item1"):SetActionItem(theAction:GetID())
            bar1:GetSubItem("XinfuFanli_Shop_Item1_NameText"):SetText(ScriptGlobal_Format("#{XFFL_250522_57}",theAction:GetName())) 
        end 
        bar1:GetSubItem("XinfuFanli_Shop_Item1_Button"):SetEvent("MouseLClick", string.format("XinfuFanli_Shop_Item1_Buy(%d)", i))   
        bar1:GetSubItem("XinfuFanli_Shop_Item1Text"):SetText(ScriptGlobal_Format("#{XFFL_250522_08}",daibi))   
        bar1:GetSubItem("XinfuFanli_Shop_Item1_LockImg"):Hide()    
        if g_ShopTbl_info[i].LimitNum > 0 then
            bar1:GetSubItem("XinfuFanli_Shop_Item1_LimitText"):SetText(ScriptGlobal_Format("#{XFFL_250522_09}",limitnum))    
        else
            bar1:GetSubItem("XinfuFanli_Shop_Item1_LimitText"):Hide()
        end
        if limitnum <= 0 and g_ShopTbl_info[i].LimitNum > 0 then
            bar1:GetSubItem("XinfuFanli_Shop_Item1_Button"):Disable()
            bar1:GetSubItem("XinfuFanli_Shop_Item1_LimitText"):SetText("#{XFFL_250522_10}")    
            bar1:GetSubItem("XinfuFanli_Shop_Item1_LockImg"):Show()
        elseif selfdaibi >= daibi then 
            showredtips = 1
        end

		g_XinfuFanli_Shop_listitem[i] = bar1
    end
    if showredtips == 1 then
        XinfuFanli_Shop_YQ1_Tips:Show()
    else
        XinfuFanli_Shop_YQ1_Tips:Hide()
    end
    XinfuFanli_Shop_Text1:SetText(ScriptGlobal_Format("#{XFFL_250522_08}",selfdaibi))
    XinfuFanli_Shop_Task1_TitleText:Hide()
    XinfuFanli_Shop_Task2_TitleText:Hide()
    XinfuFanli_Shop_Text1:Show() 
    
end
--更新埋点界面
function XinfuFanLi_Shop_UpdateMainDian()
    for i = 1, table.getn(g_XinfuFanli_MainDian_listitem) do
		if g_XinfuFanli_MainDian_listitem[i] ~= nil then
			g_XinfuFanli_MainDian_listitem[i] = nil
		end
    end
    
    XinfuFanli_Shop_TaskList:Clear()   
    local g_SelfData_info    = Lua_GetNewSvrFanLiDataInfo() 
    local g_GiftData_info    = Lua_GetNewSvrFanLiGiftTableInfo() 
    if table.getn(g_GiftData_info) < 1 then
        PushDebugMessage("table size err")
        return
    end
    XinfuFanli_Shop_YQ2_Tips:Hide()
    --每周
    for i=1, table.getn(g_XinfuFanli_MainDian_info)-1 do
		--第一列
		local bar1 = XinfuFanli_Shop_TaskList:AddChild("XinfuFanli_Shop_Task1BK")
        if not bar1 then
            PushDebugMessage("XinfuFanli_Shop_Task1BK nil")
    	   break
        end    
        
        local maidianinfo = g_SelfData_info.maidian[g_XinfuFanli_MainDian_info[i].cxid]   
        bar1:GetSubItem("XinfuFanli_Shop_Task1Text"):SetText(g_XinfuFanli_MainDian_info[i].title)    
        bar1:GetSubItem("XinfuFanli_Shop_Task1_UsageText"):SetText(ScriptGlobal_Format(g_XinfuFanli_MainDian_info[i].targettext, g_XinfuFanli_MainDian_info[i].target)) 
        if g_XinfuFanli_MainDian_info[i].isauto == 1 then
            bar1:GetSubItem("XinfuFanli_Shop_Task1_GetText"):SetText(ScriptGlobal_Format(g_XinfuFanli_MainDian_info[i].jingdu,maidianinfo.lingqu,1))      
            if g_XinfuFanli_MainDian_info[i].target == 4 then
                bar1:GetSubItem("XinfuFanli_Shop_Task1_GetText"):SetText(ScriptGlobal_Format(g_XinfuFanli_MainDian_info[i].jingdu,maidianinfo.curcount,g_XinfuFanli_MainDian_info[i].target))           
            end
        end
        if g_XinfuFanli_MainDian_info[i].fanli > 0 then
            bar1:GetSubItem("XinfuFanli_Shop_Task1_TokenText"):SetText(ScriptGlobal_Format("#{XFFL_250522_24}",g_XinfuFanli_MainDian_info[i].fanli))   
        else            
            bar1:GetSubItem("XinfuFanli_Shop_Task1_TokenText"):Hide()
        end
        if maidianinfo.lingqu == 1 or (maidianinfo.lingqucount>=g_XinfuFanli_MainDian_info[i].maxcount and g_XinfuFanli_MainDian_info[i].maxcount > 0) then 
            bar1:GetSubItem("XinfuFanli_Shop_Task1_Button"):SetText(g_XinfuFanli_MainDian_info[i].yilingqu)  
            bar1:GetSubItem("XinfuFanli_Shop_Task1_Button"):Disable()
        elseif maidianinfo.curcount >= g_XinfuFanli_MainDian_info[i].target then  --完成未领取
            bar1:GetSubItem("XinfuFanli_Shop_Task1_Button"):SetText(g_XinfuFanli_MainDian_info[i].wancheng)  
            bar1:GetSubItem("XinfuFanli_Shop_Task1_Button"):Enable() 
            bar1:GetSubItem("XinfuFanli_Shop_Task1_Button"):SetEvent("MouseLClick", string.format("XinfuFanli_MainDian_LingQu(%d)", i))   
            XinfuFanli_Shop_YQ2_Tips:Show()    
        else
            bar1:GetSubItem("XinfuFanli_Shop_Task1_Button"):SetText(g_XinfuFanli_MainDian_info[i].weiwancheng) 
            bar1:GetSubItem("XinfuFanli_Shop_Task1_Button"):Disable()  
        end 
        
        bar1:GetSubItem("XinfuFanli_Shop_Task1"):SetProperty("Image", g_XinfuFanli_MainDian_info[i].image)
		g_XinfuFanli_MainDian_listitem[i] = bar1
    end
    
    --每日部分
    local maidianinfo = g_SelfData_info.maidian[g_XinfuFanli_MainDian_info[6].cxid]   
    XinfuFanli_Shop_Task2_WeekText:SetText("#{XFFL_250522_52}") 
    XinfuFanli_Shop_Task2:SetText(ScriptGlobal_Format(g_XinfuFanli_MainDian_info[6].jingdu,maidianinfo.lingqucount,g_XinfuFanli_MainDian_info[6].maxcount))      
    local theAction = DataPool:CreateBindActionItemForShow(g_GiftData_info[1].ItemID, 1)
    if theAction:GetID() ~= 0 then
        XinfuFanli_Shop_Task2:SetActionItem(theAction:GetID()) 
    end 
    XinfuFanli_Shop_Task2_UsageText:SetText(ScriptGlobal_Format(g_XinfuFanli_MainDian_info[6].targettext, g_XinfuFanli_MainDian_info[6].target)) 
    XinfuFanli_Shop_Task2Text:SetText(g_XinfuFanli_MainDian_info[6].title)       
    XinfuFanli_Shop_Task1_Button_Tips:Hide()
    if maidianinfo.lingqu == 1 or (maidianinfo.lingqucount>=g_XinfuFanli_MainDian_info[6].maxcount and g_XinfuFanli_MainDian_info[6].maxcount > 0) then 
        XinfuFanli_Shop_Task2_ButtonNULL:SetProperty("Image","set:ZNQ_ChouJiang image:ZNQ_ChouJiang_YLQ_BK")  
        XinfuFanli_Shop_Task2_Button:Hide()
        XinfuFanli_Shop_Task2_ButtonNULL:Show()
    elseif maidianinfo.curcount >= g_XinfuFanli_MainDian_info[6].target then  --完成未领取
        XinfuFanli_Shop_Task2_ButtonNULL:Hide()
        XinfuFanli_Shop_Task2_Button:Show()  
        XinfuFanli_Shop_Task1_Button_Tips:Show()
        XinfuFanli_Shop_YQ2_Tips:Show()    
    else
        XinfuFanli_Shop_Task2_ButtonNULL:SetProperty("Image","set:XinfuFanli_Shop1 image:XinfuFanli_Shop_NoGet") 
        XinfuFanli_Shop_Task2_Button:Hide()  
        XinfuFanli_Shop_Task2_ButtonNULL:Show()
    end 
    --收尾    
    XinfuFanli_Shop_Task1_TitleText:SetText(ScriptGlobal_Format("#{XFFL_250522_26}",g_SelfData_info.maidian[2].curcount,2000))
    XinfuFanli_Shop_Task2_TitleText:SetText(ScriptGlobal_Format("#{XFFL_250522_30}",g_SelfData_info.maidian[3].curcount,2000))  
    XinfuFanli_Shop_Task1_TitleText:Show()
    XinfuFanli_Shop_Task2_TitleText:Show() 
    XinfuFanli_Shop_Text1:SetText(ScriptGlobal_Format("#{XFFL_250522_08}",g_SelfData_info.Daibi))

end
--================================================
-- 界面的默认相对位置
--================================================
function XinfuFanli_Shop_ResetPos()
	XinfuFanli_Shop_Frame:SetProperty("UnifiedXPosition", g_XinfuFanli_Shop_Frame_UnifiedXPosition);
	XinfuFanli_Shop_Frame:SetProperty("UnifiedYPosition", g_XinfuFanli_Shop_Frame_UnifiedYPosition); 
end 
--关闭
function XinfuFanli_Shop_Hidden()
    XinfuFanli_Shop_Close()
end
function XinfuFanli_Shop_Close()  
    g_XinfuFanli_Shop_Curpage = 2
	this:Hide();
end

function XinfuFanli_Shop_Item1_Buy(idx)
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("Buy")
        Set_XSCRIPT_ScriptID( 889917 )
        Set_XSCRIPT_Parameter( 0, idx ); 
        Set_XSCRIPT_Parameter( 1, 1 ); 
        Set_XSCRIPT_ParamCount( 2 ); 
    Send_XSCRIPT() 
end

function XinfuFanli_MainDian_LingQu(idx)
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("LingQu")
        Set_XSCRIPT_ScriptID( 889917 )
        Set_XSCRIPT_Parameter( 0, idx );  
        Set_XSCRIPT_ParamCount( 1 ); 
    Send_XSCRIPT() 
end

function XinfuFanli_RefreshTips() 
    local g_ShopTbl_info     = Lua_GetNewSvrFanLiShopTableInfo()
    local g_SelfData_info    = Lua_GetNewSvrFanLiDataInfo()
    local selfdaibi          = g_SelfData_info.Daibi
    XinfuFanli_Shop_YQ1_Tips:Hide()
    XinfuFanli_Shop_YQ2_Tips:Hide()
    local isShowMaintip      = 0
    for i=1,table.getn(g_ShopTbl_info) do 
        local cxid    = g_ShopTbl_info[i].CXID
        local itemid  = g_ShopTbl_info[i].ItemID 
        local itemnum = 1
        local daibi   = g_ShopTbl_info[i].Price 
        local limitnum= g_ShopTbl_info[i].LimitNum
        if g_ShopTbl_info[i].LimitNum > 0 then
            limitnum = g_ShopTbl_info[i].LimitNum - g_SelfData_info.BuyNum[cxid]
        else
            limitnum = 0
        end  
        if not(limitnum <= 0 and g_ShopTbl_info[i].LimitNum > 0) and selfdaibi >= daibi then  
            XinfuFanli_Shop_YQ1_Tips:Show()
            isShowMaintip = 1
        end 
    end 
    for i=1, table.getn(g_XinfuFanli_MainDian_info) do		
        local maidianinfo = g_SelfData_info.maidian[g_XinfuFanli_MainDian_info[i].cxid]    
        if maidianinfo.curcount >= g_XinfuFanli_MainDian_info[i].target and not (maidianinfo.lingqu == 1) then  
            XinfuFanli_Shop_YQ2_Tips:Show()   
            isShowMaintip = 1
        end  
    end
    Lua_ShowQuickEnterPointTip(42,isShowMaintip) 
end

function XinfuFanli_Shop_Info_ShowHelp()
    PushEvent("QUEST_HELPINFO", "#{XFFL_250522_51}") 
end

function XinfuFanli_OpenURL()
    GameProduceLogin:OpenURL(GetWeblink("WEB_XFFL"))
end