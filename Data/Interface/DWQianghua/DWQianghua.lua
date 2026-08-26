
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWQIANGHUA_Item = -1
local g_DWQIANGHUA_DemandMoney = 0
local g_DWQIANGHUA_GRID_SKIP = 96
-- ½ğ²ÏË¿, Ç¿»¯ÓÃµÄµÀ¾ß, °´   °ó¶¨ -> Ôª±¦½»Ò× -> Ëæ±ã½»Ò× Ë³ĞòÊ¹ÓÃ
local g_DWQIANGHUA_ToolItem = {20310168, 20310166, 20310167}
local g_DWQIANGHUA_Tool_Num = tonumber(1)
local g_DWQIANGHUA_NUM_LOW = tonumber(1)
local g_DWQIANGHUA_NUM_UP = tonumber(100000)

local g_DWQIANGHUA_Action_Type = 2
local g_DWQIANGHUA_RScript_ID = 809272
local g_DWQIANGHUA_RScript_Name = "DoDiaowenAction"

local g_DWQianghua_Frame_UnifiedPosition;

--=========================================================
-- ×¢²á´°¿Ú¹ØĞÄµÄËùÓĞÊÂ¼ş
--=========================================================
function DWQianghua_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWQIANGHUA")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWQIANGHUA")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("DW_QHSJ_UI_CHANGE")
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function DWQianghua_OnLoad()
	g_DWQIANGHUA_Item = -1
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
	g_DWQIANGHUA_Tool_Num = tonumber(1)
	DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
	-- Ê¼Ö ¿ÉÒÔµã»÷ OK °´Å¥, ÎªÁË·½±ãÌáÊ¾Íæ¼ÒĞÅÏ¢
	DWQianghua_OK:Enable()
	
	g_DWQianghua_Frame_UnifiedPosition=DWQianghua_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- ÊÂ¼ş´¦Àí
--=========================================================
function DWQianghua_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 3000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u máy chü có v¤n ğ«")
			return
		end
		BeginCareObject_DWQianghua()
		DWQianghua_Clear()
		DWQianghua_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWQianghua_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		-- ¿ÉÒÔ¸Ä³ÉÔÊĞí½Ó×ÅÇ¿»¯, ÄÇ¾Í²»ÒªÔÚ âÀïÒÆ³ıÎïÆ·
		if tonumber(arg0) == g_DWQIANGHUA_Item then
			-- Ç¿»¯ºó²»½«×°±¸·µ»¹µ½°ü¹ü, Ö§³Ö³ÖĞøÇ¿»¯ - 2009-12-07
			--DWQianghua_Resume_Equip()
			DWQianghua_UpdateBasic()
		end
	elseif (event == "UPDATE_DWQIANGHUA") then
		--¼ÓÔØ âÀïºÜÈİÒ×µ¼ÖÂ½çÃæ´¦Àí²»¹ıÀ´,  â¸öÊÂ¼şÌØ±ğ¶à
		--DWQianghua_UpdateBasic()
		if arg0 ~= nil then
			DWQianghua_Update(arg0)
			DWQianghua_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWQianghua_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == (g_DWQIANGHUA_GRID_SKIP + 1) then
			DWQianghua_Resume_Equip()
			DWQianghua_UpdateBasic()
		end
	elseif (event == "CONFIRM_DWQIANGHUA") then
		DWQianghua_OK_Clicked(1)
		
	elseif (event == "ADJEST_UI_POS" ) then
		DWQianghua_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWQianghua_Frame_On_ResetPos()
	elseif (event == "DW_QHSJ_UI_CHANGE" and tonumber(arg0)==1) then
		if tonumber(arg1) == nil then
			return
		end
		g_CaredNpc = tonumber(arg1)
		BeginCareObject_DWQianghua()
		DWQianghua_Clear()
		DWQianghua_UpdateBasic()
		--µ÷ û½çÃæÎ»ÖÃ
		if tostring(arg2) ~= nil then
			DWQianghua_Frame:SetProperty("UnifiedPosition", tostring(arg2));
		end
		this:Show()
	end
end

--=========================================================
-- ¸üĞÂ»ù±¾ÏÔÊ¾ĞÅÏ¢
-- ÔÚ âÀï¼ÆËã½ğÇ®²¢ÏÔÊ¾
--=========================================================
function DWQianghua_UpdateBasic(nToolNum)
	DWQianghua_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWQianghua_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	if nToolNum == nil then
		nToolNum = g_DWQIANGHUA_Tool_Num
	end
	DWQianghua_SetToolNumAndText(nToolNum)

	-- ¼ÆËãËùĞè½ğÇ®
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))

	DWQianghua_CLneed_Text:SetText("")

	if g_DWQIANGHUA_Item ~= -1 then
		local curExp,LevelUpNeed = LifeAbility:GetEquipDWCurExp(g_DWQIANGHUA_Item)
		if curExp >= 0 then
			if LevelUpNeed == -1 then
				DWQianghua_CLneed_Text:SetText("#{DWJJ_240329_322}")
			else
				DWQianghua_CLneed_Text:SetText(curExp.."/"..LevelUpNeed)
			end
		end
	end
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWQianghua_Clear()
	if g_DWQIANGHUA_Item ~= -1 then
		DWQianghua_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
		g_DWQIANGHUA_Item = -1
	end

	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
	DWQianghua_NumericalValue:SetProperty("DefaultEditBox", "True")
	DWQianghua_NumericalValue:SetSelected(0, -1)

end

--=========================================================
-- ¸üĞÂ½çÃæ
--=========================================================
function DWQianghua_Update(itemIndex)
	local index = tonumber(itemIndex)
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- ÅĞ¶ÏÊÇ·ñÎª°²È«Ê±¼ä
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		local ret = LifeAbility:CanEquipDiaowen_Enchase(index)
		if ret == -1 or ret == -2 then
			-- ²»ÊÇÒ»¸öÒÑ¾­Ê´¿ÌÁËµñÎÆµÄ×°±¸
			PushDebugMessage("#{ZBDW_091105_11}")
			return
		elseif ret == -3 then
			-- ×°±¸ÉÏµÄµñÎÆÒÑ¾­Ç¿»¯Âú¼¶, ²»ÄÜÔÙÇ¿»¯
			PushDebugMessage("Hoa vån trên trang b¸ các hÕ không th¬ cß¶ng hóa næa.")
			return
		end

		-- µñÎÆÇ¿»¯²»ÅĞ¶Ï×°±¸ÊÇ·ñ¼ÓËøÁË - 2009-12-07
		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñ¼ÓËø(ÔÚ â¸öÂß¼­Ö®Ç°³ÌĞòÒÑ¾­ÅĞ¶ÏÁË)
--		if PlayerPackage:IsLock(index) == 1 then
--			PushDebugMessage("#{ZBDW_091105_3}")
--			return
--		end

		-- Èç¹û¿ ¸ñÄÚÒÑ¾­ÓĞ¶ÔÓ¦ÎïÆ·ÁË, Ìæ»»Ö®
		if g_DWQIANGHUA_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
		end

		DWQianghua_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWQIANGHUA_Item = index

		local curExp,LevelUpNeed = LifeAbility:GetEquipDWCurExp(index)
		if curExp >= 0 then
			if LevelUpNeed == -1 then
				DWQianghua_CLneed_Text:SetText("#{DWJJ_240329_322}")
			else
				DWQianghua_CLneed_Text:SetText(curExp.."/"..LevelUpNeed)
			end
		end

		-- Éè¶¨ OK Îª×ÜÊÇ¿ÉÒÔµã»÷,  âÑù·½±ã¼ìÑé
		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñÂú×ãÒªÇóÀ´Éè¶¨¹¦ÄÜbutton
		-- DWQianghua_Check_AllItem()
	else
		DWQianghua_Clear()
	end
end

--=========================================================
-- Ôö¼Ó½ğ²ÏË¿µÄÊıÁ¿
--=========================================================
function DWQianghua_Addition_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num + 1)
end

--=========================================================
-- ¼õÉÙ½ğ²ÏË¿µÄÊıÁ¿
--=========================================================
function DWQianghua_Decrease_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num - 1)
end

--=========================================================
-- ½ğ²ÏË¿ÊıÁ¿¸Ä±ä
--=========================================================
function DWQianghua_ToolNumChange()
	local num = DWQianghua_NumericalValue:GetProperty("Text")
	-- ÊäÈë¿ò¸Ä±äÁË, ²»ÒªÔÙ¸Ä±äÊäÈë¿òµÄÄÚÈİ, ²»È»ÓÃ»§¾ÍÃ»·¨ÔÙÊäÈë¿òÊäÈëÊı×ÖÁË
	-- ´úÂëÖ÷¶¯ĞŞ¸ÄµÄÎÄ±¾
	if num == nil or (not num) or num == "" or tonumber(num) < g_DWQIANGHUA_NUM_LOW then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		return
	end
	-- Èç¹ûÓÃ»§É¾³ıÊäÈë¿òµÄËùÓĞÄÚÈİ, tonumber µÄ½á¹û±È½Ï¹îÒì, ÎŞ·¨×Ô¶¯ÉèÖÃÎªÄ³¸öÖµ
	num = tonumber(num)
	if num == g_DWQIANGHUA_Tool_Num then
		return
	end
	-- Íæ¼ÒÊäÈëÎÄ±¾: Ê×ÏÈ¶ÔÓĞĞ§ num ½øĞĞ±£´æ, ²»È»¿ÉÄÜÓ°ÏìÍæ¼ÒÊäÈë
	if tonumber(num) >= g_DWQIANGHUA_NUM_LOW and tonumber(num) <= g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = tonumber(num)
	elseif tonumber(num) > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_UP
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		--DWQianghua_SetToolNumAndText(g_DWQIANGHUA_NUM_UP)
	else
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		--DWQianghua_SetToolNumAndText(g_DWQIANGHUA_NUM_LOW)
	end
	--ºÜÈİÒ×µ¼ÖÂËÀÑ­»·, ÓÉÓÚ½ğÇ®ºÍÇ¿»¯ÊıÁ¿ÎŞ¹Ø, ²»ĞèÒª¸üĞÂÁË.
	--DWQianghua_UpdateBasic(num)
end

--=========================================================
-- ½ğ²ÏË¿ÊıÁ¿µÄÊäÈë¿òÊ§È¥½¹µã?
--=========================================================
function DWQianghua_TextLost()
	DWQianghua_ToolNumChange()
end

--=========================================================
-- ¸ü¸Ä½ğ²ÏË¿ÊıÁ¿²¢ÉèÖÃ±äÁ¿
-- ÎªÁË±£Ö¤ âÁ½¸ö²Ù×÷Ê¼Ö Í³Ò»
--=========================================================
function DWQianghua_SetToolNumAndText(count)
	local num = tonumber(count)
	-- ×¢Òâ âÀï²»ÒªºÍ DWQianghua_ToolNumChange() ²úÉúËÀÑ­»·ÁË
	if count == nil or count == "" or num < g_DWQIANGHUA_NUM_LOW then
		-- ÊäÈëÌ«Ğ¡µÄÊı
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
	elseif num > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_UP
	elseif num == g_DWQIANGHUA_Tool_Num then
		return
	else
		g_DWQIANGHUA_Tool_Num = num
	end

	DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWQianghua_Resume_Equip()
	if this:IsVisible() then
		if g_DWQIANGHUA_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
			DWQianghua_Object:SetActionItem(-1)
			g_DWQIANGHUA_Item = -1
		end
	end

	-- ÖØĞÂ³õÊ¼»¯½ğ²ÏË¿µÄÊıÁ¿
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
end

--=========================================================
-- ÅĞ¶ÏÊÇ·ñËùÓĞÎïÆ·¶¼ÒÑ·ÅºÃ
-- Ö»ÔÚµã»÷ OK °´Å¥µÄÊ±ºòµ÷ÓÃ â¸öº¯Êı
--=========================================================
function DWQianghua_Check_AllItem()
	DWQianghua_UpdateBasic()

	if g_DWQIANGHUA_Item == -1 then
		g_DWQIANGHUA_DemandMoney = 0
		DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
		return 1
	end

	-- ÅĞ¶Ï×°±¸ÊÇ·ñÄÜ¹»Ç¿»¯(Ã»ÓĞÊ´¿ÌµñÎÆ»ò ßÇ¿»¯µ½¶¥¼¶ÁË·µ»Ø < 0)
	local ret = LifeAbility:CanEquipDiaowen_Enchase(g_DWQIANGHUA_Item)
	if ret == -1 or ret == -2 then
		return 2
	end
	if ret < 0 then
		return 3
	end

	-- ÅĞ¶Ï½ğ²ÏË¿ÊıÁ¿, ÊäÈëµÄ½ğ²ÏË¿ÊıÁ¿
	-- ÔÚ Server ÅĞ¶Ï

	-- ÅĞ¶Ï½ğÇ®ÊÇ·ñ×ã¹»
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		return 44
	end

	DWQianghua_OK:Enable()
	return 0
end


local EB_FREE_BIND = 0;				-- ?????
local EB_BINDED = 1;				-- ????
local EB_GETUP_BIND =2			-- ????
local EB_EQUIP_BIND =3			-- ????
--=========================================================
-- È·¶¨Ö´ĞĞ¹¦ÄÜ
--=========================================================
function DWQianghua_OK_Clicked(okFlag)
	local ret = DWQianghua_Check_AllItem()
	if ret == 1 or ret == 2 then
		PushDebugMessage("#{ZBDW_091105_12}")
		return
	elseif ret == 3 then
		PushDebugMessage("Hoa vån trên trang b¸ các hÕ không th¬ cß¶ng hóa næa.")
		return
	elseif ret == 44 then
		PushDebugMessage("#{GMGameInterface_Script_PlayerMySelf_Info_Money_Not_Enough}")
		return
	end

	if ret == 0 then
		local toolNumInBag = 0		-- ??????????
		for i, tbIndex in ipairs(g_DWQIANGHUA_ToolItem) do
			toolNumInBag = toolNumInBag + PlayerPackage:CountAvailableItemByIDTable(tonumber(tbIndex))
		end
		-- ÅĞ¶ÏÇ¿»¯²ÄÁÏÊÇ·ñ×ã¹»
		if tonumber(toolNumInBag) < g_DWQIANGHUA_Tool_Num then
			PushDebugMessage("#{ZBDW_091105_13}")
			return
		end

		-- ¼ì²é°ó¶¨Çé¿ö
		local equipBindState = PlayerPackage:GetItemBindStatusByIndex(g_DWQIANGHUA_Item)
		local isNeedConfirm = 0
		if equipBindState ~= EB_BINDED then
			for i, tbIndex in ipairs(g_DWQIANGHUA_ToolItem) do
				local index, bindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(tbIndex))
				if bindState == EB_BINDED then
					isNeedConfirm = 1
					break
				end
			end
		end

		--[»ÆÊï¹â TT65953 ·Ç°ó¶¨µÄÖØÂ¥½äÖØÂ¥ÓñÓë°ó¶¨µñÎÆÊ¹ÓÃÊ±£¬²»µ¯³ö°ó¶¨ÌáÊ¾µÄÌáÊ¾¿ò ]
			local equipTableIndex	= PlayerPackage : GetItemTableIndex( g_DWQIANGHUA_Item )
			local isEquipBind	= GetItemBindStatus( g_DWQIANGHUA_Item )
			if(equipTableIndex == 10422016 or equipTableIndex == 10423024) then
				if ( 0 == isEquipBind ) then
					isNeedConfirm = 0;
				end
			end
		--[/»ÆÊï¹â TT65953 ·Ç°ó¶¨µÄÖØÂ¥½äÖØÂ¥ÓñÓë°ó¶¨µñÎÆÊ¹ÓÃÊ±£¬²»µ¯³ö°ó¶¨ÌáÊ¾µÄÌáÊ¾¿ò ]

		-- Ö´ĞĞµñÎÆÇ¿»¯¹¦ÄÜ
		if isNeedConfirm ~= 1 or (okFlag ~= nil and okFlag == 1) then
			-- Èç¹û×°±¸ÊÇ²»°ó¶¨µÄ, ²é¿´±³°üÀïÓĞÎŞ°ó¶¨µÄÇ¿»¯²ÄÁÏ
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name(g_DWQIANGHUA_RScript_Name)
				Set_XSCRIPT_ScriptID(g_DWQIANGHUA_RScript_ID)
				Set_XSCRIPT_Parameter(0, g_DWQIANGHUA_Action_Type)
				Set_XSCRIPT_Parameter(1, g_DWQIANGHUA_Item)
				-- ±ØĞëÒª¼Ó tonumber, ·ñÔò¿ÉÄÜÄªÃûÆäÃîµÄËÀµô....
				Set_XSCRIPT_Parameter(2, tonumber(g_DWQIANGHUA_Tool_Num))
				Set_XSCRIPT_ParamCount(3)
			Send_XSCRIPT()
		elseif okFlag == nil then
			-- ÏÔÊ¾È·ÈÏ´°¿Ú
			if LifeAbility:ConfirmDiaowenQianghua(0) < 0 then
				-- ³ö´íÁË? ¹îÒìÊÂ¼ş, ÔİÊ±²»ÓèÀí»áßÀ....
			end
		end
	end

	-- ÖØĞÂÉèÖÃÉı¼¶¸öÊı, ²»È»ËÆºõ½çÃæÊ²Ã´¶¼Ã»ÓĞ±ä»¯ÄØ
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function DWQianghua_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒş²Ø
--=========================================================
function DWQianghua_OnHiden()
	StopCareObject_DWQianghua()
	DWQianghua_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØĞÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
-- Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_DWQianghua()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWQianghua")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_DWQianghua()
	this:CareObject(g_CaredNpc, 0, "DWQianghua")
	g_CaredNpc = -1
	return
end

--=========================================================
-- Íæ¼Ò½ğÇ®±ä»¯
--=========================================================
function DWQianghua_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- ÅĞ¶Ï½ğÇ®¹»²»¹»
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		--DWQianghua_OK:Disable()
		return -1
	end
	return 1
end

function DWQianghua_Frame_On_ResetPos()
  DWQianghua_Frame:SetProperty("UnifiedPosition", g_DWQianghua_Frame_UnifiedPosition);
end
function DWQianghua_ChangeTabIndex()
	--²ÎÊı2:1-Ç¿»¯¡¢2-Éı¼¶
	PushEvent("DW_QHSJ_UI_CHANGE", 2,g_CaredNpc,DWQianghua_Frame:GetProperty("UnifiedPosition"))
	DWQianghua_Close()
end
