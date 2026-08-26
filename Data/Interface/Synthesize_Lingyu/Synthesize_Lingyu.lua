--!!!reloadscript =Synthesize_Lingyu

-- 界面的默认相对位置
local g_Synthesize_Lingyu_Frame_UnifiedXPosition
local g_Synthesize_Lingyu_Frame_UnifiedYPosition

local g_Current_Ability = 0
local g_Special_Item_BagIndex = -1

local g_Recipe_Group_Outlining = {1, 1}

local g_Recipe_Group = {
	[1] = {31},
	[2] = {32},
	[3] = {33},
}

local g_UI_Index = 0
local g_CurrentRecipe = 0
local g_CurrentRecipeShow = 0

local g_YuPei_ItemIndex = {20600000, 20600001, 20600002, 20600003, 20600004}

function Synthesize_Lingyu_PreLoad()
	this:RegisterEvent("LINGYU_COMPOSE")
	this:RegisterEvent("OPEN_COMPOSE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("BAG_ITEM_DRAGDROP_TO_UI")
	this:RegisterEvent("BAG_ITEM_RBCLICK_TO_UI")
	this:RegisterEvent("BAG_ITEM_DRAGAWAY_FROM_UI")
	this:RegisterEvent("UPDATE_TODAY_LINGYU_DOTIMES")
end

function Synthesize_Lingyu_OnLoad()
	g_Synthesize_Lingyu_Frame_UnifiedXPosition = Synthesize_Lingyu_Frame:GetProperty("UnifiedXPosition")
	g_Synthesize_Lingyu_Frame_UnifiedYPosition = Synthesize_Lingyu_Frame:GetProperty("UnifiedYPosition")
end

function Synthesize_Lingyu_OnEvent(event)

	if event == "LINGYU_COMPOSE" then
		local my_gid = DataPool:LuaFnGetMD(854)
		if tonumber(arg0) == 54 and my_gid ~= 1 then
			PushDebugMessage("#{SZXT_221216_204}")
			return
		elseif tonumber(arg0) == 55 and my_gid ~= 2 then
			PushDebugMessage("#{SZXT_221216_205}")
			return
		elseif tonumber(arg0) == 56 and my_gid ~= 3 then
			PushDebugMessage("#{SZXT_221216_206}")
			return
		end
	
		if g_Current_Ability ~= tonumber(arg0) then
			if this:IsVisible() then
				Synthesize_Lingyu_OnHidden()
				g_Current_Ability = tonumber(arg0)
				Synthesize_Lingyu_OnShown()
			else
				g_Current_Ability = tonumber(arg0)
				this:Show()
			end
			Synthesize_Lingyu_Update()
		else
			this:Hide()
		end
		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Synthesize_Lingyu_UpdateItem()
		Synthesize_Lingyu_ItemCheck()
		Synthesize_Lingyu_UpdateInfo()
		return
	elseif event == "OPEN_COMPOSE_GEM" then
		this:Hide()
		return
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Synthesize_Lingyu_Frame_On_ResetPos()
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == 35 and tonumber(arg1) ~= nil then
			Synthesize_Lingyu_OnItemDragedDropFromBag(tonumber(arg1))
		end
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Synthesize_Lingyu" and tonumber(arg0) ~= nil then
			Synthesize_Lingyu_OnBagItemRClicked(tonumber(arg0))
		end
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == 35 then
			Synthesize_Lingyu_OnItemDragedDropAway()
		end
	end
	
	if event == "UPDATE_TODAY_LINGYU_DOTIMES" and this:IsVisible() then
		local iTimes = Player:GetData("LYDOTIME")	
		local strTemp = ScriptGlobal_Format("#{SZXT_221216_90}", tostring(iTimes))
		Synthesize_Lingyu_SpecialMaterial_Text:SetText(strTemp)
	end
end

function Synthesize_Lingyu_OnShown()
	if g_Current_Ability == 54 then
		g_UI_Index = 1
	elseif g_Current_Ability == 55 then
		g_UI_Index = 2
	elseif g_Current_Ability == 56 then
		g_UI_Index = 3
	end
end

function Synthesize_Lingyu_Update()
	Synthesize_Lingyu_UpdateList()
	Synthesize_Lingyu_UpdateInfo()
	
	local iTimes = Player:GetData("LYDOTIME")	
	local strTemp = ScriptGlobal_Format("#{SZXT_221216_90}", tostring(iTimes))
	Synthesize_Lingyu_SpecialMaterial_Text:SetText(strTemp)

end

function Synthesize_Lingyu_UpdateList()

	local strTemp = ""
	Synthesize_Lingyu_Item_List:ClearListBox()
	
	local nPrescrNum = DataPool:GetPrescrList_Num()
	
	g_CurrentRecipeShow = 0
	
	for j = 1, 1 do
		local bAddGroup = 0
		local now_group = g_Recipe_Group[g_UI_Index][j]
		for	i = 1, nPrescrNum do
			local nPrescr = LifeAbility:GetPrescrList_Item_FromNum(i - 1)
			local need_ability, group = DataPool:GetPrescrList_Item_LifeAbility(nPrescr)
			if need_ability == g_Current_Ability and group == now_group then
				if g_Recipe_Group_Outlining[j] == 1 then
					
					if bAddGroup == 0 then
						local str = "- #gFE7E82" .. LifeAbility:GetPrescription_Kind(now_group)
						Synthesize_Lingyu_Item_List:AddItem(str, 10000 + j)
						bAddGroup = 1
					end

					local szPrescrName = DataPool:GetPrescrList_Item(nPrescr)
					local nLevel = DataPool:GetPrescrList_Item_LifeAbilityLevel(nPrescr)
					local nMaxAmount = LifeAbility:GetPrescr_Item_Maximum(nPrescr)

					if nMaxAmount > 0 then
						szPrescrName = szPrescrName.."[".. nMaxAmount .. "]"
					end

					Synthesize_Lingyu_Item_List:AddItem(" "..szPrescrName, nPrescr)
					
					if g_CurrentRecipe == 0 then
						g_CurrentRecipe = nPrescr
					end
					
					if g_CurrentRecipe == nPrescr then
						g_CurrentRecipeShow = 1
						Synthesize_Lingyu_Item_List:SetItemSelectByItemID(g_CurrentRecipe)
					end

				else
					if bAddGroup == 0 then
						local str = "+ #gFE7E82"..LifeAbility:GetPrescription_Kind(now_group)
						Synthesize_Lingyu_Item_List:AddItem(str, 10000 + j)
						bAddGroup = 1
					end
				end
			end
		end
	end
end

function Synthesize_Lingyu_UpdateItem()

	local nItemCount = Synthesize_Lingyu_Item_List:GetItemNumber()
	local nPrescrNum = DataPool:GetPrescrList_Num()

	for i = 1, nItemCount do
		local szItemText, nItemID = Synthesize_Lingyu_Item_List:GetItem(i)

		if nItemID >= 10000 then
			continue
		end

		local szPrescrName = DataPool:GetPrescrList_Item(nItemID)
		local nLevel = DataPool:GetPrescrList_Item_LifeAbilityLevel(nItemID)
		local nMaxAmount = LifeAbility:GetPrescr_Item_Maximum(nItemID)

		if nMaxAmount > 0 then
			szPrescrName = szPrescrName.."[".. nMaxAmount .. "]"
		end
		
		Synthesize_Lingyu_Item_List:SetListItemText(i - 1, " "..szPrescrName)
	end
end

function Synthesize_Lingyu_ItemCheck()	
	if g_Special_Item_BagIndex ~= -1 then
		local need_remove = 0
		
		--加锁
		if PlayerPackage:IsLock(g_Special_Item_BagIndex) == 1 then
			need_remove = 1
		end
		
		local bag_item_index = PlayerPackage:GetItemTableIndex(g_Special_Item_BagIndex)
		local isYuPei = 0	
		for i = 1, 5 do
			if bag_item_index == g_YuPei_ItemIndex[i] then
				isYuPei = 1
			end
		end
		if isYuPei == 0 then
			need_remove = 1
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_Special_Item_BagIndex, 0)
			g_Special_Item_BagIndex = -1
		end
	end
end

function Synthesize_Lingyu_UpdateInfo()
	Synthesize_Lingyu_Item:SetActionItem(-1)
	Synthesize_Lingyu_Amount:SetText("")
	Synthesize_Lingyu_Item_Name_Text:SetText("")
	
	Synthesize_Lingyu_MaterialIcon1:SetActionItem(-1)
	Synthesize_Lingyu_MaterialIcon1_Mask:Hide()
	Synthesize_Lingyu_MaterialIcon1_Amount:SetText("")
	Synthesize_Lingyu_Material1_Name_Text:SetText("")
	
	Synthesize_Lingyu_MaterialIcon2:SetActionItem(-1)
	Synthesize_Lingyu_MaterialIcon2_Mask:Hide()
	Synthesize_Lingyu_MaterialIcon2_Amount:SetText("")
	Synthesize_Lingyu_Material2_Name_Text:SetText("")
	
	if g_CurrentRecipe > 0 then
		if g_CurrentRecipeShow == 1 then
			local lingyu_bind = 0			
			
			local stuffid, stuffnum = DataPool:GetPrescrList_Item_Requirement(g_CurrentRecipe, 1)
			local have_stuff_count = PlayerPackage:Lua_GetUnLockItemCount(stuffid)
			local have_stuff_count_bind = PlayerPackage:Lua_GetUnLockBindItemCount(stuffid)
			
			if have_stuff_count_bind == 0 then
				local actionStuff = DataPool:CreateActionItemForShow(stuffid, 1)
				Synthesize_Lingyu_MaterialIcon1:SetActionItem(actionStuff:GetID())
			else
				local actionStuff = DataPool:CreateBindActionItemForShow(stuffid, 1)
				Synthesize_Lingyu_MaterialIcon1:SetActionItem(actionStuff:GetID())
			end
			
			if have_stuff_count > 99 then
				Synthesize_Lingyu_MaterialIcon1_Amount:SetText("#e0101018/" .. stuffnum)
			else
				Synthesize_Lingyu_MaterialIcon1_Amount:SetText("#e010101"..tostring(have_stuff_count).."/".."#e010101"..tostring(stuffnum))
			end
			
			if have_stuff_count < stuffnum then
				Synthesize_Lingyu_MaterialIcon1_Mask:Show()
			end
			
			local stuff_name = DataPool:LuaFnGetItemNameByTableIndex(stuffid)
			Synthesize_Lingyu_Material1_Name_Text:SetText(stuff_name)
			
			if g_Special_Item_BagIndex ~= -1 then
				local theAction = EnumAction(g_Special_Item_BagIndex, "packageitem")
				Synthesize_Lingyu_MaterialIcon2:SetActionItem(theAction:GetID())
				
				local ypBindStatus = GetItemBindStatus(g_Special_Item_BagIndex)
				if ypBindStatus == 1 then
					lingyu_bind = 1
				end
			end
			
			local lingyu_id, _ = DataPool:GetPrescrList_Item_Result(g_CurrentRecipe)
			
			if lingyu_bind == 1 then
				local actionLingYu = DataPool:CreateBindActionItemForShow(lingyu_id, 1)
				Synthesize_Lingyu_Item:SetActionItem(actionLingYu:GetID())
			else
				local actionLingYu = DataPool:CreateActionItemForShow(lingyu_id, 1)
				Synthesize_Lingyu_Item:SetActionItem(actionLingYu:GetID())
			end
			Synthesize_Lingyu_Amount:SetText("#e010101" .. "1")
			
			local lingyu_name = DataPool:LuaFnGetItemNameByTableIndex(lingyu_id)
			Synthesize_Lingyu_Item_Name_Text:SetText(lingyu_name)
		else
			if g_Special_Item_BagIndex ~= -1 then
				LifeAbility:Lock_Packet_Item(g_Special_Item_BagIndex, 0)
			end
		end
	end
	
end

function Synthesize_Lingyu_ListBox_Selected()
	local nSelIndex = Synthesize_Lingyu_Item_List:GetFirstSelectItem()
	local nPrescrNum = DataPool:GetPrescrList_Num()

	if nSelIndex > 10000 then
		if g_Recipe_Group_Outlining[nSelIndex - 10000] == 1 then
			g_Recipe_Group_Outlining[nSelIndex - 10000] = 0
		else
			g_Recipe_Group_Outlining[nSelIndex - 10000] = 1
		end
		Synthesize_Lingyu_UpdateList()
		Synthesize_Lingyu_UpdateInfo()
		return
	end
	
	if g_CurrentRecipe ~= nSelIndex then
		g_CurrentRecipe = nSelIndex
		if g_Special_Item_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Special_Item_BagIndex, 0)
			g_Special_Item_BagIndex = -1
		end		
		Synthesize_Lingyu_UpdateInfo()
	end

end

function Synthesize_Lingyu_Do_Clicked()

	local Notify = 0

	if g_CurrentRecipe == 0 then
		PushDebugMessage("#{SZXT_221216_92}")
		return
	end

	if g_Special_Item_BagIndex == -1 then
		PushDebugMessage("#{SZXT_221216_98}")
		return
	end

	LuaFnComposeLingYu(g_CurrentRecipe, g_Special_Item_BagIndex, 1)
end

function Synthesize_Lingyu_Cancel_Clicked()
	this:Hide()
end

function Synthesize_Lingyu_OnItemDragedDropFromBag(iBagIndex)

	local bag_item_index = PlayerPackage:GetItemTableIndex(iBagIndex)
	
	local isYuPei = 0	
	for i = 1, 5 do
		if bag_item_index == g_YuPei_ItemIndex[i] then
			isYuPei = 1
		end
	end
	if isYuPei == 0 then
		PushDebugMessage("#{SZXT_221216_88}")
		return
	end
	
	if g_Special_Item_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Special_Item_BagIndex, 0)
	end
	g_Special_Item_BagIndex = iBagIndex
	Synthesize_Lingyu_UpdateInfo()
end

function Synthesize_Lingyu_OnBagItemRClicked(iBagIndex)
	Synthesize_Lingyu_OnItemDragedDropFromBag(iBagIndex)
end

function Synthesize_Lingyu_OnItemDragedDropAway()
	Synthesize_Lingyu_OnSpecialItemRClicked()
end

function Synthesize_Lingyu_OnSpecialItemRClicked()	
	if g_Special_Item_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Special_Item_BagIndex, 0)
		g_Special_Item_BagIndex = -1
		Synthesize_Lingyu_UpdateInfo()
	end
end

function Synthesize_Lingyu_OnHidden()
	if g_Special_Item_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Special_Item_BagIndex, 0)
	end
	g_Special_Item_BagIndex	= -1
	Synthesize_Lingyu_MaterialIcon2:SetActionItem(-1)
	Synthesize_Lingyu_MaterialIcon1:SetActionItem(-1)
	Synthesize_Lingyu_Item:SetActionItem(-1)
	g_Current_Ability = 0
	Synthesize_Lingyu_Item_List:ClearListBox()
	
	g_UI_Index = 0
	g_CurrentRecipe = 0
	g_CurrentRecipeShow = 0
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Synthesize_Lingyu_Frame_On_ResetPos()
	Synthesize_Lingyu_Frame:SetProperty("UnifiedXPosition", g_Synthesize_Lingyu_Frame_UnifiedXPosition)
	Synthesize_Lingyu_Frame:SetProperty("UnifiedYPosition", g_Synthesize_Lingyu_Frame_UnifiedYPosition)
end
