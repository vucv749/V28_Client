--*********************************************
-- äÊŞÌ××°²ğ½â½çÃæ
--*********************************************
local PetEquipSuitDepartName = "PetEquipSuitDepart"
local g_PetEquipItemPos  = -1
local g_PetEquipItemID	 = -1
local g_ObjCareID		 = -1
local g_ServerCareID	 = -1
local g_ProductNeedMoney =  0
local MAX_OBJ_DISTANCE 	 = 3.0;
local g_PetEquipDepartiIndex = 19831205
local g_PetEquipFunCtrl  = -1	--????

local g_PetEquipSuitDepart_Frame_UnifiedPosition;

--**********************************************
--ÊÂ¼ş×¢²á
--**********************************************
function PetEquipSuitDepart_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_PETEQUIP_DEPART") --?????????
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("NEW_DEBUGMESSAGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end


--**********************************************
--
--**********************************************
function PetEquipSuitDepart_OnLoad()
	g_PetEquipSuitDepart_Frame_UnifiedPosition=PetEquipSuitDepart_Frame:GetProperty("UnifiedPosition");
end


--**********************************************
--ÊÂ¼şÏìÓ¦
--**********************************************
function PetEquipSuitDepart_OnEvent( event )
	if (event == "UI_COMMAND") then
		PetEquipSuitDepart_UiCommand(arg0)
	elseif (event == "RESUME_ENCHASE_GEM") then
		PetEquipSuitDepart_Resume_Equip(1)
	elseif (event == "OBJECT_CARED_EVENT") then
		PetEquipSuitDepart_CareEvent(arg0,arg1,arg2)
	elseif (event == "UPDATE_PETEQUIP_DEPART") then
		PetEquipSuitDepart_Update(arg0)
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		PetEquipSuitDepart_PackageItemChange(arg0)
	elseif (event == "MONEYJZ_CHANGE") then
		PetEquipSuitDepart_JZMChange()
	elseif (event == "UNIT_MONEY") then
		PetEquipSuitDepart_UnitMoney()
	elseif (event == "ADJEST_UI_POS" ) then
		PetEquipSuitDepart_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetEquipSuitDepart_Frame_On_ResetPos()
	end
end


--**********************************************
--È·¶¨°´Å¥
--**********************************************
function PetEquipSuitDepart_Buttons_Clicked()
	--ÊÇ·ñ¾É³èÎï×°±¸ ı³£·ÅÈë
	if (g_PetEquipItemPos == -1) then
		return
	end

	--·ÅÈëµÄ¾É×°±¸µÄTableÖĞµÄID
	if (g_PetEquipItemID == -1) then
		return
	end

	--ÅĞ¶ÏÎïÆ·ÊÇ·ñ¼ÓËøºÍ×ã¹»ÔÚ·şÎñÆ÷¶ËÅĞ¶Ï
	if (PlayerPackage:IsLock(g_PetEquipItemPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--·¢ËÍ¸øÉı¼¶ÃüÁî¸ø·şÎñÆ÷
	PetEquipSuitDepart:SetPetEquipDepartFunc("OnPetEquipSuitDepart", 800122, g_PetEquipItemPos, g_ServerCareID, 2)
	PetEquipSuitDepart:ShowConfirm(g_PetEquipItemPos, 17)
end


--*************************************************
--ÖØÖÃ½çÃæ
--*************************************************
function PetEquipSuitDepart_Clear()
	if (g_PetEquipItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_PetEquipItemPos,0);
	end

	PetEquipSuitDepart_OK:Disable()
	PetEquipSuitDepart_Object:SetActionItem(-1)
	PetEquipSuitDepart_Explain_Text1:SetText("#G0%")
	PetEquipSuitDepart_Explain_Text3:SetText("#G0")
	PetEquipSuitDepart_Demand_Jiaozi:SetProperty("MoneyNumber", "")

	g_PetEquipItemPos  = -1
	g_PetEquipItemID   = -1
	g_ProductNeedMoney = 0
end


--*************************************************
--´¦ÀíUI_COMMANDÂß¼­
--*************************************************
function PetEquipSuitDepart_UiCommand(arg0)
	PetEquipSuitDepart_Clear()
	--¼ì²éÊÇ·ñºô½Ğ¸Ã½çÃæ
	local nUiIdx = tonumber(arg0)
	if (nUiIdx ~= g_PetEquipDepartiIndex) then
		return
	end

	--ÊÇ·ñ¹ıÁË°²È«Ê±¼ä....
	if( tonumber(DataPool:GetLeftProtectTime()) >0 ) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end

	--¹ØĞÄµ±Ç°¶Ô»°µÄNPC
	local targetId = Get_XParam_INT(0)
	g_ServerCareID = targetId
	g_ObjCareID = DataPool:GetNPCIDByServerID(targetId);
	if (g_ObjCareID == -1) then
		PushDebugMessage("Dæ li®u máy chü có v¤n ğ«");
		return
	end

	--»ñÈ¡ÊÇÄÇ¸ö·ÖÖ§¹¦ÄÜµÄ¿ØÖÆ·û
	--1 Îª äÊŞ×°±¸ÉıĞÇ¹¦ÄÜ
	g_PetEquipFunCtrl = Get_XParam_INT(1)
	PetEquipSuitDepart_BeginCareObject()
	PetEquipSuitDepart_Clear()
	this:Show();
end


--*************************************************
--´¦ÀíRESUME_ENCHASE_GEMÂß¼­
--*************************************************
function PetEquipSuitDepart_Resume_Equip(Index)
	if (Index ~= 1) then
		return
	end

	LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	PetEquipSuitDepart_Object:SetActionItem(-1)
	g_PetEquipItemPos=-1
	PetEquipSuitDepart_Clear()
	PetEquipSuitDepart_Demand_Jiaozi:SetProperty("MoneyNumber", "")
	PetEquipSuitDepart_OK:Disable()
end

--*************************************************
--´¦ÀíOBJECT_CARED_EVENTÂß¼­
--*************************************************
function PetEquipSuitDepart_CareEvent(arg0,arg1,arg2)
	local ObjCaredID = tonumber(arg0)
	if( ObjCaredID ~= g_ObjCareID) then
		return
	end

	local ObjDistance = tonumber(arg2)
	if( (arg1 == "distance" and ObjDistance>MAX_OBJ_DISTANCE) or arg1=="destroy") then
		PetEquipSuitDepart_Close()
	end
end

--*************************************************
--´¦ÀíUPDATE_PETEQUIP_UPÂß¼­ ½çÃæ¸üĞÂ
--*************************************************
function PetEquipSuitDepart_Update(pos_packet)
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber(pos_packet)
	--ÊÇ·ñ¼ÓËø....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--¸üĞÂÉú³ÉÎïÆ·µÄAction
	local ItemID = PlayerPackage:GetItemTableIndex(BagPos)
	--Í¨¹ı±í»ñÈ¡Éú³É²ÄÁÏID¡¢²ÄÁÏÊıÄ¿¡¢²ÄÁÏÃû³Æ¡¢Éı¼¶¼¸ÂÊ¡¢ĞèÒª½ğÇ®ÊıÄ¿¡¢
	local nMaterialID,nMaterialNum,nPercent = PetEquipSuitDepart:GetPetEquipDepartInfo(ItemID) --debug
	if (-1 == nMaterialID) then
		PushDebugMessage("#{ZSZBSJ_090706_08}")
		return
	end

	--¸üĞÂĞèÇóÎïÆ·¸ñµÄAction....
	local theAction = EnumAction(BagPos, "packageitem");
	if (theAction:GetID() == 0) then
		return
	end

	if (g_PetEquipItemPos ~= -1) then
		LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	end

	LifeAbility:Lock_Packet_Item(BagPos, 1)
	PetEquipSuitDepart_Object:SetActionItem(theAction:GetID())

	g_PetEquipItemPos=BagPos


	g_PetEquipItemID	= ItemID
	g_ProductNeedMoney  = 0
	PetEquipSuitDepart_Explain_Text1:SetText("#G"..tostring(nPercent).."%")
	PetEquipSuitDepart_Explain_Text3:SetText("#G"..tostring(nMaterialNum))

	PetEquipSuitDepart_OK:Enable()
	PetEquipSuitDepart:SetPetEquipDepartFunc("OnPetEquipSuitDepart", 800122, -1, -1, 0)
end


--*************************************************
--´¦ÀíPACKAGE_ITEM_CHANGEDÂß¼­
--*************************************************
function PetEquipSuitDepart_PackageItemChange(arg0)
	if (this:IsVisible() == 0) then
		return
	end

	local NumArg0 = tonumber(arg0)
	if (arg0~= nil and -1 == NumArg0) then
		return
	end


	if (g_PetEquipItemPos == NumArg0) then
		PetEquipSuitDepart_Resume_Equip(1)
	end
end

--*************************************************
--´¦ÀíUNIT_MONEYÂß¼­
--*************************************************
function PetEquipSuitDepart_UnitMoney()
	PetEquipSuitDepart_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
end

--*************************************************
--´¦ÀíMONEYJZ_CHANGEÂß¼­
--*************************************************
function PetEquipSuitDepart_JZMChange()
	PetEquipSuitDepart_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

--*************************************************
--¿ªÊ¼¹ØĞÄNPC£¬¾ÍÊÇÈ·ÈÏÍæ¼Òµ±Ç°²Ù×÷µÄNPC£¬Èç¹ûÀëNPC
--Ì«Ô¶¾Í»á¹Ø± ´°¿ÚÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæ
--ÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­
--ÓĞµÄ¡°¹ØĞÄ¡±
--*************************************************
function PetEquipSuitDepart_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "PetEquipSuitDepart");
end


--*************************************************
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--*************************************************
function PetEquipSuitDepart_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "PetEquipSuitDepart");
end

--*************************************************
--¹Ø± ½çÃæ
--*************************************************
function PetEquipSuitDepart_Close()
	this:Hide()
	PetEquipSuitDepart_StopCareObject()
	PetEquipSuitDepart_Clear()
end


function PetEquipSuitDepart_OnHiden()
	PetEquipSuitDepart_Close()
end


function PetEquipSuitDepart_Frame_On_ResetPos()
  PetEquipSuitDepart_Frame:SetProperty("UnifiedPosition", g_PetEquipSuitDepart_Frame_UnifiedPosition);
end
