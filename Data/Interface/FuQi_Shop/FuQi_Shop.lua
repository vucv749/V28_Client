-- fuqishop

---------------------------------------------------------------------------
local g_Controls = {};									-- ??
local g_PerPageNum = 12;                               -- ????????
local g_Position = "{{0.500000,-190.000000},{0.500000,-220.000000}}";
local g_DaiBiMD = 923
local g_Curpage = 1
local g_TargetId = -1
local MAX_OBJ_DISTANCE = 3.0;
---------------------------------------------------------------------------


--*********************************
-- PreLoad
--*********************************
function FuQi_Shop_PreLoad()
	this : RegisterEvent( "UI_COMMAND" );					-- UI_COMMAND
	this : RegisterEvent( "OPEN_FUQISHOP" );
	this : RegisterEvent( "OPEN_FUQISHOP_NPC" );
	this : RegisterEvent( "UPDATE_FUQISHOP" );
	this:RegisterEvent("ADJEST_UI_POS",false)
	this : RegisterEvent( "UPDATE_BWDAIBISHOPINFO" );	
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- ??????????
	this : RegisterEvent( "GAMELOGIN_SELECTCHARACTER" );	-- ????
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- ????
	this : RegisterEvent( "OBJECT_CARED_EVENT" );
end


--*********************************
-- OnLoad
--*********************************
function FuQi_Shop_OnLoad()
	g_Controls = {
		-- 框架
		Framework = FuQi_Shop_Frame;
		-- 介绍
		Introduce = FuQi_Shop_F5_Text;
		-- 购买确认
		BuyConfirm = {
			BuyConfirmText = FuQi_Shop_Num_Text;
			CheckButton = FuQi_Shop_TeamInfo;
		};
		-- 拥有的代币元宝
		MoneyInfo = FuQi_Shop_MoneyInfo_Text;
		Review = FuQi_Shop_ReviewBtn;
		PageUp = FuQi_Shop_UpPage;
		PageDown = FuQi_Shop_DownPage;
		CurrentPage = FuQi_Shop_CurrentlyPage;
		-- 物品
		ItemInfo = {
			-- 图标
			ActiveButton = {
				[1] = FuQi_Shop_Item1,
				[2] = FuQi_Shop_Item2,
				[3] = FuQi_Shop_Item3,
				[4] = FuQi_Shop_Item4,
				[5] = FuQi_Shop_Item5,
				[6] = FuQi_Shop_Item6,
				[7] = FuQi_Shop_Item7,
				[8] = FuQi_Shop_Item8,
				[9] = FuQi_Shop_Item9,
				[10] = FuQi_Shop_Item10,
				[11] = FuQi_Shop_Item11,
				[12] = FuQi_Shop_Item12,
			};
			-- 数量
			Num = {
				[1] = FuQi_Shop_Item1Num,
				[2] = FuQi_Shop_Item2Num,
				[3] = FuQi_Shop_Item3Num,
				[4] = FuQi_Shop_Item4Num,
				[5] = FuQi_Shop_Item5Num,
				[6] = FuQi_Shop_Item6Num,
				[7] = FuQi_Shop_Item7Num,
				[8] = FuQi_Shop_Item8Num,
				[9] = FuQi_Shop_Item9Num,
				[10] = FuQi_Shop_Item10Num,
				[11] = FuQi_Shop_Item11Num,
				[12] = FuQi_Shop_Item12Num,
			};
			-- 蒙红
			Mask = {
				[1] = FuQi_Shop_ItemInfo1_BK,
				[2] = FuQi_Shop_ItemInfo2_BK,
				[3] = FuQi_Shop_ItemInfo3_BK,
				[4] = FuQi_Shop_ItemInfo4_BK,
				[5] = FuQi_Shop_ItemInfo5_BK,
				[6] = FuQi_Shop_ItemInfo6_BK,
				[7] = FuQi_Shop_ItemInfo7_BK,
				[8] = FuQi_Shop_ItemInfo8_BK,
				[9] = FuQi_Shop_ItemInfo9_BK,
				[10] = FuQi_Shop_ItemInfo10_BK,
				[11] = FuQi_Shop_ItemInfo11_BK,
				[12] = FuQi_Shop_ItemInfo12_BK,
			};
			-- 物品名称
			ItemName = {
				[1] = FuQi_Shop_ItemInfo1_Text,
				[2] = FuQi_Shop_ItemInfo2_Text,
				[3] = FuQi_Shop_ItemInfo3_Text,
				[4] = FuQi_Shop_ItemInfo4_Text,
				[5] = FuQi_Shop_ItemInfo5_Text,
				[6] = FuQi_Shop_ItemInfo6_Text,
				[7] = FuQi_Shop_ItemInfo7_Text,
				[8] = FuQi_Shop_ItemInfo8_Text,
				[9] = FuQi_Shop_ItemInfo9_Text,
				[10] = FuQi_Shop_ItemInfo10_Text,
				[11] = FuQi_Shop_ItemInfo11_Text,
				[12] = FuQi_Shop_ItemInfo12_Text,
			};
			-- 价格
			Price = {
				[1] = FuQi_Shop_ItemInfo1_Price,
				[2] = FuQi_Shop_ItemInfo2_Price,
				[3] = FuQi_Shop_ItemInfo3_Price,
				[4] = FuQi_Shop_ItemInfo4_Price,
				[5] = FuQi_Shop_ItemInfo5_Price,
				[6] = FuQi_Shop_ItemInfo6_Price,
				[7] = FuQi_Shop_ItemInfo7_Price,
				[8] = FuQi_Shop_ItemInfo8_Price,
				[9] = FuQi_Shop_ItemInfo9_Price,
				[10] = FuQi_Shop_ItemInfo10_Price,
				[11] = FuQi_Shop_ItemInfo11_Price,
				[12] = FuQi_Shop_ItemInfo12_Price,
			};
			DaiBiPic = {
				[1] = FuQi_Shop_ItemInfo1_DaiBi,
				[2] = FuQi_Shop_ItemInfo2_DaiBi,
				[3] = FuQi_Shop_ItemInfo3_DaiBi,
				[4] = FuQi_Shop_ItemInfo4_DaiBi,
				[5] = FuQi_Shop_ItemInfo5_DaiBi,
				[6] = FuQi_Shop_ItemInfo6_DaiBi,
				[7] = FuQi_Shop_ItemInfo7_DaiBi,
				[8] = FuQi_Shop_ItemInfo8_DaiBi,
				[9] = FuQi_Shop_ItemInfo9_DaiBi,
				[10] = FuQi_Shop_ItemInfo10_DaiBi,
				[11] = FuQi_Shop_ItemInfo11_DaiBi,
				[12] = FuQi_Shop_ItemInfo12_DaiBi,
			};
		};
	};
end


--*********************************
-- OnEvent
--*********************************
function FuQi_Shop_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 99833701) then
		--刷新商店
		if (this:IsVisible()) then
			g_Controls.MoneyInfo:SetText(ScriptGlobal_Format("#{FQSD_230328_17}", Get_XParam_INT(0)))
			return
		end
	elseif (event == "OPEN_FUQISHOP_NPC") then
		g_TargetId = tonumber(arg0)
		g_TargetId = Target:GetServerId2ClientId(g_TargetId);
		this:CareObject(g_TargetId, 1, "FuQi_Shop");

		g_Curpage = 1
		FuQi_Shop_OnUpdateDaiBiShop()
		this:Show();

	elseif (event == "OPEN_FUQISHOP") then
		g_TargetId = -1
		g_Curpage = 1
		FuQi_Shop_OnUpdateDaiBiShop()
		this:Show();

	elseif (event == "UPDATE_FUQISHOP") then
		if (this:IsVisible()) then
			FuQi_Shop_OnUpdateDaiBiShop()
			return
		end
	elseif ( event == "VIEW_RESOLUTION_CHANGED" or event == "ADJEST_UI_POS") then
		-- 恢复默认位置
		g_Controls.Framework:SetProperty( "UnifiedPosition", g_Position );

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		FuQi_Shop_CloseShop()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= g_TargetId) then
			return
		end

		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关睜界面
			FuQi_Shop_CloseShop()
		end	
	end
end

--*********************************
-- 清繝控件
--*********************************
function FuQi_Shop_CleanupUIControls()
	FuQi_Shop_ReviewBtn:Hide()
	-- 购买确认
	if (DataPool:Lua_GetFuQiShopDBConfirmSkip() == 0) then
		g_Controls.BuyConfirm.CheckButton:SetCheck(1)
	else
		g_Controls.BuyConfirm.CheckButton:SetCheck(0)
	end

	-- 物品
	for	i = 1, table.getn(g_Controls.ItemInfo.ActiveButton) do
		g_Controls.ItemInfo.ActiveButton[i]:Enable()
		g_Controls.ItemInfo.ActiveButton[i]:SetActionItem(-1)
		g_Controls.ItemInfo.Num[i]:SetText("")
		g_Controls.ItemInfo.Mask[i]:Hide()
		g_Controls.ItemInfo.ItemName[i]:SetText("")
		g_Controls.ItemInfo.Price[i]:SetText("")
		g_Controls.ItemInfo.DaiBiPic[i]:Hide()
	end

	--持有元宝 和代币
	g_Controls.MoneyInfo:SetText("")
	g_Controls.CurrentPage:SetText("0/0")
end


--*********************************
-- 显示[代币商店]
--*********************************
function FuQi_Shop_OnUpdateDaiBiShop()
	-- 清繝控件
	FuQi_Shop_CleanupUIControls()

	local nDaibi = DataPool:GetPlayerMission_DataRound(g_DaiBiMD)

	--代币
	g_Controls.MoneyInfo:SetText(ScriptGlobal_Format("#{FQSD_230328_17}", nDaibi))

	--设置物品
	--获得此分页物品数量
	local tblinfo= DataPool:Lua_GetFuQiShopData(g_Curpage, g_PerPageNum)
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end

    if table.getn(tblinfo) > table.getn(g_Controls.ItemInfo.ActiveButton) then
        PushDebugMessage("data over size")
        return
    end

    for i = 1, table.getn(tblinfo) do
        local itemname = DataPool:LuaFnGetItemNameByTableIndex(tblinfo[i].itemid)

        g_Controls.ItemInfo.ItemName[i]:SetText("#cfff263"..itemname)

		g_Controls.ItemInfo.Price[i]:SetText("#Y"..tblinfo[i].daibiprice)

        local id = tblinfo[i].itemid
        local num= tblinfo[i].itemnum
        local limitweek= tblinfo[i].limitweek
		local totallimit= tblinfo[i].totallimit
		local nHasBuyNum= tblinfo[i].buynum
		local nOpenTime = tblinfo[i].opentime
        local theAction = DataPool:CreateBindActionItemForShow(id, num)
	    if theAction:GetID() ~= 0 then
	    	g_Controls.ItemInfo.ActiveButton[i]:SetActionItem(theAction:GetID())
        end
        g_Controls.ItemInfo.DaiBiPic[i]:Show()
        if limitweek <= 0 and totallimit <= 0 then
            g_Controls.ItemInfo.Num[i]:Hide()
        else
            local realnum = 0
           	if limitweek > 0 then
           		realnum = limitweek - nHasBuyNum
       	 	end
       	 	if totallimit > 0 then
           		realnum = totallimit - nHasBuyNum
       	 	end
       	 	if realnum > 0 then
       	 		g_Controls.ItemInfo.Num[i]:SetText(realnum)
       	 	else
  				g_Controls.ItemInfo.Price[i]:SetText("#{FQSD_230328_41}")--??
       	 		g_Controls.ItemInfo.Num[i]:SetText("")
       	 		g_Controls.ItemInfo.DaiBiPic[i]:Hide()
       	 	end
    	end
    	if tblinfo[i].opentime > 0 then
    		if tblinfo[i].weddingtime >= tblinfo[i].opentime then
    			g_Controls.ItemInfo.Mask[i]:Hide()
    		else
    			g_Controls.ItemInfo.Mask[i]:Show()
    			g_Controls.ItemInfo.Mask[i]:SetToolTip(ScriptGlobal_Format("#{FQSD_230328_12}", tblinfo[i].opentime))
    		end
    	else
    		g_Controls.ItemInfo.Mask[i]:Hide()
    	end
    end

    if g_Curpage == 1 then
        g_Controls.PageUp:Disable()
    else
        g_Controls.PageUp:Enable()
    end

    local nTotal = DataPool:Lua_GetFuQiShopTotalCount()
    if g_Curpage*g_PerPageNum >= nTotal then
        g_Controls.PageDown:Disable()
    else
        g_Controls.PageDown:Enable()
    end

    local npagecount = 0
    if nTotal <= g_PerPageNum then
        npagecount = 1
    elseif math.mod(nTotal, g_PerPageNum) == 0  then
        npagecount = math.floor(nTotal/g_PerPageNum)
    else
        npagecount = math.floor(nTotal/g_PerPageNum) + 1
    end
    g_Controls.CurrentPage:SetText( g_Curpage.."/"..npagecount)
	FuQi_Shop_MoneyInfo_DaiBi:Show()
end


--*********************************
-- 购买
--*********************************
function FuQi_Shop_ItemClicked(uiPos)
	
	if ( uiPos <= 0 or uiPos > g_PerPageNum ) then
		return
	end

	local tblinfo= DataPool:Lua_GetFuQiShopData(g_Curpage, g_PerPageNum)
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end

    if tblinfo[uiPos] == nil or tblinfo[uiPos].itemid <= 0 or tblinfo[uiPos].savepos < 0 then
        return
    end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("BuyItem")
		Set_XSCRIPT_ScriptID(998337)	
		Set_XSCRIPT_Parameter(0, tblinfo[uiPos].savepos);
		Set_XSCRIPT_Parameter(1, tblinfo[uiPos].itemid);
		Set_XSCRIPT_Parameter(2, 0);
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();


end

--试穿
function FuQi_Shop_OpenFitting()
	if IsIdleLogic() ~= 1 and IsMoveLogic() ~= 1 then
		SetNotifyTip("#{YBSD_081225_100}");
		return 0;
	end
	StopMove();

	if(IsWindowShow("Shop_MBuy")) then
		CloseWindow("Shop_MBuy", true);
	end

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end
	RestoreShopFitting();
	this:Show();
	MouseCmd_ShopFittingSet();
	SetNotifyTip("#{YBSD_081225_099}");
end

--*********************************
-- 购买确认
--*********************************
function FuQi_Shop_OnConfirmClick()

	if (DataPool:Lua_GetFuQiShopDBConfirmSkip() == 0) then
	
		DataPool:Lua_SetFuQiShopDBConfirmSkip(1)
   	else
   	
   		DataPool:Lua_SetFuQiShopDBConfirmSkip(0)
    end

	if (DataPool:Lua_GetFuQiShopDBConfirmSkip() == 0) then
		g_Controls.BuyConfirm.CheckButton:SetCheck(1)
	else
		g_Controls.BuyConfirm.CheckButton:SetCheck(0)
	end
end

function FuQi_Shop_CloseShop()

	if g_TargetId >= 0 then
		this:CareObject(g_TargetId, 0, "FuQi_Shop")
	end

	g_Curpage = 1
	g_TargetId = -1
	this:Hide()

	PushEvent("FUQISHOP_CONFIRM_HIDE")
end

--================================================
--点击商店下一页
--================================================
function FuQi_Shop_OnPageDownClick()
    if g_Curpage*g_PerPageNum < DataPool:Lua_GetFuQiShopTotalCount() then
        g_Curpage = g_Curpage + 1
       
        FuQi_Shop_OnUpdateDaiBiShop()

    end
end

--================================================
--点击商店上一页
--================================================
function FuQi_Shop_OnPageUpClick()
    if g_Curpage > 1 then
        g_Curpage = g_Curpage - 1
        FuQi_Shop_OnUpdateDaiBiShop()
    end
end
