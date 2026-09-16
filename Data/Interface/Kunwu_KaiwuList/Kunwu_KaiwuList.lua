--!!!reloadscript =Kunwu_KaiwuList

local g_nSelect_Index = -1

local PET_MAX_NUMBER = 10	--????????
local g_Kunwu_KaiwuList_Frame_UnifiedPosition

function Kunwu_KaiwuList_PreLoad()

	this:RegisterEvent("OPEN_PET_LIST_KW")
	this:RegisterEvent("CLOSE_PET_LIST_KW")
	this:RegisterEvent("UPDATE_PET_LIST")
	this:RegisterEvent("UPDATE_PET_PAGE")
	this:RegisterEvent("DELETE_PET")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

end

function Kunwu_KaiwuList_OnLoad()
	 g_Kunwu_KaiwuList_Frame_UnifiedPosition = Kunwu_KaiwuList_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_KaiwuList_OnEvent(event)

	-- ´ò¿ª äÊÞÁÐ±í½çÃæ	
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

	-- Íæ¼ÒÉíÉÏµÄ äÊÞÊý¾Ý·¢Éú±ä»¯£¬°üÀ¨ äÊÞ³ö ½¡¢ÐÝÏ¢¡¢Ôö¼ÓÒ»Ö» äÊÞ
	if event == "UPDATE_PET_PAGE" then
		Kunwu_KaiwuList_UpdateFrame()
		return
	end
	
	-- Íæ¼ÒÉíÉÏ¼õÉÙ1Ö» äÊÞ
	if event == "DELETE_PET" then
		Kunwu_KaiwuList_UpdateFrame()
		return
	end
	
	if event == "CLOSE_PET_LIST_KW" then
		Kunwu_KaiwuList_Refuse_Click()
		return
	end	

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if event == "ADJEST_UI_POS" then
		Kunwu_KaiwuList_Frame_On_ResetPos()
		return
	end
	
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	if event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_KaiwuList_Frame_On_ResetPos()
		return
	end
end

-- ¸üÐÂ½çÃæ
function Kunwu_KaiwuList_UpdateFrame()

	-- ÏÈÇå¿ µ±Ç°ÁÐ±í
	Kunwu_KaiwuList_List:ClearListBox()
	
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
			Kunwu_KaiwuList_List:AddItem(szPetName, i)
			Kunwu_KaiwuList_List:SetItemTooltip(PetInListIndex, strToolTips)
			PetInListIndex = PetInListIndex + 1
		end
	end
end

-- Ñ¡Ôñ
function Kunwu_KaiwuList_Choose_Click()
	g_nSelect_Index = Kunwu_KaiwuList_List:GetFirstSelectItem()
	if g_nSelect_Index == -1  then
		return
	end

	local NeedCheckLock = 1
	if NeedCheckLock == 1 and PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
	--	PushDebugMessage("Thú quý ðã khóa")
	--	return
	end

	Pet:LuaFnSelectPetKW(g_nSelect_Index)
end

-- ·ÅÆú
function Kunwu_KaiwuList_Refuse_Click()
	this:Hide()
end

-- Ñ¡ÖÐÁÐ±íÖÐµÄ äÊÞ
function Kunwu_KaiwuList_Selected()
	g_nSelect_Index = Kunwu_KaiwuList_List:GetFirstSelectItem()
end

--¸ù¾ÝÑ¡ÔñµÄ äÊÞ£¬ÏÔÊ¾ÏàÓ¦µÄÏêÏ¸ÐÅÏ¢
function Kunwu_KaiwuList_ShowTargetPet()
	g_nSelect_Index = Kunwu_KaiwuList_List:GetFirstSelectItem()

	if -1 == g_nSelect_Index then
		return
	end
	Pet:ShowTargetPet(g_nSelect_Index)
end

-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
function Kunwu_KaiwuList_Frame_On_ResetPos()
	Kunwu_KaiwuList_Frame:SetProperty("UnifiedPosition", g_Kunwu_KaiwuList_Frame_UnifiedPosition)
end

function Kunwu_KaiwuList_CloseOtherPetList()
	CloseWindow("PetList", true)
	CloseWindow("Kunwu_JL_List", true)
	CloseWindow("Kunwu_KaiwuList2", true)
end
