local g_RiChangBF_Tishi_Frame_UnifiedPosition

local RiChangBF_Tishi_PiaoMiaotr= 
{
	[1] = "哈大霸",
	[2] = "桑土公",
	[3] = "乌老大",
	[4] = "任平生",
	[5] = "李秋水",
}

local RiChangBF_Tishi_QingQiutr= 
{
	[1] = "云卷舒",
	[2] = "逸",
	[3] = "艾虎",
	[4] = "云飘飘",
}

local RiChangBF_Tishi_WangRitr= 
{
	[1] = "白世镜",
	[2] = "单正",
	[3] = "谭婆",
	[4] = "玄苦",
}

local RiChangBF_Tishi_BOSSStr= 
{
	[261] = RiChangBF_Tishi_PiaoMiaotr,
	[577] = RiChangBF_Tishi_QingQiutr,
	[649] = RiChangBF_Tishi_WangRitr,
}

local RiChangBF_Tishi_ErrorStr= 
{
	[1] = "1号BOSS",
	[2] = "2号BOSS",
	[3] = "3号BOSS",
	[4] = "4号BOSS",
	[5] = "5号BOSS",
}

function RiChangBF_Tishi_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end


function RiChangBF_Tishi_OnLoad()
	g_RiChangBF_Tishi_Frame_UnifiedPosition = RiChangBF_Tishi_Frame:GetProperty("UnifiedPosition")
end


function RiChangBF_Tishi_OnEvent(event)

	--打开界面
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99880612) then
		if(not this:IsVisible() ) then
			local nParamINT0 = Get_XParam_INT(0)
			local nParamINTA = Get_XParam_INT(1)
			local nParamINTB = Get_XParam_INT(2)
	
			if nParamINT0 == 1 then
				local curSceneID = GetSceneID()
				if not RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTA] then
					if nParamINTA >=1 and nParamINTA <=5 then
						RiChangBF_Tishi_TitleZhuDi:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_53}",RiChangBF_Tishi_ErrorStr[nParamINTA]))
						RiChangBF_Tishi_DragTitle2:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_53}",RiChangBF_Tishi_ErrorStr[nParamINTA]))
					end
				else
					RiChangBF_Tishi_TitleZhuDi:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_53}",RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTA]))
					RiChangBF_Tishi_DragTitle2:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_53}",RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTA]))
				end
				RiChangBF_Tishi_TitleZhuDi:Show()
				RiChangBF_Tishi_TitleShuangXing:Hide()
			else
				local curSceneID = GetSceneID()
				if not RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTB] or not RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTA] then
					if nParamINTA >=1 and nParamINTA <=5 and nParamINTB >=1 and nParamINTB <=5 then
						RiChangBF_Tishi_TitleShuangXing:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_54}",RiChangBF_Tishi_ErrorStr[nParamINTB],RiChangBF_Tishi_ErrorStr[nParamINTA]))
						RiChangBF_Tishi_DragTitle3:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_54}",RiChangBF_Tishi_ErrorStr[nParamINTB],RiChangBF_Tishi_ErrorStr[nParamINTA]))
					end
				else
					RiChangBF_Tishi_TitleShuangXing:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_54}",RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTB],RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTA]))
					RiChangBF_Tishi_DragTitle3:SetToolTip(ScriptGlobal_Format("#{FBXZ_240408_54}",RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTB],RiChangBF_Tishi_BOSSStr[curSceneID][nParamINTA]))
				end
				RiChangBF_Tishi_TitleShuangXing:Show()
				RiChangBF_Tishi_TitleZhuDi:Hide()
			end
			
			this:Show()
		end
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD"  then
		RiChangBF_Tishi_CloseClicked()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			RiChangBF_Tishi_ResetPos()
        end
	end
	
end

function RiChangBF_Tishi_CloseClicked()
	RiChangBF_Tishi_CleanUp()	
	this:Hide()
end

function RiChangBF_Tishi_ResetPos()
    RiChangBF_Tishi_Frame:SetProperty("UnifiedPosition", g_RiChangBF_Tishi_Frame_UnifiedPosition)
end


function RiChangBF_Tishi_OnHiden()
	RiChangBF_Tishi_CloseClicked()
end

function RiChangBF_Tishi_OnClickHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskNotify" )
		Set_XSCRIPT_ScriptID( 998806 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function RiChangBF_Tishi_CleanUp()	

end