---门派第一人奖励展示
       
local g_MenPaiFirstOne_BattleAward_Frame_UnifiedXPosition;
local g_MenPaiFirstOne_BattleAward_Frame_UnifiedYPosition;

local g_MenPaiFirstOne_BattleAward_Award = {}

local g_Prize = 
{
	[1] = 	--冠军
	{
		{itemId=38002665, itemNum=1}
	},
	[2] = 	--亚军
	{
		{itemId=38002666, itemNum=1}
	},
	[3] = 	--4强
	{
		{itemId=38002667, itemNum=1}
	},
}

function MenPaiFirstOne_BattleAward_PreLoad()
	this:RegisterEvent("DDZ_OPEN_PRIZE");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function MenPaiFirstOne_BattleAward_OnLoad()
	--
	g_MenPaiFirstOne_BattleAward_Frame_UnifiedXPosition	= MenPaiFirstOne_BattleAward_Frame : GetProperty("UnifiedXPosition");
	g_MenPaiFirstOne_BattleAward_Frame_UnifiedYPosition	= MenPaiFirstOne_BattleAward_Frame : GetProperty("UnifiedYPosition");
	
	g_MenPaiFirstOne_BattleAward_Award[1] = {}
	g_MenPaiFirstOne_BattleAward_Award[1][1] = MenPaiFirstOne_BattleAward_Award1_Item1
	g_MenPaiFirstOne_BattleAward_Award[1][2] = MenPaiFirstOne_BattleAward_Award1_Item2
	g_MenPaiFirstOne_BattleAward_Award[1][3] = MenPaiFirstOne_BattleAward_Award1_Item3
	
	g_MenPaiFirstOne_BattleAward_Award[2] = {}
	g_MenPaiFirstOne_BattleAward_Award[2][1] = MenPaiFirstOne_BattleAward_Award2_Item1
	g_MenPaiFirstOne_BattleAward_Award[2][2] = MenPaiFirstOne_BattleAward_Award2_Item2
	g_MenPaiFirstOne_BattleAward_Award[2][3] = MenPaiFirstOne_BattleAward_Award2_Item3
	
	g_MenPaiFirstOne_BattleAward_Award[3] = {}
	g_MenPaiFirstOne_BattleAward_Award[3][1] = MenPaiFirstOne_BattleAward_Award3_Item1
	g_MenPaiFirstOne_BattleAward_Award[3][2] = MenPaiFirstOne_BattleAward_Award3_Item2
	g_MenPaiFirstOne_BattleAward_Award[3][3] = MenPaiFirstOne_BattleAward_Award3_Item3
	
end

function MenPaiFirstOne_BattleAward_OnEvent(event)

	if ( event=="DDZ_OPEN_PRIZE" ) then
		if this:IsVisible() then
			this:Hide()
			return
		end

		MenPaiFirstOne_BattleAward_Award_Click( 0 )
		this:Show()

	elseif (event=="PLAYER_LEAVE_WORLD") then 
		MenPaiFirstOne_BattleAward_Close_Click()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		MenPaiFirstOne_BattleAward_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiFirstOne_BattleAward_Frame_On_ResetPos()
		
	end
end


function MenPaiFirstOne_BattleAward_Init( )
	
	for index=1, table.getn(g_MenPaiFirstOne_BattleAward_Award) do	
		local itemList = g_MenPaiFirstOne_BattleAward_Award[index]
		for itemIndex = 1, table.getn(itemList) do
			
			g_MenPaiFirstOne_BattleAward_Award[index][itemIndex]:Hide()
	
		end	
	end
end


function MenPaiFirstOne_BattleAward_Award_Click( )
		
	MenPaiFirstOne_BattleAward_Init( )
	
	for index=1, table.getn(g_Prize) do
		
		local itemList = g_Prize[index]
		for itemIndex = 1, table.getn(itemList) do
			
			local awardId = itemList[itemIndex].itemId
			local awardNum = itemList[itemIndex].itemNum
			
			local showAction = DataPool:CreateBindActionItemForShow(awardId, awardNum)
			if showAction:GetID() ~= 0 then
				g_MenPaiFirstOne_BattleAward_Award[index][itemIndex]:SetActionItem(showAction:GetID())
				g_MenPaiFirstOne_BattleAward_Award[index][itemIndex]:Show()
			end
	
		end
		
	end
	
end


function MenPaiFirstOne_BattleAward_Frame_On_ResetPos()

	MenPaiFirstOne_BattleAward_Frame : SetProperty("UnifiedXPosition", g_MenPaiFirstOne_BattleAward_Frame_UnifiedXPosition);
	MenPaiFirstOne_BattleAward_Frame : SetProperty("UnifiedYPosition", g_MenPaiFirstOne_BattleAward_Frame_UnifiedYPosition);

end


function MenPaiFirstOne_BattleAward_Close_Click()
	
	if( this:IsVisible() == true ) then
		this:Hide()
	end
	
end

