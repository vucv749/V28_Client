--超级管理员工具V1
--新增GM组队玩家 可面对面道具发放 雪舞二改 2021-9-4 19:04:08 

local g_GameTools_Frame_UnifiedPosition;
local MenPaiId = -1
local TargetID = nil
local g_GameTools_ItemSearchResults = {}
local GameTools_ItemTypeId = 1
local gameToolsItemTypeList = {"装备", "材料", "宝石"}
local menpaiNameList = {"少林","明教","丐帮","武当","峨眉","星宿","天龙","天山","逍遥","无门派","曼陀","恶人谷","慕容","唐门","鬼谷","桃花岛","绝情谷"}--,"慕容","唐门","鬼谷","桃花岛"
function GameTools_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" ); -- 离开场景
	this:RegisterEvent("MAINTARGET_CHANGED")
end

function GameTools_OnLoad()
	g_GameTools_Frame_UnifiedPosition=GameTools_Frame:GetProperty("UnifiedPosition");
end

function GameTools_OnEvent(event)
	if(event == "UI_COMMAND" and arg0 == "20200427") then
		GameTools_Init()
		GameTools_FenYe1:SetCheck(1)
		this:Show();
	elseif ( event == "MAINTARGET_CHANGED" ) then
		TargetID = tonumber(arg0)
	elseif (event == "ADJEST_UI_POS" ) then
		GameTools_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GameTools_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

function GameTools_ListBox_Selected()
	local str
	str,MenPaiId = GameTools_menpaiEdix:GetCurrentSelect()
end

function GameTools_Init()
	GameTools_menpaiEdix:ResetList()
	for i = 1, table.getn(menpaiNameList) do
		GameTools_menpaiEdix:AddTextItem(menpaiNameList[i], i)
	end
	-- 初始化物品类型列表
	GameTools_ItemTypeList:ResetList()
	for i = 1, table.getn(gameToolsItemTypeList) do
		GameTools_ItemTypeList:AddTextItem(gameToolsItemTypeList[i], i)
	end
	GameTools_ItemTypeId = 1
end

--元宝
function GameTools_yuanbao(index)--1增加 2减少
    local nNum = GameTools_yuanbaoEdix:GetText()
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
function GameTools_item(index)--1增加 2减少
    local nNum = GameTools_itemEdix:GetText()
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
function GameTools_money(index)--1增加 2减少
    local nNum = GameTools_moneyEdix:GetText()
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
function GameTools_bindyuanbao(index)--1增加 2减少
    local nNum = GameTools_bindyuanbaoEdix:GetText()
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

--心法
function GameTools_xiongba(index)--1增加 2减少
    local nNum = GameTools_xiongbaEdix:GetText()
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
function GameTools_hongli(index)--1增加 2减少
    local nNum = GameTools_hongliEdix:GetText()
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
function GameTools_level(index)--1增加 2减少
    local nNum = GameTools_levelEdix:GetText()
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
function GameTools_menpai(index) 
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
function GameTools_FaFang(index)
	if TargetID == nil then
		PushDebugMessage("请选择发放装备的玩家，如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	--物品ID
    local nItem = GameTools_FaFang1Edix:GetText()
	--发放数量
	local nNum = GameTools_FaFang2Edix:GetText()
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
function GameTools_JiaoZi(index)
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
    local nNum = GameTools_JiaoZiEdix:GetText()
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

--给玩家善恶
function GameTools_JKL(index)
    local nNum = GameTools_JKLEdix:GetText()
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
function GameTools_MenGong(index)
    local nNum = GameTools_MenGongEdix:GetText()
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
function GameTools_BangGong(index)
    local nNum = GameTools_BangGongEdix:GetText()
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
function GameTools_GongLi(index)
    local nNum = GameTools_GongLiEdix:GetText()
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

--给玩家杀气
function GameTools_TiWu(index)
    local nNum = GameTools_TiWuEdix:GetText()
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

--称号
function GameTools_JingCui(index)
    local nNum = GameTools_JingCuiEdix:GetText()
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
function GameTools_ZhuangTai(index)
    local nNum = GameTools_ZhuangTaiEdix:GetText()
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
function GameTools_BaoBao(index)
    local nNum = GameTools_BaoBaoEdix:GetText()
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
function GameTools_JingYan(index)
    local nNum = GameTools_JingYanEdix:GetText()
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
function GameTools_HuoLi(index)
    local nNum = GameTools_HuoLiEdix:GetText()
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
function GameTools_JingLi(index)
    local nNum = GameTools_JingLiEdix:GetText()
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
function GameTools_DiTu(index)
    local nMap = GameTools_DiTu1Edix:GetText()
	local xPos = GameTools_DiTu2Edix:GetText()
	local yPos = GameTools_DiTu3Edix:GetText()
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
function GameTools_VIP(index)--1增加 2减少
    local nNum = GameTools_VIPEdix:GetText()
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

--给技能
function GameTools_NeiXi(index)--1增加 2减少
    local nNum = GameTools_NeiXiEdix:GetText()
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

function GameTools_ItemSelectChanged()
end

function GameTools_Frame_On_ResetPos()
	GameTools_Frame:SetProperty("UnifiedPosition", g_GameTools_Frame_UnifiedPosition);
end

--TAB界面切换
function GameTools_ChangeTabIndex( nIndex )
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


-- ========== 物品搜索功能 ==========

function GameTools_ItemType_Selected()
	local str
	str, GameTools_ItemTypeId = GameTools_ItemTypeList:GetCurrentSelect()
end

function GameTools_FormatItemDisplay(itemName, itemId)
	local idStr = tostring(itemId)
	local padding = 8 - string.len(idStr)
	if padding < 1 then padding = 1 end
	local spaces = ""
	for i = 1, padding do spaces = spaces .. " " end
	return idStr .. spaces .. itemName
end

function GameTools_DoSearch()
	local searchText = GameTools_SearchEdit:GetText()
	if searchText == nil or searchText == "" then
		GameTools_SearchStatus:SetText("")
		PushDebugMessage("请输入搜索内容")
		return
	end
	GameTools_SearchItems(searchText)
end

function GameTools_SearchItems(searchText)
	g_GameTools_ItemSearchResults = {}
	GameTools_ItemList:ClearListBox()
	GameTools_ItemIcon:SetActionItem(-1)
	GameTools_ItemIdEdit:SetText("")
	GameTools_ItemCountEdit:SetText("1")
	GameTools_SearchStatus:SetText("正在搜索 [" .. searchText .. "]...")

	local results = GameTools_SearchItemsInMemory(searchText, GameTools_ItemTypeId, 100)
	local resultCount = 0

	for i = 1, table.getn(results) do
		local item = results[i]
		table.insert(g_GameTools_ItemSearchResults, {id = item.id, name = item.name})
		local displayText = GameTools_FormatItemDisplay(item.name, item.id)
		GameTools_ItemList:AddItem(displayText, resultCount)
		resultCount = resultCount + 1
	end

	if resultCount == 0 then
		GameTools_ItemList:AddItem("未找到匹配的道具", 0)
		GameTools_SearchStatus:SetText("未找到匹配的道具")
	else
		GameTools_SearchStatus:SetText("找到 " .. resultCount .. " 个匹配的道具")
	end
	return resultCount
end

function GameTools_ItemList_Selected()
	local itemIndex = GameTools_ItemList:GetFirstSelectItem()
	if itemIndex ~= nil and itemIndex >= 0 and itemIndex < table.getn(g_GameTools_ItemSearchResults) then
		local itemData = g_GameTools_ItemSearchResults[itemIndex + 1]
		if itemData ~= nil then
			local theAction = DataPool:CreateActionItemForShow(itemData.id, 1)
			if theAction:GetID() ~= 0 then
				GameTools_ItemIcon:SetActionItem(theAction:GetID())
			end
			GameTools_ItemIdEdit:SetText(tostring(itemData.id))
			GameTools_ItemCountEdit:SetText("1")
		end
	end
end

function GameTools_SendSelectedItem()
	local itemIdText = GameTools_ItemIdEdit:GetText()
	if itemIdText == nil or itemIdText == "" then
		PushDebugMessage("请先选择一个物品")
		return
	end
	local itemId = tonumber(itemIdText)
	if itemId == nil or itemId <= 0 then
		PushDebugMessage("物品ID无效")
		return
	end
	local countText = GameTools_ItemCountEdit:GetText()
	if countText == nil or countText == "" then
		PushDebugMessage("请输入物品数量")
		return
	end
	local itemCount = tonumber(countText)
	if itemCount == nil or itemCount <= 0 then
		PushDebugMessage("请输入有效的数量")
		return
	end
	if TargetID == nil then
		PushDebugMessage("请先选中目标玩家")
		TargetID = 0
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("GMToolTypeOne")
	Set_XSCRIPT_ScriptID(666666)
	Set_XSCRIPT_Parameter(0, 9)
	Set_XSCRIPT_Parameter(1, tonumber(itemId))
	Set_XSCRIPT_Parameter(2, tonumber(itemCount))
	Set_XSCRIPT_Parameter(3, TargetID)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function GameTools_RecallLastItem()
	local itemIdText = GameTools_ItemIdEdit:GetText()
	if itemIdText == nil or itemIdText == "" then
		PushDebugMessage("请先选择一个物品")
		return
	end
	local itemId = tonumber(itemIdText)
	if itemId == nil or itemId <= 0 then
		PushDebugMessage("物品ID无效")
		return
	end
	local countText = GameTools_ItemCountEdit:GetText()
	if countText == nil or countText == "" then
		PushDebugMessage("请输入物品数量")
		return
	end
	local itemCount = tonumber(countText)
	if itemCount == nil or itemCount <= 0 then
		PushDebugMessage("请输入有效的数量")
		return
	end
	if TargetID == nil then
		PushDebugMessage("请先选中目标玩家")
		TargetID = 0
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("GMToolTypeOne")
	Set_XSCRIPT_ScriptID(666666)
	Set_XSCRIPT_Parameter(0, 25)
	Set_XSCRIPT_Parameter(1, tonumber(itemId))
	Set_XSCRIPT_Parameter(2, tonumber(itemCount))
	Set_XSCRIPT_Parameter(3, TargetID)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end
