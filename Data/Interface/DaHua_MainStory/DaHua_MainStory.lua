--DaHua_MainStory.lua

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_DaHua_MainStory_UnifiedXPosition
local g_DaHua_MainStory_UnifiedYPosition

local g_DaHua_MainStory_Param1
local g_DaHua_MainStory_Param2
local g_DaHua_MainStory_Param3

local g_DaHua_MainStory_StepInfo = {
 [1] = {nStart=20240801,nEnd=20240915,nMF=MF_2024_DH_PRIZE_1,nItemId=38003208,nItemNum=1,
		mission={
		 [1]={name="#{DHGS_240521_22}",misionid=2304,sceneId=0,x=159,z=109,npcname="B° Ð« Lão T±"}, 
		 [2]={name="#{DHGS_240521_23}",misionid=2305,sceneId=700,x=52,z=188,npcname="Ngµ Không Tàn Ni®m"}, 
		 [3]={name="#{DHGS_240521_24}",misionid=2306,sceneId=700,x=52,z=188,npcname="Ngµ Không Tàn Ni®m"}, 
		 [4]={name="#{DHGS_240521_25}",misionid=2307,sceneId=701,x=156,z=45,npcname="Tr¥m tß Ðích chí tôn Bäo"}, 
		 [5]={name="#{DHGS_240521_26}",misionid=2308,sceneId=701,x=156,z=45,npcname="Tr¥m tß Ðích chí tôn Bäo"}, 
		 [6]={name="#{DHGS_240521_27}",misionid=2309,sceneId=700,x=52,z=188,npcname="Ngµ Không Tàn Ni®m"},
		},
 },
 [2] = {nStart=20240815,nEnd=20240915,nMF=MF_2024_DH_PRIZE_2,nItemId=38003209,nItemNum=1,
		mission={
		 [1]={name="#{DHGS_240521_28}",misionid=2311,sceneId=0,x=159,z=109,npcname="B° Ð« Lão T±"},
		 [2]={name="#{DHGS_240521_29}",misionid=2312,sceneId=701,x=55,z=38,npcname="Ðß¶ng Tång"},
		 [3]={name="#{DHGS_240521_30}",misionid=2313,sceneId=701,x=82,z=97,npcname="Ðß¶ng Tång·Di H°n H§u"},
		 [4]={name="#{DHGS_240521_31}",misionid=2314,sceneId=701,x=82,z=97,npcname="Ðß¶ng Tång·Di H°n H§u"},
		 [5]={name="#{DHGS_240521_32}",misionid=2315,sceneId=701,x=75,z=94,npcname="Tôn Ngµ Không·Di H°n H§u"},
		 [6]={name="#{DHGS_240521_33}",misionid=2316,sceneId=701,x=75,z=94,npcname="Tôn Ngµ Không·Di H°n H§u"},
		},
 },
 [3] = {nStart=20240829,nEnd=20240915,nMF=MF_2024_DH_PRIZE_3,nItemId=38003210,nItemNum=1,
		mission={
		 [1]={name="#{DHGS_240521_34}",misionid=2321,sceneId=0,x=159,z=109,npcname="B° Ð« Lão T±"}, 
		 [2]={name="#{DHGS_240521_35}",misionid=2322,sceneId=0,x=159,z=109,npcname="B° Ð« Lão T±"}, 
		 [3]={name="#{DHGS_240521_36}",misionid=2323,sceneId=701,x=107,z=103,npcname="Chí tôn Bäo"}, 
		 [4]={name="#{DHGS_240521_37}",misionid=2324,sceneId=701,x=107,z=103,npcname="Chí tôn Bäo"}, 
		 [5]={name="#{DHGS_240521_38}",misionid=2325,sceneId=701,x=107,z=103,npcname="Chí tôn Bäo"}, 
		 [6]={name="#{DHGS_240521_39}",misionid=2326,sceneId=702,x=109,z=184,npcname="TØ Hà"},
		 [7]={name="#{DHGS_240521_40}",misionid=2327,sceneId=702,x=109,z=186,npcname="Chí tôn Bäo"},
		},
 },
}

function DaHua_MainStory_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	--Àë¿ª³¡¾°£¬×Ô¶¯¹Ø± 
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	
	this:RegisterEvent("UPDATE_MAP",false)
	this:RegisterEvent("SCENE_TRANSED",false)
end

function DaHua_MainStory_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_DaHua_MainStory_UnifiedXPosition	= DaHua_MainStory_Frame : GetProperty("UnifiedXPosition");
	g_DaHua_MainStory_UnifiedYPosition	= DaHua_MainStory_Frame : GetProperty("UnifiedYPosition");
	
	g_DaHua_MainStory_Param1 = 0
	g_DaHua_MainStory_Param2 = 0
	g_DaHua_MainStory_Param3 = 0
end

function DaHua_MainStory_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99913201 ) then
		
		local nFuncType = Get_XParam_INT(0)
		if nFuncType == 0 then
			DaHua_MainStory_Frame_Cancel_Clicked()
		elseif nFuncType == 1 then
			g_DaHua_MainStory_Param1 = Get_XParam_INT(1)
			g_DaHua_MainStory_Param2 = Get_XParam_INT(2)
			g_DaHua_MainStory_Param3 = Get_XParam_INT(3)
			DaHua_MainStory_Update()
			this:Show()
		elseif nFuncType == 2 then
			if( this:IsVisible() ) then
				g_DaHua_MainStory_Param1 = Get_XParam_INT(1)
				g_DaHua_MainStory_Param2 = Get_XParam_INT(2)
				g_DaHua_MainStory_Param3 = Get_XParam_INT(3)			
				DaHua_MainStory_Update()
			end
		end
						
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯	
	elseif (event == "ADJEST_UI_POS" ) then
		DaHua_MainStory_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DaHua_MainStory_On_ResetPos()
	
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide();
		
	elseif ( event == "SCENE_TRANSED") then 
		this:Hide()
	elseif ( event == "UPDATE_MAP") then 
		if( this:IsVisible() ) then
			DaHua_MainStory_Update()
		end
		
	end
end

function DaHua_MainStory_Update()

-------------------------------------------------------------------------
--½×¶Î1
	local temp = math.mod(g_DaHua_MainStory_Param1,10000)
	local nData_A = math.floor(temp/1000)
	local nData_B = math.floor((math.mod(temp,1000))/100)
	local nData_C = math.floor((math.mod(temp,100))/10)
	local nData_D = math.mod(temp,10)
	
	--Î´½âËø
	if nData_A == 0 then
		DaHua_MainStory_Client1_Letter1_RewardItem_Client:Show()
		DaHua_MainStory_Client1_Letter1_MissionGuide:Hide()
		DaHua_MainStory_Client1_Letter1_Begin:Hide()
		DaHua_MainStory_Client1_Letter1BK_Lock:Show()
		DaHua_MainStory_Client1_Letter1_Finished:Hide()
		--Ìí¼Ó½±Àø
		DaHua_MainStory_Client1_Letter1_RewardItem_Info1:Show()
		local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[1].nItemId, g_DaHua_MainStory_StepInfo[1].nItemNum)
		if theAction:GetID() ~= 0 then
			DaHua_MainStory_Client1_Letter1_RewardItem:SetActionItem(theAction:GetID())
		end		
		DaHua_MainStory_Client1_Letter1_RewardItem_Mask:Hide()
		DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Hide()			
	elseif nData_A == 1 then
		--ÒÑ½âËø£ºÒÑÍê³ÉÈ«²¿ÈÎÎñ
		if nData_B == 2 then
			DaHua_MainStory_Client1_Letter1_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter1_MissionGuide:Hide()
			DaHua_MainStory_Client1_Letter1_Begin:Hide()
			DaHua_MainStory_Client1_Letter1BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter1_Finished:Show()	
			--DaHua_MainStory_Client1_Letter1BK_FinishedInfo1:SetText("#{DHGS_240521_13}")
			--DaHua_MainStory_Client1_Letter1BK_FinishedInfo2:SetText("#{DHGS_240521_10}")
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter1_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter1_RewardItem_Mask:Show()
					--Ð¡ºìµã£ºÒþ²Ø
					DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Hide()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter1_RewardItem_Mask:Hide()
					--Ð¡ºìµã
					if nData_D == 1 then
						--´ïµ½Áì½±Ìõ¼þ£ºÏÔÊ¾
						DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Show()
					else
						--Î´´ïµ½Áì½±Ìõ¼þ£ºÒþ²Ø
						DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Hide()
					end
				end
				--Ìí¼Ó½±Àø
				local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[1].nItemId, g_DaHua_MainStory_StepInfo[1].nItemNum)
				if theAction:GetID() ~= 0 then
					DaHua_MainStory_Client1_Letter1_RewardItem:SetActionItem(theAction:GetID())
				end				
		--ÒÑ½âËø£ºÎ´Íê³ÉÈ«²¿ÈÎÎñ£¬µ«ÊÇÒÑ½ÓÈ¡»òÍê³ÉµÚ1¸öÈÎÎñ
		elseif nData_B == 1 then
			DaHua_MainStory_Client1_Letter1_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter1_MissionGuide:Show()		
			DaHua_MainStory_Client1_Letter1_Begin:Show()
			DaHua_MainStory_Client1_Letter1BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter1_Finished:Hide()	
			DaHua_MainStory_Client1_Letter1_BeginInfo1:Hide()
			DaHua_MainStory_Client1_Letter1_UnderWayBK:Show()
			if g_DaHua_MainStory_StepInfo[1].mission[nData_C] ~= nil then
				DaHua_MainStory_Client1_Letter1_MissionGuide_Info1:SetText(ScriptGlobal_Format("#{DHGS_240521_18}", g_DaHua_MainStory_StepInfo[1].mission[nData_C].name))
				if DataPool:Lua_IsHaveMission(g_DaHua_MainStory_StepInfo[1].mission[nData_C].misionid) > 0 then
					DaHua_MainStory_Client1_Letter1_MissionGuide_GotoBtn:Hide()
				else
					DaHua_MainStory_Client1_Letter1_MissionGuide_GotoBtn:Show()	
				end
			end
			
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter1_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter1_RewardItem_Mask:Show()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter1_RewardItem_Mask:Hide()
					--´ïµ½Áì½±Ìõ¼þ
					if nData_D == 1 then
						DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Show()
					else
						DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Hide()
					end
					--Ìí¼Ó½±Àø
					local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[1].nItemId, g_DaHua_MainStory_StepInfo[1].nItemNum)
					if theAction:GetID() ~= 0 then
						DaHua_MainStory_Client1_Letter1_RewardItem:SetActionItem(theAction:GetID())
					end
				end		
		--ÒÑ½âËø£ºÎ´½ÓÈ¡»òÍê³ÉÈÎºÎÈÎÎñ
		else
			DaHua_MainStory_Client1_Letter1_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter1_MissionGuide:Show()		
			DaHua_MainStory_Client1_Letter1_Begin:Show()
			DaHua_MainStory_Client1_Letter1BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter1_Finished:Hide()	
			DaHua_MainStory_Client1_Letter1_BeginInfo1:Show()
			DaHua_MainStory_Client1_Letter1_UnderWayBK:Hide()
			if g_DaHua_MainStory_StepInfo[1].mission[nData_C] ~= nil then
				DaHua_MainStory_Client1_Letter1_MissionGuide_Info1:SetText(ScriptGlobal_Format("#{DHGS_240521_18}", g_DaHua_MainStory_StepInfo[1].mission[nData_C].name))
				if DataPool:Lua_IsHaveMission(g_DaHua_MainStory_StepInfo[1].mission[nData_C].misionid) > 0 then
					DaHua_MainStory_Client1_Letter1_MissionGuide_GotoBtn:Hide()
				else
					DaHua_MainStory_Client1_Letter1_MissionGuide_GotoBtn:Show()	
				end			
			end
			--DaHua_MainStory_Client1_Letter1_MissionGuide_GotoBtn:Show()
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter1_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter1_RewardItem_Mask:Show()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter1_RewardItem_Mask:Hide()
					--´ïµ½Áì½±Ìõ¼þ
					if nData_D == 1 then
						DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Show()
					else
						DaHua_MainStory_Client1_Letter1_RewardItem_Tips:Hide()
					end
					--Ìí¼Ó½±Àø
					local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[1].nItemId, g_DaHua_MainStory_StepInfo[1].nItemNum)
					if theAction:GetID() ~= 0 then
						DaHua_MainStory_Client1_Letter1_RewardItem:SetActionItem(theAction:GetID())
					end
				end
		end
	end
-------------------------------------------------------------------------	
--½×¶Î2
	temp = math.mod(g_DaHua_MainStory_Param2,10000)
	nData_A = math.floor(temp/1000)
	nData_B = math.floor((math.mod(temp,1000))/100)
	nData_C = math.floor((math.mod(temp,100))/10)
	nData_D = math.mod(temp,10)

	--Î´½âËø
	if nData_A == 0 then
		DaHua_MainStory_Client1_Letter2_RewardItem_Client:Show()
		DaHua_MainStory_Client1_Letter2_MissionGuide:Hide()
		DaHua_MainStory_Client1_Letter2_Begin:Hide()
		DaHua_MainStory_Client1_Letter2BK_Lock:Show()
		DaHua_MainStory_Client1_Letter2_Finished:Hide()
		--Ìí¼Ó½±Àø
		DaHua_MainStory_Client1_Letter2_RewardItem_Info1:Show()
		local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[2].nItemId, g_DaHua_MainStory_StepInfo[2].nItemNum)
		if theAction:GetID() ~= 0 then
			DaHua_MainStory_Client1_Letter2_RewardItem:SetActionItem(theAction:GetID())
		end		
		DaHua_MainStory_Client1_Letter2_RewardItem_Mask:Hide()
		DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Hide()			
	elseif nData_A == 1 then
		--ÒÑ½âËø£ºÒÑÍê³ÉÈ«²¿ÈÎÎñ
		if nData_B == 2 then
			DaHua_MainStory_Client1_Letter2_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter2_MissionGuide:Hide()
			DaHua_MainStory_Client1_Letter2_Begin:Hide()
			DaHua_MainStory_Client1_Letter2BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter2_Finished:Show()	
			--DaHua_MainStory_Client1_Letter2BK_FinishedInfo1:SetText("#{DHGS_240521_14}")
			--DaHua_MainStory_Client1_Letter2BK_FinishedInfo2:SetText("#{DHGS_240521_11}")
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter2_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter2_RewardItem_Mask:Show()
					--Ð¡ºìµã£ºÒþ²Ø
					DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Hide()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter2_RewardItem_Mask:Hide()
					--Ð¡ºìµã
					if nData_D == 1 then
						--´ïµ½Áì½±Ìõ¼þ£ºÏÔÊ¾
						DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Show()
					else
						--Î´´ïµ½Áì½±Ìõ¼þ£ºÒþ²Ø
						DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Hide()
					end
				end
				--Ìí¼Ó½±Àø
				local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[2].nItemId, g_DaHua_MainStory_StepInfo[2].nItemNum)
				if theAction:GetID() ~= 0 then
					DaHua_MainStory_Client1_Letter2_RewardItem:SetActionItem(theAction:GetID())
				end				
		--ÒÑ½âËø£ºÎ´Íê³ÉÈ«²¿ÈÎÎñ£¬µ«ÊÇÒÑ½ÓÈ¡»òÍê³ÉµÚ1¸öÈÎÎñ
		elseif nData_B == 1 then
			DaHua_MainStory_Client1_Letter2_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter2_MissionGuide:Show()		
			DaHua_MainStory_Client1_Letter2_Begin:Show()
			DaHua_MainStory_Client1_Letter2BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter2_Finished:Hide()	
			DaHua_MainStory_Client1_Letter2_BeginInfo1:Hide()
			DaHua_MainStory_Client1_Letter2_UnderWayBK:Show()
			if g_DaHua_MainStory_StepInfo[2].mission[nData_C] ~= nil then
				DaHua_MainStory_Client1_Letter2_MissionGuide_Info1:SetText(ScriptGlobal_Format("#{DHGS_240521_18}", g_DaHua_MainStory_StepInfo[2].mission[nData_C].name))
				if DataPool:Lua_IsHaveMission(g_DaHua_MainStory_StepInfo[2].mission[nData_C].misionid) > 0 then
					DaHua_MainStory_Client1_Letter2_MissionGuide_GotoBtn:Hide()
				else
					DaHua_MainStory_Client1_Letter2_MissionGuide_GotoBtn:Show()	
				end				
			end
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter2_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter2_RewardItem_Mask:Show()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter2_RewardItem_Mask:Hide()
					--´ïµ½Áì½±Ìõ¼þ
					if nData_D == 1 then
						DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Show()
					else
						DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Hide()
					end
					--Ìí¼Ó½±Àø
					local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[2].nItemId, g_DaHua_MainStory_StepInfo[2].nItemNum)
					if theAction:GetID() ~= 0 then
						DaHua_MainStory_Client1_Letter2_RewardItem:SetActionItem(theAction:GetID())
					end
				end		
		--ÒÑ½âËø£ºÎ´½ÓÈ¡»òÍê³ÉÈÎºÎÈÎÎñ
		else
			DaHua_MainStory_Client1_Letter2_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter2_MissionGuide:Show()		
			DaHua_MainStory_Client1_Letter2_Begin:Show()
			DaHua_MainStory_Client1_Letter2BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter2_Finished:Hide()	
			DaHua_MainStory_Client1_Letter2_BeginInfo1:Show()
			DaHua_MainStory_Client1_Letter2_UnderWayBK:Hide()
			if g_DaHua_MainStory_StepInfo[2].mission[nData_C] ~= nil then
				DaHua_MainStory_Client1_Letter2_MissionGuide_Info1:SetText(ScriptGlobal_Format("#{DHGS_240521_18}", g_DaHua_MainStory_StepInfo[2].mission[nData_C].name))
				if DataPool:Lua_IsHaveMission(g_DaHua_MainStory_StepInfo[2].mission[nData_C].misionid) > 0 then
					DaHua_MainStory_Client1_Letter2_MissionGuide_GotoBtn:Hide()
				else
					DaHua_MainStory_Client1_Letter2_MissionGuide_GotoBtn:Show()	
				end				
			end
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter2_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter2_RewardItem_Mask:Show()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter2_RewardItem_Mask:Hide()
					--´ïµ½Áì½±Ìõ¼þ
					if nData_D == 1 then
						DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Show()
					else
						DaHua_MainStory_Client1_Letter2_RewardItem_Tips:Hide()
					end
					--Ìí¼Ó½±Àø
					local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[2].nItemId, g_DaHua_MainStory_StepInfo[2].nItemNum)
					if theAction:GetID() ~= 0 then
						DaHua_MainStory_Client1_Letter2_RewardItem:SetActionItem(theAction:GetID())
					end
				end
		end
	end	
-------------------------------------------------------------------------
	
--½×¶Î3
	temp = math.mod(g_DaHua_MainStory_Param3,10000)
	nData_A = math.floor(temp/1000)
	nData_B = math.floor((math.mod(temp,1000))/100)
	nData_C = math.floor((math.mod(temp,100))/10)
	nData_D = math.mod(temp,10)

	--Î´½âËø
	if nData_A == 0 then
		DaHua_MainStory_Client1_Letter3_RewardItem_Client:Show()
		DaHua_MainStory_Client1_Letter3_MissionGuide:Hide()
		DaHua_MainStory_Client1_Letter3_Begin:Hide()
		DaHua_MainStory_Client1_Letter3BK_Lock:Show()
		DaHua_MainStory_Client1_Letter3_Finished:Hide()
		--Ìí¼Ó½±Àø
		DaHua_MainStory_Client1_Letter3_RewardItem_Info1:Show()
		local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[3].nItemId, g_DaHua_MainStory_StepInfo[3].nItemNum)
		if theAction:GetID() ~= 0 then
			DaHua_MainStory_Client1_Letter3_RewardItem:SetActionItem(theAction:GetID())
		end		
		DaHua_MainStory_Client1_Letter3_RewardItem_Mask:Hide()
		DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Hide()		
	elseif nData_A == 1 then
		--ÒÑ½âËø£ºÒÑÍê³ÉÈ«²¿ÈÎÎñ
		if nData_B == 2 then
			DaHua_MainStory_Client1_Letter3_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter3_MissionGuide:Hide()
			DaHua_MainStory_Client1_Letter3_Begin:Hide()
			DaHua_MainStory_Client1_Letter3BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter3_Finished:Show()	
			--DaHua_MainStory_Client1_Letter3BK_FinishedInfo1:SetText("#{DHGS_240521_15}")
			--DaHua_MainStory_Client1_Letter3BK_FinishedInfo2:SetText("#{DHGS_240521_12}")
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter3_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter3_RewardItem_Mask:Show()
					--Ð¡ºìµã£ºÒþ²Ø
					DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Hide()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter3_RewardItem_Mask:Hide()
					--Ð¡ºìµã
					if nData_D == 1 then
						--´ïµ½Áì½±Ìõ¼þ£ºÏÔÊ¾
						DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Show()
					else
						--Î´´ïµ½Áì½±Ìõ¼þ£ºÒþ²Ø
						DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Hide()
					end
				end
				--Ìí¼Ó½±Àø
				local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[3].nItemId, g_DaHua_MainStory_StepInfo[3].nItemNum)
				if theAction:GetID() ~= 0 then
					DaHua_MainStory_Client1_Letter3_RewardItem:SetActionItem(theAction:GetID())
				end				
		--ÒÑ½âËø£ºÎ´Íê³ÉÈ«²¿ÈÎÎñ£¬µ«ÊÇÒÑ½ÓÈ¡»òÍê³ÉµÚ1¸öÈÎÎñ
		elseif nData_B == 1 then
			DaHua_MainStory_Client1_Letter3_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter3_MissionGuide:Show()		
			DaHua_MainStory_Client1_Letter3_Begin:Show()
			DaHua_MainStory_Client1_Letter3BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter3_Finished:Hide()	
			DaHua_MainStory_Client1_Letter3_BeginInfo1:Hide()
			DaHua_MainStory_Client1_Letter3_UnderWayBK:Show()
			if g_DaHua_MainStory_StepInfo[3].mission[nData_C] ~= nil then
				DaHua_MainStory_Client1_Letter3_MissionGuide_Info1:SetText(ScriptGlobal_Format("#{DHGS_240521_18}", g_DaHua_MainStory_StepInfo[3].mission[nData_C].name))
				if DataPool:Lua_IsHaveMission(g_DaHua_MainStory_StepInfo[3].mission[nData_C].misionid) > 0 then
					DaHua_MainStory_Client1_Letter3_MissionGuide_GotoBtn:Hide()
				else
					DaHua_MainStory_Client1_Letter3_MissionGuide_GotoBtn:Show()	
				end				
			end
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter3_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter3_RewardItem_Mask:Show()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter3_RewardItem_Mask:Hide()
					--´ïµ½Áì½±Ìõ¼þ
					if nData_D == 1 then
						DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Show()
					else
						DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Hide()
					end
					--Ìí¼Ó½±Àø
					local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[3].nItemId, g_DaHua_MainStory_StepInfo[3].nItemNum)
					if theAction:GetID() ~= 0 then
						DaHua_MainStory_Client1_Letter3_RewardItem:SetActionItem(theAction:GetID())
					end
				end		
		--ÒÑ½âËø£ºÎ´½ÓÈ¡»òÍê³ÉÈÎºÎÈÎÎñ
		else
			DaHua_MainStory_Client1_Letter3_RewardItem_Client:Show()
			DaHua_MainStory_Client1_Letter3_MissionGuide:Show()		
			DaHua_MainStory_Client1_Letter3_Begin:Show()
			DaHua_MainStory_Client1_Letter3BK_Lock:Hide()
			DaHua_MainStory_Client1_Letter3_Finished:Hide()	
			DaHua_MainStory_Client1_Letter3_BeginInfo1:Show()
			DaHua_MainStory_Client1_Letter3_UnderWayBK:Hide()
			if g_DaHua_MainStory_StepInfo[3].mission[nData_C] ~= nil then
				DaHua_MainStory_Client1_Letter3_MissionGuide_Info1:SetText(ScriptGlobal_Format("#{DHGS_240521_18}", g_DaHua_MainStory_StepInfo[3].mission[nData_C].name))
				if DataPool:Lua_IsHaveMission(g_DaHua_MainStory_StepInfo[3].mission[nData_C].misionid) > 0 then
					DaHua_MainStory_Client1_Letter3_MissionGuide_GotoBtn:Hide()
				else
					DaHua_MainStory_Client1_Letter3_MissionGuide_GotoBtn:Show()	
				end				
			end
			--½±Àø²¿·Ö
				DaHua_MainStory_Client1_Letter3_RewardItem_Info1:Show()
				--ÒÑÁì½±
				if nData_D == 2 then
					--ÒÑÁì½±£º¶Ô¹´£¬ÏÔÊ¾
					DaHua_MainStory_Client1_Letter3_RewardItem_Mask:Show()
				--Î´Áì½±
				else
					--ÒÑÁì½±£º¶Ô¹´£¬Òþ²Ø
					DaHua_MainStory_Client1_Letter3_RewardItem_Mask:Hide()
					--´ïµ½Áì½±Ìõ¼þ
					if nData_D == 1 then
						DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Show()
					else
						DaHua_MainStory_Client1_Letter3_RewardItem_Tips:Hide()
					end
					--Ìí¼Ó½±Àø
					local theAction = DataPool:CreateActionItemForShow(g_DaHua_MainStory_StepInfo[3].nItemId, g_DaHua_MainStory_StepInfo[3].nItemNum)
					if theAction:GetID() ~= 0 then
						DaHua_MainStory_Client1_Letter3_RewardItem:SetActionItem(theAction:GetID())
					end
				end
		end
	end	
	
end
	
function DaHua_MainStory_MissionGuide_GotoBtn(nIndex)

	if nIndex == 1 then
		--½×¶Î1
		local temp = math.mod(g_DaHua_MainStory_Param1,10000)
		local nData_A = math.floor(temp/1000)
		local nData_B = math.floor((math.mod(temp,1000))/100)
		local nData_C = math.floor((math.mod(temp,100))/10)
		local nData_D = math.mod(temp,10)	
		
		--Ñ°Â·
		if g_DaHua_MainStory_StepInfo[1].mission[nData_C] ~= nil then
			local resId = g_DaHua_MainStory_StepInfo[1].mission[nData_C].sceneId
			local posx = g_DaHua_MainStory_StepInfo[1].mission[nData_C].x
			local posz = g_DaHua_MainStory_StepInfo[1].mission[nData_C].z
			local name = g_DaHua_MainStory_StepInfo[1].mission[nData_C].npcname
			AutoRuntoTargetExWithName(posx, posz, resId, name)
		end
		
	elseif nIndex == 2 then
		--½×¶Î2
		local temp = math.mod(g_DaHua_MainStory_Param2,10000)
		local nData_A = math.floor(temp/1000)
		local nData_B = math.floor((math.mod(temp,1000))/100)
		local nData_C = math.floor((math.mod(temp,100))/10)
		local nData_D = math.mod(temp,10)

		--Ñ°Â·
		if g_DaHua_MainStory_StepInfo[2].mission[nData_C] ~= nil then
			local resId = g_DaHua_MainStory_StepInfo[2].mission[nData_C].sceneId
			local posx = g_DaHua_MainStory_StepInfo[2].mission[nData_C].x
			local posz = g_DaHua_MainStory_StepInfo[2].mission[nData_C].z
			local name = g_DaHua_MainStory_StepInfo[2].mission[nData_C].npcname
			AutoRuntoTargetExWithName(posx, posz, resId, name)
		end
		
	elseif nIndex == 3 then
		--½×¶Î3
		local temp = math.mod(g_DaHua_MainStory_Param3,10000)
		local nData_A = math.floor(temp/1000)
		local nData_B = math.floor((math.mod(temp,1000))/100)
		local nData_C = math.floor((math.mod(temp,100))/10)
		local nData_D = math.mod(temp,10)

		--Ñ°Â·
		if g_DaHua_MainStory_StepInfo[3].mission[nData_C] ~= nil then
			local resId = g_DaHua_MainStory_StepInfo[3].mission[nData_C].sceneId
			local posx = g_DaHua_MainStory_StepInfo[3].mission[nData_C].x
			local posz = g_DaHua_MainStory_StepInfo[3].mission[nData_C].z
			local name = g_DaHua_MainStory_StepInfo[3].mission[nData_C].npcname
			AutoRuntoTargetExWithName(posx, posz, resId, name)
		end
		
	end

end

function DaHua_MainStory_LockClicked(nIndex)

	if nIndex == 1 then
		local temp = math.mod(g_DaHua_MainStory_Param1,10000)
		local nData_A = math.floor(temp/1000)	
		if nData_A == 0 then
			temp = math.floor( math.mod(g_DaHua_MainStory_Param1,100000 ) / 10000)
			if temp == 1 then
				PushDebugMessage("#{DHGS_240521_21}")
			elseif temp == 2 then
				PushDebugMessage("#{DHGS_240521_06}")
			end
		end
	elseif nIndex == 2 then
		local temp = math.mod(g_DaHua_MainStory_Param2,10000)
		local nData_A = math.floor(temp/1000)	
		if nData_A == 0 then
			temp = math.floor( math.mod(g_DaHua_MainStory_Param2,100000 ) / 10000)
			if temp == 1 then
				PushDebugMessage("#{DHGS_240521_05}")
			elseif temp == 2 then
				PushDebugMessage("#{DHGS_240521_06}")
			elseif temp == 3 then
				PushDebugMessage("#{DHGS_240521_07}")
			end
		end	
	elseif nIndex == 3 then
		local temp = math.mod(g_DaHua_MainStory_Param3,10000)
		local nData_A = math.floor(temp/1000)	
		if nData_A == 0 then
			temp = math.floor( math.mod(g_DaHua_MainStory_Param3,100000 ) / 10000)
			if temp == 1 then
				PushDebugMessage("#{DHGS_240521_09}")
			elseif temp == 2 then
				PushDebugMessage("#{DHGS_240521_06}")
			elseif temp == 3 then
				PushDebugMessage("#{DHGS_240521_08}")
			end
		end		
	end
	
end

function DaHua_MainStory_GetPrize_Clicked(nIndex)

	if nIndex~=1 and nIndex~=2 and nIndex~=3 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetPrize" )
		Set_XSCRIPT_ScriptID( 999132 )
		Set_XSCRIPT_Parameter( 0, nIndex )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	
end

--================================================
-- ¹Ø± ½çÃæ
--================================================
function DaHua_MainStory_Frame_Cancel_Clicked()
	this:Hide()
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function DaHua_MainStory_On_ResetPos()

	DaHua_MainStory_Frame : SetProperty("UnifiedXPosition", g_DaHua_MainStory_UnifiedXPosition);
	DaHua_MainStory_Frame : SetProperty("UnifiedYPosition", g_DaHua_MainStory_UnifiedYPosition);

end

