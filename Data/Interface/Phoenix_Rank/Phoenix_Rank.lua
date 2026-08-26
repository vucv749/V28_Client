local g_Phoenix_Rank_Frame_UnifiedPosition = nil 

local g_Phoenix_Rank_state = 0
local g_Phoenix_Rank_CampName = 
{
	[1] = "#{FHKF_20240315_89}",
	[2] = "#{FHKF_20240315_90}",
	[3] = "#{FHKF_20240315_91}",
	[4] = "#{FHKF_20240315_92}",
}


local g_Phoenix_Rank_CampAward = 
{
    [1] =100,
    [2] =60,
    [3] =40,
    [4] =20,
}

local g_Phoenix_Rank_SelfAward = 
{
	{rankmin = 1, rankmax = 1,  num=200 },
	{rankmin = 2, rankmax = 2,  num=170 },
	{rankmin = 3, rankmax = 3,  num=140 },
    {rankmin = 4, rankmax = 5,  num=120 },
    {rankmin = 6, rankmax = 10, num=100 },
    {rankmin = 11, rankmax =20, num=80  },
    {rankmin = 21, rankmax =30, num=60  },
    {rankmin = 31, rankmax =60, num=50  },
    {rankmin = 61, rankmax =90, num=40  },
    {rankmin = 91, rankmax =120,num=30  },
}

function Phoenix_Rank_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("TSPHOENIX_CAMP_SWITCH")
	this:RegisterEvent("UI_COMMAND")
end 

-- Phoenix_Rank_Client02_Btn => TLBB_ButtonCommon
-- Phoenix_Rank_Small => TLBB_ButtonClose
-- Phoenix_Rank_Help => TLBB_ButtonHelp
-- Phoenix_Rank_Client02 => DefaultWindow
-- Phoenix_Rank_PageHeader_Name => TLBB_DragTitle
-- Phoenix_Rank_Client01 => DefaultWindow
-- Phoenix_Rank_Client01_Btn => TLBB_ButtonCommon
function Phoenix_Rank_OnLoad()
	g_Phoenix_Rank_Frame_UnifiedPosition = Phoenix_Rank_Frame:GetProperty("UnifiedPosition");


end

function Phoenix_Rank_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Phoenix_Rank_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Phoenix_Rank_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Phoenix_Rank_On_Hide()
	elseif(event == "TSPHOENIX_CAMP_SWITCH") then

		local opType = tonumber(arg0)
		local state = tonumber(arg1)
		g_Phoenix_Rank_state = state
		Phoenix_Rank_Clicked(1)
		if opType == 1 then

			this:Show()
		else
			this:Hide()
		end
	elseif(event == "UI_COMMAND") then
		if tonumber(arg0) == 99875101 then
			Sound:PlaySoundEffect( Get_XParam_INT(0), false)
		end		
	end
end


function Phoenix_Rank_FrameInitType(nType)

	if nType == 1 then
		Phoenix_Rank_Client01_Btn:SetCheck(1)
		Phoenix_Rank_Client01:Show()
		Phoenix_Rank_NUM_ListInfo:Show()
		Phoenix_Rank_Client02:Hide()
		Phoenix_Rank_DPS_ListInfo:Hide()
		Phoenix_Rank_Client03:Hide()
	else
		Phoenix_Rank_Client02_Btn:SetCheck(1)
		Phoenix_Rank_Client01:Hide()
		Phoenix_Rank_NUM_ListInfo:Hide()
		Phoenix_Rank_Client02:Show()
		Phoenix_Rank_DPS_ListInfo:Show()
		Phoenix_Rank_Client03:Show()
	end

end


function Phoenix_Rank_SetData(nType)

	Phoenix_Rank_Client03_Text1:SetText("")
	Phoenix_Rank_Client03_Text2:SetText("")
	Phoenix_Rank_Client03_Text3:SetText("")
	Phoenix_Rank_Client03_Text4:SetText("")
	Phoenix_Rank_Client03_Text5:SetText("")	

	if nType == 1 then
		Phoenix_Rank_NUM_ListInfo:RemoveAllItem()
		
		local data = DataPool:Lua_GetTSPhoenixCamp()
		
		--列表从第二列查有问题，需要排序一下表
		local list = {}

		for i,v in ipairs(data) do 
			list[v.m_nRank] = {["campid"] = i, ["nscore"] = v.m_nCScore, ["fscore"]= v.m_nFScore}

		
		end

		for i,v in ipairs(list) do

			Phoenix_Rank_FormatData(i,g_Phoenix_Rank_CampName[v.campid],v.nscore,v.fscore)

		end		
	elseif nType == 2 then
		Phoenix_Rank_DPS_ListInfo:RemoveAllItem()
		local data = DataPool:Lua_GetTSPhoenixScore()

		for i,v in ipairs(data) do 
			--PushDebugMessage("v.m_nCampId="..v.m_nCampId)
			if v.m_nGUID <= 0 or  v.m_nCampId <= 0 then
				--Phoenix_Rank_FormatScoreData(i,"","",0)
			else
				
				Phoenix_Rank_FormatScoreData(i,g_Phoenix_Rank_CampName[v.m_nCampId],v)

			end
		
		end
	end


end


function Phoenix_Rank_Clicked(type)
	Phoenix_Rank_SetExitButtonState()
	Phoenix_Rank_FrameInitType(type)
	Phoenix_Rank_SetData(type)

end

function Phoenix_Rank_SetExitButtonState()

	if g_Phoenix_Rank_state == 0 then
		Phoenix_Rank_Exit:Hide()
	else
		Phoenix_Rank_Exit:Show()
	end
end

function Phoenix_Rank_FormatScoreData(index,campname,data)


	local result = DataPool:GetNameWithServerInfo(data.m_szName,tonumber(data.m_nZoneWorldID))
	Phoenix_Rank_DPS_ListInfo:AddNewItem(index,0,index-1)
	Phoenix_Rank_DPS_ListInfo:AddNewItem(campname,1,index-1)
	Phoenix_Rank_DPS_ListInfo:AddNewItem(result,2,index-1)
	Phoenix_Rank_DPS_ListInfo:AddNewItem(tonumber(data.m_nDamage),3,index-1)
	local vnum = 0
	for i,v in ipairs(g_Phoenix_Rank_SelfAward) do

		if v.rankmin <= index and index <= v.rankmax then
			Phoenix_Rank_DPS_ListInfo:AddNewItem(v.num,4,index-1)
			vnum = v.num
		end
	end


	local myName = Player:GetName()
	if result == myName then
		Phoenix_Rank_Client03_Text1:SetText(index)
		Phoenix_Rank_Client03_Text2:SetText(campname)
		Phoenix_Rank_Client03_Text3:SetText(result)
		Phoenix_Rank_Client03_Text4:SetText(tonumber(data.m_nDamage))
		Phoenix_Rank_Client03_Text5:SetText(vnum)
	end
end

function Phoenix_Rank_FormatData(index,name,score1,score2)
	Phoenix_Rank_NUM_ListInfo:AddNewItem(index,0,index-1)
	Phoenix_Rank_NUM_ListInfo:AddNewItem(name,1,index-1)
	Phoenix_Rank_NUM_ListInfo:AddNewItem(score1,2,index-1)
	Phoenix_Rank_NUM_ListInfo:AddNewItem(score2,3,index-1)
	Phoenix_Rank_NUM_ListInfo:AddNewItem(score1+score2,4,index-1)
	if (score1+score2 == 0) then
		Phoenix_Rank_NUM_ListInfo:AddNewItem(g_Phoenix_Rank_CampAward[4],5,index-1)
	else
		Phoenix_Rank_NUM_ListInfo:AddNewItem(g_Phoenix_Rank_CampAward[index],5,index-1)
	end

end


function Phoenix_Rank_ListInfo_On_SelectionChanged()


end

function Phoenix_Rank_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Phoenix_Rank");
end

function Phoenix_Rank_On_ResetPos()
	Phoenix_Rank_Frame:SetProperty("UnifiedPosition", g_Phoenix_Rank_Frame_UnifiedPosition)
end

function Phoenix_Rank_On_Hide()
	this:Hide()
end



function Phoenix_Rank_Small_Click()
end

function Phoenix_Rank_Help_Click()
end

function Phoenix_Rank_CloseClicked()
	PushEvent("TSPHOENIX_CAMP_SWITCH",2)
end


function Phoenix_Rank_ExitCliecked()
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("Client_Exit")
	Set_XSCRIPT_ScriptID(403021)
	Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()

end