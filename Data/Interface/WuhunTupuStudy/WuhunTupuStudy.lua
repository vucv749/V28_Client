--!!!reloadscript =WuhunTupuStudy

local g_WuhunTupuStudy_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_CurrentFilter = 0
local g_InitList = 0
local g_CurrentSelWG = 0
local g_MaxCardLevel = 5
local g_NeedChangeScrollSize = 0
local g_RadomIdx = 0
local g_TodayLevelupCount = 0
local g_SuccRadom = {
[0]=100,
[1]=85,
[2]=70,
[3]=55,
[4]=40,
[5]=40,
[6]=40,
[7]=40,
[8]=40,
[9]=40,
[10]=40,
}
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

function WuhunTupuStudy_PreLoad()

	--this:RegisterEvent("OPEN_WHWG")
	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	
	--离开场景，自动关睜
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED", false)

end

function WuhunTupuStudy_OnLoad()	
	g_WuhunTupuStudy_UnifiedPosition = WuhunTupuStudy_Frame:GetProperty("UnifiedPosition")	
end

function WuhunTupuStudy_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880002 then
		this:Show()
		--g_CurrentSelWG = 0
		--m_ItemBagIndex = -1
		--OpenWindow("Packet")
		local objid= Get_XParam_INT(0)
		if objid~=-1 then
			WuhunTupuStudy_BeginCareObj(objid)
		end
		local nMDData= Get_XParam_INT(1)
		g_RadomIdx = math.floor(nMDData/10000000)
		g_TodayLevelupCount = math.mod(nMDData,100)
		WuhunTupuStudy_Update()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()

	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunTupuStudy_On_ResetPos()
	elseif event == "UNIT_MONEY" then
		WuhunTupuStudy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif event == "MONEYJZ_CHANGE" then 
		WuhunTupuStudy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif event == "PACKAGE_ITEM_CHANGED" then
		WuhunTupuStudy_Update()	
	end
end

function WuhunTupuStudy_InitListBar()	
	if g_InitList == 0 then		
		g_MaxBarNum = DataPool:LuaFnGetWHWGMaxCount()
		for i = 1, g_MaxBarNum do
			local bar = WuhunTupuStudy_Item_Lace:AddChild("WuhunTupuStudy_ItemBK")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("WuhunTupuStudy_Item"):SetEvent("MouseLButtonDown", string.format("WuhunTupuStudy_ItemClicked(%d)", i))
		end	
		g_InitList = 1
	end
end

--刷新
function WuhunTupuStudy_Update()	
	
	WuhunTupuStudy_InitListBar()
	
	WuhunTupuStudy_ListCleanUpAction()
	DataPool:LuaFnInitWHWGList()
	local nCount = DataPool:LuaFnGetWHWGListCount()
	
	for i = 1, g_MaxBarNum do
		WuhunTupuStudy_SetItem(i, nCount)
	end
	
	if g_NeedChangeScrollSize == 1 then		
	--	WuhunTupuStudy_Item_Lace:RefreshLayout()
		WuhunTupuStudy_Item_Lace:SetScrollPosition(0)
		g_NeedChangeScrollSize = 0
	end
	
	WuhunTupuStudy_UpdateSel()
	
	WuhunTupuStudy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	WuhunTupuStudy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function WuhunTupuStudy_UpdateSel()

	if g_CurrentSelWG ~= 0 then

		--图谱名字
		local strName = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
		local strTemp = ScriptGlobal_Format("#{WH_210223_65}", tostring(strName))
		local strText = "#{WH_210223_64}"..strTemp
		WuhunTupuStudy_ItemInfo1:SetText(strText)
		local theAction = EnumAction(g_CurrentSelWG, "whwg")
		if theAction:GetID() ~= 0 then
			WuhunTupuStudy_ItemIcon:SetActionItem(theAction:GetID())
		end

		--本次成功率
		strText = ScriptGlobal_Format("#{WH_210223_167}", g_SuccRadom[g_RadomIdx])
		WuhunTupuStudy_ItemInfo2:SetText(strText)
		--今葼升级次数
		WuhunTupuStudy_ItemInfo3:SetText( ScriptGlobal_Format("#{WH_210223_166}", g_TodayLevelupCount) )

		local nTPGrade = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Grade")
		local nTPLevel = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Level")
		--激活与否
		local nUnLocked = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		if nUnLocked == 0 then
			WuhunTupuStudy_Item_EffectBK:Hide()
			WuhunTupuStudy_EffectNone:SetText("#{WH_210223_88}")
			WuhunTupuStudy_Need_Object_Number:SetText("")
			WuhunTupuStudy_Need_Object:SetActionItem(-1)
			WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")
		else
			if nTPGrade==10 and nTPLevel==10 then
				WuhunTupuStudy_Item_EffectBK:Hide()
				WuhunTupuStudy_EffectNone:SetText("#{WH_210223_89}")
				WuhunTupuStudy_Need_Object_Number:SetText("")
				WuhunTupuStudy_Need_Object:SetActionItem(-1)
				WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")
			elseif nTPLevel==10 then
				WuhunTupuStudy_Item_EffectBK:Hide()
				WuhunTupuStudy_EffectNone:SetText("#{WH_210223_90}")
				WuhunTupuStudy_Need_Object_Number:SetText("")
				WuhunTupuStudy_Need_Object:SetActionItem(-1)
				WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")
			else
				WuhunTupuStudy_Item_EffectBK:Show()
				WuhunTupuStudy_EffectNone:SetText("")
				--
				WuhunTupuStudy_EffectLevel:SetText( ScriptGlobal_Format("#{WH_210223_86}", nTPGrade, nTPLevel) )--"Tr呔c m c b:"..
				--属性
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"AttrEffectYin")
				local wszattr,wszattrvalue = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"wszAttr")
				WuhunTupuStudy_Effect1:SetText(g_strAttrDic[attr_yang].."+"..attrvalue_yang)
				WuhunTupuStudy_Effect2:SetText( ScriptGlobal_Format("#{WH_210223_59}", g_strEffectDic[effecttype_yang],tostring(0.01*effectvalue_yang)) )
				WuhunTupuStudy_Effect3:SetText(g_strAttrDic[attr_yin].."+"..attrvalue_yin)
				WuhunTupuStudy_Effect4:SetText( ScriptGlobal_Format("#{WH_210223_60}", g_strEffectDic[effecttype_yin],tostring(0.01*effectvalue_yin)) )
				WuhunTupuStudy_Effect5:SetText(g_strAttrDic[wszattr].."+"..wszattrvalue)
				--下一级属性
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel+1,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel+1,"AttrEffectYin")
				local wszattr,wszattrvalue = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel+1,"wszAttr")
				WuhunTupuStudy_Effect1Plus:SetText( ScriptGlobal_Format("#{WH_210223_173}", attrvalue_yang) )
				WuhunTupuStudy_Effect2Plus:SetText( ScriptGlobal_Format("#{WH_210223_174}", tostring(0.01*effectvalue_yang)) )
				WuhunTupuStudy_Effect3Plus:SetText( ScriptGlobal_Format("#{WH_210223_173}", attrvalue_yin) )
				WuhunTupuStudy_Effect4Plus:SetText( ScriptGlobal_Format("#{WH_210223_175}", tostring(0.01*effectvalue_yin)) )
				WuhunTupuStudy_Effect5Plus:SetText("+"..wszattrvalue)
				WuhunTupuStudy_EffectLevelPluse:SetText( ScriptGlobal_Format("#{WH_210223_86}", nTPGrade, nTPLevel+1) )--"Th錸g c c b:"..
				--道具
				local need_itembind,need_itemunbind = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItem")
				local need_itemcount = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItemCount")
				local need_money = DataPool:LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelCost")
	
				WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
				
				--有没有道具
				local nHaveCount1 = PlayerPackage:CountAvailableItemByIDTable(need_itembind)
				local nHaveCount2 = PlayerPackage:CountAvailableItemByIDTable(need_itemunbind)
				if nHaveCount1>0 then
					local showAction = DataPool:CreateBindActionItemForShow(need_itembind, 1)
					if showAction:GetID() ~= 0 then
						WuhunTupuStudy_Need_Object:SetActionItem(showAction:GetID())
					end
				else
					local showAction = DataPool:CreateActionItemForShow(need_itemunbind, 1)
					if showAction:GetID() ~= 0 then
						WuhunTupuStudy_Need_Object:SetActionItem(showAction:GetID())
					end
				end
				local szHaveCount = ""
				if nHaveCount1+nHaveCount2 >= need_itemcount then
					szHaveCount = ScriptGlobal_Format("#{WH_210223_127}", need_itemcount)
				else
					szHaveCount = ScriptGlobal_Format("#{WH_210223_70}", need_itemcount)
				end
				WuhunTupuStudy_Need_Object_Number:SetText(szHaveCount)
			end
			
		end
	else
		WuhunTupuStudy_ItemInfo1:SetText("#{WH_210223_64}")
		local strText = ScriptGlobal_Format("#{WH_210223_167}", g_SuccRadom[g_RadomIdx])
		WuhunTupuStudy_ItemInfo2:SetText(strText)
		WuhunTupuStudy_ItemInfo3:SetText( ScriptGlobal_Format("#{WH_210223_166}", g_TodayLevelupCount) )
		WuhunTupuStudy_Item_EffectBK:Hide()
		WuhunTupuStudy_EffectNone:SetText("#{WH_210223_88}")
		WuhunTupuStudy_Need_Object_Number:SetText("")
		WuhunTupuStudy_Need_Object:SetActionItem(-1)
		WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")

		WuhunTupuStudy_ItemIcon:SetActionItem(-1)
		
		WuhunTupuStudy_Need_Object:SetActionItem(-1)
		WuhunTupuStudy_Need_Object_Number:SetText("")
	end
end

function WuhunTupuStudy_SetItem(idx, max_count)

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

	--todo 控件右下角显示已拥有的图谱的等级：%s0/10级 WH_210223_169 ，%s0为当前等级，%s1为下一阶前的等级上限
	--激活锁
	if nUnLocked == 1 then
		bar:GetSubItem("WuhunTupuStudy_Item_Mask"):Hide()
	else
		bar:GetSubItem("WuhunTupuStudy_Item_Mask"):Show()
	end

	local ctrlAction = bar:GetSubItem("WuhunTupuStudy_Item")
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

function WuhunTupuStudy_ItemClicked(nIndex)
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(nIndex - 1)
	if g_CurrentSelWG == wgID then
		return
	end
	
	g_CurrentSelWG = wgID
	
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuStudy_Item")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
				else
					ctrlAction:SetPushed(0)	
				end
			end			
		end
	end
	
	WuhunTupuStudy_UpdateSel()
	
end

function WuhunTupuStudy_UpLevel_Clicked()
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	if g_CurrentSelWG == 0 then
		PushDebugMessage("#{WH_210223_92}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("LevelUpWg")
		Set_XSCRIPT_ScriptID(888800)
		Set_XSCRIPT_Parameter(0, g_CurrentSelWG)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function WuhunTupuStudy_DoCancel()
	WuhunTupuStudy_OnCloseClicked()
end

function WuhunTupuStudy_OnCloseClicked()
	this:Hide()
end

function WuhunTupuStudy_OnHidden()
	g_CurrentSelWG = 0
	WuhunTupuStudy_ListCleanUpAction()
	WuhunTupuStudy_ItemIcon:SetActionItem(-1)
	WuhunTupuStudy_Need_Object:SetActionItem(-1)
end

function WuhunTupuStudy_ListCleanUpAction()	
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then			
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuStudy_Item")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end	
	end
end

function WuhunTupuStudy_On_ResetPos()
	if g_WuhunTupuStudy_UnifiedPosition ~= nil then
		WuhunTupuStudy_Frame:SetProperty("UnifiedPosition", g_WuhunTupuStudy_UnifiedPosition)
	end
end

function WuhunTupuStudy_BeginCareObj(obj_id)	
	m_ObjCared = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(m_ObjCared, 1)
end

function WuhunTupuStudy_Close_Cilcked()
	this:Hide()
end
