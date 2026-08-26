
local Anniversary_FanChangShop_ItemsPerPage = 8;
local Anniversary_FanChangShop_Item_Btn = {};

local Anniversary_FanChangShop_Item_Desc = {};
local Anniversary_FanChangShop_Item_Price = {};

local Anniversary_FanChangShop_Item_Id = {0}

local g_Anniversary_FanChangShop_curPageNum = 1;
local g_Anniversary_FanChangShop_maxPage = 1;
local g_Anniversary_FanChangShop_SellType = -1 
local g_Anniversary_FanChangShop_StartTime = -1 
local g_Anniversary_FanChangShop_EndTime = -1 


--当前商店的商品数量
local g_Anniversary_FanChangShop_nTotalNum	= 0;


local g_Anniversary_FanChangShop_Frame_UnifiedPosition;

--===============================================
-- PreLoad
--===============================================
function Anniversary_FanChangShop_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("UPDATE_YUANBAO")
end

--===============================================
-- OnLoad
--===============================================
function Anniversary_FanChangShop_OnLoad()
	Anniversary_FanChangShop_Item_Btn[1] = Anniversary_FanChangShop_Item1;
	Anniversary_FanChangShop_Item_Btn[2] = Anniversary_FanChangShop_Item2;
	Anniversary_FanChangShop_Item_Btn[3] = Anniversary_FanChangShop_Item3;
	Anniversary_FanChangShop_Item_Btn[4] = Anniversary_FanChangShop_Item4;
	Anniversary_FanChangShop_Item_Btn[5] = Anniversary_FanChangShop_Item5;
	Anniversary_FanChangShop_Item_Btn[6] = Anniversary_FanChangShop_Item6;
	Anniversary_FanChangShop_Item_Btn[7] = Anniversary_FanChangShop_Item7;
	Anniversary_FanChangShop_Item_Btn[8] = Anniversary_FanChangShop_Item8;

	
	Anniversary_FanChangShop_Item_Desc[1] = Anniversary_FanChangShop_ItemInfo1_Text;
	Anniversary_FanChangShop_Item_Desc[2] = Anniversary_FanChangShop_ItemInfo2_Text;
	Anniversary_FanChangShop_Item_Desc[3] = Anniversary_FanChangShop_ItemInfo3_Text;
	Anniversary_FanChangShop_Item_Desc[4] = Anniversary_FanChangShop_ItemInfo4_Text;
	Anniversary_FanChangShop_Item_Desc[5] = Anniversary_FanChangShop_ItemInfo5_Text;
	Anniversary_FanChangShop_Item_Desc[6] = Anniversary_FanChangShop_ItemInfo6_Text;
	Anniversary_FanChangShop_Item_Desc[7] = Anniversary_FanChangShop_ItemInfo7_Text;
	Anniversary_FanChangShop_Item_Desc[8] = Anniversary_FanChangShop_ItemInfo8_Text;

	
	Anniversary_FanChangShop_Item_Price[1] = Anniversary_FanChangShop_ItemInfo1_Price;
	Anniversary_FanChangShop_Item_Price[2] = Anniversary_FanChangShop_ItemInfo2_Price;
	Anniversary_FanChangShop_Item_Price[3] = Anniversary_FanChangShop_ItemInfo3_Price;
	Anniversary_FanChangShop_Item_Price[4] = Anniversary_FanChangShop_ItemInfo4_Price;
	Anniversary_FanChangShop_Item_Price[5] = Anniversary_FanChangShop_ItemInfo5_Price;
	Anniversary_FanChangShop_Item_Price[6] = Anniversary_FanChangShop_ItemInfo6_Price;
	Anniversary_FanChangShop_Item_Price[7] = Anniversary_FanChangShop_ItemInfo7_Price;
	Anniversary_FanChangShop_Item_Price[8] = Anniversary_FanChangShop_ItemInfo8_Price;
	
	g_Anniversary_FanChangShop_Frame_UnifiedPosition = Anniversary_FanChangShop_Frame:GetProperty("UnifiedPosition");
	
end

--===============================================
-- OnEvent
--===============================================
function Anniversary_FanChangShop_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99981201 ) then	
	
		if Get_XParam_INT( 0 ) <= 0 or Get_XParam_INT(3) <= 0 then
			Anniversary_FanChangShop_Close()
			return
		end
		
		for i=1, Anniversary_FanChangShop_ItemsPerPage  do
			Anniversary_FanChangShop_Item_Price[i]:Show();
			Anniversary_FanChangShop_Item_Id[i] = 0
		end
		
		g_Anniversary_FanChangShop_nTotalNum = 0;
		
		
		g_Anniversary_FanChangShop_SellType = Get_XParam_INT(1)
		g_Anniversary_FanChangShop_nTotalNum = Get_XParam_INT(2)
		
		local curPage = Get_XParam_INT(3)		
		g_Anniversary_FanChangShop_StartTime = Get_XParam_INT(4)	
		g_Anniversary_FanChangShop_EndTime = Get_XParam_INT(5)	
		-- 计算总页数
		local nTotalPage;
		if( g_Anniversary_FanChangShop_nTotalNum < 1 ) then
			nTotalPage = 1;
		else
			nTotalPage = math.floor((g_Anniversary_FanChangShop_nTotalNum-1)/Anniversary_FanChangShop_ItemsPerPage)+1;
		end

		g_Anniversary_FanChangShop_maxPage = nTotalPage;		
		
		Anniversary_FanChangShop_UpdatePage(curPage)
		
		Lua_ShowQuickEnterPointTip(41, 0)
		
		this:Show();
		
	
	elseif (event == "ADJEST_UI_POS" ) then
		Anniversary_FanChangShop_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Anniversary_FanChangShop_Frame_On_ResetPos()

	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		Anniversary_FanChangShop_Close();
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Anniversary_FanChangShop_Close();
		
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		Anniversary_FanChangShop_DBNum_Text:SetText(ScriptGlobal_Format("#{WGFC_250509_09}", tostring(Player:GetData("YUANBAO"))))
	end
	
end

--===============================================
-- UpdatePage
--===============================================
function Anniversary_FanChangShop_UpdatePage(thePage)
	

	if(thePage < 1 or thePage > g_Anniversary_FanChangShop_maxPage) then 
		thePage = 1
	end

	g_Anniversary_FanChangShop_curPageNum = thePage;
	
	local tblinfo= NpcShop:GetAnniversaryFanChangShopItemData(g_Anniversary_FanChangShop_SellType, thePage, Anniversary_FanChangShop_ItemsPerPage)
	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("GetAnniversaryFanChangShopItemData error")
		return
    end 

	for i = 1, Anniversary_FanChangShop_ItemsPerPage do
		Anniversary_FanChangShop_Item_Btn[i]:SetActionItem(-1);
		Anniversary_FanChangShop_Item_Desc[i]:SetText("");
		Anniversary_FanChangShop_Item_Price[i]:SetText("");
		Anniversary_FanChangShop_Item_Id[i] = -1
	end
		
	for i = 1, table.getn(tblinfo) do
		--第一列
        local itemid 	    = tblinfo[i].itemid
		local itemdesc 	    = tblinfo[i].desc
		local price      = tblinfo[i].price

		if itemid > 0 and i <= Anniversary_FanChangShop_ItemsPerPage then
			
			local ret = DataPool:Lua_SetZNFCShopItemInfo(i-1, itemid, g_Anniversary_FanChangShop_curPageNum)

			local theAction = EnumAction(i-1, "znfcshop_item"); 
			if theAction:GetID() ~= 0 then
				Anniversary_FanChangShop_Item_Btn[i]:SetActionItem(theAction:GetID())
				local item_name = DataPool:LuaFnGetItemNameByTableIndex(itemid)
				Anniversary_FanChangShop_Item_Desc[i]:SetText(ScriptGlobal_Format("#{WGFC_250509_21}",item_name));
				
				Anniversary_FanChangShop_Item_Id[i] = itemid
								
				Anniversary_FanChangShop_Item_Btn[i]:Enable()
					
				--Anniversary_FanChangShop_Item_Price[i]:SetProperty("GoldIcon", "set:Button2 image:Icon_GoldCoin")
				--Anniversary_FanChangShop_Item_Price[i]:SetProperty("SilverIcon", "set:Button2 image:Icon_SilverCoin")
				--Anniversary_FanChangShop_Item_Price[i]:SetProperty("CopperIcon", "set:Button2 image:Icon_CopperCoin")
				--Anniversary_FanChangShop_Item_Price[i]:SetProperty("MoneyNumber", tostring(price))				
				Anniversary_FanChangShop_Item_Price[i]:SetText(ScriptGlobal_Format("#{WGFC_250509_20}",tostring(price)))				
			end
		end

	end

		Anniversary_FanChangShop_UpPage:Enable();
		Anniversary_FanChangShop_DownPage:Enable();

		if ( g_Anniversary_FanChangShop_curPageNum == g_Anniversary_FanChangShop_maxPage ) then
			Anniversary_FanChangShop_DownPage:Disable();
		end
		
		if ( g_Anniversary_FanChangShop_curPageNum == 1 ) then
			Anniversary_FanChangShop_UpPage:Disable()
		end

		Anniversary_FanChangShop_CurrentlyPage:SetText(tostring(g_Anniversary_FanChangShop_curPageNum) .. "/" .. tostring(g_Anniversary_FanChangShop_maxPage) );

		Anniversary_FanChangShop_DBNum_Text:SetText(ScriptGlobal_Format("#{WGFC_250509_09}", tostring(Player:GetData("YUANBAO"))))

		local yys = math.floor(g_Anniversary_FanChangShop_StartTime / 10000)
		local mms = math.floor(math.mod(g_Anniversary_FanChangShop_StartTime, 10000) / 100)
		local dds = math.mod(g_Anniversary_FanChangShop_StartTime, 100)
		local yye = math.floor(g_Anniversary_FanChangShop_EndTime / 10000)
		local mme = math.floor(math.mod(g_Anniversary_FanChangShop_EndTime, 10000) / 100)
		local dde = math.mod(g_Anniversary_FanChangShop_EndTime, 100)
		Anniversary_FanChangShop_TimeTips:SetText(ScriptGlobal_Format("#{WGFC_250509_19}", yys, mms, dds, yye, mme, dde))

end

--===============================================
-- Button_Clicked
--===============================================
function Anniversary_FanChangShop_Btn_Clicked(nIndex)

	if(nIndex < 1 or nIndex > 8) then 
		return;
	end

	Anniversary_FanChangShop_Item_Btn[nIndex]:DoAction()
	
	--local buyItemId = 0
	--if Anniversary_FanChangShop_Item_Id[nIndex] ~= nil then
	--	buyItemId = Anniversary_FanChangShop_Item_Id[nIndex]
		
	--	Clear_XSCRIPT()
	--		Set_XSCRIPT_Function_Name("ZNFCShopBuyItem")
	--		Set_XSCRIPT_ScriptID(999812)
	--		Set_XSCRIPT_Parameter( 0, g_Anniversary_FanChangShop_curPageNum )
	--		Set_XSCRIPT_Parameter( 1, nIndex )
	--		Set_XSCRIPT_Parameter( 2, buyItemId )
	--		Set_XSCRIPT_Parameter( 3, 1 )
	--		Set_XSCRIPT_ParamCount(4)
	--	Send_XSCRIPT()
		
	--end
	
end


--===============================================
-- 试穿
--===============================================
function Anniversary_FanChangShop_ItemPreviewBtn()

	if IsIdleLogic() ~= 1 and IsMoveLogic() ~= 1 then
		SetNotifyTip("#{YBSD_081225_100}");
		return 0;
    end
    
    if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
    end 
    
    if(IsWindowShow("PetJian")) then
		CloseWindow("PetJian", true);
    end 

	StopMove(); 
	RestoreShopFitting();
	this:Show();
	MouseCmd_ShopFittingSet();
	SetNotifyTip("#{YBSD_081225_099}");
	
end

--===============================================
-- PageUp
--===============================================
function Anniversary_FanChangShop_PageUp()

	local curPage = g_Anniversary_FanChangShop_curPageNum - 1;
	if ( curPage < 0 )  then
		curPage = 1;
	end
	
	Anniversary_FanChangShop_UpdatePage( curPage );
	
end

--===============================================
-- PageDown
--===============================================
function Anniversary_FanChangShop_PageDown()

	local curPage = g_Anniversary_FanChangShop_curPageNum + 1;
	
	if ( curPage >= g_Anniversary_FanChangShop_maxPage ) then
		curPage = g_Anniversary_FanChangShop_maxPage;
	end
	
	Anniversary_FanChangShop_UpdatePage( curPage );
	
end

--===============================================
-- Close
--===============================================
function Anniversary_FanChangShop_Close()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
    end 
    
    if(IsWindowShow("PetJian")) then
		CloseWindow("PetJian", true);
    end 

	SetDefaultMouse();  
	RestoreShopFitting();
	
	PushEvent("CLOSE_MESSAGEBOX", 446)
	
	this:Hide();
end

function Anniversary_FanChangShop_Frame_On_ResetPos()

	Anniversary_FanChangShop_Frame:SetProperty("UnifiedPosition", g_Anniversary_FanChangShop_Frame_UnifiedPosition);
  
end

