-- ÈÎÎñ¸ú×Ù   author£ºhouzhifang

local g_strWndName = "MissionTrack";

local g_dlgctrls = {}; --????
local MissionPucker = {};
local g_nNowCheck = 0;   --0:???,1:????,2:????
local g_LockState = 0;   --0:???,1:???
local LEVEL_TO_MY_LEVEL = 10000;
local g_Temp_Mylevel = 1;

local g_DiFu_Scene_Id = 77; --????ID
--TT53675¶ÔËùÓÐ²»·ûºÏ¹æ·¶£¬Ã»ÓÐ½«missionparamµÚ0Î»×öÎªÈÎÎñÍê³É±êÖ¾µÄÈÎÎñ½Å±¾×öÌØÊâ´¦Àí,ÐèÒªÌØÊâ´¦ÀíµÄÈÎÎñ½Å±¾ºÅÁÐ±í£º
local SpecialMissionList = {200006,200031}

local g_MissionTrack_AutoMissionList = {
	891274, 891275, 891276, 891277, 891278, 891279, --????
}

local g_MissionTrack_Frame_UnifiedSize;
local g_MissionTrack_Frame_UnifiedXPosition;
local g_MissionTrack_Frame_UnifiedYPosition;
local g_MissionTrack__Frame_AbsolutePosition;
local g_MissionTrack__Frame_AbsoluteSize;
local g_MissionTrack_Function_Frame_AbsolutePosition;
local g_MissionTrack_DragTitle_AbsolutePosition;
local g_MissionTrack_Close_AbsolutePosition;
local g_MissionTrack__CheckBox_Frame_AbsolutePosition;
local g_MissionTrack_Lock_AbsolutePosition;
local g_MissionTrack_UnLock_AbsolutePosition;

function MissionTrack_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("OPEN_MISSION_TRACK");
	this:RegisterEvent("UPDATE_MISSION_TRACK");
	this:RegisterEvent("UPDATE_WILLGET_MISSION_TRACK");

	this:RegisterEvent("TRACK_ALPHA_ACTION");
	this:RegisterEvent("UNIT_LEVEL"); --?????????????
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("ADJEST_UI_RELATION_POS")
end

function MissionTrack_OnLoad()
	local i=1;
	for i=1,200 do
		MissionPucker[i] = 1;
	end;
	MissionTrack_Lock:Show();
	MissionTrack_UnLock:Hide();
	MissionTrack_ShowORHideFunc(0);

	g_MissionTrack_Frame_UnifiedSize = MissionTrack_Frame:GetProperty("UnifiedSize");
	g_MissionTrack_Frame_UnifiedXPosition = MissionTrack_Frame:GetProperty("UnifiedXPosition");
	g_MissionTrack_Frame_UnifiedYPosition = MissionTrack_Frame:GetProperty("UnifiedYPosition");
	g_MissionTrack__Frame_AbsolutePosition = MissionTrack__Frame:GetProperty("AbsolutePosition");
	g_MissionTrack__Frame_AbsoluteSize = MissionTrack__Frame:GetProperty("AbsoluteSize");
	g_MissionTrack_Function_Frame_AbsolutePosition = MissionTrack_Function_Frame:GetProperty("AbsolutePosition");
	g_MissionTrack_DragTitle_AbsolutePosition = MissionTrack_DragTitle:GetProperty("AbsolutePosition");
	g_MissionTrack_Close_AbsolutePosition = MissionTrack_Close:GetProperty("AbsolutePosition");
	g_MissionTrack__CheckBox_Frame_AbsolutePosition = MissionTrack_CheckBox_Frame:GetProperty("AbsolutePosition");
	g_MissionTrack_Lock_AbsolutePosition = MissionTrack_Lock:GetProperty("AbsolutePosition");
	g_MissionTrack_UnLock_AbsolutePosition = MissionTrack_UnLock:GetProperty("AbsolutePosition");

end

function MissionTrack_OnEvent(event)
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if(event == "OPEN_WINDOW") then
		if( arg0 == "MissionTrack") then
			this:Show();
			MissionTrack_ShowORHideFunc(0);
			MissionTrack_UpdateHaveGetMission(-1);
			DataPool:UpdateTrackStateButton(0);
		end
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "MissionTrack") then
			this:Hide();
		end
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if not this:IsVisible() then
			return;
		end
		if (g_nNowCheck == 1) then
			MissionTrack_UpdateHaveGetMission(-1);
		end
	elseif (event == "OPEN_MISSION_TRACK") then
		--local nMissionTrackShow = DataPool:IsTrackFuncShow(1);
		--if (nMissionTrackShow > 0) then
		--	AxTrace(0, 0, "11111111111111111");
			local nType = tonumber(arg0);
			if (nType == 1) then
				this:Show();
				MissionTrack_ShowORHideFunc(0);
				MissionTrack_UpdateHaveGetMission(-1);
				DataPool:UpdateTrackStateButton(0);
			end
		--end
	elseif (event == "UPDATE_MISSION_TRACK") then
		if not this:IsVisible() then
			return;
		end
		if (g_nNowCheck == 1) then
			local nSelect = tonumber(arg0)
			MissionTrack_UpdateHaveGetMission(nSelect);
		end
	elseif (event == "UPDATE_WILLGET_MISSION_TRACK" or event == "UNIT_LEVEL") then
		if not this:IsVisible() then
			return;
		end
		if (g_nNowCheck == 2) then
			MissionTrack_UpdateWillGet();
		end
	elseif (event == "TRACK_ALPHA_ACTION") then
		MissionTrack_SetAlpha(arg0)
	elseif (event == "ADJEST_UI_POS") then
		local nCurX = MissionTrack_Frame:GetProperty("AbsoluteXPosition")
		local nCurY = MissionTrack_Frame:GetProperty("AbsoluteYPosition")
		local nCurWidht	= MissionTrack_Frame:GetProperty("AbsoluteWidth")
		local nCurHeigh	= MissionTrack_Frame:GetProperty("AbsoluteHeight")
		local nScreenMaxWidht = tonumber(arg0)
		local nScreenMaxHeigh = tonumber(arg1)
		if (nCurX+nCurWidht > nScreenMaxWidht or nCurY+nCurHeigh > nScreenMaxHeigh) then
			MissionTrack_On_Reset()
			--Í¬Ê±µ÷ ûCampaignTrack½çÃæ
			AdjustUIPos("CampaignTrack")
		end
	elseif (event == "ADJEST_UI_RELATION_POS") then
		if (arg0 == "MissionTrack" ) then
			MissionTrack_On_Reset()
		end
	end
end

-- ÊÇ·ñÎª×Ô¶¯»¯ÈÎÎñ
function MissionTrack_CheckScriptId_CanAutoRun(nScriptId)
	if nScriptId >= 893186 and nScriptId <= 893212 then --????????
		return 2
	end
	for i, findId in g_MissionTrack_AutoMissionList do --????????
		if nScriptId == findId then
			return 1
		end
	end
	return 0
end

function MissionTrack_UpdateHaveGetMission(nSelectMissionID)
	local i = 1;
	local nMyLevel = Player:GetData( "LEVEL" );
	local nNowFirstItem;
	nNowFirstItem = MissionTrack_ListBoxTransparent:GetCurrentFirstItem();

	MissionTrack_HaveGet:SetCheck(1);
	MissionTrack_WillGet:SetCheck(0);
	g_nNowCheck = 1;

	MissionTrack_ListBoxTransparent:ClearListBoxEx();

	local nMissionNum = 20
	local color;

	for i=1,nMissionNum do
		if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
			DataPool:GetPlayerMission_Description(i-1);
		end
	end;

	local k = 0;
	local Sequence_OnefoldGenre = {}
	local Sequence_Assemble = {}
	local Constitutes = {};
	local MissionTitles = {};

	for j=1, 200 do
		local bHave = 0;
		for i=1, nMissionNum do
			if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
				local MissionKind = DataPool:GetPlayerMission_Kind(i-1);
				if(MissionKind == j) then
				local nThisKindHaveMission = DataPool:HaveMisstionTrackThisType(MissionKind);
					if (nThisKindHaveMission == 1 ) then
						--AxTrace(0,0,"j = ".. j .. " i-1 ="..(i-1));

						if ( MissionPucker[j] > 0 ) then
							local strInfo = DataPool:GetPlayerMission_Memo(i-1);
							local nMissionLevel = DataPool:GetPlayerMission_Level(i-1);

							if nMissionLevel == LEVEL_TO_MY_LEVEL then
								nMissionLevel =  Player:GetData( "LEVEL" );
								if (nMissionLevel > 0) then   --????????0,??????,????????,?????????????
									g_Temp_Mylevel = nMissionLevel;
								else
									nMissionLevel = g_Temp_Mylevel;
								end
							end

							if(bHave == 0) then
								local str= "#cff9900" .. DataPool:GetMissionInfo_Kind(j);   --title
								Constitutes = {str,100+j,"",0}
								table.insert(MissionTitles, str);
								table.insert(Sequence_OnefoldGenre,Constitutes)
								bHave = 1;
							end
	--------------------------------------------------
							local strOKFail = "";
							local nFinished = 0;
						--ÏÔÊ¾ÈÎÎñÊÇ·ñÒÑÍê³É»òÒÑÊ§°Ü
							local Mission_Variable = DataPool:GetPlayerMission_Variable(i-1,0);
							--TT53675¶ÔÓÚËùÓÐÃ»ÓÐÓÃmissionparamµÚ0Î»±íÊ¾ÈÎÎñÊÇ·ñÍê³ÉµÄÈÎÎñ£¬Ê¹ÓÃIsMissionSuccessÅÐ¶ÏÈÎÎñÊÇ·ñÍê³É
                      		local IsSpecial = 0
	                 		local nScriptId = DataPool:GetPlayerMission_Display(i-1,7)
	                 		for i, findId in SpecialMissionList do
		                  		if nScriptId == findId then
			                     	IsSpecial = 1
			                    	break
		                      end
	                  		end
	                  		if nScriptId >= 1020000 and nScriptId <= 1029999 then --????????????????
	   	                  		IsSpecial = 1
	                  		end
							if IsSpecial == 1 then
									Mission_Variable = IsMissionSuccess(i-1)
							end
							if MissionTrack_CheckScriptId_CanAutoRun(nScriptId) > 0 then
								if Mission_Variable == 1 then
									nFinished = 1
								end
								Mission_Variable = 3
							end
							if(Mission_Variable >0) then
								if(Mission_Variable == 1) then
									strOKFail = "Hoàn thành";
									nFinished = 1
								elseif(Mission_Variable == 2) then
									strOKFail = "Thành công";
								elseif(Mission_Variable == 3) then
									if IsNGRunning() == 1 then
										strOKFail = "#Gt¹ ðµng"
									else
										strOKFail = "#{_INFONGSTRm· ra}"
									end
								end
							end

							color = "FFF8A10A";	--??
							local nChange, strMissionName = DataPool:GetMissionShortName(strInfo);--string.sub(strInfo, -6);
							if (nChange > 0) then
								strMissionName = strMissionName .. "...";
							end
							if (nFinished == 1) then   --???
								Constitutes = {"  #Y(" .. nMissionLevel ..") " .. strMissionName .. " #G" .. strOKFail,i-1,color,nMissionLevel,nFinished};
							else
								Constitutes = {"  #Y(" .. nMissionLevel ..") " .. strMissionName .. " " .. strOKFail,i-1,color,nMissionLevel,nFinished};
							end
							table.insert(Sequence_OnefoldGenre,Constitutes)
						else
							if(bHave == 0) then
								local str= "#gFE7E82" .. DataPool:GetMissionInfo_Kind(j);
								Constitutes = {str,100+j,"",0}
								table.insert(Sequence_OnefoldGenre,Constitutes)
								table.insert(MissionTitles, str);
								bHave = 1;
							end
						end
						k=k+1;
					end
				end
			end
		end
		----
		table.sort(Sequence_OnefoldGenre,CompareTable)

		for i,n in ipairs(Sequence_OnefoldGenre) do
			table.insert(Sequence_Assemble,n)
		end
		Sequence_OnefoldGenre = {};
		----
	end
	local Per_Segment,xxxx,i,j;
	for i,Per_Segment in ipairs(Sequence_Assemble) do
		local nMissionTrackType = DataPool:GetPlayerMissionTrackType(Per_Segment[2]);
		if (Per_Segment[3] ~= "" and nMissionTrackType > 0) then
			local nIsMissionTrackOpen = DataPool:IsMissionTrackOpen(Per_Segment[2]);
			if (nIsMissionTrackOpen > 0) then
				MissionTrack_ListBoxTransparent:AddItemExWithoutLayout(Per_Segment[1],Per_Segment[2], 3, Per_Segment[3],4)
				MissionTrack_AddMissionTrackInfo(Per_Segment[2], nMissionTrackType, Per_Segment[5]);
			end
		elseif (tonumber(Per_Segment[4]) == 0) then
				MissionTrack_ListBoxTransparent:AddItemExWithoutLayout(Per_Segment[1],Per_Segment[2], 0);
				end
		end
	MissionTrack_ListBoxTransparent:RequestLayout();

	if (nSelectMissionID ~= -1) then
		local itemNum = MissionTrack_ListBoxTransparent:GetItemNumByMissionId(nSelectMissionID);
		if( itemNum ~= -1) then
			MissionTrack_ListBoxTransparent:SetCurrentFirstItem(itemNum);
		else
			MissionTrack_ListBoxTransparent:SetCurrentFirstItem(nNowFirstItem);
		end
		MissionTrack_ListBoxTransparent:SetItemSelectByItemID(nSelectMissionID);
	else
		MissionTrack_ListBoxTransparent:SetCurrentFirstItem(nNowFirstItem);
	end

	--QuestLog_Amount : SetText( k .. "/" .. nMissionNum);
---
	--QuestLog_ListBox_SelectChanged();

	--if Current_Clicked ~= -1 then
	--	--QuestLog_Listbox : EnsureItemIsVisable(Current_Clicked);
	--	QuestLog_Listbox : SetCurrentFirstItem(Current_Clicked);
	--	Current_Clicked = -1
	--end
end

function MissionTrack_AddMissionTrackInfo(nMissionIndex, nMissionTrackType, nFinished)
	local nNewIndex = nMissionIndex+200;
	local color = "FFCCCCCC";
	local MissionParam_Index = 0;
	local strTarget = "";

	local strFinishNPC, strFinishSceneName, nFinishSceneID, nFinishX, nFinishY = DataPool:GetMissionFinishInfo(nMissionIndex);
	-- PushDebugMessage(strFinishNPC);
	-- PushDebugMessage(nFinished);
	if (nFinished == 1 and strFinishNPC ~= "") then       --??????
		--if (strFinishNPC ~= "") then
			--local strTemp = string.format("   #WÈ¥#G%s#W Ò#R%s#{_INFOAIM%d,%d,%d,%s}#W", strFinishSceneName, strFinishNPC, nFinishX, nFinishY, nFinishSceneID, strFinishNPC);
			local strTemp = "";
			local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex,7)--czf modify,2009.08.26
			if nIndex == 1018870 then
				strTemp = string.format("#WKHÑ#G%s#WTräo#R%s#W", strFinishSceneName, strFinishNPC);
			elseif nIndex == 210273 then
				strTemp = "#{XSRW_100313_01}"
			elseif nIndex == 210257 then
				strTemp = "#{XSRW_100313_02}"
			elseif nIndex == 210264 then
				strTemp = "#{XSRW_100313_03}"
			elseif nIndex == 210265 then
				strTemp = "#{XSRW_100313_04}"
			elseif nIndex == 210269 then
				strTemp = "#{XSRW_100313_05}"
			elseif nIndex == 890638 then  --Q4?? ?????
				strTemp = "   ".."#{XBLFT_131112_99}";
			elseif nIndex == 600047 or nIndex == 600048 or nIndex == 600049 then		--???? for:TT 64489
				strTemp = string.format("#WðI tìm#R%s",	strFinishNPC);
			elseif nIndex == 998289 then
				strTemp = "#{FQZC_230331_287}"
			elseif nIndex == 998317 then
				strTemp = "#{FQZC_230331_292}"
			elseif MissionTrack_CheckScriptId_CanAutoRun(nIndex) >= 1 then
				strTemp = string.format("#WKHÑ#G%s#WTräo#R%s#{_INFONGAIM%d, %d, %d, %s}", strFinishSceneName, strFinishNPC, nFinishX, nFinishY, nFinishSceneID, strFinishNPC);
			else
				strTemp = string.format("#WKHÑ#G%s#WTräo#R%s#{_INFOAIM%d, %d, %d, %s}", strFinishSceneName, strFinishNPC, nFinishX, nFinishY, nFinishSceneID, strFinishNPC);
			end
			strTarget = strTemp;
		--end
	else    --??????
		--local nRound = DataPool:GetPlayerMission_Display(nMissionIndex,3);
		--if( nRound >= 0 ) then
		--	Mission_Variable = DataPool:GetPlayerMission_DataRound(nRound);
		--	if(Mission_Variable >= 0) then
		--		strTarget = "ÈÎÎñµ±Ç°»·Êý£º#W"..tostring(Mission_Variable);
		--	end
		--end
			--ÏÔÊ¾ÈÎÎñÒøÆ±ÊýÁ¿
		--if( DataPool:GetPlayerMission_Display(nMissionIndex,4) > 0 ) then
		--	Mission_Variable = DataPool:GetPlayerMission_Variable(nMissionIndex,MissionParam_Index);
		--	MissionParam_Index = MissionParam_Index + 1;

		--	if(Mission_Variable >0) then
		--		silverdesc = DataPool:GetPlayerMission_BillName(nMissionIndex);
		--		strTarget = "ÐèÒªµÃµ½½ðÇ®£º#W"..tostring(Mission_Variable);
		--	end
		--end

		local strAppend = "";
		local Mission_Variable = 0;
		--TT53675¶ÔËùÓÐ²»·ûºÏ¹æ·¶£¬Ã»ÓÐ½«missionparamµÚ0Î»×öÎªÈÎÎñÍê³É±êÖ¾µÄÈÎÎñ½Å±¾×öÌØÊâ´¦Àí
		local IsSpecial = 0
	    local nScriptId1 = DataPool:GetPlayerMission_Display(nMissionIndex,7)
	    for i, findId in SpecialMissionList do
		    if nScriptId1 == findId then
			     IsSpecial = 1
			     break
		    end
	   end
	   if nScriptId1>=1020000 and nScriptId1<=1029999 then --????????????????
	   	    IsSpecial = 1
	   end
	   if IsSpecial==0 then
		    MissionParam_Index = MissionParam_Index + 1;
		end
		--ÈÎÎñÐèÒªÉ±µÄnpc
		local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nMissionIndex);
		if( nDemandKillNum > 0 ) then
			strAppend = "#WDÎ giªt chªt:";
			for i=1, nDemandKillNum do
				--    ÐèÒªµÄNPC£¬ÐèÒªNPC ID£¬ÐèÒª¶àÉÙ¸ö
				local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nMissionIndex);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nMissionIndex,MissionParam_Index,Kill_Random_Type,i-1);
				MissionParam_Index = MissionParam_Index + 1;
				if (i == 1 and nDemandKillNum > 1) then
					strAppend = strAppend.."#W"..nNPCName..":"..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
				elseif (i == 1 and nDemandKillNum == 1) then
					strAppend = strAppend.."#W"..nNPCName..":"..tostring(Mission_Variable).."/"..tostring(nNum);
				elseif( i == nDemandKillNum) then
					strAppend = strAppend.."#W            "..nNPCName..":"..tostring(Mission_Variable).."/"..tostring(nNum);
				else
					strAppend = strAppend.."#W            "..nNPCName..":"..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
				end
				nNewIndex = nNewIndex + 1;
			end
		end

		--ÈÎÎñÐèÒªµÄÎïÆ·
		local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nMissionIndex);
		if( nDemandNum > 0 ) then
			if(Item_Random_Type == -100) then
				strAppend = "#WDÎ ð® trình:";
				nNewIndex = nNewIndex + 1;
				Item_Random_Type = 0
			else
				strAppend = "#WDÎ nh§n ðßþc:";
				nNewIndex = nNewIndex + 1;
			end
		end

		for i=1, nDemandNum do
			--    ÐèÒªµÄÀàÐÍ£¬ÐèÒªÎïÆ·ID£¬ÐèÒª¶àÉÙ¸ö
			local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nMissionIndex);
			Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)

			if Mission_Variable > nNum then
				Mission_Variable = nNum
			end


			local Mission_Variable2 = DataPool:GetPlayerMission_Variable(nMissionIndex,0);
			if Mission_Variable2 > 0 then
				Mission_Variable = nNum
			end

			if (i == 1 and nDemandNum > 1) then
				strAppend = strAppend.."#W"..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
			elseif(i == 1 and nDemandNum == 1) then
				strAppend = strAppend.."#W"..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum);
			elseif(i == nDemandNum) then
				strAppend = strAppend.."#W            "..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum);
			else
				strAppend = strAppend.."#W            "..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
			end
		end

		--ÈÎÎñ×Ô¶¨ÒåµÄÎïÆ·
		local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nMissionIndex);
		for i=1, nCustomNum do
			--    ÐèÒªµÄNPC£¬ÐèÒªNPC ID£¬ÐèÒª¶àÉÙ¸ö
			local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
			Mission_Variable = DataPool:GetPlayerMission_Variable(nMissionIndex,MissionParam_Index);
			AxTrace(0, 0, strCustom..tostring(Mission_Variable));
			MissionParam_Index = MissionParam_Index + 1;

			local strDot = "";
			if (i < nCustomNum) then
				strDot = "#r";
			end

			if nNum == 0 then
				strAppend = strAppend.."   " .. strCustom..strDot;
			else
				strAppend = strAppend.."   " .. strCustom .. ":".. Mission_Variable .. "/" .. nNum..strDot;

			end
		end

		--ÈÎÎñ×Ô¶¨ÒåµÄËæ»úÎïÆ· zzÌí¼Ó
		local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nMissionIndex);
		for i=1,nRandomCustomNum do
			local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nMissionIndex);

			local strDot = "";
			if (i < nCustomNum) then
				strDot = "#r";
			end

			if nNeedNum == 0 then
				strAppend = strAppend..strCustom..strDot;
			else
				strAppend = strAppend..strCustom .. ":".. nCompleteNum .. "/" .. nNeedNum..strDot;
			end
		end


		local strTemp = "";
		strTarget = "";
		if (nMissionTrackType == 1) then   --????,??????????
			strTarget = DataPool:GetLuaMissionTrackInfo(nMissionIndex);
			if (strAppend ~= "") then
				strTarget = "   #W" .. strTarget.."#r#W"..strAppend;
			else
				strTarget = "   #W" .. strTarget;
			end
		elseif(nMissionTrackType == 2) then   --??????,????????????
			local strNPCName, strSceneName, nTargetScene, nPosX, nPosY = DataPool:GetDeliveryMissionTrackInfo(nMissionIndex);
			if (strNPCName ~= "") then
				-- Ó¢ÐÛÈÎÎñ¶ÔÓ¦ ³¡¾°Îª-1
				local strTemp = "";
				if(nTargetScene ~= -1) then
					--strTemp = string.format("   #WÈ¥#G%s#W Ò#R%s#{_INFOAIM%d,%d,%d,%s}#W", strSceneName, strNPCName, nPosX, nPosY, nTargetScene, strNPCName);
					local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex,7)--czf modify,2009.08.26
					if nIndex == 1018870 then
						strTemp = string.format("#WKHÑ#G%s#WTräo#R%s#W", strSceneName, strNPCName);
					else
						strTemp = string.format("#WKHÑ#G%s#WTräo#R%s#{_INFOAIM%d, %d, %d, %s}", strSceneName, strNPCName, nPosX, nPosY, nTargetScene, strNPCName);
					end
				else
					strTemp = string.format("#WKHÑ#G%s#WTräo#R%s#W", strSceneName, strNPCName);
				end
				strTarget = strTarget .. strTemp .. "#r";
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		elseif(nMissionTrackType == 3) then   --????????
			local nMonsterNum = DataPool:GetKillMonsterMissionTrackInfo_num(nMissionIndex);
			if (nMonsterNum > 0) then
				for nn = 1, nMonsterNum do
					local strMonsterName, strSceneName, nSceneId, nCount, nXpos, nYpos = DataPool:GetKillMonsterMissionTrackInfo_MonsterInfo(nMissionIndex, nn-1);
					if(strMonsterName ~= "") then
						local strTemp = "";
						if(nSceneId ~= -1) then
							 strTemp = string.format("#WKHÑ#G%s#WSát#R%s#{_INFOAIM%d, %d, %d, %s}#W", tostring(strSceneName),tostring(strMonsterName), tonumber(nXpos), tonumber(nYpos), tonumber(nSceneId), tostring(strMonsterName));
						else
							 strTemp = string.format("#WKHÑ#G%s#WSát#R%s#W", tostring(strSceneName),tostring(strMonsterName));
						end
						strTarget = strTarget .. strTemp;
						strTarget = strTarget .. "#r";
					end
				end
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		elseif(nMissionTrackType == 4) then
			local nLootItemNum = DataPool:GetLootItemMissionTrackInfo_num(nMissionIndex);
			if(nLootItemNum > 0) then
				for nn = 1, nLootItemNum do
					local strMonsterName, strSceneName, strItemName, nSceneID, nItemNum, xPos, yPos = DataPool:GetLootItemMissionTrackInfo_ItemInfo(nMissionIndex, nn-1);
					if (strMonsterName ~= "") then
						local strTemp = "";
						if(nSceneID ~= -1) then
							 strTemp = string.format("#WKHÑ#G%s#WSát#R%s#{_INFOAIM%d, %d, %d, %s}#W", strSceneName, strMonsterName, xPos, yPos, nSceneID, strMonsterName);
						else
							 strTemp = string.format("#WKHÑ#G%s#WSát#R%s#W", strSceneName, strMonsterName);
						end
						strTarget = strTarget .. strTemp;
						strTarget = strTarget .. "#r";
					end
				end
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		elseif (nMissionTrackType == 6) then
			local strObjName, strTargetNPC, strTargetScene, nTargetScene, xPos, yPos = DataPool:GetHusongMissionTrackInfo(nMissionIndex);
			if (strObjName ~= "") then
				local strTemp = "";
				if(nTargetScene ~= -1) then
					strTemp = string.format("#WÐÁo%sTräo#R%s#{_INFOAIM%d, %d, %d, %s}#W#r",strTargetScene, strTargetNPC, xPos, yPos, nTargetScene, strTargetNPC);
				else
					strTemp = string.format("#WÐÁo%sTräo#R%s#W",strTargetScene, strTargetNPC);
				end
				strTarget = strTarget .. strTemp;
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		end

		if(nMissionTrackType == 7) then
			local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex, 7)
			-- ÐÂÌì¸³ÏµÍ³ÐÞÁ¶ÈÎÎñÉè¼Æ begin
			if nIndex == 891274 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission1(nMissionIndex)
			end
			if nIndex == 891275 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission2(nMissionIndex)
			end
			if nIndex == 891276 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission3(nMissionIndex)
			end
			if nIndex == 891277 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission4(nMissionIndex)
			end
			if nIndex == 891278 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission5(nMissionIndex)
			end
			if nIndex == 891279 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission6(nMissionIndex)
			end
			if nIndex == 891280 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission7(nMissionIndex)
			end
			if nIndex == 891281 then
				strTarget = "   "..QuestLog_GetTrack_XiuLianMission8(nMissionIndex)
			end
			-- ÐÂÌì¸³ÏµÍ³ÐÞÁ¶ÈÎÎñÉè¼Æ end
		end

		if(nMissionTrackType == 8) then
			local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex, 7)
			--Q4´ò¿¨ Ñ°±¦ÀÖ·­Ìì
			if nIndex == 890638 then
				strTarget="   "..MissionTrack_GetXunBaoLeFanTianTarget(nMissionIndex)
			end
			--¡¾2021Q1¡¿4ÔÂ°æ±¾´ò¿¨»î¶¯ Ðû´«Ó¢ÐÛ´ó»á
			if nIndex == 250552 then
				strTarget = MissionTrack_GetXuanChuanYXDHTarget(nMissionIndex)
			end
			-- [2022Q3]À­ïÚÖÜ³£»î¶¯Éè¼Æ
			if nIndex == 888160 then
				strTarget = "   "..QuestLog_GetTrack_Guard(nMissionIndex)
			end
			--¡¾2022Q4¡¿ÇéÈË½Ú´ò¿¨
			if nIndex == 890055 then
				strTarget = "   "..QuestLog_GetTrack_QingRenJieDaKa(nMissionIndex)
			end
			--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ2ÌØÐ´
			if nIndex == 893187 then
				strTarget = MissionTrack_LiLianMission21(nMissionIndex)
			end
			if nIndex == 893197 then
				strTarget = MissionTrack_LiLianMission22(nMissionIndex)
			end
			if nIndex == 893207 then
				strTarget = MissionTrack_LiLianMission23(nMissionIndex)
			end

			if nIndex == 893189 then
				strTarget = MissionTrack_LiLianMission14(nMissionIndex)
		end

			if nIndex == 893199 then
				strTarget = MissionTrack_LiLianMission24(nMissionIndex)
			end

			if nIndex == 893209 then
				strTarget = MissionTrack_LiLianMission34(nMissionIndex)
			end
			
			-- ÐÂÉí·ÝÏµÍ³-Òýµ¼ÈÎÎñ
			if nIndex == 998655 then
				strTarget = "   "..QuestLog_GetTrack_IdentityGuide1(nMissionIndex)
			end
			if nIndex == 998656 then
				strTarget = "   "..QuestLog_GetTrack_IdentityGuide2(nMissionIndex)
			end
			if nIndex == 998657 then
				strTarget = "   "..QuestLog_GetTrack_IdentityGuide3(nMissionIndex)
			end
			if nIndex == 998658 then
				strTarget = "   "..QuestLog_GetTrack_IdentityGuide4(nMissionIndex)
			end
			if nIndex == 998659 then
				strTarget = "   "..QuestLog_GetTrack_IdentityGuide5(nMissionIndex)
			end

		end		
		
		-- [2017-ÔªÏü½Ú²ÂµÆÃ »î¶¯]
		if (nMissionTrackType == 9 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 892384) then
			strTarget = "   "..QuestLog_GetTrack_2017YXJCDM(nMissionIndex);
		end

		--//2021¾çÇéÈÎÎñ-ypl -¾çÇé1
		if (nMissionTrackType == 10 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891083) then
			strTarget = "   "..QuestLog_GetTrack_2021JuQing1(nMissionIndex);
		end

		--//2021¾çÇéÈÎÎñ-ypl -¾çÇé2
		if (nMissionTrackType == 11 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891095) then
			strTarget = "   "..QuestLog_GetTrack_2021JuQing2(nMissionIndex);
		end

		--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong£ºÈÎÎñ2
		if (nMissionTrackType == 12 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891219) then
			strTarget = "   "..QuestLog_GetTrack_2021TianFu2(nMissionIndex);
		end

		--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong£ºÈÎÎñ3
		if (nMissionTrackType == 13 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891220) then
			strTarget = "   "..QuestLog_GetTrack_2021TianFu3(nMissionIndex);
		end

		--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong£ºÈÎÎñ4
		if (nMissionTrackType == 14 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891221) then
			strTarget = "   "..QuestLog_GetTrack_2021TianFu4(nMissionIndex);
		end

		--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong£ºÈÎÎñ5
		if (nMissionTrackType == 15 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891222) then
			strTarget = "   "..QuestLog_GetTrack_2021TianFu5(nMissionIndex);
		end

		--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong£ºÈÎÎñ6
		if (nMissionTrackType == 16 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891223) then
			strTarget = "   "..QuestLog_GetTrack_2021TianFu6(nMissionIndex);
		end

		--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong£ºÈÎÎñ7
		if (nMissionTrackType == 17 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 891224) then
			strTarget = "   "..QuestLog_GetTrack_2021TianFu7(nMissionIndex);
		end

		--22Q1Ó¦¾°´ò¿¨
		if (nMissionTrackType == 18 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 893090) then
			strTarget = "   "..MissionTrack_Get22Q1QTESignInDesc(nMissionIndex);
		end

		--//2022ÊÞ»ê°æ±¾Ô¤ÈÈ-ypl
		if (nMissionTrackType == 19 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 893108) then
			strTarget = "   "..QuestLog_GetTrack_2022PetYuRe(nMissionIndex);
		end

		if (nMissionTrackType == 21 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 893242) then
			strTarget = "   "..QuestLog_GetTrack_2022TianFu1(nMissionIndex);
		end

		if (nMissionTrackType == 21 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 893243) then
			strTarget = "   "..QuestLog_GetTrack_2022TianFu2(nMissionIndex);
		end

		if (nMissionTrackType == 22 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 890161) then
			strTarget = "   "..QuestLog_GetTrack_MainLineMission8(nMissionIndex);
			if (strAppend ~= "") then
				strTarget = strTarget .."#r#W"..strAppend;
			end
		end

		if (nMissionTrackType == 22 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 890162) then
			strTarget = "   "..QuestLog_GetTrack_MainLineMission9(nMissionIndex);
			if (strAppend ~= "") then
				strTarget = strTarget .."#r#W"..strAppend;
			end
		end

		if (nMissionTrackType == 22 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 890163) then
			strTarget = "   "..QuestLog_GetTrack_MainLineMission10(nMissionIndex);
			if (strAppend ~= "") then
				strTarget = strTarget .."#r#W"..strAppend;
			end
		end

		if (nMissionTrackType == 22 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 890164) then
			strTarget = "   "..QuestLog_GetTrack_MainLineMission11(nMissionIndex);
			if (strAppend ~= "") then
				strTarget = strTarget .."#r#W"..strAppend;
			end
		end

		if (nMissionTrackType == 22 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 890165) then
			strTarget = "   "..QuestLog_GetTrack_MainLineMission12(nMissionIndex);
			if (strAppend ~= "") then
				strTarget = strTarget .."#r#W"..strAppend;
			end
		end


		if (nMissionTrackType == 24 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998352) then
			strTarget = "   "..QuestLog_GetTrack_2023TianFu3(nMissionIndex);
		end

		if (nMissionTrackType == 24 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998353) then
			strTarget = "   "..QuestLog_GetTrack_2023TianFu4(nMissionIndex);
		end

		-- ÐÇ»ðÉúÑãÃÅÈÎÎñ1
		-- !!!reloadscript =MissionTrack
		-- PushDebugMessage("nMissionTrackType"..nMissionTrackType)
		-- if (nMissionTrackType == 20 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 791022) then
		-- 	PushDebugMessage("MissionTrack02")
		-- 	strTarget = "   "..QuestLog_GetTrack_XingHuoYanMen01(nMissionIndex);
		-- end

		if (nMissionTrackType == 23 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998289) then
			strTarget = "   "..MissionTrack_Complete_CoupleWeeklyMission2(nMissionIndex);
		end
		
		--2023Q380¼¶Éñ±ø¾çÇéÈÎÎñ
		if (nMissionTrackType == 25 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998389) then
			strTarget = "   "..QuestLog_GetTrack_202380SBJQ1(nMissionIndex);
		end	
		if (nMissionTrackType == 26 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998391) then
			strTarget = "   "..QuestLog_GetTrack_202380SBJQ2(nMissionIndex);
		end
		--2024Q1preheat
		
		if (nMissionTrackType == 27) then
			if DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998695 then
				strTarget = QuestLog_GetTrack_PreHeatMission1(nMissionIndex);
			end
			if DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998696 then
				strTarget = QuestLog_GetTrack_PreHeatMission2(nMissionIndex);
			end
			if DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998697 then
				strTarget = QuestLog_GetTrack_PreHeatMission3(nMissionIndex);
			end
			if DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998698 then
				strTarget = QuestLog_GetTrack_PreHeatMission4(nMissionIndex);
			end
		end

		if (nMissionTrackType == 28) then
			if DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 998819 then
				strTarget = QuestLog_GetTrack_2024DWDK(nMissionIndex);
			end
		end

		--´ó»°Î÷ÓÎµÚÒ»½×¶ÎÖ÷Ïß¾çÇé-ypl
		if (nMissionTrackType == 29 and DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 999119) then
			strTarget = "   "..QuestLog_GetTrack_2024DHMission(nMissionIndex);
		end	
		if ( nMissionTrackType == 30 ) then
			local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex, 7)
			if nIndex == 999147 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage2_1(nMissionIndex)
			elseif nIndex == 999148 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage2_2(nMissionIndex)
			elseif nIndex == 999149 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage2_3(nMissionIndex)
			elseif nIndex == 999150 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage2_4(nMissionIndex)
			elseif nIndex == 999151 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage2_5(nMissionIndex)
			elseif nIndex == 999152 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage2_6(nMissionIndex)
			end
		end
		--2024Q2´ó»°Î÷ÓÎµÚÈý½×¶ÎÖ÷Ïß¾çÇé
		if nMissionTrackType == 31 then
			local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex, 7)
			if nIndex == 999191 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage3_1(nMissionIndex)
			end
			if nIndex == 999193 then
				strTarget = "   "..MissionTrack_GetTrack_DHXYStage3_2(nMissionIndex)
			end
		end	
				
		if DataPool:GetPlayerMission_Display(nMissionIndex, 7) == 890291 then
			strTarget = "   "..MissionTrack_LongHaizi(nMissionIndex)
		end
			
	end

	-- ÌØÐ´ Ö±½ÓÈ«²¿ÌØÐ´×·×ÙÐÅÏ¢
	local nScriptId = DataPool:GetPlayerMission_Display(nMissionIndex, 7)
	if 791022 == nScriptId then
		strTarget = "   "..MissionTrack_GetTrack_XingHuoYanMen01(nMissionIndex)
	end
	if 791023 == nScriptId then
		strTarget = "   "..MissionTrack_GetTrack_XingHuoYanMen02(nMissionIndex)
	end
	if 791024 == nScriptId then
		strTarget = "   "..MissionTrack_GetTrack_XingHuoYanMen03(nMissionIndex)
	end
	if 893181 == nScriptId then
		strTarget = "   "..MissionTrack_GetTrack_XYPCA_caidan5(nMissionIndex)
	elseif 810115 == nScriptId then
		strTarget = "   "..MissionTrack_GetTrack_TXDaGongTu(nMissionIndex)
	end	
	if 505010 == nScriptId then
		strTarget = "   "..MissionTrack_Roman(nMissionIndex)
	end
	if 998474 == nScriptId then
		strTarget = "   "..MissionTrack_TianDeng(nMissionIndex)
	end
	
	if 505010 == nScriptId then
		strTarget = "   "..MissionTrack_Roman(nMissionIndex)
	end
	
	if 998355 == nScriptId or 998356 == nScriptId or 998357 == nScriptId or 998358 == nScriptId or 998359 == nScriptId then
		if nFinished == 1 then
			strTarget = "   "..MissionTrack_JingJinMision(nMissionIndex)
		end	
	end
	
	if 998539 == nScriptId then
		strTarget = "   "..MissionTrack_QRJGW(nMissionIndex)
	end
	if  nScriptId >= 998586 and nScriptId <= 998594 then
		strTarget = "   "..MissionTrack_ShenFenTuPo(nMissionIndex)
	end

	if 998665 == nScriptId then
		strTarget = "   "..MissionTrack_TCJL(nMissionIndex)
	end
	
	-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ·çÓê¼±Ð¥
	if nScriptId == 998774 then
		strTarget = "" .. MissionTrack_2024PM_Mission1(nMissionIndex)
	end
	-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ÌìÐÄÄÑ²â
	if nScriptId == 998775 then
		strTarget = "" .. MissionTrack_2024PM_Mission2(nMissionIndex)
	end
	-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ÖïÐ°Ö®·¨
	if nScriptId == 998776 then
		strTarget = "" .. MissionTrack_2024PM_Mission3(nMissionIndex)
	end
	-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ÔÙ ½²ÔÉ½
	if nScriptId == 998777 then
		strTarget = "" .. MissionTrack_2024PM_Mission4(nMissionIndex)
	end
	
	-- £¨6.21£©¡¾»³¾É¡¿¡¾2024Q2¡¿ÐÂ°æ±¾ÎÈ»î-ÏÄÈ ±ùä¿ÁÜ»î¶¯¡¤³ÌÐòÏà¹Ø
	if 998812 == nScriptId then
		strTarget = "   "..MissionTrack_XRBQL(nMissionIndex)
	end
	if 999431 == nScriptId or 999432 == nScriptId or 999433 == nScriptId or 999434 == nScriptId or 
	999435 == nScriptId or 999436 == nScriptId or 999437 == nScriptId or 999438 == nScriptId then
		if nFinished == 1 then
			strTarget = ""..MissionTrack_GetTrack_2024Q3Preheat(nMissionIndex)
		end
	end
	MissionTrack_ListBoxTransparent:AddItemExWithoutLayout(strTarget, nMissionIndex, 0, color, 4);
end

function MissionTrack_TCJL( nMissionIndex )

	local curDayIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local curDayId = math.mod(curDayIndex-1, 3) + 1
	local strDic = { [1] = "#{TCJL_20240109_56}",[2] = "#{TCJL_20240109_151}",[3] = "#{TCJL_20240109_152}" }
	
	local isDone = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	
	if isDone == 1 then
		return "#{TCJL_20240109_155}"
	end
	
	if strDic[curDayId] ~= nil then
		return strDic[curDayId]
	end

	return ""
end

function MissionTrack_JingJinMision( nMissionIndex )
	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname ,Npcscene = MissionTrack_GetItem_JingJinMission( nIndex1,nIndex2 )

	if NPCname ~= "" and LPname ~= "" then
		local strTemp = string.format("#WKHÑ#G%s#WTräo#R%s#W", Npcscene, NPCname);

		return strTemp
	end

	return ""
end

function MissionTrack_Complete_CoupleWeeklyMission2(nSelIndex)
	local type =    DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local needNum = DataPool:GetPlayerMission_Variable( nSelIndex, 3 ) 
	local num =     DataPool:GetPlayerMission_Variable( nSelIndex, 4 ) 
	local str = "err"
	if type == 818 then
		str = ScriptGlobal_Format("#{FQZC_230331_74}", num,needNum)
	elseif type == 817 then
		str = ScriptGlobal_Format("#{FQZC_230331_100}", num,needNum)
	elseif type == 816 then
		str = ScriptGlobal_Format("#{FQZC_230331_101}", num,needNum)
	end
	return "#{FQZC_230331_289}".."\n   "..str
end

-- ÐÇ»ðÉúÑãÃÅÈÎÎñ1 ÈÎÎñ×·×Ù
function MissionTrack_GetTrack_XingHuoYanMen01( nSelIndex )
	local bFinish 			= DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local nProcessStepNum 	= DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local nNewProccessDay 	= DataPool:GetPlayerMission_Variable( nSelIndex, 2 )

	local nCurDay 		= tonumber(DataPool:GetServerDayTime())

	-- PushDebugMessage("bFinish:"..bFinish..",nProcessStepNum:"..nProcessStepNum..",nNewProccessDay:"..nNewProccessDay..",nCurDay:"..nCurDay)

	-- Î´Íê³É
	if nProcessStepNum < 1 then
		if nCurDay < nNewProccessDay then
			-- ½×¶Î2
			return "#{XHSYM_20220426_76}"
		else
			-- ½×¶Î3
			return "#{XHSYM_20220426_134}"
		end
	else
		-- Íê³ÉÁË
		if nCurDay < nNewProccessDay then
			-- ½×¶Î2
			return "#{XHSYM_20220426_77}"
		else
			-- ½×¶Î3
			return "#{XHSYM_20220426_155}"
		end
	end
end

-- ÐÇ»ðÉúÑãÃÅÈÎÎñ2 ÈÎÎñ×·×Ù
function MissionTrack_GetTrack_XingHuoYanMen02( nSelIndex )
	local bFinish 			= DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local curKillNum = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local nProcessStepNum 	= DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local statestr = ScriptGlobal_Format("#{XHSYM_20220426_97}", curKillNum)
	-- Î´Íê³É
	if nProcessStepNum < 1 then
		return "#{XHSYM_20220426_98}\n"..statestr
	else
		-- Íê³ÉÁË
		return "#{XHSYM_20220426_99}\n"..statestr
	end

end

-- ÐÇ»ðÉúÑãÃÅÈÎÎñ3 ÈÎÎñ×·×Ù
function MissionTrack_GetTrack_XingHuoYanMen03( nSelIndex )
	local bFinish 			= DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local curCaijiNum = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local nProcessStepNum 	= DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local statestr = ScriptGlobal_Format("#{XHSYM_20220426_113}", curCaijiNum)
	-- Î´Íê³É
	if nProcessStepNum < 1 then
		return "#{XHSYM_20220426_114}\n"..statestr
	else
		-- Íê³ÉÁË
		return "#{XHSYM_20220426_115}\n"..statestr
	end
end
function MissionTrack_GetTrack_XYPCA_caidan5(nMissionIndex)
	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if nCurDay <= 20220703 then
		return "#{XRDK_220428_275}"
	else
		return "#{XRDK_220428_274}"
	end
end

function MissionTrack_GetTrack_TXDaGongTu(nMissionIndex)
	local bFinished = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local nBuffIdx 	= DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local statestr = ""
	if nBuffIdx == 1 then
		statestr = ScriptGlobal_Format("#{CJDG_221110_97}", bFinished)
	else
		statestr = ScriptGlobal_Format("#{CJDG_221110_98}", bFinished)
	end
	return statestr
end
function MissionTrack_GetXunBaoLeFanTianTarget( nMissionIndex )

    local pos =
	{
		-- Ë ÖÝ	ÂëÍ·£¨238£¬81£©¡¢ÎÄÃí£¨90£¬81£©¡¢Å·Ò±×Ó£¨266£¬138£©
		[1] = {
			[1] = {SceneID = 1, PosX = 238, PosZ = 81,	SceneName = "Tô Châu",	SubName = "Bªn tàu"},
			[2] = {SceneID = 1, PosX = 90,	PosZ = 81,	SceneName = "Tô Châu",	SubName = "Vån miªu"},
			[3] = {SceneID = 1, PosX = 266, PosZ = 138,	SceneName = "Tô Châu",	SubName = "Âu Dã TØ"},
		},
		-- ÂåÑô	ÎäÆ÷µê£¨209£¬154£©¡¢ÔÂÀÏ£¨48£¬62£©¡¢ïÚ¾Ö£¨84£¬118£©
		[2] = {
			[1] = {SceneID = 0, PosX = 209, PosZ = 154,	SceneName = "LÕc Dß½ng",	SubName = "Vû khí ðiªm"},
			[2] = {SceneID = 0, PosX = 48,	PosZ = 62,	SceneName = "LÕc Dß½ng",	SubName = "Nguy®t Lão"},
			[3] = {SceneID = 0, PosX = 84, 	PosZ = 118,	SceneName = "LÕc Dß½ng",	SubName = "Tiêu cøc"},
		},
		-- ´óÀí	Íû²ÔÌ¨£¨240,56£©¡¢Îå»ªÌ³£¨160,169£©¡¢ÔÆÆ®Æ®£¨264,128£©
		[3] = {
			[1] = {SceneID = 2, PosX = 240, PosZ = 56,	SceneName = "ÐÕi Lý",	SubName = "V÷ng Thß½ng Ðài"},
			[2] = {SceneID = 2, PosX = 160, PosZ = 169,	SceneName = "ÐÕi Lý",	SubName = "Ngû Hoa Ðàn"},
			[3] = {SceneID = 2, PosX = 264, PosZ = 128,	SceneName = "ÐÕi Lý",	SubName = "Vân Phiêu Phiêu"},
		},
	}
    local index_suzhou = 1
    local index_luoyang = 2
    local index_dali = 3

    local sub_suzhou = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
    local sub_luoyang = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
    local sub_dali = DataPool:GetPlayerMission_Variable( nMissionIndex, 7 )

    local city_suzhou = pos[index_suzhou][sub_suzhou].SceneName;
    local posx_suzhou = pos[index_suzhou][sub_suzhou].PosX;
    local posz_suzhou = pos[index_suzhou][sub_suzhou].PosZ;
    local sceneid_suzhou = pos[index_suzhou][sub_suzhou].SceneID;

    local city_luoyang = pos[index_luoyang][sub_luoyang].SceneName;
    local posx_luoyang = pos[index_luoyang][sub_luoyang].PosX;
    local posz_luoyang = pos[index_luoyang][sub_luoyang].PosZ;
    local sceneid_luoyang = pos[index_luoyang][sub_luoyang].SceneID;

    local city_dali = pos[index_dali][sub_dali].SceneName;
    local posx_dali = pos[index_dali][sub_dali].PosX;
    local posz_dali = pos[index_dali][sub_dali].PosZ;
    local sceneid_dali = pos[index_dali][sub_dali].SceneID;

    local strComplete = ScriptGlobal_Format("#{XBLFT_131112_98}", posx_suzhou,posz_suzhou,posx_luoyang,posz_luoyang,posx_dali,posz_dali)

    return strComplete
end

-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ·çÓê¼±Ð¥
function MissionTrack_2024PM_Mission1(nMissionIndex)
	local strTarget = ""
	local nFinished = DataPool:GetPlayerMission_Variable(nMissionIndex, 0)
	if nFinished ~= 1 then
		-- Íê³ÉÈÎÎñÊý
		local nStep01Num = DataPool:GetPlayerMission_Variable(nMissionIndex, 1)
		local nStep02Num = DataPool:GetPlayerMission_Variable(nMissionIndex, 2)
		if nStep01Num ~= 1 or nStep02Num ~= 1 then
			strTarget = "   #W#{JJFY_240407_82}#r#W   "
			strTarget = strTarget .. ScriptGlobal_Format("#{JJFY_240407_83}",nStep01Num) .. "#r#W   "
			strTarget = strTarget .. ScriptGlobal_Format("#{JJFY_240407_81}",nStep02Num)
		else
			-- Ìæ»»Îª¹ý³Ì2¸ú×Ù
			strTarget = "   #W#{JJFY_240407_85}"
		end
	else
		strTarget = "   #W#{JJFY_240407_86}"
	end
	return strTarget
end
-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ÌìÐÄÄÑ²â
function MissionTrack_2024PM_Mission2(nMissionIndex)
	local strTarget = ""
	local nFinished = DataPool:GetPlayerMission_Variable(nMissionIndex, 0)
	if nFinished == 0 then
		--ÐÞ²¹²ÄÁÏ
		local nMaterialCount = 0
		for i,nItemID in {40005164,40005165,40005166} do
			local nMaterialNum = DataPool : GetPlayerMission_ItemCountNow(nItemID)
			if nMaterialNum > 0 then
				nMaterialCount  = nMaterialCount + 1
			end
		end
		local nTaskItemNum = DataPool:GetPlayerMission_Variable(nMissionIndex, 1)
		strTarget = "   #W#{JJFY_240407_125}#r#W   "
		-- strTarget = strTarget .. ScriptGlobal_Format("#{JJFY_240407_175}", nMaterialCount) .. "#r#W   "
		strTarget = strTarget .. ScriptGlobal_Format("#{JJFY_240407_126}", nTaskItemNum)
	else
		strTarget = "   #W#{JJFY_240407_127}"
	end
	return strTarget
end
-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ÖïÐ°Ö®·¨
function MissionTrack_2024PM_Mission3(nMissionIndex)
	local strTarget = ""
	local nFinished = DataPool:GetPlayerMission_Variable(nMissionIndex, 0)
	if nFinished == 0 then
		local nKillNum = DataPool:GetPlayerMission_Variable(nMissionIndex, 1)
		strTarget = "   #W#{JJFY_240407_144}#r#W   "
		strTarget = strTarget .. ScriptGlobal_Format("#{JJFY_240407_145}", nKillNum)
	else
		strTarget = "   #W#{JJFY_240407_146}"
	end
	return strTarget
end
-- ¡¾2024Q2¡¿ÐÂ°æ±¾Ô¤ÈÈ-É½ÖØË®¸´ ÔÙ ½²ÔÉ½
function MissionTrack_2024PM_Mission4(nMissionIndex)
	local strTarget = ""
	local nFinished = DataPool:GetPlayerMission_Variable(nMissionIndex, 0)
	if nFinished == 0 then
		local nStep01 = DataPool:GetPlayerMission_Variable(nMissionIndex, 1)	
		if nStep01 == 0 then
			strTarget = "   #W#{JJFY_240407_153}"
		else
			-- ÈÎÎñ¹ý³Ì2
			strTarget = "   #W#{JJFY_240407_154}"
			local count = 0
			if DataPool:GetPlayerMission_Variable(nMissionIndex, 2) ~= 0 then
				count = count + 1
			end
			if DataPool:GetPlayerMission_Variable(nMissionIndex, 3) ~= 0 then
				count = count + 1
			end
			if DataPool:GetPlayerMission_Variable(nMissionIndex, 4) ~= 0 then
				count = count + 1
			end
			local strAppend = ""
			strAppend = strAppend.."   #W" .. ScriptGlobal_Format("#{JJFY_240407_155}",count)
			strTarget = strTarget.."#r#W"..strAppend
		end
	else
		strTarget = "   #W#{JJFY_240407_156}"
	end
	return strTarget
end

function MissionTrack_UpdateWillGet()

	MissionTrack_HaveGet:SetCheck(0);
	MissionTrack_WillGet:SetCheck(1);
	g_nNowCheck = 2;

	local nMyLevel = Player:GetData( "LEVEL" )
	MissionTrack_ListBoxTransparent:ClearListBoxEx();

	CollectMissionOutline();

	for iMissionType=1,200 do             --???????200?
	    local strOutlineName = "#cff9900" .. DataPool:GetMissionInfo_Kind( iMissionType );  --#gFE7E82

		if( strOutlineName ~= "" or strOutlineName ~= 0) then
	   		local iStart = iMissionType*10000;
	    	local DeployNum = GetMissionOutlineNum( iMissionType )
	   		if( DeployNum > 0 and iMissionType ~= 50) then       --??????,?????
	        	local OutLineMission_Seq = {};
	        	local i = 1;
				for i=1, DeployNum do
				    local color= "";
					local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName, PosX, PosY, SceneID = GetMissionOutlineInfo( iMissionType, i );
					if( MissionLevel - nMyLevel <= 5 and MissionLevel >= nMyLevel -3) then
						local strInfo = "";
						strInfo = " #Y("..MissionLevel..")"..strMissionName;   --???
						table.insert(OutLineMission_Seq,strInfo)
						--MissionTrack_ListBoxTransparent:AddItemExWithoutLayout( strInfo, (iStart+i), 0);
						strInfo = "";
	    				strNpcPos = "#{_INFOAIM"..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."}";
	    				if strScene and strScene ~= "" then
	    					strInfo = strInfo.."   #G"..strScene.."  #R"..strNpcName..strNpcPos;
	    				else
	    					strInfo = strInfo.."   #R"..strNpcName..strNpcPos
	    				end
						table.insert(OutLineMission_Seq,strInfo)        --??????
					end
				end

				if (table.getn(OutLineMission_Seq) > 0) then
					MissionTrack_ListBoxTransparent:AddItemExWithoutLayout( strOutlineName, iStart, 0 )
					local nn = 1;
					color = "FFD9F80A";	--??
					for nn,Per_Seq in ipairs(OutLineMission_Seq) do
						MissionTrack_ListBoxTransparent:AddItemExWithoutLayout( Per_Seq, (iStart+nn), 0, color, 4);
					end
				end
	    	end
		end
	end
	MissionTrack_ListBoxTransparent:RequestLayout();
end

function MissionTrack_CloseFunc()
	this:Hide();
	DataPool:SetTrackFuncShow(1, 0);
	DataPool:UpdateTrackStateButton(0);
end

function MissionTrack_HaveGetFunc()
	MissionTrack_HaveGet:SetCheck(1);
	MissionTrack_WillGet:SetCheck(0);
	if(g_nNowCheck ~= 1) then
		MissionTrack_UpdateHaveGetMission(-1);
	end
end

function MissionTrack_WillGetFunc()
	MissionTrack_HaveGet:SetCheck(0);
	MissionTrack_WillGet:SetCheck(1);
	if(g_nNowCheck ~= 2) then
		MissionTrack_UpdateWillGet();
	end
end

function MissionTrack_ItemContextClickedForEye()
	local curSceneID = GetSceneID();
	if (curSceneID == g_DiFu_Scene_Id) then
			return
	end

	local nClickedItemInx = MissionTrack_ListBoxTransparent:GetClickedButtonItem();
	DataPool:MissionTrackGotoQuestLog(nClickedItemInx);
end

function MissionTrack_ItemContextClickedForClose()
	local nClickedItemInx = MissionTrack_ListBoxTransparent:GetClickedButtonItem();
	DataPool:SetMissionTrackOpen(nClickedItemInx, 0);
	MissionTrack_UpdateHaveGetMission(-1);
	DataPool:UpdateQuestLogByTrack();
end

function MissionTrack_On_Height_Add()
	local nHeightOld = MissionTrack_Frame:GetProperty("AbsoluteHeight");
	local nListTopOld = MissionTrack__Frame:GetProperty("AbsoluteYPosition");
	local nHeightOld2 = MissionTrack__Frame:GetProperty("AbsoluteHeight");
	local nFunctionTopOld = MissionTrack_Function_Frame:GetProperty("AbsoluteYPosition");
	if (tonumber(nHeightOld) < 379) then
		MissionTrack_Frame:SetProperty("AbsoluteHeight", nHeightOld+17);
		MissionTrack__Frame:SetProperty("AbsoluteHeight", nHeightOld2+17);
		MissionTrack__Frame:SetProperty("AbsoluteYPosition", nListTopOld);
		MissionTrack_Function_Frame:SetProperty("AbsoluteYPosition", nFunctionTopOld);
	end
end

function MissionTrack_On_Height_Reduce()
	local nHeightOld = MissionTrack_Frame:GetProperty("AbsoluteHeight");
	local nListTopOld = MissionTrack__Frame:GetProperty("AbsoluteYPosition");
	local nHeightOld2 = MissionTrack__Frame:GetProperty("AbsoluteHeight");
	local nFunctionTopOld = MissionTrack_Function_Frame:GetProperty("AbsoluteYPosition");
	if (tonumber(nHeightOld) > 158) then
		MissionTrack_Frame:SetProperty("AbsoluteHeight", nHeightOld-17);
		MissionTrack__Frame:SetProperty("AbsoluteYPosition", nListTopOld);
		MissionTrack__Frame:SetProperty("AbsoluteHeight", nHeightOld2-17);
		MissionTrack_Function_Frame:SetProperty("AbsoluteYPosition", nFunctionTopOld);
	end
end

function MissionTrack_On_Width_Add()
	--MissionTrack_Frame_Context:SetProperty("Alpha", "10");

	local nWidthOld = MissionTrack_Frame:GetProperty("AbsoluteWidth");
	local nFrameLeftOld = MissionTrack_Frame:GetProperty("AbsoluteXPosition");
	local nCheckBoxX = MissionTrack_CheckBox_Frame:GetProperty("AbsoluteXPosition");
	local nDragX = MissionTrack_DragTitle:GetProperty("AbsoluteXPosition");
	local nCloseX = MissionTrack_Close:GetProperty("AbsoluteXPosition");
	local nWidthOld2 = MissionTrack__Frame:GetProperty("AbsoluteWidth");
	local nFuncLeft = MissionTrack_Function_Frame:GetProperty("AbsoluteXPosition");
	local nLockX = MissionTrack_Lock:GetProperty("AbsoluteXPosition");
	if (tonumber(nWidthOld) < 310) then
		MissionTrack_Frame:SetProperty("AbsoluteWidth", nWidthOld + 10);
		MissionTrack_Frame:SetProperty("AbsoluteXPosition", nFrameLeftOld-10);
		MissionTrack_CheckBox_Frame:SetProperty("AbsoluteXPosition", nCheckBoxX + 10);
		MissionTrack_DragTitle:SetProperty("AbsoluteXPosition", nDragX + 10);
		MissionTrack_Close:SetProperty("AbsoluteXPosition", nCloseX + 10);
		MissionTrack__Frame:SetProperty("AbsoluteWidth", nWidthOld2 + 10);
		MissionTrack_Function_Frame:SetProperty("AbsoluteXPosition", nFuncLeft + 10);
		MissionTrack_Lock:SetProperty("AbsoluteXPosition", nLockX + 10);
		MissionTrack_UnLock:SetProperty("AbsoluteXPosition", nLockX + 10);
	end
end

function MissionTrack_On_Width_Reduce()
	local nWidthOld = MissionTrack_Frame:GetProperty("AbsoluteWidth");
	local nFrameLeftOld = MissionTrack_Frame:GetProperty("AbsoluteXPosition");
	local nCheckBoxX = MissionTrack_CheckBox_Frame:GetProperty("AbsoluteXPosition");
	local nDragX = MissionTrack_DragTitle:GetProperty("AbsoluteXPosition");
	local nCloseX = MissionTrack_Close:GetProperty("AbsoluteXPosition");
	local nWidthOld2 = MissionTrack__Frame:GetProperty("AbsoluteWidth");
	local nFuncLeft = MissionTrack_Function_Frame:GetProperty("AbsoluteXPosition");
	local nLockX = MissionTrack_Lock:GetProperty("AbsoluteXPosition");
	if (tonumber(nWidthOld) > 230) then
		MissionTrack_Frame:SetProperty("AbsoluteWidth", nWidthOld - 10);
		MissionTrack_Frame:SetProperty("AbsoluteXPosition", nFrameLeftOld+10);
		MissionTrack_CheckBox_Frame:SetProperty("AbsoluteXPosition", nCheckBoxX - 10);
		MissionTrack_DragTitle:SetProperty("AbsoluteXPosition", nDragX - 10);
		MissionTrack_Close:SetProperty("AbsoluteXPosition", nCloseX - 10);
		MissionTrack__Frame:SetProperty("AbsoluteWidth", nWidthOld2 - 10);
		MissionTrack_Function_Frame:SetProperty("AbsoluteXPosition", nFuncLeft - 10);
		MissionTrack_Lock:SetProperty("AbsoluteXPosition", nLockX - 10);
		MissionTrack_UnLock:SetProperty("AbsoluteXPosition", nLockX - 10);
	end
end

function MissionTrack_On_Lock()

	if (g_LockState == 0) then   --????
		g_LockState = 1;
		MissionTrack_UnLock:Show();
		MissionTrack_Lock:Hide();
		MissionTrack_HaveGet:SetProperty("MouseHollow", "True");
		MissionTrack_WillGet:SetProperty("MouseHollow", "True");
		MissionTrack_Close:SetProperty("MouseHollow", "True");
		MissionTrack_Frame:SetProperty("MouseHollow", "True");
		MissionTrack_DragTitle:SetProperty("MouseHollow", "True");
		MissionTrack_Function_Frame:SetProperty("MouseHollow", "True");
		MissionTrack_Height_Add:SetProperty("MouseHollow", "True");
		MissionTrack_Height_Reduce:SetProperty("MouseHollow", "True");
		MissionTrack_Width_Add:SetProperty("MouseHollow", "True");
		MissionTrack_Width_Reduce:SetProperty("MouseHollow", "True");
		MissionTrack_Reset:SetProperty("MouseHollow", "True");
	else               --??
		g_LockState = 0;
		MissionTrack_Lock:Show();
		MissionTrack_UnLock:Hide();
		MissionTrack_HaveGet:SetProperty("MouseHollow", "False");
		MissionTrack_WillGet:SetProperty("MouseHollow", "False");
		MissionTrack_Close:SetProperty("MouseHollow", "False");
		MissionTrack_Frame:SetProperty("MouseHollow", "False");
		MissionTrack_DragTitle:SetProperty("MouseHollow", "False");
		MissionTrack_Function_Frame:SetProperty("MouseHollow", "False");
		MissionTrack_Height_Add:SetProperty("MouseHollow", "False");
		MissionTrack_Height_Reduce:SetProperty("MouseHollow", "False");
		MissionTrack_Width_Add:SetProperty("MouseHollow", "False");
		MissionTrack_Width_Reduce:SetProperty("MouseHollow", "False");
		MissionTrack_Reset:SetProperty("MouseHollow", "False");
	end
	MissionTrack_ShowORHideFunc(0);

end

function MissionTrack_On_Reset()
	MissionTrack_Frame:SetProperty("UnifiedSize", g_MissionTrack_Frame_UnifiedSize);
	MissionTrack_Frame:SetProperty("UnifiedXPosition", g_MissionTrack_Frame_UnifiedXPosition);
	MissionTrack_Frame:SetProperty("UnifiedYPosition", g_MissionTrack_Frame_UnifiedYPosition);

	MissionTrack__Frame:SetProperty("AbsolutePosition", g_MissionTrack__Frame_AbsolutePosition);
	MissionTrack__Frame:SetProperty("AbsoluteSize", g_MissionTrack__Frame_AbsoluteSize);

	MissionTrack_Function_Frame:SetProperty("AbsolutePosition", g_MissionTrack_Function_Frame_AbsolutePosition);

	MissionTrack_DragTitle:SetProperty("AbsolutePosition", g_MissionTrack_DragTitle_AbsolutePosition);
	MissionTrack_Close:SetProperty("AbsolutePosition", g_MissionTrack_Close_AbsolutePosition);
	MissionTrack_CheckBox_Frame:SetProperty("AbsolutePosition", g_MissionTrack__CheckBox_Frame_AbsolutePosition);
	MissionTrack_Lock:SetProperty("AbsolutePosition", g_MissionTrack_Lock_AbsolutePosition);
	MissionTrack_UnLock:SetProperty("AbsolutePosition", g_MissionTrack_UnLock_AbsolutePosition);
end

function MissionTrack_Func_MouseEnter()
	MissionTrack_ShowORHideFunc(1);
end

function MissionTrack_Func_MouseLeave()
	MissionTrack_ShowORHideFunc(0);
end

function MissionTrack_ShowORHideFunc( nShow )

	if (nShow >= 1 and g_LockState == 0) then
		MissionTrack_Height_Add:Show();
		MissionTrack_Height_Reduce:Show();
		MissionTrack_Width_Add:Show();
		MissionTrack_Width_Reduce:Show();
		MissionTrack_Reset:Show();
	else
		MissionTrack_Height_Add:Hide();
		MissionTrack_Height_Reduce:Hide();
		MissionTrack_Width_Add:Hide();
		MissionTrack_Width_Reduce:Hide();
		MissionTrack_Reset:Hide();
	end
end


function MissionTrack_SetAlpha(val)
	local bNum = val
	if tonumber(bNum) < 0.3 then
		MissionTrack_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_Function_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_ListBoxTransparent:SetVScrollbarAlpha("0.3");
	elseif tonumber(bNum) < 0.5 then
		MissionTrack_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_Function_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_ListBoxTransparent:SetVScrollbarAlpha(val);
	else
		MissionTrack_Frame:SetProperty( "Alpha", val );
		MissionTrack_Function_Frame:SetProperty( "Alpha", val );
		MissionTrack_ListBoxTransparent:SetVScrollbarAlpha(val);
	end
	MissionTrack_Frame_Context:SetProperty( "Alpha", val );
end

--TT53675¶ÔËùÓÐ²»·ûºÏ¹æ·¶£¬Ã»ÓÐ½«missionparamµÚ0Î»×öÎªÈÎÎñÍê³É±êÖ¾µÄÈÎÎñ½Å±¾×öÌØÊâ´¦Àí£¬ÅÐ¶ÏÈÎÎñÊÇ·ñÍê³É
function IsMissionSuccess(nSelIndex)
       local MissionParam_Index = 0
       local Mission_Variable = 0
--ÈÎÎñÐèÒªÉ±µÄnpc
		local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nSelIndex);
		if( nDemandKillNum > 0 ) then
			for i=1, nDemandKillNum do
				--    ÐèÒªµÄNPC£¬ÐèÒªNPC ID£¬ÐèÒª¶àÉÙ¸ö
				local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nSelIndex);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index,Kill_Random_Type,i-1);
				MissionParam_Index = MissionParam_Index + 1;
				if Mission_Variable < nNum then
					return 0
				end
			end
		end

--ÈÎÎñÐèÒªµÄÎïÆ·
		local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nSelIndex);
		if( nDemandNum > 0 ) then
			for i=1, nDemandNum do
				--    ÐèÒªµÄÀàÐÍ£¬ÐèÒªÎïÆ·ID£¬ÐèÒª¶àÉÙ¸ö
				local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nSelIndex);
				Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
				 if Mission_Variable < nNum then
					return 0
				 end
			 end
		 end

-----------------------------------------------------------------------------------
--ÈÎÎñ×Ô¶¨ÒåµÄÎïÆ·
		local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nSelIndex);
		if( nCustomNum > 0 ) then
			for i=1, nCustomNum do
				--    ÐèÒªµÄNPC£¬ÐèÒªNPC ID£¬ÐèÒª¶àÉÙ¸ö
				local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
				MissionParam_Index = MissionParam_Index + 1;
				if Mission_Variable < nNum then
				    return 0
				end
			end
		end

-----------------------------------------------------------------------------------

--ÈÎÎñ×Ô¶¨ÒåµÄËæ»úÎïÆ· zzÌí¼Ó

	local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nSelIndex);
	if( nRandomCustomNum > 0 ) then
		for i=1,nRandomCustomNum do
			local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nSelIndex);
			if nCompleteNum < nNeedNum then
				return 0
			end
		end
	end

	return 1
end


function MissionTrack_GetXuanChuanYXDHTarget( nMissionIndex )

	local MenPaiList = {
		[0] = "#{BFHX_210203_07}",    --??
		[1] = "#{BFHX_210203_13}",    --??
		[2] = "#{BFHX_210203_12}",    --??
		[3] = "#{BFHX_210203_14}",    --??
		[4] = "#{BFHX_210203_08}",    --??
		[5] = "#{BFHX_210203_11}",    --??
		[6] = "#{BFHX_210203_10}",    --??
		[7] = "#{BFHX_210203_09}",    --??
		[8] = "#{BFHX_210203_15}",     --??
		[9] = "Tñ do",     --???
		[10] = "#{GMGameInterface_Script_DataPool_Info_ManTuoShanZhuang}",     --????
	}

	local isDoneAll = 1
	local isDoneList = {}
	for i = 1, 5 do
		local isDone = DataPool:GetPlayerMission_VariableByByte( nMissionIndex, i, 1 )
		if isDoneAll == 1 and isDone == 0 then
			isDoneAll = 0
		end
		isDoneList[i] = isDone
	end
	if isDoneAll == 1 then
		return "   #W#{BFHX_210203_17}"
	end

	local strComplete = "   #W#{BFHX_210203_16}#R\n"
	for i = 1, 5 do
		local temp_str = ""
		local menpaiId = DataPool:GetPlayerMission_VariableByByte( nMissionIndex, i, 0 )
		if isDoneList[i] == 1 then
			temp_str = "   "..MenPaiList[menpaiId].." : 1 / 1"
		elseif isDoneList[i] == 0 then
			temp_str = "   "..MenPaiList[menpaiId].." : 0 / 1"
		end
		strComplete = strComplete..temp_str
		if i ~= 5 then
			strComplete = strComplete.."\n"
		end
	end
	return strComplete

end

function MissionTrack_Get22Q1QTESignInDesc(nMissionIndex)
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
    local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	if param0 == 1 then
		local msgtip = {"#{BBYJ_220104_18}","#{BBYJ_220104_18}","#{BBYJ_220104_18}"}
		if msgtip[param1] ~= nil then
			local str = ScriptGlobal_Format(msgtip[param1], param2)
			return "#W"..str.."\n"
		else
			local str = ScriptGlobal_Format(msgtip[1], param2)
			return "#W"..str.."\n"
		end
	else
		local msgtip = {"#{BBYJ_220104_15}","#{BBYJ_220104_16}","#{BBYJ_220104_17}"}
		if msgtip[param1] ~= nil then
			local str = ScriptGlobal_Format(msgtip[param1], param2)
			return "#W"..str.."\n"
		else
			local str = ScriptGlobal_Format(msgtip[1], param2)
			return "#W"..str.."\n"
		end
	end
end

--ÎäµÀÈý²ãÀúÁ·ÈÎÎñ ÌØÐ´ Íê³ÉÇé¿ö
function MissionTrack_GetItem_JingJinMission( nIndex1,nIndex2 )
	local NPCname = ""
	local LPname = ""
	local MenPaiNpc = {

	[0] ={MenPai="Thiªu Lâm",SceneName="Thiªu Lâm Tñ",NPC={[0]="#{LLRW_230309_22}",[1]="#{LLRW_230309_21}"},LP={[0]="#{XLRW_210725_481}",[1]="#{XLRW_210725_480}"},},
	[1] ={MenPai="Minh Giáo",SceneName="Quang Minh Ði®n",NPC={[0]="#{LLRW_230309_26}",[1]="#{LLRW_230309_25}"},LP={[0]="#{XLRW_210725_485}",[1]="#{XLRW_210725_484}"},},
	[2] ={MenPai="Cái Bang",SceneName="Cái Bang T±ng Ðà",NPC={[0]="#{LLRW_230309_24}",[1]="#{LLRW_230309_23}"},LP={[0]="#{XLRW_210725_483}",[1]="#{XLRW_210725_482}"},},
	[3] ={MenPai="Võ Ðang",SceneName="Võ Ðang S½n",NPC={[0]="#{LLRW_230309_27}",[1]="#{LLRW_230309_28}"},LP={[0]="#{XLRW_210725_486}",[1]="#{XLRW_210725_487}"},},
	[4] ={MenPai="Nga Mi",SceneName="Nga Mi S½n",NPC={[0]="#{LLRW_230309_33}",[1]="#{LLRW_230309_34}"},LP={[0]="#{XLRW_210725_492}",[1]="#{XLRW_210725_493}"},},
	[5] ={MenPai="Tinh Túc",SceneName="Tinh Túc Häi",NPC={[0]="#{LLRW_230309_35}",[1]="#{LLRW_230309_36}"},LP={[0]="#{XLRW_210725_494}",[1]="#{XLRW_210725_495}"},},
	[6] ={MenPai="Thiên Long",SceneName="Thiên Long Tñ",NPC={[0]="#{LLRW_230309_29}",[1]="#{LLRW_230309_30}"},LP={[0]="#{XLRW_210725_488}",[1]="#{XLRW_210725_489}"},},
	[7] ={MenPai="Thiên S½n",SceneName="Thiên S½n",NPC={[0]="#{LLRW_230309_37}",[1]="#{LLRW_230309_38}"},LP={[0]="#{XLRW_210725_496}",[1]="#{XLRW_210725_497}"},},
	[8] ={MenPai="Tiêu dao",SceneName="Lång Ba Ðµng",NPC={[0]="#{LLRW_230309_31}",[1]="#{LLRW_230309_32}"},LP={[0]="#{XLRW_210725_490}",[1]="#{XLRW_210725_491}"},},
	[10] ={MenPai="MÕn Ðà",SceneName="MÕn Ðà S½n Trang",NPC={[0]="#{LLRW_230309_39}",[1]="#{LLRW_230309_40}"},LP={[0]="#{XLRW_210725_737}",[1]="#{XLRW_210725_738}"},},

	}
	if nIndex1 < 0 or nIndex1 > 10 or nIndex1 == 9 or nIndex2 < 0 or nIndex2 >1 then
		return NPCname,LPname
	end
	NPCname = MenPaiNpc[nIndex1].NPC[nIndex2]
	LPname = MenPaiNpc[nIndex1].LP[nIndex2]
	return NPCname,LPname,MenPaiNpc[nIndex1].SceneName
end

--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ2ÌØÐ´ ÈÎÎñ×·×Ù
function MissionTrack_GetItem_LiLianMission2( nIndex )
	local itemnum = 0
	local itemname = ""
	local tList = {{3,30900028,},{3,20310110,},{1,10156001,},{1,10156002,},
		{3,20310113,},{10,20310020,},{10,20310003,},{10,20310004,},}
	if tList[nIndex] ~= nil then
		itemnum = tList[nIndex][1]
		itemname = DataPool:LuaFnGetItemNameByTableIndex(tList[nIndex][2])
	end
	return itemnum,itemname
end
function MissionTrack_LiLianMission21( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if param0 == 0 then
		local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		local itemnum,itemname = MissionTrack_GetItem_LiLianMission2( nIndex )
		if itemnum > 0 then
			return "#W"..ScriptGlobal_Format("#{ZQSS_220429_59}", itemnum, itemname)
		end
	end
	return ""
end
function MissionTrack_LiLianMission22( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if param0 == 0 then
		local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		local itemnum,itemname = MissionTrack_GetItem_LiLianMission2( nIndex )
		if itemnum > 0 then
			return "#W"..ScriptGlobal_Format("#{XZDZ_220428_59}", itemnum, itemname)
		end
	end
	return ""
end
function MissionTrack_LiLianMission23( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if param0 == 0 then
		local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		local itemnum,itemname = MissionTrack_GetItem_LiLianMission2( nIndex )
		if itemnum > 0 then
			return "#W"..ScriptGlobal_Format("#{LNQZ_220429_59}", itemnum, itemname)
		end
	end
	return ""
end


--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ4ÌØÐ´ Íê³ÉÇé¿ö
function MissionTrack_GetItem_LiLianMission4( nIndex1,nIndex2 )
	local NPCname = ""
	local LPname = ""
	local MenPaiNpc = {

	[0] ={MenPai="Thiªu Lâm",NPC={[0]="#{LLRW_231010_22}",[1]="#{LLRW_231010_21}"},LP={[0]="#{XLRW_210725_481}",[1]="#{XLRW_210725_480}"},},
	[1] ={MenPai="Minh Giáo",NPC={[0]="#{LLRW_231010_26}",[1]="#{LLRW_231010_25}"},LP={[0]="#{XLRW_210725_485}",[1]="#{XLRW_210725_484}"},},
	[2] ={MenPai="Cái Bang",NPC={[0]="#{LLRW_231010_24}",[1]="#{LLRW_231010_23}"},LP={[0]="#{XLRW_210725_483}",[1]="#{XLRW_210725_482}"},},
	[3] ={MenPai="Võ Ðang",NPC={[0]="#{LLRW_231010_27}",[1]="#{LLRW_231010_28}"},LP={[0]="#{XLRW_210725_486}",[1]="#{XLRW_210725_487}"},},
	[4] ={MenPai="Nga Mi",NPC={[0]="#{LLRW_231010_33}",[1]="#{LLRW_231010_34}"},LP={[0]="#{XLRW_210725_492}",[1]="#{XLRW_210725_493}"},},
	[5] ={MenPai="Tinh Túc",NPC={[0]="#{LLRW_231010_35}",[1]="#{LLRW_231010_36}"},LP={[0]="#{XLRW_210725_494}",[1]="#{XLRW_210725_495}"},},
	[6] ={MenPai="Thiên Long",NPC={[0]="#{LLRW_231010_29}",[1]="#{LLRW_231010_30}"},LP={[0]="#{XLRW_210725_488}",[1]="#{XLRW_210725_489}"},},
	[7] ={MenPai="Thiên S½n",NPC={[0]="#{LLRW_231010_37}",[1]="#{LLRW_231010_38}"},LP={[0]="#{XLRW_210725_496}",[1]="#{XLRW_210725_497}"},},
	[8] ={MenPai="Tiêu dao",NPC={[0]="#{LLRW_231010_31}",[1]="#{LLRW_231010_32}"},LP={[0]="#{XLRW_210725_490}",[1]="#{XLRW_210725_491}"},},
	[10] ={MenPai="MÕn Ðà",NPC={[0]="#{LLRW_231010_39}",[1]="#{LLRW_231010_40}"},LP={[0]="#{XLRW_210725_737}",[1]="#{XLRW_210725_738}"},},

	}
	if nIndex1 < 0 or nIndex1 > 10 or nIndex1 == 9 or nIndex2 < 0 or nIndex2 >1 then
		return NPCname,LPname
	end
	NPCname = MenPaiNpc[nIndex1].NPC[nIndex2]
	LPname = MenPaiNpc[nIndex1].LP[nIndex2]
	return NPCname,LPname,MenPaiNpc[nIndex1].MenPai
end
function MissionTrack_LiLianMission14( nMissionIndex )

		local nIndex1 = Player:GetData("MEMPAI")
		local nIndex2 = DataPool:GetSectType()
		local NPCname,LPname = MissionTrack_GetItem_LiLianMission4( nIndex1,nIndex2 )
		if NPCname ~= "" and LPname ~= "" then
			return "#W"..ScriptGlobal_Format("#{ZQSS_220429_174}", LPname, NPCname)
		end

	return ""
end

function MissionTrack_LiLianMission24( nMissionIndex )

		local nIndex1 = Player:GetData("MEMPAI")
		local nIndex2 = DataPool:GetSectType()
		local NPCname,LPname = MissionTrack_GetItem_LiLianMission4( nIndex1,nIndex2 )
		if NPCname ~= "" and LPname ~= "" then
			return "#W"..ScriptGlobal_Format("#{XZDZ_220428_174}", LPname, NPCname)
		end

	return ""
end

function MissionTrack_LiLianMission34( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )

		local nIndex1 = Player:GetData("MEMPAI")
		local nIndex2 = DataPool:GetSectType()
		local NPCname,LPname = MissionTrack_GetItem_LiLianMission4( nIndex1,nIndex2 )
		if NPCname ~= "" and LPname ~= "" then
			return "#W"..ScriptGlobal_Format("#{LNQZ_220429_174}", LPname, NPCname)
		end
	return ""
end

function MissionTrack_Roman(nMissionIndex)
	local posIdx = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	local dictArr = {
		"#{QYHY_230330_115}",
		"#{QYHY_230330_116}",
		"#{QYHY_230330_117}",
		"#{QYHY_230330_118}",
		"#{QYHY_230330_119}",
		"#{QYHY_230330_120}",
		"#{QYHY_230330_121}",
		"#{QYHY_230330_122}",
		"#{QYHY_230330_123}",
		"#{QYHY_230330_124}",
		}
	if posIdx <= 10 and posIdx >= 1 then
		return "#W"..ScriptGlobal_Format("#{QYHY_230330_50}", dictArr[posIdx])
	else
		return " "
	end
end

function MissionTrack_QRJGW(nMissionIndex)
	local myScore = DataPool:LuaFnGetMD( 1027 )
	local bFinish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if bFinish == 0 then
		return "#W".."#{QRGW_231120_87}"  --ScriptGlobal_Format("#{QYHY_230330_50}", dictArr[posIdx])
	else
		return "#W"..ScriptGlobal_Format("#{QRGW_231120_86}", myScore)
	end

end

function MissionTrack_ShenFenTuPo(nMissionIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )--??
--	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )--ÐèÒªµÀ¾ßid
	local param3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )--????count
	
--	local itemname = DataPool:LuaFnGetItemNameByTableIndex(param2)

	return "#W"..ScriptGlobal_Format("#{YCGZ_231225_10}", param1, param3)
end

function MissionTrack_TianDeng(nMissionIndex)
	local isQiYuanFinish = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )--1??????????
	if isQiYuanFinish == 1 then
		return "#W".."#{ZNTD_230720_209}"
	else
		return "#W".."#{ZNTD_230720_160}"
	end
end

function MissionTrack_LongHaizi(nMissionIndex)
	local scnIndex = DataPool:GetPlayerMission_Variable(nMissionIndex,2); --??????
	local clueIndex = DataPool:GetPlayerMission_Variable(nMissionIndex,4); --??????
	local tableclues = { --??
		"#{LNDK_231025_120}","#{LNDK_231025_121}","#{LNDK_231025_122}","#{LNDK_231025_123}",
	}
	if scnIndex == 1 then --??
		tableclues = {
			"#{LNDK_231025_124}","#{LNDK_231025_125}","#{LNDK_231025_126}","#{LNDK_231025_127}",
		}
	elseif scnIndex == 2 then --??
		tableclues = {
			"#{LNDK_231025_116}","#{LNDK_231025_117}","#{LNDK_231025_118}","#{LNDK_231025_119}",
		}	
	end
	return  tableclues[math.floor((clueIndex+2)/3)] or "error"..scnIndex..clueIndex
end

function MissionTrack_XRBQL(nMissionIndex)
	local isMissionComplete = DataPool:GetPlayerMission_Variable(nMissionIndex,0);
	if isMissionComplete == 1 then 
		return "#W".."#{XRBG_20240412_81}"
	else
		return "#W"..ScriptGlobal_Format("#{XRBG_20240412_82}", 0)
	end
end
function MissionTrack_GetTrack_DHXYStage2_1(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_244}", 1)
		return strComplete	
	else
		local num = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )


		if num == 0 then
			--½×¶ÎÒ»½øÐÐÖÐ
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_241}", 0)


			return strComplete
		elseif num == 1 then
			--½×¶Î¶þ½øÐÐÖÐ
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_242}", 0)
			return strComplete
		elseif num == 2 then
			--½×¶ÎÈý½øÐÐÖÐ
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_243}", 0)
			return strComplete
		end
	end
	return ""
end

function MissionTrack_GetTrack_DHXYStage2_2(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_248}", 1)
		return strComplete	
	else
		local stage1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		if stage1 == 0 then
			--½×¶ÎÒ»½øÐÐÖÐ
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_245}", 0)
			return strComplete
		end
		local stage2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
		if stage2 == 0 then
			--½×¶ÎÒ»½øÐÐÖÐ
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_246}", 0)
			return strComplete
		end
		local stage3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
		--½×¶ÎÈý½øÐÐÖÐ
		local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_247}", stage3)
		return strComplete
	end
	return ""
end

function MissionTrack_GetTrack_DHXYStage2_3(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_254}", 1)
		return strComplete	
	else
		local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		if param2 == 0 then
			--½×¶ÎÒ»½øÐÐÖÐ
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_249}", 0)
			return strComplete
		end
		local param3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
		local param4 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
		if param3 < 1 or param4 < 1 then
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_250}", param3, param4)
			return strComplete
		end
		local param5 = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
		if param5 < 1 then
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_252}", param5)
			return strComplete
		end
	end
	return ""
end

function MissionTrack_GetTrack_DHXYStage2_4(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_258}", 1)
		return strComplete	
	else
		local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		if param2 == 0 then
			--½×¶ÎÒ»½øÐÐÖÐ
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_255}", param2)
			return strComplete
		end
		local param3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
		if param3 == 0 then
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_256}", param3)
			return strComplete
		end
		local param4 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
		if param4 == 0 then
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_257}", param4)
			return strComplete
		end
	end
	return ""
end
function MissionTrack_GetTrack_DHXYStage2_5(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_269}", 1)
		return strComplete	
	else
		local stagecur = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		if stagecur == 0 then
			--µÚÒ»½×¶Î
			local stage1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
			if stage1 == 0 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_259}", 0)
				return strComplete
			elseif stage1 == 1 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_260}", 0)
				return strComplete
			end
		elseif stagecur == 1 then
			--µÚ¶þ½×¶Î
			local stage2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
			if stage2 == 0 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_261}", 0)
				return strComplete
			elseif stage2 == 1 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_262}", 0)
				return strComplete
			elseif stage2 == 2 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_263}", 0)
				return strComplete
			elseif stage2 == 3 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_264}", 0)
				return strComplete
			elseif stage2 == 4 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_265}", 0)
				return strComplete
			elseif stage2 == 5 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_266}", 0)
				return strComplete
			end
		elseif stagecur == 2 then
			--µÚÈý½×¶Î
			local stage3a = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
			local stage3b = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
			if stage3a == 0 or stage3b == 0 then
				local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_267}", stage3a, stage3b)
				return strComplete
			end
		end
	end
	return ""
end
function MissionTrack_GetTrack_DHXYStage2_6(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_274}", 1)
		return strComplete	
	else
		local stage1a = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		local stage1b = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
		if stage1a == 0 or stage1b == 0 then
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_270}", stage1a, stage1b)
			return strComplete
		end
		local stage2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
		if stage2 == 0 then
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_272}", stage2)
			return strComplete
		end
		local stage3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
		if stage3 == 0 then
			local strComplete = "#W"..ScriptGlobal_Format("#{DHEJ_240521_273}", stage3)
			return strComplete
		end
	end
end

--2024Q2´ó»°Î÷ÓÎµÚÈý½×¶ÎÖ÷Ïß¾çÇé
function MissionTrack_GetTrack_DHXYStage3_1(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W".."#{DSJD_240520_192}"
		return strComplete
	else
		local num = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
		if num == 0 then
			--½ÓÈÎÎñ
			local value1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
			local value2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_191}", value1, value2)
			return strComplete
		elseif num == 1 then
			--½ø¸±±¾
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_193}", 0)
			return strComplete
		elseif num == 2 then
			--Ñ°Â·¿´¾çÇé2
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_311}", 0)
			return strComplete
		elseif num == 3 then
			--Ñ°Â·¿´¾çÇé3
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_312}", 0)
			return strComplete
		elseif num == 4 then
			--Ñ°Â·¿´¾çÇé4
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_313}", 0)
			return strComplete
		elseif num == 5 then
			--¿ªboss
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_184}", 0)
			return strComplete
		elseif num == 6 then
			--É±boss
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_193}", 1)
			return strComplete
		end
	end
	return ""
end
function MissionTrack_GetTrack_DHXYStage3_2(nMissionIndex)
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if finish == 1 then
		local strComplete = "#W".."#{DSJD_240520_253}"
		return strComplete
	else
		local num = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
		if num == 0 then
			--½ÓÈÎÎñ
			local value = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_252}", value)
			return strComplete
		elseif num == 1 then
			--½ø¸±±¾
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_208}", 0)
			return strComplete
		elseif num == 2 then
			--µÚÒ»²¨
			local value = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_220}", value)
			return strComplete
		elseif num == 3 then
			--µÚ¶þ²¨
			local value = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_223}", value)
			return strComplete
		elseif num == 4 then
			--µÚÈý²¨
			local value = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_224}", value)
			return strComplete
		elseif num == 5 then
			--¿ªboss¾çÇé
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_194}", 0)
			return strComplete
		elseif num == 6 then
			--µÚËÄ²¨
			local value1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
			local value2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 7 )
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_225}", value1, value2 )
			return strComplete
		elseif num == 7 then
			--¿ªÌì½Ù¾çÇé
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_234}", 0)
			return strComplete
		elseif num == 8 then
			--¿ªÌì½Ù
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_240}", 0)
			return strComplete
		elseif num == 9 then
			--³É¹¦
			local strComplete = "#W"..ScriptGlobal_Format("#{DSJD_240520_208}", 1)
			return strComplete
		end
	end
	return ""
end
function MissionTrack_GetTrack_2024Q3Preheat(nMissionIndex)
	local isMissionComplete = DataPool:GetPlayerMission_Variable(nMissionIndex,0);
	if isMissionComplete == 1 then 
		return "#W".."#{ERYR_240701_334}"
	end
end

