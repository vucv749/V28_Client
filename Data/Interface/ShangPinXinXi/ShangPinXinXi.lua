local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
--0洛阳，3嵩山，4太湖，1苏州，5镜湖，6无量山，2大理，7剑阁，8敦煌
local g_PaoShangScene =
{
	[0]={sceneid=0,name="洛阳"},
	[1]={sceneid=3,name="嵩山"},
	[2]={sceneid=4,name="太湖"},
	[3]={sceneid=1,name="苏州"},
	[4]={sceneid=5,name="镜湖"},
	[5]={sceneid=6,name="无量山"},
	[6]={sceneid=2,name="大理"},
	[7]={sceneid=7,name="剑阁"},
	[8]={sceneid=8,name="敦煌"},
}


local g_PaoShangItem ={}
local g_PaoShangItemName ={}
local g_PaoShangItemPirce ={}
local g_PaoShangBtn={}

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

local Data_BuyPirce={}
local Data_SellPirce={}
local Data_SceneItemLvl={}

local g_PaoShang_Zijin = 0 -- 玩家资金
local g_PaoShang_ItemNum = 1 -- 物品1数量
local g_PaoShang_Item1 = 2 -- 物品1
local g_PaoShang_Item1_Price = 3
local g_PaoShang_Item2 = 4 -- 物品2
local g_PaoShang_Item2_Price = 4
local g_PaoShang_Item3 = 6 -- 物品3

local g_PaoShang_Item3_Price = 7
local g_PaoShang_Item4 = 11-- 物品4

local g_PaoShangIndex_Item =
{
	[1] = g_PaoShang_Item1,
	[2] = g_PaoShang_Item2,
	[3] = g_PaoShang_Item3,
};

local g_PaoShangIndex_ItemNum = g_PaoShang_ItemNum

local g_PaoShangIndex_ItemPrice =
{
	[1] = g_PaoShang_Item1_Price,
	[2] = g_PaoShang_Item2_Price,
	[3] = g_PaoShang_Item3_Price,
};
--local g_PaoShangNameText ={}

local		g_NPCID = 0
local		g_CurSecneID = 0
local		g_AskSceneID = 0
local		g_NormalPriceType = 0
local		g_SpecialLeft = 0
local   g_CurMissionId = 2115

local objCared = -1;

function ShangPinXinXi_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("CLOSE_PAOSHANGWINDOWS",false)

	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("OBJECT_CARED_EVENT")	
	
end

function ShangPinXinXi_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= ShangPinXinXi_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= ShangPinXinXi_Frame:GetProperty("UnifiedYPosition");
	
	g_PaoShangItem[1] = ShangPinXinXi_Goumai_But
	g_PaoShangItem[2] = ShangPinXinXi_Goumai_But1
	g_PaoShangItem[3] = ShangPinXinXi_Goumai_But2	

	g_PaoShangItemName[1] = ShangPinXinXi_Goumai_Text
	g_PaoShangItemName[2] = ShangPinXinXi_Goumai_Text2
	g_PaoShangItemName[3] = ShangPinXinXi_Goumai_Text3

	g_PaoShangBtn[0] = ShangPinXinXi_Luoyang_Btn
	g_PaoShangBtn[1] = ShangPinXinXi_Songshan_Btn
	g_PaoShangBtn[2] = ShangPinXinXi_Taihu_Btn
	g_PaoShangBtn[3] = ShangPinXinXi_Suzhou_Btn
	g_PaoShangBtn[4] = ShangPinXinXi_Jinghu_Btn
	g_PaoShangBtn[5] = ShangPinXinXi_Wulianshan_Btn
	g_PaoShangBtn[6] = ShangPinXinXi_Dali_Btn
	g_PaoShangBtn[7] = ShangPinXinXi_Jiange_Btn
	g_PaoShangBtn[8] = ShangPinXinXi_Dunhuang_Btn
	
	nMyItemPic[1]	= ShangPinXinXi_Goumai_jinbi
	nMyItemPic[2]	= ShangPinXinXi_Goumai_jinbi1
	nMyItemPic[3]	= ShangPinXinXi_Goumai_jinbi2

	nMyItemPrice[1]	= ShangPinXinXi_Goumai_shuliang
	nMyItemPrice[2]	= ShangPinXinXi_Goumai_shuliang1
	nMyItemPrice[3]	= ShangPinXinXi_Goumai_shuliang2	
	
	Button_SceneItemLvl[1]	= ShangPinXinXi_Goumai_Tuijian
	Button_SceneItemLvl[2]	= ShangPinXinXi_Goumai_Tuijian1
	Button_SceneItemLvl[3]	= ShangPinXinXi_Goumai_Tuijian2
	
end

function ShangPinXinXi_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		ShangPinXinXi_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		ShangPinXinXi_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 8927600) then
		if(IsWindowShow("PaoShang")) then
			CloseWindow("PaoShang", true);
		end

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
		
		local isHaveMission = DataPool:Lua_IsHaveMission(g_CurMissionId)
					
		ShangPinXinXi_Goumai_Text1:SetText( ScriptGlobal_Format( "#{PSGN_180327_15}", g_PaoShangScene[g_AskSceneID].name))	
		for i=0,8 do
			g_PaoShangBtn[i]:SetCheck(0)
		end
		g_PaoShangBtn[g_AskSceneID]:SetCheck(1)

		nWeapon[1],nWeapon[2],nWeapon[3] = DataPool:GetPaoShangData(g_AskSceneID,1);			
		nWeaponPrice[1],nWeaponPrice[2],nWeaponPrice[3],Data_SceneItemLvl[1],Data_SceneItemLvl[2],Data_SceneItemLvl[3] = DataPool:GetPaoShangData(g_AskSceneID,2,g_NormalPriceType);		

		local misIndex = DataPool:GetPlayerMissionIndexByID(g_CurMissionId)
		local nMyItemNumList = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShangIndex_ItemNum)
		
		nMyItemNum[1] = math.mod(nMyItemNumList,1000)
		nMyItemNumList = math.floor(nMyItemNumList/1000)
		nMyItemNum[2] = math.mod(nMyItemNumList,1000)
		nMyItemNum[3] = math.floor(nMyItemNumList/1000)

		--右侧物品
		if isHaveMission > 0 then
			
			for i=1,3 do
				nMyItem[i] = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShangIndex_Item[i])
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
				Data_SceneItemLvl[3+i] = 0
			end
		end

		--上面三个物品		
		for i = 1,3 do
			local theAction =DataPool:CreateActionItemForShow(nWeapon[i], 1)
			if theAction:GetID() ~= 0 then
				g_PaoShangItem[i]:SetActionItem(theAction:GetID());
				local szItemName = PlayerPackage:GetItemName( nWeapon[i] )
				nMyItemPic[i]:Show()
				nMyItemPrice[i]:SetText(nWeaponPrice[i])
				g_PaoShangItemName[i]:SetText(szItemName)
				if Data_SceneItemLvl[i] == 3 then
					Button_SceneItemLvl[i]:Show()
				else
					Button_SceneItemLvl[i]:Hide()
				end
			else
				g_PaoShangItem[i]:SetActionItem(-1);
				g_PaoShangItemName[i]:SetText("")				
				nMyItemPic[i]:Hide()
				nMyItemPrice[i]:Hide()
				Button_SceneItemLvl[i]:SetProperty("Image","");
			end
		end	
		local paramvalue = 0
		if isHaveMission > 0 then		
			local misIndex = DataPool:GetPlayerMissionIndexByID(g_CurMissionId)
			paramvalue = DataPool:GetPlayerMission_Variable(misIndex, g_PaoShang_Zijin)
		end

		this:CareObject(objCared, 1, "ShangPinXinXi");		
		this:Show()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 8927606) then

		local nType = Get_XParam_INT(0)

		if nType == 0 then
			if( this:IsVisible() ) then
				ShangPinXinXi_OnClose();
			end
		elseif nType == 1 then
			local xx = Get_XParam_INT(1)
			objCared = DataPool:GetNPCIDByServerID(xx)
		end	

	elseif( event == "CLOSE_PAOSHANGWINDOWS" ) then	
		ShangPinXinXi_OnClose();	
	elseif( event == "SCENE_TRANSED" ) then		
		ShangPinXinXi_OnClose()
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			ShangPinXinXi_OnClose()
		end			
	end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function ShangPinXinXi_ResetPos()
	ShangPinXinXi_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	ShangPinXinXi_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function ShangPinXinXi_CityClick(nCityID)
	for i=0,8 do
		g_PaoShangBtn[i]:SetCheck(0)
	end
	g_PaoShangBtn[nCityID]:SetCheck(1)

	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenPaoShangScene" )
		Set_XSCRIPT_ScriptID(892760)
		Set_XSCRIPT_Parameter(0,nCityID)
		Set_XSCRIPT_Parameter(1,0)		
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
			
end

function ShangPinXinXi_OnClose()
	this:CareObject(objCared, 0, "ShangPinXinXi");
	this:Hide()
end
