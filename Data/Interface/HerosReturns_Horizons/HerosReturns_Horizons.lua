--HerosReturns_Horizons.lua
local g_HerosReturns_Horizons_Frame_UnifiedPosition

local g_HerosReturns_Horizons_FenYe={};
local g_HerosReturns_Horizons_RedPoint={};
local g_HerosReturns_Horizons_RedPointState = {0,0,0,0}
local g_HerosReturns_Horizons_LeftTime = 0
local g_HerosReturns_Horizons_HlLevel = 0
local g_HerosReturns_Horizons_CurSelected = 0

local g_HerosReturns_Horizons_BonusActionButton = {}
local g_HerosReturns_Horizons_BonusTips = {}
local g_HerosReturns_Horizons_BonusReceived = {}
local g_HerosReturns_Horizons_BonusMask = {}
local g_HerosReturns_Horizons_BonusProgress = nil

local g_HerosReturns_Horizons_Bonus={
	[2] = {
		[1] = {itemId=38002524, count=3, jianwen=5 },
		[2] = {itemId=10124359, count=1, jianwen=10 },
		[3] = {itemId=10141932, count=1, jianwen=15 },
		[4] = {itemId=38002519, count=2, jianwen=20 },
	},
	[3] = {
		[1] = {itemId=38002524, count=3, jianwen=5 },
		[2] = {itemId=10124359, count=1, jianwen=10 },
		[3] = {itemId=10141932, count=1, jianwen=15 },
		[4] = {itemId=38002519, count=2, jianwen=20 },
		[5] = {itemId=20800013, count=15, jianwen=25 },
		[6] = {itemId=38002519, count=4, jianwen=30 },
	},
}

local g_HerosReturns_Horizons_HlLevelIamge={
	[1] = "#{HLYH_220613_50}",
	[2] = "#{HLYH_220613_51}",
	[3] = "#{HLYH_220613_52}",
}

local g_HerosReturns_Horizons_JiangHu={
	[2] = {
		--兽魂
		[1] = { Name="#{HLYH_220613_41}", Level="#{HLYH_220613_42}", Image="set:PetSoulEquip1 image:PetSoulEquip1_9", Desc="#{HLYH_220613_4}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Shouhun", TagImage="set:HerosReturns07 image:Tag_Function",
			Task={ 
				[1]={ Name="#{HLYH_220613_9}", id=0, Bonus=3, xPos=89, zPos=139, sceneId=1, NpcName="云深深" },
				[2]={ Name="#{HLYH_220613_10}", id=1, Bonus=5, xPos=89, zPos=139, sceneId=1, NpcName="云深深" },
				} 
		},
		--青丘试炼
		[2] = { Name="#{HLYH_220613_43}", Level="#{HLYH_220613_44}", Image="set:Huodong_14 image:Huodong_14_4", Desc="#{HLYH_220613_5}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Qingqiu", TagImage="set:HerosReturns07 image:Tag_Raid",
			Task={ 
				[1]={ Name="#{HLYH_220613_11}", id=2, Bonus=5, xPos=134, zPos=81, sceneId=1, NpcName="云兰舟" },
				[2]={ Name="#{HLYH_220613_12}", id=3, Bonus=8, xPos=134, zPos=81, sceneId=1, NpcName="云兰舟" },
				} 
		},
		--剑纵山河
		[3] = { Name="#{HLYH_220613_45}", Level="#{HLYH_220613_46}", Image="set:Huodong_13 image:Huodong_13_9", Desc="#{HLYH_220613_6}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Jianzong", TagImage="set:HerosReturns07 image:Tag_Activity",
			Task={ 
				[1]={ Name="#{HLYH_220613_13}", id=4, Bonus=5, xPos=166, zPos=108, sceneId=0, NpcName="周尚" },
				[2]={ Name="#{HLYH_220613_14}", id=5, Bonus=8, xPos=166, zPos=108, sceneId=0, NpcName="周尚" },
				} 
		},
	},
	[3] = {
		--兽魂
		[1] = { Name="#{HLYH_220613_41}", Level="#{HLYH_220613_42}", Image="set:PetSoulEquip1 image:PetSoulEquip1_9", Desc="#{HLYH_220613_4}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Shouhun", TagImage="set:HerosReturns07 image:Tag_Function",
			Task={ 
				[1]={ Name="#{HLYH_220613_9}", id=0, Bonus=3, xPos=89, zPos=139, sceneId=1, NpcName="云深深" },
				[2]={ Name="#{HLYH_220613_10}", id=1, Bonus=5, xPos=89, zPos=139, sceneId=1, NpcName="云深深" },
				} 
		},
		--青丘试炼
		[2] = {Name="#{HLYH_220613_43}", Level="#{HLYH_220613_44}", Image="set:Huodong_14 image:Huodong_14_4", Desc="#{HLYH_220613_5}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Qingqiu", TagImage="set:HerosReturns07 image:Tag_Raid",
			Task={ 
				[1]={ Name="#{HLYH_220613_11}", id=2, Bonus=5, xPos=134, zPos=81, sceneId=1, NpcName="云兰舟" },
				[2]={ Name="#{HLYH_220613_12}", id=3, Bonus=8, xPos=134, zPos=81, sceneId=1, NpcName="云兰舟" },
				} 
		},
		--剑纵山河
		[3] = { Name="#{HLYH_220613_45}", Level="#{HLYH_220613_46}", Image="set:Huodong_13 image:Huodong_13_9", Desc="#{HLYH_220613_6}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Jianzong", TagImage="set:HerosReturns07 image:Tag_Activity",
			Task={ 
				[1]={ Name="#{HLYH_220613_13}", id=4, Bonus=5, xPos=166, zPos=108, sceneId=0, NpcName="周尚" },
				[2]={ Name="#{HLYH_220613_14}", id=5, Bonus=8, xPos=166, zPos=108, sceneId=0, NpcName="周尚" },
				} 
		},
		--武魂
		[4] = { Name="#{HLYH_220613_47}", Level="#{HLYH_220613_48}", Image="set:WuhunTupu1 image:WuhunTupu1_4", Desc="#{HLYH_220613_7}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Wuhun", TagImage="set:HerosReturns07 image:Tag_Function",
			Task={ 
				[1]={ Name="#{HLYH_220613_15}", id=6, Bonus=3, xPos=136, zPos=180, sceneId=2, NpcName="武泽" },
				[2]={ Name="#{HLYH_220613_16}", id=7, Bonus=3, xPos=136, zPos=180, sceneId=2, NpcName="武泽" },
				} 
		},
		--水月山庄
		[5] = { Name="#{HLYH_220613_49}", Level="#{HLYH_220613_48}", Image="set:Huodong_12 image:Huodong_12_9", Desc="#{HLYH_220613_8}", 
			TitleImage="set:HerosReturns07 image:Subtitle_Shuiyue", TagImage="set:HerosReturns07 image:Tag_Raid",
			Task={ 
				[1]={ Name="#{HLYH_220613_17}", id=8, Bonus=5, xPos=128, zPos=107, sceneId=1, NpcName="沈夜雨" },
				[2]={ Name="#{HLYH_220613_18}", id=9, Bonus=8, xPos=128, zPos=107, sceneId=1, NpcName="沈夜雨" },
				} 
		},
	},
};


--预加载函数，可以而且只能在这里注册脚本关心的事件
function HerosReturns_Horizons_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("HUILIU_SHOW_JIANGHUJIANWEN");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function HerosReturns_Horizons_OnLoad()
	g_HerosReturns_Horizons_Frame_UnifiedPosition = HerosReturns_Horizons_FrameFull:GetProperty("UnifiedPosition")
	
	g_HerosReturns_Horizons_FenYe[1] = HerosReturns_Horizons_Buttontab01;
	g_HerosReturns_Horizons_FenYe[2] = HerosReturns_Horizons_Buttontab02;
	g_HerosReturns_Horizons_FenYe[3] = HerosReturns_Horizons_Buttontab03;
	g_HerosReturns_Horizons_FenYe[4] = HerosReturns_Horizons_Buttontab04;
	
	g_HerosReturns_Horizons_RedPoint[1] = HerosReturns_Horizons_Buttontab01_tips;
	g_HerosReturns_Horizons_RedPoint[2] = HerosReturns_Horizons_Buttontab02_tips;
	g_HerosReturns_Horizons_RedPoint[3] = HerosReturns_Horizons_Buttontab03_tips;
	g_HerosReturns_Horizons_RedPoint[4] = HerosReturns_Horizons_Buttontab04_tips;
end

--响应事件的函数，当注册的事件发生时会调用的函数
function HerosReturns_Horizons_OnEvent(event)
	if (event == "HUILIU_SHOW_JIANGHUJIANWEN") then
		
		g_HerosReturns_Horizons_HlLevel = tonumber(arg1)
		g_HerosReturns_Horizons_LeftTime = tonumber(arg2)
		
		if tonumber(arg0) > 0 or this:IsVisible() then
			HerosReturns_Horizons_Update( g_HerosReturns_Horizons_HlLevel )
		end
		if tonumber(arg0) > 0 then
			this:Show()
		end
				
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 80811005 and this:IsVisible()) then
		--红点
		g_HerosReturns_Horizons_RedPointState[1] = Get_XParam_INT( 0 )
		g_HerosReturns_Horizons_RedPointState[2] = Get_XParam_INT( 1 )
		g_HerosReturns_Horizons_RedPointState[3] = Get_XParam_INT( 2 )
		g_HerosReturns_Horizons_RedPointState[4] = Get_XParam_INT( 3 )
		HerosReturns_Horizons_UpdateRedPoint()	
		
	elseif (event == "ADJEST_UI_POS" ) then
		HerosReturns_Horizons_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HerosReturns_Horizons_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HerosReturns_Horizons_Close()
	end
end

function HerosReturns_Horizons_Update( hlLevel )

	-- 刷新按钮状态
	g_HerosReturns_Horizons_FenYe[1]:SetProperty("Selected", "False")
	g_HerosReturns_Horizons_FenYe[2]:SetProperty("Selected", "False")
	g_HerosReturns_Horizons_FenYe[3]:SetProperty("Selected", "False")
	g_HerosReturns_Horizons_FenYe[4]:SetProperty("Selected", "True")

	local tblJiangHu = g_HerosReturns_Horizons_JiangHu[hlLevel];
	local tblBonus = g_HerosReturns_Horizons_Bonus[hlLevel];
	if tblJiangHu == nil then
		return
	end

	HerosReturns_Horizons_Lace:Clear()
	
	-- 显示
	for i=1, table.getn(tblJiangHu) do
	
		if tblJiangHu[i] == nil then
			break
		end
		
		local bar1 = HerosReturns_Horizons_Lace:AddChild("HerosReturns_Horizons_CoinAItem1")
		if not bar1 then
    	break
  	end
  	
  	bar1:GetSubItem("HerosReturns_Horizons_CoinAItem1_Icon"):SetProperty("Image", tblJiangHu[i].Image );
  	bar1:GetSubItem("HerosReturns_Horizons_CoinAItem1_Name"):SetText( tblJiangHu[i].Name );
  	bar1:GetSubItem("HerosReturns_Horizons_CoinAItem1_Text"):SetText( tblJiangHu[i].Level );
  	bar1:GetSubItem("HerosReturns_Horizons_CoinAItem1_Tag"):SetProperty("Image", tblJiangHu[i].TagImage );
  	bar1:SetEvent( "MouseLClick", string.format("HerosReturns_Horizons_Select_Clicked(%d, %d)", hlLevel, i))
	end
	
	HerosReturns_Horizons_Lace:SetSelected(1);
	HerosReturns_Horizons_Select_Clicked( hlLevel, 1 )
		
	-- 奖励
	local nJianWen = GetHeroesReturnsJianWenValue()
	HerosReturns_Horizons_Progress_Name:SetText( ScriptGlobal_Format("#{HLYH_220613_22}", nJianWen )  )
	
	if hlLevel == 2 then
		HerosReturns_Horizons_Progress1_Client:Show();
		HerosReturns_Horizons_Progress2_Client:Hide();
	end
	if hlLevel == 3 then
		HerosReturns_Horizons_Progress2_Client:Show();
		HerosReturns_Horizons_Progress1_Client:Hide();
	end
	HerosReturns_Horizons_InitBonusCtrl( hlLevel );
	HerosReturns_Horizons_ShowBonus( hlLevel, nJianWen );
	
	--回流等级
	if g_HerosReturns_Horizons_HlLevelIamge[ hlLevel ] ~= nil then
		HerosReturns_HorizonsText_Image:SetText( g_HerosReturns_Horizons_HlLevelIamge[ hlLevel ] )
	end
	
	-- 刷新剩余时间 
	local nLeftTime = tonumber(g_HerosReturns_Horizons_LeftTime);
	if nLeftTime > 0 then
		local nDay = math.floor(nLeftTime / (3600 * 24));
		local nHour = math.ceil( math.mod( nLeftTime, 3600*24)/ 3600 )
		
		HerosReturns_HorizonsText2:SetText( ScriptGlobal_Format("#{HJHL_201224_29}", nDay, nHour) );
		HerosReturns_HorizonsText2:Show();
	end
	
end

function HerosReturns_Horizons_InitBonusCtrl( hlLevel )
	if hlLevel == 2 then
		g_HerosReturns_Horizons_BonusActionButton[1] = HerosReturns_Horizons_Progress_Item1;
		g_HerosReturns_Horizons_BonusActionButton[2] = HerosReturns_Horizons_Progress_Item2;
		g_HerosReturns_Horizons_BonusActionButton[3] = HerosReturns_Horizons_Progress_Item3;
		g_HerosReturns_Horizons_BonusActionButton[4] = HerosReturns_Horizons_Progress_Item4;
		
		g_HerosReturns_Horizons_BonusTips[1] = HerosReturns_Horizons_Progress_Item1_Tips;
		g_HerosReturns_Horizons_BonusTips[2] = HerosReturns_Horizons_Progress_Item2_Tips;
		g_HerosReturns_Horizons_BonusTips[3] = HerosReturns_Horizons_Progress_Item3_Tips;
		g_HerosReturns_Horizons_BonusTips[4] = HerosReturns_Horizons_Progress_Item4_Tips;
		
		g_HerosReturns_Horizons_BonusReceived[1] = HerosReturns_Horizons_Progress_Item1_Received;
		g_HerosReturns_Horizons_BonusReceived[2] = HerosReturns_Horizons_Progress_Item2_Received;
		g_HerosReturns_Horizons_BonusReceived[3] = HerosReturns_Horizons_Progress_Item3_Received;
		g_HerosReturns_Horizons_BonusReceived[4] = HerosReturns_Horizons_Progress_Item4_Received;
		
		g_HerosReturns_Horizons_BonusMask[1] = HerosReturns_Horizons_Progress_Item1_Grey;
		g_HerosReturns_Horizons_BonusMask[2] = HerosReturns_Horizons_Progress_Item2_Grey;
		g_HerosReturns_Horizons_BonusMask[3] = HerosReturns_Horizons_Progress_Item3_Grey;
		g_HerosReturns_Horizons_BonusMask[4] = HerosReturns_Horizons_Progress_Item4_Grey;
		
		g_HerosReturns_Horizons_BonusProgress = HerosReturns_Horizons_EXP1
	else
		g_HerosReturns_Horizons_BonusActionButton[1] = HerosReturns_Horizons_Progress2_Item1;
		g_HerosReturns_Horizons_BonusActionButton[2] = HerosReturns_Horizons_Progress2_Item2;
		g_HerosReturns_Horizons_BonusActionButton[3] = HerosReturns_Horizons_Progress2_Item3;
		g_HerosReturns_Horizons_BonusActionButton[4] = HerosReturns_Horizons_Progress2_Item4;
		g_HerosReturns_Horizons_BonusActionButton[5] = HerosReturns_Horizons_Progress2_Item5;
		g_HerosReturns_Horizons_BonusActionButton[6] = HerosReturns_Horizons_Progress2_Item6;
		
		g_HerosReturns_Horizons_BonusTips[1] = HerosReturns_Horizons_Progress2_Item1_Tips;
		g_HerosReturns_Horizons_BonusTips[2] = HerosReturns_Horizons_Progress2_Item2_Tips;
		g_HerosReturns_Horizons_BonusTips[3] = HerosReturns_Horizons_Progress2_Item3_Tips;
		g_HerosReturns_Horizons_BonusTips[4] = HerosReturns_Horizons_Progress2_Item4_Tips;
		g_HerosReturns_Horizons_BonusTips[5] = HerosReturns_Horizons_Progress2_Item5_Tips;
		g_HerosReturns_Horizons_BonusTips[6] = HerosReturns_Horizons_Progress2_Item6_Tips;
		
		g_HerosReturns_Horizons_BonusReceived[1] = HerosReturns_Horizons_Progress2_Item1_Received;
		g_HerosReturns_Horizons_BonusReceived[2] = HerosReturns_Horizons_Progress2_Item2_Received;
		g_HerosReturns_Horizons_BonusReceived[3] = HerosReturns_Horizons_Progress2_Item3_Received;
		g_HerosReturns_Horizons_BonusReceived[4] = HerosReturns_Horizons_Progress2_Item4_Received;
		g_HerosReturns_Horizons_BonusReceived[5] = HerosReturns_Horizons_Progress2_Item5_Received;
		g_HerosReturns_Horizons_BonusReceived[6] = HerosReturns_Horizons_Progress2_Item6_Received;
		
		g_HerosReturns_Horizons_BonusMask[1] = HerosReturns_Horizons_Progress2_Item1_Grey;
		g_HerosReturns_Horizons_BonusMask[2] = HerosReturns_Horizons_Progress2_Item2_Grey;
		g_HerosReturns_Horizons_BonusMask[3] = HerosReturns_Horizons_Progress2_Item3_Grey;
		g_HerosReturns_Horizons_BonusMask[4] = HerosReturns_Horizons_Progress2_Item4_Grey;
		g_HerosReturns_Horizons_BonusMask[5] = HerosReturns_Horizons_Progress2_Item5_Grey;
		g_HerosReturns_Horizons_BonusMask[6] = HerosReturns_Horizons_Progress2_Item6_Grey;
		
		g_HerosReturns_Horizons_BonusProgress = HerosReturns_Horizons_EXP2
	end
end

function HerosReturns_Horizons_ShowBonus( hlLevel, nJianWenValue )
	local tblBonus = g_HerosReturns_Horizons_Bonus[hlLevel];
	if tblBonus == nil then
		return
	end
	
	local nFinishCount = 0
	for i=1, table.getn(tblBonus) do
		if g_HerosReturns_Horizons_BonusActionButton[i] ~= nil and tblBonus[i] ~= nil then
			
			local theAction = DataPool:CreateBindActionItemForShow(tblBonus[i].itemId, tblBonus[i].count)
			if theAction:GetID() ~= 0 then
				g_HerosReturns_Horizons_BonusActionButton[i]:SetActionItem( theAction:GetID() );
			end
			
			local bGetFlag = GetHeroesReturnsJianWenBonus( i );
			if bGetFlag == nil then
				bGetFlag = 0;
			end
			
			g_HerosReturns_Horizons_BonusTips[i]:Hide();
			g_HerosReturns_Horizons_BonusMask[i]:Hide();
			g_HerosReturns_Horizons_BonusReceived[i]:Hide();
			if nJianWenValue >= tblBonus[i].jianwen then
				nFinishCount = i;
								
				if bGetFlag == 0 then
					g_HerosReturns_Horizons_BonusTips[i]:Show();
				else
					g_HerosReturns_Horizons_BonusMask[i]:Show();
					g_HerosReturns_Horizons_BonusReceived[i]:Show();
				end
			end
		end
	end
	
	g_HerosReturns_Horizons_BonusProgress: SetProgress(nFinishCount, table.getn(tblBonus));
	
end

function HerosReturns_Horizons_Select_Clicked( hlLevel, index )
	if hlLevel == nil or index == nil then
		return
	end
	
	local tblJiangHu = g_HerosReturns_Horizons_JiangHu[hlLevel]
	if tblJiangHu == nil or tblJiangHu[index] == nil then
		return
	end
	
	--区域3
	HerosReturns_Horizons_Subtitle_Images:SetProperty("Image", tblJiangHu[index].TitleImage )
	HerosReturns_Horizons_Infomation_Text:SetText( tblJiangHu[index].Desc );
	
	--区域4
	local tblTask = tblJiangHu[index].Task;
	if tblTask == nil then
		return
	end

	if tblTask[1] ~= nil then
		local nNum = GetHeroesReturnsJianTaskInfo( tblTask[1].id );
		if nNum == nil then
			nNum = 0
		end
		HerosReturns_Horizons_Mission1_Name:SetText( ScriptGlobal_Format(tblTask[1].Name, nNum) );
		HerosReturns_Horizons_Mission1_Num:SetText( ScriptGlobal_Format("#{HLYH_220613_22}", tblTask[1].Bonus) );
	end
	
	if tblTask[2] ~= nil then
		local nNum = GetHeroesReturnsJianTaskInfo( tblTask[2].id );
		if nNum == nil then
			nNum = 0
		end
		HerosReturns_Horizons_Mission2_Name:SetText( ScriptGlobal_Format(tblTask[2].Name, nNum) );
		HerosReturns_Horizons_Mission2_Num:SetText( ScriptGlobal_Format("#{HLYH_220613_22}", tblTask[2].Bonus) );
	end
	
	g_HerosReturns_Horizons_CurSelected = index;
	
end

function HerosReturns_Horizons_Mission1_GotoBtn_Clicked()

	if g_HerosReturns_Horizons_HlLevel <= 0 then
		PushDebugMessage("#{HLYH_220613_23}")
		return
	end
	
	local tblJiangHu = g_HerosReturns_Horizons_JiangHu[g_HerosReturns_Horizons_HlLevel];
	if tblJiangHu == nil or tblJiangHu[g_HerosReturns_Horizons_CurSelected] == nil then
		PushDebugMessage("#{HLYH_220613_24}")
		return
	end
	
	local tblTask = tblJiangHu[g_HerosReturns_Horizons_CurSelected].Task;
	if tblTask[1] ~= nil then
		AutoRuntoTargetExWithName(tblTask[1].xPos, tblTask[1].zPos, tblTask[1].sceneId, tblTask[1].NpcName )
	end 

end

function HerosReturns_Horizons_Mission2_GotoBtn_Clicked()

	if g_HerosReturns_Horizons_HlLevel <= 0 then
		PushDebugMessage("#{HLYH_220613_23}")
		return
	end

	local tblJiangHu = g_HerosReturns_Horizons_JiangHu[g_HerosReturns_Horizons_HlLevel];
	if tblJiangHu == nil or tblJiangHu[g_HerosReturns_Horizons_CurSelected] == nil then
		PushDebugMessage("#{HLYH_220613_24}")
		return
	end
	
	local tblTask = tblJiangHu[g_HerosReturns_Horizons_CurSelected].Task;
	if tblTask[2] ~= nil then
		AutoRuntoTargetExWithName(tblTask[2].xPos, tblTask[2].zPos, tblTask[2].sceneId, tblTask[2].NpcName )
	end 
	
end

function HerosReturns_Horizons_BonusClicked( index )

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGetJianWenBonus")
		Set_XSCRIPT_ScriptID(808110)
		Set_XSCRIPT_Parameter(0,index)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--刷新红点
function HerosReturns_Horizons_UpdateRedPoint()

	for i = 1, 4 do
		if g_HerosReturns_Horizons_RedPointState[i] == 1 then
			g_HerosReturns_Horizons_RedPoint[i]:Show()
		else
			g_HerosReturns_Horizons_RedPoint[i]:Hide()
		end
	end
			
end

--页面切换 1、归来礼馈 2、江湖告令 3、荣归阁 4、江湖见闻
function HerosReturns_Horizons_FenYe_Clicked(index)
	if index < 1 or index > 4 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenUI" ); 		-- 脚本号
		Set_XSCRIPT_ScriptID( 808110 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, index)
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
	
	
	Variable:SetVariable("HerosReturnsUIPos", HerosReturns_Horizons_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HerosReturns_Horizons_OnClickHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnShowHelp" ); 		-- 脚本号
		Set_XSCRIPT_ScriptID( 808110 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function HerosReturns_Horizons_Close()
	this:Hide()
end

function HerosReturns_Horizons_OnHidden()
	
end

function HerosReturns_Horizons_Frame_On_ResetPos()
  HerosReturns_Horizons_FrameFull:SetProperty("UnifiedPosition", g_HerosReturns_Horizons_Frame_UnifiedPosition);
end

function HerosReturns_Horizons_On_SetLastPos()
	local CurUIPos = Variable:GetVariable("HerosReturnsUIPos")
	if( CurUIPos ~= nil) then
	    HerosReturns_Horizons_FrameFull:SetProperty("UnifiedPosition", CurUIPos )
	end
end
