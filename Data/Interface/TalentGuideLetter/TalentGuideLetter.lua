local g_Frame_UnifiedPosition
local MP_SHAOLIN  = 0
local MP_MINGJIAO = 1
local MP_GAIBANG  = 2
local MP_WUDANG   = 3
local MP_EMEI     = 4
local MP_XINGSU   = 5
local MP_DALI     = 6
local MP_TIANSHAN = 7
local MP_XIAOYAO  = 8
local MP_COUNT    = 9  --用来做判断使用的，最大不能超过这个数，如果需要新增门派，在这个宏之前增加，并修改这个宏的值
local MP_MANTUO = 10
local MP_MENPAI11 = 11--menpai11

local g_NPC = {
	[MP_SHAOLIN] = {sceneId=9, name={[1]="玄阅",[2]="玄篱",}, pos = {[1] = {132, 142}, [2] = {73, 149}}},
	[MP_MINGJIAO] = {sceneId=11, name={ [1]="莫思归",[2]="林焱",}, pos = {[1] = {50, 119}, [2] = {131, 138}}},
	[MP_GAIBANG] = {sceneId=10, name={[1]="杜少康",[2]="路老大",}, pos = {[1] = {129, 112}, [2] = {55, 135}}},
	[MP_WUDANG] = {sceneId=12, name={[1]="碧落散人", [2]="逐浪散人"}, pos = {[1] = {49, 181}, [2] = {46, 130}}},
	[MP_EMEI] = {sceneId=15, name={[1]="聚落花", [2]="苏戈"}, pos = {[1] = {157, 125}, [2] = {131, 100}}},
	[MP_XINGSU] = {sceneId=16, name={[1]="蒿莱子", [2]="莲舟子"}, pos = {[1] = {64, 144}, [2] = {70, 111}}},
	[MP_DALI] = {sceneId=13, name={[1]="本喜", [2]="本然"}, pos = {[1] = {58, 110}, [2] = {38, 109}}},
	[MP_TIANSHAN] = {sceneId=17, name={[1]="吴森森", [2]="吴淼淼"}, pos = {[1] = {47, 102}, [2] = {53, 118}}},
	[MP_XIAOYAO] = {sceneId=14, name={[1]="艾凉河", [2]="秦烟萝"}, pos = {[1] = {110, 151}, [2] = {95, 127}}},
	[MP_MANTUO] = {sceneId=592, name={[1]="嵇聆风", [2]="嵇扶光"}, pos = {[1] = {185, 142}, [2] = {183, 132}}}, --替代2022
	[MP_MENPAI11] = {sceneId=703, name={[1]="山人木", [2]="山姥"}, pos = {[1] = {105, 31}, [2] = {201, 43}}}, --menpai11
}

local g_TargetNPC = {

	[MP_SHAOLIN] = {sceneId=9, name="玄慈", posx = 38, posy = 98,},
	[MP_MINGJIAO] = {sceneId=11, name="林世长", posx = 98, posy = 52,},
	[MP_GAIBANG] = {sceneId=10, name="宋慈", posx = 92, posy = 64,},
	[MP_WUDANG] = {sceneId=12, name="张玄素", posx = 77, posy = 85,},
	[MP_EMEI] = {sceneId=15, name="孟青青", posx = 96, posy = 73,},
	[MP_XINGSU] = {sceneId=16, name="丁春秋", posx = 142, posy = 55,},
	[MP_DALI] = {sceneId=13, name="本因", posx = 96, posy = 66,},
	[MP_TIANSHAN] = {sceneId=17, name="梅剑", posx = 91, posy = 44,},
	[MP_XIAOYAO] = {sceneId=14, name="苏星河", posx = 125, posy = 144,},
	[MP_MANTUO] = {sceneId=592, name="王夫人", posx = 140, posy = 75,},
	[MP_MENPAI11] = {sceneId=703, name="山鬼", posx = 83, posy = 26,},--menpai11
}

local g_FenYe = 0
local g_IsShow = 0
--=========
-- PreLoad()
--=========
function TalentGuideLetter_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function TalentGuideLetter_OnLoad()

	g_Frame_UnifiedPosition = TalentGuideLetter_Frame:GetProperty("UnifiedPosition")
	
end

--=========
-- Event
--=========
function TalentGuideLetter_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 89121801 then
		g_IsShow = 1
		local param = Get_XParam_INT(0)
		if param == 1 then
			--打开界面
			TalentGuideLetter_ShowFrame(1)
			TalentGuideLetter_Btn2:SetProperty("Disabled", "True"); 
			TalentGuideLetter_Btn3:SetProperty("Disabled", "True");   
			TalentGuideLetter_Btn4:SetProperty("Disabled", "True");  
			this:Show()
		elseif param == 2 then
			--自动寻路：找npc
			TalentGuideLetter_GoToFindNpc()
		elseif param == 3 then
			--关闭界面
			TalentGuideLetter_OnHiden()
		end
		

	elseif event == "UI_COMMAND" and tonumber(arg0) == 89324201 then
		local param = Get_XParam_INT(0)
		g_IsShow = 0
		if param == 1 then
			--打开界面
			TalentGuideLetter_ShowFrame(2)
			TalentGuideLetter_Btn2:SetProperty("Disabled", "False");  
			TalentGuideLetter_Btn3:SetProperty("Disabled", "True");  
			TalentGuideLetter_Btn4:SetProperty("Disabled", "True");  
			this:Show()
		elseif param == 2 then
			--自动寻路：找npc
			TalentGuideLetter_GoToFindNpc()
		elseif param == 3 then
			--关闭界面
			TalentGuideLetter_OnHiden()
		end

	elseif event == "UI_COMMAND" and tonumber(arg0) == 99835201 then
		local param = Get_XParam_INT(0)
		g_IsShow = 0
		if param == 1 then
			--打开界面
			TalentGuideLetter_ShowFrame(3)
			TalentGuideLetter_Btn1:SetProperty("Disabled", "False");  
			TalentGuideLetter_Btn2:SetProperty("Disabled", "False");  
			TalentGuideLetter_Btn3:SetProperty("Disabled", "False");
			TalentGuideLetter_Btn4:SetProperty("Disabled", "True");    
			this:Show()
		elseif param == 2 then
			--自动寻路：找npc
			TalentGuideLetter_GoToFindNpc()
		elseif param == 3 then
			--关闭界面
			TalentGuideLetter_OnHiden()
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99971101 then
		local param = Get_XParam_INT(0)
		g_IsShow = 0
		if param == 1 then
			--打开界面
			TalentGuideLetter_ShowFrame(4)
			TalentGuideLetter_Btn1:SetProperty("Disabled", "False");  
			TalentGuideLetter_Btn2:SetProperty("Disabled", "False");  
			TalentGuideLetter_Btn3:SetProperty("Disabled", "False");  
			TalentGuideLetter_Btn4:SetProperty("Disabled", "False");  
			this:Show()
		elseif param == 2 then
			--自动寻路：找npc
			TalentGuideLetter_GoToFindNpc()
		elseif param == 3 then
			--关闭界面
			TalentGuideLetter_OnHiden()
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99835301 then
		local param = Get_XParam_INT(0)
		if param == 2 then
			TalentGuideLetter_GoToFindTargetNpc()
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		TalentGuideLetter_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		TalentGuideLetter_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		TalentGuideLetter_ResetPos()
	
	end

end

function TalentGuideLetter_ShowFrame(idx)
	g_FenYe = idx
	if g_FenYe == 1 then
		TalentGuideLetter_Btn1:SetCheck(1)
		TalentGuideLetter_Btn2:SetCheck(0)
		TalentGuideLetter_Btn3:SetCheck(0)
		TalentGuideLetter_Btn4:SetCheck(0)
		TalentGuideLetter_background1:Show()
		TalentGuideLetter_background2:Hide()
		TalentGuideLetter_background3:Hide()
		TalentGuideLetter_background4:Hide()
		TalentGuideLetter_QianWang:Show()
		if g_IsShow == 1 then
			TalentGuideLetter_QianWang:Show()
			TalentGuideLetter_QianWang:SetToolTip("#{WDEC_220425_11}")
			TalentGuideLetter_background1_1:SetProperty("Image","set:ZLLetter8 image:ZLLetter_xiuxing")
		else
			TalentGuideLetter_background1_1:SetProperty("Image","set:ZLLetter10 image:ZLLetter_lilian2")
			TalentGuideLetter_QianWang:Hide()
		end
	elseif g_FenYe == 2 then
		TalentGuideLetter_Btn1:SetCheck(0)
		TalentGuideLetter_Btn2:SetCheck(1)
		TalentGuideLetter_Btn3:SetCheck(0)
		TalentGuideLetter_Btn4:SetCheck(0)

		TalentGuideLetter_background1:Hide()
		TalentGuideLetter_background2:Show()
		TalentGuideLetter_background3:Hide()
		TalentGuideLetter_background4:Hide()

		TalentGuideLetter_QianWang:Show()
		TalentGuideLetter_QianWang:SetToolTip("#{WDEC_220425_15}")
	elseif g_FenYe == 3 then
		TalentGuideLetter_Btn1:SetCheck(0)
		TalentGuideLetter_Btn2:SetCheck(0)
		TalentGuideLetter_Btn3:SetCheck(1)
		TalentGuideLetter_Btn4:SetCheck(0)

		TalentGuideLetter_background1:Hide()
		TalentGuideLetter_background2:Hide()
		TalentGuideLetter_background3:Show()
		TalentGuideLetter_background4:Hide()

		TalentGuideLetter_QianWang:Show()
		TalentGuideLetter_QianWang:SetToolTip("#{WDSC_230605_06}")
	elseif g_FenYe == 4 then
		TalentGuideLetter_Btn1:SetCheck(0)
		TalentGuideLetter_Btn2:SetCheck(0)
		TalentGuideLetter_Btn3:SetCheck(0)
		TalentGuideLetter_Btn4:SetCheck(1)

		TalentGuideLetter_background1:Hide()
		TalentGuideLetter_background2:Hide()
		TalentGuideLetter_background3:Hide()
		TalentGuideLetter_background4:Show()
		
		TalentGuideLetter_QianWang:Show()
		TalentGuideLetter_QianWang:SetToolTip("#{WDSC_230605_06}")
	end
end

function TalentGuideLetter_OnFenYeClicked(idx)
	
	TalentGuideLetter_ShowFrame(idx)
end

--点击：前往server判断，是否可以寻路找npc
function TalentGuideLetter_Clicked()
	if g_FenYe == 1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GotoFindNpc");
			Set_XSCRIPT_ScriptID(891218);
		    --Set_XSCRIPT_Parameter(0, 2);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	elseif g_FenYe == 2 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnAccept");
			Set_XSCRIPT_ScriptID(893242);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	elseif g_FenYe == 4 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnAccept");
			Set_XSCRIPT_ScriptID(999711);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	else
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnAccept");
			Set_XSCRIPT_ScriptID(998352);
		    --Set_XSCRIPT_Parameter(0, 2);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	end
	TalentGuideLetter_OnHiden()
end

--响应：通过server判断，可以寻路找npc
function TalentGuideLetter_GoToFindNpc()

	if g_FenYe == 1 then
		AutoRuntoTargetExWithName(160, 157, 2, "赵天师")
	else
		local selfMP = Get_XParam_INT(1)
		local selfLP = Get_XParam_INT(2)
		if g_NPC[selfMP] == nil or g_NPC[selfMP].pos[selfLP] == nil then
			return
		end
		AutoRuntoTargetExWithName(g_NPC[selfMP].pos[selfLP][1], g_NPC[selfMP].pos[selfLP][2], g_NPC[selfMP].sceneId, g_NPC[selfMP].name[selfLP])
	end
	TalentGuideLetter_OnHiden()
end

--响应：通过server判断，可以寻路找npc
function TalentGuideLetter_GoToFindTargetNpc()
	local selfMP = Get_XParam_INT(1)
	if g_TargetNPC[selfMP] == nil then
		return
	end
	AutoRuntoTargetExWithName(g_TargetNPC[selfMP].posx, g_TargetNPC[selfMP].posy, g_TargetNPC[selfMP].sceneId, g_TargetNPC[selfMP].name)
	TalentGuideLetter_OnHiden()
end

--调整：界面位置
function TalentGuideLetter_ResetPos()

	TalentGuideLetter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--关闭：界面
function TalentGuideLetter_OnHiden()
	g_IsShow = 0
	this:Hide()
end
