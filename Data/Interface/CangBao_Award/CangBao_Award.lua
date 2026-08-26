--******************************************
--组队藏宝图奖励预览
--create by  limengyue
--2024-07-18
--******************************************

local g_CangBao_Award_Frame_UnifiedPosition;

local g_CangBao_Award_Award1 = {}
local g_CangBao_Award_Award2 = {}
local g_CangBao_Award_Award3 = {}
local g_CangBao_Award_Award4 = {}

--三种模式展示不同id
local g_CangBao_Mode =
{
	[1] = {nLow={39920158,38002534,20600001,0},nMidLow={39920158,39920157,38002533,20600001},nMidHigh={39920158,39920157,38002533,20600002},nHigh={38003055,30000010,10125702,10142079},},
	[2] = {nLow={39920154,30505192,38002534,39920157},nMidLow={39920155,39920157,39920158,38002533},nMidHigh={39920156,39920157,39920158,38002533},nHigh={39920156,39920158,38002533,30503115},},
	[3] = {nLow={39920157,38002533,20600001,20600002},nMidLow={39920157,38002533,20600001,20600002},nMidHigh={39920159,38003055,10125297,10141271},nHigh={39920159,38003055,10125301,10141275},},
}

function CangBao_Award_PreLoad()
	--this:RegisterEvent("OPEN_CANGBAOTU_AWARD");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function CangBao_Award_OnLoad()
	--
	g_CangBao_Award_Frame_UnifiedPosition	= CangBao_Award_Frame : GetProperty("UnifiedPosition");

	g_CangBao_Award_Award1[1] = CangBao_Award_Icon1_1
	g_CangBao_Award_Award1[2] = CangBao_Award_Icon1_2
	g_CangBao_Award_Award1[3] = CangBao_Award_Icon1_3
	g_CangBao_Award_Award1[4] = CangBao_Award_Icon1_4

	g_CangBao_Award_Award2[1] = CangBao_Award_Icon2_1
	g_CangBao_Award_Award2[2] = CangBao_Award_Icon2_2
	g_CangBao_Award_Award2[3] = CangBao_Award_Icon2_3
	g_CangBao_Award_Award2[4] = CangBao_Award_Icon2_4

	g_CangBao_Award_Award3[1] = CangBao_Award_Icon3_1
	g_CangBao_Award_Award3[2] = CangBao_Award_Icon3_2
	g_CangBao_Award_Award3[3] = CangBao_Award_Icon3_3
	g_CangBao_Award_Award3[4] = CangBao_Award_Icon3_4

	g_CangBao_Award_Award4[1] = CangBao_Award_Icon4_1
	g_CangBao_Award_Award4[2] = CangBao_Award_Icon4_2
	g_CangBao_Award_Award4[3] = CangBao_Award_Icon4_3
	g_CangBao_Award_Award4[4] = CangBao_Award_Icon4_4

end

function CangBao_Award_OnEvent(event)

	--if ( event=="OPEN_CANGBAOTU_AWARD" ) then
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340340 ) then
		--打开界面
		if(IsWindowShow("CangBao_Award")) then
			CloseWindow("CangBao_Award", true)
		end
		CangBao_Award_Info(Get_XParam_INT(0) )
	elseif (event=="PLAYER_LEAVE_WORLD") then
		CangBao_Award_Hide()

	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_Award_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		CangBao_Award_Frame_On_ResetPos()

	end
end

--=========================================================
--不同难度奖励不同
--=========================================================
function CangBao_Award_Info( nMode )

	if nMode < 1 or nMode > table.getn(g_CangBao_Mode) then
		nMode = 1
	end
	--最低
	for index=1,table.getn(g_CangBao_Award_Award1)  do
		local nItemID = g_CangBao_Mode[nMode].nLow[index]
		if nItemID > 0 then
			g_CangBao_Award_Award1[index]:Show();
			local nShowActionA = DataPool:CreateBindActionItemForShow(nItemID, 1)
			if nShowActionA:GetID() ~= 0 then
				g_CangBao_Award_Award1[index]:SetActionItem(nShowActionA:GetID())
			end
		else
			g_CangBao_Award_Award1[index]:Hide();
		end
	end
	
	--中低
	for index=1,table.getn(g_CangBao_Award_Award2)  do
		local nItemID = g_CangBao_Mode[nMode].nMidLow[index]
		if nItemID > 0 then
			g_CangBao_Award_Award2[index]:Show();
			local nShowActionB = DataPool:CreateBindActionItemForShow(nItemID, 1)
			if nShowActionB:GetID() ~= 0 then
				g_CangBao_Award_Award2[index]:SetActionItem(nShowActionB:GetID())
			end
		else
			g_CangBao_Award_Award2[index]:Hide();
		end
	end
	--中高
	for index=1,table.getn(g_CangBao_Award_Award3)  do
		local nItemID = g_CangBao_Mode[nMode].nMidHigh[index]
		if nItemID > 0 then
			g_CangBao_Award_Award3[index]:Show();
			local nShowActionC = DataPool:CreateBindActionItemForShow(nItemID, 1)
			if nShowActionC:GetID() ~= 0 then
				g_CangBao_Award_Award3[index]:SetActionItem(nShowActionC:GetID())
			end
		else
			g_CangBao_Award_Award3[index]:Hide();
		end
	end
	--高级
	for index=1,table.getn(g_CangBao_Award_Award4)  do
		local nItemID = g_CangBao_Mode[nMode].nHigh[index]
		if nItemID > 0 then
			g_CangBao_Award_Award4[index]:Show();
			local nShowActionD = DataPool:CreateBindActionItemForShow(nItemID, 1)
			if nShowActionD:GetID() ~= 0 then
				g_CangBao_Award_Award4[index]:SetActionItem(nShowActionD:GetID())
			end
		else
			g_CangBao_Award_Award4[index]:Hide();
		end
	end
	this:Show()
end


--=========================================================
--ResetPos
--=========================================================
function CangBao_Award_Frame_On_ResetPos()
	CangBao_Award_Frame:SetProperty("UnifiedPosition", g_CangBao_Award_Frame_UnifiedPosition);
end

--=========================================================
--关闭
--=========================================================
function CangBao_Award_Hide()
	this:Hide()
end
