
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWHECHENG_Item = -1
local g_DWHECHENG_DemandMoney = 50000
local g_DWHECHENG_GRID_SKIP = 95

local g_DWHECHENG_Action_Type = 4
local g_DWHECHENG_RScript_ID = 809272
local g_DWHECHENG_RSCript_Name = "DoDiaowenAction"

local g_DWHecheng_Frame_UnifiedPosition;

--=========================================================
-- ×¢²á´°¿Ú¹ØĞÄµÄËùÓĞÊÂ¼ş
--=========================================================
function DWHecheng_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWHECHENG")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWHECHENG")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function DWHecheng_OnLoad()
	g_DWHECHENG_Item = -1
	g_DWHECHENG_DemandMoney = 50000
	DWHecheng_OK:Enable()
	
	g_DWHecheng_Frame_UnifiedPosition=DWHecheng_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- ÊÂ¼ş´¦Àí
--=========================================================
function DWHecheng_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 1000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u máy chü có v¤n ğ«")
			return
		end
		BeginCareObject_DWHecheng()
		DWHecheng_Clear()
		DWHecheng_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWHecheng_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWHECHENG_Item == tonumber(arg0)) then
			DWHecheng_Resume_Equip()
		end
	elseif (event == "UPDATE_DWHECHENG") then
		if arg0 ~= nil then
			DWHecheng_Update(arg0)
		end
		DWHecheng_UpdateBasic()
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWHecheng_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == (g_DWHECHENG_GRID_SKIP + 1) then
			DWHecheng_Resume_Equip()
			DWHecheng_UpdateBasic()
		end
	elseif (event == "CONFIRM_DWHECHENG") then
		DWHecheng_OK_Clicked(1)
	
	elseif (event == "ADJEST_UI_POS" ) then
		DWHecheng_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWHecheng_Frame_On_ResetPos()
	end
end

--=========================================================
-- ¸üĞÂ»ù±¾ÏÔÊ¾ĞÅÏ¢
--=========================================================
function DWHecheng_UpdateBasic()
	DWHecheng_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWHecheng_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- ¼ÆËãËùĞè½ğÇ®
	if g_DWHECHENG_Item == -1 then
		g_DWHECHENG_DemandMoney = 0
	else
		g_DWHECHENG_DemandMoney = 50000
	end
	DWHecheng_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWHECHENG_DemandMoney))

	DWHecheng_OK:Enable()
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWHecheng_Clear()
	if g_DWHECHENG_Item ~= -1 then
		DWHecheng_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWHECHENG_Item, 0)
		g_DWHECHENG_Item = -1
	end

	g_DWHECHENG_DemandMoney = 50000
	DWHecheng_UpdateBasic()
end

--=========================================================
-- ¸üĞÂ½çÃæ
--=========================================================
function DWHecheng_Update(itemIndex)
	local index = tonumber(itemIndex)
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- ÅĞ¶ÏÊÇ·ñÎª°²È«Ê±¼ä
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñÎªµñÎÆÍ¼Ñù
		if LifeAbility:IsDiaowenPic(index) == -1 then
			PushDebugMessage("#{ZBDW_091105_2}")
			return
		end

		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñ¼ÓËø(ÔÚ â¸öÂß¼­Ö®Ç°³ÌĞòÒÑ¾­ÅĞ¶ÏÁË)
		if PlayerPackage:IsLock(index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end
		
		-- Èç¹û¿ ¸ñÄÚÒÑ¾­ÓĞÍ¼ÑùÁË, Ìæ»»Ö®
		if g_DWHECHENG_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWHECHENG_Item, 0)
		end
		DWHecheng_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWHECHENG_Item = index

	else
		DWHecheng_Clear()
	end
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWHecheng_Resume_Equip()
	if this:IsVisible() then
		DWHecheng_Clear()
	end
end

--=========================================================
-- ÅĞ¶ÏÊÇ·ñËùÓĞÎïÆ·¶¼ÒÑ·ÅºÃ
-- Ö»ÔÚµã»÷ OK °´Å¥µÄÊ±ºòµ÷ÓÃ â¸öº¯Êı
--=========================================================
function DWHecheng_Check_AllItem()
	DWHecheng_UpdateBasic()

	if g_DWHECHENG_Item == -1 then
		return 1
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWHECHENG_DemandMoney then
		return 44
	end

	return 0
end


local EB_FREE_BIND = 0;				-- ?????
local EB_BINDED = 1;				-- ????
local EB_GETUP_BIND =2			-- ????
local EB_EQUIP_BIND =3			-- ????
--=========================================================
-- È·¶¨Ö´ĞĞ¹¦ÄÜ
--=========================================================
function DWHecheng_OK_Clicked(okFlag)
	local ret = DWHecheng_Check_AllItem()
	if ret == 1 then
		PushDebugMessage("#{ZBDW_091105_2}")
	elseif ret == 44 then
		PushDebugMessage("#{GMGameInterface_Script_PlayerMySelf_Info_Money_Not_Enough}")
	end

	if ret == 0 then
		-- ¼ì²é°ó¶¨Çé¿ö
		local picBindState = PlayerPackage:GetItemBindStatusByIndex(g_DWHECHENG_Item)
		local isNeedConfirm = 0
		-- µÃµ½Íæ¼Ò±³°üÀïµÄ²ÄÁÏĞÅÏ¢
		local matInfo = PlayerPackage:CheckDiaowenHechengMat(g_DWHECHENG_Item)
		--PushDebugMessage(picBindState)
		if picBindState ~= EB_BINDED then
			-- ¸ù¾İµñÎÆÍ¼Ñù, ÅĞ¶ÏÍæ¼Ò±³°üÀïÊÇ·ñ´æÔÚ¿ÉÄÜÓÃµ½µÄ°ó¶¨µÄºÏ³É²ÄÁÏ
			if matInfo == -2 then
				isNeedConfirm = 1
			end
		else
			isNeedConfirm = 1
		end

		-- Èç¹ûÃ»ÓĞ°ó¶¨µÄºÏ³É²ÄÁÏºÍºÏ³É·û, ²ÄÁÏ×ã¹»Ö±½ÓºÏ³É
		-- Èç¹ûÊÇÍæ¼Òµã»÷ÁË°ó¶¨ÌáÊ¾ĞÅÏ¢µÄÈ·ÈÏ°´Å¥, Ö±½ÓºÏ³É
		if (isNeedConfirm ~= 1 and matInfo == 1) or (okFlag ~= nil and okFlag == 1) then
			-- Ö´ĞĞµñÎÆºÏ³É¹¦ÄÜ
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name(g_DWHECHENG_RSCript_Name)
				Set_XSCRIPT_ScriptID(g_DWHECHENG_RScript_ID)
				Set_XSCRIPT_Parameter(0, g_DWHECHENG_Action_Type)
				Set_XSCRIPT_Parameter(1, g_DWHECHENG_Item)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		elseif okFlag == nil then
			if matInfo == -1 then
				-- Èç¹û²ÄÁÏ²»¹», ÌáÊ¾ĞÅÏ¢
				PushDebugMessage("#{ZBDW_091105_4}")
			elseif isNeedConfirm == 1 then
				-- Èç¹û²ÄÁÏ×ã¹», µ«ÊÇÓĞ°ó¶¨²ÄÁÏ, ÏÔÊ¾È·ÈÏ´°¿Ú
				if LifeAbility:ConfirmDiaowenHecheng(0) < 0 then
					-- ³ö´íÁË? ¹îÒìÊÂ¼ş, ÔİÊ±²»ÓèÀí»áßÀ....
				end
			end
		end
	end
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function DWHecheng_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒş²Ø
--=========================================================
function DWHecheng_OnHiden()
	StopCareObject_DWHecheng()
	DWHecheng_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØĞÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
-- Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_DWHecheng()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWHecheng")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_DWHecheng()
	this:CareObject(g_CaredNpc, 0, "DWHecheng")
	g_CaredNpc = -1
	return
end

--=========================================================
-- Íæ¼Ò½ğÇ®±ä»¯
--=========================================================
function DWHecheng_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- ÅĞ¶Ï½ğÇ®¹»²»¹»
	if selfMoney < g_DWHECHENG_DemandMoney then
		return -1
	end
	return 1
end

function DWHecheng_Frame_On_ResetPos()
  DWHecheng_Frame:SetProperty("UnifiedPosition", g_DWHecheng_Frame_UnifiedPosition);
end
