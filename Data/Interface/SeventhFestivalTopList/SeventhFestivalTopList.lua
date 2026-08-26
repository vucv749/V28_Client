----------------------
-- SeventhFestivalTopList ---
----------------------
--界面位置
local g_SeventhFestivalTopList_UnifiedPosition = nil

--计时器
local g_SeventhFestivalTopList_CooldownDur = 4*1000	--4s冷却
local g_SeventhFestivalTopList_Cooldown = 
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

local g_Present_BarList = {}
local g_Receive_BarList = {}

--页签显示
local g_SeventhFestivalTopList_CurPage = 0--默认显示页签--注：1-3标示排行榜 4-5标示兑换奖励
local g_SeventhFestivalTopList_MaxPage = 4--最大页签数

--排行榜相关控件
local g_SeventhFestivalTopList_Btn_Page = {}
local g_SeventhFestivalTopList_Present_Name = {}
local g_SeventhFestivalTopList_Present_Score = {}
local g_SeventhFestivalTopList_Present_Winner = {}

local g_SeventhFestivalTopList_Btn_PageImage = {}

local g_SeventhFestivalTopList_Receive_Name = {}
local g_SeventhFestivalTopList_Receive_Score = {}
local g_SeventhFestivalTopList_Receive_Winner = {}

local g_SeventhFestivalTopList_RankImage = {
"set:QiXi_HuaBang3 image:QiXi2_HuaBangNum1",
"set:QiXi_HuaBang3 image:QiXi2_HuaBangNum2",
"set:QiXi_HuaBang3 image:QiXi2_HuaBangNum3",
}

local g_SeventhFestivalTopList_QRJ = 0
--上榜人数
local g_SeventhFestivalTopList_Count = 20

--活动状态
local g_SeventhFestivalTopList_State = -1
local g_SeventhFestivalTopList_StateShow = -1

--榜单信息
local g_SeventhFestivalTopList_Info = --待修改
{
	[1] = {desc = "#{QXHB_20210701_94}", count = 3, sendmd = 1094, receivemd = 1095, sendtitle = "#{QXHB_20210701_96}", receivetitle = "#{QXHB_20210701_115}", strsend = "#{QXHB_20210701_101}", strreceive = "#{QXHB_20210701_103}", strsendNum = "#{QXHB_20210701_105}", strreceiveNum = "#{QXHB_20210701_255}"},
	[2] = {desc = "#{QXHB_20210701_140}", count = 3, sendmd = 1096, receivemd = 1097, sendtitle = "#{QXHB_20210701_96}", receivetitle = "#{QXHB_20210701_115}", strsend = "#{QXHB_20210701_101}", strreceive = "#{QXHB_20210701_103}", strsendNum = "#{QXHB_20210701_105}", strreceiveNum = "#{QXHB_20210701_255}"},
	[3] = {desc = "#{QXHB_20210701_149}", count = 3, sendmd = 1098, receivemd = 1099, sendtitle = "#{QXHB_20210701_96}", receivetitle = "#{QXHB_20210701_115}", strsend = "#{QXHB_20210701_101}", strreceive = "#{QXHB_20210701_103}", strsendNum = "#{QXHB_20210701_105}", strreceiveNum = "#{QXHB_20210701_255}"},
}

--榜单信息
local g_SeventhFestivalTopList_Tip = --待修改
{
	[1] = {tip1 = "#{QXLS_150724_71}", tip2 = "#{QXLS_150724_72}", tip3 = "#{QXLS_150724_73}"},
	[2] = {tip1 = "#{QXLS_150724_71}", tip2 = "#{QXLS_150724_126}", tip3 = "#{QXLS_150724_73}"},
	[3] = {tip1 = "#{QXLS_150724_71}", tip2 = "#{QXLS_150724_127}", tip3 = "#{QXLS_150724_73}"},
}

local SeventhFestivalTopList_Exchange_Qingrenjie_Action = {}
local SeventhFestivalTopList_Exchange_Qingrenjie_Button = {}
local SeventhFestivalTopList_Exchange_Qingrenjie_Text = {}
local SeventhFestivalTopList_Exchange_Qingrenjie_Text2 = {}
local SeventhFestivalTopList_Exchange_PreButton = {}

g_SeventhFestivalTopList_Qingrenjie_Bonus =
{
	[1] = {neednum = 2400, itemid = 10125769, count = 1, name = "新时装：仙履奇缘（永久，获取绑定）", LimitMD = -1, LimitNum = -1, IsShowButton = 1},
	[2] = {neednum = 1500, itemid = 30310140, count = 1, name = "超级珍兽笼：新珍兽", LimitMD = 766, LimitNum = 3, IsShowButton = 1},
	[3] = {neednum = 2400, itemid = 38003215, count = 1, name = "金箍棒", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
	[4] = {neednum = 1500, itemid = 38003216, count = 1, name = "紫青宝剑", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
	[5] = {neednum = 1200, itemid = 38003214, count = 1, name = "照妖镜", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
	[6] = {neednum = 600, itemid = 10125802, count = 1, name = "夜锦天澜", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
	[7] = {neednum = 600, itemid = 10125818, count = 1, name = "游岚月色", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
	[8] = {neednum = 22, itemid = 30503140, count = 1, name = "虹耀石", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
	[9] = {neednum = 10, itemid = 38002138, count = 1, name = "10交子", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
	[10] = {neednum = 1, itemid = 38002139, count = 1, name = "1交子", LimitMD = -1, LimitNum = -1, IsShowButton = 0},
}

--===============================================
-- PreLoad()
--===============================================
function SeventhFestivalTopList_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_QIXI_TOPLIST")
	this:RegisterEvent("REFRESH_QIXI_TOPLIST")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UPDATA_QIXI_TOPLIST",false)
end

--===============================================
-- OnLoad()
--===============================================
function SeventhFestivalTopList_OnLoad()
	g_SeventhFestivalTopList_UnifiedPosition = SeventhFestivalTopList_Frame:GetProperty("UnifiedPosition")
		
--排行榜相关控件
	g_SeventhFestivalTopList_Btn_Page[1]	= SeventhFestivalTopList_Top_TopList1
	g_SeventhFestivalTopList_Btn_Page[2]	= SeventhFestivalTopList_Top_TopList3
	g_SeventhFestivalTopList_Btn_Page[3]	= SeventhFestivalTopList_Top_TopList2
	g_SeventhFestivalTopList_Btn_Page[4]	= SeventhFestivalTopList_Top_TopList4
	
	g_SeventhFestivalTopList_Btn_PageImage[1] = SeventhFestivalTopList_ClientBK1
	g_SeventhFestivalTopList_Btn_PageImage[2] = SeventhFestivalTopList_ClientBK3
	g_SeventhFestivalTopList_Btn_PageImage[3] = SeventhFestivalTopList_ClientBK2
	g_SeventhFestivalTopList_Btn_PageImage[4] = SeventhFestivalTopList_ClientBK4
	
--排行榜兑换相关控件	
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[1] = SeventhFestivalTopList_Exchange_Item1_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[2] = SeventhFestivalTopList_Exchange_Item2_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[3] = SeventhFestivalTopList_Exchange_Item3_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[4] = SeventhFestivalTopList_Exchange_Item4_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[5] = SeventhFestivalTopList_Exchange_Item5_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[6] = SeventhFestivalTopList_Exchange_Item6_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[7] = SeventhFestivalTopList_Exchange_Item7_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[8] = SeventhFestivalTopList_Exchange_Item8_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[9] = SeventhFestivalTopList_Exchange_Item9_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[10] = SeventhFestivalTopList_Exchange_Item10_Icon

	SeventhFestivalTopList_Exchange_Qingrenjie_Button[1] = SeventhFestivalTopList_Exchange_Item1_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[2] = SeventhFestivalTopList_Exchange_Item2_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[3] = SeventhFestivalTopList_Exchange_Item3_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[4] = SeventhFestivalTopList_Exchange_Item4_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[5] = SeventhFestivalTopList_Exchange_Item5_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[6] = SeventhFestivalTopList_Exchange_Item6_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[7] = SeventhFestivalTopList_Exchange_Item7_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[8] = SeventhFestivalTopList_Exchange_Item8_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[9] = SeventhFestivalTopList_Exchange_Item9_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[10] = SeventhFestivalTopList_Exchange_Item10_Get
	
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[1] = SeventhFestivalTopList_Exchange_Item1_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[2] = SeventhFestivalTopList_Exchange_Item2_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[3] = SeventhFestivalTopList_Exchange_Item3_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[4] = SeventhFestivalTopList_Exchange_Item4_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[5] = SeventhFestivalTopList_Exchange_Item5_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[6] = SeventhFestivalTopList_Exchange_Item6_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[7] = SeventhFestivalTopList_Exchange_Item7_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[8] = SeventhFestivalTopList_Exchange_Item8_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[9] = SeventhFestivalTopList_Exchange_Item9_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[10] = SeventhFestivalTopList_Exchange_Item10_Text

	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[1] = SeventhFestivalTopList_Exchange_Item1_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[2] = SeventhFestivalTopList_Exchange_Item2_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[3] = SeventhFestivalTopList_Exchange_Item3_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[4] = SeventhFestivalTopList_Exchange_Item4_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[5] = SeventhFestivalTopList_Exchange_Item5_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[6] = SeventhFestivalTopList_Exchange_Item6_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[7] = SeventhFestivalTopList_Exchange_Item7_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[8] = SeventhFestivalTopList_Exchange_Item8_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[9] = SeventhFestivalTopList_Exchange_Item9_Text2
	SeventhFestivalTopList_Exchange_Qingrenjie_Text2[10] = SeventhFestivalTopList_Exchange_Item10_Text2
	
	SeventhFestivalTopList_Exchange_PreButton[1] = SeventhFestivalTopList_Exchange_Item1_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[2] = SeventhFestivalTopList_Exchange_Item2_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[3] = SeventhFestivalTopList_Exchange_Item3_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[4] = SeventhFestivalTopList_Exchange_Item4_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[5] = SeventhFestivalTopList_Exchange_Item5_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[6] = SeventhFestivalTopList_Exchange_Item6_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[7] = SeventhFestivalTopList_Exchange_Item7_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[8] = SeventhFestivalTopList_Exchange_Item8_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[9] = SeventhFestivalTopList_Exchange_Item9_ItemPreview
	SeventhFestivalTopList_Exchange_PreButton[10] = SeventhFestivalTopList_Exchange_Item10_ItemPreview
	
end

--===============================================
-- OnEvent()
--===============================================
function SeventhFestivalTopList_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 891396) then
		--设置当前页
		local npage = Get_XParam_INT(0)
		if npage == 4 then
			--显示界面
			g_SeventhFestivalTopList_CurPage = npage
			g_SeventhFestivalTopList_Btn_Page[g_SeventhFestivalTopList_CurPage] : SetCheck(1)
			this:Show()
			g_SeventhFestivalTopList_QRJ = Get_XParam_INT(3)
			SeventhFestivalTopList_Exchange_Qingrenjie_Update()
		else
			if npage < 1 or npage > 3 then
				return
			end
			g_SeventhFestivalTopList_CurPage = npage
			g_SeventhFestivalTopList_Btn_Page[g_SeventhFestivalTopList_CurPage] : SetCheck(1)
			--显示状态
			local state = Get_XParam_INT(1)
			if state ~= nil and state >= 0 then
				SeventhFestivalTopList_Rank_ShowState(state)
			end
			--显示倒计时
			local strTime = Get_XParam_STR(0)
			if strTime ~= nil then
				SeventhFestivalTopList_CountDown:SetText(strTime)
			end
			g_SeventhFestivalTopList_QRJ = Get_XParam_INT(3)
		end
		
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89139603 ) then
		
		if Get_XParam_INT(0) == 2 and this:IsVisible() then
			if g_SeventhFestivalTopList_CurPage == 4 then
				g_SeventhFestivalTopList_QRJ = Get_XParam_INT(1)			
				SeventhFestivalTopList_Exchange_Qingrenjie_Update()
			end
		end
	
	elseif (event == "OPEN_QIXI_TOPLIST") then
		--显示排行榜
		SeventhFestivalTopList_Rank_ShowTopList()
		
	elseif (event == "REFRESH_QIXI_TOPLIST") then
		if tonumber(arg0) == 1 then
			--显示排行榜
			SeventhFestivalTopList_Rank_ShowTopList()
		else
			if this:IsVisible() then
				--显示排行榜
				SeventhFestivalTopList_Rank_ShowTopList()
			end
		end
		
	elseif (event == "ADJEST_UI_POS") then
		SeventhFestivalTopList_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SeventhFestivalTopList_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		SeventhFestivalTopList_Close_Click()
	elseif (event  == "UI_COMMAND") and (tonumber(arg0) == 89139602) then
		if this:IsVisible() then 
			--更新MD
			local npage = Get_XParam_INT(0)
			if npage < 1 or npage > 3 then
				return
			end
			g_SeventhFestivalTopList_CurPage = npage
			local nSendNum = Get_XParam_INT(1)
			local nReceiveNum = Get_XParam_INT(2)
			SeventhFestivalTopList_Rank_ShowRoseNum(nSendNum, nReceiveNum)
		end
	end
end

--显示收送花数量
function SeventhFestivalTopList_Rank_ShowRoseNum(nSendNum, nReceiveNum)	
	local nNumStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strsendNum, nSendNum)
	SeventhFestivalTopList_Ranking_Present_Rose:SetText(nNumStr)
	
	local nReceiveNumStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strreceiveNum, nReceiveNum)
	SeventhFestivalTopList_Ranking_Receive_Rose:SetText(nReceiveNumStr)
end

--===============================================
-- 以下为界面更新显示
--===============================================
--显示排行榜状态
function SeventhFestivalTopList_Rank_ShowState(state)	
	g_SeventhFestivalTopList_State = state
end

--显示排行榜
function SeventhFestivalTopList_Rank_ShowTopList()
	--有效性判断
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return
	end
	
	--显示界面
	this:Show()
	
	--隐藏兑奖
	SeventhFestivalTopList_Exchange_Frame:Hide()
	
	--显示排行榜
	SeventhFestivalTopList_Ranking_Frame:Show()
	
	for i = 1, table.getn(g_SeventhFestivalTopList_Btn_PageImage) do
		g_SeventhFestivalTopList_Btn_PageImage[i]:Hide()
		if i == g_SeventhFestivalTopList_CurPage then
			g_SeventhFestivalTopList_Btn_PageImage[i]:Show()
		end
	end
	
	--显示活动说明
	SeventhFestivalTopList_Explain_Text:SetText(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].desc)
	
	--显示送花相关信息
	SeventhFestivalTopList_Ranking_Present_Title:Hide() --SetText(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].sendtitle)
	local nSendNum =  DataPool:GetPlayerMission_DataRound(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].sendmd)
	local nNumStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strsendNum, nSendNum)
	SeventhFestivalTopList_Ranking_Present_Rose:SetText(nNumStr)
	
	--显示收花数量
	SeventhFestivalTopList_Ranking_Receive_Title:Hide() --SetText(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].receivetitle)
	local nReceiveNum =  DataPool:GetPlayerMission_DataRound(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].receivemd)
	local nReceiveNumStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strreceiveNum, nReceiveNum)
	SeventhFestivalTopList_Ranking_Receive_Rose:SetText(nReceiveNumStr)

	SeventhFestivalTopList_Ranking_Present_ListContent:Clear()
	
	local MyInfoS = 0
	local MyInfoR = 0
	--显示榜单
	local strDefName = SeventhFestivalTopList_Rank_DefaultName()
	for i=1, g_SeventhFestivalTopList_Count do
		local bar = SeventhFestivalTopList_Ranking_Present_ListContent:AddChild("SeventhFestivalTopList_Ranking_Present_List_CoinAItem")
		
		if i >= 4 then
			local strN = ScriptGlobal_Format("#{QXHB_20210701_97}", i)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NumText"):Show()
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NumText"):SetText(strN)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NumTop"):Hide()
		else
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NumText"):Hide()
			if g_SeventhFestivalTopList_RankImage[i] ~= nil then
				bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NumTop"):Show()
				bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NumTop"):SetProperty("Image", g_SeventhFestivalTopList_RankImage[i])
			end
		end
				
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NameText"):SetText(strDefName)
				
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_Num"):SetText("")	
			
		--更新数据
		local index,guid,name,score = DataPool:Lua_GetQixiSendTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			local strname = ScriptGlobal_Format("#{QXHB_20210701_98}", name)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NameText"):SetText(strname)
			local scoreStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strsend, tostring(score))
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_Num"):SetText(scoreStr)	
			
			if Player:GetGUID() == guid then
				MyInfoS = index + 1
			end
		end	

		g_Present_BarList[i] = bar
	end
		
	SeventhFestivalTopList_Ranking_Receive_ListContent:Clear()
	for i=1, g_SeventhFestivalTopList_Count do
		local bar = SeventhFestivalTopList_Ranking_Receive_ListContent:AddChild("SeventhFestivalTopList_Ranking_Receive_List_CoinAItem")
			
		if i >= 4 then
			local strN = ScriptGlobal_Format("#{QXHB_20210701_97}", i)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NumText"):Show()
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NumText"):SetText(strN)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NumTop"):Hide()
		else
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NumText"):Hide()
			if g_SeventhFestivalTopList_RankImage[i] ~= nil then
				bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NumTop"):Show()
				bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NumTop"):SetProperty("Image", g_SeventhFestivalTopList_RankImage[i])
			end
		end
			
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NameText"):SetText(strDefName)
			
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_Num"):SetText("")	
		
		--更新数据
		local index,guid,name,score = DataPool:Lua_GetQixiReceiveTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			local strname = ScriptGlobal_Format("#{QXHB_20210701_98}", name)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NameText"):SetText(strname)
			local scoreStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strreceive, tostring(score))
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_Num"):SetText(scoreStr)	
			
			if Player:GetGUID() == guid then
				MyInfoR = index + 1
			end
		end
		
		g_Receive_BarList[i] = bar
	end
	
	if MyInfoS > 0 then
		local str = ScriptGlobal_Format("#{QXHB_20210701_103}", MyInfoS)
		SeventhFestivalTopList_Ranking_Present_MeNum:Show()
		SeventhFestivalTopList_Ranking_Present_MeNum:SetText(str)
		SeventhFestivalTopList_Ranking_Present_Me:SetText("#{QXHB_20210701_102}")
	else
		SeventhFestivalTopList_Ranking_Present_MeNum:Hide()
		SeventhFestivalTopList_Ranking_Present_Me:SetText("#{QXHB_20210701_104}")
	end
	
	if MyInfoR > 0 then
		local str = ScriptGlobal_Format("#{QXHB_20210701_103}", MyInfoR)
		SeventhFestivalTopList_Ranking_Receive_MeNum:Show()
		SeventhFestivalTopList_Ranking_Receive_MeNum:SetText(str)
		SeventhFestivalTopList_Ranking_Receive_Me:SetText("#{QXHB_20210701_102}")
	else
		SeventhFestivalTopList_Ranking_Receive_MeNum:Hide()
		SeventhFestivalTopList_Ranking_Receive_Me:SetText("#{QXHB_20210701_104}")	
	end
	
end

--显示默认的名字
function SeventhFestivalTopList_Rank_DefaultName()
	local strMsg=""
	
	if g_SeventhFestivalTopList_State < 6 then 
		strMsg = "#{QXHB_20210701_99}"
	elseif g_SeventhFestivalTopList_State >= 6 then 
		strMsg = "#{QXHB_20210701_100}"	
	end
		
	return strMsg
end

--===============================================
-- 以下为事件响应
--===============================================
--点击关闭
function SeventhFestivalTopList_Close_Click()
	--关闭预览界面	
	if(IsWindowShow("SeventhFestivalTopListPreview")) then
		CloseWindow("SeventhFestivalTopListPreview", true)
	end
	--数据清空
	SeventhFestivalTopList_Clear()
	--界面隐藏
	this:Hide()
end

--点击页签
function SeventhFestivalTopList_Page_Click(index)
	--有效性判断
	if index <= 0 or index > g_SeventhFestivalTopList_MaxPage then
		PushDebugMessage("页签错误，请重新选择")
		return
	end
		
	if(IsWindowShow("SeventhFestivalTopListPreview")) then
		CloseWindow("SeventhFestivalTopListPreview", true)
	end
	
	local nPage = g_SeventhFestivalTopList_CurPage
	g_SeventhFestivalTopList_CurPage = index
	
	--页面内容更新
	if g_SeventhFestivalTopList_CurPage >= 1 and g_SeventhFestivalTopList_CurPage <= 3 then
		--刷新排行榜
		local flag = SeventhFestivalTopList_RankClick_Refresh()
		if flag == 0 and nPage >= 1 and nPage <= g_SeventhFestivalTopList_MaxPage then
			g_SeventhFestivalTopList_Btn_Page[nPage]:SetCheck(1)--切回原来页面
		end
	elseif g_SeventhFestivalTopList_CurPage == 4 then
		SeventhFestivalTopList_Exchange_Qingrenjie_Update()
	end
end

--点击刷新
function SeventhFestivalTopList_RankClick_Refresh()
	--有效性判断
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return 0
	end
	--判断冷却时间
	local nCooldown = g_SeventhFestivalTopList_Cooldown[g_SeventhFestivalTopList_CurPage]
	local iCur = FindFriendDataPool:GetTickCount()
	if ( iCur - nCooldown < g_SeventhFestivalTopList_CooldownDur) then
		PushDebugMessage("#{QXHB_20210701_163}")
	  return 0
	end
	g_SeventhFestivalTopList_Cooldown[g_SeventhFestivalTopList_CurPage] = iCur
	
	--请求服务器数据
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientAskQixiTopList" )
		Set_XSCRIPT_ScriptID( 891396 )--待修改脚本号：891396
		Set_XSCRIPT_Parameter(0,g_SeventhFestivalTopList_CurPage)
		Set_XSCRIPT_Parameter(1,1)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
	return 1
end

--点击送花榜领奖
function SeventhFestivalTopList_Prize_Present()

	--有效性判断
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return
	end	
	
	--判断领奖时间
	if g_SeventhFestivalTopList_State == 0 then--理论上不存在
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip1)
		return
	elseif g_SeventhFestivalTopList_State >= 1 and g_SeventhFestivalTopList_State <= 5 then--排行榜计时中
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip2)
		return
	elseif g_SeventhFestivalTopList_State == 6 then--可以领奖
	else--理论上不存在
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip3)
		return
	end
	
	--判断安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		return
	end
	
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
		return
	end
	
	--领奖
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientGetQixiSendTopListPrize" )
		Set_XSCRIPT_ScriptID( 891396 )--待修改脚本号：891396
		Set_XSCRIPT_Parameter(0,g_SeventhFestivalTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

--点击收花榜领奖
function SeventhFestivalTopList_Prize_Receive()

	--有效性判断
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return
	end	
	
	--判断领奖时间
	if g_SeventhFestivalTopList_State == 0 then--理论上不存在
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip1)
		return
	elseif g_SeventhFestivalTopList_State >= 1 and g_SeventhFestivalTopList_State <= 5 then--排行榜计时中
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip2)
		return
	elseif g_SeventhFestivalTopList_State == 6 then--可以领奖
	else--理论上不存在
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip3)
		return
	end
	
	--判断安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		return
	end
	
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
		return
	end
	
	--领奖
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientGetQixiReceiveTopListPrize" )
		Set_XSCRIPT_ScriptID( 891396 )--待修改脚本号：891396
		Set_XSCRIPT_Parameter(0,g_SeventhFestivalTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

--===============================================
-- 以下为基础函数
--===============================================
--状态清空
function SeventhFestivalTopList_Clear()
	--取消按钮的选中状态
 	--if g_SeventhFestivalTopList_CurPage >= 1 or g_SeventhFestivalTopList_CurPage <= 6 then
 		--g_RoseBtn_Page[g_SeventhFestivalTopList_CurPage]:SetCheck(0)
 	--end
 	--当前页码清空
	g_SeventhFestivalTopList_CurPage = 0
	--活动状态清空
	g_SeventhFestivalTopList_State = -1
end

--重置位置
function SeventhFestivalTopList_ResetPos()
	SeventhFestivalTopList_Frame:SetProperty("UnifiedPosition",g_SeventhFestivalTopList_UnifiedPosition)
end

--奖励兑换窗口
function SeventhFestivalTopList_Exchange_Click(nIndex)
	if g_SeventhFestivalTopList_CurPage == 4 then
		SeventhFestivalTopList_Exchange_Qingrenjie_Click(nIndex)
	end
end

--情人结兑换奖励窗口
function SeventhFestivalTopList_Exchange_Qingrenjie_Update()
	SeventhFestivalTopList_Ranking_Frame:Hide()
	SeventhFestivalTopList_Exchange_Frame:Show()
	
	for i = 1, table.getn(g_SeventhFestivalTopList_Btn_PageImage) do
		g_SeventhFestivalTopList_Btn_PageImage[i]:Hide()
		if i == 4 then
			g_SeventhFestivalTopList_Btn_PageImage[i]:Show()
		end
	end
	
	SeventhFestivalTopList_Explain_Text:SetText( "#{QXHB_20210701_165}" )
	
	local str = ScriptGlobal_Format("#{QXHB_20210701_178}", g_SeventhFestivalTopList_QRJ)
	SeventhFestivalTopList_TextNum:SetText(str)

	for i = 1, table.getn(g_SeventhFestivalTopList_Qingrenjie_Bonus) do
		local theAction = DataPool:CreateBindActionItemForShow(g_SeventhFestivalTopList_Qingrenjie_Bonus[i].itemid, g_SeventhFestivalTopList_Qingrenjie_Bonus[i].count)
		if theAction:GetID() ~= 0 then
			SeventhFestivalTopList_Exchange_Qingrenjie_Action[i]:SetActionItem(theAction:GetID())
		end
		
		local strText = ScriptGlobal_Format("#{QXHB_20210701_167}", g_SeventhFestivalTopList_Qingrenjie_Bonus[i].neednum)
		SeventhFestivalTopList_Exchange_Qingrenjie_Text[i]:SetText( strText )
		
		if g_SeventhFestivalTopList_Qingrenjie_Bonus[i].IsShowButton == 1 then
			SeventhFestivalTopList_Exchange_PreButton[i]:Show()
		else
			SeventhFestivalTopList_Exchange_PreButton[i]:Hide()
		end
		
		SeventhFestivalTopList_Exchange_Qingrenjie_Text2[i]:Hide()
		local nLimitNum = g_SeventhFestivalTopList_Qingrenjie_Bonus[i].LimitNum
		local nLimitMD = g_SeventhFestivalTopList_Qingrenjie_Bonus[i].LimitMD
		if nLimitMD > 0 and nLimitNum > 0 then
			SeventhFestivalTopList_Exchange_Qingrenjie_Text2[i]:Show()
			
			local nMyExchangeNum = math.floor(DataPool:GetPlayerMission_DataRound(nLimitMD)/100)
			local nLastNum = nLimitNum - nMyExchangeNum
			if nLastNum <= 0 then
				nLastNum = 0				
				local str = ScriptGlobal_Format("#{QRZM_211119_307}", nLastNum)
				SeventhFestivalTopList_Exchange_Qingrenjie_Text2[i]:SetText(str)
			else
				local str = ScriptGlobal_Format("#{QRZM_211119_305}", nLastNum)
				SeventhFestivalTopList_Exchange_Qingrenjie_Text2[i]:SetText(str)
			end
		end
	end
	
end

--情人结兑换奖励
function SeventhFestivalTopList_Exchange_Qingrenjie_Click(i)
	if i >= 3 and i <= 5 then
		local strName = DataPool:LuaFnGetItemNameByTableIndex(g_SeventhFestivalTopList_Qingrenjie_Bonus[i].itemid)
		local str = ScriptGlobal_Format("#{QXHB_20240802_01}", g_SeventhFestivalTopList_Qingrenjie_Bonus[i].neednum, strName)
		PushEvent("QIXIRANK_EXCHANGE_CONFIRM", 1, i, str)
	else
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
		Set_XSCRIPT_ScriptID( 891396 )
		Set_XSCRIPT_Parameter(0, i)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	end
end

--打开元宝商店——花舞人间——春城百花
function SeventhFestivalTopList_BuyRose()
	SeventhFestivalTopList_Shop_Goto(0, 6, 5)
end

function SeventhFestivalTopList_Shop_Goto(Fenye, Tag, Shop)
	if(IsWindowShow("YuanbaoShop")) then
		CloseWindow("YuanbaoShop", true)
	end
	PushEvent("TOGGLE_YUANBAOSHOP", Fenye, -1, -1, Tag, Shop)
end

--奖励预览
function SeventhFestivalTopList_RankClick_Award()
	PushEvent("OPEN_QIXITOPLIST_ZHANSHI", 1, g_SeventhFestivalTopList_CurPage)
end

--说明
function SeventhFestivalTopList_HelpClicked()

	PushEvent("OPEN_SWEEPPAGE_QUEST", "TopList_ExplainHelp", g_SeventhFestivalTopList_CurPage) 
	
end

function SeventhFestivalTopList_DuiHuan()

	if 1 == 1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "SeventhFestivalOpenDuiHuan" )
		Set_XSCRIPT_ScriptID( 891396 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
	
end

function SeventhFestivalTopList_Exchange_ItemPreview( Idx )

	if Idx == 1 then
		PushEvent("OPEN_DRESSPREVIEW", 10125769, 97, 68) --时装\发型\脸型
	end
	
	if Idx == 2 then
		Pet:OpenPetJianByZhenShouDanId(30310140);
	end
	
end
