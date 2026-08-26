---DoublePlay_TopListAward
       
local g_DoublePlay_TopListAward_Frame_UnifiedXPosition;
local g_DoublePlay_TopListAward_Frame_UnifiedYPosition;

local g_DoublePlay_TopListAward_Award = {}
local g_TargetId = -1
local g_nType = -1
local g_AwardIndex = {0, 1, 2, 3, 5}

function DoublePlay_TopListAward_PreLoad()
	this:RegisterEvent("OPEN_DOUBLE_XIUXIAN_RANKINGLIST_REWARD"); 
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function DoublePlay_TopListAward_OnLoad()
	--
	g_DoublePlay_TopListAward_Frame_UnifiedXPosition	= DoublePlay_TopListAward_Frame : GetProperty("UnifiedXPosition");
	g_DoublePlay_TopListAward_Frame_UnifiedYPosition	= DoublePlay_TopListAward_Frame : GetProperty("UnifiedYPosition");
	
	g_DoublePlay_TopListAward_Award[1] = DoublePlay_TopListAward_Icon1
	g_DoublePlay_TopListAward_Award[2] = DoublePlay_TopListAward_Icon2
	g_DoublePlay_TopListAward_Award[3] = DoublePlay_TopListAward_Icon3
	g_DoublePlay_TopListAward_Award[4] = DoublePlay_TopListAward_Icon4
	g_DoublePlay_TopListAward_Award[5] = DoublePlay_TopListAward_Icon5
	g_DoublePlay_TopListAward_Award[6] = DoublePlay_TopListAward_Icon6
	
	g_DoublePlay_TopListAward_Award[7] = DoublePlay_TopListAward_Icon1_2
	g_DoublePlay_TopListAward_Award[8] = DoublePlay_TopListAward_Icon2_2
	g_DoublePlay_TopListAward_Award[9] = DoublePlay_TopListAward_Icon3_2
	g_DoublePlay_TopListAward_Award[10] = DoublePlay_TopListAward_Icon4_2
	g_DoublePlay_TopListAward_Award[11] = DoublePlay_TopListAward_Icon5_2
	g_DoublePlay_TopListAward_Award[12] = DoublePlay_TopListAward_Icon6_2
end

function DoublePlay_TopListAward_OnEvent(event)

	if ( event=="OPEN_DOUBLE_XIUXIAN_RANKINGLIST_REWARD" ) then

		g_nType = tonumber(arg0)
		
		DoublePlay_TopListAward_BeginCareObject( tonumber(arg1) )
		DoublePlay_TopListAward_Info( )
		this:Show()

	elseif (event=="PLAYER_LEAVE_WORLD") then 
		DoublePlay_TopListAward_Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		DoublePlay_TopListAward_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		DoublePlay_TopListAward_Frame_On_ResetPos()
		
	end
end


function DoublePlay_TopListAward_Init( )
	
end


function DoublePlay_TopListAward_Info( )
	DoublePlay_TopListAward_Init( )
	
	--物品
	local showAction1 = DataPool:CreateBindActionItemForShow(38002849, 1)
	if showAction1:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[1]:SetActionItem(showAction1:GetID())
	end

	local showAction2 = DataPool:CreateBindActionItemForShow(38002850, 1)
	if showAction2:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[2]:SetActionItem(showAction2:GetID())
	end

	local showAction3 = DataPool:CreateBindActionItemForShow(38002851, 1)
	if showAction3:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[3]:SetActionItem(showAction3:GetID())
	end

	local showAction4 = DataPool:CreateBindActionItemForShow(38002852, 1)
	if showAction4:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[4]:SetActionItem(showAction4:GetID())
	end

	local showAction5 = DataPool:CreateBindActionItemForShow(38002853, 1)
	if showAction5:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[5]:SetActionItem(showAction5:GetID())
	end

	local showAction6 = DataPool:CreateBindActionItemForShow(38002854, 1)
	if showAction6:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[6]:SetActionItem(showAction6:GetID())
	end
	
	--称号
	local showAction1_2 = DataPool:CreateBindActionItemForShow(39920116, 1)
	if showAction1_2:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[7]:SetActionItem(showAction1_2:GetID())
	end

	local showAction2_2 = DataPool:CreateBindActionItemForShow(39920117, 1)
	if showAction2_2:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[8]:SetActionItem(showAction2_2:GetID())
	end

	local showAction3_2 = DataPool:CreateBindActionItemForShow(39920117, 1)
	if showAction3_2:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[9]:SetActionItem(showAction3_2:GetID())
	end
	
	local showAction4_2 = DataPool:CreateBindActionItemForShow(39920118, 1)
	if showAction4_2:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[10]:SetActionItem(showAction4_2:GetID())
	end
	
	local showAction5_2 = DataPool:CreateBindActionItemForShow(39920120, 1)
	if showAction5_2:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[11]:SetActionItem(showAction5_2:GetID())
	end
	
	local showAction6_2 = DataPool:CreateBindActionItemForShow(39920120, 1)
	if showAction6_2:GetID() ~= 0 then
		g_DoublePlay_TopListAward_Award[12]:SetActionItem(showAction6_2:GetID())
	end
end


function DoublePlay_TopListAward_Frame_On_ResetPos()

	DoublePlay_TopListAward_Frame : SetProperty("UnifiedXPosition", g_DoublePlay_TopListAward_Frame_UnifiedXPosition);
	DoublePlay_TopListAward_Frame : SetProperty("UnifiedYPosition", g_DoublePlay_TopListAward_Frame_UnifiedYPosition);

end


function DoublePlay_TopListAward_Hide()
	this:Hide()	
end


--=========================================================
--开始关心NPC
--=========================================================
function DoublePlay_TopListAward_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		DoublePlay_TopListAward_Hide()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "DoublePlay_TopListAward" )
end

