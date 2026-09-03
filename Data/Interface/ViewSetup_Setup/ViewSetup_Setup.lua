
local ViewSetup = {};
local viewSetNum = 15;
local g_ViewSetup_Setup_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function ViewSetup_Setup_PreLoad()

	this:RegisterEvent("OPEN_OPTIMIZE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function ViewSetup_Setup_OnLoad()
		
		ViewSetup[1]   = "dxyy" 	--????				View_LightmapQuality
		ViewSetup[2]   = "fhj"		--?????			View_Fanhunjiao
		ViewSetup[3]   = "wtdh"		--????				View_ObjectMove
		ViewSetup[4]   = "rwyy"		--????				View_HumanLightmap
		ViewSetup[5]   = "ksfw"		--????? ????	View_VisibleRangeLevelNew
		ViewSetup[6]   = "dhgxzl"	--????				View_UpdateQuality
		ViewSetup[7]   = "yszl"		--????	???		View_ColorQuality
		ViewSetup[8]  = "cy"		 	--??					View_TextureFiltering
		ViewSetup[9]  = "txdjsz"	--????				View_EffectLevel
	--	ViewSetup[10]  = "mxxslj"	--Ä£ÐÍÏÔÊ¾				View_ModelShowLogic

		ViewSetup[10]   = "qpfg"	-- ????
		ViewSetup[11]   = "rt"	-- ??
		ViewSetup[12]   = "miwu"	-- ????
		ViewSetup[13]   = "zdbt"	-- ????
		ViewSetup[14]   = "qpms"	-- ????
		ViewSetup[15]   = "cztb"	-- ????
		
		g_ViewSetup_Setup_Frame_UnifiedPosition=ViewSetup_Setup_Frame:GetProperty("UnifiedPosition");
			
end

--===============================================
-- OnEvent()
--===============================================
function ViewSetup_Setup_OnEvent(event)

	if ( event == "OPEN_OPTIMIZE" ) then
		this:Show();
		
	elseif (event == "ADJEST_UI_POS" ) then
		ViewSetup_Setup_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ViewSetup_Setup_Frame_On_ResetPos()
	end

end

--ÏÔÊ¾ÉèÖÃ nIndex 1ËÙ¶ÈÓÅÏÈ 2¾ùºâÉèÖÃ
function ViewSetup_Setup_ClickViewSetup(nIndex)

	if( nIndex == 1 )then
		local setting =  {0, 0, 0, 0, 2, 0, 0, 0, 0,  0, 0, 1, 0, 0, 1}	--????; 

		local bNeedReset1 = tonumber(SystemSetup:View_GetData(ViewSetup[2])) ~= setting[2];
		local bNeedReset2 = tonumber(SystemSetup:View_GetData(ViewSetup[15])) ~= setting[15];

		if(bNeedReset1 or bNeedReset2) then
			PushDebugMessage("Kh·i ðµng lÕi trò ch½i");
		end

		for i=1, viewSetNum do
			SystemSetup:View_SetData(ViewSetup[i], setting[i]);
		end
	
	else
		local setting = {2, 0, 2, 2, 2, 2, 2, 2, 2,  0, 0, 1, 0, 0, 1}	--????

		local bNeedReset1 = tonumber(SystemSetup:View_GetData(ViewSetup[2])) ~= setting[2];
		local bNeedReset2 = tonumber(SystemSetup:View_GetData(ViewSetup[15])) ~= setting[15];

		if(bNeedReset1 or bNeedReset2) then
			PushDebugMessage("Kh·i ðµng lÕi trò ch½i");
		end
	
		for i=1, viewSetNum do
			SystemSetup:View_SetData(ViewSetup[i], setting[i]);
		end
	end

--¸üÐÂ²Ù×÷
		SystemSetup:OptimizeConfirm()
end

--¹Ø± Ìì¿ ÊÓ½Ç
function ViewSetup_Setup_CloseSkyEye()

		local string = "tksj";	
	  SystemSetup:View_SetData( string, 0);
	  
	 SystemSetup:OptimizeConfirm()
	
end


--·Ö±æÂÊ nIndex 1-1024*768 2-800*600
function ViewSetup_Setup_ScreenSize(nIndex)
			
	--È«ÆÁÄ£Ê½µÄ»°,ÒªÏÈ¸ÄÎª·ÇÈ«ÆÁ
	local  bFullScreen = SystemSetup:View_GetData(ViewSetup[14]);
	if bFullScreen ~= 0 then
		SystemSetup:View_SetData(ViewSetup[14], 0);
	end
	
	if nIndex == 1 then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1024,768", 0);
	else
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "800,600", 0);
	end
	
	SystemSetup:OptimizeConfirm()
end

function ViewSetup_Setup_Frame_On_ResetPos()
  ViewSetup_Setup_Frame:SetProperty("UnifiedPosition", g_ViewSetup_Setup_Frame_UnifiedPosition);
end


