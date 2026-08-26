-- ËÎÁÉ³ÆºÅÁìÈ¡½çÃæ

local g_objCared 		= -1
local g_Title_Index = 0					-- ???????????
local g_UI_Title_MAX = 7				-- ???????????
local g_UI_Command_ID = 50202301			-- UICommandID
local g_UI_RewardStart = 1				-- ?????????


local g_TitleID_List = {}				-- ????
local g_RewardType = {}					-- ????
local g_UI_Name_List = {}				-- list?Item??
local g_UI_Title_List = {}				-- ??????
local g_TitleNeed_List = {}				-- ?????????
local g_UI_Control_List = {}			-- UI??????
local g_UI_Command_EventList = {}		-- UICommand

local g_data_list = {}					-- ????

local g_Frame_UnifiedPosition = nil		-- ?????????

local g_UI_Title_Icon = "set:TaskTools05 image:TaskTools05_2"

function RongYuTitle_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function RongYuTitle_OnLoad()
	g_UI_Control_List = {
		Frame = RongYuTitle_Frame,
		TitleList = RongYuTitleList,
		Desc = RongYuTitle_Hint,
	}

	g_TitleID_List = {
		{39920084,1034,1},{39920085,1035,2},{39920086,1036,3},{39920087,1037,4},{39920088,1038,5},{39920089,1039,6},{39920090,1040,7} 
	}
	g_UI_Name_List = {
		ItemName		= "RongYuTitleItem",		-- ???Item??
		TileName		= "RongYuTitle_Text",		-- ????
		HistoryStr		= "RongYuTitle_Text2",		-- ??????
		HistoryNeed		= "RongYuTitle_MenGongNum",	-- ????
		Button			= "RongYuTitle_OKButton",	-- ????
		Already			= "RongYuTitle_YiWanCheng",		-- ?????
		Icon			= "RongYuTitle_IconBK",		-- actionbutton
		TitleNeed		= 0,
		TitleID			= 0,
		TitleGet                = 0,
		ButtonIndex	        = -1,
	}
	g_UI_Command_EventList = {
		OpenUI = 2,
		RwardReturn = 3,
	}
	g_RewardType = {title=1}--{title=1,fashion=2,mount=3,}
	g_TitleNeed_List ={500,2000,5000,20000,50000,100000,200000}
	g_Frame_UnifiedPosition = g_UI_Control_List.Frame:GetProperty("UnifiedPosition")
end

-- ¶Ô´«¹ýÀ´µÄÊý¾Ý½øÐÐ³õÊ¼»¯
local function initdata()
	g_data_list = {}
	for i=1, g_UI_Title_MAX do
		g_data_list[i] = Get_XParam_INT(i+g_UI_RewardStart)
	end

end

-- Ë¢ÐÂ´«¹ýÀ´µÄÊý¾Ý
local function updatedata()
	local curidx = Get_XParam_INT(2)
	if curidx > 0 and curidx <= g_UI_Title_MAX then
		g_data_list[curidx] = Get_XParam_INT(3)
	end

	for i=1,g_UI_Title_MAX do
		if g_TitleID_List[curidx][2] ==g_UI_Title_List[i].TitleID then
			g_UI_Title_List[i].TitleGet = Get_XParam_INT(3)
			break
		end
	end

	g_UI_Control_List.TitleList:Clear()
	for i = 1, g_UI_Title_MAX do
		RongYuTitle_AddItem(i)
	end
	table.sort(g_UI_Title_List,RongYuTitle_SortID)
	for i = 1, g_UI_Title_MAX do
		RongYuTitle_FreshItem(i)
	end
end

function RongYuTitle_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == g_UI_Command_ID then
		RongYuTitle_DragTitle:SetText("#{XSLDZ_180521_225}")
		local eventID = Get_XParam_INT(0)	

		if eventID == g_UI_Command_EventList.OpenUI then
			if not this:IsVisible() then
				initdata()
				RongYuTitle_OnShow()
				RongYuTitle_CareTargetObject(Get_XParam_INT(1))
			end
			
		elseif eventID == g_UI_Command_EventList.RwardReturn then
			if this:IsVisible() then

				updatedata()
				
				for i=1,g_UI_Title_MAX do
					RongYuTitle_RefreshOneTitleInfo(i, i)
				end
			end
		end
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		RongYuTitle_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		RongYuTitle_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		RongYuTitle_OnClosed()
	end
end

-- ÏÔÊ¾½çÃæ
function RongYuTitle_OnShow()
	--RongYuTitle_ResetPos()

	RongYuTitle_InitShow()

	RongYuTitle_RefreshInfo()
	this:Show()
	
end

-- ³õÊ¼»¯½çÃæÐÅÏ¢
function RongYuTitle_InitShow()
	g_UI_Title_List = {}
	g_UI_Control_List.TitleList:Clear()
	local titlemax = g_UI_Title_MAX
	for i = 1, titlemax do
		RongYuTitle_AddItem(i)
	end
	table.sort(g_UI_Title_List,RongYuTitle_SortID)
	for i = 1, titlemax do
		RongYuTitle_FreshItem(i)
	end
end

function RongYuTitle_AddItem(i)

	g_UI_Title_List[i] = {}
	g_UI_Title_List[i].TitleID = g_TitleID_List[i][2]
	g_UI_Title_List[i].needhistory = g_TitleNeed_List[i]
	g_UI_Title_List[i].TitleGet = g_data_list[i]
	-- ×¢²áµã»÷ÊÂ¼þ
	g_UI_Title_List[i].ButtonIndex = i
	g_UI_Title_List[i].itemid = g_TitleID_List[i][1]

end

function RongYuTitle_FreshItem(i)

	local titleItem = g_UI_Control_List.TitleList:AddChild(g_UI_Name_List.ItemName)
	if titleItem == nil then
		return
	end
	g_UI_Title_List[i].Item = titleItem
	g_UI_Title_List[i].TitleName = titleItem:GetSubItem(g_UI_Name_List.TileName)
	g_UI_Title_List[i].HistoryStr = titleItem:GetSubItem(g_UI_Name_List.HistoryStr)
	g_UI_Title_List[i].HistoryNeed = titleItem:GetSubItem(g_UI_Name_List.HistoryNeed)
	g_UI_Title_List[i].Button = titleItem:GetSubItem(g_UI_Name_List.Button)
	g_UI_Title_List[i].Already = titleItem:GetSubItem(g_UI_Name_List.Already)
	g_UI_Title_List[i].Icon = titleItem:GetSubItem(g_UI_Name_List.Icon)
	
	local tmp = DataPool:CreateActionItemForShow(g_UI_Title_List[i].itemid, 1)
    if tmp:GetID() ~= 0 then
        g_UI_Title_List[i].Icon:SetActionItem(tmp:GetID())
    end

	g_UI_Title_List[i].Button:SetEvent( "Clicked", string.format("RongYuTitle_ClickOK(%d)",g_UI_Title_List[i].ButtonIndex))
end

-- Ë¢ÐÂUIÄÚÈÝ
function RongYuTitle_RefreshInfo()
	local titlemax = g_UI_Title_MAX

	for i = 1, titlemax do
		RongYuTitle_RefreshOneTitleInfo(i, i)
	end

	local history = Player : GetData("RONGYUHISTORY")

	local str = ScriptGlobal_Format("#{XSLDZ_180521_228}", tostring(history))

	g_UI_Control_List.Desc:SetText(str)
end

function RongYuTitle_RefreshOneTitleInfo(titleIndex, idx)
	
	local titleItem = g_UI_Title_List[titleIndex]
	if titleItem ~= nil then
		--local data = RongYuTitle_GetDataByIndex(titleIndex)
		local datatype,value,szName,bGet = 1,titleItem.TitleID,"",false --data[1],data[2],"",false

		if datatype == g_RewardType.title then
			szName = "#{XSLDZ_180521_226}"..Player:EnumAllTitles(value, "name")
		else
			return
		end

		local bGet = false
		if titleItem.TitleGet > 0 then
			bGet = true
		else
			bGet = false
		end

		titleItem.TitleName:SetText(szName)
		titleItem.HistoryStr:SetText("#{XSLDZ_180521_227}")
		
		--ÊýÖµ²»´ï±ê£¬½øÐÐÑ É«Çø·Ö
		local history,szpoint,needhistory = Player:GetData("RONGYUHISTORY"),"",titleItem.needhistory
		if history >= needhistory then
			szpoint = "#G"..tostring(needhistory)
		else
			szpoint = "#cFF0000"..tostring(needhistory)
		end
		local szNeed = ScriptGlobal_Format("#{XSLDZ_180521_273}", szpoint)
		titleItem.HistoryNeed:SetText(szNeed)


		-- Á½¸öUI»¥³â¹ØÏµ
		if bGet then
			titleItem.Button:Show()
			titleItem.Already:Show()
			titleItem.Button:Disable()
			titleItem.Button:SetText("Dî lînh")
		else
			titleItem.Button:Show()
			titleItem.Already:Hide()
			titleItem.Button:Enable()
			titleItem.Button:SetText("Lînh")
		end
	end
end

function RongYuTitle_GetDataByIndex(titleIndex)
	return g_TitleID_List[titleIndex]
end

-- µã»÷ÁìÈ¡³ÆºÅ
function RongYuTitle_ClickOK(index)
	if index == nil then
		return
	end
	local item = g_UI_Title_List[index]
	if item == nil then
		return
	end

	local data = RongYuTitle_GetDataByIndex(index)
	if data == nil then
		return
	end

	-- ÒÑ¾­ÓµÓÐ
	local bget = g_data_list[index] > 0
	if bget then
		PushDebugMessage("#{XSLDZ_180521_232}")
		return	
	end

	-- ÀúÊ·¹±Ï×ÊÇ·ñ×ã¹»
	local history = Player:GetData("RONGYUHISTORY")
	if g_TitleNeed_List[index] > history then
		PushDebugMessage("#{XSLDZ_180521_233}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("AddTitleRequest")
		Set_XSCRIPT_ScriptID(502023)
		Set_XSCRIPT_Parameter(0, index)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function RongYuTitle_Hide()
	RongYuTitle_OnClosed()
end

function RongYuTitle_OnClosed()
	g_objCared = -1
	this:Hide()
end

function RongYuTitle_OnHelp()
	--Lua_ShowHelpTips("#{JSJM_180123_47}","RongYuTitle","RongYuTitle_Help")
	Helper:GotoHelper("*RongYuTitle");
end

function RongYuTitle_ResetPos()
	g_UI_Control_List.Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

function  RongYuTitle_CareTargetObject(ntarget)
	g_objCared = DataPool:GetNPCIDByServerID(tonumber(ntarget))
	this:CareObject(g_objCared, 1, "RongYuTitle")
end

function  RongYuTitle_Help_Click()
	PushEvent("CCSHOP_HELP", 4)
end



--¶Ô×ÓÀàÐÍÊý¾Ý½øÐÐÅÅÐò
function RongYuTitle_SortID(a,b)
	
	local aneedhistory = a.needhistory
	local bneedhistory = b.needhistory

	if a.TitleGet == 0 and b.TitleGet == 1 then
		return true	
	elseif a.TitleGet == 1 and b.TitleGet == 0 then
		return false
	end
	
	if a.needhistory > b.needhistory then
		return false
	elseif  a.needhistory < b.needhistory then	
		return true
	end
	
	return false	
end
