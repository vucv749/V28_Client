--!!!reloadscript =Kunwu_JL_List

local g_nSelect_Index = -1

local PET_MAX_NUMBER = 10	--????????
local g_Kunwu_JL_List_Frame_UnifiedPosition

function Kunwu_JL_List_PreLoad()

	this:RegisterEvent("OPEN_PET_LIST_JL")
	this:RegisterEvent("CLOSE_PET_LIST_JL")
	this:RegisterEvent("UPDATE_PET_LIST")
	this:RegisterEvent("UPDATE_PET_PAGE")
	this:RegisterEvent("DELETE_PET")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

end

function Kunwu_JL_List_OnLoad()
	 g_Kunwu_JL_List_Frame_UnifiedPosition = Kunwu_JL_List_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_JL_List_OnEvent(event)

	-- ´ò¿ª äÊÞÁÐ±í½çÃæ	
	if event == "OPEN_PET_LIST_JL" then
		g_nSelect_Index = -1
		this:Show()
		Kunwu_JL_List_UpdateFrame()
		Kunwu_JL_List_CloseOtherPetList()
		return
	end
	
	if event == "UPDATE_PET_LIST" then
		Kunwu_JL_List_UpdateFrame()
		return
	end

	-- Íæ¼ÒÉíÉÏµÄ äÊÞÊý¾Ý·¢Éú±ä»¯£¬°üÀ¨ äÊÞ³ö ½¡¢ÐÝÏ¢¡¢Ôö¼ÓÒ»Ö» äÊÞ
	if event == "UPDATE_PET_PAGE" then
		Kunwu_JL_List_UpdateFrame()
		return
	end
	
	-- Íæ¼ÒÉíÉÏ¼õÉÙ1Ö» äÊÞ
	if event == "DELETE_PET" then
		Kunwu_JL_List_UpdateFrame()
		return
	end
	
	if event == "CLOSE_PET_LIST_JL" then
		Kunwu_JL_List_Refuse_Click()
		return
	end	

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if event == "ADJEST_UI_POS" then
		Kunwu_JL_List_Frame_On_ResetPos()
		return
	end
	
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	if event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_JL_List_Frame_On_ResetPos()
		return
	end
end

-- ¸üÐÂ½çÃæ
function Kunwu_JL_List_UpdateFrame()

	-- ÏÈÇå¿ µ±Ç°ÁÐ±í
	Kunwu_JL_List_List:ClearListBox()
	
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
			Kunwu_JL_List_List:AddItem(szPetName, i)
			Kunwu_JL_List_List:SetItemTooltip(PetInListIndex, strToolTips)
			PetInListIndex = PetInListIndex + 1
		end
	end
end

-- Ñ¡Ôñ
function Kunwu_JL_List_Choose_Click()
	g_nSelect_Index = Kunwu_JL_List_List:GetFirstSelectItem()
	if g_nSelect_Index == -1  then
		return
	end

	local NeedCheckLock = 1
	if NeedCheckLock == 1 and PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
	--	PushDebugMessage("Thú quý ðã khóa")
	--	return
	end

	Pet:LuaFnSelectPetJL(g_nSelect_Index)
end

-- ·ÅÆú
function Kunwu_JL_List_Refuse_Click()
	this:Hide()
end

-- Ñ¡ÖÐÁÐ±íÖÐµÄ äÊÞ
function Kunwu_JL_List_Selected()
	g_nSelect_Index = Kunwu_JL_List_List:GetFirstSelectItem()
end

--¸ù¾ÝÑ¡ÔñµÄ äÊÞ£¬ÏÔÊ¾ÏàÓ¦µÄÏêÏ¸ÐÅÏ¢
function Kunwu_JL_List_ShowTargetPet()
	g_nSelect_Index = Kunwu_JL_List_List:GetFirstSelectItem()

	if -1 == g_nSelect_Index then
		return
	end
	Pet:ShowTargetPet(g_nSelect_Index)
end

-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
function Kunwu_JL_List_Frame_On_ResetPos()
	Kunwu_JL_List_Frame:SetProperty("UnifiedPosition", g_Kunwu_JL_List_Frame_UnifiedPosition)
end

function Kunwu_JL_List_CloseOtherPetList()
	CloseWindow("PetList", true)
	CloseWindow("Kunwu_KaiwuList", true)
	CloseWindow("Kunwu_KaiwuList2", true)
end
