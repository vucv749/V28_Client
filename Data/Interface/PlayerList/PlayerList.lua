--PlayerList

local pl = {}
local MAX_PLAYER_IDX = 16
local g_PlayerList_Frame_UnifiedXPosition
local g_PlayerList_Frame_UnifiedYPosition

local g_InitList = 0
local g_BarList = {}
function PlayerList_PreLoad()
	this:RegisterEvent("PLAYERLIST_SHOW")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PlayerList_OnLoad()

	pl = {
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
		{id=-1,name="",level=0,guild="",menpai="",isFriend=false,iconstr="ENEMY",havemskbuff=0},
	   }
	   
	g_PlayerList_Frame_UnifiedXPosition	= PlayerList_Frame:GetProperty("UnifiedXPosition")
	g_PlayerList_Frame_UnifiedYPosition	= PlayerList_Frame:GetProperty("UnifiedYPosition")
end

function PlayerList_OnEvent(event)

	if event == "PLAYERLIST_SHOW" then
		if this:IsVisible() then
			PlayerList_Hide()
		else
			PlayerList_Show()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PlayerList_ResetPos()
	end
end

function PlayerList_InitList()
	if g_InitList == 0 then
		for i = 1, MAX_PLAYER_IDX do
			local bar = PlayerList_List:AddChild("PlayerList_ListItem")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar
			bar:SetEvent("MouseLClick", string.format("PlayerList_PlayerSelect(0, %d)", i))
			bar:SetEvent("MouseDoubleClick", string.format("PlayerList_PlayerSelect(1, %d)", i))
		end
		g_InitList = 1
	end
end

function PlayerList_Update(flag)

	PlayerList_InitList()
	
	for i = 1, MAX_PLAYER_IDX do
		PlayerList_SetItem(i, flag)
	end
	
	PlayerList_List:RefreshLayout()
	PlayerList_List:SetScrollPosition(0)

end

function PlayerList_SetItem(idx, flag)
	if g_BarList[idx] == nil then
		return
	end
	
	local bar = g_BarList[idx]

	if pl[idx] == nil then
		bar:Hide()
		return
	end
	
	if pl[idx].id == -1 then
		bar:Hide()
		return
	end
	
	bar:Show()
	
	local color = ""
	local color_real = ""
	local icostr = ""
	if flag == false then
		color = "#cFF0000"
	elseif flag == true then
		color = "#c00FF00"
	end
	
	local na = pl[idx].name
	if na == "" then na = "N/A" end

	local lv = pl[idx].level
			
	local bp = pl[idx].guild
	if bp == "" then bp = "N/A" end
			
	local mp = pl[idx].menpai
	if mp == "" then mp= "无" end
	
	if pl[idx].iconstr == "ENEMY" then
		icostr = "#-18"
		color_real = color
	elseif pl[idx].iconstr == "FLAG" then
		icostr = "#-22"
		color_real = color.."#b"
	else
		icostr = "#-17"
		color_real = color
	end

	bar:GetSubItem("PlayerList_List_ItemText1"):SetText(icostr..color_real..na)
	bar:GetSubItem("PlayerList_List_ItemText2"):SetText("#cFFFFFF"..tostring(lv).."级")
	

	bar:GetSubItem("PlayerList_List_ItemText3"):SetText("#c00B0F0"..bp)
	bar:GetSubItem("PlayerList_List_ItemText4"):SetText("#cFFFF00"..mp)

	if pl[idx].havemskbuff == 1 then
		bar:GetSubItem("PlayerList_List_ItemText2"):SetText("#cFFFFFF".."?".."级")
	        bar:GetSubItem("PlayerList_List_ItemText3"):SetText("?")
	end

end

--选择目标
function PlayerList_PlayerSelect(isAttack, idx)

	if idx < 1 or idx > MAX_PLAYER_IDX then
		return
	end

	local iii = PlayerList_Item_Check4:GetCheck()

	if isAttack == 1 and pl[idx].isFriend == false and iii == 1 then
		SetMainTargetFromList(pl[idx].id , pl[idx].isFriend ,true)
	else
		SetMainTargetFromList(pl[idx].id , pl[idx].isFriend ,false)
	end
end

--关闭
function PlayerList_Hide()
	this:Hide()
end

--弹出
function PlayerList_Show()
	
	PlayerList_EnmeyList:SetCheck(1)
	PlayerList_PlayerList1:SetCheck(0)
	
	if tonumber(Variable:GetVariable("DBAttack")) == 1 then
		PlayerList_Item_Check4:SetCheck(1)
	else
		PlayerList_Item_Check4:SetCheck(0)
	end
	
	this:Show()
	PlayerList_ChannalChange(false)
end

--友好敌对切换
function PlayerList_ChannalChange(flag)
	
	UpdatePlayerList(flag)

	for i = 1, MAX_PLAYER_IDX do
		pl[i].id = -1
	end

	for i = 1, MAX_PLAYER_IDX do
		pl[i].id, pl[i].name, pl[i].level, pl[i].guild, pl[i].menpai, pl[i].iconstr, pl[i].havemskbuff = GetPlayerFromList(i - 1)
		pl[i].isFriend = flag
	end

	PlayerList_Update(flag)
end

--帮助
function PlayerList_OnHelp()
	Helper:GotoHelper("*PlayerList")
end

--右键菜单
function PlayerList_OpenMenu()

end


function PlayerList_DBAttack_Clicked()
	local temp = PlayerList_Item_Check4:GetCheck()
	Variable:SetVariable("DBAttack",tostring(temp), 0)
end

function PlayerList_ResetPos()
	PlayerList_Frame:SetProperty("UnifiedXPosition", g_PlayerList_Frame_UnifiedXPosition)
	PlayerList_Frame:SetProperty("UnifiedYPosition", g_PlayerList_Frame_UnifiedYPosition)
end