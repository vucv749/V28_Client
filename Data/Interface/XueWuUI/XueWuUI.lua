--超级管理员工具V1
--新增GM组队玩家 可面对面道具发放 雪舞二改 2021-9-4 19:04:08 

local g_XueWuUI_Frame_UnifiedPosition;
local MenPaiId = -1
local TargetID = nil
local menpaiNameList = {"少林","明教","丐帮","武当","峨眉","星宿","天龙","天山","逍遥","无门派"}--,"慕容","唐门","鬼谷","桃花岛"
function XueWuUI_PreLoad()
	this:RegisterEvent("OPEN_XUEWU_UI");
	this:RegisterEvent("CLOSE_XUEWU_UI");
	this:RegisterEvent("XUEWU_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" ); -- 离开场景
	this:RegisterEvent("MAINTARGET_CHANGED")
end

function XueWuUI_OnLoad()
	g_XueWuUI_Frame_UnifiedPosition=XueWuUI_Frame:GetProperty("UnifiedPosition");
end

function XueWuUI_OnEvent(event)
	if event == "OPEN_XUEWU_UI" then
		PushDebugMessage("11111111")
		XueWuUI_Init()
		XueWuUI_FenYe1:SetCheck(1)
		this:Show();
	elseif event == "CLOSE_XUEWU_UI" then
		this:Hide();
	elseif event == "XUEWU_NOTIFY" then
		if arg0 ~= nil then
			PushDebugMessage("[XueWuUI] " .. arg0)
		end
	elseif ( event == "MAINTARGET_CHANGED" ) then
		TargetID = tonumber(arg0)
	elseif (event == "ADJEST_UI_POS" ) then
		XueWuUI_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XueWuUI_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

function XueWuUI_ListBox_Selected()
	local str
	str,MenPaiId = XueWuUI_menpaiEdix:GetCurrentSelect()
end

function XueWuUI_Init()
	--先清空当前列表
	XueWuUI_menpaiEdix:ResetList()
	for i = 1, table.getn(menpaiNameList) do
		XueWuUI_menpaiEdix:AddTextItem(menpaiNameList[i], i)
	end	
end

--元宝
function XueWuUI_yuanbao(index)--1增加 2减少
    local nNum = XueWuUI_yuanbaoEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--物品装备
function XueWuUI_item(index)--1增加 2减少
    local nNum = XueWuUI_itemEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,2);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--金币
function XueWuUI_money(index)--1增加 2减少
    local nNum = XueWuUI_moneyEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,3);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--绑定元宝
function XueWuUI_bindyuanbao(index)--1增加 2减少
    local nNum = XueWuUI_bindyuanbaoEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,4);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--返券
function XueWuUI_xiongba(index)--1增加 2减少
    local nNum = XueWuUI_xiongbaEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,5);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--赠点
function XueWuUI_hongli(index)--1增加 2减少
    local nNum = XueWuUI_hongliEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,6);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--角色等级
function XueWuUI_level(index)--1增加 2减少
    local nNum = XueWuUI_levelEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,7);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--切换门派
function XueWuUI_menpai(index) 
    if MenPaiId == - 1 then
	   PushDebugMessage("请选择加入的门派")
	   TargetID = 0
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,8);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(MenPaiId));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	   
end

--给玩家发放道具装备 BY雪舞[BUG-319] 2021-9-4 21:45:55 
function XueWuUI_FaFang(index)
	if TargetID == nil then
		PushDebugMessage("请选择发放装备的玩家，如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	--物品ID
    local nItem = XueWuUI_FaFang1Edix:GetText()
	--发放数量
	local nNum = XueWuUI_FaFang2Edix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if nItem == nil then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,9); 				--nType 
		Set_XSCRIPT_Parameter(1,tonumber(nItem));	--arg2  道具ID
		Set_XSCRIPT_Parameter(2,tonumber(nNum));	--arg3  道具数量
		Set_XSCRIPT_Parameter(3,TargetID);		--isWho 玩家Guid
		Set_XSCRIPT_ParamCount(4);					--参数总数
    Send_XSCRIPT();
end

--给玩家交子
function XueWuUI_JiaoZi(index)
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
    local nNum = XueWuUI_JiaoZiEdix:GetText()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,10);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--给玩家金坷垃
function XueWuUI_JKL(index)
    local nNum = XueWuUI_JKLEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--给玩家门贡
function XueWuUI_MenGong(index)
    local nNum = XueWuUI_MenGongEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--给玩家帮贡
function XueWuUI_BangGong(index)
    local nNum = XueWuUI_BangGongEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--给玩家修炼功力
function XueWuUI_GongLi(index)
    local nNum = XueWuUI_GongLiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,14);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--给玩家无字谱体悟
function XueWuUI_TiWu(index)
    local nNum = XueWuUI_TiWuEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,15);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--给玩家真元精粹
function XueWuUI_JingCui(index)
    local nNum = XueWuUI_JingCuiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,16);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--给buff
function XueWuUI_ZhuangTai(index)
    local nNum = XueWuUI_ZhuangTaiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,17);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();
end

--给宝宝
function XueWuUI_BaoBao(index)
    local nNum = XueWuUI_BaoBaoEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,18);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--经验
function XueWuUI_JingYan(index)
    local nNum = XueWuUI_JingYanEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,19);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--活力
function XueWuUI_HuoLi(index)
    local nNum = XueWuUI_HuoLiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,20);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--精力
function XueWuUI_JingLi(index)
    local nNum = XueWuUI_JingLiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,21);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--传送到指定地图ID
function XueWuUI_DiTu(index)
    local nMap = XueWuUI_DiTu1Edix:GetText()
	local xPos = XueWuUI_DiTu2Edix:GetText()
	local yPos = XueWuUI_DiTu3Edix:GetText()
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	if nMap == nil then
		nMap = 99999
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,22);
		Set_XSCRIPT_Parameter(1,tonumber(nMap)); --地图ID
		Set_XSCRIPT_Parameter(2,tonumber(xPos)); --X
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(yPos)); --Y
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();
end

--给会员点
function XueWuUI_VIP(index)--1增加 2减少
    local nNum = XueWuUI_VIPEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,23);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--给内息
function XueWuUI_NeiXi(index)--1增加 2减少
    local nNum = XueWuUI_NeiXiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,24);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

function XueWuUI_ItemSelectChanged()
end

function XueWuUI_Frame_On_ResetPos()
	XueWuUI_Frame:SetProperty("UnifiedPosition", g_XueWuUI_Frame_UnifiedPosition);
end

--TAB界面切换
function XueWuUI_ChangeTabIndex( nIndex )
 local nUI = 0
	if 1 == nIndex then
		-- nUI = 20200427
		return
	elseif 2 == nIndex then
		nUI = 202004272
	elseif 3 == nIndex then
		nUI = 202004273
	elseif 4 == nIndex then
		nUI = 202004274
	elseif 5 == nIndex then
		nUI = 202004275
	elseif 6 == nIndex then
		nUI = 202004276
	elseif 7 == nIndex then
		nUI = 316022021
	end
	if nUI ~= 0 then
		PushEvent("UI_COMMAND", nUI)
		this:Hide();
	end
end