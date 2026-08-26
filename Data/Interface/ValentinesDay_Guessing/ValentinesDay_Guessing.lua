
local ValentinesDay_Guessing_MainFrame_UnifiedPosition

local ValentinesDay_Guessing_FinishTimes

local ValentinesDay_Guessing_BagPos = -1
local ValentinesDay_Guessing_Select = -1

local ValentinesDay_Guessing_SelectOK = -1
local ValentinesDay_Guessing_DownSceneId = -1

local ValentinesDay_Guessing_BtnCheck = {}
local ValentinesDay_Guessing_ChooseImage = {}
local ValentinesDay_Guessing_WinImage = {}


--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function ValentinesDay_Guessing_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

--=========================================================
-- 载入初始化
--=========================================================
function ValentinesDay_Guessing_OnLoad()

	ValentinesDay_Guessing_BtnCheck = {
		ValentinesDay_Guessing_Frame_Bk1_CheckCity, ValentinesDay_Guessing_Frame_Bk2_CheckCity, ValentinesDay_Guessing_Frame_Bk3_CheckCity
	}
	ValentinesDay_Guessing_ChooseImage = {
		ValentinesDay_Guessing_Frame_Bk1_Choosen, ValentinesDay_Guessing_Frame_Bk2_Choosen, ValentinesDay_Guessing_Frame_Bk3_Choosen
	}
	ValentinesDay_Guessing_WinImage = {
		ValentinesDay_Guessing_Frame_Bk1_Win, ValentinesDay_Guessing_Frame_Bk2_Win, ValentinesDay_Guessing_Frame_Bk3_Win
	}

	ValentinesDay_Guessing_MainFrame_UnifiedPosition = ValentinesDay_Guessing_Frame:GetProperty("UnifiedPosition")
end

--=========================================================
-- 事件处理
--=========================================================
function ValentinesDay_Guessing_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 81012701 then
		local nBagPos = Get_XParam_INT(0)
		if nBagPos >= 0 then
			LifeAbility : Lock_Packet_Item(ValentinesDay_Guessing_BagPos, 0);
			ValentinesDay_Guessing_BagPos = nBagPos
			LifeAbility : Lock_Packet_Item(nBagPos, 1);

			ValentinesDay_Guessing_SelectOK = Get_XParam_INT(1)
			ValentinesDay_Guessing_DownSceneId = Get_XParam_INT(2)

			ValentinesDay_Guessing_Update()
			this:Show()
		elseif nBagPos == -1 then
			this:Hide()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ValentinesDay_Guessing_Frame:SetProperty("UnifiedPosition", ValentinesDay_Guessing_MainFrame_UnifiedPosition)

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ValentinesDay_Guessing_OnHiden()
	end
end


function ValentinesDay_Guessing_CheckClk(nIdx)
	if nIdx >= 1 and nIdx <= 3 then
		ValentinesDay_Guessing_Select = nIdx
		for i=1,3 do
			ValentinesDay_Guessing_ChooseImage[i]:Hide()
			ValentinesDay_Guessing_BtnCheck[i]:SetCheck(0)
		end
		ValentinesDay_Guessing_ChooseImage[nIdx]:Show()
		ValentinesDay_Guessing_BtnCheck[nIdx]:SetCheck(1)
	end
end
function ValentinesDay_Guessing_Update()
	if ValentinesDay_Guessing_SelectOK >=1 and ValentinesDay_Guessing_SelectOK <= 3 then
		for i=1,3 do
			ValentinesDay_Guessing_BtnCheck[i]:SetCheck(0)
			ValentinesDay_Guessing_BtnCheck[i]:Disable()
			ValentinesDay_Guessing_ChooseImage[i]:Hide()
			ValentinesDay_Guessing_WinImage[i]:Hide()
		end
		ValentinesDay_Guessing_BtnCheck[ValentinesDay_Guessing_SelectOK]:SetCheck(1)
		ValentinesDay_Guessing_ChooseImage[ValentinesDay_Guessing_SelectOK]:Show()
		if ValentinesDay_Guessing_DownSceneId > 0 then
			ValentinesDay_Guessing_WinImage[ValentinesDay_Guessing_DownSceneId]:Show()
		end
		ValentinesDay_Guessing_Frame_SelectBtn:Disable()
	else
		for i=1,3 do
			ValentinesDay_Guessing_BtnCheck[i]:SetCheck(0)
			ValentinesDay_Guessing_BtnCheck[i]:Enable()
			ValentinesDay_Guessing_ChooseImage[i]:Hide()
			ValentinesDay_Guessing_WinImage[i]:Hide()
		end
		ValentinesDay_Guessing_Frame_SelectBtn:Enable()
	end
end
--=========================================================
-- 控件事件 - 关睜
--=========================================================
function ValentinesDay_Guessing_Close()
	ValentinesDay_Guessing_OnHiden()
end

--=========================================================
-- 界面关睜事件
--=========================================================
function ValentinesDay_Guessing_OnHiden()
	ValentinesDay_Guessing_Select = -1
	if ValentinesDay_Guessing_BagPos >= 0 then
		LifeAbility : Lock_Packet_Item(ValentinesDay_Guessing_BagPos, 0);
		ValentinesDay_Guessing_BagPos = -1
	end
	ValentinesDay_Guessing_SelectOK = -1
	this:Hide()
end

function ValentinesDay_Guessing_SelectClk()
	if ValentinesDay_Guessing_Select == -1 then
		PushDebugMessage("#{QRWH_221115_46}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSelect")
		Set_XSCRIPT_ScriptID(810127)
		Set_XSCRIPT_Parameter(0, ValentinesDay_Guessing_BagPos)
		Set_XSCRIPT_Parameter(1, ValentinesDay_Guessing_Select-1)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end
