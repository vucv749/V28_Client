local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_NameList = {}
local g_SexList = {}
local g_GoodGameList = {}
local g_PlayerList = {}
local g_OKList = {}
local g_CampImage = {
	[1] = "set:Makefriends image:SB", --
	[2] = "set:Makefriends image:SL", --
	[3] = "set:Makefriends image:PJ", --
}
local g_SexImage = {
	[0] = "set:Button8 image:IM_F_Online", --nv
	[1] = "set:Button8 image:IM_M_Online", --nan
}



function Makefriends_Settlement_PreLoad()

	--this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("JIAOYOU_SHOW_GOODGAMEUI")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("UI_COMMAND")
end

function Makefriends_Settlement_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Makefriends_Settlement_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Makefriends_Settlement_Frame:GetProperty("UnifiedYPosition");
	
	g_SexList[1] = Makefriends_Settlement_Info2
	g_SexList[2] = Makefriends_Settlement_Info4
	g_SexList[3] = Makefriends_Settlement_Info6
	g_SexList[4] = Makefriends_Settlement_Info8
	g_SexList[5] = Makefriends_Settlement_Info10
	g_SexList[6] = Makefriends_Settlement_Info12
	g_SexList[7] = Makefriends_Settlement_Info14
	g_SexList[8] = Makefriends_Settlement_Info16
	g_SexList[9] = Makefriends_Settlement_Info18
	g_SexList[10] = Makefriends_Settlement_Info20
	g_SexList[11] = Makefriends_Settlement_Info22
	g_SexList[12] = Makefriends_Settlement_Info24
	g_SexList[13] = Makefriends_Settlement_Info26
	g_SexList[14] = Makefriends_Settlement_Info28
	g_SexList[15] = Makefriends_Settlement_Info30
	g_SexList[16] = Makefriends_Settlement_Info32
	g_SexList[17] = Makefriends_Settlement_Info34
	g_SexList[18] = Makefriends_Settlement_Info36
	
	g_NameList[1] = Makefriends_Settlement_Info3
	g_NameList[2] = Makefriends_Settlement_Info5
	g_NameList[3] = Makefriends_Settlement_Info7
	g_NameList[4] = Makefriends_Settlement_Info9
	g_NameList[5] = Makefriends_Settlement_Info11
	g_NameList[6] = Makefriends_Settlement_Info13
	g_NameList[7] = Makefriends_Settlement_Info15
	g_NameList[8] = Makefriends_Settlement_Info17
	g_NameList[9] = Makefriends_Settlement_Info19
	g_NameList[10] = Makefriends_Settlement_Info21
	g_NameList[11] = Makefriends_Settlement_Info23
	g_NameList[12] = Makefriends_Settlement_Info25
	g_NameList[13] = Makefriends_Settlement_Info27
	g_NameList[14] = Makefriends_Settlement_Info29
	g_NameList[15] = Makefriends_Settlement_Info31
	g_NameList[16] = Makefriends_Settlement_Info33
	g_NameList[17] = Makefriends_Settlement_Info35
	g_NameList[18] = Makefriends_Settlement_Info37
	
	g_GoodGameList[1] = Makefriends_Settlement_Good1
	g_GoodGameList[2] = Makefriends_Settlement_Good2
	g_GoodGameList[3] = Makefriends_Settlement_Good3
	g_GoodGameList[4] = Makefriends_Settlement_Good4
	g_GoodGameList[5] = Makefriends_Settlement_Good5
	g_GoodGameList[6] = Makefriends_Settlement_Good6
	g_GoodGameList[7] = Makefriends_Settlement_Good7
	g_GoodGameList[8] = Makefriends_Settlement_Good8
	g_GoodGameList[9] = Makefriends_Settlement_Good9
	g_GoodGameList[10] = Makefriends_Settlement_Good10
	g_GoodGameList[11] = Makefriends_Settlement_Good11
	g_GoodGameList[12] = Makefriends_Settlement_Good12
	g_GoodGameList[13] = Makefriends_Settlement_Good13
	g_GoodGameList[14] = Makefriends_Settlement_Good14
	g_GoodGameList[15] = Makefriends_Settlement_Good15
	g_GoodGameList[16] = Makefriends_Settlement_Good16
	g_GoodGameList[17] = Makefriends_Settlement_Good17
	g_GoodGameList[18] = Makefriends_Settlement_Good18
	
	g_PlayerList[1] = Makefriends_Settlement_Number_InfoBK1
	g_PlayerList[2] = Makefriends_Settlement_Number_InfoBK2
	g_PlayerList[3] = Makefriends_Settlement_Number_InfoBK3
	g_PlayerList[4] = Makefriends_Settlement_Number_InfoBK4
	g_PlayerList[5] = Makefriends_Settlement_Number_InfoBK5
	g_PlayerList[6] = Makefriends_Settlement_Number_InfoBK6
	g_PlayerList[7] = Makefriends_Settlement_Number_InfoBK7
	g_PlayerList[8] = Makefriends_Settlement_Number_InfoBK8
	g_PlayerList[9] = Makefriends_Settlement_Number_InfoBK9
	g_PlayerList[10] = Makefriends_Settlement_Number_InfoBK10
	g_PlayerList[11] = Makefriends_Settlement_Number_InfoBK11
	g_PlayerList[12] = Makefriends_Settlement_Number_InfoBK12
	g_PlayerList[13] = Makefriends_Settlement_Number_InfoBK13
	g_PlayerList[14] = Makefriends_Settlement_Number_InfoBK14
	g_PlayerList[15] = Makefriends_Settlement_Number_InfoBK15
	g_PlayerList[16] = Makefriends_Settlement_Number_InfoBK16
	g_PlayerList[17] = Makefriends_Settlement_Number_InfoBK17
	g_PlayerList[18] = Makefriends_Settlement_Number_InfoBK18
	
	g_OKList[1] = Makefriends_Settlement_Good1_Null
	g_OKList[2] = Makefriends_Settlement_Good2_Null
	g_OKList[3] = Makefriends_Settlement_Good3_Null
	g_OKList[4] = Makefriends_Settlement_Good4_Null
	g_OKList[5] = Makefriends_Settlement_Good5_Null
	g_OKList[6] = Makefriends_Settlement_Good6_Null
	g_OKList[7] = Makefriends_Settlement_Good7_Null
	g_OKList[8] = Makefriends_Settlement_Good8_Null
	g_OKList[9] = Makefriends_Settlement_Good9_Null
	g_OKList[10] = Makefriends_Settlement_Good10_Null
	g_OKList[11] = Makefriends_Settlement_Good11_Null
	g_OKList[12] = Makefriends_Settlement_Good12_Null
	g_OKList[13] = Makefriends_Settlement_Good13_Null
	g_OKList[14] = Makefriends_Settlement_Good14_Null
	g_OKList[15] = Makefriends_Settlement_Good15_Null
	g_OKList[16] = Makefriends_Settlement_Good16_Null
	g_OKList[17] = Makefriends_Settlement_Good17_Null
	g_OKList[18] = Makefriends_Settlement_Good18_Null

	
end

function Makefriends_Settlement_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		Makefriends_Settlement_ResetPos()
	 elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Makefriends_Settlement_ResetPos()
	--elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
	--	this:Hide();
	elseif( event == "JIAOYOU_SHOW_GOODGAMEUI" ) then
		Makefriends_Settlement_Updata()
		this:Show();
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329005) then	--
		local nAddScore = Get_XParam_INT(0) 
		local nCurRound = Get_XParam_INT(1) 
		local nCamp = Get_XParam_INT(2) 
		local nCurRoundCampResult = Get_XParam_INT(3) 
		local nPingJuDaiBiNum = Get_XParam_INT(4) 
		local bIsSpecial = Get_XParam_INT(5) 
		--Makefriends_Settlement_Info1:SetText("第"..(nCurRound-1).."轮")
		local str = ""
		if nCurRoundCampResult == 1 then
			if nCamp == 1 then
				str = ScriptGlobal_Format("#{JYHD_230331_137}", nAddScore)
				if bIsSpecial >= 1 then
					str = str.."#{JYHD_230331_182}"
				else
					str = str.."#{JYHD_230331_183}"
				end
			elseif nCamp == 2 then
				str = ScriptGlobal_Format("#{JYHD_230331_133}", nAddScore)
				if bIsSpecial >= 1 then
					str = str.."#{JYHD_230331_180}"
				else
					str = str.."#{JYHD_230331_181}"
				end
			end
		elseif nCurRoundCampResult == 2 then
			if nCamp == 1 then
				str = ScriptGlobal_Format("#{JYHD_230331_133}", nAddScore)
				if bIsSpecial >= 1 then
					str = str.."#{JYHD_230331_180}"
				else
					str = str.."#{JYHD_230331_181}"
				end
			elseif nCamp == 2 then
				str = ScriptGlobal_Format("#{JYHD_230331_137}", nAddScore)
				if bIsSpecial >= 1 then
					str = str.."#{JYHD_230331_182}"
				else
					str = str.."#{JYHD_230331_183}"
				end
			end
		end
		Makefriends_Settlement_Info38:SetText(str)
		if nCurRound ~= 4 then
			Makefriends_Settlement_Info39:SetText("#{JYHD_230331_134}")
			Makefriends_Settlement_Info40:SetText("#{JYHD_230331_135}")
			Makefriends_Settlement_TimeWatch:SetProperty("Timer", 15)
			Makefriends_Settlement_Info39:Show()
			Makefriends_Settlement_Info40:Show()
			Makefriends_Settlement_TimeWatch:Show()
		else
			--Makefriends_Settlement_TimeWatch:SetProperty("Timer", 15)
			Makefriends_Settlement_Info39:Hide()
			Makefriends_Settlement_Info40:Hide()
			Makefriends_Settlement_TimeWatch:Hide()
		end
		
		if nAddScore > nPingJuDaiBiNum then
			Makefriends_Settlement_Info3_Null:SetProperty("Image", g_CampImage[2])
		elseif nAddScore < nPingJuDaiBiNum then
			Makefriends_Settlement_Info3_Null:SetProperty("Image", g_CampImage[1])
		else
			Makefriends_Settlement_Info3_Null:SetProperty("Image", g_CampImage[3])
		end
		
		
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329006) then	--
		local nIndex = Get_XParam_INT(0) 
		for i = 1, table.getn(g_GoodGameList) do
			g_GoodGameList[i]:Hide()
		end
		if nIndex >= 1 and nIndex <= table.getn(g_OKList) then
			g_OKList[nIndex]:Show()
		end
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329007) then	--
		this:Hide()
	end
	
end

function Makefriends_Settlement_Updata()

	for i = 1, table.getn(g_PlayerList) do
		g_OKList[i]:Hide()
	end
	for i = 1, table.getn(g_PlayerList) do
		g_PlayerList[i]:Hide()
		local nGuid, strName, nSex = SocialActivitesDataPool:GetGoodGamePlayerByIndex(i-1)
		if nGuid ~= -1 then
			g_PlayerList[i]:Show()
			g_NameList[i]:SetText(ScriptGlobal_Format("#{JYHD_230331_109}", strName))
			if nSex == 0 then
				g_SexList[i]:SetProperty("Image", g_SexImage[nSex])
			elseif nSex == 1 then
				g_SexList[i]:SetProperty("Image", g_SexImage[nSex])
			end
			g_GoodGameList[i]:Show()
		end
	end

end


function Makefriends_Settlement_ResetPos()

	Makefriends_Settlement_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Makefriends_Settlement_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);

end


function Makefriends_Settlement_ReachZero()

	this:Hide()

end

function Makefriends_Settlement_Good(index)

	if index < 1 or index > table.getn(g_GoodGameList) then
		return 
	end

	
	local nGuid, strName, nSex =  SocialActivitesDataPool:GetGoodGamePlayerByIndex(index-1)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GoodGame" ); 	-- ???
		Set_XSCRIPT_ScriptID( 998329 );					-- ????
		Set_XSCRIPT_Parameter(0, nGuid)
		Set_XSCRIPT_Parameter(1, index)
		Set_XSCRIPT_ParamCount( 2 );						-- ????
	Send_XSCRIPT()
end

function Makefriends_Settlement_Close()
	this:Hide()
end

function Makefriends_Settlement_OnHiden()

end
