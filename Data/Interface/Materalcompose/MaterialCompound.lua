--/* modified by cuiyinjie ¿ª·Å4¼¶Èı¾«ºÏ³É¹¦ÄÜ */
local STUFF_SLOTS = {}										-- ???
local ITEM_IN_SLOTS = {}									-- ???????????
local Current = 0											-- ??????? 1:???? 2:???? 3: ????
local Type = -1												-- ?????????
local Grade = -1											-- ?????????
local theNPC = -1											-- ?? NPC
local MATERIAL_COUNT = 5									-- ??????????
local SLOT_COUNT = 6										-- ???????????
local SPECIAL_MATERIAL_SLOT = 6								-- ?????????
local MAX_OBJ_DISTANCE = 3.0

local LaskPack = {}

local curSuccRate = 0;
local RuleTable = {
	{
		msgDiffTypeErr = "Bäo thÕch cùng loÕi m¾i có th¬ ghép.",
		msgDiffGradeErr = "Chï ğßşc ghép bäo thÕch ngang c¤p",
		msgLackMoney = "Tài nguyên không ğü #{_EXCHG%d}. ",
		msgLackStuff = "V§t ph¦m ghép m²i l¥n phäi l¾n h½n 2.",
		msgSlotEmpty = "Hãy ğ£t Bäo ThÕch c¥n ghép vào.",         -- add  by zchw
		maxGrade = 9,
		msgGradeLimited = "Bäo thÕch cao nh¤t là Lv9, không th¬ ghép næa.",
		[1] = { SpecialStuff = 30900015, MoneyCost = 5000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[2] = { SpecialStuff = 30900015, MoneyCost = 6000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[3] = { SpecialStuff = 30900015, MoneyCost = 7000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[4] = { SpecialStuff = 30900016, MoneyCost = 8000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[5] = { SpecialStuff = 30900016, MoneyCost = 9000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[6] = { SpecialStuff = 30900016, MoneyCost = 10000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[7] = { SpecialStuff = 30900016, MoneyCost = 11000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[8] = { SpecialStuff = 30900016, MoneyCost = 12000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	},
	{
		msgDiffTypeErr = "Nguyên li®u cùng loÕi m¾i ğßşc ghép.",
		msgDiffGradeErr = "Nguyên li®u cùng c¤p m¾i ğßşc ghép.",
		msgLackMoney = "Tài nguyên không ğü #{_EXCHG%d}. ",
		msgLackStuff = "V§t ph¦m ghép m²i l¥n phäi l¾n h½n 2.",
		msgSlotEmpty = "Hãy ğßa nguyên li®u c¥n ghép vào.",				-- add by zchw
		maxGrade = 5,	-- ???????,3????4?,?????5? mark by cuiyinjie maxGrade add 1
		msgGradeLimited = "T¯i ğa ğ£t vào nguyên li®u Lv3, nguyên li®u cüa các hÕ không th¬ tiªp tøc ghép.", --µÈ¼¶¼Ó1¼¶
		[1] = { SpecialStuff = -1, MoneyCost = 500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[2] = { SpecialStuff = -1, MoneyCost = 1000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[3] = { SpecialStuff = -1, MoneyCost = 1500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[4] = { SpecialStuff = -1, MoneyCost = 5000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, }, -- modify by cuiyinjie cost 20yin -> cost 50yin
--		[5] = { SpecialStuff = -1, MoneyCost = 2500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[6] = { SpecialStuff = -1, MoneyCost = 3000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[7] = { SpecialStuff = -1, MoneyCost = 3500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[8] = { SpecialStuff = -1, MoneyCost = 4000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
	},
	{
		msgDiffTypeErr = "C¥n phäi sØ døng Huy«n Thiên Hàn Ng÷c ğ¬ ghép.",
		msgDiffGradeErr = "C¥n phäi sØ døng cùng mµt loÕi Huy«n Thiên Hàn Ng÷c ğ¬ ghép.",
		msgLackMoney = "Tài nguyên không ğü #{_EXCHG%d}. ",
		msgLackStuff = "V§t ph¦m ghép m²i l¥n phäi l¾n h½n 2.",
		msgSlotEmpty = "Hãy ğßa Huy«n Thiên Hàn Ng÷c c¥n ghép vào.",
		maxGrade = 2,
		msgGradeLimited = "C¥n ğ£t vào cùng mµt loÕi Huy«n Thiên Hàn Ng÷c, Huy«n Thiên Hàn Ng÷c cüa bÕn không th¬ ghép.",
		[1] = { SpecialStuff = -1, MoneyCost = 10000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[2] = { SpecialStuff = -1, MoneyCost = 1000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[3] = { SpecialStuff = -1, MoneyCost = 1500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[4] = { SpecialStuff = -1, MoneyCost = 2000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[5] = { SpecialStuff = -1, MoneyCost = 2500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[6] = { SpecialStuff = -1, MoneyCost = 3000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[7] = { SpecialStuff = -1, MoneyCost = 3500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[8] = { SpecialStuff = -1, MoneyCost = 4000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
	},
}

local g_MaterialCompound_Frame_UnifiedPosition;

-- ×¢²áÊÂ¼ş
function MaterialCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")						-- ??????

	this:RegisterEvent("UPDATE_COMPOSE_GEM")				-- ????????
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")				-- ???????????……
	this:RegisterEvent("OBJECT_CARED_EVENT")				-- ??????? NPC
	this:RegisterEvent("RESUME_ENCHASE_GEM")				-- ????
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE")			-- ?????
	-- this:RegisterEvent("TOGLE_SKILL_BOOK")				-- ´ò¿ªÃÅÅÉ¼¼ÄÜ½çÃæÊÇ·ñĞèÒª¹Ø± ´Ë½çÃæ
	-- this:RegisterEvent("TOGLE_COMMONSKILL_PAGE")			-- ´ò¿ªÆ Í¨¼¼ÄÜ½çÃæÊÇ·ñĞèÒª¹Ø± £¿
	-- this:RegisterEvent("CLOSE_SKILL_BOOK")				-- ¹Ø± ÃÅÅÉ¼¼ÄÜ½çÃæ
	-- this:RegisterEvent("DISABLE_ENCHASE_ALL_GEM")		-- ËùÓĞºÏ³ÉÏà¹ØµÄÎïÆ·ĞèÒªËø¶¨
	-- this:RegisterEvent("UPDATE_COMPOSE_ITEM")			-- ÎïÆ·ºÏ³É½çÃæ´ò¿ª£¬´Ë½çÃæÊÇ·ñĞèÒª¹Ø± £¿
	-- this:RegisterEvent("OPEN_COMPOSE_ITEM")				-- ÎïÆ·ºÏ³É½çÃæ´ò¿ª£¬´Ë½çÃæÊÇ·ñĞèÒª¹Ø± £¿
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--???? Vega
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

-- ½çÃæÔØÈë
function MaterialCompound_OnLoad()
	STUFF_SLOTS[1] = Materalcompose_Space1
	STUFF_SLOTS[2] = Materalcompose_Space2
	STUFF_SLOTS[3] = Materalcompose_Space3
	STUFF_SLOTS[4] = Materalcompose_Space4
	STUFF_SLOTS[5] = Materalcompose_Space5
	STUFF_SLOTS[6] = Materalcompose_Special_Button

	ITEM_IN_SLOTS[1] = -1
	ITEM_IN_SLOTS[2] = -1
	ITEM_IN_SLOTS[3] = -1
	ITEM_IN_SLOTS[4] = -1
	ITEM_IN_SLOTS[5] = -1
	ITEM_IN_SLOTS[6] = -1

	LaskPack[1] = -1
	LaskPack[2] = -1
	LaskPack[3] = -1
	LaskPack[4] = -1
	LaskPack[5] = -1
	LaskPack[6] = -1
	
	 g_MaterialCompound_Frame_UnifiedPosition=Materalcompose_Frame:GetProperty("UnifiedPosition");
	 
end

-- ¼à¿Ø¸÷ÖÖÊÂ¼ş
function MaterialCompound_OnEvent( event )

	if event == "UI_COMMAND" and tonumber( arg0 ) == 19810424 then	-- ????
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 2 then				-- ??????,???
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000Tï l® thành công");
		Current = 2
		Materalcompose_DragTitle : SetText("#gFF0FA0Ghép nguyên li®u")
		MaterialCompose_Info : SetText("Có th¬ dùng Miên B¯, Bí Ngân, Tinh Thiªt ğ¬ tång c¤p ghép. (#GC¥n 5 nguyên li®u ghép#Y)")
		Materalcompose_Static1 : Hide()
		Materalcompose_Special : Hide()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UI_COMMAND" and tonumber( arg0 ) == 86021935 then	-- ????
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 3 then				-- ??????,???
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000Tï l® thành công");
		Current = 3
		Materalcompose_DragTitle : SetText("#gFF0FA0Ghép Hàn Ng÷c")
		MaterialCompose_Info : SetText("Có th¬ dùng 5 viên Huy«n Thiên Hàn Ng÷c ghép 1 Hàn Ng÷c Tinh Túy (#GC¥n 5 cái ğ¬ ghép nguyên li®u Huy«n Thiên Hàn Ng÷c#Y)")
		Materalcompose_Static1 : Hide()
		Materalcompose_Special : Hide()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ı£¬×Ô¶¯¹Ø± 
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			MaterialCompound_Cancel_Clicked()
		end
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_COMPOSE_GEM" and this : IsVisible() then
		MaterialCompound_Update( arg0, arg1 )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "PACKAGE_ITEM_CHANGED" and this : IsVisible() then
		if not arg0 or tonumber( arg0 ) == -1 then
			return
		end

		for i = 1, SLOT_COUNT do
			if ITEM_IN_SLOTS[i] == tonumber( arg0 ) then
				MaterialCompound_Remove( i )
				break
			end
		end
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "RESUME_ENCHASE_GEM" and this : IsVisible() then
		if arg0 then
			MaterialCompound_Remove( tonumber( arg0 ) - 6 )
		end

		return
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end

	if event == "CLOSE_SYNTHESIZE_ENCHASE" and this : IsVisible() then
		MaterialCompound_Cancel_Clicked()
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
	
	if (event == "ADJEST_UI_POS" ) then
		MaterialCompound_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		MaterialCompound_Frame_On_ResetPos()
		end
		
end

-- µã»÷ºÏ³É°´Å¥
function MaterialCompound_OK_Clicked()
	-- ¸ù¾İµ±Ç°Ëù´¦µÄ½çÃæ½øĞĞ¼ì²é
	local Notify = 0;
	local CurrentRule = RuleTable[Current]
	if not CurrentRule then
		return
	end

	--¼ì²é°ó¶¨×´Ì¬
	--ÏÂÃæ âÒ»¶ÎÊÇ²ÄÁÏ°ó¶¨ÌáÊ¾£¬ ÅÄşĞ´µÄÓĞbug£¬È«²¿×¢µô£¬²ÉÓÃĞÂµÄÂß¼­
--		for i = 1, MATERIAL_COUNT do

--			if(LaskPack[i] ~= ITEM_IN_SLOTS[i]) then

--				LaskPack[i] = ITEM_IN_SLOTS[i];
--				Notify = 1;

--			end

--		end

--		if(Notify == 1) then

--			for i = 1, MATERIAL_COUNT do

--				if(ITEM_IN_SLOTS[i] == -1) then

--					continue

--				end

--				if(MaterialCompound_IsBind(ITEM_IN_SLOTS[i]) == 1) then
				--¼ì²éÓĞÃ»ÓĞ°ó¶¨µÄÎïÆ·
--					ShowSystemInfo("BSHE_20070924_001");
--					return;

--				end

--			end

--		end

	local materialCount = 0

	-- add by zchw
	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] ~= -1 then
			Grade = MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] );
			break;
		end
	end
	if Grade == -1 then
		PushDebugMessage( CurrentRule.msgSlotEmpty )
		return
	end
	-- end of zchw

	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] == -1 then
			continue
		end
		materialCount = materialCount + 1

		-- ¼ì²éÊÇ·ñ¶¼ÊÇÍ¬ÖÖ²ÄÁÏ
		if MaterialCompound_ItemInterface( ITEM_IN_SLOTS[i] ) ~= Current then
			PushDebugMessage( CurrentRule.msgDiffTypeErr )
			return
		end

		if Type ~= MaterialCompound_GetItemType( ITEM_IN_SLOTS[i] ) then
			PushDebugMessage( CurrentRule.msgDiffTypeErr )
			return
		end

		-- ¼ì²é²ÄÁÏÊÇ·ñµÈ¼¶ÏàÍ¬
		if not CurrentRule[Grade] or Grade ~= MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) then
			PushDebugMessage( CurrentRule.msgDiffGradeErr )
			return
		end

		-- ¼ì²é²ÄÁÏÊÇ·ñÊÇ×î¸ßµÈ¼¶
		if MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) >= RuleTable[Current].maxGrade then
			PushDebugMessage( CurrentRule.msgGradeLimited )
			return
		end
		--ºÏ³É8£¬9¼¶±¦Ê¯¹¦ÄÜ¹Ø± 
		if Current == 1 then
			if MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) > 6 then
				PushDebugMessage( "#{BSHC_090313_1}" )
				return
			end
		end
	end

	-- ¼ì²éÉíÉÏµÄ½ğÇ®ÊÇ·ñ×ã¹»
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < CurrentRule[Grade].MoneyCost then
		PushDebugMessage( string.format( CurrentRule.msgLackMoney, CurrentRule[Grade].MoneyCost ) )
		return
	end

	-- ¼ì²é²ÄÁÏÊıÁ¿ÊÇ·ñ×ã¹»
	if not CurrentRule[Grade].CountTable[materialCount] then
		PushDebugMessage( CurrentRule.msgLackStuff )
		return
	end

	-- Èç¹ûÊÇ±¦Ê¯ºÏ³É½çÃæ£¬ÔòÈç¹ûÃ»ÓĞ·ÅÈëÌØÊâ²ÄÁÏ½«¸ø³ö½çÃæÌáÊ¾
	if Current == 1 then
		if ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] and ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] == -1 then
--			local dialogStr = "Èç¹û²»Ê¹ÓÃ#{_ITEM" .. CurrentRule[Grade].SpecialStuff ..
--				"}½øĞĞºÏ³ÉµÄ»°£¬ºÏ³ÉµÄ³É¹¦ÂÊ×î¸ßÖ»ÓĞ75£¥£¬ÄúÊÇ·ñÈ·¶¨¼ÌĞøºÏ³É£¿"
--			LifeAbility : Do_Combine( ITEM_IN_SLOTS[1], ITEM_IN_SLOTS[2],
--				ITEM_IN_SLOTS[3], ITEM_IN_SLOTS[4],
--				ITEM_IN_SLOTS[5], ITEM_IN_SLOTS[6], 0, dialogStr )
			PushDebugMessage( "Ghép bäo thÕch c¥n ğ£t Bùa Ghép Bäo ThÕch." )
			return
		end
	end

	LifeAbility : Do_Combine( ITEM_IN_SLOTS[1], ITEM_IN_SLOTS[2],
		ITEM_IN_SLOTS[3], ITEM_IN_SLOTS[4],
		ITEM_IN_SLOTS[5], ITEM_IN_SLOTS[6],(curSuccRate.."%") )
end

-- µã»÷È¡Ïû»ò ß¹Ø± °´Å¥
function MaterialCompound_Cancel_Clicked()
	MaterialCompound_Close()
	MaterialCompound_StopCareObject()
end

-- ¹Ø± ½çÃæ
function MaterialCompound_Close()
	this : Hide()
	MaterialCompound_Clear()
end

-- Çå¿ ½çÃæÔªËØ
function MaterialCompound_Clear()
	Current = 0
	Type = -1
	Grade = -1
	Materalcompose_SuccessValue : SetText("#cFF0000Tï l® thành công")
	Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
	Materalcompose_OK : Disable()

	for i = 1, SLOT_COUNT do
		STUFF_SLOTS[i] : SetActionItem(-1)

		if ITEM_IN_SLOTS[i] ~= -1 then
			LifeAbility : Lock_Packet_Item( ITEM_IN_SLOTS[i], 0 )
		end

		STUFF_SLOTS[i] : Enable()
		ITEM_IN_SLOTS[i] = -1
	end
	LifeAbility:ClearComposeItems();
	LaskPack[1] = -1
	LaskPack[2] = -1
	LaskPack[3] = -1
	LaskPack[4] = -1
	LaskPack[5] = -1
	LaskPack[6] = -1
end

-- ÅĞ¶ÏÄ³¸ö±³°ü¸ñ×ÓÖĞµÄÎïÆ·ÊÇ·ñ±¦Ê¯
function MaterialCompound_IsGem( bagPos )
	if PlayerPackage : IsGem( bagPos ) == 1 then
		return 1
	else
		return 0
	end
end

-- ÅĞ¶ÏÄ³¸ö±³°ü¸ñ×ÓÖĞµÄÎïÆ·ÊÇ·ñ²ÄÁÏ
function MaterialCompound_IsMaterial( bagPos )
	--local MatIdentifier = PlayerPackage : GetItemSubTableIndex( bagPos, 0 ) * 10000000 + PlayerPackage : GetItemSubTableIndex( bagPos, 1 )*100000 + PlayerPackage : GetItemSubTableIndex( bagPos, 2 )*1000 + PlayerPackage : GetItemSubTableIndex( bagPos, 3 )
	local itemId = PlayerPackage:GetItemTableIndex(bagPos)
	if itemId >= 20500000 and itemId <= 20500008 then
		return 1
	end

	if itemId >= 20501000 and itemId <= 20501008 then
		return 1
	end

	if itemId >= 20502000 and itemId <= 20502008 then
		return 1
	end

	return 0

end

-- µÃµ½Ä³¸ö±³°ü¸ñ×ÓÖĞµÄÎïÆ·µÄÀàĞÍ
function MaterialCompound_GetItemType( bagPos )
	if MaterialCompound_IsGem( bagPos ) == 1 then
		return ( PlayerPackage : GetItemSubTableIndex( bagPos, 2 ) * 1000 + PlayerPackage : GetItemSubTableIndex( bagPos, 3 ) )
	elseif MaterialCompound_IsMaterial( bagPos ) == 1 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 2 )
	elseif PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 2 )
	end

	return -1
end

-- µÃµ½Ä³¸ö±³°ü¸ñ×ÓÖĞµÄÎïÆ·µÄµÈ¼¶
function MaterialCompound_GetItemGrade( bagPos )
	if MaterialCompound_IsGem( bagPos ) == 1 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 1 )
	elseif MaterialCompound_IsMaterial( bagPos ) == 1 then
		return PlayerPackage : GetItemGrade( bagPos )
	elseif PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		return PlayerPackage : GetItemGrade( bagPos )
	end

	return PlayerPackage : GetItemGrade( bagPos )
end

-- µÃµ½µ±Ç°½çÃæÓ¦¸ÃÆ¥ÅäµÄÌØÊâ²ÄÁÏºÅ
-- Èç¹û²»ÊÇ±¦Ê¯½çÃæÔò·µ»Ø -1
-- Èç¹ûÊÇ±¦Ê¯½çÃæµ«ÊÇ»¹Ã»ÓĞ·ÅÈÎºÎ±¦Ê¯Ôò·µ»Ø -1
function MaterialCompound_GetSpecialMaterial()
	local CurrentRule = RuleTable[Current]
	if CurrentRule then
		if CurrentRule[Grade] then
			return CurrentRule[Grade].SpecialStuff
		end
	end

	return -1
end

-- ÅĞ¶ÏÄ³¸ö±³°ü¸ñ×ÓÖĞµÄÎïÆ·ÊôÓÚÄÇ¸ö½çÃæ£¬Æ¥Åä Current£¬Ã»ÓĞÆ¥ÅäµÄÓÃ 0
-- ½çÃæµÄµ±Ç°×´Ì¬ 1£º±¦Ê¯ºÏ³É 2£º²ÄÁÏºÏ³É
function MaterialCompound_ItemInterface( bagPos )
	if Current == 1 then
		if MaterialCompound_IsGem( bagPos ) == 1 then
			return Current
		end

		if PlayerPackage : GetItemTableIndex( bagPos ) == MaterialCompound_GetSpecialMaterial() then
			return Current
		end
	elseif Current == 2 then
		if MaterialCompound_IsMaterial( bagPos ) == 1 then
			return Current
		end
	elseif Current == 3 then
		if(PlayerPackage:GetItemTableIndex(bagPos)==20310110)then
			return Current
		end
	end

	return 0
end

-- Ë¢ĞÂºÏ³É½çÃæÉÏµÄÎïÆ·
function MaterialCompound_Update( pos0, pos1 )
	local slot = tonumber( pos0 )
	local bagPos = tonumber( pos1 )

	-- AxTrace( 0, 1, "Current=".. Current )
	-- AxTrace( 0, 1, "slot=".. slot )
	-- AxTrace( 0, 1, "bagPos=".. bagPos )
	local CurrentRule = RuleTable[Current]
	if not CurrentRule then
		return
	end

	if not this : IsVisible() then					-- ?????
		return
	end

	-- ÑéÖ¤ÎïÆ·ÓĞĞ§ĞÔ
	local bagItem = EnumAction( bagPos, "packageitem" )
	if bagItem : GetID() == 0 then
		return
	end

	-- AxTrace( 0, 1, "MaterialCompound_ItemInterface( bagPos )=".. MaterialCompound_ItemInterface( bagPos ) )
	--  Òµ½ bagPos µÄÎïÆ·ÀàĞÍ£¬À´ÅĞ¶ÏÊÇ·ñ·ûºÏµ±Ç°½çÃæ£¬·ñÔòÃ»ÓĞÈÎºÎÌáÊ¾
	if MaterialCompound_ItemInterface( bagPos ) ~= Current then
		PushDebugMessage( "LoÕi nguyên li®u không phù hşp" )
		return
	end

	-- Èç¹û bagPos ÊÇµ±Ç°½çÃæĞèÒªµÄÎïÆ·£¬ Òµ½¸ÃÎïÆ·Ó¦¸Ã´¦ÔÚµÄ¸ñ×Ó·¶Î§
	-- Èç¹ûÊÇ±¦Ê¯»ò ß²ÄÁÏ
	if MaterialCompound_IsGem( bagPos ) == 1 or MaterialCompound_IsMaterial( bagPos ) == 1 or PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		-- AxTrace( 0, 1, "it's a main material." )
		-- ÅĞ¶ÏÒ»ÏÂÊÇ·ñÀàĞÍÏàÍ¬£¬²»ÏàÍ¬¸ø³öÌáÊ¾
		if Type ~= -1 then
			if Type ~= MaterialCompound_GetItemType( bagPos ) then
				PushDebugMessage( CurrentRule.msgDiffTypeErr )
				return
			end
		end

		-- ÅĞ¶ÏÒ»ÏÂÊÇ·ñµµ´ÎÏàÍ¬£¬Èç¹û²»ÏàÍ¬¸ø³öÌáÊ¾
		if Grade ~= -1 then
			if Grade ~= MaterialCompound_GetItemGrade( bagPos ) then
				PushDebugMessage( CurrentRule.msgDiffGradeErr )
				return
			end
		elseif MaterialCompound_GetItemGrade( bagPos ) >= RuleTable[Current].maxGrade then
			PushDebugMessage( CurrentRule.msgGradeLimited )
			return
		end

		if slot == 0 then						-- ??????
			-- ´Ó 1 ~ MATERIAL_COUNT Ö®¼ä ÒÒ»¸ö¿ ×ÅµÄ¸ñ×Ó£¬Èç¹ûÃ»ÓĞ¿ ¸ñ×ÓÁË£¬Ôò·µ»Ø
			for i = 1, MATERIAL_COUNT do
				if ITEM_IN_SLOTS[i] == -1 then
					slot = i
					break
				end
			end

			-- AxTrace( 0, 1, "slot=".. slot )

			if slot == 0 then
				return
			end
		else
			-- ÅĞ¶Ï bagPos ÊÇ·ñÓ¦¸Ã´¦ÔÚ â¸ö¸ñ×Ó£¬¸ñ×Ó²»¶ÔÔòÖ±½Ó·µ»Ø
			if slot < 1 or slot > MATERIAL_COUNT then
				return
			end
		end
	-- Èç¹ûÊÇÌØÊâ²ÄÁÏ
	elseif PlayerPackage : GetItemTableIndex( bagPos ) == MaterialCompound_GetSpecialMaterial() then
		-- AxTrace( 0, 1, "it's a special material." )
		if slot == 0 then						-- ??????
			-- ¿´¿´µÚ SPECIAL_MATERIAL_SLOT ¸ö¸ñ×ÓÊÇ·ñ¿ ×ÅµÄ¸ñ×Ó£¬Èç¹û²»ÊÇ£¬Ôò·µ»Ø
			if ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] and ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] == -1 then
				slot = SPECIAL_MATERIAL_SLOT
			else
				return
			end
		else
			-- ÅĞ¶Ï bagPos ÊÇ·ñÓ¦¸Ã´¦ÔÚ â¸ö¸ñ×Ó£¬¸ñ×Ó²»¶ÔÔòÖ±½Ó·µ»Ø
			if slot ~= SPECIAL_MATERIAL_SLOT then
				PushDebugMessage( "Hãy ğ£t vào ô nguyên li®u ğ£c thù." )
				return
			end
		end
	end

	-- AxTrace( 0, 1, "ITEM_IN_SLOTS[slot]=".. ITEM_IN_SLOTS[slot] )
	-- °ÑÎïÆ··Åµ½¸ñ×ÓÉÏ
	-- Èç¹ûÔ­À´µÄ¸ñ×ÓÓĞÎïÆ·£¬ÔòÒÆ³ıÔ­À´µÄÎïÆ·
	if ITEM_IN_SLOTS[slot] ~= -1 then
		MaterialCompound_Remove( slot )
	end

	-- ½«±¾ÎïÆ··Åµ½ÎïÆ·¸ñ£¬²¢Ëø¶¨ËùÔÚµÄ±³°ü¸ñ
	STUFF_SLOTS[slot] : SetActionItem( bagItem : GetID() )
	ITEM_IN_SLOTS[slot] = bagPos
	LifeAbility : Lock_Packet_Item( bagPos, 1 )

	if Type == -1 then
		Type = MaterialCompound_GetItemType( bagPos )
	end

	if Grade == -1 then
		Grade = MaterialCompound_GetItemGrade( bagPos )
	end

	-- ¸üĞÂ½çÃæµÄ³É¹¦ÂÊÏÔÊ¾
	MaterialCompound_RecalcSuccOdds()

	-- Èç¹ûÎïÆ·²»ÊÇÌØÊâ²ÄÁÏ£¬²¢ÇÒµ±Ç°µÄÀàĞÍºÍµµ´Î¶¼ÊÇ -1£¬Ôò¸ù¾İ¸ÃÎïÆ·½øĞĞÏàÓ¦ÉèÖÃ£¬²¢¾İ´ËÏÔÊ¾½ğÇ®ÏûºÄ
	if PlayerPackage : GetItemTableIndex( bagPos ) ~= MaterialCompound_GetSpecialMaterial() then
		MaterialCompound_RecalcCost()
	end
end

-- ÒÆ³ıÒ»¸ö²ÄÁÏ
function MaterialCompound_Remove( slot )
	if not this : IsVisible() then
		return
	end

	if slot < 1 or slot > SLOT_COUNT then
		return
	end

	if ITEM_IN_SLOTS[slot] == -1 then
		return
	end

	STUFF_SLOTS[slot] : SetActionItem( -1 )
	LifeAbility : Lock_Packet_Item( ITEM_IN_SLOTS[slot], 0 )
	ITEM_IN_SLOTS[slot] = -1

	if slot >= 1 and slot <= MATERIAL_COUNT then
		local materialCount = 0

		for i = 1, MATERIAL_COUNT do
			if ITEM_IN_SLOTS[i] ~= -1 then
				materialCount = materialCount + 1
			end
		end

		if materialCount == 0 then					-- ????????????
			Type = -1
			Grade = -1
			MaterialCompound_Remove( SPECIAL_MATERIAL_SLOT )
		end

		MaterialCompound_RecalcSuccOdds()
		MaterialCompound_RecalcCost()
	elseif slot == SPECIAL_MATERIAL_SLOT then
		MaterialCompound_RecalcSuccOdds()
	end
end

-- ÖØĞÂ¼ÆËã³É¹¦ÂÊ
function MaterialCompound_RecalcSuccOdds()
	if not RuleTable[Current] or not RuleTable[Current][Grade] then
		Materalcompose_SuccessValue : SetText("#cFF0000Tï l® thành công")
		Materalcompose_OK : Disable()
		return
	end

	local currentRule = RuleTable[Current][Grade]
	local materialCount = 0

	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] ~= -1 then
			materialCount = materialCount + 1
		end
	end

	-- AxTrace( 0, 1, "materialCount=".. materialCount )
	local str = "#cFF0000Tï l® thành công: "

	if not currentRule.CountTable[materialCount] then
		curSuccRate = 0;
		str = str .. "Không th¬ ghép"
		Materalcompose_OK : Disable()
	elseif ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] ~= -1
	 and currentRule.SpecialStuff == PlayerPackage : GetItemTableIndex( ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] )
	then
		-- AxTrace( 0, 1, "SuccOddsWithSpecStuff=".. currentRule.CountTable[materialCount].SuccOddsWithSpecStuff )
		str = str .. currentRule.CountTable[materialCount].SuccOddsWithSpecStuff .. "%"
		curSuccRate = currentRule.CountTable[materialCount].SuccOddsWithSpecStuff;
		Materalcompose_OK : Enable()
	else
		-- AxTrace( 0, 1, "SuccOdds=".. currentRule.CountTable[materialCount].SuccOdds )
		str = str .. currentRule.CountTable[materialCount].SuccOdds .. "%"
		curSuccRate = currentRule.CountTable[materialCount].SuccOdds;
		Materalcompose_OK : Enable()
	end

	Materalcompose_SuccessValue : SetText( str )
end

-- ÖØĞÂ¼ÆËã½ğÇ®ÏûºÄ
function MaterialCompound_RecalcCost()
	if not RuleTable[Current] or not RuleTable[Current][Grade] then
		Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( RuleTable[Current][Grade].MoneyCost ) )
end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC£¬
--ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
--Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function MaterialCompound_BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		PushDebugMessage("Chßa phát hi®n NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "MaterialCompound" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function MaterialCompound_StopCareObject()
	this : CareObject( theNPC, 0, "MaterialCompound" )
	theNPC = -1
end

function MaterialCompound_IsBind( ItemID )

	if(GetItemBindStatus(ItemID, 0) == 1) then

		return 1;

	else

		return 0;

	end

end

function Materalcompose_Help_Clicked()
	Helper:GotoHelper("*MaterialCompound")
end

function MaterialCompound_Frame_On_ResetPos()
  Materalcompose_Frame:SetProperty("UnifiedPosition", g_MaterialCompound_Frame_UnifiedPosition);
end
