
-- 珍兽外观换肤界面

local g_PetExterior_Change_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0
local g_PetExterior_Change_serverNpcId = -1
local g_PetExterior_Change_clientNpcId = -1

local g_PetExterior_Change_CurExteriorSelect = 0
local g_PetExterior_Change_CurSelectPet = -1
local m_PetMaxNumber = 10

local g_PetExterior_MaxBarNum = 100
local g_InitList = 0
local g_PetExterior_BarList = {}
local g_PetExterior_ItemList = {}
local g_PetExterior_PageButton = {}

local g_PetExterior_AttackTraits ={
	[11] = "#{ZSHF_20230705_40}",
	[12] = "#{ZSHF_20230705_41}",
	[13] = "#{ZSHF_20230705_42}",
}
local g_PetExterior_AttackTraitsR ={
	[11] = "#{ZSHF_20230705_137}",	
	[12] = "#{ZSHF_20230705_136}",
	[13] = "#{ZSHF_20230705_138}",
}

local g_PetExterior_AttackTraitsEx ={
	[11] = "#{ZSHF_20230705_99}",
	[12] = "#{ZSHF_20230705_98}",
	[13] = "#{ZSHF_20230705_100}",
}

function PetExterior_Change_PreLoad()
	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")	
	
	this:RegisterEvent("OPEN_PET_EXTERIOR_UI")
	this:RegisterEvent("PET_EXTERIOR_ADD_COLLECTION")
	this:RegisterEvent("PET_EXTERIOR_DEL_COLLECTION")
	this:RegisterEvent("PET_EXTERIOR_COLLECTION_UPDATE")
	this:RegisterEvent("PET_EXTERIOR_CANCEL_COLLECTION")
		
	this:RegisterEvent("UPDATE_PET_PAGE")
	this:RegisterEvent("ADD_PET")
	this:RegisterEvent("DELETE_PET")
		
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
end

function PetExterior_Change_OnLoad()

    g_PetExterior_Change_UnifiedPosition = PetExterior_Change_Frame:GetProperty("UnifiedPosition");	
	
	g_PetExterior_PageButton = {PetExterior_Change_Page1, PetExterior_Change_Page2, PetExterior_Change_Page3, PetExterior_Change_Page4}

end

function PetExterior_Change_OnEvent(event)
	
	if event == "OPEN_PET_EXTERIOR_UI" then

		if this:IsVisible() then
			return
		end
		
		g_PetExterior_Change_serverNpcId = tonumber(arg0)
		local PetGuidH = tonumber(arg1)
		local PetGuidL = tonumber(arg2)
		
		if g_PetExterior_Change_serverNpcId >= 0 then
			g_PetExterior_Change_clientNpcId = Target:GetServerId2ClientId(g_PetExterior_Change_serverNpcId)
			if (g_PetExterior_Change_clientNpcId ~= -1) then
				this:CareObject(g_PetExterior_Change_clientNpcId, 1, "PetExterior_Change")
			end
		end
				
		this:Show()		
		PetExterior_Change_Show()	
		
		local nExteriorId = -1
		if PetGuidH > 0 and PetGuidL > 0 then
			local nIndex = Pet:GetPetIndexByGUID( PetGuidH, PetGuidL )
			if nIndex ~= nil and nIndex ~= -1 then
				if g_PetExterior_Change_CurSelectPet ~= nIndex then	
					g_PetExterior_Change_CurSelectPet = nIndex
					PetExterior_Change_UpdateListItem(g_PetExterior_Change_CurSelectPet)
					PetExterior_Change_OnUpdatePetAtt()					
				end
			end
			local nExteriorId = Pet:Lua_GetPetExteriorChangeDataByGuid( PetGuidH, PetGuidL )
			if nExteriorId == nil then
				nExteriorId = -1
			end
		end
				
		PetExterior_Change_Update(nExteriorId, -1)
		
		if(IsWindowShow("PetExterior_Gain")) then
			CloseWindow("PetExterior_Gain", true)
		end
		
		return

	end

	if ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		PetExterior_Change_CareObj(arg0,arg1,arg2)
	end
		
	if event == "PET_EXTERIOR_ADD_COLLECTION"  then
	-- 新增珍兽形貌	
		local PetExteriorId = tonumber(arg0)
		if this:IsVisible() then
			PetExterior_Change_Update(PetExteriorId, -1)
			
			PetExterior_Change_FakeObject:SetFakeObject("")
			Pet:Lua_UpdatePetExteriorModel(PetExteriorId)
			PetExterior_Change_FakeObject:SetFakeObject("Pet_Exterior")
			return
		end
		
	end
		
	if event == "PET_EXTERIOR_DEL_COLLECTION"  then
	-- 删除珍兽形貌		
		local PetExteriorId = tonumber(arg0)
		if this:IsVisible() then
			PetExterior_Change_Update(-1, -1)
			return
		end
		
	end

	if event == "PET_EXTERIOR_CANCEL_COLLECTION"  then
		if this:IsVisible() then	
			g_PetExterior_Change_CurExteriorSelect = -1
		end
	end

	if event == "PET_EXTERIOR_COLLECTION_UPDATE"  then
		if this:IsVisible() then		
			--PetExterior_Change_UpdatePetList()
			--PetExterior_Change_UpdateListItem(pHID , pLID)
			--PetExterior_Change_Update(-1, -1)
		end
	end

	-- 更新珍兽
	if event == "UPDATE_PET_PAGE" and this:IsVisible() then
		PetExterior_Change_UpdatePetList()
		local nExteriorId = -1
		if g_PetExterior_ItemList[g_PetExterior_Change_CurExteriorSelect] ~= nil then
			nExteriorId = g_PetExterior_ItemList[g_PetExterior_Change_CurExteriorSelect].nExteriorID
		end
		PetExterior_Change_UpdateListItem(g_PetExterior_Change_CurSelectPet)	
		PetExterior_Change_Update(nExteriorId, -1)
		return		
	end
	
	if event == "ADD_PET" or event == "DELETE_PET" then
		if this:IsVisible() then  
			PetExterior_Change_Close_Window()
		end
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then	
		PetExterior_Change_Frame_On_ResetPos()
		return		
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then	
		PetExterior_Change_Close_Window()
		return
	end

end

function PetExterior_Change_Show()
	
	PetExterior_Change_Reset()

	-- 初始化格子
	PetExterior_Change_InitList()
	
	-- 初始化珍兽列表
	PetExterior_Change_UpdatePetList()		
	
end

function PetExterior_Change_InitList()
	
	if g_InitList == 0 then		
		for i = 1, g_PetExterior_MaxBarNum do
			local bar = PetExterior_Change_SkinList:AddChild("PetExterior_Change_SkinList_Clent")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			
			bar:GetSubItem("PetExterior_Change_SkinList_Item"):SetEvent("MouseLButtonDown", string.format("PetExterior_Change_ItemClicked(%d)", i))
			bar:GetSubItem("PetExterior_Change_SkinList_Item"):SetProperty("Empty", "False")
			bar:GetSubItem("PetExterior_Change_SkinList_Item"):SetProperty("UseDefaultTooltip", "True")
			
			bar:GetSubItem("PetExterior_Change_SkinList_Item_Tips1"):Hide()
			bar:GetSubItem("PetExterior_Change_SkinList_Item_Tips2"):Hide()
			bar:GetSubItem("PetExterior_Change_SkinList_ItemRed"):Hide()
			bar:GetSubItem("PetExterior_Change_SkinList_ItemNew"):Hide()
			
			bar:GetSubItem("PetExterior_Change_SkinList_ItemBK"):SetProperty("Image", "set:Ach image:Ach_AchIconBack")
			
			table.insert(g_PetExterior_BarList, bar)
			table.insert(g_PetExterior_ItemList, {})
		end		
		g_InitList = 1
	end
	
	Pet:Lua_InitPetExteriorList()
	
end

function PetExterior_Change_InitData(theAttackType)

	Pet:Lua_SortPetExteriorList(g_PetExterior_Change_CurSelectPet)
	
	local nPetIdx = 1
	local Exterior_Count = 0
	local nCount = Pet:Lua_GetPetExteriorListCount()
	for i = 0, nCount - 1 do	
		local nPetExteriorId = Pet:Lua_GetPetExteriorInfoFromList(i, "Id")	
		local nPetModelId = Pet:Lua_GetPetExteriorInfoFromList(i, "ModelId")	
		if Pet:Lua_IsHavePetExteriorCollection(nPetExteriorId) == 1 and nPetIdx <= g_PetExterior_MaxBarNum then			
			Exterior_Count = Exterior_Count + 1			
			local Attack_Type = Pet:Lua_GetPetExteriorInfo(nPetExteriorId, "Attack")			
			if theAttackType <= 0 then				
				g_PetExterior_ItemList[nPetIdx].nExteriorID = nPetExteriorId
				g_PetExterior_ItemList[nPetIdx].nModelId = nPetModelId
				
				nPetIdx = nPetIdx + 1
			elseif theAttackType > 0 and Attack_Type == theAttackType then
				g_PetExterior_ItemList[nPetIdx].nExteriorID = nPetExteriorId
				g_PetExterior_ItemList[nPetIdx].nModelId = nPetModelId
				
				nPetIdx = nPetIdx + 1
			end
		end
	end
	
	local str = ScriptGlobal_Format("#{ZSHF_20230705_113}", Exterior_Count)
	PetExterior_Change_SkinListTitle:SetText(str)
	
	if nPetIdx <= g_PetExterior_MaxBarNum then
		for i = nPetIdx, g_PetExterior_MaxBarNum do
			g_PetExterior_ItemList[i].nExteriorID = -1
			g_PetExterior_ItemList[i].nModelId = -1
		end
	end
	
end

function PetExterior_Change_Update(Exterior_Id, Attack_Type)

	PetExterior_Change_InitData(Attack_Type)
	
	PetExterior_Change_Page_Switch(Attack_Type)
		
	if g_PetExterior_MaxBarNum > 0 then
		
		g_PetExterior_Change_CurExteriorSelect = -1
		
		for i = 1 , g_PetExterior_MaxBarNum do		
			
			PetExterior_Change_AddItem(i, Exterior_Id, Attack_Type)
		
		end
		
		PetExterior_Change_SkinList:RefreshLayout()
		PetExterior_Change_SkinList:SetScrollPosition(0)
		
		PetExterior_Change_SetItemSelected(g_PetExterior_Change_CurExteriorSelect)
		
		PetExterior_Change_OnUpdateExteriorAtt()		
		PetExterior_Change_OnUpdatePetAtt()
	end
		
	PetExterior_Change_RemoveTip(g_PetExterior_Change_CurExteriorSelect)
	
end

function PetExterior_Change_AddItem(index, Exterior_Id, theAttackType)

	if g_PetExterior_BarList[index] == nil then
		return
	end
	
	if g_PetExterior_ItemList[index] == nil then
		return
	end
	
	if index > g_PetExterior_MaxBarNum then
		g_PetExterior_BarList[index]:Hide()
		return
	end
	
	local bar = g_PetExterior_BarList[index]
	local nExteriorID = g_PetExterior_ItemList[index].nExteriorID
	
	bar:Show()	
	
	local nTakeLevel = Pet:Lua_GetPetExteriorInfo(nExteriorID, "TakeLevel")
	local Attack_Type = Pet:Lua_GetPetExteriorInfo(nExteriorID, "Attack")
	local ctrlAction = bar:GetSubItem("PetExterior_Change_SkinList_Item")
	if ctrlAction ~= nil then
		local iconFile = Pet:Lua_GetPetExteriorInfo(nExteriorID, "Icon")
		if iconFile ~= nil then
			ctrlAction:SetProperty("NormalImage", iconFile)
			ctrlAction:SetProperty("HoverImage", iconFile)
			bar:GetSubItem("PetExterior_Change_SkinList_ItemBK"):SetProperty("Image", "set:Ach image:Ach_AchIconBack")
		else
			ctrlAction:SetProperty("NormalImage", "")
			ctrlAction:SetProperty("HoverImage", "")
			bar:GetSubItem("PetExterior_Change_SkinList_ItemBK"):SetProperty("Image", "")
		end
			
		local nExName = Pet:Lua_GetPetExteriorInfo(nExteriorID, "Name")
		local nExText = Pet:Lua_GetPetExteriorInfo(nExteriorID, "ExText")
		if nExText ~= nil and nExName ~= nil then	
			if Attack_Type ~= nil and g_PetExterior_AttackTraitsEx[Attack_Type] ~= nil then
				local attstr = ScriptGlobal_Format("#{ZSHF_20230705_97}", g_PetExterior_AttackTraitsEx[Attack_Type])
				nExText = nExText.."#r"..attstr
			end
			
			local tipsstr = ScriptGlobal_Format("#{ZSHF_20230705_134}", nExName)
			tipsstr = tipsstr..nExText
			
			if nTakeLevel ~= nil then
				tipsstr = tipsstr.."#r"..ScriptGlobal_Format("#{ZSHF_20230705_151}", nTakeLevel)
			end
			ctrlAction:SetToolTip(tipsstr)
		else
			ctrlAction:SetToolTip("")
		end
	end
	
	-- 已选
	bar:GetSubItem("PetExterior_Change_SkinList_Item_Tips1"):Hide()
	if nExteriorID > 0 and g_PetExterior_Change_CurSelectPet ~= -1 then
		local nPetExteriorID = Pet:Lua_GetPetExteriorChangeDataByPetIdx(g_PetExterior_Change_CurSelectPet)
		if nPetExteriorID ~= nil and nExteriorID == nPetExteriorID then
			-- 当前选择的珍兽占用了这个外观
			bar:GetSubItem("PetExterior_Change_SkinList_Item_Tips1"):Show()
		end
	end
	
	-- 试穿
	bar:GetSubItem("PetExterior_Change_SkinList_Item_Tips2"):Hide()
	
	-- 新
	local nExteriorTips = Pet:Lua_GetPetExteriorChangeDataTips(nExteriorID)
	if nExteriorTips == 1 then
		bar:GetSubItem("PetExterior_Change_SkinList_ItemNew"):Show()
	else
		bar:GetSubItem("PetExterior_Change_SkinList_ItemNew"):Hide()
	end
	
	-- 携带等级
	bar:GetSubItem("PetExterior_Change_SkinList_ItemLevel"):SetText("")
	if nTakeLevel ~= nil then
		local str = "#e010101#gffffff"..nTakeLevel
		bar:GetSubItem("PetExterior_Change_SkinList_ItemLevel"):SetText(str)
	end
	
	-- 蒙红
	--bar:GetSubItem("PetExterior_Change_SkinList_ItemRed"):Hide()
	--if g_PetExterior_Change_CurSelectPet ~= -1 then
	--	local Pet_Attack_Type = Pet:Lua_GetPetExteriorAttackTrait(g_PetExterior_Change_CurSelectPet)
	--	if Attack_Type ~= nil and Pet_Attack_Type ~= Attack_Type then
	--		bar:GetSubItem("PetExterior_Change_SkinList_ItemRed"):Show()
	--	end
	--end
			
	local nPetExterior_ChangeId = Pet:Lua_GetPetExteriorInfoFromList(index-1, "Id")			
	if nPetExterior_ChangeId == Exterior_Id then
		g_PetExterior_Change_CurExteriorSelect = index
	end

end

function PetExterior_Change_ItemClicked(nIndex)
	
	if g_PetExterior_ItemList[nIndex] == nil then
		return
	end
	
	if g_PetExterior_ItemList[nIndex].nExteriorID <= 0 then
		return
	end
		
	if g_PetExterior_Change_CurExteriorSelect ~= nIndex then
			
		g_PetExterior_Change_CurExteriorSelect = nIndex
		
		PetExterior_Change_SetItemSelected(nIndex)
		
		PetExterior_Change_OnUpdateExteriorAtt()		
		PetExterior_Change_OnUpdatePetAtt()
		
		PetExterior_Change_RemoveTip(g_PetExterior_Change_CurExteriorSelect)
		
	else
		
		g_PetExterior_Change_CurExteriorSelect = -1		
		PetExterior_Change_SetItemSelected(-1)
		PetExterior_Change_PetData2:SetText("")
		PetExterior_Change_Pet_BianYi:SetText("")
		PetExterior_Change_Pet_Name:SetText("")
		
		PetExterior_Change_FakeObject:SetFakeObject("")	
		
		PetExterior_Change_OnUpdateExteriorAtt()			
		PetExterior_Change_OnUpdatePetAtt()
		
	end

end

function PetExterior_Change_SetItemSelected(nIndex)

	for i = 1, g_PetExterior_MaxBarNum do		
		if g_PetExterior_BarList[i] ~= nil then	
			local ctrlAction = g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_Item")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					
					g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_Item_Tips2"):Show()
					
					if g_PetExterior_ItemList[nIndex] ~= nil and g_PetExterior_ItemList[nIndex].nExteriorID > 0 and g_PetExterior_Change_CurSelectPet ~= -1 then
						local nPetExteriorID = Pet:Lua_GetPetExteriorChangeDataByPetIdx(g_PetExterior_Change_CurSelectPet)
						if nPetExteriorID ~= nil and g_PetExterior_ItemList[nIndex].nExteriorID == nPetExteriorID then
							-- 当前选择的珍兽占用了这个外观
							g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_Item_Tips2"):Hide()
						end
					end
				else
					ctrlAction:SetPushed(0)	
					
					g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_Item_Tips2"):Hide()
				end
			end
		end
	end
	
end

function PetExterior_Change_OnUpdateExteriorAtt()
			
	if g_PetExterior_Change_CurExteriorSelect > 0 then
	
		local nIndex = g_PetExterior_Change_CurExteriorSelect
		
		PetExterior_Change_FakeObject:SetFakeObject("")
		
		if g_PetExterior_ItemList[nIndex] ~= nil and g_PetExterior_ItemList[nIndex].nExteriorID > 0 then
			local nPetAttackId = Pet:Lua_GetPetExteriorInfo(g_PetExterior_ItemList[nIndex].nExteriorID, "Attack")
			if g_PetExterior_AttackTraits[nPetAttackId] ~= nil then
				local AttackStr = g_PetExterior_AttackTraits[nPetAttackId]				
				if g_PetExterior_Change_CurSelectPet >= 0 then
					local Pet_Attack_Type = Pet:Lua_GetPetExteriorAttackTrait(g_PetExterior_Change_CurSelectPet)
					if nPetAttackId ~= Pet_Attack_Type then
						AttackStr = g_PetExterior_AttackTraitsR[nPetAttackId]
					end
				end
				PetExterior_Change_PetData2:SetText(AttackStr)
			else
				PetExterior_Change_PetData2:SetText("")
			end	
					
			local nExName = Pet:Lua_GetPetExteriorInfo(g_PetExterior_ItemList[nIndex].nExteriorID, "Name")
			if nExName ~= nil then	
				local namestr = ScriptGlobal_Format("#{ZSHF_20230705_134}", nExName)
				PetExterior_Change_Pet_Name:SetText(namestr)
			else
				PetExterior_Change_Pet_Name:SetText("")
			end
					
			local nExText = Pet:Lua_GetPetExteriorInfo(g_PetExterior_ItemList[nIndex].nExteriorID, "ExText")
			if nExText ~= nil then	
				PetExterior_Change_Pet_BianYi:SetText(nExText)
			else
				PetExterior_Change_Pet_BianYi:SetText("")
			end
			
			Pet:Lua_UpdatePetExteriorModel(g_PetExterior_ItemList[nIndex].nExteriorID)
			PetExterior_Change_FakeObject:SetFakeObject("Pet_Exterior")
			
			--PetExterior_Change_Pet_Show:SetText("#{ZSHF_20230705_132}")
			
			if g_PetExterior_Change_CurSelectPet ~= -1 then
				local nPetExteriorID = Pet:Lua_GetPetExteriorChangeDataByPetIdx(g_PetExterior_Change_CurSelectPet)
				if nPetExteriorID ~= nil and g_PetExterior_ItemList[nIndex].nExteriorID == nPetExteriorID then
					-- 当前选择的珍兽占用了这个外观
					--PetExterior_Change_Pet_Show:SetText("#{ZSHF_20230705_133}")
				end
			end
		end
		
	else
		PetExterior_Change_PetData2:SetText("")
		PetExterior_Change_Pet_BianYi:SetText("")
		PetExterior_Change_Pet_Name:SetText("")
		
		PetExterior_Change_FakeObject:SetFakeObject("")
		
		PetExterior_Change_UpdateListItem(g_PetExterior_Change_CurSelectPet)	
	end
	
end

--*************************************************
--珍兽下拉菜单
--*************************************************
function PetExterior_Change_UpdatePetList()

	PetExterior_Change_Choose_Select:ResetList()
	
	local nPetCount = Pet:GetPet_Count()
	if nPetCount > 0 then		
		for	i = 1, 10 do		
			if Pet:IsPresent(i-1) then				
				
				local szPetName = Pet:GetPetList_Appoint(i-1)				
				local nChangeId = Pet:Lua_GetPetExteriorChangeDataByPetIdx(i-1)
				
				if nChangeId < 0 then
					if Pet:GetIsFighting(i-1) then					
						PetExterior_Change_Choose_Select:AddTextItem("#c0A9605"..szPetName, i-1)
					elseif (Pet:GetIsPossession(i-1)) then					
						PetExterior_Change_Choose_Select:AddTextItem("#c996699"..szPetName, i-1)						
					else					
						PetExterior_Change_Choose_Select:AddTextItem(szPetName, i-1)					
					end
				else				
					szPetName = szPetName.."#{ZSHF_20230705_112}"
					
					if Pet:GetIsFighting(i-1) then					
						PetExterior_Change_Choose_Select:AddTextItem("#c0A9605"..szPetName, i-1)
					elseif Pet:GetIsPossession(i-1) then					
						PetExterior_Change_Choose_Select:AddTextItem("#c996699"..szPetName, i-1)						
					else					
						PetExterior_Change_Choose_Select:AddTextItem(szPetName, i-1)					
					end
				end

			end
		end
	end
end

function PetExterior_Change_UpdateListItem(pet_index)	
		
	if pet_index ~= nil and pet_index >= 0 then			
		if Pet:IsPresent(pet_index) then			
			local szPetName = Pet:GetPetList_Appoint(pet_index)			
			local nChangeId = Pet:Lua_GetPetExteriorChangeDataByPetIdx(pet_index)		
			if nChangeId >= 0 then						
				szPetName = szPetName.."#{ZSHF_20230705_112}"
				--PetExterior_Change_Pet_Show:SetText("#{ZSHF_20230705_133}")
			else
				--PetExterior_Change_Pet_Show:SetText("#{ZSHF_20230705_131}")
			end						
			local szText = szPetName						
			if Pet:GetIsFighting(pet_index) then
				szText = "#c0A9605"..szPetName
			elseif Pet:GetIsPossession(pet_index) then
				szText = "#c996699"..szPetName					
			end
						
			if g_PetExterior_Change_CurSelectPet == pet_index then
				PetExterior_Change_Choose_Select:SetText(szText)
			end	
		
			PetExterior_Change_FakeObject:SetFakeObject("")
			Pet:Lua_UpdatePetExteriorModelByPetIdx(pet_index)
			PetExterior_Change_FakeObject:SetFakeObject("Pet_Exterior")
						
		end
	end	
	
end

-- 选中珍兽
function PetExterior_Change_OnSelectPet()

	local _,nIndex = PetExterior_Change_Choose_Select:GetCurrentSelect()
	
	if g_PetExterior_Change_CurSelectPet ~= nIndex then
	
		g_PetExterior_Change_CurSelectPet = nIndex
		
		local nExteriorId = Pet:Lua_GetPetExteriorChangeDataByPetIdx( nIndex )
		if nExteriorId == nil then
			nExteriorId = -1
		end
		PetExterior_Change_Update(-1, -1)
		
		PetExterior_Change_OnUpdatePetAtt()
	end
	
end

function PetExterior_Change_OnUpdatePetAtt()
		
	-- 设置所选珍兽的类型
	local Pet_Attack_Type = Pet:Lua_GetPetExteriorAttackTrait(g_PetExterior_Change_CurSelectPet)
	if g_PetExterior_AttackTraits[Pet_Attack_Type] ~= nil and g_PetExterior_AttackTraitsR[Pet_Attack_Type] ~= nil then
		local AttackStr = g_PetExterior_AttackTraits[Pet_Attack_Type]
		PetExterior_Change_PetData1:SetText(AttackStr)
	else
		PetExterior_Change_PetData1:SetText("")
	end
		
end

-- 删除新字
function PetExterior_Change_RemoveTip(nIndex)
	
	if g_PetExterior_ItemList[nIndex] == nil then
		return
	end

	local CurSelExteriorID = g_PetExterior_ItemList[nIndex].nExteriorID
	local nTip = Pet:Lua_GetPetExteriorChangeDataTips(CurSelExteriorID)
	if nTip == 1 then
		Pet:Lua_RemovePetExteriorChangeDataTips(CurSelExteriorID)
		for i = 1, g_PetExterior_MaxBarNum do
			if g_PetExterior_BarList[i] and g_PetExterior_ItemList[i] then		
				local nExteriorID = g_PetExterior_ItemList[i].nExteriorID	
				if Pet:Lua_GetPetExteriorChangeDataTips(nExteriorID) == 1 then
					g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_ItemNew"):Show()
				else
					g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_ItemNew"):Hide()
				end
			end
		end	
	end
	
end

function PetExterior_Change_Page_Switch(Attack_Type)

	if Attack_Type <= 0 then
		g_PetExterior_PageButton[1]:SetCheck(1)
		g_PetExterior_PageButton[2]:SetCheck(0)
		g_PetExterior_PageButton[3]:SetCheck(0)
		g_PetExterior_PageButton[4]:SetCheck(0)
	elseif Attack_Type == 11 then
		g_PetExterior_PageButton[1]:SetCheck(0)
		g_PetExterior_PageButton[2]:SetCheck(1)
		g_PetExterior_PageButton[3]:SetCheck(0)
		g_PetExterior_PageButton[4]:SetCheck(0)
	elseif Attack_Type == 12 then
		g_PetExterior_PageButton[1]:SetCheck(0)
		g_PetExterior_PageButton[2]:SetCheck(0)
		g_PetExterior_PageButton[3]:SetCheck(1)
		g_PetExterior_PageButton[4]:SetCheck(0)
	elseif Attack_Type == 13 then
		g_PetExterior_PageButton[1]:SetCheck(0)
		g_PetExterior_PageButton[2]:SetCheck(0)
		g_PetExterior_PageButton[3]:SetCheck(0)
		g_PetExterior_PageButton[4]:SetCheck(1)
	else
		return
	end
	
end

function PetExterior_Change_Page_Clicked(Attack_Type)
	
	PetExterior_Change_ResetBar()
	
	PetExterior_Change_Update(-1, Attack_Type)
	
end

function PetExterior_Change_Reset()
	
	-- 清空图鉴选中
	g_PetExterior_Change_CurExteriorSelect = -1
	
	PetExterior_Change_FakeObject:SetFakeObject( "" )
	
	-- 清空珍兽列表
	PetExterior_Change_Choose_Select:ResetList()
	PetExterior_Change_Choose_Select:SetText("")
	
	PetExterior_Change_PetData1:SetText("")
	PetExterior_Change_PetData2:SetText("")
	PetExterior_Change_Pet_BianYi:SetText("")
	PetExterior_Change_Pet_Name:SetText("")
	
	g_PetExterior_Change_CurSelectPet = -1
	
	PetExterior_Change_SetItemSelected(-1)
	
end

function PetExterior_Change_OK_Clicked()

	if g_PetExterior_Change_CurSelectPet < 0 then
		PushDebugMessage("#{ZSHF_20230705_45}")
		return
	end
	
	if g_PetExterior_Change_CurExteriorSelect <= 0 then
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end
	
	if g_PetExterior_ItemList[g_PetExterior_Change_CurExteriorSelect] == nil then
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end
	
	local nSelExteriorID = g_PetExterior_ItemList[g_PetExterior_Change_CurExteriorSelect].nExteriorID
	if nSelExteriorID <= 0 then
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end
	
	if Pet:Lua_IsHavePetExteriorCollection(nSelExteriorID) ~= 1 then	
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end	

	if not Pet:IsPresent(g_PetExterior_Change_CurSelectPet) then
		return
	end

	--是否幻化
	local gen = Pet:GetType(g_PetExterior_Change_CurSelectPet)
	if gen == nil or gen < 100 then	--100以上为幻化珍兽
		PushDebugMessage("#{ZSHF_20230705_50}")
		return 0
	end
	
	local strName,strName2 = Pet:GetName(g_PetExterior_Change_CurSelectPet)
	local msg = ""
	--出战
	if Pet:GetIsFighting(g_PetExterior_Change_CurSelectPet) then
		msg = ScriptGlobal_Format("#{ZSHF_20230705_60}",strName2)
		PushDebugMessage(msg)
		return	
	end
	
	--附体
	if Pet:GetIsPossession(g_PetExterior_Change_CurSelectPet) then
		msg = ScriptGlobal_Format("#{ZSHF_20230705_61}",strName2)
		PushDebugMessage(msg)
		return	
	end

	local hid,lid = Pet:GetGUID(g_PetExterior_Change_CurSelectPet);
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998478)
		Set_XSCRIPT_Function_Name("OnChangePetExterior")
		Set_XSCRIPT_Parameter(0, hid)
		Set_XSCRIPT_Parameter(1, lid)
		Set_XSCRIPT_Parameter(2, nSelExteriorID)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()

end

function PetExterior_Change_Cancel_Clicked()

	if g_PetExterior_Change_CurSelectPet < 0 then
		PushDebugMessage("#{ZSHF_20230705_49}")
		return
	end	
	
	if not Pet:IsPresent(g_PetExterior_Change_CurSelectPet) then
		return
	end
	
	local strName,strName2 = Pet:GetName(g_PetExterior_Change_CurSelectPet)
	local msg = ""	
	--出战
	if Pet:GetIsFighting(g_PetExterior_Change_CurSelectPet) then
		msg = ScriptGlobal_Format("#{ZSHF_20230705_65}",strName2)
		PushDebugMessage(msg)
		return	
	end
	
	--附体
	if Pet:GetIsPossession(g_PetExterior_Change_CurSelectPet) then
		msg = ScriptGlobal_Format("#{ZSHF_20230705_66}",strName2)
		PushDebugMessage(msg)
		return	
	end
	
	local hid,lid = Pet:GetGUID(g_PetExterior_Change_CurSelectPet);
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998478)
		Set_XSCRIPT_Function_Name("CancelChangePetExterior")
		Set_XSCRIPT_Parameter(0, hid)
		Set_XSCRIPT_Parameter(1, lid)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--*************************************************
--删除皮肤
--*************************************************
function PetExterior_Change_Delete_Clicked()
	
	if g_PetExterior_Change_CurExteriorSelect <= 0 then
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end
	
	if g_PetExterior_ItemList[g_PetExterior_Change_CurExteriorSelect] == nil then
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end

	local nPetExterior_ChangeId = g_PetExterior_ItemList[g_PetExterior_Change_CurExteriorSelect].nExteriorID
	if nPetExterior_ChangeId <= 0 then
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end
	
	if Pet:Lua_IsHavePetExteriorCollection(nPetExterior_ChangeId) ~= 1 then	
		PushDebugMessage("#{ZSHF_20230705_47}")
		return
	end	
	
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998478)
		Set_XSCRIPT_Function_Name("OnDeletePetExterior")
		Set_XSCRIPT_Parameter(0, nPetExterior_ChangeId)
		Set_XSCRIPT_Parameter(1, 1)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
end

--*************************************************
--前往拓形
--*************************************************
function PetExterior_Change_Goto_Clicked()

	AutoRuntoTargetExWithName(262, 131, 2, "云绾绾")
	
end

--*************************************************
--向左旋转珍兽
--*************************************************
function PetExterior_Change_Pet_Modle_TurnLeft(start)

	--向左旋转开始
	if(start == 1) then
		PetExterior_Change_FakeObject:RotateBegin(-0.3)
	--向左旋转结束
	else
		PetExterior_Change_FakeObject:RotateEnd()
	end
	
end

--*************************************************
--向右旋转珍兽
--*************************************************
function PetExterior_Change_Pet_Modle_TurnRight(start)

	--向右旋转开始
	if(start == 1) then
		PetExterior_Change_FakeObject:RotateBegin(0.3)
	--向右旋转结束
	else
		PetExterior_Change_FakeObject:RotateEnd()
	end
	
end

function PetExterior_Change_Close_Window()

	this:Hide()

end

function PetExterior_Change_ResetBar()
	
	for i = 1, g_PetExterior_MaxBarNum do
		if g_PetExterior_BarList[i] then
			local ctrlAction = g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_Item")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
			g_PetExterior_BarList[i]:GetSubItem("PetExterior_Change_SkinList_ItemLevel"):SetText("")
		end
	end
	
end

function PetExterior_Change_OnHidden()

	if (g_PetExterior_Change_clientNpcId ~= -1) then
		this:CareObject(g_PetExterior_Change_clientNpcId, 0, "PetExterior_Change")
	end

	PetExterior_Change_Reset()
	
	PetExterior_Change_ResetBar()

end

--*************************************************
--关心NPC
--*************************************************
function PetExterior_Change_CareObj(careId, op, distance)
	
	if(nil == careId or nil == op or nil == distance) then
		return
	end

	if(tonumber(careId) ~= g_PetExterior_Change_clientNpcId) then
		return
	end

	if (op == "distance" and tonumber(distance) > MAX_OBJ_DISTANCE or op == "destroy") then
		PetExterior_Change_OnHidden()
	end
	
end

function PetExterior_Change_Frame_On_ResetPos()

	PetExterior_Change_Frame:SetProperty("UnifiedPosition", g_PetExterior_Change_UnifiedPosition);
	
end




