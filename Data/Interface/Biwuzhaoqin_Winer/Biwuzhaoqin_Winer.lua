local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Biwuzhaoqin_Winer_Role = 0


function Biwuzhaoqin_Winer_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SCENE_TRANSED",false)

end

function Biwuzhaoqin_Winer_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Biwuzhaoqin_Winer_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Biwuzhaoqin_Winer_Frame:GetProperty("UnifiedYPosition");
end

function Biwuzhaoqin_Winer_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Biwuzhaoqin_Winer_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		Biwuzhaoqin_Winer_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 79210805) then
		local finalpk = Get_XParam_INT(0)

		if finalpk == -1 then
			Biwuzhaoqin_Winer_OnClose()
			return
		elseif finalpk == 0 or finalpk == 1 then
			g_Biwuzhaoqin_Winer_Role = Get_XParam_INT(1)
			local winnername = Get_XParam_STR(0)
			Biwuzhaoqin_Winer_Update(finalpk, winnername)
			this:Show()
		elseif finalpk == 2 then
			Biwuzhaoqin_Winer_Text:SetText("#{BWZQ_20230329_381}")
			Biwuzhaoqin_Winer_OK:Hide()
			Biwuzhaoqin_Winer_Cancel:Hide()
		end
		
	elseif( event == "SCENE_TRANSED" ) then		
		Biwuzhaoqin_Winer_OnClose()
	end
end

function Biwuzhaoqin_Winer_Update(finalpk, winnername)
	if finalpk == 1 then
		Biwuzhaoqin_Winer_InfoBK1:Show()
		Biwuzhaoqin_Winer_InfoBK2:Hide()
		--Biwuzhaoqin_Winer_Info:SetText("#{BWZQ_20230329_377}")
		Biwuzhaoqin_Winer_Info2:SetText("#G"..winnername)
	else
		Biwuzhaoqin_Winer_InfoBK1:Hide()
		Biwuzhaoqin_Winer_InfoBK2:Show()
		--Biwuzhaoqin_Winer_Info:SetText("#{BWZQ_20230329_376}")
		--Biwuzhaoqin_Winer_Info2:SetText("")
	end
	if g_Biwuzhaoqin_Winer_Role == 1 then
		Biwuzhaoqin_Winer_Text:SetText("#{BWZQ_20230329_379}".."#{BWZQ_20230329_380}")
		Biwuzhaoqin_Winer_OK:Show()
		Biwuzhaoqin_Winer_Cancel:Show()
	else
		Biwuzhaoqin_Winer_Text:SetText("#{BWZQ_20230329_382}")
		Biwuzhaoqin_Winer_OK:Hide()
		Biwuzhaoqin_Winer_Cancel:Hide()
	end
	SetTimer("Biwuzhaoqin_Winer","Biwuzhaoqin_Winer_OnClose()", 10000)
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_Winer_ResetPos()
	Biwuzhaoqin_Winer_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Biwuzhaoqin_Winer_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function Biwuzhaoqin_Winer_OnClose()
	this:Hide()
	KillTimer("Biwuzhaoqin_Winer_OnClose()");		--?????
end

function Biwuzhaoqin_Winer_Accept()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GotoBHGSure" )
		Set_XSCRIPT_ScriptID( 792108 )
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()
end
function Biwuzhaoqin_Winer_CancelClick()
	if g_Biwuzhaoqin_Winer_Role == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GotoBHGSure" )
			Set_XSCRIPT_ScriptID( 792108 )
			Set_XSCRIPT_Parameter(0, 0)
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
	Biwuzhaoqin_Winer_OnClose()
end
