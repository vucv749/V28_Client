-- 快捷功能入口  dujm
-----------------------------------------------------------------------------
--Notice
--客户端接口
--Lua_IsShowQuickEnterPointTip,Lua_ShowQuickEnterPointTip     动态小红点显隐
--Lua_IsShowQuickEnterPointFresh,Lua_ShowQuickEnterPointFresh 动态浮动tips显隐
--Lua_IsShowQuickEnter,Lua_ShowQuickEnter                     动态button显隐 ！！！这个默认是显示的，只有在活动时间内，有需求动态隐藏的功能才调用，不然不需要调用
--服务器接口
--LuaFnUpdateQuickEnter 		button显隐
--LuaFnUpdateQuickEnterTips 	红点显隐
--LuaFnUpdateQuickEnterFresh 	浮动tips显隐
--增加新功能需要做什么？
--程序只需要在 PlayerQuicklyEnter_Clicked 函数中显示click事件即可，时间和等级不需要判断，浮动tips，按钮tips都是配表实现。
--Click事件的index为表中ID( ID也是XML文件里的控件后缀) 
--表ID不需要连续，目的是支持功能先后上外网的情况。

-----------------------------------------------------------------------------
local playerQuicklyEnterUI          = {}	-- UI名称
local playerQuicklyEnterAnimateBtn  = {}	-- 动态提示按钮 
local g_RedPoint                    = {}

local BkSize = {
	[1] = {45,49},  -- 1024x768分辨率下的frame尺寸
	[2] = {45,49},  -- 非1024x768分辨率以上的frame尺寸
} 
local ArraySize = {
	[1] = {19.5,42},--{15.4,33.1},  -- 1024x768分辨率下的frame尺寸
	[2] = {19.5,42},--{20,43},  -- 非1024x768分辨率以上的frame尺寸
}

local g_nScreenWidthLimit = 1280 
local g_nButtonCount = 0
local g_bIsFlex = 0 
local g_FlexTips = { 
} 
local g_nScreenWidth =0
local g_nScreenHeight = 0
local nChangeSceneCount = 0
local nChangeSceneCheck = 0
--**********************************
-- PRELOAD
--**********************************
function PlayerQuicklyEnter_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD" );	-- 进入world
	this:RegisterEvent("UNIT_LEVEL");				-- 升级   
	this:RegisterEvent("HIDE_THIS_UI")				-- 隐藏界面
	this:RegisterEvent("RESET_ALLUI")				-- 返回登录界面, 重置所有UI 
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false);	-- 游戏分辨率发生了变化
	this:RegisterEvent("UI_COMMAND")				-- 界面 
	this:RegisterEvent("UPDATE_QUICK")				-- 按钮 
	this:RegisterEvent("UPDATE_QUICKTIPS")			-- 红点
	this:RegisterEvent("UPDATE_QUICKFRESH")			-- freshtips 
end

--**********************************
-- ONLOAD
--**********************************
function PlayerQuicklyEnter_OnLoad()
	g_nButtonCount 	= GetPlayerQuickEnterCount()
	local g_Flex	= GetPlayerQuickEnterHide() 

	if type(g_Flex)  ~= "table" then
		return
	end 
	-- BK 
	for i=1,g_nButtonCount do
		local nCtlidx = g_Flex[i].ID 
		if g_Flex[i].IsOpen == 0 and _G["PlayerQuicklyEnter_Bk"..nCtlidx] == nil then
			continue;
		end
        playerQuicklyEnterUI[nCtlidx]         =  _G["PlayerQuicklyEnter_Bk"..nCtlidx]
        playerQuicklyEnterAnimateBtn[nCtlidx] =  _G["PlayerQuicklyEnter_Image"..nCtlidx]
		g_RedPoint[nCtlidx] 				  =  _G[string.format("PlayerQuicklyEnter_Image%d_Tips",nCtlidx)]   
		assert(playerQuicklyEnterUI[nCtlidx] ~= nil)
		assert(playerQuicklyEnterAnimateBtn[nCtlidx] ~= nil)
		assert(g_RedPoint[nCtlidx] ~= nil) 
	end  
end

--**********************************
-- ONEvent
--**********************************
function PlayerQuicklyEnter_OnEvent( event )
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	-- 切换场景特殊处理
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		-- 解决按钮切场景闪烁问题
		nChangeSceneCount = nChangeSceneCount + 1
		if ( nChangeSceneCount <= 1 ) then
			g_bIsFlex = 0  
			PlayerQuicklyEnter_UpdateUI()
		end
	elseif ( event == "HIDE_THIS_UI" ) then
		if this:IsVisible() then
			this:Hide() 
		end 
	elseif ( event == "RESET_ALLUI" ) then
		nChangeSceneCount = 0;
		nChangeSceneCheck = 0;
		CloseFreshManGuide() 
		-- 关闭所有按钮的闪烁
		for	i = 1, table.getn( g_RedPoint ) do
			g_RedPoint[i]:Hide()
		end 
		this:Hide() 
	elseif event == "UNIT_LEVEL" then 
		PlayerQuicklyEnter_UpdateUI()
	elseif event == "UPDATE_QUICK" then 
		PlayerQuicklyEnter_UpdateUI()
	elseif event == "UPDATE_QUICKTIPS" then 
		PlayerQuicklyEnter_UpdateUI()
	elseif event == "UPDATE_QUICKFRESH" then 
		PlayerQuicklyEnter_UpdateUI()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then 
		PlayerQuicklyEnter_UpdateUIPos() 
	end
end
  
--**********************************
-- UI布局更新
--**********************************
function PlayerQuicklyEnter_UpdateUI() 
	
	--先判定一下游戏是否在主流程，并且自己是否有效
	if(Player:IsVaild() ~= 1 ) then
		return
	end 

	if g_bIsFlex == 1 then
		--PlayerQuicklyEnter_Open:Show()
		--PlayerQuicklyEnter_Close:Hide()
	else
		--PlayerQuicklyEnter_Open:Hide()
		--PlayerQuicklyEnter_Close:Show()
	end 
	--打开按钮Tips
	PlayerQuicklyEnter_OpenButton_Tips:Hide() 
	for i = 1,g_nButtonCount do
		g_FlexTips[i] = ""
	end 

	local g_Flex	= GetPlayerQuickEnterHide()
	if type(g_Flex) ~= "table" then
		return
	end  

	for i = 1,g_nButtonCount do
		local nCtlidx = g_Flex[i].ID 
		if g_bIsFlex == 1 and g_Flex[i].IsOpen == 1 and g_Flex[i].CanHide == 1 and g_Flex[i].FlashOnHide == 1 and Lua_IsShowQuickEnterPointTip(nCtlidx) == 1 then
			PlayerQuicklyEnter_OpenButton_Tips:Show() 
			if g_Flex[i].TipsOnHide == 1 and g_Flex[i].TipsPriority > 0 then
				g_FlexTips[g_Flex[i].TipsPriority] = g_Flex[i].HideTipsStr
			end 
		end
	end 
	local OpenTips = "" 
	for i = 1,g_nButtonCount do
		if g_FlexTips[i] ~= "" then
			OpenTips = OpenTips..g_FlexTips[i]
			break
		end
	end 

	PlayerQuicklyEnter_OpenButton:SetToolTip(OpenTips) 

	--设置各个功能坐标
	PlayerQuicklyEnter_UpdateUIPos()
	
	if g_nButtonCount > 0 then
		this:Show();
	end

	PlayerQuicklyEnter_Update_JiNianHua(20)
end
 
--**********************************
-- UI位置
--**********************************
function PlayerQuicklyEnter_UpdateUIPos() 

	local nNextIndex = g_nButtonCount
	local nSizeIndex = 1
	if ( g_nScreenWidth <= g_nScreenWidthLimit ) then
		nSizeIndex = 1
	else
		nSizeIndex = 2
	end

	local nMinimapWidth
	if 1 == 1 then --SystemSetup:IsClassic()
    	nMinimapWidth = 245
    end

	-- Frame
	PlayerQuicklyEnter_Frame:SetProperty( "UnifiedPosition", "{{1.000000, "..tostring(-1 * ( nNextIndex + 1 ) * BkSize[nSizeIndex][1] - nMinimapWidth).."},{0.000000,3}}" )
	PlayerQuicklyEnter_Frame:SetProperty( "AbsoluteSize", "w:"..( nNextIndex + 1 ) * BkSize[nSizeIndex][1].." h:"..BkSize[nSizeIndex][2].."" )
	
	--Lua_TDU_Log("PlayerQuicklyEnter_Frame UnifiedPosition: "..PlayerQuicklyEnter_Frame:GetProperty("UnifiedPosition"))
	--Lua_TDU_Log("PlayerQuicklyEnter_Frame AbsoluteSize: "..PlayerQuicklyEnter_Frame:GetProperty("AbsoluteSize"))

	PlayerQuicklyEnter_Open:SetProperty( "UnifiedPosition", "{{0.000000,"..nNextIndex * BkSize[nSizeIndex][1].."},{0.500000,-21}}" )
	PlayerQuicklyEnter_Open:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
	PlayerQuicklyEnter_OpenButton:SetProperty( "UnifiedSize", "{{0.000000,"..ArraySize[nSizeIndex][1].."},{0.000000,"..ArraySize[nSizeIndex][2].."}}" ) 

	PlayerQuicklyEnter_Close:SetProperty( "UnifiedPosition", "{{0.000000,"..nNextIndex * BkSize[nSizeIndex][1].."},{0.500000,-21}}" )
	PlayerQuicklyEnter_Close:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
	PlayerQuicklyEnter_CloseButton:SetProperty( "UnifiedSize", "{{0.000000,"..ArraySize[nSizeIndex][1].."},{0.000000,"..ArraySize[nSizeIndex][2].."}}" ) 

	local g_Flex	= GetPlayerQuickEnterHide()
	if type(g_Flex) ~= "table" then
		return
	end  

	for i = 1, g_nButtonCount do
		local nCtlidx = g_Flex[i].ID 
		if g_Flex[i].IsOpen == 0 then
			if playerQuicklyEnterUI[nCtlidx] ~= nil then
				playerQuicklyEnterUI[nCtlidx]:Hide()
			end
			continue
		end 
		
		local isshow = 	g_Flex[i].IsShow	
		local IsShowQuickEnter =  Lua_IsShowQuickEnter(nCtlidx)
		--Lua_TDU_Log("nCtlidx"..nCtlidx);
		--Lua_TDU_Log("isshow"..isshow);
		--Lua_TDU_Log("IsShowQuickEnter"..IsShowQuickEnter);

		--控件显隐
		if g_Flex[i].IsShow == 1 and (g_bIsFlex == 0 or (g_bIsFlex == 1 and (g_Flex[i].CanHide == 0))) and Lua_IsShowQuickEnter(nCtlidx) == 1 then
			nNextIndex = nNextIndex - 1
			-- BK
			playerQuicklyEnterUI[nCtlidx]:Show()
			playerQuicklyEnterUI[nCtlidx]:SetProperty( "UnifiedPosition", "{{0.000000,"..nNextIndex * BkSize[nSizeIndex][1].."},{0.000000,0}}" )
			playerQuicklyEnterUI[nCtlidx]:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
			
			-- Image
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetToolTip(g_Flex[i].TipsStr) 
			
		else
			playerQuicklyEnterUI[nCtlidx]:Hide()
		end 

		--红点显隐
		if Lua_IsShowQuickEnterPointTip(nCtlidx) == 1 and playerQuicklyEnterUI[nCtlidx]:IsVisible() then
			g_RedPoint[nCtlidx]:Show()
		elseif Lua_IsShowQuickEnterPointTip(nCtlidx) == 0 then
			g_RedPoint[nCtlidx]:Hide()
		end 

		--fresh显隐
		if Lua_IsShowQuickEnterPointFresh(nCtlidx) == 1 and playerQuicklyEnterUI[nCtlidx]:IsVisible() then  
			local fx, fy = this:GetChildOffset("PlayerQuicklyEnter_Bk"..nCtlidx);
			--Lua_TDU_Log("PlayerQuicklyEnter_Bk GetChildOffset: fx:"..fx.."   fy:"..fy)
			OpenFreshManGuide( 1, nCtlidx, fx + 12, fy + 45, "PlayerQuicklyEnter", "northeast" );
			Lua_ShowQuickEnterPointFresh(nCtlidx, 0)
		end 

	end	 
end 
  
--**********************************
-- 按钮事件
--**********************************
function PlayerQuicklyEnter_Clicked( nIndex )
	local nChk = PlayerQuickEnterClickCheck(nIndex)
	if  nChk == nil or nChk == 0 then
		PlayerQuicklyEnter_UpdateUI()
		return
	end	
	if ( nIndex == 1 ) then   --扫荡
		local nPlayerLevel = Player:GetData("LEVEL")
		if nPlayerLevel < 15 then
			if ( IsWindowShow( "SweepAll" ) ) then
				CloseWindow( "SweepAll", true );
				return
			end
		end	
		OpenSecKillList();
	elseif (nIndex == 2 ) then --周活跃
		local nPlayerLevel = Player:GetData("LEVEL")
		if nPlayerLevel < 35 then
			PushDebugMessage("#{ZLSJ_231106_116}")
			return 
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenUI");
			Set_XSCRIPT_ScriptID(800121);
			Set_XSCRIPT_Parameter(0, 0 )
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenUI")
			Set_XSCRIPT_ScriptID(998526)
			Set_XSCRIPT_Parameter(0, 1 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	elseif (nIndex == 3 ) then  --英雄归来
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnOpenUI" ); 		-- 脚本号
			Set_XSCRIPT_ScriptID( 808110 );						-- 脚本编号
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
		Send_XSCRIPT()	
	elseif (nIndex == 4 )  then --参武道
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("UILogic")
			Set_XSCRIPT_ScriptID(891218)
			Set_XSCRIPT_Parameter( 0, 1 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	elseif (nIndex == 5 )  then --兽魂现
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenUI")
			Set_XSCRIPT_ScriptID(893040)
			Set_XSCRIPT_Parameter( 0, 1 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	elseif (nIndex == 6 )  then --鸣玉录
		if(IsWindowShow("PetSoul_FengHunLu")) then
			CloseWindow("PetSoul_FengHunLu", true)
			return
		end 
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "AskOpenMainUI" ); 	
			Set_XSCRIPT_ScriptID( 791010 );						-- 脚本编号
			Set_XSCRIPT_ParamCount( 0 );						-- 参数个数
		Send_XSCRIPT()
	elseif (nIndex == 7 )  then --新门派扶持
		if(IsWindowShow("ManTuo_Fuchi")) then
			CloseWindow("ManTuo_Fuchi", true)
			return
		end 
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnOpenGuanHuaiButton" ); 	
			Set_XSCRIPT_ScriptID( 888921 );						-- 脚本编号
			Set_XSCRIPT_ParamCount( 0 );						-- 参数个数
		Send_XSCRIPT()
	elseif (nIndex == 8 )  then --曼陀山寨预热任务
		if(IsWindowShow("ManTuo_Yure")) then
			CloseWindow("ManTuo_Yure", true)
			return
		end 
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIEvent" ); 	
			Set_XSCRIPT_ScriptID( 791060 )						-- 脚本编号
			Set_XSCRIPT_Parameter( 0, 4 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (nIndex == 10 )  then --主线剧情任务
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("UILogic")
			Set_XSCRIPT_ScriptID(890154)
			Set_XSCRIPT_Parameter( 0, 1 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	elseif (nIndex == 11 )  then --2023Q1不老长春谷预热任务
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnOpenUI")
			Set_XSCRIPT_ScriptID(890152)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif (nIndex == 12 )  then --打开阵营选择界面
		Lua_OpenShengWangChoose()
	elseif (nIndex == 13 )  then -- 战令
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "AskOpenMainUI" )
			Set_XSCRIPT_ScriptID( 890215 )
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif (nIndex == 14 )  then --2023Q2版本预热-此间相思
		if(IsWindowShow("CiJianXiangSi")) then
			CloseWindow("CiJianXiangSi", true)
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OpenUI" )
				Set_XSCRIPT_ScriptID( 998272 )
				Set_XSCRIPT_Parameter( 0, 3 )
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()			
			return
		end 		
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OpenUI" )
			Set_XSCRIPT_ScriptID( 998272 )
			Set_XSCRIPT_Parameter( 0, 1 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()		
	elseif (nIndex == 15 )  then
		--2023Q3版本预热-神兵预热
		if(IsWindowShow("ShenBing_Yure")) then
			CloseWindow("ShenBing_Yure", true)
			return
		end 		
		-- 1、领取奖励 2、自动寻路 3、帮助 4、请求打开主界面
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIEvent" )
			Set_XSCRIPT_ScriptID(791100)
			Set_XSCRIPT_Parameter(0, 4)					
			Set_XSCRIPT_Parameter(1, 0)				
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	-- elseif (nIndex == 16 )  then --2023Q380级神兵剧情任务
		-- if(IsWindowShow("MengQianChen")) then
			-- CloseWindow("MengQianChen", true)		
			-- return
		-- end 
		-- Clear_XSCRIPT()
			-- Set_XSCRIPT_Function_Name( "OpenUI" )
			-- Set_XSCRIPT_ScriptID( 998396 )
			-- Set_XSCRIPT_Parameter( 0, 1 )
			-- Set_XSCRIPT_ParamCount(1)
		-- Send_XSCRIPT()			
	elseif (nIndex == 17 )  then	
		if(IsWindowShow("QiXi_Activity")) then
			CloseWindow("QiXi_Activity", true)
			return
		end 		
		--七夕防流失整合界面
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnOpenUI")
			Set_XSCRIPT_ScriptID(998508)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif (nIndex == 18 )  then	--2023q3 神兵副武器系统引导设计
		if(IsWindowShow("ShenbingGuideLetter")) then
			CloseWindow("ShenbingGuideLetter", true)
			return
		end 		
		--神兵副武器系统引导设计 快捷入口界面
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenUI")
			Set_XSCRIPT_ScriptID(890273)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()	 
	elseif (nIndex == 19 )  then	--特色服
		if(IsWindowShow("TimingPlay")) then
			CloseWindow("TimingPlay", true)
			return
		end 		
		-- 
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenTeSeUI")
			Set_XSCRIPT_ScriptID(998517)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()	
	elseif (nIndex == 20 )  then	--嘉年华直播
		PlayerQuicklyEnter_Open_JiNianHua()
	elseif nIndex == 21 then
		--2023Q4时装随机宝箱
		if(IsWindowShow("Fashion_Box")) then
			CloseWindow("Fashion_Box", true)
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnOpenUI" )
			Set_XSCRIPT_ScriptID( 998531 )
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif nIndex == 22 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenZhengHeUI")
			Set_XSCRIPT_ScriptID(998526)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif nIndex == 23 then
		--新身份系统-引导任务
		if(IsWindowShow("Idetity_Guide")) then
			CloseWindow("Idetity_Guide", true)
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnOpenUI" )
			Set_XSCRIPT_ScriptID(998655)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif nIndex == 24 then--2024Q1preheat
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenMainUI")
			Set_XSCRIPT_ScriptID(998694)
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif nIndex == 25 then--飞凰礼
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnShowClientUI")
			Set_XSCRIPT_ScriptID(998584)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif nIndex == 26 then -- 【2024Q2】新版本预热-山重水复
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUIEvent")
			Set_XSCRIPT_ScriptID(998772)
			Set_XSCRIPT_Parameter(0, 4)
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif nIndex == 27 then--新任务引导
		PushEvent("UI_COMMAND", 99878902,1)
	elseif nIndex == 28 then--大话西游整合界面
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnOpenDaHuaXiYouActivity")
			Set_XSCRIPT_ScriptID(890364)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif (nIndex == 29) then	--大话预热
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnOpenDaHuaXiYouYuReActivity")
			Set_XSCRIPT_ScriptID(999406)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()		
	elseif (nIndex == 31) then	--大话预热
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenUI")
			Set_XSCRIPT_ScriptID(999441)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()	
	else
		return
	end
end 

function PlayerQuicklyEnter_Open_Clicked()
	g_bIsFlex = 0 
	PushEvent( "CLOSE_FRESHMAN_GUIDE" );
	PlayerQuicklyEnter_UpdateUI()  --所有按钮都在此处更新
end

function PlayerQuicklyEnter_Close_Clicked() 
	g_bIsFlex = 1
	PushEvent( "CLOSE_FRESHMAN_GUIDE" );
	PlayerQuicklyEnter_UpdateUI()  --所有按钮都在此处更新
end


function PlayerQuicklyEnter_Open_JiNianHua()
	
	GameProduceLogin:OpenURL(GetWeblink("WEB_JNHZB"))
end

function PlayerQuicklyEnter_Update_JiNianHua(nCtlidx)

	if playerQuicklyEnterUI[nCtlidx]:IsVisible() == false then
		return
	end

	--日期
	local curDay = tonumber(DataPool:GetServerDayTime());
	--时间
	local curTime = tonumber(DataPool:GetServerMinuteTime())

	if curDay == 20241019 then
		if curTime < 100000 then
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetToolTip("")
		elseif curTime >= 100000 and curTime < 190000 then
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetToolTip("#{JNHZB_20210929_1}")
		else
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetToolTip("#{JNHZB_20210929_3}")
		end
	end

	if curDay == 20241020 then
		if curTime < 150000 then
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetToolTip("#{JNHZB_20210929_3}")
		elseif curTime >= 150000 and curTime < 180000 then
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetToolTip("#{JNHZB_20210929_2}")
		else
			playerQuicklyEnterAnimateBtn[nCtlidx]:SetToolTip("")
		end
	end
end
