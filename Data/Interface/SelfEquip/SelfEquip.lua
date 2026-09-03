-- Êý¾Ý³ØÖÐ¶¨ÒåµÄ×°±¸Êý¾Ý.
--HEQUIP_WEAPON		=0,		//ÎäÆ÷	WEAPON
--HEQUIP_CAP			=1,		//Ã±×Ó	DEFENCE
--HEQUIP_ARMOR		=2,		//ÒÂ·þ	DEFENCE
--HEQUIP_CUFF			=3,		//»¤Íó	DEFENCE
--HEQUIP_BOOT			=4,		//Ð¬	DEFENCE
--HEQUIP_SASH			=5,		//Ñü´ø	ADORN
--HEQUIP_RING			=6,		//½äÖ¸	ADORN
--HEQUIP_NECKLACE	=7,		//ÏîÁ´	ADORN
--HEQUIP_RIDER		=8,		//°µÆ÷	ADORN
--HEQUIP_BAG			=9,		//ÐÐÄÒ
--HEQUIP_BOX			=10,	//Ïä¸ñ
--HEQUIP_RING_2		=11,	//µÚ¶þ¸ö½äÖ¸	ADORN
--HEQUIP_CHARM		=12,	//»¤·û				ADORN
--HEQUIP_CHARM_2	=13,	//µÚ¶þ¸ö»¤·û	ADORN
--HEQUIP_WRIST		=14,	//»¤Íó				ADORN
--HEQUIP_SHOULDER	=15,	//»¤¼ç				DEFENCE
--HEQUIP_DRESS		=16,	//Ê±×°				DEFENCE
--HEQUIP_RESERVE	=17,	//Ô¤Áô1
--HEQUIP_RESERVE_2=18,	//Ô¤Áô2

--Í³Ò»»¯ÏÂÒ³Ç©ÏÔÊ¾Òþ²Ø Ä¿Ç°¹Ì¶¨Ë³Ðò ÐÂÔö¸ÄÐòºÅ Ã¿¸öÒ³Ç©¶¼ÐèÒªÌí¼Ó
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		NeedCheck = 0,Tip = ""},
	[2] = {Text = "#{INTERFACE_XML_882}",		NeedCheck = 0,Tip = ""},
	[3] = {Text = "#{INTERFACE_XML_854}",		NeedCheck = 0,Tip = ""},
	[4] = {Text = "#{WH_xml_XX(95)}",			NeedCheck = 0,Tip = ""},
	[5] = {Text = "#{XL_XML_35}",				NeedCheck = 0,Tip = ""},
	[6] = {Text = "#{TalentMP_20210804_57}",	NeedCheck = 1,Tip = ""},
	[7] = {Text = "#{SZXT_221216_22}",			NeedCheck = 0,Tip = "#{SZXT_221216_23}"},
	[8] = {Text = "#{SBFW_20230707_1}",		NeedCheck = 1,Tip = "#{SBFW_20230707_2}"},
	[9] = {Text = "#{DWJJ_240329_153}",  	 	NeedCheck = 0,Tip = ""},
	[10] = {Text = "#{DFJC_250709_1}",  	 	NeedCheck = 0,Tip = ""},
	[11] = {Text = "#{GRYM_221213_22}",  	 	NeedCheck = 0,Tip = ""},
	[12] = {Text = "#{INTERFACE_XML_496}",		NeedCheck = 0,Tip = ""},
}
local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}
--------------------------------------------------------------------------------
-- ×°±¸°´Å¥Êý¾Ý¶¨Òå
--
local  g_WEAPON;		--??
local  g_ARMOR;			--??
local  g_CAP;				--??
local  g_CUFF;			--??
local  g_BOOT;			--?
local  g_RING;			--??
local  g_SASH;			--??
local  g_NECKLACE;	--??
local  g_Dark;			--??
local  g_RING_2;		--??2
local  g_CHARM;			--??
local  g_CHARM_2;		--??2
local  g_WRIST;			--??
local  g_SHOULDER;	--??

local  g_EquipMask ={}
---------------------------------------------------------------------------------
-- µãÊý¶¨Òå
--

local g_RemainPoint 			= 0;	-- ????
local g_CurExperience 	  = 0;	-- ??????
local g_RequireExperience = 0;  -- ??????

local g_AddStr = 0;					-- ???????????.
local g_AddSpr = 0;					-- ???????????.
local g_AddCon = 0;					-- ???????????.
local g_AddInt = 0;					-- ???????????.
local g_AddDex = 0;					-- ???????????.

local g_CurRemainPoint = 0;				-- ????????

-- ÊÇ·ñ´ò¿ª³ÆºÅ½çÃæ
local g_bOpenTitleDlg = 0;
local SELFEQUIP_TAB_TEXT = {};
local LEVEL_MAX_ENABLE =119;	--??????

local g_PropertyTable = {}

local g_XiulianTipTable = {"#{XL_XML_90}","#{XL_XML_91}","#{XL_XML_92}","#{XL_XML_93}","#{XL_XML_94}"
							,"#{XL_XML_95}","#{XL_XML_96}","#{XL_XML_97}","#{XL_XML_98}","#{XL_XML_99}"
							,"#{XL_XML_100}"}


--------------------------------------------
-- Ìá¹©³¤°´×ó¼ü½øÐÐÁ¬¼ÓµÄ¹¦ÄÜ	-- HenryFour@2010-04-16
local g_AutoClick_BtnFlag = -1			-- ????????????????
local g_AutoClickTimer_Step = 100		-- ????(??)???? Click ??
local g_AutoClick_FunList = {}			-- ????? Timer ?????????????
local g_AutoClick_Going = -1			-- ????????????(???LButton???X?Timer????, ????? g_AutoClickTimer_Step * X ??????????, ?????????????????????)

function SelfEquip_PreLoad()

	-- ´ò¿ª½çÃæ
	this:RegisterEvent("OPEN_EQUIP");

	-- ¹Ø± ½çÃæ
	this:RegisterEvent("CLOSE_EQUIP");	
	
	--Àë¿ª³¡¾°£¬×Ô¶¯¹Ø± 
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	-- ¸üÐÂ×°±¸
	this:RegisterEvent("REFRESH_EQUIP");

	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MAX_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_MAX_MP");
	this:RegisterEvent("UNIT_RAGE");			-- ????


	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_MAX_EXP");
	this:RegisterEvent("UNIT_STR");
	this:RegisterEvent("UNIT_SPR");
	this:RegisterEvent("UNIT_CON");
	this:RegisterEvent("UNIT_INT");
	this:RegisterEvent("UNIT_DEX");
	this:RegisterEvent("UNIT_POINT_REMAIN");
	this:RegisterEvent("UNIT_XIULIAN_STR");
	this:RegisterEvent("UNIT_XIULIAN_SPR");
	this:RegisterEvent("UNIT_XIULIAN_CON");
	this:RegisterEvent("UNIT_XIULIAN_INT");
	this:RegisterEvent("UNIT_XIULIAN_DEX");

	this:RegisterEvent("UNIT_ATT_PHYSICS");
	this:RegisterEvent("UNIT_ATT_MAGIC");
	this:RegisterEvent("UNIT_DEF_PHYSICS");
	this:RegisterEvent("UNIT_DEF_MAGIC");
	this:RegisterEvent("UNIT_HIT");
	this:RegisterEvent("UNIT_MISS");
	this:RegisterEvent("UNIT_CRITICAL_ATTACK");
	this:RegisterEvent("UNIT_CRITICAL_DEFENCE");
	this:RegisterEvent("CUR_TITLE_CHANGED"); 		--??????
	this:RegisterEvent("UNIT_XIULIAN_ATT_PHYSICS");
	this:RegisterEvent("UNIT_XIULIAN_ATT_MAGIC");
	this:RegisterEvent("UNIT_XIULIAN_DEF_PHYSICS");
	this:RegisterEvent("UNIT_XIULIAN_DEF_MAGIC");
	this:RegisterEvent("UNIT_XIULIAN_HIT");
	this:RegisterEvent("UNIT_XIULIAN_MISS");

	this:RegisterEvent("UNIT_DEF_COLD");				--????
	this:RegisterEvent("UNIT_DEF_FIRE");
	this:RegisterEvent("UNIT_DEF_LIGHT");
	this:RegisterEvent("UNIT_DEF_POSION");
	this:RegisterEvent("UNIT_MENPAI");

	this:RegisterEvent("UNIT_ATT_COLD");				--????
	this:RegisterEvent("UNIT_ATT_FIRE");
	this:RegisterEvent("UNIT_ATT_LIGHT");
	this:RegisterEvent("UNIT_ATT_POSION");

	this:RegisterEvent("UNIT_RESISTOTHER_COLD");			--????
	this:RegisterEvent("UNIT_RESISTOTHER_FIRE");
	this:RegisterEvent("UNIT_RESISTOTHER_LIGHT");
	this:RegisterEvent("UNIT_RESISTOTHER_POSION");

	this:RegisterEvent("UNIT_VIGOR");		-- ?????
	this:RegisterEvent("UNIT_ENERGY");	-- ?????
	this:RegisterEvent("UINT_IBPOWER")


	this:RegisterEvent("GUILD_SHOW_MYGUILDNAME"); --??????


	-- ÊÖ¶¯µ÷ ûµãÊý³É¹¦
	this:RegisterEvent("MANUAL_ATTR_SUCCESS_EQUIP");

	this:RegisterEvent("UPDATE_DUR");

	this:RegisterEvent("SEX_CHANGED");

	-- FakeObjectÄ£ÐÍ½çÃæ»¥³â
	this:RegisterEvent("OPEN_SHOP_FITTING");						-- ???????
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING");			-- ???????
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");		-- ???????

	this:RegisterEvent("UPDATE_EXTERIOR_TIP")
	this:RegisterEvent("FINISH_MISSION")	
	this:RegisterEvent("OPEN_DRESSPREVIEW")


end

function SelfEquip_OnLoad()

	-- action buttion °´Å¥
	g_WEAPON   = SelfEquip_11;		--??
	g_ARMOR    = SelfEquip_12;		--??
	g_CAP      = SelfEquip_1;		--??
	g_CUFF     = SelfEquip_4;		--??
	g_BOOT     = SelfEquip_6;		--?
	g_RING     = SelfEquip_7;		--??
	g_SASH     = SelfEquip_5;		--??
	g_NECKLACE = SelfEquip_13;		--??
	g_Dark	   = SelfEquip_14;		--??
	g_RING_2	 = SelfEquip_8;		--??2
	g_CHARM		 = SelfEquip_9;		--??
	g_CHARM_2	 = SelfEquip_10;		--??2
	g_WRIST		 = SelfEquip_3;		--??
	g_SHOULDER = SelfEquip_2;		--??

	g_EquipMask[0]	= SelfEquip_11_Mask;
	g_EquipMask[2]	= SelfEquip_12_Mask;
	g_EquipMask[1]	= SelfEquip_1_Mask;
	g_EquipMask[3]	= SelfEquip_4_Mask;
	g_EquipMask[4]	= SelfEquip_6_Mask;
	g_EquipMask[6]	= SelfEquip_7_Mask;
	g_EquipMask[5]	= SelfEquip_5_Mask;
	g_EquipMask[7]	= SelfEquip_13_Mask;
	g_EquipMask[8]	= SelfEquip_14_Mask;
	g_EquipMask[11]	= SelfEquip_8_Mask;
	g_EquipMask[12]	= SelfEquip_9_Mask;
	g_EquipMask[13]	= SelfEquip_10_Mask;
	g_EquipMask[14]	= SelfEquip_3_Mask;
	g_EquipMask[15]	= SelfEquip_2_Mask;

    g_PropertyTable[1] = SelfEquip_Str_Plus;
    g_PropertyTable[2] = SelfEquip_Nimbus_Plus;
    g_PropertyTable[3] = SelfEquip_PhysicalStrength_Plus;
    g_PropertyTable[4] = SelfEquip_Stability_Plus;
    g_PropertyTable[5] = SelfEquip_Footwork_Plus;
    g_PropertyTable[6] = SelfEquip_Perporty1_Plus;
    g_PropertyTable[7] = SelfEquip_Perporty2_Plus;
    g_PropertyTable[8] = SelfEquip_Perporty3_Plus;
    g_PropertyTable[9] = SelfEquip_Perporty4_Plus;
    g_PropertyTable[10] = SelfEquip_Perporty7_Plus;
    g_PropertyTable[11] = SelfEquip_Perporty6_Plus;

	SELFEQUIP_TAB_TEXT = {
		[0] = "T.B¸",
		"T.Tin",
		"Thú",
		"Khác",
	};

	g_AutoClick_FunList[1] = SelfEquip_Add1_Click
	g_AutoClick_FunList[2] = SelfEquip_Add2_Click
	g_AutoClick_FunList[3] = SelfEquip_Add3_Click
	g_AutoClick_FunList[4] = SelfEquip_Add4_Click
	g_AutoClick_FunList[5] = SelfEquip_Add5_Click
	g_AutoClick_FunList[6] = SelfEquip_Dec1_Click
	g_AutoClick_FunList[7] = SelfEquip_Dec2_Click
	g_AutoClick_FunList[8] = SelfEquip_Dec3_Click
	g_AutoClick_FunList[9] = SelfEquip_Dec4_Click
	g_AutoClick_FunList[10] = SelfEquip_Dec5_Click

	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1

	g_PageButton[1] = SelfEquip_SelfEquip
	g_PageButton[2] = SelfEquip_SelfData
	g_PageButton[3] = SelfEquip_Pet
	g_PageButton[4] = SelfEquip_Wuhun
	g_PageButton[5] = SelfEquip_Xiulian
	g_PageButton[6] = SelfEquip_Talent
	g_PageButton[7] = SelfEquip_Lingyu
	g_PageButton[8] = SelfEquip_Weapon2
	g_PageButton[9] = SelfEquip_DWJinJie
	g_PageButton[10] = SelfEquip_Peak
	g_PageButton[11] = SelfEquip_Profile
	g_PageButton[12] = SelfEquip_OtherInfo
	
	g_PageMask[1] = SelfEquip_SelfEquip_Mask
	g_PageMask[2] = SelfEquip_SelfData_Mask
	g_PageMask[3] = SelfEquip_Pet_Mask
	g_PageMask[4] = SelfEquip_Wuhun_Mask
	g_PageMask[5] = SelfEquip_Xiulian_Mask
	g_PageMask[6] = SelfEquip_Talent_Mask
	g_PageMask[7] = SelfEquip_Lingyu_Mask
	g_PageMask[8] = SelfEquip_Weapon2_Mask
	g_PageMask[9] = SelfEquip_DWJinJie_Mask
	g_PageMask[10] = SelfEquip_Peak_Mask
	g_PageMask[11] = SelfEquip_Profile_Mask
	g_PageMask[12] = SelfEquip_OtherInfo_Mask
	
	g_PageTip[1] = SelfEquip_SelfEquip_tips
	g_PageTip[2] = SelfEquip_SelfData_tips
	g_PageTip[3] = SelfEquip_Pet_tips
	g_PageTip[4] = SelfEquip_Wuhun_tips
	g_PageTip[5] = SelfEquip_Xiulian_tips
	g_PageTip[6] = SelfEquip_Talent_tips
	g_PageTip[7] = SelfEquip_Lingyu_tips
	g_PageTip[8] = SelfEquip_Weapon2_tips
	g_PageTip[9] = SelfEquip_DWJinJie_tips
	g_PageTip[10] = SelfEquip_Peak_tips
	g_PageTip[11] = SelfEquip_Profile_tips
	g_PageTip[12] = SelfEquip_OtherInfo_tips
end

-- OnEvent
function SelfEquip_OnEvent(event)

	-- ÏÔÊ¾tooltip
	SelfEquip_SetStateTooltip();

	-- FakeObjectÄ£ÐÍ½çÃæ»¥³â
	if ( event == "OPEN_SHOP_FITTING" ) or								-- ???????
		 ( event == "OPEN_DRESS_PAINT_FITTING" ) or					-- ???????
		 ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or 
		 ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) or 
		 ( event == "OPEN_DRESSPREVIEW") or --????
		 ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or --??
		 ( event == "OPEN_DRESS_ENCHASE_FITTING" ) then			-- ???????
		if (this:IsVisible()) then
			SelfEquip_CloseUI();
			return
		end
	end

	if ( event == "OPEN_EQUIP" ) then

		if(this:IsVisible()) then
			SelfEquip_Close();
			return;
		end
		SelfEquip_Open()

		SelfEquip_FakeObject:SetFakeObject("Player");
		local selfUnionPos = Variable:GetVariable("SelfUnionPos");
		if(selfUnionPos ~= nil) then
			SelfEquip_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end

		Equip_OnUpdateShow();
		Equip_RefreshEquip();

		--ÔÚ´ò¿ªµÄÊ±ºò£¬½«ÊôÐÔÒ³µÄÈ±Ê¡Ò³½øÐÐµ÷ û
		SelfEquip_SelfEquip:SetCheck(1);
		SelfEquip_SelfData:SetCheck(0);
		SelfEquip_Pet:SetCheck(0);

		-- ÏÔÊ¾¾«Á¦
		SelfEquip_ShowVigor();
		SelfEquip_ShowIBPower()
		-- ÏÔÊ¾»îÁ¦
		SelfEquip_ShowEnergy();
		--SelfEquip_SetTabColor(0);

		SelfEquip_ShowPage()
		SelfEquip_UpdateRedPoint()
	end

	-- ¹Ø± ½çÃæ
	if ( event == "CLOSE_EQUIP" ) then
		if (this:IsVisible()) then
			SelfEquip_CloseUI();
			return
		end
	end
	
	if( event == "PLAYER_LEAVE_WORLD") then
		SelfEquip_Close();
		return;
	end
--[[
	if("CUR_TITLE_CHANGED" == event) then
		GetCurTitle();
		return;
	end

	if(event == "GUILD_SHOW_MYGUILDNAME") then
		GetGuildTitle();
		return;
	end
	--]]
	-- ×°±¸±ä»¯Ê±Ë¢ÐÂ×°±¸.
	if("REFRESH_EQUIP" == event) then

		Equip_RefreshEquip();
		return;
	end

	if("MANUAL_ATTR_SUCCESS_EQUIP" == event) then

		-- ·ÖÅäÊôÐÔ³É¹¦.
		SelfEquip_ManualAttr_Success();

		-- ÉèÖÃÊÖ¶¯µ÷½ÚµãÊý°´Å¥µÄ×´Ì¬.
		SetAcceptButtonState();

		Equip_OnUpdateShow();
		return;
	end

	--ÒÔÏÂÊÂ¼þÏÞÓÚ´°¿Ú´ò¿ªÊ±
	if(this:IsVisible()) then

		local nNumber=0;
		local nMaxnumber=0;
		local strName;
		
		-- µÈ¼¶
		if event == "UNIT_LEVEL" and arg0 == "player" then
			SelfEquip_ShowPage()
			Equip_OnUpdateShow()
		elseif event == "UNIT_MAX_EXP" and arg0 == "player" then
			Equip_OnUpdateShow()
		-- Ñª
		elseif((event == "UNIT_HP" or event == "UNIT_MAX_HP")  and arg0 == "player") then
			nNumber = Player:GetData("HP");
			nMaxnumber = Player:GetData( "MAXHP" );

			local strHpText = tostring( nNumber ).."/"..tostring( nMaxnumber );
			strHpText = "#cFAFFA4"..strHpText;
			SelfEquip_HP:SetText( strHpText );
		-- mana
		elseif((event == "UNIT_MP" or event == "UNIT_MAX_MP")  and arg0 == "player") then
			nNumber = Player:GetData( "MP" );
			nMaxnumber = Player:GetData( "MAXMP" );

			local strMpText = tostring( nNumber ).."/"..tostring( nMaxnumber ) ;
			strMpText = "#cFAFFA4"..strMpText;
			SelfEquip_MP:SetText( strMpText );

		-- Å­Æø
		elseif((event == "UNIT_RAGE" )  and arg0 == "player") then
			-- Å­Æø
		  nNumber = Player:GetData("RAGE");
		  nMaxnumber = Player:GetData("MAXRAGE");

		  local strRageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
		  strRageText = "#cFAFFA4"..strRageText;
			SelfEquip_SP:SetText(strRageText );
		--¾­ÑéÖµ
		elseif(event == "UNIT_EXP" and arg0 == "player") then
			nNumber = Player:GetData("EXP");
			SelfEquip_Exp2:SetText( "#cC8B88E"..tostring( nNumber ) );

			-- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
			g_RequireExperience = Player:GetData("NEEDEXP");
			SelfEquip_Exp1:SetText( "#cC8B88E"..tostring( g_RequireExperience ) );
			SelfData_Exp1_UpdateTips();

			SelfData_LevelUpLock_UpdateTip()--??tip?? ???
			-- ¸ù¾Ý¾­Ñé½ûÖ¹»ò ß´ò¿ªÉý¼¶
			if(nNumber >= g_RequireExperience and tonumber(Player:GetData("LEVEL"))<LEVEL_MAX_ENABLE) then

				SelfEquip_UpLevel:Enable();
			else

				SelfEquip_UpLevel:Disable();
			end


		--STR
		elseif(event == "UNIT_STR" and arg0 == "player") then
			nNumber = Player:GetData("STR");
			SelfEquip_Str:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_STR" and arg0 == "player") then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_STR");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Str_Plus:SetText( StrText );
			else
				SelfEquip_Str_Plus:SetText("");
			end


		--SPR
		elseif(event == "UNIT_SPR" and arg0 == "player") then
			nNumber = Player:GetData("SPR");
			SelfEquip_Nimbus:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_SPR" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_SPR");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Nimbus_Plus:SetText( StrText );
			else
				SelfEquip_Nimbus_Plus:SetText("");
			end

		--CON
		elseif(event == "UNIT_CON" and arg0 == "player") then
			nNumber = Player:GetData("CON");
			SelfEquip_PhysicalStrength:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_CON" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_CON");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_PhysicalStrength_Plus:SetText( StrText );
			else
				SelfEquip_PhysicalStrength_Plus:SetText("");
			end

		--INT
		elseif(event == "UNIT_INT" and arg0 == "player") then
			nNumber = Player:GetData("INT");
			SelfEquip_Stability:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_INT" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_INT");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Stability_Plus:SetText( StrText );
			else
				SelfEquip_Stability_Plus:SetText("");
			end

		--DEX
		elseif(event == "UNIT_DEX" and arg0 == "player") then
			nNumber = Player:GetData("DEX");
			SelfEquip_Footwork:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_DEX" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_DEX");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Footwork_Plus:SetText( StrText );
			else
				SelfEquip_Footwork_Plus:SetText("");
			end
		--POINT_REMAIN
		elseif(event == "UNIT_POINT_REMAIN" and arg0 == "player") then
			-- ÖØÖÃÊôÐÔµãµÄ·ÖÅä
			SelfEquip_ResetCharRemainPoint();

		--ATT_PHYSICS
		elseif(event == "UNIT_ATT_PHYSICS" and arg0 == "player") then
			nNumber = Player:GetData("ATT_PHYSICS");
			SelfEquip_Perporty1:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_ATT_PHYSICS" and arg0 == "player") then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_ATTP");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty1_Plus:SetText( StrText );
			else
				SelfEquip_Perporty1_Plus:SetText("");
			end
		--DEF_PHYSICS
		elseif(event == "UNIT_DEF_PHYSICS" and arg0 == "player") then
			nNumber = Player:GetData("DEF_PHYSICS");
			if nNumber > 999999 then --?????? modified by hukai
				SelfEquip_Perporty3:SetText( "??????" );
			else
				SelfEquip_Perporty3:SetText( tostring( nNumber ) );
			end

		elseif(event == "UNIT_XIULIAN_DEF_PHYSICS" and arg0 == "player") then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_DEFP");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty3_Plus:SetText( StrText );
			else
				SelfEquip_Perporty3_Plus:SetText("");
			end
		--ATT_MAGIC
		elseif(event == "UNIT_ATT_MAGIC" and arg0 == "player") then
			nNumber = Player:GetData("ATT_MAGIC");
			SelfEquip_Perporty2:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_ATT_MAGIC" and arg0 == "player" ) then
		    if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_ATTM");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty2_Plus:SetText( StrText );
			else
				SelfEquip_Perporty2_Plus:SetText("");
			end

		--DEF_MAGIC
		elseif(event == "UNIT_DEF_MAGIC" and arg0 == "player") then
			nNumber = Player:GetData("DEF_MAGIC");
			if nNumber > 999999 then --?????? modified by hukai
				SelfEquip_Perporty4:SetText( "??????" );
			else
				SelfEquip_Perporty4:SetText( tostring( nNumber ) );
			end

		elseif(event == "UNIT_XIULIAN_DEF_MAGIC" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_DEFM");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty4_Plus:SetText( StrText );
			else
				SelfEquip_Perporty4_Plus:SetText("");
			end


		--UNIT_HUIXINFANGYU
--		elseif(event == "UNIT_MISS" and arg0 == "player") then
--			nNumber = Player:GetData("MISS");
--			SelfEquip_Perporty5:SetText( tostring( nNumber ) );

		--UNIT_MISS
		elseif(event == "UNIT_MISS" and arg0 == "player") then
			nNumber = Player:GetData("MISS");
			SelfEquip_Perporty6:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_MISS" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_MISS");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty6_Plus:SetText( StrText );
			else
				SelfEquip_Perporty6_Plus:SetText("");
			end

		--UNIT_HIT
		elseif(event == "UNIT_HIT" and arg0 == "player") then
			nNumber = Player:GetData("HIT");
			SelfEquip_Perporty7:SetText( tostring( nNumber ) );

		elseif(event == "UNIT_XIULIAN_HIT" and arg0 == "player" ) then
			if(Player:GetData("XIULIANFLAG") > 0) then
				nNumber = Player:GetData("XIULIAN_HIT");
				local StrText = "#H+" .. tostring( nNumber );
				SelfEquip_Perporty7_Plus :SetText( StrText );
			else
				SelfEquip_Perporty7_Plus :SetText("");
			end

		--UNIT_CRITICAL_ATTACK
		elseif(event == "UNIT_CRITICAL_ATTACK" and arg0 == "player") then
			nNumber = Player:GetData("CRITICALATTACK");
			SelfEquip_Perporty8:SetText( tostring( nNumber ) );

		--UNIT_CRITICAL_DEFENCE
		elseif(event == "UNIT_CRITICAL_DEFENCE" and arg0 == "player") then
			nNumber = Player:GetData("CRITICALDEFENCE");
			SelfEquip_Perporty9:SetText( tostring( nNumber ) );

		--±ù·ÀÓù
		elseif(event == "UNIT_DEF_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--»ð·ÀÓù
		elseif(event == "UNIT_DEF_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--µç·ÀÓù
		elseif(event == "UNIT_DEF_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¶¾·ÀÓù
		elseif(event == "UNIT_DEF_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õ±ù¿¹
		elseif(event == "UNIT_RESISTOTHER_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õ»ð¿¹
		elseif(event == "UNIT_RESISTOTHER_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õµç¿¹
		elseif(event == "UNIT_RESISTOTHER_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--¼õ¶¾¿¹
		elseif(event == "UNIT_RESISTOTHER_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		--±ù¹¥»÷
		elseif(event == "UNIT_ATT_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--»ð¹¥»÷
		elseif(event == "UNIT_ATT_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--µç¹¥»÷
		elseif(event == "UNIT_ATT_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--¶¾¹¥»÷
		elseif(event == "UNIT_ATT_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();

		elseif(event == "UNIT_VIGOR" and arg0 == "player") then

			SelfEquip_ShowVigor();

		elseif(event == "UINT_IBPOWER" and arg0 == "player") then

			SelfEquip_ShowIBPower();
		elseif(event == "UNIT_ENERGY" and arg0 == "player") then

			SelfEquip_ShowEnergy();
		elseif( event == "UPDATE_DUR" ) then
			SelfEquip_UpdateMask();
		else

			-- ²»ÒªÄ¬ÈÏµÄÇé¿öÏÂµ÷ÓÃ â¸öº¯Êý£¬ »áÔì³ÉÊôÐÔµãÊýÄªÃûÆäÃîµÄË¢ÐÂ¡£
			-- 2006-3-23
			--Equip_OnUpdateShow();
		end

		if event == "SEX_CHANGED"  then
			SelfEquip_FakeObject : Hide();
			SelfEquip_FakeObject : Show();
			SelfEquip_FakeObject:SetFakeObject("Player");
		end
		
		if event == "UPDATE_EXTERIOR_TIP" then
			SelfEquip_Exterior_Tips()
		end
		
		return;
	end

	-- ÆäËüÊÂ¼þ¶¼¸üÐÂÈËÎïµÄ»ù±¾ÐÅÏ¢.
	--Equip_OnUpdateShow();
	
	if event == "FINISH_MISSION" and this:IsVisible() == 1 then
		SelfEquip_ShowPage()
	end

end

-- ¸üÐÂÖ÷½Ç»ù±¾ÐÅÏ¢
function Equip_OnUpdateShow()



	g_RemainPoint 			= 0;	-- ????
	g_CurExperience 	  = 0;	-- ??????
	g_RequireExperience = 0;  -- ??????

	g_AddStr = 0;					-- ???????????.
	g_AddSpr = 0;					-- ???????????.
	g_AddCon = 0;					-- ???????????.
	g_AddInt = 0;					-- ???????????.
	g_AddDex = 0;					-- ???????????.
	g_CurRemainPoint = 0;	-- ????????


	local nNumber=0;
	local nMaxnumber=0;
	local strName;

	-- ½ûÖ¹Ôö¼ÓÇ±ÄÜ°´Å¥.
	Equip_Addition_Button1:Disable();
	Equip_Decrease_Button1:Disable();

	Equip_Addition_Button2:Disable();
	Equip_Decrease_Button2:Disable();

	Equip_Addition_Button3:Disable();
	Equip_Decrease_Button3:Disable();

	Equip_Addition_Button4:Disable();
	Equip_Decrease_Button4:Disable();

	Equip_Addition_Button5:Disable();
	Equip_Decrease_Button5:Disable();

	-- ÔÊÐí°´Å¥
	-- SelfEquip_Accept:Enalbe();

	-- ½ûÖ¹Ôö¼Ó°´Å¥
	-- SelfEquip_Accept:Disable();

	-- µÃµ½×Ô¼ºµÄÃû×Ö
	strName = Player:GetName();
	SelfEquip_PageHeader:SetText("#gFF0FA0".. strName );

	-- µÃµ½ÑªÖµ
	nNumber = Player:GetData("HP");
	nMaxnumber = Player:GetData( "MAXHP" );
	local HPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	HPText = "#cFAFFA4"..HPText;
	SelfEquip_HP:SetText( HPText );


	-- µÃµ½Ä§·¨Öµ
	nNumber = Player:GetData( "MP" );
	nMaxnumber = Player:GetData( "MAXMP" );

	local MPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	MPText = "#cFAFFA4"..MPText;
	SelfEquip_MP:SetText( MPText );

	-- Å­Æø
  nNumber = Player:GetData("RAGE");
  nMaxnumber = Player:GetData("MAXRAGE");
  local RageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
  RageText = "#cFAFFA4"..RageText;
 	SelfEquip_SP:SetText( RageText );

	-- µÃµ½µ±Ç°¾­Ñé
	g_CurExperience = Player:GetData("EXP");
	local CurExpText = tostring( g_CurExperience );
	CurExpText = "#cC8B88E"..CurExpText;
	SelfEquip_Exp2:SetText( CurExpText );

	-- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
	g_RequireExperience = Player:GetData("NEEDEXP");
	local NeedExpText =  tostring( g_RequireExperience );
	NeedExpText = "#cC8B88E"..NeedExpText;
	SelfEquip_Exp1:SetText( NeedExpText );
	SelfData_Exp1_UpdateTips();

	SelfData_LevelUpLock_UpdateTip()--??tip?? ???
	-- ¸ù¾Ý¾­Ñé½ûÖ¹»ò ß´ò¿ªÉý¼¶
	if(g_CurExperience >= g_RequireExperience) then

		SelfEquip_UpLevel:Enable();
	else

		SelfEquip_UpLevel:Disable();
	end

	-- µÃµ½µÈ¼¶
	nNumber = Player:GetData( "LEVEL" );
	local LevelText = tostring( nNumber ).."  c¤p";
	LevelText = "#cC8B88E"..LevelText;
	SelfEquip_Level:SetText( LevelText );

	-- Èç¹ûµÈ¼¶´óÓÚÄ³Öµ½ûÖ¹°´Å¥.
	if( LEVEL_MAX_ENABLE <= nNumber ) then
		SelfEquip_UpLevel:Disable();
	end

  -- Á¦Á¿
  nNumber = Player:GetData("STR");
  local StrText = tostring( nNumber );
  --StrText = "#DED784"..StrText;
	SelfEquip_Str:SetText( StrText );

	-- ÁéÆø
  nNumber = Player:GetData("SPR");
  local SprText = tostring( nNumber );
  --SprText = "#DED784"..SprText;
	SelfEquip_Nimbus:SetText( SprText );

	-- ÌåÖÊ
	nNumber = Player:GetData("CON");
	local ConText = tostring( nNumber );
	SelfEquip_PhysicalStrength:SetText( ConText );


	-- ¶¨Á¦
	nNumber = Player:GetData("INT");
	SelfEquip_Stability:SetText( tostring( nNumber ) );

	-- Éí·¨
	nNumber = Player:GetData("DEX");
	SelfEquip_Footwork:SetText( tostring( nNumber ) );

	-- Ê£ÓàµãÊý
	g_RemainPoint = Player:GetData("POINT_REMAIN");
	SelfEquip_Potential:SetText( tostring( g_RemainPoint ) );
	g_CurRemainPoint = g_RemainPoint;

	if(g_CurRemainPoint > 0) then

		Equip_Addition_Button1:Enable();
		Equip_Addition_Button2:Enable();
		Equip_Addition_Button3:Enable();
		Equip_Addition_Button4:Enable();
		Equip_Addition_Button5:Enable();

	end;


	-- ÎïÀí¹¥»÷
	nNumber = Player:GetData("ATT_PHYSICS");
	SelfEquip_Perporty1:SetText( tostring( nNumber ) );

	-- ÎïÀí·ÀÓù
	nNumber = Player:GetData("DEF_PHYSICS");
	if nNumber > 999999 then --?????? modified by hukai
		SelfEquip_Perporty3:SetText( "??????" );
	else
		SelfEquip_Perporty3:SetText( tostring( nNumber ) );
	end

	-- Ä§·¨¹¥»÷
	nNumber = Player:GetData("ATT_MAGIC");
	SelfEquip_Perporty2:SetText( tostring( nNumber ) );

	-- Ä§·¨·ÀÓù
	nNumber = Player:GetData("DEF_MAGIC");
	if nNumber > 999999 then --?????? modified by hukai
		SelfEquip_Perporty4:SetText( "??????" );
	else
		SelfEquip_Perporty4:SetText( tostring( nNumber ) );
	end

	-- ÉÁ±ÜÂÊ
	nNumber = Player:GetData("MISS");
	SelfEquip_Perporty6:SetText( tostring( nNumber ) );

	-- ÃüÖÐÂÊ
	nNumber = Player:GetData("HIT");
	SelfEquip_Perporty7:SetText( tostring( nNumber ) );

	--zhangqiang£¬ÐÞÁ¶ÊôÐÔ¼Ó³É==============================
	if Player:GetData("XIULIANFLAG") > 0 then
		nNumber = Player:GetData("XIULIAN_STR");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Str_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_SPR");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Nimbus_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_CON");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_PhysicalStrength_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_INT");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Stability_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_DEX");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Footwork_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_HIT");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty7_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_ATTP");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty1_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_DEFP");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty3_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_ATTM");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty2_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_DEFM");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty4_Plus:SetText( StrText );

		nNumber = Player:GetData("XIULIAN_MISS");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty6_Plus:SetText( StrText );
	else
		SelfEquip_Str_Plus:SetText( "" );
		SelfEquip_Nimbus_Plus:SetText( "" );
		SelfEquip_PhysicalStrength_Plus:SetText( "" );
		SelfEquip_Stability_Plus:SetText( "" );
		SelfEquip_Footwork_Plus:SetText( "" );
		SelfEquip_Perporty7_Plus:SetText( "" );
		SelfEquip_Perporty1_Plus:SetText( "" );
		SelfEquip_Perporty3_Plus:SetText( "" );
		SelfEquip_Perporty2_Plus:SetText( "" );
		SelfEquip_Perporty4_Plus:SetText( "" );
		SelfEquip_Perporty6_Plus:SetText( "" );
	end
	--=======================================================

	-- »áÐÄ¹¥»÷
	nNumber = Player:GetData("CRITICALATTACK");
	SelfEquip_Perporty8:SetText( tostring( nNumber ) );

	SelfEquip_Perporty8_Plus:SetText( "" );

	-- »áÐÄ·ÀÓù
	nNumber = Player:GetData("CRITICALDEFENCE");
	SelfEquip_Perporty9:SetText( tostring( nNumber ) );

	SelfEquip_Perporty9_Plus:SetText( "" );

	-- »îÁ¦
	SelfEquip_ShowVigor();

	-- ¾«Á¦
	SelfEquip_ShowEnergy();

	-- ÃÅÅÉ
	local menpai = Player:GetData("MEMPAI");
	local strName = "";

	SelfEquip_PeakLevel:SetText(ScriptGlobal_Format("#{DFJC_250709_67}",GetDFengLevel()))
	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == menpai) then
		strName = "Thiªu Lâm";

	elseif(1 == menpai) then
		strName = "Minh Giáo";

	elseif(2 == menpai) then
		strName = "Cái Bang";

	elseif(3 == menpai) then
		strName = "Võ Ðang";

	elseif(4 == menpai) then
		strName = "Nga Mi";

	elseif(5 == menpai) then
		strName = "Tinh Túc";

	elseif(6 == menpai) then
		strName = "Thiên Long";

	elseif(7 == menpai) then
		strName = "Thiên S½n";

	elseif(8 == menpai) then
		strName = "Tiêu Dao";

	elseif(9 == menpai) then
		strName = "Tñ do";

	elseif(10== menpai) then
		strName = "Mµ Dung";
	end
	
	local secttype = DataPool:GetSectType()
	if secttype < 0 then
	-- ÉèÖÃÏÔÊ¾µÄÃÅÅÉ.
		SelfEquip_MenPai:SetText(strName);

	else
		if menpai == 9 then
			SelfEquip_MenPai:SetText(strName);
		else
			if menpai == 10 then
				strName = "MÕn Ðà";
			end
			local sectname = DataPool:Lua_GetSectName(menpai,secttype)
			SelfEquip_MenPai:SetText(strName.."·"..sectname);
		end

	end

	-- ÉèÖÃ°ï»áÏÔÊ¾
--	GetGuildTitle();

	-- µÃµ½³ÆºÅ
--	GetCurTitle();

	-- ÉèÖÃÊÖ¶¯µ÷½ÚµãÊý°´Å¥µÄ×´Ì¬.
	SetAcceptButtonState();

end

-- Ë¢ÐÂ×°±¸
function Equip_RefreshEquip()


	--  Çå¿ °´Å¥ÏÔÊ¾Í¼±ê
	g_WEAPON:SetActionItem(-1);			--??
	g_CAP:SetActionItem(-1);				--??
	g_ARMOR:SetActionItem(-1);			--??
	g_CUFF:SetActionItem(-1);				--??
	g_BOOT:SetActionItem(-1);				--?
	g_SASH:SetActionItem(-1);				--??
	g_RING:SetActionItem(-1);				--??
	g_NECKLACE:SetActionItem(-1);		--??
	g_Dark:SetActionItem(-1);			--??
	g_RING_2:SetActionItem(-1);			--??2
	g_CHARM:SetActionItem(-1);			--??
	g_CHARM_2:SetActionItem(-1);		--??2
	g_WRIST:SetActionItem(-1);			--??
	g_SHOULDER:SetActionItem(-1);		--??
	SelfEquip_15:SetActionItem(-1)
	
	local ActionWeapon 		= EnumAction(0, "equip");
	local ActionCap    		= EnumAction(1, "equip");
	local ActionArmor  		= EnumAction(2, "equip");
	local ActionCuff   		= EnumAction(3, "equip");
	local ActionBoot   		= EnumAction(4, "equip");
	local ActionSash   		= EnumAction(5, "equip");
	local ActionRing    	= EnumAction(6, "equip");
	local ActionNecklace	= EnumAction(7, "equip");
	local ActionMount			= EnumAction(17, "equip");
	local ActionRing_2		= EnumAction(11, "equip");
	local ActionCharm 		= EnumAction(12, "equip");
	local ActionCharm_2   = EnumAction(13, "equip");
	local ActionWrist  		= EnumAction(14, "equip");
	local ActionShoulder  = EnumAction(15, "equip");

	-- ÏÔÊ¾ÈËÉíÉÏµÄÎäÆ÷×°±¸
	g_WEAPON:SetActionItem(ActionWeapon:GetID());			--??
	g_CAP:SetActionItem(ActionCap:GetID());						--??
	g_ARMOR:SetActionItem(ActionArmor:GetID());				--??
	g_CUFF:SetActionItem(ActionCuff:GetID());					--??
	g_BOOT:SetActionItem(ActionBoot:GetID());					--?
	g_SASH:SetActionItem(ActionSash:GetID());					--??
	g_RING:SetActionItem(ActionRing:GetID());					--??
	g_NECKLACE:SetActionItem(ActionNecklace:GetID());	--??
	g_Dark:SetActionItem(ActionMount:GetID());				--??
	g_RING_2:SetActionItem(ActionRing_2:GetID());			--??2
	g_CHARM:SetActionItem(ActionCharm:GetID());			--??
	g_CHARM_2:SetActionItem(ActionCharm_2:GetID());		--??2
	g_WRIST:SetActionItem(ActionWrist:GetID());			--??
	g_SHOULDER:SetActionItem(ActionShoulder:GetID());		--??
	
	local ActionSB  = EnumAction(37, "equip")
	SelfEquip_15:SetActionItem(ActionSB:GetID())
	
	SelfEquip_UpdateMask();
end

function SelfEquip_Equip_Click( nTypeIn,buttonIn )

	local nType = tonumber( nTypeIn );
	local button = tonumber( buttonIn );
	if( nType == 11 ) then
		if( button == 1 ) then
			g_WEAPON:DoAction();	--??
		else
			g_WEAPON:DoSubAction();	--??
		end
	elseif( nType == 12 ) then
		if( button == 1 ) then
			g_ARMOR:DoAction();	--??
		else
			g_ARMOR:DoSubAction();	--??
		end
	elseif( nType == 1 ) then
		if( button == 1 ) then
			g_CAP:DoAction();	--??
		else
			g_CAP:DoSubAction();	--??
		end
	elseif( nType == 4 ) then
		if( button == 1 ) then
			g_CUFF:DoAction();	--??
		else
			g_CUFF:DoSubAction();	--??
		end
	elseif( nType == 6 ) then
		if( button == 1 ) then
			g_BOOT:DoAction();	--?
		else
			g_BOOT:DoSubAction();	--?
		end
	elseif( nType == 7 ) then
		if( button == 1 ) then
			g_RING:DoAction();	--??
		else
			g_RING:DoSubAction();	--??
		end
	elseif( nType == 5 ) then
		if( button == 1 ) then
			g_SASH:DoAction();	--??
		else
			g_SASH:DoSubAction();	--??
		end
	elseif( nType == 13) then
		if( button == 1 ) then
			g_NECKLACE:DoAction();	--??
		else
			g_NECKLACE:DoSubAction();	--??
		end
	elseif( nType == 14 ) then
		if( button == 1 ) then
			g_Dark:DoAction();	--??
		else
			g_Dark:DoSubAction();	--??
		end
	elseif( nType == 2 ) then
		if( button == 1 ) then
			g_SHOULDER:DoAction();	--??
		else
			g_SHOULDER:DoSubAction();	--??
		end
	elseif( nType == 3 ) then
		if( button == 1 ) then
			g_WRIST:DoAction();	--??
		else
			g_WRIST:DoSubAction();	--??
		end
	elseif( nType == 8 ) then
		if( button == 1 ) then
			g_RING_2:DoAction();	--??2
		else
			g_RING_2:DoSubAction();	--??
		end
	elseif( nType == 9 ) then
		if( button == 1 ) then
			g_CHARM:DoAction();	--??
		else
			g_CHARM:DoSubAction();	--??
		end
	elseif( nType == 10 ) then
		if( button == 1 ) then
			g_CHARM_2:DoAction();	--??2
		else
			g_CHARM_2:DoSubAction();	--??2
		end
	elseif nType == 15 then
		if button == 1 then
			SelfEquip_15:DoAction()	--??
		else
			SelfEquip_15:DoSubAction()	--??
		end
	end
end


----------------------------------------------------------------------------
-- Á¦Á¿µãÊý°´Å¥
--
-- ¼õÉÙÁ¦Á¿µãÊý°´Å¥
function SelfEquip_Dec1_Click()

	if (g_AddStr > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end;

		g_AddStr = g_AddStr - 1;
	end

	if(g_AddStr <= 0) then
		g_AddStr = 0;
		Equip_Decrease_Button1:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Á¦Á¿
	ShowCurStr();

end

-- Ôö¼ÓÁ¦Á¿µãÊý°´Å¥
function SelfEquip_Add1_Click()

	if (g_CurRemainPoint > 0) then
		g_AddStr = g_AddStr + 1;
		if(g_AddStr > 0) then
			Equip_Decrease_Button1:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Á¦Á¿
	ShowCurStr();

end


-----------------------------------------------------------------------------
-- ÁéÆøµãÊý°´Å¥
--
-- ¼õÉÙÁéÆøµãÊý°´Å¥
function SelfEquip_Dec2_Click()

	if (g_AddSpr > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddSpr = g_AddSpr - 1;
	end

	if(g_AddSpr <= 0) then

		g_AddSpr = 0;
		Equip_Decrease_Button2:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÁéÆø
	ShowCurSpr();

end

-- Ôö¼ÓÁéÆøµãÊý°´Å¥
function SelfEquip_Add2_Click()

	if (g_CurRemainPoint > 0) then
		g_AddSpr = g_AddSpr + 1;
		if(g_AddSpr > 0) then
			Equip_Decrease_Button2:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÁéÆø
	ShowCurSpr();

end


-----------------------------------------------------------------------------
-- ÌåÖÊµãÊý°´Å¥
--
-- ¼õÉÙÌåÖÊµãÊý°´Å¥
function SelfEquip_Dec3_Click()

	if (g_AddCon > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddCon = g_AddCon - 1;
	end

	if(g_AddCon <= 0) then

		g_AddCon = 0;
		Equip_Decrease_Button3:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÌåÖÊ
	ShowCurCon();


end

-- Ôö¼ÓÌåÖÊµãÊý°´Å¥
function SelfEquip_Add3_Click()

	if (g_CurRemainPoint > 0) then
		g_AddCon = g_AddCon + 1;
		if(g_AddCon > 0) then
			Equip_Decrease_Button3:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾ÌåÖÊ
	ShowCurCon();

end


-------------------------------------------------------------------------------
-- ¶¨Á¦µãÊý°´Å¥
--
-- ¼õÉÙ¶¨Á¦µãÊý°´Å¥
function SelfEquip_Dec4_Click()

	if (g_AddInt > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddInt = g_AddInt - 1;
	end

	if(g_AddInt <= 0) then

		g_AddInt = 0;
		Equip_Decrease_Button4:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾¶¨Á¦
	ShowCurInt();

end

-- Ôö¼Ó¶¨Á¦µãÊý°´Å¥
function SelfEquip_Add4_Click()

	if (g_CurRemainPoint > 0) then
		g_AddInt = g_AddInt + 1;
		if(g_AddInt > 0) then
			Equip_Decrease_Button4:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then

		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾¶¨Á¦
	ShowCurInt();

end



--------------------------------------------------------------------------------
-- Éí·¨µãÊý°´Å¥
--
-- ¼õÉÙÉí·¨µãÊý°´Å¥
function SelfEquip_Dec5_Click()

	if (g_AddDex > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddDex = g_AddDex - 1;
	end

	if(g_AddDex <= 0) then

		g_AddDex = 0;
		Equip_Decrease_Button5:Disable();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Éí·¨
	ShowCurDex();

end

-- Ôö¼ÓÉí·¨µãÊý°´Å¥
function SelfEquip_Add5_Click()

	if (g_CurRemainPoint > 0) then
		g_AddDex = g_AddDex + 1;
		if(g_AddDex > 0) then
			Equip_Decrease_Button5:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then

		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end

	-- ÏÔÊ¾µ±Ç°Ê£ÓàµÄµãÊý
	ShowCurRemainPoint();

	-- ÉèÖÃÊ£ÓàµãÊý°´Å¥×´Ì¬
	SetAcceptButtonState();

	-- ÏÔÊ¾Éí·¨
	ShowCurDex();

end

--------------------------------------------------------------------------------
--
-- ´ò¿ªËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function EanbleAskAttrBn(bEnable)

	Equip_Addition_Button1:Enable();
	Equip_Addition_Button2:Enable();
	Equip_Addition_Button3:Enable();
	Equip_Addition_Button4:Enable();
	Equip_Addition_Button5:Enable();
end

--------------------------------------------------------------------------------
--
-- ´ò¿ªËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function EanblePointAddButtion()

	Equip_Addition_Button1:Enable();
	Equip_Addition_Button2:Enable();
	Equip_Addition_Button3:Enable();
	Equip_Addition_Button4:Enable();
	Equip_Addition_Button5:Enable();
end


--------------------------------------------------------------------------------
--
-- ½ûÖ¹ËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function DisablePointAddButtion()

	Equip_Addition_Button1:Disable();
	Equip_Addition_Button2:Disable();
	Equip_Addition_Button3:Disable();
	Equip_Addition_Button4:Disable();
	Equip_Addition_Button5:Disable();
end


--------------------------------------------------------------------------------
--
-- ´ò¿ªËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function EanblePointDecButtion()

	Equip_Decrease_Button1:Enable();
	Equip_Decrease_Button2:Enable();
	Equip_Decrease_Button3:Enable();
	Equip_Decrease_Button4:Enable();
	Equip_Decrease_Button5:Enable();
end


--------------------------------------------------------------------------------
--
-- ½ûÖ¹ËùÓÐµÄµãÊýÔö¼Ó°´Å¥
--
function DisablePointDecButtion()

	Equip_Decrease_Button1:Disable();
	Equip_Decrease_Button2:Disable();
	Equip_Decrease_Button3:Disable();
	Equip_Decrease_Button4:Disable();
	Equip_Decrease_Button5:Disable();
end


---------------------------------------------------------------------------------
--
-- ÏÔÊ¾µ±Ç°µÄÇ±ÄÜ
--
function ShowCurRemainPoint()

	SelfEquip_Potential:SetText( tostring( g_CurRemainPoint ) );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾Á¦Á¿
--
function ShowCurStr()

	SelfEquip_Str:SetText( tostring( g_AddStr + Player:GetData("STR") ) );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾ÁéÆø
--
function ShowCurSpr()

	SelfEquip_Nimbus:SetText( tostring( g_AddSpr + Player:GetData("SPR"))  );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾ÌåÖÊ
--
function ShowCurCon()

	SelfEquip_PhysicalStrength:SetText( tostring( g_AddCon + Player:GetData("CON"))  );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾¶¨Á¦
--
function ShowCurInt()

	SelfEquip_Stability:SetText( tostring( g_AddInt + Player:GetData("INT"))  );

end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾Éí·¨
--
function ShowCurDex()

	SelfEquip_Footwork:SetText( tostring( g_AddDex + Player:GetData("DEX"))  );

end



---------------------------------------------------------------------------------
--
-- ½ûÖ¹, ´ò¿ªÉêÇëÇ±ÄÜ°´Å¥Ç±ÄÜ°´Å¥
--
function SetAcceptButtonState()

	if(g_CurRemainPoint == g_RemainPoint) then

		SelfEquip_Accept:Disable();
	else

		SelfEquip_Accept:Enable();
	end;

end

---------------------------------------------------------------------------------
--
-- ÉêÇëÔö¼ÓÇ±ÄÜ
--
function SelfEquip_Accept_Click()

	-- ·¢ËÍ¸ü¸ÄÊôÐÔÇëÇó.
	Player:SendAskManualAttr(g_AddStr, g_AddSpr, g_AddCon, g_AddInt, g_AddDex);

	-- ²âÊÔÊ¹ÓÃ, Ïò·þÎñÆ÷Òª×°±¸µÄÏêÏ¸ÐÅÏ¢
	--AskEquipDetial();

end


---------------------------------------------------------------------------------
--
-- ÊÖ¶¯µ÷ û³É¹¦
--
function SelfEquip_ManualAttr_Success()

	g_AddStr = 0;					-- ???????????.
	g_AddSpr = 0;					-- ???????????.
	g_AddCon = 0;					-- ???????????.
	g_AddInt = 0;					-- ???????????.
	g_AddDex = 0;					-- ???????????.

	-- ½ûÖ¹ËùÓÐ¼õÉÙµãÊý°´Å¥
	DisablePointDecButtion();

	-- Ê£ÓàÃ»ÓÐ·ÖÅäµÄµãÊý
	g_RemainPoint = g_CurRemainPoint;
	if(g_CurRemainPoint > 0) then

		EanblePointAddButtion();
	end


end

---------------------------------------------------------------------------------
--
-- µã»÷³ÆºÅ°´Å¥
--
function TitleButton_Click()

	g_bOpenTitleDlg = 1;
	-- ´ò¿ª³ÆºÅ½çÃæ
	OpenTitleList();

end

----------------------------------------------------------------------------------
--
-- µã»÷°ï»á°´Å¥
--
function OpenConfraternity_click()

	-- ´ò¿ª»ò¹Ø± °ï»á½çÃæ
	Guild:ToggleGuildDetailInfo();
end


----------------------------------------------------------------------------------
--
-- µÃµ½µ±Ç°µÄtitle
--
--[[
function GetCurTitle()

	-- µÃµ½µ±Ç°µÄ³ÆºÅ.
	local strCurTitle = Player:GetCurTitle();
	SelfEquip_Agname:SetText(strCurTitle);

end

function GetGuildTitle()
	local szGuildName = Guild:GetMyGuildInfo("Name");
	if(nil ~= szGuildName and "" ~= szGuildName) then
		SelfEquip_Confraternity:SetText(szGuildName);
	else
		SelfEquip_Confraternity:SetText("");
	end
end
--]]
----------------------------------------------------------------------------------
--
-- Ñ¡×°Íæ¼ÒÄ£ÐÍ£¨Ïò×ó)
--
function SelfEquip_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SelfEquip_FakeObject:RotateBegin(-0.3);
	--Ïò×óÐý×ª½áÊø
	else
		SelfEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- Ñ¡×°Íæ¼ÒÄ£ÐÍ£¨ÏòÓÒ)
--
function SelfEquip_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SelfEquip_FakeObject:RotateBegin(0.3);
	--ÏòÓÒÐý×ª½áÊø
	else
		SelfEquip_FakeObject:RotateEnd();
	end
end

---------------------------------------------------------------------------------
--
-- ÉèÖÃ×´Ì¬tooltip
--
function SelfEquip_SetStateTooltip()


	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceDefine  		= Player:GetData( "DEFENCECOLD" );
	local iFireDefine 		= Player:GetData( "DEFENCEFIRE" );
	local iThunderDefine	= Player:GetData( "DEFENCELIGHT" );
	local iPoisonDefine		= Player:GetData( "DEFENCEPOISON" );

	--²»ÏÔÊ¾¸º¿¹ÐÔ
	if iIceDefine < 0 then
		iIceDefine = 0
	end
	if iFireDefine < 0 then
		iFireDefine = 0
	end
	if iThunderDefine < 0 then
		iThunderDefine = 0
	end
	if iPoisonDefine < 0 then
		iPoisonDefine = 0
	end

	local iIceAttack  		= Player:GetData( "ATTACKCOLD" );
	local iFireAttack 		= Player:GetData( "ATTACKFIRE" );
	local iThunderAttack	= Player:GetData( "ATTACKLIGHT" );
	local iPoisonAttack		= Player:GetData( "ATTACKPOISON" );

	local iIceResistOther	= Player:GetData( "RESISTOTHERCOLD" );
	local iFireResistOther= Player:GetData( "RESISTOTHERFIRE" );
	local iThunderResistOther	= Player:GetData( "RESISTOTHERLIGHT" );
	local iPoisonResistOther= Player:GetData( "RESISTOTHERPOISON" );

	local iIceResistLimit = Player:GetData("SUBRESISTLIMITCOLD")
	local iFireResistLimit = Player:GetData("SUBRESISTLIMITFIRE")
	local iThunderResistLimit = Player:GetData("SUBRESISTLIMITLIGHT")
	local iPoisonResistLimit = Player:GetData("SUBRESISTLIMITPOISON")
	
	SelfEquip_IceFastness:SetToolTip("Bång công:"..tostring(iIceAttack).."#rKháng Bång:"..tostring(iIceDefine).."#rGiäm kháng Bång: "..tostring(iIceResistOther).."#{JKXX_091228_1}"..tostring(iIceResistLimit) );
	SelfEquip_FireFastness:SetToolTip("Höa công:"..tostring(iFireAttack).."#rKháng Höa: "..tostring(iFireDefine).."#rGiäm kháng Höa: "..tostring(iFireResistOther).."#{JKXX_091228_2}"..tostring(iFireResistLimit) );
	SelfEquip_ThunderFastness:SetToolTip("Huy«n công:"..tostring(iThunderAttack).."#rKháng Huy«n:"..tostring(iThunderDefine).."#rGiäm kháng Huy«n: "..tostring(iThunderResistOther).."#{JKXX_091228_3}"..tostring(iThunderResistLimit) );
	SelfEquip_PoisonFastness:SetToolTip("Ðµc công:"..tostring(iPoisonAttack).."#rKháng Ðµc:"..tostring(iPoisonDefine).."#rGiäm kháng Ðµc: "..tostring(iPoisonResistOther).."#{JKXX_091228_4}"..tostring(iPoisonResistLimit) );

end


---------------------------------------------------------------------------------
--
-- ÏÔÊ¾»îÁ¦
--
function SelfEquip_ShowVigor()
	--

	local iVigor = Player:GetData("VIGOR");
	local iVigorMax = Player:GetData("MAXVIGOR");
	local VigorText = tostring(iVigor).."/"..tostring(iVigorMax);
	SelfEquip_Vigor:SetText( VigorText );

end

--
function SelfEquip_ShowIBPower()
	local iIBPower = Player:GetData("IBPOWER")
	local iIBPowerMax = Player:GetData("MAXIBPOWER")
	local ibPowerText = tostring(iIBPower).."/"..tostring(iIBPowerMax)
	SelfEquip_Energy2:SetText( ibPowerText )
end

---------------------------------------------------------------------------------
--
-- ÏÔÊ¾»îÁ¦
--
function SelfEquip_ShowEnergy()
	--

	local iEnergy 	 = Player:GetData("ENERGY");
	local iEnergyMax = Player:GetData("MAXENERGY");
	local EnergyText = tostring(iEnergy).."/"..tostring(iEnergyMax);
	SelfEquip_Energy:SetText(EnergyText);


end


----------------------------------------------------------------------------------------
--
-- ¹Ø± ½çÃæ
--

function SelfEquip_CloseUI()

	-- ´ò¿ª»ò ß¹Ø± ³ÆºÅ½çÃæ
	CloseTitleList()
	SelfEquip_FakeObject:SetFakeObject("")
	SelfEquip_Close()

end


function SelfEquip_Page_Pet()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	TogglePetPage();
	--SelfEquip_SetTabColor(0);
end

--´ò¿ª×Ô¼ºµÄ×ÊÁÏÒ³Ãæ
function SelfEquip_Page_SelfData()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");

end

function SelfEquip_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end

	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = SelfEquip_SelfEquip,
								SelfEquip_SelfData,
								SelfEquip_Pet,
								SelfEquip_OtherInfo,
							};

	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..SELFEQUIP_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..SELFEQUIP_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function SelfEquip_Page_XiuLian()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		SelfEquip_Xiulian : SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	local nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
		--SelfEquip_SetTabColor(0);
	else
		SelfEquip_Xiulian : SetCheck(0)
		PushDebugMessage("#{XL_090707_62}")
		SelfEquip_ClearPage()
	end
end

function SelfEquip_Page_OtherInfo()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
    UpdateDoubleExpData();

end

function SelfEquip_UpdateMask()	
	for i = 0, 15 do
		if i ~= 9 and i ~=10 then
			SelfEquip_UpdateMaskByIndex(i)
		end
	end
	
	SelfEquip_15_Mask:Hide()
	local ActionSB = EnumAction(37, "equip")
	if ActionSB:GetEquipDur() < 0.1 then
		SelfEquip_15_Mask:Show()
	end
end

function SelfEquip_UpdateMaskByIndex(index)
	local ActionIndex = EnumAction(index, "equip")
	if ActionIndex:GetEquipDur() < 0.1 then
		g_EquipMask[index]:Show();
	else
		g_EquipMask[index]:Hide()
	end
end

-- function SelfEquip_OpenBlog()
-- 	local strCharName =  Player:GetName();
-- 	local strAccount =  Player:GetData("ACCOUNTNAME")
-- 	Blog:OpenBlogPage(strAccount,strCharName,true);
-- end


function SelfEquip_Open()
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	SetTimer("SelfEquip", "SelfEquip_AutoClick_Timer()", g_AutoClickTimer_Step)
 
	local is69kaji = Player : GetData("69KAJI") 
	if is69kaji == 1 then
		LEVEL_MAX_ENABLE = 69 
	end

	local is89kaji = Player : GetData("89KAJI") 
	if is89kaji == 1 then
		LEVEL_MAX_ENABLE = 89 
	end

	this:Show();
	SelfEquip_Exterior_Tips()
	local isopen6 = T300Func:IsNoDifOpen(6)
	local isopen5 = T300Func:IsNoDifOpen(5)
	if isopen5 == 1 then
		--SelfEquip_Wuhun:Disable()
	else
		SelfEquip_Wuhun:Enable()
	end
	if isopen6 == 1 then
		--SelfEquip_Xiulian:Disable()
	else
		SelfEquip_Xiulian:Enable()
	end
	
end

function SelfEquip_Close()	
	LEVEL_MAX_ENABLE = 119
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	KillTimer("SelfEquip_AutoClick_Timer()")
	this:Hide();
end

function SelfEquip_AskLevelup()
    local PlayerLevel = Player:GetData( "LEVEL" )
    local EvaluateLevelList = { 30, 45, 65, 75, 85 }

    local strMasterName = GetMasterName()

    if "" ~= strMasterName then   --??????????????????,?????
        local ListSize = table.getn( EvaluateLevelList )
		for i = 1, ListSize do
			if EvaluateLevelList[ i ] == ( PlayerLevel+1 ) and PlayerLevel < 45 then
				--´ò¿ªÆÀ¼Û½çÃæ

				AskEvaluateAndLevelup()
				return
			end
		end
    end

    AskLevelUp( tonumber(0) )

end

--ÏÔÊ¾Îä»êUI
function SelfEquip_Page_Wuhun()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		SelfEquip_Wuhun : SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
	--SelfEquip_SetTabColor(0);
end


function SelfEquip_Page_Talent()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1)
		ToggleTalentPage()
		--SelfEquip_SetTabColor(0)
	else
		SelfEquip_Talent:SetCheck(0)
		SelfEquip_ClearPage()
	end
end

--ÇÐ»»¸öÈË ¹Ê¾½çÃæ
function SelfEquip_Profile_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);	
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

function SelfEquip_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		SelfEquip_Lingyu:SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function SelfEquip_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		SelfEquip_Weapon2:SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function SelfEquip_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		SelfEquip_DWJinJie:SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

function SelfEquip_ShowTooltip(Subject)
	if (g_PropertyTable[Subject] ~= nil) then
		if g_PropertyTable[Subject]:GetText() == "" then
			g_PropertyTable[Subject]:SetToolTip("")
		else
			if (g_XiulianTipTable[Subject] ~= nil) then
				g_PropertyTable[Subject]:SetToolTip( g_XiulianTipTable[Subject] )
			end
		end
	end
end

-- ÖØÖÃÈËÎï½ÇÉ«µÄÊ£ÓàÊôÐÔµãºÍÒÑ¾­·ÖÅäµÄÊôÐÔµã
function SelfEquip_ResetCharRemainPoint()
	g_AddStr = 0;					-- ???????????.
	g_AddSpr = 0;					-- ???????????.
	g_AddCon = 0;					-- ???????????.
	g_AddInt = 0;					-- ???????????.
	g_AddDex = 0;					-- ???????????.

	-- ½ûÓÃÊôÐÔµãµÄÔö¼ÓºÍ¼õÉÙ²Ù×÷
	DisablePointAddButtion();
	DisablePointDecButtion();

	-- »ñÈ¡Ê£ÓàÊôÐÔµã
	local nNumber 		= Player:GetData("POINT_REMAIN");
	g_CurRemainPoint 	= nNumber;
	g_RemainPoint   	= nNumber;

	-- ¸üÐÂÏÔÊ¾
	ShowCurStr();
	ShowCurSpr();
	ShowCurCon();
	ShowCurInt();
	ShowCurDex();
	ShowCurRemainPoint();

	if(g_CurRemainPoint > 0) then
		EanblePointAddButtion();
	end

	-- ÉèÖÃÊÖ¶¯µ÷½ÚµãÊý°´Å¥µÄ×´Ì¬.
	SetAcceptButtonState();
end

--***************************************************
-- Çå¿ Êó±ê³¤°´±ê¼Ç
--***************************************************
function SelfEquip_AutoClick_Clear(id)
	id = tonumber(id)
	if (id == g_AutoClick_BtnFlag) then
		g_AutoClick_BtnFlag = -1
	end
end

--***************************************************
-- ¶¨Ê±Æ÷»Øµ÷º¯Êý
--    ÊµÏÖÂýÆô¶¯, ÒÔºó¿ÉÒÔ¿¼ÂÇ¼ÓËÙ(±ØÒªÐÔ²»´ó)
--***************************************************
function SelfEquip_AutoClick_Timer()
	if (g_AutoClick_BtnFlag ~= -1) then
		-- µÚÒ»´ÎLButtonºó¾­¹ýX¸öTimer²ÅËã¿ªÊ¼, Ò²¾ÍÊÇËµÊÇ g_AutoClickTimer_Step * X µÄÊ±ºò¿ªÊ¼½øÐÐ×Ô¶¯¼Ó,  âÑùÎªÁË·ÀÖ¹±¾À´Òªµã»÷Ò»ÏÂµÄ½á¹ûµãÁËºÃ¶àÏÂ
		if (g_AutoClick_Going < 4) then
			g_AutoClick_Going = g_AutoClick_Going + 1
			--Ä¿Ç°ÏÈÉèÖÃ 6 Step µÄµÈ´ýÊ±¼ä, ÏÂÃæ×¢ÊÍµÄ´úÂë¿ÉÒÔºóÀ´ÓÃÓÚÊµÏÖÂýÆô¶¯, Öð½¥¼ÓËÙÐ§¹û.
			--if (g_AutoClick_Going == 2 or g_AutoClick_Going == 5) then
				--g_AutoClick_FunList[g_AutoClick_BtnFlag]()
			--end
		else
			g_AutoClick_FunList[g_AutoClick_BtnFlag]()
		end
	end
end

--***************************************************
-- Êó±ê×ó¼üËÉ¿ª²Ù×÷
--    ×¢Òâ âÀïÆäÊµÊÇ´úÌæ Click, ËùÒÔÐèÒªÖ´ÐÐÒ»´Î Click ²Ù×÷
--***************************************************
function SelfEquip_AutoClick_LButtonUp(id)
	id = tonumber(id)
	SelfEquip_AutoClick_Clear(id)
	g_AutoClick_FunList[id]()
end

--***************************************************
-- ÉèÖÃ¶¨Ê±Æ÷
--    ÉèÖÃ±ê¼ÇËµÃ÷Êó±êÒÑ¾­°´ÏÂ
--***************************************************
function SelfEquip_AutoClick_SetTimer(id)
	id = tonumber(id)
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = id
end

function SelfEquip_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"));
	SelfEquip_ClearPage()
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, g_MaxPage do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, g_MaxPage do
		if SelfEquip_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)
			g_PageOrder[g_PageCount] = i

			if SelfEquip_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Hide()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function SelfEquip_Page_Peak()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		SelfPeak_Peak:SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	SelfEquip_Close()	
end


function SelfEquip_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--??
		SelfEquip_ClearPage()
	elseif idx == 2 then--??
		SelfEquip_Page_SelfData()
	elseif idx == 3 then--??
		SelfEquip_Page_Pet()
	elseif idx == 4 then--??
		SelfEquip_Page_Wuhun()
	elseif idx == 5 then--??
		SelfEquip_Page_XiuLian()
	elseif idx == 6 then--??
		SelfEquip_Page_Talent()
	elseif idx == 7 then--??
		SelfEquip_Page_LingYu()
	elseif idx == 8 then--??
		SelfEquip_Page_ShenBing()
	elseif idx == 9 then--????
		SelfEquip_Page_DWJinJie()
	elseif idx == 10 then--??
		SelfEquip_Page_Peak()
	elseif idx == 11 then--??
		SelfEquip_Profile_Switch()
	elseif idx == 12 then--??
		SelfEquip_Page_OtherInfo()
	end
end

function SelfEquip_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--??
		return 1
	elseif idx == 8 then--??
		return 1
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function SelfEquip_IsPageEnable(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return 1
	elseif idx == 7 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		return 1
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function SelfEquip_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--¸üÐÂ·ÖÒ³ºìµã
function SelfEquip_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function SelfEquip_OnYirong()
	Exterior:LuaFnInitExteriorFashionList(1)
end

function SelfEquip_Exterior_Tips()

	-- ÈËÎïÍ¼¼øµÚÒ»´ÎÉÏÏßÐ¡ºìµã+×ÓÅ®Í¼¼øµÚÒ»´ÎÉÏÏßÐ¡ºìµã
	if DataPool:LuaFnGetMF(550)==1 then 
		SelfEquip_Yirong_Icontips:Show()
		return
	end

	if Exterior:LuaFnIsHaveExteriorShowTip(-1) == 1 then
        SelfEquip_Yirong_Icontips:Show()
		return
	end
	
	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		SelfEquip_Yirong_Icontips:Show()
		return
	end
	
	if Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		SelfEquip_Yirong_Icontips:Show()
		return
    end
	
	if Exterior:LuaFnIsHaveCoupleFashionShowTip(-1) == 1 then
		SelfEquip_Yirong_Icontips:Show()
		return
    end

	SelfEquip_Yirong_Icontips:Hide()

end

function SelfData_LevelUpLock_UpdateTip()
	local level = Player:GetData("LEVEL");
	local nState,nFlag,nTime = Lua_LevelUpLock_GetState()
	if(nState ~= 2 and level < 90 and level >= 40)then
		SelfEquip_UpLevel:SetToolTip("#{JZSJ_220321_01}")
	else
		SelfEquip_UpLevel:SetToolTip("")
	end
end

function SelfData_Exp1_UpdateTips()
	local nYueKaExpRate = Player:GetData("YUEKAEXPRATE");
	if nYueKaExpRate <= 0 then
		SelfEquip_Exp1:SetToolTip("")
		return
	end
	
	local nServerLevel = Player:GetData("SERVERLEVEL");
	local nPlayerLevel = Player:GetData("LEVEL");
	local nRegularNeedExp = Player:GetData("REGULARNEEDEXP");
	if tonumber(nRegularNeedExp) == nil then
		nRegularNeedExp = 0
	end
	local szText = "";
	if nPlayerLevel > nServerLevel then
		szText = ScriptGlobal_Format("#{HJYK_230821_14}", nServerLevel, nRegularNeedExp )
	elseif nPlayerLevel == nServerLevel then
		szText = ScriptGlobal_Format("#{HJYK_230821_13}", nServerLevel, nRegularNeedExp )
	else
		local nLevel = nServerLevel - nPlayerLevel;
		if nLevel == 1 then
			szText = ScriptGlobal_Format("#{HJYK_230821_9}", nServerLevel, nRegularNeedExp )
		elseif nLevel == 2 then
			szText = ScriptGlobal_Format("#{HJYK_230821_10}", nServerLevel, nRegularNeedExp )
		elseif nLevel == 3 then
			szText = ScriptGlobal_Format("#{HJYK_230821_11}", nServerLevel, nRegularNeedExp )
		else
			szText = ScriptGlobal_Format("#{HJYK_230821_12}", nServerLevel, nRegularNeedExp )
		end
	end
	
	SelfEquip_Exp1:SetToolTip( szText )
end
