-- 万能传送界面
-- 雪舞精简代码 2025-5-7 15:16:22

local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local sceninfog={}
local sceninfo1 = {}
local sceninfo2 = {}
local sceninfo3 = {}
local sceninfo4 = {}
local sceninfo5 = {}
local currentIndex  = 1

local MAX_OBJ_DISTANCE = 3.0;
local ObjCaredIDID = -1;

function ChuanSongSystem_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("OPEN_CHUANSONG_SYSTEM");
	-- this:RegisterEvent("OBJECT_CARED_EVENT");
end

function ChuanSongSystem_OnEvent(event)
	if event == "OPEN_CHUANSONG_SYSTEM"  then
		
		-- local xx = Get_XParam_INT(0);
		-- ObjCaredID = DataPool : GetNPCIDByServerID(xx);
		-- if ObjCaredID == -1 then
			-- PushDebugMessage("server传过来的数据有问题。");
			-- return;
		-- end
		-- ObjCaredIDID = xx
		-- BeginCareObject_ChuanSongSystem()
		
		this:Show()
		ChuanSongSystem_ShowCategory(1)
	end
	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
	elseif (event == "ADJEST_UI_POS" ) then	
		ChuanSongSystem_ResetPos()	
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			ChuanSongSystem_Close()
		end
	end
		
end

function ChuanSongSystem_OnLoad()
	for i = 1, 30 do 
		sceninfog[i] = _G["ChuanSongSystem_goto"..i]
	end
	
	sceninfo1 = {
		{str="洛阳商会",Num=ChuanSongSystem_goto1},
		{str="大    理",Num=ChuanSongSystem_goto2},
		{str="苏    州",Num=ChuanSongSystem_goto3},
		{str="苏州铁匠铺",Num=ChuanSongSystem_goto4},
		{str="楼兰古城",Num=ChuanSongSystem_goto5},
		{str="束河古镇",Num=ChuanSongSystem_goto6},
		{str="星    宿",Num=ChuanSongSystem_goto7},
		{str="逍    遥",Num=ChuanSongSystem_goto8},
		{str="少    林",Num=ChuanSongSystem_goto9},
		{str="天    山",Num=ChuanSongSystem_goto10},
		{str="天    龙",Num=ChuanSongSystem_goto11},
		{str="峨    嵋",Num=ChuanSongSystem_goto12},
		{str="武    当",Num=ChuanSongSystem_goto13},
		{str="明    教",Num=ChuanSongSystem_goto14},
		{str="丐    帮",Num=ChuanSongSystem_goto15},
		--{str="#cff99cc学习新手技能",Num=ChuanSongSystem_goto16},
	}

	sceninfo2 = {
		{str="宝藏洞一层",Num=ChuanSongSystem_goto1},
		{str="宝藏洞三层",Num=ChuanSongSystem_goto2},
		{str="宝藏洞五层",Num=ChuanSongSystem_goto3},
		{str="摩 崖 洞",Num=ChuanSongSystem_goto4},
		{str="古墓一层",Num=ChuanSongSystem_goto5},
		{str="古墓五层",Num=ChuanSongSystem_goto6},
		{str="古墓九层",Num=ChuanSongSystem_goto7},
		{str="地宫一层",Num=ChuanSongSystem_goto8},
		{str="地宫二层",Num=ChuanSongSystem_goto9},
		{str="地宫三层",Num=ChuanSongSystem_goto10},
		{str="迷    宫",Num=ChuanSongSystem_goto11},
		{str="塔    克",Num=ChuanSongSystem_goto12},
		{str="汗 血 岭",Num=ChuanSongSystem_goto13},
		{str="火 焰 谷",Num=ChuanSongSystem_goto14},
		--{str="#G无量山-新手BOSS",Num=ChuanSongSystem_goto15},
		--{str="#G敦煌-新手BOSS",Num=ChuanSongSystem_goto16},
	}

	sceninfo3 = {
		{str="#Y草原-必抢",Num=ChuanSongSystem_goto1},
		{str="#Y苍山-必抢",Num=ChuanSongSystem_goto2},
		{str="#Y武夷-必抢",Num=ChuanSongSystem_goto3},
		{str="#Y玄武岛-必抢",Num=ChuanSongSystem_goto4},
		{str="企 鹅 王",Num=ChuanSongSystem_goto5},
		{str="工魂影像",Num=ChuanSongSystem_goto6},
		{str="丐帮孙立者",Num=ChuanSongSystem_goto7},
		{str="峨嵋袁公子",Num=ChuanSongSystem_goto8},
		{str="明教金裳",Num=ChuanSongSystem_goto9},
		{str="少林彭侯",Num=ChuanSongSystem_goto10},
		{str="星宿三十娘",Num=ChuanSongSystem_goto11},
		{str="天山白岑",Num=ChuanSongSystem_goto12},
		{str="武当孟昧",Num=ChuanSongSystem_goto13},
		{str="逍遥贾川",Num=ChuanSongSystem_goto14},
		{str="天龙王君",Num=ChuanSongSystem_goto15},
	}

	sceninfo4 = {
		{str="宋辽边境",Num=ChuanSongSystem_goto1},
		{str="黄金之链",Num=ChuanSongSystem_goto2},
		{str="棋    局",Num=ChuanSongSystem_goto3},
		{str="蹴    鞠",Num=ChuanSongSystem_goto4},
		{str="燕 子 坞",Num=ChuanSongSystem_goto5},
		{str="飘 渺 峰",Num=ChuanSongSystem_goto6},
		{str="楼兰寻宝",Num=ChuanSongSystem_goto7},
		
	}

	sceninfo5 = {
		{str="#cFF0000圣兽山龙龟-必争",Num=ChuanSongSystem_goto1},
		{str="#cFF0000圣兽山箱子-必争",Num=ChuanSongSystem_goto2},
		{str="#cFF0000重楼霜影",Num=ChuanSongSystem_goto3},
	}

	g_Frame_UnifiedXPosition = ChuanSongSystem_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition = ChuanSongSystem_Frame:GetProperty("UnifiedYPosition");
end

function ChuanSongSystem_Close()
	-- StopCareObject_ChuanSongSystem()
	this:Hide();
end

function ChuanSongSystem_ResetPos()
	ChuanSongSystem_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	ChuanSongSystem_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

--执行脚本
function ChuanSongSystem_Clicked(index)
	if index > 30 and index < 1 then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Teleport"); 	
		Set_XSCRIPT_ScriptID(990001);
		Set_XSCRIPT_Parameter(0,tonumber(currentIndex ));
		Set_XSCRIPT_Parameter(1,tonumber(index));
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT()
end

-- 切换大页面
function ChuanSongSystem_ShowCategory(index)
	if index < 1 or index > 6 then 
		return 
	end 
	currentIndex  = index
	local nchuansong = 0
	
	-- 隐藏所有按钮 
	for i=1,30 do
		if sceninfog[i] then 
			sceninfog[i]:Hide();
		end
	end
		
	if index == 1 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo1) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 2 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo2) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 3 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo3) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 4 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo4) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 5 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo5) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 6 then
		ChuanSongSystem_Client:Hide()
	end

end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_ChuanSongSystem()
	this:CareObject(ObjCaredID, 1, "ChuanSongSystem");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_ChuanSongSystem()
	this:CareObject(ObjCaredID, 0, "ChuanSongSystem");
end