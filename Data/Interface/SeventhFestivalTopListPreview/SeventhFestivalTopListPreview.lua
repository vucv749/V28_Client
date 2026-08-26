----------------------
-- SeventhFestivalTopListPreview ---
----------------------
local g_SeventhFestivalTopListPreview_UnifiedPosition = nil

local g_SeventhFestivalTopListPreview_CurIdx = 1
local g_SeventhFestivalTopListPreview_CurPage = 1

--¿Ò∫––≈œ¢
local g_SeventhFestivalTopListPreview_SGift =
{
[1] = {
	[1] = { 30310137, 1 },
	[2] = { 30310138, 1 },
	[3] = { 30310139, 1 },
	[4] = { 30310140, 1 },
	[5] = { 30310011, 1 },
	},
[2] = {
	[1] = { 38003280, 1 },
	[2] = { 38003281, 1 },
	[3] = { 38003282, 1 },
	[4] = { 38003283, 1 },
	[5] = { 38003284, 1 },
	},
[3] = {
	[1] = { 38003275, 1 },
	[2] = { 38003276, 1 },
	[3] = { 38003277, 1 },
	[4] = { 38003278, 1 },
	[5] = { 38003279, 1 },
	},
}
local g_SeventhFestivalTopListPreview_STitle = 39920122

local g_SeventhFestivalTopListPreview_Button = {}

local g_SeventhFestivalTopListPreview_RGift =
{
[1] = {
	[1] = { 30310137, 1 },
	[2] = { 30310138, 1 },
	[3] = { 30310139, 1 },
	[4] = { 30310140, 1 },
	[5] = { 30310011, 1 },
	},
[2] = {
	[1] = { 38003280, 1 },
	[2] = { 38003281, 1 },
	[3] = { 38003282, 1 },
	[4] = { 38003283, 1 },
	[5] = { 38003284, 1 },
	},
[3] = {
	[1] = { 38003275, 1 },
	[2] = { 38003276, 1 },
	[3] = { 38003277, 1 },
	[4] = { 38003278, 1 },
	[5] = { 38003279, 1 },
	},
}
local g_SeventhFestivalTopListPreview_RTitle = 39920121

local g_SeventhFestivalTopListPreview_Titlestr = {
"#{QXHB_20210701_132}","#{QXHB_20210701_164}","#{QXHB_20210701_148}",
}

local g_SeventhFestivalTopListPreview_Image = {
[1] = { "set:QiXi_HuaBang14 image:QiXi4_HuaBangZSSHImage", "set:QiXi_HuaBang13 image:QiXi4_HuaBangZSSHImage2" },
[2] = { "set:QiXi_HuaBang14 image:QiXi4_HuaBangQCSHImage2", "set:QiXi_HuaBang14 image:QiXi4_HuaBangQCSHImage" },
[3] = { "set:QiXi_HuaBang11 image:QiXi4_HuaBangSZSHImage2", "set:QiXi_HuaBang12 image:QiXi4_HuaBangSZSHImage" },
}

function SeventhFestivalTopListPreview_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_QIXITOPLIST_ZHANSHI")
	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--===============================================
-- OnLoad()
--===============================================
function SeventhFestivalTopListPreview_OnLoad()
	g_SeventhFestivalTopListPreview_Button = {
		[1] = SeventhFestivalTopListPreview_Num6Award1, 
		[2] = SeventhFestivalTopListPreview_Num2Award1, 
		[3] = SeventhFestivalTopListPreview_Num3Award1,
		[4] = SeventhFestivalTopListPreview_Num4Award1, 
		[5] = SeventhFestivalTopListPreview_Num5Award1,
	}
	
	g_SeventhFestivalTopListPreview_UnifiedPosition = SeventhFestivalTopListPreview_Frame:GetProperty("UnifiedPosition")	
end

--===============================================
-- OnEvent()
--===============================================
function SeventhFestivalTopListPreview_OnEvent(event)
	if (event == "OPEN_QIXITOPLIST_ZHANSHI") then
		local bShow = tonumber(arg0)
		local nCurPage = tonumber(arg1)
		
		if nCurPage == nil or g_SeventhFestivalTopListPreview_SGift[nCurPage] == nil or 
								g_SeventhFestivalTopListPreview_RGift[nCurPage] == nil then
			SeventhFestivalTopListPreview_Close_Click()
			return
		end
		
		if(IsWindowShow("SeventhFestivalTopListPreview")) then
			CloseWindow("SeventhFestivalTopListPreview", true)
			return
		end
		
		SeventhFestivalTopListPreview_Init(nCurPage, 1, 1)
		
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		SeventhFestivalTopListPreview_ResetPos()
	elseif(event == "ADJEST_UI_POS") then
		SeventhFestivalTopListPreview_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		SeventhFestivalTopListPreview_OnHiden()
	end
end

function SeventhFestivalTopListPreview_Init(nCurPage, bSend, nCurIdx)

	if nCurPage == nil or g_SeventhFestivalTopListPreview_SGift[nCurPage] == nil or g_SeventhFestivalTopListPreview_RGift[nCurPage] == nil then
		SeventhFestivalTopListPreview_Close_Click()
		return
	end
	
	g_SeventhFestivalTopListPreview_CurPage = nCurPage
	
	if nCurPage == 1 or nCurPage == 3 then
		SeventhFestivalTopListPreview_Num6Award1YuLan:Show()
	else
		SeventhFestivalTopListPreview_Num6Award1YuLan:Hide()
	end
	
	SeventhFestivalTopListPreview_Clear()
	
	g_SeventhFestivalTopListPreview_CurIdx = nCurIdx
	if nCurIdx == 1 then
		SeventhFestivalTopListPreview_PresentBtn:SetCheck(1)
		SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(0)
	else
		SeventhFestivalTopListPreview_PresentBtn:SetCheck(0)
		SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(1)
	end
	
	if g_SeventhFestivalTopListPreview_Titlestr[nCurPage] ~= nil then
		SeventhFestivalTopListPreview_DragTitle:SetText(g_SeventhFestivalTopListPreview_Titlestr[nCurPage])
	end
	
	if g_SeventhFestivalTopListPreview_Image[nCurPage] ~= nil then
		SeventhFestivalTopListPreview_Pic:SetProperty("Image", g_SeventhFestivalTopListPreview_Image[nCurPage])
	end
	
	if bSend == 1 then
		if nCurPage == 2 then			
			local theAction = DataPool:CreateActionItemForShow(g_SeventhFestivalTopListPreview_STitle, 1)
			if theAction:GetID() ~= 0 then
				SeventhFestivalTopListPreview_Num1Award2:SetActionItem(theAction:GetID())
			end
			SeventhFestivalTopListPreview_Num1BK:Show()
			SeventhFestivalTopListPreview_Num6BK:Hide()
		else
			SeventhFestivalTopListPreview_Num1BK:Hide()
			SeventhFestivalTopListPreview_Num6BK:Show()
		end
		for i = 1, 5 do
			local itemid = g_SeventhFestivalTopListPreview_SGift[nCurPage][i][1]
			local itemnum = g_SeventhFestivalTopListPreview_SGift[nCurPage][i][2]
			local theAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				if nCurPage == 2 and i == 1 then
					SeventhFestivalTopListPreview_Num1Award1:SetActionItem(theAction:GetID())	
				else
					g_SeventhFestivalTopListPreview_Button[i]:SetActionItem(theAction:GetID())
				end
			end
		end
		
		if g_SeventhFestivalTopListPreview_Image[nCurPage][1] ~= nil then
			SeventhFestivalTopListPreview_Pic:SetProperty("Image", g_SeventhFestivalTopListPreview_Image[nCurPage][1])
		end
	else
		if nCurPage == 2 then			
			local theAction = DataPool:CreateActionItemForShow(g_SeventhFestivalTopListPreview_RTitle, 1)
			if theAction:GetID() ~= 0 then
				SeventhFestivalTopListPreview_Num1Award2:SetActionItem(theAction:GetID())
			end
			SeventhFestivalTopListPreview_Num1BK:Show()
			SeventhFestivalTopListPreview_Num6BK:Hide()
		else
			SeventhFestivalTopListPreview_Num1BK:Hide()
			SeventhFestivalTopListPreview_Num6BK:Show()
		end
		for i = 1, 5 do
			local itemid = g_SeventhFestivalTopListPreview_RGift[nCurPage][i][1]
			local itemnum = g_SeventhFestivalTopListPreview_RGift[nCurPage][i][2]
			local theAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				if nCurPage == 2 and i == 1 then
					SeventhFestivalTopListPreview_Num1Award1:SetActionItem(theAction:GetID())	
				else
					g_SeventhFestivalTopListPreview_Button[i]:SetActionItem(theAction:GetID())
				end
			end
		end
		
		if g_SeventhFestivalTopListPreview_Image[nCurPage][2] ~= nil then
			SeventhFestivalTopListPreview_Pic:SetProperty("Image", g_SeventhFestivalTopListPreview_Image[nCurPage][2])
		end
	end
	
	this:Show()
end

function SeventhFestivalTopListPreview_ResetPos()
	SeventhFestivalTopListPreview_Frame:SetProperty("UnifiedPosition", g_SeventhFestivalTopListPreview_UnifiedPosition)
end

function SeventhFestivalTopListPreview_OnHiden()
	this:Hide()
end

function SeventhFestivalTopListPreview_Close_Click()
	this:Hide()
end

function SeventhFestivalTopListPreview_Clear()
	for i = 1, 5 do
		g_SeventhFestivalTopListPreview_Button[i]:SetActionItem(-1)		
	end
	SeventhFestivalTopListPreview_Num1Award1:SetActionItem(-1)		
	SeventhFestivalTopListPreview_Num1Award2:SetActionItem(-1)	
end

function SeventhFestivalTopListPreview_Present_Click()
	if g_SeventhFestivalTopListPreview_CurIdx == 1 then
		return
	end
	
	g_SeventhFestivalTopListPreview_CurIdx = 1
	SeventhFestivalTopListPreview_PresentBtn:SetCheck(1)
	SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(0)
	
	SeventhFestivalTopListPreview_Init(g_SeventhFestivalTopListPreview_CurPage, 1, 1)
end

function SeventhFestivalTopListPreview_Receive_Click()
	if g_SeventhFestivalTopListPreview_CurIdx == 2 then
		return
	end
	
	g_SeventhFestivalTopListPreview_CurIdx = 2
	SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(1)
	SeventhFestivalTopListPreview_PresentBtn:SetCheck(0)
	
	SeventhFestivalTopListPreview_Init(g_SeventhFestivalTopListPreview_CurPage, 0, 2)
end

function SeventhFestivalTopListPreview_YuLan()

	if g_SeventhFestivalTopListPreview_CurPage == 1 then
		Pet:OpenPetJianByZhenShouDanIdFor77(30310137);
	end
	
	if g_SeventhFestivalTopListPreview_CurPage == 3 then
		PushEvent("OPEN_DRESSPREVIEW", 10125785, 98, 68) --??\??\??
	end

end

