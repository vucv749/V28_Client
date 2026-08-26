local g_RiChangBF_ChouQian_Frame_UnifiedPosition
local RiChangBF_ChouQian_Namelist = {}
local RiChangBF_ChouQian_Choicelist = {}
local g_RiChangBF_Player_ChoiceList = {}
local g_RiChangBF_Player_Namelist = {}
local g_RiChangBF_Choose1_Btn = 0
local g_RiChangBF_Choose2_Btn = 0
local g_RiChangBF_Choice = 0


--Íæ¼ÒÍ·ÏñÑ¡Ôñ
local RiChangBF_ChouQian_TitlePIC =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_ZD"},
	[2] = {image = "set:RiChangBF1 image:RiChangBF_SX"},
	[3] = {image = "set:RiChangBF1 image:RiChangBF_KG"},
}

--×îÖ ½á¹û
local RiChangBF_ChouQian_PlayerChoosePIC1 =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_ZDXZ"}, --????
	[2] = {image = "set:RiChangBF1 image:RiChangBF_SXWXZ"},--????
}
--×îÖ ½á¹û
local RiChangBF_ChouQian_PlayerChoosePIC2 =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_SXXZ"}, --????
	[2] = {image = "set:RiChangBF1 image:RiChangBF_ZDWXZ"},--????
}

local RiChangBF_ChouQian_PlayerChoosePIC =
{
	[1] = RiChangBF_ChouQian_PlayerChoosePIC1,
	[2] = RiChangBF_ChouQian_PlayerChoosePIC2,
}

--×îÖ ½á¹û ÏÔÊ¾Ç©ÃæÎÄ×Ö
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

--×îÖ ½á¹û
local RiChangBF_ChouQian_LastPIC =
{
	[1] = {image = "set:RiChangBF1 image:RiChangBF_ZDZS"},
	[2] = {image = "set:RiChangBF1 image:RiChangBF_SXZS"},
}

local RiChangBF_ChouQian_PiaoMiaotr= 
{
	[1] = "Cáp ÐÕi Bá",
	[2] = "Tang Th± Công",
	[3] = "Ô Lão ÐÕi",
	[4] = "Nh§m Bình Sinh",
	[5] = "Lý Thu Thüy",
}

local RiChangBF_ChouQian_QingQiutr= 
{
	[1] = "Vân Quy¬n Thß",
	[2] = "D§t",
	[3] = "Ngäi H±",
	[4] = "Vân Phiêu Phiêu",
}

local RiChangBF_ChouQian_WangRitr= 
{
	[1] = "BÕch Thª Kính",
	[2] = "Ð½n Chính",
	[3] = "Ðàm Bà",
	[4] = "Huy«n Kh±",
}

local RiChangBF_ChouQian_BOSSStr= 
{
	[261] = RiChangBF_ChouQian_PiaoMiaotr,
	[577] = RiChangBF_ChouQian_QingQiutr,
	[649] = RiChangBF_ChouQian_WangRitr,
}

local RiChangBF_ChouQian_ErrorStr= 
{
	[1] = "1Hào BOSS",
	[2] = "2Hào BOSS",
	[3] = "3Hào BOSS",
	[4] = "4Hào BOSS",
	[5] = "5Hào BOSS",
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

	--Ãû×Ö
	RiChangBF_ChouQian_Namelist[1] = RiChangBF_ChouQian_Name1
	RiChangBF_ChouQian_Namelist[2] = RiChangBF_ChouQian_Name2
	RiChangBF_ChouQian_Namelist[3] = RiChangBF_ChouQian_Name3
	RiChangBF_ChouQian_Namelist[4] = RiChangBF_ChouQian_Name4
	RiChangBF_ChouQian_Namelist[5] = RiChangBF_ChouQian_Name5
	RiChangBF_ChouQian_Namelist[6] = RiChangBF_ChouQian_Name6

	--Ñ¡Ôñ
	RiChangBF_ChouQian_Choicelist[1] = RiChangBF_ChouQian_Title1
	RiChangBF_ChouQian_Choicelist[2] = RiChangBF_ChouQian_Title2
	RiChangBF_ChouQian_Choicelist[3] = RiChangBF_ChouQian_Title3
	RiChangBF_ChouQian_Choicelist[4] = RiChangBF_ChouQian_Title4
	RiChangBF_ChouQian_Choicelist[5] = RiChangBF_ChouQian_Title5
	RiChangBF_ChouQian_Choicelist[6] = RiChangBF_ChouQian_Title6

end


function RiChangBF_ChouQian_OnEvent(event)

	--´ò¿ª½çÃæ
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
	--¹Ø± ½çÃæ
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

--°´Å¥ÖÃ»Ò
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
	if g_RiChangBF_Choose1_Btn == 1 then --????
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
