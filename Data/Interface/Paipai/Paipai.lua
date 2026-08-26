-- 幸运拍拍 2025Q4运营活动-幸运天使
-- 雪舞制作@WAYLEE

local  NUM1 = {}
local  NUM2 = {}
local  NUM3 = {}
local  TP = {}
local  TPXZ = {}
local  TPTX = {}
local  TEX = {}
local  PaipaiInfo = 8
local  IsPaipaiBegin = 0
local  Prize = 1
local  COUNT1 = 0
local  COUNT2 = 0
local  COUNT3 = 0
local  Ramnum1 = 0
local  Ramnum2 = 0
local  Ramnum3 = 0
local  c1 = 0
local  c2 = 0
local  c3 = 0

local  JiangPinNum = {}

local g_Paipai_Frame_UnifiedPosition;
function Paipai_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Paipai_OnLoad()
	
	-- 奖品数量 1..10
	for i = 1, 10 do
		JiangPinNum[i] = _G["Paipai_Num" .. i]
	end
	
	-- 三个数字滚轮 0..20
	for i = 0, 20 do
		NUM1[i] = _G["Paipai_number1_" .. i]
		NUM2[i] = _G["Paipai_number2_" .. i]
		NUM3[i] = _G["Paipai_number3_" .. i]
	end
	
	-- 奖品图标/选中框/特效/文本 1..8
	for i = 1, 8 do
		TP[i]   = _G["Paipai_wupin"   .. i]
		TPXZ[i] = _G["Paipai_wupinxz" .. i]
		TPTX[i] = _G["Paipai_wupintx" .. i]
		TEX[i]  = _G["Paipai_Text"    .. i]
	end
	g_Paipai_Frame_UnifiedPosition = Paipai_Frame:GetProperty("UnifiedPosition");
end

function Paipai_OnEvent(event)

	--打开拍拍界面
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20130427 ) then
		if IsPaipaiBegin == 1 then
			for i = 1,8 do
				TPXZ[i]:SetProperty("visible", "false");
				TPXZ[i]:Hide();
			end
			
		elseif IsPaipaiBegin == 0 then
			Paipai_UpDate();
			
		end
	
		local PaipaiItemName
		local action = 0 
		local PaipaiItemNum = string.split(Get_XParam_STR(0), ",") 
		local PaipaiLowLimit = string.split(Get_XParam_STR(1), ",") 
		local PaipaiUpLimit = string.split(Get_XParam_STR(2), ",") 
		local PaipaiItem = string.split(Get_XParam_STR(3), ",")
		local PaipaiTX = string.split(Get_XParam_STR(4), ",") --稀有度

		for j=1,8 do
			--稀有度
			if(tonumber(PaipaiTX[j]) >= 1) then
				TPTX[j]:Show();
			end
			--图标
			action = DataPool:CreateActionItemForShow(tonumber(PaipaiItem[j]), tonumber(PaipaiItemNum[j])) 
			TP[j]:SetActionItem(action:GetID())
			TP[j]:SetProperty("visible", "true");

			--名称
			PaipaiItemName = DataPool:LuaFnGetItemNameByTableIndex(tonumber(PaipaiItem[j]))

			TPXZ[j]:SetToolTip(PaipaiItemName.."X"..PaipaiItemNum[j]);

			--介绍
			TEX[j]:SetText(tostring(PaipaiLowLimit[j]) .. "---" .. tostring(PaipaiUpLimit[j]));
			--下标数量
			-- JiangPinNum[j]:SetText("#e010101"..PaipaiItemNum[j])
	
		end
		this:Show();

	--接受抽奖数据
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20130428 ) then
		Prize = Get_XParam_INT(0);
		Ramnum1 = Get_XParam_INT(1);
		Ramnum2 = Get_XParam_INT(2);
		Ramnum3 = Get_XParam_INT(3);

		Paipai_choujiang:SetProperty("Disabled","true");
		Paipai_lingqu:SetProperty("Disabled","true");
		KillTimer("Paipai_TimerProcJiaSu1()");
		if COUNT1 ~= 0 then
			c1 = COUNT1 - 1
		else
			c1 = 20
		end
		SetTimer("Paipai","Paipai_TimerProcJianSu()",100);
	
	--开始摇奖
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20130508 ) then
		Paipai_UpDate();
		IsPaipaiBegin = 1;
		Paipai_choujiang:SetText("#{PAIPAI_03}")
		Paipai_lingqu:SetProperty("Disabled","true");
		SetTimer("Paipai1","Paipai_TimerProcJiaSu1()",80);
		SetTimer("Paipai2","Paipai_TimerProcJiaSu2()",40);
		SetTimer("Paipai3","Paipai_TimerProcJiaSu3()",20);
	-- elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20131218 ) then
		-- Paipai_UpDate();
		-- IsPaipaiBegin = 0;		
	-- elseif ( event == "UI_COMMAND" and tonumber(arg0) == 33910301 ) then
		-- local nIndex = Get_XParam_INT(0);
		-- Paipai_OnChouJiang(nIndex)
	end
end

function Paipai_TimerProcJianSu()
	if (c1 ~= Ramnum1) then 
		if ( c1 == 20 ) then
			c1 = 0;
			NUM1[20]:SetProperty("visible", "false");
			NUM1[20]:Hide();
			NUM1[c1]:SetProperty("visible", "true");
			NUM1[c1]:Show();
		else
			NUM1[c1]:SetProperty("visible", "false");
			NUM1[c1]:Hide();
			NUM1[c1+1]:SetProperty("visible", "true");
			NUM1[c1+1]:Show();
			c1 = c1 + 1
		end
	elseif (c1 == Ramnum1) then
		KillTimer("Paipai_TimerProcJianSu()");
		KillTimer("Paipai_TimerProcJiaSu2()");
		if COUNT2 ~= 0 then
			c2 = COUNT2 - 1
		else
			c2 = 20
		end
		SetTimer("Paipai","Paipai_TimerProcJianSu2()",100);
	end
end

function Paipai_TimerProcJianSu2()

	if (c2 ~= Ramnum2) then 
		if ( c2 == 20 ) then
			c2 = 0;
			NUM2[20]:SetProperty("visible", "false");
			NUM2[20]:Hide();
			NUM2[c2]:SetProperty("visible", "true");
			NUM2[c2]:Show();
		else
			NUM2[c2]:SetProperty("visible", "false");
			NUM2[c2]:Hide();
			NUM2[c2+1]:SetProperty("visible", "true");
			NUM2[c2+1]:Show();
			c2 = c2 + 1
		end
	elseif (c2 == Ramnum2) then
		KillTimer("Paipai_TimerProcJianSu2()");
		KillTimer("Paipai_TimerProcJiaSu3()");
		if COUNT3 ~= 0 then
			c3 = COUNT3 - 1
		else
			c3 = 20
		end
		SetTimer("Paipai","Paipai_TimerProcJianSu3()",100);
	end
end

function Paipai_TimerProcJianSu3()

	if (c3 ~= Ramnum3) then 
		if ( c3 == 20 ) then
			c3 = 0;
			NUM3[20]:SetProperty("visible", "false");
			NUM3[20]:Hide();
			NUM3[c3]:SetProperty("visible", "true");
			NUM3[c3]:Show();
		else
			NUM3[c3]:SetProperty("visible", "false");
			NUM3[c3]:Hide();
			NUM3[c3+1]:SetProperty("visible", "true");
			NUM3[c3+1]:Show();
			c3 = c3 + 1
		end
	elseif (c3 == Ramnum3) then
		KillTimer("Paipai_TimerProcJianSu3()");
		Paipai_choujiang:SetProperty("Disabled","false");
		Paipai_lingqu:SetProperty("Disabled","false");
		COUNT1 = 0
		COUNT2 = 0
		COUNT3 = 0	
		TPXZ[Prize]:SetProperty("visible", "true");
		TPXZ[Prize]:Show();
		Prize = 1
		IsPaipaiBegin = 0
		Paipai_choujiang:SetText("#{PAIPAI_02}")
	end

end

function Paipai_Click_SetTimer(id)
	id = tonumber(id)
end

function Paipai_UpDate()
	for i = 1,8 do
		TPXZ[i]:SetProperty("visible", "false");
		TPXZ[i]:Hide();
	end
	for i = 0,20 do
		NUM1[i]:SetProperty("visible", "false");
		NUM1[i]:Hide()
		NUM2[i]:SetProperty("visible", "false");
		NUM2[i]:Hide()
		NUM3[i]:SetProperty("visible", "false");
		NUM3[i]:Hide()
	end
	Paipai_choujiang:SetText("#{PAIPAI_02}")

	NUM1[0]:Show();
	NUM2[0]:Show();
	NUM3[0]:Show();
end

function Paipai_TimerProcJiaSu1()
	
	if COUNT1 == 0 then 
		NUM1[20]:SetProperty("visible", "false");
		NUM1[20]:Hide();
		NUM1[COUNT1]:SetProperty("visible", "true");
		NUM1[COUNT1]:Show();
		COUNT1 = COUNT1 + 1;
	elseif COUNT1 == 20 then
		NUM1[COUNT1-1]:SetProperty("visible", "false");
		NUM1[COUNT1-1]:Hide();
		NUM1[COUNT1]:SetProperty("visible", "true");
		NUM1[COUNT1]:Show();
		COUNT1 = 0;
	else
		NUM1[COUNT1-1]:SetProperty("visible", "false");
		NUM1[COUNT1-1]:Hide();
		NUM1[COUNT1]:SetProperty("visible", "true");
		NUM1[COUNT1]:Show();
		COUNT1 = COUNT1 + 1;
	end

end

function Paipai_TimerProcJiaSu2()
	
	if COUNT2 == 0 then 
		NUM2[20]:SetProperty("visible", "false");
		NUM2[20]:Hide();
		NUM2[COUNT2]:SetProperty("visible", "true");
		NUM2[COUNT2]:Show();
		COUNT2 = COUNT2 + 1;
	elseif COUNT2 == 20 then
		NUM2[COUNT2-1]:SetProperty("visible", "false");
		NUM2[COUNT2-1]:Hide();
		NUM2[COUNT2]:SetProperty("visible", "true");
		NUM2[COUNT2]:Show();
		COUNT2 = 0;
	else
		NUM2[COUNT2-1]:SetProperty("visible", "false");
		NUM2[COUNT2-1]:Hide();
		NUM2[COUNT2]:SetProperty("visible", "true");
		NUM2[COUNT2]:Show();
		COUNT2 = COUNT2 + 1;
	end
end

function Paipai_TimerProcJiaSu3()
	
	if COUNT3 == 0 then 
		NUM3[20]:SetProperty("visible", "false");
		NUM3[20]:Hide();
		NUM3[COUNT3]:SetProperty("visible", "true");
		NUM3[COUNT3]:Show();
		COUNT3 = COUNT3 + 1;
	elseif COUNT3 == 20 then
		NUM3[COUNT3-1]:SetProperty("visible", "false");
		NUM3[COUNT3-1]:Hide();
		NUM3[COUNT3]:SetProperty("visible", "true");
		NUM3[COUNT3]:Show();
		COUNT3 = 0;
	else
		NUM3[COUNT3-1]:SetProperty("visible", "false");
		NUM3[COUNT3-1]:Hide();
		NUM3[COUNT3]:SetProperty("visible", "true");
		NUM3[COUNT3]:Show();
		COUNT3 = COUNT3 + 1;
	end

end

function Paipai_ChouJiang()
	if( DataPool:GetPlayerMission_ItemCountNow(30504640) < 1) then
		PushDebugMessage("缺少所需的拍拍锤子");
		return;
	end
	if IsPaipaiBegin == 0 then
		IsPaipaiBegin = 2;
		--给服务器发送检查物品消息
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("CheckRightTime");
			Set_XSCRIPT_ScriptID(339103);
			Set_XSCRIPT_Parameter(0, 0);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	elseif IsPaipaiBegin == 1 then
		IsPaipaiBegin = 2;
		--给服务器发送抽奖消息
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("CheckRightTime");
			Set_XSCRIPT_ScriptID(339103);
			Set_XSCRIPT_Parameter(0, 1);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	else
		PushDebugMessage("请先领取奖品，才能继续抽奖。")
	end
end

function Paipai_OnChouJiang(index)
	
	-- if index == 0 then
		-- --给服务器发送检查物品消息
		-- Clear_XSCRIPT();
			-- Set_XSCRIPT_Function_Name("DelItem");
			-- Set_XSCRIPT_ScriptID(339103);
			-- Set_XSCRIPT_ParamCount(0);
		-- Send_XSCRIPT();	
	-- elseif index == 1 then
		-- --给服务器发送抽奖消息
		-- Clear_XSCRIPT();
			-- Set_XSCRIPT_Function_Name("RandomItem");
			-- Set_XSCRIPT_ScriptID(339103);
			-- Set_XSCRIPT_ParamCount(0);
		-- Send_XSCRIPT();
	-- else
		-- IsPaipaiBegin = 0
		-- return
	-- end
end

function Paipai_LingJiang()
	--给服务器发送领奖消息
	Paipai_UpDate()
	IsPaipaiBegin=0 
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GiveItem");
		Set_XSCRIPT_ScriptID(339103);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end

function Paipai_Frame_On_ResetPos()
	Paipai_Frame:SetProperty("UnifiedPosition", g_Paipai_Frame_UnifiedPosition);
end

function Paipai_GuanBi()
	this:Hide();
end
