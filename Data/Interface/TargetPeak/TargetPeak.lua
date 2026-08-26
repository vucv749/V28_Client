--!!!reloadscript =TargetPeak
local g_TargetPeak_Frame_UnifiedPosition

local g_PageButton = {}
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		},
	[2] = {Text = "#{INTERFACE_XML_882}",		},
	[3] = {Text = "#{INTERFACE_XML_854}",		},
	[4] = {Text = "#{WH_xml_XX(95)}",			},
	[5] = {Text = "#{SZXT_221216_22}",			},
	[6] = {Text = "#{SBFW_20230707_1}",			},
	[7] = {Text = "#{DWJJ_240329_153}",  	 	},
	[8] = {Text = "#{DFJC_250709_1}",  	 	},
	[9] = {Text = "#{GRYM_221213_22}",  	 	},
}

local g_menpai = {
	[1] = {Text = "Thiªu Lâm",}, --??
	[2] = {Text = "Minh Giáo",}, --??
	[3] = {Text = "Cái Bang",}, --??
	[4] = {Text = "Võ Ðang",}, --??
	[5] = {Text = "Nga Mi",}, --??
	[6] = {Text = "Tinh Túc",}, --??
	[7] = {Text = "Thiên Long",}, --??
	[8] = {Text = "Thiên S½n",}, --??
	[9] = {Text = "Tiêu dao",}, --??
	[10] = {Text = "MÕn Ðà S½n Trang",}, --????
	[11] = {Text = "Ác Nhân C¯c",}, --???
}


local TargetPeak_Image_Icon =
{
	"set:Peak image:Peak_LevelNum0",
	"set:Peak image:Peak_LevelNum1",
	"set:Peak image:Peak_LevelNum2",
	"set:Peak image:Peak_LevelNum3",
	"set:Peak image:Peak_LevelNum4",
	"set:Peak image:Peak_LevelNum5",
	"set:Peak image:Peak_LevelNum6",
	"set:Peak image:Peak_LevelNum7",
	"set:Peak image:Peak_LevelNum8",
	"set:Peak image:Peak_LevelNum9",
}


local g_TargetPeak_shuxing_INT_Cache = {}
local g_TargetPeak_shuxing_INT_SpecialAttrName= {}
local g_DeFengLv = 0
local g_DFMenPaiInfo = {}
function TargetPeak_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function TargetPeak_OnLoad()
	g_TargetPeak_Frame_UnifiedPosition = TargetPeak_Frame:GetProperty("UnifiedPosition")

	-- ·ÖÒ³°´Å¥
	g_PageButton[1] = TargetPeak_SelfEquip
	g_PageButton[2] = TargetPeak_TargetData
	g_PageButton[3] = TargetPeak_Pet
	g_PageButton[4] = TargetPeak_TargetWuhun
	g_PageButton[5] = TargetPeak_TargetLingyu
	g_PageButton[6] = TargetPeak_TargetWeapon2
	g_PageButton[7] = TargetPeak_TargetDWJinJie
	g_PageButton[8] = TargetPeak_TargetPeak
	g_PageButton[9] = TargetPeak_TargetProfile
	
end

function TargetPeak_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 20251127 then
		if this:IsVisible() then
			this:Hide()
			return
		end
		g_DeFengLv = Get_XParam_INT(0)
		g_DFMenPaiInfo = {0,0,0}
		g_DFMenPaiInfo[1] = Get_XParam_INT(1)
		g_DFMenPaiInfo[2] = Get_XParam_INT(2)
		g_DFMenPaiInfo[3] = Get_XParam_INT(3)
		-- if not CachedTarget:IsPresent(1) then
			-- return
		-- end

		-- if not CachedTarget:CanGetTargetEquip() then
			-- PushDebugMessage("¾àÀë¸ÃÍæ¼ÒÌ«Ô¶£¬ÎÞ·¨²é¿´×ÊÁÏ¡£")				-- ¾àÀë¸ÃÍæ¼ÒÌ«Ô¶£¬ÎÞ·¨²é¿´×ÊÁÏ¡£
			-- return
		-- end
		-- local objCared = CachedTarget:GetData("NPCID", 1)
		-- if type(objCared) ~= "number" then
			-- PushDebugMessage ("¾àÀë¸ÃÍæ¼ÒÌ«Ô¶£¬ÎÞ·¨²é¿´×ÊÁÏ¡£")			-- ¾àÀë¸ÃÍæ¼ÒÌ«Ô¶£¬ÎÞ·¨²é¿´×ÊÁÏ¡£
			-- return
		-- end

		--this:CareObject(objCared , 1)
		TargetPeak_OnShown()
		TargetPeak_Update()
		TargetPeak_ShowPage()
		this:Show()
	end	
	
	if event == "PLAYER_LEAVE_WORLD" then
		--this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		TargetPeak_Frame_On_ResetPos()
	end
	
	if event == "OTHERPLAYER_UPDATE_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
		TargetPeak_Update()
	end
	
end

function TargetPeak_OnShown()
	local otherUnionPos = Variable:GetVariable("OtherUnionPos")
	if otherUnionPos ~= nil then
		TargetPeak_Frame:SetProperty("UnifiedPosition", otherUnionPos)
	end
end
--Update
function TargetPeak_Update()

	local DFLevel = g_DeFengLv
	TargetPeak_DealLevel(DFLevel)
	
	local TargetPeak_WuxueLearn_Attack = {}
	local TargetPeak_WuxueLearn_Defence = {}
	local TargetPeak_WuxueLearn_Attack_Num = {}
	local TargetPeak_WuxueLearn_Defence_Num = {}
	local TargetPeak_WuxueLearn_Attack_Locked = {}
	local TargetPeak_WuxueLearn_Defence_Locked = {}
	local TargetPeak_WuxueLearn_Attack_NumIcon = {}
	local TargetPeak_WuxueLearn_Defence_NumIcon = {}
	
	g_TargetPeak_shuxing_INT_Cache = {}
	g_TargetPeak_shuxing_INT_SpecialAttrName = {}

	for i = 1, DFLevel, 1 do
		local ret,DFDFengAttrValueStr = GetDFengDFengAttrValueStr(i)
		if ret > 0 then
			TargetPeak_InsertData(i)
		end
		TargetPeak_InsertData_DFengQND(i)
	end	
	for i=1,9 do
		_G["TargetPeak_ListContent_Attr"..i]:SetText("0")
	end
	TargetPeak_DealData()

	local nAttackMenPai1,nDefenceMenPai1,nAttackMenPaiXDD1,nDefenceMenPaiXDD1 = GetTarAttackDefenceType(g_DFMenPaiInfo[1])
	local nAttackMenPai2,nDefenceMenPai2,nAttackMenPaiXDD2,nDefenceMenPaiXDD2 = GetTarAttackDefenceType(g_DFMenPaiInfo[2])
	local nAttackMenPai3,nDefenceMenPai3,nAttackMenPaiXDD3,nDefenceMenPaiXDD3 = GetTarAttackDefenceType(g_DFMenPaiInfo[3])

	for i=1,3 do
		TargetPeak_WuxueLearn_Attack[i] = _G[string.format("TargetPeak_WuxueLearn_Attack%d",i)]
		TargetPeak_WuxueLearn_Attack[i]:SetText("#cff0000chßa lña ch÷n môn phái")
		TargetPeak_WuxueLearn_Attack[i]:SetProperty("HorzFormatting","HorzCentred")
		TargetPeak_WuxueLearn_Attack[i]:SetToolTip("")
		TargetPeak_WuxueLearn_Attack[i]:Hide()
		TargetPeak_WuxueLearn_Defence[i] = _G[string.format("TargetPeak_WuxueLearn_Defence%d",i)]
		TargetPeak_WuxueLearn_Defence[i]:SetText("#cff0000chßa lña ch÷n môn phái")
		TargetPeak_WuxueLearn_Defence[i]:SetProperty("HorzFormatting","HorzCentred")
		TargetPeak_WuxueLearn_Defence[i]:SetToolTip("")
		TargetPeak_WuxueLearn_Defence[i]:Hide()
		
		TargetPeak_WuxueLearn_Attack_Num[i] = _G[string.format("TargetPeak_WuxueLearn_Attack%d_Num",i)]
		TargetPeak_WuxueLearn_Attack_Num[i]:SetText("")
		TargetPeak_WuxueLearn_Defence_Num[i] = _G[string.format("TargetPeak_WuxueLearn_Defence%d_Num",i)]
		TargetPeak_WuxueLearn_Defence_Num[i]:SetText("")
		TargetPeak_WuxueLearn_Attack_Locked[i] = _G[string.format("TargetPeak_WuxueLearn_Attack%d_Locked",i)]
		TargetPeak_WuxueLearn_Attack_Locked[i]:Show()
		TargetPeak_WuxueLearn_Defence_Locked[i] = _G[string.format("TargetPeak_WuxueLearn_Defence%d_Locked",i)]
		TargetPeak_WuxueLearn_Defence_Locked[i]:Show()
		TargetPeak_WuxueLearn_Attack_NumIcon[i] = _G[string.format("TargetPeak_WuxueLearn_Attack%d_NumIcon",i)]
		TargetPeak_WuxueLearn_Attack_NumIcon[i]:Hide()
		TargetPeak_WuxueLearn_Defence_NumIcon[i] = _G[string.format("TargetPeak_WuxueLearn_Defence%d_NumIcon",i)]
		TargetPeak_WuxueLearn_Defence_NumIcon[i]:Hide()
	end

	if DFLevel >= 10 then
		TargetPeak_WuxueLearn_Attack1_Locked:Hide()
		TargetPeak_WuxueLearn_Attack1:Show()
	end

	if DFLevel >= 20 then
		TargetPeak_WuxueLearn_Defence1_Locked:Hide()
		TargetPeak_WuxueLearn_Defence1:Show()
	end

	if DFLevel >= 50 then
		TargetPeak_WuxueLearn_Attack2_Locked:Hide()
		TargetPeak_WuxueLearn_Defence2_Locked:Hide()
		TargetPeak_WuxueLearn_Attack2:Show()
		TargetPeak_WuxueLearn_Defence2:Show()
	end

	if DFLevel >= 100 then
		TargetPeak_WuxueLearn_Attack3_Locked:Hide()
		TargetPeak_WuxueLearn_Defence3_Locked:Hide()
		TargetPeak_WuxueLearn_Attack3:Show()
		TargetPeak_WuxueLearn_Defence3:Show()
	end
	
	local AttackMenPai = {nAttackMenPai1,nAttackMenPai2,nAttackMenPai3}
	local DefenceMenPai = {nDefenceMenPai1,nDefenceMenPai2,nDefenceMenPai3}
	
	local AttackMenPaiXDD = {nAttackMenPaiXDD1,nAttackMenPaiXDD2,nAttackMenPaiXDD3}
	local DfenceMenPaiXDD = {nDefenceMenPaiXDD1,nDefenceMenPaiXDD2,nDefenceMenPaiXDD3}
	
	for i=1,3 do
		if AttackMenPai[i] > 0 then
			local szJinGongMenPai = g_menpai[AttackMenPai[i]].Text
			local nAttackMenPaiXDD_ex = AttackMenPaiXDD[i]
			if nAttackMenPaiXDD_ex < 5 then
				nAttackMenPaiXDD_ex = AttackMenPaiXDD[i]
			else
				nAttackMenPaiXDD_ex = 5
			end
			TargetPeak_WuxueLearn_Attack[i]:SetText(szJinGongMenPai)
			TargetPeak_WuxueLearn_Attack[i]:SetProperty("HorzFormatting","LeftAligned")
			TargetPeak_WuxueLearn_Attack[i]:SetToolTip("#cfff263nhi«u nh¤t có ðúng không#G"..szJinGongMenPai.."#cfff263môn phái tÕo thành Ðích thß½ng t±n gia tång#G"..tostring(nAttackMenPaiXDD_ex).."#cfff263(Nhu tính toán ð¯i phß½ng Ðích Thü Ngñ Võ Quyªt)")
			TargetPeak_WuxueLearn_Attack[i]:Show()
			TargetPeak_WuxueLearn_Attack_Num[i]:SetText(AttackMenPaiXDD[i])
			TargetPeak_WuxueLearn_Attack_Locked[i]:Hide()
			TargetPeak_WuxueLearn_Attack_NumIcon[i]:Show()
		end

		if DefenceMenPai[i] > 0 then
			local szFangYuMenPai = g_menpai[DefenceMenPai[i]].Text
			local nDefenceMenPaiXDD_ex = DfenceMenPaiXDD[i]
			if nDefenceMenPaiXDD_ex < 5 then
				nDefenceMenPaiXDD_ex = DfenceMenPaiXDD[i]
			else
				nDefenceMenPaiXDD_ex = 5
			end
			TargetPeak_WuxueLearn_Defence[i]:SetText(szFangYuMenPai)
			TargetPeak_WuxueLearn_Defence[i]:SetProperty("HorzFormatting","LeftAligned")
			TargetPeak_WuxueLearn_Defence[i]:SetToolTip("#G"..szFangYuMenPai.."#cfff263môn phái Ð¯i tñ thân tÕo thành Ðích thß½ng t±n nhi«u nh¤t r½i ch§m lÕi#G"..tostring( nDefenceMenPaiXDD_ex).."#cfff263(Nhu tính toán ð¯i phß½ng Ðích công kích Võ Quyªt)")
			TargetPeak_WuxueLearn_Defence[i]:Show()
			TargetPeak_WuxueLearn_Defence_Num[i]:SetText(DfenceMenPaiXDD[i])
			TargetPeak_WuxueLearn_Defence_Locked[i]:Hide()
			TargetPeak_WuxueLearn_Defence_NumIcon[i]:Show()
		end
		
	end
end

function TargetPeak_DealData()

	local shuxing = {"Lñc lßþng","Nµi Lñc","Ð¸nh lñc","Thân pháp","NgoÕi công công kích","Nµi công công kích","NgoÕi công phòng ngñ","Nµi công phòng ngñ","Th¬ lñc"}
	for i=1, table.getn(shuxing) do
		local key = shuxing[i]
		local ShuxingCache = g_TargetPeak_shuxing_INT_Cache[key]
		
		if ShuxingCache and tonumber(ShuxingCache) > 0 then
			local SpecialAttrNameShuxingCache = g_TargetPeak_shuxing_INT_SpecialAttrName[key]
			_G["TargetPeak_ListContent_Attr"..i]:SetText(ShuxingCache..SpecialAttrNameShuxingCache)
		end

	end

end

function GetTarAttackDefenceType(nData)
	local nMPID = {0,0,0,0}
	nMPID[1] = math.mod( nData, 100)
	nMPID[2] = math.mod( math.floor( nData /100 ) , 100)
	nMPID[3] = math.mod( math.floor( nData /10000 ) , 100)
	nMPID[4] = math.floor(nData / 1000000)
	return nMPID[1],nMPID[2],nMPID[3],nMPID[4]
end

function TargetPeak_CloseUI()
	this:Hide()
end

function TargetPeak_OnHidden()
	--this:Hide()
end

-- ´ò¿ªÍæ¼Ò×°±¸UI
function TargetPeak_TargetEquip_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(1), 1)
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenEquipFrame("other")
	this:Hide()
end

-- ´ò¿ªÍæ¼ÒÐÅÏ¢½çÃæ
function TargetPeak_TargetData_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(2), 1)
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("other")
	this:Hide()
end

-- ´ò¿ªÍæ¼Ò³èÎïUI
function TargetPeak_OtherPet_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(3), 1)
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPetFrame("other")
	this:Hide()
end

function TargetPeak_TargetWuhun_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(4), 1)
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		TargetPeak_TargetWuhun:SetCheck(0)
		return
	end
	
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherWuhun()
	this:Hide()
end

function TargetPeak_TargetLingyu_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(5), 1)
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
	this:Hide()
end

function TargetPeak_ShenBing_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(6), 1)
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
	this:Hide()
end

function TargetPeak_DWJinJie_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(7), 1)
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
	this:Hide()
end
function TargetPeak_ClearPage()
	Variable:SetVariable("TargetPageNumber", tostring(0), 1)
end
function TargetPeak_TargetProfile_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(9), 1)
	local lv = CachedTarget:GetData("LEVEL", 1)
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetPeak_TargetProfile:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end
--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function TargetPeak_Frame_On_ResetPos()
	TargetPeak_Frame:SetProperty("UnifiedPosition", g_TargetPeak_Frame_UnifiedPosition)
end

function TargetPeak_ShowPage()

	for i = 1, 9 do
		g_PageButton[i]:Hide()
	end
		
	local nPageNumber = tonumber(Variable:GetVariable("TargetPageNumber"));
	TargetPeak_ClearPage()
	
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, 9 do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, 9 do
		if TargetPeak_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)
			g_PageOrder[g_PageCount] = i
		end
	end
end
function TargetPeak_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 6 then--??
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 7 then--????
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 8 then--?? 
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 9 then--??
		return 1
	end
	return 0
end

function TargetPeak_OtherProfile_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(9), 1)
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetPeak_TargetProfile:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetPeak_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
	this:Hide()
end

function TargetPeak_OnPageClicked(idx)

	Variable:SetVariable("TargetPageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--??
		TargetPeak_TargetEquip_Switch()
	elseif idx == 2 then--??
		TargetPeak_TargetData_Switch()
	elseif idx == 3 then--??
		TargetPeak_OtherPet_Switch()
	elseif idx == 4 then--??
		TargetPeak_TargetWuhun_Switch()
	elseif idx == 5 then--??
		TargetPeak_TargetLingyu_Switch()
	elseif idx == 6 then--??
		TargetPeak_ShenBing_Switch()
	elseif idx == 7 then--????
		TargetPeak_DWJinJie_Switch()
	elseif idx == 8 then
		TargetPeak_ClearPage()
	elseif idx == 9 then
		TargetPeak_OtherProfile_Switch()
	end
end
function TargetPeak_InsertData(index)

	local attrRet ,DFDFengAttrStr = GetDFengDFengAttrStr(index)

	if attrRet > 0 then
		
		local nDFDFengAttrValueStr = GetDFengDFengAttrValueINT(index)

		local nRetSpecialAttr,nDFFeng_Special_Attrname = GetDFengDFengAttrEquipSpecialAttName(index)

		if g_TargetPeak_shuxing_INT_Cache[DFDFengAttrStr] and g_TargetPeak_shuxing_INT_Cache[DFDFengAttrStr] > 0 then
			g_TargetPeak_shuxing_INT_Cache[DFDFengAttrStr] = tonumber(g_TargetPeak_shuxing_INT_Cache[DFDFengAttrStr]) + tonumber(nDFDFengAttrValueStr)
		else
			g_TargetPeak_shuxing_INT_Cache[DFDFengAttrStr] = nDFDFengAttrValueStr
		end

		
		g_TargetPeak_shuxing_INT_SpecialAttrName[DFDFengAttrStr] = nDFFeng_Special_Attrname
	end

end

function TargetPeak_InsertData_DFengQND(index)
	local attrstr = "Ti«m nång Ði¬m"
	local QNDValue = GetDFengDFengQNDValueINT(index)
	if  QNDValue > 0 then
		if g_TargetPeak_shuxing_INT_Cache[attrstr] and g_TargetPeak_shuxing_INT_Cache[attrstr] > 0 then
			g_TargetPeak_shuxing_INT_Cache[attrstr] = tonumber(g_TargetPeak_shuxing_INT_Cache[attrstr]) + tonumber(QNDValue)
		else
			g_TargetPeak_shuxing_INT_Cache[attrstr] = QNDValue
		end
	end

	g_TargetPeak_shuxing_INT_SpecialAttrName[attrstr] = ""

end

function TargetPeak_DealLevel(param1)
	local num = TargetPeak_getDigitLevel(param1)
	local ones,tens,hundreds = TargetPeak_getDigits(param1)

	if num == -1 then
		num = 1 
		ones = 0
	end
	if num == 1 then
		TargetPeak_LevelFrame_1:Show()
		TargetPeak_LevelFrame_2:Hide()
		TargetPeak_LevelFrame_3:Hide()

		TargetPeak_LevelFrame_1_1:SetProperty("Image",TargetPeak_Image_Icon[ones+1]);

	elseif num == 2 then
		TargetPeak_LevelFrame_1:Hide()
		TargetPeak_LevelFrame_2:Show()
		TargetPeak_LevelFrame_3:Hide()

		TargetPeak_LevelFrame_2_1:SetProperty("Image",TargetPeak_Image_Icon[tens+1])
		TargetPeak_LevelFrame_2_2:SetProperty("Image",TargetPeak_Image_Icon[ones+1]);
	elseif num == 3 then
		TargetPeak_LevelFrame_1:Hide()
		TargetPeak_LevelFrame_2:Hide()
		TargetPeak_LevelFrame_3:Show()

		TargetPeak_LevelFrame_3_1:SetProperty("Image",TargetPeak_Image_Icon[hundreds+1]);
		TargetPeak_LevelFrame_3_2:SetProperty("Image",TargetPeak_Image_Icon[tens+1]);		
		TargetPeak_LevelFrame_3_3:SetProperty("Image",TargetPeak_Image_Icon[ones+1]);		
	end

end

function TargetPeak_getDigits(param1)
	local n = math.abs(param1)
	local ones = math.mod( param1, 10)
	local tens = math.floor( n /10 ) 
	tens =  math.mod( tens, 10)
	local hundreds = math.floor(n / 100) 
	hundreds =  math.mod( hundreds, 10)
	return ones,tens,hundreds
end
	
function TargetPeak_getDigitLevel(n)
	n = math.abs(n)
	if n < 10 then
		return 1
	elseif n < 100 then
		return 2
	elseif n < 1000 then
		return 3		
	end
	return -1
end
