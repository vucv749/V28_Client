-- Êý¾Ý³ØÖÐ¶¨ÒåµÄ×°±¸Êý¾Ý.
--HEQUIP_WEAPON		=0,		//ÎäÆ÷	WEAPON
--HEQUIP_CAP			=1,		//Ã±×Ó	DEFENCE
--HEQUIP_ARMOR		=2,		//ÒÂ·þ	DEFENCE
--HEQUIP_CUFF			=3,		//ÊÖÌ×	DEFENCE
--HEQUIP_BOOT			=4,		//Ð¬	DEFENCE
--HEQUIP_SASH			=5,		//Ñü´ø	ADORN
--HEQUIP_RING			=6,		//½ä×Ó	ADORN
--HEQUIP_NECKLACE	=7,		//ÏîÁ´	ADORN
--HEQUIP_DARK		=8,		//Æï³Ë----ÒÑÐÞ¸ÄÎª°µÆ÷by houzhifang
--HEQUIP_BAG			=9,		//ÐÐÄÒ                            »¤·û
--HEQUIP_BOX			=10,	//Ïä¸ñ
--HEQUIP_RING_2		=11,	//µÚ¶þ¸ö½äÖ¸	ADORN
--HEQUIP_CHARM		=12,	//»¤·û	            ADORN
--HEQUIP_CHARM_2		=13,	//µÚ¶þ¸ö»¤·û	    ADORN
--HEQUIP_WRIST		=14,	//»¤Íó	DEFENCE
--HEQUIP_SHOULDER		=15,	//»¤¼ç	DEFENCE
--HEQUIP_DRESS		=16,	//Ê±×°


--------------------------------------------------------------------------------
-- ×°±¸°´Å¥Êý¾Ý¶¨Òå
--
local  g_WEAPON;		--??
local  g_ARMOR;			--??
local  g_CAP;			--??
local  g_CUFF;			--??
local  g_BOOT;			--?
local  g_RING;			--??
local  g_SASH;			--??
local  g_NECKLACE;		--??
local  g_Dark;			--??---??????
local  g_Charm;			-- ??
local  g_Charm2;		-- ??2
local  g_Shoulder;		-- ??
local  g_Glove;			-- ??
local  g_Ring2;			-- ??2

local g_Cur_Name = "";
local g_TargetEquip_Cur_ZoneWorldId = -1
local g_objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local TARGETEQUIP_TAB_TEXT = {};

local g_TargetEquip_Frame_UnifiedPosition;

local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		},
	[2] = {Text = "#{INTERFACE_XML_882}",		},
	[3] = {Text = "#{INTERFACE_XML_854}",		},
	[4] = {Text = "#{WH_xml_XX(95)}",			},
	[5] = {Text = "#{SZXT_221216_22}",			},
	[6] = {Text = "#{SBFW_20230707_1}",			},
	[7] = {Text = "#{DWJJ_240329_153}",  	 	},
	[8] = {Text = "#{DFJC_250709_1}",  	 		},
	[9] = {Text = "#{GRYM_221213_22}",  	 	},

}
local g_PageButton = {}
local g_PageOrder = {}

local g_TargetEquip_Position15;
local g_TargetEquip_Position14;
local g_TargetEquip_Position13;
local g_TargetEquip_Position12;

function TargetEquip_PreLoad()

	-- ´ò¿ª½çÃæ
	this:RegisterEvent("MAINTARGET_CHANGED");
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("CLOSE_TARGET_EQUIP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function TargetEquip_OnLoad()

	-- action buttion °´Å¥
	g_WEAPON		= TargetEquip_Equip11;		--??
	g_ARMOR			= TargetEquip_Equip12;		--??
	g_CAP			= TargetEquip_Equip1;		--??
	g_CUFF			= TargetEquip_Equip8;		--??
	g_BOOT			= TargetEquip_Equip4;		--?
	g_RING			= TargetEquip_Equip6;		--??
	g_SASH			= TargetEquip_Equip7;		--??
	g_NECKLACE		= TargetEquip_Equip13;		--??
	g_Dark			= TargetEquip_Equip14;		--??
	g_Charm			= TargetEquip_Equip9;		-- ??
	g_Charm2		= TargetEquip_Equip10;		-- ??2
	g_Shoulder		= TargetEquip_Equip3;		-- ??
	g_Glove			= TargetEquip_Equip2;		-- ??
	g_Ring2			= TargetEquip_Equip5;		-- ??2

	TARGETEQUIP_TAB_TEXT = {
		[0] = "T.B¸",
		"T.Tin",
		"Thú",
	};
	
	g_TargetEquip_Frame_UnifiedPosition=TargetEquip_Frame:GetProperty("UnifiedPosition");
	
	-- ·ÖÒ³°´Å¥
	g_PageButton[1] = TargetEquip_SelfEquip
	g_PageButton[2] = TargetEquip_TargetData
	g_PageButton[3] = TargetEquip_Pet
	g_PageButton[4] = TargetEquip_TargetWuhun
	g_PageButton[5] = TargetEquip_TargetLingyu
	g_PageButton[6] = TargetEquip_TargetWeapon2
	g_PageButton[7] = TargetEquip_TargetDWJinJie
	g_PageButton[8] = TargetEquip_TargetPeak
	g_PageButton[9] = TargetEquip_TargetProfile
	

	
	g_TargetEquip_Position12	= TargetEquip_Equip12:GetProperty("UnifiedPosition");
	g_TargetEquip_Position13	= TargetEquip_Equip13:GetProperty("UnifiedPosition");
	g_TargetEquip_Position14	= TargetEquip_Equip14:GetProperty("UnifiedPosition");
	g_TargetEquip_Position15	= TargetEquip_Equip15:GetProperty("UnifiedPosition");
	
end

function TargetEquip_SetTabColor(idx)

	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = TargetEquip_SelfEquip,
								TargetEquip_TargetData,
								-- TargetEquip_Blog,
								TargetEquip_Pet,
							};

	while i < 3 do
		if(i == idx) then
			tab[i]:SetText(selColor..TARGETEQUIP_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..TARGETEQUIP_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

-- OnEvent
function TargetEquip_OnEvent(event)

	if ( event == "MAINTARGET_CHANGED" and tonumber(arg0) == -1) then

		return;
	end

	if( "PLAYER_LEAVE_WORLD" == event) then
		this : Hide();
		return;
	end

	-- ×°±¸±ä»¯Ê±Ë¢ÐÂ×°±¸.
	if("OTHERPLAYER_UPDATE_EQUIP" == event) then

		if (not CachedTarget:IsPresent(1)) then
			return;
		end

		if not ZBS:IsCanGetTargetEquip() then
			return
		end
		
		if (not CachedTarget:CanGetTargetEquip()) then
			PushDebugMessage ("#{JSCK_90507_1}")				-- ???????,???????
			return
		end

		g_objCared = CachedTarget:GetData("NPCID", 1)
		if (type(g_objCared) ~="number") then
			PushDebugMessage ("#{JSCK_90507_1}")				-- ???????,???????
			return
		end

		local otherUnionPos = Variable:GetVariable("OtherUnionPos");
		if(otherUnionPos ~= nil) then
			TargetEquip_Frame:SetProperty("UnifiedPosition", otherUnionPos);
		end
		TargetEquip_SetTabColor(0);
		TargetEquip_SelfEquip:SetCheck(1);
		TargetEquip_TargetData:SetCheck(0);

		TargetEquip_FakeObject:SetFakeObject("");
		CachedTarget:TargetEquip_ChangeModel();
		TargetEquip_FakeObject:SetFakeObject("Target");

		-- ¿ªÊ¼¹ØÐÄOBJ
		TargetEquip_BeginCareObject(g_objCared);
		TargetEquip_OnUpdateShow();
		TargetEquip_RefreshEquip();

		this:Show();
				
		--Ò³Ç©
		TargetEquip_ShowPage()
	
		local isopen5 = T300Func:IsNoDifOpen(5)
		if isopen5 == 1 then
			--TargetEquip_TargetWuhun:Disable()
		else
			TargetEquip_TargetWuhun:Enable()
		end
		return;
	end

	if( "CLOSE_TARGET_EQUIP" == event ) then

		TargetEquip_CloseUI();
		return;
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if( arg1=="destroy") then
			TargetEquip_CloseUI();
			return;
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		TargetEquip_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TargetEquip_Frame_On_ResetPos()
		
	end

end

-- ¸üÐÂÖ÷½Ç»ù±¾ÐÅÏ¢
function TargetEquip_OnUpdateShow()

	local nNumber = 0;
	local nMaxnumber = 0;
	local strName = "";

	-- µÃµ½Ãû×Ö
  strName = CachedTarget:GetData("NAME", 1);
  if strName == nil then
  	return
  end
  
  g_Cur_Name = strName;
  TargetEquip_PageHeader:SetText("#gFF0FA0" .. strName );

  g_TargetEquip_Cur_ZoneWorldId = CachedTarget:GetData("ZONEWORLD", 1);

	-- µÃµ½³ÆºÅ
	strName = CachedTarget:GetData("TITLE", 1)
	TargetEquip_Agname:SetText( ""..strName );

	-- µÃµ½°ïÅÉ
	strName = CachedTarget:GetData("GUILD", 1)
	TargetEquip_Confraternity:SetText( ""..strName );

	-- µÃµ½µÈ¼¶
	nNumber = CachedTarget:GetData("LEVEL", 1);
	TargetEquip_Level:SetText("C¤p: " .. tostring( nNumber ));

	-- µÃµ½ÅäÅ¼ÐÅÏ¢
	local szConsort = SystemSetup:GetPrivateInfo("other","Consort");
	TargetEquip_Spouse:SetText(szConsort);
	
	--µÃµ½½á»éÊ±¼ä
	strName = SystemSetup:GetPrivateInfo("other","Weddingtime");
	TargetEquip_Date:SetText(strName)
	

	-- ÃÅÅÉ
	local menpai = CachedTarget:GetData("MEMPAI",1);
	local strMenpai = "";

	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == menpai) then
		strMenpai = "Thiªu Lâm";

	elseif(1 == menpai) then
		strMenpai = "Minh Giáo";

	elseif(2 == menpai) then
		strMenpai = "Cái Bang";

	elseif(3 == menpai) then
		strMenpai = "Võ Ðang";

	elseif(4 == menpai) then
		strMenpai = "Nga Mi";

	elseif(5 == menpai) then
		strMenpai = "Tinh Túc";

	elseif(6 == menpai) then
		strMenpai = "Thiên Long";

	elseif(7 == menpai) then
		strMenpai = "Thiên S½n";

	elseif(8 == menpai) then
		strMenpai = "Tiêu Dao";

	elseif(9 == menpai) then
		strMenpai = "Tñ do";

	elseif(10== menpai) then
		strMenpai = "Mµ Dung";

	elseif(11== menpai) then--MPTODO menpai11
		strMenpai = "Ác Nhân C¯c";
	end

	local secttype = CachedTarget:GetData("SECTTYPE",1);
	if secttype < 0 then
	-- ÉèÖÃÏÔÊ¾µÄÃÅÅÉ.
		TargetEquip_MenPai:SetText(strMenpai);

	else
		if menpai == 9 then
			TargetEquip_MenPai:SetText(strMenpai);
		else
			local sectname = DataPool:Lua_GetSectName(menpai,secttype)
			TargetEquip_MenPai:SetText(strMenpai.."·"..sectname);
		end

	end




	-- ¸öÈËËµÃ÷
	local szLuck = SystemSetup:GetPrivateInfo("other","luck");
	TargetEquip_Message:SetText(szLuck);

	--
	local tZWId =  CachedTarget:GetData("ZONEWORLD");

	local myZWID = DataPool:GetSelfZoneWorldID()
	TargetEquip_Server:SetText("")
	if myZWID ~= tZWId then		
		TargetEquip_Server:SetText(DataPool:GetServerName(tZWId))
	end


end

-- Ë¢ÐÂ×°±¸
function TargetEquip_RefreshEquip()

	--  Çå¿ °´Å¥ÏÔÊ¾Í¼±ê
	g_WEAPON:SetActionItem(-1);			--??
	g_CAP:SetActionItem(-1);				--??
	g_ARMOR:SetActionItem(-1);			--??
	g_CUFF:SetActionItem(-1);				--??
	g_BOOT:SetActionItem(-1);				--?
	g_SASH:SetActionItem(-1);				--??
	g_RING:SetActionItem(-1);				--??
	g_NECKLACE:SetActionItem(-1);		--??
	g_Dark:SetActionItem(-1);				--??
	g_Charm:SetActionItem(-1);			-- ??
	g_Charm2:SetActionItem(-1);			-- ??2
	g_Shoulder:SetActionItem(-1);		-- ??
	g_Glove:SetActionItem(-1);			-- ??
	g_Ring2:SetActionItem(-1);			-- ??2
	TargetEquip_Equip15:SetActionItem(-1)
	
	local ActionWeapon 		= EnumAction(0, "targetequip");
	local ActionCap    		= EnumAction(1, "targetequip");
	local ActionArmor  		= EnumAction(2, "targetequip");
	local ActionGlove		= EnumAction(3, "targetequip");
	local ActionBoot   		= EnumAction(4, "targetequip");
	local ActionSash   		= EnumAction(5, "targetequip");
	local ActionRing    	= EnumAction(6, "targetequip");
	local ActionNecklace	= EnumAction(7, "targetequip");
	local ActionDark		= EnumAction(17, "targetequip");    --?????  by houzhifang
	local ActionRing2		= EnumAction(11, "targetequip");
	local ActionCharm		= EnumAction(12, "targetequip");
	local ActionCharm2		= EnumAction(13, "targetequip");
	local ActionCuff  		= EnumAction(14, "targetequip");
	local ActionShoulder	= EnumAction(15, "targetequip");

	-- ÏÔÊ¾ÈËÉíÉÏµÄÎäÆ÷×°±¸
	g_WEAPON:SetActionItem(ActionWeapon:GetID());			--??
	g_CAP:SetActionItem(ActionCap:GetID());						--??
	g_ARMOR:SetActionItem(ActionArmor:GetID());				--??
	g_CUFF:SetActionItem(ActionCuff:GetID());					--??
	g_BOOT:SetActionItem(ActionBoot:GetID());					--?
	g_SASH:SetActionItem(ActionSash:GetID());					--??
	g_RING:SetActionItem(ActionRing:GetID());					--??
	g_NECKLACE:SetActionItem(ActionNecklace:GetID());	--??
	g_Dark:SetActionItem(ActionDark:GetID());					--??
	g_Charm:SetActionItem(ActionCharm:GetID());				-- ??
	g_Charm2:SetActionItem(ActionCharm2:GetID());			-- ??2
	g_Shoulder:SetActionItem(ActionShoulder:GetID());	-- ??
	g_Glove:SetActionItem(ActionGlove:GetID());				-- ??
	g_Ring2:SetActionItem(ActionRing2:GetID());				-- ??2
	
	local ActionSB = EnumAction(37, "targetequip")
	TargetEquip_Equip15:SetActionItem(ActionSB:GetID())
end

----------------------------------------------------------------------------------
--
-- Ðý×ªÍæ¼ÒÄ£ÐÍ£¨Ïò×ó)
--
function TargetEquip_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(-0.3);
	--Ïò×óÐý×ª½áÊø
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- Ðý×ªÍæ¼ÒÄ£ÐÍ£¨ÏòÓÒ)
--
function TargetEquip_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(0.3);
	--ÏòÓÒÐý×ª½áÊø
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------------
--
-- ¹Ø± ½çÃæ
--
function TargetEquip_CloseUI()

	this:Hide();

	-- È¡Ïû¹ØÐÄOBJ
	TargetEquip_StopCareObject(g_objCared);

	-- Çå¿ FakeModel´°¿Ú
	TargetEquip_FakeObject:SetFakeObject("");
	CachedTarget:TargetEquip_DestroyUIModel();

	-- Çå¿ ½ÇÉ«ÐÅÏ¢ºÍ×°±¸Í¼±ê
	TargetEquip_ClearPlayerInfo();
	TargetEquip_ClearEquipItem();

end

----------------------------------------------------------------------------------------
--
-- Çå¿ ×°±¸½çÃæÖÐµÄ½ÇÉ«ÐÅÏ¢
--
function TargetEquip_ClearPlayerInfo()

	TargetEquip_PageHeader:SetText("");
	TargetEquip_Agname:SetText("");
	TargetEquip_Confraternity:SetText("");
	TargetEquip_Level:SetText("C¤p: ");
	TargetEquip_Spouse:SetText("");
	TargetEquip_MenPai:SetText("Phái: ");
	TargetEquip_Message:SetText("");

end

----------------------------------------------------------------------------------------
--
--  Çå¿ ×°±¸½çÃæÖÐµÄ×°±¸Í¼±ê
--
function TargetEquip_ClearEquipItem()

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
	g_Charm:SetActionItem(-1);		-- ??
	g_Charm2:SetActionItem(-1);		-- ??2
	g_Shoulder:SetActionItem(-1);		-- ??
	g_Glove:SetActionItem(-1);		-- ??
	g_Ring2:SetActionItem(-1);		-- ??2
	TargetEquip_Equip15:SetActionItem(-1)
end

----------------------------------------------------------------------------------------
--
-- ´ò¿ªÍæ¼ÒÐÅÏ¢½çÃæ
--
-- ×ÊÁÏ
--
function TargetEquip_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
--
-- ²©¿Í
--
-- function TargetEquip_TargetBlog_Down()
-- 	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);

-- 	local strCharName =  CachedTarget:GetData("NAME");
-- 	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
-- 	Blog:OpenBlogPage(strAccount,strCharName,false);
-- end
--
--  äÊÞ
--
function TargetEquip_OtherPet_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end
--
-- Æï³Ë
--
function TargetEquip_OtherRide_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end

--Îä»ê

function TargetEquip_TargetWuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		TargetEquip_TargetWuhun : SetCheck(0)
		TargetEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenOtherWuhun();
end

function TargetEquip_TargetLingyu_Switch()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
end

function TargetEquip_ShenBing_Switch()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function TargetEquip_DWJinJie_Switch()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end

function TargetEquip_OpenShopDress()
	PushEvent( "TARGET_DRESS",  g_objCared )
end

function TargetEquip_OtherProfile_Switch()
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetEquip_TargetProfile:SetCheck(0)
		TargetEquip_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end

function TargetEquip_OtherDFeng_Switch()
	--if ZBS:IsZBSFinalDFengBanFlag() == 1 then
--		PushDebugMessage("#{WCBZ_250812_1}")
	--    return 0
	--end
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		TargetEquip_TargetPeak:SetCheck(0)
		TargetEquip_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1)
	--SystemSetup:Lua_OpenDFengOther()
	local eLoad = GetTargetPlayerGUID();
	if eLoad ~=nil and eLoad ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetTargetWuJingData");
			Set_XSCRIPT_ScriptID(502161);
			Set_XSCRIPT_Parameter(0,tonumber(eLoad));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	this:Hide();
end

----------------------------------------------------------------------------------------
--
-- ¡°Ë½ÁÄ¡±°´Å¥µÄÏìÓ¦º¯Êý
--
function Set_To_Private()

	--CachedTarget:Set_To_Private(g_Cur_Name);
	Talk:ContexMenuTalk(g_Cur_Name, g_TargetEquip_Cur_ZoneWorldId);
end

----------------------------------------------------------------------------------------
--
-- ¡°¼ÓÎªºÃÓÑ¡±°´Å¥µÄÏìÓ¦º¯Êý
--
function Set_To_Friend()
	if g_TargetEquip_Cur_ZoneWorldId ~= -1 and g_TargetEquip_Cur_ZoneWorldId ~= DataPool:GetSelfZoneWorldID() then
		PushDebugMessage("#{BHKF_140909_327}")
		return
	end
	DataPool:AddFriendAndGrouping(g_Cur_Name)
end


function TargetEquip_ShowPage()

	for i = 1, 9 do
		g_PageButton[i]:Hide()
	end
		
	local nPageNumber = tonumber(Variable:GetVariable("TargetPageNumber"));
	TargetEquip_ClearPage()
	
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, 9 do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, 9 do
		if TargetEquip_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)
			g_PageOrder[g_PageCount] = i
		end
	end
end

function TargetEquip_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 6 then--??
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 7 then--????
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 8 then--??
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 9 then--??
		return 1
	end
	return 0
end

function TargetEquip_ClearPage()
	Variable:SetVariable("TargetPageNumber", tostring(0), 1)
end

function TargetEquip_OnPageClicked(idx)

	Variable:SetVariable("TargetPageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--??
		TargetEquip_ClearPage()
	elseif idx == 2 then--??
		TargetEquip_TargetData_Down()
	elseif idx == 3 then--??
		TargetEquip_OtherPet_Down()
	elseif idx == 4 then--??
		TargetEquip_TargetWuhun_Switch()
	elseif idx == 5 then--??
		TargetEquip_TargetLingyu_Switch()
	elseif idx == 6 then--??
		TargetEquip_ShenBing_Switch()
	elseif idx == 7 then--????
		TargetEquip_DWJinJie_Switch()
	elseif idx == 8 then
		TargetEquip_OtherDFeng_Switch()
	elseif idx == 9 then
		TargetEquip_OtherProfile_Switch()
	end
end

--=========================================================
--¿ªÊ¼¹ØÐÄOBJ
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄOBJ£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function TargetEquip_BeginCareObject(objCaredId)

	if (type(objCaredId) == "number") then
		g_objCared = objCaredId;
		this:CareObject(g_objCared, 1, "TargetEquip");
	else
		return;
	end

end

--=========================================================
--Í£Ö¹¶ÔÄ³OBJµÄ¹ØÐÄ
--=========================================================
function TargetEquip_StopCareObject(objCaredId)

	if (type(objCaredId) == "number") then
		this:CareObject(objCaredId, 0, "TargetEquip");
		g_objCared = -1;
	else
		return;
	end

end

function TargetEquip_Frame_On_ResetPos()
  TargetEquip_Frame:SetProperty("UnifiedPosition", g_TargetEquip_Frame_UnifiedPosition);
end
