--!!!reloadscript =SelfDWJinJie_Packet

local g_SelfDWJinJie_Packet_Frame_UnifiedPosition

local g_InitList = 0

local g_MaxFeatures = 0

local g_FeaturesListCtrl

local g_FeaturesBarList = {}

local g_CurEquipFeatures = 0

function SelfDWJinJie_Packet_PreLoad()
	this:RegisterEvent("OPEN_FEATURES_BOX")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SelfDWJinJie_Packet_OnLoad()
	g_SelfDWJinJie_Packet_Frame_UnifiedPosition = SelfDWJinJie_Packet_Frame:GetProperty("UnifiedPosition")
	
	g_FeaturesListCtrl = SelfDWJinJie_Packet_ActionsList
end

function SelfDWJinJie_Packet_OnEvent(event)
	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		SelfDWJinJie_Packet_Frame_On_ResetPos()
	end
	
	if event == "OPEN_FEATURES_BOX" then
		DWJinJie_Change_CleanUp()
		this:Show()
		SelfDWJinJie_Packet_Update()
	end
	
end

function SelfDWJinJie_Packet_InitList()
	
	if g_InitList == 0 then
		g_MaxFeatures = DataPool:LuaFnGetFeaturesMaxCount()
		for i = 1, g_MaxFeatures do
			local bar = g_FeaturesListCtrl:AddChild("SelfDWJinJie_Packet_TopListItem2")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_FeaturesBarList[i] = bar
		end

		g_InitList = 1
	end
end

function SelfDWJinJie_Packet_OnShown()
	
end

--Update
function SelfDWJinJie_Packet_Update()
	SelfDWJinJie_Packet_InitList()	
	SelfDWJinJie_Packet_CleanUp()
	
	SelfDWJinJie_Packet_UpdateFeaturesList()
end

function SelfDWJinJie_Packet_UpdateFeaturesList()

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
			local featuresActionBtn = bar:GetSubItem("SelfDWJinJie_Packet_TopListItem2Action")
			
			local featureId = DataPool:LuaFnEnumFeaturesID(i - 1)
			
			if featuresActionBtn ~= nil then
				featuresActionBtn:SetActionItem(-1)
				local featuresAction = EnumAction(featureId, "features")
				featuresActionBtn:SetActionItem(featuresAction:GetID())
				
				local featuresLevel = DataPool:LuaFnGetFeaturesInfo(featureId, "Level")
				--bar:GetSubItem("SelfDWJinJie_Packet_TopListItem2ActionLevel"):SetText(tostring(featuresLevel))
				
				if tonumber(featuresLevel) ~= nil and featuresLevel > 0 then
					bar:GetSubItem("SelfDWJinJie_Packet_TopListItem2Action_Mask16"):Hide()
				else
					bar:GetSubItem("SelfDWJinJie_Packet_TopListItem2Action_Mask16"):Show()
				end
			end
			
			local featuresName = DataPool:LuaFnGetFeaturesInfo(featureId, "Name")
			bar:GetSubItem("SelfDWJinJie_Packet_TopListItem2ActionName"):SetText("#cfff263"..tostring(featuresName))
		end
	end
	
	g_FeaturesListCtrl:RefreshLayout()
end

function SelfDWJinJie_Packet_CleanUp()

end

function SelfDWJinJie_Packet_CloseClicked()
	this:Hide()
end

function SelfDWJinJie_Packet_OnHidden()
	SelfDWJinJie_Packet_CleanUp()
end

function SelfDWJinJie_Packet_DWTeXingInfo_Clicked()
	if g_CurEquipFeatures > 0 then
		PushEvent("OPEN_SWEEPPAGE_QUEST", "DWJinJie_Help", g_CurEquipFeatures)
	end
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function SelfDWJinJie_Packet_Frame_On_ResetPos()
	SelfDWJinJie_Packet_Frame:SetProperty("UnifiedPosition", g_SelfDWJinJie_Packet_Frame_UnifiedPosition)
end
