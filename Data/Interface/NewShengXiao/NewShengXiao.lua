local g_Frame_UnifiedPosition
local g_process_textctrl = {}
local g_accept_imgctrl = {}
local g_finish_imgctrl = {}
local g_mask_imgctrl = {}
local g_missionbox_ctrl = {}

local g_go_ctrl = {}
local g_NewShengXiao_MisDay = {
[2350]={20250121,20250124},
[2351]={20250122,20250124},
[2352]={20250122,20250124},
[2353]={20250123,20250124},
[2354]={20250123,20250124},
[2355]={20250124,20250124},
}
local g_NewShengXiao_MaskDay = {
20250121,
20250122,
20250123,
20250124,
}
local g_NewShengXiao_BoxDay = {
20250125,
20250126,
20250127,
}

local g_NewShengXiao_MisID = {2350,2351,2352,2353,2354,2355}

local g_MissionPos={
[1]={scn=2,x=160,z=157,npcname="Tri®u Thiên Sß"},--??1
[2]={scn=0,x=158,z=105,npcname="Long Ti¬u Uy"},--??2
[3]={scn=0,x=158,z=105,npcname="Long Ti¬u Uy"},--??4
[4]={scn=0,x=158,z=105,npcname="Long Ti¬u Uy"},--??6
[5]={scn=0,x=161,z=105,npcname="Xà Ti¬u ThuÜ"},--??1-3
}
local g_NewShengXiao_submitMFs = {}
local g_NewShengXiao_misprizeMFs = {}
local g_NewShengXiao_boxprizeMFs = {}
local g_NewShengXiao_mddata = 0
--=========
-- PreLoad()
--=========
function NewShengXiao_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function NewShengXiao_OnLoad()

	g_Frame_UnifiedPosition = NewShengXiao_Frame:GetProperty("UnifiedPosition")
	g_process_textctrl = {
		NewShengXiao_1_MissionProcess,	NewShengXiao_2_MissionProcess,	NewShengXiao_3_MissionProcess,	NewShengXiao_4_MissionProcess,
	}
	g_accept_imgctrl = {
		NewShengXiao_1_AcceptImage, NewShengXiao_2_AcceptImage, NewShengXiao_3_AcceptImage, NewShengXiao_4_AcceptImage
	}
	g_finish_imgctrl = {
		NewShengXiao_1_TaskOverImage, NewShengXiao_2_TaskOverImage, NewShengXiao_3_TaskOverImage, NewShengXiao_4_TaskOverImage
	}
	g_mask_imgctrl = {
		NewShengXiao_1_HighLight, NewShengXiao_2_HighLight, NewShengXiao_3_HighLight, NewShengXiao_4_HighLight
	}
	g_missionbox_ctrl = {
		{btn=NewShengXiao_1_BK_ItemBtn, openimg=NewShengXiao_1_BK_ItemImage, animate=NewShengXiao_1_BK_Light, greyimg=NewShengXiao_1_BK_ItemBtn_Gray},
		{btn=NewShengXiao_2_BK_ItemBtn, openimg=NewShengXiao_2_BK_ItemImage, animate=NewShengXiao_2_BK_Light, greyimg=NewShengXiao_2_BK_ItemBtn_Gray},
		{btn=NewShengXiao_3_BK_ItemBtn, openimg=NewShengXiao_3_BK_ItemImage, animate=NewShengXiao_3_BK_Light, greyimg=NewShengXiao_3_BK_ItemBtn_Gray},
		{btn=NewShengXiao_4_BK_ItemBtn, openimg=NewShengXiao_4_BK_ItemImage, animate=NewShengXiao_4_BK_Light, greyimg=NewShengXiao_4_BK_ItemBtn_Gray},
	}
	g_go_ctrl = {
		{btn=NewShengXiao_1_Btn, maskimg=NewShengXiao_1_Btn_TimeOutImage},
		{btn=NewShengXiao_2_Btn, maskimg=NewShengXiao_2_Btn_TimeOutImage},
		{btn=NewShengXiao_3_Btn, maskimg=NewShengXiao_3_Btn_TimeOutImage},
		{btn=NewShengXiao_4_Btn, maskimg=NewShengXiao_4_Btn_TimeOutImage},
	}
end

--=========
-- Event
--=========
function NewShengXiao_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 35000001 then

		local param = Get_XParam_INT(0)
		if param == 1 then
			--´ò¿ª½çÃæ
			NewShengXiao_InitData(Get_XParam_INT(1), Get_XParam_INT(2), Get_XParam_INT(3), Get_XParam_INT(4))
			NewShengXiao_Update()
			this:Show()
		elseif param == 2 and this:IsVisible() then
			NewShengXiao_InitData(Get_XParam_INT(1), Get_XParam_INT(2), Get_XParam_INT(3), Get_XParam_INT(4))
			--´ò¿ª½çÃæ
			NewShengXiao_Update()
		elseif param == 3 then
			--¹Ø± ½çÃæ
			NewShengXiao_Close()
		end
		
	elseif event == "HIDE_ON_SCENE_TRANSED" then

		NewShengXiao_Close()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		NewShengXiao_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		NewShengXiao_ResetPos()
	
	end

end

function NewShengXiao_InitData(submitMFs, misprizeMFs, boxprizeMFs, mddata)
	for i=1,6 do
		g_NewShengXiao_submitMFs[i] = math.mod(submitMFs,10)
		submitMFs = math.floor(submitMFs/10)
	end
	for i=1,4 do
		g_NewShengXiao_misprizeMFs[i] = math.mod(misprizeMFs,10)
		misprizeMFs = math.floor(misprizeMFs/10)
	end
	for i=1,3 do
		g_NewShengXiao_boxprizeMFs[i] = math.mod(boxprizeMFs,10)
		boxprizeMFs = math.floor(boxprizeMFs/10)
	end
	--Ê¹ÓÃ´ÎÊý2Î»(×î¶à10´Î) + ÁìÈ¡Ê±¼ä8Î»
	g_NewShengXiao_mddata = mddata
end

function NewShengXiao_Update()
	--ÈÎÎñ
	local curDay = tonumber(DataPool:GetServerDayTime())
	for i=1,6 do
		if i == 1 or i == 6 then
			local ictrl = i
			if i == 6 then ictrl = 4 end;
			--Ö»¿´Ò»¸öÈÎÎñ
			local missionId = g_NewShengXiao_MisID[i]
			local bHaveMission = DataPool:Lua_IsHaveMission(missionId)
			if g_NewShengXiao_submitMFs[i] == 1 then
				g_accept_imgctrl[ictrl]:Hide()
				g_finish_imgctrl[ictrl]:Show()
				g_go_ctrl[ictrl].btn:Hide()
				g_go_ctrl[ictrl].maskimg:Hide()
			elseif bHaveMission > 0 then
				g_accept_imgctrl[ictrl]:Show()
				g_finish_imgctrl[ictrl]:Hide()
				if curDay > g_NewShengXiao_MisDay[missionId][2] then
					--¹ýÆÚ
					g_go_ctrl[ictrl].btn:Hide()
					g_go_ctrl[ictrl].maskimg:Show()
				else
					g_go_ctrl[ictrl].btn:Show()
					g_go_ctrl[ictrl].maskimg:Hide()
				end
			else
				if curDay >= g_NewShengXiao_MisDay[missionId][1] and curDay <= g_NewShengXiao_MisDay[missionId][2] then
					g_accept_imgctrl[ictrl]:Hide()
					g_finish_imgctrl[ictrl]:Hide()
					g_go_ctrl[ictrl].btn:Show()
					g_go_ctrl[ictrl].maskimg:Hide()
				elseif curDay < g_NewShengXiao_MisDay[missionId][1] then
					--Ã»¿ªÊ¼
					g_accept_imgctrl[ictrl]:Hide()
					g_finish_imgctrl[ictrl]:Hide()
					
					g_go_ctrl[ictrl].btn:Show()
					g_go_ctrl[ictrl].maskimg:Hide()
				else
					--¹ýÆÚ
					g_accept_imgctrl[ictrl]:Hide()
					g_finish_imgctrl[ictrl]:Hide()
					
					g_go_ctrl[ictrl].btn:Hide()
					g_go_ctrl[ictrl].maskimg:Show()
				end
			end
			local bSubmit = g_NewShengXiao_submitMFs[i]
			local str = ScriptGlobal_Format("#{SXXG_241111_323}", bSubmit)
			g_process_textctrl[ictrl]:SetText(str)
		elseif i == 2 or i == 4 then
			--¿´Á½¸öÈÎÎñ
			local ictrl = i
			if i == 4 then ictrl = 3 end
			local missionId1 = g_NewShengXiao_MisID[i]
			local missionId2 = g_NewShengXiao_MisID[i+1]
			local bHaveMission1 = DataPool:Lua_IsHaveMission(missionId1)
			local bHaveMission2 = DataPool:Lua_IsHaveMission(missionId2)
			if g_NewShengXiao_submitMFs[i+1] == 1 then
				g_accept_imgctrl[ictrl]:Hide()
				g_finish_imgctrl[ictrl]:Show()
				g_go_ctrl[ictrl].btn:Hide()
				g_go_ctrl[ictrl].maskimg:Hide()
			elseif bHaveMission1 > 0 then
				g_accept_imgctrl[ictrl]:Show()
				g_finish_imgctrl[ictrl]:Hide()
				if curDay > g_NewShengXiao_MisDay[missionId1][2] then
					--¹ýÆÚ
					g_go_ctrl[ictrl].btn:Hide()
					g_go_ctrl[ictrl].maskimg:Show()
				else
					g_go_ctrl[ictrl].btn:Show()
					g_go_ctrl[ictrl].maskimg:Hide()
				end
			elseif bHaveMission2 > 0 then
				g_accept_imgctrl[ictrl]:Show()
				g_finish_imgctrl[ictrl]:Hide()
				if curDay > g_NewShengXiao_MisDay[missionId1][2] then
					--¹ýÆÚ
					g_go_ctrl[ictrl].btn:Hide()
					g_go_ctrl[ictrl].maskimg:Show()
				else
					g_go_ctrl[ictrl].btn:Show()
					g_go_ctrl[ictrl].maskimg:Hide()
				end
			else
				if curDay >= g_NewShengXiao_MisDay[missionId1][1] and curDay <= g_NewShengXiao_MisDay[missionId1][2] then
					g_accept_imgctrl[ictrl]:Hide()
					g_finish_imgctrl[ictrl]:Hide()
					g_go_ctrl[ictrl].btn:Show()
					g_go_ctrl[ictrl].maskimg:Hide()
				elseif curDay < g_NewShengXiao_MisDay[missionId1][1] then
					--Ã»¿ªÊ¼
					g_accept_imgctrl[ictrl]:Hide()
					g_finish_imgctrl[ictrl]:Hide()
					g_go_ctrl[ictrl].btn:Show()
					g_go_ctrl[ictrl].maskimg:Hide()
				else
					--¹ýÆÚ
					g_accept_imgctrl[ictrl]:Hide()
					g_finish_imgctrl[ictrl]:Hide()
					g_go_ctrl[ictrl].btn:Hide()
					g_go_ctrl[ictrl].maskimg:Show()
				end
			end
			local bSubmit = g_NewShengXiao_submitMFs[i] + g_NewShengXiao_submitMFs[i+1]
			local str = ScriptGlobal_Format("#{SXXG_241111_324}", bSubmit)
			g_process_textctrl[ictrl]:SetText(str)
		end
	end
	--ÃÉ°æ
	for i=1,4 do
		if curDay >= g_NewShengXiao_MaskDay[i] then
			g_mask_imgctrl[i]:Hide()
		else
			g_mask_imgctrl[i]:Show()
		end
	end
	--½ø¶È
	for i=1,4 do
		local misIdx = i
		if i == 3 then misIdx = 4 end;
		if i == 4 then misIdx = 6 end;
		if g_NewShengXiao_misprizeMFs[i] == 1 then
			--ÒÑÁìÈ¡
			g_missionbox_ctrl[i].animate:Hide()
			g_missionbox_ctrl[i].openimg:Show()
			g_missionbox_ctrl[i].btn:Hide()
			g_missionbox_ctrl[i].greyimg:Hide()
		else

			local missionId = g_NewShengXiao_MisID[misIdx]
			if i == 1 or i == 4 then
				--Ò»¸öÈÎÎñ
				if g_NewShengXiao_submitMFs[misIdx] == 1 then
					g_missionbox_ctrl[i].animate:Show()
					g_missionbox_ctrl[i].greyimg:Hide()
					g_missionbox_ctrl[i].btn:Show()
					g_missionbox_ctrl[i].openimg:Hide()
				elseif curDay > g_NewShengXiao_MisDay[missionId][2] then
					--¹ýÆÚÁË
					g_missionbox_ctrl[i].animate:Hide()
					g_missionbox_ctrl[i].greyimg:Show()
					g_missionbox_ctrl[i].btn:Hide()
					g_missionbox_ctrl[i].openimg:Hide()
				else
					g_missionbox_ctrl[i].animate:Hide()
					g_missionbox_ctrl[i].greyimg:Hide()
					g_missionbox_ctrl[i].btn:Show()
					g_missionbox_ctrl[i].openimg:Hide()
				end
			elseif i == 2 or i == 3 then
				--ÖÐ¼äÁ½¸öÈÎÎñ
				if g_NewShengXiao_submitMFs[misIdx+1] == 1 then
					g_missionbox_ctrl[i].animate:Show()
					g_missionbox_ctrl[i].greyimg:Hide()
					g_missionbox_ctrl[i].btn:Show()
					g_missionbox_ctrl[i].openimg:Hide()
				elseif curDay > g_NewShengXiao_MisDay[missionId][2] then
					--¹ýÆÚÁË
					g_missionbox_ctrl[i].animate:Hide()
					g_missionbox_ctrl[i].greyimg:Show()
					g_missionbox_ctrl[i].btn:Hide()
					g_missionbox_ctrl[i].openimg:Hide()
				else
					g_missionbox_ctrl[i].animate:Hide()
					g_missionbox_ctrl[i].greyimg:Hide()
					g_missionbox_ctrl[i].btn:Show()
					g_missionbox_ctrl[i].openimg:Hide()
				end
			end
		end
	end

	--Áì½±²¿·Ö ¸£×Ö
	local curDay = tonumber(DataPool:GetServerDayTime())
	if curDay < g_NewShengXiao_BoxDay[1] then
		NewShengXiao_5_ChestBtn_Open:Hide()
		NewShengXiao_5_ChestBtn:Hide()
		NewShengXiao_5_FuZi_GoToBtn:Hide()
		NewShengXiao_5_FuZi_Disable:Show()--????????,?????
		NewShengXiao_5_BK_Light:Hide()
		NewShengXiao_5_MissionProcess:SetText( "#{SXXG_241111_347}" )
	elseif curDay >= g_NewShengXiao_BoxDay[1] and curDay <= g_NewShengXiao_BoxDay[3] then
		local md = g_NewShengXiao_mddata 
		local mdday = math.mod(md,100000000)
		local usecount = math.floor(md/100000000)
		if mdday == curDay then
			--ÒÑ¾­Áì¹ý¸£ÌùÁË
			NewShengXiao_5_FuZi_GoToBtn:Hide()--????????????,????,????!
			NewShengXiao_5_FuZi_Disable:Hide()--????????,?????

			local curIdx = 1
			if curDay == g_NewShengXiao_BoxDay[2] then
				curIdx = 2
			elseif curDay == g_NewShengXiao_BoxDay[3] then
				curIdx = 3
			end
			if g_NewShengXiao_boxprizeMFs[curIdx] == 1 then
				--ÒÑ¾­Áì¹ý½±ÁË
				NewShengXiao_5_ChestBtn_Open:Show()
				NewShengXiao_5_ChestBtn:Hide()
				NewShengXiao_5_BK_Light:Hide()
				NewShengXiao_5_MissionProcess:SetText( "#{SXXG_241111_349}" )
			elseif usecount >= 10 then
				NewShengXiao_5_ChestBtn_Open:Hide()
				NewShengXiao_5_ChestBtn:Show()
				NewShengXiao_5_BK_Light:Show()
				local processText = ScriptGlobal_Format("#{SXXG_241111_312}", usecount)
				NewShengXiao_5_MissionProcess:SetText( processText )
			else
				NewShengXiao_5_ChestBtn_Open:Hide()
				NewShengXiao_5_ChestBtn:Show()
				NewShengXiao_5_BK_Light:Hide()
				local processText = ScriptGlobal_Format("#{SXXG_241111_312}", usecount)
				NewShengXiao_5_MissionProcess:SetText( processText )
			end
		else
			--È¥Áì¸£Ìù
			NewShengXiao_5_ChestBtn_Open:Hide()
			NewShengXiao_5_ChestBtn:Hide()
			NewShengXiao_5_FuZi_GoToBtn:Show()--????????????,????,????!
			NewShengXiao_5_FuZi_Disable:Hide()--????????,?????
			NewShengXiao_5_BK_Light:Show()
			NewShengXiao_5_MissionProcess:SetText("#{SXXG_241111_348}")
		end
	elseif curDay > g_NewShengXiao_BoxDay[3] then
	end
end

--µ÷ û£º½çÃæÎ»ÖÃ
function NewShengXiao_ResetPos()
	NewShengXiao_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--¹Ø± £º½çÃæ
function NewShengXiao_Close()
	this:Hide()
end

function NewShengXiao_GoBtn_Clicked(nIndex)

	local curDay = tonumber(DataPool:GetServerDayTime())
	if curDay < g_NewShengXiao_MisDay[2350][1] then
		PushDebugMessage("#{SXXG_241111_11}")
		return
	end
	if curDay > g_NewShengXiao_BoxDay[3] then
		PushDebugMessage("#{SXXG_241111_11}")
		return
	end

	local nPlayerLevel = Player:GetData("LEVEL")
	if nPlayerLevel < 30 then
		PushDebugMessage("#{SXXG_241111_12}")
		return
	end
	if g_MissionPos[nIndex] ~= nil then
		AutoRuntoTargetExWithName(g_MissionPos[nIndex].x, g_MissionPos[nIndex].z, g_MissionPos[nIndex].scn, g_MissionPos[nIndex].npcname)
		NewShengXiao_Close()
	end
end

function NewShengXiao_ItemBtn_Clicked(nIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGetPrize")
		Set_XSCRIPT_ScriptID(350000)
		Set_XSCRIPT_Parameter(0, nIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
function NewShengXiao_HelpClk()
	PushEvent("QUEST_HELPINFO", "#{SXXG_241111_03}")
end
