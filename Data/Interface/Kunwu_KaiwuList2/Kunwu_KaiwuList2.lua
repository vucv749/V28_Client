--!!!reloadscript =Kunwu_KaiwuList2

local g_nSelect_Index = -1

local PET_MAX_NUMBER = 10	--????????
local g_Kunwu_KaiwuList2_Frame_UnifiedPosition
local g_SelTargetPet = 0

function Kunwu_KaiwuList2_PreLoad()

	this:RegisterEvent("OPEN_PET_LIST_KWTS")
	this:RegisterEvent("CLOSE_PET_LIST_KWTS")
	this:RegisterEvent("UPDATE_PET_LIST")
	this:RegisterEvent("UPDATE_PET_PAGE")
	this:RegisterEvent("DELETE_PET")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

end

function Kunwu_KaiwuList2_OnLoad()
	 g_Kunwu_KaiwuList2_Frame_UnifiedPosition = Kunwu_KaiwuList2_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_KaiwuList2_OnEvent(event)

	-- ´ò¿ª äÊÞÁÐ±í½çÃæ	
	if event == "OPEN_PET_LIST_KWTS" then
		g_nSelect_Index = -1
		g_SelTargetPet = tonumber(arg0)
		if this:IsVisible() then
			if g_SelTargetPet == 0 then
				Pet:LuaFnSendKWTSPetListState(1)
			else
				Pet:LuaFnSendKWTSPetListState(2)
			end
		end		
		this:Show()
		Kunwu_KaiwuList2_UpdateFrame()
		Kunwu_KaiwuList2_CloseOtherPetList()
		return
	end
	
	if event == "UPDATE_PET_LIST" then
		Kunwu_KaiwuList2_UpdateFrame()
		return
	end

	-- Íæ¼ÒÉíÉÏµÄ äÊÞÊý¾Ý·¢Éú±ä»¯£¬°üÀ¨ äÊÞ³ö ½¡¢ÐÝÏ¢¡¢Ôö¼ÓÒ»Ö» äÊÞ
	if event == "UPDATE_PET_PAGE" then
		Kunwu_KaiwuList2_UpdateFrame()
		return
	end
	
	-- Íæ¼ÒÉíÉÏ¼õÉÙ1Ö» äÊÞ
	if event == "DELETE_PET" then
		Kunwu_KaiwuList2_UpdateFrame()
		return
	end
	
	if event == "CLOSE_PET_LIST_KWTS" then
		Kunwu_KaiwuList2_Refuse_Click()
		return
	end	

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if event == "ADJEST_UI_POS" then
		Kunwu_KaiwuList2_Frame_On_ResetPos()
		return
	end
	
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	if event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_KaiwuList2_Frame_On_ResetPos()
		return
	end
end

-- ¸üÐÂ½çÃæ
function Kunwu_KaiwuList2_UpdateFrame()
	
	if g_SelTargetPet == 0 then
		Kunwu_KaiwuList2_DragTitle:SetText("#{KWCC_241219_63}")
	else
		Kunwu_KaiwuList2_DragTitle:SetText("#{KWCC_241219_64}")
	end

	-- ÏÈÇå¿ µ±Ç°ÁÐ±í
	Kunwu_KaiwuList2_List:ClearListBox()
	
	local PetInListIndex = 0;
	for	i = 0, PET_MAX_NUMBER - 1 do
		local szPetName, szOn = Pet:GetPetList_Appoint(i)
		local strToolTips = ""

		if szPetName ~= "" then
			-- äÊÞ²»ÔÚ±³°üÀï
			if szOn ~= "on_packa" then 
				szPetName = "#c808080" .. szPetName		-- ????
			elseif Pet:GetPetLocation(i) ~= -1 then
			--	szPetName = "#c808080" .. szPetName		-- »ÒÉ«ÏÔÊ¾
			end
			
			if PlayerPackage:IsPetLock(i) == 1 then
				local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i)
				if nUnlockElapsedTime == 0 then
					szPetName = szPetName.. "  #-05"
					strToolTips = "Ðã khóa"
				else
					szPetName = szPetName.. "  #-10"
					local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime)		
					strToolTips = strLeftTime
				end
			end
			Kunwu_KaiwuList2_List:AddItem(szPetName, i)
			Kunwu_KaiwuList2_List:SetItemTooltip(PetInListIndex, strToolTips)
			PetInListIndex = PetInListIndex + 1
		end
	end
end

-- Ñ¡Ôñ
function Kunwu_KaiwuList2_Choose_Click()
	g_nSelect_Index = Kunwu_KaiwuList2_List:GetFirstSelectItem()
	if g_nSelect_Index == -1  then
		return
	end

	local NeedCheckLock = 1
	if NeedCheckLock == 1 and PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
	--	PushDebugMessage("Thú quý ðã khóa")
	--	return
	end
	
	Pet:LuaFnSelectPetKWTS(g_nSelect_Index, tonumber(g_SelTargetPet))
end

-- ·ÅÆú
function Kunwu_KaiwuList2_Refuse_Click()
	this:Hide()
end

-- Ñ¡ÖÐÁÐ±íÖÐµÄ äÊÞ
function Kunwu_KaiwuList2_Selected()
	g_nSelect_Index = Kunwu_KaiwuList2_List:GetFirstSelectItem()
end

--¸ù¾ÝÑ¡ÔñµÄ äÊÞ£¬ÏÔÊ¾ÏàÓ¦µÄÏêÏ¸ÐÅÏ¢
function Kunwu_KaiwuList2_ShowTargetPet()
	g_nSelect_Index = Kunwu_KaiwuList2_List:GetFirstSelectItem()

	if -1 == g_nSelect_Index then
		return
	end
	Pet:ShowTargetPet(g_nSelect_Index)
end

-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
function Kunwu_KaiwuList2_Frame_On_ResetPos()
	Kunwu_KaiwuList2_Frame:SetProperty("UnifiedPosition", g_Kunwu_KaiwuList2_Frame_UnifiedPosition)
end

function Kunwu_KaiwuList2_CloseOtherPetList()
	CloseWindow("PetList", true)
	CloseWindow("Kunwu_JL_List", true)
	CloseWindow("Kunwu_KaiwuList", true)
end

function Kunwu_KaiwuList2_OnHidden()
	Pet:LuaFnSendKWTSPetListState(0)
end

function Kunwu_KaiwuList2_OnShown()
	if g_SelTargetPet == 0 then
		Pet:LuaFnSendKWTSPetListState(1)
	else
		Pet:LuaFnSendKWTSPetListState(2)
	end
end
