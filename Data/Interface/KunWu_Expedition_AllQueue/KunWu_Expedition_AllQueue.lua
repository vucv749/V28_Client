
local g_KunWu_Expedition_AllQueue_Frame_UnifiedPosition
local g_KunWu_Expedition_AllQueue_Kind = 1
--local g_KunWu_Expedition_AllQueue_PetDispatchCount = 0
local g_KunWu_Expedition_AllQueue_ListItem ={}
local g_KunWu_Expedition_AllQueue_ListFinish ={}
local g_KunWu_Expedition_AllQueue_Count = 0
function KunWu_Expedition_AllQueue_PreLoad()
	this:RegisterEvent("OPEN_PET_PAIQIAN_ALLQUEUE")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("CLOSE_PET_PAIQIAN_QUEUE",false)
end

function KunWu_Expedition_AllQueue_OnLoad()
	g_KunWu_Expedition_AllQueue_Frame_UnifiedPosition = KunWu_Expedition_AllQueueFrameBK:GetProperty("UnifiedPosition")

end

function KunWu_Expedition_AllQueue_OnEvent(event)
	if event == "VIEW_RESOLUTION_CHANGED" then
		KunWu_Expedition_AllQueue_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		KunWu_Expedition_AllQueue_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		KunWu_Expedition_AllQueue_Close()
	elseif event == "CLOSE_PET_PAIQIAN_QUEUE" then
		KunWu_Expedition_AllQueue_Close()
	elseif event == "OPEN_PET_PAIQIAN_ALLQUEUE" then	
		-- if this:IsVisible() then
		-- 	KunWu_Expedition_AllQueue_Close()
		-- 	return
		-- end
		-- g_KunWu_Expedition_AllQueue_Kind = tonumber( arg0 )
		-- this:Show()
		-- KunWu_Expedition_AllQueue_Open()
	end
	
end

-- function KunWu_Expedition_AllQueue_Open()
-- 	KunWu_Expedition_AllQueue_ReturnList:Clear()
-- 	local nCount = Pet:Lua_SortPetDispatchQueue(g_KunWu_Expedition_AllQueue_Kind)
-- 	local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
-- 	g_KunWu_Expedition_AllQueue_ListItem ={}
-- 	g_KunWu_Expedition_AllQueue_Count = 0
-- 	for i = 1 , nCount do
-- 		local temp,j = Pet:Lua_EnumPetDispatchQueue(i)
-- 		local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchLevel,nRequiredDispatchFightNum =  Pet:Lua_EnumPetDispatchTableItem(temp)
-- 		local nStatus, nParamIndex, nFinishTime, nPetIndex = Pet:Lua_SelectPetDispatchItem(temp, j)
-- 		if nStatus == 1 then
-- 			ItemBar = KunWu_Expedition_AllQueue_ReturnList:AddChild("KunWu_Expedition_AllQueueItemBK")
-- 			ItemBar:GetSubItem("KunWu_Expedition_AllQueue_FBText"):SetText(nTypeName)
-- 			local nTitle, nDesc, nParam1, nParam2, nParam3, nParam4, nParam5 = Pet:GetDispatchTaskInfoByParamIndex(nParamIndex,0)
-- 			if nTitle ~= nil then
-- 				ItemBar:GetSubItem("KunWu_Expedition_AllQueue_MissionText"):SetText("#{"..nTitle.."}")
-- 			end
-- 			local szPortrait = Pet:GetPetPortraitByIndex(nPetIndex)
-- 			if(nil ~= szPortrait and "" ~= szPortrait) then
-- 				ItemBar:GetSubItem("KunWu_Expedition_AllQueue_PetItem"):SetProperty("Image", tostring(szPortrait))
-- 			end
-- 			ItemBar:GetSubItem("KunWu_Expedition_AllQueue_DetailBtn"):SetEvent( "MouseLClick", "KunWu_Expedition_AllQueue_Search_Clicked("..temp..","..j..")" )
			
-- 			if curTime >= nFinishTime then
-- 				ItemBar:GetSubItem("KunWu_Expedition_AllQueue_TimeText"):SetText("#{ZSPQ_241216_116}")
-- 			else
-- 				local diffTime = nFinishTime - curTime
-- 				local showmin = math.floor(diffTime/60)
-- 				local showsec = math.mod(diffTime,60)
			
-- 				local showhour = math.floor(showmin/60)
-- 				showmin = math.mod(showmin,60)
			
-- 				local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
-- 				ItemBar:GetSubItem("KunWu_Expedition_AllQueue_TimeText"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_112}",nStr))
-- 			end
-- 			g_KunWu_Expedition_AllQueue_Count = g_KunWu_Expedition_AllQueue_Count + 1
-- 			g_KunWu_Expedition_AllQueue_ListItem[g_KunWu_Expedition_AllQueue_Count] = ItemBar
-- 			g_KunWu_Expedition_AllQueue_ListFinish[g_KunWu_Expedition_AllQueue_Count] = nFinishTime
			
			
-- 		end
-- 	end
-- 	KunWu_Expedition_AllQueue_ListInfoText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_111}",g_KunWu_Expedition_AllQueue_Count))
-- 	KunWu_Expedition_AllQueue_OnTimer()
-- 	SetTimer("KunWu_Expedition_AllQueue","KunWu_Expedition_AllQueue_OnTimer()", 1000)

-- end


-- function KunWu_Expedition_AllQueue_OnTimer()
-- 	local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
-- 	for i = 1 , g_KunWu_Expedition_AllQueue_Count do
-- 		local ItemBar = g_KunWu_Expedition_AllQueue_ListItem[i]
-- 		--PushDebugMessage("xtc:")
-- 		if ItemBar ~= nil then
		
-- 			local nFinishTime = g_KunWu_Expedition_AllQueue_ListFinish[i]
		
-- 			local diffTime = nFinishTime - curTime
-- 			if diffTime<=0 then
-- 				ItemBar:GetSubItem("KunWu_Expedition_AllQueue_TimeText"):SetText("#{ZSPQ_241216_116}")
-- 			else
				
-- 				local showmin = math.floor(diffTime/60)
-- 				local showsec = math.mod(diffTime,60)

-- 				local showhour = math.floor(showmin/60)
-- 				showmin = math.mod(showmin,60)

-- 				local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
-- 				--PushDebugMessage("i:"..tostring(i).."---"..nStr)
-- 				ItemBar:GetSubItem("KunWu_Expedition_AllQueue_TimeText"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_112}",nStr))
-- 			end

-- 		end
-- 	end


-- end

-- function KunWu_Expedition_AllQueue_Search_Clicked(i, j)
-- 	if g_KunWu_Expedition_AllQueue_Kind == 2 then
-- 		i = i-4
-- 	end
-- 	PushEvent("PET_PAIQIAN_LOCATE", i, j)
-- end

function KunWu_Expedition_AllQueue_On_ResetPos()
	KunWu_Expedition_AllQueueFrameBK:SetProperty("UnifiedPosition", g_KunWu_Expedition_AllQueue_Frame_UnifiedPosition)
end

function KunWu_Expedition_AllQueue_Close()
	this:Hide()
end

function KunWu_Expedition_AllQueue_OnHidden()
	g_KunWu_Expedition_AllQueue_Kind = 1
	--g_KunWu_Expedition_AllQueue_PetDispatchCount = 0
	KunWu_Expedition_AllQueue_ReturnList:Clear()
	g_KunWu_Expedition_AllQueue_ListItem ={}
	g_KunWu_Expedition_AllQueue_ListFinish ={}
	KillTimer("KunWu_Expedition_AllQueue_OnTimer()")
	g_KunWu_Expedition_AllQueue_Count = 0
end