--游戏管理员工具主界面
--by.Fjqh For Entertainment or Communication Only
--By.Fjqh The computer To Write!!!
local g_UIPos;
local GameTools6_CurName,GameTools6_CurGuid = "","";
local GameTools6_SelectObject = 1;
local GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
local GameTools6_SelfTab = {}
local GameTools6_TarTab = {}
local GameTools6_AllTab = {}
local GameTools6_EditBoxTab = {}
local GameTools6_EditBoxTabRed = {}
local GameTools6_Info = {};

--===============================================
-- OnLoad()
--===============================================
function GameTools6_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("NEW_DEBUGMESSAGE")
	this:RegisterEvent("MAINTARGET_CHANGED")
	this:RegisterEvent("CHAT_SHOWUSERINFO");
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

--===============================================
-- OnLoad()
--===============================================
function GameTools6_OnLoad()
	GameTools6_EditBoxTab = {GameTools6_BoxPar1,GameTools6_BoxPar2,GameTools6_BoxPar3};
	GameTools6_EditBoxTabRed = {GameTools6_BoxPar1_Background,GameTools6_BoxPar2_Background,GameTools6_BoxPar3_Background};
	
	--==========多人 开始==========
	GameTools6_AllTab[1] = {"怪物ID","场景位置","绑定脚本","怪物ID=P1,怪物表ID\n怪物方向=P2,如默认则输入-1\n绑定脚本=P3脚本号,如无脚本则输入-1","创建怪物(怪物)"};
	GameTools6_AllTab[2] = {"怪物ID","场景位置","绑定脚本","怪物ID=P1,怪物表ID\n怪物方向=P2,如默认则输入-1\n绑定脚本=P3脚本号,如无脚本则输入-1","创建怪物(NPC)"};
	GameTools6_AllTab[3] = {"怪物ID","无效","无效","怪物ID=怪物表ID\n清理当前场景上所有该ID的创建怪物或NPC","删除怪物"};
	GameTools6_AllTab[4] = {"脚本ID","无效","无效","脚本ID=六位数ID\n重载任意LUA脚本","重载LUA脚本"};
	GameTools6_AllTab[5] = {"无效","无效","无效","重载全局脚本ScriptGlobal.lua，修改的函数和脚本立即生效","重载全局脚本"};
	GameTools6_AllTab[6] = {"无效","无效","无效","重载商店TXT文件\n重新加载文件，对文件的修改立即生效","重载商店"};
	GameTools6_AllTab[7] = {"无效","无效","无效","重载爆率TXT文件\n重新加载文件，对文件的修改立即生效","重载爆率"};
	GameTools6_AllTab[8] = {"无效","无效","无效","重载怪物TXT文件\n重新加载文件，对文件的修改立即生效","重载怪物文件"};
	GameTools6_AllTab[9] = {"是否开启","无效","无效","小喇叭是否开放使用\n开启为0,关闭为1","小喇叭是否开放使用"};
	GameTools6_AllTab[10] = {"无效","无效","无效","重载掉落公告文本 DropNotify.txt ，对文件的修改立即生效","重载掉落公告文本"};
	GameTools6_AllTab[11] = {"无效","无效","无效","重载EquipBase.txt ，对文件的修改立即生效","重载装备文件"};
	GameTools6_AllTab[12] = {"无效","无效","无效","重载手工品质分布表/起始数值段对应文件 ItemSegAffect.txt  ItemSegValue.txt ，对文件的修改立即生效","重载装备属性文件"};
	GameTools6_AllTab[13] = {"无效","无效","无效","重载AllowableScriptFunc.txt ，对文件的修改立即生效","重载脚本放行表"};
	GameTools6_AllTab[14] = {"无效","无效","无效","重载CommonItem.txt ，对文件的修改立即生效","重载物品表"};
	GameTools6_AllTab[15] = {"无效","无效","无效","重载GemInfo.txt ，对文件的修改立即生效","重载宝石表"};
	GameTools6_AllTab[16] = {"无效","无效","无效","重载PetAttrTable.txt ，对文件的修改立即生效","重载珍兽表"};
	GameTools6_AllTab[17] = {"无效","无效","无效","重载MonsterAttrExTable.txt ，对文件的修改立即生效","重载怪物表"};
	GameTools6_AllTab[18] = {"无效","无效","无效","重载PetLingXing.txt ，对文件的修改立即生效","重载灵性表"};
	GameTools6_AllTab[19] = {"无效","无效","无效","重载PetHuanhuaTable.txt ，对文件的修改立即生效","重载幻化表"};
	--==========多人 开始==========
	
	--==========他人 开始==========
	GameTools6_TarTab[1] = {"无效","无效","无效","查看目标的角色的财富","查看财富"};
	GameTools6_TarTab[2] = {"有效的#G物品ID","发放的#G数量","无效","给目标角色一次性发放P2个P1","发放物品"};
	GameTools6_TarTab[3] = {"发放数量","无效","无效","给目标角色发P1金币","发金币"};
	GameTools6_TarTab[4] = {"发放数量","无效","无效","给目标角色发P1交子","发交子"};
	GameTools6_TarTab[5] = {"发放数量","无效","无效","给目标角色发P1元宝","发元宝"};
	GameTools6_TarTab[6] = {"发放数量","无效","无效","给目标角色发P1绑元","发绑元"};
	GameTools6_TarTab[7] = {"MD编号[0-511]","无效","无效","查询目标角色P1的MD值","查MD"};
	GameTools6_TarTab[8] = {"EX编号[0-1535]","无效","无效","查询目标角色P1的EX值","查EX"};
	GameTools6_TarTab[9] = {"FLAG编号[0-319]","无效","无效","查询目标角色P1的FLAG值","查FLAG"};
	GameTools6_TarTab[10] = {"MD编号[0-511]","设置的值","无效","设置目标角色P1的MD值","设MD"};
	GameTools6_TarTab[11] = {"EX编号[0-1535]","设置的值","无效","设置目标角色P1的EX值","设EX"};
	GameTools6_TarTab[12] = {"FLAG编号[0-319]","设置的值[0-1]","无效","设置目标角色P1的FLAG值","设FLAG"};
	GameTools6_TarTab[13] = {"无效","无效","无效","设置玩家拥有超级BT属性","GM超级属性"};
	GameTools6_TarTab[14] = {"P1珍兽ID","P2五维资质","P3成长率","选择后点击确定","领取宠物"};
	GameTools6_TarTab[15] = {"无效","无效","无效","查询身上所有BUFF","查BUFF"};
	GameTools6_TarTab[16] = {"P1提升等级","无效","无效","提升玩家等级(只能提升,不能降低)","提升等级"};
	--==========他人 结束==========
	
	--==========自己 开始==========
	GameTools6_SelfTab[1] = {"有效的#G物品ID","领取的#G数量","无效","一次性领取P2个P1","领取物品"};
	GameTools6_SelfTab[2] = {"背包或装备格位#G[0-59]","无效","无效","查询P1位置上的字符信息","查物品字符信息"};
	GameTools6_SelfTab[3] = {"起始格位#G[0-89]","结束格位#G[0-89]","无效","清理背包P1-P2格位上的物品","清背包"};
	GameTools6_SelfTab[4] = {"领取数量","无效","无效","领取金币数=P1","领金币"};
	GameTools6_SelfTab[5] = {"扣除数量","无效","无效","扣除金币数=P1，当身上金币小于P1时则把身上金币全数扣除","扣金币"};
	GameTools6_SelfTab[6] = {"领取数量","无效","无效","领取交子数=P1","领交子"};
	GameTools6_SelfTab[7] = {"扣除数量","无效","无效","扣除交子数=P1，当身上交子小于P1时则把身上交子全数扣除","扣交子"};
	GameTools6_SelfTab[8] = {"领取数量","无效","无效","领取元宝数=P1","领元宝"};
	GameTools6_SelfTab[9] = {"扣除数量","无效","无效","扣除元宝数=P1，当身上元宝小于P1时则把身上元宝全数扣除","扣元宝"};
	GameTools6_SelfTab[10] = {"领取数量","无效","无效","领取绑元数=P1","领绑元"};
	GameTools6_SelfTab[11] = {"扣除数量","无效","无效","扣除绑元数=P1，当身上绑元小于P1时则把身上绑元全数扣除","扣绑元"};
	GameTools6_SelfTab[12] = {"领取数量","无效","无效","领取经验数=P1","领经验"};
	GameTools6_SelfTab[13] = {"扣除数量","无效","无效","扣除经验数=P1，当身上经验小于P1时则把身上经验全数扣除","扣经验"};
	GameTools6_SelfTab[14] = {"等级数[1-119]","无效","无效","等级=P1","设置等级"};
	GameTools6_SelfTab[15] = {"门派号[0-8]","无效","无效","无门派时加入门派=P1","加入门派"};
	GameTools6_SelfTab[16] = {"无效","无效","无效","将本门派未学的心法学习","学心法"};
	GameTools6_SelfTab[17] = {"心法等级[1-119]","无效","无效","将本门派已学会的心法等级=P1","设置心法等级"};
	GameTools6_SelfTab[18] = {"无效","无效","无效","查询身上所有BUFF","查BUFF"};
	GameTools6_SelfTab[19] = {"MD编号[0-511]","无效","无效","查询P1的MD值","查MD"};
	GameTools6_SelfTab[20] = {"EX编号[0-1535]","无效","无效","查询P1的EX值","查EX"};
	GameTools6_SelfTab[21] = {"FLAG编号[0-319]","无效","无效","查询P1的FLAG值","查FLAG"};
	GameTools6_SelfTab[22] = {"WORLD编号[1-100]","无效","无效","查询P1的WORLD值","查WORLD"};
	GameTools6_SelfTab[23] = {"技能编号","无效","无效","学习技能编号=P1","学习技能"};
	GameTools6_SelfTab[24] = {"技能编号","无效","无效","删除技能编号=P1","删除技能"};
	GameTools6_SelfTab[25] = {"BUFFID","无效","无效","赋予BUFF=P1","加BUFF"};
	GameTools6_SelfTab[26] = {"BUFFID","无效","无效","删除BUFF=P1","删BUFF"};
	GameTools6_SelfTab[27] = {"无效","无效","无效","当前场景数据","查场景数据"};
	GameTools6_SelfTab[28] = {"场景ID","位置X","位置Z","传送到场景P1[P2,P3]位置处","换场景"};
	GameTools6_SelfTab[29] = {"MD编号[0-511]","设置的值","无效","设置P1的MD值","设MD"};
	GameTools6_SelfTab[30] = {"EX编号[0-1535]","设置的值","无效","设置P1的EX值","设EX"};
	GameTools6_SelfTab[31] = {"FLAG编号[0-319]","设置的值[0-1]","无效","设置P1的FLAG值","设FLAG"};
	GameTools6_SelfTab[32] = {"WORLD编号[1-100]","设置的值","无效","设置P1的WORLD值","设WORLD"};
	GameTools6_SelfTab[33] = {"无效","无效","无效","设置玩家拥有超级BT属性","GM超级属性"};
	GameTools6_SelfTab[34] = {"无效","无效","无效","选择后点击确定","获取GM状态"};
	GameTools6_SelfTab[35] = {"P1珍兽ID","P2五维资质","P3成长率","选择后点击确定","领取宠物"};
	GameTools6_SelfTab[36] = {"无效","无效","无效","选择后点击确定","恢复血蓝气怒"};
	GameTools6_SelfTab[37] = {"无效","无效","无效","选择后点击确定","清空角色全部技能冷却"};
	--==========自己 结束==========
	
	g_UIPos = GameTools6_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function GameTools6_OnEvent(event)
	if event == "UI_COMMAND" then
		local UIID = tonumber(arg0);
		if UIID == 316022021 then
			if not this:IsVisible() then
				GameTools6_Select_Clicked(1);
				this:Show();
				if GameTools6_SelectShowServer:GetCheck() == 1 then
					GameTools6_SelectShowServer:SetCheck(0);
				end
				GameTools6_SelectShowServer_Clicked()
			end
		elseif UIID == 316022022 then
			if this:IsVisible() then
				if Get_XParam_INT(0) == UIID then
					GameTools6_CurName,GameTools6_CurGuid = Get_XParam_STR(0),Get_XParam_STR(1);
					GameTools6_SetCheck(2);
				end
			end
		elseif UIID == 707022021 then
			if this:IsVisible() then
				if GameTools6_SelectObject == 2 then
					if GameTools6_CurGuid == "" then
						return
					end
				end
				if arg1 == arg0 then
					GameTools6_EditBoxTab[1]:SetText(arg2);
					GameTools6_EditBoxTab[2]:SetText(arg3);
				elseif tonumber(arg1) == 881122334 then
					GameTools6_EditBoxTab[1]:SetText(arg2);
				end
			end
		end
	elseif event == "NEW_DEBUGMESSAGE" then
		if this:IsVisible() then
			GameTools6_GetInfo()
		end
	elseif event == "MAINTARGET_CHANGED" then
		if this:IsVisible() and GameTools6_SelectObject == 2 then
			if Target:IsPresent() then
				local int1 = tonumber(arg0);
				if int1 and int1 >= 15000 then
					int2 = GetTargetPlayerGUID();
					if int2 and int2 > 100000000 then
						local str1 = Target:GetName();
						local str2 = string.format("%.7X",int2);
						GameTools6_EditBoxTab[1]:SetText(str1);
						GameTools6_EditBoxTab[2]:SetText(str2);
					end
				end
			end
		end
	elseif event == "CHAT_SHOWUSERINFO" then
		if this:IsVisible() and GameTools6_SelectObject == 2 then
			local str1 = tostring( DataPool:GetFriend( "chat", "ID_TEXT" ) );
			if str1 and str1 ~= "" then
				local int1 = tonumber(str1,16);
				if int1 and int1 > 100000000 then
					GameTools6_EditBoxTab[1]:SetText(DataPool:GetFriend( "chat", "NAME"  ));
					GameTools6_EditBoxTab[2]:SetText(str1);
				end
			end
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		GameTools6_Frame:SetProperty("UnifiedPosition", g_UIPos)
	end
end

--===============================================
--打开物品搜索界面
--===============================================
function GameTools6_Loadini_Clicked()
	-- PushEvent("UI_COMMAND",707022022);
	
	local yPos = GameTools6_Frame:GetProperty("AbsoluteYPosition")
	local xPos = GameTools6_Frame:GetProperty("AbsoluteXPosition")
	local nWidth = GameTools6_Frame:GetProperty("AbsoluteWidth")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenGameMasterControl_ItemSearch" );
		Set_XSCRIPT_ScriptID(199998);	
		Set_XSCRIPT_Parameter(0,tonumber(xPos)-tonumber(nWidth));
		Set_XSCRIPT_Parameter(1,tonumber(yPos));
		Set_XSCRIPT_ParamCount(2);	
	Send_XSCRIPT()
	
end
function GameTools6_Close_Clicked()
	GameTools6_CurName,GameTools6_CurGuid = "","";
	GameTools6_SelectObject = 1;
	GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
	this:Hide();
end

function GameTools6_SelectShowServer_Clicked()
	if GameTools6_SelectShowServer:GetCheck() == 0 then
		GameTools6_CallBk:Hide();
		GameTools6_Frame:SetProperty("AbsoluteHeight",612);
	else
		GameTools6_CallBk:Show();
		GameTools6_Frame:SetProperty("AbsoluteHeight",680);
	end
end

function GameTools6_ServerCallOne()
	GameTools6_Oncd:Show();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GameMasterControl_ServerCallOne")
		Set_XSCRIPT_ScriptID(199998)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function GameTools6_ServerCallTwo()
	GameTools6_Oncd:Show();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GameMasterControl_ServerCallTwo")
		Set_XSCRIPT_ScriptID(199998)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function GameTools6_ClientCallOne()
	PushDebugMessage("此项目修改时开放的")
end

function GameTools6_ClientCallTwo()
	-- PushEvent("UI_COMMAND",426022021);
	PushDebugMessage("此项目修改时开放的")
end

function GameTools6_Use_Clicked()
	if GameTools6_SelectProjectIdx < 1 then
		PushDebugMessage("请选中操作项目")
		return
	end
	local tab1;
	local str1 = "GameMasterControl_AllUse"
	if GameTools6_SelectObject == 1 then
		str1 = "GameMasterControl_SelfUse"
		tab1 = GameTools6_SelfTab[GameTools6_SelectProjectIdx];
	elseif GameTools6_SelectObject == 2 then
		str1 = "GameMasterControl_TarUse"
		tab1 = GameTools6_TarTab[GameTools6_SelectProjectIdx];
	else
		tab1 = GameTools6_AllTab[GameTools6_SelectProjectIdx];
	end
	local tab2 = {0,0,0};
	local int1
	for i,j in GameTools6_EditBoxTab do
		j:SetProperty("DefaultEditBox","False");
		if tab1[i] ~= "无效" then
			int1 = tonumber(j:GetText());
			if not int1 then
				msg = "P"..i.."输入不正确，请检查。"
				PushDebugMessage(msg)
				j:SetProperty("DefaultEditBox","True");
				return
			end
			tab2[i] = int1;
		end
	end
	GameTools6_Oncd:Show();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name(str1)
		Set_XSCRIPT_ScriptID(199998)
		Set_XSCRIPT_Parameter(0,GameTools6_SelectProjectIdx )
		for i = 1,3 do
			Set_XSCRIPT_Parameter(i,tab2[i] );
		end
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function GameTools6_AddTar_Clicked()
	if GameTools6_SelectObject == 2 then
		local str1 = GameTools6_EditBoxTab[1]:GetText();
		local str2 = GameTools6_EditBoxTab[2]:GetText();
		local int1 = string.len(str1);
		local int2 = string.len(str2);
		if int1 == 0 then
			PushDebugMessage("请输入角色名")
			return
		elseif int1 > 12 then
			PushDebugMessage("该角色名非法，如目标确认是该名字时，请尽快用代码执行区进行封号")
			return
		elseif int2 ~= 7 then
			PushDebugMessage("请输入16进GUID");
			return
		end
		local str3 = str2..str1;
		GameTools6_Oncd:Show();
		NewUserCard(str3,-1,0);
	end
end

function GameTools6_Select_Clicked(Par)
	GameTools6_SelectObject = Par;
	if Par == 1 then
		GameTools6_SelectSelf:SetCheck(1);
		GameTools6_SelectTar:SetCheck(0);
		GameTools6_SelectAll:SetCheck(0);
		GameTools6_CurName = Player:GetName();
		GameTools6_CurGuid = string.format("%.8X",Player:GetGUID());
		GameTools6_SetCheck(1)
	elseif Par == 2 then
		GameTools6_SelectSelf:SetCheck(0);
		GameTools6_SelectTar:SetCheck(1);
		GameTools6_SelectAll:SetCheck(0);
		GameTools6_SetCheck(0)
	else
		GameTools6_SelectSelf:SetCheck(0);
		GameTools6_SelectTar:SetCheck(0);
		GameTools6_SelectAll:SetCheck(1);
		GameTools6_CurName = "所有在线角色";
		GameTools6_CurGuid = "";
		GameTools6_SetCheck(1)
	end
end

function GameTools6_SetCheck(Par)
	local str0 = "";
	if Par > 0 then
		GameTools6_Use:Enable();
		if Par == 1 then
			GameTools6_AddTar:Disable();
		else
			str0 = string.format("#B添加目标成功。\n角色名[%s]\nGUID[%s]\n确认无误后可选择项目对该目标进行操作。",GameTools6_CurName,GameTools6_CurGuid)
			GameTools6_AddTar:Enable();
		end
		GameTools6_Server1:Enable();
		GameTools6_Server2:Enable();
		GameTools6_Client1:Enable();
		GameTools6_Client2:Enable();
		for i,j in GameTools6_EditBoxTab do
			j:SetProperty("DefaultEditBox","False");
			j:SetText("");
			j:Disable();
			GameTools6_EditBoxTabRed[i]:Show();
		end
		local tab1 = GameTools6_SelfTab;
		if GameTools6_SelectObject == 2 then
			tab1 = GameTools6_TarTab;
		elseif GameTools6_SelectObject == 3 then
			tab1 = GameTools6_AllTab;
		end
		GameTools6_SelectBox:SetText("选择将要操作的项目")
		GameTools6_SelectBox:ResetList();
		for i,j in tab1 do
			if i < 10 then
				GameTools6_SelectBox:AddTextItem("["..i.."]           【"..j[5].."】",i);
			elseif i < 100 then
				GameTools6_SelectBox:AddTextItem("["..i.."]          【"..j[5].."】",i);
			else
				GameTools6_SelectBox:AddTextItem("["..i.."]         【"..j[5].."】",i);
			end
		end
	else
		str0 = "#B自动获取信息：选中目标(没有自动填充的话切换下目标即可)或聊天窗查看他人角色资料可自动填充输入\n输入信息：P1输入角色名，P2输入角色的GUID"
		GameTools6_CurName = "";
		GameTools6_CurGuid = "";
		GameTools6_Use:Disable();
		GameTools6_Server1:Disable();
		GameTools6_Server2:Disable();
		GameTools6_Client1:Disable();
		GameTools6_Client2:Disable();
		GameTools6_AddTar:Enable();
		for i,j in GameTools6_EditBoxTab do
			j:SetText("");
			j:SetProperty("DefaultEditBox","False");
			if i ~= 3 then
				j:Enable();
				GameTools6_EditBoxTabRed[i]:Hide();
			else
				j:Disable();
				GameTools6_EditBoxTabRed[i]:Show();
			end
		end
		GameTools6_SelectBox:SetText("请先添加目标")
		GameTools6_SelectBox:ResetList();
	end
	GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
	local str1 = GameTools6_CurName ~= "" and "#G"..GameTools6_CurName or "#cff0000尚未添加目标";
	local str2 = "#cFF00FF目标："..str1;
	local str3 = GameTools6_CurGuid ~= "" and str2.."|"..GameTools6_CurGuid.."#cff0000(重要)" or str2.."#cff0000(重要)";
	GameTools6_SelectTip:SetText(str3);
	GameTools6_SetTipBox(str0);
end

function GameTools6_SetTipBox(Par)
	GameTools6_TipBox:SetText(Par);
end

function GameTools6_GetInfo()
	if arg0 == "FJQHGM" then
		GameTools6_Info = {};
	elseif arg0 == "FJQHTOOL" then
		local str1 = table.concat(GameTools6_Info);
		GameTools6_SetTipBox(GameTools6_SelectProjectInfo.."\n=====操作结果=====\n"..str1);
		GameTools6_Info = {};
	elseif string.sub(arg0,1,6) == "FJQHGM" then
		local str1 = string.sub(arg0,7,-1)
		table.insert(GameTools6_Info,str1)
	end
end

function GameTools6_SelectBox_Clicked()
	local _,int1 = GameTools6_SelectBox:GetCurrentSelect();
	if int1 < 1 or int1 == GameTools6_SelectProjectIdx then
		return
	end
	local tab1;
	if GameTools6_SelectObject == 1 then
		tab1 = GameTools6_SelfTab[int1];
	elseif GameTools6_SelectObject == 2 then
		if GameTools6_CurGuid == "" then
			return
		end
		tab1 = GameTools6_TarTab[int1];
	else
		tab1 = GameTools6_AllTab[int1];
	end
	if not tab1 then
		return
	end
	GameTools6_SelectProjectIdx = int1;
	GameTools6_SelectProjectInfo = "#W对目标：#G["..GameTools6_CurName.."]#W进行\n#B【"..tab1[5].."#B】\n";
	for i,j in GameTools6_EditBoxTab do
		j:SetProperty("DefaultEditBox","False");
		GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#cfff263P"..i
		if tab1[i] == "无效" then
			j:SetText("无效");
			j:Disable();
			GameTools6_EditBoxTabRed[i]:Show();
			GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#cFF0000无效\n";
		else
			j:SetText("");
			j:Enable();
			GameTools6_EditBoxTabRed[i]:Hide();
			GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#W"..tab1[i].."\n";
		end
	end
	GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#B"..tab1[4];
	GameTools6_SetTipBox(GameTools6_SelectProjectInfo)
end

function GameTools6_FrameClose()
	GameTools6_SelectBox:ResetList();
	GameTools6_CurName,GameTools6_CurGuid = "","";
	GameTools6_SelectObject = 1;
	GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
	GameTools6_Info = {};
end