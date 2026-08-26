--2023周活跃奖励放出 by ypl

local g_Frame_UnifiedPosition

--活跃值
local g_ZhouHuoYue_Award_CurDayHuoYue

--小红点
local g_ZhouHuoYue_Award_RedPoint
local g_ZhouHuoYue_Award_Other_RedPoint

local g_ZhouHuoYue_Award_disable

---------------------累积奖励---------------------
--0、MD
local g_ZhouHuoYue_Award_MD1 = 894 --MD_2023_WEEK_ACTIVE_0 --替代
--1、进度条
local g_ZhouHuoYue_Award_ProgressMax = 10
--2、数值 + 控件
local g_ZhouHuoYue_Award_Special = {}

---------------------每日奖励---------------------
--0、MD
local g_ZhouHuoYue_Award_MD2 = {}
--1、数值 + 控件
local g_ZhouHuoYue_Award_Day = {}

--local my_gid = DataPool:LuaFnGetMD(854)

--=========
-- PreLoad()
--=========
function ZhouHuoYue_Award_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function ZhouHuoYue_Award_OnLoad()

	g_Frame_UnifiedPosition = ZhouHuoYue_Award_Frame:GetProperty("UnifiedPosition")
	
	g_ZhouHuoYue_Award_ProgressMax = 10
	
	g_ZhouHuoYue_Award_CurDayHuoYue = 0
	g_ZhouHuoYue_Award_RedPoint = 0
	g_ZhouHuoYue_Award_Other_RedPoint = 0
	
	g_ZhouHuoYue_Award_disable = 1
	
	g_ZhouHuoYue_Award_Special[1] = {button=ZhouHuoYue_Award_Item_1, image=ZhouHuoYue_Award_Item_1OK, animate=ZhouHuoYue_Award_Item_1_Animate, need=3, id=20501003, num=1}
	g_ZhouHuoYue_Award_Special[2] = {button=ZhouHuoYue_Award_Item_2, image=ZhouHuoYue_Award_Item_2OK, animate=ZhouHuoYue_Award_Item_2_Animate, need=5, id=20502003, num=1}
	g_ZhouHuoYue_Award_Special[3] = {button=ZhouHuoYue_Award_Item_3, image=ZhouHuoYue_Award_Item_3OK, animate=ZhouHuoYue_Award_Item_3_Animate, need=8, id=38002519, num=1}
	g_ZhouHuoYue_Award_Special[4] = {button=ZhouHuoYue_Award_Item_4, image=ZhouHuoYue_Award_Item_4OK, animate=ZhouHuoYue_Award_Item_4_Animate, need=10, id=38002221, num=1}
	
	g_ZhouHuoYue_Award_MD2[1]={md=895, } --MD_2023_WEEK_ACTIVE_1 --替代
	g_ZhouHuoYue_Award_MD2[2]={md=896, } --MD_2023_WEEK_ACTIVE_2 --替代
	g_ZhouHuoYue_Award_MD2[3]={md=897, } --MD_2023_WEEK_ACTIVE_3 --替代
	g_ZhouHuoYue_Award_MD2[4]={md=898, } --MD_2023_WEEK_ACTIVE_4 --替代
	g_ZhouHuoYue_Award_MD2[5]={md=899, } --MD_2023_WEEK_ACTIVE_5 --替代
	g_ZhouHuoYue_Award_MD2[6]={md=900, } --MD_2023_WEEK_ACTIVE_6 --替代
	g_ZhouHuoYue_Award_MD2[7]={md=901, } --MD_2023_WEEK_ACTIVE_7 --替代
	
	g_ZhouHuoYue_Award_Day[1] = {	[1] = {need=200, id=30502002, num=3, button=ZhouHuoYue_AwardIcon1, image=ZhouHuoYue_AwardIcon1_OK, animate=ZhouHuoYue_AwardIcon1_Animate, disableImage=ZhouHuoYue_AwardIcon1_Disable},
			[2] = {need=400, id=20310168, num=5, button=ZhouHuoYue_AwardIcon2, image=ZhouHuoYue_AwardIcon2_OK, animate=ZhouHuoYue_AwardIcon2_Animate, disableImage=ZhouHuoYue_AwardIcon2_Disable},}
	g_ZhouHuoYue_Award_Day[2] = {	[1] = {need=200, id=30900006, num=5, button=ZhouHuoYue_AwardIcon3, image=ZhouHuoYue_AwardIcon3_OK, animate=ZhouHuoYue_AwardIcon3_Animate, disableImage=ZhouHuoYue_AwardIcon3_Disable},
			[2] = {need=400, id=20800013, num=5, button=ZhouHuoYue_AwardIcon4, image=ZhouHuoYue_AwardIcon4_OK, animate=ZhouHuoYue_AwardIcon4_Animate, disableImage=ZhouHuoYue_AwardIcon4_Disable},}
	g_ZhouHuoYue_Award_Day[3] = {	[1] = {need=200, id=30008034, num=5, button=ZhouHuoYue_AwardIcon5, image=ZhouHuoYue_AwardIcon5_OK, animate=ZhouHuoYue_AwardIcon5_Animate, disableImage=ZhouHuoYue_AwardIcon5_Disable},
			[2] = {need=400, id=30503140, num=2, button=ZhouHuoYue_AwardIcon6, image=ZhouHuoYue_AwardIcon6_OK, animate=ZhouHuoYue_AwardIcon6_Animate, disableImage=ZhouHuoYue_AwardIcon6_Disable},}
	g_ZhouHuoYue_Award_Day[4] = {	[1] = {need=200, id=38002533, num=4, button=ZhouHuoYue_AwardIcon7, image=ZhouHuoYue_AwardIcon7_OK, animate=ZhouHuoYue_AwardIcon7_Animate, disableImage=ZhouHuoYue_AwardIcon7_Disable},
			[2] = {need=400, id=30503133, num=2, button=ZhouHuoYue_AwardIcon8, image=ZhouHuoYue_AwardIcon8_OK, animate=ZhouHuoYue_AwardIcon8_Animate, disableImage=ZhouHuoYue_AwardIcon8_Disable},}
	g_ZhouHuoYue_Award_Day[5] = {	[1] = {need=200, id=30700241, num=2, button=ZhouHuoYue_AwardIcon9, image=ZhouHuoYue_AwardIcon9_OK, animate=ZhouHuoYue_AwardIcon9_Animate, disableImage=ZhouHuoYue_AwardIcon9_Disable},
			[2] = {need=400, id=30503020, num=1, button=ZhouHuoYue_AwardIcon10, image=ZhouHuoYue_AwardIcon10_OK, animate=ZhouHuoYue_AwardIcon10_Animate, disableImage=ZhouHuoYue_AwardIcon10_Disable},}
	g_ZhouHuoYue_Award_Day[6] = {	[1] = {need=200, id=38002532, num=3, button=ZhouHuoYue_AwardIcon11, image=ZhouHuoYue_AwardIcon11_OK, animate=ZhouHuoYue_AwardIcon11_Animate, disableImage=ZhouHuoYue_AwardIcon11_Disable},
			[2] = {need=400, id=38002524, num=1, button=ZhouHuoYue_AwardIcon12, image=ZhouHuoYue_AwardIcon12_OK, animate=ZhouHuoYue_AwardIcon12_Animate, disableImage=ZhouHuoYue_AwardIcon12_Disable},}
	g_ZhouHuoYue_Award_Day[7] = {	[1] = {need=200, id=30501361, num=2, button=ZhouHuoYue_AwardIcon13, image=ZhouHuoYue_AwardIcon13_OK, animate=ZhouHuoYue_AwardIcon13_Animate, disableImage=ZhouHuoYue_AwardIcon13_Disable},
			[2] = {need=400, id=50313004, num=1, button=ZhouHuoYue_AwardIcon14, image=ZhouHuoYue_AwardIcon14_OK, animate=ZhouHuoYue_AwardIcon14_Animate, disableImage=ZhouHuoYue_AwardIcon14_Disable},}		
	
end

--=========
-- Event
--=========
function ZhouHuoYue_Award_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 79201201 then
		-- g_ZhouHuoYue_Award_Other_RedPoint = Get_XParam_INT(2)
		-- if this:IsVisible() then
			-- if g_ZhouHuoYue_Award_Other_RedPoint == 1 then
				-- --ZhouHuoYue_Award_Index0_Tips:Show()
			-- else
				-- --ZhouHuoYue_Award_Index0_Tips:Hide()
			-- end
		-- end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99826301 then
		local nOperate = Get_XParam_INT(0)
		 --关闭
		if nOperate == 0 then
			this:Hide()
			return
		end	
		g_ZhouHuoYue_Award_CurDayHuoYue = Get_XParam_INT(1)
		g_ZhouHuoYue_Award_RedPoint = Get_XParam_INT(2)
		g_ZhouHuoYue_Award_Other_RedPoint = Get_XParam_INT(3)
		g_ZhouHuoYue_Award_disable = Get_XParam_INT(4)
		
		--刷新
		if nOperate == 1 then
			if this:IsVisible() then
				--ZhouHuoYue_Award_OnHiden()
				ZhouHuoYue_Award_UpdateUI()	
				--this:Show()
			else
				ZhouHuoYue_Award_RedPointOnly()	
			end
		--打开
		elseif nOperate == 2 then
			-- local selfUnionPos = Variable:GetVariable("ZhouHuoYue");
			-- if(selfUnionPos ~= nil) then
				-- ZhouHuoYue_Award_Frame:SetProperty("UnifiedPosition", selfUnionPos);
			-- end			
			-- if(IsWindowShow("FeelFeedBack800")) then
				-- CloseWindow("FeelFeedBack800", true)
			-- end			
			--ZhouHuoYue_Award_OnHiden()
			ZhouHuoYue_Award_UpdateUI()			
			this:Show()
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		ZhouHuoYue_Award_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		ZhouHuoYue_Award_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		ZhouHuoYue_Award_ResetPos()
	
	end

end

function ZhouHuoYue_Award_UpdateUI()

	ZhouHuoYue_Award_Infotext:SetText("#{FLFC_230310_04}")

	--ZhouHuoYue_Award_Index0:SetCheck(0)
	--ZhouHuoYue_Award_Index1:SetCheck(1)

	local nRedPoint = 0

	---------------
	--0、活动介绍
	---------------
	ZhouHuoYue_Award_Infotext:SetText("#{FLFC_230310_04}")

	---------------
	--1、累积奖励
	---------------
	local md = DataPool:LuaFnGetMD(g_ZhouHuoYue_Award_MD1)
	--（1）进度条
	local nValue = math.floor(md/10000)
	if nValue <= g_ZhouHuoYue_Award_ProgressMax then
		ZhouHuoYue_AwardEXP:SetProgress(nValue, g_ZhouHuoYue_Award_ProgressMax)
	else
		ZhouHuoYue_AwardEXP:SetProgress(g_ZhouHuoYue_Award_ProgressMax, g_ZhouHuoYue_Award_ProgressMax)
	end
	--ZhouHuoYue_AwardEXPTip:SetToolTip(ScriptGlobal_Format("#{FLFC_230310_25}",nValue))
	ZhouHuoYue_Award_TextProgressNum:SetText(ScriptGlobal_Format("#{FLFC_230310_37}",nValue))
	--（2）各档奖励、领取情况
	local prize_flag = {}
	prize_flag[1] = math.mod(md,10)
	prize_flag[2] = math.floor(math.mod(md,100)/10)
	prize_flag[3] = math.floor(math.mod(md,1000)/100)
	prize_flag[4] = math.floor(math.mod(md,10000)/1000)
	local theAction = {}
	for i=1, table.getn(g_ZhouHuoYue_Award_Special) do
		--ActionButton(奖励item信息)
		theAction[i] = DataPool:CreateBindActionItemForShow(g_ZhouHuoYue_Award_Special[i].id, g_ZhouHuoYue_Award_Special[i].num)
		g_ZhouHuoYue_Award_Special[i].button:SetActionItem(theAction[i]:GetID())
		g_ZhouHuoYue_Award_Special[i].button:Enable()
		--Image(是否领奖)
		if prize_flag[i] == 1 then
			g_ZhouHuoYue_Award_Special[i].animate:Hide()
			g_ZhouHuoYue_Award_Special[i].image:Show()
			--g_ZhouHuoYue_Award_Special[i].button:Disable()
		else
			g_ZhouHuoYue_Award_Special[i].image:Hide()
			--Animate(是否可以领奖)
			if nValue >= g_ZhouHuoYue_Award_Special[i].need then
				nRedPoint = 1
				g_ZhouHuoYue_Award_Special[i].animate:Show()
			else
				g_ZhouHuoYue_Award_Special[i].animate:Hide()
				--g_ZhouHuoYue_Award_Special[i].button:Disable()
			end
		end
	end
			
	---------------
	--2、每日奖励
	---------------
	local nDayActivePoint = {} --每日活跃值
	local nDayPrizeState = {} --每日奖励是否领取
	for i=1, table.getn(g_ZhouHuoYue_Award_MD2) do 
		local temp = DataPool:LuaFnGetMD(g_ZhouHuoYue_Award_MD2[i].md)
		nDayActivePoint[i] = math.floor(temp/100)
		nDayPrizeState[i] = {}
		nDayPrizeState[i][1] = math.mod(temp,10)
		nDayPrizeState[i][2] = math.mod(math.floor(temp/10),10)
	end
	for i=1, table.getn(g_ZhouHuoYue_Award_Day) do
		for j=1, table.getn(g_ZhouHuoYue_Award_Day[i]) do
			--ActionButton(奖励item信息)
			local theAction = DataPool:CreateBindActionItemForShow(g_ZhouHuoYue_Award_Day[i][j].id, g_ZhouHuoYue_Award_Day[i][j].num)
			g_ZhouHuoYue_Award_Day[i][j].button:SetActionItem(theAction:GetID())	
			g_ZhouHuoYue_Award_Day[i][j].button:Enable()
			--Image(是否领奖)
			if nDayPrizeState[i][j] == 1 then
				g_ZhouHuoYue_Award_Day[i][j].animate:Hide()
				g_ZhouHuoYue_Award_Day[i][j].image:Show()
				g_ZhouHuoYue_Award_Day[i][j].disableImage:Hide()
				--g_ZhouHuoYue_Award_Day[i][j].button:Disable()
			else
				g_ZhouHuoYue_Award_Day[i][j].image:Hide()
				--Animate(是否可以领奖)
				if i > g_ZhouHuoYue_Award_disable then	
					g_ZhouHuoYue_Award_Day[i][j].disableImage:Hide()
					g_ZhouHuoYue_Award_Day[i][j].animate:Hide()
				elseif i == g_ZhouHuoYue_Award_disable then
					if nDayActivePoint[i] >= g_ZhouHuoYue_Award_Day[i][j].need then
						nRedPoint = 1
						g_ZhouHuoYue_Award_Day[i][j].animate:Show()
						g_ZhouHuoYue_Award_Day[i][j].disableImage:Hide()
					else
						g_ZhouHuoYue_Award_Day[i][j].animate:Hide()
						g_ZhouHuoYue_Award_Day[i][j].disableImage:Hide()
					end
				else
					if nDayActivePoint[i] >= g_ZhouHuoYue_Award_Day[i][j].need then
						nRedPoint = 1
						g_ZhouHuoYue_Award_Day[i][j].animate:Show()
						g_ZhouHuoYue_Award_Day[i][j].disableImage:Hide()
					else
						g_ZhouHuoYue_Award_Day[i][j].animate:Hide()
						g_ZhouHuoYue_Award_Day[i][j].disableImage:Hide()
					end					
				end				
			end			
		end
	end	
	
	---------------
	--3、今日活跃值
	---------------	
	ZhouHuoYue_Award_TextNull2:SetText(ScriptGlobal_Format("#{FLFC_230310_12}",g_ZhouHuoYue_Award_CurDayHuoYue))
	---------------
	--4、小红点
	---------------
	if g_ZhouHuoYue_Award_RedPoint == 1 then --if nRedPoint == 1 then
		--ZhouHuoYue_Award_Index1_Tips:Show()
	else
		--ZhouHuoYue_Award_Index1_Tips:Hide()
	end
	-- if g_ZhouHuoYue_Award_Other_RedPoint == 1 then
		-- --ZhouHuoYue_Award_Index0_Tips:Show()
	-- else
		-- --ZhouHuoYue_Award_Index0_Tips:Hide()
	-- end
end

function ZhouHuoYue_Award_RedPointOnly()	

	local nRedPoint = g_ZhouHuoYue_Award_RedPoint
	
	if nRedPoint == 1 then
		--ZhouHuoYue_Award_Index1_Tips:Show()
	else
		--ZhouHuoYue_Award_Index1_Tips:Hide()
	end
	
end

function ZhouHuoYue_Award_Index(nIndex)
	--Variable:SetVariable("ZhouHuoYue", ZhouHuoYue_Award_Frame:GetProperty("UnifiedPosition"), 1);
	if nIndex == 0 then
		-- if(IsWindowShow("ZhouHuoYue_Award")) then
			-- CloseWindow("ZhouHuoYue_Award", true)
		-- end		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnOpenMainWindow");
			Set_XSCRIPT_ScriptID(792012);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();	
	elseif nIndex == 1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("RequestOpenUI");
			Set_XSCRIPT_ScriptID(998263);
			Set_XSCRIPT_Parameter(0,nIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();	
	end
end

function ZhouHuoYue_Award_Day_Clicked(nIndex, nSubIndex)

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetPrizeDay");
		Set_XSCRIPT_ScriptID(998263);
		Set_XSCRIPT_Parameter(0,nIndex);
		Set_XSCRIPT_Parameter(1,nSubIndex);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
	
end

function ZhouHuoYue_Award_Special_Clicked(nIndex)

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetPrizeSpecial");
		Set_XSCRIPT_ScriptID(998263);
		Set_XSCRIPT_Parameter(0,nIndex);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
end

function ZhouHuoYue_Award_ResetPos()

	ZhouHuoYue_Award_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function ZhouHuoYue_Award_HelpClicked()
	PushEvent("QUEST_HELPINFO", "#{FLFC_230310_03}")
end

function ZhouHuoYue_Award_OnHiden()
	--Variable:SetVariable("ZhouHuoYue", ZhouHuoYue_Award_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide()
end

function ZhouHuoYue_Award_Close()
	--Variable:SetVariable("ZhouHuoYue", ZhouHuoYue_Award_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide()
end