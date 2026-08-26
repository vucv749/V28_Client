---DoublePK_TopListAward
       
local g_DoublePK_TopListAward_Frame_UnifiedXPosition;
local g_DoublePK_TopListAward_Frame_UnifiedYPosition;

local g_DoublePK_TopListAward_Award = {}
local g_TargetId = -1
local g_nType = -1
local g_AwardIndex = {0, 1, 2, 3, 5}

function DoublePK_TopListAward_PreLoad()
	this:RegisterEvent("OPEN_DOUBLE_PK_RANKINGLIST_REWARD"); 
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function DoublePK_TopListAward_OnLoad()
	--
	g_DoublePK_TopListAward_Frame_UnifiedXPosition	= DoublePK_TopListAward_Frame : GetProperty("UnifiedXPosition");
	g_DoublePK_TopListAward_Frame_UnifiedYPosition	= DoublePK_TopListAward_Frame : GetProperty("UnifiedYPosition");
	
	g_DoublePK_TopListAward_Award[1] = DoublePK_TopListAward_Icon1
	g_DoublePK_TopListAward_Award[2] = DoublePK_TopListAward_Icon2
	g_DoublePK_TopListAward_Award[3] = DoublePK_TopListAward_Icon3
	g_DoublePK_TopListAward_Award[4] = DoublePK_TopListAward_Icon4
	g_DoublePK_TopListAward_Award[5] = DoublePK_TopListAward_Icon5
	g_DoublePK_TopListAward_Award[6] = DoublePK_TopListAward_Icon6
	
	g_DoublePK_TopListAward_Award[7] = DoublePK_TopListAward_Icon1_2
	g_DoublePK_TopListAward_Award[8] = DoublePK_TopListAward_Icon2_2
	g_DoublePK_TopListAward_Award[9] = DoublePK_TopListAward_Icon3_2
	g_DoublePK_TopListAward_Award[10] = DoublePK_TopListAward_Icon4_2
	g_DoublePK_TopListAward_Award[11] = DoublePK_TopListAward_Icon5_2
	g_DoublePK_TopListAward_Award[12] = DoublePK_TopListAward_Icon6_2
end

function DoublePK_TopListAward_OnEvent(event)

	if ( event=="OPEN_DOUBLE_PK_RANKINGLIST_REWARD" ) then

		g_nType = tonumber(arg0)
		
		DoublePK_TopListAward_BeginCareObject( tonumber(arg1) )
		DoublePK_TopListAward_Info( )
		this:Show()

	elseif (event=="PLAYER_LEAVE_WORLD") then 
		DoublePK_TopListAward_Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		DoublePK_TopListAward_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		DoublePK_TopListAward_Frame_On_ResetPos()
		
	end
end


function DoublePK_TopListAward_Init( )
	
end


function DoublePK_TopListAward_Info( )
	DoublePK_TopListAward_Init( )
	
	--物品
	local showAction1 = DataPool:CreateBindActionItemForShow(38002835, 1)
	if showAction1:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[1]:SetActionItem(showAction1:GetID())
	end

	local showAction2 = DataPool:CreateBindActionItemForShow(38002836, 1)
	if showAction2:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[2]:SetActionItem(showAction2:GetID())
	end

	local showAction3 = DataPool:CreateBindActionItemForShow(38002837, 1)
	if showAction3:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[3]:SetActionItem(showAction3:GetID())
	end

	local showAction4 = DataPool:CreateBindActionItemForShow(38002838, 1)
	if showAction4:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[4]:SetActionItem(showAction4:GetID())
	end

	local showAction5 = DataPool:CreateBindActionItemForShow(38002839, 1)
	if showAction5:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[5]:SetActionItem(showAction5:GetID())
	end

	local showAction6 = DataPool:CreateBindActionItemForShow(38002840, 1)
	if showAction6:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[6]:SetActionItem(showAction6:GetID())
	end
	
	--称号
	local showAction1_2 = DataPool:CreateBindActionItemForShow(39920113, 1)
	if showAction1_2:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[7]:SetActionItem(showAction1_2:GetID())
	end

	local showAction2_2 = DataPool:CreateBindActionItemForShow(39920114, 1)
	if showAction2_2:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[8]:SetActionItem(showAction2_2:GetID())
	end

	local showAction3_2 = DataPool:CreateBindActionItemForShow(39920114, 1)
	if showAction3_2:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[9]:SetActionItem(showAction3_2:GetID())
	end
	
	local showAction4_2 = DataPool:CreateBindActionItemForShow(39920115, 1)
	if showAction4_2:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[10]:SetActionItem(showAction4_2:GetID())
	end
	
	local showAction5_2 = DataPool:CreateBindActionItemForShow(39920119, 1)
	if showAction5_2:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[11]:SetActionItem(showAction5_2:GetID())
	end
	
	local showAction6_2 = DataPool:CreateBindActionItemForShow(39920119, 1)
	if showAction6_2:GetID() ~= 0 then
		g_DoublePK_TopListAward_Award[12]:SetActionItem(showAction6_2:GetID())
	end
end


function DoublePK_TopListAward_Frame_On_ResetPos()

	DoublePK_TopListAward_Frame : SetProperty("UnifiedXPosition", g_DoublePK_TopListAward_Frame_UnifiedXPosition);
	DoublePK_TopListAward_Frame : SetProperty("UnifiedYPosition", g_DoublePK_TopListAward_Frame_UnifiedYPosition);

end


function DoublePK_TopListAward_Hide()
	this:Hide()	
end


--=========================================================
--开始关心NPC
--=========================================================
function DoublePK_TopListAward_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		DoublePK_TopListAward_Hide()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "DoublePK_TopListAward" )
end

