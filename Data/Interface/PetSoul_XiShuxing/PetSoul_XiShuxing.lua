
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_PetSoul_XiShuxing_Frame_UnifiedPosition;
local g_BeforeText = {}
local g_AfterText = {}
local g_CheckButton = {}
local g_Already = 0
local g_BagIndex = -1
local g_ItemIndex = -1
local g_BaodiIndex = -1
local g_MAX = 100
local g_NeedItem = {
	[0] = 38002534,	--???
	[1] = 38002533,	--???
	[2] = 38002532,	--???
}
local g_NeedRMBItem = {
	[1] = 38002541,	
	[2] = 38002540,	
}
local g_IsLock = {0,0,0,0,0,0}
local g_DailyLeft = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
}
local g_AvailableLockNum = {0,0}
local g_Total = {0,0}
local g_nBeforePerfect = 0
local g_nAfterPerfect = 0
local g_ShenShouData = {
	[1] = {total = 200,   locknum = 1, needitemcount = 2,},
	[2] = {total = 500,   locknum = 2, needitemcount = 2,},
	[3] = {total = 1000,  locknum = 3, needitemcount = 3,},
	[4] = {total = 2000,  locknum = 4, needitemcount = 3,},
	[5] = {total = 5000,  locknum = 5, needitemcount = 4,},
	[6] = {total = 10000, locknum = 6, needitemcount = 5,},
}
local g_YiShouData = {
	[1] = {total = 100,   locknum = 1, needitemcount = 2,},
	[2] = {total = 200,   locknum = 2, needitemcount = 2,},
	[3] = {total = 500,   locknum = 3, needitemcount = 3,},
	[4] = {total = 1000,  locknum = 4, needitemcount = 3,},
	[5] = {total = 2000,  locknum = 5, needitemcount = 4,},
}
local g_TypeText = {
	[0] = "#{SHCX_20211229_32}";
	[1] = "#{SHCX_20211229_31}";
	[2] = "#{SHCX_20211229_30}";
}
local g_BaodiItem = {
	[1] = {itemId = 38002633, nType = 2, baodi = 3,},--??????
	[2] = {itemId = 38002634, nType = 2, baodi = 4,},--??????
	[3] = {itemId = 38002635, nType = 2, baodi = 5,},--??????
	[4] = {itemId = 38002636, nType = 1, baodi = 3,},--??????
	[5] = {itemId = 38002637, nType = 1, baodi = 4,},--??????
	[6] = {itemId = 38002638, nType = 1, baodi = 5,},--??????
}
--=========================================================
-- ×¢²á´°¿Ú¹ØÐÄµÄËùÓÐÊÂ¼þ
--=========================================================
function PetSoul_XiShuxing_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_PETSOUL" ,false)
	this:RegisterEvent("UPDATE_PETSOUL_ITEM" ,false)
	this:RegisterEvent("UPDATE_PETSOUL_BAODIITEM" ,false)
	this:RegisterEvent("UPDATE_PETSOUL_AFTERXISHUXING" ,false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED" ,false)
	this:RegisterEvent("UPDATE_PETSOUL_AFTERSAVE" ,false)
	this:RegisterEvent("PETSOUL_XISHUXING_CONFIRMOK" ,false)	
	this:RegisterEvent("OBJECT_CARED_EVENT" ,false)
	this:RegisterEvent("ADJEST_UI_POS" ,false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED" ,false)
	this:RegisterEvent("UNIT_MONEY" ,false)					--????
	this:RegisterEvent("MONEYJZ_CHANGE" ,false)					--????
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function PetSoul_XiShuxing_OnLoad()

	g_PetSoul_XiShuxing_Frame_UnifiedPosition = PetSoul_XiShuxing_Frame:GetProperty("UnifiedPosition");
	
	g_BeforeText[1] = PetSoul_XiShuxing_BeforeAttr1
	g_BeforeText[2] = PetSoul_XiShuxing_BeforeAttr2
	g_BeforeText[3] = PetSoul_XiShuxing_BeforeAttr3
	g_BeforeText[4] = PetSoul_XiShuxing_BeforeAttr4
	g_BeforeText[5] = PetSoul_XiShuxing_BeforeAttr5
	g_BeforeText[6] = PetSoul_XiShuxing_BeforeAttr6

	g_AfterText[1] = PetSoul_XiShuxing_AfterAttr1
	g_AfterText[2] = PetSoul_XiShuxing_AfterAttr2
	g_AfterText[3] = PetSoul_XiShuxing_AfterAttr3
	g_AfterText[4] = PetSoul_XiShuxing_AfterAttr4
	g_AfterText[5] = PetSoul_XiShuxing_AfterAttr5
	g_AfterText[6] = PetSoul_XiShuxing_AfterAttr6
	
	g_CheckButton[1] = PetSoul_XiShuxing_Kuang_Type1
	g_CheckButton[2] = PetSoul_XiShuxing_Kuang_Type2
	g_CheckButton[3] = PetSoul_XiShuxing_Kuang_Type3
	g_CheckButton[4] = PetSoul_XiShuxing_Kuang_Type4
	g_CheckButton[5] = PetSoul_XiShuxing_Kuang_Type5
	g_CheckButton[6] = PetSoul_XiShuxing_Kuang_Type6
end

--=========================================================
-- ÊÂ¼þ´¦Àí
--=========================================================
function PetSoul_XiShuxing_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 80012708) then
		if Get_XParam_INT(0) == 2 then
			g_DailyLeft[0] = g_MAX - Get_XParam_INT(1);
			g_DailyLeft[1] = g_MAX - Get_XParam_INT(2);
			g_DailyLeft[2] = g_MAX - Get_XParam_INT(3);
			g_Total[1] = Get_XParam_INT(4);
			g_Total[2] = Get_XParam_INT(5);
			PetSoul_XiShuxing_CalcAvailableLockNum()
			PetSoul_XiShuxing_FlushWindow()
			return
		end

		local xx = Get_XParam_INT(1);
		g_CaredNpc = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " g_CaredNpc="..g_CaredNpc)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
			return;
		end

		BeginCareObject_PetSoul_XiShuxing()

		PetSoul_XiShuxing_Clear() 

		g_DailyLeft[0] = g_MAX - Get_XParam_INT(2);
		g_DailyLeft[1] = g_MAX - Get_XParam_INT(3);
		g_DailyLeft[2] = g_MAX - Get_XParam_INT(4);
		g_Total[1] = Get_XParam_INT(5);
		g_Total[2] = Get_XParam_INT(6);
		PetSoul_XiShuxing_CalcAvailableLockNum()
		PetSoul_XiShuxing_ShowFrame() 
		this:Show()
	
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			PetSoul_XiShuxing_OnHiden()
		end

	elseif (event == "UPDATE_PETSOUL") then
		PetSoul_XiShuxing_UpdatePetSoul(tonumber(arg0), 0) 
	elseif (event == "UPDATE_PETSOUL_ITEM") then
		PetSoul_XiShuxing_UpdateItem(tonumber(arg0))
	elseif (event == "UPDATE_PETSOUL_BAODIITEM") then
		PetSoul_XiShuxing_UpdateBaodiItem(tonumber(arg0))

	elseif (event == "UPDATE_PETSOUL_AFTERXISHUXING") then
		PetSoul_XiShuxing_ShowResult()

	elseif (event == "UPDATE_PETSOUL_AFTERSAVE") then
		PushDebugMessage("#{SHCX_20211229_26}")
		g_Already = 0
		PetSoul_XiShuxing_UpdatePetSoul(g_BagIndex, 0) 
		PetSoul_XiShuxing_ClearAfter() 

	elseif (event == "PETSOUL_XISHUXING_CONFIRMOK") then
		local opt = tonumber(arg0)
		if opt == 1 then
			PetSoul_XiShuxing_Clear() 
			PetSoul_XiShuxing_ShowFrame() 
		elseif opt == 2 then
			g_Already = 0
			PetSoul_XiShuxing_OnHiden()
		elseif opt == 3 then
			PetSoul_XiShuxing_UpdatePetSoul(tonumber(arg1), 1) 
		end

	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_XiShuxing_Frame_On_ResetPos() 

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_XiShuxing_Frame_On_ResetPos()

	elseif event == "UNIT_MONEY" and this:IsVisible() then
		PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

	elseif event == "MONEYJZ_CHANGE" and this:IsVisible() then
		PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		--PetSoul_XiShuxing_ClearItem()
	end
end
 
function PetSoul_XiShuxing_FlushWindow() 
	
	local iQual = Pet:LuaFnGetPetSoulData(g_BagIndex, "QUAL")
	if iQual == 0 then--??
		iRealExtensionCount = 4
	elseif iQual == 1 then--??
		iRealExtensionCount = 5
	elseif iQual == 2 or iQual == 3 then--??
		iQual = 2
		iRealExtensionCount = 6
	end	
	PetSoul_XiShuxing_Num:SetText(ScriptGlobal_Format("#{SHCX_20211229_29}", g_TypeText[iQual], g_DailyLeft[iQual]))

	for i = 1, iRealExtensionCount do
		g_CheckButton[i]:SetProperty("Disabled", "False");
		if iQual == 0 then--??
			g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
		elseif iQual == 1 then--??
			g_CheckButton[i]:SetToolTip(ScriptGlobal_Format("#{SHCX_20211229_36}", g_Total[1], g_AvailableLockNum[1]))
		elseif iQual == 2 or iQual == 3 then--??
			g_CheckButton[i]:SetToolTip(ScriptGlobal_Format("#{SHCX_20211229_35}", g_Total[2], g_AvailableLockNum[2]))
		end	
	end
	PetSoul_XiShuxing_Num:SetToolTip(ScriptGlobal_Format("#{SHCX_20211229_33}", g_DailyLeft[2], g_DailyLeft[1], g_DailyLeft[0]))

end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function PetSoul_XiShuxing_Clear() 

	if g_BagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
		g_BagIndex = -1
	end

	if g_ItemIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
		g_ItemIndex = -1
	end
	PetSoul_XiShuxing_ClearBaodiItem()
	g_nBeforePerfect = 0
	g_nAfterPerfect = 0
	g_Already = 0
	g_DailyLeft[0] = 0
	g_DailyLeft[1] = 0
	g_DailyLeft[2] = 0
	g_Total = {0,0}
	g_AvailableLockNum = {0,0}
	for i = 1, 6 do
		g_BeforeText[i]:SetText("")
		g_AfterText[i]:SetText("")
		g_IsLock[i] = 0
		g_CheckButton[i]:SetCheck(0)
		g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
	end
	PetSoul_XiShuxing_Num:SetText("")
	PetSoul_XiShuxing_Num:SetToolTip("")
	PetSoul_XiShuxing_BeforeIcon:SetActionItem(-1)
	PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")
	PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)
	PetSoul_XiShuxing_NeedNum:SetText("")
	PetSoul_XiShuxing_NeedNum2BK:Hide()
	PetSoul_XiShuxing_NeedNumBK:Hide()
	PetSoul_XiShuxing_WantNum:SetProperty("MoneyNumber", tostring(0))
	PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(0))
	PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(0))

	PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");

	Pet:LuaFnClearPetSoulExValue()

end

function PetSoul_XiShuxing_ClearIcon()
	if g_Already == 1 then
		PushEvent("PETSOUL_XISHUXING_CONFIRM", 1, g_BagIndex)
	else
		if g_BagIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
			g_BagIndex = -1
		end

		if g_ItemIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
			g_ItemIndex = -1
		end

		g_nBeforePerfect = 0
		g_nAfterPerfect = 0
		g_Already = 0

		for i = 1, 6 do
			g_BeforeText[i]:SetText("")
			g_AfterText[i]:SetText("")
			g_IsLock[i] = 0
			g_CheckButton[i]:SetCheck(0)
			g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
		end

		PetSoul_XiShuxing_Num:SetText("")
		PetSoul_XiShuxing_Num:SetToolTip("")
		PetSoul_XiShuxing_BeforeIcon:SetActionItem(-1)
		PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")
		PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)
		PetSoul_XiShuxing_NeedNum:SetText("")
		PetSoul_XiShuxing_NeedNumBK:Hide()
		PetSoul_XiShuxing_NeedIcon2:SetActionItem(-1)
		PetSoul_XiShuxing_NeedNum2:SetText("")
		PetSoul_XiShuxing_NeedNum2BK:Hide()
		PetSoul_XiShuxing_WantNum:SetProperty("MoneyNumber", tostring(0))

		PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");
		PetSoul_XiShuxing_ClearBaodiItem()
		Pet:LuaFnClearPetSoulExValue()
		PetSoul_XiShuxing_ShowFrame() 
	end
end


function PetSoul_XiShuxing_ClearItem()

	if g_ItemIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
		g_ItemIndex = -1
	end

	PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)

	PetSoul_XiShuxing_NeedNum:SetText("")
	PetSoul_XiShuxing_NeedNumBK:Hide()

end

function PetSoul_XiShuxing_ClearBaodiItem( )
	if g_BaodiIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_BaodiIndex, 0)
		g_BaodiIndex = -1
	end

	PetSoul_XiShuxing_NeedIcon2:SetActionItem(-1)

	PetSoul_XiShuxing_NeedNum2:SetText("")
	PetSoul_XiShuxing_NeedNum2BK:Hide()

end

function PetSoul_XiShuxing_ShowFrame() 

	PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

	PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");
	PetSoul_XiShuxing_Num:SetText("#{SHCX_20211229_28}")
	PetSoul_XiShuxing_Num:SetToolTip(ScriptGlobal_Format("#{SHCX_20211229_33}", g_DailyLeft[2], g_DailyLeft[1], g_DailyLeft[0]))
end
--=========================================================
-- ¸üÐÂ½çÃæ
--=========================================================
function PetSoul_XiShuxing_UpdatePetSoul(itemIndex, isConfirm)

	if itemIndex == nil or itemIndex < 0 then
		return
	end
	for i = 1, table.getn(g_CheckButton) do
		g_IsLock[i] = 0
		g_CheckButton[i]:SetCheck(0)
		g_CheckButton[i]:SetProperty("Disabled", "True");
	end

	local theAction = EnumAction(itemIndex, "packageitem")
	if theAction:GetID() ~= 0 then

		if Pet:LuaFnIsPetSoul(itemIndex) ~= 1 then
			PushDebugMessage("#{SHCX_20211229_17}")
			return
		end
		PetSoul_XiShuxing_Num:SetText("")
		PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");
		g_nBeforePerfect = 0
		local iRealExtensionCount = 0
		local iQual = Pet:LuaFnGetPetSoulData(itemIndex, "QUAL")
		if iQual == 0 then--??
			iRealExtensionCount = 4
		elseif iQual == 1 then--??
			iRealExtensionCount = 5
		elseif iQual == 2 or iQual == 3 then--??
			iQual = 2
			iRealExtensionCount = 6
		end	

		PetSoul_XiShuxing_Num:SetText(ScriptGlobal_Format("#{SHCX_20211229_29}", g_TypeText[iQual], g_DailyLeft[iQual]))

		for i = 1, iRealExtensionCount do
			g_CheckButton[i]:SetProperty("Disabled", "False");
			if iQual == 0 then--??
				g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
			elseif iQual == 1 then--??
				g_CheckButton[i]:SetToolTip(ScriptGlobal_Format("#{SHCX_20211229_36}", g_Total[1], g_AvailableLockNum[1]))
			elseif iQual == 2 or iQual == 3 then--??
				g_CheckButton[i]:SetToolTip(ScriptGlobal_Format("#{SHCX_20211229_35}", g_Total[2], g_AvailableLockNum[2]))
			end	
		end

		
		----------------------------------------------------------------------------------Ã»Ï´¹ýÇÒ²ÛÎ»¿ 
		if g_Already ~= 1 and g_BagIndex < 0 then

			PetSoul_XiShuxing_BeforeIcon:SetActionItem(theAction:GetID())
			if g_BagIndex ~= itemIndex then
				g_BagIndex = itemIndex
				PetSoul_XiShuxing_ClearItem()
				PetSoul_XiShuxing_ClearBaodiItem()
			end
			LifeAbility:Lock_Packet_Item(g_BagIndex, 1)

			PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

			for i = 0, iRealExtensionCount - 1 do
				local tempStr, qual = Pet:LuaFnGetPetSoulData(g_BagIndex, "TIPS", i)
				g_BeforeText[i+1]:SetText(tempStr)
				if qual == 4 then
					g_nBeforePerfect = g_nBeforePerfect + 1
				end
			end
			
		----------------------------------------------------------------------------------Ã»Ï´¹ýÇÒ²ÛÎ»ÒÑ¾­·ÅÁË Ìæ»»
		elseif g_Already ~= 1 and g_BagIndex >= 0 then

			LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
			if g_BagIndex ~= itemIndex then
				g_BagIndex = itemIndex
				PetSoul_XiShuxing_ClearItem()
				PetSoul_XiShuxing_ClearBaodiItem()
			end
			LifeAbility:Lock_Packet_Item(g_BagIndex, 1)

			PetSoul_XiShuxing_BeforeIcon:SetActionItem(theAction:GetID())

			PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

			for i = 1, table.getn(g_BeforeText) do
				g_BeforeText[i]:SetText("")
			end

			for i = 0, iRealExtensionCount - 1 do
				local tempStr, qual = Pet:LuaFnGetPetSoulData(g_BagIndex, "TIPS", i)
				g_BeforeText[i+1]:SetText(tempStr)
				if qual == 4 then
					g_nBeforePerfect = g_nBeforePerfect + 1
				end
			end
			g_Already = 0
		------------------------------------------------------------------------------------------ÒÑ¾­Ï´ÁË
		elseif g_Already == 1 and g_BagIndex >= 0 then

			if isConfirm == 0 then--????
				PushEvent("PETSOUL_XISHUXING_CONFIRM", 3, itemIndex)
			else
				LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
				PetSoul_XiShuxing_BeforeIcon:SetActionItem(-1)
				PetSoul_XiShuxing_BeforeIcon:SetActionItem(theAction:GetID())
				PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")
				if g_BagIndex ~= itemIndex then
					g_BagIndex = itemIndex
					PetSoul_XiShuxing_ClearItem()
					PetSoul_XiShuxing_ClearBaodiItem()
				end
				LifeAbility:Lock_Packet_Item(g_BagIndex, 1)
				

				PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

				for i = 1, table.getn(g_BeforeText) do
					g_BeforeText[i]:SetText("")
					g_AfterText[i]:SetText("")
				end

				for i = 0, iRealExtensionCount - 1 do
				local tempStr, qual = Pet:LuaFnGetPetSoulData(g_BagIndex, "TIPS", i)
					g_BeforeText[i+1]:SetText(tempStr)
					if qual == 4 then
						g_nBeforePerfect = g_nBeforePerfect + 1
					end
				end
				g_Already = 0
			end
		end
	
		PetSoul_XiShuxing_WantNum:SetProperty("MoneyNumber", tostring(50000))
		
	else
		PetSoul_XiShuxing_Clear()
	end
end

function PetSoul_XiShuxing_ShowResult()

	g_Already = 1
	PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")

	local theAction = EnumAction(g_BagIndex, "packageitem")

	if theAction:GetID() ~= 0 then
		if Pet:LuaFnIsPetSoul(g_BagIndex) ~= 1 then
			return
		end
		local icon =  tostring(LifeAbility : Get_Item_Icon_Name(g_BagIndex))
		PetSoul_XiShuxing_AfterIcon:SetProperty("Image",icon)

		for i = 1, table.getn(g_AfterText) do
			g_AfterText[i]:SetText("")
		end

	    --¸ù¾ÝÆ·ÖÊ»ñµÃÌõÄ¿ÊýÁ¿
		local iRealExtensionCount = 0
		local iQual = Pet:LuaFnGetPetSoulData(g_BagIndex, "QUAL")
		if iQual == 0 then
			iRealExtensionCount = 4
		elseif iQual == 1 then
			iRealExtensionCount = 5
		elseif iQual == 2 or iQual == 3 then
			iRealExtensionCount = 6
		end	
		
		for i = 0, iRealExtensionCount - 1 do
			local tempStr = Pet:LuaFnGetPetSoulExDesc(i, g_BagIndex)
			g_AfterText[i+1]:SetText(tempStr)
		end
	end
	PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	
	--Ë¢ÐÂµÀ¾ß
	if g_ItemIndex >= 0 then

		local itemId = PlayerPackage : GetItemTableIndex(g_ItemIndex) --?????-1
		if itemId <= 0 then
			if g_ItemIndex >= 0 then
				LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
				g_ItemIndex = -1
			end
			PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)
			PetSoul_XiShuxing_NeedNum:SetText("")
			PetSoul_XiShuxing_NeedNumBK:Hide()
		else
			local iQual = Pet:LuaFnGetPetSoulData(g_BagIndex, "QUAL")
			if iQual == 3 then
 				iQual = 2 
 			end
			local nItemNum = PlayerPackage:GetBagItemNum(g_ItemIndex)
			local nNeedNum = PetSoul_XiShuxing_CalcNeedItemNum(iQual)
			local text = ""
			if nItemNum > 999 then
				text = "999+".."/"..nNeedNum
			else
				if nItemNum >= nNeedNum  then
					text = nItemNum.."/"..nNeedNum
				else
					text = "#cff0000"..nItemNum.."/"..nNeedNum
				end	
			end 
			PetSoul_XiShuxing_NeedNum:SetText(text)
			PetSoul_XiShuxing_NeedNumBK:Show()
		end
	end
	if g_BaodiIndex >= 0 then

		local itemId = PlayerPackage : GetItemTableIndex(g_BaodiIndex) --?????-1
		if itemId <= 0 then
			if g_BaodiIndex >= 0 then
				LifeAbility:Lock_Packet_Item(g_BaodiIndex, 0)
				g_BaodiIndex = -1
			end
			PetSoul_XiShuxing_NeedIcon2:SetActionItem(-1)
			PetSoul_XiShuxing_NeedNum2:SetText("")
			PetSoul_XiShuxing_NeedNum2BK:Hide()
		else
			local nItemNum = PlayerPackage:GetBagItemNum(g_BaodiIndex)
			local nNeedNum = 1
			local text = ""
			if nItemNum > 999 then
				text = "999+".."/"..nNeedNum
			else
				if nItemNum >= nNeedNum  then
					text = nItemNum.."/"..nNeedNum
				else
					text = "#cff0000"..nItemNum.."/"..nNeedNum
				end	
			end 
			PetSoul_XiShuxing_NeedNum2:SetText(text)
			PetSoul_XiShuxing_NeedNum2BK:Show()
		end
	end
end

function PetSoul_XiShuxing_UpdateItem(nIndex)

	if (nIndex == nil or nIndex < 0 ) then
		return
	end

	local itemId = PlayerPackage : GetItemTableIndex(nIndex)
	if itemId ~= g_NeedItem[0] and itemId ~= g_NeedItem[1] and itemId ~= g_NeedItem[2] and itemId ~= g_NeedRMBItem[1] and itemId ~= g_NeedRMBItem[2] then
		PushDebugMessage("#{SHCX_20211229_41}")
		return 
	end 
 	--ÏÔÊ¾ÐèÒªµÄ²ÄÁÏ
 	if g_BagIndex < 0 then
 		PushDebugMessage("#{SHCX_20211229_19}")
 		return
 	end

 	local iQual = Pet:LuaFnGetPetSoulData(g_BagIndex, "QUAL")
 	if iQual == 3 then
 		iQual = 2 
 	end

 	if (iQual > 0 and itemId ~= g_NeedItem[iQual] and itemId ~= g_NeedRMBItem[iQual] ) or 
 		(iQual == 0 and itemId ~= g_NeedItem[iQual]) then
 		local theAction = EnumAction(g_BagIndex, "packageitem") 
 		local szPetSoul = theAction:GetName()
 		local szItemName = PlayerPackage:GetItemName(g_NeedItem[iQual])
 		PushDebugMessage(ScriptGlobal_Format("#{SHCX_20211229_42}", szPetSoul, szItemName))
 		return
 	end

 	if g_ItemIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
	end
 	g_ItemIndex = nIndex
 	local isBind = GetItemBindStatus(g_ItemIndex)
 	local theAction
 	if isBind == 1 then
 		theAction = DataPool:CreateBindActionItemForShow(itemId, 1)
 	else
 		theAction = DataPool:CreateActionItemForShow(itemId, 1)
 	end
	
	if theAction:GetID() ~= 0 then
		PetSoul_XiShuxing_NeedIcon:SetActionItem(theAction:GetID())

		if g_ItemIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_ItemIndex, 1)
		end

	end

	local nItemNum = PlayerPackage:GetBagItemNum(g_ItemIndex)
	local nNeedNum = PetSoul_XiShuxing_CalcNeedItemNum(iQual)
	local text = ""
	if nItemNum > 999 then
		text = "999+".."/"..nNeedNum
	else
		if nItemNum >= nNeedNum  then
			text = nItemNum.."/"..nNeedNum
		else
			text = "#cff0000"..nItemNum.."/"..nNeedNum
		end
		
	end 
	PetSoul_XiShuxing_NeedNum:SetText(text)
	PetSoul_XiShuxing_NeedNumBK:Show()
 end

 function PetSoul_XiShuxing_UpdateBaodiItem(nIndex)

	if (nIndex == nil or nIndex < 0 ) then
		return
	end

	local itemId = PlayerPackage : GetItemTableIndex(nIndex)
	if itemId ~= g_BaodiItem[1].itemId and itemId ~= g_BaodiItem[2].itemId and itemId ~= g_BaodiItem[3].itemId 
		and itemId ~= g_BaodiItem[4].itemId and itemId ~= g_BaodiItem[5].itemId and itemId ~= g_BaodiItem[6].itemId then
		PushDebugMessage("#{SHCX_20211229_72}")
		return 
	end 

 	--ÏÔÊ¾ÐèÒªµÄ²ÄÁÏ
 	if g_BagIndex < 0 then
 		PushDebugMessage("#{SHCX_20211229_19}")
 		return
 	end

 	local iQual = Pet:LuaFnGetPetSoulData(g_BagIndex, "QUAL")
 	if iQual == 3 then
 		iQual = 2
 	end

 	local isFind = 0
 	for i = 1, table.getn(g_BaodiItem) do
 		if g_BaodiItem[i].itemId == itemId and g_BaodiItem[i].nType == iQual then
 			isFind = 1
 		end
 	end
 	if isFind == 0 then
 		local theAction = EnumAction(g_BagIndex, "packageitem") 
 		local szPetSoul = theAction:GetName()
 		PushDebugMessage(ScriptGlobal_Format("#{SHCX_20211229_73}", szPetSoul))
 		return
 	end

 	if g_BaodiIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_BaodiIndex, 0)
	end
 	g_BaodiIndex = nIndex
 	local isBind = GetItemBindStatus(g_BaodiIndex)
 	local theAction
 	if isBind == 1 then
 		theAction = DataPool:CreateBindActionItemForShow(itemId, 1)
 	else
 		theAction = DataPool:CreateActionItemForShow(itemId, 1)
 	end
	
	if theAction:GetID() ~= 0 then
		PetSoul_XiShuxing_NeedIcon2:SetActionItem(theAction:GetID())

		if g_BaodiIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_BaodiIndex, 1)
		end

	end

	local nItemNum = PlayerPackage:GetBagItemNum(g_BaodiIndex)
	local nNeedNum = 1
	local text = ""
	if nItemNum > 999 then
		text = "999+".."/"..nNeedNum
	else
		if nItemNum >= nNeedNum  then
			text = nItemNum.."/"..nNeedNum
		else
			text = "#cff0000"..nItemNum.."/"..nNeedNum
		end
		
	end 
	PetSoul_XiShuxing_NeedNum2:SetText(text)
	PetSoul_XiShuxing_NeedNum2BK:Show()
 end

--=========================================================
-- È·¶¨Ö´ÐÐ¹¦ÄÜ
--=========================================================
function PetSoul_XiShuxing_OK_Clicked() 

  	if g_BagIndex <= -1 then
  		PushDebugMessage("#{SHCX_20211229_19}");
		return
  	end 

  	if g_ItemIndex <= -1 then
  		PushDebugMessage("#{SHCX_20211229_41}");
		return
  	end 

  	local nLockState = g_IsLock[6]+g_IsLock[5]*10+g_IsLock[4]*100+g_IsLock[3]*1000+g_IsLock[2]*10000+g_IsLock[1]*100000

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnPetSoulXiShuXing");
		Set_XSCRIPT_ScriptID(800127);
		Set_XSCRIPT_Parameter(0, g_BagIndex);
		Set_XSCRIPT_Parameter(1, g_ItemIndex);
		Set_XSCRIPT_Parameter(2, g_BaodiIndex);
		Set_XSCRIPT_Parameter(3, nLockState);
		Set_XSCRIPT_Parameter(4, 0);
		Set_XSCRIPT_ParamCount(5); 
	Send_XSCRIPT();	  
	
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
--=========================================================
-- ½çÃæÒþ²Ø
--=========================================================
function PetSoul_XiShuxing_OnHiden()
	if g_Already > 0 then
		PushEvent("PETSOUL_XISHUXING_CONFIRM", 2, g_BagIndex)
		return
	else
		PetSoul_XiShuxing_Clear()
	end

	StopCareObject_PetSoul_XiShuxing()
	this:Hide()
	return
end

function PetSoul_XiShuxing_OnEsc()

	PetSoul_XiShuxing_Clear()
	StopCareObject_PetSoul_XiShuxing()
	this:Hide()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØÐÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
-- Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_PetSoul_XiShuxing()

	this:CareObject(g_CaredNpc, 1, "PetSoul_XiShuxing")
	return

end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_PetSoul_XiShuxing()
	this:CareObject(g_CaredNpc, 0, "PetSoul_XiShuxing")
	g_CaredNpc = -1
	return
end
 

function PetSoul_XiShuxing_Frame_On_ResetPos()
  	PetSoul_XiShuxing_Frame:SetProperty("UnifiedPosition", g_PetSoul_XiShuxing_Frame_UnifiedPosition);
end

function PetSoul_XiShuxing_SaveChange_Clicked()

	if g_BagIndex == nil or g_BagIndex < 0 then
		PushDebugMessage("#{SHCX_20211229_19}");
		return
	end

	if g_Already ~= 1 then
		PushDebugMessage("#{SHCX_20211229_23}");
		return
	end

	--ÅÐ¶ÏÍêÃÀ
	local count = Pet:LuaFnGetPetSoulPerfectExCount(g_BagIndex)
	if count >= 3 then
		--¶þ´Î
		PushEvent("PETSOUL_XISHUXING_CHANGECONFIRM", g_BagIndex)
		return
	end
	Pet:LuaFnSavePetSoulExValue(g_BagIndex)

end	

function PetSoul_XiShuxing_ClearAfter() 

	for i = 1, 6 do
		g_AfterText[i]:SetText("")
	end

	PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")

	PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

	Pet:LuaFnClearPetSoulExValue()

end

function PetSoul_XiShuxing_CalcAvailableLockNum()

	for i = 1, table.getn(g_YiShouData) do
		if g_YiShouData[i].total <= g_Total[1] then
			g_AvailableLockNum[1] = g_YiShouData[i].locknum
		end
	end

	for i = 1, table.getn(g_ShenShouData) do
		if g_ShenShouData[i].total <= g_Total[2] then
			g_AvailableLockNum[2] = g_ShenShouData[i].locknum
		end
	end

end

function PetSoul_XiShuxing_CalcNeedItemNum(iQual)

	local nLock = 0
	for i = 1, table.getn(g_IsLock) do
		if g_IsLock[i] == 1 then
			nLock = nLock + 1
		end
	end

	if iQual == 0 then
		return 1
	elseif iQual == 1 then
		for i = 1, table.getn(g_YiShouData) do
			if g_YiShouData[i].locknum == nLock then
				return g_YiShouData[i].needitemcount
			end
		end
	elseif iQual == 2 then
		for i = 1, table.getn(g_ShenShouData) do
			if g_ShenShouData[i].locknum == nLock then
				return g_ShenShouData[i].needitemcount
			end
		end
	end

	return 1
end

function PetSoul_XiShuxing_CheckButtonClicked( idx )
	--¿ÓÀïÊÇ·ñÓÐµÀ¾ß
	if g_BagIndex < 0 then
		PushDebugMessage("#{SHCX_20211229_19}")
		g_CheckButton[idx]:SetCheck(0)
		return
	end
	--¿ÓÀïÊÇ·ñÓÐÊÞ»êµÀ¾ß
	local theAction = EnumAction(g_BagIndex, "packageitem")
	if theAction:GetID() ~= 0 then
		if Pet:LuaFnIsPetSoul(g_BagIndex) ~= 1 then
			PushDebugMessage("#{SHCX_20211229_19}")
			g_CheckButton[idx]:SetCheck(0)
			return
		end
	end
	--ÊÇ·ñÊÇÉñÊÞÒìÊÞ
	local iRealExtensionCount = 0
	local iQual = Pet:LuaFnGetPetSoulData(g_BagIndex, "QUAL")
	if iQual == 0 then--??
		g_CheckButton[idx]:SetCheck(0)
		PushDebugMessage("#{SHCX_20211229_37}")
		return
	elseif iQual == 1 then--??
		iRealExtensionCount = 5
	elseif iQual == 2 or iQual == 3 then--??
		iQual = 2
		iRealExtensionCount = 6
	end	
	--ÊÇ·ñ¿ÉÒÔµã
	if idx > iRealExtensionCount then
		g_CheckButton[idx]:SetCheck(0)
		return
	end
	--ÒÑ¾­µãÁËÇå¿ 
	if g_IsLock[idx] == 1 then
		g_IsLock[idx] = 0
		g_CheckButton[idx]:SetCheck(0)
		--Ë¢ÐÂÐèÒªµÄµÀ¾ß
		local itemId = PlayerPackage : GetItemTableIndex(g_ItemIndex)
		local nItemNum = PlayerPackage:GetBagItemNum(g_ItemIndex)
		local nNeedNum = PetSoul_XiShuxing_CalcNeedItemNum(iQual)
		local text = ""
		if nItemNum > 999 then
			text = "999+".."/"..nNeedNum
		else
			if nItemNum >= nNeedNum  then
				text = nItemNum.."/"..nNeedNum
			else
				text = "#cff0000"..nItemNum.."/"..nNeedNum
			end	
		end 
		PetSoul_XiShuxing_NeedNum:SetText(text)
		PetSoul_XiShuxing_NeedNumBK:Show()
		return
	end
	--ÊÇ·ñÑ¡¶àÁË
	local nLockNum = 0
	for i = 1, 6 do
		if g_IsLock[i] == 1 then
			nLockNum = nLockNum + 1
		end
	end
	nLockNum = nLockNum + 1
	if nLockNum > g_AvailableLockNum[iQual] then
		PushDebugMessage(ScriptGlobal_Format("#{SHCX_20211229_38}", g_AvailableLockNum[iQual]))
		g_CheckButton[idx]:SetCheck(0)
		return
	end
	--µãÉÏ
	g_IsLock[idx] = 1
	g_CheckButton[idx]:SetCheck(1)
	--Ë¢ÐÂÐèÒªµÄµÀ¾ß
	local itemId = PlayerPackage : GetItemTableIndex(g_ItemIndex)
	local nItemNum = PlayerPackage:GetBagItemNum(g_ItemIndex)
	local nNeedNum = PetSoul_XiShuxing_CalcNeedItemNum(iQual)
	local text = ""
	if nItemNum > 999 then
		text = "999+".."/"..nNeedNum
	else
		if nItemNum >= nNeedNum  then
			text = nItemNum.."/"..nNeedNum
		else
			text = "#cff0000"..nItemNum.."/"..nNeedNum
		end	
	end 
	PetSoul_XiShuxing_NeedNum:SetText(text)
	PetSoul_XiShuxing_NeedNumBK:Show()
end

function PetSoul_XiShuxing_Help()
	PushEvent("CCSHOP_HELP", 5)
end
