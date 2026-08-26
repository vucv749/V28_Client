--GM内部工具第二套V2.0 雪舞编写 
--雪舞制作 邮箱：hnxq@foxmail.com 2022-05-26 

local g_GameTools2_Frame_UnifiedPosition;
local TargetID
function GameTools2_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED" ); -- 离开场景
	this:RegisterEvent("MAINTARGET_CHANGED")
end

function GameTools2_OnLoad()
	g_GameTools2_Frame_UnifiedPosition=GameTools2_Frame:GetProperty("UnifiedPosition");
end

function GameTools2_OnEvent(event)
	if(event == "UI_COMMAND" and arg0 == "202004272") then
		GameTools2_FenYe2:SetCheck(1)
		this:Show();
	elseif ( event == "MAINTARGET_CHANGED" ) then
		TargetID = tonumber(arg0)
	elseif (event == "ADJEST_UI_POS" ) then
		GameTools2_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GameTools2_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

--元宝
function GameTools2_BOSS(index)
    local nID 		= GameTools2_BOSS1Edix:GetText() --怪物ID
	local nBAI		= GameTools2_BOSS2Edix:GetText() --基础AI
	local nEAI 		= GameTools2_BOSS3Edix:GetText() --扩展AI
	local nScriptID = GameTools2_BOSS4Edix:GetText() --脚本
	if nID == nil then 
		PushDebugMessage("请输入正确的怪物ID！")
	end
	if nBAI == nil then
		nBAI = 0
	end
	if nEAI == nil then
		nEAI = 0
	end
	if nScriptID == nil then
		nScriptID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,25); 
		Set_XSCRIPT_Parameter(1,tonumber(index));
		Set_XSCRIPT_Parameter(2,tonumber(nID)); 
		Set_XSCRIPT_Parameter(3,tonumber(nBAI));
		Set_XSCRIPT_Parameter(4,tonumber(nEAI));
		Set_XSCRIPT_Parameter(5,tonumber(nScriptID));
		Set_XSCRIPT_ParamCount(6);
    Send_XSCRIPT();	
end



--武学心得
function GameTools2_XinDe(index) 
    local nNum = GameTools2_XinDeEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,28);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end



--契灵值
function GameTools2_QiLing(index) 
    local nNum = GameTools2_QiLingEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,30);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--功勋值
function GameTools2_GongXun(index) 
    local nNum = GameTools2_GongXunEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,31);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--斩杀目标
function GameTools2_ZhanSha(index) 
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,32);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,0);
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--查询和设置GetMissionData的值 [添加时间：2022-7-19 23:49:00 XUEWU-QQ784055837]
function GameTools2_GetMissionData(index) 
	local nNum = GameTools2_GetMissionDataEdix:GetText() --查询的值
	local SetValue = GameTools2_GetMissionData2Edix:GetText() --需要设置的内容
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	--只显示客户端的值（特殊作用） 前面输入99999，后面输入你要查询的客户端的值就可以显示了。
	if nNum == 99999 and SetValue ~= nil  then 
		DataValue = DataPool:GetPlayerMission_DataRound(tonumber(SetValue))
		PushDebugMessage("DataPool:GetPlayerMission_DataRound 客户端值："..DataValue)
	end
	
	if  index == 1 and nNum == nil then
		PushDebugMessage("请填写需要查询的变量ID。")
	end
	if  index == 1 then
		SetValue = 0
	end
	
	if	index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("第一个和第二个编辑框内容为空，请填写完整后才能修改哦！")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("请输入想要修改的值，第二个编辑框内容为空！")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("请输入要修改的变量ID，第一个编辑框内容为空！")
		return
	end
	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("请先选中目标头像，才能查询目标玩家的GetMissionData值！")
		elseif index == 2 then 
			PushDebugMessage("请先选中目标头像，才能设置目标玩家的GetMissionData值！")
		end
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,33);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --设置的值。
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--查询和设置GetMissionDataEx的值 [添加时间：2022-7-19 23:49:00 XUEWU-QQ784055837]
function GameTools2_GetMissionDataEx(index) 
	local nNum = GameTools2_GetMissionDataExEdix:GetText() --查询的值
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	local SetValue = GameTools2_GetMissionDataEx2Edix:GetText() --需要设置的内容
	if  index == 1 then
		SetValue = 0
	end
	
	if  index == 1 and nNum == nil then
		PushDebugMessage("请填写需要查询的变量ID。")
		return
	end
	if  index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("第一个和第二个编辑框内容为空，请填写完整后才能修改哦！")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("请输入想要修改的值，第二个编辑框内容为空！")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("请输入要修改的变量ID，第一个编辑框内容为空！")
		return
	end	

	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("请先选中目标头像，才能查询目标玩家的GetMissionDataEx值！")
		elseif index == 2 then 
			PushDebugMessage("请先选中目标头像，才能设置目标玩家的GetMissionDataEx值！")
		end
		TargetID = 0
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,34);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --设置的值。
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--查询和设置GetMissionFlag的值 [添加时间：2022-7-20 15:43:08 XUEWU]
function GameTools2_GetMissionFlag(index) 
	local nNum = GameTools2_GetMissionFlagEdix:GetText() --查询的值
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	local SetValue = GameTools2_GetMissionFlag2Edix:GetText() --需要设置的内容

	if  index == 1 then
		SetValue = 0
	end
	
	if  SetValue ~= 1 and SetValue ~= 0 then
		PushDebugMessage("设置的值只能是0或者1。")
		return
	end
	
	if  index == 1 and nNum == nil then
		PushDebugMessage("请填写需要查询的变量ID。")
		return
	end
	if  index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("第一个和第二个编辑框内容为空，请填写完整后才能修改哦！")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("请输入想要修改的值，第二个编辑框内容为空！")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("请输入要修改的变量ID，第一个编辑框内容为空！")
		return
	end	

	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("请先选中目标头像，才能查询目标玩家的GetMissionFlag值！")
		elseif index == 2 then 
			PushDebugMessage("请先选中目标头像，才能设置目标玩家的GetMissionFlag值！")
		end
		TargetID = 0
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,35);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --设置的值。
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--查询和设置LuaFnGetWorldGlobalData的值 [添加时间：2022-7-20 15:43:08 XUEWU]
function GameTools2_GetWorldGlobalData(index) 
	local nNum = GameTools2_GetWorldGlobalDataEdix:GetText() --查询的值
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	local SetValue = GameTools2_GetWorldGlobalData2Edix:GetText() --需要设置的内容
	if  index == 1 then
		SetValue = 0
	end
	if  index == 1 and nNum == nil then
		PushDebugMessage("请填写需要查询的变量ID。")
		return
	end
	if  index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("第一个和第二个编辑框内容为空，请填写完整后才能修改哦！")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("请输入想要修改的值，第二个编辑框内容为空！")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("请输入要修改的变量ID，第一个编辑框内容为空！")
		return
	end	
	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("请先选中目标头像，才能查询目标玩家的GetWorldGlobalData值！")
		elseif index == 2 then 
			PushDebugMessage("请先选中目标头像，才能设置目标玩家的GetWorldGlobalData值！")
		end
		TargetID = 0
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,36);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --设置的值。
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end



--武意等级
function GameTools2_WuYiLevel(index)
    local nNum = GameTools2_WuYiLevelEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,38);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--武意杀怪
function GameTools2_WuYiShaGuai(index)
    local nNum = GameTools2_WuYiShaGuaiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,39);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--武意双倍
function GameTools2_WuYiSB(index)
    local nNum = GameTools2_WuYiSBEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,40);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--培元点
function GameTools2_WuYiPY(index)
    local nNum = GameTools2_WuYiPYEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,41);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--神鼎药尘
function GameTools2_ZiNvLevel(index)
    local nNum = GameTools2_ZiNvLevelEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,42);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--子女经验
function GameTools2_ZiNvJY(index)
    local nNum = GameTools2_ZiNvJYEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,43);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--神工值
function GameTools2_CZD(index)
    local nNum = GameTools2_CZDEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	if TargetID == nil then
		PushDebugMessage("如果发放给玩家，请先选中他的头像！")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,44);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end



function GameTools2_Frame_On_ResetPos()
	GameTools2_Frame:SetProperty("UnifiedPosition", g_GameTools2_Frame_UnifiedPosition);
end

--TAB界面切换
function GameTools2_ChangeTabIndex( nIndex )
 local nUI = 0
	if 1 == nIndex then
		nUI = 20200427
	elseif 2 == nIndex then
		return
		-- nUI = 202004272
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

--查询和设置GetMissionFlagEx的值
function GameTools2_GetMissionFlagEx(index) 
	local nNum = GameTools2_GetMissionFlagExEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("请先输入数据，再执行操作")
		return
	end
	local SetValue = GameTools2_GetMissionFlagEx2Edix:GetText()
	if  index == 1 then
		SetValue = 0
	end
	if  index == 2 and SetValue ~= "1" and SetValue ~= "0" then
		PushDebugMessage("设置的值只能是0或者1。")
		return
	end
	if  index == 2 and (SetValue == nil or SetValue == "") then
		PushDebugMessage("请输入想要修改的值，第二个编辑框内容为空！")
		return
	end
	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("请先选中目标头像，才能查询目标玩家的GetMissionFlagEx值！")
		elseif index == 2 then 
			PushDebugMessage("请先选中目标头像，才能设置目标玩家的GetMissionFlagEx值！")
		end
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,46);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue));
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--发送公告
function GameTools2_GongGao()
	local msg = GameTools2_GongGaoEdix:GetText()
	if msg == nil or msg == "" then
		PushDebugMessage("请输入公告内容！")
		return
	end
	-- Clear_XSCRIPT();
		-- Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		-- Set_XSCRIPT_ScriptID(666666);
		-- Set_XSCRIPT_Parameter(0,47);
		-- Set_XSCRIPT_Parameter(1,1);
		-- Set_XSCRIPT_Parameter(2,0);
		-- Set_XSCRIPT_Parameter(3,0);
		-- Set_XSCRIPT_ParamCount(4);
		-- Set_XSCRIPT_String(0,msg);
    -- Send_XSCRIPT();	
	
	local text = GameTools2_GongGaoEdix:GetText()
	Talk:SendChatMessage("near", 
		string.format("&SYSDATA&,%s,%s,%s",
			("666666"),
			("AddGlobalCountNews"),
			(text)
			)
		);
		
end


--解散帮会(输入GuildID)
function GameTools2_DisbandGuild()
	local nGuildID = GameTools2_DisbandGuildEdix:GetText()
	if nGuildID == nil or nGuildID == "" then
		PushDebugMessage("请输入要解散的帮会ID！")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,48);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_Parameter(2,tonumber(nGuildID));
		Set_XSCRIPT_Parameter(3,0);
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
end
