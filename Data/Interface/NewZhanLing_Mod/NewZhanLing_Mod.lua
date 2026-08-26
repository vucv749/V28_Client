local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

--******************************
--牻令补充进度界面
--******************************



function NewZhanLing_Mod_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("UPDATE_YUANBAO",false)
end

function NewZhanLing_Mod_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		NewZhanLing_Mod_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		NewZhanLing_Mod_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
        this:Hide()

    elseif event == "UI_COMMAND" and (tonumber(arg0) == 99852604) then	--??????
		NewZhanLing_Mod_Open()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 99852605) then	--??????
		local bIsShowHotPoint1 = Get_XParam_INT(0)
		local bIsShowHotPoint2 = Get_XParam_INT(1)
		local bIsShowHotPoint3 = Get_XParam_INT(2)
		local bIsShowHotPoint4 = Get_XParam_INT(3)
		local bIsShowHotPoint5 = Get_XParam_INT(4)
		if bIsShowHotPoint1 == 1 then
			NewZhanLing_Mod_Pic1Btn_Tips:Show()
		else
			NewZhanLing_Mod_Pic1Btn_Tips:Hide()
		end
		if bIsShowHotPoint2 == 1 then
			NewZhanLing_Mod_Pic2Btn_Tips:Show()
		else
			NewZhanLing_Mod_Pic2Btn_Tips:Hide()
		end
		if bIsShowHotPoint3 == 1 then
			NewZhanLing_Mod_Pic3Btn_Tips:Show()
		else
			NewZhanLing_Mod_Pic3Btn_Tips:Hide()
		end
		if bIsShowHotPoint4 == 1 then
			NewZhanLing_Mod_Pic4Btn_Tips:Show()
		else
			NewZhanLing_Mod_Pic4Btn_Tips:Hide()
		end
		if bIsShowHotPoint5 == 1 then
			NewZhanLing_Mod_Pic5Btn_Tips:Show()
		else
			NewZhanLing_Mod_Pic5Btn_Tips:Hide()
		end
	end
end

function NewZhanLing_Mod_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= NewZhanLing_Mod_Frame:GetProperty("UnifiedXPosition")
	g_Frame_UnifiedYPosition	= NewZhanLing_Mod_Frame:GetProperty("UnifiedYPosition")
end

function NewZhanLing_Mod_Open()
  
    this:Show()
end



function NewZhanLing_Mod_Close()
    this:Hide()
end

--================================================
-- 界面的默认相对位置
--================================================
function NewZhanLing_Mod_ResetPos()
	NewZhanLing_Mod_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	NewZhanLing_Mod_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

-- index:1新牻令，2游龙卡，3扫荡，4天鉴神卷, 5扫荡银币(铜符)获取：每葼2个副本
function NewZhanLing_Mod_Enter_Clicked(index)
    if index == 1 then
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
	elseif  index == 2 then
		local isInHell = IsInHell()
		if isInHell == 1 then--??????????
			PushDebugMessage("#{HJYK_201223_46}")
			return
		end
		
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnClickOpenBtn")
		Set_XSCRIPT_ScriptID(892666) 
		Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif  index == 3 then--
		local nPlayerLevel = Player:GetData("LEVEL")
		if nPlayerLevel < 15 then
			if ( IsWindowShow( "SweepAll" ) ) then
				CloseWindow( "SweepAll", true );
				return
			end
		end	
		OpenSecKillList();
	elseif  index == 4 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "AskOpenMainUI" )
			Set_XSCRIPT_ScriptID( 890215 )
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif index == 5 then--??????
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnOpenUI")
			Set_XSCRIPT_ScriptID(890289)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
end
