
local g_IsAnimate = 0

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_DaHua_StoryLine2_YiHun_Frame_UnifiedXPosition;
local g_DaHua_StoryLine2_YiHun_Frame_UnifiedYPosition;

local g_MySel = 0
--local g_SelectBackCtrl = {}
local g_SelectTextCtrl = {}
local g_SelectWrongImCtrl = {}--??
local g_SelectRightImCtrl = {}--??
local g_YiHun_Animate = {}

function DaHua_StoryLine2_YiHun_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UPDATE_FAKE_OBJECT")
end

function DaHua_StoryLine2_YiHun_OnLoad()

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_DaHua_StoryLine2_YiHun_Frame_UnifiedXPosition	= DaHua_StoryLine2_YiHun_Frame : GetProperty("UnifiedXPosition");
	g_DaHua_StoryLine2_YiHun_Frame_UnifiedYPosition	= DaHua_StoryLine2_YiHun_Frame : GetProperty("UnifiedYPosition");
--	g_SelectBackCtrl = {
--		DaHua_StoryLine2_YiHun_Name1_TipsBk, DaHua_StoryLine2_YiHun_Name2_TipsBk	
--	}
--	g_SelectTextCtrl = {
--		DaHua_StoryLine2_YiHun_Name1_Tips, DaHua_StoryLine2_YiHun_Name2_Tips
--	}
	g_SelectWrongImCtrl = {
		DaHua_StoryLine2_YiHun_Name1_Tips_XuanCuo, DaHua_StoryLine2_YiHun_Name2_Tips_XuanCuo
	}--??
	g_SelectRightImCtrl = {
		DaHua_StoryLine2_YiHun_Name1_Tips_XuanDui, DaHua_StoryLine2_YiHun_Name2_Tips_XuanDui
	}--??
	g_YiHun_Animate = {
		DaHua_StoryLine2_YiHun_Animate1,--??????? ??? 
		DaHua_StoryLine2_YiHun_Animate4,--???????? ???
		DaHua_StoryLine2_YiHun_Animate2,--???????? ???
		DaHua_StoryLine2_YiHun_Animate3,--????????? ???
	}
end

function DaHua_StoryLine2_YiHun_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0)==99916501 then
		local xx = Get_XParam_INT(0);
		if tonumber(xx) == 1 then
			if g_IsAnimate >= 1 then
				--ÌØÐ§ÖÐ
				return
			end
			DaHua_StoryLine2_YiHun_Init()
			DaHua_StoryLine2_YiHun_SetCount()
			this:Show()
		elseif tonumber(xx) == 2 then
			--Ë¢ÐÂ½çÃæ
			if this:IsVisible() then
				--²¥·ÅÌØÐ§
				local ans = Get_XParam_INT(1);
				--PushDebugMessage("ans="..ans)
				g_IsAnimate = 1
				DaHua_StoryLine2_YiHun_Name1_Btn:Disable()
				DaHua_StoryLine2_YiHun_Name2_Btn:Disable()
				DaHua_StoryLine2_YiHun_Pic_Btn:SetText("#{DHEJ_240521_298}")
				DaHua_StoryLine2_YiHun_Pic_Btn:Disable()
				if ans == 1 then
					--ÌÆÉ®ÒÆ»ê¶¯»­
					local ts = math.random(1,2)
					g_YiHun_Animate[ts]:Show()
					g_YiHun_Animate[ts]:Play(true)
				else
					--ËïÎò¿ ÒÆ»ê¶¯»­
					local wk = math.random(3,4)
					g_YiHun_Animate[wk]:Show()
					g_YiHun_Animate[wk]:Play(true)
				end
				SetTimer("DaHua_StoryLine2_YiHun","DaHua_StoryLine2_YiHun_AnimateTimerProc()", 4000)
			end
		elseif tonumber(xx) == 3 then
			--½á¹û·´À¡
			local bCorrect = Get_XParam_INT(1);
			if bCorrect == 1 then
				g_SelectRightImCtrl[g_MySel]:Show()
--				if g_SelectTextCtrl[g_MySel] ~= nil then
--					g_SelectBackCtrl[g_MySel]:Show()
--					g_SelectTextCtrl[g_MySel]:SetText("#{DHEJ_240521_301}")
--				end
			else
				g_SelectWrongImCtrl[g_MySel]:Show()
--				if g_SelectTextCtrl[g_MySel] ~= nil then
--					g_SelectBackCtrl[g_MySel]:Show()
--					g_SelectTextCtrl[g_MySel]:SetText("#{DHEJ_240521_98}")
--				end
			end
			g_IsAnimate = 0
			DaHua_StoryLine2_YiHun_Name1_Btn:Disable()
			DaHua_StoryLine2_YiHun_Name2_Btn:Disable()
			DaHua_StoryLine2_YiHun_Pic_Btn:Show()
			DaHua_StoryLine2_YiHun_Pic_Btn:Enable()
			DaHua_StoryLine2_YiHun_Pic_Btn:SetText("")
			DaHua_StoryLine2_YiHun_SetCount()
		elseif tonumber(xx) == 4 then
			--finish
			DaHua_StoryLine2_YiHun_ClientBK:Hide()
			DaHua_StoryLine2_YiHun_Client2:Hide()
			DaHua_StoryLine2_YiHun_Client2_PicBK:Show()
			SetTimer("DaHua_StoryLine2_YiHun","DaHua_StoryLine2_YiHun_AnimateFinishProc()", 3000)
			DaHua_StoryLine2_YiHun_Pic_Btn:Hide()
			DaHua_StoryLine2_YiHun_SetCount()
		else
			this:Hide()
		end

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide();

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		DaHua_StoryLine2_YiHun_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		DaHua_StoryLine2_YiHun_Frame_On_ResetPos()
	end

end

function DaHua_StoryLine2_YiHun_Init()
	--DaHua_StoryLine2_YiHun_Client:Show()
	DaHua_StoryLine2_YiHun_Info:Show()
	DaHua_StoryLine2_YiHun_Help:Show()
	DaHua_StoryLine2_YiHun_Tips:Show()
	DaHua_StoryLine2_YiHun_ClientBK:Show()
	DaHua_StoryLine2_YiHun_Client2:Hide()
	DaHua_StoryLine2_YiHun_Client2_PicBK:Hide()
	DaHua_StoryLine2_YiHun_Name1_Btn:Disable()
	DaHua_StoryLine2_YiHun_Name2_Btn:Disable()
--	g_SelectBackCtrl[1]:Hide()
--	g_SelectBackCtrl[2]:Hide()
--	g_SelectTextCtrl[1]:SetText("")
--	g_SelectTextCtrl[2]:SetText("")
	g_SelectWrongImCtrl[1]:Hide()
	g_SelectWrongImCtrl[2]:Hide()
	g_SelectRightImCtrl[1]:Hide()
	g_SelectRightImCtrl[2]:Hide()
	DaHua_StoryLine2_YiHun_Pic_Btn:Show()
	DaHua_StoryLine2_YiHun_Pic_Btn:Enable()
	DaHua_StoryLine2_YiHun_Pic_Btn:SetText("")
	for i=1,4 do
		g_YiHun_Animate[i]:Hide()
		g_YiHun_Animate[i]:Play(false)
	end
	DaHua_StoryLine2_YiHun_Client2:Hide()
	g_SelectWrongImCtrl[1]:Hide()
	g_SelectWrongImCtrl[2]:Hide()
	g_SelectRightImCtrl[1]:Hide()
	g_SelectRightImCtrl[2]:Hide()
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function DaHua_StoryLine2_YiHun_Frame_On_ResetPos()

	DaHua_StoryLine2_YiHun_Frame : SetProperty("UnifiedXPosition", g_DaHua_StoryLine2_YiHun_Frame_UnifiedXPosition);
	DaHua_StoryLine2_YiHun_Frame : SetProperty("UnifiedYPosition", g_DaHua_StoryLine2_YiHun_Frame_UnifiedYPosition);

end

function DaHua_StoryLine2_YiHun_ChooseClick(nIdx)
	if g_IsAnimate == 1 then
		--PushDebugMessage("Chßa ðªn gi¶ lña ch÷n")
		return
	end
	g_MySel = nIdx
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnYiHunChoose")
		Set_XSCRIPT_Parameter( 0, nIdx )
		Set_XSCRIPT_ScriptID(999165)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

function DaHua_StoryLine2_YiHun_StartClick()
	if g_IsAnimate >= 1 then
		--PushDebugMessage("cd - t× ði¬n hÕng trung")
		return
	end
--	g_SelectBackCtrl[1]:Hide()
--	g_SelectBackCtrl[2]:Hide()
--	g_SelectTextCtrl[1]:SetText("")
--	g_SelectTextCtrl[2]:SetText("")
	g_SelectWrongImCtrl[1]:Hide()
	g_SelectWrongImCtrl[2]:Hide()
	g_SelectRightImCtrl[1]:Hide()
	g_SelectRightImCtrl[2]:Hide()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnYiHunStart")
		Set_XSCRIPT_ScriptID(999165) 
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function DaHua_StoryLine2_YiHun_OnHide()
	KillTimer("DaHua_StoryLine2_YiHun_AnimateTimerProc()")
	KillTimer("DaHua_StoryLine2_YiHun_AnimateFinishProc()")
	KillTimer("DaHua_StoryLine2_YiHun_AnimateCloseProc()")
	g_IsAnimate = 0
	g_MySel = 0
	this:Hide()
end

function DaHua_StoryLine2_YiHun_HelpClk()
	PushEvent("QUEST_HELPINFO", "#{DHEJ_240521_237}")
end

function DaHua_StoryLine2_YiHun_AnimateTimerProc()
	KillTimer("DaHua_StoryLine2_YiHun_AnimateTimerProc()")
	g_IsAnimate = 2
	--ÇëÑ¡Ôñ
	for i=1,4 do
		g_YiHun_Animate[i]:Hide()
		g_YiHun_Animate[i]:Play(false)
	end
	DaHua_StoryLine2_YiHun_Name1_Btn:Enable()
	DaHua_StoryLine2_YiHun_Name2_Btn:Enable()
	DaHua_StoryLine2_YiHun_Pic_Btn:Disable()
	DaHua_StoryLine2_YiHun_Pic_Btn:SetText("#{DHEJ_240521_299}")
	PushDebugMessage("#{DHEJ_240521_312}")
end

function DaHua_StoryLine2_YiHun_SetCount()
	if DataPool:Lua_IsHaveMission(2312) > 0 then
		local misIndex = DataPool:GetPlayerMissionIndexByID(2312)
		local nCount = DataPool:GetPlayerMission_Variable(misIndex, 4) 
		DaHua_StoryLine2_YiHun_Tips:SetText(ScriptGlobal_Format("#{DHEJ_240521_303}", nCount))
	else
		DaHua_StoryLine2_YiHun_Tips:SetText(ScriptGlobal_Format("#{DHEJ_240521_303}", 0))
	end

end
function DaHua_StoryLine2_YiHun_AnimateFinishProc()
	KillTimer("DaHua_StoryLine2_YiHun_AnimateFinishProc()")
	--DaHua_StoryLine2_YiHun_Client:Hide()
	DaHua_StoryLine2_YiHun_Info:Hide()
	DaHua_StoryLine2_YiHun_Help:Hide()
	DaHua_StoryLine2_YiHun_Tips:Hide()
	DaHua_StoryLine2_YiHun_Client2_PicBK:Hide()
	DaHua_StoryLine2_YiHun_Client2:Show()
	DaHua_StoryLine2_YiHun_Client2_Suwukong:Show()
	DaHua_StoryLine2_YiHun_Client2_Suwukong:Play(true)
	SetTimer("DaHua_StoryLine2_YiHun","DaHua_StoryLine2_YiHun_AnimateCloseProc()", 5000)
end

function DaHua_StoryLine2_YiHun_AnimateCloseProc()
	PushDebugMessage("#{DHEJ_240521_101}")
	DaHua_StoryLine2_YiHun_OnHide()
end
