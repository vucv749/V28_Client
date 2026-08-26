--雪舞 2026-2-21

local PET_MAX_NUMBER = 6 + 4

local PETNUM = 0
local PET_FIGHT_EXTLIST_ABSOLUTE = {};

local g_PetFight_List_Frame_UnifiedXPosition
local g_PetFight_List_Frame_UnifiedYPosition
--OnLoad
function PetFight_List_PreLoad()
	this:RegisterEvent("SHOW_CONTEXMENU");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("HIDE_CONTEXMENU_SPEAKER");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("OPEN_PETFIGHT_LIST");
	this:RegisterEvent("TOGLE_PET_PAGE");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetFight_List_OnLoad()
	
	PET_FIGHT_EXTLIST_ABSOLUTE[1] = 26
	PET_FIGHT_EXTLIST_ABSOLUTE[2] = 43
	PET_FIGHT_EXTLIST_ABSOLUTE[3] = 60
	PET_FIGHT_EXTLIST_ABSOLUTE[4] = 77
	PET_FIGHT_EXTLIST_ABSOLUTE[5] = 94
	PET_FIGHT_EXTLIST_ABSOLUTE[6] = 111
	PET_FIGHT_EXTLIST_ABSOLUTE[7] = 128
	PET_FIGHT_EXTLIST_ABSOLUTE[8] = 145
	PET_FIGHT_EXTLIST_ABSOLUTE[9] = 162
	PET_FIGHT_EXTLIST_ABSOLUTE[10] = 179

	g_PetFight_List_Frame_UnifiedXPosition	= PetFight_List_Frame:GetProperty("UnifiedXPosition")
	g_PetFight_List_Frame_UnifiedYPosition	= PetFight_List_Frame:GetProperty("UnifiedYPosition")

end

function PetFight_List_OnEvent(event)
	if( event == "OPEN_PETFIGHT_LIST" ) then
		if tonumber(arg0) == 1 then
			PlayerFrame_Fight_Update()
			PetFight_List_ResetPos()
			this:Show()

		else
			PetFight_List_MouseLeave()
		end
	elseif (event == "UPDATE_PET_PAGE") then
		if this:IsVisible() then
			PlayerFrame_Fight_Update()
		end
	elseif event == "TOGLE_PET_PAGE" then --和pet界面互斥
		this:Hide()
	elseif event == "ACCELERATE_KEYSEND" then
		PetFight_List_HandleAccKey(arg0)
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetFight_List_ResetPos()
	end
end

function PlayerFrame_Fight_Clicked(event)

end
function PlayerFrame_Fight_Update()
	local nPetCount = Pet:GetPet_Count()
	local szPetName

	PetFight_ListBox:ClearListBox()
	if nPetCount < 1 then
		Pet:SetSelectPetIdx(-1)
		return
	end
	PetFight_List_UpdateBagLine(nPetCount)
	-- local bSelect = 0
	local firSel = -1
	for	i=1, PET_MAX_NUMBER do
		if Pet:IsPresent(i-1) then
			if firSel == -1 then
				firSel = i - 1
			end
			szPetName = Pet:GetPetList_Appoint(i - 1)
			local times = 0--Pet:Lua_GetCooldownRemainTime(i - 1,160)
			if Pet:GetIsFighting(i - 1) then --出战
				PetFight_ListBox:AddItem(szPetName, i - 1, "FF0A9605")
			elseif Pet:GetIsPossession(i -1 ) then --附体
				PetFight_ListBox:AddItem(szPetName, i - 1, "FF996699");
			elseif times > 0 then --收回/阵亡 cd
				PetFight_ListBox:AddItem(szPetName, i - 1, "FF858985");
				local str = ScriptGlobal_Format("#{ZSCZ_241217_04}",math.floor((times+1000)/1000))
				local index = PetFight_ListBox:GetItemNumByItemId(i-1)
				PetFight_ListBox:SetItemTooltip(index,str)
			else
				PetFight_ListBox:AddItem(szPetName, i - 1) --拥有
			end
		end
	end

end
function PetFight_List_MouseEnter()
	DataPool:SetPetFightList_Show2(1)
end

function PetFight_List_MouseLeave()

	local bshow1 = DataPool:GetPetFightList_Show1()
	local bshow2 = DataPool:GetPetFightList_Show2()
	DataPool:SetPetFightList_Show2(0)

	if bshow1 == 0 and bshow2 == 0 then
	    this:Hide()
	end
end

function PetFight_List_Selected()
	PETNUM = PetFight_ListBox:GetFirstSelectItem()
	local nPetCount = Pet:GetPet_Count()
	if Pet:GetIsFighting(PETNUM) then --出战
		return
	end
	if PETNUM < 0 and nPetCount > 0 then
		PETNUM = 0
		return
	end

	PetFight_List_Clicked()
	--Pet:NotifySelChange(PETNUM)
end
function PetFight_List_Clicked()
	-- 已经提交到指定界面容器的珍兽不能出战
	if (IsWindowShow("PetSavvy") and Pet:GetPetLocation(PETNUM) == 12)				-- 用成年珍兽提升珍兽悟性
		or (IsWindowShow("PetSavvyGGD")	and Pet:GetPetLocation(PETNUM) == 3)		-- 用根骨丹提升珍兽悟性
		or (IsWindowShow("MissionReply") and Pet:GetPetLocation(PETNUM) == 7) then	-- 任务提交物品或珍兽
		-- "珍兽处于提交状态，无法出战。"
		PushDebugMessage("#{ZSTJZT_090904}")
		return		
	end
	if Pet:IsPresent(PETNUM) then
	    Pet:Go_Fight(PETNUM)
	end
end


function PetFight_List_UpdateBagLine( nMaxLine )
	
	if nMaxLine > 10 or nMaxLine < 0  then
		return
	end
	local nWindowHeight;
	nWindowHeight = PET_FIGHT_EXTLIST_ABSOLUTE[nMaxLine];
	PetFight_List_Frame:SetProperty( "AbsoluteHeight",nWindowHeight );
	
end



function PetFight_List_HandleAccKey(op)
	if op == "acc_pet" then
		this:Hide()
	end
end

function PetFight_List_ResetPos()
	local nPetCount = Pet:GetPet_Count()
	local ynewpos =  "{1.000000," .. tostring(-75.000000 -  nPetCount * 17 ).. "..}"

	PetFight_List_Frame:SetProperty("UnifiedXPosition", g_PetFight_List_Frame_UnifiedXPosition )
	PetFight_List_Frame:SetProperty("UnifiedYPosition", ynewpos ) 

	local nPosX = tonumber(PetFight_List_Frame:GetProperty("AbsoluteXPosition"))
	local nPosY = tonumber(PetFight_List_Frame:GetProperty("AbsoluteYPosition"))

	
	PetFight_List_Frame:AutoMousePosition(nPosX, nPosY);

end