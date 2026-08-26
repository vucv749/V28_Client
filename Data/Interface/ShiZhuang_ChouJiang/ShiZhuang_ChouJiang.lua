--!!!reloadscript =ShiZhuang_ChouJiang

local g_ShiZhuang_ChouJiang_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_Preview_Item = {30310075, 10125068, 30310075, 10125068, 30310075, 10125068, 30310075}
local g_Preview_Type = {0, 1, 0, 1, 0, 1, 0}
local g_Need_YuanBao = {16888, 16888, 16888, 16888, 16888, 16888, 16888}

local g_check_btn = {}
local g_check_text = {}

local g_CurShowIndex = 0

local g_ButtonOp = 0	--1:?? 2:?? 3:?? 4:????

local g_WinImageStr = "set:ShiZhuang_ChouJiang1 image:ShiZhuang_ChouJiangGet"
local g_NotWinImageStr = "set:ShiZhuang_ChouJiang1 image:ShiZhuang_ChouJiangNo"


function ShiZhuang_ChouJiang_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("OPEN_FASHION_LOTTERY")
	this:RegisterEvent("REFRESH_FASHION_LOTTERY")
end

function ShiZhuang_ChouJiang_OnLoad()
	g_ShiZhuang_ChouJiang_Frame_UnifiedPosition = ShiZhuang_ChouJiang_Frame:GetProperty("UnifiedPosition")
	
	g_check_btn[1] = ShiZhuang_ChouJiang_Btn1
	g_check_btn[2] = ShiZhuang_ChouJiang_Btn2
	g_check_btn[3] = ShiZhuang_ChouJiang_Btn3
	g_check_btn[4] = ShiZhuang_ChouJiang_Btn4
	g_check_btn[5] = ShiZhuang_ChouJiang_Btn5
	g_check_btn[6] = ShiZhuang_ChouJiang_Btn6
	g_check_btn[7] = ShiZhuang_ChouJiang_Btn7
	
	g_check_text[1] = ShiZhuang_ChouJiang_Title1Text2
	g_check_text[2] = ShiZhuang_ChouJiang_Title2Text2
	g_check_text[3] = ShiZhuang_ChouJiang_Title3Text2
	g_check_text[4] = ShiZhuang_ChouJiang_Title4Text2
	g_check_text[5] = ShiZhuang_ChouJiang_Title5Text2
	g_check_text[6] = ShiZhuang_ChouJiang_Title6Text2
	g_check_text[7] = ShiZhuang_ChouJiang_Title7Text2
	
end

function ShiZhuang_ChouJiang_OnEvent(event)

	if event == "OPEN_FASHION_LOTTERY" then
		if not this:IsVisible() then
			local targetId = tonumber(arg0)
			ShiZhuang_ChouJiang_CleanUp()
			this:Show()
			g_CurShowIndex = 1
			ShiZhuang_ChouJiang_Update()
			ShiZhuang_ChouJiang_BeginCareObj(tonumber(targetId))
		else
			ShiZhuang_ChouJiang_Frame:SetForce()
			ShiZhuang_ChouJiang_Update()
		end
		return
	end
	
	if event == "REFRESH_FASHION_LOTTERY" then
		if this:IsVisible() then
			ShiZhuang_ChouJiang_Update()
		end
		return
	end
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ShiZhuang_ChouJiang_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
end

function ShiZhuang_ChouJiang_Update()
	
	g_ButtonOp = 0
	ShiZhuang_ChouJiang_Result_Image:Hide()
	for i = 1, 7 do
		if i == g_CurShowIndex then
			g_check_btn[i]:SetCheck(1)
		else
			g_check_btn[i]:SetCheck(0)
		end
		g_check_text[i]:SetText("")
	end
	
	local lottery_stage = DataPool:LuaFnGetFashionLotteryStage()
	local current_lottery_index = DataPool:LuaFnGetCurFashionLotteryIndex() + 1
	for i = 1, 7 do
		local bSign = DataPool:LuaFnGetLotterySignUpFlag(i - 1)
		local lottery_num = DataPool:LuaFnGetMyLotteryNumber(i - 1)
		local lottery_num_str = string.format("%07d", lottery_num)
		local win_lottery = 0
		if lottery_num ~= 0 then
			win_lottery = DataPool:LuaFnIsLotteryWin(i - 1, lottery_num)
		end
		local bTakeBack = DataPool:LuaFnGetLotteryTakeBackFlag(i - 1)
		if lottery_stage == 1 then
			if bSign == 1 then
				if i == g_CurShowIndex then
					ShiZhuang_ChouJiang_UpdateOpButton(0, 2)	--??,??
					ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
				end
				g_check_text[i]:SetText("#{JLTJ_230320_22}")
			else
				if i == g_CurShowIndex then
					ShiZhuang_ChouJiang_UpdateOpButton(1, 1)	--??
					local strTemp = ScriptGlobal_Format("#{JLTJ_230320_19}", tostring(g_Need_YuanBao[i]))
					ShiZhuang_ChouJiang_NumText:SetText(strTemp)
					g_ButtonOp = 1
				end
				g_check_text[i]:SetText("#{JLTJ_230320_18}")
			end
		elseif lottery_stage == 2 then
			if bSign == 1 then
				if i < current_lottery_index then
					if bTakeBack == 1 then
						if i == g_CurShowIndex then
							ShiZhuang_ChouJiang_UpdateOpButton(0, 5)	--???
							if win_lottery == 1 then
								ShiZhuang_ChouJiang_Result_Image:Show()
								ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_WinImageStr)
							else
								ShiZhuang_ChouJiang_Result_Image:Show()
								ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_NotWinImageStr)
							end
						end
						g_check_text[i]:SetText("#{JLTJ_230320_28}")
					else
						if win_lottery == 1 then
							if i == g_CurShowIndex then
								ShiZhuang_ChouJiang_UpdateOpButton(1, 3)	--??
								g_ButtonOp = 3
								ShiZhuang_ChouJiang_Result_Image:Show()
								ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_WinImageStr)
							end
							g_check_text[i]:SetText("#{JLTJ_230320_27}")
						else
							if i == g_CurShowIndex then
								ShiZhuang_ChouJiang_UpdateOpButton(1, 4)	--????
								g_ButtonOp = 4
								ShiZhuang_ChouJiang_Result_Image:Show()
								ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_NotWinImageStr)
							end
							g_check_text[i]:SetText("#{JLTJ_230320_25}")
						end
					end
					
					if i == g_CurShowIndex then
						if lottery_num ~= 0 then
							local strTemp = ScriptGlobal_Format("#{JLTJ_230320_24}", lottery_num_str)
							ShiZhuang_ChouJiang_NumText:SetText(strTemp)
						else
							ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
						end
					end
				elseif i == current_lottery_index then
					local is_lottery_draw = DataPool:LuaFnIsLotteryDraw(i - 1)
					local bGetNumOver = DataPool:LuaFnIsCurLotteryGetNumberOver()
					if is_lottery_draw == 1 then
						if bTakeBack == 1 then
							if i == g_CurShowIndex then
								ShiZhuang_ChouJiang_UpdateOpButton(0, 5)	--???
								if win_lottery == 1 then
									ShiZhuang_ChouJiang_Result_Image:Show()
									ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_WinImageStr)
								else
									ShiZhuang_ChouJiang_Result_Image:Show()
									ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_NotWinImageStr)
								end
							end
							g_check_text[i]:SetText("#{JLTJ_230320_28}")
						else
							if win_lottery == 1 then
								if i == g_CurShowIndex then
									ShiZhuang_ChouJiang_UpdateOpButton(1, 3)	--??
									g_ButtonOp = 3
									ShiZhuang_ChouJiang_Result_Image:Show()
									ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_WinImageStr)
								end
								g_check_text[i]:SetText("#{JLTJ_230320_27}")
							else
								if i == g_CurShowIndex then
									ShiZhuang_ChouJiang_UpdateOpButton(1, 4)	--????
									g_ButtonOp = 4
									ShiZhuang_ChouJiang_Result_Image:Show()
									ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_NotWinImageStr)
								end
								g_check_text[i]:SetText("#{JLTJ_230320_25}")
							end	
						end
					else
						if bGetNumOver == 1 then
							if lottery_num ~= 0 then
								if i == g_CurShowIndex then
									ShiZhuang_ChouJiang_UpdateOpButton(0, 6)	--????
								end
								g_check_text[i]:SetText("#{JLTJ_230320_23}")
							else
								if bTakeBack == 1 then
									if i == g_CurShowIndex then
										ShiZhuang_ChouJiang_UpdateOpButton(0, 5)	--???
									end
									g_check_text[i]:SetText("#{JLTJ_230320_28}")
								else
									if i == g_CurShowIndex then
										ShiZhuang_ChouJiang_UpdateOpButton(1, 4)	--????
										g_ButtonOp = 4
									end
									g_check_text[i]:SetText("#{JLTJ_230320_25}")
								end
							end
						else
							if lottery_num ~= 0 then
								if i == g_CurShowIndex then
									ShiZhuang_ChouJiang_UpdateOpButton(0, 6)	--????
								end
								g_check_text[i]:SetText("#{JLTJ_230320_23}")
							else
								if i == g_CurShowIndex then
									ShiZhuang_ChouJiang_UpdateOpButton(1, 2)	--??
									g_ButtonOp = 2
								end
								g_check_text[i]:SetText("#{JLTJ_230320_22}")
							end
						end
					end
					
					if i == g_CurShowIndex then
						if lottery_num ~= 0 then
							local strTemp = ScriptGlobal_Format("#{JLTJ_230320_24}", lottery_num_str)
							ShiZhuang_ChouJiang_NumText:SetText(strTemp)
						else
							ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
						end
					end
				else
					if i == g_CurShowIndex then
						ShiZhuang_ChouJiang_UpdateOpButton(0, 2)	--??,??
						ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
					end
					g_check_text[i]:SetText("#{JLTJ_230320_22}")
				end
			else
				if i == g_CurShowIndex then
					ShiZhuang_ChouJiang_UpdateOpButton(0, 7)	--???
					ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
				end
				g_check_text[i]:SetText("#{JLTJ_230320_20}")
			end			
		elseif lottery_stage == 3 or lottery_stage == 4 then
			if bSign == 1 then
				if bTakeBack == 1 then
					if i == g_CurShowIndex then
						ShiZhuang_ChouJiang_UpdateOpButton(0, 5)	--???
						if win_lottery == 1 then
							ShiZhuang_ChouJiang_Result_Image:Show()
							ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_WinImageStr)
						else
							ShiZhuang_ChouJiang_Result_Image:Show()
							ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_NotWinImageStr)
						end
					end
					g_check_text[i]:SetText("#{JLTJ_230320_28}")
				else
					if win_lottery == 1 then
						if i == g_CurShowIndex then
							ShiZhuang_ChouJiang_UpdateOpButton(1, 3)	--??
							g_ButtonOp = 3
							ShiZhuang_ChouJiang_Result_Image:Show()
							ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_WinImageStr)
						end
						g_check_text[i]:SetText("#{JLTJ_230320_27}")
					else
						if i == g_CurShowIndex then
							ShiZhuang_ChouJiang_UpdateOpButton(1, 4)	--????
							g_ButtonOp = 4
							ShiZhuang_ChouJiang_Result_Image:Show()
							ShiZhuang_ChouJiang_Result_Image:SetProperty("Image", g_NotWinImageStr)
						end
						g_check_text[i]:SetText("#{JLTJ_230320_25}")
					end
				end
			else
				if i == g_CurShowIndex then
					ShiZhuang_ChouJiang_UpdateOpButton(0, 7)	--???
					ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
				end
				g_check_text[i]:SetText("#{JLTJ_230320_20}")
			end
			
			if i == g_CurShowIndex then
				if lottery_num ~= 0 then
					local strTemp = ScriptGlobal_Format("#{JLTJ_230320_24}", lottery_num_str)
					ShiZhuang_ChouJiang_NumText:SetText(strTemp)
				else
					ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
				end
			end
		else
			if bSign == 1 then
				if i == g_CurShowIndex then
					ShiZhuang_ChouJiang_UpdateOpButton(0, 2)	--??,??
					ShiZhuang_ChouJiang_NumText:SetText("#{JLTJ_230320_21}")
				end
				g_check_text[i]:SetText("#{JLTJ_230320_22}")				
			else
				if i == g_CurShowIndex then
					ShiZhuang_ChouJiang_UpdateOpButton(0, 1)	--??,??
					local strTemp = ScriptGlobal_Format("#{JLTJ_230320_19}", tostring(g_Need_YuanBao[i]))
					ShiZhuang_ChouJiang_NumText:SetText(strTemp)
				end
				g_check_text[i]:SetText("#{JLTJ_230320_18}")
			end
		end
	end

	local actionItem = DataPool:CreateActionItemForShow(g_Preview_Item[g_CurShowIndex], 1)
	ShiZhuang_ChouJiang_Bonus_Item:SetActionItem(actionItem:GetID())
	
	if g_CurShowIndex == 2 or g_CurShowIndex == 4 or g_CurShowIndex == 6 then
		ShiZhuang_ChouJiang_Image:SetProperty("Image", "set:ShiZhuang_ChouJiang2 image:ShiZhuang_ShiZhuang")
	else
		ShiZhuang_ChouJiang_Image:SetProperty("Image", "set:ShiZhuang_ChouJiang2 image:ShiZhuang_ZhenShou")
	end
end

function ShiZhuang_ChouJiang_Select_Lottery(index)
	if g_CurShowIndex == index then
		return
	end
	
	g_CurShowIndex = index
	ShiZhuang_ChouJiang_Update()
end

function ShiZhuang_ChouJiang_Preview()
	if g_Preview_Type[g_CurShowIndex] == 0 then
		Pet:OpenPetJianByZhenShouDanId(g_Preview_Item[g_CurShowIndex])
	elseif g_Preview_Type[g_CurShowIndex] == 1 then
		DataPool:LuaFnOpenFashionLotteryDressPreview(g_Preview_Item[g_CurShowIndex])
	end
end

function ShiZhuang_ChouJiang_DoClicked()
	if g_ButtonOp == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888811)
			Set_XSCRIPT_Function_Name("FashionLotterySignUp")
			Set_XSCRIPT_Parameter(0, m_ObjServerId)
			Set_XSCRIPT_Parameter(1, g_CurShowIndex - 1)
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif g_ButtonOp == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888811)
			Set_XSCRIPT_Function_Name("FashionLotteryGetNumber")
			Set_XSCRIPT_Parameter(0, m_ObjServerId)
			Set_XSCRIPT_Parameter(1, g_CurShowIndex - 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif g_ButtonOp == 3 then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888811)
			Set_XSCRIPT_Function_Name("TakeBonus")
			Set_XSCRIPT_Parameter(0, m_ObjServerId)
			Set_XSCRIPT_Parameter(1, g_CurShowIndex - 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif g_ButtonOp == 4 then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888811)
			Set_XSCRIPT_Function_Name("TakeBackYuanBao")
			Set_XSCRIPT_Parameter(0, m_ObjServerId)
			Set_XSCRIPT_Parameter(1, g_CurShowIndex - 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function ShiZhuang_ChouJiang_CloseClicked()
	this:Hide()
end

function ShiZhuang_ChouJiang_CleanUp()
	for i = 1, 7 do
		g_check_text[i]:SetText("")
	end
	g_ButtonOp = 0
	ShiZhuang_ChouJiang_NumText:SetText("")
	ShiZhuang_ChouJiang_Bonus_Item:SetActionItem(-1)
end

function ShiZhuang_ChouJiang_OnHidden()
	ShiZhuang_ChouJiang_CleanUp()
	m_ObjServerId = -1
	CloseWindow("ShiZhuang_ZhanShiFitting", true)
end

function ShiZhuang_ChouJiang_UpdateOpButton(bEnable, flag)

	ShiZhuang_ChouJiang_Wait_Image:Hide()
	ShiZhuang_ChouJiang_Not_Image:Hide()
	ShiZhuang_ChouJiang_Get_Image:Hide()
	if bEnable == 1 then
		ShiZhuang_ChouJiang_Do_Btn:Enable()
	else
		ShiZhuang_ChouJiang_Do_Btn:Disable()
	end
	
	--典金画契
	if flag == 1 then
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("NormalImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn1Normal")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("HoverImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn1Hover")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("PushedImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn1push")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("DisabledImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn1Dis")
		ShiZhuang_ChouJiang_Do_Btn:Show()
		return
	end
	--领取福运签
	if flag == 2 then
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("NormalImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn3Normal")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("HoverImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn3Hover")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("PushedImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn3push")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("DisabledImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn3Dis")
		ShiZhuang_ChouJiang_Do_Btn:Show()
		return
	end
	--领取福运锦鲤
	if flag == 3 then
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("NormalImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn2Normal")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("HoverImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn2Hover")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("PushedImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn2push")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("DisabledImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn2Dis")
		ShiZhuang_ChouJiang_Do_Btn:Show()
		return
	end
	--领取元宝
	if flag == 4 then
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("NormalImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn4Normal")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("HoverImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn4Hover")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("PushedImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn4push")
		ShiZhuang_ChouJiang_Do_Btn:SetProperty("DisabledImage", "set:ShiZhuang_ChouJiang1 image:ShiZhuang_btn4Dis")
		ShiZhuang_ChouJiang_Do_Btn:Show()
		return
	end
	--已领取
	if flag == 5 then
		ShiZhuang_ChouJiang_Do_Btn:Hide()		
		ShiZhuang_ChouJiang_Get_Image:Show()
		return
	end
	--等待开奖
	if flag == 6 then
		ShiZhuang_ChouJiang_Do_Btn:Hide()
		ShiZhuang_ChouJiang_Wait_Image:Show()
		return
	end
	--没报名
	if flag == 7 then
		ShiZhuang_ChouJiang_Do_Btn:Hide()
		ShiZhuang_ChouJiang_Not_Image:Show()
		return
	end
end

function ShiZhuang_ChouJiang_HelpClicked()

end
--Care Obj
function ShiZhuang_ChouJiang_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function ShiZhuang_ChouJiang_Frame_On_ResetPos()
	if g_ShiZhuang_ChouJiang_Frame_UnifiedPosition ~= nil then
		ShiZhuang_ChouJiang_Frame:SetProperty("UnifiedPosition", g_ShiZhuang_ChouJiang_Frame_UnifiedPosition)
	end
end
