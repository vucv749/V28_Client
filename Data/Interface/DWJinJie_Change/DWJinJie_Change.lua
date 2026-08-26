--!!!reloadscript =DWJinJie_Change

local g_DWJinJie_Change_Frame_UnifiedPosition
local g_ObjServerId = -1

local g_InitList = 0
local g_MaxDWEquip = 16
--0.武器 1.帽子 2.衣服 3.手套 4.鞋 5.腰带 6.戒指 7.项链 11.戒指2 12.护符 13.护符2 14.护腕 15.护肩 17.暗器 18.武魂 37.神兵
local g_EquipPointList = {0, 37, 1, 15, 14, 3, 5, 4, 6, 11, 12, 13, 2, 7, 17, 18}
local g_OpenEquipPointList = {0, 2, 6, 11}
--local g_OpenEquipPointList = {0, 2, 6, 11, 7}
local g_MaxFeatures = 0

local g_FeaturesListCtrl

local g_FeaturesBarList = {}
local g_EffectBarList = {}

local g_FeaturesEffectListCtrl

local g_EquipActionButton = {}
local g_EquipActionButtonMask = {}
local g_EquipActionButtonMask2 = {}

local g_CurSelEquipIndex = 0
local g_CurSelPage = 0

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

function DWJinJie_Change_PreLoad()
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_YUANBAO")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("REFRESH_EQUIP")
	this:RegisterEvent("FEATURES_CHANGE")
end

function DWJinJie_Change_OnLoad()
	g_DWJinJie_Change_Frame_UnifiedPosition = DWJinJie_Change_Frame:GetProperty("UnifiedPosition")
	
	g_FeaturesListCtrl = DWJinJie_Change_DWTeXing_TopList2
	g_FeaturesEffectListCtrl = DWJinJie_Change_DWTeXing_TopList_Item1
	
	g_EquipActionButton[1] = DWJinJie_Change_EquipItem1
	g_EquipActionButton[2] = DWJinJie_Change_EquipItem2
	g_EquipActionButton[3] = DWJinJie_Change_EquipItem3
	g_EquipActionButton[4] = DWJinJie_Change_EquipItem4
	g_EquipActionButton[5] = DWJinJie_Change_EquipItem5
	g_EquipActionButton[6] = DWJinJie_Change_EquipItem6
	g_EquipActionButton[7] = DWJinJie_Change_EquipItem7
	g_EquipActionButton[8] = DWJinJie_Change_EquipItem8
	g_EquipActionButton[9] = DWJinJie_Change_EquipItem9
	g_EquipActionButton[10] = DWJinJie_Change_EquipItem10
	g_EquipActionButton[11] = DWJinJie_Change_EquipItem11
	g_EquipActionButton[12] = DWJinJie_Change_EquipItem12
	g_EquipActionButton[13] = DWJinJie_Change_EquipItem13
	g_EquipActionButton[14] = DWJinJie_Change_EquipItem14
	g_EquipActionButton[15] = DWJinJie_Change_EquipItem15
	g_EquipActionButton[16] = DWJinJie_Change_EquipItem16
	
	g_EquipActionButtonMask[1] = DWJinJie_Change_Mask1
	g_EquipActionButtonMask[2] = DWJinJie_Change_Mask2
	g_EquipActionButtonMask[3] = DWJinJie_Change_Mask3
	g_EquipActionButtonMask[4] = DWJinJie_Change_Mask4
	g_EquipActionButtonMask[5] = DWJinJie_Change_Mask5
	g_EquipActionButtonMask[6] = DWJinJie_Change_Mask6
	g_EquipActionButtonMask[7] = DWJinJie_Change_Mask7
	g_EquipActionButtonMask[8] = DWJinJie_Change_Mask8
	g_EquipActionButtonMask[9] = DWJinJie_Change_Mask9
	g_EquipActionButtonMask[10] = DWJinJie_Change_Mask10
	g_EquipActionButtonMask[11] = DWJinJie_Change_Mask11
	g_EquipActionButtonMask[12] = DWJinJie_Change_Mask12
	g_EquipActionButtonMask[13] = DWJinJie_Change_Mask13
	g_EquipActionButtonMask[14] = DWJinJie_Change_Mask14
	g_EquipActionButtonMask[15] = DWJinJie_Change_Mask15
	g_EquipActionButtonMask[16] = DWJinJie_Change_Mask16
	
	g_EquipActionButtonMask2[1] = DWJinJie_Change_Mask1_2
	g_EquipActionButtonMask2[2] = DWJinJie_Change_Mask2_2
	g_EquipActionButtonMask2[3] = DWJinJie_Change_Mask3_2
	g_EquipActionButtonMask2[4] = DWJinJie_Change_Mask4_2
	g_EquipActionButtonMask2[5] = DWJinJie_Change_Mask5_2
	g_EquipActionButtonMask2[6] = DWJinJie_Change_Mask6_2
	g_EquipActionButtonMask2[7] = DWJinJie_Change_Mask7_2
	g_EquipActionButtonMask2[8] = DWJinJie_Change_Mask8_2
	g_EquipActionButtonMask2[9] = DWJinJie_Change_Mask9_2
	g_EquipActionButtonMask2[10] = DWJinJie_Change_Mask10_2
	g_EquipActionButtonMask2[11] = DWJinJie_Change_Mask11_2
	g_EquipActionButtonMask2[12] = DWJinJie_Change_Mask12_2
	g_EquipActionButtonMask2[13] = DWJinJie_Change_Mask13_2
	g_EquipActionButtonMask2[14] = DWJinJie_Change_Mask14_2
	g_EquipActionButtonMask2[15] = DWJinJie_Change_Mask15_2
	g_EquipActionButtonMask2[16] = DWJinJie_Change_Mask16_2
end

function DWJinJie_Change_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 89030505 then
		if not this:IsVisible() then
			DWJinJie_Change_CleanUp()
			DWJinJie_Change_FirstSelect()
			this:Show()
			DWJinJie_Change_Update()
			DWJinJie_Change_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		DWJinJie_Change_Frame_On_ResetPos()
	end
	
	if event == "UPDATE_YUANBAO" and this:IsVisible() then
		local strYuanBao = ScriptGlobal_Format("#{ZQPM_240402_34}", tostring(Player:GetData("YUANBAO")))
	end
	
	if event == "REFRESH_EQUIP" and this:IsVisible() then
		DWJinJie_Change_Update()
		return
	end
	
	if event == "FEATURES_CHANGE" and this:IsVisible() then
		local featureId = tonumber(arg0)
		DWJinJie_Change_ChangeFeatures(1, featureId)
	end
	
end

function DWJinJie_Change_InitList()
	
	if g_InitList == 0 then
		g_MaxFeatures = DataPool:LuaFnGetFeaturesMaxCount()
		for i = 1, g_MaxFeatures do
			local bar = g_FeaturesListCtrl:AddChild("DWJinJie_Change_DWTeXing_TopListItem2")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_FeaturesBarList[i] = bar
		--	bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2Action"):SetProperty("Empty", "False")
		--	bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2Action"):SetProperty("UseDefaultTooltip", "True")
		--	bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2Action"):SetProperty("DraggingEnabled", "True")
		--	bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2Action"):SetProperty("DragAcceptName", "FP"..tostring(i))
			bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2Action"):SetEvent("MouseLClick", string.format("DWJinJie_Change_Features_LClicked(%d)", i))
		end

		g_InitList = 1
	end
end

function DWJinJie_Change_OnShown()
	
end

function DWJinJie_Change_FirstSelect()
	g_CurSelEquipIndex = 1
end

--Update
function DWJinJie_Change_Update()
	DWJinJie_Change_InitList()	
	DWJinJie_Change_CleanUp()
	
	DWJinJie_Change_Update_CurSelInfo()
	DWJinJie_Change_UpdateEquipList()
	DWJinJie_Change_UpdateFeaturesList()
	DWJinJie_Change_UpdateFeaturesEffectList()
	
	if g_CurSelPage == 1 then
		DWJinJie_Change_DWTeXingList1:Show()
		DWJinJie_Change_DWTeXingList2:Hide()
		DWJinJie_Change_DWTeXing_Page1:SetCheck(1)
		DWJinJie_Change_DWTeXing_Page2:SetCheck(0)
	else
		DWJinJie_Change_DWTeXingList1:Hide()
		DWJinJie_Change_DWTeXingList2:Show()
		DWJinJie_Change_DWTeXing_Page1:SetCheck(0)
		DWJinJie_Change_DWTeXing_Page2:SetCheck(1)
	end
end

function DWJinJie_Change_Update_CurSelInfo()
	DWJinJie_Change_EquipItem:SetActionItem(-1)
	DWJinJie_Change_EquipItemMask:Hide()
	
	DWJinJie_Change_DWLevel:SetText("")
	DWJinJie_Change_DWLevelUp:SetText("")
	DWJinJie_Change_DWLevelUpNum:SetText("")
	DWJinJie_Change_DWShuXingUp:SetText("")
	
	DWJinJie_Change_DWItem:SetActionItem(-1)
	DWJinJie_Change_DWItemMask:Hide()
	
	DWJinJie_Change_Title:SetText("")
	DWJinJie_Change_ShuXing:SetText("")
	DWJinJie_Change_NumLevel:SetText("")
	
	DWJinJie_Change_Havelevel:SetText("")
	DWJinJie_Change_Nowlevel:SetText("")
	DWJinJie_Change_InfoText:SetText("")
	
	DWJinJie_Change_Nowlevel:SetToolTip("")
	
	local strTemp = ""
	if g_CurSelEquipIndex >= 1 and g_CurSelEquipIndex <= g_MaxDWEquip then
		local equip_point = g_EquipPointList[g_CurSelEquipIndex]
		local equipAction = EnumAction(equip_point, "equip")
		if equipAction:GetID() ~= 0 then
			DWJinJie_Change_EquipItem:SetActionItem(equipAction:GetID())
			
			local broken = 0
			if equipAction:GetEquipDur() < 0.1 and equip_point ~= 17 then
				DWJinJie_Change_EquipItemMask:Show()
				broken = 1
			end
			
			local dwId, dwLevel = DataPool:LuaFnGetEquipDiaowenInfo(equip_point)
			local dwRank = DataPool:LuaFnGetEquipDiaoWenRank(equip_point)
			if tonumber(dwId) ~= nil and tonumber(dwId) > 0 then
				local dwName = DataPool:LuaFnGetDiaoWenName(tonumber(dwId))
				DWJinJie_Change_DWLevel:SetText("#cfff263"..tostring(dwName))
				
				local dwExp, dwMaxExp = DataPool:LuaFnGetEquipDiaowenExp(equip_point)
				if tonumber(dwExp) ~= nil and tonumber(dwMaxExp) ~= nil then
					if tonumber(dwMaxExp) < 0 then
						DWJinJie_Change_DWLevelUp:SetText("#{DWJJ_240329_318}")
						DWJinJie_Change_DWLevelUpNum:SetText("#{DWJJ_240329_322}")
					else
						DWJinJie_Change_DWLevelUp:SetText("#{DWJJ_240329_318}")
						DWJinJie_Change_DWLevelUpNum:SetText("#cfff263"..tostring(dwExp).."/"..tostring(dwMaxExp))
					end
				end
				
				local dwEffectString = DataPool:LuaFnGetEquipDiaoWenEffect(equip_point)
				DWJinJie_Change_DWShuXingUp:SetText("#cfff263"..tostring(dwEffectString))
				
				if tonumber(dwRank) ~= nil and tonumber(dwRank) >= 1 and tonumber(dwRank) <= g_MaxJinJieLevel then
					strTemp = ScriptGlobal_Format("#{DWJJ_240329_316}", g_JinJieLevelStr[tonumber(dwRank)])
					DWJinJie_Change_Title:SetText(strTemp)
					
					if tonumber(dwRank) == g_MaxJinJieLevel then
						strTemp =  "#{DWJJ_240329_177}"
						DWJinJie_Change_NumLevel:SetText(strTemp)
					else
						local dwRankExp = DataPool:LuaFnGetEquipDiaoWenRankExp(equip_point)
						local dwRankMaxExp = DataPool:LuaFnGetDiaoWenRankMaxExp(tonumber(dwRank))
						strTemp = ScriptGlobal_Format("#{DWJJ_240329_317}", tostring(dwRankExp).."/"..tostring(dwRankMaxExp))
						DWJinJie_Change_NumLevel:SetText(strTemp)
					end
					
					local dwJinJieEffectString = DataPool:LuaFnGetEquipDiaoWenJinJieEffect(equip_point)
					DWJinJie_Change_ShuXing:SetText("#cfff263"..tostring(dwJinJieEffectString))
					
					local featureId = DataPool:LuaFnGetEquipDiaoWenFeaturesId(equip_point)
					if tonumber(featureId) ~= nil and tonumber(featureId) > 0 then
						local featuresName = DataPool:LuaFnGetFeaturesInfo(featureId, "Name")
						local featuresLevel = DataPool:LuaFnGetFeaturesInfo(featureId, "Level")
						local featuresExp = DataPool:LuaFnGetFeaturesInfo(featureId, "Exp")
						local maxExp, _, _ = LifeAbility:GetDiaowenJinJieTeXingShengJiRequiredCount(featuresLevel)
						local book_id = DataPool:LuaFnGetFeaturesInfo(featureId, "BookId")
						
						if book_id ~= 0 then
							local featuresAction = EnumAction(featureId, "features")
							DWJinJie_Change_DWItem:SetActionItem(featuresAction:GetID())
						
							strTemp = ScriptGlobal_Format("#{DWJJ_240329_319}", tostring(featuresName), tostring(featuresLevel))
							DWJinJie_Change_Havelevel:SetText(strTemp)

							local validLevel = featuresLevel
							if tonumber(dwRank) ~= nil and tonumber(dwRank) > 0 then
								local limitLevel = math.floor(dwRank / 5)
								if limitLevel < validLevel then
									validLevel = limitLevel
								end
							end
							
							if validLevel == 0 then
								DWJinJie_Change_Nowlevel:SetText("#{DWJJ_240329_349}")
								
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_359}", g_JinJieLevelStr[tonumber(dwRank)], tostring(featuresLevel))
								DWJinJie_Change_Nowlevel:SetToolTip(strTemp)
							else
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_320}", tostring(validLevel))
								DWJinJie_Change_Nowlevel:SetText(tostring(strTemp))
								
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_358}", g_JinJieLevelStr[tonumber(dwRank)], tostring(featuresLevel), tostring(validLevel))
								DWJinJie_Change_Nowlevel:SetToolTip(strTemp)
							end

							if validLevel == 0 then
								DWJinJie_Change_InfoText:SetText("#{DWJJ_240329_211}")
							else
								local strDesc = DataPool:LuaFnGetFeaturesDesc(featureId, validLevel)
								local dueValue =  equipAction:GetEquipDurValue()
								if dueValue > 0 then
									local strLimitDesc = DataPool:LuaFnGetFeaturesEffectLimitDesc(featureId)
									DWJinJie_Change_InfoText:SetText("#cfff263"..tostring(strDesc).."#r"..tostring(strLimitDesc))
								else
									DWJinJie_Change_InfoText:SetText("#cfff263"..tostring(strDesc).."#r#{DWJJ_240329_346}")
								end
							end
						else
							DWJinJie_Change_Havelevel:SetText("#{DWJJ_240329_357}")
						end
					else
						DWJinJie_Change_Havelevel:SetText("#{DWJJ_240329_357}")
					end
				else
					DWJinJie_Change_Title:SetText("#{DWJJ_240329_321}")
				end
			else
				DWJinJie_Change_DWLevel:SetText("#{DWJJ_240329_344}")
			end
		end
	end
end

function DWJinJie_Change_UpdateEquipList()
	for i = 1, g_MaxDWEquip do
		local equip_point = g_EquipPointList[i]
		g_EquipActionButton[i]:SetActionItem(-1)
		g_EquipActionButtonMask[i]:Hide()
		g_EquipActionButtonMask2[i]:Hide()
		
		local equipAction = EnumAction(equip_point, "equip")
		if equipAction:GetID() ~= 0 then
			g_EquipActionButton[i]:SetActionItem(equipAction:GetID())
			
			if equipAction:GetEquipDur() < 0.1 and equip_point ~= 17 then
				g_EquipActionButtonMask[i]:Show()
			end
				
			if DWJinJie_Change_IsEquipPointOpened(equip_point) == 1 then
				
			else
			--	g_EquipActionButtonMask2[i]:Show()
			end
		end
	end
	
	DWJinJie_Change_SelectEquip(g_CurSelEquipIndex)
end

function DWJinJie_Change_SelectEquip(idx)
	for i = 1, g_MaxDWEquip do
		g_EquipActionButton[i]:SetPushed(0)
		if g_CurSelEquipIndex == i then
			g_EquipActionButton[i]:SetPushed(1)
		end
	end
end

function DWJinJie_Change_UpdateFeaturesList()

	DataPool:LuaFnInitFeaturesList(0)
	local list_count = DataPool:LuaFnGetFeaturesListCount()
	for i = 1, g_MaxFeatures do
		if g_FeaturesBarList[i] ~= nil then
			local bar = g_FeaturesBarList[i]
			
			if i > list_count then
				bar:Hide()
				continue
			end
			
			bar:Show()
			local featuresActionBtn = bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2Action")
			
			local featureId = DataPool:LuaFnEnumFeaturesID(i - 1)
			
			if featuresActionBtn ~= nil then
				featuresActionBtn:SetActionItem(-1)
				local featuresAction = EnumAction(featureId, "features")
				featuresActionBtn:SetActionItem(featuresAction:GetID())
				
				local featuresLevel = DataPool:LuaFnGetFeaturesInfo(featureId, "Level")
				--bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2ActionLevel"):SetText(tostring(featuresLevel))
				
				if tonumber(featuresLevel) ~= nil and featuresLevel > 0 then
				--	featuresActionBtn:SetProperty("DraggingEnabled", "True")
					bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2_Mask"):Hide()
				else
				--	featuresActionBtn:SetProperty("DraggingEnabled", "False")
					bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2_Mask"):Show()
				end
			end
			
			local featuresName = DataPool:LuaFnGetFeaturesInfo(featureId, "Name")
			bar:GetSubItem("DWJinJie_Change_DWTeXing_TopListItem2ActionName"):SetText("#cfff263"..tostring(featuresName))
		end
	end
	
	g_FeaturesListCtrl:RefreshLayout()
end

function DWJinJie_Change_UpdateFeaturesEffectList()
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

function DWJinJie_Change_EquipClicked(idx)
	if g_CurSelEquipIndex == idx then
		return
	end
	
	local equip_point = g_EquipPointList[idx]
	if DWJinJie_Change_IsEquipPointOpened(equip_point) ~= 1 then
	--	return
	end
	
	g_CurSelEquipIndex = idx
	DWJinJie_Change_SelectEquip(g_CurSelEquipIndex)
	DWJinJie_Change_Update_CurSelInfo()
end

function DWJinJie_Change_RemoveFeatures()
	if g_CurSelEquipIndex >= 1 and g_CurSelEquipIndex <= g_MaxDWEquip then
		local equipAction = EnumAction(g_EquipPointList[g_CurSelEquipIndex], "equip")
		if equipAction:GetID() ~= 0 then
			local featureId = DataPool:LuaFnGetEquipDiaoWenFeaturesId(g_EquipPointList[g_CurSelEquipIndex])
			if tonumber(featureId) ~= nil and tonumber(featureId) > 0 then
				Clear_XSCRIPT()
					Set_XSCRIPT_ScriptID(809272)
					Set_XSCRIPT_Function_Name("DoDiaowenJinJieTeXingGengHuan")
					Set_XSCRIPT_Parameter(0, g_ObjServerId)
					Set_XSCRIPT_Parameter(1, g_EquipPointList[g_CurSelEquipIndex])
					Set_XSCRIPT_Parameter(2, featureId)
					Set_XSCRIPT_Parameter(3, 0)
					Set_XSCRIPT_ParamCount(4)
				Send_XSCRIPT()
			end
		end
	end
end

function DWJinJie_Change_SwitchInfo(idx)
	if g_CurSelPage ~= idx then
		g_CurSelPage = idx
		if g_CurSelPage == 1 then
			DWJinJie_Change_DWTeXingList1:Show()
			DWJinJie_Change_DWTeXingList2:Hide()
		else
			DWJinJie_Change_DWTeXingList1:Hide()
			DWJinJie_Change_DWTeXingList2:Show()
		end
	end
end

function DWJinJie_Change_CleanUp()
	g_FeaturesEffectListCtrl:ClearAllElement()
end

function DWJinJie_Change_CloseClicked()
	this:Hide()
end

function DWJinJie_Change_OnHidden()
	DWJinJie_Change_CleanUp()
	g_ObjServerId = -1
end

function DWJinJie_Change_DWTeXingInfo_Clicked()
	PushEvent("OPEN_SWEEPPAGE_QUEST", "DWJinJie_Help")
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function DWJinJie_Change_Frame_On_ResetPos()
	DWJinJie_Change_Frame:SetProperty("UnifiedPosition", g_DWJinJie_Change_Frame_UnifiedPosition)
end

--Care Obj
function DWJinJie_Change_BeginCareObj(obj_id)	
	g_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function DWJinJie_Change_ChangeFeatures(changeType, featureId)
	if tonumber(featureId) == nil then
		return
	end
	
	if g_CurSelEquipIndex >= 1 and g_CurSelEquipIndex <= g_MaxDWEquip then
		local equip_point = g_EquipPointList[g_CurSelEquipIndex]
		if DWJinJie_Change_IsEquipPointOpened(equip_point) ~= 1 then
		--	return
		end
		
		if changeType == 1 then
			local equipAction = EnumAction(equip_point, "equip")
			if equipAction:GetID() ~= 0 then
				Clear_XSCRIPT()
					Set_XSCRIPT_ScriptID(809272)
					Set_XSCRIPT_Function_Name("DoDiaowenJinJieTeXingGengHuan")
					Set_XSCRIPT_Parameter(0, g_ObjServerId)
					Set_XSCRIPT_Parameter(1, equip_point)
					Set_XSCRIPT_Parameter(2, featureId)
					Set_XSCRIPT_Parameter(3, 1)
					Set_XSCRIPT_ParamCount(4)
				Send_XSCRIPT()
			end
		else
		
		end
	end
end

function DWJinJie_Change_Features_LClicked(idx)
	local featureId = DataPool:LuaFnEnumFeaturesID(idx - 1)
	
	local featuresLevel = DataPool:LuaFnGetFeaturesInfo(featureId, "Level")
	
	if tonumber(featuresLevel) ~= nil and featuresLevel > 0 then
		if g_CurSelEquipIndex >= 1 and g_CurSelEquipIndex <= g_MaxDWEquip then
			local equip_point = g_EquipPointList[g_CurSelEquipIndex]
			if DWJinJie_Change_IsEquipPointOpened(equip_point) ~= 1 then
			--	return
			end
			
			local equipAction = EnumAction(equip_point, "equip")
			if equipAction:GetID() ~= 0 then
				Clear_XSCRIPT()
					Set_XSCRIPT_ScriptID(809272)
					Set_XSCRIPT_Function_Name("DoDiaowenJinJieTeXingGengHuan")
					Set_XSCRIPT_Parameter(0, g_ObjServerId)
					Set_XSCRIPT_Parameter(1, equip_point)
					Set_XSCRIPT_Parameter(2, featureId)
					Set_XSCRIPT_Parameter(3, 1)
					Set_XSCRIPT_ParamCount(4)
				Send_XSCRIPT()
			end
		end
	end
end

function DWJinJie_Change_IsEquipPointOpened(ep)
	for i = 1, table.getn(g_OpenEquipPointList) do
		if ep == g_OpenEquipPointList[i] then
			return 1
		end
	end
	return 0
end
