
local g_Selectindex = -1;
local g_nShopIndex = {};
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local OpenType =0; --0:???? 1:??????
local g_LastSelect_NormalShop =""
local g_LastSelect_RecycleShop =""
--===============================================
-- OnLoad
--===============================================
function PS_ShopList_PreLoad()
	this:RegisterEvent("PS_OPEN_SHOPLIST");						-- ?????????
	this:RegisterEvent("PS_UPDATE_SEARCH_SHOPLIST");	-- ??????????
	this:RegisterEvent("PS_OPEN_RECYCLESHOPLIST");	-- ??????????
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_UPDATE_SEARCH_RECYCLESHOPLIST");
	
end

function PS_ShopList_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_ShopList_OnEvent(event)
	if ( event == "PS_OPEN_SHOPLIST" ) then
		OpenType = 0;
		this:Show();
		--objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Shoplist");
	
		g_Selectindex = -1;

		PS_ShopList_Search_UpdateFrame();
		
	elseif( event == "PS_UPDATE_SEARCH_SHOPLIST" )  then
		g_Selectindex = -1;
		OpenType = 0;
		PS_ShopList_Search_UpdateFrame();
		
	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Shoplist");
		end	
	elseif(event == "PS_UPDATE_SEARCH_RECYCLESHOPLIST")then
		OpenType = 1;
		g_Selectindex = -1;
		PS_ShopList_Search_UpdateFrame();
	end

end

--===============================================
-- UpdateFrame()   ÒÑ¾­Ã»ÓÐÊ¹ÓÃ â¸öº¯ÊýÁË
--===============================================
function PS_ShopList_UpdateFrame()
	
	--ÉÌÒµÖ¸Êý
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("Buôn bán luÛ th×a;" .. szTemp);
	
	PS_ShopList_ShopList:RemoveAllItem();
	
	local nNum = PlayerShop:GetShopNum("all");
	
	for i=0 , nNum-1 do
		g_nShopIndex[i] = -1;
		--	    Ãû×Ö,     ×ÜÊýÁ¿, ¿ª ÅÊý, ÀàÐÍ
		local szShopName,OpenNum,SaleNum,szType = PlayerShop:EnumShop(i);
		local szState = SaleNum.."/"..OpenNum;
		PS_ShopList_ShopList:AddNewItem(szShopName, 0, i);
		PS_ShopList_ShopList:AddNewItem(szState, 1, i);
		PS_ShopList_ShopList:AddNewItem(szType, 2, i);	
		
		g_nShopIndex[i] = i;
	end
	
	UpdateShopInfo();	
	
end

--===============================================
-- ÏÔÊ¾·ÖÀà²éÑ¯½á¹û
--===============================================
function PS_ShopList_Search_UpdateFrame()
	PS_ShopList_Check_Item:Show();
	PS_ShopList_Check_Item2:Show();
	local ListCtr ;
	if(OpenType == 0) then
		PS_ShopList_Check_Item2:SetCheck(1);
		PS_ShopList_Check_Item:SetCheck(0);
		PS_ShopList_RecycleShopList:Hide();
		PS_ShopList_ShopList:Show();
		PS_ShopList_Button_Accept:SetProperty("Text", "Mua s¡m");
		ListCtr = PS_ShopList_ShopList;
		PS_ShopList_Find:Show();
		PS_ShopList_Button_Remove:Show();
		PS_ShopList_Button_Manage:Show();
	else
		PS_ShopList_Check_Item2:SetCheck(0);
		PS_ShopList_Check_Item:SetCheck(1);
		PS_ShopList_RecycleShopList:Show();
		PS_ShopList_ShopList:Hide();
		PS_ShopList_Button_Accept:SetProperty("Text", "Bán ra");
		ListCtr = PS_ShopList_RecycleShopList;
		PS_ShopList_Find:Hide();
		PS_ShopList_Button_Manage:Show();
		PS_ShopList_Button_Remove:Hide();
	end


	

	PS_ShopList_DragTitle:SetText("#gFF0FA0thß½ng hµi cØa hàng");

	local szType = PlayerShop:GetShopListType();
	if(szType == "panchu" and OpenType==0)  then
		PS_ShopList_Find:Hide()
		PS_ShopList_Check_Item:Hide();
		PS_ShopList_Check_Item2:Hide();
		PS_ShopList_Button_Remove:Hide();
		PS_ShopList_Button_Manage:Hide();
		PS_ShopList_Button_Accept:SetText("Xem xét");
		PS_ShopList_DragTitle:SetText("#gFF0FA0chu¦n b¸ Bàn Xu¤t Ðích cØa hàng");

	end


	--Çå¿ ËµÃ÷ÄÚÈÝ
	PS_ShopList_Since:SetText("");				-- ????
	PS_ShopList_ShopOwner:SetText("");		-- ????
	PS_ShopList_ShopOwnerID:SetText("");	-- ??ID
	PS_ShopList_ShopInfo:SetText("");			-- ??
	PS_ShopList_DPID:SetText("")

	g_Selectindex = -1;

	--ÉÌÒµÖ¸Êý
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("Buôn bán luÛ th×a:" .. szTemp);
	ListCtr:RemoveAllItem();
	
	local nNum = PlayerShop:GetShopNum("search");

	ListCtr:SetProperty("SortDirection", "None")
	
	for i=0 , nNum-1 do
		g_nShopIndex[i] = -1;
		local nIndex = PlayerShop:EnumSearchShopIndex(i);
		
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType, nShopIndex = PlayerShop:EnumShop(nIndex);
		--local szState = SaleNum.."/"..OpenNum;

		-- ÎªÁËÖ§³ÖÅÅÐò, ¸Ä³É 00/00 µÄÍ³Ò»¸ñÊ½, ×¢ÒâµÃµ½µÄ SaleNum ºÍ OpenNum ÊÇ×Ö·û´®
		local strSaleNum = SaleNum
		local strOpenNum = OpenNum
		if (tonumber(SaleNum) < 10) then
			strSaleNum = "0" .. tostring(SaleNum)
		end
		if (tonumber(OpenNum) < 10) then
			strOpenNum = "0" .. tostring(OpenNum)
		end
		local szState = strSaleNum.."/"..strOpenNum

		if OpenType ==0 and szShopName == g_LastSelect_NormalShop then
			g_Selectindex = i;
		end
		
		if OpenType ==1 and szShopName == g_LastSelect_RecycleShop then
			g_Selectindex = i;
		end

		-- ÎªÁËÈÃÅÅÐòÄÜ¹» ý³£°´  ×Ö·û´®±È½Ï, Í³Ò» shopindex µÄ³¤¶È
		local strShopIndex = nShopIndex
		if (tonumber(nShopIndex) < 10) then
			strShopIndex = "00" .. strShopIndex
		elseif (tonumber(nShopIndex) < 100) then
			strShopIndex = "0" .. strShopIndex
		end

		if nFrezeType == 1 then
			strShopIndex = "#cCCCCCC" .. strShopIndex
			szShopName = "#cCCCCCC" .. szShopName
			szState    = "#cCCCCCC" .. szState
			szType     = "#cCCCCCC" .. szType
			nRecItemnum =  "#cCCCCCC" .. nRecItemnum
		elseif nIsFavor == 1 then
			strShopIndex = "#B" .. strShopIndex
			szShopName = "#B" .. szShopName;
			szState    = "#B" .. szState;
			szType     = "#B" .. szType;
			nRecItemnum =  "#B" .. nRecItemnum;
		end

		if(OpenType == 0) then
			-- ÉÌµêÁÐ±í
			ListCtr:AddNewItem(strShopIndex, 0, i)
			ListCtr:AddNewItem(szShopName, 1, i);
			ListCtr:AddNewItem(szState, 2, i);
			ListCtr:AddNewItem(szType, 3, i);
		else
			-- ²ÄÁÏÊ ¹º
			ListCtr:AddNewItem(strShopIndex, 0, i)
			ListCtr:AddNewItem(szShopName, 1, i);
			ListCtr:AddNewItem(nRecItemnum, 2, i);
		end
		
		g_nShopIndex[i] = nIndex;
	end

	if (g_Selectindex >= 0) then
		ListCtr:SetSelectItem(g_Selectindex)
		ListCtr:SetVertScollPosition(g_Selectindex)
	end
end

--===============================================
-- Refuse
--===============================================
function PS_ShopListRefuse_Clicked()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Shoplist");

end

--===============================================
-- Accept
--===============================================
function PS_ShopListAccept_Clicked(szType)
	--È¥´ò¿ªÑ¡ÖÐµÄÁÐ±í
	if( g_Selectindex >= 0 )      then
		if OpenType ==1 then
			--Ê ¹ºÉÌµê,¹ºÎï
			PlayerShop:OpenRecycleShopDLG2(g_nShopIndex[g_Selectindex],szType);
			return
		else
			if( szType == "buy" )    then
				PlayerShop:AskOpenShop("buy",g_nShopIndex[g_Selectindex]);
			else
				PlayerShop:AskOpenShop("manage",g_nShopIndex[g_Selectindex]);
			end
		end
	else 
		PushDebugMessage("Thïnh lña ch÷n mµt cái cØa hàng");
		return;
	end
	
--	this:Hide();
	--È¡Ïû¹ØÐÄ
--	this:CareObject(objCared, 0, "PS_Shoplist");
	
end

--===============================================
-- µã»÷ÁÐ±í
--===============================================
function PS_ShopList_SelectChanged()
	
	local nIndex = PS_ShopList_ShopList:GetSelectItem();

	g_Selectindex = nIndex;
	
	if(g_Selectindex == -1)  then
		return;
	end
	PlayerShop:SetCurSelShopIdx(g_nShopIndex[nIndex]);
	
	local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[nIndex]);
	
	g_LastSelect_NormalShop = szShopName;
	
	--¸üÐÂÏÔÊ¾µÄÐÅÏ¢
	UpdateShopInfo()
	
end

function PS_RecycleShopList_SelectChanged()
	
	local nIndex = PS_ShopList_RecycleShopList:GetSelectItem();
	
	g_Selectindex = nIndex;
	
	if(g_Selectindex == -1)  then
		return;
	end
	PlayerShop:SetCurSelShopIdx(g_nShopIndex[nIndex]);
	
	local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[nIndex]);
	
	g_LastSelect_RecycleShop = szShopName;
	
	--¸üÐÂÏÔÊ¾µÄÐÅÏ¢
	UpdateShopInfo()
	
end

--===============================================
-- ¸üÐÂÉÌµêµÄÐÅÏ¢
--===============================================
function UpdateShopInfo()

	if g_Selectindex == -1    then
		return;
	end
	
	--¸üÐÂÐÅÏ¢
	-- ¿ªµêÊ±¼ä
	local szSince = PlayerShop:EnumShopInfo("since",g_nShopIndex[g_Selectindex]);
	PS_ShopList_Since:SetText("Sáng tÕo th¶i gian:".. szSince);
	
	-- µêÖ÷Ãû×Ö --¸ÄÎª³¬Á´½Ó by wangdw
	local szName = PlayerShop:EnumShopInfo("ownername",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwner:SetChatString("#YðIªm chü: #{_INFOUSR".. szName .. "}");
	
	-- µêÆÌID
	local shopIndex = PlayerShop:EnumShopInfo("shopindex", g_nShopIndex[g_Selectindex])
	if (tonumber(shopIndex) <= 0) then
		PS_ShopList_DPID:SetText("#Yc¼a hàng ID:")
	else
		PS_ShopList_DPID:SetText("#Yc¼a hàng ID:" .. shopIndex)
	end

	-- µêÖ÷ID
	local szID = PlayerShop:EnumShopInfo("ownerid",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwnerID:SetText("Ðiªm chü ID:".. szID);
	
	-- ½éÉÜ
	local szInfo = "";
	if(OpenType == 0)then
		 szInfo = PlayerShop:EnumShopInfo("desc",g_nShopIndex[g_Selectindex]);
	else
		 szInfo = PlayerShop:EnumShopInfo("recdesc",g_nShopIndex[g_Selectindex]);
	end
		
	PS_ShopList_ShopInfo:SetText(szInfo);
	
	-- ¼ÓÈë/È¥³ý Ãûµê
	if( g_Selectindex == -1 )   then 
		return;
	end
	local szShopName,OpenNum,SaleNum,szType,nIsFavor = PlayerShop:EnumShop(g_nShopIndex[g_Selectindex]);
	if(nIsFavor == 1)   then
		PS_ShopList_Button_Remove:SetText("KhÑ xoá tên Ðiªm");
	else
		PS_ShopList_Button_Remove:SetText("#{INTERFACE_XML_353}");
	end
	
end


--===============================================
-- Close
--===============================================
function PS_CreateShopClose_Clicked()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Shoplist");
end

--===============================================
-- ²é Ò
--===============================================
function PS_ShopList_Find_Clicked()
	PlayerShop:OpenFindShop();
end

--===============================================
-- ¼ÓÈë/È¥³ý Ãûµê
--===============================================
function PS_ShopList_Favor_Clicked()
	local selectIndex = PS_ShopList_ShopList:GetSelectItem();
	if(selectIndex < 0)     then
		return;
	end
	PlayerShop:AddFavor(g_nShopIndex[selectIndex]);
	
	local totalCount = PS_ShopList_ShopList:GetItemCount();
	
	--¼ÓÈëÃûµêºó£¬×Ô¶¯Ñ¡ÖÐÏÂÒ»¸öµê£¬Èç¹ûÒÑ¾­ÊÇ×îºóÒ»¸öµêÁË£¬ÔòÑ¡ÖÐÇ°Ò»¸ö£¬Èç¹ûÖ»ÓÐÒ»¸öµê£¬ÔòÑ¡ÖÐ×Ô¼º
	if(selectIndex + 1 < totalCount) then
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex + 1]);
		g_LastSelect_NormalShop = szShopName;
	elseif(selectIndex - 1 >= 0) then
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex - 1]);
		g_LastSelect_NormalShop = szShopName;
	else
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex]);
		g_LastSelect_NormalShop = szShopName;
	end
end

--===============================================
-- OnHiden
--===============================================
function PS_ShopList_Frame_OnHiden()
	PlayerShop:CloseSearchFrame();

end

function PS_ShopList_ChangeTabIndex(idx)
	
	if(idx==0)then
		if(PS_ShopList_Check_Item2:GetCheck()~=1)then
			PlayerShop:FindShop("all",0);
		end
	else
		if(PS_ShopList_Check_Item:GetCheck()~=1)then
			PlayerShop:FindShop("recycleshop",0);
		end
	end
end
