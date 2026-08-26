--PetPropagateSingle.lua
--µ¥ÈË äÊÞ·±Ö³½çÃæ(Á½¸ö äÊÞ)
local firstPet  = { idx = -1, guid = { high = -1, low = -1 } }
local secondPet = { idx = -1, guid = { high = -1, low = -1 } }
local g_currentChoose = -1
local g_wastemoney 	= 20000
--µ¥ÈË äÊÞ·±Ö³²ÄÁÏ
local g_ItemPos 	= -1
--µ¥ÈË äÊÞ·±Ö³²ÄÁÏID °®ÐÄÐ¡ÎÑ
local g_ItemTblID   = 30309794
--
local g_clientNpcId = -1
local g_serverNpcId = -1

local g_PetPropagateSingle_Frame_UnifiedPosition;

--*************************************************
--
--*************************************************
function PetPropagateSingle_PreLoad()
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "REPLY_MISSION_PET" )				-- ???????????
	this : RegisterEvent( "UPDATE_PET_PAGE" )				-- ?????????????
	this : RegisterEvent( "DELETE_PET" )					-- ??????????
	this : RegisterEvent( "OBJECT_CARED_EVENT" )			-- ?? NPC ??????
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )				--??
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UPDATE_PET_PROPAGASINGLE" )
	this : RegisterEvent( "TEAM_PETCREATE_OPENED" )
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetPropagateSingle_OnLoad()
 	g_PetPropagateSingle_Frame_UnifiedPosition=PetPropagateSingle_Frame:GetProperty("UnifiedPosition");
end

--*************************************************
--
--*************************************************
function PetPropagateSingle_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		PetPropagateSingle_UICommand(arg0)

	elseif ( event == "UNIT_MONEY" )		then
		PetPropagateSingle_ShowMoney()

	elseif ( event == "MONEYJZ_CHANGE")		then
		PetPropagateSingle_ShowJZ()

	elseif ( event == "REPLY_MISSION_PET" ) then
		PetPropagateSingle_SelectPet(arg0)

	elseif ( event == "UPDATE_PET_PAGE" ) 	then
		PetPropagateSingle_UpdatePetSelected()

	elseif ( event == "DELETE_PET" ) 		then
		PetPropagateSingle_UpdatePetSelected()

	elseif ( event == "OBJECT_CARED_EVENT" )		then
		PetPropagateSingle_CareObj(arg0,arg1,arg2)

	elseif ( event == "PACKAGE_ITEM_CHANGED" ) 		then
		if ( arg0 ~= nil and -1 == tonumber(arg0)) 	then
			return
		end

		if tonumber(arg0) == g_ItemPos then
			PetPropagateSingle_Resume_Object()
		end

	elseif ( event == "UPDATE_PET_PROPAGASINGLE" ) 	then
		PetPropagateSingle_Update(arg0)

	elseif ( event == "TEAM_PETCREATE_OPENED" ) then
		if (this : IsVisible() == false) then
			return
		end

		if (g_clientNpcId ~= -1) then
			this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
		end

		PetPropagateSingle_Clear()
		Pet : ShowPetList( 1 )
		this : Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetPropagateSingle_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetPropagateSingle_Frame_On_ResetPos()
		
	end
end

--*************************************************
--µ¥ÈË äÊÞ·±Ö³½çÃæ½ÓÊÜÃüÁî
--*************************************************
function PetPropagateSingle_UICommand(arg0)
	local nOpt = tonumber(arg0)
	if (nOpt == 20091025) then
		Pet : CloseTeamPetProCreate()
		PetPropagateSingle_Show()
	end
end

--*************************************************
--´¦ÀíÍæ¼ÒÈ·ÈÏÒª×öµÄÊÂÇé
--*************************************************
function PetPropagateSingle_OK_Clicked()
	-- ·¢ËÍ UI_Command ½øÐÐºÏ³É
	local nName1 = PetPropagateSingle_PetName1 : GetText()
	local nName2 = PetPropagateSingle_PetName2 : GetText()
	if (firstPet.guid.high == -1 or firstPet.guid.low == -1	or secondPet.guid.high == -1 or secondPet.guid.low == -1) then
		PushDebugMessage("Thïnh lña ch÷n Trân Thú!")
		return
	end

	if (nName1 == nil or nName1 == "" or nName2 == nil or nName2 == "") then
		PushDebugMessage("Thïnh lña ch÷n Trân Thú!")
		return
	end

	if (g_ItemPos == -1) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	local nItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
	if (nItemID ~= g_ItemTblID) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	--½ðÇ®ÊÇ·ñ×ã¹»
	local nHaveMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if (nHaveMoney < g_wastemoney) then
		PushDebugMessage("#{no_money}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnSignalPetProcreateRegister" )
		Set_XSCRIPT_ScriptID( 800101 )
		Set_XSCRIPT_Parameter( 0, g_serverNpcId )
		Set_XSCRIPT_Parameter( 1, firstPet.guid.high )
		Set_XSCRIPT_Parameter( 2, firstPet.guid.low )
		Set_XSCRIPT_Parameter( 3, secondPet.guid.high )
		Set_XSCRIPT_Parameter( 4, secondPet.guid.low )
		Set_XSCRIPT_Parameter( 5, g_ItemPos )
		Set_XSCRIPT_ParamCount( 6 )
	Send_XSCRIPT()
end

--*************************************************
--µã»÷X°´Å¥£¬Òþ²Ø´°¿Ú¡£
--*************************************************
function PetPropagateSingle_OnHidden()
	if (this : IsVisible() == false) then
		return
	end

	if (g_clientNpcId ~= -1) then
		this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
	end

	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Hide()
end

--*************************************************
--µã»÷È¡Ïû°´Å¥£¬´°¿ÚÒþ²Øº¯Êý
--*************************************************
function PetPropagateSingle_Close_Window()
	if (this : IsVisible() == false) then
		return
	end

	if (g_clientNpcId ~= -1) then
		this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
	end

	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Hide()
end

--*************************************************
--¹ØÐÄNPC
--*************************************************
function PetPropagateSingle_CareObj(careId, op, distance)
	if(nil == careId or nil == op or nil == distance) then
		return;
	end

	if(tonumber(careId) ~= g_clientNpcId) then
		return;
	end

	if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
		PetPropagateSingle_OnHidden()
	end
end

--*************************************************
--´ò¿ªµ¥ÈË äÊÞ·±Ö³½çÃæ
--*************************************************
function PetPropagateSingle_Show()
	if (this : IsVisible()) then									-- ??????,????
		return
	end

	--½çÃæµÄÖ÷ÈË
	g_serverNpcId = Get_XParam_INT(0)
	g_clientNpcId = Target : GetServerId2ClientId(g_serverNpcId)

	if (g_clientNpcId == -1) then
		return
	end

	this : CareObject(g_clientNpcId, 1, "PetPropagateSingle")

	-- äÊÞÏÔÊ¾½çÃæ
	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Show()

	local npcObjId = Get_XParam_INT( 0 )
	BeginCareObject( npcObjId )

	PetPropagateSingle_SelfJiaozi : SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	PetPropagateSingle_SelfMoney  : SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetPropagateSingle_PetList_Select1 : Enable()
	PetPropagateSingle_PetList_Select2 : Enable()
end


--*************************************************
--Ñ¡Ôñ äÊÞ
--*************************************************
function PetPropagateSingle_SelectPet_Clicked(type)
	if (type == "first") then
		g_currentChoose = 1
		PetPropagateSingle_PetList_Select1 : Disable()
		PetPropagateSingle_PetList_Select2 : Enable()
	elseif (type == "second") then
		g_currentChoose = 2
		PetPropagateSingle_PetList_Select1 : Enable()
		PetPropagateSingle_PetList_Select2 : Disable()
	else
		return
	end
	-- ¹ØÒ»ÏÂÔÙ¿ª£¬Çå¿ Êý¾Ý
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

--***************************************************
--
--***************************************************
function PetPropagateSingle_SelectPet( arg0 )

	--ÅÐ¶Ïµ¥ÈË äÊÞ·±Ö³
	if (not (this : IsVisible())) then
		return
	end

	-- äÊÞË÷Òý
	local petIdx = tonumber(arg0)
	if (-1 == petIdx) then
		return
	end
	
	-- äÊÞÒÑ±»ÆäËü½çÃæÑ¡ÖÐÇÒÅÅ³ýµ¥ÈË äÊÞ·±Ö³½çÃæ£¬ÓÉºóÃæÅÐ¶Ï
	if (Pet:GetPetLocation(petIdx) ~= -1 and Pet:GetPetLocation(petIdx) ~= 2) then
		return;
	end

	--ÅÐ¶ÏÊÇ·ñ äÊÞ¼ÓËø
	if (PlayerPackage:IsPetLock(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_09}")
		return
	end

	--ÅÐ¶ÏÊÇ·ñ äÊÞ³ö ½
	if (Pet : GetIsFighting(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_10}")
		return
	end

	--ÅÐ¶ÏÊÇ·ñÎª äÊÞ±¦±¦
	--if (Pet : GetPetType(petIdx) ~= 0) then
	--	PushDebugMessage("#{DRFZZC_091013_11}")
	--	return
	--end

	--ÅÐ¶Ï äÊÞÊÇ·ñÎª»Ã»¯
	if (Pet : GetGeneration(petIdx) >= 100 ) then
		PushDebugMessage("#{DRFZZC_091013_12}")
		return
	end

	--ÅÐ¶Ï äÊÞÊÇ·ñ¿ìÀÖ¶ÈÎª100
	if (Pet : GetHappy(petIdx) ~= 100) then
		PushDebugMessage("#{DRFZZC_091013_13}")
		return
	end

	--ÅÐ¶Ï äÊÞÊÇ·ñ´©ÁË×°±¸
	if (Pet : IsPetHaveEquip(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_14}")
		return
	end

	--ÅÐ¶Ï äÊÞÊÙÃüÊÇ·ñÎª1000
	if (Pet : GetNaturalLife(petIdx) < 1000) then
		PushDebugMessage("#{DRFZZC_091013_15}")
		return
	end

	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	if (g_currentChoose == 1) then
		--ÅÐ¶ÏÊÇ·ñµÚÒ»¸ö äÊÞºÍµÚ¶þ¸ö äÊÞÊÇÍ¬Ò»¸ö äÊÞ
		if (secondPet.idx ~= -1 and secondPet.idx == petIdx) then
			ShowSystemTipInfo( "Nh§p 2 Trân thú khác nhau." )
			return
		end

		--Èç¹ûÆäÖÐÓÐ äÊÞÁË£¬Çå¿ 
		PetPropagateSingle_RemoveFirstPet()

		firstPet.idx = petIdx
		firstPet.guid.high = guidH
		firstPet.guid.low  = guidL

		--ÌîÐ´µÚÒ»¸ö äÊÞÃû×Ö
		PetPropagateSingle_PetName1 : SetText( petName )
		Pet : SetPetLocation( petIdx , 2 )
		Pet : UpdatePetList()

	elseif (g_currentChoose == 2) then
		--ÅÐ¶ÏÊÇ·ñµÚÒ»¸ö äÊÞºÍµÚ¶þ¸ö äÊÞÊÇÍ¬Ò»¸ö äÊÞ
		if (firstPet.idx ~= -1 and firstPet.idx == petIdx) then
			ShowSystemTipInfo( "Nh§p 2 Trân thú khác nhau." )
			return
		end

		--Èç¹ûÆäÖÐÓÐ äÊÞÁË£¬Çå¿ 
		PetPropagateSingle_RemoveSecondPet()

		secondPet.idx = petIdx
		secondPet.guid.high = guidH
		secondPet.guid.low  = guidL

		--ÌîÐ´µÚ¶þ¸ö äÊÞµÄÃû×Ö
		PetPropagateSingle_PetName2 : SetText( petName )
		Pet : SetPetLocation( petIdx , 2 )
		Pet : UpdatePetList()
	end

	--ÏÔÊ¾ÏûºÄ¶àÉÙ½ðÇ®
	PetPropagateSingle_CalcCost()
end

--***************************************************
--Çå¿ µÚÒ»¸ö äÊÞ
--***************************************************
function PetPropagateSingle_RemoveFirstPet()
	if (firstPet.idx ~= -1) then
		Pet : SetPetLocation( firstPet.idx, -1 )
		-- ¸üÐÂ äÊÞÁÐ±í½çÃæ
		Pet : UpdatePetList()
	end

	firstPet.idx = -1
	firstPet.guid.high = -1
	firstPet.guid.low  = -1
	PetPropagateSingle_PetName1 : SetText( "" )
end


--***************************************************
--Çå¿ µÚ¶þ¸ö äÊÞ
--***************************************************
function PetPropagateSingle_RemoveSecondPet()
	if (secondPet.idx ~= -1) then
		Pet : SetPetLocation( secondPet.idx, -1 )
		-- ¸üÐÂ äÊÞÁÐ±í½çÃæ
		Pet : UpdatePetList()
	end

	secondPet.idx = -1
	secondPet.guid.high = -1
	secondPet.guid.low  = -1
	PetPropagateSingle_PetName2 : SetText( "" )
end


--****************************************************
--¼ÆËã½ðÇ®ÏûºÄ
--****************************************************
function PetPropagateSingle_CalcCost()
	PetPropagateSingle_Money : SetProperty( "MoneyNumber", tostring( g_wastemoney ) )
end


--****************************************************
--¸üÐÂ½çÃæ
--****************************************************
function PetPropagateSingle_Update( pos_packet )
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber( pos_packet )

	--ÊÇ·ñ¼ÓËø....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--¸üÐÂµ¥ÈË äÊÞ·±Ö³²ÄÁÏ½çÃæ
	local ItemID = PlayerPackage : GetItemTableIndex( BagPos )
	if ( ItemID <= 0) then
		PushDebugMessage("#{GMActionSystem_Item_CantUseInPetSkillStudy}")
		return
	end

	--²é¿´ÎïÆ·ÊÇ·ñÊÇ¡°°®ÐÄÐ¡ÎÑ¡±
	if ( ItemID ~= g_ItemTblID) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	-- äÊÞÎïÆ·Î»ÖÃÊÇ·ñºÏ·¨
	if (g_ItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
	end

	LifeAbility : Lock_Packet_Item( BagPos, 1 )
	g_ItemPos = BagPos

	--¸üÐÂ äÊÞ»¹Í¯µÄ äÊÞ½çÃæ
	local theAction = EnumAction( BagPos, "packageitem" )
	if (theAction : GetID() == 0) then
		return
	end

	PetPropagateSingle_Object : SetActionItem( theAction : GetID() )
	PetPropagateSingle_CalcCost()
end


--*************************************************
--
--*************************************************
function PetPropagateSingle_Resume_Object()
	PetPropagateSingle_ClearActionItem()
end

--*************************************************
--
--*************************************************
function PetPropagateSingle_Clear()
	PetPropagateSingle_ClearPetName()
	PetPropagateSingle_ClearActionItem()
	PetPropagateSingle_ClearMoney()
end

--*************************************************
--Çå¿ Á½¸ö äÊÞÃû×Ö
--*************************************************
function PetPropagateSingle_ClearPetName()
	PetPropagateSingle_RemoveFirstPet()
	PetPropagateSingle_RemoveSecondPet()
end

--*************************************************
--Çå¿ ·±Ö³ÎïÆ·
--*************************************************
function PetPropagateSingle_ClearActionItem()
	if g_ItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
		PetPropagateSingle_Object : SetActionItem( -1 )
		g_ItemPos = -1
	end
end

--*************************************************
--Çå¿ ½ðÇ®
--*************************************************
function PetPropagateSingle_ClearMoney()
	PetPropagateSingle_Money : SetProperty( "MoneyNumber", 0 )
	PetPropagateSingle_SelfJiaozi : SetProperty( "MoneyNumber", 0 )
	PetPropagateSingle_SelfMoney  : SetProperty( "MoneyNumber", 0 )
end

--*************************************************
--Ñ¡Ôñ äÊÞ¸üÐÂ
--*************************************************
function PetPropagateSingle_UpdatePetSelected()
	-- ÅÐ¶Ï±»Ñ¡ÖÐµÄ äÊÞÊÇ·ñ»¹ÔÚ±³°üÀï
	if (firstPet.idx ~= -1) then
		local newIdx = Pet : GetPetIndexByGUID( firstPet.guid.high, firstPet.guid.low )
		Pet : SetPetLocation( firstPet.idx, -1 )
		-- Èç¹û²»ÔÚÔòÉ¾µô
		if (newIdx == -1) then
			firstPet.idx = -1
			firstPet.guid.high = -1
			firstPet.guid.low  = -1
			PetPropagateSingle_PetName1 : SetText( "" )
		-- ·ñÔòÅÐ¶Ï äÊÞµÄÎ»ÖÃÊÇ·ñ·¢Éú±ä»¯
		elseif (newIdx ~= firstPet.idx) then
			-- Èç¹û·¢Éú±ä»¯Ôò¶ÔÎ»ÖÃ½øÐÐ¸üÐÂ
			firstPet.idx = newIdx
		end
	end

	-- ÅÐ¶Ï±»Ñ¡ÖÐµÄ äÊÞÊÇ·ñ»¹ÔÚ±³°üÀï
	if (secondPet.idx ~= -1) then
		local newIdx = Pet : GetPetIndexByGUID( secondPet.guid.high, secondPet.guid.low )
		Pet : SetPetLocation( secondPet.idx, -1 )
		-- Èç¹û²»ÔÚÔòÉ¾µô
		if (newIdx == -1) then
			secondPet.idx = -1
			secondPet.guid.high = -1
			secondPet.guid.low  = -1
			PetPropagateSingle_PetName2 : SetText( "" )
		-- ·ñÔòÅÐ¶Ï äÊÞµÄÎ»ÖÃÊÇ·ñ·¢Éú±ä»¯
		elseif (newIdx ~= secondPet.idx) then
			-- Èç¹û·¢Éú±ä»¯Ôò¶ÔÎ»ÖÃ½øÐÐ¸üÐÂ
			secondPet.idx = newIdx
		end
	end
end

--********************************************
--ÏÔÊ¾×ÔÉíÓµÓÐµÄ½ðÇ®
--********************************************
function PetPropagateSingle_ShowMoney()
	PetPropagateSingle_SelfMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--********************************************
--ÏÔÊ¾×ÔÉíÓµÓÐµÄ½»×Ó
--********************************************
function PetPropagateSingle_ShowJZ()
	PetPropagateSingle_SelfJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
end

function PetPropagateSingle_Frame_On_ResetPos()
  PetPropagateSingle_Frame:SetProperty("UnifiedPosition", g_PetPropagateSingle_Frame_UnifiedPosition);
end
