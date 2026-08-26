local MAX_OBJ_DISTANCE = 3.0

local g_GemTableIndex = -1

local g_NeedItemPos = -1
local g_NeedItemID = -1
local g_NeedItemID2 = -1

local g_NeedMoney = 0

local g_NotifyBind = 1

local g_ActionButton_Gem
local g_ActionButton_GemNew

local ObjCaredID = -1

local npcObjId = -1

local g_GemMelting_Frame_UnifiedPosition

local g_DummyGemLayed = 2
local g_DummyNewGem = 3

function GemMelting_PreLoad()

	this:RegisterEvent("UPDATE_GEMMELTING")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function GemMelting_OnLoad()

	g_ActionButton_Gem = GemMelting_GemItem1
	g_ActionButton_GemNew = GemMelting_ProductItem
	g_GemMelting_Frame_UnifiedPosition = GemMelting_Frame:GetProperty("UnifiedPosition")

end

function GemMelting_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 112237 then

		npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"))
		Variable:SetVariable("GemNPCObjId", "", 1)
		if(npcObjId == nil) then
			npcObjId = Get_XParam_INT( 0 )
		end
		
		ObjCaredID = DataPool : GetNPCIDByServerID(npcObjId)
		if ObjCaredID == -1 then
			PushDebugMessage("Dæ li®u máy chü có v¤n ğ«")
			return
		end
		BeginCareObject_GemMelting()
		GemMelting_Clear()
		local GemUnionPos = Variable:GetVariable("GemUnionPos")
		if(GemUnionPos ~= nil) then
		  GemMelting_Frame:SetProperty("UnifiedPosition", GemUnionPos)
		end

		this:Show()

	elseif event == "OBJECT_CARED_EVENT" and this:IsVisible() then

		if(tonumber(arg0) ~= ObjCaredID) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemMelting_Close()
		end

	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then

		if arg0 == nil or tonumber(arg0) == -1 then
			return
		end
		
		GemMelting_RefreshItem()

	elseif event == "UPDATE_GEMMELTING" then

		if arg0 == nil or arg1 == nil then
			return
		end
		GemMelting_Update(tonumber(arg0),tonumber(arg1))

	elseif event == "UNIT_MONEY" then

		GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	elseif event == "MONEYJZ_CHANGE" then

		GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )   --???? Vega

	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then

		local NumArg0 = tonumber(arg0)
		if NumArg0 == 61 then
			GemMelting_Resume_Item(1)
		elseif NumArg0 == 62 then
			GemMelting_Resume_Item(2)
		end
		
	elseif event == "ADJEST_UI_POS" then
		GemMelting_Frame_On_ResetPos()
		
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		GemMelting_Frame_On_ResetPos()

	end

end

--ÖØÖÃ½çÃæ
function GemMelting_Clear()

	if g_NeedItemPos ~= -1 then
		LifeAbility:Lock_Packet_Item(g_NeedItemPos,0)
		g_NeedItemPos = -1
	end
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,0)
		g_GemTableIndex = -1
	end

	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)

	GemMelting_NeedItem:SetToolTip("")
	GemMelting_NeedItem:SetActionItem(-1)
		
	GemMelting_NeedMoney:SetProperty("MoneyNumber", "")
	GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )

	
	g_NeedItemID = -1
	g_NeedItemID2 = -1

	g_NeedMoney = 0

	g_NotifyBind = 1

	GemMelting_Accept:Disable()

end

--¸üĞÂ½çÃæ
function GemMelting_Update( pos_ui, pos_packet )

	if pos_ui == 1 then
		GemMelting_UpdateGemItem( pos_ui, pos_packet )
	elseif pos_ui == 2 then
		GemMelting_UpdateNeedItem( pos_ui, pos_packet )
	end

end

--¸üĞÂ±¦Ê¯¸ñ×Ó
function GemMelting_UpdateGemItem( pos_ui, pos_packet )

	--ÊÇ·ñ¼ÓËø....
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--±ØĞëÊÇ±¦Ê¯....
	local Item_Class = PlayerPackage:GetItemSubTableIndex(pos_packet,0)
	if Item_Class ~= 5 then
		PushDebugMessage("#{JKBS_081021_006}")
		return
	end

	local nItemTableIndex = PlayerPackage:GetItemTableIndex(pos_packet)

	--»ñÈ¡ÈÛÁ¶µÄĞÅÏ¢....
	local CurProductID = -1
	local CurNeedItemID = -1
	local CurNeedMoney = 0
	local CurNeedItemID2 = -1
	CurProductID, CurNeedItemID, CurNeedMoney, CurNeedItemID2 = GemMelting:GetGemMeltingInfo(nItemTableIndex)
	if -1 == CurProductID then
		PushDebugMessage("#{JKBS_081021_007}")
		return
	end
	
	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,0)
		g_GemTableIndex = -1
	end

	DataPool:Lua_GemMeltingLayedItem_Update(nItemTableIndex)
	
	local layedGemItem = EnumAction(g_DummyGemLayed, "Gem_Layed")
	if layedGemItem:GetID() ~= 0 then
		g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
		LifeAbility:Lock_Packet_ItemByID(nItemTableIndex,1)
		g_GemTableIndex = nItemTableIndex
	end
	
	local newGemItem = EnumAction(g_DummyNewGem, "Gem_Layed")
	if newGemItem:GetID() ~= 0 then
		g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
	end
	
	GemMelting_Accept:Disable()	
	--ÅĞ¶ÏÖ®Ç°µÄ·ûÊÇ·ñ·ûºÏ
	if g_NeedItemPos ~= -1 then
	
		local nNeedItemTableIndex = PlayerPackage:GetItemTableIndex(g_NeedItemPos)
		
		if CurNeedItemID ~= nNeedItemTableIndex and CurNeedItemID2 ~= nNeedItemTableIndex then
			GemMelting_NeedItem:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_NeedItemPos,0)
			g_NeedItemPos = -1
		else
			local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)
	
			if nGemCount >= 3 then
				--ÆôÓÃÈÛÁ¶°´Å¥
				GemMelting_Accept:Enable()
			end
		end
	end
	
	g_NeedItemID = CurNeedItemID
	g_NeedItemID2 = CurNeedItemID2
	local needItem = "#{BSRL_90512_11}#{_ITEM"..CurNeedItemID.."}"
	if(CurNeedItemID2 ~=-1 ) then
		needItem = needItem.."Ho£c là#{_ITEM"..CurNeedItemID2.."}"
	end
	GemMelting_NeedItem:SetToolTip(needItem)

	--ÏÔÊ¾ËùĞèÇ®Êı
	g_NeedMoney = CurNeedMoney
	GemMelting_NeedMoney:SetProperty("MoneyNumber", tostring(g_NeedMoney))

end

--¸üĞÂÈÛÁ¶·û¸ñ×Ó
function GemMelting_UpdateNeedItem( pos_ui, pos_packet )

	--ÊÇ·ñ¼ÓËø
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--¼ì²âÊÇ·ñÒÑ¾­·ÅÁË±¦Ê¯
	if g_GemTableIndex == -1 then
		PushDebugMessage("#{JKBS_081022_001}")
		return
	end
	
	--ÊÇ·ñÊÇĞèÒªµÄÎïÆ·
	if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID and PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID2 then
		local needItem = "#{JKBS_081021_010}#{_ITEM"..g_NeedItemID.."}"
		if(g_NeedItemID2 ~=-1 ) then
			needItem = needItem.."Ho£c là#{_ITEM"..g_NeedItemID2.."}"
		end
		PushDebugMessage(needItem)
		return
	end

	--¸üĞÂĞèÇóÎïÆ·¸ñµÄAction
	local theAction = EnumAction(pos_packet, "packageitem");
	if theAction:GetID() == 0 then
		return
	end

	if g_NeedItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0)
	end

	g_NeedItemPos = pos_packet;
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 1 )
	GemMelting_NeedItem:SetActionItem(theAction:GetID())
	
	local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)
	
	if nGemCount >= 3 then
		--ÆôÓÃÈÛÁ¶°´Å¥
		GemMelting_Accept:Enable()
	end
	
	g_NotifyBind = 1


end

--Çå³ıActionButton
function GemMelting_Resume_Item( nIndex )

	--Èç¹ûÊÇÒÆ³ı±¦Ê¯¸ñ×ÓÀïµÄ±¦Ê¯....
	if nIndex == 1 then
		GemMelting_Clear()
		return
	end

	--Çå³ıĞèÇóÎïÆ·....
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 0 )
	GemMelting_NeedItem:SetActionItem(-1)
	g_NeedItemPos = -1

	--½ûÓÃÈÛÁ¶°´Å¥....
	GemMelting_Accept:Disable()

end

function GemMelting_RefreshItem()
		
	if g_GemTableIndex ~= -1 then
		
		g_ActionButton_Gem:SetActionItem(-1)
		g_ActionButton_GemNew:SetActionItem(-1)
		LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,0)
	
		DataPool:Lua_GemMeltingLayedItem_Update(g_GemTableIndex)

		local layedGemItem = EnumAction(g_DummyGemLayed, "Gem_Layed")
		if layedGemItem:GetID() ~= 0 then
			g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
			LifeAbility:Lock_Packet_ItemByID(g_GemTableIndex,1)
		end

		local newGemItem = EnumAction(g_DummyNewGem, "Gem_Layed")
		if newGemItem:GetID() ~= 0 then
			g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
		end		
		
		if g_NeedItemPos ~=  -1 then
			
			local nGemMeltingItemTableIndex = PlayerPackage:GetItemTableIndex(g_NeedItemPos)
			
			local CurProductID, CurNeedItemID, CurNeedMoney, CurNeedItemID2 = GemMelting:GetGemMeltingInfo( g_GemTableIndex )
			
			if CurNeedItemID ~= nGemMeltingItemTableIndex and CurNeedItemID2 ~= nGemMeltingItemTableIndex then
				GemMelting_NeedItem:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(g_NeedItemPos,0)
				g_NeedItemPos = -1
				GemMelting_Accept:Disable()
			else
				local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)
	
				if nGemCount >= 3 then
					GemMelting_Accept:Enable()
				else
					GemMelting_Accept:Disable()
				end
			end
		else
			GemMelting_Accept:Disable()
		end
	
	else
		GemMelting_Clear()
	end

end

--È·¶¨
function GemMelting_Buttons_Clicked()

	--ÅĞ¶Ïµç»°ÃÜ±£ºÍ¶ş¼¶ÃÜÂë±£»¤
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then			
		return
	end
	
	--¼ì²âÊÇ·ñÒÑ¾­·ÅÁË±¦Ê¯
	if g_GemTableIndex == -1 then
		return
	end
	
	--Ç®ÊÇ·ñ¹»
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_NeedMoney then
		PushDebugMessage( "#{JKBS_081021_011}" )
		return
	end

	--¼ì²â°ó¶¨×´Ì¬
	local bHaveBind = 0
	if GetItemBindStatus(g_NeedItemPos) == 1 then
		bHaveBind = 1
	end

	local nBindGemCount = PlayerPackage:Lua_GetUnLockBindItemCount(g_GemTableIndex)
	if nBindGemCount > 0 then
		bHaveBind = 1	
	end

	--Èç¹ûÓĞ°ó¶¨µÄÔòĞèÒªÌáÊ¾
	if bHaveBind == 1 and g_NotifyBind == 1 then
		ShowSystemInfo("JKBS_081022_003")
		g_NotifyBind = 0
		return
	end

	--ÈÛÁ¶
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGemMelting")
		Set_XSCRIPT_ScriptID(800118)
		Set_XSCRIPT_Parameter(0,g_GemTableIndex)
		Set_XSCRIPT_Parameter(1,g_NeedItemPos)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

--¹Ø± 
function GemMelting_Close()
	this:Hide();
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--½çÃæÒş²Ø
function GemMelting_OnHide()
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC£¬
--ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
--Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_GemMelting()
	this:CareObject(ObjCaredID, 1, "GemMelting");
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_GemMelting()
	this:CareObject(ObjCaredID, 0, "GemMelting");
end

function GemMelting_Frame_On_ResetPos()
	GemMelting_Frame:SetProperty("UnifiedPosition", g_GemMelting_Frame_UnifiedPosition);
end
