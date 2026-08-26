--×°±¸ÐÞ¸ÄÆ÷ V5 ²ÔÉ½Ñ©¶¨ÖÆ°æ
--Ñ©Îè@WAYLEE 2024-2-14 23:51:04
local g_GameTools5_Frame_UnifiedPosition;
local g_AttrSecond = {};
local g_Conut = 0
local g_max = 0
local StarId = -1
local KongShuId = -1

local StarNameList = {"0?","1?","2?","3?","4?","5?","6?","7?","8?","9?"}
local KongShuNameList = {"0Kh±ng","1Kh±ng","2Kh±ng","3Kh±ng","4Kh±ng"}--,"5Kh±ng","6Kh±ng"

local g_Equip_ID = -1 --????ID
local g_posBag = -1 --????

function GameTools5_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED" ); -- ????
end

function GameTools5_OnLoad()
	g_GameTools5_Frame_UnifiedPosition=GameTools5_Frame:GetProperty("UnifiedPosition");
	-- ³õÊ¼»¯±í
	for i = 1, 41 do
		g_AttrSecond[i] = _G["GameTools5_AttrSecondButton"..i]
	end
end

-- »ñÈ¡×°±¸ÀàÐÍºÍ×Ö·û´®
function GameTools5_LuaFnGetBagEquipType(nPos)
    -- ÏÈÈ¡×°±¸µã
    local EquipPoint = LifeAbility:Get_Equip_Point(nPos)
    local EquipNames = {
        [0]  = "Vû khí",
        [1]  = "Mão",
        [2]  = "Th¶i Trang",
        [3]  = "Hµ Thü",
        [4]  = "Gi¥y",
        [5]  = "Yêu Ðai",
        [6]  = "Gi¾i Chï",
        [7]  = "HÕng Liên",
        [8]  = "CßÞi",
        [9]  = "Bá Vß½ng Linh",  -- ??
        [10] = "Võ H°n",
        [11] = "Gi¾i Chï",   -- ?????
        [12] = "Hµ Phù",
        [13] = "Hµ Phù",   -- ?????
        [14] = "Hµ Uy¬n",
        [15] = "Hµ Kiên",
        [16] = "Y Phøc",
        [17] = "Ám Khí",
        [18] = "Long Vån",
        [21] = "Hào Hi®p ?N",
    }
    local Str = EquipNames[EquipPoint] or "Không biªt"
    return EquipPoint, Str
end


function GameTools5_OnEvent(event)
	if(event == "UI_COMMAND" and arg0 == "202004275") then
		GameTools5_Init()
		this:Show();
		
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 201107281 ) and this:IsVisible() then
		
		--¶þ´Î·ÅÈëµÄ»°£¬ÏÈ½âËøÒÔÇ°µÄ×°±¸
		if g_posBag ~= -1 then
			LifeAbility:Lock_Packet_Item(g_posBag,0); 
		end
		GameTools5_FenYe5:SetCheck(1)
		g_posBag = tonumber(arg1)
		local theAction = EnumAction(g_posBag, "packageitem")
		if theAction:GetID() ~= 0 then
			g_Equip_ID = theAction:GetID()
			GameTools5_Item:SetActionItem(g_Equip_ID)
			--ÏÔÊ¾µÀ¾ßÃû×Ö
			local ItemName = LifeAbility:GetPrescr_Material(theAction:GetDefineID())
			GameTools5_Name:SetText("#c0066fftên: #G"..ItemName)
			--Ð¯´øµÈ¼¶
			local nItemLevel = LifeAbility:Get_Equip_Level(g_posBag);
			GameTools5_Level:SetText("#c0066ffc¤p b§c: #G"..nItemLevel)
			--×°±¸µã
			local EqType1,EqType2 = GameTools5_LuaFnGetBagEquipType(g_posBag)
			GameTools5_EqType:SetText("#c0066ffloÕi hình: #G"..EqType2)
			--Type
			GameTools5_EqType2:SetText("#c0066fftrang b¸ Ði¬m: #G"..EqType1)
			
			--Ë¢ÐÂµñÎÆÐÅÏ¢
			GameTools5_reDWinfo(g_posBag)
			
			--Ëø¶¨ÎïÆ·
			LifeAbility:Lock_Packet_Item(g_posBag,1);
			
			--´´½¨ ßÐÅÏ¢
			GameTools5_CreatEdix:SetText( PlayerPackage:GetItemCreator(g_posBag) )
		end
	--µ¥¶ÀË¢ÐÂ±¦Ê¯ÐÅÏ¢
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 202402112 ) and this:IsVisible() then
		-- ±¦Ê¯ÐÅÏ¢ÏÔÊ¾
		local gems = { PlayerPackage:GetEquipGemInfo(g_posBag) }
		local gemUI = {
			{ btn = GameTools5_Gem1, txt = GameTools5_GeminfoTxt1, edix = GameTools5_GeminfoEdix1 },
			{ btn = GameTools5_Gem2, txt = GameTools5_GeminfoTxt2, edix = GameTools5_GeminfoEdix2 },
			{ btn = GameTools5_Gem3, txt = GameTools5_GeminfoTxt3, edix = GameTools5_GeminfoEdix3 },
			{ btn = GameTools5_Gem4, txt = GameTools5_GeminfoTxt4, edix = GameTools5_GeminfoEdix4 },
		}

		for i, ui in ipairs(gemUI) do
			local gemId = gems[i]
			if gemId ~= nil and gemId > 0 then
				local action = DataPool:CreateActionItemForShow(gemId, 1)
				ui.btn:SetActionItem(action:GetID())
				ui.txt:SetText(LuaFnGetItemName(gemId))
				ui.edix:SetText(gemId)
			else
				ui.btn:SetActionItem(-1)
				ui.txt:SetText("Kh±ng V¸ Vô bäo thÕch")
				ui.edix:SetText("")
			end
		end
				
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 202402111 ) and this : IsVisible() then
	
		--ÐÇ¼¶
		StarId = PlayerPackage:GetItemQual(g_posBag) 
		GameTools5_StarEdix:SetCurrentSelect(StarId)
		
		--Ç¿»¯
		local nEnhanceLevel = PlayerPackage:GetEnhanceLevel(g_posBag) 
		GameTools5_strengthenEdix:SetText(nEnhanceLevel);
		
		--¿×Êý
		KongShuId = PlayerPackage:GetEquipSlot(g_posBag)
		GameTools5_KongShuEdix:SetCurrentSelect(KongShuId);
		
		--Íâ¹ÛID
		local nVisual = PlayerPackage:GetVisualID(g_posBag);
		GameTools5_VisualEdix:SetText(nVisual)
		
		--¸¡¶¯Öµ
		local nFuDong = Get_XParam_INT(2)--PlayerPackage:GetEquipAttrHidden(g_posBag)
		GameTools5_FuDongEdix:SetText(nFuDong)
		
		--µñÎÆÊ£ÓàÊýÁ¿»ñÈ¡
		local DWMaxNum = Get_XParam_INT(0)
		if DWMaxNum > 0 then
			local dwmax = math.floor(DWMaxNum / 10000)
			local dwneed = math.mod(DWMaxNum, 10000)
			GameTools5_DWSum:SetText("#G"..tostring(dwneed).."/"..tostring(dwmax))
			GameTools5_DWSumEdix1:SetText(dwneed)
		else
			GameTools5_DWSumEdix1:SetText(0)
			GameTools5_DWSum:SetText("#GVÔ/Vô")
		end
		
		--×°±¸ID
		local nItemID = PlayerPackage:GetItemTableIndex(g_posBag)
		GameTools5_IDEdix:SetText(nItemID)
		
		--×°±¸¼ø¶¨/°ó¶¨/Ëø¶¨×´Ì¬/Ãú¿Ì/×ÊÖÊ¼ø¶¨
		local status = PlayerPackage:GetItemStatus(g_posBag)
		if LuaFnHasBit(status, 0) == 1 then 
			GameTools5_ZhuangTaiButton1:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton1:SetCheck(0) 
		end -- ??
		if LuaFnHasBit(status, 1) == 1 then 
			GameTools5_ZhuangTaiButton2:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton2:SetCheck(0) 
		end -- ??
		if LuaFnHasBit(status, 2) == 1 then 
			GameTools5_ZhuangTaiButton3:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton3:SetCheck(0) 
		end -- ??
		if LuaFnHasBit(status, 6) == 1 then 
			GameTools5_ZhuangTaiButton4:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton4:SetCheck(0) 
		end -- ??
		if LuaFnHasBit(status, 5) == 1 then 
			GameTools5_ZhuangTaiButton5:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton5:SetCheck(0) 
		end -- ????
		
		--ÊÇ·ñ¹óÖØ
		local Goods = "#cFF0000quý tr÷ng"
		if Get_XParam_INT(1) == 0 then
			Goods = "#GPHi quý tr÷ng"
		end
		GameTools5_Goods:SetText("#c0066ffph¦m ch¤t:"..Goods)
			
		--ÄÍ¾Ã¶È
		local nDurValue,nDurMaxValue = PlayerPackage:GetEquipDurValue(g_posBag)
		GameTools5_DurValueEdix:SetText(nDurValue)
		GameTools5_MaxDurValueEdix:SetText(nDurMaxValue)
		
		--Ê£Óà¿ÉÐÞÀí´ÎÊý
		local nXiuLi = PlayerPackage:GetFaileTimes(g_posBag)
		GameTools5_XiuLiCountEdix:SetText(nXiuLi)
		
		--ÊôÐÔÌõÊý
		local nTiaoShu = PlayerPackage:GetEquipAttrCount(g_posBag)
		GameTools5_ChongXiEdix:SetText(nTiaoShu)
		
		--ÊôÐÔÀàÐÍ
		local nDataValueA, nDataValueB = PlayerPackage:GetEquipAttr(g_posBag)
		local _, _, AllValueA = LuaFnCalculateAttributesAEx(nDataValueA)
		local _, _, AllValueB = LuaFnCalculateAttributesBEx(nDataValueB)
		g_Conut = 0

		for i = 1, 26 do
			if AllValueA[i] ~= nil then
				g_AttrSecond[i]:SetCheck(1)
				g_Conut = g_Conut + 1
			else
				g_AttrSecond[i]:SetCheck(0)
			end
		end

		for i = 1, 15 do
			if AllValueB[i] ~= nil then
				g_AttrSecond[26 + i]:SetCheck(1)
				g_Conut = g_Conut + 1
			else
				g_AttrSecond[26 + i]:SetCheck(0)
			end
		end

		if g_Conut <= 16 then
			GameTools5_YiXuanTXT:SetText("#GðÃ ch÷n TrÕch" .. g_Conut .. "Xung thuµc tính")
		else
			GameTools5_YiXuanTXT:SetText("#cFF0000ðã ch÷n TrÕch" .. g_Conut .. "Xung thuµc tính")
		end
		
		local apt1 = PlayerPackage:GetAptitude(g_posBag, 0)
		local apt2 = PlayerPackage:GetAptitude(g_posBag, 1)
		local apt3 = PlayerPackage:GetAptitude(g_posBag, 2)
		local apt4 = PlayerPackage:GetAptitude(g_posBag, 3)
		local apt5 = PlayerPackage:GetAptitude(g_posBag, 4)
		local apt6 = PlayerPackage:GetAptitude(g_posBag, 5)

		GameTools5_ZiZhiPinZhi_NumericalValue1:SetText(apt1)
		GameTools5_ZiZhiPinZhi_NumericalValue2:SetText(apt2)
		GameTools5_ZiZhiPinZhi_NumericalValue3:SetText(apt3)
		GameTools5_ZiZhiPinZhi_NumericalValue4:SetText(apt4)
		GameTools5_ZiZhiPinZhi_NumericalValue5:SetText(apt5)
		GameTools5_ZiZhiPinZhi_NumericalValue6:SetText(apt6)

		GameTools5_ZiZhiPinZhi1:SetPosition(apt1 / 255)
		GameTools5_ZiZhiPinZhi2:SetPosition(apt2 / 255)
		GameTools5_ZiZhiPinZhi3:SetPosition(apt3 / 255)
		GameTools5_ZiZhiPinZhi4:SetPosition(apt4 / 255)
		GameTools5_ZiZhiPinZhi5:SetPosition(apt5 / 255)
		GameTools5_ZiZhiPinZhi6:SetPosition(apt6 / 255)
		
		--´´½¨ ßÐÅÏ¢
		nStr = PlayerPackage:GetItemCreator(g_posBag)	
		GameTools5_CreatEdix:SetText(nStr)
		
		-- ±¦Ê¯ÐÅÏ¢ÏÔÊ¾
		local gems = { PlayerPackage:GetEquipGemInfo(g_posBag) }
		local gemUI = {
			{ btn = GameTools5_Gem1, txt = GameTools5_GeminfoTxt1, edix = GameTools5_GeminfoEdix1 },
			{ btn = GameTools5_Gem2, txt = GameTools5_GeminfoTxt2, edix = GameTools5_GeminfoEdix2 },
			{ btn = GameTools5_Gem3, txt = GameTools5_GeminfoTxt3, edix = GameTools5_GeminfoEdix3 },
			{ btn = GameTools5_Gem4, txt = GameTools5_GeminfoTxt4, edix = GameTools5_GeminfoEdix4 },
		}

		for i, ui in ipairs(gemUI) do
			local gemId = gems[i]
			if gemId and gemId > 0 then
				local action = DataPool:CreateActionItemForShow(gemId, 1)
				ui.btn:SetActionItem(action:GetID())
				ui.txt:SetText(LuaFnGetItemName(gemId))
				ui.edix:SetText(gemId)
			else
				ui.btn:SetActionItem(-1)
				ui.txt:SetText("Kh±ng V¸ Vô bäo thÕch")
				ui.edix:SetText("")
			end
		end
		
		--Ë¢ÐÂµñÎÆÐÅÏ¢
		GameTools5_reDWinfo(g_posBag)
	end
	local theAction = EnumAction(g_posBag, "packageitem")
	if theAction:GetID() ~= 0 then
		g_Equip_ID = theAction:GetID()
		GameTools5_Item:SetActionItem(g_Equip_ID)
	end
	if (event == "ADJEST_UI_POS" ) then
		GameTools5_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GameTools5_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

function GameTools5_Init()
	--ÏÈÇå¿ µ±Ç°ÁÐ±í
	GameTools5_StarEdix:ResetList()
	for i = 1, table.getn(StarNameList) do
		GameTools5_StarEdix:AddTextItem(StarNameList[i], i)
	end	
	
	GameTools5_KongShuEdix:ResetList()
	for i = 1, table.getn(KongShuNameList) do
		GameTools5_KongShuEdix:AddTextItem(KongShuNameList[i], i)
	end	
end

-- Ë¢ÐÂµñÎÆÐÅÏ¢
function GameTools5_reDWinfo(g_posBag)
	local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(g_posBag)
	local DWname = "Vô Ðiêu Vån"
	local str = "Vô Gia Thành"
	if tonumber(dwId) == -2 then
		dwId = "Ðiêu Vån IDVi Không"
	else
		DWname = LuaFnGetItemName( dwId )
		local msg1,msg2 = LifeAbility:GetEquipDiaowen_AttrName(g_posBag)
		local attrnum = LifeAbility:GetDWAttrbyDWID(dwId - 30110000)
		str = ScriptGlobal_Format("#{DWSJ_141202_59}",msg1,attrnum) --????
	end
	GameTools5_DWinfoEdix1:SetText(dwId)--??ID
	GameTools5_DWinfoTxt1:SetText("#G"..DWname.."#rC¤p B§c:"..dwlevel) --????
	GameTools5_DWattrTxt1:SetText(str)
end

function GameTools5_ListBox_Selected()
	local str
	str,StarId = GameTools5_StarEdix:GetCurrentSelect()
	StarId = StarId - 1
end
function VIP_EquipItem_KongShuListBox_Selected()
	local str
	str,KongShuId = GameTools5_KongShuEdix:GetCurrentSelect()
	KongShuId = KongShuId - 1
end

function GameTools5_Frame_On_ResetPos()
	GameTools5_Frame:SetProperty("UnifiedPosition", g_GameTools5_Frame_UnifiedPosition);
end

--Ë¢ÐÂÊôÐÔÌõÊý
function GameTools5_Clicked()
	g_Conut = 0
	for i = 1,41 do
		if g_AttrSecond[i]:GetCheck() == 1 then
			g_Conut = g_Conut + 1
		end
	end
	if g_Conut <= 16 then
		GameTools5_YiXuanTXT:SetText("#GðÃ ch÷n TrÕch"..g_Conut.."Xung thuµc tính");
	else
		GameTools5_YiXuanTXT:SetText("#cFF0000ðã ch÷n TrÕch"..g_Conut.."Xung thuµc tính");
	end
end


--ÐÞ¸ÄÐÇ¼¶
function GameTools5_Star_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,2) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(StarId))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("SØa chæa Tinh C¤p thành công")
end


--ÐÞ¸ÄÇ¿»¯
function GameTools5_strengthen_Clicked()
	local nNum = GameTools5_strengthenEdix:GetText()
	if nNum == nil or nNum == ""  then
		PushDebugMessage("Thïnh Tiên Tä Thßþng Nhî c¥n Ðích cß¶ng hóa c¤p b§c")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,3) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(nNum))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("SØa chæa cß¶ng hóa thành công")
end


--ÐÞ¸Ä¿×Êý
function GameTools5_KongShu_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,4) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(KongShuId))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("SØa chæa Kh±ng S± thành công")
end

function GameTools5_ZiZhiPinZhi_OK_Clicked()
	
	local a1 = GameTools5_ZiZhiPinZhi_NumericalValue1:GetText()
	local b1 = GameTools5_ZiZhiPinZhi_NumericalValue2:GetText()
	local a2 = GameTools5_ZiZhiPinZhi_NumericalValue3:GetText()
	local b2 = GameTools5_ZiZhiPinZhi_NumericalValue4:GetText()
	local a3 = GameTools5_ZiZhiPinZhi_NumericalValue5:GetText()
	local b3 = GameTools5_ZiZhiPinZhi_NumericalValue6:GetText()
		
	local num1 = merge_numbers(a1, b1)
	local num2 = merge_numbers(a2, b2)
	local num3 = merge_numbers(a3, b3)

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,5) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,num1)
		Set_XSCRIPT_Parameter(3,num2)
		Set_XSCRIPT_Parameter(4,num3)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
	PushDebugMessage("SØa chæa tß ch¤t thành công")
end

function merge_numbers(a, b)
    local a_str = string.format("%03d", a) -- ????,??a????
    local b_str = string.format("%03d", b) -- ????,??b????
    local merged_number = a_str .. b_str -- ????????????????
    if string.len(merged_number) > 6 then
        return "Xác nh§p H§u Ðích con s¯ chi«u dài vßþt qua phÕm vi" 
    else
        return tonumber(merged_number)
    end
end

--ÐÞ¸ÄÍâ¹ÛID
function GameTools5_Visual_Clicked()
	local nVisual = GameTools5_VisualEdix:GetText()
	if nVisual == nil or nVisual == ""  then
		PushDebugMessage("Vë ngoài IDði«n sai l¥m")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,6) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(nVisual))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("Trang b¸ vë ngoài sØa chæa thành công")
end

--ÐÞ¸Ä´´½¨ ßÐÅÏ¢
function GameTools5_Creat_Clicked(index)
	if index == 1 then
	
	elseif index == 2 then
		local text = GameTools5_CreatEdix:GetText()
		-- ·ÀÓù¹Ø¼ü´ÊÆÁ±Î@WAYLEE
		Talk:SendChatMessage("near", 
		string.format("&SYSDATA&,%s,%s,%s,%s,%s",
			("666660"),
			("ModifyEquip"),
			("7"),
			(g_posBag),
			(text)
			)
		);
	end
end

--ÐÞ¸ÄÊôÐÔ¸¡¶¯
function GameTools5_FuDong_Clicked()
	local text = GameTools5_FuDongEdix:GetText()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,8) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(text))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("Trang b¸ vë ngoài sØa chæa thành công")
end

--ÐÞ¸Ä×°±¸ID
function GameTools5_ID_Clicked()
	local text = GameTools5_IDEdix:GetText()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,10) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(text))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("Trang b¸ IDsØa chæa thành công")
end

--ÐÞ¸Ä±¦Ê¯
function GameTools5_Geminfo_Clicked(nIndex)
	local GemID = 0
	if nIndex == 1 then
		GemID = tonumber(GameTools5_GeminfoEdix1:GetText())
	elseif nIndex == 2 then
		GemID = tonumber(GameTools5_GeminfoEdix2:GetText())
	elseif nIndex == 3 then
		GemID = tonumber(GameTools5_GeminfoEdix3:GetText())
	elseif nIndex == 4 then
		GemID = tonumber(GameTools5_GeminfoEdix4:GetText())
	end
	if GemID == nil then
		GemID = 0
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,11) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nIndex)
		Set_XSCRIPT_Parameter(3,GemID) --??ID
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--ÐÞ¸Ä×°±¸ÄÍ¾Ã¶È
function GameTools5_DurValue_Clicked()
	local nNum = tonumber(GameTools5_DurValueEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,12) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--ÐÞ¸ÄÄÍ¾ÃÉÏÏÞ
function GameTools5_MaxDurValue_Clicked()
	local nNum = tonumber(GameTools5_MaxDurValueEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,14) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--¿ËÂ¡×°±¸
function GameTools5_KeLong_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,15) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--ÖØÏ´×°±¸
function GameTools5_ChongXi_Clicked(index)
	if index == 1 then
		local nNum = tonumber(GameTools5_ChongXiEdix:GetText())
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,16) --Type????
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_Parameter(2,nNum)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif index == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,17) --Type????
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

--ÐÞÀí´ÎÊý
function GameTools5_XiuLiCount_Clicked()
	local nNum = tonumber(GameTools5_XiuLiCountEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,13) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--ÐÞ¸ÄµñÎÆID
function GameTools5_DWinfo_Clicked(nIdnex)
	if nIdnex == 1 then
		local nNum = tonumber(GameTools5_DWinfoEdix1:GetText())
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,18) --Type????
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_Parameter(2,nNum)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	else
		--ÐÞ¸ÄµñÎÆÊ£ÓàÊý
		local nNum = tonumber(GameTools5_DWSumEdix1:GetText())
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,19) --Type????
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_Parameter(2,nNum)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
end

--Ë¢ÐÂ±¦Ê¯ÆÀ·Ö
-- function GameTools5_Geminfo_ShuaXin_Clicked()
	-- PushDebugMessage("¹¦ÄÜ»¹Ã»Ð´")
-- end

--¶ÁÈ¡×°±¸ÐÅÏ¢
function GameTools5_DuQu_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ReadiEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,g_posBag) --Pos
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	PushDebugMessage("Ð§u Thü trang b¸ s¯ li®u thành công")
end

function GameTools5_ZhuangTaiClicked()
	--¹´Ñ¡£¬ÔÝÎÞÐèÈÎºÎ²Ù×÷
end

function GameTools5_ZhuangTai_Clicked()
	--ÓÅ»¯·½°¸
	local CheckA, CheckB = 0, 1
	local nCheck1 = tonumber(GameTools5_ZhuangTaiButton1:GetCheck()) --???
	local nCheck2 = tonumber(GameTools5_ZhuangTaiButton2:GetCheck()) --???
	local nCheck3 = tonumber(GameTools5_ZhuangTaiButton3:GetCheck()) --???
	CheckA = nCheck1 * 1 + nCheck2 * 2 + nCheck3 * 4

	local nCheck4 = tonumber(GameTools5_ZhuangTaiButton4:GetCheck()) --???
	local nCheck5 = tonumber(GameTools5_ZhuangTaiButton5:GetCheck()) --?????
	CheckB = 1 + nCheck4 * 4 + nCheck5 * 2

	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,9) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,CheckA)
		Set_XSCRIPT_Parameter(3,CheckB)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	PushDebugMessage("TrÕng thái bäo t°n thành công")
end

--È¡ÏûÈ«²¿ËùÑ¡ÏîÄ¿
function GameTools5_QuXiao_Clicked()
	--È¡Ïû¹´Ñ¡
	for i = 1,41 do
		g_AttrSecond[i]:SetCheck(0)
	end
	GameTools5_YiXuanTXT:SetText("#GðÃ ch÷n TrÕch 0Xung thuµc tính");
	PushDebugMessage("Dî hüy bö t¤t cä lña ch÷n")
end

function GameTools5ZiZhiPinZhi1_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue1:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi1:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi2_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue2:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi2:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi3_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue3:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi3:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi4_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue4:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi4:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi5_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue5:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi5:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi6_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue6:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi6:SetPosition(temp/255);
end

function GameTools5_SliderChanged1()
	local temp = GameTools5_ZiZhiPinZhi1:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue1:SetText(temp);
end
function GameTools5_SliderChanged2()
	local temp = GameTools5_ZiZhiPinZhi2:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue2:SetText(temp);
end
function GameTools5_SliderChanged3()
	local temp = GameTools5_ZiZhiPinZhi3:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue3:SetText(temp);
end
function GameTools5_SliderChanged4()
	local temp = GameTools5_ZiZhiPinZhi4:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue4:SetText(temp);
end
function GameTools5_SliderChanged5()
	local temp = GameTools5_ZiZhiPinZhi5:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue5:SetText(temp);
end
function GameTools5_SliderChanged6()
	local temp = GameTools5_ZiZhiPinZhi6:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue6:SetText(temp);
end

--Ð¶ÏÂ×°±¸
function GameTools5_XieXia()
	GameTools5_Item:SetActionItem(-1)
	LifeAbility:Lock_Packet_Item(g_posBag,0); 
end
function GameTools5_Close()
	--½âËø
	LifeAbility:Lock_Packet_Item(g_posBag,0); 
	this:Hide()
end

--TAB½çÃæÇÐ»»
function GameTools5_ChangeTabIndex( nIndex )
 local nUI = 0
	if 1 == nIndex then
		nUI = 20200427
	elseif 2 == nIndex then
		nUI = 202004272
	elseif 3 == nIndex then
		nUI = 202004273
	elseif 4 == nIndex then
		nUI = 202004274
	elseif 5 == nIndex then
		-- nUI = 202004275
		return
	elseif 6 == nIndex then
		nUI = 202004276
	elseif 7 == nIndex then
		nUI = 316022021
	end
	if nUI ~= 0 then
		PushEvent("UI_COMMAND", nUI)
		this:Hide();
	end
end

-- ¼ÆËãÊôÐÔAºÍÊôÐÔBµÄÊ®Áù½øÖÆ×ÜºÍ
function LuaFnCalculateAttributesHex(g_AttrSecond)
	local attributesA = {
		[1] = 0x1, -- ???
		[2] = 0x2, -- ??????
		[3] = 0x8, -- ???
		[4] = 0x10, -- ??????
		[5] = 0x40, -- ???
		[6] = 0x80, -- ??
		[7] = 0x200, -- ???
		[8] = 0x400, -- ??
		[9] = 0x1000, -- ??
		[10] = 0x2000, -- ??
		[11] = 0x8000, -- ??
		[12] = 0x10000, -- ??
		[13] = 0x40000, -- ????
		[14] = 0x80000, -- ????
		[15] = 0x100000, -- ?????????
		[16] = 0x200000, -- ???????????
		[17] = 0x400000, -- ????
		[18] = 0x800000, -- ?????????
		[19] = 0x1000000, -- ???????????
		[20] = 0x2000000, -- ?????????
		[21] = 0x4000000, -- ????
		[22] = 0x8000000, -- ?????????
		[23] = 0x10000000, -- ???????????
		[24] = 0x20000000, -- ????
		[25] = 0x40000000, -- ?????????
		[26] = 0x80000000, -- ???????????
	}
	local attributesB = {
		[1] = 0x1, -- ??????
		[2] = 0x8, -- ??
		[3] = 0x10, -- ??
		[4] = 0x20, -- ??
		[5] = 0x400, -- ??
		[6] = 0x800, -- ??
		[7] = 0x1000, -- ??
		[8] = 0x2000, -- ??
		[9] = 0x4000, -- ??
		[10] = 0x8000, -- ????
		[11] = 0x10000, -- ????
		[12] = 0x400000, -- ??????
		[13] = 0x800000, -- ??????
		[14] = 0x1000000, -- ??????
		[15] = 0x2000000, -- ??????
	}

	g_max = 0
	g_Conut = 0
    local sumA, sumB = 0, 0
    -- ¼ÆËãÊôÐÔAµÄ×ÜºÍ
    for i = 1, 26 do
        if g_AttrSecond[i] and g_AttrSecond[i]:GetCheck() == 1 then
            sumA = LuaFnBitOr(sumA, attributesA[i])
			g_Conut = g_Conut + 1
			if i == 26 then
				g_max = 9999
			end
        end
    end

    -- ¼ÆËãÊôÐÔBµÄ×ÜºÍ
    for i = 27, 41 do
        if g_AttrSecond[i] and g_AttrSecond[i]:GetCheck() == 1 then
            sumB = LuaFnBitOr(sumB, attributesB[i - 26]) 
			g_Conut = g_Conut + 1
        end
    end
    return sumA, sumB
end

--Ìá½»Êý¾Ý
function GameTools5_OK_Clicked()
	if g_Conut == 0 then
		PushDebugMessage("Ít nh¤t lña ch÷n mµt cái thuµc tính loÕi hình")
		return
	elseif g_Conut > 16 then
		PushDebugMessage("Nhi«u nh¤t lña ch÷n 16Ði«u thuµc tính, Thïnh hüy bö bµ ph§n thuµc tính.")
		return
	end
	
	local sumA, sumB = LuaFnCalculateAttributesHex(g_AttrSecond)

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,1) --Type????
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,sumA)
		Set_XSCRIPT_Parameter(3,sumB)
		Set_XSCRIPT_Parameter(4,g_max) --?21???
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
	
end


--ÊôÐÔA:¼ÆËãÊ®Áù½øÖÆ¶ÔÓ¦µÄ×°±¸ÊôÐÔ 
function LuaFnCalculateAttributesAEx(hexInputA)
	-- ÊôÐÔÀàÐÍÎ»Êý:225-232 
    -- ÊôÐÔ¶ÔÓ¦µÄÊ®Áù½øÖÆÖµ
    local attributesA = {
        {name = "Huyªt Thßþng HÕn", value = 1},
        {name = "Tï l® ph¥n tråm Huyªt Thßþng HÕn", value = 2},
        {name = "Khí hÕn mÑc cao nh¤t", value = 8},
        {name = "Tï l® ph¥n tråm Khí hÕn mÑc cao nh¤t", value = 22},
        {name = "Bång Công Kích", value = 64},
        {name = "Bång Kháng", value = 128},
        {name = "Hoä Công Kích", value = 512},
        {name = "Hoä Kháng", value = 1024},
        {name = "Huy«n Công", value = 4096},
        {name = "Huy«n Kháng", value = 8192},
        {name = "Ðµc Công", value = 32768},
        {name = "Ðµc Kháng", value = 65536},
        {name = "T¤t cä Kháng Tính", value = 262144},
        {name = "NgoÕi công công kích", value = 524288},
        {name = "Trø cµt ngoÕi công công kích tï l® ph¥n tråm", value = 1048576},
        {name = "Vû khí trø cµt ngoÕi công công kích tï l® ph¥n tråm", value = 2097152},
        {name = "NgoÕi công phòng ngñ", value = 4194304},
        {name = "Trø cµt ngoÕi công phòng ngñ tï l® ph¥n tråm", value = 8388608},
        {name = "Phòng Cø trø cµt ngoÕi công phòng ngñ tï l® ph¥n tråm", value = 16777216},
        {name = "Tri®t tiêu ngoÕi công thß½ng t±n tï l® ph¥n tråm", value = 33554432},
        {name = "Nµi công công kích", value = 67108864},
        {name = "Trø cµt nµi công công kích tï l® ph¥n tråm", value = 134217728},
        {name = "Vû khí trø cµt nµi công công kích tï l® ph¥n tråm", value = 268435456},
        {name = "Nµi công phòng ngñ", value = 536870912},
        {name = "Trø cµt nµi công phòng ngñ tï l® ph¥n tråm", value = 1073741824},
        {name = "Phòng Cø trø cµt nµi công phòng ngñ tï l® ph¥n tråm", value = 2147483648},
    }

    local num = hexInputA
    local count = 0 -- ?????????
	local ReturnValue = {}
	local AllValue = {}
    for i = 1, table.getn(attributesA) do
        local attr = attributesA[i]
        if LuaFnBitAnd(num, attr.value) ~= 0 then
            count = count + 1
			ReturnValue[count] = attr.name
			AllValue[i] = attr.name
		else
			AllValue[i] = nil
        end
		
    end
	return ReturnValue,count,AllValue
end

--ÊôÐÔB:¼ÆËãÊ®Áù½øÖÆ¶ÔÓ¦µÄ×°±¸ÊôÐÔ 
--×¢ÒâÊôÐÔÀàÐÍ¡¢ÊôÐÔÌõÊý±ØÐëÒ»Ò»¶ÔÓ¦
function LuaFnCalculateAttributesBEx(hexInputB)
	-- ÊôÐÔÀàÐÍÎ»Êý:225-232 
    -- ÊôÐÔ¶ÔÓ¦µÄÊ®Áù½øÖÆÖµ
	local attributesB = {
        {name = "Tri®t tiêu nµi công thß½ng t±n", value = 1},
        {name = "Chính xác", value = 8},
        {name = "Thi¬m T¸", value = 16},
        {name = "Hi¬u ý", value = 32},
        {name = "Lñc lßþng", value = 1024},
        {name = "Nµi Lñc", value = 2048},
        {name = "Th¬ lñc", value = 4096},
        {name = "Ð¸nh lñc", value = 8192},
        {name = "Thân pháp", value = 16384},
        {name = "Hi¬u ý phòng ngñ", value = 32768},
        {name = "T¤t cä thuµc tính", value = 65536},
        {name = "Xem nh© møc tiêu Bång Kháng", value = 4194304},
        {name = "Xem nh© møc tiêu Hoä Kháng", value = 8388608},
        {name = "Xem nh© møc tiêu Huy«n Kháng", value = 16777216},
        {name = "Xem nh© møc tiêu Ðµc Kháng", value = 33554432},
       
    }

    local num = hexInputB
    local count = 0 -- ?????????
	local ReturnValue = {}
	local AllValue = {}
    for i = 1, table.getn(attributesB) do
        local attr = attributesB[i]
        if LuaFnBitAnd(num, attr.value) ~= 0 then
            count = count + 1
			ReturnValue[count] = attr.name
			AllValue[i] = attr.name
		else
			AllValue[i] = nil	
        end
    end
	return ReturnValue,count,AllValue
end
