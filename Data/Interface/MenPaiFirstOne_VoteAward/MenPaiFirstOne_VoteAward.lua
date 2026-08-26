--活跃积分商店 
local g_MenPaiFirstOne_VoteAward_Frame_UnifiedXPosition
local g_MenPaiFirstOne_VoteAward_Frame_UnifiedYPosition    
local g_MenPaiFirstOne_VoteAward_LevelType = 1 
local g_MenPaiFirstOne_VoteAward_Ctl={}
local g_MenPaiFirstOne_VoteAward_Award = 
{
	[1] = { [1]={id=39920102,bind=0,num=1}, [2]={id=38002603 ,bind=1,num=1},}, 
	[2] = { [1]={id=38002604 ,bind=1,num=1},[2]={id=-1,bind=0,num=0},}, 
	[3] = { [1]={id=38002605 ,bind=1,num=1},[2]={id=-1,bind=0,num=0},}, 
	[4] = { [1]={id=30900045 ,bind=1,num=1},[2]={id=-1,bind=0,num=0},}, 
}
function MenPaiFirstOne_VoteAward_PreLoad()

	this:RegisterEvent("OPEN_DDZ_AWARD", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("ADJEST_UI_POS",false)  
	
end

function MenPaiFirstOne_VoteAward_OnLoad() 
	g_MenPaiFirstOne_VoteAward_Frame_UnifiedXPosition = MenPaiFirstOne_VoteAward_Frame:GetProperty("UnifiedXPosition") 
	g_MenPaiFirstOne_VoteAward_Frame_UnifiedYPosition = MenPaiFirstOne_VoteAward_Frame:GetProperty("UnifiedYPosition") 
	g_MenPaiFirstOne_VoteAward_Ctl[1]={}
	g_MenPaiFirstOne_VoteAward_Ctl[2]={}
	g_MenPaiFirstOne_VoteAward_Ctl[3]={}
	g_MenPaiFirstOne_VoteAward_Ctl[4]={}
	g_MenPaiFirstOne_VoteAward_Ctl[1][1] =MenPaiFirstOne_VoteAward_Award1_Item1
	g_MenPaiFirstOne_VoteAward_Ctl[1][2] =MenPaiFirstOne_VoteAward_Award1_Item2
	g_MenPaiFirstOne_VoteAward_Ctl[2][1] =MenPaiFirstOne_VoteAward_Award2_Item1
	g_MenPaiFirstOne_VoteAward_Ctl[2][2] =MenPaiFirstOne_VoteAward_Award2_Item2
	g_MenPaiFirstOne_VoteAward_Ctl[3][1] =MenPaiFirstOne_VoteAward_Award3_Item1
	g_MenPaiFirstOne_VoteAward_Ctl[3][2] =MenPaiFirstOne_VoteAward_Award3_Item2
	g_MenPaiFirstOne_VoteAward_Ctl[4][1] =MenPaiFirstOne_VoteAward_Award4_Item1
	g_MenPaiFirstOne_VoteAward_Ctl[4][2] =MenPaiFirstOne_VoteAward_Award4_Item2
	
end
 
--=========
-- Event
--=========
function MenPaiFirstOne_VoteAward_OnEvent(event) 
	if event == "OPEN_DDZ_AWARD"  then --        
        MenPaiFirstOne_VoteAward_Open() 
		this:Show()
		return
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		MenPaiFirstOne_VoteAward_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		MenPaiFirstOne_VoteAward_Close()
	elseif event == "ADJEST_UI_POS" then
		MenPaiFirstOne_VoteAward_On_ResetPos() 		
	end

end
 
--=========
-- 重置
--=========
function MenPaiFirstOne_VoteAward_On_ResetPos()

	MenPaiFirstOne_VoteAward_Frame:SetProperty("UnifiedXPosition", g_MenPaiFirstOne_VoteAward_Frame_UnifiedXPosition)
	MenPaiFirstOne_VoteAward_Frame:SetProperty("UnifiedYPosition", g_MenPaiFirstOne_VoteAward_Frame_UnifiedYPosition)

end
 
--=========
-- 关睜
--=========
function MenPaiFirstOne_VoteAward_Close() 
    g_MenPaiFirstOne_VoteAward_LevelType = 1
	this:Hide()
end 
--=========
-- 打开
--=========
function MenPaiFirstOne_VoteAward_Open()  
     for i = 1, table.getn(g_MenPaiFirstOne_VoteAward_Ctl) do
		 for j = 1,  table.getn(g_MenPaiFirstOne_VoteAward_Ctl[i]) do
			 if g_MenPaiFirstOne_VoteAward_Award[i][j].id >= 0  then
				local theAction
				if g_MenPaiFirstOne_VoteAward_Award[i][j].bind == 0 then
					theAction = DataPool:CreateActionItemForShow(g_MenPaiFirstOne_VoteAward_Award[i][j].id, g_MenPaiFirstOne_VoteAward_Award[i][j].num)
				else
					theAction = DataPool:CreateBindActionItemForShow(g_MenPaiFirstOne_VoteAward_Award[i][j].id, g_MenPaiFirstOne_VoteAward_Award[i][j].num)
				end
				if theAction:GetID() ~= 0 then 
					g_MenPaiFirstOne_VoteAward_Ctl[i][j]:SetActionItem( theAction:GetID() );
					g_MenPaiFirstOne_VoteAward_Ctl[i][j]:Show()
				end			
			else
				g_MenPaiFirstOne_VoteAward_Ctl[i][j]:Hide()
			 end
		 end
	 end
end

--=========
-- 切换级别
--=========
function MenPaiFirstOne_VoteAward_LevelType_Clicked(index) 
end  
