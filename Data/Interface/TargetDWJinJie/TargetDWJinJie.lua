--!!!reloadscript =TargetDWJinJie
local g_TargetDWJinJie_Frame_UnifiedPosition

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

function TargetDWJinJie_PreLoad()
	this:RegisterEvent("TOGGLE_OTHER_FEATURES_PAGE")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_YUANBAO")
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP")
end

function TargetDWJinJie_OnLoad()
	g_TargetDWJinJie_Frame_UnifiedPosition = TargetDWJinJie_Frame:GetProperty("UnifiedPosition")
	
	g_PageButtons[1] = TargetDWJinJie_Page1_Sift1
	g_PageButtons[2] = TargetDWJinJie_Page1_Sift2
	g_PageButtons[3] = TargetDWJinJie_Page1_Sift3
	g_PageButtons[4] = TargetDWJinJie_Page1_Sift4
	g_PageButtons[5] = TargetDWJinJie_Page1_Sift5
	
	g_DWEffectListCtrl = TargetDWJinJie_DWTeXing_TopList1
	g_FeaturesEffectListCtrl = TargetDWJinJie_DWTeXing_TopListItem2
	
	g_EquipActionButton[1] = TargetDWJinJie_EquipItem1
	g_EquipActionButton[2] = TargetDWJinJie_EquipItem2
	g_EquipActionButton[3] = TargetDWJinJie_EquipItem3
	g_EquipActionButton[4] = TargetDWJinJie_EquipItem4
	g_EquipActionButton[5] = TargetDWJinJie_EquipItem5
	g_EquipActionButton[6] = TargetDWJinJie_EquipItem6
	g_EquipActionButton[7] = TargetDWJinJie_EquipItem7
	g_EquipActionButton[8] = TargetDWJinJie_EquipItem8
	g_EquipActionButton[9] = TargetDWJinJie_EquipItem9
	g_EquipActionButton[10] = TargetDWJinJie_EquipItem10
	g_EquipActionButton[11] = TargetDWJinJie_EquipItem11
	g_EquipActionButton[12] = TargetDWJinJie_EquipItem12
	g_EquipActionButton[13] = TargetDWJinJie_EquipItem13
	g_EquipActionButton[14] = TargetDWJinJie_EquipItem14
	g_EquipActionButton[15] = TargetDWJinJie_EquipItem15
	g_EquipActionButton[16] = TargetDWJinJie_EquipItem16
	
	g_EquipActionButtonMask[1] = TargetDWJinJie_Mask1
	g_EquipActionButtonMask[2] = TargetDWJinJie_Mask2
	g_EquipActionButtonMask[3] = TargetDWJinJie_Mask3
	g_EquipActionButtonMask[4] = TargetDWJinJie_Mask4
	g_EquipActionButtonMask[5] = TargetDWJinJie_Mask5
	g_EquipActionButtonMask[6] = TargetDWJinJie_Mask6
	g_EquipActionButtonMask[7] = TargetDWJinJie_Mask7
	g_EquipActionButtonMask[8] = TargetDWJinJie_Mask8
	g_EquipActionButtonMask[9] = TargetDWJinJie_Mask9
	g_EquipActionButtonMask[10] = TargetDWJinJie_Mask10
	g_EquipActionButtonMask[11] = TargetDWJinJie_Mask11
	g_EquipActionButtonMask[12] = TargetDWJinJie_Mask12
	g_EquipActionButtonMask[13] = TargetDWJinJie_Mask13
	g_EquipActionButtonMask[14] = TargetDWJinJie_Mask14
	g_EquipActionButtonMask[15] = TargetDWJinJie_Mask15
	g_EquipActionButtonMask[16] = TargetDWJinJie_Mask16
end

function TargetDWJinJie_OnEvent(event)
	
	if event == "TOGGLE_OTHER_FEATURES_PAGE" then
		if this:IsVisible() then
			this:Hide()
			return
		end
	
		if not CachedTarget:IsPresent(1) then
			return
		end

		if not ZBS:IsCanGetTargetEquip() then
			return
		end

		if not CachedTarget:CanGetTargetEquip() then
			PushDebugMessage("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		
		local objCared = CachedTarget:GetData("NPCID", 1)
		if type(objCared) ~= "number" then
			PushDebugMessage ("#{JSCK_90507_1}")			-- 距离该玩家太远，无法查看资料。
			return
		end
		
		this:CareObject(objCared , 1)
		TargetDWJinJie_OnShown()
		TargetDWJinJie_FirstSelect()
		TargetDWJinJie_Update()
		this:Show()
	end	
	
	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		TargetDWJinJie_Frame_On_ResetPos()
	end
	
	if event == "UPDATE_YUANBAO" and this:IsVisible() then
		local strYuanBao = ScriptGlobal_Format("#{ZQPM_240402_34}", tostring(Player:GetData("YUANBAO")))
	end
	
	if event == "OTHERPLAYER_UPDATE_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
		TargetDWJinJie_Update()
	end
	
end

function TargetDWJinJie_InitList()
	if g_InitList == 0 then
		g_InitList = 1
	end
end

function TargetDWJinJie_OnShown()
	local otherUnionPos = Variable:GetVariable("OtherUnionPos")
	if otherUnionPos ~= nil then
		TargetDWJinJie_Frame:SetProperty("UnifiedPosition", otherUnionPos)
	end
end

function TargetDWJinJie_FirstSelect()
	g_CurSelEquipIndex = 1
end
--Update
function TargetDWJinJie_Update()
	--Tab
	TargetDWJinJie_TargetDWJinJie:SetCheck(1)
	
	TargetDWJinJie_InitList()	
	TargetDWJinJie_CleanUp()
	
	TargetDWJinJie_Update_CurSelInfo()
	TargetDWJinJie_UpdateEquipList()
	TargetDWJinJie_UpdateFeaturesEffectList()
	TargetDWJinJie_UpdateDWEffectList()
end

function TargetDWJinJie_Update_CurSelInfo()
	TargetDWJinJie_DWTeXing_EquipItem:SetActionItem(-1)
	TargetDWJinJie_DWTeXing_EquipItemMask:Hide()
	
	TargetDWJinJie_DWTeXing_DWLevel:SetText("")
	TargetDWJinJie_DWTeXing_DWLevelUp:SetText("")
	TargetDWJinJie_DWTeXing_DWLevelUpNum:SetText("")
	TargetDWJinJie_DWTeXing_DWShuXingUp:SetText("")
	
	TargetDWJinJie_DWTeXing_DWItem:SetActionItem(-1)
	TargetDWJinJie_DWTeXing_DWItemMask:Hide()
	
	TargetDWJinJie_DWTeXing_Title:SetText("")
	TargetDWJinJie_DWTeXing_ShuXing:SetText("")
	TargetDWJinJie_DWTeXing_NumLevel:SetText("")
	
	TargetDWJinJie_DWTeXing_Havelevel:SetText("")
	TargetDWJinJie_DWTeXing_Nowlevel:SetText("")
	TargetDWJinJie_DWTeXing_InfoText:SetText("")
	
	TargetDWJinJie_DWTeXing_Nowlevel:SetToolTip("")
	
	local strTemp = ""

	if g_CurSelEquipIndex >= 1 and g_CurSelEquipIndex <= g_MaxDWEquip then
		local equip_point = g_EquipPointList[g_CurSelEquipIndex]
		local equipAction = EnumAction(equip_point, "targetequip")
		if equipAction:GetID() ~= 0 then
			TargetDWJinJie_DWTeXing_EquipItem:SetActionItem(equipAction:GetID())
			
			local broken = 0
			if equipAction:GetEquipDur() < 0.1 and equip_point ~= 17 then
				TargetDWJinJie_DWTeXing_EquipItemMask:Show()
				broken = 1
			end
			
			local dwId, dwLevel = DataPool:LuaFnGetOtherEquipDiaowenInfo(equip_point)
			local dwRank = DataPool:LuaFnGetOtherEquipDiaoWenRank(equip_point)
			if tonumber(dwId) ~= nil and tonumber(dwId) > 0 then			
				local dwName = DataPool:LuaFnGetDiaoWenName(tonumber(dwId))
				TargetDWJinJie_DWTeXing_DWLevel:SetText("#cfff263"..tostring(dwName))
				
				local dwExp, dwMaxExp = DataPool:LuaFnGetOtherEquipDiaowenExp(equip_point)
				if tonumber(dwExp) ~= nil and tonumber(dwMaxExp) ~= nil then
					if tonumber(dwMaxExp) < 0 then
						TargetDWJinJie_DWTeXing_DWLevelUp:SetText("#{DWJJ_240329_318}")
						TargetDWJinJie_DWTeXing_DWLevelUpNum:SetText("#{DWJJ_240329_322}")
					else
						TargetDWJinJie_DWTeXing_DWLevelUp:SetText("#{DWJJ_240329_318}")
						TargetDWJinJie_DWTeXing_DWLevelUpNum:SetText("#cfff263"..tostring(dwExp).."/"..tostring(dwMaxExp))
					end
				end
				
				local dwEffectString = DataPool:LuaFnGetOtherEquipDiaoWenEffect(equip_point)
				TargetDWJinJie_DWTeXing_DWShuXingUp:SetText("#cfff263"..tostring(dwEffectString))
				
				if tonumber(dwRank) ~= nil and tonumber(dwRank) >= 1 and tonumber(dwRank) <= g_MaxJinJieLevel then
					strTemp = ScriptGlobal_Format("#{DWJJ_240329_316}", g_JinJieLevelStr[tonumber(dwRank)])
					TargetDWJinJie_DWTeXing_Title:SetText(strTemp)
					
					if tonumber(dwRank) == g_MaxJinJieLevel then
						strTemp =  "#{DWJJ_240329_177}"
						TargetDWJinJie_DWTeXing_NumLevel:SetText(strTemp)
					else
						local dwRankExp = DataPool:LuaFnGetOtherEquipDiaoWenRankExp(equip_point)
						local dwRankMaxExp = DataPool:LuaFnGetDiaoWenRankMaxExp(tonumber(dwRank))
						strTemp = ScriptGlobal_Format("#{DWJJ_240329_317}", tostring(dwRankExp).."/"..tostring(dwRankMaxExp))
						TargetDWJinJie_DWTeXing_NumLevel:SetText(strTemp)
					end
					
					local dwJinJieEffectString = DataPool:LuaFnGetOtherEquipDiaoWenJinJieEffect(equip_point)
					TargetDWJinJie_DWTeXing_ShuXing:SetText("#cfff263"..tostring(dwJinJieEffectString))
					
					local featureId = DataPool:LuaFnGetOtherEquipDiaoWenFeaturesId(equip_point)
					if tonumber(featureId) ~= nil and tonumber(featureId) > 0 then

						local featuresName = DataPool:LuaFnGetOtherFeaturesInfo(featureId, "Name")
						local featuresLevel = DataPool:LuaFnGetOtherFeaturesInfo(featureId, "Level")
						local featuresExp = DataPool:LuaFnGetOtherFeaturesInfo(featureId, "Exp")
						local maxExp, _, _ = LifeAbility:GetDiaowenJinJieTeXingShengJiRequiredCount(featuresLevel)
						local book_id = DataPool:LuaFnGetOtherFeaturesInfo(featureId, "BookId")
						
						if book_id ~= 0 then
							local featuresAction = EnumAction(featureId, "other_features")
							TargetDWJinJie_DWTeXing_DWItem:SetActionItem(featuresAction:GetID())
						
							strTemp = ScriptGlobal_Format("#{DWJJ_240329_319}", tostring(featuresName), tostring(featuresLevel))
							TargetDWJinJie_DWTeXing_Havelevel:SetText(strTemp)
							
							local validLevel = featuresLevel
							if tonumber(dwRank) ~= nil and tonumber(dwRank) > 0 then
								local limitLevel = math.floor(dwRank / 5)
								if limitLevel < validLevel then
									validLevel = limitLevel
								end
							end
							
							if validLevel == 0 then
								TargetDWJinJie_DWTeXing_Nowlevel:SetText("#{DWJJ_240329_349}")
								
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_359}", g_JinJieLevelStr[tonumber(dwRank)], tostring(featuresLevel))
								TargetDWJinJie_DWTeXing_Nowlevel:SetToolTip(strTemp)
							else
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_320}", tostring(validLevel))
								TargetDWJinJie_DWTeXing_Nowlevel:SetText(tostring(strTemp))
								
								strTemp = ScriptGlobal_Format("#{DWJJ_240329_358}", g_JinJieLevelStr[tonumber(dwRank)], tostring(featuresLevel), tostring(validLevel))
								TargetDWJinJie_DWTeXing_Nowlevel:SetToolTip(strTemp)
							end
							
							if validLevel == 0 then
								TargetDWJinJie_DWTeXing_InfoText:SetText("#{DWJJ_240329_211}")
							else
								local strDesc = DataPool:LuaFnGetFeaturesDesc(featureId, validLevel)
								local dueValue =  equipAction:GetEquipDurValue()
								if dueValue > 0 then
									local strLimitDesc = DataPool:LuaFnGetOtherFeaturesEffectLimitDesc(featureId)
									TargetDWJinJie_DWTeXing_InfoText:SetText("#cfff263"..tostring(strDesc).."#r"..tostring(strLimitDesc))
								else
									TargetDWJinJie_DWTeXing_InfoText:SetText("#cfff263"..tostring(strDesc).."#r#{DWJJ_240329_346}")
								end
							end
						else
							TargetDWJinJie_DWTeXing_Havelevel:SetText("#{DWJJ_240329_357}")
						end
					else
						TargetDWJinJie_DWTeXing_Havelevel:SetText("#{DWJJ_240329_357}")
					end
				else
					TargetDWJinJie_DWTeXing_Title:SetText("#{DWJJ_240329_321}")
				end
			else
				TargetDWJinJie_DWTeXing_DWLevel:SetText("#{DWJJ_240329_344}")
			end
		end
	end
end

function TargetDWJinJie_UpdateEquipList()
	for i = 1, g_MaxDWEquip do
		local equip_point = g_EquipPointList[i]
		g_EquipActionButton[i]:SetActionItem(-1)
		g_EquipActionButtonMask[i]:Hide()
		
		local equipAction = EnumAction(equip_point, "targetequip")
		if equipAction:GetID() ~= 0 then
			g_EquipActionButton[i]:SetActionItem(equipAction:GetID())
				
			if equipAction:GetEquipDur() < 0.1 and equip_point ~= 17 then
				g_EquipActionButtonMask[i]:Show()
			end
		end
	end
	
	TargetDWJinJie_SelectEquip(g_CurSelEquipIndex)
end

function TargetDWJinJie_SelectEquip(idx)
	for i = 1, g_MaxDWEquip do
		g_EquipActionButton[i]:SetPushed(0)
		if g_CurSelEquipIndex == i then
			g_EquipActionButton[i]:SetPushed(1)
		end
	end
end

function TargetDWJinJie_UpdateFeaturesEffectList()
	g_FeaturesEffectListCtrl:ClearAllElement()
	local iMaxFeatures = DataPool:LuaFnGetFeaturesMaxCount()
	for i = 1, iMaxFeatures do
		local featureId = DataPool:LuaFnEnumFeaturesIdFromTable(i - 1)
		local num1, _ = DataPool:LuaFnGetOtherEquipTotalFeaturesValue(featureId)
		if num1 > 0 then
			local featuresName = DataPool:LuaFnGetFeaturesInfo(featureId, "Name")
			local strEffect = DataPool:LuaFnGetOtherEquipTotalValidFeaturesDesc(featureId)
			local strDesc = DataPool:LuaFnGetOtherFeaturesEffectLimitDesc(featureId)
			
			if i == 1 then
				g_FeaturesEffectListCtrl:AddTextElement("#cff6600"..tostring(featuresName).."#r#cfff263"..tostring(strEffect).."#r"..tostring(strDesc))
			else
				g_FeaturesEffectListCtrl:AddTextElement("#r#cff6600"..tostring(featuresName).."#r#cfff263"..tostring(strEffect).."#r"..tostring(strDesc))
			end
		end
	end
end

function TargetDWJinJie_UpdateDWEffectList()
	g_DWEffectListCtrl:Clear()
	DataPool:LuaFnCalcEquipDWAttr(1)
	for i = 1, 64 do
		local val, attr_name, attr_val = DataPool:LuaFnGetEquipDWAttr(i - 1)
		if tonumber(val) ~= nil and tonumber(val) > 0 then
			local bar = g_DWEffectListCtrl:AddChild("TargetDWJinJie_DWTeXing_TopList_Item1")
			bar:GetSubItem("TargetDWJinJie_DWTeXing_TopList_Text_UnVisible"):SetText(tostring(attr_name))
			bar:GetSubItem("TargetDWJinJie_DWTeXing_TopList_UnVisible"):SetText(tostring(attr_val))
		end
	end
	
	local bHave, attr_name, attr_val = DataPool:LuaFnGetNecklaceDW(1)
	if tonumber(bHave) ~= nil and tonumber(bHave) == 1 then
		local bar = g_DWEffectListCtrl:AddChild("TargetDWJinJie_DWTeXing_TopList_Item1")
		bar:GetSubItem("TargetDWJinJie_DWTeXing_TopList_Text_UnVisible"):SetText(tostring(attr_name))
		bar:GetSubItem("TargetDWJinJie_DWTeXing_TopList_UnVisible"):SetText(tostring(attr_val))
	end
end

function TargetDWJinJie_EquipClicked(idx)
	if g_CurSelEquipIndex == idx then
		return
	end

	g_CurSelEquipIndex = idx
	TargetDWJinJie_SelectEquip(g_CurSelEquipIndex)
	TargetDWJinJie_Update_CurSelInfo()
end

function TargetDWJinJie_CleanUp()
	g_FeaturesEffectListCtrl:ClearAllElement()
	g_DWEffectListCtrl:Clear()
end

function TargetDWJinJie_CloseClicked()
	this:Hide()
end

function TargetDWJinJie_OnHidden()
	g_CurSelEquipIndex = 0
	TargetDWJinJie_CleanUp()
end

function TargetDWJinJie_DWTeXingInfo_Clicked()
	if g_CurEquipFeatures > 0 then
		PushEvent("OPEN_SWEEPPAGE_QUEST", "DWJinJie_Help", g_CurEquipFeatures)
	end
end

-- 打开玩家装备UI
function TargetDWJinJie_TargetEquip_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(1), 1)
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenEquipFrame("other")
end

-- 打开玩家信息界面
function TargetDWJinJie_TargetData_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(2), 1)
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("other")
end

-- 打开玩家宠物UI
function TargetDWJinJie_OtherPet_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(3), 1)
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPetFrame("other")
end

function TargetDWJinJie_TargetWuhun_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(4), 1)
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		TargetDWJinJie_TargetWuhun:SetCheck(0)
		return
	end
	
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherWuhun()
end

function TargetDWJinJie_TargetLingyu_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(5), 1)
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
end

function TargetDWJinJie_ShenBing_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(6), 1)
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function TargetDWJinJie_DWJinJie_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(7), 1)
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end
function TargetDWJinJie_TargetPeak_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(8), 1)
	-- if ZBS:IsZBSFinalDFengBanFlag() == 1 then
		-- PushDebugMessage("#{WCBZ_250812_1}")
	    -- return 0
	-- end
	local lv = CachedTarget:GetData("LEVEL", 1)
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		TargetDWJinJie_TargetPeak:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	--SystemSetup:Lua_OpenDFengOther()
	local eLoad = GetTargetPlayerGUID();
	if eLoad ~=nil and eLoad ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetTargetWuJingData");
			Set_XSCRIPT_ScriptID(502161);
			Set_XSCRIPT_Parameter(0,tonumber(eLoad));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	this:Hide();
end

function TargetDWJinJie_TargetProfile_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(9), 1)
	local lv = CachedTarget:GetData("LEVEL", 1)
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetDWJinJie_TargetProfile:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetDWJinJie_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function TargetDWJinJie_Frame_On_ResetPos()
	TargetDWJinJie_Frame:SetProperty("UnifiedPosition", g_TargetDWJinJie_Frame_UnifiedPosition)
end

function TargetDWJinJie_IsEquipPointOpened(ep)
	for i = 1, table.getn(g_OpenEquipPointList) do
		if ep == g_OpenEquipPointList[i] then
			return 1
		end
	end
	return 0
end
