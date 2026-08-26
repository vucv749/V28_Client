--******************************************
--等级排行榜奖励预览
--create by  
--******************************************
       
local g_Levelup_TopListAward_Frame_UnifiedXPosition;
local g_Levelup_TopListAward_Frame_UnifiedYPosition;

local g_Levelup_TopListAward_Award = {}
local g_Levelup_TopListAward_button= {}
local g_Levelup_TopListAward_reward_button= {}

local g_Levelup_TopListAward_Text = {}

local g_Levelup_AwardTitleText = 
{
	[1] = "#{TXLY_240904_80}",
	[2] = "#{TXLY_240904_81}",
	[3] = "#{TXLY_240904_82}",
	[4] = "#{TXLY_240904_83}",
	[5] = "#{TXLY_240904_84}",
}

local g_TargetId = -1
local g_nType = -1
local g_Levelup_MaxRow = 6
local g_rankIndex = -1

function Levelup_TopListAward_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)--??or????
	this:RegisterEvent("OPEN_NORMAL_RANK_REWARD"); 
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
	this:RegisterEvent("UPDATE_NORMAL_RANK_RED_POINT");
	this:RegisterEvent("CLOSE_NORMAL_RANK_REWARD")
end

function Levelup_TopListAward_OnLoad()
	--
	g_LevelUp_TopListAward_Frame_UnifiedXPosition	= Levelup_TopListAward_Frame : GetProperty("UnifiedXPosition");
	g_LevelUp_TopListAward_Frame_UnifiedXPosition	= Levelup_TopListAward_Frame : GetProperty("UnifiedYPosition");
	
	g_Levelup_TopListAward_Award[0] = Levelup_TopListAward_Icon1
	g_Levelup_TopListAward_Award[1] = Levelup_TopListAward_Icon2
	g_Levelup_TopListAward_Award[2] = Levelup_TopListAward_Icon3
	g_Levelup_TopListAward_Award[3] = Levelup_TopListAward_Icon4
	g_Levelup_TopListAward_Award[4] = Levelup_TopListAward_Icon5
	g_Levelup_TopListAward_Award[5] = Levelup_TopListAward_Icon6
	g_Levelup_TopListAward_Award[6] = Levelup_TopListAward_Icon7

	g_Levelup_TopListAward_Award[10] = Levelup_TopListAward_Icon1_2
	g_Levelup_TopListAward_Award[11] = Levelup_TopListAward_Icon2_2
	g_Levelup_TopListAward_Award[12] = Levelup_TopListAward_Icon3_2
	g_Levelup_TopListAward_Award[13] = Levelup_TopListAward_Icon4_2
	g_Levelup_TopListAward_Award[14] = Levelup_TopListAward_Icon5_2
	g_Levelup_TopListAward_Award[15] = Levelup_TopListAward_Icon6_2
	g_Levelup_TopListAward_Award[16] = Levelup_TopListAward_Icon7_2


	g_Levelup_TopListAward_Award[20] = Levelup_TopListAward_Icon1_3
	g_Levelup_TopListAward_Award[21] = Levelup_TopListAward_Icon2_3
	g_Levelup_TopListAward_Award[22] = Levelup_TopListAward_Icon3_3


	g_Levelup_TopListAward_button[0]=Levelup_TopListAward_Get1
	g_Levelup_TopListAward_button[1]=Levelup_TopListAward_Get2
	g_Levelup_TopListAward_button[2]=Levelup_TopListAward_Get3
	g_Levelup_TopListAward_button[3]=Levelup_TopListAward_Get4
	g_Levelup_TopListAward_button[4]=Levelup_TopListAward_Get5
	g_Levelup_TopListAward_button[5]=Levelup_TopListAward_Get6
	g_Levelup_TopListAward_button[6]=Levelup_TopListAward_Get7


	g_Levelup_TopListAward_reward_button[0] = Levelup_TopListAward_Get1Image
	g_Levelup_TopListAward_reward_button[1] = Levelup_TopListAward_Get2Image
	g_Levelup_TopListAward_reward_button[2] = Levelup_TopListAward_Get3Image
	g_Levelup_TopListAward_reward_button[3] = Levelup_TopListAward_Get4Image
	g_Levelup_TopListAward_reward_button[4] = Levelup_TopListAward_Get5Image
	g_Levelup_TopListAward_reward_button[5] = Levelup_TopListAward_Get6Image
	g_Levelup_TopListAward_reward_button[6] = Levelup_TopListAward_Get7Image

	g_Levelup_TopListAward_Text[0] = Levelup_TopListAward_AwardInfo1
	g_Levelup_TopListAward_Text[1] = Levelup_TopListAward_AwardInfo2
	g_Levelup_TopListAward_Text[2] = Levelup_TopListAward_AwardInfo3
	g_Levelup_TopListAward_Text[3] = Levelup_TopListAward_AwardInfo4
	g_Levelup_TopListAward_Text[4] = Levelup_TopListAward_AwardInfo5
	g_Levelup_TopListAward_Text[5] = Levelup_TopListAward_AwardInfo6
	g_Levelup_TopListAward_Text[6] = Levelup_TopListAward_AwardInfo7
	

end

function Levelup_TopListAward_OnEvent(event)

	if ( event=="OPEN_NORMAL_RANK_REWARD" ) then
		g_nType = tonumber(arg0)
		Levelup_TopListAward_Info(g_nType )
		Levelup_TopListAward_UpButton(g_nType)
		this:Show()
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		Levelup_TopListAward_Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		Levelup_TopListAward_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		Levelup_TopListAward_Frame_On_ResetPos()

	elseif event == "UPDATE_NORMAL_RANK_RED_POINT" then
		if this:IsVisible() then
			Levelup_TopListAward_UpButton(g_nType) --?????????
		end

	elseif(event == "UI_COMMAND" and tonumber(arg0) == 999494001) then
		if this:IsVisible() then
			Levelup_TopListAward_UpButton(g_nType) --?????????
		end
	elseif  event == "CLOSE_NORMAL_RANK_REWARD" then
		if this:IsVisible() then
			this:Hide()
		end
	end
end


function Levelup_TopListAward_Info(rankType)

	local nMaxRow =	DataPool:lua_GetNormalRankingMaxRewardNum(rankType)
	if nMaxRow ~= g_Levelup_MaxRow then
		return
	end	

	if g_Levelup_AwardTitleText[rankType] ~= nil then
		Levelup_TopListAward_DragTitle:SetText(g_Levelup_AwardTitleText[rankType])
	end 

	-- 狚常奖励
	for i = 0, g_Levelup_MaxRow-1 do
		local name, icon1,num1,icon2,num2,icon3,num3,icon4,num4 = DataPool:lua_GetNormalRankingRewardShowInfo(rankType,i)

		if icon1 ~= nil and icon1 > 0  then
			local showAction1 = DataPool:CreateBindActionItemForShow(icon1, num1)
			if showAction1:GetID() ~= 0 then
				g_Levelup_TopListAward_Award[i]:SetActionItem(showAction1:GetID())
			else
				g_Levelup_TopListAward_Award[i]:SetActionItem(-1)
			end
		else
			g_Levelup_TopListAward_Award[i]:SetActionItem(-1)
		end

		if icon2 ~= nil and icon2 > 0  then
			if num2 < 1 then
				num2 = 1
			end

			local showAction2 = DataPool:CreateBindActionItemForShow(icon2, num2)
			if showAction2:GetID() ~= 0 then
				g_Levelup_TopListAward_Award[i+10]:SetActionItem(showAction2:GetID())
			else
				g_Levelup_TopListAward_Award[i+10]:SetActionItem(-1)
			end
		else
			g_Levelup_TopListAward_Award[i+10]:SetActionItem(-1)
		end

		if icon3 ~= nil and icon3 > 0 and g_Levelup_TopListAward_Award[i+20] ~= nil then
			if num3 < 1 then
				num3 = 1
			end

			local showAction3 = DataPool:CreateBindActionItemForShow(icon3, num3)
			if showAction3:GetID() ~= 0 then
				g_Levelup_TopListAward_Award[i+20]:SetActionItem(showAction3:GetID())
				g_Levelup_TopListAward_Award[i+20]:Show()
			else
				g_Levelup_TopListAward_Award[i+20]:SetActionItem(-1)
				g_Levelup_TopListAward_Award[i+20]:Hide()
			end
		else
			if  g_Levelup_TopListAward_Award[i+20] ~= nil  then
				g_Levelup_TopListAward_Award[i+20]:SetActionItem(-1)
				g_Levelup_TopListAward_Award[i+20]:Hide()
			end
		end

		g_Levelup_TopListAward_Text[i]:SetText("#{" .. name .. "}")
	end

	-- 保底奖励
	local icon1,num1,icon2,num2 = DataPool:lua_GetNormalRankingBaseRewardInfo(rankType)
	if icon1 ~= nil and icon1 > 0  then
		local showAction1 = DataPool:CreateBindActionItemForShow(icon1, num1)
		if showAction1:GetID() ~= 0 then
			g_Levelup_TopListAward_Award[g_Levelup_MaxRow]:SetActionItem(showAction1:GetID())
		else
			g_Levelup_TopListAward_Award[g_Levelup_MaxRow]:SetActionItem(-1)
		end
	else
		g_Levelup_TopListAward_Award[g_Levelup_MaxRow]:SetActionItem(-1)
	end

	if icon2 ~= nil and icon2 > 0  then
		if num2 < 1 then
			num2 = 1
		end

		local showAction2 = DataPool:CreateBindActionItemForShow(icon2, num2)
		if showAction2:GetID() ~= 0 then
			g_Levelup_TopListAward_Award[g_Levelup_MaxRow+10]:SetActionItem(showAction2:GetID())
		else
			g_Levelup_TopListAward_Award[g_Levelup_MaxRow+10]:SetActionItem(-1)
		end
	else
		g_Levelup_TopListAward_Award[g_Levelup_MaxRow+10]:SetActionItem(-1)
	end
end

function Levelup_TopListAward_UpButton(rankType)

	local nInsert, nreward,nIndex,nGetBouns = DataPool:lua_GetNormalRankPlayerRewardInfo(rankType)
	g_rankIndex = nIndex

	-- 先把所有的会显
	local nOpen = DataPool:lua_IsNormalRankGetBoutsTime(rankType)

	for i = 0,  table.getn(g_Levelup_TopListAward_button) do
		g_Levelup_TopListAward_button[i]:Disable()
		g_Levelup_TopListAward_button[i]:Show()
	end

	for i = 0,  table.getn(g_Levelup_TopListAward_reward_button) do
		g_Levelup_TopListAward_reward_button[i]:Hide()
	end
	
	-- 如果未上榜 返回
	if nInsert == 0 then
		return
	end

	-- 转换为保底
	if nIndex ~= -1 then
		nIndex =  DataPool:lua_GetNormalRankingRewardShowIndex(rankType,nIndex)
	end


	-- 茽通奖励
	if nIndex ~= -1 then
		-- 数据出问题了，先返回吧
		if g_Levelup_TopListAward_button[nIndex] == nil then
			return
		end

		-- 如果领奖了
		if nGetBouns ~= 0 then
			g_Levelup_TopListAward_button[nIndex]:Hide()
			g_Levelup_TopListAward_reward_button[nIndex]:Show()
		else
			if nOpen == 1 then
				g_Levelup_TopListAward_button[nIndex]:Enable()
			end
		end
	end

	-- 保底奖励
	nIndex = g_Levelup_MaxRow
	-- 数据出问题了，先返回吧
	if g_Levelup_TopListAward_button[nIndex] == nil then
		return
	end

	if nreward ~= 0 then
		g_Levelup_TopListAward_button[nIndex]:Hide()
		g_Levelup_TopListAward_reward_button[nIndex]:Show()
	else
		g_Levelup_TopListAward_button[nIndex]:Enable()
	end

end	

function Levelup_TopListAward_Frame_On_ResetPos()
	Levelup_TopListAward_Frame : SetProperty("UnifiedXPosition", g_Levelup_TopListAward_Frame_UnifiedXPosition);
	Levelup_TopListAward_Frame : SetProperty("UnifiedYPosition", g_Levelup_TopListAward_Frame_UnifiedYPosition);
end


function Levelup_TopListAward_Hide()
	this:Hide()	
end

function Levelup_TopListAward_Click()
	local nRankIndex, nSceneId, nobjId  = DataPool:lua_GetNormalRankingPlayerRankInfo(g_nType)
	if nSceneId == nil then
		return
	end

	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name( "OnReciveReward" )
	Set_XSCRIPT_ScriptID(999494)
	Set_XSCRIPT_Parameter(0,g_nType)		--???
	Set_XSCRIPT_Parameter(1,nRankIndex)		--??
	Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end
