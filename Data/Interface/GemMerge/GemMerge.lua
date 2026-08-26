
local theNPC = -1											-- ?? NPC
local MAX_OBJ_DISTANCE = 3.0

local g_DummyGemLayed = 0
local g_DummyNewGem = 1

local RuleTable = {
	msgLackMoney = "Nhçm trên ngß¶i Ðích ti«n tài không ðü#{_EXCHG%d}.",
	maxGrade = 9,
	msgGradeLimited = "Hþp thành Ðích bäo thÕch cao nh¤t c¤p b§c Vi C¤p 9, Nhçm Ðích bäo thÕch không th¬ tiªp tøc hþp thành.",
	[1] = { SpecialStuff = 30900015, MoneyCost = 5000 },
	[2] = { SpecialStuff = 30900015, MoneyCost = 6000 },
	[3] = { SpecialStuff = 30900015, MoneyCost = 7000 },
	[4] = { SpecialStuff = 30900016, MoneyCost = 8000 },
	[5] = { SpecialStuff = 30900016, MoneyCost = 9000 },
	[6] = { SpecialStuff = 30900016, MoneyCost = 10000 },
	[7] = { SpecialStuff = 30900016, MoneyCost = 11000 },
	[8] = { SpecialStuff = 30900016, MoneyCost = 12000 },
}

local g_ActionButton_PackageGem
local g_ActionButton_ReplaceItem
local g_ActionButton_ProductItem
local g_ActionButton_ComposeItem

local g_GemMerge_Frame_UnifiedPosition

local g_GemTableIndex = -1			--??????
local g_ReplaceTableIndex = 20800022--????
local g_ComposeBagIndex = -1		--???????
local g_ReplaceBagIndex = -1		--???????
local g_CurrentOdds = 0
local g_nMaxShowNum = 250

-- ×¢²áÊÂ¼þ
function GemMerge_PreLoad()

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
function GemMerge_OnLoad()
	
	g_ActionButton_PackageGem = GemMerge_GemItem1 		--?????????
	g_ActionButton_ReplaceItem = GemMerge_GemItem2 		--?????
	g_ActionButton_ReplaceItem : SetDrawCorner(3, false);
	g_ActionButton_ProductItem = GemMerge_ProductItem 	--???????
	g_ActionButton_ComposeItem = GemMerge_NeedItem		--?????
	
	g_GemMerge_Frame_UnifiedPosition=GemMerge_Frame:GetProperty("UnifiedPosition")
end

--¼à¿Ø¸÷ÖÖÊÂ¼þ
function GemMerge_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 2024061401 then	--????????
		GemMerge_Clear()
		GemMerge_RefreshItem()
		GemMerge_GaiLvNum:SetText("")
		this:Show()

		local npcObjId = Get_XParam_INT( 0 )
		GemMerge_BeginCareObject( npcObjId )
		GemMerge_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		GemMerge_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			GemMerge_Cancel_Clicked()
		end
		GemMerge_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		GemMerge_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "COMPOSE_GEM_PUTIN_ITEM" and this:IsVisible() then
		GemMerge_Update(arg0, arg1)
		GemMerge_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		GemMerge_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if event == "BUY_ITEM" and this:IsVisible() then	--????,????
		local itemId = tonumber(arg1)
		if itemId == GemMerge_GetSpecialMaterial() then
			GemMerge_Update(0,tonumber(PlayerPackage:GetBagPosByItemIndex(itemId)))	
			GemMerge_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
			GemMerge_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		end
		return
	end

	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		GemMerge_RefreshItem()

		GemMerge_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		GemMerge_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "RESUME_ENCHASE_GEM" and this : IsVisible() then
		if arg0 then
			GemMerge_Remove( tonumber( arg0 ) - 6 )
		end
		return
	end

	if event == "CLOSE_SYNTHESIZE_ENCHASE" and this : IsVisible() then
		GemMerge_Cancel_Clicked()
		GemMerge_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "UNIT_MONEY" and this:IsVisible() then
		GemMerge_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "MONEYJZ_CHANGE" and this:IsVisible() then
		GemMerge_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if event == "ADJEST_UI_POS" then
		GemMerge_Frame_On_ResetPos()
		return
	end
	
	if event == "VIEW_RESOLUTION_CHANGED" then
		GemMerge_Frame_On_ResetPos()
		return
	end
	
end

--µã»÷ºÏ³É°´Å¥
function GemMerge_OK_Clicked()
	--¸ù¾Ýµ±Ç°Ëù´¦µÄ½çÃæ½øÐÐ¼ì²é
	local Notify = 0
	
	--ÅÐ¶Ïµç»°ÃÜ±£ºÍ¶þ¼¶ÃÜÂë±£»¤
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then			
		return
	end
	
	if g_GemTableIndex == -1 then
		PushDebugMessage("#{BSFHC_240613_19}")
		return
	end
	
	local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)
	local nGemLevel = GemMerge_GetGemLevel(g_GemTableIndex)
	
	--¼ì²é²ÄÁÏÊÇ·ñÊÇ×î¸ßµÈ¼¶
	if nGemLevel >= RuleTable.maxGrade then
		PushDebugMessage( RuleTable.msgGradeLimited )
		return
	end
	
	--ÔÝÊ±Ö»¿ª·Å5¼¶±¦Ê¯Éý¼¶
	if nGemLevel ~= 5 then
		PushDebugMessage( "Chï có C¤p 5 bäo thÕch m· ra Li­u ThØ công nång" )
		return
	end
	if nGemCount < 4 then
		-- local msg =ScriptGlobal_Format( "#{BSDJ_170811_13}", "4")
		-- PushDebugMessage(msg)
		PushDebugMessage("#{BSFHC_240613_20}")
		return
	end

	--Èç¹ûÊÇ±¦Ê¯ºÏ³É½çÃæ£¬ÔòÈç¹ûÃ»ÓÐ·ÅÈëÌØÊâ²ÄÁÏ½«¸ø³ö½çÃæÌáÊ¾
	if PlayerPackage:CountAvailableItemByIDTable(g_ReplaceTableIndex) == 0 then
		PushDebugMessage("#{BSFHC_240613_21}")
		return
	end
	--Èç¹ûÊÇ±¦Ê¯ºÏ³É½çÃæ£¬ÔòÈç¹ûÃ»ÓÐ·ÅÈëÌØÊâ²ÄÁÏ½«¸ø³ö½çÃæÌáÊ¾
	if g_ComposeBagIndex == -1 then
		PushDebugMessage("#{BSFHC_240613_22}")
		return
	end

	-- ¼ì²éÉíÉÏµÄ½ðÇ®ÊÇ·ñ×ã¹»
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < RuleTable[nGemLevel].MoneyCost then
		PushDebugMessage( string.format( RuleTable.msgLackMoney, RuleTable[nGemLevel].MoneyCost ) )
		return
	end
	-- ²ÄÁÏÀ¸±³°ü¿ ¼ä
	if GetBagSpace(g_GemTableIndex) <= 0 then 
		PushDebugMessage("#{BSFHC_240613_33}")
		return
	end


	if LifeAbility:Lua_GetGemComposeNotify() == 1 then 
		LifeAbility:Lua_SetGemComposeNotify(0)

		local nItemTableIndex = g_GemTableIndex
		local szItemName = DataPool:Lua_GetItemNameByIndex(nItemTableIndex)
		local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(nItemTableIndex)
		local nHaveBindCount = PlayerPackage:Lua_GetUnLockBindItemCount(nItemTableIndex)

		if nHaveBindCount == 0 then 
			local strNotice = ScriptGlobal_Format("#{BSFHC_240613_29}", szItemName)
			PushEvent("GAMELOGIN_SYSTEM_INFO_OK", strNotice, "-1")
		elseif nHaveBindCount < 4 then 
			local nNoBindCount = 4 - nHaveBindCount
			local strNotice = ScriptGlobal_Format("#{BSFHC_240613_31}", nHaveBindCount, szItemName, nNoBindCount, szItemName)
			PushEvent("GAMELOGIN_SYSTEM_INFO_OK", strNotice, "-1")
		else
			local strNotice = ScriptGlobal_Format("#{BSFHC_240613_30}", szItemName)
			PushEvent("GAMELOGIN_SYSTEM_INFO_OK", strNotice, "-1")
		end
		return 
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "WuxiangCompound" )
		Set_XSCRIPT_ScriptID(701602)
		Set_XSCRIPT_Parameter(0, g_GemTableIndex)					
		Set_XSCRIPT_Parameter(1, g_ComposeBagIndex)						
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--µã»÷È¡Ïû»ò ß¹Ø± °´Å¥
function GemMerge_Cancel_Clicked()
	GemMerge_Close()
	GemMerge_StopCareObject()
end

--¹Ø± ½çÃæ
function GemMerge_Close()
	this:Hide()
	GemMerge_Clear()
	--ÎÞÏà±¦Ê¯
	if PlayerPackage:CountAvailableItemByIDTable(g_ReplaceTableIndex) > 0 then 
		LifeAbility:Lock_Packet_ItemByID(g_ReplaceTableIndex,0)
	end
end

--Çå¿ ½çÃæÔªËØ
function GemMerge_Clear()

	GemMerge_GaiLvNum:SetText("")
	GemMerge_NeedMoney:SetProperty( "MoneyNumber", "0" )

	g_ActionButton_PackageGem:SetActionItem(-1)
	g_ActionButton_ProductItem:SetActionItem(-1)
	g_ActionButton_ComposeItem:SetActionItem(-1)
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,0)
		DataPool:Lua_GemComposeLayedItem_Update(0)
		g_GemTableIndex = -1
	end	

	if g_ComposeBagIndex ~=  -1 then
		LifeAbility:Lock_Packet_Item(g_ComposeBagIndex,0)
		g_ComposeBagIndex = -1
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)

end

--µÃµ½µ±Ç°½çÃæÓ¦¸ÃÆ¥ÅäµÄÌØÊâ²ÄÁÏºÅ
--Èç¹ûÊÇ±¦Ê¯½çÃæµ«ÊÇ»¹Ã»ÓÐ·ÅÈÎºÎ±¦Ê¯Ôò·µ»Ø -1
function GemMerge_GetSpecialMaterial()
	if g_GemTableIndex == -1 then
		return -1
	end
	
	local nGemLevel = GemMerge_GetGemLevel(g_GemTableIndex)
	if RuleTable[nGemLevel] ~= nil then
		return RuleTable[nGemLevel].SpecialStuff
	end

	return -1
end

--ÊÇ²»ÊÇºÏ³É·û
function GemMerge_IsComposeItem(bagPos)
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	if nItemTableIndex == 30900016 then
		return 1
	end
	
	return 0
end

--ÊÇ²»ÊÇÚ¤Ê¯
function GemMerge_IsMingshiGem(bagPos)
	if PlayerPackage:IsGem(bagPos) ~= 1 then
		return 0
	end
	--²»°üº¬Ú¤Ê¯
	local nItemType = PlayerPackage:GetItemSubTableIndex(bagPos, 2)
	if nItemType ~= 21 then 
		return 0
	end
	
	return 1
end

--ÊÇ²»ÊÇ±¦Ê¯(²»º¬Ú¤Ê¯)
function GemMerge_IsSuitableGem(bagPos)
	if PlayerPackage:IsGem(bagPos) ~= 1 then
		return 0
	end
	--²»°üº¬Ú¤Ê¯
	local nItemType = PlayerPackage:GetItemSubTableIndex(bagPos, 2)
	if nItemType == 21 then 
		return 0
	end
	
	return 1
end

--Ë¢ÐÂºÏ³É½çÃæÉÏµÄÎïÆ·
function GemMerge_Update(pos0, pos1)
	
	local slot = tonumber(pos0)
	local bagPos = tonumber(pos1)

	--ÑéÖ¤ÎïÆ·ÓÐÐ§ÐÔ
	local bagItem = EnumAction(bagPos, "packageitem")
	if bagItem:GetID() == 0 then
		return
	end
	
	if slot == 0 then
		if GemMerge_IsSuitableGem(bagPos) == 1 then
			GemMerge_PutInGem(bagPos)
		elseif GemMerge_IsComposeItem(bagPos) == 1 then
			GemMerge_PutInComposeItem(bagPos)
		elseif GemMerge_IsMingshiGem(bagPos) == 1 then 
			PushDebugMessage("#{BSFHC_240613_17}")	
		else
			PushDebugMessage("#{BSQHB_120830_03}")
			return
		end
	elseif slot == 1 then
		GemMerge_PutInGem(bagPos)
	elseif slot == 2 then
		GemMerge_PutInComposeItem(bagPos)
	end

end

--Íù±¦Ê¯¿ò·ÅÈëÒ»¸öÎïÆ·
function GemMerge_PutInGem(bagPos)
	
	if GemMerge_IsComposeItem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_09}")		--?????????
		return
	elseif GemMerge_IsMingshiGem(bagPos) == 1 then 
		PushDebugMessage("#{BSFHC_240613_17}")	
		return
	elseif GemMerge_IsSuitableGem(bagPos) ~= 1 then
		PushDebugMessage("#{BSQHB_120830_03}")		--??????
		return
	end
	

	local nGemLevel = PlayerPackage:GetItemSubTableIndex(bagPos, 1)
	if nGemLevel ~= 5 then
		PushDebugMessage("#{BSFHC_240613_17}")		--????5???(????)
		return
	end
		
	local gemItem = EnumAction(bagPos, "packageitem")
	if gemItem:GetID() == 0 then
		return
	end
	
	g_ActionButton_PackageGem:SetActionItem(-1)
	g_ActionButton_ProductItem:SetActionItem(-1)
	
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
		g_ActionButton_PackageGem : SetActionItem(theAction:GetID())
		LifeAbility : Lock_Packet_ItemByID(nItemTableIndex, 1)
		g_GemTableIndex = nItemTableIndex
	end

	DataPool:Lua_GemComposeLayedItem_Update(nItemTableIndex)
	
	-- local newGemItem = EnumAction(g_DummyNewGem, "Gem_Layed")
	local newGemTableIndex = nItemTableIndex + 100000
	local newGemItem = DataPool:CreateBindActionItemForShow(newGemTableIndex, 0)
	if newGemItem:GetID() ~= 0 then
		g_ActionButton_ProductItem:SetActionItem(newGemItem:GetID())
	end
	
	if g_ComposeBagIndex ~= -1 then
		local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(g_ComposeBagIndex)
		if GemMerge_GetSpecialMaterial() ~= nComposeItemTableIndex then
			g_ActionButton_ComposeItem:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_ComposeBagIndex,0)
			g_ComposeBagIndex = -1
		end
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)
	
	GemMerge_RecalcCost()
	GemMerge_RecalcSuccOdds()
	
end

--Íù±¦Ê¯ºÏ³É·û¿ò·ÅÈëÒ»¸öÎïÆ·
function GemMerge_PutInComposeItem(bagPos)
	
	if GemMerge_IsSuitableGem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_08}")		--???????
		return
	elseif GemMerge_IsComposeItem(bagPos) ~= 1 then
		-- PushDebugMessage("#{BSQHB_120830_03}")		--²ÄÁÏÀàÐÍ²»·û
		PushDebugMessage("#{BSFHC_240613_18}")		--??????????
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
	
	local nGemLevel = GemMerge_GetGemLevel(g_GemTableIndex)
	local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(bagPos)
	
	if GemMerge_GetSpecialMaterial() == -1 then
		PushDebugMessage("RuleTablech¯ng ðÞ hªt n±i Trì hþp thành trß¾c m£t c¤p b§c Ðích bäo thÕch")
		return	
	elseif GemMerge_GetSpecialMaterial() ~= nComposeItemTableIndex then

		if nGemLevel < 4 then
			PushDebugMessage( "#{BSQHB_120830_12}" )
		elseif nGemLevel < 7 then
			PushDebugMessage( "#{BSQHB_120830_13}" )
		elseif nGemLevel < 8 then
			PushDebugMessage( "#{BSQHB_120830_07}" )
		end
		return
	end
	
	if g_ComposeBagIndex == -1 then
		
		g_ActionButton_ComposeItem:SetActionItem(composeItem:GetID())
		g_ComposeBagIndex = bagPos
		LifeAbility:Lock_Packet_Item(g_ComposeBagIndex, 1)	
		
	else
	
		g_ActionButton_ComposeItem:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_ComposeBagIndex,0)
		
		g_ActionButton_ComposeItem:SetActionItem(composeItem:GetID())
		g_ComposeBagIndex = bagPos
		LifeAbility:Lock_Packet_Item(g_ComposeBagIndex, 1)
	
	end
	
	LifeAbility:Lua_SetGemComposeNotify(1)
	
	GemMerge_RecalcSuccOdds()
	
end

--ÒÆ³ýÒ»¸ö²ÄÁÏ
function GemMerge_Remove(slot)
	
	if slot == 1 then
		GemMerge_Clear()
	elseif slot == 2 then
		g_ActionButton_ComposeItem:SetActionItem(-1)
		if g_ComposeBagIndex ~=  -1 then
			LifeAbility:Lock_Packet_Item(g_ComposeBagIndex,0)
			g_ComposeBagIndex = -1
		end
		
		LifeAbility:Lua_SetGemComposeNotify(1)
		
		GemMerge_RecalcCost()
		GemMerge_RecalcSuccOdds()
	end	
	
end

--ÖØÐÂ¼ÆËãºÏ³É¸ÅÂÊ
function GemMerge_RecalcSuccOdds()
	
	g_CurrentOdds = 0
	
	if g_GemTableIndex == -1 then
		GemMerge_GaiLvNum:SetText("")
		return
	end	
	
	local nGemLevel = GemMerge_GetGemLevel(g_GemTableIndex)
	local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)

	local str = "#cFF0000"
	
	if nGemCount < 4 then		
		GemMerge_GaiLvNum:SetText("#{BSDJ_170811_37}")
	elseif PlayerPackage:CountAvailableItemByIDTable(g_ReplaceTableIndex) <= 0 then 
		GemMerge_GaiLvNum:SetText("#{BSFHC_240613_09}") --????????
	else
		local nOdds = 75
		
		if g_ComposeBagIndex ~= -1 then
			nOdds = 100
		end
		str = str..tostring(nOdds).."%"
		
		GemMerge_GaiLvNum:SetText(str)
		
		g_CurrentOdds = nOdds
	end
end

--ÖØÐÂ¼ÆËã½ðÇ®ÏûºÄ
function GemMerge_RecalcCost()
	
	if g_GemTableIndex == -1 then
		GemMerge_NeedMoney:SetProperty("MoneyNumber", "0")
		return 
	end

	local nGemLevel = GemMerge_GetGemLevel(g_GemTableIndex)

	if RuleTable[nGemLevel] ~= nil then
		GemMerge_NeedMoney:SetProperty("MoneyNumber", tostring(RuleTable[nGemLevel].MoneyCost) )
		return
	end

	GemMerge_NeedMoney:SetProperty("MoneyNumber", "0")
end

function GemMerge_RefreshItem()
	-- ÎÞÏà±¦Ê¯
	if true then
		local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(g_ReplaceTableIndex)
		local nHaveBindCount = PlayerPackage:Lua_GetUnLockBindItemCount(g_ReplaceTableIndex)
		local theAction = nil
		if nHaveBindCount > 0 then 
			theAction = DataPool:CreateBindActionItemForShow(g_ReplaceTableIndex, nHaveCount) 
		else
			theAction = DataPool:CreateActionItemForShow(g_ReplaceTableIndex, nHaveCount) 
		end
		if 0 ~= theAction:GetID() then
			g_ActionButton_ReplaceItem : SetActionItem(theAction:GetID())
			if nHaveCount <= 0 then 
				GemMerge_GemItem2_Number:SetText("#cFF0000#e000001"..nHaveCount)
			else
				GemMerge_GemItem2_Number:SetText("#e000001"..nHaveCount)
			end
			LifeAbility:Lock_Packet_ItemByID(g_ReplaceTableIndex, 1)
		end
	end
	if g_ActionButton_PackageGem:GetActionItem() == -1 then 
		g_ActionButton_PackageGem:SetActionItem(-1)
		g_ActionButton_ProductItem:SetActionItem(-1)
		g_GemTableIndex = -1
	end
	--Éý¼¶±¦Ê¯
	if g_GemTableIndex ~= -1 then
		
		g_ActionButton_PackageGem:SetActionItem(-1)
		g_ActionButton_ProductItem:SetActionItem(-1)
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
				g_ActionButton_PackageGem : SetActionItem(theAction:GetID())
				LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex, 1)
			end
		end

		DataPool:Lua_GemComposeLayedItem_Update(g_GemTableIndex)

		-- local newGemItem = EnumAction(g_DummyNewGem, "Gem_Layed")
		local newGemTableIndex = g_GemTableIndex + 100000
		local newGemItem = DataPool:CreateBindActionItemForShow(newGemTableIndex, 0)
		if newGemItem:GetID() ~= 0 then
			g_ActionButton_ProductItem:SetActionItem(newGemItem:GetID())
		end		
		
		if g_ComposeBagIndex ~=  -1 then
			local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(g_ComposeBagIndex)
			if GemMerge_GetSpecialMaterial() ~= nComposeItemTableIndex then
				g_ActionButton_ComposeItem:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(g_ComposeBagIndex,0)
				g_ComposeBagIndex = -1
			end
		end
		
		GemMerge_RecalcCost()
		GemMerge_RecalcSuccOdds()
	
	end

end

function GemMerge_GetGemLevel(nSN)
	
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
function GemMerge_BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		PushDebugMessage("Chßa phát hi®n NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "Gemmerge" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function GemMerge_StopCareObject()
	this : CareObject( theNPC, 0, "Gemmerge" )
	theNPC = -1
end

function GemMerge_Help_Clicked()
	Helper:GotoHelper("*Gemmerge")
end

function GemMerge_Frame_On_ResetPos()
  GemMerge_Frame:SetProperty("UnifiedPosition", g_GemMerge_Frame_UnifiedPosition)
end

