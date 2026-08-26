--!!!reloadscript =TargetLingyu

local g_TargetLingyu_Frame_UnifiedPosition

local g_LingYuAction = {}

function TargetLingyu_PreLoad()
	--open or close this window
	this:RegisterEvent("TOGGLE_OTHER_LINGYU_PAGE")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	--update equip
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function TargetLingyu_OnLoad()
	g_TargetWuhun_Frame_UnifiedPosition = TargetLingyu_Frame:GetProperty("UnifiedPosition")
	
	g_LingYuAction[1] = TargetLingyu_Plan_Item1
	g_LingYuAction[2] = TargetLingyu_Plan_Item2
	g_LingYuAction[3] = TargetLingyu_Plan_Item3
	g_LingYuAction[4] = TargetLingyu_Plan_Item4
	g_LingYuAction[5] = TargetLingyu_Plan_Item5
	g_LingYuAction[6] = TargetLingyu_Plan_Item6	

end

function TargetLingyu_OnEvent(event)
	
	if event == "PLAYER_LEAVE_WORLD" then		
		this:Hide()
		return
	end
	
	if event == "TOGGLE_OTHER_LINGYU_PAGE" then
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
		TargetLingyu_Update()
		this:Show()
	end
		
	if event == "OTHERPLAYER_UPDATE_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1)
		TargetLingyu_Update()
	end
		
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		TargetLingyu_Frame_On_ResetPos()
	end
end

--Update
function TargetLingyu_Update()
	--Tab
	TargetLingyu_Lingyu:SetCheck(1)
	--Pos
	local otherUnionPos = Variable:GetVariable("OtherUnionPos")
	if otherUnionPos ~= nil then
		TargetLingyu_Frame:SetProperty("UnifiedPosition", otherUnionPos)
	end
	
	for i = 1, 6 do
		g_LingYuAction[i]:SetActionItem(-1)
		local ActionLY = EnumAction(18 + i, "targetequip")
		g_LingYuAction[i]:SetActionItem(ActionLY:GetID())
	end
	
	DataPool:LuaFnUpdateLingYuAttrList(0)
	
	TargetLingyu_SetItemsSkill:SetActionItem(-1)
	TargetLingyu_SetItemsSkill:SetProperty("DraggingEnabled", "False")
	TargetLingyu_SetItemsSkill:Hide()
	
	if DataPool:LuaFnGetLingYuSetSkillForUI(0) > 0 then
		local theAction = EnumAction(1, "lingyuset_skill")
		TargetLingyu_SetItemsSkill:SetProperty("UseDefaultTooltip", "False")
		TargetLingyu_SetItemsSkill:SetActionItem(theAction:GetID())
		TargetLingyu_SetItemsSkill:Show()
	end
	
	TargetLingyu_ListContent:Clear()
	local attr_list_count = DataPool:LuaFnGetOtherLingYuAttrCount()
	for i = 1, attr_list_count do	
		local bar = TargetLingyu_ListContent:AddChild("TargetLingyu_ListContent_CoinAItem")
		local strAttrName = DataPool:LuaFnGetOtherLingYuAttrName(i - 1)
		local strAttrValue = DataPool:LuaFnGetOtherLingYuAttrValueString(i - 1)
		bar:GetSubItem("TargetLingyu_PropertiesText"):SetText(strAttrName)
		bar:GetSubItem("TargetLingyu_Properties"):SetText(strAttrValue)
	end
	
	local effect_count = DataPool:LuaFnGetOtherLingYuSetEffectCount()
	
	if effect_count >= 1 then
		TargetLingyu_SetItemsInfo1:Show()
		local effect_title = DataPool:LuaFnGetOtherLingYuSetAttrDesc(1, 0)
		TargetLingyu_SetItemsInfo1_1:SetText(effect_title)
		
		local effect_name = DataPool:LuaFnGetOtherLingYuSetAttrDesc(2, 0)
		TargetLingyu_SetItemsInfo1_Text:SetText(effect_name)
		
		local effect_num = DataPool:LuaFnGetOtherLingYuSetAttrDesc(3, 0)
		TargetLingyu_SetItemsInfo1_Text2:SetText("#cFFF263+"..effect_num)
	else
		TargetLingyu_SetItemsInfo1:Hide()
	end
	
	if effect_count >= 2 then
		if DataPool:LuaFnGetLingYuSetSkillForUI(0) > 0 then		
			TargetLingyu_SetItemsInfo2:Show()
			TargetLingyu_SetItemsInfo3:Hide()
			local effect_title = DataPool:LuaFnGetOtherLingYuSetAttrDesc(1, 1)
			TargetLingyu_SetItemsInfo2_1:SetText(effect_title)
			
			local effect_name = DataPool:LuaFnGetOtherLingYuSetAttrDesc(2, 1)
			TargetLingyu_SetItemsInfo2_Text:SetText(effect_name)
			
			local effect_num = DataPool:LuaFnGetOtherLingYuSetAttrDesc(3, 1)
			TargetLingyu_SetItemsInfo2_Text2:SetText("#cFFF263"..effect_num)
		else
			TargetLingyu_SetItemsInfo2:Hide()
			TargetLingyu_SetItemsInfo3:Show()
			local effect_title = DataPool:LuaFnGetOtherLingYuSetAttrDesc(1, 1)
			TargetLingyu_SetItemsInfo3_1:SetText(effect_title)
			
			local effect_name = DataPool:LuaFnGetOtherLingYuSetAttrDesc(2, 1)
			TargetLingyu_SetItemsInfo3_Text:SetText(effect_name)
			
			local effect_num = DataPool:LuaFnGetOtherLingYuSetAttrDesc(3, 1)
			TargetLingyu_SetItemsInfo3_Text2:SetText("#cFFF263+"..effect_num)
		end
	else
		TargetLingyu_SetItemsInfo2:Hide()
		TargetLingyu_SetItemsInfo3:Hide()
	end

end

function TargetLingyu_OnHiden()
	for i = 1, 6 do
		g_LingYuAction[i]:SetActionItem(-1)
	end
end



-- 打开玩家装备UI
function TargetLingyu_OtherEquip_Page_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(1), 1)
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenEquipFrame("other");
end

-- 打开玩家信息界面
function TargetLingyu_OtherData_Page_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(2), 1)
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
-- 打开玩家宠物UI
function TargetLingyu_OtherPet_Page_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(3), 1)
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end

function TargetLingyu_OtherWuhun_Page_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(4), 1)
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		TargetLingyu_Wuhun:SetCheck(0)
		return
	end
	
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherWuhun()
end

function TargetLingyu_TargetLingyu_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(5), 1)
end

function TargetLingyu_ShenBing_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(6), 1)
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function TargetLingyu_DWJinJie_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(7), 1)
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end

function TargetLingyu_OtherProfile_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(9), 1)
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetLingyu_Profile:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end
function TargetLingyu_OtherPeak_Switch()
	--if ZBS:IsZBSFinalDFengBanFlag() == 1 then
	--	PushDebugMessage("#{WCBZ_250812_1}")
	--    return 0
	--end
	Variable:SetVariable("TargetPageNumber", tostring(8), 1)
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		TargetLingyu_Peak:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetLingyu_Frame:GetProperty("UnifiedPosition"), 1)
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

function TargetLingyu_OnClose()
	this:Hide()
end

function TargetLingyu_OnHelp()
	Helper:GotoHelper("*TargetLingyu")
end

function TargetLingyu_Frame_On_ResetPos()
  TargetLingyu_Frame:SetProperty("UnifiedPosition", g_TargetLingyu_Frame_UnifiedPosition)
end