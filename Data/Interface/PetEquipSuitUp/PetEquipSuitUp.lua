--*********************************************
-- äÊÞÌ××°Éý¼¶½çÃæ
--*********************************************

local PetEquipSuitUpName = "PetEquipSuitUp"
local g_PetEquipItemPos  = -1
local g_PetEquipItemID	 = -1
local g_PetEquipProductID= -1
local g_ObjCareID		 = -1
local g_ProductNeedMoney = 0
local g_PetEquipUiIndex	 = 19831204
local MAX_OBJ_DISTANCE 	 = 3.0;
local g_PetEquipFunCtrl  = -1	--????


local g_PetEquipSuitUp_Frame_UnifiedPosition;

--**********************************************
--ÊÂ¼þ×¢²á
--**********************************************
function PetEquipSuitUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_PETEQUIP_UP") --?????????
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("NEW_DEBUGMESSAGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end


--**********************************************
--
--**********************************************
function PetEquipSuitUp_OnLoad()
	g_PetEquipSuitUp_Frame_UnifiedPosition=PetEquipSuitUp_Frame:GetProperty("UnifiedPosition");
end


--**********************************************
--ÊÂ¼þÏìÓ¦
--**********************************************
function PetEquipSuitUp_OnEvent( event )
	if (event == "UI_COMMAND") then
		PetEquipSuitUp_UiCommand(arg0)
	elseif (event == "UNIT_MONEY") then
		PetEquipSuitUp_UnitMoney()
	elseif (event == "MONEYJZ_CHANGE") then
		PetEquipSuitUp_JZMChange()
	elseif (event == "RESUME_ENCHASE_GEM") then
		PetEquipSuitUp_Resume_Equip(1)
	elseif (event == "OBJECT_CARED_EVENT") then
		PetEquipSuitUp_CareEvent(arg0,arg1,arg2)
	elseif (event == "UPDATE_PETEQUIP_UP") then
		PetEquipSuitUp_Update(arg0)
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		PetEquipSuitUp_PackageItemChange(arg0)
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetEquipSuitUp_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetEquipSuitUp_Frame_On_ResetPos()
	end
end


--**********************************************
--È·¶¨°´Å¥
--**********************************************
function PetEquipSuitUp_Buttons_Clicked()
	--ÊÇ·ñ¾É³èÎï×°±¸ ý³£·ÅÈë
	if (g_PetEquipItemPos == -1 or g_PetEquipProductID == -1) then
		return
	end

	--·ÅÈëµÄ¾É×°±¸µÄTableÖÐµÄID
	if (g_PetEquipItemID == -1) then
		return
	end

	--ÅÐ¶ÏÎïÆ·ÊÇ·ñ¼ÓËøºÍ×ã¹»ÔÚ·þÎñÆ÷¶ËÅÐ¶Ï

	--ÅÐ¶Ï½ðÇ®ÊÇ²»ÊÇ¹»
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if (selfMoney < g_ProductNeedMoney) then
		PushDebugMessage( "Không ðü ti«n, không th¬ tiªn hành thång c¤p Trang B¸ Trân Thú!" )
		return
	end

	--·¢ËÍ¸øÉý¼¶ÃüÁî¸ø·þÎñÆ÷
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnPetEquipSuitUp")
		Set_XSCRIPT_ScriptID(800109)
		Set_XSCRIPT_Parameter(0,g_PetEquipItemPos)
		Set_XSCRIPT_Parameter(1,g_ObjCareID)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	PetEquipSuitUp_Clear()
end


--*************************************************
--ÖØÖÃ½çÃæ
--*************************************************
function PetEquipSuitUp_Clear()
	if (g_PetEquipItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_PetEquipItemPos,0);
	end

	PetEquipSuitUp_Accept:Disable()
	PetEquipSuitUp_GemItem:SetActionItem(-1)
	PetEquipSuitUp_ProductItem:SetActionItem(-1)
	PetEquipSuitUp_ProductItem:Hide();
	PetEquipSuitUp_Explain2_Info:SetText("#{ZSZBSJ_XML_05}")
	PetEquipSuitUp_Explain4:SetText("#{ZSZBSJ_XML_03}")
	PetEquipSuitUp_Demand_Jiaozi:SetProperty("MoneyNumber", "")
	PetEquipSuitUp_Explain3_Text2:SetText("")
	g_PetEquipItemPos  = -1
	g_PetEquipItemID   = -1
	g_PetEquipProductID= -1
	g_ProductNeedMoney = 0
end

--*************************************************
--´¦ÀíUI_COMMANDÂß¼­
--*************************************************
function PetEquipSuitUp_UiCommand(arg0)

	--¼ì²éÊÇ·ñºô½Ð¸Ã½çÃæ
	local nUiIdx = tonumber(arg0)
	if (nUiIdx ~= g_PetEquipUiIndex) then
		return
	end

	--¹ØÐÄµ±Ç°¶Ô»°µÄNPC
	local targetId = Get_XParam_INT(0)
	g_ObjCareID = DataPool:GetNPCIDByServerID(targetId);
	if (g_ObjCareID == -1) then
		PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
		return
	end

	--»ñÈ¡ÊÇÄÇ¸ö·ÖÖ§¹¦ÄÜµÄ¿ØÖÆ·û
	--1 Îª äÊÞ×°±¸ÉýÐÇ¹¦ÄÜ
	g_PetEquipFunCtrl = Get_XParam_INT(1)

	PetEquipSuitUp_BeginCareObject()
	PetEquipSuitUp_Clear()
	this:Show();
end

--*************************************************
--´¦ÀíUNIT_MONEYÂß¼­
--*************************************************
function PetEquipSuitUp_UnitMoney()
	PetEquipSuitUp_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
end

--*************************************************
--´¦ÀíMONEYJZ_CHANGEÂß¼­
--*************************************************
function PetEquipSuitUp_JZMChange()
	PetEquipSuitUp_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

--*************************************************
--´¦ÀíRESUME_ENCHASE_GEMÂß¼­
--*************************************************
function PetEquipSuitUp_Resume_Equip(Index)
	if (Index ~= 1) then
		return
	end

	LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	PetEquipSuitUp_GemItem:SetActionItem(-1)
	g_PetEquipItemPos=-1
	PetEquipSuitUp_Clear()
	PetEquipSuitUp_ProductItem:SetActionItem(-1)
	g_PetEquipProductID=-1
	PetEquipSuitUp_Demand_Jiaozi:SetProperty("MoneyNumber", "")
	PetEquipSuitUp_Accept:Disable()
end

--*************************************************
--´¦ÀíOBJECT_CARED_EVENTÂß¼­
--*************************************************
function PetEquipSuitUp_CareEvent(arg0,arg1,arg2)
	local ObjCaredID = tonumber(arg0)
	if( ObjCaredID ~= g_ObjCareID) then
		return
	end

	local ObjDistance = tonumber(arg2)
	if( (arg1 == "distance" and ObjDistance>MAX_OBJ_DISTANCE) or arg1=="destroy") then
		PetEquipSuitUp_Close()
	end
end

--*************************************************
--´¦ÀíUPDATE_PETEQUIP_UPÂß¼­ ½çÃæ¸üÐÂ
--*************************************************
function PetEquipSuitUp_Update( pos_packet )
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber(pos_packet)

	--deleted by guochenshu for TT:66411
	--ÊÇ·ñ¼ÓËø....
	--if (PlayerPackage:IsLock(BagPos) == 1) then
	--	PushDebugMessage("#{Item_Locked}")
	--	return
	--end

	local ItemID = PlayerPackage:GetItemTableIndex(BagPos)
	--Í¨¹ý±í»ñÈ¡Éú³ÉÎïÆ·ID¡¢ÐèÒª½ðÇ®ÊýÄ¿¡¢Éý¼¶¼¸ÂÊ¡¢²ÄÁÏÖÖÀà
	local nProductID,nPercent,nNeedMoney,nMaterialKind, strImpact= PetEquipSuitUp:GetPetEquipUpProductInfo(ItemID, 0) --debug

	if (-1 == nProductID) then
		PushDebugMessage("#{ZSZBSJ_090706_03}")
		return
	end

	--¸üÐÂÐèÇóÎïÆ·¸ñµÄAction....
	local theAction = EnumAction(BagPos, "packageitem");
	if (theAction:GetID() == 0) then
		return
	end

	if (g_PetEquipItemPos ~= -1) then
		LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	end
	LifeAbility:Lock_Packet_Item(BagPos, 1)
	PetEquipSuitUp_GemItem:SetActionItem(theAction:GetID())

	g_PetEquipItemPos=BagPos
	--¸üÐÂÉú³ÉÎïÆ·µÄAction
	g_PetEquipItemID	= ItemID
	g_PetEquipProductID = nProductID
	g_ProductNeedMoney  = nNeedMoney

	PetEquipSuitUp_Explain4:SetText("#{ZSZBSJ_XML_04}")
	local ProductAction = PetEquipSuitUp:UpdateProductAction(nProductID,BagPos) --debug
	if (ProductAction and ProductAction:GetID() ~= 0) then
		PetEquipSuitUp_ProductItem:SetActionItem(ProductAction:GetID());
		PetEquipSuitUp_ProductItem:Show()
	else
		PetEquipSuitUp_ProductItem:SetActionItem(-1);
	end

	--¸üÐÂÐèÒª½ðÇ®ÊýÄ¿
	PetEquipSuitUp_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(g_ProductNeedMoney))
	PetEquipSuitUp_Explain3_Text2:SetText("#G"..tostring(nPercent).."%")

	--¸ù¾ÝTableÖÐµÄID»ñÈ¡ËùÐèÒªµÄ²ÄÁÏ
	local nMaterial = {
					  [1] = {id=0,num=0,name="",},
					  [2] = {id=0,num=0,name="",},
					  [3] = {id=0,num=0,name="",},
					  }
	local szTipInfo = "#{ZSZBSJ_XML_06}"
	if (nMaterialKind > 0) then
		for i=1,nMaterialKind do
			nMaterial[i].id,nMaterial[i].num,nMaterial[i].name = PetEquipSuitUp:GetPetEquipUpMaterial(g_PetEquipItemID, 0, i) --debug
			if (-1 ~= nMaterial[i].id) then
				szTipInfo = szTipInfo..nMaterial[i].name.."#G"..nMaterial[i].num..";"
			end
		end

		if (strImpact ~= nil) then
			szTipInfo = szTipInfo.."\n"..strImpact
		end

		PetEquipSuitUp_Explain2_Info:SetText(szTipInfo)
	end

	PetEquipSuitUp_Accept:Enable()
end


--*************************************************
--´¦ÀíPACKAGE_ITEM_CHANGEDÂß¼­
--*************************************************
function PetEquipSuitUp_PackageItemChange(arg0)
	if (this:IsVisible() == 0) then
		return
	end

	local NumArg0 = tonumber(arg0)
	if (arg0~= nil and -1 == NumArg0) then
		return
	end


	if (g_PetEquipItemPos == NumArg0) then
		PetEquipSuitUp_Resume_Equip(1)
	end
end

--*************************************************
--¿ªÊ¼¹ØÐÄNPC£¬¾ÍÊÇÈ·ÈÏÍæ¼Òµ±Ç°²Ù×÷µÄNPC£¬Èç¹ûÀëNPC
--Ì«Ô¶¾Í»á¹Ø± ´°¿ÚÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæ
--ÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­
--ÓÐµÄ¡°¹ØÐÄ¡±
--*************************************************
function PetEquipSuitUp_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "PetEquipSuitUp");
end


--*************************************************
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--*************************************************
function PetEquipSuitUp_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "PetEquipSuitUp");
end

--*************************************************
--¹Ø± ½çÃæ
--*************************************************
function PetEquipSuitUp_Close()
	this:Hide()
	PetEquipSuitUp_StopCareObject()
	PetEquipSuitUp_Clear()
end


function PetEquipSuitUp_OnHide()
	PetEquipSuitUp_Close()
end

function PetEquipSuitUp_Frame_On_ResetPos()
  PetEquipSuitUp_Frame:SetProperty("UnifiedPosition", g_PetEquipSuitUp_Frame_UnifiedPosition);
end
