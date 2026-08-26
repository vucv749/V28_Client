--******************************************
--组队藏宝图副本 最后领奖界面
--create by  limengyue 
--2024-07-22
--******************************************
local g_CangBao_Info_Frame_UnifiedPosition;
--关心NPc
local g_CangBao_targetId = -1;
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1

local g_CangBao_PlayerIdx = {}--记录下玩家顺序 第几个玩家
--g_CangBao_PlayerIdx[1]={nIndex = 1,nPlayerName = "aa", nItemID = 30000005, nAskIdx = 2, nAskRet = 0, nHeadID = 0}
--控件
local g_CangBao_PlayerList = {} --6个玩家
local g_CangBao_ItemList = {} --6个奖励
local g_CangBao_GetFlagList = {} --6个已领取标记
local g_CangBao_TextList = {} --6个文本区
local g_CangBao_ChangeBtnList = {} --6个交换按钮
local g_CangBao_AcceptBtnList = {} --6个接受交换按钮
local g_CangBao_PrizeBtnList = {} --6个领奖按钮
local g_CangBao_HeadImgList = {} --6个头像区
local g_CangBao_MyImgList = {} --6个显示自己
local g_CangBao_ExchangeTxtList = {} --6个显示交换状态
local g_CangBao_GetTxtList = {} --6个显示已领取

--=========================================================
--PreLoad
--=========================================================
function CangBao_Info_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function CangBao_Info_OnLoad()
	g_CangBao_Info_Frame_UnifiedPosition = CangBao_Info_Frame:GetProperty("UnifiedPosition");
	--控件
	--6个玩家
	g_CangBao_PlayerList[1] = CangBao_Info_Player1
	g_CangBao_PlayerList[2] = CangBao_Info_Player2
	g_CangBao_PlayerList[3] = CangBao_Info_Player3
	g_CangBao_PlayerList[4] = CangBao_Info_Player4
	g_CangBao_PlayerList[5] = CangBao_Info_Player5
	g_CangBao_PlayerList[6] = CangBao_Info_Player6
	--6个奖励
	g_CangBao_ItemList[1] = CangBao_Info_Player1_Item
	g_CangBao_ItemList[2] = CangBao_Info_Player2_Item
	g_CangBao_ItemList[3] = CangBao_Info_Player3_Item
	g_CangBao_ItemList[4] = CangBao_Info_Player4_Item
	g_CangBao_ItemList[5] = CangBao_Info_Player5_Item
	g_CangBao_ItemList[6] = CangBao_Info_Player6_Item
	-- --6个已领取标记
	-- g_CangBao_GetFlagList[1] = CangBao_Info_Player1_GetBK
	-- g_CangBao_GetFlagList[2] = CangBao_Info_Player2_GetBK
	-- g_CangBao_GetFlagList[3] = CangBao_Info_Player3_GetBK
	-- g_CangBao_GetFlagList[4] = CangBao_Info_Player4_GetBK
	-- g_CangBao_GetFlagList[5] = CangBao_Info_Player5_GetBK
	-- g_CangBao_GetFlagList[6] = CangBao_Info_Player6_GetBK
	--6个头像区
	g_CangBao_HeadImgList[1] = CangBao_Info_Player1_Image
	g_CangBao_HeadImgList[2] = CangBao_Info_Player2_Image
	g_CangBao_HeadImgList[3] = CangBao_Info_Player3_Image
	g_CangBao_HeadImgList[4] = CangBao_Info_Player4_Image
	g_CangBao_HeadImgList[5] = CangBao_Info_Player5_Image
	g_CangBao_HeadImgList[6] = CangBao_Info_Player6_Image
	--6个文本区
	g_CangBao_TextList[1] = CangBao_Info_Player1_Exchange
	g_CangBao_TextList[2] = CangBao_Info_Player2_Exchange
	g_CangBao_TextList[3] = CangBao_Info_Player3_Exchange
	g_CangBao_TextList[4] = CangBao_Info_Player4_Exchange
	g_CangBao_TextList[5] = CangBao_Info_Player5_Exchange
	g_CangBao_TextList[6] = CangBao_Info_Player6_Exchange
	--6个显示自己
	g_CangBao_MyImgList[1] = CangBao_Info_Player1Image
	g_CangBao_MyImgList[2] = CangBao_Info_Player2Image
	g_CangBao_MyImgList[3] = CangBao_Info_Player3Image
	g_CangBao_MyImgList[4] = CangBao_Info_Player4Image
	g_CangBao_MyImgList[5] = CangBao_Info_Player5Image
	g_CangBao_MyImgList[6] = CangBao_Info_Player6Image
	--6个交换按钮
	g_CangBao_ChangeBtnList[1] = CangBao_Info_Player1_ExchangeBtn
	g_CangBao_ChangeBtnList[2] = CangBao_Info_Player2_ExchangeBtn
	g_CangBao_ChangeBtnList[3] = CangBao_Info_Player3_ExchangeBtn
	g_CangBao_ChangeBtnList[4] = CangBao_Info_Player4_ExchangeBtn
	g_CangBao_ChangeBtnList[5] = CangBao_Info_Player5_ExchangeBtn
	g_CangBao_ChangeBtnList[6] = CangBao_Info_Player6_ExchangeBtn
	--6个接受交换按钮
	g_CangBao_AcceptBtnList[1] = CangBao_Info_Player1_OKBtn
	g_CangBao_AcceptBtnList[2] = CangBao_Info_Player2_OKBtn
	g_CangBao_AcceptBtnList[3] = CangBao_Info_Player3_OKBtn
	g_CangBao_AcceptBtnList[4] = CangBao_Info_Player4_OKBtn
	g_CangBao_AcceptBtnList[5] = CangBao_Info_Player5_OKBtn
	g_CangBao_AcceptBtnList[6] = CangBao_Info_Player6_OKBtn
	--6个领奖按钮
	g_CangBao_PrizeBtnList[1] = CangBao_Info_Player1_GetBtn
	g_CangBao_PrizeBtnList[2] = CangBao_Info_Player2_GetBtn
	g_CangBao_PrizeBtnList[3] = CangBao_Info_Player3_GetBtn
	g_CangBao_PrizeBtnList[4] = CangBao_Info_Player4_GetBtn
	g_CangBao_PrizeBtnList[5] = CangBao_Info_Player5_GetBtn
	g_CangBao_PrizeBtnList[6] = CangBao_Info_Player6_GetBtn
	--6个显示交换状态
	g_CangBao_ExchangeTxtList[1] = CangBao_Info_Player1_Exchange2
	g_CangBao_ExchangeTxtList[2] = CangBao_Info_Player2_Exchange2
	g_CangBao_ExchangeTxtList[3] = CangBao_Info_Player3_Exchange2
	g_CangBao_ExchangeTxtList[4] = CangBao_Info_Player4_Exchange2
	g_CangBao_ExchangeTxtList[5] = CangBao_Info_Player5_Exchange2
	g_CangBao_ExchangeTxtList[6] = CangBao_Info_Player6_Exchange2
	--6个显示已领取
	g_CangBao_GetTxtList[1] = CangBao_Info_Player1_GetBK
	g_CangBao_GetTxtList[2] = CangBao_Info_Player2_GetBK
	g_CangBao_GetTxtList[3] = CangBao_Info_Player3_GetBK
	g_CangBao_GetTxtList[4] = CangBao_Info_Player4_GetBK
	g_CangBao_GetTxtList[5] = CangBao_Info_Player5_GetBK
	g_CangBao_GetTxtList[6] = CangBao_Info_Player6_GetBK
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function CangBao_Info_On_ResetPos()

	CangBao_Info_Frame:SetProperty("UnifiedPosition", g_CangBao_Info_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_Info_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340320 ) then
		--打开界面
		if(IsWindowShow("CangBao_Info")) then
			CloseWindow("CangBao_Info", true)
		end
		--添加NPC关心 不需要
		g_CangBao_targetId = Get_XParam_INT(0)
		if g_CangBao_targetId >= 0 then
			objCared = DataPool : GetNPCIDByServerID(g_CangBao_targetId);
			CangBao_Info_BeginCareObject(objCared)
		end
		CangBao_Info_Open(Get_XParam_INT(1),Get_XParam_STR(0),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_STR(1),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_STR(2),Get_XParam_INT(6),Get_XParam_INT(7),Get_XParam_STR(3),Get_XParam_INT(8),Get_XParam_INT(9),Get_XParam_STR(4),Get_XParam_INT(10),Get_XParam_INT(11),Get_XParam_STR(5),Get_XParam_INT(12),Get_XParam_INT(13))
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89340321 ) then
		--打开界面
		if(IsWindowShow("CangBao_Info")) then
			--更新数据
			CangBao_Info_Update(Get_XParam_INT(0),Get_XParam_STR(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_STR(1),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_STR(2),Get_XParam_INT(5),Get_XParam_INT(6),Get_XParam_STR(3),Get_XParam_INT(7),Get_XParam_INT(8),Get_XParam_STR(4),Get_XParam_INT(9),Get_XParam_INT(10),Get_XParam_STR(5),Get_XParam_INT(11),Get_XParam_INT(12))
		end
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_Info_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_Info_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_Info_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--打开界面
--nAskRet 0 1正在交换 2是交换成功领取  3是已领取
--=========================================================
function CangBao_Info_Open(nItem1,nPlayer1,nPlayer1Info,nItem2,nPlayer2,nPlayer2Info,nItem3,nPlayer3,nPlayer3Info,nItem4,nPlayer4,nPlayer4Info,nItem5,nPlayer5,nPlayer5Info,nItem6,nPlayer6,nPlayer6Info,nTick)
	CangBao_Info_Update(nItem1,nPlayer1,nPlayer1Info,nItem2,nPlayer2,nPlayer2Info,nItem3,nPlayer3,nPlayer3Info,nItem4,nPlayer4,nPlayer4Info,nItem5,nPlayer5,nPlayer5Info,nItem6,nPlayer6,nPlayer6Info,nTick)
	this:Show()
end

--=========================================================
--打开界面
--nAskRet 0 1正在交换 2是交换成功  3是已领取交换奖励  4是自己领取了自己的
--=========================================================
function CangBao_Info_Update(nItem1,nPlayer1,nPlayer1Info,nItem2,nPlayer2,nPlayer2Info,nItem3,nPlayer3,nPlayer3Info,nItem4,nPlayer4,nPlayer4Info,nItem5,nPlayer5,nPlayer5Info,nItem6,nPlayer6,nPlayer6Info,nTick)
	g_CangBao_PlayerIdx = {}
	
	--PushDebugMessage("人名 "..nPlayer1.." "..nPlayer2.." "..nPlayer3.." "..nPlayer4.." "..nPlayer5.." "..nPlayer6)
	--PushDebugMessage("对应信息"..nPlayer1Info.." "..nPlayer2Info.." "..nPlayer3Info.." "..nPlayer4Info.." "..nPlayer5Info.." "..nPlayer6Info)
	--剩余时间
	if nTick > 0 then
		CangBao_Info_Time:SetProperty("Timer", tostring(nTick))
	else
		CangBao_Info_Time:SetProperty("Timer", "0")
	end
	
	local mAskPlayerIDx1 = math.mod(nPlayer1Info,10)
	local mAskResult1 = math.floor(math.mod(nPlayer1Info,100)/10) 
	local mHeadID1 = math.floor(math.mod(nPlayer1Info,100000)/100) 
	g_CangBao_PlayerIdx[1]={nIndex = 1,nPlayerName = tostring(nPlayer1), nItemID = tonumber(nItem1),nAskIdx = mAskPlayerIDx1, nAskRet = mAskResult1, nHeadID = mHeadID1}
	local mAskPlayerIDx2 = math.mod(nPlayer2Info,10)
	local mAskResult2 = math.floor(math.mod(nPlayer2Info,100)/10) 
	local mHeadID2 = math.floor(math.mod(nPlayer2Info,100000)/100) 
	g_CangBao_PlayerIdx[2]={nIndex = 2,nPlayerName = tostring(nPlayer2), nItemID = tonumber(nItem2),nAskIdx = mAskPlayerIDx2, nAskRet = mAskResult2, nHeadID = mHeadID2}
	local mAskPlayerIDx3 = math.mod(nPlayer3Info,10)
	local mAskResult3 = math.floor(math.mod(nPlayer3Info,100)/10) 
	local mHeadID3 = math.floor(math.mod(nPlayer3Info,100000)/100) 
	g_CangBao_PlayerIdx[3]={nIndex = 3,nPlayerName = tostring(nPlayer3), nItemID = tonumber(nItem3),nAskIdx = mAskPlayerIDx3, nAskRet = mAskResult3, nHeadID = mHeadID3}
	local mAskPlayerIDx4 = math.mod(nPlayer4Info,10)
	local mAskResult4 = math.floor(math.mod(nPlayer4Info,100)/10) 
	local mHeadID4 = math.floor(math.mod(nPlayer4Info,100000)/100) 
	g_CangBao_PlayerIdx[4]={nIndex = 4,nPlayerName = tostring(nPlayer4), nItemID = tonumber(nItem4),nAskIdx = mAskPlayerIDx4, nAskRet = mAskResult4, nHeadID = mHeadID4}
	local mAskPlayerIDx5 = math.mod(nPlayer5Info,10)
	local mAskResult5 = math.floor(math.mod(nPlayer5Info,100)/10) 
	local mHeadID5 = math.floor(math.mod(nPlayer5Info,100000)/100) 
	g_CangBao_PlayerIdx[5]={nIndex = 5,nPlayerName = tostring(nPlayer5), nItemID = tonumber(nItem5),nAskIdx = mAskPlayerIDx5, nAskRet = mAskResult5, nHeadID = mHeadID5}
	local mAskPlayerIDx6 = math.mod(nPlayer6Info,10)
	local mAskResult6 = math.floor(math.mod(nPlayer6Info,100)/10) 
	local mHeadID6 = math.floor(math.mod(nPlayer6Info,100000)/100) 
	g_CangBao_PlayerIdx[6]={nIndex = 6,nPlayerName = tostring(nPlayer6), nItemID = tonumber(nItem6),nAskIdx = mAskPlayerIDx6, nAskRet = mAskResult6, nHeadID = mHeadID6}
	local myName = Player:GetName()	
	local myIdx = -1
	for index=1,table.getn(g_CangBao_PlayerList)  do
		--当前名字
		local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
		--对比
		if myName == nCurName then
			myIdx = index
			break
		end
	end
	for index=1,table.getn(g_CangBao_PlayerList)  do
		--玩家有奖励才显示
		if g_CangBao_PlayerIdx[index].nItemID > 0 then
			g_CangBao_PlayerList[index]:Show();
			--当前名字
			local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
			g_CangBao_TextList[index]:SetText(nCurName)
			--当前头像
			local mHeadID = g_CangBao_PlayerIdx[index].nHeadID
			local portrait = DataPool:GetPortraitByID(mHeadID)
			--PushDebugMessage("test 第"..index.."个玩家"..nCurName.."头像id="..mHeadID.." 头像图片="..portrait)
			g_CangBao_HeadImgList[index]:SetProperty("Image", portrait)
			--默认隐藏状态文字
			g_CangBao_ExchangeTxtList[index]:Hide();
			g_CangBao_GetTxtList[index]:Hide();
			--默认未领取
			--g_CangBao_GetFlagList[index]:Hide();
			--默认隐藏三个按钮
			--当前请求交换的idx
			local nAskIdx = g_CangBao_PlayerIdx[index].nAskIdx	
			--先看是不是我自己
			g_CangBao_PrizeBtnList[index]:Hide();
			g_CangBao_AcceptBtnList[index]:Hide();
			g_CangBao_ChangeBtnList[index]:Hide();
			
			--显示文本
			if myName ==  nCurName then
				--显示我的
				g_CangBao_MyImgList[index]:Show();
				--g_CangBao_TextList[index]:SetText("#{ZDBT_240703_153}")
				--领取按钮只有自己有 并且是未领取状态才显示
				if g_CangBao_PlayerIdx[index].nAskRet == 4 then
					--领了自己的奖励
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--显示细节 自己的物品
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				elseif g_CangBao_PlayerIdx[index].nAskRet == 3 then
					--已领取
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--显示细节 交换来的物品
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				else
					if g_CangBao_PlayerIdx[index].nAskRet == 2 then
						--显示细节 别人的物品
						local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
						if nShowActionA:GetID() ~= 0 then
							g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
						end
					else
						--显示细节 自己的物品
						local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
						if nShowActionA:GetID() ~= 0 then
							g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
						end
					end
					g_CangBao_PrizeBtnList[index]:Show();	
					g_CangBao_PrizeBtnList[index]:Enable();
				end
			else
				--别人那边怎么显示 领没领 是我的目标 我是别人的目标 大闲人
				g_CangBao_MyImgList[index]:Hide();
				--是否已经领取
				if g_CangBao_PlayerIdx[index].nAskRet == 4 then
					--已领取 领取的自己item
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--%s0少侠获得
					--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
					--显示细节 自己的物品
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				elseif g_CangBao_PlayerIdx[index].nAskRet == 3 then
					--已领取 领取的目标的item
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--%s0少侠获得
					--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
					--显示细节 物品
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				elseif g_CangBao_PlayerIdx[index].nAskRet == 2 then
					--刚交换完 显示别人的item
					--%s0少侠获得
					--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
					--显示细节 物品
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				else
					--PushDebugMessage("还没领")
					--显示细节 自己的物品
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
					--别人还没领奖  分为 是我的目标 我是别人的目标 大闲人
					if g_CangBao_PlayerIdx[myIdx].nAskIdx == index then
						--PushDebugMessage("是我的目标")
						--是我的目标
						--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
						--按钮处理
						g_CangBao_ChangeBtnList[index]:Show();
						g_CangBao_ChangeBtnList[index]:Disable();
						g_CangBao_ChangeBtnList[index]:SetText("#{ZDBT_240703_164}")--申请中
					else
						--不是我的目标
						--PushDebugMessage("不是我的目标 ask="..g_CangBao_PlayerIdx[index].nAskIdx.." myIdx="..myIdx)
						if g_CangBao_PlayerIdx[index].nAskIdx == myIdx then 
							--但是我是他的目标
							g_CangBao_ExchangeTxtList[index]:Show();
							--%s0少侠请求交换
							--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_165}", nCurName))
							--按钮处理
							g_CangBao_AcceptBtnList[index]:Show();
							g_CangBao_AcceptBtnList[index]:Enable();
						else
							--大闲人
							--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
							--看我能不能申请
							if g_CangBao_PlayerIdx[myIdx].nAskRet < 1 then
								--我不在交换中也没领奖
								g_CangBao_ChangeBtnList[index]:Show();
								g_CangBao_ChangeBtnList[index]:Enable();
								g_CangBao_ChangeBtnList[index]:SetText("#{ZDBT_240703_97}")--交换
							else
								--他爱干嘛干嘛 跟我没关系了
							end
						end
					end
				end
			end	
		else
			g_CangBao_PlayerList[index]:Hide();
		end
	end
	--关闭二次确认界面
	PushEvent("CONFIRM_CANGBAOTU",-1,-1,-1,-1)
	PushEvent("CONFIRM_CANGBAOTU_ACCEPT",-1,-1,-1,-1)
end
--=========================================================
--关闭界面
--=========================================================
function CangBao_Info_Close()
	PushEvent("CONFIRM_CANGBAOTU",-1,-1,-1,-1)
	PushEvent("CONFIRM_CANGBAOTU_ACCEPT",-1,-1,-1,-1)
	this:Hide()
end

--=========================================================
--开始关心NPC
--=========================================================
function CangBao_Info_BeginCareObject(objCaredId)
	if g_Object ~= -1 then
		this:CareObject(objCaredId, 0, "CangBao_Info");
	end
	g_Object = objCaredId
	this:CareObject(g_Object, 1, "CangBao_Info")
end


--=========================================================
--停止对某NPC的关心
--=========================================================
function CangBao_Info_StopCareObject()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "CangBao_Info");
		g_Object = -1;
	end
end

--=========================================================
--帮助
--=========================================================
function CangBao_Info_Help()
	PushEvent("QUEST_HELPINFO", "缺字典")--"#{XSX_220705_170}")
end

--=========================================================
--默认领取奖励
--=========================================================
function CangBao_Info_GetMyAward()
	local myName = Player:GetName()	
	local myItem = -1
	for index=1,table.getn(g_CangBao_PlayerList)  do
		--名字
		local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
		if myName ==  nCurName then
			--显示我的
			myItem = g_CangBao_PlayerIdx[index].nItemID
		end
	end
	--全交给服务器判断
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetMyAward")
		Set_XSCRIPT_ScriptID(893403)
		Set_XSCRIPT_Parameter( 0,g_CangBao_targetId)
		Set_XSCRIPT_Parameter( 1,myItem)
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
end


--=========================================================
--交换按钮
--=========================================================
function CangBao_Info_ExchangeClick(index)
	if index < 1 or index > 6 then
		PushDebugMessage("数据错误 ExchangeClick(index)"..index)
		return
	end
	--是个二次确认按钮
	local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
	local nCurItem = g_CangBao_PlayerIdx[index].nItemID
	--PushDebugMessage("传入变量 "..g_CangBao_targetId.." "..nCurName.." "..nCurItem.." "..index)
	PushEvent("CONFIRM_CANGBAOTU",g_CangBao_targetId,nCurName,nCurItem,index)

	-- --测试给服务器判断
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name("ChangeAward")
		-- Set_XSCRIPT_ScriptID(893403)
		-- Set_XSCRIPT_Parameter( 0,g_CangBao_targetId)
		-- Set_XSCRIPT_Parameter( 1,index)
		-- Set_XSCRIPT_ParamCount( 2 )
	-- Send_XSCRIPT()
end

--=========================================================
--接受按钮
--=========================================================
function CangBao_Info_AcceptClick(index)
	if index < 1 or index > 6 then
		PushDebugMessage("数据错误 AcceptClick(index)"..index)
		return
	end

	--是个二次确认按钮
	local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
	local nCurItem = g_CangBao_PlayerIdx[index].nItemID
	--PushDebugMessage("传入变量 "..g_CangBao_targetId.." "..nCurName.." "..nCurItem.." "..index)
	PushEvent("CONFIRM_CANGBAOTU_ACCEPT",g_CangBao_targetId,nCurName,nCurItem,index)

	
	-- --测试给服务器判断
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name("AcceptAward")
		-- Set_XSCRIPT_ScriptID(893403)
		-- Set_XSCRIPT_Parameter( 0,g_CangBao_targetId)
		-- Set_XSCRIPT_Parameter( 1,index)
		-- Set_XSCRIPT_ParamCount( 2 )
	-- Send_XSCRIPT()
end