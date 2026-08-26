-- petrhdk


-- 保存UI默认位置
local Kunwu_JLRH_Frame_UnifiedPosition = nil

local g_ItemImage = {
	[1] = "set:CircularTaskTool147 image:CircularTaskTool147_15",
	[2] = "set:CircularTaskTool147 image:CircularTaskTool147_16",
	[3] = "set:CircularTaskTool148 image:CircularTaskTool148_1",
	[4] = "set:CircularTaskTool148 image:CircularTaskTool148_2",
	[5] = "set:CircularTaskTool148 image:CircularTaskTool148_3",
	[6] = "set:CircularTaskTool148 image:CircularTaskTool148_4",
}

local g_ItemImageYesOrNo = {
	[1] = "set:Kunwu_JLRH image:Kunwu_JLRH_Correct",
	[2] = "set:Kunwu_JLRH image:Kunwu_JLRH_Wrong",
	
}

local g_MaoMiName = {
	[53631] = "#{JLRH_241211_10}",
	[53632] = "#{JLRH_241211_182}",
	[53633] = "#{JLRH_241211_17}",
	[53634] = "#{JLRH_241211_217}",
	[53635] = "#{JLRH_241211_18}",
	[53636] = "#{JLRH_241211_218}",
}

local g_MaoMiImage = {
	[53631] = "set:Kunwu_JLRH image:Kunwu_JLRH_Img1",
	[53632] = "set:Kunwu_JLRH image:Kunwu_JLRH_Img2",
	[53633] = "set:Kunwu_JLRH image:Kunwu_JLRH_Img3",
	[53634] = "set:Kunwu_JLRH image:Kunwu_JLRH_Img4",
	[53635] = "set:Kunwu_JLRH image:Kunwu_JLRH_Img5",
	[53636] = "set:Kunwu_JLRH image:Kunwu_JLRH_Img6",
}

local g_MaoMiStr = {
	[53631] = "#{JLRH_241211_159}",
	[53632] = "#{JLRH_241211_160}",
	[53633] = "#{JLRH_241211_161}",
	[53634] = "#{JLRH_241211_210}",
	[53635] = "#{JLRH_241211_211}",
	[53636] = "#{JLRH_241211_212}",
}

local g_MaoMiTitleImage = {
	[53631] = "set:Kunwu_JLRH image:Kunwu_JLRH_Title1",
	[53632] = "set:Kunwu_JLRH image:Kunwu_JLRH_Title2",
	[53633] = "set:Kunwu_JLRH image:Kunwu_JLRH_Title3",
	[53634] = "set:Kunwu_JLRH image:Kunwu_JLRH_Title4",
	[53635] = "set:Kunwu_JLRH image:Kunwu_JLRH_Title5",
	[53636] = "set:Kunwu_JLRH image:Kunwu_JLRH_Title6",
}

local g_Timer = -1
local g_TargetId = -1
local g_nObjID  = -1


local g_LastAnswer = {
}
local g_LastAnswerTips = {
}

local g_Answer = {
}

local g_AnswerBK = {
}


local g_AnswerBtn = {
}

local g_AnswerText = {
}

local g_GameTime = 180

function Kunwu_JLRH_PreLoad()
  
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
    this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
	this:RegisterEvent("UI_COMMAND")


end -- end func Kunwu_JLRH_Frame_PreLoad()

function Kunwu_JLRH_OnLoad()
    Kunwu_JLRH_Frame_UnifiedPosition = Kunwu_JLRH_Frame:GetProperty("UnifiedPosition")
	
	g_LastAnswer[1] = Kunwu_JLRH_Result_Img1
	g_LastAnswer[2] = Kunwu_JLRH_Result_Img2
	g_LastAnswer[3] = Kunwu_JLRH_Result_Img3
	
	g_LastAnswerTips[1] = Kunwu_JLRH_Result_Img1Tips
	g_LastAnswerTips[2] = Kunwu_JLRH_Result_Img2Tips
	g_LastAnswerTips[3] = Kunwu_JLRH_Result_Img3Tips
	
	g_Answer[1] = Kunwu_JLRH_Client1_Img1
	g_Answer[2] = Kunwu_JLRH_Client1_Img2
	g_Answer[3] = Kunwu_JLRH_Client1_Img3	
	
	g_AnswerBK[1] = Kunwu_JLRH_Client1_YiTiJiaoImg1
	g_AnswerBK[2] = Kunwu_JLRH_Client1_YiTiJiaoImg2
	g_AnswerBK[3] = Kunwu_JLRH_Client1_YiTiJiaoImg3	
	
	g_AnswerText[1] = Kunwu_JLRH_Client1_PaopaoImg1
	g_AnswerText[2] = Kunwu_JLRH_Client1_PaopaoImg2
	g_AnswerText[3] = Kunwu_JLRH_Client1_PaopaoImg3	
	
	g_AnswerBtn[1] = Kunwu_JLRH_GiftBtn1
	g_AnswerBtn[2] = Kunwu_JLRH_GiftBtn2
	g_AnswerBtn[3] = Kunwu_JLRH_GiftBtn3
	g_AnswerBtn[4] = Kunwu_JLRH_GiftBtn4
	g_AnswerBtn[5] = Kunwu_JLRH_GiftBtn5
	g_AnswerBtn[6] = Kunwu_JLRH_GiftBtn6
	
	
end -- end func Kunwu_JLRH_Frame_OnLoad()

function Kunwu_JLRH_OnEvent(event)
	if (event == "HIDE_ON_SCENE_TRANSED") then
        Kunwu_JLRH_Frame_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        Kunwu_JLRH_Frame_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        Kunwu_JLRH_Frame_UnifiedPos()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 33116302) then	--服务端传数据
	
		local nTickCount = Get_XParam_INT(0)	
		local nLastAnswerList1  = Get_XParam_INT(1) 
		local nLastAnswerList2  = Get_XParam_INT(2) 
		local nLastAnswerList3  = Get_XParam_INT(3) 
		local nAnswerList1 = Get_XParam_INT(4) 
		local nAnswerList2  = Get_XParam_INT(5) 
		local nAnswerList3  = Get_XParam_INT(6) 
		local nAnswerGoodOrBad1  = Get_XParam_INT(7) 
		local nAnswerGoodOrBad2 =  Get_XParam_INT(8) 
		local nAnswerGoodOrBad3 =  Get_XParam_INT(9) 
		local param =  Get_XParam_INT(10) 
		local nIsTeamLeader = Get_XParam_INT(11) 
		g_TargetId = Get_XParam_INT(12) 
		local nDataId = Get_XParam_INT(13) 
		g_nObjID = Target:GetServerId2ClientId(g_TargetId)
        if not g_nObjID or g_nObjID < 0 then
            return
        end
		this:CareObject(g_nObjID, 1)
		Kunwu_JLRH_Frame_Updata(nTickCount, nLastAnswerList1, nLastAnswerList2, nLastAnswerList3, nAnswerList1, nAnswerList2, nAnswerList3, nAnswerGoodOrBad1, nAnswerGoodOrBad2, nAnswerGoodOrBad3, param, nIsTeamLeader, nDataId)
		this:Show()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 33116303) then	--服务端传数据
		local nType = Get_XParam_INT(0)	
		if nType == 0 then
			this:Hide()
		elseif nType == 1 then
			if g_Timer > 0 then
				KillTimer("Kunwu_JLRH_Timer()")
			end
			g_Timer = 3
			SetTimer("Kunwu_JLRH","Kunwu_JLRH_Timer()", 1*1000)
			--Kunwu_JLRH_Client1_Paopao_Animate1:Play(true)
			--Kunwu_JLRH_Client1_Paopao_Animate2:Play(true)
			--Kunwu_JLRH_Client1_Paopao_Animate3:Play(true)
			Kunwu_JLRH_Client1_Result_Animate:SetProperty("Animate", "Kunwu_JLRH_3minWin")
			Kunwu_JLRH_Client1_Result_Animate:Play(true)
		elseif nType == 2 then
			g_Timer = 3
			SetTimer("Kunwu_JLRH","Kunwu_JLRH_Timer()", 1*1000)
			--Kunwu_JLRH_Client1_Paopao_Animate1:Play(true)
			--Kunwu_JLRH_Client1_Paopao_Animate2:Play(true)
			--Kunwu_JLRH_Client1_Paopao_Animate3:Play(true)
			Kunwu_JLRH_Client1_Result_Animate:SetProperty("Animate", "Kunwu_JLRH_2minWin")
			Kunwu_JLRH_Client1_Result_Animate:Play(true)
		elseif nType == 3 then
			--Kunwu_JLRH_Client1_Paopao_Animate1:Play(true)
			--Kunwu_JLRH_Client1_Paopao_Animate2:Play(true)
			--Kunwu_JLRH_Client1_Paopao_Animate3:Play(true)
			Kunwu_JLRH_Client1_Result_Animate:SetProperty("Animate", "Kunwu_JLRH_Fail")
			Kunwu_JLRH_Client1_Result_Animate:Play(true)
		end
	end
end -- end func Kunwu_JLRH_Frame_OnEvent()

function Kunwu_JLRH_Timer()
	g_Timer = g_Timer - 1 
	if g_Timer == 0 then
		KillTimer("Kunwu_JLRH_Timer()")
		this:Hide()
	end
end

function Kunwu_JLRH_Frame_Updata(nTickCount, nLastAnswerList1, nLastAnswerList2, nLastAnswerList3, nAnswerList1, nAnswerList2, nAnswerList3, nAnswerGoodOrBad1, nAnswerGoodOrBad2, nAnswerGoodOrBad3, param, nIsTeamLeader, nDataId)

	
	Kunwu_JLRH_Time2:SetProperty("Timer", g_GameTime-nTickCount+1)
	
	local nParam = param
	local nLastAnswerList = {-1, -1, -1}
	local nAnswerList = {-1, -1, -1}
	local nAnswerGoodOrBad = {0,0,0}
	local bNeedShow = {0,0,0,0,0,0}
	
	nLastAnswerList[1] = nLastAnswerList1
	nLastAnswerList[2] = nLastAnswerList2
	nLastAnswerList[3] = nLastAnswerList3
	
	nAnswerList[1] = nAnswerList1
	nAnswerList[2] = nAnswerList2
	nAnswerList[3] = nAnswerList3
	
	nAnswerGoodOrBad[1] = nAnswerGoodOrBad1
	nAnswerGoodOrBad[2] = nAnswerGoodOrBad2
	nAnswerGoodOrBad[3] = nAnswerGoodOrBad3
	
	
	bNeedShow[1] = math.mod(nParam, 10)
	bNeedShow[2] = math.mod(math.floor(nParam/10), 10)
	bNeedShow[3] = math.mod(math.floor(nParam/100), 10)
	bNeedShow[4] = math.mod(math.floor(nParam/1000), 10)
	bNeedShow[5] = math.mod(math.floor(nParam/10000), 10)
	bNeedShow[6] = math.mod(math.floor(nParam/100000), 10)
	
	
	if g_MaoMiTitleImage[nDataId] ~=nil then
		--Kunwu_JLRH_Title:SetProperty("Image", g_MaoMiTitleImage[nDataId])
		Kunwu_JLRH_ZhenshouBK:SetProperty("Image", g_MaoMiImage[nDataId])
		Kunwu_JLRH_Info:SetText(g_MaoMiStr[nDataId])
	end
	
	for i = 1, table.getn(nLastAnswerList) do
		if g_ItemImage[nLastAnswerList[i]] ~= nil then
			g_LastAnswer[i]:SetProperty("Image", g_ItemImage[nLastAnswerList[i]])
			if nAnswerGoodOrBad[i] == 1 then
				g_LastAnswerTips[i]:SetProperty("Image", g_ItemImageYesOrNo[1])
			else
				g_LastAnswerTips[i]:SetProperty("Image", g_ItemImageYesOrNo[2])
			end
			g_LastAnswer[i]:Show()
			g_LastAnswerTips[i]:Show()
		else
			g_LastAnswer[i]:Hide()
			g_LastAnswerTips[i]:Hide()
		end
	end
	
	for i = 1, table.getn(nAnswerList) do
		if g_ItemImage[nAnswerList[i]] ~= nil then
			g_Answer[i]:SetProperty("Image", g_ItemImage[nAnswerList[i]])		
			g_AnswerBK[i]:Show()
			g_AnswerText[i]:Hide()
		else
			g_AnswerBK[i]:Hide()
			g_AnswerText[i]:Show()
		end
	end
	
	if nIsTeamLeader == 1 then
		--Kunwu_JLRH_Client1_OK:Show()
		--Kunwu_JLRH_Client1_Cancel:Show()
		Kunwu_JLRH_Client1_ALLDelete:Show()
		local nAnswerNum = 0
		for i = 1,  table.getn(nAnswerList) do
			if nAnswerList[i] ~= -1 then
				nAnswerNum = nAnswerNum + 1
			end
		end
		if nAnswerNum == 0 then
			Kunwu_JLRH_Client1_ALLDelete:Disable()
		else
			Kunwu_JLRH_Client1_ALLDelete:Enable()
		end
		--Kunwu_JLRH_TeammateText:Hide()
	else
		--Kunwu_JLRH_Client1_OK:Hide()
		--Kunwu_JLRH_Client1_Cancel:Hide()
		Kunwu_JLRH_Client1_ALLDelete:Hide()
		--Kunwu_JLRH_TeammateText:Show()
	end
	
	Kunwu_JLRH_Client2:Hide()
	Kunwu_JLRH_Client4:Show()
	for i = 1, table.getn(bNeedShow) do 
		if bNeedShow[i] == 1 then
			local bAdd = 0
			for j = 1, table.getn(nAnswerList) do
				if i == nAnswerList[j] then
					g_AnswerBtn[i]:Disable()
					bAdd = 1
				end
			end
			if bAdd == 0 then
				g_AnswerBtn[i]:Enable()
			end
			Kunwu_JLRH_Client2:Show()
			Kunwu_JLRH_Client4:Hide()
		else
			g_AnswerBtn[i]:Disable()
		end
	end
	
	
end -- end func Kunwu_JLRH_Frame_Updata()


-- 界面默认位置
function Kunwu_JLRH_Frame_UnifiedPos()
    if (this:IsVisible()) then
        if (Kunwu_JLRH_Frame_UnifiedPosition ~= nil) then
            Kunwu_JLRH_Frame:SetProperty("UnifiedPosition", Kunwu_JLRH_Frame_UnifiedPosition)
        end
    end
end -- end func Kunwu_JLRH_Frame_UnifiedPos()

function Kunwu_JLRH_Frame_Hide()
    this:Hide()
end -- end func Kunwu_JLRH_Frame_Hide()

-- 关闭按钮点击事件
function Kunwu_JLRH_Frame_Close_Clicked()
	Kunwu_JLRH_Frame_Hide()
end  -- end func Kunwu_JLRH_Frame_Close_Clicked()

function Kunwu_JLRH_Help_Clicked()
    --PushEvent("CCSHOP_HELP", 32)
end -- end func Kunwu_JLRH_Frame_Help()

function Kunwu_JLRH_Frame_AddAnswer(index)
   Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AddAnswer" )
		Set_XSCRIPT_ScriptID(331163)
		Set_XSCRIPT_Parameter(0, g_TargetId);	
		Set_XSCRIPT_Parameter(1, index);	
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end -- end func Kunwu_JLRH_Frame_AddAnswer()

function Kunwu_JLRH_Frame_GiveUpAnswer()
   Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GiveUpAnswer" )
		Set_XSCRIPT_ScriptID(331163)
		Set_XSCRIPT_Parameter(0, g_TargetId);	
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
end -- end func Kunwu_JLRH_Frame_AddAnswer()


