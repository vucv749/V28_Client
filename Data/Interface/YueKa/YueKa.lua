local g_YueKa_Frame_UnifiedYPosition;
local g_YueKa_Frame_UnifiedYPosition;  

function YueKa_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
	this:RegisterEvent("UPDATE_DOUBLE_EXP") 
end

function YueKa_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		YueKa_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		YueKa_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		YueKa_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		YueKa_Close()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89266604 ) then		  
		if ( IsWindowShow( "YueKa" ) == false ) then
            YueKa_OnShown()
        else
            YueKa_Close()    
        end 
    elseif(event == "UPDATE_DOUBLE_EXP" ) then

        local DT = SystemSetup : GetDoubleExp("remaintime");
		if DT > 0 then 
			YueKa_Text3:Show() 
            YueKa_Text3:SetProperty("Timer",DT); 
            YueKa_Text4:Hide()
		else  
            YueKa_Text3:Hide()
            YueKa_Text4:Show()
		end
	end
end

function YueKa_OnLoad()  
	-- 保存界面的默认相对位置
	g_YueKa_Frame_UnifiedXPosition	= YueKa_Frame:GetProperty("UnifiedXPosition");
	g_YueKa_Frame_UnifiedYPosition	= YueKa_Frame:GetProperty("UnifiedYPosition"); 
end 

function YueKa_OnShown() 
	
	if IsWindowShow("Bank") then
		CloseWindow("Bank", true)
	end
	if IsWindowShow("Shop") then
		CloseWindow("Shop", true)
	end
	if IsWindowShow("DressBoxFrame") then
		CloseWindow("DressBoxFrame", true)
	end
	
	if(IsWindowShow("PetBankList")) then
		CloseWindow("PetBankList", true); 
	end
	
	if(IsWindowShow("TargetPet")) then
		CloseWindow("TargetPet", true); 
	end
	
	if(IsWindowShow("TargetPet2")) then
		CloseWindow("TargetPet2", true); 
	end
	
	if(IsWindowShow("PetBankMain")) then
		CloseWindow("PetBankMain", true);
	end
	
	if(IsWindowShow("BigBank")) then
		CloseWindow("BigBank", true);
	end

    local year  = Get_XParam_INT( 0 );
    local month = Get_XParam_INT( 1 );
    local day   = Get_XParam_INT( 2 );
    local Name  = Player:GetName()
    YueKa_Text1:SetText(ScriptGlobal_Format("#{HJYK_201223_13}", Name,year,month,day))
	this:Show();
end 

--================================================
-- 界面的默认相对位置
--================================================
function YueKa_ResetPos()
	YueKa_Frame:SetProperty("UnifiedXPosition", g_YueKaFrame_UnifiedXPosition);
	YueKa_Frame:SetProperty("UnifiedYPosition", g_YueKa_Frame_UnifiedYPosition); 
end 

function YueKa_Close() 
	this:Hide();
end

function YueKa_Help() 
    PushEvent("YUEKA_HELP")
end

function YueKa_Btn_Clicked(index)    
	if index == 10 then
		YueKa_LevelupReduceExp_Help()
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoFunc")
			Set_XSCRIPT_ScriptID(892666) 
    	Set_XSCRIPT_Parameter( 0, index );					-- ??? 
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end

function YueKa_LevelupReduceExp_Help()
	local nYueKaExpRate = Player:GetData("YUEKAEXPRATE");
	if nYueKaExpRate <= 0 then
		PushDebugMessage("#{HJYK_201223_17}")
		return
	end
	
	local nServerLevel = Player:GetData("SERVERLEVEL");
	local nPlayerLevel = Player:GetData("LEVEL");
	local nRegularNeedExp = Player:GetData("REGULARNEEDEXP");
	if tonumber(nRegularNeedExp) == nil then
		nRegularNeedExp = 0
	end
	local szMsg = "";
	if nPlayerLevel > nServerLevel then
		szMsg = ScriptGlobal_Format("#{HJYK_230821_8}", nServerLevel, nRegularNeedExp )
	elseif nPlayerLevel == nServerLevel then
		szMsg = ScriptGlobal_Format("#{HJYK_230821_7}", nServerLevel, nRegularNeedExp )
	else
		local nLevel = nServerLevel - nPlayerLevel;
		if nLevel == 1 then
			szMsg = ScriptGlobal_Format("#{HJYK_230821_3}", nServerLevel, nRegularNeedExp )
		elseif nLevel == 2 then
			szMsg = ScriptGlobal_Format("#{HJYK_230821_4}", nServerLevel, nRegularNeedExp )
		elseif nLevel == 3 then
			szMsg = ScriptGlobal_Format("#{HJYK_230821_5}", nServerLevel, nRegularNeedExp )
		else
			szMsg = ScriptGlobal_Format("#{HJYK_230821_6}", nServerLevel, nRegularNeedExp )
		end
	end
	
	PushEvent("OPEN_QUEST_HELP_MSG", "#{HJYK_230821_2}", szMsg ) 
	PushDebugMessage("#{HJYK_230821_15}")
end
