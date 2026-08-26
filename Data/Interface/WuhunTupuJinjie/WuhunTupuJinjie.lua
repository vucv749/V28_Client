--!!!reloadscript =WuhunTupuJinjie

local g_WuhunTupuJinjie_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_CurrentFilter = 0
local g_InitList = 0
local g_CurrentSelWG = 0
local g_MaxCardLevel = 5
local g_NeedChangeScrollSize = 0

local g_strAttrDic = {
[6]="#{equip_attr_attack_cold}",
[9]="#{equip_attr_attack_fire}",
[12]="#{equip_attr_attack_light}",
[15]="#{equip_attr_attack_poison}",
[19]="#{equip_attr_attack_p}",
[26]="#{equip_attr_attack_m}",
}
local g_strEffectDic = {
[0] = "#{WH_210223_142}",--????
[1] = "#{WH_210223_143}",--????
[2] = "#{WH_210223_138}",--???
[3] = "#{WH_210223_139}",--???
[4] = "#{WH_210223_140}",--???
[5] = "#{WH_210223_141}",--???
}

function WuhunTupuJinjie_PreLoad()

	--this:RegisterEvent("OPEN_WHWG")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("XINGZHEN_UPDATE", false)
	
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	
	--离开场景，自动关睜
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED", false)

end

function WuhunTupuJinjie_OnLoad()	
	g_WuhunTupuJinjie_UnifiedPosition = WuhunTupuJinjie_Frame:GetProperty("UnifiedPosition")	
end

function WuhunTupuJinjie_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880003 then
		this:Show()
		--g_CurrentSelWG = 0
		--m_ItemBagIndex = -1
		--OpenWindow("Packet")
		local objid= Get_XParam_INT(0)
		if objid~=-1 then
			WuhunTupuJinjie_BeginCareObj(objid)
		end
		WuhunTupuJinjie_Update()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunTupuJinjie_On_ResetPos()
	elseif event == "UNIT_MONEY" then
		WuhunTupuJinjie_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif event == "MONEYJZ_CHANGE" then 
		WuhunTupuJinjie_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif event == "PACKAGE_ITEM_CHANGED" then
		WuhunTupuJinjie_Update()
	end
end

function WuhunTupuJinjie_InitListBar()	
	if g_InitList == 0 then		
		g_MaxBarNum = DataPool:LuaFnGetWHWGMaxCount()
		for i = 1, g_MaxBarNum do
			local bar = WuhunTupuJinjie_Item_Lace:AddChild("WuhunTupuJinjie_ItemBK")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("WuhunTupuJinjie_Item"):SetEvent("MouseLButtonDown", string.format("WuhunTupuJinjie_ItemClicked(%d)", i))
		end	
		g_InitList = 1
	end
end

--刷新
function WuhunTupuJinjie_Update()	
	
	WuhunTupuJinjie_InitListBar()
	
	WuhunTupuJinjie_ListCleanUpAction()
	DataPool:LuaFnInitWHWGList()
	local nCount = DataPool:LuaFnGetWHWGListCount()
	
	for i = 1, g_MaxBarNum do
		WuhunTupuJinjie_SetItem(i, nCount)
	end
	
	if g_NeedChangeScrollSize == 1 then		
	--	WuhunTupuJinjie_Item_Lace:RefreshLayout()
		WuhunTupuJinjie_Item_Lace:SetScrollPosition(0)
		g_NeedChangeScrollSize = 0
	end
	WuhunTupuJinjie_UpdateSel()
	
	WuhunTupuJinjie_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	WuhunTupuJinjie_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function WuhunTupuJinjie_UpdateSel()

	if g_CurrentSelWG ~= 0 then

		--图谱名字
		local strName = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
		local strTemp = ScriptGlobal_Format("#{WH_210223_65}", tostring(strName))
		local strText = "#{WH_210223_64}"..strTemp
		WuhunTupuJinjie_ItemInfo1:SetText(strText)
		local theAction = EnumAction(g_CurrentSelWG, "whwg")
		if theAction:GetID() ~= 0 then
			WuhunTupuJinjie_ItemIcon:SetActionItem(theAction:GetID())
		end

		local nTPGrade = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Grade")
		local nTPLevel = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Level")
		--激活与否
		local nUnLocked = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		if nUnLocked == 0 then
			WuhunTupuJinjie_Need_Object_Number:SetText("")
			WuhunTupuJinjie_Need_Object:SetActionItem(-1)
			WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", "0")
			WuhunTupuJinjie_Item_EffectBK:Hide()
			WuhunTupuJinjie_EffectNone:SetText("#{WH_210223_88}")
		else
			if nTPGrade==10 then
				WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", tostring(0))
				WuhunTupuJinjie_Need_Object:SetActionItem(-1)
				WuhunTupuJinjie_Need_Object_Number:SetText("")
				WuhunTupuJinjie_Item_EffectBK:Hide()
				WuhunTupuJinjie_EffectNone:SetText("#{WH_210223_89}")
			elseif nTPLevel==10 then
				--狚常显示
				WuhunTupuJinjie_Item_EffectBK:Show()
				WuhunTupuJinjie_EffectNone:SetText("")

				WuhunTupuJinjie_EffectLevel:SetText( ScriptGlobal_Format("#{WH_210223_86}", nTPGrade, nTPLevel) )
				local need_itembind,need_itemunbind = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"LevelItem")
				local need_itemcount = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"LevelItemCount")
				local need_money = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"LevelCost")

				WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
				--当前等级属性
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"AttrEffectYin")
				local wszattr,wszattrvalue = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"wszAttr")
				WuhunTupuJinjie_Effect1:SetText(g_strAttrDic[attr_yang].."+"..attrvalue_yang)
				WuhunTupuJinjie_Effect2:SetText( ScriptGlobal_Format("#{WH_210223_59}", g_strEffectDic[effecttype_yang],tostring(0.01*effectvalue_yang)) )
				WuhunTupuJinjie_Effect3:SetText(g_strAttrDic[attr_yin].."+"..attrvalue_yin)
				WuhunTupuJinjie_Effect4:SetText( ScriptGlobal_Format("#{WH_210223_60}", g_strEffectDic[effecttype_yin],tostring(0.01*effectvalue_yin)) )
				WuhunTupuJinjie_Effect5:SetText(g_strAttrDic[wszattr].."+"..wszattrvalue)
				--有没有道具
				local nHaveCount1 = PlayerPackage:CountAvailableItemByIDTable(need_itembind)
				local nHaveCount2 = PlayerPackage:CountAvailableItemByIDTable(need_itemunbind)
				if nHaveCount1>0 then
					local showAction = DataPool:CreateBindActionItemForShow(need_itembind, 1)
					if showAction:GetID() ~= 0 then
						WuhunTupuJinjie_Need_Object:SetActionItem(showAction:GetID())
					end
				else
					local showAction = DataPool:CreateActionItemForShow(need_itemunbind, 1)
					if showAction:GetID() ~= 0 then
						WuhunTupuJinjie_Need_Object:SetActionItem(showAction:GetID())
					end
				end
				local szHaveCount = ""
				if nHaveCount1+nHaveCount2 >= need_itemcount then
					szHaveCount = ScriptGlobal_Format("#{WH_210223_127}", need_itemcount)
				else
					szHaveCount = ScriptGlobal_Format("#{WH_210223_70}", need_itemcount)
				end
				WuhunTupuJinjie_Need_Object_Number:SetText(szHaveCount)
				--下一阶
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade+1,0,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade+1,0,"AttrEffectYin")
				local wszattr,wszattrvalue = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade+1,0,"wszAttr")
				WuhunTupuJinjie_Effect1Plus:SetText( ScriptGlobal_Format("#{WH_210223_173}", attrvalue_yang) )
				WuhunTupuJinjie_Effect2Plus:SetText( ScriptGlobal_Format("#{WH_210223_174}", tostring(0.01*effectvalue_yang)) )
				WuhunTupuJinjie_Effect3Plus:SetText( ScriptGlobal_Format("#{WH_210223_173}", attrvalue_yin) )
				WuhunTupuJinjie_Effect4Plus:SetText( ScriptGlobal_Format("#{WH_210223_175}", tostring(0.01*effectvalue_yin)) )
				WuhunTupuJinjie_Effect5Plus:SetText("+"..wszattrvalue)
				WuhunTupuJinjie_EffectNone:SetText("")
				WuhunTupuJinjie_EffectLevelPluse:SetText( ScriptGlobal_Format("#{WH_210223_86}", nTPGrade+1, 0) )
			else
				WuhunTupuJinjie_Need_Object_Number:SetText("")
				WuhunTupuJinjie_Need_Object:SetActionItem(-1)
				WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", "0")
				WuhunTupuJinjie_Item_EffectBK:Hide()
				WuhunTupuJinjie_EffectNone:SetText(ScriptGlobal_Format("#{WH_210223_181}", nTPGrade, 10))
			end
		end
	else
		WuhunTupuJinjie_ItemInfo1:SetText("#{WH_210223_64}")

		WuhunTupuJinjie_EffectLevel:SetText("")--????:?
		WuhunTupuJinjie_EffectLevelPluse:SetText("")--????:?
		
		WuhunTupuJinjie_Item_EffectBK:Hide()
		WuhunTupuJinjie_EffectNone:SetText("")
		
		WuhunTupuJinjie_ItemIcon:SetActionItem(-1)
		WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", "0")
		WuhunTupuJinjie_Need_Object:SetActionItem(-1)
		WuhunTupuJinjie_Need_Object_Number:SetText("")
	end
end

function WuhunTupuJinjie_SetItem(idx, max_count)

	if g_BarList[idx] == nil then
		return
	end
	
	if idx > max_count then
		g_BarList[idx]:Hide()
		return
	end
	
	local bar = g_BarList[idx]
	bar:Show()
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(idx - 1)
	local nUnLocked = DataPool:LuaFnGetWHWGInfo(wgID, "UnLocked")
	local nLevel = DataPool:LuaFnGetWHWGInfo(wgID, "Level")
	local nGrade = DataPool:LuaFnGetWHWGInfo(wgID, "Grade")
	local strName = DataPool:LuaFnGetWHWGInfo(wgID, "Name")

	--激活锁
	if nUnLocked == 1 then
		bar:GetSubItem("WuhunTupuJinjie_Item_Mask"):Hide()
	else
		bar:GetSubItem("WuhunTupuJinjie_Item_Mask"):Show()
	end

	local ctrlAction = bar:GetSubItem("WuhunTupuJinjie_Item")
	if ctrlAction ~= nil then

		ctrlAction:SetActionItem(-1)
		
		local theAction = EnumAction(wgID, "whwg")
		if theAction:GetID() ~= 0 then
			ctrlAction:SetActionItem(theAction:GetID())
		end
	
		ctrlAction:SetProperty("DraggingEnabled", "False")
		
		if wgID == g_CurrentSelWG then
			ctrlAction:SetPushed(1)
		else
			ctrlAction:SetPushed(0)
		end
	end
end

function WuhunTupuJinjie_ItemClicked(nIndex)
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(nIndex - 1)
	if g_CurrentSelWG == wgID then
		return
	end
	
	g_CurrentSelWG = wgID
	
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuJinjie_Item")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
				else
					ctrlAction:SetPushed(0)	
				end
			end			
		end
	end
	
	WuhunTupuJinjie_UpdateSel()
	
end

function WuhunTupuJinjie_GradeUp_Clicked()
	
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then			
		return
	end
	if g_CurrentSelWG == 0 then
		PushDebugMessage("#{WH_210223_102}")
		return
	end
	--激活与否
	local nUnLocked = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
	if nUnLocked==0 then
		PushDebugMessage("#{WH_210223_103}")
		return
	end
	local nTPGrade = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Grade")
	local nTPLevel = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Level")
	if nTPGrade==10 then
		PushDebugMessage("#{WH_210223_104}")
		return
	end
	if nTPLevel<10 then
		PushDebugMessage("#{WH_210223_105}")
		return
	end

	local need_itembind,need_itemunbind = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItem")
	local need_itemcount = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItemCount")
	local nHaveCount1 = PlayerPackage:CountAvailableItemByIDTable(need_itembind)
	local nHaveCount2 = PlayerPackage:CountAvailableItemByIDTable(need_itemunbind)
	if (nHaveCount1+nHaveCount2)<need_itemcount then
		PushDebugMessage("#{WH_210223_183}")
		return
	end

	local need_money = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelCost")
	local nHaveMoney = Player:GetData("MONEY")
	local nHaveJiaoZi = Player:GetData("MONEY_JZ")
	if (nHaveMoney+nHaveJiaoZi)<need_money then
		PushDebugMessage("#{WH_210223_81}")
		return
	end

	--二次确认
	local strName = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
	local needItemName = PlayerPackage:GetItemName( need_itembind )
	local strInfo = ScriptGlobal_Format("#{WH_210223_106}", strName,need_itemcount,needItemName,need_money )
	PushEvent("WHWG_GRADEUP_CONFIRM",g_CurrentSelWG,strInfo)

end

function WuhunTupuJinjie_DoCancel()
	WuhunTupuJinjie_OnCloseClicked()
end

function WuhunTupuJinjie_OnCloseClicked()
	this:Hide()
end

function WuhunTupuJinjie_OnHidden()
	g_CurrentSelWG = 0
	WuhunTupuJinjie_ListCleanUpAction()
	WuhunTupuJinjie_ItemIcon:SetActionItem(-1)
	WuhunTupuJinjie_Need_Object:SetActionItem(-1)
end

function WuhunTupuJinjie_ListCleanUpAction()	
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then			
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuJinjie_Item")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end	
	end
end

function WuhunTupuJinjie_On_ResetPos()
	if g_WuhunTupuJinjie_UnifiedPosition ~= nil then
		WuhunTupuJinjie_Frame:SetProperty("UnifiedPosition", g_WuhunTupuJinjie_UnifiedPosition)
	end
end

function WuhunTupuJinjie_BeginCareObj(obj_id)	
	m_ObjCared = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(m_ObjCared, 1)
end

function WuhunTupuJinjie_Close_Cilcked()
	this:Hide()
end
