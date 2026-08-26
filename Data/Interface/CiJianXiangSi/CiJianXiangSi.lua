--2023Q2版本预热-此间相思

local g_Frame_UnifiedPosition

local g_CiJianXiangSi_Index --?????
local g_CiJianXiangSi_Finish --?????????
local g_CiJianXiangSi_XiangSiDian --????
local g_CiJianXiangSi_PrizeState --???????
local g_CiJianXiangSi_SpecialRedPoint --?????
		
local g_CiJianXiangSi_MissionName = {}
local g_CiJianXiangSi_MissionImage = {}
local g_CiJianXiangSi_MissionDesc = {}
local g_CiJianXiangSi_MissionYuGao = {}	
local g_CiJianXiangSi_MissionJieShao = {}		
		
local g_CiJianXiangSi_Item = {}

--=========
-- PreLoad()
--=========
function CiJianXiangSi_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function CiJianXiangSi_OnLoad()

	g_Frame_UnifiedPosition = CiJianXiangSi_Frame:GetProperty("UnifiedPosition")
	
	g_CiJianXiangSi_Index = 0
	g_CiJianXiangSi_Finish = 0
	g_CiJianXiangSi_XiangSiDian = 0
	g_CiJianXiangSi_PrizeState = 0
	g_CiJianXiangSi_SpecialRedPoint = 0
	
	g_CiJianXiangSi_MissionName[1] = "set:CiJianXiangSi image:Title1"
	g_CiJianXiangSi_MissionName[2] = "set:CiJianXiangSi image:Title2"
	g_CiJianXiangSi_MissionName[3] = "set:CiJianXiangSi image:Title3"
	g_CiJianXiangSi_MissionName[4] = "set:CiJianXiangSi image:Title4"
	
	g_CiJianXiangSi_MissionImage[1] = "set:CiJianXiangSi image:Image1"
	g_CiJianXiangSi_MissionImage[2] = "set:CiJianXiangSi image:Image2"
	g_CiJianXiangSi_MissionImage[3] = "set:CiJianXiangSi image:Image3"
	g_CiJianXiangSi_MissionImage[4] = "set:CiJianXiangSi image:Image4"	
	
	g_CiJianXiangSi_MissionDesc[1] = "#{CJXS_230330_41}"
	g_CiJianXiangSi_MissionDesc[2] = "#{CJXS_230330_42}"
	g_CiJianXiangSi_MissionDesc[3] = "#{CJXS_230330_43}"
	g_CiJianXiangSi_MissionDesc[4] = "#{CJXS_230330_44}"	
	
	g_CiJianXiangSi_MissionYuGao[1] = "#{CJXS_230330_45}"
	g_CiJianXiangSi_MissionYuGao[2] = "#{CJXS_230330_46}"
	g_CiJianXiangSi_MissionYuGao[3] = "#{CJXS_230330_47}"
	g_CiJianXiangSi_MissionYuGao[4] = "#{CJXS_230330_48}"	
	
	g_CiJianXiangSi_MissionJieShao[1] = "#{CJXS_230330_238}"
	g_CiJianXiangSi_MissionJieShao[2] = "#{CJXS_230330_239}"
	g_CiJianXiangSi_MissionJieShao[3] = "#{CJXS_230330_240}"
	g_CiJianXiangSi_MissionJieShao[4] = "#{CJXS_230330_237}"	
	
	g_CiJianXiangSi_Item[1] = {id=20600002, num=1}
	g_CiJianXiangSi_Item[2] = {id=38002519, num=1}
	g_CiJianXiangSi_Item[3] = {id=20501003, num=1}
	
end

--=========
-- Event
--=========
function CiJianXiangSi_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 99827201 then
		local nOperate = Get_XParam_INT(0)
		 --关睜
		if nOperate == 0 then
			this:Hide()
			return
		end	
		
		g_CiJianXiangSi_Index = Get_XParam_INT(1)
		g_CiJianXiangSi_Finish = Get_XParam_INT(2)
		g_CiJianXiangSi_XiangSiDian = Get_XParam_INT(3)
		g_CiJianXiangSi_PrizeState = Get_XParam_INT(4)
		g_CiJianXiangSi_SpecialRedPoint =  Get_XParam_INT(5)
		
		--打开
		if nOperate == 1 then
			CiJianXiangSi_UpdateUI()			
			this:Show()
		--刷新
		elseif nOperate == 2 then
			if this:IsVisible() then
				CiJianXiangSi_UpdateUI()
			else
				CiJianXiangSi_FlushRetPoint()
			end
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		CiJianXiangSi_Close()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		CiJianXiangSi_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		CiJianXiangSi_ResetPos()
	
	end

end

function CiJianXiangSi_UpdateUI()
	
	---------------
	--1、任务阶段
	---------------
	local nImage1 = g_CiJianXiangSi_MissionName[g_CiJianXiangSi_Index]
	local nImage2 = g_CiJianXiangSi_MissionImage[g_CiJianXiangSi_Index]
	if nImage1 == nil then
		nImage1 = ""
	end
	if nImage2 == nil then
		nImage2 = ""
	end	
	CiJianXiangSi_TitleBK:SetProperty("Image", nImage1)
	CiJianXiangSi_Text1:SetProperty("Image", nImage2)
	
	-----------------
	--2、任务完成标识
	-----------------
	if g_CiJianXiangSi_Finish == 1 then
		CiJianXiangSi_Over:Show()
	else
		CiJianXiangSi_Over:Hide()
	end
	
	---------------
	--3、任务详情
	---------------
	local name = g_CiJianXiangSi_MissionDesc[g_CiJianXiangSi_Index]
	if name == nil then
		name = ""
	end	
	CiJianXiangSi_Text2:SetText(name)
	
	---------------
	--4、任务预告
	---------------
	name = g_CiJianXiangSi_MissionYuGao[g_CiJianXiangSi_Index]
	if name == nil then
		name = ""
	end		
	local name2 = g_CiJianXiangSi_MissionJieShao[g_CiJianXiangSi_Index]
	if name2 == nil then
		name2 = ""
	end		
	if g_CiJianXiangSi_Finish == 1 then
		CiJianXiangSi_Text3:SetText(name)
	else
		CiJianXiangSi_Text3:SetText(name2)
	end
	
	local theAction = DataPool:CreateBindActionItemForShow(g_CiJianXiangSi_Item[1].id, g_CiJianXiangSi_Item[1].num)
	CiJianXiangSi_Button1:SetActionItem(theAction:GetID())
	theAction = DataPool:CreateBindActionItemForShow(g_CiJianXiangSi_Item[2].id, g_CiJianXiangSi_Item[2].num)
	CiJianXiangSi_Button2:SetActionItem(theAction:GetID())
	theAction = DataPool:CreateBindActionItemForShow(g_CiJianXiangSi_Item[3].id, g_CiJianXiangSi_Item[3].num)
	CiJianXiangSi_Button3:SetActionItem(theAction:GetID())

	-----------------
	--5、领奖情况
	--红点、按钮状态
	-----------------
	Lua_ShowQuickEnterPointTip(14,0)
	if g_CiJianXiangSi_SpecialRedPoint == 1 then
		Lua_ShowQuickEnterPointTip(14,1)
	end
	local state1 = math.mod(g_CiJianXiangSi_PrizeState, 10)
	local state2 = math.floor(math.mod(g_CiJianXiangSi_PrizeState, 100)/10)
	local state3 = math.floor(g_CiJianXiangSi_PrizeState/100)
	if state1 == 1 then
		CiJianXiangSi_Button1:Disable()
		CiJianXiangSi_Mark1:Show()
		CiJianXiangSi_ButtonAnimate1:Play(false)
	else
		CiJianXiangSi_Button1:Enable()
		CiJianXiangSi_Mark1:Hide()	
		if g_CiJianXiangSi_XiangSiDian >= 1 then
			CiJianXiangSi_ButtonAnimate1:Play(true)
			Lua_ShowQuickEnterPointTip(14,1)
		else
			CiJianXiangSi_ButtonAnimate1:Play(false)
		end
	end
	if state2 == 1 then
		CiJianXiangSi_Button2:Disable()
		CiJianXiangSi_Mark2:Show()
		CiJianXiangSi_ButtonAnimate2:Play(false)
	else
		CiJianXiangSi_Button2:Enable()
		CiJianXiangSi_Mark2:Hide()
		if g_CiJianXiangSi_XiangSiDian >= 2 then
			CiJianXiangSi_ButtonAnimate2:Play(true)
			Lua_ShowQuickEnterPointTip(14,1)
		else
			CiJianXiangSi_ButtonAnimate2:Play(false)
		end		
	end	
	if state3 == 1 then
		CiJianXiangSi_Button3:Disable()
		CiJianXiangSi_Mark3:Show()
		CiJianXiangSi_ButtonAnimate3:Play(false)
	else
		CiJianXiangSi_Button3:Enable()
		CiJianXiangSi_Mark3:Hide()	
		if g_CiJianXiangSi_XiangSiDian >= 3 then
			CiJianXiangSi_ButtonAnimate3:Play(true)
			Lua_ShowQuickEnterPointTip(14,1)
		else
			CiJianXiangSi_ButtonAnimate3:Play(false)
		end		
	end	
	
	--6、相思点数
	CiJianXiangSi_NUM_Text:SetText(ScriptGlobal_Format("#{CJXS_230330_236}", g_CiJianXiangSi_XiangSiDian))
	
end

function CiJianXiangSi_FlushRetPoint()

	-----------------
	--5、领奖情况
	--红点、按钮状态
	-----------------
	Lua_ShowQuickEnterPointTip(14,0)
	if g_CiJianXiangSi_SpecialRedPoint == 1 then
		Lua_ShowQuickEnterPointTip(14,1)
	end	
	local state1 = math.mod(g_CiJianXiangSi_PrizeState, 10)
	local state2 = math.floor(math.mod(g_CiJianXiangSi_PrizeState, 100)/10)
	local state3 = math.floor(g_CiJianXiangSi_PrizeState/100)
	if state1 == 1 then
	else
		if g_CiJianXiangSi_XiangSiDian >= 1 then
			Lua_ShowQuickEnterPointTip(14,1)
		end
	end
	if state2 == 1 then
	else
		if g_CiJianXiangSi_XiangSiDian >= 2 then
			Lua_ShowQuickEnterPointTip(14,1)
		end		
	end	
	if state3 == 1 then
	else
		if g_CiJianXiangSi_XiangSiDian >= 3 then
			Lua_ShowQuickEnterPointTip(14,1)
		end		
	end
	
end

function CiJianXiangSi_GetPrize(nIndex)

	if nIndex >= 1 and nIndex <= 3 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetPrize");
			Set_XSCRIPT_ScriptID(998272);
			Set_XSCRIPT_Parameter(0,nIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();	
	end
	
end

function CiJianXiangSi_ResetPos()

	CiJianXiangSi_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function CiJianXiangSi_HelpClicked()
	PushEvent("QUEST_HELPINFO", "#{CJXS_230330_37}")
end

function CiJianXiangSi_Close()
	this:Hide()
end
