-- PetSavvyGGD.lua
--  äÊÞÌáÉýÎòÐÔ£¨ÓÃ¸ù¹Çµ¤£©

local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

local theNPC = -1													-- ?? NPC
local MAX_OBJ_DISTANCE = 3.0
local g_PetSavvyGGD_YuanbaoPay=1

local currentChoose = -1

local moneyCosts = {													-- ???????????
	[0] = 100,
	[1] = 110,
	[2] = 121,
	[3] = 133,
	[4] = 146,
	[5] = 161,
	[6] = 177,
	[7] = 194,
	[8] = 214,
	[9] = 235,
	[10] = 25937,
	[11] = 28531,
	[12] = 31384,
	[13] = 34523,
	[14] = 37975,
}

-- ÎòÐÔµÈ¼¶¶ÔÓ¦Ôª±¦
local YuanBaoCosts = {
	[0] = 28880,
	[1] = 28860,
	[2] = 28820,
	[3] = 28740,
	[4] = 28580,
	[5] = 28380,
	[6] = 27780,
	[7] = 25840,
	[8] = 24120,
	[9] = 500,
}


local WX_10 = 0
local WX_15 = 1
local UI_TYPE = 0

local g_PetSavvyGGD_Frame_UnifiedPosition;

function PetSavvyGGD_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )				-- ???????????
	this : RegisterEvent( "UPDATE_PET_PAGE" )					-- ?????????????
	this : RegisterEvent( "DELETE_PET" )							-- ??????????
	this : RegisterEvent( "OBJECT_CARED_EVENT" )			-- ?? NPC ??????
	this : RegisterEvent( "UNIT_MONEY" );
	this : RegisterEvent( "MONEYJZ_CHANGE" )					--???? Vega
	this : RegisterEvent( "OPEN_EXCHANGE_FRAME" );		--??????
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this : RegisterEvent("QUICKUP_PET_SENDMSG",true)				--????
end

function PetSavvyGGD_OnLoad()
	PetSavvyGGD_Clear()
	 g_PetSavvyGGD_Frame_UnifiedPosition=PetSavvyGGD_Frame:GetProperty("UnifiedPosition");
end


function PetSavvyGGD_OK_Clicked()
	-- Ê×ÏÈÅÐ¶¨Íæ¼ÒÊÇ·ñ·ÅÈëÐèÒªÌáÉýµÄ äÊÞ£¬Èç¹ûÃ»ÓÐ·ÅÈëNPC½«»áµ¯³ö¶Ô»°²¢·µ»Ø£º
	if mainPet.idx == -1 then
	-- Çë·ÅÈëÄúÒªÌáÉýÎòÐÔµÈ¼¶µÄ äÊÞ¡£
		ShowSystemTipInfo( "Nh§p Trân Thú c¥n tång c¤p ngµ tính." )
		return
	end

	-- ÅÐ¶¨Íæ¼ÒµÄ½ðÇ®ÊÇ·ñ×ã¹»£¬Èç¹û²»¹»½«»áµ¯³ö¶Ô»°¡£
	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end	

	-- ÄúµÄ½ðÇ®²»×ã£¬ÇëÈ·ÈÏ
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--???? Vega
	if selfMoney < cost then
		ShowSystemTipInfo( "Ngân lßþng không ðü, hãy xác nh§n." )
		return
	end
	
	--¼ì²é¸ù¹Çµ¤
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local nItemIdGenGuDanBind = 0; --??????
	local msgTemp;
	
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "Th¤p";
		nItemIdGenGuDan = 30502000;
		nItemIdGenGuDanBind = 30504038;
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "Trung"
		nItemIdGenGuDan = 30502001;
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "Cao"
		nItemIdGenGuDan = 30502002;
	elseif nSavvyNeed >= 11 and nSavvyNeed <= 15 then
		msgTemp = "Siêu"
		nItemIdGenGuDan = 30502004;
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	if(bExist <= 0 and nItemIdGenGuDanBind ~= 0) then
		bExist = IsItemExist( nItemIdGenGuDanBind );
	end
	
	if bExist <= 0 then
		local msg = "Nâng ngµ tính ðªn "..nSavvyNeed.." C¥n "..msgTemp.." c¤p Cån C¯t Ðan. ";
		PetSavvyGGD_GGD : SetText( msg );
		-- SetNotifyTip( msg );
		-- return;
	end
	
	-- ·¢ËÍ UI_Command ½øÐÐºÏ³É
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetSavvy" )
		Set_XSCRIPT_ScriptID( 800106 )
		Set_XSCRIPT_Parameter( 0, mainPet.guid.high )
		Set_XSCRIPT_Parameter( 1, mainPet.guid.low )	
		Set_XSCRIPT_Parameter( 2, g_PetSavvyGGD_YuanbaoPay )	
		Set_XSCRIPT_ParamCount( 3 )
	Send_XSCRIPT()
	
end

-- ¹Ø± ¡¢È¡Ïû
function PetSavvyGGD_Cancel_Clicked()
	this : Hide()
end

-- Ñ¡Ôñ äÊÞ
function PetSavvyGGD_SelectPet( petIdx )
	if -1 == petIdx then
		return
	end
	
	-- äÊÞÒÑ±»ÆäËü½çÃæÑ¡ÖÐ
	if (Pet:GetPetLocation(petIdx) ~= -1) then
		return;
	end
	
	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )


	-- Èç¹ûÔ­À´ÒÑ¾­Ñ¡ÔñÁËÒ»¸ö±»ÌáÉýµÄ³è
	-- ÔòÇå¿ Ô­À´µÄÊý¾Ý
	PetSavvyGGD_RemoveMainPet()
	
	local savvy = Pet : GetSavvy( petIdx )
	local nGen = Pet:GetType(petIdx) ;
	
	if UI_TYPE == WX_10 then
		if savvy <=9 then
			-- ½« äÊÞÃû×ÖÌîµ½ÎÄ±¾¿òÖÐ
			PetSavvyGGD_Pet : SetText( petName )
			-- ¸ø äÊÞÉÏËø£¬ÉèÖÃ äÊÞÒÑ¾­Ìá½»µ½3ºÅ½çÃæÈÝÆ÷
			Pet : SetPetLocation( petIdx, 3 )
			-- ¸üÐÂ äÊÞÁÐ±í½çÃæ
			Pet:UpdatePetList()	
		else
			PetSavvyGGD_Pet : SetText( "" )
			PetSavvyGGD_GGD : SetText( "" )
			PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", 0 )
			PetSavvyGGD_Text2 : SetText( "Không th¬ tång" )
			PetSavvyGGD_OK:Disable();
			PetSavvyGGD_Quick:Disable()
			PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
			PetSavvyGGD_Quick_Up_Animate:Play(false)
			return
		end
	end

	if UI_TYPE == WX_15 then
		
		PetSavvyGGD_Pet : SetText( "" )
		PetSavvyGGD_GGD : SetText( "" )	
		PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", 0 )
		PetSavvyGGD_Text2 : SetText( "" )
		PetSavvyGGD_OK:Disable();
		PetSavvyGGD_Quick:Disable()
		PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
		PetSavvyGGD_Quick_Up_Animate:Play(false)
		
		--»Ã»¯ äÊÞ
		if nGen >= 100 then
			if savvy < 15 then
				if savvy >= 10 then
					-- ½« äÊÞÃû×ÖÌîµ½ÎÄ±¾¿òÖÐ
					PetSavvyGGD_Pet : SetText( petName )
					-- ¸ø äÊÞÉÏËø£¬ÉèÖÃ äÊÞÒÑ¾­Ìá½»µ½3ºÅ½çÃæÈÝÆ÷
					Pet : SetPetLocation( petIdx, 3 )
					-- ¸üÐÂ äÊÞÁÐ±í½çÃæ
					Pet:UpdatePetList()
				else
					SetNotifyTip("#{RXZS_090804_26}")	--??=10?????????????????
					return
				end
			else
				--»Ã»¯ äÊÞÎòÐÔ´óÓÚ14¾Í²»ÄÜÔÙÌáÉýÁË....
				SetNotifyTip("#{RXZS_090804_27}")	--??????????15,?????????
				return
			end
		else
			--·Ç»Ã»¯ äÊÞ
			SetNotifyTip("#{RXZS_090804_25}")	--?????,???=10?????????????????
			return
		end
	end

	-- ¼ÇÂ¼¸Ã³èµÄÎ»ÖÃºÅ¡¢GUID
	mainPet.idx = petIdx
	mainPet.guid.high = guidH
	mainPet.guid.low = guidL
	
	--¸üÐÂ½ðÇ®ºÍ¼¸ÂÊÏÔÊ¾
	PetSavvyGGD_CalcSuccOdds()
	PetSavvyGGD_CalcCost()
	--¼ì²é ¸ú¹Ç µ¤
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local msgTemp;
	
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "Th¤p";		
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "Trung"		
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "Cao"		
	elseif nSavvyNeed >= 11 and nSavvyNeed <= 15 then
		msgTemp = "Siêu"		
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	
	if bExist <= 0 then
		local msg = "Nâng ngµ tính ðªn "..nSavvyNeed.." C¥n "..msgTemp.." c¤p Cån C¯t Ðan. ";
		PetSavvyGGD_GGD : SetText( msg );		
		return;
	end

end

function PetSavvyGGD_OnEvent(event)

	--PushDebugMessage("PetSavvyGGD : "..event);

	if event == "UI_COMMAND" and tonumber( arg0 ) == 19820425 then	-- ????
		if this : IsVisible() then									-- ??????,????
			return
		end
		UI_TYPE = WX_10
		PetSavvyGGD_Text:SetText("#{INTERFACE_XML_1030}")

		this : Show()
		PetSavvyGGD_Pet : SetText( "" )
		PetSavvyGGD_Text2 : SetText( "" )
		PetSavvyGGD_NeedMoney:SetProperty("MoneyNumber", tostring(0));
		local npcObjId = Get_XParam_INT( 0 )
		BeginCareObject( npcObjId )
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		PetSavvyGGD_OK:Disable();
		PetSavvyGGD_Quick:Disable()
		PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
		PetSavvyGGD_Quick_Up_Animate:Play(false)
		if g_PetSavvyGGD_YuanbaoPay == 1 or g_PetSavvyGGD_YuanbaoPay == 0 then
			PetSavvyGGD_Blank_Queren:SetCheck(g_PetSavvyGGD_YuanbaoPay)
		end
		return
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 20090812 then
		if this : IsVisible() then									-- ??????,????
			return
		end
		UI_TYPE = WX_15
		PetSavvyGGD_Text:SetText("#{RXZS_XML_32}")

		this : Show()
		PetSavvyGGD_Pet : SetText( "" )
		PetSavvyGGD_Text2 : SetText( "" )
		PetSavvyGGD_NeedMoney:SetProperty("MoneyNumber", tostring(0));
		local npcObjId = Get_XParam_INT( 0 )
		BeginCareObject( npcObjId )
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		PetSavvyGGD_OK:Disable();
		PetSavvyGGD_Quick:Disable()
		PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
		PetSavvyGGD_Quick_Up_Animate:Play(false)
		if g_PetSavvyGGD_YuanbaoPay == 1 or g_PetSavvyGGD_YuanbaoPay == 0 then
			PetSavvyGGD_Blank_Queren:SetCheck(g_PetSavvyGGD_YuanbaoPay)
		end
		return

	end

	-- Íæ¼ÒÑ¡ÁËÒ»Ö» äÊÞ
	if ( event == "REPLY_MISSION_PET" and this:IsVisible() )then
		--PetSavvyGGD_GGD : SetText( "" );
		PetSavvyGGD_SelectPet( tonumber( arg0 ) )
	
		PetSavvyGGD_SelfMoney_Text:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	-- Íæ¼ÒÉíÉÏµÄ äÊÞÊý¾Ý·¢Éú±ä»¯£¬°üÀ¨ äÊÞ³ö ½¡¢ÐÝÏ¢¡¢Ôö¼ÓÒ»Ö» äÊÞ
	if event == "UPDATE_PET_PAGE" and this : IsVisible() then
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	-- Íæ¼ÒÉíÉÏ¼õÉÙÒ»Ö» äÊÞ
	if event == "DELETE_PET" and this : IsVisible() then
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	-- ¹ØÐÄ NPC µÄ´æÔÚºÍ·¶Î§
	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		Pet : ShowPetList( 0 )
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then			
			PetSavvyGGD_Cancel_Clicked()
		end
		return
	end

	if (event == "UNIT_MONEY" and this:IsVisible()) then
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end

	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
	
	-- ´ò¿ª½»Ò×½çÃæµÄÍ¬Ê±¹Ø± ¸Ã½çÃæ£¬µ«ÊÇÐèÒªË¢ÐÂÒ»ÏÂ äÊÞÁÐ±í
	if (event == "OPEN_EXCHANGE_FRAME" and this:IsVisible()) then
		StopCareObject()
		PetSavvyGGD_Clear()
		Pet : ShowPetList( 0 )
		Pet : ShowPetList( 1 )
		this:Hide()
	end
	
	 if (event == "ADJEST_UI_POS" ) then
		PetSavvyGGD_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSavvyGGD_Frame_On_ResetPos()
	end
		
	if (event == "QUICKUP_PET_SENDMSG") and (tonumber(arg0) == 1) then
		PetSavvyGGD_ExeScript()
	end
end

function PetSavvyGGD_Choose_Clicked( type )

	-- ¹ØÒ»ÏÂÔÙ¿ª£¬Çå¿ Êý¾Ý
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end


function PetSavvyGGD_Close()
	Pet : ShowPetList( 0 )
	StopCareObject()
	PetSavvyGGD_Clear()
end

function PetSavvyGGD_RemoveMainPet()
	if mainPet.idx ~= -1 then
		Pet : SetPetLocation( mainPet.idx, -1 )
		-- ¸üÐÂ äÊÞÁÐ±í½çÃæ
		Pet:UpdatePetList()
	end

	mainPet.idx = -1
	mainPet.guid.high = -1
	mainPet.guid.low = -1
end

function PetSavvyGGD_Clear()
	PetSavvyGGD_RemoveMainPet()
	PetSavvyGGD_GGD : SetText( "" );
	PetSavvyGGD_Pet : SetText( "" );
	PetSavvyGGD_Text2 : SetText( "#cFF0000Tï l® thành công" )
	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )

	PetSavvyGGD_OK : Disable()
	PetSavvyGGD_Quick:Disable()
	PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
	PetSavvyGGD_Quick_Up_Animate:Play(false)
	currentChoose = -1
end

-- ¼ÆËã³É¹¦ÂÊ
function PetSavvyGGD_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetSavvyGGD_Text2 : SetText( "#cFF0000Tï l® thành công" )
		PetSavvyGGD_OK : Disable()
		PetSavvyGGD_Quick:Disable()
		PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
		PetSavvyGGD_Quick_Up_Animate:Play(false)
		return
	end

	succOdds = {													-- ???????????
		[0] = 1000,
		[1] = 850,
		[2] = 750,
		[3] = 600,
		[4] = 200,
		[5] = 310,
		[6] = 310,
		[7] = 30,
		[8] = 70,
		[9] = 100,
		[10] = 30,
		[11] = 30,
		[12] = 30,
		[13] = 30,
		[14] = 30,

	}

	local savvy = Pet : GetSavvy( mainPet.idx )
	local str = "#cFF0000"
	local odds = succOdds[savvy]
	if not odds then
		str = "Không th¬ tång"
		PetSavvyGGD_OK : Disable()
		PetSavvyGGD_Quick:Disable()
		PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
		PetSavvyGGD_Quick_Up_Animate:Play(false)
	else
		str = str .. math.floor( odds / 10 ) .. "%"
		PetSavvyGGD_OK : Enable()
		PetSavvyGGD_Quick:Enable()
		PetSavvyGGD_Quick : SetText( "#{ZSKJT_130428_1}" )
		PetSavvyGGD_Quick_Up_Animate:Play(true)
	end

	PetSavvyGGD_Text2 : SetText( str )
end

-- ¼ÆËã½ðÇ®ÏûºÄ
function PetSavvyGGD_CalcCost()
	if mainPet.idx == -1 then
		PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end

	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( cost ) )
end


function PetSavvyGGD_UpdateSelected()
	
	-- ÅÐ¶Ï±»Ñ¡ÖÐµÄ äÊÞÊÇ·ñ»¹ÔÚ±³°üÀï
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( mainPet.guid.high, mainPet.guid.low )
		Pet : SetPetLocation( mainPet.idx, -1 )
		-- Èç¹û²»ÔÚÔòÉ¾µô
		if newIdx == -1 then
			mainPet.idx = -1
			mainPet.guid.high = -1
			mainPet.guid.low = -1
			PetSavvyGGD_Pet : SetText( "" )
			PetSavvyGGD_Text2 : SetText( "#cFF0000Tï l® thành công" )
			PetSavvyGGD_OK : Disable()
			PetSavvyGGD_Quick:Disable()
			PetSavvyGGD_Quick:SetText( "#{ZSKJT_130507_1}" )
			PetSavvyGGD_Quick_Up_Animate:Play(false)
		-- ·ñÔòÅÐ¶Ï äÊÞµÄÎ»ÖÃÊÇ·ñ·¢Éú±ä»¯
		elseif newIdx ~= mainPet.idx then
			-- Èç¹û·¢Éú±ä»¯Ôò¶ÔÎ»ÖÃ½øÐÐ¸üÐÂ
			mainPet.idx = newIdx
		end
	end

	PetSavvyGGD_SelectPet( mainPet.idx );

end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	if theNPC == -1 then
		PushDebugMessage("Chßa phát hi®n NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "PetSavvyGGD" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject()
	this : CareObject( theNPC, 0, "PetSavvyGGD" )
	Pet : ShowPetList( 0 )
	theNPC = -1
end


function PetSavvyGGD_Frame_On_ResetPos()
  PetSavvyGGD_Frame:SetProperty("UnifiedPosition", g_PetSavvyGGD_Frame_UnifiedPosition);
end



--¿ì½ÝÌáÉý°´Å¥°´ÏÂ---
function PetSavvyGGD_Quick_Up_Clicked()
	if PetSavvyGGD_check() == 0 then 
	
		local savvy = Pet : GetSavvy( mainPet.idx )	
		local petName = Pet : GetPetList_Appoint( mainPet.idx )
		local cost = YuanBaoCosts[savvy]
		--µ¯³öÈ·ÈÏ¿ò
		PushEvent("QUICKUP_PET_CONFIRM", 1, tonumber(savvy), tonumber(cost),0, tostring(petName))

	end
end

-- ¿ì½ÝÌáÉýµÄÌõ¼þÅÐ¶Ï
function PetSavvyGGD_check()
	--15¼¶ÅÐ¶Ï
	local mylevel = Player:GetData("LEVEL");
	if mylevel < 15 then
		PushDebugMessage("#{ZSKJT_130717_01}")
		return 1
	end
	--ÔÝÊ±Ã»ÓÐ°²È«ÊÂ¼þºÍÃÜ±£µÄapi

	--Íæ¼Òµ±Ç°ÊÇ·ñÒÑ¾­Ñ¡ÔñÁËÒ»Ö» äÊÞ
	if mainPet.idx == -1 then
		PushDebugMessage("#{ZSKJT_130428_3}")
		return 1
	end

	--µ±Ç°ËùÑ¡ÔñµÄ äÊÞÊÇ·ñ´¦ÓÚËø¶¨×´Ì¬
	if (Pet:IsProtect(mainPet.idx) == 1) then
		PushDebugMessage("#{ZSKSSJ_081113_06}")
		return 1
	end

	--µ±Ç°ËùÑ¡ÔñµÄ äÊÞÊÇ·ñ´¦ÓÚ³ö ½×´Ì¬
	local petname,status = Pet:GetPetList_Appoint(mainPet.idx)
	if (status == "on_fight") then
		PushDebugMessage("#{ZSKJT_130428_23}")
		return 1
	end
	--µ±Ç°ËùÑ¡Ôñ äÊÞµÄÎòÐÔÊÇ·ñÐ¡ÓÚ10
	local savvy = Pet : GetSavvy( mainPet.idx )
	if savvy >= 10 then 
		PushDebugMessage("#{ZSKJT_130428_4}")
		return 1
	end

	return 0
end

function PetSavvyGGD_ExeScript()	
	if PetSavvyGGD_check() == 0 then 
		-- PushDebugMessage("text xtcc")
		-- -- ·¢ËÍ UI_Command ½øÐÐºÏ³É
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "QuickPetSavvy" )
			Set_XSCRIPT_ScriptID( 800106 )
			Set_XSCRIPT_Parameter( 0, mainPet.guid.high )
			Set_XSCRIPT_Parameter( 1, mainPet.guid.low )	
			Set_XSCRIPT_ParamCount( 2 )
		Send_XSCRIPT()
	end
	
end

function PetSavvyGGD_Blank_Queren_Clicked() 
	g_PetSavvyGGD_YuanbaoPay = PetSavvyGGD_Blank_Queren:GetCheck();
end
