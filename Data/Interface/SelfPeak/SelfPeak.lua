--!!!reloadscript =SelfPeak

local g_SelfPeak_Frame_UnifiedPosition

--Í³Ò»»¯ÏÂÒ³Ç©ÏÔÊ¾Òþ²Ø Ä¿Ç°¹Ì¶¨Ë³Ðò ÐÂÔö¸ÄÐòºÅ Ã¿¸öÒ³Ç©¶¼ÐèÒªÌí¼Ó
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		NeedCheck = 0,Tip = ""},
	[2] = {Text = "#{INTERFACE_XML_882}",		NeedCheck = 0,Tip = ""},
	[3] = {Text = "#{INTERFACE_XML_854}",		NeedCheck = 0,Tip = ""},
	[4] = {Text = "#{WH_xml_XX(95)}",			NeedCheck = 0,Tip = ""},
	[5] = {Text = "#{XL_XML_35}",				NeedCheck = 0,Tip = ""},
	[6] = {Text = "#{TalentMP_20210804_57}",	NeedCheck = 1,Tip = ""},
	[7] = {Text = "#{SZXT_221216_22}",			NeedCheck = 0,Tip = "#{SZXT_221216_23}"},
	[8] = {Text = "#{SBFW_20230707_1}",		NeedCheck = 1,Tip = "#{SBFW_20230707_2}"},
	[9] = {Text = "#{DWJJ_240329_153}",  	 	NeedCheck = 0,Tip = ""},
	[10] = {Text = "#{DFJC_250709_1}",		NeedCheck = 0,Tip = ""},
	[11] = {Text = "#{GRYM_221213_22}",  	 	NeedCheck = 0,Tip = ""},
	[12] = {Text = "#{INTERFACE_XML_496}",		NeedCheck = 0,Tip = ""},
}


local g_menpai = {
	[1] = {Text = "#{DFJC_250709_20}",}, --??
	[2] = {Text = "#{DFJC_250709_21}",}, --??
	[3] = {Text = "#{DFJC_250709_22}",}, --??
	[4] = {Text = "#{DFJC_250709_23}",}, --??
	[5] = {Text = "#{DFJC_250709_24}",}, --??
	[6] = {Text = "#{DFJC_250709_25}",}, --??
	[7] = {Text = "#{DFJC_250709_26}",}, --??
	[8] = {Text = "#{DFJC_250709_27}",}, --??
	[9] = {Text = "#{DFJC_250709_28}",}, --??
	[10] = {Text = "#{DFJC_250709_29}",}, --????
	[11] = {Text = "#{DFJC_250709_30}",}, --???
}
local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}

local g_SkillAction = {}
local g_SkillActionLock = {}
local g_ExtensionText = {}


local g_maxdfenglevel = 200 --#define MAX_DFENG_LEVEL 200	// ??????

local g_SelfPeak_shuxing_INT_Cache = {}
local g_SelfPeak_shuxing_INT_SpecialAttrName= {}

-- Èë¿ÚNPC
local SelfPeak_Goto_EnterNPCInfo =
{
    scn = 2,
    pos = { 219, 43 },
    name = "Huy«n Trí pháp sß",
} -- end SelfPeak_Goto_EnterNPCInfo

local SelfPeak_Image_Icon =
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
} -- end SelfPeak_Image_Icon

function SelfPeak_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	

	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)

	this:RegisterEvent("REFRESH_EQUIP", false)
	this:RegisterEvent("UNIT_LEVEL", false)

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	

end

function SelfPeak_OnLoad()
	g_SelfPeak_Frame_UnifiedPosition	= SelfPeak_Frame:GetProperty("UnifiedPosition")
	g_PageTip[1] = SelfPeak_SelfPeak_tips
	g_PageTip[2] = SelfPeak_SelfData_tips
	g_PageTip[3] = SelfPeak_Pet_tips
	g_PageTip[4] = SelfPeak_Wuhun_tips
	g_PageTip[5] = SelfPeak_Xiulian_tips
	g_PageTip[6] = SelfPeak_Talent_tips
	g_PageTip[7] = SelfPeak_Lingyu_tips
	g_PageTip[8] = SelfPeak_Weapon2_tips
	g_PageTip[9] = SelfPeak_DWJinJie_tips
	g_PageTip[10] = SelfPeak_Peak_tips
	g_PageTip[11] = SelfPeak_Profile_tips
	g_PageTip[12] = SelfPeak_OtherInfo_tips


	g_PageButton[1] = SelfPeak_SelfPeak
	g_PageButton[2] = SelfPeak_SelfData
	g_PageButton[3] = SelfPeak_Pet
	g_PageButton[4] = SelfPeak_Wuhun
	g_PageButton[5] = SelfPeak_Xiulian
	g_PageButton[6] = SelfPeak_Talent
	g_PageButton[7] = SelfPeak_Lingyu
	g_PageButton[8] = SelfPeak_Weapon2
	g_PageButton[9] = SelfPeak_DWJinJie
	g_PageButton[10] = SelfPeak_Peak
	g_PageButton[11] = SelfPeak_Profile
	g_PageButton[12] = SelfPeak_OtherInfo
	

	g_PageMask[1] = SelfPeak_SelfPeak_Mask
	g_PageMask[2] = SelfPeak_SelfData_Mask
	g_PageMask[3] = SelfPeak_Pet_Mask
	g_PageMask[4] = SelfPeak_Wuhun_Mask
	g_PageMask[5] = SelfPeak_Xiulian_Mask
	g_PageMask[6] = SelfPeak_Talent_Mask
	g_PageMask[7] = SelfPeak_Lingyu_Mask
	g_PageMask[8] = SelfPeak_Weapon2_Mask
	g_PageMask[9] = SelfPeak_DWJinJie_Mask
	g_PageMask[10] = SelfPeak_Peak_Mask
	g_PageMask[11] = SelfPeak_Profile_Mask
	g_PageMask[12] = SelfPeak_OtherInfo_Mask
	

end

function SelfPeak_OnEvent(event)

	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 20251126 then

		if this:IsVisible() then
			this:Hide()
			return
		end

		SelfPeak_ShowPage()
		SelfPeak_Update()
		SelfPeak_OnShown() --????
		this:Show()
		SelfPeak_UpdateRedPoint()
		return
	end

	if event == "REFRESH_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
		SelfPeak_Update()
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		SelfPeak_Frame_On_ResetPos()
	end

	if event == "UNIT_LEVEL" and this:IsVisible() then
		SelfPeak_Update()	
	end

end

function SelfPeak_InsertData_DFengQND(index)
	local attrstr = "Ti«m nång Ði¬m"
	local QNDValue = GetDFengDFengQNDValueINT(index)
	if  QNDValue > 0 then
		if g_SelfPeak_shuxing_INT_Cache[attrstr] and g_SelfPeak_shuxing_INT_Cache[attrstr] > 0 then
			g_SelfPeak_shuxing_INT_Cache[attrstr] = tonumber(g_SelfPeak_shuxing_INT_Cache[attrstr]) + tonumber(QNDValue)
		else
			g_SelfPeak_shuxing_INT_Cache[attrstr] = QNDValue
		end
	end

	g_SelfPeak_shuxing_INT_SpecialAttrName[attrstr] = ""

end
function SelfPeak_InsertData(index)
	local attrRet ,DFengAttrStr = GetDFengDFengAttrStr(index)
	if attrRet > 0 then
		local nDFDFengAttrValueStr = GetDFengDFengAttrValueINT(index)
		local nRetSpecialAttr,nDFFeng_Special_Attrname = GetDFengDFengAttrEquipSpecialAttName(index)

		if g_SelfPeak_shuxing_INT_Cache[DFengAttrStr] and g_SelfPeak_shuxing_INT_Cache[DFengAttrStr] > 0 then
			g_SelfPeak_shuxing_INT_Cache[DFengAttrStr] = tonumber(g_SelfPeak_shuxing_INT_Cache[DFengAttrStr]) + tonumber(nDFDFengAttrValueStr)
		else
			g_SelfPeak_shuxing_INT_Cache[DFengAttrStr] = nDFDFengAttrValueStr
		end
		
		g_SelfPeak_shuxing_INT_SpecialAttrName[DFengAttrStr] = nDFFeng_Special_Attrname
	end

end
function SelfPeak_DealData()

	local shuxing = {"Lñc lßþng","Nµi Lñc","Ð¸nh lñc","Thân pháp","NgoÕi công công kích","Nµi công công kích","NgoÕi công phòng ngñ","Nµi công phòng ngñ","Th¬ lñc"}
	for i=1, table.getn(shuxing) do
		local key = shuxing[i]
		local ShuxingCache = g_SelfPeak_shuxing_INT_Cache[key]
		
		if ShuxingCache and tonumber(ShuxingCache) > 0 then
			local SpecialAttrNameShuxingCache = g_SelfPeak_shuxing_INT_SpecialAttrName[key]
			_G["SelfPeak_ListContent_Attr"..i]:SetText(ShuxingCache..SpecialAttrNameShuxingCache)
		end

	end


end

--Update
function SelfPeak_Update()

	local DFLevle = GetDFengLevel()
	SelfPeak_DealLevel(DFLevle)

	local DFExp = GetDFengExp()
	local nDFNeedExp = GetDFengNeedExp()
	local szDFExp = "#cfff263Võ Cänh kinh nghi®m:"..DFExp.."/"..nDFNeedExp
	
	local bHaveExtra=0;
	local nTimes = GetDFengLevelupTimes()
	local levelupNumStr = "#cfff263B±n Chu còn th×a Võ Cänh c¤p b§c tång lên s¯ l¥n:"..(7-nTimes)
	local bIsZhuiGan, bIsWkZhuiGan = GetDFengZhuiGanInfo()
	if bIsWkZhuiGan > 0 or bIsZhuiGan > 0 then
		local nExtraTimes = GetDFengExtraLevelupTimes()
		if bIsZhuiGan > 0 and nExtraTimes < 3 then
			SelfPeak_ExtraNum_Text:SetText("#cfff263thêm vào s¯ l¥n:"..(3-nExtraTimes))
			bHaveExtra=1;
		else
			SelfPeak_ExtraNum_Text:SetText("#cfff263thêm vào tång lên s¯ l¥n Dî ÐÕt hÕn mÑc cao nh¤t")
		end
		SelfPeak_ExtraNum_Text:Show()
	else
		SelfPeak_ExtraNum_Text:Hide()
	end	

	local ntimes = 7 - nTimes
	if ntimes <= 0 and bHaveExtra == 0 then --	#G?????????????,???????????
		SelfPeak_LevelUpNum_Text:Hide()
		SelfPeak_LevelUpNum_Text:SetText("")
		SelfPeak_LevelEXP_Text:SetText("#GB‘n Chu Võ Cänh Khä tång lên c¤p b§c Dî ÐÕt hÕn mÑc cao nh¤t, không th¬ tiªp tøc nh§n ðßþc Võ Cänh kinh nghi®m.")
	else 
		SelfPeak_LevelUpNum_Text:Show()
		SelfPeak_LevelUpNum_Text:SetText(levelupNumStr)
		SelfPeak_LevelEXP_Text:SetText(szDFExp)
	end

	local SelfPeak_WuxueLearn_Attack = {}
	local SelfPeak_WuxueLearn_Defence = {}
	local SelfPeak_WuxueLearn_Attack_Num = {}
	local SelfPeak_WuxueLearn_Defence_Num = {}
	local SelfPeak_WuxueLearn_Attack_Locked = {}
	local SelfPeak_WuxueLearn_Defence_Locked = {}
	local SelfPeak_WuxueLearn_Attack_NumIcon = {}
	local SelfPeak_WuxueLearn_Defence_NumIcon = {}
	g_SelfPeak_shuxing_INT_Cache = {}
	g_SelfPeak_shuxing_INT_SpecialAttrName = {}
	
	for i=1,3 do
		SelfPeak_WuxueLearn_Attack[i] = _G[string.format("SelfPeak_WuxueLearn_Attack%d",i)]
		SelfPeak_WuxueLearn_Attack[i]:SetText("#cff0000chßa lña ch÷n môn phái")
		SelfPeak_WuxueLearn_Attack[i]:SetProperty("HorzFormatting","HorzCentred")
		SelfPeak_WuxueLearn_Attack[i]:SetToolTip("")
		SelfPeak_WuxueLearn_Attack[i]:Hide()
		SelfPeak_WuxueLearn_Defence[i] = _G[string.format("SelfPeak_WuxueLearn_Defence%d",i)]
		SelfPeak_WuxueLearn_Defence[i]:SetText("#cff0000chßa lña ch÷n môn phái")
		SelfPeak_WuxueLearn_Defence[i]:SetProperty("HorzFormatting","HorzCentred")
		SelfPeak_WuxueLearn_Defence[i]:SetToolTip("")
		SelfPeak_WuxueLearn_Defence[i]:Hide()
		
		SelfPeak_WuxueLearn_Attack_Num[i] = _G[string.format("SelfPeak_WuxueLearn_Attack%d_Num",i)]
		SelfPeak_WuxueLearn_Attack_Num[i]:SetText("")
		SelfPeak_WuxueLearn_Defence_Num[i] = _G[string.format("SelfPeak_WuxueLearn_Defence%d_Num",i)]
		SelfPeak_WuxueLearn_Defence_Num[i]:SetText("")
		SelfPeak_WuxueLearn_Attack_Locked[i] = _G[string.format("SelfPeak_WuxueLearn_Attack%d_Locked",i)]
		SelfPeak_WuxueLearn_Attack_Locked[i]:Show()
		SelfPeak_WuxueLearn_Defence_Locked[i] = _G[string.format("SelfPeak_WuxueLearn_Defence%d_Locked",i)]
		SelfPeak_WuxueLearn_Defence_Locked[i]:Show()
		SelfPeak_WuxueLearn_Attack_NumIcon[i] = _G[string.format("SelfPeak_WuxueLearn_Attack%d_NumIcon",i)]
		SelfPeak_WuxueLearn_Attack_NumIcon[i]:Hide()
		SelfPeak_WuxueLearn_Defence_NumIcon[i] = _G[string.format("SelfPeak_WuxueLearn_Defence%d_NumIcon",i)]
		SelfPeak_WuxueLearn_Defence_NumIcon[i]:Hide()
	end

	for i=1,9 do
		_G["SelfPeak_ListContent_Attr"..i]:SetText("0")
	end
	
	for i = 1, DFLevle, 1 do
		local ret,DFDFengAttrValueStr = GetDFengDFengAttrValueStr(i)
		if ret > 0 then
			SelfPeak_InsertData(i)
		end
		SelfPeak_InsertData_DFengQND(i)
	end	

	SelfPeak_DealData()

	if DFLevle >= 200 then
		SelfPeak_LevelEXP_Text:Hide()
		SelfPeak_LevelUpNum_Text:Hide()
	else
		SelfPeak_LevelEXP_Text:Show()
		SelfPeak_LevelUpNum_Text:Show()
	end


	local retDFengAttrNextLStr,nextLevelStr = GetDFengDFengAttrNextLevelStr()
	if retDFengAttrNextLStr > 0 then
		SelfPeak_NextLevelAttr:SetText(nextLevelStr)
	else
		local QNDValue = GetDFengDFengQNDValueINT(DFLevle+1)
		if QNDValue > 0 then
			local qnd = "#cfff263ti«m nång Ði¬m".." +"..QNDValue
			SelfPeak_NextLevelAttr:SetText(qnd)
		else
			SelfPeak_NextLevelAttr:SetText("#Gc„p b§c Dî ÐÕt hÕn mÑc cao nh¤t")
		end
	end

	if DFLevle >= 10 then
		SelfPeak_WuxueLearn_Attack1_Locked:Hide()
		SelfPeak_WuxueLearn_Attack1:Show()
	end	
	if DFLevle >= 20 then
		SelfPeak_WuxueLearn_Defence1_Locked:Hide()
		SelfPeak_WuxueLearn_Defence1:Show()
	end	
	if DFLevle >= 50 then
		SelfPeak_WuxueLearn_Attack2_Locked:Hide()
		SelfPeak_WuxueLearn_Defence2_Locked:Hide()
		SelfPeak_WuxueLearn_Attack2:Show()
		SelfPeak_WuxueLearn_Defence2:Show()
	end	

	if DFLevle >= 100 then
		SelfPeak_WuxueLearn_Attack3_Locked:Hide()
		SelfPeak_WuxueLearn_Defence3_Locked:Hide()
		SelfPeak_WuxueLearn_Attack3:Show()
		SelfPeak_WuxueLearn_Defence3:Show()
	end

	SelfPeak_WuxueLearn_AttackPoint:SetText("#cfff263công kích Võ Quyªt")
	SelfPeak_WuxueLearn_DefencePoint:SetText("#cfff263Thü Ngñ Võ Quyªt")

	local ndefencexdd= GetDFengDefenceXDD();
	local nattackxdd = GetDFengAttackXDD();

	local nAttackMenPai1 = GetAttackMenPai1()
	local nAttackMenPai2 = GetAttackMenPai2()
	local nAttackMenPai3 = GetAttackMenPai3()
	local nDefenceMenPai1 = GetDefenceMenPai1()
	local nDefenceMenPai2 = GetDefenceMenPai2()
	local nDefenceMenPai3 = GetDefenceMenPai3()

	local nAttackMenPaiXDD1 = GetAttackMenPaiXDD1()
	local nAttackMenPaiXDD2 = GetAttackMenPaiXDD2()
	local nAttackMenPaiXDD3 = GetAttackMenPaiXDD3()
	
	local nDfenceMenPaiXDD1 = GetDefenceMenPaiXDD1()
	local nDfenceMenPaiXDD2 = GetDefenceMenPaiXDD2()
	local nDfenceMenPaiXDD3 = GetDefenceMenPaiXDD3()

	local nattackminu = nattackxdd - nAttackMenPaiXDD1 - nAttackMenPaiXDD2 - nAttackMenPaiXDD3
	local ndefenceminu = ndefencexdd - nDfenceMenPaiXDD1 - nDfenceMenPaiXDD2 - nDfenceMenPaiXDD3

	SelfPeak_WuxueLearn_AttackPoint_Num:SetText("#cfff263công kích Võ Quyªt Ði¬m: #G"..nattackminu)
	SelfPeak_WuxueLearn_DefencePoint_Num:SetText("#cfff263Thü Ngñ Võ Quyªt Ði¬m: #G"..ndefenceminu)

	local nNextLevelMinu = 0
	local nDfengType = 0
	if DFLevle >= g_maxdfenglevel then
		SelfPeak_NextAttrPreview_Text:Hide()
	else
		SelfPeak_NextAttrPreview_Text:Show()
		for i = DFLevle+1, g_maxdfenglevel, 1 do
			local ret,DFDFengAttrType = GetDFengDFengAttrValueType(i)
			if ret > 0 then
				if DFDFengAttrType == 104	then
					nNextLevelMinu = i - DFLevle
					nDfengType = 104
					break
				elseif DFDFengAttrType == 105 then
					nNextLevelMinu = i - DFLevle
					nDfengType = 105
					break
				end
			end
		end		
		
		SelfPeak_NextAttrPreview:SetText("")
		if nDfengType == 104   then
			SelfPeak_NextAttrPreview_Text:SetText("#cfff263khoäng cách nh§n ðßþc công kích Võ Quyªt Ði¬m Hoàn Th£ng: #G"..nNextLevelMinu.."#cfff263C¤p")	
		elseif nDfengType == 105   then
			SelfPeak_NextAttrPreview_Text:SetText("#cfff263khoäng cách nh§n ðßþc Thü Ngñ Võ Quyªt Ði¬m Hoàn Th£ng: #G"..nNextLevelMinu.."#cfff263C¤p")	
		else
			SelfPeak_NextAttrPreview_Text:Hide()
		end	
		
	end

	local AttackMenPai = {nAttackMenPai1,nAttackMenPai2,nAttackMenPai3}
	local DefenceMenPai = {nDefenceMenPai1,nDefenceMenPai2,nDefenceMenPai3}
	
	local AttackMenPaiXDD = {nAttackMenPaiXDD1,nAttackMenPaiXDD2,nAttackMenPaiXDD3}
	local DfenceMenPaiXDD = {nDfenceMenPaiXDD1,nDfenceMenPaiXDD2,nDfenceMenPaiXDD3}
	
	for i=1,3 do
		if AttackMenPai[i] > 0 then
			local szJinGongMenPai = g_menpai[AttackMenPai[i]].Text
			local nAttackMenPaiXDD_ex = AttackMenPaiXDD[i]
			if nAttackMenPaiXDD_ex < 5 then
				nAttackMenPaiXDD_ex = AttackMenPaiXDD[i]
			else
				nAttackMenPaiXDD_ex = 5
			end
			SelfPeak_WuxueLearn_Attack[i]:SetText(szJinGongMenPai)
			SelfPeak_WuxueLearn_Attack[i]:SetProperty("HorzFormatting","LeftAligned")
			SelfPeak_WuxueLearn_Attack[i]:SetToolTip("#cfff263nhi«u nh¤t có ðúng không#G"..szJinGongMenPai.."#cfff263môn phái tÕo thành Ðích thß½ng t±n gia tång#G"..tostring(nAttackMenPaiXDD_ex).."#cfff263(Nhu tính toán ð¯i phß½ng Ðích Thü Ngñ Võ Quyªt)")
			SelfPeak_WuxueLearn_Attack[i]:Show()
			SelfPeak_WuxueLearn_Attack_Num[i]:SetText(AttackMenPaiXDD[i])
			SelfPeak_WuxueLearn_Attack_Locked[i]:Hide()
			SelfPeak_WuxueLearn_Attack_NumIcon[i]:Show()
		end

		if DefenceMenPai[i] > 0 then
			local szFangYuMenPai = g_menpai[DefenceMenPai[i]].Text
			local nDefenceMenPaiXDD_ex = DfenceMenPaiXDD[i]
			if nDefenceMenPaiXDD_ex < 5 then
				nDefenceMenPaiXDD_ex = DfenceMenPaiXDD[i]
			else
				nDefenceMenPaiXDD_ex = 5
			end
			SelfPeak_WuxueLearn_Defence[i]:SetText(szFangYuMenPai)
			SelfPeak_WuxueLearn_Defence[i]:SetProperty("HorzFormatting","LeftAligned")
			SelfPeak_WuxueLearn_Defence[i]:SetToolTip("#G"..szFangYuMenPai.."#cfff263môn phái Ð¯i tñ thân tÕo thành Ðích thß½ng t±n nhi«u nh¤t r½i ch§m lÕi#G"..tostring( nDefenceMenPaiXDD_ex).."#cfff263(Nhu tính toán ð¯i phß½ng Ðích công kích Võ Quyªt)")
			SelfPeak_WuxueLearn_Defence[i]:Show()
			SelfPeak_WuxueLearn_Defence_Num[i]:SetText(DfenceMenPaiXDD[i])
			SelfPeak_WuxueLearn_Defence_Locked[i]:Hide()
			SelfPeak_WuxueLearn_Defence_NumIcon[i]:Show()
		end
		
	end

end

function SelfPeak_Equip_Clicked(buttonIn)
	local button = tonumber(buttonIn)
	if button == 1 then
		SelfPeak_Equip:DoAction()
	else
		SelfPeak_Equip:DoSubAction()
	end
end

function SelfPeak_OnShown()
	local selfUnionPos = Variable:GetVariable("SelfUnionPos")
	if selfUnionPos ~= nil then
		SelfPeak_Frame:SetProperty("UnifiedPosition", selfUnionPos)
	end
end

function SelfPeak_OnHiden()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
	
	--SelfPeak_ListContent:Clear()
end
--player's equip
function SelfPeak_Page_SelfEquip()
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	OpenEquip(1)
	SelfPeak_Close()
end
--player's info
function SelfPeak_Page_SelfData()
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("self")
	SelfPeak_Close()
end
--player's pet
function SelfPeak_Page_Pet()
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePetPage()
	SelfPeak_Close()
end
function SelfPeak_Page_Wuhun()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		SelfEquip_Wuhun : SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
	SelfPeak_Close()
end
--xiu lian
function SelfPeak_Page_Xiulian()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		return
	end
	
    local nLevel = Player:GetData("LEVEL")
	if nLevel >= 70 then
		Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
		XiuLianPage()
		SelfPeak_Close()
	else
	    SelfPeak_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    SelfPeak_ClearPage()
	end
end

function SelfPeak_Page_Talent()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
		ToggleTalentPage()
	else
		SelfPeak_Talent:SetCheck(0)
		SelfPeak_ClearPage()
		return
	end
	SelfPeak_Close()
end

function SelfPeak_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		SelfPeak_Lingyu:SetCheck(0)
		SelfPeak_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
	SelfPeak_Close()
end

function SelfPeak_Page_Peak()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		SelfPeak_Peak:SetCheck(0)
		SelfPeak_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
end

function SelfPeak_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		SelfPeak_DWJinJie:SetCheck(0)
		SelfPeak_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
	SelfPeak_Close()
end

--ÇÐ»»¸öÈË ¹Ê¾½çÃæ
function SelfPeak_Page_Profile()
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1);
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
	SelfPeak_Close()
end

--player's other info
function SelfPeak_Page_OtherInfo()
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	OtherInfoPage()
	SelfPeak_Close()	
end
--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function SelfPeak_Frame_On_ResetPos()
	SelfPeak_Frame:SetProperty("UnifiedPosition", g_SelfPeak_Frame_UnifiedPosition)
end

function SelfPeak_ShowPage()
	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"))
	SelfPeak_ClearPage()
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, g_MaxPage do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, g_MaxPage do
		if SelfPeak_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if SelfPeak_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Hide()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function SelfPeak_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1)
	idx = g_PageOrder[idx]
	if idx == 1 then--??
		SelfPeak_Page_SelfEquip()
	elseif idx == 2 then--??
		SelfPeak_Page_SelfData()
	elseif idx == 3 then--??
		SelfPeak_Page_Pet()
	elseif idx == 4 then--??
		SelfPeak_Page_Wuhun()
	elseif idx == 5 then--??
		SelfPeak_Page_Xiulian()
	elseif idx == 6 then--??
		SelfPeak_Page_Talent()
	elseif idx == 7 then--??
		SelfPeak_Page_LingYu()
	elseif idx == 8 then--??
		SelfPeak_Page_ShenBing()
	elseif idx == 9 then--????
		SelfPeak_Page_DWJinJie()
	elseif idx == 10 then--??
		SelfPeak_ClearPage()
	elseif idx == 11 then--??
		SelfPeak_Page_Profile()
	elseif idx == 12 then--??
		SelfPeak_Page_OtherInfo()
	end
end

function SelfPeak_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--??
		return 1
	elseif idx == 8 then--??
		return 1
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--??
		return 1

	end
	return 0
end

function SelfPeak_IsPageEnable(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return 1
	elseif idx == 7 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		return 1
	elseif idx == 12 then--??
		return 1

	end
	return 0
end

function SelfPeak_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--¸üÐÂ·ÖÒ³ºìµã
function SelfPeak_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end
function SelfPeak_CloseUI()
	-- ´ò¿ª»ò ß¹Ø± ³ÆºÅ½çÃæ
	SelfPeak_Close()
end


function SelfPeak_Close()	
	this:Hide();
end
function SelfPeak_Page_ShenBing()
	Variable:SetVariable("SelfUnionPos", SelfPeak_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
	SelfPeak_Close()
end

function SelfPeak_TopFrame_HelpClicked()
	PushEvent("CCSHOP_HELP", 40)	
end
function SelfPeak_BottomRight_HelpClicked()
	PushEvent("CCSHOP_HELP", 41)	
end


--=========================================================
function SelfPeak_Goto_Clicked()
    -- Ñ°Â·Ç°ÍùÈë¿ÚNPC
    local targetInfo = SelfPeak_Goto_EnterNPCInfo
    if (targetInfo ~= nil) then
        AutoRuntoTargetExWithName(targetInfo.pos[1], targetInfo.pos[2], targetInfo.scn, targetInfo.name)
    end

end

function SelfPeak_DealLevel(param1)
	local num = SelfPeak_getDigitLevel(param1)
	local ones,tens,hundreds = SelfPeak_getDigits(param1)

	if num == -1 then
		num = 1 
		ones = 0
	end
	if num == 1 then
		SelfPeak_LevelFrame_1:Show()
		SelfPeak_LevelFrame_2:Hide()
		SelfPeak_LevelFrame_3:Hide()

		SelfPeak_LevelFrame_1_1:SetProperty("Image",SelfPeak_Image_Icon[ones+1]);

	elseif num == 2 then
		SelfPeak_LevelFrame_1:Hide()
		SelfPeak_LevelFrame_2:Show()
		SelfPeak_LevelFrame_3:Hide()

		SelfPeak_LevelFrame_2_1:SetProperty("Image",SelfPeak_Image_Icon[tens+1])
		SelfPeak_LevelFrame_2_2:SetProperty("Image",SelfPeak_Image_Icon[ones+1]);
	elseif num == 3 then
		SelfPeak_LevelFrame_1:Hide()
		SelfPeak_LevelFrame_2:Hide()
		SelfPeak_LevelFrame_3:Show()

		SelfPeak_LevelFrame_3_1:SetProperty("Image",SelfPeak_Image_Icon[hundreds+1]);
		SelfPeak_LevelFrame_3_2:SetProperty("Image",SelfPeak_Image_Icon[tens+1]);		
		SelfPeak_LevelFrame_3_3:SetProperty("Image",SelfPeak_Image_Icon[ones+1]);		
	end

end

function SelfPeak_getDigits(param1)
	local n = math.abs(param1)
	local ones = math.mod( param1, 10)
	local tens = math.floor( n /10 ) 
	tens =  math.mod( tens, 10)
	local hundreds = math.floor(n / 100) 
	hundreds =  math.mod( hundreds, 10)
	return ones,tens,hundreds
end
	
function SelfPeak_getDigitLevel(n)
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
