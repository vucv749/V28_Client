--ShenbingGuideLetter界面
local g_ShenbingGuideLetter_Frame_UnifiedXPosition;
local g_ShenbingGuideLetter_Frame_UnifiedYPosition;
local ShenbingGuideLetter_g_zidonxunlu1 = 89027202 --神兵副武器 自动寻路
local ShenbingGuideLetter_g_npc1 ={
	posX = 228,
	posZ = 103,
	sceneid = 2,
	Name = "欧冶安",
}
local ShenbingGuideLetter_g_npc2 ={
	posX = 245,
	posZ = 59,
	sceneid = 2,
	Name = "萧峰",
}
local ShenbingGuideLetter_g_npc3 ={
	posX = 245,
	posZ = 56,
	sceneid = 2,
	Name = "扫地神僧",
}
local ShenbingGuideLetter_g_OnpenUI = 89027302 --快捷路口打开此界面
local ShenbingGuideLetter_g_MF1 = 955 --引导任务一
local ShenbingGuideLetter_g_MF2 = 956 --引导任务二
local ShenbingGuideLetter_g_ShenbingJuqingMissionId = 2220 --神兵剧情任务
local ShenbingGuideLetter_g_curYe = 1 --1是神兵引导任务 2是神兵剧情任务
local ShenbingGuideLetter_g_isRedPoint1 = 0 --神兵副武器引导任务是否显示红点
local ShenbingGuideLetter_g_isRedPoint2 = 0 --神兵剧情任务是否显示红点
local ShenbingGuideLetter_g_isFinish7Mission = 0 --是否完成七个引导任务
local ShenbingGuideLetter_g_isFinishYD1 = 0 --是否完成引导任务一
local ShenbingGuideLetter_g_isFinishJQ1 = 0 --是否完成剧情任务一
local ShenbingGuideLetter_g_isLonMen = 0


--local ShenbingGuideLetter_g_ShowHelp = 89027402 --神兵古卷 打开帮助对话框

--===============================================
-- PreLoad()
--===============================================
function ShenbingGuideLetter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--===============================================
-- OnLoad()
--===============================================
function ShenbingGuideLetter_OnLoad()
	-- 保存界面的默认相对位置
	g_ShenbingGuideLetter_Frame_UnifiedXPosition	= ShenbingGuideLetter_Frame:GetProperty("UnifiedXPosition");
    g_ShenbingGuideLetter_Frame_UnifiedYPosition	= ShenbingGuideLetter_Frame:GetProperty("UnifiedYPosition");
end

--===============================================
-- OnEvent()
--===============================================
function ShenbingGuideLetter_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == ShenbingGuideLetter_g_OnpenUI) then
		local isLonmen = Get_XParam_INT(0)
		ShenbingGuideLetter_g_isLonMen = isLonmen
		if isLonmen == 1 then--是龙门 到时候测试特殊更新服务器脚本传1
			ShenbingGuideLetter_Btn2:Disable()
		else
			ShenbingGuideLetter_Btn2:Enable()
		end
		ShenbingGuideLetter_g_isFinish7Mission = Get_XParam_INT(1)
		ShenbingGuideLetter_g_isFinishYD1 = Get_XParam_INT(2)
		ShenbingGuideLetter_g_isFinishJQ1 = Get_XParam_INT(3)
		this:Show();
		ShenbingGuideLetter_g_isRedPoint1 = 0--这里是点击18号快捷入口，两个红点都关闭
		ShenbingGuideLetter_g_isRedPoint2 = 0
		ShenbingGuideLetter_Update()
		ShenbingGuideLetter_RedPoint()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == ShenbingGuideLetter_g_zidonxunlu1) then
		local xunluOrRedPoint = Get_XParam_INT(0)
		if xunluOrRedPoint == 1 then
			ShenbingGuideLetter_AutoRun()
		elseif xunluOrRedPoint == 0 then
			ShenbingGuideLetter_g_isRedPoint1 = 1 --神兵副武器引导任务红点开
			ShenbingGuideLetter_RedPoint()
		elseif xunluOrRedPoint == 2 then
			ShenbingGuideLetter_g_isRedPoint1 = 0 --神兵副武器引导任务红点关
			ShenbingGuideLetter_RedPoint()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99839601) then--神兵剧情任务用
		local param = Get_XParam_INT(0)
		local nOpen = Get_XParam_INT(1)
		local nRedPoint = Get_XParam_INT(2)		
		if param == 0 then
			--关闭界面
			ShenbingGuideLetter_OnHiden()
		else
			if nRedPoint == 1 then
				ShenbingGuideLetter_g_isRedPoint2 = 0
				ShenbingGuideLetter_RedPoint()	
			else
				ShenbingGuideLetter_g_isRedPoint2 = 0
				ShenbingGuideLetter_RedPoint()	
			end
			if param == 1 then--打开界面
				this:Show()
				ShenbingGuideLetter_Update()
			elseif param == 2 then--自动寻路：找npc
				ShenbingGuideLetter_MengQianChenGoToFindNpc()
			elseif param == 3 then
			end
		end
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		ShenbingGuideLetter_UpdateUIPos()
	elseif ( event == "ADJEST_UI_POS" ) then
		ShenbingGuideLetter_UpdateUIPos()
	end
end
--关闭界面
function ShenbingGuideLetter_OnHiden()
	ShenbingGuideLetter_g_curYe = 1
	ShenbingGuideLetter_g_isRedPoint1=0
	ShenbingGuideLetter_g_isRedPoint2=0
	ShenbingGuideLetter_g_isFinish7Mission =0
	ShenbingGuideLetter_g_isFinishYD1 = 0
	ShenbingGuideLetter_g_isFinishJQ1 = 0
	ShenbingGuideLetter_g_isLonMen = 0
	ShenbingGuideLetter_background1:SetProperty("Image","ShenbingGuide image:Letter_zts");
	this:Hide()
end
--分页按钮
function ShenbingGuideLetter_OnFenYeClicked(index)
	ShenbingGuideLetter_g_curYe = index
	ShenbingGuideLetter_Update()
end
--刷新界面
function ShenbingGuideLetter_Update()
	--分页按钮状态初始化
	ShenbingGuideLetter_Btn1:Show();
	ShenbingGuideLetter_Btn2:Show();
	ShenbingGuideLetter_Btn1:SetCheck(0);
	ShenbingGuideLetter_Btn2:SetCheck(0);
	--根据任务完成情况控制之后的界面显示
	if ShenbingGuideLetter_g_isFinishYD1 == 1 then
		ShenbingGuideLetter_Btn1:Hide()
		ShenbingGuideLetter_g_curYe = 2
	elseif ShenbingGuideLetter_g_isFinishJQ1 == 1 then
		ShenbingGuideLetter_Btn2:Hide()
		ShenbingGuideLetter_g_curYe = 1
	end
	if ShenbingGuideLetter_g_curYe == 1 then
		ShenbingGuideLetter_Btn1:SetCheck(1);
	elseif ShenbingGuideLetter_g_curYe == 2 then
		ShenbingGuideLetter_Btn2:SetCheck(1);
	end
	--界面显示
	if ShenbingGuideLetter_g_curYe == 1 then
		--显示神兵副武器引导任务界面
		ShenbingGuideLetter_background1:SetProperty("Image","set:ShenbingGuide image:Letter_zts");
		if ShenbingGuideLetter_g_isFinish7Mission == 0 then
			ShenbingGuideLetter_QianWang:Show()
		else
			ShenbingGuideLetter_QianWang:Hide()
		end
		--隐藏神兵剧情任务引导界面
		ShenbingGuideLetter_QianWang2:Hide()
	elseif ShenbingGuideLetter_g_curYe == 2  then
		--隐藏神兵副武器引导任务界面
		ShenbingGuideLetter_QianWang:Hide()
		--显示神兵剧情任务引导界面
		ShenbingGuideLetter_background1:SetProperty("Image","set:ShenbingGuide image:Letter_sds");
		ShenbingGuideLetter_QianWang2:Show()
		if ShenbingGuideLetter_g_isLonMen == 1 then--在龙门上，并且完成了引导任务一
			ShenbingGuideLetter_Btn2:SetCheck(0)
			ShenbingGuideLetter_Btn2:Disable()
			ShenbingGuideLetter_QianWang2:Hide()
			ShenbingGuideLetter_QianWang:Hide()
			ShenbingGuideLetter_background1:SetProperty("Image","set:ShenbingGuide image:Letter_zts");
		end
	end
end
--刷新红点
function ShenbingGuideLetter_RedPoint()
	--红点
	if ShenbingGuideLetter_g_isRedPoint2 == 1 or ShenbingGuideLetter_g_isRedPoint1 == 1 then--两个有一个满足红点需求就出红点
		Lua_ShowQuickEnterPointTip(18, 1)
	else
		Lua_ShowQuickEnterPointTip(18, 0)
	end
end
--自动寻路 前往按钮
function ShenbingGuideLetter_Clicked()
	if ShenbingGuideLetter_g_isFinishYD1 ~= 1 then
		AutoRuntoTargetExWithName(ShenbingGuideLetter_g_npc1.posX, ShenbingGuideLetter_g_npc1.posZ, ShenbingGuideLetter_g_npc1.sceneid, ShenbingGuideLetter_g_npc1.Name)
		PushDebugMessage("#{SQYD_230802_107}")
	end
	ShenbingGuideLetter_OnHiden()
end
--适应屏幕变化
function ShenbingGuideLetter_UpdateUIPos()
	ShenbingGuideLetter_Frame:SetProperty("UnifiedXPosition", g_ShenbingGuideLetter_Frame_UnifiedXPosition);
	ShenbingGuideLetter_Frame:SetProperty("UnifiedYPosition", g_ShenbingGuideLetter_Frame_UnifiedYPosition);
end
-----合并界面新增------
--神兵剧情任务引导点击前往按钮
function ShenbingGuideLetter_MengQianChenClicked()
	if ShenbingGuideLetter_g_isLonMen == 1 then
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GotoFindNpc");
		Set_XSCRIPT_ScriptID(998388);
		--Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end
--神兵剧情任务引导响应：通过server判断，可以寻路找npc
function ShenbingGuideLetter_MengQianChenGoToFindNpc()
	AutoRuntoTargetExWithName(277, 151, 3, "萧峰")
	ShenbingGuideLetter_OnHiden()
end