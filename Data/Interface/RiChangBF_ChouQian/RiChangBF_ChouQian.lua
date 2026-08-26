local g_RiChangBF_ChouQian_Frame_UnifiedPosition
local RiChangBF_ChouQian_Namelist = {}
local RiChangBF_ChouQian_Choicelist = {}
local g_RiChangBF_Player_ChoiceList = {}
local g_RiChangBF_Player_Namelist = {}
local g_RiChangBF_Choose1_Btn = 0
local g_RiChangBF_Choose2_Btn = 0
local g_RiChangBF_Choice = 0


--玩家头像选择
local RiChangBF_ChouQian_TitlePIC =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_ZD"},
	[2] = {image = "set:RiChangBF1 image:RiChangBF_SX"},
	[3] = {image = "set:RiChangBF1 image:RiChangBF_KG"},
}

--最终结果
local RiChangBF_ChouQian_PlayerChoosePIC1 =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_ZDXZ"}, --亮的诛敌
	[2] = {image = "set:RiChangBF1 image:RiChangBF_SXWXZ"},--暗的双星
}
--最终结果
local RiChangBF_ChouQian_PlayerChoosePIC2 =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_SXXZ"}, --亮的双星
	[2] = {image = "set:RiChangBF1 image:RiChangBF_ZDWXZ"},--暗的诛敌
}

local RiChangBF_ChouQian_PlayerChoosePIC =
{
	[1] = RiChangBF_ChouQian_PlayerChoosePIC1,
	[2] = RiChangBF_ChouQian_PlayerChoosePIC2,
}

--最终结果 显示签面文字
local RiChangBF_ChouQian_PlayerChooseStr1 =
{
	[1] = {str = "#{FBXZ_240408_57}"},
	[2] = {str = "#{FBXZ_240408_58}"},
}

local RiChangBF_ChouQian_PlayerChooseStr2 =
{
	[1] = {str = "#{FBXZ_240408_58}"},
	[2] = {str = "#{FBXZ_240408_57}"},
}

local RiChangBF_ChouQian_PlayerChooseStr =
{
	[1] = RiChangBF_ChouQian_PlayerChooseStr1,
	[2] = RiChangBF_ChouQian_PlayerChooseStr2,
}

--最终结果
local RiChangBF_ChouQian_LastPIC =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_ZDZS"},
	[2] = {image = "set:RiChangBF1 image:RiChangBF_SXZS"},
}

local RiChangBF_ChouQian_PiaoMiaotr= 
{
	[1] = "哈大霸",
	[2] = "桑土公",
	[3] = "乌老大",
	[4] = "任平生",
	[5] = "李秋水",
}

local RiChangBF_ChouQian_QingQiutr= 
{
	[1] = "云卷舒",
	[2] = "逸",
	[3] = "艾虎",
	[4] = "云飘飘",
}

local RiChangBF_ChouQian_WangRitr= 
{
	[1] = "白世镜",
	[2] = "单正",
	[3] = "谭婆",
	[4] = "玄苦",
}

local RiChangBF_ChouQian_BOSSStr= 
{
	[261] = RiChangBF_ChouQian_PiaoMiaotr,
	[577] = RiChangBF_ChouQian_QingQiutr,
	[649] = RiChangBF_ChouQian_WangRitr,
}

local RiChangBF_ChouQian_ErrorStr= 
{
	[1] = "1号BOSS",
	[2] = "2号BOSS",
	[3] = "3号BOSS",
	[4] = "4号BOSS",
	[5] = "5号BOSS",
}

function RiChangBF_ChouQian_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end


function RiChangBF_ChouQian_OnLoad()
	g_RiChangBF_ChouQian_Frame_UnifiedPosition = RiChangBF_ChouQian_Frame:GetProperty("UnifiedPosition")

	--名字
	RiChangBF_ChouQian_Namelist[1] = RiChangBF_ChouQian_Name1
	RiChangBF_ChouQian_Namelist[2] = RiChangBF_ChouQian_Name2
	RiChangBF_ChouQian_Namelist[3] = RiChangBF_ChouQian_Name3
	RiChangBF_ChouQian_Namelist[4] = RiChangBF_ChouQian_Name4
	RiChangBF_ChouQian_Namelist[5] = RiChangBF_ChouQian_Name5
	RiChangBF_ChouQian_Namelist[6] = RiChangBF_ChouQian_Name6

	--选择
	RiChangBF_ChouQian_Choicelist[1] = RiChangBF_ChouQian_Title1
	RiChangBF_ChouQian_Choicelist[2] = RiChangBF_ChouQian_Title2
	RiChangBF_ChouQian_Choicelist[3] = RiChangBF_ChouQian_Title3
	RiChangBF_ChouQian_Choicelist[4] = RiChangBF_ChouQian_Title4
	RiChangBF_ChouQian_Choicelist[5] = RiChangBF_ChouQian_Title5
	RiChangBF_ChouQian_Choicelist[6] = RiChangBF_ChouQian_Title6

end


function RiChangBF_ChouQian_OnEvent(event)

	--打开界面
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99880610) then
		RiChangBF_ChouQian_Close:Hide()
		RiChangBF_ChouQian_CleanUp()
		local nParamSTR0 = Get_XParam_STR(0)		
		local nParamINT0 = Get_XParam_INT(0)
		local nChoice =  math.floor(math.mod(nParamINT0/1,10))
		local nHumanNum = math.floor(math.mod(nParamINT0/10,10))
		if nHumanNum == 0 then
			return
		end
		g_RiChangBF_Choice = nChoice
		for i=1,nHumanNum do
			g_RiChangBF_Player_Namelist[i] = Get_XParam_STR(i)
			g_RiChangBF_Player_ChoiceList[i] = Get_XParam_INT(i)
		end
		if nParamSTR0 == "FIRST" then
			RiChangBF_ChouQian_Open(nHumanNum,g_RiChangBF_Player_Namelist)
		elseif nParamSTR0 == "FINSH" then
			local nANum = math.floor(math.mod(nParamINT0/100,10))
			local nBNum = math.floor(math.mod(nParamINT0/1000,10))
			RiChangBF_ChouQian_Over(nHumanNum,nChoice,nANum,nBNum,g_RiChangBF_Player_Namelist,g_RiChangBF_Player_ChoiceList)
		end
		if IsWindowShow("RiChangBF_TishiTips") == true then
			CloseWindow("RiChangBF_TishiTips", true)
		end
	--关闭界面
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99880611) then
		RiChangBF_ChouQian_Close:Show()		
		-- if( this:IsVisible() ) then
		-- 	RiChangBF_ChouQian_CloseClicked()
		-- end
		if IsWindowShow("RiChangBF_JieShao") == true then
			CloseWindow("RiChangBF_JieShao", true)
		end
		if IsWindowShow("RiChangBF_TishiTips") == true then
			CloseWindow("RiChangBF_TishiTips", true)
		end
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD"  then
		RiChangBF_ChouQian_CloseClicked()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			RiChangBF_ChouQian_ResetPos()
        end
	end
	
end

function RiChangBF_ChouQian_CloseClicked()
	RiChangBF_ChouQian_CleanUp()	
	this:Hide()
end

function RiChangBF_ChouQian_ResetPos()
    RiChangBF_ChouQian_Frame:SetProperty("UnifiedPosition", g_RiChangBF_ChouQian_Frame_UnifiedPosition)
end


function RiChangBF_ChouQian_OnHidden()
	RiChangBF_ChouQian_CloseClicked()
end

function RiChangBF_ChouQian_HelpClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskNotify" )
		Set_XSCRIPT_ScriptID( 998806 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function RiChangBF_ChouQian_DoClicked()
	if( this:IsVisible() ) then
		if g_RiChangBF_Choice ~= 1 and g_RiChangBF_Choice ~= 2 then
			return
		end

		if (g_RiChangBF_Choose1_Btn == 1 and g_RiChangBF_Choose2_Btn == 0) or (g_RiChangBF_Choose1_Btn == 0 and g_RiChangBF_Choose2_Btn == 1) then
			RiChangBF_ChouQian_PlayerChoose()
		else
			PushDebugMessage("#{FBXZ_240408_52}")
		end
	end
end

function RiChangBF_ChouQian_Open(nHumanNum,Player_Namelist)

	for i=1,6 do
		if i <= nHumanNum then
			RiChangBF_ChouQian_Namelist[i]:SetText(Player_Namelist[i])	
		else
			RiChangBF_ChouQian_Namelist[i]:SetText("#{FBXZ_240408_23}")
		end
		RiChangBF_ChouQian_Choicelist[i]:SetProperty("Image",RiChangBF_ChouQian_TitlePIC[3].image)
	end

	RiChangBF_ChouQian_Do_Btn:Show()
	RiChangBF_ChouQian_NumText:Show()
	RiChangBF_ChouQian_WatchText:SetProperty("Timer",tostring(15))
	RiChangBF_ChouQian_WatchText:Show()
	RiChangBF_ChouQian_NumTextBK:Show()
	RiChangBF_ChouQian_ChooseBtn(0,0)

	RiChangBF_ChouQian_Choose1_Image:Hide()
	RiChangBF_ChouQian_Choose1_Text:Hide()
	--RiChangBF_ChouQian_Choose1_Win:Hide()

	RiChangBF_ChouQian_Choose2_Image:Hide()
	RiChangBF_ChouQian_Choose2_Text:Hide()
	--RiChangBF_ChouQian_Choose2_Win:Hide()

	RiChangBF_ChouQian_After_Text:Hide()
	RiChangBF_ChouQian_After_Image:Hide()

	RiChangBF_ChouQian_DoAfter_Text:Hide()

	this:Show()
end

function RiChangBF_ChouQian_Over(nHumanNum,nChoice,nANum,nBNum,Player_Namelist,Player_ChoiceList)

	if nChoice ~= 1 and nChoice ~= 2 then
		return
	end
	
	RiChangBF_ChouQian_Do_Btn:Hide()
	RiChangBF_ChouQian_NumText:Hide()
	RiChangBF_ChouQian_WatchText:Hide()
	RiChangBF_ChouQian_NumTextBK:Hide()

	RiChangBF_ChouQian_Choose1_Btn:Hide()
	RiChangBF_ChouQian_Choose2_Btn:Hide()
	RiChangBF_ChouQian_Choose1_Image:Hide()
	RiChangBF_ChouQian_Choose1_Text:Hide()
	RiChangBF_ChouQian_Choose2_Image:Hide()
	RiChangBF_ChouQian_Choose2_Text:Hide()
	--RiChangBF_ChouQian_Choose1_Win:Hide()
	--RiChangBF_ChouQian_Choose2_Win:Hide()

	RiChangBF_ChouQian_DoAfter_Text:Hide()
	
	if nChoice == 1 then
		local curSceneID = GetSceneID()
		if not RiChangBF_ChouQian_BOSSStr[curSceneID] then
			RiChangBF_ChouQian_After_Text:SetText(ScriptGlobal_Format("#{FBXZ_240408_26}",RiChangBF_ChouQian_ErrorStr[nANum]))
		else
			RiChangBF_ChouQian_After_Text:SetText(ScriptGlobal_Format("#{FBXZ_240408_26}",RiChangBF_ChouQian_BOSSStr[curSceneID][nANum]))
		end
	else
		local curSceneID = GetSceneID()
		if not RiChangBF_ChouQian_BOSSStr[curSceneID] then
			RiChangBF_ChouQian_After_Text:SetText(ScriptGlobal_Format("#{FBXZ_240408_51}",RiChangBF_ChouQian_ErrorStr[nBNum],RiChangBF_ChouQian_ErrorStr[nANum]))
		else
			RiChangBF_ChouQian_After_Text:SetText(ScriptGlobal_Format("#{FBXZ_240408_51}",RiChangBF_ChouQian_BOSSStr[curSceneID][nBNum],RiChangBF_ChouQian_BOSSStr[curSceneID][nANum]))
		end
	end
	RiChangBF_ChouQian_After_Text:Show()

	for i=1,nHumanNum do
		if i <= nHumanNum then
			RiChangBF_ChouQian_Namelist[i]:SetText(Player_Namelist[i])
			RiChangBF_ChouQian_Choicelist[i]:SetProperty("Image",RiChangBF_ChouQian_TitlePIC[Player_ChoiceList[i]].image)
		else
			RiChangBF_ChouQian_Namelist[i]:SetText("#{FBXZ_240408_23}")
			RiChangBF_ChouQian_Choicelist[i]:SetProperty("Image",RiChangBF_ChouQian_TitlePIC[3].image)
		end
	end
	
	RiChangBF_ChouQian_After_Image:SetProperty("Image",RiChangBF_ChouQian_LastPIC[nChoice].image)
	RiChangBF_ChouQian_After_Image:Show()

	this:Show()
end

function RiChangBF_ChouQian_InfoBtn()
	OpenWindow("RiChangBF_JieShao")
end

--按钮置灰
function RiChangBF_ChouQian_ChooseBtn(nNum1,nNum2)

	g_RiChangBF_Choose1_Btn = nNum1
	RiChangBF_ChouQian_Choose1_Btn:SetCheck(nNum1)
	
	g_RiChangBF_Choose2_Btn = nNum2
	RiChangBF_ChouQian_Choose2_Btn:SetCheck(nNum2)

	RiChangBF_ChouQian_Choose1_Btn:Show()
	RiChangBF_ChouQian_Choose2_Btn:Show()
end

function RiChangBF_ChouQian_Choose1_BtnClicked()
	RiChangBF_ChouQian_ChooseBtn(1,0)
end

function RiChangBF_ChouQian_Choose2_BtnClicked()
	RiChangBF_ChouQian_ChooseBtn(0,1)
end

function RiChangBF_ChouQian_PlayerChoose()

	RiChangBF_ChouQian_Do_Btn:Hide()
	RiChangBF_ChouQian_Choose1_Btn:Hide()
	RiChangBF_ChouQian_Choose2_Btn:Hide()

	local nChoice1 = 0
	local nChoice2 = 0
	if g_RiChangBF_Choose1_Btn == 1 then --选择按钮
		nChoice1 = 1
		nChoice2 = 2
	else
		nChoice1 = 2
		nChoice2 = 1
	end

	RiChangBF_ChouQian_Choose1_Image:SetProperty("Image",RiChangBF_ChouQian_PlayerChoosePIC[g_RiChangBF_Choice][nChoice1].image)
	RiChangBF_ChouQian_Choose1_Text:SetText(RiChangBF_ChouQian_PlayerChooseStr[g_RiChangBF_Choice][nChoice1].str)
	RiChangBF_ChouQian_Choose2_Image:SetProperty("Image",RiChangBF_ChouQian_PlayerChoosePIC[g_RiChangBF_Choice][nChoice2].image)
	RiChangBF_ChouQian_Choose2_Text:SetText(RiChangBF_ChouQian_PlayerChooseStr[g_RiChangBF_Choice][nChoice2].str)

	RiChangBF_ChouQian_Choose1_Image:Show()
	RiChangBF_ChouQian_Choose1_Text:Show()
	RiChangBF_ChouQian_Choose2_Image:Show()
	RiChangBF_ChouQian_Choose2_Text:Show()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "SetChoose" )
		Set_XSCRIPT_ScriptID( 998806 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()

	RiChangBF_ChouQian_DoAfter_Text:SetText("#{FBXZ_240408_56}")
	RiChangBF_ChouQian_DoAfter_Text:Show()

end

function RiChangBF_ChouQian_CleanUp()	
	g_RiChangBF_Player_ChoiceList = {}
	g_RiChangBF_Player_Namelist = {}
	g_RiChangBF_Choose1_Btn = 0
	g_RiChangBF_Choose2_Btn = 0
	g_RiChangBF_Choice = 0
end

function RiChangBF_ChouQian_OnClose()	
	RiChangBF_ChouQian_CloseClicked()
end