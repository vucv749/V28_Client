local g_Makefriends_Rest_Frame_UnifiedXPosition;
local g_Makefriends_Rest_Frame_UnifiedYPosition;

function Makefriends_Rest_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SOCIALACTIVITYES_REST_XXS_MINI");
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function Makefriends_Rest_OnLoad()
    g_Makefriends_Rest_Frame_UnifiedXPosition	= Makefriends_Rest_Frame : GetProperty("UnifiedXPosition");
	g_Makefriends_Rest_Frame_UnifiedYPosition	= Makefriends_Rest_Frame : GetProperty("UnifiedYPosition");
end

function Makefriends_Rest_On_ResetPos()

	
	Makefriends_Rest_Frame : SetProperty("UnifiedXPosition", g_Makefriends_Rest_Frame_UnifiedXPosition);
	Makefriends_Rest_Frame : SetProperty("UnifiedYPosition", g_Makefriends_Rest_Frame_UnifiedYPosition);

end

function Makefriends_Rest_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		if arg0=="jiaoyou_xiuxi" then
            SocialActivitesDataPool:ClearSocialAvtivitesData()
			Makefriends_Rest_Info6:SetProperty("Timer", tonumber(0));
			Makefriends_Rest_Info8:SetProperty("Timer", tonumber(0));
			Makefriends_Rest_Info4:SetText("")
			Makefriends_Rest_Info1:SetText("#{JYHD_230331_31}")
		else
			this:Hide()
		end
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="SOCIALACTIVITYES_REST_XXS_MINI") then
		if arg0=="1" then
			Makefriends_Rest_Info6:SetProperty("Timer", tonumber(0));
			Makefriends_Rest_Info8:SetProperty("Timer", tonumber(0));
			Makefriends_Rest_Info4:SetText("")
			Makefriends_Rest_Info10:SetText("")
			Makefriends_Rest_Info1:SetText("#{JYHD_230331_31}")
			this:Show()
		else
			this:Hide()
		end

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99833402 ) then

		if 1300 == GetSceneServerID() then
			Makefriends_Rest_Info1:SetText("#{JYHD_230331_31}")
		end

		local time = Get_XParam_INT(0)
		local memcount = Get_XParam_INT(1)
		local daibi = Get_XParam_INT(2)
		local strdaibi = ScriptGlobal_Format("#{JYHD_230331_144}", daibi)
		Makefriends_Rest_Info6:SetProperty("Timer", tonumber(time));
		Makefriends_Rest_Info4:SetText(memcount)
		Makefriends_Rest_Info10:SetText(strdaibi)

		local sec = Lua_GetDiffTime_InSecond_ServerTime(23,59,59)
		Makefriends_Rest_Info8:SetProperty("Timer", tonumber(sec));
                this:Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20230410 ) then
		if( this:IsVisible() ) then
			if 1300 == GetSceneServerID() then
				Makefriends_Rest_Info1:SetText("#{JYHD_230331_31}")
			end

			local time = Get_XParam_INT(0)
			local memcount = Get_XParam_INT(1)
			local daibi = Get_XParam_INT(2)
			local strdaibi = ScriptGlobal_Format("#{JYHD_230331_144}", daibi)
			Makefriends_Rest_Info6:SetProperty("Timer", tonumber(time));
			Makefriends_Rest_Info4:SetText(memcount)
			Makefriends_Rest_Info10:SetText(strdaibi)

			local sec = Lua_GetDiffTime_InSecond_ServerTime(23,59,59)
			
			Makefriends_Rest_Info8:SetProperty("Timer", tonumber(sec));
		end	
	elseif (event == "ADJEST_UI_POS" ) then
		
		Makefriends_Rest_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		
		Makefriends_Rest_On_ResetPos();
	end
end

function Makefriends_Rest_Open()

end

function Makefriends_Rest_Close()

end

function Makefriends_Rest_OpenMini()

	this:Hide()
	PushEvent("SOCIALACTIVITYES_REST_XXS_MINI",0)
end