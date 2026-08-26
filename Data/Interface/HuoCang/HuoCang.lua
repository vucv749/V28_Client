local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_HuoCangScene =
{
	[0]={sceneid=0,	name="洛阳",		posx =149, posz =145,			type = 0, npcname = "程苍柏",},
	[1]={sceneid=3,	name="嵩山",		posx =167, posz =221,			type = 0, npcname = "康家实",},
	[2]={sceneid=4,	name="太湖",		posx =180, posz =116.8,		type = 0, npcname = "赵大光",},
	[3]={sceneid=1,	name="苏州",		posx =177, posz =150,			type = 0, npcname = "谢云亭",},
	[4]={sceneid=5,	name="镜湖",		posx =127.7, posz =150.6,	type = 0, npcname = "罗矜贵",},
	[5]={sceneid=6,	name="无量山",	posx =133.3, posz =119.5,	type = 0, npcname = "方则泰",},
	[6]={sceneid=2, name="大理",		posx =189, posz =135,			type = 0, npcname = "杨辰予",},
	[7]={sceneid=7,	name="剑阁",		posx =137, posz =136.2,		type = 0, npcname = "白五七",},
	[8]={sceneid=8,	name="敦煌",		posx =74.3, posz =82.7,		type = 0, npcname = "司徒岳",},
}

local g_HuoCangItem ={}
local g_HuoCangItemName ={}
local g_HuoCangItemPirce ={}
local g_HuoCangBtn={}

local nWeapon={};
local nWeaponPrice={};
local nMyItem = {}
local nMyItemNum = {}
local nMyItemPic = {}
local nMyItemPrice = {}

local Button_BuyItemPrice={}
local Button_SellItemPrice={}
local Button_BuyItemPic={}
local Button_SellItemPic={}
local Button_BuyItemText={}
local Button_SellItemText={}
local Button_SceneItemLvl={}
local Button_ItemNullText={}
local Button_BigItem={}

local Data_BuyPirce={}
local Data_SellPirce={}
local Data_SceneItemLvl={}

local g_HuoCang_Zijin = 0 -- 玩家资金
local g_HuoCang_ItemNum = 1 -- 物品数量
local g_HuoCang_Item1 = 2 -- 物品1
local g_HuoCang_Item1_Price = 3
local g_HuoCang_Item2 = 4 -- 物品2
local g_HuoCang_Item2_Price = 5
local g_HuoCang_Item3 = 6 -- 物品3
local g_HuoCang_Item3_Price = 7

local g_HuoCangIndex_Item =
{
	[1] = g_HuoCang_Item1,
	[2] = g_HuoCang_Item2,
	[3] = g_HuoCang_Item3,
	[4] = g_HuoCang_Item4
};

local g_HuoCangIndex_ItemNum = g_HuoCang_ItemNum

local g_HuoCangIndex_ItemPrice =
{
	[1] = g_HuoCang_Item1_Price,
	[2] = g_HuoCang_Item2_Price,
	[3] = g_HuoCang_Item3_Price,
	[4] = g_HuoCang_Item4_Price,
};
--local g_HuoCangNameText ={}

local		g_NPCID = 0
local		g_CurSecneID = 0
local		g_AskSceneID = 0
local		g_NormalPriceType = 0
local		g_SpecialLeft = 0
local   g_CurMissionId = 2115


function HuoCang_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("CLOSE_PAOSHANGWINDOWS",true)

	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("SYN_PAOSHANG_LEFTTIME",false)
end

function HuoCang_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= HuoCang_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= HuoCang_Frame:GetProperty("UnifiedYPosition");

	-- g_HuoCangNameText[0] = HuoCang_Luoyang_List
	-- g_HuoCangNameText[1] = HuoCang_Songshan_List
	-- g_HuoCangNameText[2] = HuoCang_Suzhou_List
	-- g_HuoCangNameText[3] = HuoCang_Xihu_List
	-- g_HuoCangNameText[4] = HuoCang_Taihu_List
	-- g_HuoCangNameText[5] = HuoCang_Wulianshan_List
	-- g_HuoCangNameText[6] = HuoCang_Dali_List
	-- g_HuoCangNameText[7] = HuoCang_Wanjiegu_List
	-- g_HuoCangNameText[8] = HuoCang_Dunhuang_List		

	g_HuoCangBtn[0] = HuoCang_Luoyang_Btn
	g_HuoCangBtn[1] = HuoCang_Songshan_Btn
	g_HuoCangBtn[2] = HuoCang_Taihu_Btn
	g_HuoCangBtn[3] = HuoCang_Suzhou_Btn
	g_HuoCangBtn[4] = HuoCang_Jinghu_Btn
	g_HuoCangBtn[5] = HuoCang_Wulianshan_Btn
	g_HuoCangBtn[6] = HuoCang_Dali_Btn
	g_HuoCangBtn[7] = HuoCang_Jiange_Btn
	g_HuoCangBtn[8] = HuoCang_Dunhuang_Btn

	
	g_HuoCangItem[1] = HuoCang_Goumai_But
	g_HuoCangItem[2] = HuoCang_Goumai_But1
	g_HuoCangItem[3] = HuoCang_Goumai_But2 

	g_HuoCangItemName[1] = HuoCang_Text1
	g_HuoCangItemName[2] = HuoCang_Text2
	g_HuoCangItemName[3] = HuoCang_Text3
	
	Button_BuyItemPrice[1]	= HuoCang_Mairu_shuliang
	Button_BuyItemPrice[2]	= HuoCang_Mairu_shuliang1
	Button_BuyItemPrice[3]	= HuoCang_Mairu_shuliang2	
	
	Button_SellItemPrice[1]	= HuoCang_Maichu_shuliang
	Button_SellItemPrice[2]	= HuoCang_Maichu_shuliang1
	Button_SellItemPrice[3]	= HuoCang_Maichu_shuliang2
	
	Button_BuyItemPic[1]	= HuoCang_Mairu_jinbi
	Button_BuyItemPic[2]	= HuoCang_Mairu_jinbi1
	Button_BuyItemPic[3]	= HuoCang_Mairu_jinbi2		

	Button_SellItemPic[1]	= HuoCang_Maichu_jinbi
	Button_SellItemPic[2]	= HuoCang_Maichu_jinbi1
	Button_SellItemPic[3]	= HuoCang_Maichu_jinbi2			
	
	Button_BuyItemText[1] = HuoCang_Mairu_Text_1
	Button_BuyItemText[2] = HuoCang_Mairu_Text2_1
	Button_BuyItemText[3] = HuoCang_Mairu_Text3_1
	
	Button_SellItemText[1]	= HuoCang_Maichu_Text_1
	Button_SellItemText[2]	= HuoCang_Maichu_Text2_1
	Button_SellItemText[3]	= HuoCang_Maichu_Text3_1	
		
	Button_ItemNullText[1]	= HuoCang_Text1_1
	Button_ItemNullText[2]	= HuoCang_Text2_1
	Button_ItemNullText[3]	= HuoCang_Text3_1	
							
	HuoCang_Shuliang_Text1:Hide()
	HuoCang_Shuliang_Text2:Hide()
	HuoCang_Shuliang_Text3:Hide()
	
	Button_BigItem[1] = HuoCang_Goumai_BK
	Button_BigItem[2] = HuoCang_Goumai_BK1
	Button_BigItem[3] = HuoCang_Goumai_BK2

end

function HuoCang_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		HuoCang_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		HuoCang_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 8927601) then

		g_NPCID = Get_XParam_INT(0)
		g_CurSecneID = Get_XParam_INT(1)
		g_AskSceneID = Get_XParam_INT(2)
		g_NormalPriceType = Get_XParam_INT(3)
		g_LeftTime	= Get_XParam_INT(4)
		Data_BuyPirce[1] = Get_XParam_INT(5)
		Data_BuyPirce[2] = Get_XParam_INT(6)
		Data_BuyPirce[3] = Get_XParam_INT(7)
		Data_SellPirce[1] = Get_XParam_INT(8)
		Data_SellPirce[2] = Get_XParam_INT(9)
		Data_SellPirce[3] = Get_XParam_INT(10)
		if g_LeftTime > 0 then
--			HuoCang_Huocang_Text9:Show()
--			HuoCang_Huocang_Text9:SetText("#{PSGN_180515_104}")
			HuoCang_StopWatch_1:Show()
			HuoCang_StopWatch_1:SetProperty("Timer", tostring(g_LeftTime));
			HuoCang_StopWatch_2:Hide()
		else
--			HuoCang_Huocang_Text9:SetText("#{PSGN_180515_152}")
			HuoCang_StopWatchTimeOut()
		end
		
		local isHaveMission = DataPool:Lua_IsHaveMission(g_CurMissionId)
				
		HuoCang_Goumai_Text1:SetText( ScriptGlobal_Format( "#{PSGN_180515_154}", g_HuoCangScene[g_AskSceneID].name))
		
		nWeapon[1],nWeapon[2],nWeapon[3] = DataPool:GetPaoShangData(g_AskSceneID,1);			
		nWeaponPrice[1],nWeaponPrice[2],nWeaponPrice[3],Data_SceneItemLvl[1],Data_SceneItemLvl[2],Data_SceneItemLvl[3] = DataPool:GetPaoShangData(g_AskSceneID,2,g_NormalPriceType);		

		--右侧物品
		if isHaveMission > 0 then
			local misIndex = DataPool:GetPlayerMissionIndexByID(g_CurMissionId)
			local nTmpMyItemNum = DataPool:GetPlayerMission_Variable(misIndex, g_HuoCangIndex_ItemNum)
			nMyItemNum[1] = math.mod(nTmpMyItemNum,1000)
			nTmpMyItemNum = math.floor(nTmpMyItemNum/1000)
			nMyItemNum[2] = math.mod(nTmpMyItemNum,1000)
			nMyItemNum[3] = math.floor(nTmpMyItemNum/1000)
			for i=1,3 do
				nMyItem[i] = DataPool:GetPlayerMission_Variable(misIndex, g_HuoCangIndex_Item[i])
				if nMyItem[i] == -1 then
					nWeapon[3+i] = 0 
				else
					nWeapon[3+i] = nMyItem[i]
				end
			end			
		else
			for i=1,3 do
				nMyItem[i] = 0
				nMyItemNum[i] = 0
				nWeapon[3+i] = 0 
			end
		end

		--下面三个物品
		for i = 4,6 do
			local ii=i-3
			local theAction = DataPool:CreateActionItemForShow(nWeapon[i], nMyItemNum[ii])
			if theAction:GetID() ~= 0 then
				g_HuoCangItem[ii]:SetActionItem(theAction:GetID());
				local szItemName = PlayerPackage:GetItemName( nWeapon[i] )
				g_HuoCangItemName[ii]:SetText(theAction:GetName())
				Button_BuyItemPrice[ii]:SetText(Data_BuyPirce[ii])
				if Data_SellPirce[ii] <= 0 then
					Button_SellItemPrice[ii]:SetText("-")
				else
					Button_SellItemPrice[ii]:SetText(Data_SellPirce[ii])
				end
				Button_BuyItemPic[ii]:Show()
				Button_SellItemPic[ii]:Show()			
				Button_BuyItemText[ii]:Show()
				Button_SellItemText[ii]:Show()				
				Button_ItemNullText[ii]:Hide()		
			else
				g_HuoCangItem[ii]:SetActionItem(-1);
				g_HuoCangItemName[ii]:SetText("")				
				Button_BuyItemPrice[ii]:SetText("")
				Button_SellItemPrice[ii]:SetText("")
				Button_BuyItemPic[ii]:Hide()
				Button_SellItemPic[ii]:Hide()
				Button_BuyItemText[ii]:Hide()
				Button_SellItemText[ii]:Hide()
				Button_ItemNullText[ii]:Show()		
			end
		end	

		local paramvalue = 0
		if isHaveMission > 0 then		
			local misIndex = DataPool:GetPlayerMissionIndexByID(g_CurMissionId)
			paramvalue = DataPool:GetPlayerMission_Variable(misIndex, g_HuoCang_Zijin)
		end

		HuoCang_Money1_Need:SetText(paramvalue)

--		PushEvent("UI_COMMAND", 201903282, 3 )
--		PushEvent("CHANGEUI_PAOSHANG", 1)
		this:Show()
		HuoCang_ResetPos()
	elseif( event == "CLOSE_PAOSHANGWINDOWS" ) then	
			HuoCang_OnForceClose();
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 201903282) then	
		local nType = tonumber(arg1)
		if( this:IsVisible() ) and nType == 1 then		
			HuoCang_OnClose();
		end	
	elseif( event == "SYN_PAOSHANG_LEFTTIME" ) then
		g_LeftTime	= tonumber(arg0)
		if g_LeftTime > 0 then
--			HuoCang_Huocang_Text9:Show()
--			HuoCang_Huocang_Text9:SetText("#{PSGN_180515_104}")
			HuoCang_StopWatch_1:Show()
			HuoCang_StopWatch_1:SetProperty("Timer", tostring(g_LeftTime));
			HuoCang_StopWatch_2:Hide()
		else
--			HuoCang_Huocang_Text9:SetText("#{PSGN_180515_152}")
			HuoCang_StopWatchTimeOut()
		end	
	elseif( event == "SCENE_TRANSED" ) then		
		HuoCang_OnClose()
	end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function HuoCang_ResetPos()
	HuoCang_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	HuoCang_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function HuoCang_CityClick(nCityID)
	for i=0,8 do
		g_HuoCangBtn[i]:SetCheck(0)
	end
	g_HuoCangBtn[nCityID]:SetCheck(1)
	g_AskSceneID = nCityID
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenPaoShangScene" )
		Set_XSCRIPT_ScriptID(892760)
		Set_XSCRIPT_Parameter(0,nCityID)
		Set_XSCRIPT_Parameter(1,2)		
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
			
end

function HuoCang_OnForceClose()
	for i=0,8 do
		g_HuoCangBtn[i]:SetCheck(0)
	end
	g_HuoCangBtn[0]:SetCheck(1)
	this:Hide()
end
function HuoCang_OnClose()
	for i=0,8 do
		g_HuoCangBtn[i]:SetCheck(0)
	end
	g_HuoCangBtn[0]:SetCheck(1)
	HuoCang_HideBig()
	this:Hide()
end

function HuoCang_Buy()

	local tAutoRunInfo = g_HuoCangScene[g_AskSceneID]
	AutoRuntoTargetExWithName(tAutoRunInfo.posx, tAutoRunInfo.posz, tAutoRunInfo.sceneid, tAutoRunInfo.npcname)

end

function HuoCang_HideBig()
--	PushEvent("UI_COMMAND", 201903282, 2 )
	PushEvent("CHANGEUI_PAOSHANG", 1)
	this:Hide()
end


function HuoCang_StopWatchTimeOut()
	HuoCang_StopWatch_1:Hide()
--	HuoCang_Huocang_Text9:SetText("#{PSGN_180515_152}")
	HuoCang_StopWatch_2:Show()
end

function HuoCang_Click(nIndex)
	if nWeapon[nIndex+3] <= 0 then
		Button_BigItem[nIndex]:SetCheck(0)
	end	
end

function HuoCang_Help_Click()
	local tipStr = "#{PSGN_180515_153}"
--	Lua_ShowHelpTips(tipStr,"HuoCang","HuoCang_Help_Click")
	PushEvent("QUEST_HELPINFO","#{PSGN_180515_153}")
end

function HuoCang_HideDetail()
	HuoCang_OnClose()
end
