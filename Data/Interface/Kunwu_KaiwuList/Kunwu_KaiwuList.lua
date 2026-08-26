--!!!reloadscript =Kunwu_KaiwuList

local g_nSelect_Index = -1

local PET_MAX_NUMBER = 10	--最大珍兽携带上限
local g_Kunwu_KaiwuList_Frame_UnifiedPosition

function Kunwu_KaiwuList_PreLoad()

	this:RegisterEvent("OPEN_PET_LIST_KW")
	this:RegisterEvent("CLOSE_PET_LIST_KW")
	this:RegisterEvent("UPDATE_PET_LIST")
	this:RegisterEvent("UPDATE_PET_PAGE")
	this:RegisterEvent("DELETE_PET")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

end

function Kunwu_KaiwuList_OnLoad()
	 g_Kunwu_KaiwuList_Frame_UnifiedPosition = Kunwu_KaiwuList_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_KaiwuList_OnEvent(event)

	-- 打开珍兽列表界面	
	if event == "OPEN_PET_LIST_KW" then
		g_nSelect_Index = -1
		this:Show()
		Kunwu_KaiwuList_UpdateFrame()
		Kunwu_KaiwuList_CloseOtherPetList()
		return
	end
	
	if event == "UPDATE_PET_LIST" then
		Kunwu_KaiwuList_UpdateFrame()
		return
	end

	-- 玩家身上的珍兽数据发生变化，包括珍兽出战、休息、增加一只珍兽
	if event == "UPDATE_PET_PAGE" then
		Kunwu_KaiwuList_UpdateFrame()
		return
	end
	
	-- 玩家身上减少1只珍兽
	if event == "DELETE_PET" then
		Kunwu_KaiwuList_UpdateFrame()
		return
	end
	
	if event == "CLOSE_PET_LIST_KW" then
		Kunwu_KaiwuList_Refuse_Click()
		return
	end	

	-- 游戏窗口尺寸发生了变化
	if event == "ADJEST_UI_POS" then
		Kunwu_KaiwuList_Frame_On_ResetPos()
		return
	end
	
	-- 游戏分辨率发生了变化
	if event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_KaiwuList_Frame_On_ResetPos()
		return
	end
end

-- 更新界面
function Kunwu_KaiwuList_UpdateFrame()

	-- 先清空当前列表
	Kunwu_KaiwuList_List:ClearListBox()
	
	local PetInListIndex = 0;
	for	i = 0, PET_MAX_NUMBER - 1 do
		local szPetName, szOn = Pet:GetPetList_Appoint(i)
		local strToolTips = ""

		if szPetName ~= "" then
			--珍兽不在背包里
			if szOn ~= "on_packa" then 
				szPetName = "#c808080" .. szPetName		-- 灰色显示
			elseif Pet:GetPetLocation(i) ~= -1 then
			--	szPetName = "#c808080" .. szPetName		-- 灰色显示
			end
			
			if PlayerPackage:IsPetLock(i) == 1 then
				local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i)
				if nUnlockElapsedTime == 0 then
					szPetName = szPetName.. "  #-05"
					strToolTips = "已加锁"
				else
					szPetName = szPetName.. "  #-10"
					local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime)		
					strToolTips = strLeftTime
				end
			end
			Kunwu_KaiwuList_List:AddItem(szPetName, i)
			Kunwu_KaiwuList_List:SetItemTooltip(PetInListIndex, strToolTips)
			PetInListIndex = PetInListIndex + 1
		end
	end
end

-- 选择
function Kunwu_KaiwuList_Choose_Click()
	g_nSelect_Index = Kunwu_KaiwuList_List:GetFirstSelectItem()
	if g_nSelect_Index == -1  then
		return
	end

	local NeedCheckLock = 1
	if NeedCheckLock == 1 and PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
	--	PushDebugMessage("珍兽已加锁")
	--	return
	end

	Pet:LuaFnSelectPetKW(g_nSelect_Index)
end

-- 放弃
function Kunwu_KaiwuList_Refuse_Click()
	this:Hide()
end

-- 选中列表中的珍兽
function Kunwu_KaiwuList_Selected()
	g_nSelect_Index = Kunwu_KaiwuList_List:GetFirstSelectItem()
end

--根据选择的珍兽，显示相应的详细信息
function Kunwu_KaiwuList_ShowTargetPet()
	g_nSelect_Index = Kunwu_KaiwuList_List:GetFirstSelectItem()

	if -1 == g_nSelect_Index then
		return
	end
	Pet:ShowTargetPet(g_nSelect_Index)
end

-- 恢复界面的默认相对位置
function Kunwu_KaiwuList_Frame_On_ResetPos()
	Kunwu_KaiwuList_Frame:SetProperty("UnifiedPosition", g_Kunwu_KaiwuList_Frame_UnifiedPosition)
end

function Kunwu_KaiwuList_CloseOtherPetList()
	CloseWindow("PetList", true)
	CloseWindow("Kunwu_JL_List", true)
	CloseWindow("Kunwu_KaiwuList2", true)
end