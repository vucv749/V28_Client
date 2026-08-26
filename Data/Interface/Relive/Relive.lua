--***********************************************************************************************************************************************
-- ¸´»î½çÃæ		
--×¢Òâ£¬´Ë½çÃæÎª¸´»î×¨ÓÃ£¬Çë²»ÒªÓÃÀ´×öÆäËûÓÃÍ¾
--***********************************************************************************************************************************************
local Current_status = 0;
local Current_Quest = -1;
-------------------------------------------------------------------------------------------------------------------------------------------------
--
-- ´Ë´¦¶¨ÒåÐèÒª±£´æÊý¾ÝµÄ¾Ö²¿±äÁ¿
--

--------------------------------------------------------
-- µ±Ç°¶Ô»°¿òµÄ²Ù×÷ÀàÐÍ
local g_Event;

local Event_Relive = 0;
local Event_Callof = 1;
local g_newPlayerReliveSceneRes = {	--?????????? CLIENTRESID
      548
}
local g_relive_tjc_res = 618
local g_relive_dlsy_res = 639	-- ????????id
local g_relive_SpecialItem = 0;

function Relive_IsSpecialSceneResID()
	local curSceneID = GetSceneID()
	for i = 1, table.getn(g_newPlayerReliveSceneRes) do
		if curSceneID == g_newPlayerReliveSceneRes[i] then
			return 1
		end
	end
	return 0
end
--***********************************************************************************************************************************************
--
-- OnLoad
--
--************************************************************************************************************************************************
function Relive_PreLoad()

	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("RELIVE_HIDE");
	this:RegisterEvent("RELIVE_REFESH_TIME");

	--À­ÈË¼¼ÄÜ
	this:RegisterEvent("OPEN_CALLOF_PLAYER");
	
end

function Relive_OnLoad()
end


--***********************************************************************************************************************************************
--
-- ÊÂ¼þÏìÓ¦º¯Êý
--
--
--************************************************************************************************************************************************
function Relive_OnEvent(event)
	AxTrace( 0,0, "here");
	if ( event == "RELIVE_SHOW" ) then
		if Relive_IsSpecialSceneResID() == 1 then  
			Relive_Text:SetText("#{XSLDZ_180521_125}")
			Question_Text:SetText("#gFF0FA0s¯ng lÕi");
			Relive_Release_Button:SetText("H°i Dinh")
			Relive_Release_Button:Show()
			Relive_Release_Button:Enable()
			Relive_Time_Text : SetProperty("Timer",tostring(arg2)); 
			Question_Help:Disable();
			Question_Close:Disable();
			Relive_Fool_Button:Hide()
			--ÓÐ¸´»î°´Å¥
			if ( arg1 == "1" ) then
				Relive_Relive_Button:Enable();
			--ÎÞ¸´»î°´Å¥
			else
				Relive_Relive_Button:Disable();
			end
			Current_status = 0;
			this:Show();
			g_Event = Event_Relive;
			return 
		end
		if Relive_IsTJCPVPSceneResID() == 1 then
			Relive_Text:SetText("#{BLDPVP_221214_146}")
		elseif (Relive_IsDLSYScene() == 1) then
			Relive_Text:SetText("#{DLZX_230518_94}")
		elseif Relive_IsPTDBScene() == 1 then
			Relive_Text:SetText("#{PTDB_231225_9}")
		elseif Relive_IsKFRCBOSSScene() == 1 then
			Relive_Text:SetText("#{KFRC_240326_100}")
		else
			Relive_Text:SetText( "Nhî ðã tØ vong, Ðãn b·i vì Nhî Ð¯i nhân gian còn có chút HÑa Ch¤p Ni®m, các hÕ tiªp tøc ch¶ Ðãi vçn là linh h°n xu¤t khiªu?" );
		end
		
--		Relive_Time_Text:SetText( arg2 );
		Relive_Time_Text : SetProperty("Timer",tostring(arg2));
		--ÓÐ¸´»î°´Å¥
		if ( arg0 == "1" ) then
			Relive_Fool_Button:Enable();
		--ÎÞ¸´»î°´Å¥
		else
			Relive_Fool_Button:Disable();
		end
		--ÓÐ¸´»î°´Å¥
		if ( arg1 == "1" ) then
			Relive_Relive_Button:Enable();
		--ÎÞ¸´»î°´Å¥
		else
			Relive_Relive_Button:Disable();
		end
		
		g_relive_SpecialItem = tonumber(arg3)
		Question_Help:Disable();
		Question_Close:Disable();
		Current_status = 0;
		Relive_Fool_Button:SetText("Tân thü");
		Relive_Release_Button:SetText("Xu¤t khiªu");
		Relive_Relive_Button:SetText("S¯ng lÕi"); 
		Question_Text:SetText("#gFF0FA0s¯ng lÕi");
		this:Show();
		g_Event = Event_Relive;

	elseif ( event == "RELIVE_HIDE" ) then
		Current_status = 0;
		this:Hide();

	elseif ( event == "RELIVE_REFESH_TIME" ) then
	
		Relive_Time_Text : SetProperty("Timer",tostring(arg0));
		Current_status = 0;
	
		
	elseif ( event == "OPEN_CALLOF_PLAYER" )  then
		
		Relive_Text:SetText(arg0 .. "LÕp Nhî quá khÑ, có ð°ng ý hay không A?");
			
		Relive_Release_Button:SetText("Xác nh§n");
		Relive_Relive_Button:SetText("Hüy bö");

		Question_Text:SetText("#gFF0FA0LÕp Nhân");

		Relive_Time_Text:SetProperty("Timer",tostring( arg3 ));
		this:Show()
		g_Event = Event_Callof;
		
	end
end



--***********************************************************************************************************************************************
--
-- µã»÷³öÇÏ°´Å¥
--
--
--************************************************************************************************************************************************
function Relive_Out_Ghost()

	if( g_Event == Event_Callof )  then
		Friend:CallOf("ok");
		this:Hide();
	
	elseif(g_Event == Event_Relive)then
		if(Current_status == 1) then
			if(Current_Quest > -1) then
				QuestFrameMissionAbnegate(Current_Quest);
			end
			this:Hide();
			return;
		else
			if Relive_IsTJCPVPSceneResID() == 1 then
				if DataPool:LuaFnIsCanReliveInTJCPVP() < 1 then
					return
				end
			elseif Relive_IsDLSYScene() == 1 then
				if DataPool:LuaFnIsCanReliveInDLSY() < 1 then
					return
				end
			elseif Relive_IsPTDBScene() == 1 then
				if PTDB:LuaFnIsCanRelive() < 1 then
					return
				end
			elseif Relive_IsKFRCBOSSScene() == 1 then
				if KFRCBOSS:LuaFnKFRCBOSSIsCanRelive() < 1 then
					return
				end
			end
			Player:SendReliveMessage_OutGhost();
		end
		
	end

end


--***********************************************************************************************************************************************
--
-- µã»÷¸´»î°´Å¥
--
--
--***********************************************************************************************************************************************
function Relive_Relive()

	if( g_Event == Event_Relive )  then
		if(Current_status == 1) then
			this:Hide();
			return;
		else
			-- »¹»êÁéÂ¶ÌØÐ´
			if g_relive_SpecialItem == 1 then 
				PushEvent("CONFIRM_RELIVE_SPECIALITEM")
				local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(30007044)
				if nHaveCount <= 0 then 
					Relive_Relive_Button:Disable();
				end
			else
				Player:SendReliveMessage_Relive();
			end
		end;
		 
	elseif(g_Event == Event_Callof)then 
		this:Hide();
	
	end

end

--¼ÆÊ±Æ÷£½0
function Relive_Time_Zero()
	if( g_Event == Event_Callof )  then
		this:Hide();
	end;

end

function Relive_Out_Fool()
	Player:SendReliveMessage_Fool();
end

function Relive_IsTJCPVPSceneResID()
	local curSceneID = GetSceneID()
	if curSceneID == g_relive_tjc_res then
		return 1
	end

	return 0
end

-- ÊÇ·ñµÛÁêÉîÔ¨³¡¾°
function Relive_IsDLSYScene()
	local curSceneID = GetSceneID()
	if (curSceneID == g_relive_dlsy_res) then
		return 1
	end

	return 0
end -- end func Relive_IsDLSYScene()

-- ÊÇ·ñÅÀËþ¶á±¦³¡¾°
function Relive_IsPTDBScene()
	local curSceneID = GetSceneID()
	local isOk = PTDB:LuaFnIsPTDBScene(curSceneID)
	if (isOk > 0) then
		return 1
	end

	return 0
end -- end func Relive_IsPTDBScene()

-- ÊÇ·ñ¿ç·þÈ ³£BOSS
function Relive_IsKFRCBOSSScene()
	local curSceneID = GetSceneID()
	local isOk = KFRCBOSS:LuaFnIsCKFRCBOSSScene(curSceneID)
	if (isOk > 0) then
		return 1
	end

	return 0
end -- end func Relive_IsKFRCBOSSScene()
