--雕纹进阶突破
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_ServerObj = -1
local g_DWJinJie_TeXingShengJi_DemandMoney = 0

local g_UICOMMAND = 89030506
local g_TupoItemID = 20310175 

local g_DWJinJie_TeXingShengJi_Frame_UnifiedPosition;

local g_CurSelTeXingID = 0

local g_FullRigthActionBtn = {}
local g_Position_Scroll = 0
-- local g_TexingSpData = {
-- 	[1] = {"1","2","3","4","5","6","7","8","9","10"},
-- 	[11] = {"0.5","1","1.5","2","2.5","3","3.5","4","4.5","5"},
-- }
local g_TexingSpData16_2 = {"0.5","1","1.5","2","2.5","3","3.5","4","4.5","5"}
local g_InitList = 0
local g_FeaturesBarList = {}
local g_FeaturesActionList = {}
local g_FeaturesActionTipsList = {}
local g_FeaturesActionMaskList = {}
local g_ShowMode = 1 -- 1?? 2??
local g_FeaturesListBarInfo= {}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWJinJie_TeXingShengJi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

--=========================================================
-- 载入初始化
--=========================================================
function DWJinJie_TeXingShengJi_OnLoad()
	g_DWJinJie_TeXingShengJi_DemandMoney = 0
	DWJinJie_TeXingShengJi_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWJinJie_TeXingShengJi_DemandMoney))
	-- 始譅可以点击 OK 按钮, 为了方便提示玩家信息
	DWJinJie_TeXingShengJi_OK:Enable()
	g_DWJinJie_TeXingShengJi_Frame_UnifiedPosition=DWJinJie_TeXingShengJi_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function DWJinJie_TeXingShengJi_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND) then
		local opt =  Get_XParam_INT(0)
		if opt == 1 then
			local xx = Get_XParam_INT(1)  --targetid
			g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
			if g_CaredNpc == -1 then
				PushDebugMessage("server data error")
				return
			end
			BeginCareObject_DWJinJie_TeXingShengJi()
			DWJinJie_TeXingShengJi_Clear()
			DWJinJie_TeXingShengJi_UpdateRight()
			DWJinJie_TeXingShengJi_TeXingChoose(1)
			this:Show()
		elseif opt == 2 then
			if not this:IsVisible() then	
				return 
			end
			g_Position_Scroll = DWJinJie_TeXingShengJi_DWTeXing_TopList:GetScrollPosition()	--??????????
			DWJinJie_TeXingShengJi_UpdateRight()
			DWJinJie_TeXingShengJi_UpdateBasic()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if (arg0~= nil and -1 == tonumber(arg0)) or g_CurSelTeXingID <1 then
			return
		end
		if g_ShowMode == 1 then
			local _,_,_,_,nTeXingShuItemID = LifeAbility:GetDiaowenTeXingDescInfo(g_CurSelTeXingID)
			local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(nTeXingShuItemID)
			local color = "#G"
			if toolNumInBag < 1 then
				color = "#cFF0000"
			end
			DWJinJie_TeXingShengJi_Item2Num:SetText(color..toolNumInBag.."/1")--????
		elseif g_ShowMode == 2 then
			local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(g_TupoItemID)
			local texingID,texingLevel,texingExp = LifeAbility:GetDiaowenJinJieTeXingByID(g_CurSelTeXingID)
			local nRequiredTeXingShu,nRequiredJiaoZi,nRequiredTuPoItem = LifeAbility:GetDiaowenJinJieTeXingShengJiRequiredCount(texingLevel)
			if nRequiredTuPoItem < 0 then
				nRequiredTuPoItem = 0
			end
			local color = "#G"
			if toolNumInBag < nRequiredTuPoItem then
				color = "#cFF0000"
			end
			DWJinJie_TeXingShengJi_Item2Num:SetText(color..toolNumInBag.."/"..nRequiredTuPoItem) --????
		end

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWJinJie_TeXingShengJi_CloseClicked()
		end

	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWJinJie_TeXingShengJi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		DWJinJie_TeXingShengJi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	-- elseif (event == "CONFIRM_DWJinJie_TeXingShengJi") then
	-- 	DWJinJie_TeXingShengJi_OK_Clicked(1)
	elseif (event == "ADJEST_UI_POS" ) then
		DWJinJie_TeXingShengJi_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWJinJie_TeXingShengJi_Frame_On_ResetPos()
	end
end

--=========================================================
-- 左边
--=========================================================
function DWJinJie_TeXingShengJi_UpdateBasic()

	DWJinJie_TeXingShengJi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWJinJie_TeXingShengJi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	local totalTeXingNum =  DataPool:LuaFnGetFeaturesMaxCount()
	if g_CurSelTeXingID < 1 or g_CurSelTeXingID > totalTeXingNum or table.getn(g_FeaturesListBarInfo) < 1 then
		DWJinJie_TeXingShengJi_Clear()
		return
	end
	local szTeXingName,szXiaoGuoDesc,szXiaoGuoTips,szTeXingIcon,nTeXingShuItemID = LifeAbility:GetDiaowenTeXingDescInfo(g_CurSelTeXingID)
	if not szTeXingName then
		PushDebugMessage("#{DWJJ_240329_180}")
		return
	end

	DWJinJie_TeXingShengJi_DWTeXingInfoBtn:Show()

	local haveNum = LifeAbility:GetDiaowenJinJieTeXingHaveNum()
	local texingID,texingLevel,texingExp = LifeAbility:GetDiaowenJinJieTeXingByID(g_CurSelTeXingID)
	local dataIncres,dataScale =  LifeAbility:GetDiaowenTeXingAddInfo(g_CurSelTeXingID,texingLevel)
	local nRequiredTeXingShu,nRequiredJiaoZi,nRequiredTuPoItem = LifeAbility:GetDiaowenJinJieTeXingShengJiRequiredCount(texingLevel)
	local texingMaxLevel = LifeAbility:GetDiaowenJinJieTeXingMaxLevel()

	local curTeXingAction =  EnumAction(g_CurSelTeXingID,"features") 
	if curTeXingAction:GetID() ~= 0 then
		DWJinJie_TeXingShengJi_Item:SetActionItem(curTeXingAction:GetID())
	end

	DWJinJie_TeXingShengJi_DWTeXingTitle1:SetText("#cfff263"..szTeXingName)
	if texingLevel < 1 then
		DWJinJie_TeXingShengJi_DWTeXing_InfoText:SetText("#{DWJJ_240329_201}")
		DWJinJie_TeXingShengJi_DWTeXingTitle2:Hide()
		DWJinJie_TeXingShengJi_DWTeXing_levelNow:Hide()
	else
		DWJinJie_TeXingShengJi_DWTeXingTitle2:Show()
		DWJinJie_TeXingShengJi_DWTeXingTitle2:SetText(ScriptGlobal_Format("#{DWJJ_240329_178}",szTeXingName,tostring(texingLevel)))
		DWJinJie_TeXingShengJi_DWTeXing_levelNow:Show()
		-- if g_TexingSpData[g_CurSelTeXingID] then
		-- 	dataIncres = g_TexingSpData[g_CurSelTeXingID][texingLevel]
		-- end
		if g_CurSelTeXingID == 16 then
			DWJinJie_TeXingShengJi_DWTeXing_InfoText:SetText(
				string.format(
					"#cfff263"..szXiaoGuoTips,tostring(dataIncres/dataScale),
					g_TexingSpData16_2[texingLevel]
				)
			)
		else
			DWJinJie_TeXingShengJi_DWTeXing_InfoText:SetText(
				"#cfff263"..string.format(
					szXiaoGuoTips,tostring(dataIncres/dataScale)
				)
			)
		end
	end
	if texingLevel == texingMaxLevel then
		DWJinJie_TeXingShengJi_DWTeXing_EXP:SetProgress(1,1)
		DWJinJie_TeXingShengJi_DWTeXing_levelNeed:Hide()
		--DWJinJie_TeXingShengJi_DWTeXing_levelNeed:SetText(ScriptGlobal_Format("#{DWJJ_240329_176}",0,0)) --升级所需 
		DWJinJie_TeXingShengJi_DWTeXing_InfoText2:SetText(
			"#{DWJJ_240329_177}"
		)
		DWJinJie_TeXingShengJi_DWTeXingTitle3:Hide()
		--DWJinJie_TeXingShengJi_DWTeXingTitle3:SetText(ScriptGlobal_Format("#{DWJJ_240329_178}",szTeXingName,"#{DWJJ_240329_177}"))
	else
		DWJinJie_TeXingShengJi_DWTeXing_EXP:SetProgress(texingExp,nRequiredTeXingShu)
		DWJinJie_TeXingShengJi_DWTeXing_levelNeed:Show()
		DWJinJie_TeXingShengJi_DWTeXing_levelNeed:SetText(ScriptGlobal_Format("#{DWJJ_240329_176}",texingExp,nRequiredTeXingShu)) --???? 
		local nextdataIncres, nextdataScale =  LifeAbility:GetDiaowenTeXingAddInfo(g_CurSelTeXingID,texingLevel+1)
		-- if g_TexingSpData[g_CurSelTeXingID] then
		-- 	nextdataIncres = g_TexingSpData[g_CurSelTeXingID][texingLevel+1]
		-- end
		if g_CurSelTeXingID == 16 then
			DWJinJie_TeXingShengJi_DWTeXing_InfoText2:SetText(
				"#cfff263"..string.format(
					szXiaoGuoTips,tostring(nextdataIncres/nextdataScale),
					g_TexingSpData16_2[texingLevel+1]
				)
			)
		else
			DWJinJie_TeXingShengJi_DWTeXing_InfoText2:SetText(
				"#cfff263"..string.format(
					szXiaoGuoTips,tostring(nextdataIncres/nextdataScale)
				)
			)
		end
		DWJinJie_TeXingShengJi_DWTeXingTitle3:Show()
		DWJinJie_TeXingShengJi_DWTeXingTitle3:SetText(ScriptGlobal_Format("#{DWJJ_240329_178}",szTeXingName,tostring(texingLevel+1)))
	end

	DWJinJie_TeXingShengJi_DWTeXing_levelNow:SetText(ScriptGlobal_Format("#{DWJJ_240329_170}",texingLevel) )


	--突破or升级
	if  texingExp >= nRequiredTeXingShu then
		g_ShowMode = 2
	else
		g_ShowMode = 1
	end
	if g_ShowMode == 1 then
		--升级
		local texingShuAction =  DataPool:CreateActionItemForShow(nTeXingShuItemID, 1)
		if texingShuAction:GetID() ~= 0 then
			DWJinJie_TeXingShengJi_Item2:SetActionItem(texingShuAction:GetID())
		end
		DWJinJie_TeXingShengJi_Item2:Show()
		DWJinJie_TeXingShengJi_LevelupText:Show()
		DWJinJie_TeXingShengJi_LevelupText:SetText(ScriptGlobal_Format("#{DWJJ_240329_179}",DataPool:Lua_GetItemNameByIndex(nTeXingShuItemID)))
	
		local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(nTeXingShuItemID)
		local color = "#G"
		if toolNumInBag < 1 then
			color = "#cFF0000"
		end
		DWJinJie_TeXingShengJi_Item2Num:Show()
		DWJinJie_TeXingShengJi_Item2Num:SetText(color..toolNumInBag.."/".."1")--????
		g_DWJinJie_TeXingShengJi_DemandMoney = 0
		DWJinJie_TeXingShengJi_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWJinJie_TeXingShengJi_DemandMoney))
	elseif g_ShowMode == 2 then
		--突破
		local texingShuAction =  DataPool:CreateActionItemForShow(g_TupoItemID, 1)
		if texingShuAction:GetID() ~= 0 then
			DWJinJie_TeXingShengJi_Item2:SetActionItem(texingShuAction:GetID())
		end

		local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(g_TupoItemID)
		if nRequiredTuPoItem <= 0 then
			nRequiredTuPoItem = 0
			DWJinJie_TeXingShengJi_Item2Num:Hide()
			DWJinJie_TeXingShengJi_LevelupText:Hide()
			DWJinJie_TeXingShengJi_Item2:Hide()
		else
			DWJinJie_TeXingShengJi_Item2Num:Show()
			DWJinJie_TeXingShengJi_LevelupText:Show()
			DWJinJie_TeXingShengJi_Item2:Show()
			DWJinJie_TeXingShengJi_LevelupText:SetText(ScriptGlobal_Format("#{DWJJ_240329_179}",DataPool:Lua_GetItemNameByIndex(g_TupoItemID)))
			local color = "#G"
			if toolNumInBag < nRequiredTuPoItem then
				color = "#cFF0000"
			end
			DWJinJie_TeXingShengJi_Item2Num:SetText(color..toolNumInBag.."/"..nRequiredTuPoItem) --????
		end
	
		if nRequiredJiaoZi < 0 then
			g_DWJinJie_TeXingShengJi_DemandMoney = 0
		else
			g_DWJinJie_TeXingShengJi_DemandMoney = nRequiredJiaoZi
		end
		DWJinJie_TeXingShengJi_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWJinJie_TeXingShengJi_DemandMoney))
	else
		PushDebugMessage("error")	
	end
end

function DWJinJie_TeXingShengJi_InitRight()
	if g_InitList == 0 then
		local MaxFeatures = DataPool:LuaFnGetFeaturesMaxCount()
		for i = 1, MaxFeatures do
			local bar = DWJinJie_TeXingShengJi_DWTeXing_TopList:AddChild("DWJinJie_TeXingShengJi_DWTeXing_TopListItem")
			if bar then
				bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
				g_FeaturesBarList[i] = bar
				local featuresActionBtn = bar:GetSubItem("DWJinJie_TeXingShengJi_DWTeXing_TopListItemAction")
				if featuresActionBtn then
					g_FeaturesActionList[i] = featuresActionBtn
					featuresActionBtn:SetEvent("MouseLButtonDown", string.format("DWJinJie_TeXingShengJi_TeXingChoose(%d)", i))
				end
				local featuresActionBtnTips =  bar:GetSubItem("DWJinJie_TeXingShengJi_DWTeXing_TopListItemtips")
				if featuresActionBtnTips then
					g_FeaturesActionTipsList[i] = featuresActionBtnTips
				end
				local featuresActionBtnMask =  bar:GetSubItem("DWJinJie_TeXingShengJi_DWTeXing_TopListItemAction_Mask")
				if featuresActionBtnMask then
					g_FeaturesActionMaskList[i] = featuresActionBtnMask
				end
				
			--	bar:GetSubItem("SelfDWJinJie_DWTeXing_TopListItem2Action"):SetProperty("Empty", "False")
			--	bar:GetSubItem("SelfDWJinJie_DWTeXing_TopListItem2Action"):SetProperty("UseDefaultTooltip", "True")
			--	bar:GetSubItem("SelfDWJinJie_DWTeXing_TopListItem2Action"):SetProperty("DraggingEnabled", "True")
			--	bar:GetSubItem("SelfDWJinJie_DWTeXing_TopListItem2Action"):SetProperty("DragAcceptName", "FP"..tostring(i))
			end
		end		
		g_InitList = 1
	end
end

function DWJinJie_TeXingShengJi_UpdateRight()
	DWJinJie_TeXingShengJi_InitRight()
	DataPool:LuaFnInitFeaturesList(0)
	local totalTeXingNum = DataPool:LuaFnGetFeaturesMaxCount()
	local texingMaxLevel = LifeAbility:GetDiaowenJinJieTeXingMaxLevel()
	local list_count = DataPool:LuaFnGetFeaturesListCount()
	--local haveMoney =  Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	local showBtnNum = 0
	g_FeaturesListBarInfo = {}
	for i = 1, totalTeXingNum do
		local showBtn = 1
		local showTips = 0
		local showMask = 0
		if i > list_count then
			showBtn = 0
		else
			local featureId = DataPool:LuaFnEnumFeaturesID(i - 1)
			local texingID,texingLevel,texingExp = LifeAbility:GetDiaowenJinJieTeXingByID(featureId)
			local nRequiredTeXingShu,nRequiredJiaoZi,nRequiredTuPoItem = LifeAbility:GetDiaowenJinJieTeXingShengJiRequiredCount(texingLevel)
			if LifeAbility:GetDiaowenJinJieTeXingValid(featureId) ~= 1 then
				showBtn = 0
			else
				if texingLevel < 1 then
					showMask = 1
				end
				if  texingExp >= nRequiredTeXingShu then
					local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(g_TupoItemID)
					if nRequiredTuPoItem >= 0 then
						if toolNumInBag >= nRequiredTuPoItem   then
							showTips = 1
						end
					end
				else
					local _,_,_,_,nTeXingShuItemID = LifeAbility:GetDiaowenTeXingDescInfo(featureId)
					local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(nTeXingShuItemID)
					if toolNumInBag > 0 and texingLevel<texingMaxLevel then
						showTips = 1
					end
				end
			end
			
			if showBtn == 1 then
				showBtnNum = showBtnNum + 1
				g_FeaturesListBarInfo[showBtnNum] = {}
				g_FeaturesListBarInfo[showBtnNum].featureId = featureId
				g_FeaturesListBarInfo[showBtnNum].showTips = showTips
				g_FeaturesListBarInfo[showBtnNum].showMask = showMask
			end
		end
	end
	for i = 1, showBtnNum do
		local left = g_FeaturesListBarInfo[i]
		local endtask = 0 
		if left.showMask == 1 and left.showTips == 0 then
			for j = i, showBtnNum do
				local right =  g_FeaturesListBarInfo[j]
				if j == showBtnNum then
					endtask = 1
				end
				if right.showMask == 1 and right.showTips == 1 then
					--交换
					local t_featureId,t_showTips,t_showMask = left.featureId,left.showTips,left.showMask
					left.featureId = right.featureId
					left.showTips = right.showTips
					left.showMask = right.showMask
					right.featureId = t_featureId
					right.showTips = t_showTips
					right.showMask = t_showMask
					break
				end
			end
		end
		if endtask == 1 then
			break
		end
	end
	for i = 1, totalTeXingNum do
		if g_FeaturesListBarInfo[i] then
			local showTips = g_FeaturesListBarInfo[i].showTips 
			local showMask = g_FeaturesListBarInfo[i].showMask 
			local featureId = g_FeaturesListBarInfo[i].featureId 
			if g_FeaturesBarList[i] ~= nil then
				g_FeaturesBarList[i]:Show()
			end
			if g_FeaturesActionList[i] ~= nil then
				local featuresActionBtn = g_FeaturesActionList[i]
				if featuresActionBtn ~= nil then
					featuresActionBtn:SetActionItem(-1)
					local featuresAction = EnumAction(featureId, "features")
					featuresActionBtn:SetActionItem(featuresAction:GetID())
					if featureId == g_CurSelTeXingID then
						featuresActionBtn:SetPushed(1)
					else
						featuresActionBtn:SetPushed(0)
					end
				end
			end
			if g_FeaturesActionTipsList[i]  ~= nil then
				local featuresActionBtnTips = g_FeaturesActionTipsList[i]
				if showTips == 1   then
					featuresActionBtnTips:Show()
				else
					featuresActionBtnTips:Hide()
				end
			end
			if g_FeaturesActionTipsList[i]  ~= nil then
				local featuresActionBtnTips = g_FeaturesActionTipsList[i]
				if showTips == 1   then
					featuresActionBtnTips:Show()
				else
					featuresActionBtnTips:Hide()
				end
			end
			if g_FeaturesActionMaskList[i]  ~= nil then
				if showMask == 1 then
					g_FeaturesActionMaskList[i]:Show()
				else
					g_FeaturesActionMaskList[i]:Hide()
				end
			end
		else
			-- if g_FeaturesActionMaskList[i]  ~= nil then
			-- 	g_FeaturesActionMaskList[i]:Hide()
			-- end
			if g_FeaturesBarList[i] ~= nil then
				g_FeaturesBarList[i]:Hide()
			end
			-- if g_FeaturesActionTipsList[i]  ~= nil then
			-- 	g_FeaturesActionTipsList[i]:Hide()
			-- end
		end
	end
	DWJinJie_TeXingShengJi_DWTeXing_TopList:RefreshLayout()
	DWJinJie_TeXingShengJi_DWTeXing_TopList:SetScrollPosition(g_Position_Scroll)
end

function DWJinJie_TeXingShengJi_TeXingChoose(id)
	if g_FeaturesListBarInfo[id] then
		g_CurSelTeXingID = g_FeaturesListBarInfo[id].featureId
		DWJinJie_TeXingShengJi_UpdateBasic()
		for i = 1, table.getn(g_FeaturesActionList) do
			local featuresActionBtn = g_FeaturesActionList[i]
			if i == id then
				featuresActionBtn:SetPushed(1)
			else
				featuresActionBtn:SetPushed(0)
			end
		end
	end
end

--=========================================================
-- 重置界面
--=========================================================
function DWJinJie_TeXingShengJi_Clear()
	g_CurSelTeXingID = 0
	DWJinJie_TeXingShengJi_Item:SetActionItem(-1)
	DWJinJie_TeXingShengJi_Item2:SetActionItem(-1)
	g_DWJinJie_TeXingShengJi_DemandMoney = 0
	DWJinJie_TeXingShengJi_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWJinJie_TeXingShengJi_DemandMoney))
	DWJinJie_TeXingShengJi_DWTeXingTitle1:SetText("")
	DWJinJie_TeXingShengJi_DWTeXing_InfoText:SetText("#{DWJJ_240329_347}")
	DWJinJie_TeXingShengJi_DWTeXing_InfoText2:SetText("")
	DWJinJie_TeXingShengJi_DWTeXing_levelNeed:SetText("")
	DWJinJie_TeXingShengJi_DWTeXing_EXP:SetProgress(0,1)
	DWJinJie_TeXingShengJi_DWTeXing_levelNow:SetText("")
	DWJinJie_TeXingShengJi_Item2Num:SetText("")
	DWJinJie_TeXingShengJi_DWTeXingTitle2:SetText("")
	DWJinJie_TeXingShengJi_DWTeXingTitle3:SetText("")
	DWJinJie_TeXingShengJi_LevelupText:SetText("")
	DWJinJie_TeXingShengJi_Item2:Hide()
	DWJinJie_TeXingShengJi_DWTeXingInfoBtn:Hide()
	g_Position_Scroll = 0
end



--=========================================================
-- 确定执行功能
--=========================================================
function DWJinJie_TeXingShengJi_OK_Clicked(okFlag)

	if g_CurSelTeXingID < 1  then
		PushDebugMessage("#{DWJJ_240329_180}")
		return
	end

	local haveNum = LifeAbility:GetDiaowenJinJieTeXingHaveNum()
	local texingID,texingLevel,texingExp = LifeAbility:GetDiaowenJinJieTeXingByID(g_CurSelTeXingID)
	local szTeXingName,szXiaoGuoDesc,szXiaoGuoTips,szTeXingIcon,nTeXingShuItemID = LifeAbility:GetDiaowenTeXingDescInfo(g_CurSelTeXingID)
	local dataIncres,dataScale =  LifeAbility:GetDiaowenTeXingAddInfo(g_CurSelTeXingID,texingLevel)
	local nRequiredTeXingShu,nRequiredJiaoZi,nRequiredTuPoItem = LifeAbility:GetDiaowenJinJieTeXingShengJiRequiredCount(texingLevel)
	local texingMaxLevel = LifeAbility:GetDiaowenJinJieTeXingMaxLevel()
	if g_ShowMode == 1 then
		if texingLevel >= texingMaxLevel then
			PushDebugMessage("#{DWJJ_240329_181}")
			return
		end
		if texingExp >= nRequiredTeXingShu then
			PushDebugMessage("#{DWJJ_240329_182}")
			return
		end
		local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(nTeXingShuItemID)
		if toolNumInBag < 1 then
			PushDebugMessage(ScriptGlobal_Format("#{DWJJ_240329_183}",DataPool:Lua_GetItemNameByIndex(nTeXingShuItemID)))
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoTeXingQiangHua")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_ServerObj)
			Set_XSCRIPT_Parameter(1, g_CurSelTeXingID)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif g_ShowMode == 2 then
		if texingLevel >= texingMaxLevel then
			PushDebugMessage("#{DWJJ_240329_188}")
			return
		end
		if texingExp < nRequiredTeXingShu then
			PushDebugMessage("#{DWJJ_240329_189}")
			return
		end
		local toolNumInBag = PlayerPackage:CountAvailableItemByIDTable(g_TupoItemID)
		if toolNumInBag < nRequiredTuPoItem then
			PushDebugMessage("#{DWJJ_240329_190}")
			return
		end
		if Player:GetData("MONEY") + Player:GetData("MONEY_JZ") <  nRequiredJiaoZi then
			PushDebugMessage("#{DWJJ_240329_94}")
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoTeXingShengJi")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_ServerObj)
			Set_XSCRIPT_Parameter(1, g_CurSelTeXingID)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	else
		PushDebugMessage("error2")
	end

end

--=========================================================
-- 关睜界面
--=========================================================
function DWJinJie_TeXingShengJi_CloseClicked()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWJinJie_TeXingShengJi_OnHidden()
	StopCareObject_DWJinJie_TeXingShengJi()
	DWJinJie_TeXingShengJi_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定犫个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWJinJie_TeXingShengJi()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWJinJie_TeXingShengJi")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWJinJie_TeXingShengJi()
	this:CareObject(g_CaredNpc, 0, "DWJinJie_TeXingShengJi")
	g_CaredNpc = -1
	return
end


function DWJinJie_TeXingShengJi_Frame_On_ResetPos()
  DWJinJie_TeXingShengJi_Frame:SetProperty("UnifiedPosition", g_DWJinJie_TeXingShengJi_Frame_UnifiedPosition);
end


function DWJinJie_TeXingShengJi_Detail_Clicked()
	local szTeXingName,szXiaoGuoDesc,szXiaoGuoTips,szTeXingIcon,nTeXingShuItemID = LifeAbility:GetDiaowenTeXingDescInfo(g_CurSelTeXingID)
	if szXiaoGuoDesc then
		PushEvent("QUEST_HELPINFO",szXiaoGuoDesc)
	end
end
