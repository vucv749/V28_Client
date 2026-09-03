local nTheTabIndex = 0;
local PACKAGE_BUTTONS_NUM = 100;
local PACKAGE_BUTTONS = {};
local PACKAGE_BUTTON_BACK={};
local PACKAGE_EXTBAG_NUM = 10;
local PACKAGE_EXTBAG = {};
local PACKAGE_TAB = {};
local PACKAGE_TAB_TEXT = {};
local PACKAGE_NUM_PER_LINE = 10;
local Lock_Flag = 0;
local g_MaxLine = 0;
local g_PackageHeight={};
g_PackageHeight["title"] = { 0, 25, };
g_PackageHeight["page"]  = { 25, 20, };
g_PackageHeight["bag"]	 = { 42, 36, };
g_PackageHeight["money"] = { 0, 50,};

-- ±³°ü½çÃæµÄÄ¬ÈÏÎ»ÖÃ
local g_Packet_Frame_UnifiedXPosition;
local g_Packet_Frame_UnifiedYPosition;

function Packet_PreLoad()
	this:RegisterEvent("TOGLE_CONTAINER");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("TOGLE_BIGBANK");
	this:RegisterEvent("OPEN_BOOTH");
	this:RegisterEvent("LOCK_WORK_Item");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("CLOSE_MISSION_REPLY");	
	this:RegisterEvent("OPEN_STALL_SALE");	
	this:RegisterEvent("OPEN_ITEM_COFFER");	
	this:RegisterEvent("PS_OPEN_MY_SHOP");
	this:RegisterEvent("RESET_EXT_BAG");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UPDATE_BIND_YUANBAO");
	this:RegisterEvent("CITY_SHOW_SHOP");
	
	-- ¿ªÊ¼ ûÀíºÍ½áÊø ûÀí
	this:RegisterEvent("BEGIN_PACKUP_PACKET");
	this:RegisterEvent("END_PACKUP_PACKET");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	this:RegisterEvent("OPEN_RECYCLESHOP_BUYER");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("OPEN_WINDOW")
	
	-- ×¢²áµÈ¼¶
	this:RegisterEvent("UNIT_LEVEL")
	
	-- ¼¤»î½çÃæÊÂ¼þ
	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("OPEN_UP_ITEM")

	this:RegisterEvent("YIGUI_OPEN", true)
	
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function Packet_OnLoad()
	PACKAGE_BUTTONS =	{	
		Packet_Space_Line1_Row1_button,Packet_Space_Line1_Row2_button,Packet_Space_Line1_Row3_button,Packet_Space_Line1_Row4_button,Packet_Space_Line1_Row5_button,
		Packet_Space_Line1_Row6_button,Packet_Space_Line1_Row7_button,Packet_Space_Line1_Row8_button,Packet_Space_Line1_Row9_button,Packet_Space_Line1_Row10_button,
		Packet_Space_Line2_Row1_button,Packet_Space_Line2_Row2_button,Packet_Space_Line2_Row3_button,Packet_Space_Line2_Row4_button,Packet_Space_Line2_Row5_button,
		Packet_Space_Line2_Row6_button,Packet_Space_Line2_Row7_button,Packet_Space_Line2_Row8_button,Packet_Space_Line2_Row9_button,Packet_Space_Line2_Row10_button,
		Packet_Space_Line3_Row1_button,Packet_Space_Line3_Row2_button,Packet_Space_Line3_Row3_button,Packet_Space_Line3_Row4_button,Packet_Space_Line3_Row5_button,
		Packet_Space_Line3_Row6_button,Packet_Space_Line3_Row7_button,Packet_Space_Line3_Row8_button,Packet_Space_Line3_Row9_button,Packet_Space_Line3_Row10_button,
		Packet_Space_Line4_Row1_button,Packet_Space_Line4_Row2_button,Packet_Space_Line4_Row3_button,Packet_Space_Line4_Row4_button,Packet_Space_Line4_Row5_button,
		Packet_Space_Line4_Row6_button,Packet_Space_Line4_Row7_button,Packet_Space_Line4_Row8_button,Packet_Space_Line4_Row9_button,Packet_Space_Line4_Row10_button,
		Packet_Space_Line5_Row1_button,Packet_Space_Line5_Row2_button,Packet_Space_Line5_Row3_button,Packet_Space_Line5_Row4_button,Packet_Space_Line5_Row5_button,
		Packet_Space_Line5_Row6_button,Packet_Space_Line5_Row7_button,Packet_Space_Line5_Row8_button,Packet_Space_Line5_Row9_button,Packet_Space_Line5_Row10_button,
		Packet_Space_Line6_Row1_button,Packet_Space_Line6_Row2_button,Packet_Space_Line6_Row3_button,Packet_Space_Line6_Row4_button,Packet_Space_Line6_Row5_button,
		Packet_Space_Line6_Row6_button,Packet_Space_Line6_Row7_button,Packet_Space_Line6_Row8_button,Packet_Space_Line6_Row9_button,Packet_Space_Line6_Row10_button,
		Packet_Space_Line7_Row1_button,Packet_Space_Line7_Row2_button,Packet_Space_Line7_Row3_button,Packet_Space_Line7_Row4_button,Packet_Space_Line7_Row5_button,
		Packet_Space_Line7_Row6_button,Packet_Space_Line7_Row7_button,Packet_Space_Line7_Row8_button,Packet_Space_Line7_Row9_button,Packet_Space_Line7_Row10_button,
		Packet_Space_Line8_Row1_button,Packet_Space_Line8_Row2_button,Packet_Space_Line8_Row3_button,Packet_Space_Line8_Row4_button,Packet_Space_Line8_Row5_button,
		Packet_Space_Line8_Row6_button,Packet_Space_Line8_Row7_button,Packet_Space_Line8_Row8_button,Packet_Space_Line8_Row9_button,Packet_Space_Line8_Row10_button,
		Packet_Space_Line9_Row1_button,Packet_Space_Line9_Row2_button,Packet_Space_Line9_Row3_button,Packet_Space_Line9_Row4_button,Packet_Space_Line9_Row5_button,
		Packet_Space_Line9_Row6_button,Packet_Space_Line9_Row7_button,Packet_Space_Line9_Row8_button,Packet_Space_Line9_Row9_button,Packet_Space_Line9_Row10_button,
		Packet_Space_Line10_Row1_button,Packet_Space_Line10_Row2_button,Packet_Space_Line10_Row3_button,Packet_Space_Line10_Row4_button,Packet_Space_Line10_Row5_button,
		Packet_Space_Line10_Row6_button,Packet_Space_Line10_Row7_button,Packet_Space_Line10_Row8_button,Packet_Space_Line10_Row9_button,Packet_Space_Line10_Row10_button,
						};
											
	PACKAGE_EXTBAG  = {
						Packet_Space_Line1;
						Packet_Space_Line2;
						Packet_Space_Line3;
						Packet_Space_Line4;
						Packet_Space_Line5;
						Packet_Space_Line6;
						Packet_Space_Line7;
						Packet_Space_Line8;
						Packet_Space_Line9;
						Packet_Space_Line10;
						}
		
	PACKAGE_TAB_TEXT = {
		[0] = "ÐÕo cø",
		"Ng.li®u",
		"Nhi®m Vø",
	};
	
	PACKAGE_TAB = {
		[0] = Packet_Material,
		[1] = Packet_Stall,
		[2] = Packet_Mission,		
		};	
	
	Packet_Pet:Enable();
	
	--Packet_Lock:Disable();
	
	-- ±£´æ±³°ü½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Packet_Frame_UnifiedXPosition	= Packet_Frame:GetProperty("UnifiedXPosition");
	g_Packet_Frame_UnifiedYPosition	= Packet_Frame:GetProperty("UnifiedYPosition");

end

function Packet_Open()
	Packet_ResetExtBag();
	this:Show();
	NotifyPacketStatus(1)
end

function Packet_Close()
	this:Hide();
	nTheTabIndex = 0;
	PACKAGE_TAB[nTheTabIndex]:SetCheck(1);
	
	--¹Ø± ½çÃæÊ±£¬ÏòServerÇëÇó±³°üÍ¬²½
	--AskMyBagListº¯Êý±¾ÉíÓÐ¼ÆÊ±¿ØÖÆ
	DataPool:AskMyBagList();
	NotifyPacketStatus(0)
end

function Packet_OnEvent( event )
	if ( event == "TOGLE_CONTAINER" ) then
		if( this:IsVisible() ) then
			Packet_Close();
		else
			Packet_Open();
		end
	elseif ( event == "PS_OPEN_MY_SHOP" )  then
		Packet_Open();
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Packet_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		Packet_ChangeTabIndex(nTheTabIndex);
		Lua_BagChangeEvent();
	elseif ( event == "OPEN_EXCHANGE_FRAME" ) then
		Packet_Open();
	elseif ( event == "TOGLE_BANK" ) then
		Packet_Open();
	elseif ( event == "TOGLE_BIGBANK" ) then
		Packet_Open();
	elseif ( event == "OPEN_BOOTH" ) then
		Packet_Open();
	elseif ( event == "OPEN_WINDOW" ) then
		if( arg0 == "Packet") then
			Packet_Open();
		end
	--Ëø¶¨ ýÔÚ²Ù×÷µÄ±³°üÖÐµÄÎïÆ·
	elseif ( event == "LOCK_PACKET_ITEM" ) then 

	elseif ( event == "REPLY_MISSION" ) then 
		Packet_Open();
	elseif ( event == "CLOSE_MISSION_REPLY" ) then
		Packet_Close();
	elseif ( event == "OPEN_ITEM_COFFER" ) then
		
	elseif ( event == "OPEN_STALL_SALE" )  then
		Packet_Open(); 
	elseif ( event == "CITY_SHOW_SHOP" and arg0 == "open") then
		Packet_Open();		
	elseif ( event == "RESET_EXT_BAG" ) then
		Packet_ResetExtBag();
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		Packet_YuanBao2:SetText("KNB: "..tostring(Player:GetData("YUANBAO")));
	elseif (event == "UPDATE_BIND_YUANBAO" and this:IsVisible()) then
		Packet_BangdingYuanbao:SetText("#{BDYB_090714_01}"..tostring(Player:GetData("BIND_YUANBAO")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Packet_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	
	--Ëø¶¨¡° ûÀí°´Å¥¡±
	elseif ( event == "BEGIN_PACKUP_PACKET" )   then		
		Packet_Classify:Disable()
	
	--´ò¿ª¡° ûÀí°´Å¥¡±
	elseif ( event == "END_PACKUP_PACKET" )	    then		
		Packet_Classify:Enable()
  --ÃË»á²ÄÁÏ×ª»¯
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2024040301 ) then
		nTheTabIndex = 1
		PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
		Packet_Open()
	--ÉñÆ÷Á¶»ê
	elseif event == "UI_COMMAND" and tonumber(arg0) == 19831114 then
		Packet_Open()
	--°µÆ÷¼¼ÄÜÖØÏ´
	elseif event == "UI_COMMAND" and tonumber(arg0) == 800034 then
		Packet_Open()
	--ÖØÏ´Îä»ê¼¼ÄÜ
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20090722 then
		Packet_Open()

	-- Éñ±øÔ¤ÈÈÈÎÎñ3
	elseif event == "UI_COMMAND" and tonumber(arg0) == 79110301 then
		nTheTabIndex = 2
		PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
		Packet_Open()
	
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		Packet_Close();
	
	elseif(event == "OPEN_RECYCLESHOP_BUYER") then
		Packet_Open();		
	
	-- µÈ¼¶
	elseif(event == "UNIT_LEVEL" and this:IsVisible()) then 
		local result, money = Player:GetLevelMoneyLimit();
		if result then 
  		Packet_Money:SetToolTip("#{money_tips} " ..  string.format("#{_MONEY%d}", money) );
	  end
	  
	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 920170825 ) then
		nTheTabIndex = 1
		PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
		Packet_Open()
  
  -- ±¦Ê¯ÏâÇ¶
  elseif ( event == "UI_COMMAND" and tonumber(arg0)== 19830424 ) then
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  
  -- ×°±¸¼«ÏÞÏâÇ¶
  elseif ( event == "UI_COMMAND" and tonumber(arg0)== 751107 ) then
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()

  -- ×°±¸´ò¿×
  elseif ( event == "UI_COMMAND" and tonumber(arg0) == 25 ) then
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  	
  -- ×°±¸¼«ÏÞ´ò¿×
  elseif ( event == "UI_COMMAND" and tonumber(arg0) == 75117 ) then
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  
  -- ±¦Ê¯ ª³ý
  elseif ( event == "UI_COMMAND" and tonumber(arg0) == 27 ) then
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  	
  -- ±¦Ê¯¼«ÏÞ ª³ý
  elseif ( event == "UI_COMMAND" and tonumber(arg0) == 25702 ) then
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  
  -- ±¦Ê¯µñ×Á
  elseif ( event == "UI_COMMAND" and tonumber(arg0) == 112236 ) then
  	nTheTabIndex = 1
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  
  -- ±¦Ê¯ÈÛÁ¶
  elseif ( event == "UI_COMMAND" and tonumber(arg0) == 112237 ) then
  	nTheTabIndex = 1
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  	
  -- ±¦Ê¯ºÏ³É
  elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 23 ) then
  	nTheTabIndex = 1
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  -- ÎÞÏà±¦Ê¯ºÏ³É
  elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 2024061401 ) then
  	nTheTabIndex = 1
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  elseif ( event == "UI_COMMAND" and tonumber(arg0)== 20110509 ) then
	nTheTabIndex = 0
	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
	Packet_Open()
  -- ²ÄÁÏºÏ³É
  elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 19810424 ) then
  	nTheTabIndex = 1
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  
  -- º®ÓñºÏ³É
  elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 86021935 ) then
  	nTheTabIndex = 1
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  
	-- Ê±×°´ò¿×
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20091027 ) then
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  	
  --Ê±×°ÏâÇ¶
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20091029 ) then   	
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()
  	
	--ÅäÊÎºÏ³É
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 19860143 ) then   	
  	nTheTabIndex = 1
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
	  Packet_Open()
	
	--ÅäÊÎ ª³ý
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 19851274 ) then   	
  	nTheTabIndex = 0
  	PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
  	Packet_Open()  	  	
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 20210315 ) then
	-- Ê±×°È¾É«
		Packet_Open()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 99850605 ) then
		Packet_Open()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 89106201 ) then
		--É¨µ´ÔÂ¿¨&È ¿¨
		Packet_Open()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 89021506 ) then
		
		Packet_Open()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 88990903 ) then
		
		Packet_Open()
	elseif ( event == "YIGUI_OPEN" ) then
		Packet_Open();
		
	elseif (event == "OPEN_UP_ITEM" ) then
		if this:IsVisible()  then
			return
		end
		nTheTabIndex = 0
		PACKAGE_TAB[nTheTabIndex]:SetCheck(1)
		Packet_Open()

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		Packet_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ	
		Packet_Frame_On_ResetPos()
		-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	end
	
end

function Packet_ResetExtBag()
	Packet_OnUpdateShow();
	Packet_UpdateDragAcceptName();
end

function Packet_OnShow()
	Packet_ChangeTabIndex(nTheTabIndex);
end

function Packet_ChangeTabIndex(nTabIndex)
	if( nTabIndex < 0 or nTabIndex >=3) then
		return;
	end
	nTheTabIndex = nTabIndex;
	Packet_OnUpdateShow();
	Packet_UpdateDragAcceptName();
end

function Packet_UpdateBagLine( nMaxLine )
	
	g_MaxLine = nMaxLine;
	local i
	for i = 1, 10 do
		if( i <= g_MaxLine ) then
			PACKAGE_EXTBAG[ i ]:Show();
		else
			PACKAGE_EXTBAG[ i ]:Hide();
		end
	end
	local nWindowHeight;
	nWindowHeight = g_MaxLine * 35 + 335;
	Packet_Frame:SetProperty( "AbsoluteHeight",nWindowHeight );
	
end

function Packet_OnUpdateShow()	
	local i=1;
	local szPacketName = "";
	local CurrNum = 20;
	local BaseNum = 20;
	local MaxNum = 100;
	Lock_Flag = 0;

	if(nTheTabIndex == 0) then
		szPacketName = "base";
		CurrNum = DataPool:GetBaseBag_Num();
		BaseNum = DataPool:GetBaseBag_BaseNum();
		MaxNum = DataPool:GetBaseBag_MaxNum();
	elseif(nTheTabIndex == 1) then
		szPacketName = "material";
		CurrNum = DataPool:GetMatBag_Num();
		BaseNum = DataPool:GetMatBag_BaseNum();
		MaxNum = DataPool:GetMatBag_MaxNum();
	elseif(nTheTabIndex == 2) then
		szPacketName = "quest";
		CurrNum = DataPool:GetTaskBag_Num();
		BaseNum = DataPool:GetTaskBag_BaseNum();
		MaxNum = DataPool:GetTaskBag_MaxNum();
	else 
		return;
	end
	
	local nMaxLine = math.floor( CurrNum / PACKAGE_NUM_PER_LINE );
	--Èç¹ûÊÇ û³ýÁË
	if( nMaxLine * PACKAGE_NUM_PER_LINE == CurrNum ) then
	else
		nMaxLine = nMaxLine + 1;
	end
	AxTrace( 8,0,"Lßþng ô Túi hi®n có:"..tostring( CurrNum ).."  S¯ v§t ph¦m ðßþc hi¬n th¸:"..tostring( nMaxLine ) );
	--Èç¹û³¬¹ýµ±Ç°ÏÔÊ¾µÄ×î´ó·¶Î§ÁË£¬¾Í¸üÐÂ°üµÄÐÐÊý
	Packet_UpdateBagLine( nMaxLine );
	local nMaxDisplayNumber = nMaxLine * PACKAGE_NUM_PER_LINE;
	for i=1, nMaxDisplayNumber do
		--Èç¹ûÊÇÐèÒªÏÔÊ¾µÄ
		if( i <= CurrNum ) then
			local theAction,bLocked = PlayerPackage:EnumItem(szPacketName, i-1);
			PACKAGE_BUTTONS[ i ]:Show();
			if theAction:GetID() ~= 0 then
				PACKAGE_BUTTONS[i]:SetActionItem(theAction:GetID());
			else
				PACKAGE_BUTTONS[i]:SetActionItem(-1);
			end
			if bLocked == 1 then
				PACKAGE_BUTTONS[i]:Disable();
				Lock_Flag = 1
			else
				PACKAGE_BUTTONS[i]:Enable();
			end

		else  --????????
			PACKAGE_BUTTONS[ i ]:SetActionItem( -1 );
			PACKAGE_BUTTONS[ i ]:Hide();
		end
	end	
	
	if Lock_Flag == 0 then
		Packet_Classify : Enable();
	else
		Packet_Classify : Disable();
	end

	--Money
	local result, money = Player:GetLevelMoneyLimit();
	if result then 
  	Packet_Money:SetToolTip("#{money_tips} " ..  string.format("#{_MONEY%d}", money) );
  end
	Packet_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--YuanBao
	Packet_YuanBao2:SetText("KNB: "..tostring(Player:GetData("YUANBAO")));
	--BindYuanBao
	Packet_BangdingYuanbao:SetText("#{BDYB_090714_01}"..tostring(Player:GetData("BIND_YUANBAO")));
	--Money_JZ
	Packet_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
end

function Packet_UpdateDragAcceptName()
	
	local nStartAcceptIndex = 0;
	
	if(nTheTabIndex == 0) then
		nStartAcceptIndex = 1;
	elseif(nTheTabIndex == 1) then
		nStartAcceptIndex = DataPool:GetBaseBag_MaxNum()+1;
	elseif(nTheTabIndex == 2) then
		nStartAcceptIndex = DataPool:GetBaseBag_MaxNum()+DataPool:GetMatBag_MaxNum()+1;
	else
		return;
	end

	local i=1;
	while i<=PACKAGE_BUTTONS_NUM do
		PACKAGE_BUTTONS[i]:SetProperty("DragAcceptName", "P"..tostring(nStartAcceptIndex));
		
		nStartAcceptIndex = nStartAcceptIndex+1;
		i = i+1;
	end

end

function Packet_ItemBtnClicked( nLine, nRow )

		local nIndex = ( nLine - 1 ) * PACKAGE_NUM_PER_LINE + nRow;
	if(nIndex < 1 or nIndex > PACKAGE_BUTTONS_NUM) then 
		return;
	end
	
	local nBagPos = nIndex
	if(nTheTabIndex == 1) then
        nBagPos = nBagPos + DataPool:GetBaseBag_MaxNum()
	elseif(nTheTabIndex == 2) then
		nBagPos = nBagPos + DataPool:GetBaseBag_MaxNum() + DataPool:GetTaskBag_MaxNum()
	end
	
	-- @WAYLEE
	local nIsPutItem = 0
	local nExtraLayoutActionButton = {
		"SGZB_XiLian","TongYongXueWuUI","Equip_JieBang","DWChaiJie","GameTools5","GemcomupDate","Gemfenli","Gemzhuoke",
		--ÉñÆ÷¹¦ÄÜ
		"SuperWeapon9_ShengJie","SuperWeapon9_ShengXing","SuperWeapon9_TuPo","SuperWeaponChange","SuperWeaponJJ","SuperWeaponQH","SuperWeaponSoulless","SuperWeaponTL",
		"SuperWeapon9_Change","SuperWeapon9_JieMeng",
		--½ð¸ ï±
		"JinGangCuo_AddNum",
		--¾«Í¨¹¦ÄÜ
		"EquipEducation_Update","EquipEducation_Transfer","EquipEducation_Temper","EquipEducation_Decompose","EquipAttributeTransfer",
		--ÍõÈ¨ÌìµÀ
		"EquipBaoJian_Transfer","EquipEducation_JinJie2","EquipEducation_ShengLing",
		--ÁúÎÆ
		"LongwenLevelUp","LongwenPropertyResetNEW","LongwenStarUp","LongwenExtraPropertyStudy","LongwenExtraPropertyStudy2","LongwenExtraPropertyUp",
	} 
	
	for i = 1,table.getn(nExtraLayoutActionButton) do
		if IsWindowShow(nExtraLayoutActionButton[i]) then
			PushEvent("UI_COMMAND",201107281,tonumber(nBagPos - 1));
			nIsPutItem = 1;
			break;
		end
	end
	
	if nIsPutItem ~= 1 then
		PACKAGE_BUTTONS[nIndex]:DoAction();
	end


end

function Packet_ItemBtnSubClicked( nLine,nRow )
	local nIndex = ( nLine - 1 ) * PACKAGE_NUM_PER_LINE + nRow;
	if(nIndex < 1 or nIndex > PACKAGE_BUTTONS_NUM) then 
		return;
	end

	PACKAGE_BUTTONS[nIndex]:DoSubAction();
end



--===============================================
-- Æô¶¯°ÚÌ¯½çÃæ(ÔÚ°ÚÌ¯Ç°»áÏÈÈ·ÈÏÌ¯Î»·Ñ)
--===============================================
function Packet_Sale_Clicked()
	PlayerPackage:OpenStallSaleFrame();
end

function Packet_PackUp_Clicked()
	PlayerPackage:PackUpPacket(nTheTabIndex);
end


--===============================================
-- µã»÷Ëø¶¨
--===============================================
function Packet_Lock_Open()
	PlayerPackage:OpenLockFrame(nTheTabIndex);
end

-- ¶þ¼¶ÃÜÂë
function Packet_OpenDlgForErjimima()
	local isSetMinorPwd = IsMinorPwdSetup();
	if(tonumber(isSetMinorPwd) == 1) then		--???
		OpenChangeMinorPasswordDlg();
	else		--???
		OpenSetMinorPasswordDlg();
	end
	
end

--================================================
-- »Ö¸´±³°ü½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Packet_Frame_On_ResetPos()

	Packet_Frame:SetProperty("UnifiedXPosition", g_Packet_Frame_UnifiedXPosition);
	Packet_Frame:SetProperty("UnifiedYPosition", g_Packet_Frame_UnifiedYPosition);

end

function Packet_OnChongZhi()
	-- Chongzhi()
	
	PushDebugMessage("Ngß¶i thÑ nh¤t X64hàm s¯");
	 PushDebugMessage(XueWu(1,3));
end

function Packet_OnDuiHuan()
	local bflg =YuanbaoExange()
	if bflg~= 1 then
		return ;
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AskOpenDuihuanWindow");
		Set_XSCRIPT_ScriptID(181000);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end
