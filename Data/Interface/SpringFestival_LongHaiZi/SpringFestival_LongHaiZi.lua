--!!!reloadscript =SpringFestival_LongHaiZi

local g_SpringFestival_LongHaiZi_Frame_UnifiedPosition

local g_UICOMMAND = 89029101

local g_Camera_ClickNum = 3;
local g_DistanceMin = 3;
local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度
local g_CameraPosition =
{
	[1] = {
		{fHeight = 0.8, fDistance = 10, fPitch=0.2},
		{fHeight = 0.8, fDistance = 6, fPitch=0.2},
		{fHeight = 1, fDistance = 4, fPitch=0.2},
		{fHeight = 1.2, fDistance = 2,  fPitch=0.2}
	},
	[2] = {
		{fHeight = 0.8, fDistance = 10, fPitch=0.2},
		{fHeight = 0.8, fDistance = 6, fPitch=0.2},
		{fHeight = 1, fDistance = 4, fPitch=0.2},
		{fHeight = 1.2, fDistance = 2,  fPitch=0.2}
	}
}
local g_CameraSettingIndex = 1
local g_modelActionXiaRen = 27 
local g_modelActionTaoPao = 26
local g_RequiedModel = 8660

function SpringFestival_LongHaiZi_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SpringFestival_LongHaiZi_OnLoad()
	g_SpringFestival_LongHaiZi_Frame_UnifiedPosition = SpringFestival_LongHaiZi_Frame:GetProperty("UnifiedPosition")
	
end
local function UpdateCamera()
		
	local fHeight = g_CameraPosition[g_CameraSettingIndex][g_Camera_ClickNum].fHeight
	local fDistance = g_CameraPosition[g_CameraSettingIndex][g_Camera_ClickNum].fDistance
	local fPitch = g_CameraPosition[g_CameraSettingIndex][g_Camera_ClickNum].fPitch

	FakeObj_SetCamera("LongHaiZi", g_CameraHeight, fHeight)
	FakeObj_SetCamera("LongHaiZi", g_CameraDistance, fDistance)
	FakeObj_SetCamera("LongHaiZi", g_CameraPitch, fPitch)
end

function SpringFestival_LongHaiZi_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
        local nOpt = Get_XParam_INT(0)
		if nOpt == 1 then
			--打开界面
			g_Camera_ClickNum = 2
			local nModelId = Get_XParam_INT(1)
			SpringFestival_LongHaiZi_FakeObject:SetFakeObject("")
			DataPool:SetLongHaiZiModel(nModelId)
			SpringFestival_LongHaiZi_FakeObject:SetFakeObject("LongHaiZi")
			this:Show()
			if g_RequiedModel == nModelId then
				g_CameraSettingIndex = 2
			else
				g_CameraSettingIndex = 1
			end
			local nAction = Get_XParam_INT(2)
			if nAction == 1 then
				DataPool:ChangeLongHaiZiAction(g_modelActionXiaRen)
				SpringFestival_LongHaiZi_Button_Close:Disable()
				SpringFestival_LongHaiZi_FiveSecCloseUI()
			elseif nAction == 2 then
				DataPool:ChangeLongHaiZiAction(g_modelActionTaoPao)
				SpringFestival_LongHaiZi_Button_Close:Disable()
				SpringFestival_LongHaiZi_FiveSecCloseUI()
			else
				SpringFestival_LongHaiZi_Button_Close:Enable()
			end
			local name = Get_XParam_STR(0)
			local txt = Get_XParam_STR(1)
			SpringFestival_LongHaiZi_PageHeader_Name:SetText(ScriptGlobal_Format("#{LNDK_231025_138}",name))
			SpringFestival_LongHaiZi_Text:SetText(txt)
			UpdateCamera()
		end
	end
	
	if event == "PLAYER_LEAVE_WORLD" then		
		this:Hide()
		return
	end
	
		
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SpringFestival_LongHaiZi_Frame_On_ResetPos()
	end
end




function SpringFestival_LongHaiZi_OnHiden()
	SpringFestival_LongHaiZi_FakeObject:SetFakeObject("")
end


function SpringFestival_LongHaiZi_OnClose()
	this:Hide()
end

-- function SpringFestival_LongHaiZi_OnHelp()
-- 	Helper:GotoHelper("*SpringFestival_LongHaiZi")
-- end

function SpringFestival_LongHaiZi_Frame_On_ResetPos()
  SpringFestival_LongHaiZi_Frame:SetProperty("UnifiedPosition", g_SpringFestival_LongHaiZi_Frame_UnifiedPosition)
end

function SpringFestival_LongHaiZi_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		SpringFestival_LongHaiZi_FakeObject:RotateBegin(-0.3)
	--stop
	else
		SpringFestival_LongHaiZi_FakeObject:RotateEnd()
	end
end

function SpringFestival_LongHaiZi_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		SpringFestival_LongHaiZi_FakeObject:RotateBegin(0.3)
	--stop
	else
		SpringFestival_LongHaiZi_FakeObject:RotateEnd()
	end
end



function SpringFestival_LongHaiZi_ZoomOut()
	if g_Camera_ClickNum <= 1 then
		return;
	end
	g_Camera_ClickNum = g_Camera_ClickNum - 1;
	UpdateCamera()
end

function SpringFestival_LongHaiZi_ZoomIn()
	if g_Camera_ClickNum >= 4 then
		return;
	end
	g_Camera_ClickNum = g_Camera_ClickNum + 1;
	UpdateCamera()
end

function SpringFestival_LongHaiZi_FiveSecCloseUI()
	KillTimer("SpringFestival_LongHaiZi_OnFiveSecCloseUI()")
	SetTimer("SpringFestival_LongHaiZi","SpringFestival_LongHaiZi_OnFiveSecCloseUI()", 5000)
end

function SpringFestival_LongHaiZi_OnFiveSecCloseUI()
    KillTimer("SpringFestival_LongHaiZi_OnFiveSecCloseUI()")
    SpringFestival_LongHaiZi_OnClose()
end


