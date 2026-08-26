local g_TopChongZhi_Frame_UnifiedYPosition;
local g_TopChongZhi_Frame_UnifiedYPosition;  
 --===============================================
-- 充值超值赠
--===============================================
local g_TopChongZhi_LoadFirstTime = 1 

local g_TopChongZhi_ButtonState = {
	[1] =0,
	[2] =0,
	[3] =0,
	[4] =0,
	[5] =0,
	[6] =0,
	[7] =0, 
	[8] =0, 
};
--显示奖励物品配表
local g_TopChongZhi_Gifts = {
	[1] ={
			{GiftItemID = 50513004, num = 1,},{GiftItemID = 20501003, num = 5,},{GiftItemID = 20502003, num = 5,},{GiftItemID = 30505900 , num = 1,}
		,},
	[2] ={
			{GiftItemID = 50513004, num = 1,},{GiftItemID = 20501003, num = 5,},{GiftItemID = 20502003, num = 5,},{GiftItemID = 30505705, num = 1,}
		,},
	[3] ={
			{GiftItemID = 50513004, num = 1,},{GiftItemID = 20501004, num = 5,},{GiftItemID = 20502004, num = 5,},{GiftItemID = 30120003, num = 1,}
		,},
	[4] ={
			{GiftItemID = 30900057, num = 2,},{GiftItemID = 20501004, num = 5,},{GiftItemID = 20502004, num = 5,},{GiftItemID = 30120003, num = 1,}
		,},
	[5] ={
			{GiftItemID = 30900057, num = 2,},{GiftItemID = 20501004, num = 10,},{GiftItemID = 20502004, num = 10,},{GiftItemID = 38003055, num = 5,}
		,},
	[6] ={
			{GiftItemID = 30900057, num = 3,},{GiftItemID = 38002397, num = 100,},{GiftItemID = 38002499, num = 50,},{GiftItemID = 30900213, num = 1,}
		,},
	[7] ={
			{GiftItemID = 10125727, num = 1,},{GiftItemID = 38002397, num = 100,},{GiftItemID = 38002499, num = 50,},{GiftItemID = 38003055, num = 5,}
		,}, 
	[8] ={
			{GiftItemID = 10142399, num = 1,},{GiftItemID = 38003160, num = 1,},{GiftItemID = 10415055, num = 1,},{GiftItemID = 39920110, num = 1,}
		,}, 
} 
local g_TopChongZhi_ICON = { 
}
local g_TopChongZhi_Text = { 
}
local g_TopChongZhi_Btn = { 
}
local g_TopChongZhi_GetGiftsCondition =
{
	[1] = { Exch = 200000, Cost = 200000, },
	[2] = { Exch = 400000, Cost = 400000, },
	[3] = { Exch = 600000, Cost = 600000, },
	[4] = { Exch = 800000, Cost = 800000, },
	[5] = { Exch = 1000000, Cost = 1000000, },
	[6] = { Exch = 1200000, Cost = 1200000, },
	[7] = { Exch = 1600000, Cost = 1600000, }, 
	[8] = { Exch = 2000000, Cost = 2000000, }, 
}
local g_TopChongZhi_Cost =0;
local g_TopChongZhi_Exch =0; 
local g_Object =0; 
local g_TopChongZhiObjId =0; 
local MAX_OBJ_DISTANCE = 3.0

local g_TopChongIsOpenFanChang =0; 
-- 
local g_Fuli_LimitedSaveUp_GiftsImage = {
	[1] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_1", },
	[2] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_2", },
	[3] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_3", },
	[4] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_4", },
	[5] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_5", },
	[6] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_6", },
	[7] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_7", }, 
	[8] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_7", }, 
}

function TopChongZhi_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
end

function TopChongZhi_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		TopChongZhi_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		TopChongZhi_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()	
	elseif (event == "OBJECT_CARED_EVENT") then 
		if(tonumber(arg0) ~= g_TopChongZhi_obj) then
			return;
		end 
		--如果和商人的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			SetDefaultMouse();  
			TopChongZhi_Close();
		end  
	elseif event == "PLAYER_LEAVE_WORLD" then
		TopChongZhi_Close()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 18100001 ) then		 
		TopChongZhi_UpdateInfo() 
		if ( IsWindowShow( "TopChongZhi" ) == false ) then
			TopChongZhi_OnShown() 
		end 
	end
end

function TopChongZhi_OnLoad()  
	-- 保存界面的默认相对位置
	g_TopChongZhi_Frame_UnifiedXPosition	= TopChongZhi_Frame:GetProperty("UnifiedXPosition");
	g_TopChongZhi_Frame_UnifiedYPosition	= TopChongZhi_Frame:GetProperty("UnifiedYPosition"); 
end 

function TopChongZhi_OnShown() 
	this:Show();
end 
--================================================
-- 界面的默认相对位置
--================================================
function TopChongZhi_ResetPos()
	TopChongZhi_Frame:SetProperty("UnifiedXPosition", g_TopChongZhiFrame_UnifiedXPosition);
	TopChongZhi_Frame:SetProperty("UnifiedYPosition", g_TopChongZhi_Frame_UnifiedYPosition);
	g_TopChongZhi_ICON[1] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk1_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk1_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk1_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk1_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk1_Icon5,
	};
	g_TopChongZhi_ICON[2] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk2_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk2_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk2_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk2_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk2_Icon5,
	};
	g_TopChongZhi_ICON[3] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk3_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk3_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk3_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk3_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk3_Icon5,
	};
	g_TopChongZhi_ICON[4] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk4_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk4_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk4_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk4_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk4_Icon5,
	};
	g_TopChongZhi_ICON[5] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk5_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk5_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk5_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk5_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk5_Icon5,
	};
	g_TopChongZhi_ICON[6] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk6_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk6_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk6_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk6_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk6_Icon5,
	};
	g_TopChongZhi_ICON[7] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk7_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk7_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk7_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk7_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk7_Icon5,
	};	
	g_TopChongZhi_ICON[8] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk8_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk8_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk8_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk8_Icon4,
		TopChongZhi_BaiBao_Frame3_Bk8_Icon5,
	};
	g_TopChongZhi_Text[1] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk1_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk1_Text1_2,
	};
	g_TopChongZhi_Text[2] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk2_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk2_Text1_2,
	};
	g_TopChongZhi_Text[3] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk3_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk3_Text1_2,
	};
	g_TopChongZhi_Text[4] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk4_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk4_Text1_2,
	};
	g_TopChongZhi_Text[5] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk5_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk5_Text1_2,
	};
	g_TopChongZhi_Text[6] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk6_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk6_Text1_2,
	};
	g_TopChongZhi_Text[7] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk7_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk7_Text1_2,
	};
	g_TopChongZhi_Text[8] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk8_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk8_Text1_2,
	};
	g_TopChongZhi_Btn ={
		TopChongZhi_BaiBao_Frame3_Bk1_Button1,
		TopChongZhi_BaiBao_Frame3_Bk2_Button1,
		TopChongZhi_BaiBao_Frame3_Bk3_Button1,
		TopChongZhi_BaiBao_Frame3_Bk4_Button1,
		TopChongZhi_BaiBao_Frame3_Bk5_Button1,
		TopChongZhi_BaiBao_Frame3_Bk6_Button1,
		TopChongZhi_BaiBao_Frame3_Bk7_Button1,
		TopChongZhi_BaiBao_Frame3_Bk8_Button1,
	}
end 

function TopChongZhi_Close()
	StopCareObject_YuanbaoExchange()
	this:Hide();
end
 
function TopChongZhi_UpdateInfo()
	g_TopChongZhiObjId		 = Get_XParam_INT(0)
	g_TopChongZhi_Exch  	 = Get_XParam_INT(1)
	g_TopChongZhi_Cost  	 = Get_XParam_INT(2)
	g_TopChongIsOpenFanChang = Get_XParam_INT(3)
	for i=1,table.getn(g_TopChongZhi_ButtonState) do
		g_TopChongZhi_ButtonState[i] = Get_XParam_INT(i+3)
	end
	TopChongZhi_BeginCareObject(Target:GetServerId2ClientId(g_TopChongZhiObjId))
	TopChongZhi_FlushWindow()
end

function TopChongZhi_BeginCareObject(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "TopChongZhi")
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_YuanbaoExchange()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "TopChongZhi")
		g_Object = -1
	end
end

function TopChongZhi_FlushWindow() 
	TopChongZhi_CleanActionItemInfo()  
	for i = 1,  table.getn(g_TopChongZhi_Gifts) do  
		for j = 1,  table.getn(g_TopChongZhi_Gifts[i]) do 
			local GiftItemID	=	g_TopChongZhi_Gifts[i][j].GiftItemID
			local GiftItemNum	= 	g_TopChongZhi_Gifts[i][j].num
			if GiftItemID == 38002868 and g_TopChongIsOpenFanChang == 0 then
				continue
			end
			local theAction 	= 	DataPool:CreateBindActionItemForShow(GiftItemID, GiftItemNum)
			if theAction:GetID() ~= 0 then
				g_TopChongZhi_ICON[i][j]:SetActionItem(theAction:GetID())
				g_TopChongZhi_ICON[i][j]:Show()
			end
		end
 
		--未达成
		if g_TopChongZhi_ButtonState[i] == 0 then 
			if g_TopChongZhi_Exch < g_TopChongZhi_GetGiftsCondition[i].Exch then
				local Text1 = ScriptGlobal_Format("#{XSJNH_180111_71}", g_TopChongZhi_Exch,g_TopChongZhi_GetGiftsCondition[i].Exch)
				g_TopChongZhi_Text[i].Exch:SetText(Text1)
			else
				local Text1 = ScriptGlobal_Format("#{XSJNH_180111_73}", g_TopChongZhi_GetGiftsCondition[i].Exch,g_TopChongZhi_GetGiftsCondition[i].Exch)
				g_TopChongZhi_Text[i].Exch:SetText(Text1)
			end
			if g_TopChongZhi_Cost < g_TopChongZhi_GetGiftsCondition[i].Cost then
				local Text2 = ScriptGlobal_Format("#{XSJNH_180111_72}", g_TopChongZhi_Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
				g_TopChongZhi_Text[i].Cost:SetText(Text2)
			else
				local Text2 = ScriptGlobal_Format("#{XSJNH_180111_74}", g_TopChongZhi_GetGiftsCondition[i].Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
				g_TopChongZhi_Text[i].Cost:SetText(Text2)
			end 
			g_TopChongZhi_Btn[i]:SetProperty("DisabledImage", "set:XinShouNewBK image:XinShouNew_WDC") 
			g_TopChongZhi_Btn[i]:Disable()
		--可以领取
		elseif g_TopChongZhi_ButtonState[i] == 1 then 
			local Text1 = ScriptGlobal_Format("#{XSJNH_180111_73}", g_TopChongZhi_GetGiftsCondition[i].Exch,g_TopChongZhi_GetGiftsCondition[i].Exch)
			g_TopChongZhi_Text[i].Exch:SetText(Text1)
			local Text2 = ScriptGlobal_Format("#{XSJNH_180111_74}", g_TopChongZhi_GetGiftsCondition[i].Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
			g_TopChongZhi_Text[i].Cost:SetText(Text2) 
			g_TopChongZhi_Btn[i]:Enable() 
			--g_TopChongZhi_Btn[i]:SetProperty("NormalImage", "set:ServerNewUI4 image:XinShouYueUI_GM_Normal")
			--g_TopChongZhi_Btn[i]:SetProperty("HoverImage",  "set:ServerNewUI4 image:XinShouYueUI_GM_Hover")
			--g_TopChongZhi_Btn[i]:SetProperty("PushedImage", "set:ServerNewUI4 image:XinShouYueUI_GM_Pushed")
		--已领取
		elseif g_TopChongZhi_ButtonState[i] == 2 then
			local Text1 = ScriptGlobal_Format("#{XSJNH_180111_73}", g_TopChongZhi_GetGiftsCondition[i].Exch,g_TopChongZhi_GetGiftsCondition[i].Exch)
			g_TopChongZhi_Text[i].Exch:SetText(Text1)
			local Text2 = ScriptGlobal_Format("#{XSJNH_180111_74}", g_TopChongZhi_GetGiftsCondition[i].Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
			g_TopChongZhi_Text[i].Cost:SetText(Text2) 
			g_TopChongZhi_Btn[i]:SetProperty("DisabledImage", "set:XinShouNewBK image:XinShouNew_YLQ") 
			g_TopChongZhi_Btn[i]:Disable()
		end 
	end
 
end

function TopChongZhi_CleanActionItemInfo() 
	for i = 1, table.getn(g_TopChongZhi_ICON) do
		for j = 1, table.getn(g_TopChongZhi_ICON[i]) do
			g_TopChongZhi_ICON[i][j]:SetActionItem(-1)
			g_TopChongZhi_ICON[i][j]:Hide()
		end 
	end 
end 

function TopChongZhi_BaiBao_Frame3_GetGift( Index )
	-- 执行脚本
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "YBCost_GetPrize" ); 	-- ??????
		Set_XSCRIPT_ScriptID( 181000 );						-- ????
		Set_XSCRIPT_Parameter( 0, g_TopChongZhiObjId );		-- ???
		Set_XSCRIPT_Parameter( 1, Index );					-- ???
		Set_XSCRIPT_ParamCount( 2 );						-- ????
	Send_XSCRIPT()
end  
--===============================================
-- 充值超值赠 -end
--===============================================
