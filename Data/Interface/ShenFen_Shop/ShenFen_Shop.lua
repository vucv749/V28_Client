
local ShenFen_Shop_GOODS_NUM = 12;
local ShenFen_Shop_GOODS_BUTTONS = {};
local ShenFen_Shop_GOODS_ITEMNUM = {};
local ShenFen_Shop_GOODS_DESCS = {};
local ShenFen_Shop_GOODS_PRICE = {};
local ShenFen_Shop_GOOD_BAD    = {};
local ShenFen_Shop_GOOD_Animate = {};
local ShenFen_Shop_GOOD = {0}

local g_ShenFen_Shop_nPageNum = 1;
local g_ShenFen_Shop_maxPage = 1;
local g_ShenFen_Shop_CurIdentity = -1 

local g_ShenFen_Shop_objCared = -1;
local g_ShenFen_Shop_ServerCareID = -1;

local MAX_OBJ_DISTANCE = 3.0;

--当前商店的商品数量
local	g_ShenFen_Shop_nTotalNum	= 0;

local g_ShenFen_Shop_Name = {
[1] = "#{SZSW_231228_19}",
[2] = "#{SZSW_231228_20}",
[3] = "#{SZSW_231228_21}",
[4] = "#{SZSW_231228_22}",
}

local g_ShenFen_Shop_Frame_UnifiedPosition;

--===============================================
-- PreLoad
--===============================================
function ShenFen_Shop_PreLoad()

	this:RegisterEvent("OPEN_SHENFEN_SHOP")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

--===============================================
-- OnLoad
--===============================================
function ShenFen_Shop_OnLoad()
	ShenFen_Shop_GOODS_BUTTONS[1] = ShenFen_Shop_Item1;
	ShenFen_Shop_GOODS_BUTTONS[2] = ShenFen_Shop_Item2;
	ShenFen_Shop_GOODS_BUTTONS[3] = ShenFen_Shop_Item3;
	ShenFen_Shop_GOODS_BUTTONS[4] = ShenFen_Shop_Item4;
	ShenFen_Shop_GOODS_BUTTONS[5] = ShenFen_Shop_Item5;
	ShenFen_Shop_GOODS_BUTTONS[6] = ShenFen_Shop_Item6;
	ShenFen_Shop_GOODS_BUTTONS[7] = ShenFen_Shop_Item7;
	ShenFen_Shop_GOODS_BUTTONS[8] = ShenFen_Shop_Item8;
	ShenFen_Shop_GOODS_BUTTONS[9] = ShenFen_Shop_Item9;
	ShenFen_Shop_GOODS_BUTTONS[10]= ShenFen_Shop_Item10;
	ShenFen_Shop_GOODS_BUTTONS[11]= ShenFen_Shop_Item11;
	ShenFen_Shop_GOODS_BUTTONS[12]= ShenFen_Shop_Item12;
	
	ShenFen_Shop_GOODS_ITEMNUM[1] = ShenFen_Shop_Item1Num;
	ShenFen_Shop_GOODS_ITEMNUM[2] = ShenFen_Shop_Item2Num;
	ShenFen_Shop_GOODS_ITEMNUM[3] = ShenFen_Shop_Item3Num;
	ShenFen_Shop_GOODS_ITEMNUM[4] = ShenFen_Shop_Item4Num;
	ShenFen_Shop_GOODS_ITEMNUM[5] = ShenFen_Shop_Item5Num;
	ShenFen_Shop_GOODS_ITEMNUM[6] = ShenFen_Shop_Item6Num;
	ShenFen_Shop_GOODS_ITEMNUM[7] = ShenFen_Shop_Item7Num;
	ShenFen_Shop_GOODS_ITEMNUM[8] = ShenFen_Shop_Item8Num;
	ShenFen_Shop_GOODS_ITEMNUM[9] = ShenFen_Shop_Item9Num;
	ShenFen_Shop_GOODS_ITEMNUM[10] = ShenFen_Shop_Item10Num;
	ShenFen_Shop_GOODS_ITEMNUM[11] = ShenFen_Shop_Item11Num;
	ShenFen_Shop_GOODS_ITEMNUM[12] = ShenFen_Shop_Item12Num;
	
	ShenFen_Shop_GOODS_DESCS[1] = ShenFen_Shop_ItemInfo1_Text;
	ShenFen_Shop_GOODS_DESCS[2] = ShenFen_Shop_ItemInfo2_Text;
	ShenFen_Shop_GOODS_DESCS[3] = ShenFen_Shop_ItemInfo3_Text;
	ShenFen_Shop_GOODS_DESCS[4] = ShenFen_Shop_ItemInfo4_Text;
	ShenFen_Shop_GOODS_DESCS[5] = ShenFen_Shop_ItemInfo5_Text;
	ShenFen_Shop_GOODS_DESCS[6] = ShenFen_Shop_ItemInfo6_Text;
	ShenFen_Shop_GOODS_DESCS[7] = ShenFen_Shop_ItemInfo7_Text;
	ShenFen_Shop_GOODS_DESCS[8] = ShenFen_Shop_ItemInfo8_Text;
	ShenFen_Shop_GOODS_DESCS[9] = ShenFen_Shop_ItemInfo9_Text;
	ShenFen_Shop_GOODS_DESCS[10]= ShenFen_Shop_ItemInfo10_Text;
	ShenFen_Shop_GOODS_DESCS[11]= ShenFen_Shop_ItemInfo11_Text;
	ShenFen_Shop_GOODS_DESCS[12]= ShenFen_Shop_ItemInfo12_Text;
	
	ShenFen_Shop_GOODS_PRICE[1] = ShenFen_Shop_ItemInfo1_Price;
	ShenFen_Shop_GOODS_PRICE[2] = ShenFen_Shop_ItemInfo2_Price;
	ShenFen_Shop_GOODS_PRICE[3] = ShenFen_Shop_ItemInfo3_Price;
	ShenFen_Shop_GOODS_PRICE[4] = ShenFen_Shop_ItemInfo4_Price;
	ShenFen_Shop_GOODS_PRICE[5] = ShenFen_Shop_ItemInfo5_Price;
	ShenFen_Shop_GOODS_PRICE[6] = ShenFen_Shop_ItemInfo6_Price;
	ShenFen_Shop_GOODS_PRICE[7] = ShenFen_Shop_ItemInfo7_Price;
	ShenFen_Shop_GOODS_PRICE[8] = ShenFen_Shop_ItemInfo8_Price;
	ShenFen_Shop_GOODS_PRICE[9] = ShenFen_Shop_ItemInfo9_Price;
	ShenFen_Shop_GOODS_PRICE[10]= ShenFen_Shop_ItemInfo10_Price;
	ShenFen_Shop_GOODS_PRICE[11]= ShenFen_Shop_ItemInfo11_Price;
	ShenFen_Shop_GOODS_PRICE[12]= ShenFen_Shop_ItemInfo12_Price;
	
	ShenFen_Shop_GOOD_BAD[1]  =     ShenFen_Shop_ItemInfo1_GB;
	ShenFen_Shop_GOOD_BAD[2]  =     ShenFen_Shop_ItemInfo2_GB;
	ShenFen_Shop_GOOD_BAD[3]  =     ShenFen_Shop_ItemInfo3_GB;
	ShenFen_Shop_GOOD_BAD[4]  =     ShenFen_Shop_ItemInfo4_GB;
	ShenFen_Shop_GOOD_BAD[5]  =     ShenFen_Shop_ItemInfo5_GB;
	ShenFen_Shop_GOOD_BAD[6]  =     ShenFen_Shop_ItemInfo6_GB;
	ShenFen_Shop_GOOD_BAD[7]  =     ShenFen_Shop_ItemInfo7_GB;
	ShenFen_Shop_GOOD_BAD[8]  =     ShenFen_Shop_ItemInfo8_GB;
	ShenFen_Shop_GOOD_BAD[9]  =     ShenFen_Shop_ItemInfo9_GB;
	ShenFen_Shop_GOOD_BAD[10] =     ShenFen_Shop_ItemInfo10_GB;
	ShenFen_Shop_GOOD_BAD[11] =     ShenFen_Shop_ItemInfo11_GB;
	ShenFen_Shop_GOOD_BAD[12] =     ShenFen_Shop_ItemInfo12_GB;
	
	ShenFen_Shop_GOOD_Animate[1] = ShenFen_Shop_Item1Animate
	ShenFen_Shop_GOOD_Animate[2] = ShenFen_Shop_Item2Animate
	ShenFen_Shop_GOOD_Animate[3] = ShenFen_Shop_Item3Animate
	ShenFen_Shop_GOOD_Animate[4] = ShenFen_Shop_Item4Animate
	ShenFen_Shop_GOOD_Animate[5] = ShenFen_Shop_Item5Animate
	ShenFen_Shop_GOOD_Animate[6] = ShenFen_Shop_Item6Animate
	ShenFen_Shop_GOOD_Animate[7] = ShenFen_Shop_Item7Animate
	ShenFen_Shop_GOOD_Animate[8] = ShenFen_Shop_Item8Animate
	ShenFen_Shop_GOOD_Animate[9] = ShenFen_Shop_Item9Animate
	ShenFen_Shop_GOOD_Animate[10] = ShenFen_Shop_Item10Animate
	ShenFen_Shop_GOOD_Animate[11] = ShenFen_Shop_Item11Animate
	ShenFen_Shop_GOOD_Animate[12] = ShenFen_Shop_Item12Animate
	
	 g_ShenFen_Shop_Frame_UnifiedPosition = ShenFen_Shop_Frame:GetProperty("UnifiedPosition");
	
end

--===============================================
-- OnEvent
--===============================================
function ShenFen_Shop_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99858501 ) then	
	
		if Get_XParam_INT( 0 ) <= 0 or Get_XParam_INT(3) <= 0 then
			ShenFen_Shop_Close()
			return
		end
		
		for i=1, ShenFen_Shop_GOODS_NUM  do
			ShenFen_Shop_GOOD_BAD[i]:Hide()
			ShenFen_Shop_GOODS_PRICE[i]:Show();
			ShenFen_Shop_GOOD[i] = 0
		end
		
		g_ShenFen_Shop_nTotalNum = 0;
		this:Show();

		--关心商人Obj
		g_ShenFen_Shop_ServerCareID = Get_XParam_INT(1)
		g_ShenFen_Shop_objCared = DataPool:GetNPCIDByServerID(g_ShenFen_Shop_ServerCareID);
		if( 0 > g_ShenFen_Shop_objCared ) then
			PushDebugMessage("server传过来的数据有问题。");
			return
		end
		this:CareObject(g_ShenFen_Shop_objCared, 1, "ShenFen_Shop");
		
		g_ShenFen_Shop_nTotalNum = Get_XParam_INT(2)
		g_ShenFen_Shop_CurIdentity = Get_XParam_INT(3)
		
		local curPage = Get_XParam_INT(4)		
		ShenFen_Shop_UpdatePage(curPage)
		
		OpenWindow("Packet")

		if(IsWindowShow("ShenFenShop_BulkBuying")) then
			CloseWindow("ShenFenShop_BulkBuying", true);
		end
		
		SetDefaultMouse();
		
	elseif (event == "OPEN_SHENFEN_SHOP") then
	
		if tonumber(arg2) <= 0 then
			ShenFen_Shop_Close()
			return
		end
		
		for i=1, ShenFen_Shop_GOODS_NUM  do
			ShenFen_Shop_GOOD_BAD[i]:Hide()
			ShenFen_Shop_GOODS_PRICE[i]:Show();
			ShenFen_Shop_GOOD[i] = 0
		end
		
		g_ShenFen_Shop_nTotalNum = 0;

		--关心商人Obj
		g_ShenFen_Shop_ServerCareID = tonumber(arg0)
		g_ShenFen_Shop_objCared = DataPool:GetNPCIDByServerID(g_ShenFen_Shop_ServerCareID);
		if( 0 > g_ShenFen_Shop_objCared ) then
			PushDebugMessage("server传过来的数据有问题。");
			return
		end
		this:CareObject(g_ShenFen_Shop_objCared, 1, "ShenFen_Shop");
		
		g_ShenFen_Shop_nTotalNum = tonumber(arg1)
		g_ShenFen_Shop_CurIdentity = tonumber(arg2)
		
		local curPage = tonumber(arg3)		
		ShenFen_Shop_UpdatePage(curPage)
		
		OpenWindow("Packet")

		if(IsWindowShow("ShenFenShop_BulkBuying")) then
			CloseWindow("ShenFenShop_BulkBuying", true);
		end
		
		SetDefaultMouse();
		this:Show();
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_ShenFen_Shop_objCared) then
			return;
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			SetDefaultMouse();
			this:CareObject(g_ShenFen_Shop_objCared, 0, "ShenFen_Shop");
			this:Hide();			
		end
			
	elseif (event == "ADJEST_UI_POS" ) then
		ShenFen_Shop_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenFen_Shop_Frame_On_ResetPos()

	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		ShenFen_Shop_Close();
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShenFen_Shop_Close();
		
	end
	
end

--===============================================
-- UpdatePage
--===============================================
function ShenFen_Shop_UpdatePage(thePage)
	
	--使用什么作为货币
	for i=1, ShenFen_Shop_GOODS_NUM  do
		ShenFen_Shop_GOOD_BAD[i]:Hide()
		ShenFen_Shop_GOODS_PRICE[i]:Show();
		ShenFen_Shop_GOOD_Animate[i]:Hide()
		ShenFen_Shop_GOOD[i] = 0
	end
	
	ShenFen_Shop_DragTitle:SetText("#{SZSW_231228_42}")
	if g_ShenFen_Shop_Name[g_ShenFen_Shop_CurIdentity] ~= nil then
		ShenFen_Shop_DragTitle:SetText(g_ShenFen_Shop_Name[g_ShenFen_Shop_CurIdentity])
	end

	local i = 1;
		
	-- 计算总页数
	local nTotalPage;
	if( g_ShenFen_Shop_nTotalNum < 1 ) then
		nTotalPage = 1;
	else
		nTotalPage = math.floor((g_ShenFen_Shop_nTotalNum-1)/ShenFen_Shop_GOODS_NUM)+1;
	end

	g_ShenFen_Shop_maxPage = nTotalPage;
	
	if(thePage < 1 or thePage > nTotalPage) then 
		return;	
	end
	
	g_ShenFen_Shop_nPageNum = thePage;

	local nStartIndex = (thePage-1)*ShenFen_Shop_GOODS_NUM;

	local nActIndex = nStartIndex;
	local nMissionItemIndex = 0;
	i = 1;
	while i <= ShenFen_Shop_GOODS_NUM do
		local nRet, itemid, itemnum, itemcosttype, itemcost, itemlimit = NpcShop:GetReputationShopItemByIdx(g_ShenFen_Shop_CurIdentity, nActIndex)
		if nRet == nil or nRet <= 0 then
			ShenFen_Shop_GOODS_BUTTONS[i]:SetActionItem(-1);
			ShenFen_Shop_GOODS_DESCS[i]:SetText("");
			ShenFen_Shop_GOODS_PRICE[i]:Hide();		
			ShenFen_Shop_GOODS_ITEMNUM[i]:SetText("");	
		else
			local theAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				ShenFen_Shop_GOODS_BUTTONS[i]:SetActionItem(theAction:GetID());
				
				local item_name = DataPool:LuaFnGetItemNameByTableIndex(itemid)
				ShenFen_Shop_GOODS_DESCS[i]:SetText(item_name);
				
				ShenFen_Shop_GOOD[i] = itemid
								
				ShenFen_Shop_GOODS_BUTTONS[i]:Enable()
				ShenFen_Shop_GOODS_BUTTONS[i]:SetProperty("Gloom", "false")
				local nHaveBuy = NpcShop:GetReputationShopBuyCountByIdx(nActIndex)
				if nHaveBuy >= itemlimit then
					ShenFen_Shop_GOODS_ITEMNUM[i]:SetText("");
					ShenFen_Shop_GOODS_BUTTONS[i]:Disable()
					ShenFen_Shop_GOODS_BUTTONS[i]:SetProperty("Gloom", "true")
				else
					local nShowStr = "#e330000"..tostring(itemlimit-nHaveBuy)
					ShenFen_Shop_GOODS_ITEMNUM[i]:SetText(nShowStr);
				end
					
				ShenFen_Shop_GOODS_PRICE[i]:SetProperty("GoldIcon", "set:Button2 image:Icon_GoldCoin")
				ShenFen_Shop_GOODS_PRICE[i]:SetProperty("SilverIcon", "set:Button2 image:Icon_SilverCoin")
				ShenFen_Shop_GOODS_PRICE[i]:SetProperty("CopperIcon", "set:Button2 image:Icon_CopperCoin")
				ShenFen_Shop_GOODS_PRICE[i]:SetProperty("MoneyNumber", tostring(itemcost))				
			else				
				ShenFen_Shop_GOODS_BUTTONS[i]:SetActionItem(-1);
				ShenFen_Shop_GOODS_DESCS[i]:SetText("");
				ShenFen_Shop_GOODS_PRICE[i]:Hide();		
			end
		end
				
		i = i + 1;	
		nActIndex = nActIndex+1;
	end

	NGSetInt("ShenFenShop_Pos", nMissionItemIndex)
	
	if( nTotalPage == 1 ) then
		ShenFen_Shop_UpPage:Hide();
		ShenFen_Shop_DownPage:Hide();
		ShenFen_Shop_CurrentlyPage:Hide();
	else
		ShenFen_Shop_UpPage:Show();
		ShenFen_Shop_DownPage:Show();
		ShenFen_Shop_CurrentlyPage:Show();
		
		ShenFen_Shop_UpPage:Enable();
		ShenFen_Shop_DownPage:Enable();

		if ( g_ShenFen_Shop_nPageNum == nTotalPage ) then
			ShenFen_Shop_DownPage:Disable();
		end
		
		if ( g_ShenFen_Shop_nPageNum == 1 ) then
			ShenFen_Shop_UpPage:Disable()
		end

		ShenFen_Shop_CurrentlyPage:SetText(tostring(g_ShenFen_Shop_nPageNum) .. "/" .. tostring(nTotalPage) );
	end
end

--===============================================
-- Button_Clicked
--===============================================
function ShenFen_Shop_Clicked(nIndex)

	if(nIndex < 1 or nIndex > 12) then 
		return;
	end
	
	local CurItemID = 0
	if ShenFen_Shop_GOOD[nIndex] ~= nil then
		CurItemID = ShenFen_Shop_GOOD[nIndex]
	end
	
	if CheckIBBuyMult() == 1 then
		PrepearStopIBBuyMult();
		-- 打开批量购买界面
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenReputationShopMultiBuy")
			Set_XSCRIPT_ScriptID(998585)
			Set_XSCRIPT_Parameter( 0, g_ShenFen_Shop_ServerCareID )
			Set_XSCRIPT_Parameter( 1, g_ShenFen_Shop_nPageNum )
			Set_XSCRIPT_Parameter( 2, nIndex )
			Set_XSCRIPT_Parameter( 3, CurItemID )
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		return
	end
		
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ReputationShopBuyItem")
		Set_XSCRIPT_ScriptID(998585)
		Set_XSCRIPT_Parameter( 0, g_ShenFen_Shop_ServerCareID )
		Set_XSCRIPT_Parameter( 1, g_ShenFen_Shop_nPageNum )
		Set_XSCRIPT_Parameter( 2, nIndex )
		Set_XSCRIPT_Parameter( 3, CurItemID )
		Set_XSCRIPT_Parameter( 4, 1 )
		Set_XSCRIPT_Parameter( 5, 0 )
		Set_XSCRIPT_ParamCount(6)
	Send_XSCRIPT()
	
end

--===============================================
-- 批量购买
--===============================================
function ShenFen_Shop_StartMultiBuy()

	PrepearStartIBBuyMult();
	
end

--===============================================
-- PageUp
--===============================================
function ShenFen_Shop_PageUp()

	local curPage = g_ShenFen_Shop_nPageNum - 1;
	if ( curPage < 0 )  then
		curPage = 1;
	end
	
	ShenFen_Shop_UpdatePage( curPage );
	
end

--===============================================
-- PageDown
--===============================================
function ShenFen_Shop_PageDown()

	local curPage = g_ShenFen_Shop_nPageNum + 1;
	
	if ( curPage >= g_ShenFen_Shop_maxPage ) then
		curPage = g_ShenFen_Shop_maxPage;
	end
	
	ShenFen_Shop_UpdatePage( curPage );
	
end

--===============================================
-- Close
--===============================================
function ShenFen_Shop_Close()
	
	SetDefaultMouse();
	
	--取消关心
	this:CareObject(g_ShenFen_Shop_objCared, 0, "ShenFen_Shop");

	if(IsWindowShow("ShenFenShop_BulkBuying")) then
		CloseWindow("ShenFenShop_BulkBuying", true);
	end
	
	this:Hide();
	
end

function ShenFen_Shop_Frame_On_ResetPos()

	ShenFen_Shop_Frame:SetProperty("UnifiedPosition", g_ShenFen_Shop_Frame_UnifiedPosition);
  
end

