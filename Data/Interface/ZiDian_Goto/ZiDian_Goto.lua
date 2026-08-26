local g_ZiDian_Goto_Frame_UnifiedXPosition
local g_ZiDian_Goto_Frame_UnifiedYPosition

local g_ZiDian_Goto_Xunlu =
{
	[1] = {PosX = 177, PosZ = 179, Scene = 1, Name = "Tr呓ng Tr誧h 衞an"},
}

--预加载函数，可以而且只能在犫里注册脚本关心的事件
function ZiDian_Goto_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function ZiDian_Goto_OnLoad()
	-- 保存界面的默认相对位置
	g_ZiDian_Goto_Frame_UnifiedXPosition	= ZiDian_Goto_Frame:GetProperty("UnifiedXPosition");
	g_ZiDian_Goto_Frame_UnifiedYPosition	= ZiDian_Goto_Frame:GetProperty("UnifiedYPosition");

end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZiDian_Goto_ResetPos()
	ZiDian_Goto_Frame:SetProperty("UnifiedXPosition", g_ZiDian_Goto_Frame_UnifiedXPosition);
	ZiDian_Goto_Frame:SetProperty("UnifiedYPosition", g_ZiDian_Goto_Frame_UnifiedYPosition);
end


--响应事件的函数，当注册的事件发生时会调用的函数
function ZiDian_Goto_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber( arg0 ) == 99982600 then	
		local cmdType = Get_XParam_INT(0)
		if cmdType == 1 then
			--打开界面
			ZiDian_Goto_Show(Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6))
		elseif cmdType == 2 then
			--寻路
			ZiDian_Goto_Goto()
		end
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then	
		ZiDian_Goto_OnHide()
		
	elseif event == "ADJEST_UI_POS" then	
		ZiDian_Goto_ResetPos()
		
	elseif event == "VIEW_RESOLUTION_CHANGED" then	
		ZiDian_Goto_ResetPos()
		
	end
end

--显示UI
function ZiDian_Goto_Show(yy1,mm1,dd1,yy2,mm2,dd2)
	ZiDian_Goto_Text:SetText(ScriptGlobal_Format("#{QCXY_250704_07}", yy1,mm1,dd1,yy2,mm2,dd2))
	Lua_ShowQuickEnterPointTip(45, 0)
	this:Show()
end

--隐藏UI
function ZiDian_Goto_OnHide()
	this:Hide()
end


function ZiDian_Goto_Goto()
	--前往寻路
	AutoRuntoTargetExWithName(g_ZiDian_Goto_Xunlu[1].PosX,g_ZiDian_Goto_Xunlu[1].PosZ,g_ZiDian_Goto_Xunlu[1].Scene,g_ZiDian_Goto_Xunlu[1].Name)
	ZiDian_Goto_OnHide()
	
end


function ZiDian_Goto_HelpClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("FCHelpClicked")
		Set_XSCRIPT_ScriptID(999826)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function ZiDian_Goto_GotoClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("FCGotoClicked")
		Set_XSCRIPT_ScriptID(999826)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end


