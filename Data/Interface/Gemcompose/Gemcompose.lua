
local theNPC = -1											-- ?? NPC
local MAX_OBJ_DISTANCE = 3.0

local g_Gemcompose_YuanbaoPay = 1

local g_GemTableIndex = -1

local g_DummyGemLayed = 0
local g_DummyNewGem = 1

local RuleTable = {
	msgLackMoney = "Nhçm trên ngß¶i Ðích ti«n tài không ðü#{_EXCHG%d}.",
	maxGrade = 9,
	msgGradeLimited = "Hþp thành Ðích bäo thÕch cao nh¤t c¤p b§c Vi C¤p 9, Nhçm Ðích bäo thÕch không th¬ tiªp tøc hþp thành.",
	[1] = { SpecialStuff = 30900015, MoneyCost = 5000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[2] = { SpecialStuff = 30900015, MoneyCost = 6000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[3] = { SpecialStuff = 30900015, MoneyCost = 7000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[4] = { SpecialStuff = 30900016, MoneyCost = 8000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[5] = { SpecialStuff = 30900016, MoneyCost = 9000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[6] = { SpecialStuff = 30900016, MoneyCost = 10000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[7] = { SpecialStuff = 30900016, MoneyCost = 11000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[8] = { SpecialStuff = 30900016, MoneyCost = 12000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
}

local g_ActionButton_Gem
local g_ActionButton_GemNew
local g_ActionButton_ComposeItem

local g_Gemcompose_Frame_UnifiedPosition
local npcObjId = -1

local g_ItemBagIndex = -1			--???????
local g_ComposeMode = 0				--??5?1

local g_CurrentOdds = 0

local g_nMaxShowNum = 250

-- ×¢²áÊÂ¼þ
function Gemcompose_PreLoad()

	this:RegisterEvent("UI_COMMAND")						--??????
	this:RegisterEvent("COMPOSE_GEM_PUTIN_ITEM")			--??????????
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--???????????
	this:RegisterEvent("OBJECT_CARED_EVENT")				--???????NPC
	this:RegisterEvent("RESUME_ENCHASE_GEM")				--????
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE")			--?????
	this:RegisterEvent("UNIT_MONEY")					--????
	this:RegisterEvent("MONEYJZ_CHANGE")					--????
	this:RegisterEvent("BUY_ITEM")							--????,????
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

--½çÃæÔØÈë
function Gemcompose_OnLoad()
	
	g_ActionButton_Gem = Gemcompose_Space1
	g_ActionButton_GemNew = Gemcompose_Space2
	g_ActionButton_ComposeItem = Gemcompose_Special_Button
	
	g_Gemcompose_YuanbaoPay = 1
	
	g_Gemcompose_Frame_UnifiedPosition=Gemcompose_Frame:GetProperty("UnifiedPosition")

end

--¼à¿Ø¸÷ÖÖÊÂ¼þ
function Gemcompose_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 23 then	--????
		
		--if g_Gemcompose_YuanbaoPay == 1 or g_Gemcompose_YuanbaoPay == 0 then
		--	Gemcompose_YuanBaoPay:SetCheck(g_Gemcompose_YuanbaoPay)
		--end
		Gemcompose_Clear()

		Gemcompose_SuccessValue_Text:SetText("")

		Gemcompose_Info:SetText("#{INTERFACE_XML_316}")
		Gemcompose_Static1:Show()
		Gemcompose_Special:Show()
		
		local GemUnionPos = Variable:GetVariable("GemUnionPos")
		if(GemUnionPos ~= nil) then
		  Gemcompose_Frame:SetProperty("UnifiedPosition", GemUnionPos)
		end

		this:Show()

		npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"))
		Variable:SetVariable("GemNPCObjId", "", 1)
		if(npcObjId == nil) then
			npcObjId = Get_XParam_INT( 0 )
		end
		Gemcompose_BeginCareObject( npcObjId )
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		
		Gemcompose_Special_Choice:ResetList()
		
		Gemcompose_Special_Choice:AddTextItem("#{BSDJ_170811_04}",0)
		Gemcompose_Special_Choice:AddTextItem("#{BSDJ_170811_05}",1)
		Gemcompose_Special_Choice:AddTextItem("#{BSDJ_170811_06}",2)
		Gemcompose_Special_Choice:SetCurrentSelect(0)
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			Gemcompose_Cancel_Clicked()
		end
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "COMPOSE_GEM_PUTIN_ITEM" and this:IsVisible() then
		Gemcompose_Update(arg0, arg1)
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if event == "BUY_ITEM" and this:IsVisible() then	--????,????
		local itemId = tonumber(arg1)
		if itemId == Gemcompose_GetSpecialMaterial() then
			Gemcompose_Update(0,tonumber(PlayerPackage:GetBagPosByItemIndex(itemId)))	
			Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
			Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		end
		return
	end

	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		Gemcompose_RefreshItem()

		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "RESUME_ENCHASE_GEM" and this : IsVisible() then
		if arg0 then
			Gemcompose_Remove( tonumber( arg0 ) - 6 )
		end
		return
	end

	if event == "CLOSE_SYNTHESIZE_ENCHASE" and this : IsVisible() then
		Gemcompose_Cancel_Clicked()
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "UNIT_MONEY" and this:IsVisible() then
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "MONEYJZ_CHANGE" and this:IsVisible() then
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if event == "ADJEST_UI_POS" then
		Gemcompose_Frame_On_ResetPos()
		return
	end
	
	if event == "VIEW_RESOLUTION_CHANGED" then
		Gemcompose_Frame_On_ResetPos()
		return
	end
	
end

--µã»÷ºÏ³É°´Å¥
function Gemcompose_OK_Clicked()
	--¸ù¾Ýµ±Ç°Ëù´¦µÄ½çÃæ½øÐÐ¼ì²é
	local Notify = 0
	
	--ÅÐ¶Ïµç»°ÃÜ±£ºÍ¶þ¼¶ÃÜÂë±£»¤
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then			
		return
	end
	
	if g_GemTableIndex == -1 then
		PushDebugMessage("#{BSQHB_120830_10}")
		return
	end
	
	local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	
	--¼ì²é²ÄÁÏÊÇ·ñÊÇ×î¸ßµÈ¼¶
	if nGemLevel >= RuleTable.maxGrade then
		PushDebugMessage( RuleTable.msgGradeLimited )
		return
	end
	
	--ÓÃ7¼¶¼°7¼¶ÒÔÉÏ±¦Ê¯ºÏ³É¸ü¸ß¼¶±ð±¦Ê¯µÄ¹¦ÄÜÄ¿Ç°ÒÑ¹Ø± 
	if nGemLevel >= 7 then
		PushDebugMessage( "#{BSHC_090313_1}" )
		return
	end
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	if nSel == 0 and nGemCount < 5 then
		local msg =ScriptGlobal_Format( "#{BSDJ_170811_13}", "5")
		PushDebugMessage(msg)
		return
	elseif nSel == 1 and nGemCount < 4 then
		local msg =ScriptGlobal_Format( "#{BSDJ_170811_13}", "4")
		PushDebugMessage(msg)
		return
	elseif nSel == 2 and nGemCount < 3 then
		local msg =ScriptGlobal_Format( "#{BSDJ_170811_13}", "3")
		PushDebugMessage(msg)
		return
	end
	
	-- ¼ì²éÉíÉÏµÄ½ðÇ®ÊÇ·ñ×ã¹»
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < RuleTable[nGemLevel].MoneyCost then
		PushDebugMessage( string.format( RuleTable.msgLackMoney, RuleTable[nGemLevel].MoneyCost ) )
		return
	end

	--Èç¹ûÊÇ±¦Ê¯ºÏ³É½çÃæ£¬ÔòÈç¹ûÃ»ÓÐ·ÅÈëÌØÊâ²ÄÁÏ½«¸ø³ö½çÃæÌáÊ¾
	if g_ItemBagIndex == -1 then
		PushDebugMessage("#{BSDJ_170811_15}")
		return
	end
	
	LifeAbility:Do_Combine(g_GemTableIndex,g_ItemBagIndex,nSel,g_CurrentOdds)
end

--µã»÷È¡Ïû»ò ß¹Ø± °´Å¥
function Gemcompose_Cancel_Clicked()
	Gemcompose_Close()
	Gemcompose_StopCareObject()
end

--¹Ø± ½çÃæ
function Gemcompose_Close()
	this:Hide()
	Gemcompose_Clear()
end

--Çå¿ ½çÃæÔªËØ
function Gemcompose_Clear()

	--g_Gemcompose_YuanbaoPay = Gemcompose_YuanBaoPay:GetCheck()

	Gemcompose_SuccessValue_Text:SetText("")
	Gemcompose_NeedMoney:SetProperty( "MoneyNumber", "0" )

	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	g_ActionButton_ComposeItem:SetActionItem(-1)
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,0)
		DataPool:Lua_GemComposeLayedItem_Update(0)
		g_GemTableIndex = -1
	end	
	
	if g_ItemBagIndex ~=  -1 then
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
		g_ItemBagIndex = -1
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)

end

--µÃµ½µ±Ç°½çÃæÓ¦¸ÃÆ¥ÅäµÄÌØÊâ²ÄÁÏºÅ
--Èç¹û²»ÊÇ±¦Ê¯½çÃæÔò·µ»Ø -1
--Èç¹ûÊÇ±¦Ê¯½çÃæµ«ÊÇ»¹Ã»ÓÐ·ÅÈÎºÎ±¦Ê¯Ôò·µ»Ø -1
function Gemcompose_GetSpecialMaterial()
	
	if g_GemTableIndex == -1 then
		return -1
	end
	
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)

	if RuleTable[nGemLevel] ~= nil then
		return RuleTable[nGemLevel].SpecialStuff
	end

	return -1
end

--ÊÇ²»ÊÇºÏ³É·û
function Gemcompose_IsComposeItem(bagPos)
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	if nItemTableIndex == 30900015 or nItemTableIndex == 30900016 or nItemTableIndex == 30900128 then
		return 1
	end
	
	return 0
	
end

--Ë¢ÐÂºÏ³É½çÃæÉÏµÄÎïÆ·
function Gemcompose_Update(pos0, pos1)
	
	local slot = tonumber(pos0)
	local bagPos = tonumber(pos1)

	--ÑéÖ¤ÎïÆ·ÓÐÐ§ÐÔ
	local bagItem = EnumAction(bagPos, "packageitem")
	if bagItem:GetID() == 0 then
		return
	end
	
	if slot == 0 then
		
		if PlayerPackage:IsGem(bagPos) == 1 then
			
			Gemcompose_PutInGem(bagPos)
		elseif Gemcompose_IsComposeItem(bagPos) == 1 then
			
			Gemcompose_PutInComposeItem(bagPos)
		else
			PushDebugMessage("#{BSQHB_120830_03}")
			return
		end
	
	elseif slot == 1 then
		
		Gemcompose_PutInGem(bagPos)
		
	elseif slot == 2 then
	
		Gemcompose_PutInComposeItem(bagPos)
	
	end

end

--Íù±¦Ê¯¿ò·ÅÈëÒ»¸öÎïÆ·
function Gemcompose_PutInGem(bagPos)
	
	if Gemcompose_IsComposeItem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_09}")		--?????????
		return
	elseif PlayerPackage:IsGem(bagPos) ~= 1 then
		PushDebugMessage("#{BSQHB_120830_03}")		--??????
		return
	end
	

	local nGemLevel = PlayerPackage:GetItemSubTableIndex(bagPos, 1)
	if nGemLevel == 8 then
		PushDebugMessage("#{BSQHB_120830_04}")		--?8?????9???????????
		return
	end

	if nGemLevel == 7 then
		PushDebugMessage("#{BSHC_090313_1}")		--7?????
		return
	end
		
	local gemItem = EnumAction(bagPos, "packageitem")
	if gemItem:GetID() == 0 then
		return
	end
	
	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,0)
		g_GemTableIndex = -1
	end
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(nItemTableIndex)
	local nHaveBindCount = PlayerPackage:Lua_GetUnLockBindItemCount(nItemTableIndex)

	-- PushDebugMessage("nHaveBindCount1"..nHaveBindCount)

	if nHaveCount > g_nMaxShowNum then
		nHaveCount = g_nMaxShowNum
	end
	
	local theAction = nil 
	if nHaveBindCount > 0 then
		theAction = DataPool:CreateBindActionItemForShow(nItemTableIndex, nHaveCount)
	else
		theAction = DataPool:CreateActionItemForShow(nItemTableIndex, nHaveCount)
	end
	 
	if 0 ~= theAction:GetID() then
		g_ActionButton_Gem : SetActionItem(theAction:GetID())
		LifeAbility : Lock_Packet_ItemByID(nItemTableIndex, 1)
		g_GemTableIndex = nItemTableIndex
	end

	DataPool:Lua_GemComposeLayedItem_Update(nItemTableIndex)
	
	local layedGemItem = EnumAction(g_DummyGemLayed, "Gem_Layed")
	-- if layedGemItem:GetID() ~= 0 then
	-- 	g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
	-- 	LifeAbility:Lock_Packet_ItemByID(nItemTableIndex,1)
	-- 	g_GemTableIndex = nItemTableIndex
	-- end
	local newGemItem = EnumAction(g_DummyNewGem, "Gem_Layed")
	if newGemItem:GetID() ~= 0 then
		g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
	end
	
	if g_ItemBagIndex ~= -1 then
	
		local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(g_ItemBagIndex)
		
		if Gemcompose_GetSpecialMaterial() ~= nComposeItemTableIndex then
			
			g_ActionButton_ComposeItem:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
			g_ItemBagIndex = -1

		end
	end
	
	if nGemLevel == 7 then
		Gemcompose_Special_Choice:SetCurrentSelect(1)
	else
		Gemcompose_Special_Choice:SetCurrentSelect(0)
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)
	
	Gemcompose_RecalcCost()
	Gemcompose_RecalcSuccOdds()
	
end

--Íù±¦Ê¯ºÏ³É·û¿ò·ÅÈëÒ»¸öÎïÆ·
function Gemcompose_PutInComposeItem(bagPos)
	
	if PlayerPackage:IsGem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_08}")		--???????
		return
	elseif Gemcompose_IsComposeItem(bagPos) ~= 1 then
		PushDebugMessage("#{BSQHB_120830_03}")		--??????
		return
	end
	
	local composeItem = EnumAction(bagPos, "packageitem")
	if composeItem:GetID() == 0 then
		return
	end
	
	if g_GemTableIndex == -1 then
		PushDebugMessage("#{BSQHB_120830_06}")	--??????
		return		
	end
	
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(bagPos)
	
	if Gemcompose_GetSpecialMaterial() == -1 then
		PushDebugMessage("#{BSQHB_120830_06}")	--??????
		return	
	elseif Gemcompose_GetSpecialMaterial() ~= nComposeItemTableIndex then
		
		if nGemLevel < 4 then
			PushDebugMessage( "#{BSQHB_120830_12}" )
		elseif nGemLevel < 7 then
			PushDebugMessage( "#{BSQHB_120830_13}" )
		elseif nGemLevel < 8 then
			PushDebugMessage( "#{BSQHB_120830_07}" )
		end
		return
	end
	
	if g_ItemBagIndex == -1 then
		
		g_ActionButton_ComposeItem:SetActionItem(composeItem:GetID())
		g_ItemBagIndex = bagPos
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex, 1)	
		
	else
	
		g_ActionButton_ComposeItem:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
		
		g_ActionButton_ComposeItem:SetActionItem(composeItem:GetID())
		g_ItemBagIndex = bagPos
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex, 1)
	
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)
	
	Gemcompose_RecalcSuccOdds()
	
end

function Gemcompose_Special_ChoiceChanged()
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	if g_GemTableIndex ~= -1 then
	
		local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
		if nGemLevel == 7 and nSel ~= 1 then
			PushDebugMessage("#{BSDJ_170811_07}")		--??8????????????
			Gemcompose_Special_Choice:SetCurrentSelect(1)
			return
		end		
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)
	
	Gemcompose_RecalcSuccOdds()

end

--ÒÆ³ýÒ»¸ö²ÄÁÏ
function Gemcompose_Remove(slot)
	
	if slot == 1 then
	
		Gemcompose_Clear()
		
	elseif slot == 2 then
	
		g_ActionButton_ComposeItem:SetActionItem(-1)
		if g_ItemBagIndex ~=  -1 then
			LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
			g_ItemBagIndex = -1
		end
		
		LifeAbility:Lua_SetGemComposeNotify(1)
		
		Gemcompose_RecalcCost()
		Gemcompose_RecalcSuccOdds()
	end	
	
end

--ÖØÐÂ¼ÆËãºÏ³É¸ÅÂÊ
function Gemcompose_RecalcSuccOdds()
	
	g_CurrentOdds = 0
	
	if g_GemTableIndex == -1 then
		Gemcompose_SuccessValue_Text:SetText("")
		return
	end	
	
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)

	local str = "#cFF0000"
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	if nSel == 0 and RuleTable[nGemLevel] ~= nil and RuleTable[nGemLevel].CountTable[5] ~= nil then
		
		if nGemCount < 5 then
			Gemcompose_SuccessValue_Text:SetText("#{BSDJ_170811_37}")
		else
		
			local nOdds = RuleTable[nGemLevel].CountTable[5].SuccOdds
			
			if g_ItemBagIndex ~= -1 then
				nOdds = RuleTable[nGemLevel].CountTable[5].SuccOddsWithSpecStuff
			end
			str = str..tostring(nOdds).."%"
			
			Gemcompose_SuccessValue_Text:SetText(str)
			
			g_CurrentOdds = nOdds
		end
		
	elseif nSel == 1 and RuleTable[nGemLevel].CountTable[4] ~= nil  then
		
		if nGemCount < 4 then		
			Gemcompose_SuccessValue_Text:SetText("#{BSDJ_170811_37}")
		else
			local nOdds = RuleTable[nGemLevel].CountTable[4].SuccOdds
			
			if g_ItemBagIndex ~= -1 then
				nOdds = RuleTable[nGemLevel].CountTable[4].SuccOddsWithSpecStuff
			end
			str = str..tostring(nOdds).."%"
			
			Gemcompose_SuccessValue_Text:SetText(str)
			
			g_CurrentOdds = nOdds
		end
	
	elseif nSel == 2 and RuleTable[nGemLevel].CountTable[3] ~= nil then
	
		if nGemCount < 3 then
			Gemcompose_SuccessValue_Text:SetText("#{BSDJ_170811_37}")
		else
		
			local nOdds = RuleTable[nGemLevel].CountTable[3].SuccOdds
			
			if g_ItemBagIndex ~= -1 then
				nOdds = RuleTable[nGemLevel].CountTable[3].SuccOddsWithSpecStuff
			end
			str = str..tostring(nOdds).."%"
			
			Gemcompose_SuccessValue_Text:SetText(str)
			
			g_CurrentOdds = nOdds
		end
	end	
end

--ÖØÐÂ¼ÆËã½ðÇ®ÏûºÄ
function Gemcompose_RecalcCost()
	
	if g_GemTableIndex == -1 then
		Gemcompose_NeedMoney:SetProperty("MoneyNumber", "0")
		return 
	end

	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)

	if RuleTable[nGemLevel] ~= nil then
		Gemcompose_NeedMoney:SetProperty("MoneyNumber", tostring(RuleTable[nGemLevel].MoneyCost) )
		return
	end

	Gemcompose_NeedMoney:SetProperty("MoneyNumber", "0")
end

function Gemcompose_RefreshItem()
		
	if g_GemTableIndex ~= -1 then
		
		g_ActionButton_Gem:SetActionItem(-1)
		g_ActionButton_GemNew:SetActionItem(-1)
		LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,0)
		local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(g_GemTableIndex)
		local nHaveBindCount = PlayerPackage:Lua_GetUnLockBindItemCount(g_GemTableIndex)

		-- PushDebugMessage("nHaveBindCount2"..nHaveBindCount)

		if nHaveCount > g_nMaxShowNum then
			nHaveCount = g_nMaxShowNum
		end

		if nHaveCount > 0 then
			local theAction = nil 
			if nHaveBindCount > 0 then
				theAction = DataPool:CreateBindActionItemForShow(g_GemTableIndex, nHaveCount)
			else
				theAction = DataPool:CreateActionItemForShow(g_GemTableIndex, nHaveCount)
			end
			 
			if 0 ~= theAction:GetID() then
				g_ActionButton_Gem : SetActionItem(theAction:GetID())
				LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex, 1)
			end
		end

		DataPool:Lua_GemComposeLayedItem_Update(g_GemTableIndex)

		local layedGemItem = EnumAction(g_DummyGemLayed, "Gem_Layed")
		-- if layedGemItem:GetID() ~= 0 then
		-- 	g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
		-- 	LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,1)
		-- end

		local newGemItem = EnumAction(g_DummyNewGem, "Gem_Layed")
		if newGemItem:GetID() ~= 0 then
			g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
		end		
		
		if g_ItemBagIndex ~=  -1 then
			
			local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(g_ItemBagIndex)
			
			if Gemcompose_GetSpecialMaterial() ~= nComposeItemTableIndex then
				g_ActionButton_ComposeItem:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
				g_ItemBagIndex = -1
			end
		end
		
		Gemcompose_RecalcCost()
		Gemcompose_RecalcSuccOdds()
	
	end

end

function Gemcompose_GetGemLevel(nSN)
	
	if nSN < 0 then
		return 0
	end

	local nLevel = math.floor(math.mod(nSN,10000000) / 100000)
	return nLevel

end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function Gemcompose_BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		PushDebugMessage("Chßa phát hi®n NPC")
		this : Hide()
		--g_Gemcompose_YuanbaoPay = Gemcompose_YuanBaoPay:GetCheck()
		return
	end

	this : CareObject( theNPC, 1, "Gemcompose" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function Gemcompose_StopCareObject()
	this : CareObject( theNPC, 0, "Gemcompose" )
	theNPC = -1
end

function Gemcompose_Help_Clicked()
	Helper:GotoHelper("*Gemcompose")
end

function Gemcompose_Frame_On_ResetPos()
  Gemcompose_Frame:SetProperty("UnifiedPosition", g_Gemcompose_Frame_UnifiedPosition)
end

