local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_PaoShangScene =
{
	[0]={sceneid=0,name="LÕc Dß½ng"},
	[1]={sceneid=3,name="Tung S½n"},
	[2]={sceneid=4,name="Thái H°"},
	[3]={sceneid=1,name="Tô Châu"},
	[4]={sceneid=5,name="Kính K°"},
	[5]={sceneid=6,name="Vô Lßþng S½n"},
	[6]={sceneid=2,name="ÐÕi Lý"},
	[7]={sceneid=7,name="Kiªm Các"},
	[8]={sceneid=8,name="Ðôn Hoàng"},
}
local objCared = -1;
local g_MaxBuyNum = 250

local g_PaoShangItem ={}
local g_PaoShangItemText ={}
local g_PaoShangItemPrice ={}

local nWeapon={};
local nWeaponPrice={};

local g_CurBuyNum = 1
local g_CurSellNum = 1
local g_CurItemIndex = 1
local g_CurSellItemIndex = 4

-- Ìá¹©³¤°´×ó¼ü½øÐÐÁ¬¼ÓµÄ¹¦ÄÜ	-- HenryFour@2010-04-16
local g_AutoClick_BtnFlag = -1			-- ????????????????
local g_AutoClickTimer_Step = 144		-- ????(??)???? Click ??
local g_AutoClick_FunList = {}			-- ????? Timer ?????????????
local g_AutoClick_Going = -1			-- ????????????(???LButton???X?Timer????, ????? g_AutoClickTimer_Step * X ??????????, ?????????????????????)


local g_PaoShangSellItem ={}
local g_PaoShangSellItemText ={}
local g_PaoShangSellItemPrice ={}

local g_PaoShang_Zijin = 0 -- ????
local g_PaoShang_Item_Num = 1
local g_PaoShang_Item1 = 2 -- ??1
local g_PaoShang_Item1_Price = 3
local g_PaoShang_Item2 = 4 -- ??2
local g_PaoShang_Item2_Price = 5
local g_PaoShang_Item3 = 6 -- ??3
local g_PaoShang_Item3_Price = 7

local g_PaoShangIndex_Item =
{
	[1] = g_PaoShang_Item1,
	[2] = g_PaoShang_Item2,
	[3] = g_PaoShang_Item3,
};

local g_PaoShangIndex_ItemNum = g_PaoShang_Item_Num

local g_PaoShangIndex_ItemPrice =
{
	[1] = g_PaoShang_Item1_Price,
	[2] = g_PaoShang_Item2_Price,
	[3] = g_PaoShang_Item3_Price,
};

local nMyItem = {}
local nMyItemNum = {}
local g_PaoShangPriceGB={}
local		g_NPCID = 0
local		g_CurSecneID = 0
local		g_AskSceneID = 0
local		g_NormalPriceType = 0


local		g_MissionID = 2115

local g_MyPaoShang_Zijin = 0

local Data_BuyPrice ={}
local Data_SellPrice ={}
local Data_SceneItemLvl={}
local Button_BuyItemPrice={}
local Button_SellItemPrice={}
local Button_BuyItemText={}
local Button_SellItemText={}
local Button_SceneItemLvl={}
local g_PaoShangBigItem={}

function PaoShang_PreLoad()

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("CLOSE_PAOSHANGWINDOWS",false)

	this:RegisterEvent("SCENE_TRANSED")
	
end

function PaoShang_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Frame_UnifiedXPosition	= PaoShang_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= PaoShang_Frame:GetProperty("UnifiedYPosition");
	
	g_PaoShangItem[1] = PaoShang_But1
	g_PaoShangItem[2] = PaoShang_But2
	g_PaoShangItem[3] = PaoShang_But3
	g_PaoShangItem[4] = PaoShang_But5	
	g_PaoShangItem[5] = PaoShang_But6	
	g_PaoShangItem[6] = PaoShang_But7	

	g_PaoShangBigItem[1] = PaoShang_Action_Set1
	g_PaoShangBigItem[2] = PaoShang_Action_Set2
	g_PaoShangBigItem[3] = PaoShang_Action_Set3
	g_PaoShangBigItem[4] = PaoShang_Action_Set5	
	g_PaoShangBigItem[5] = PaoShang_Action_Set6	
	g_PaoShangBigItem[6] = PaoShang_Action_Set7	
	
	g_PaoShangItemText[1] = PaoShang_ItemInfo1_Text
	g_PaoShangItemText[2] = PaoShang_ItemInfo2_Text
	g_PaoShangItemText[3] = PaoShang_ItemInfo3_Text
	g_PaoShangItemText[4] = PaoShang_ItemInfo5_Text
	g_PaoShangItemText[5] = PaoShang_ItemInfo6_Text
	g_PaoShangItemText[6] = PaoShang_ItemInfo7_Text
		
	g_PaoShangItemPrice[1] = PaoShang_ItemInfo1_Price
	g_PaoShangItemPrice[2] = PaoShang_ItemInfo2_Price
	g_PaoShangItemPrice[3] = PaoShang_ItemInfo3_Price
	
	g_PaoShangPriceGB[4] = PaoShang_ItemInfo5_Text1
	g_PaoShangPriceGB[5] = PaoShang_ItemInfo6_Text1
	g_PaoShangPriceGB[6] = PaoShang_ItemInfo7_Text1
	
	g_AutoClick_FunList[1] = PaoShang_Add_Clicked
	g_AutoClick_FunList[2] = PaoShang_Sub_Clicked	
	g_AutoClick_FunList[3] = PaoShang_SellAdd_Clicked	
	g_AutoClick_FunList[4] = PaoShang_SellSub_Clicked	

	Button_BuyItemPrice[1]	= PaoShang_Huocang_shuliang5_1
	Button_BuyItemPrice[2]	= PaoShang_Huocang_shuliang6_1
	Button_BuyItemPrice[3]	= PaoShang_Huocang_shuliang7_1	
	
	Button_SellItemPrice[1]	= PaoShang_Huocang_shuliang5
	Button_SellItemPrice[2]	= PaoShang_Huocang_shuliang6
	Button_SellItemPrice[3]	= PaoShang_Huocang_shuliang7	

	Button_BuyItemText[1]	= PaoShang_Huocang_Text5_1
	Button_BuyItemText[2]	= PaoShang_Huocang_Text6_1
	Button_BuyItemText[3]	= PaoShang_Huocang_Text7_1		
	
	Button_SellItemText[1]	= PaoShang_Huocang_Text5
	Button_SellItemText[2]	= PaoShang_Huocang_Text6
	Button_SellItemText[3]	= PaoShang_Huocang_Text7				
	
	Button_SceneItemLvl[1]	= PaoShang_Goumai_Tuijian1
	Button_SceneItemLvl[2]	= PaoShang_Goumai_Tuijian2
	Button_SceneItemLvl[3]	= PaoShang_Goumai_Tuijian3
	
	PaoShang_Text5:Hide()
	PaoShang_Text6:Hide()
	PaoShang_Text7:Hide()
	
end

function PaoShang_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		PaoShang_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		PaoShang_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 8927605) then
		if DataPool:Lua_IsHaveMission(g_MissionID) <= 0 then
			this:Hide()
			return
		end	
		
		local nType = Get_XParam_INT(0)
		
		if nType == 1 then
			local xx = Get_XParam_INT(1)
			objCared = DataPool:GetNPCIDByServerID(xx)
			return
		end

		g_CurSecneID = Get_XParam_INT(1)
		g_AskSceneID = Get_XParam_INT(2)
		g_NormalPriceType = Get_XParam_INT(3)
		Data_BuyPrice[1] = Get_XParam_INT(4)
		Data_BuyPrice[2] = Get_XParam_INT(5)
		Data_BuyPrice[3] = Get_XParam_INT(6)						
		Data_SellPrice[1]	= Get_XParam_INT(7)
		Data_SellPrice[2]	= Get_XParam_INT(8)
		Data_SellPrice[3]	= Get_XParam_INT(9)
		nWeaponPrice[4]	= Get_XParam_INT(7)
		nWeaponPrice[5]	= Get_XParam_INT(8)
		nWeaponPrice[6]	= Get_XParam_INT(9)
		local g_nLeftTime = Get_XParam_INT(10)
			
		PaoShang_ClearSellItem()
		
		PaoShang_ShangPin_Text1:SetText( ScriptGlobal_Format( "#{PSGN_180327_24}", g_PaoShangScene[g_AskSceneID].name))
		
		--×ó²àÎïÆ·
		nWeapon[1],nWeapon[2],nWeapon[3] = DataPool:GetPaoShangData(g_AskSceneID,1);
		nWeaponPrice[1],nWeaponPrice[2],nWeaponPrice[3],Data_SceneItemLvl[1],Data_SceneItemLvl[2],Data_SceneItemLvl[3] = DataPool:GetPaoShangData(g_AskSceneID,2,g_NormalPriceType);
										
	
		--ÓÒ²àÎïÆ·
		local misIndex = DataPool:GetPlayerMissionIndexByID(g_MissionID)
		local nMyItemNumList = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShangIndex_ItemNum)

		nMyItemNum[1] = math.mod(nMyItemNumList,1000)
		nMyItemNumList = math.floor(nMyItemNumList/1000)
		nMyItemNum[2] = math.mod(nMyItemNumList,1000)
		nMyItemNum[3] = math.floor(nMyItemNumList/1000)
		for i=1,3 do
			nMyItem[i] = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShangIndex_Item[i])
			if nMyItem[i] == -1 then
				nWeapon[3+i] = 0 
			else
				nWeapon[3+i] = nMyItem[i]
			end
		end		
		
		--×ó²à3¸öÎïÆ·		
		for i = 1,3 do
			local theAction = DataPool:CreateActionItemForShow(nWeapon[i], 1)
			if theAction:GetID() ~= 0 then
				g_PaoShangItem[i]:SetActionItem(theAction:GetID());
				local szItemName = PlayerPackage:GetItemName( nWeapon[i] )
				g_PaoShangItemText[i]:SetText(szItemName)
				local pricestr = ScriptGlobal_Format( "#{PSGN_180515_223}", nWeaponPrice[i] )
				g_PaoShangItemPrice[i]:SetText(pricestr);
--				g_PaoShangItemPrice[i]:SetProperty("Visible" , "True" )		
				if Data_SceneItemLvl[i] == 3 then
					Button_SceneItemLvl[i]:Show()
				else
					Button_SceneItemLvl[i]:Hide()
				end
			end			
		end	

		--ÓÒ²à3¸öÎïÆ·		
		for i = 4,6 do
			local ii = i - 3
			local theAction = DataPool:CreateActionItemForShow(nWeapon[i], nMyItemNum[i-3])
			if theAction:GetID() ~= 0 then
				g_PaoShangItem[i]:SetActionItem(theAction:GetID());
				local szItemName = PlayerPackage:GetItemName( nWeapon[i] )
				g_PaoShangItemText[i]:SetText(szItemName)
				Button_BuyItemPrice[ii]:SetText( ScriptGlobal_Format( "#{PSGN_180515_223}", Data_BuyPrice[ii]) )
				Button_SellItemPrice[ii]:SetText( ScriptGlobal_Format( "#{PSGN_180515_223}", Data_SellPrice[ii]) )
				Button_BuyItemText[ii]:Show()
				Button_SellItemText[ii]:Show()							
				g_PaoShangPriceGB[i]:SetText("")	
			else
				g_PaoShangItem[i]:SetActionItem(-1);
				g_PaoShangPriceGB[i]:SetText("#{PSGN_180515_143}")	
			end			
		end	

		if( this:IsVisible() == false) then
			g_CurBuyNum = 1
			g_CurSellNum	= 1	
			
			PaoShang_Num1:SetText(g_CurBuyNum)
			PaoShang_Num2:SetText(g_CurSellNum)
	
			g_CurItemIndex = 1
			g_CurSellItemIndex = PaoShang_SelectSellItem()		
		end		
		
		if g_CurSellItemIndex == 0 then
			g_CurSellItemIndex = PaoShang_SelectSellItem()		
		end
				
		PaoShang_OnItemClick(g_CurItemIndex)
		PaoShang_OnSellItemClick(g_CurSellItemIndex)
				
		PaoShang_SelfUpdate()
				
		SetTimer("PaoShang", "PaoShang_AutoClick_Timer()", g_AutoClickTimer_Step)
		this:CareObject(objCared, 1, "PaoShang");

		if g_nLeftTime <= 0 then
			PaoShang_Button1:Hide()
			PaoShang_Text:Show()			
		else
			PaoShang_Button1:Show()
			PaoShang_Text:Hide()
		end

		if(IsWindowShow("ShangPinXinXi")) then
			CloseWindow("ShangPinXinXi", true);
		end
		this:Show()
	elseif( event == "CLOSE_PAOSHANGWINDOWS" ) then	
		PaoShang_OnClose();			
	elseif( event == "UI_COMMAND" and tonumber(arg0) ==  8927602 ) then

		if( this:IsVisible() ) then
			nWeaponPrice[4]	= Get_XParam_INT(0)
			nWeaponPrice[5]	= Get_XParam_INT(1)
			nWeaponPrice[6]	= Get_XParam_INT(2)					
			PaoShang_UpdateSellItem();
			if g_CurSellItemIndex <4 or g_CurSellItemIndex > 6 or nWeaponPrice[g_CurSellItemIndex] <= 0 then
				g_CurSellItemIndex = PaoShang_SelectSellItem()		
			end
			PaoShang_OnSellItemClick(g_CurSellItemIndex)
			PaoShang_OnItemClick(g_CurItemIndex)
		end

	elseif( event == "SCENE_TRANSED" ) then		
		PaoShang_OnClose()	
	end
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function PaoShang_ResetPos()
	PaoShang_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	PaoShang_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end



function PaoShang_OnClose()
	KillTimer("PaoShang_AutoClick_Timer()")
	this:CareObject(objCared, 0, "PaoShang");
	this:Hide()
end



--***************************************************
-- Çå¿ Êó±ê³¤°´±ê¼Ç
--***************************************************
function PaoShang_AutoClick_Clear(id)
	id = tonumber(id)
	if (id == g_AutoClick_BtnFlag) then
		g_AutoClick_BtnFlag = -1
	end
end

--***************************************************
-- ¶¨Ê±Æ÷»Øµ÷º¯Êý
--    ÊµÏÖÂýÆô¶¯, ÒÔºó¿ÉÒÔ¿¼ÂÇ¼ÓËÙ(±ØÒªÐÔ²»´ó)
--***************************************************
function PaoShang_AutoClick_Timer()
	if (g_AutoClick_BtnFlag ~= -1) then
		-- µÚÒ»´ÎLButtonºó¾­¹ýX¸öTimer²ÅËã¿ªÊ¼, Ò²¾ÍÊÇËµÊÇ g_AutoClickTimer_Step * X µÄÊ±ºò¿ªÊ¼½øÐÐ×Ô¶¯¼Ó,  âÑùÎªÁË·ÀÖ¹±¾À´Òªµã»÷Ò»ÏÂµÄ½á¹ûµãÁËºÃ¶àÏÂ
		if (g_AutoClick_Going < 4) then
			g_AutoClick_Going = g_AutoClick_Going + 1
		else
			--Ä¿Ç°ÏÈÉèÖÃ 6 Step µÄµÈ´ýÊ±¼ä, ÏÂÃæ×¢ÊÍµÄ´úÂë¿ÉÒÔºóÀ´ÓÃÓÚÊµÏÖÂýÆô¶¯, Öð½¥¼ÓËÙÐ§¹û.
			--if (g_AutoClick_Going == 2 or g_AutoClick_Going == 5) then
				--g_AutoClick_FunList[g_AutoClick_BtnFlag]()
			--end
			g_AutoClick_FunList[g_AutoClick_BtnFlag]()
		end
	end
end

--***************************************************
-- Êó±ê×ó¼üËÉ¿ª²Ù×÷
--    ×¢Òâ âÀïÆäÊµÊÇ´úÌæ Click, ËùÒÔÐèÒªÖ´ÐÐÒ»´Î Click ²Ù×÷
--***************************************************
function PaoShang_AutoClick_LButtonUp(id)
	id = tonumber(id)
	PaoShang_AutoClick_Clear(id)
	g_AutoClick_FunList[id]()
end

--***************************************************
-- ÉèÖÃ¶¨Ê±Æ÷
--    ÉèÖÃ±ê¼ÇËµÃ÷Êó±êÒÑ¾­°´ÏÂ
--***************************************************
function PaoShang_AutoClick_SetTimer(id)
	id = tonumber(id)
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = id
end

--¼Óµã
function PaoShang_Add_Clicked()

	if (g_CurBuyNum + 1) * nWeaponPrice[g_CurItemIndex] > g_MyPaoShang_Zijin then
		PushDebugMessage("#{PSGN_180515_95}")
		return
	end
	
	if g_CurBuyNum >= g_MaxBuyNum then
		PushDebugMessage("#{PSGN_180515_130}")
		return
	end		

	g_CurBuyNum = g_CurBuyNum + 1;
	PaoShang_Num1:SetText(g_CurBuyNum)
	local need = g_CurBuyNum*nWeaponPrice[g_CurItemIndex]
	PaoShang_Money1_Need:SetText(need.."#-31")
	local misIndex = DataPool:GetPlayerMissionIndexByID(g_MissionID)
	local paramvalue = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShang_Zijin)
	if need <= paramvalue then
		--#G
		PaoShang_Money2_Need:SetText(paramvalue.."#-31")
	else
		PaoShang_Money2_Need:SetText("#cff0000"..paramvalue.."#-31")
	end
end

--¼õÈ¥
function PaoShang_Sub_Clicked()
	if g_CurBuyNum <=1 then
		PushDebugMessage("#{PSGN_180515_97}")
		return
	end
	g_CurBuyNum = g_CurBuyNum - 1;
	PaoShang_Num1:SetText(g_CurBuyNum)
	local need = g_CurBuyNum*nWeaponPrice[g_CurItemIndex]
	PaoShang_Money1_Need:SetText(need.."#-31")
	local misIndex = DataPool:GetPlayerMissionIndexByID(g_MissionID)
	local paramvalue = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShang_Zijin)
	if need <= paramvalue then
		--#G
		PaoShang_Money2_Need:SetText(paramvalue.."#-31")
	else
		PaoShang_Money2_Need:SetText("#cff0000"..paramvalue.."#-31")
	end
end


--¼Óµã
function PaoShang_SellAdd_Clicked()
	if g_CurSellItemIndex<4 or g_CurSellItemIndex>6 then
		PushDebugMessage("#{PSGN_180515_144}")
		return
	end
	
	if g_CurSellNum < nMyItemNum[g_CurSellItemIndex-3] then
		g_CurSellNum = g_CurSellNum + 1;
		PaoShang_Num2:SetText(g_CurSellNum)
		PaoShang_Money3_Need:SetText( tostring(g_CurSellNum*nWeaponPrice[g_CurSellItemIndex]).."#-31" );
	else
		PushDebugMessage("#{PSGN_180515_98}")
	end
end

--¼õÈ¥
function PaoShang_SellSub_Clicked()
	if g_CurSellItemIndex<4 or g_CurSellItemIndex>6 then
		PushDebugMessage("#{PSGN_180515_144}")
		return
	end
	
	if g_CurSellNum > 1 then
		g_CurSellNum = g_CurSellNum - 1;
		PaoShang_Num2:SetText(g_CurSellNum)
		PaoShang_Money3_Need:SetText( tostring(g_CurSellNum*nWeaponPrice[g_CurSellItemIndex]).."#-31" )
	else
		PushDebugMessage("#{PSGN_180515_99}")
	end
end

function PaoShang_Buy()
	local nString = PaoShang_Num1:GetText()
	if nString == nil or nString =="" then
		PushDebugMessage("#{PSGN_180515_97}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PaoShangBuyItem" )
		Set_XSCRIPT_ScriptID(892760)
		Set_XSCRIPT_Parameter(0,g_CurItemIndex-1)
		Set_XSCRIPT_Parameter(1,g_CurBuyNum)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end

function PaoShang_Sell()
	if g_CurSellItemIndex<4 or g_CurSellItemIndex>6 then
		PushDebugMessage("#{PSGN_180515_145}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PaoShangSellItem" )
		Set_XSCRIPT_ScriptID(892760)
		Set_XSCRIPT_Parameter(0,g_CurSellItemIndex-4)
		Set_XSCRIPT_Parameter(1,g_CurSellNum)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end

function PaoShang_OnItemClick(nIndex)
	for i=1,3 do
		g_PaoShangItem[i]:SetPushed(0)
		g_PaoShangBigItem[i]:SetCheck(0)
	end

	g_PaoShangItem[nIndex]:SetPushed(1)
	g_PaoShangBigItem[nIndex]:SetCheck(1)
	g_CurItemIndex = nIndex
	g_CurBuyNum = 1
	
	PaoShang_Num1:SetText(g_CurBuyNum)
	local need = g_CurBuyNum*nWeaponPrice[g_CurItemIndex]
	PaoShang_Money1_Need:SetText(need.."#-31")
	local misIndex = DataPool:GetPlayerMissionIndexByID(g_MissionID)
	local paramvalue = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShang_Zijin)
	if need <= paramvalue then
		--#G
		PaoShang_Money2_Need:SetText(paramvalue.."#-31")
	else
		PaoShang_Money2_Need:SetText("#cff0000"..paramvalue.."#-31")
	end
end

function PaoShang_OnSellItemClick(nIndex)
	if nIndex<4 or nIndex>6 then
		for i=4,6 do
			g_PaoShangItem[i]:SetPushed(0)
			g_PaoShangBigItem[i]:SetCheck(0)
		end
		g_CurSellNum = 1
		PaoShang_Num2:SetText(g_CurSellNum)		
		PaoShang_Money3_Need:SetText( tostring(0).."#-31" );			
		return
	end
	if nMyItemNum[nIndex-3] <= 0 then
		g_PaoShangBigItem[nIndex]:SetCheck(0)
		return
	end
	
	for i=4,6 do
		g_PaoShangItem[i]:SetPushed(0)
		g_PaoShangBigItem[i]:SetCheck(0)
	end
	g_PaoShangItem[nIndex]:SetPushed(1)
	g_PaoShangBigItem[nIndex]:SetCheck(1)
	g_CurSellItemIndex = nIndex
	g_CurSellNum = nMyItemNum[nIndex-3]
	
	PaoShang_Num2:SetText(g_CurSellNum)
	PaoShang_Money3_Need:SetText( tostring(g_CurSellNum*nWeaponPrice[g_CurSellItemIndex]).."#-31" );	
end

function PaoShang_ClearSellItem()
	for i=4,6 do
		local ii=i-3
		g_PaoShangItem[i]:SetActionItem(-1)
		g_PaoShangItemText[i]:SetText("")
		g_PaoShangPriceGB[i]:SetText("#{PSGN_180515_143}")
		Button_BuyItemPrice[ii]:SetText("")
		Button_SellItemPrice[ii]:SetText("")
		Button_BuyItemText[ii]:Hide()
		Button_SellItemText[ii]:Hide()						
	end
end

function PaoShang_SelfUpdate()
	if DataPool:Lua_IsHaveMission(g_MissionID) > 0 then
		local misIndex = DataPool:GetPlayerMissionIndexByID(g_MissionID)
		g_MyPaoShang_Zijin = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShang_Zijin)
		PaoShang_Money4_Need:SetText(tostring(g_MyPaoShang_Zijin).."#-31");			
	end
end

function PaoShang_UpdateSellItem()				
	if DataPool:Lua_IsHaveMission(g_MissionID) <= 0 then
		this:Hide()
		return
	end						
	
		PaoShang_ClearSellItem()
		--ÓÒ²àÎïÆ·
		local misIndex = DataPool:GetPlayerMissionIndexByID(g_MissionID)
		local nMyItemNumList = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShangIndex_ItemNum)

		nMyItemNum[1] = math.mod(nMyItemNumList,1000)
		nMyItemNumList = math.floor(nMyItemNumList/1000)
		nMyItemNum[2] = math.mod(nMyItemNumList,1000)
		nMyItemNum[3] = math.floor(nMyItemNumList/1000)
		for i=1,3 do
			nMyItem[i] = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShangIndex_Item[i])
			if nMyItem[i] == -1 then
				nWeapon[3+i] = 0 
			else
				nWeapon[3+i] = nMyItem[i]
			end
		end

		--×ó²à3¸öÎïÆ·		
		for i = 1,3 do
			local theAction = DataPool:CreateActionItemForShow(nWeapon[i], 1)
			if theAction:GetID() ~= 0 then
				g_PaoShangItem[i]:SetActionItem(theAction:GetID());
				local szItemName = PlayerPackage:GetItemName( nWeapon[i] )
				g_PaoShangItemText[i]:SetText(szItemName)
				local pricestr = ScriptGlobal_Format( "#{PSGN_180515_223}", nWeaponPrice[i])
				g_PaoShangItemPrice[i]:SetText(pricestr);
--				g_PaoShangItemPrice[i]:SetProperty("Visible" , "True" )		
				if Data_SceneItemLvl[i] == 3 then
					Button_SceneItemLvl[i]:Show()
				else
					Button_SceneItemLvl[i]:Hide()
				end
			end			
		end	
						
		--ÓÒ²à3¸öÎïÆ·		
		for i = 4,6 do
			local ii = i - 3
			local theAction = DataPool:CreateActionItemForShow(nWeapon[i], nMyItemNum[i-3])
			if theAction:GetID() ~= 0 then
				g_PaoShangItem[i]:SetActionItem(theAction:GetID());
				local szItemName = PlayerPackage:GetItemName( nWeapon[i] )
				g_PaoShangItemText[i]:SetText(szItemName)
				Button_BuyItemPrice[ii]:SetText( ScriptGlobal_Format( "#{PSGN_180515_223}", Data_BuyPrice[ii]) )
				Button_SellItemPrice[ii]:SetText( ScriptGlobal_Format( "#{PSGN_180515_223}", Data_SellPrice[ii]) )
				Button_BuyItemText[ii]:Show()
				Button_SellItemText[ii]:Show()							
				g_PaoShangPriceGB[i]:SetText("")	
			else
				g_PaoShangItem[i]:SetActionItem(-1);
				g_PaoShangPriceGB[i]:SetText("#{PSGN_180515_143}")	
			end			
		end	
		local paramvalue = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShang_Zijin)		
		PaoShang_Money4_Need:SetText(tostring(paramvalue).."#-31");			
		g_MyPaoShang_Zijin = paramvalue
end

function PaoShang_ChangeBuyNum()
	local misIndex = DataPool:GetPlayerMissionIndexByID(g_MissionID)
	local paramvalue = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShang_Zijin)
	local nString = PaoShang_Num1:GetText()
	if nString == nil or nString =="" then
		g_CurBuyNum = 1
		PaoShang_Money1_Need:SetText(tostring(0).."#-31");	
		PaoShang_Money2_Need:SetText(paramvalue.."#-31")
		return
	end
	
	local nNum = tonumber(nString)
	if nNum == g_CurBuyNum then
		return
	end
	
	if nNum * nWeaponPrice[g_CurItemIndex] > g_MyPaoShang_Zijin then
		g_CurBuyNum =  math.floor(g_MyPaoShang_Zijin/nWeaponPrice[g_CurItemIndex])
	else
		g_CurBuyNum = nNum
	end			
	
	if g_CurBuyNum <= 0 then
		g_CurBuyNum = 1
	end

	if g_CurBuyNum > g_MaxBuyNum then
		g_CurBuyNum = g_MaxBuyNum
	end

	PaoShang_Num1:SetText(g_CurBuyNum)
	local need = g_CurBuyNum*nWeaponPrice[g_CurItemIndex]
	PaoShang_Money1_Need:SetText(need.."#-31");
	if need <= paramvalue then
		--#G
		PaoShang_Money2_Need:SetText(paramvalue.."#-31")
	else
		PaoShang_Money2_Need:SetText("#cff0000"..paramvalue.."#-31")
	end
end

function PaoShang_ChangeSellNum()
	local nString = PaoShang_Num2:GetText()
	local nNum = tonumber(nString)
	
	if g_CurSellItemIndex < 4 or g_CurSellItemIndex>6 then
		g_CurSellNum = 1
		if nNum ~= g_CurSellNum then
			PaoShang_Num2:SetText(g_CurSellNum)		
		end
		PaoShang_Money3_Need:SetText( tostring(0).."#-31" );			
		return
	end
	
	
	if nString == nil or nString =="" then
		g_CurSellNum = 1
		if nNum ~= g_CurSellNum then
			PaoShang_Num2:SetText(g_CurSellNum)	
		end	
		PaoShang_Money3_Need:SetText( tostring(g_CurSellNum*nWeaponPrice[g_CurSellItemIndex]).."#-31" );			
		return
	end
	
	if nNum == g_CurSellNum then
		return
	end
		
	if nNum > nMyItemNum[g_CurSellItemIndex-3] then
		g_CurSellNum = nMyItemNum[g_CurSellItemIndex-3]	
	else
		g_CurSellNum = nNum
	end
	
	if g_CurSellNum <= 0 then
		g_CurSellNum = 1
	end
		
	PaoShang_Num2:SetText(g_CurSellNum)		
	PaoShang_Money3_Need:SetText( tostring(g_CurSellNum*nWeaponPrice[g_CurSellItemIndex]).."#-31" );	
end

function PaoShang_SelectSellItem()
	for i=1,3 do
		if nMyItemNum[i] > 0 then
			return i+3
		end
	end	
	return 0
end
