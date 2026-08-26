--!!!reloadscript =SelfDWJinJie

local g_SelfDWJinJie_Frame_UnifiedPosition

--统一化下页签显示隐藏 目前固定顺序 新增改序号 每个页签都需要添加
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

local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}

local g_InitList = 0
local g_MaxDWEquip = 16
--0.武器 1.帽子 2.衣服 3.手套 4.鞋 5.腰带 6.戒指 7.项链 11.戒指2 12.护符 13.护符2 14.护腕 15.护肩 17.暗器 18.武魂 37.神兵
local g_EquipPointList = {0, 37, 1, 15, 14, 3, 5, 4, 6, 11, 12, 13, 2, 7, 17, 18}
local g_OpenEquipPointList = {0, 2, 6, 11}

local g_DWEffectListCtrl
local g_FeaturesEffectListCtrl

local g_EquipActionButton = {}
local g_EquipActionButtonMask = {}

local g_CurSelEquipIndex = 0

local g_CurEquipFeatures = 0

local g_MaxJinJieLevel = 50
local g_JinJieLevelStr = 
{
"#{DWJJ_240329_260}", "#{DWJJ_240329_261}", "#{DWJJ_240329_262}", "#{DWJJ_240329_263}", "#{DWJJ_240329_264}",
"#{DWJJ_240329_265}", "#{DWJJ_240329_266}", "#{DWJJ_240329_267}", "#{DWJJ_240329_268}", "#{DWJJ_240329_269}",
"#{DWJJ_240329_270}", "#{DWJJ_240329_271}", "#{DWJJ_240329_272}", "#{DWJJ_240329_273}", "#{DWJJ_240329_274}",
"#{DWJJ_240329_275}", "#{DWJJ_240329_276}", "#{DWJJ_240329_277}", "#{DWJJ_240329_278}", "#{DWJJ_240329_279}",
"#{DWJJ_240329_280}", "#{DWJJ_240329_281}", "#{DWJJ_240329_282}", "#{DWJJ_240329_283}", "#{DWJJ_240329_284}",
"#{DWJJ_240329_285}", "#{DWJJ_240329_286}", "#{DWJJ_240329_287}", "#{DWJJ_240329_288}", "#{DWJJ_240329_289}",
"#{DWJJ_240329_290}", "#{DWJJ_240329_291}", "#{DWJJ_240329_292}", "#{DWJJ_240329_293}", "#{DWJJ_240329_294}",
"#{DWJJ_240329_295}", "#{DWJJ_240329_296}", "#{DWJJ_240329_297}", "#{DWJJ_240329_298}", "#{DWJJ_240329_299}",
"#{DWJJ_240329_300}", "#{DWJJ_240329_301}", "#{DWJJ_240329_302}", "#{DWJJ_240329_303}", "#{DWJJ_240329_304}",
"#{DWJJ_240329_305}", "#{DWJJ_240329_306}", "#{DWJJ_240329_307}", "#{DWJJ_240329_308}", "#{DWJJ_240329_309}",
}

function SelfDWJinJie_PreLoad()
	this:RegisterEvent("TOGGLE_FEATURES_PAGE")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_YUANBAO")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("REFRESH_EQUIP")
end

function SelfDWJinJie_OnLoad()
	g_SelfDWJinJie_Frame_UnifiedPosition = SelfDWJinJie_Frame:GetProperty("UnifiedPosition")
	
	g_PageButton[1] = SelfDWJinJie_SelfEquip
	g_PageButton[2] = SelfDWJinJie_SelfData
	g_PageButton[3] = SelfDWJinJie_Pet
	g_PageButton[4] = SelfDWJinJie_Wuhun
	g_PageButton[5] = SelfDWJinJie_Xiulian
	g_PageButton[6] = SelfDWJinJie_Talent
	g_PageButton[7] = SelfDWJinJie_Lingyu
	g_PageButton[8] = SelfDWJinJie_Weapon2
	g_PageButton[9] = SelfDWJinJie_DWJinJie
	g_PageButton[10] = SelfDWJinJie_Peak
	g_PageButton[11] = SelfDWJinJie_Profile
	g_PageButton[12] = SelfDWJinJie_OtherInfo

	g_PageMask[1] = SelfDWJinJie_SelfEquip_Mask
	g_PageMask[2] = SelfDWJinJie_SelfData_Mask
	g_PageMask[3] = SelfDWJinJie_Pet_Mask
	g_PageMask[4] = SelfDWJinJie_Wuhun_Mask
	g_PageMask[5] = SelfDWJinJie_Xiulian_Mask
	g_PageMask[6] = SelfDWJinJie_Talent_Mask
	g_PageMask[7] = SelfDWJinJie_Lingyu_Mask
	g_PageMask[8] = SelfDWJinJie_Weapon2_Mask
	g_PageMask[9] = SelfDWJinJie_DWJinJie_Mask
	g_PageMask[10] = SelfDWJinJie_Peak_Mask
	g_PageMask[11] = SelfDWJinJie_Profile_Mask
	g_PageMask[12] = SelfDWJinJie_OtherInfo_Mask
	

	g_PageTip[1] = SelfDWJinJie_SelfEquip_tips
	g_PageTip[2] = SelfDWJinJie_SelfData_tips
	g_PageTip[3] = SelfDWJinJie_Pet_tips
	g_PageTip[4] = SelfDWJinJie_Wuhun_tips
	g_PageTip[5] = SelfDWJinJie_Xiulian_tips
	g_PageTip[6] = SelfDWJinJie_Talent_tips
	g_PageTip[7] = SelfDWJinJie_Lingyu_tips
	g_PageTip[8] = SelfDWJinJie_Weapon2_tips
	g_PageTip[9] = SelfDWJinJie_DWJinJie_tips
	g_PageTip[10] = SelfDWJinJie_Peak_tips
	g_PageTip[11] = SelfDWJinJie_Profile_tips
	g_PageTip[12] = SelfDWJinJie_OtherInfo_tips
	
	g_PageButtons[1] = SelfDWJinJie_Page1_Sift1
	g_PageButtons[2] = SelfDWJinJie_Page1_Sift2
	g_PageButtons[3] = SelfDWJinJie_Page1_Sift3
	g_PageButtons[4] = SelfDWJinJie_Page1_Sift4
	g_PageButtons[5] = SelfDWJinJie_Page1_Sift5
	
	g_DWEffectListCtrl = SelfDWJinJie_DWTeXing_TopList1
	g_FeaturesEffectListCtrl = SelfDWJinJie_DWTeXing_TopListItem2
	
	g_EquipActionButton[1] = SelfDWJinJie_EquipItem1
	g_EquipActionButton[2] = SelfDWJinJie_EquipItem2
	g_EquipActionButton[3] = SelfDWJinJie_EquipItem3
	g_EquipActionButton[4] = SelfDWJinJie_EquipItem4
	g_EquipActionButton[5] = SelfDWJinJie_EquipItem5
	g_EquipActionButton[6] = SelfDWJinJie_EquipItem6
	g_EquipActionButton[7] = SelfDWJinJie_EquipItem7
	g_EquipActionButton[8] = SelfDWJinJie_EquipItem8
	g_EquipActionButton[9] = SelfDWJinJie_EquipItem9
	g_EquipActionButton[10] = SelfDWJinJie_EquipItem10
	g_EquipActionButton[11] = SelfDWJinJie_EquipItem11
	g_EquipActionButton[12] = SelfDWJinJie_EquipItem12
	g_EquipActionButton[13] = SelfDWJinJie_EquipItem13
	g_EquipActionButton[14] = SelfDWJinJie_EquipItem14
	g_EquipActionButton[15] = SelfDWJinJie_EquipItem15
	g_EquipActionButton[16] = SelfDWJinJie_EquipItem16
	
	g_EquipActionButtonMask[1] = SelfDWJinJie_Mask1
	g_EquipActionButtonMask[2] = SelfDWJinJie_Mask2
	g_EquipActionButtonMask[3] = SelfDWJinJie_Mask3
	g_EquipActionButtonMask[4] = SelfDWJinJie_Mask4
	g_EquipActionButtonMask[5] = SelfDWJinJie_Mask5
	g_EquipActionButtonMask[6] = SelfDWJinJie_Mask6
	g_EquipActionButtonMask[7] = SelfDWJinJie_Mask7
	g_EquipActionButtonMask[8] = SelfDWJinJie_Mask8
	g_EquipActionButtonMask[9] = SelfDWJinJie_Mask9
	g_EquipActionButtonMask[10] = SelfDWJinJie_Mask10
	g_EquipActionButtonMask[11] = SelfDWJinJie_Mask11
	g_EquipActionButtonMask[12] = SelfDWJinJie_Mask12
	g_EquipActionButtonMask[13] = SelfDWJinJie_Mask13
	g_EquipActionButtonMask[14] = SelfDWJinJie_Mask14
	g_EquipActionButtonMask[15] = SelfDWJinJie_Mask15
	g_EquipActionButtonMask[16] = SelfDWJinJie_Mask16
end

function SelfDWJinJie_OnEvent(event)
	
	if event == "TOGGLE_FEATURES_PAGE" then
		if this:IsVisible() then
			this:Hide()
			return
		end
		
		SelfDWJinJie_CleanUp()
		SelfDWJinJie_ShowPage()
		SelfDWJinJie_OnShown()
		SelfDWJinJie_FirstSelect()
		this:Show()
		SelfDWJinJie_Update()
		SelfDWJinJie_UpdateRedPoint()
	end	
	
	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		SelfDWJinJie_Frame_On_ResetPos()
	end
	
	if event == "UPDATE_YUANBAO" and this:IsVisible() then
		local strYuanBao = ScriptGlobal_Format("#{ZQPM_240402_34}", tostring(Player:GetData("YUANBAO")))
	end
	
	if event == "REFRESH_EQUIP" and this:IsVisible() then
		SelfDWJinJie_Update()
		return
	end
	
end

function SelfDWJinJie_InitList()
	if g_InitList == 0 then
		g_InitList = 1
	end
end

function SelfDWJinJie_OnShown()
	local selfUnionPos = Variable:GetVariable("SelfUnionPos")
	if selfUnionPos ~= nil then
		SelfDWJinJie_Frame:SetProperty("UnifiedPosition", selfUnionPos)
	end
end

function SelfDWJinJie_FirstSelect()
	g_CurSelEquipIndex = 1
end

--Update
function SelfDWJinJie_Update()
	SelfDWJinJie_InitList()	
	SelfDWJinJie_CleanUp()
	
	SelfDWJinJie_Update_CurSelInfo()
	SelfDWJinJie_UpdateEquipList()
	SelfDWJinJie_UpdateFeaturesEffectList()
	SelfDWJinJie_UpdateDWEffectList()
end

function SelfDWJinJie_Update_CurSelInfo()
	SelfDWJinJie_DWTeXing_EquipItem:SetActionItem(-1)
	SelfDWJinJie_DWTeXing_EquipItemMask:Hide()
	
	SelfDWJinJie_DWTeXing_DWLevel:SetText("")
	SelfDWJinJie_DWTeXing_DWLevelUp:SetText("")
	SelfDWJinJie_DWTeXing_DWLevelUpNum:SetText("")
	SelfDWJinJie_DWTeXing_DWShuXingUp:SetText("")
	
	SelfDWJinJie_DWTeXing_DWItem:SetActionItem(-1)
	SelfDWJinJie_DWTeXing_DWItemMask:Hide()
	
	SelfDWJinJie_DWTeXing_Title:SetText("")
	SelfDWJinJie_DWTeXing_ShuXing:SetText("")
	SelfDWJinJie_DWTeXing_NumLevel:SetText("")
	
	SelfDWJinJie_DWTeXing_Havelevel:SetText("")
	SelfDWJinJie_DWTeXing_Nowlevel:SetText("")
	SelfDWJinJie_DWTeXing_InfoText:SetText("")
	
	SelfDWJinJie_DWTeXing_Nowlevel:SetToolTip("")
	
	local strTemp = ""
	if g_CurSelEquipIndex >= 1 and g_CurSelEquipIndex <= g_MaxDWEquip then
		local equip_point = g_EquipPointList[g_CurSelEquipIndex]
		local equipAction = EnumAction(equip_point, "equip")
		if equipAction:GetID() ~= 0 then
			SelfDWJinJie_DWTeXing_EquipItem:SetActionItem(equipAction:GetID())
			
			local broken = 0
			if equipAction:GetEquipDur() < 0.1 and equip_point ~= 17 then
				SelfDWJinJie_DWTeXing_EquipItemMask:Show()
				broken = 1
			end
			
			local dwId, dwLevel = DataPool:LuaFnGetEquipDiaowenInfo(equip_point)
			local dwRank = DataPool:LuaFnGetEquipDiaoWenRank(equip_point)
			if tonumber(dwId) ~= nil and tonumber(dwId) > 0 then
				local dwName = DataPool:LuaFnGetDiaoWenName(tonumber(dwId))
				SelfDWJinJie_DWTeXing_DWLevel:SetText("#cfff263"..tostring(dwName))
				
				local dwExp, dwMaxExp = DataPool:LuaFnGetEquipDiaowenExp(equip_point)
				if tonumber(dwExp) ~= nil and tonumber(dwMaxExp) ~= nil then
					if tonumber(dwMaxExp) < 0 then
						SelfDWJinJie_DWTeXing_DWLevelUp:SetText("#{DWJJ_240329_318}")
						SelfDWJinJie_DWTeXing_DWLevelUpNum:SetText("#{DWJJ_240329_322}")
					else
						SelfDWJinJie_DWTeXing_DWLevelUp:SetText("#{DWJJ_240329_318}")
						SelfDWJinJie_DWTeXing_DWLevelUpNum:SetText("#cfff263"..tostring(dwExp).."/"..tostring(dwMaxExp))
					end
				end
				
				local dwEffectString = DataPool:LuaFnGetEquipDiaoWenEffect(equip_point)
				SelfDWJinJie_DWTeXing_DWShuXingUp:SetText("#cfff263"..tostring(dwEffectString))
				
				if tonumber(dwRank) ~= nil and tonumber(dwRank) >= 1 and tonumber(dwRank) <= g_MaxJinJieLevel then
					strTemp = ScriptGlobal_Format("#{DWJJ_240329_316}", g_JinJieLevelStr[tonumber(dwRank)])
					SelfDWJinJie_DWTeXing_Title:SetText(strTemp)
					
					if tonumber(dwRank) == g_MaxJinJieLevel then
						strTemp =  "#{DWJJ_240329_177}"
						SelfDWJinJie_DWTeXing_NumLevel:SetText(strTemp)
					else
						local dwRankExp = DataPool:LuaFnGetEquipDiaoWenRankExp(equip_point)
						local dwRankMaxExp = DataPool:LuaFnGetDiaoWenRankMaxExp(tonumber(dwRank))
						strTemp = ScriptGlobal_Format("#{DWJJ_240329_317}", tostring(dwRankExp).."/"..tostring(dwRankMaxExp))
						SelfDWJinJie_DWTeXing_NumLevel:SetText(strTemp)
					end
					
					local dwJinJieEffectString = DataPool:LuaFnGetEquipDiaoWenJinJieEffect(equip_point)
					SelfDWJinJie_DWTeXing_ShuXing:SetText("#cfff263"..tostring(dwJinJieEffectString))
					
					local featureId = DataPool:LuaFnGetEquipDiaoWenFeaturesId(equip_point)
					if tonumber(featureId) ~= nil and tonumber(featureId) > 0 then

						local featuresName = DataPool:LuaFnGetFeaturesInfo(featureId, "Name")
						local featuresLevel = DataPool:LuaFnGetFeaturesInfo(featureId, "Level")
						local featuresExp = DataPool:LuaFnGetFeaturesInfo(featureId, "Exp")
						local maxExp, _, _ = LifeAbility:GetDiaowenJinJieTeXingShengJiRequiredCount(featuresLevel)
						local book_id = DataPool:LuaFnGetFeaturesInfo(featureId, "BookId")
						
						if book_id ~= 0 then							
							local featuresAction = EnumAction(featureId, "features")
							SelfDWJinJie_DWTeXing_DWItem:SetActionItem(featuresAction:GetID())
							
							strTemp = ScriptGlobal_Format("#{DWJJ_240329_319}", tostring(featuresName), tostring(featuresLevel))
							SelfDWJinJie_DWTeXing_Havelevel:SetText(strTemp)
							
							local validLevel = featuresLevel
							if tonumber(dwRank) ~= nil and tonumber(dwRank) > 0 then
								local limitLevel = math.floor(dwRank / 5)
								if limitLevel < validLevel then
									validLevel = limitLevel
								end
							end

							if validLevel == 0 then
								SelfDWJinJie_DWTeXing_Nowlevel:SetText("#{DWJJ_240329_349}")
								
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_359}", g_JinJieLevelStr[tonumber(dwRank)], tostring(featuresLevel))
								SelfDWJinJie_DWTeXing_Nowlevel:SetToolTip(strTemp)
							else
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_320}", tostring(validLevel))
								SelfDWJinJie_DWTeXing_Nowlevel:SetText(tostring(strTemp))
								
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_358}", g_JinJieLevelStr[tonumber(dwRank)], tostring(featuresLevel), tostring(validLevel))
								SelfDWJinJie_DWTeXing_Nowlevel:SetToolTip(strTemp)
							end

							if validLevel == 0 then
								SelfDWJinJie_DWTeXing_InfoText:SetText("#{DWJJ_240329_211}")
							else
								local strDesc = DataPool:LuaFnGetFeaturesDesc(featureId, validLevel)
								local dueValue =  equipAction:GetEquipDurValue()
								if dueValue > 0 then
									local strLimitDesc = DataPool:LuaFnGetFeaturesEffectLimitDesc(featureId)
									SelfDWJinJie_DWTeXing_InfoText:SetText("#cfff263"..tostring(strDesc).."#r"..tostring(strLimitDesc))
								else
									SelfDWJinJie_DWTeXing_InfoText:SetText("#cfff263"..tostring(strDesc).."#r#{DWJJ_240329_346}")
								end
							end
						else
							SelfDWJinJie_DWTeXing_Havelevel:SetText("#{DWJJ_240329_357}")
						end
					else
						SelfDWJinJie_DWTeXing_Havelevel:SetText("#{DWJJ_240329_357}")
					end
				else
					SelfDWJinJie_DWTeXing_Title:SetText("#{DWJJ_240329_321}")
				end
			else
				SelfDWJinJie_DWTeXing_DWLevel:SetText("#{DWJJ_240329_344}")
			end			
		end
	end
end

function SelfDWJinJie_UpdateEquipList()
	for i = 1, g_MaxDWEquip do
		local equip_point = g_EquipPointList[i]
		g_EquipActionButton[i]:SetActionItem(-1)
		g_EquipActionButtonMask[i]:Hide()

		local equipAction = EnumAction(equip_point, "equip")
		if equipAction:GetID() ~= 0 then
			g_EquipActionButton[i]:SetActionItem(equipAction:GetID())
			
			if equipAction:GetEquipDur() < 0.1 and equip_point ~= 17 then
				g_EquipActionButtonMask[i]:Show()
			end
		end
	end
	
	SelfDWJinJie_SelectEquip(g_CurSelEquipIndex)
end

function SelfDWJinJie_SelectEquip(idx)
	for i = 1, g_MaxDWEquip do
		g_EquipActionButton[i]:SetPushed(0)
		if g_CurSelEquipIndex == i then
			g_EquipActionButton[i]:SetPushed(1)
		end
	end
end

function SelfDWJinJie_UpdateFeaturesEffectList()
	g_FeaturesEffectListCtrl:ClearAllElement()
	local iMaxFeatures = DataPool:LuaFnGetFeaturesMaxCount()
	for i = 1, iMaxFeatures do
		local featureId = DataPool:LuaFnEnumFeaturesIdFromTable(i - 1)
		local num1, _ = DataPool:LuaFnGetEquipTotalFeaturesValue(featureId)
		if num1 > 0 then
			local featuresName = DataPool:LuaFnGetFeaturesInfo(featureId, "Name")
			local strEffect = DataPool:LuaFnGetEquipTotalValidFeaturesDesc(featureId)
			local strDesc = DataPool:LuaFnGetFeaturesEffectLimitDesc(featureId)
			
			if i == 1 then
				g_FeaturesEffectListCtrl:AddTextElement("#cff6600"..tostring(featuresName).."#r#cfff263"..tostring(strEffect).."#r"..tostring(strDesc))
			else
				g_FeaturesEffectListCtrl:AddTextElement("#r#cff6600"..tostring(featuresName).."#r#cfff263"..tostring(strEffect).."#r"..tostring(strDesc))
			end
		end
	end
end

function SelfDWJinJie_UpdateDWEffectList()
	g_DWEffectListCtrl:Clear()
	DataPool:LuaFnCalcEquipDWAttr(0)
	for i = 1, 64 do
		local val, attr_name, attr_val = DataPool:LuaFnGetEquipDWAttr(i - 1)
		if tonumber(val) ~= nil and tonumber(val) > 0 then
			local bar = g_DWEffectListCtrl:AddChild("SelfDWJinJie_DWTeXing_TopList_Item1")
			bar:GetSubItem("SelfDWJinJie_DWTeXing_TopList_Text_UnVisible"):SetText(tostring(attr_name))
			bar:GetSubItem("SelfDWJinJie_DWTeXing_TopList_UnVisible"):SetText(tostring(attr_val))
		end
	end
	
	local bHave, attr_name, attr_val = DataPool:LuaFnGetNecklaceDW(0)
	if tonumber(bHave) ~= nil and tonumber(bHave) == 1 then
		local bar = g_DWEffectListCtrl:AddChild("SelfDWJinJie_DWTeXing_TopList_Item1")
		bar:GetSubItem("SelfDWJinJie_DWTeXing_TopList_Text_UnVisible"):SetText(tostring(attr_name))
		bar:GetSubItem("SelfDWJinJie_DWTeXing_TopList_UnVisible"):SetText(tostring(attr_val))
	end
end

function SelfDWJinJie_EquipClicked(idx)
	if g_CurSelEquipIndex == idx then
		return
	end

	g_CurSelEquipIndex = idx
	SelfDWJinJie_SelectEquip(g_CurSelEquipIndex)
	SelfDWJinJie_Update_CurSelInfo()
end

function SelfDWJinJie_CleanUp()
	g_FeaturesEffectListCtrl:ClearAllElement()
	g_DWEffectListCtrl:Clear()
end

function SelfDWJinJie_CloseClicked()
	this:Hide()
end

function SelfDWJinJie_OnHidden()
	g_CurSelEquipIndex = 0
	SelfDWJinJie_CleanUp()
	CloseWindow("SelfDWJinJie_Packet", true)
end

function SelfDWJinJie_DWTeXingInfo_Clicked()
	if g_CurEquipFeatures > 0 then
		PushEvent("OPEN_SWEEPPAGE_QUEST", "DWJinJie_Help", g_CurEquipFeatures)
	end
end

function SelfDWJinJie_DWTeXing_OpenFeaturesBox()
	LuaFnOpenFeaturesBox()
end

--player's equip
function SelfDWJinJie_Page_SelfEquip()
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	OpenEquip(1)
end

--player's info
function SelfDWJinJie_Page_SelfData()
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("self")
end

--player's pet
function SelfDWJinJie_Page_Pet()
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePetPage()
end

function SelfDWJinJie_Page_Wuhun()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		SelfDWJinJie_Wuhun:SetCheck(0)
		SelfDWJinJie_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	ToggleWuhunPage()
end

--xiu lian
function SelfDWJinJie_Page_Xiulian()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		return
	end
	
    local nLevel = Player:GetData("LEVEL")
	if nLevel >= 70 then
		Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
		XiuLianPage()
	else
	    SelfDWJinJie_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    SelfDWJinJie_ClearPage()
	end
end

function SelfDWJinJie_Page_Talent()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
		ToggleTalentPage()
	else
		SelfDWJinJie_Talent:SetCheck(0)
		SelfDWJinJie_ClearPage()
	end
end

function SelfDWJinJie_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		SelfDWJinJie_Lingyu:SetCheck(0)
		SelfDWJinJie_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function SelfDWJinJie_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		SelfDWJinJie_Weapon2:SetCheck(0)
		SelfDWJinJie_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function SelfDWJinJie_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		SelfDWJinJie_DWJinJie:SetCheck(0)
		SelfDWJinJie_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

--切换个人牴示界面
function SelfDWJinJie_Page_Profile()
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1);
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

--player's other info
function SelfDWJinJie_Page_OtherInfo()
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	OtherInfoPage()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function SelfDWJinJie_Frame_On_ResetPos()
	SelfDWJinJie_Frame:SetProperty("UnifiedPosition", g_SelfDWJinJie_Frame_UnifiedPosition)
end

function SelfDWJinJie_ShowPage()
	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"))
	SelfDWJinJie_ClearPage()
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
		if SelfDWJinJie_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if SelfDWJinJie_IsPageEnable(i) == 1 then
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

function SelfDWJinJie_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1)
	idx = g_PageOrder[idx]
	if idx == 1 then--??
		SelfDWJinJie_Page_SelfEquip()
	elseif idx == 2 then--??
		SelfDWJinJie_Page_SelfData()
	elseif idx == 3 then--??
		SelfDWJinJie_Page_Pet()
	elseif idx == 4 then--??
		SelfDWJinJie_Page_Wuhun()
	elseif idx == 5 then--??
		SelfDWJinJie_Page_Xiulian()
	elseif idx == 6 then--??
		SelfDWJinJie_Page_Talent()
	elseif idx == 7 then--??
		SelfDWJinJie_Page_LingYu()
	elseif idx == 8 then--??
		SelfDWJinJie_Page_ShenBing()
	elseif idx == 9 then--????
	--	SelfDWJinJie_Page_DWJinJie()
	elseif idx == 10 then--??
		SelfDWJinJie_Page_Peak()
	elseif idx == 11 then--??
		SelfDWJinJie_Page_Profile()
	elseif idx == 12 then--??
		SelfDWJinJie_Page_OtherInfo()
	end
end

function SelfDWJinJie_CheckPage(idx)
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

function SelfDWJinJie_IsPageEnable(idx)
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

function SelfDWJinJie_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--更新分页红点
function SelfDWJinJie_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function SelfDWJinJie_IsEquipPointOpened(ep)
	for i = 1, table.getn(g_OpenEquipPointList) do
		if ep == g_OpenEquipPointList[i] then
			return 1
		end
	end
	return 0
end


function SelfDWJinJie_Page_Peak()
	Variable:SetVariable("SelfUnionPos", SelfDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end
