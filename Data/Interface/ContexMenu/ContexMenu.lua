
--当对象消失的时候，自动关闭这个窗口
local objCared = -1;

local g_MenuType = "";

--同盟成员菜单
local g_LeagueMemberID = -1;

local currentSelectChannal = "1";
local currentIndex;
local currentGuildListIndex;
local currentSelectMember = 0;
local g_showType = "";
local g_Voteinfo_index = 1;

local g_Menu_ObjName = "";
local g_Menu_ObjId = 0;

local g_TeamBoard_Guid = -1;

--- 擂台观战者buff的Impact,如果有这个BUFF,屏蔽右键菜单
local g_LEITAI_VIEWER_BUFF = 2711  

local currentRankListIndex;

local g_MoveToMenuItem = {}
local g_GroupingName = {}

---------------------------------------
--团队
local g_CurSelRaidMember = -1
local g_RaidSquadIndex = -1
---------------------------------------


--OnLoad
function ContexMenu_PreLoad()
	this:RegisterEvent("SHOW_CONTEXMENU");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("HIDE_CONTEXMENU_SPEAKER");
end

function ContexMenu_OnLoad()
    local strTip = GetDictionaryString( "Tip_PVP_Peace" )
    PVP_Peace:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_Moral" )
    PVP_Moral:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_FreeForAll" )
    PVP_FreeforAll:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_FreeForTeam" )
    PVP_FreeforTeam:SetToolTip( strTip )
    
    --strTip = GetDictionaryString( "Tip_PVP_FreeForGuild" )
    strTip = GetDictionaryString( "TM_20080311_16" )
    PVP_FreeforGuild:SetToolTip( strTip )
    
    strTip = GetDictionaryString( "Tip_PVP_Peace" )
    PVP_Peace_Before21:SetToolTip( strTip )
	
	g_MoveToMenuItem = {
			ContexMenu_GroupingMoveTo1,
			ContexMenu_GroupingMoveTo2,
			ContexMenu_GroupingMoveTo3,
			ContexMenu_GroupingMoveTo4,
	}

	g_GroupingName = {
							"#{KDHYYH_211025_37}",
							"#{KDHYYH_211025_38}",
							"#{KDHYYH_211025_39}",
							"#{KDHYYH_211025_40}",
	}
end

function ContexMenu_OnEvent(event)
	AxTrace(1, 0, "chat_private contex menu enter: " .. arg0 );

	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if ( event == "SHOW_CONTEXMENU" ) then
		g_showType = arg0;

		local isChalView = DataPool:IfHaveBuffByID(g_LEITAI_VIEWER_BUFF)
	    if isChalView == 1 then
	        -- 如果正在观战,不能弹出右键菜单
	        return
	    end
	
		local checkHaveMaskBuff = Lua_CheckMainTargetHaveMaskBuff()
		
		
		if(arg0 == "other_player_ts") then			

			this:TransAllWindowText();
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			
			ContexMenu_Tserver:SetPopMenuPos(arg2, arg3); 
			local sceneLogicID = GetSceneID()
			if sceneLogicID == 605 or sceneLogicID == 618 then --or PTDB:LuaFnIsPTDBScene(sceneLogicID) then
				ContexMenu_Tserver_Open_Other_PVP_Challenge:Enable()
			else
				ContexMenu_Tserver_Open_Other_PVP_Challenge:Disable()
			end
			ContexMenu_Tserver_AskTeam:Disable()
			ContexMenu_Tserver_InviteTeam:Disable()
			ContexMenu_Tserver_ApplyToRaid:Disable()
			ContexMenu_Tserver_InviteToRaid:Disable()
			local otherTeamOrRaidState = tonumber(arg4)
			local isCanUseRaid = ContexMenu_IsCanUseRaid()
			local isCanUseTeam = ContexMenu_IsCanUseTeamDiffServer()
			if otherTeamOrRaidState == 1 then
				if Player:IsInTeam() ~= 1 and Player:IsInRaid() ~= 1 then
					if isCanUseTeam == 1 then
						ContexMenu_Tserver_AskTeam:Enable()
					end
				end
			elseif otherTeamOrRaidState == 10 then
				if Player:IsInTeam() ~= 1 and Player:IsInRaid() ~= 1 then	
					if isCanUseTeam == 1 then
						ContexMenu_Tserver_ApplyToRaid:Enable()
					end
				end
			else
				if Player:IsInTeam() == 1 then	
					if isCanUseTeam == 1 then
						ContexMenu_Tserver_InviteTeam:Enable()
					end
				elseif Player:IsInRaid() == 1 then
					if Player:IsRaidLeader() == 1 or Player:IsRaidAssitant() == 1 then
						if isCanUseRaid == 1 then
							ContexMenu_Tserver_InviteToRaid:Enable()
						end
					end
				else
					if isCanUseTeam == 1 then
						ContexMenu_Tserver_InviteTeam:Enable()
					end
				end
			end

			ContexMenu_Tserver:Show();
		
			return;
		end
		if(arg0 == "other_player") then

			this:TransAllWindowText();
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			
			ContexMenu_OtherPlayer:SetPopMenuPos(arg2, arg3);
			if Player : GetData( "GUILD" ) == -1 then
				OtherPlayer_InviteToGuild : Disable()
			else
				OtherPlayer_InviteToGuild : Enable()
			end

		--	local menuItem = "邀请入帮    "
		--	if Player : GetData( "GUILD" ) == -1 then
		--		menuItem = "#cefefef邀请入帮    "
		--	end

		--	OtherPlayer_InviteToGuild : SetText( menuItem )
			ContexMenu_OtherPlayer:Show();
		
			return;
		end

		-------------------------------------------------------------------------------------------------------------------------
		--
		--  如果是队长打开的菜单
		--
		if(arg0 == "Team_Leader") then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			
			if( Player:InTeamFollowMode() ) then
				ContexMenu_TeamFollowLeader:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamFollowLeader:Show();
			else
				ContexMenu_TeamLeader:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamLeader:Show();
			end
			
			AxTrace(0, 0, "队长菜单 menu enter: " ..tostring( arg4 ) );
			currentSelectMember = tonumber( arg4 );

			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 如果是其他队员打开的菜单.
		--
		if(arg0 == "Team_Member") then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			if( Player:InTeamFollowMode() ) then
				ContexMenu_TeamFollowMember:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamFollowMember:Show();
			else
				ContexMenu_TeamMember:SetPopMenuPos(arg2, arg3);
				ContexMenu_TeamMember:Show();
			end
			currentSelectMember = arg4;
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 如果是队员出战珍兽的右键弹出菜单
		-- add by WTT
		--
		if(arg0 == "Team_Member_Pet") then
			ContexMenuFrame_Close();
			this:Show();
			
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");			

			-- 设置位置并显示
			ContexMenu_MemberPetMenu:SetPopMenuPos(arg2, arg3);
			ContexMenu_MemberPetMenu:Show();
			
			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 打开自己队伍界面
		--
		if(arg0 == "player") then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			
			local horse =  GetRideStatic( 1 );
			if( tonumber( horse ) == 0 ) then
				Myself_DisbondRide:Disable();
			elseif( tonumber( horse ) == 1 ) then
				Myself_DisbondRide:Enable();
				Myself_DisbondRide:SetText("邀请同骑");
			else
				Myself_DisbondRide:Enable();
				Myself_DisbondRide:SetText("取消同骑");
			end
			
			local Level = Player:GetData( "LEVEL" );
			
			if( Level > 20 ) then
				ContexMenu_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode" );
			else
				ContexMenu_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode_Before21" );
			end
			ContexMenu_Self:Show();
			ContexMenu_Self:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		
	  --------------------------------------------------------------------------------------------------------------------------
		--
		-- 自己有队伍, 只打开摆摊按钮界面
		--
		if(arg0 == "player_in_team") then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			local horse =  GetRideStatic( 1 );
			if( tonumber( horse ) == 0 ) then
				Myself_InTeam_DisbondRide:Disable();
			elseif( tonumber( horse ) == 1 ) then
				Myself_InTeam_DisbondRide:Enable();
				Myself_InTeam_DisbondRide:SetText("邀请同骑");
			else
				Myself_InTeam_DisbondRide:Enable();
				Myself_InTeam_DisbondRide:SetText("取消同骑");
			end
		
			local Level = Player:GetData( "LEVEL" );
			
			if( Level > 20 ) then
				ContexMenu_Self_InTeam_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode" );
			else
				ContexMenu_Self_InTeam_ChangePVPMode:SetProperty( "PopMenu", "Menu_PVPMode_Before21" );
			end
			if Player:IsInTeam() == 1 then
				Myself_QuitTeam:SetText("#{INTERFACE_XML_704}")
			elseif Player:IsInRaid() == 1 then
				Myself_QuitTeam:SetText("#{TDGZ_XML_24}")
			end
			
			ContexMenu_Self_In_Team:Show();
			ContexMenu_Self_In_Team:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 点击其他队友模型, 弹出的对话框
		--
		if(arg0 == "other_team_member") then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			
			local horse =  GetRideStatic( 0 );
			if( tonumber( horse ) == 0 ) then
				ContexMenu_Model_Open_Other_Invite_Ride:Disable();
			elseif( tonumber( horse ) == 1 ) then
				ContexMenu_Model_Open_Other_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Invite_Ride:SetText("邀请同骑");
			else
				ContexMenu_Model_Open_Other_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Invite_Ride:SetText("取消同骑");
			end
			
			if Player : GetData( "GUILD" ) == -1 then
				ContexMenu_Model_Open_Other_InviteToGuild : Disable()
			else
				ContexMenu_Model_Open_Other_InviteToGuild : Enable()
			end

			ContexMenu_Model_Open_Other:Show();
			ContexMenu_Model_Open_Other:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 点击非组队玩家弹出来的界面
		--
		if(arg0 == "other_not_team_member") then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

		
			local horse =  GetRideStatic( 0 );
			AxTrace( 1,0, "GetRideStatic="..tostring( horse ) );
			if( tonumber( horse ) == 0 ) then
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:Disable();
			elseif( tonumber( horse ) == 1 ) then
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:SetText("邀请同骑");
			else
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:Enable();
				ContexMenu_Model_Open_Other_Not_teammer_Invite_Ride:SetText("取消同骑");
			end
			
			if Player : GetData( "GUILD" ) == -1 then
				ContexMenu_Model_Open_Other_Not_teammer_InviteToGuild : Disable()
			else
				ContexMenu_Model_Open_Other_Not_teammer_InviteToGuild : Enable()
			end

			ContexMenu_Model_Open_Other_Not_teammer:Show();
			ContexMenu_Model_Open_Other_Not_teammer:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 非组队玩家, 点击组队玩家, 弹出的菜单
		--
		if(arg0 == "other_team_member_me_not_teamer") then

			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");
			local horse =  GetRideStatic( 0 );
			AxTrace( 1,0, "GetRideStatic="..tostring( horse ) );
			if( tonumber( horse ) == 0 ) then
				ContexMenu_Model_Open_Other_teammer_me_Ride:Disable();
			elseif( tonumber( horse ) == 1 ) then
				ContexMenu_Model_Open_Other_teammer_me_Ride:Enable();
				ContexMenu_Model_Open_Other_teammer_me_Ride:SetText("邀请同骑");
			else
				ContexMenu_Model_Open_Other_teammer_me_Ride:Enable();
				ContexMenu_Model_Open_Other_teammer_me_Ride:SetText("取消同骑");
			end
			
			if Player : GetData( "GUILD" ) == -1 then
				ContexMenu_Model_Open_Other_teammer_me_InviteToGuild : Disable()
			else
				ContexMenu_Model_Open_Other_teammer_me_InviteToGuild : Enable()
			end
			ContexMenu_Model_Open_Other_teammer_me_not_teammer:Show();
			ContexMenu_Model_Open_Other_teammer_me_not_teammer:SetPopMenuPos(arg2, arg3);
			return;
		end;
		
		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 点击聊天里的人物名, 弹出的菜单
		--		
		if(arg0 == "chat_private") then
			if checkHaveMaskBuff ==  1 then
				return 
			end
			ContexMenu_HideAll();
			this:Show();
			--关心NPC
			g_MenuType = arg1;
			if tonumber(arg4) == 2 then
				ContexMenu_TserverAlike:Show()
				ContexMenu_TserverAlike:SetPopMenuPos(arg2,arg3);
			elseif(tonumber(arg4)==1)then
			
				if Player:IsInTeam() == 1 then
					ContexMenu_ChatBoard_RaidInvite:Disable()
					ContexMenu_ChatBoard_RaidApply:Disable()
				-- elseif Player:IsInRaid() == 1 then
				-- 	if Player:IsRaidLeader() == 1 or Player:IsRaidAssitant() == 1 then
				-- 		ContexMenu_ChatBoard_RaidInvite:Enable()
				-- 	else
				-- 		ContexMenu_ChatBoard_RaidInvite:Disable()
				-- 	end
				-- 	ContexMenu_ChatBoard_RaidApply:Disable()				
				else
					ContexMenu_ChatBoard_RaidInvite:Disable()
					ContexMenu_ChatBoard_RaidApply:Disable()
				end
				ContexMenu_ChatBoard:Show();
				ContexMenu_ChatBoard:SetPopMenuPos(arg2,arg3);
			elseif (tonumber(arg4)==3) then
				ContexMenu_SecretChatBoard:Show();
				ContexMenu_SecretChatBoard:SetPopMenuPos(arg2,arg3);
			else
				if Player:IsInTeam() == 1 then
					ContexMenu_ChatBoard_RaidInvite_NoToushu:Disable()
					ContexMenu_ChatBoard_RaidApply_NoToushu:Disable()
				-- elseif Player:IsInRaid() == 1 then
				-- 	if Player:IsRaidLeader() == 1 or Player:IsRaidAssitant() == 1 then
				-- 		ContexMenu_ChatBoard_RaidInvite_NoToushu:Enable()
				-- 	else
				-- 		ContexMenu_ChatBoard_RaidInvite_NoToushu:Disable()
				-- 	end
				-- 	ContexMenu_ChatBoard_RaidApply_NoToushu:Disable()	
				else
					ContexMenu_ChatBoard_RaidInvite_NoToushu:Disable()
					ContexMenu_ChatBoard_RaidApply_NoToushu:Disable()
				end
				ContexMenu_ChatBoard_NoToushu:Show();
				ContexMenu_ChatBoard_NoToushu:SetPopMenuPos(arg2,arg3);
			end
			
			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 点击组队平台里的人物名, 弹出的菜单
		--		
		if(arg0 == "teamboard_info") then
			ContexMenu_HideAll();
			this:Show();
			ContexMenu_TeamBoard:Show();
			ContexMenu_TeamBoard:SetPopMenuPos(arg1,arg2);
			g_TeamBoard_Guid = tonumber(arg3);
			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 点击征友投票人后 , 弹出的菜单
		--
		if(arg0 == "findfrind_vote") then
			ContexMenu_HideAll();
			this:Show();
			g_MenuType = arg1;
			g_Voteinfo_index = tonumber(arg4);   --现在是第几条
			ContexMenu_FindFriend_VoteInfo:Show();
			ContexMenu_FindFriend_VoteInfo:SetPopMenuPos(arg2,arg3);

			return;
		end;

		--------------------------------------------------------------------------------------------------------------------------
		--
		-- 点击好友列表理
		--
		if arg0 == "friendmenu" then
			-- if checkHaveMaskBuff ==  1 then
			-- 	return 
			-- end
			currentSelectChannal = arg2
			currentIndex = arg3
			ContexMenuFrame_Close()
			this:Show()
			--关心NPC
			objCared = tonumber(arg1)
			this:CareObject(objCared, 1, "ContexMenu")

			if tonumber(arg2) == 5 then
				ContexMenu_BlackListMenu:Show()
				ContexMenu_BlackListMenu:SetPopMenuPos(arg4, arg5)
			elseif tonumber(arg2) == 6 then
				ContexMenu_EnmeyListMenu:Show()
				ContexMenu_EnmeyListMenu:SetPopMenuPos(arg4, arg5)
			else
				if Player:IsInTeam() == 1 then
					ContexMenu_Friend_RaidInvite:Disable()
					ContexMenu_Friend_RaidApply:Disable()
				-- elseif Player:IsInRaid() == 1 then
				-- 	if Player:IsRaidLeader() == 1 or Player:IsRaidAssitant() == 1 then
				-- 		ContexMenu_Friend_RaidInvite:Enable()
				-- 	else
				-- 		ContexMenu_Friend_RaidInvite:Disable()
				-- 	end
				-- 	ContexMenu_Friend_RaidApply:Disable()					
				else
					ContexMenu_Friend_RaidInvite:Disable()
					ContexMenu_Friend_RaidApply:Disable()
				end
				for i = 0 , 3 do
					local strGroupName = DataPool:GetGroupingName(i)
					if strGroupName ~= "" then
						g_MoveToMenuItem[i + 1]:SetText("移动到"..strGroupName)
					else
						g_MoveToMenuItem[i + 1]:SetText("移动到"..g_GroupingName[i + 1])
					end
				end
				ContexMenu_FriendMenu:Show()
				ContexMenu_FriendMenu:SetPopMenuPos(arg4, arg5)
			end
			return
		end

--------------------------------------------------------------------------------------------------------------------------
		--
		-- 点击好友列表理
		--
		if( arg0 == "groupingmenu" ) then
			AxTrace( 0,0, "show groping menu" );
			currentSelectChannal = arg2;
			currentIndex = arg3;
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu")
			
			for i = 0 , 3 do
				local strGroupName = DataPool:GetGroupingName(i)
				if strGroupName ~= "" then
					g_MoveToMenuItem[i + 1]:SetText("移动到"..strGroupName)
				else
					g_MoveToMenuItem[i + 1]:SetText("移动到"..g_GroupingName[i + 1])
				end
			end

			ContexMenu_GroupingMenu:Show()
			ContexMenu_GroupingMenu:SetPopMenuPos(arg4,arg5)
			return;
		end
--------------------------------------------------------------------------------------------------------------------------
		--
		-- 地图上自己宠物的菜单
		--
		if( arg0 == "my_pet" ) then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			ContexMenu_MyPetMenu:Show();
			ContexMenu_MyPetMenu:SetPopMenuPos(arg2,arg3);
			return;
		end
		
		if( arg0 == "my_pet_from_petframe" ) then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			ContexMenu_MyPetMenuFromPetFrame:Show();
			ContexMenu_MyPetMenuFromPetFrame:SetPopMenuPos(arg2,arg3);
			return;
		end
--------------------------------------------------------------------------------------------------------------------------
		--
		-- 地图上其他宠物的菜单
		--
		
		if( arg0 == "other_pet" ) then
			if checkHaveMaskBuff ==  1 then
				return 
			end
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			ContexMenu_OtherPetMenu:Show();
			ContexMenu_OtherPetMenu:SetPopMenuPos(arg2,arg3);
			return;
		end		
--------------------------------------------------------------------------------------------------------------------------
		--
		-- pk模式菜单
		--
		if( arg0 == "PKmode" ) then
			ContexMenuFrame_Close();
			this:Show();
			--关心NPC
			--objCared = tonumber(arg1);
			--this:CareObject(objCared, 1, "ContexMenu");
			if(tonumber(arg1)==0)then
				AxTrace(0, 1, "arg1="..tonumber(arg1));
				Menu_PVPMode_Before21:Show();
				Menu_PVPMode_Before21:SetPopMenuPos(arg2,arg3);
			else
				Menu_PVPMode:Show();
				Menu_PVPMode:SetPopMenuPos(arg2,arg3);
			end
			
			return;
		end
--------------------------------------------------------------------------------------------------------------------------
		--
		-- 帮会成员
		--
		if( arg0 == "GUILDLIST" ) then
			currentGuildListIndex = arg2;
			if(tonumber(arg5)==0)  then
				return;
			elseif(tonumber(arg5)==1) then
				ContexMenuFrame_Close();
				this:Show();
				ContexMenu_GuildList:Show();
				ContexMenu_GuildList:SetPopMenuPos(arg3,arg4);
			elseif(tonumber(arg5)==2) then
				return;		
			end
			
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			return;
		end
		
		--同盟成员
		if arg0 == "GuildLeagueMember" then
				g_LeagueMemberID = tonumber(arg1);
				ContexMenuFrame_Close();
				this:Show();
				ContexMenu_GuildLeagueMember:Show();
				ContexMenu_GuildLeagueMember:SetPopMenuPos(arg2,arg3);			
		end
--------------------------------------------------------------------------------------------------------------------------
		--弹出右键菜单For"官员列表"
		--add by xindefeng
		if( arg0 == "OfficialPopMenu" ) then
			currentGuildListIndex = arg2
			local type = tonumber(arg5)--选择类型
			if(type == 0)  then	--自己
				return;
			elseif(type == 1) then	--在线
				ContexMenuFrame_Close();
				this:Show();
				ContexMenu_OfficialPopMenu:Show();
				ContexMenu_OfficialPopMenu:SetPopMenuPos(arg3,arg4);
			elseif(type == 2) then	--不在线
				return
			end
			
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu")

			return
		end
		if( arg0 == "TrustFriend" ) then
			
			ContexMenuFrame_Close();
			this:Show();
			ContexMenu_TrustFriendMenu:Show();
			ContexMenu_TrustFriendMenu:SetPopMenuPos(arg1,arg2);
			
			g_Menu_ObjName	= arg3;
			g_Menu_ObjId	= arg4;
						
			return
		end
		-- 3v3排行榜右键查看
		--
		if( arg0 == "RANKLIST" ) then
			currentRankListIndex = arg2;
			if(tonumber(arg5)==0)  then
				return;
			elseif(tonumber(arg5)==1) then
				ContexMenuFrame_Close();
				this:Show();
				ContexMenu_HuaShanLunJian_TopList:Show();
				ContexMenu_HuaShanLunJian_TopList:SetPopMenuPos(arg3,arg4);
			end

			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			return;
		end
			
		--比武大会2018排行榜右键查看
		
		------------------------------------------------------------------------------------
		
		--团队
		if(arg0 == "Raider_NotTeamerNotRaider") then
			ContexMenuFrame_Close();
			local horse =  GetRideStatic( 0 );

			if( tonumber( horse ) == 0 ) then
				Raider_NotTeamerNotRaider_InviteToRide:Disable();
			elseif( tonumber( horse ) == 1 ) then
				Raider_NotTeamerNotRaider_InviteToRide:Enable();
				Raider_NotTeamerNotRaider_InviteToRide:SetText("邀请同骑");
			elseif( tonumber( horse ) == 2 ) then
				Raider_NotTeamerNotRaider_InviteToRide:Enable();
				Raider_NotTeamerNotRaider_InviteToRide:SetText("取消同骑");
			end
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			Raider_NotTeamerNotRaider:Show()
			Raider_NotTeamerNotRaider:SetPopMenuPos(arg2, arg3)

			nLevel = Target:GetLevel()
			
			return
		end

		if(arg0 == "NotTeamerNotRaider_Raider") then
			ContexMenuFrame_Close()

			if Player:GetData("GUILD") == -1 then
				NotTeamerNotRaider_Raider_InviteToGuild:Disable()
			end

			local horse =  GetRideStatic( 0 );
			if( tonumber( horse ) == 0 ) then
				NotTeamerNotRaider_Raider_InviteToRide:Disable();
			elseif( tonumber( horse ) == 1 ) then
				NotTeamerNotRaider_Raider_InviteToRide:Enable();
				NotTeamerNotRaider_Raider_InviteToRide:SetText("邀请同骑");
			elseif( tonumber( horse ) == 2 ) then
				NotTeamerNotRaider_Raider_InviteToRide:Enable();
				NotTeamerNotRaider_Raider_InviteToRide:SetText("取消同骑");
			end
			this:Show();
			--关心NPC
			objCared = tonumber(arg1);
			this:CareObject(objCared, 1, "ContexMenu");

			NotTeamerNotRaider_Raider:Show()
			NotTeamerNotRaider_Raider:SetPopMenuPos(arg2, arg3)

			nLevel = Target:GetLevel()
			
			return
		end

		if(arg0 == "RaidFrame_Menu") then
			ContexMenuFrame_Close()

			local menuType = tonumber(arg1)
			g_CurSelRaidMember = tonumber(arg2)
			if menuType == 1 then
				Union1_Menu:Show()
				Union1_Menu:SetPopMenuPos(arg3, arg4)
			elseif menuType == 2 then
				Union2_Menu:Show()
				Union2_Menu:SetPopMenuPos(arg3, arg4)
			elseif menuType == 3 then
				Union3_Menu:Show()
				Union3_Menu:SetPopMenuPos(arg3, arg4)
			elseif menuType == 4 then
				Union4_Menu:Show()
				Union4_Menu:SetPopMenuPos(arg3, arg4)
			elseif menuType == 5 then
				Union5_Menu:Show()
				Union5_Menu:SetPopMenuPos(arg3, arg4)
			elseif menuType == 6 then
				Union6_Menu:Show()
				Union6_Menu:SetPopMenuPos(arg3, arg4)
			end

			this:Show()
			return
		end
		if(arg0 == "squadmemwindow") then
			ContexMenuFrame_Close()

			g_CurSelRaidMember = tonumber(arg1)
			local squad,mem = Raid:GetMemberIndexByGUID(g_CurSelRaidMember)
			Raid:SelectAsTargetByIdx(squad, mem)
			UISquadMemWindow_Menu:SetPopMenuPos(arg2, arg3)
			UISquadMemWindow_Menu:Show()
			this:Show()
			return
		end

		if(arg0 == "raidsquadwindow") then
			ContexMenuFrame_Close()
			g_RaidSquadIndex = tonumber(arg1)
			UIRaidSquadWindow_Menu:SetPopMenuPos(arg2, arg3)
			UIRaidSquadWindow_Menu:Show()
			this:Show()
			return
		end

		--Add By YPL, 2011-12-05
		if(arg0 == "groupwindow_show") then
			--读取参数
			g_RaidSquadIndex = tonumber(arg1)
			--关闭旧窗口
			if (g_RaidSquadIndex == 0) or (g_RaidSquadIndex == 1) or (g_RaidSquadIndex == 2) or (g_RaidSquadIndex == 3) or (g_RaidSquadIndex == 4) then
			else
				return
			end
			Raid:CloseRaidSquadWindowByIdx(g_RaidSquadIndex)
			local state = GetShowState(g_RaidSquadIndex)
			--Add By YPL, 2011-12-14
			local pos_x = tonumber(arg2)
			local pos_y = tonumber(arg3)
			--End
			--Modify By YPL, 2011-12-14
			--local ret = Raid:OpenRaidSquadWindowByIdx(g_RaidSquadIndex, state)
			local ret = 0
			if state == 0 then
				ret = Raid:OpenRaidSquadWindowByIdx(g_RaidSquadIndex, 1, pos_x, pos_y)
			else
				ret = Raid:OpenRaidSquadWindowByIdx(g_RaidSquadIndex, 0, pos_x, pos_y)
			end
			--End
			if ret ~= 1 then
				return
			end
			if state == 0 then
				SetShowState(g_RaidSquadIndex, 1)
			elseif state == 1 then
				SetShowState(g_RaidSquadIndex, 0)
			else
				return
			end
		end
		--End

		if (arg0 == "PartyFrame_RaidMenu") then
			ContexMenuFrame_Close()

			local menuType = tonumber(arg1)
			g_CurSelRaidMember = tonumber(arg2)
			if menuType == 1 then
				ContexMenu_RaidMember2:Show()
				ContexMenu_RaidMember2:SetPopMenuPos(arg3, arg4)
				this:Show()
			elseif menuType == 2 then
				ContexMenu_RaidMember1:Show()
				ContexMenu_RaidMember1:SetPopMenuPos(arg3, arg4)
				this:Show()
			elseif menuType == 3 then
				ContexMenu_RaidMember3:Show()
				ContexMenu_RaidMember3:SetPopMenuPos(arg3, arg4)
				this:Show()
			elseif menuType == 4 then
				ContexMenu_RaidMember4:Show()
				ContexMenu_RaidMember4:SetPopMenuPos(arg3, arg4)
				this:Show()
			elseif menuType == 5 then
				ContexMenu_RaidMember3:Show()
				ContexMenu_RaidMember3:SetPopMenuPos(arg3, arg4)
				this:Show()
			end

			return
		end
		

		------------------------------------------------------------------------------------
		
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1=="destroy") then
			ContexMenuFrame_Close();

			--取消关心
			this:CareObject(objCared, 0, "ContexMenu");
		end
	elseif(event == "HIDE_CONTEXMENU_SPEAKER")then
		if(this:IsVisible() and g_showType == "chat_private" and g_MenuType == "speaker") then
			ContexMenuFrame_Close();
		end
	end
end
function ContexMenuFrame_Close()
	ContexMenu_HideAll();
	this:Hide();
	this:CareObject(objCared, 0, "ContexMenu");
end

function ContexMenuFrame_Clicked()
	ContexMenuFrame_Close();
	
end

function ContexMenu_HideAll()

	Menu_PVPMode:ClosePopMenu();
	Menu_PVPMode_Before21:ClosePopMenu();

	ContexMenu_Tserver:ClosePopMenu();
	-- 隐藏其他玩家
	ContexMenu_OtherPlayer:ClosePopMenu();

	-- 隐藏npc
	ContexMenu_NPC:ClosePopMenu();

	-- 隐藏队长菜单
	ContexMenu_TeamLeader:ClosePopMenu();

	-- 隐藏队友
	ContexMenu_TeamMember:ClosePopMenu();

	-- 隐藏自建队伍菜单
	ContexMenu_Self:ClosePopMenu();
	
	-- 隐藏自己已经在队伍中, 打开摆摊菜单
	ContexMenu_Self_In_Team:ClosePopMenu();
	
	-- 隐藏其他, 已经组队玩家菜单.
	ContexMenu_Model_Open_Other:ClosePopMenu();
	
	-- 隐藏非组队玩家菜单
	ContexMenu_Model_Open_Other_Not_teammer:ClosePopMenu();
	
	-- 隐藏非组队玩家申请菜单
	ContexMenu_Model_Open_Other_teammer_me_not_teammer:ClosePopMenu();
	
	-- 隐藏聊天窗口菜单
	ContexMenu_ChatBoard:ClosePopMenu();
	
	ContexMenu_FriendMenu:ClosePopMenu();
	ContexMenu_EnmeyListMenu:ClosePopMenu();
	
	-- 隐藏组队界面上的队友珍兽按钮右键菜单
	ContexMenu_MemberPetMenu:ClosePopMenu();
	
	-- 隐藏自己宠物窗口菜单
	ContexMenu_MyPetMenu:ClosePopMenu();
	
	-- 隐藏其他宠物窗口菜单
	ContexMenu_OtherPetMenu:ClosePopMenu();
	
	-- 隐藏组队跟随菜单。
	ContexMenu_TeamFollowLeader:ClosePopMenu();
	
	-- 隐藏队友.
	ContexMenu_TeamFollowMember:ClosePopMenu();
	
	ContexMenu_BlackListMenu:ClosePopMenu();

	ContexMenu_GroupingMenu:ClosePopMenu();
	--帮派
	ContexMenu_GuildList:ClosePopMenu();
	--同盟成员
	ContexMenu_GuildLeagueMember:ClosePopMenu();
		
	--官员列表右键菜单--add by xindefeng
	ContexMenu_OfficialPopMenu:ClosePopMenu();
		
	--new
	ContexMenu_MyPetMenuFromPetFrame:ClosePopMenu();

	--
	ContexMenu_ChatBoard_NoToushu:ClosePopMenu();
	--FindFriend_Voteinfo
	ContexMenu_FindFriend_VoteInfo:ClosePopMenu();
	
	ContexMenu_TrustFriendMenu : ClosePopMenu();
	ContexMenu_TeamBoard: ClosePopMenu();
	--ContexMenu_BWRankingList:ClosePopMenu()
	ContexMenu_TserverAlike:ClosePopMenu();
	ContexMenu_TserverBelike:ClosePopMenu();
	ContexMenu_HuaShanLunJian_TopList:ClosePopMenu()
	
	NotTeamerNotRaider_Raider:ClosePopMenu()
	Raider_NotTeamerNotRaider:ClosePopMenu()
	Union1_Menu:ClosePopMenu()
	Union2_Menu:ClosePopMenu()
	Union3_Menu:ClosePopMenu()
	Union4_Menu:ClosePopMenu()
	Union5_Menu:ClosePopMenu()
	Union6_Menu:ClosePopMenu()
	UIRaidSquadWindow_Menu:ClosePopMenu()
	UISquadMemWindow_Menu:ClosePopMenu()
	ContexMenu_RaidMember1:ClosePopMenu()
	ContexMenu_RaidMember2:ClosePopMenu()
	ContexMenu_RaidMember3:ClosePopMenu()
	ContexMenu_RaidMember4:ClosePopMenu()
	ContexMenu_SecretChatBoard:ClosePopMenu()
	
end

function ContexMenu_OtherPlayer_Clicked(itemname)

	AxTrace(0,0,"itemname = "..itemname)
	if(itemname == "zudui") then
		if(Target:IsPresent()) then
			Target:SendTeamRequest();
		end
	elseif(itemname == "tanwei") then
		StallBuy:OpenStall();
	elseif(itemname == "siliao") then
		--
	elseif( itemname == "Ride" ) then
		InviteRide();
	end
	ContexMenuFrame_Close();
end

--交易
function ContexMenu_Exchange_Clicked()
	Exchange:SendExchangeApply();
	ContexMenuFrame_Close();
end

--跟随
function ContexMenu_OtherPlayer_Follow_Clicked()
	Target:Follow();
	ContexMenuFrame_Close();
end

-- 邀请入帮
function ContexMenu_InviteToGuild_Clicked()
	if Player : GetData( "GUILD" ) == -1 then
		return
	end

	Guild : InviteToGuild()
	ContexMenuFrame_Close()
end

--送玫瑰花
function ContexMenu_GiveRose_Clicked()
	 ContexMenuFrame_Clicked();
	 
	local nGUID = GetTargetPlayerGUID();
	
	AxTrace(0,0,"nGUID:"..nGUID);
	
	if( tonumber( nGUID ) == -1 ) then	
	--	return;
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GiveRose" )
		Set_XSCRIPT_ScriptID( 006673 )
		Set_XSCRIPT_Parameter( 0, tonumber( nGUID ) )
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()


	ContexMenuFrame_Close()
end

--*******************************************************************************************************************************
--
-- 申请加入队伍
--
--*******************************************************************************************************************************
function ContexMenu_OtherPlayer_Apply_Clicked()

		if(Target:IsPresent()) then
			Target:SendTeamApply();
		end
		
		ContexMenuFrame_Close();

end



--*******************************************************************************************************************************
--
-- 离开队伍
--
--*******************************************************************************************************************************
function ContexMenu_LeaveTeam_Clicked()
	if Player:IsInTeam() == 1 then
		Player:LeaveTeam()
	elseif Player:IsInRaid() == 1 then
		Player:LeaveRiad()
	end
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- 解散队伍
--
--*******************************************************************************************************************************
function ContexMenu_DismissTeam_Clicked()

	Player:OpenDismissTeamMsgbox();			-- 打开解散队伍的二次确认窗口			add by WTT	20090218	
	ContexMenuFrame_Close();
end


--*******************************************************************************************************************************
--
-- 踢出当前选中的队员.
--
--*******************************************************************************************************************************
function ContexMenu_KickTeamMember_Clicked()
	AxTrace( 0,0, "current select = "..tostring( currentSelectMember ) );
	Player:KickTeamMember(currentSelectMember);
	ContexMenuFrame_Close();
end


--*******************************************************************************************************************************
--
-- 自己创建队伍
--
--*******************************************************************************************************************************
function ContexMenu_SelfCreateTeam_Clicked()
	Player:CreateTeamSelf();
	ContexMenuFrame_Close();
	
end

--*******************************************************************************************************************************
--
-- 提升为队长
--
--*******************************************************************************************************************************
function ContexMenu_AppointLeader_Clicked()
	AxTrace( 0,0, "current select = "..tostring( currentSelectMember ) );
	Player:AppointLeader(currentSelectMember);
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- 取消跟随
--
--*******************************************************************************************************************************
function ContexMenu_StopFollow_Clicked()
	Player:StopFollow();
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- 摆摊
--
--*******************************************************************************************************************************
function ContexMenu_StallSale_Clicked()
	PlayerPackage:OpenStallSaleFrame();
	ContexMenuFrame_Close();
end

--*******************************************************************************************************************************
--
-- 私聊
--
--*******************************************************************************************************************************

function ContexMenu_ChatBoard_Private_Talk_Clicked()
	 ContexMenuFrame_Clicked();
	 Talk:ContexMenuTalk();
	 ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_CheckInfo_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_Invite_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end
	ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_Apply_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	if(nil ~= szName) then
		Target:SendTeamApply(szName);
	end
	ContexMenuFrame_Close();
end
	
function ContexMenu_ChatBoard_AddFriend_Clicked()
	 ContexMenuFrame_Clicked();
	 DataPool:AddFriendAndGrouping(Talk:HandleMenuAction("Name"))
	 ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_PingBi_Clicked()
	ContexMenuFrame_Clicked();
	Talk:HandleMenuAction("PingBi");
	ContexMenuFrame_Close();
end

function ContexMenu_ChatBoard_Toushu_Clicked()
	ContexMenuFrame_Clicked();
	Talk:HandleMenuAction("Toushu");
	ContexMenuFrame_Close();
end

function send_detail()
	Target:Close_Before_TargetEquip_UI();
	Target:SendAskDetail();
	ContexMenuFrame_Close();
	
	--缓存主目标信息
	CacheMainTarget();
end
--*******************************************************************************************************************************
--
--好友
--*******************************************************************************************************************************
function ContexMenu_OnIMChat()
	DataPool:OpenIMChat(tonumber(currentSelectChannal), tonumber(currentIndex))	
	ContexMenuFrame_Close()	
end

function ContexMenu_OnSendMail()
	local name = DataPool:GetFriend(tonumber(currentSelectChannal), tonumber(currentIndex), "NAME")
	DataPool:OpenMail(name)	
	ContexMenuFrame_Close()	
end

function ContexMenu_OnFriendHistroy()
	DataPool:OpenHistroy(tonumber(currentSelectChannal), tonumber(currentIndex))
	ContexMenuFrame_Close()
end

function ContexMenu_OnFriendInfo()
	DataPool:ShowFriendInfo(tonumber(currentSelectChannal), tonumber(currentIndex))
	ContexMenuFrame_Close()
end
	
function ContexMenu_OnDelFriend()
	DataPool:AskDelFriend(tonumber(currentSelectChannal), tonumber(currentIndex))
	Friend:Close()
	ContexMenuFrame_Close()
end

function ContexMenu_InviteAddFriendByFriendList()
	DataPool:InviteAddFriendByFriendList(tonumber(currentSelectChannal), tonumber(currentIndex))
	ContexMenuFrame_Close()
end
	
function ContexFriend_OnPrivate()
	local name = DataPool:GetFriend(tonumber(currentSelectChannal), tonumber(currentIndex), "NAME")
	Talk:ContexMenuTalk(name)
	ContexMenuFrame_Close()
end

function ContexMenu_OnInviteTeam()
	Friend:InviteTeam(DataPool:GetFriend(tonumber(currentSelectChannal), tonumber(currentIndex), "NAME"))
end

function ContexMenu_OnAskTeam()
	Friend:AskTeam(DataPool:GetFriend(tonumber(currentSelectChannal), tonumber(currentIndex), "NAME"))
end

----add:lby20071207迷影跟踪关系信息中查找28818
function ContexMenu_OnFriendInfoEx()
	DataPool:LookupOtherParticularInfo(tonumber(currentSelectChannal), tonumber(currentIndex))
	ContexMenuFrame_Close()
end

function ContexMenu_OpenBeiZhu()
	PushEvent("OPEN_REMARK", tonumber(currentSelectChannal), tonumber(currentIndex))
	ContexMenuFrame_Close()
end

function ContexMenu_AddFriend()
	DataPool:AddFriendAndGrouping()
	ContexMenuFrame_Close()
end 

function ContexMenu_InviteAddFriend()
	DataPool:InviteAddFriend();
	ContexMenuFrame_Close();
end 

function ContexMenu_InviteAddFriendByteam()
	local guid = DataPool:GetTeamMemGUIDByUIIndex( tonumber( currentSelectMember ) );
	if( tonumber( guid ) == -1 ) then	
		return;
	end
	DataPool:InviteAddFriendByteam(guid);
	ContexMenuFrame_Close();
end

function ContexMenu_AddFriendTeamate()	
	local strName = DataPool:GetTeamMemNameByUIIndex(tonumber( currentSelectMember))
	if strName == nil or strName == "" then	
		return
	end
	DataPool:AddFriendAndGrouping(strName)
	ContexMenuFrame_Close()
end

function ContexMenu_ThrowBlackList()
	DataPool:ThrowToBlackList( tonumber( currentSelectChannal ), tonumber( currentIndex ) );
	Friend:Close();
	ContexMenuFrame_Close();
end

function ContexMenu_ThrowList( nGroup )

	if tonumber(currentSelectChannal) == 8 then
		local name = DataPool:GetFriend(tonumber(currentSelectChannal), tonumber(currentIndex), "NAME")
		DataPool:AddFriend(nGroup, name, 1)		
		if tonumber(nGroup) == 5 then
		    PushDebugMessage("暂时无法加入黑名单")
		end
	else
		DataPool:ThrowToList( tonumber( currentSelectChannal ), tonumber( currentIndex ), tonumber( nGroup ) );
	end
	Friend:Close();
	ContexMenuFrame_Close();
end

function ContexMenu_OnPrivate()
	--local name =  DataPool:GetFriend( tonumber( currentSelectChannal ), tonumber( currentIndex ), "NAME" );
	local name = Target:GetName();
	Talk:ContexMenuTalk( name );
	ContexMenuFrame_Close();
end

------好友界面与聊天板中选择该玩家-----
function ContexMenu_OnSelectThePlayer()
	local szName = Talk:HandleMenuAction("Name")
	if nil == szName then
		szName = DataPool:GetFriend(tonumber(currentSelectChannal), tonumber(currentIndex), "NAME")
  end
  
	if nil ~= szName then
		Target:SelectThePlayer(szName)
	end
  
	ContexMenuFrame_Close()
end

---帮派管理中选择该玩家----
function ContexMenu_GuildList_OnSelectThePlayer()
  local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
 
	if(nil ~= szName) then
		Target:SelectThePlayer(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_GuildList_Private_Talk_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	Talk:ContexMenuTalk( szName );
	ContexMenuFrame_Close();	
end;
function ContexMenu_GuildList_CheckInfo_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
	ContexMenuFrame_Close();	
end;
function ContexMenu_GuildList_AddFriend_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name")
	DataPool:AddFriendAndGrouping(szName)
	ContexMenuFrame_Close()
end
function ContexMenu_GuildList_Invite_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_GuildList_Apply_Clicked()

	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	if(nil ~= szName) then
		Target:SendTeamApply(szName);
	end
	ContexMenuFrame_Close();

end
function ContexMenu_GuildList_OnSendMail()
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name");
	DataPool:OpenMail( szName );
	
	ContexMenuFrame_Close();
end

--同盟成员帮会详细信息处理
function ContexMenu_GuildLeagueMember_DetailInfo_Clicked()
	Guild:AskAnyGuildDetailInfo(g_LeagueMemberID) --查询指定ID帮会详细信息
	Guild:CloseKickGuildBox()
	
	ContexMenuFrame_Close();
end



function ContexMenu_PetHandle( order )
	if( order == nil ) then
		return;
	end
	
	local action = {};
	action[1] = "feed";
	action[2] = "dome";
	action[3] = "relax";
	action[4] = "detail";
	
	Pet:HandlePetMenuItem(action[order]);
	
	ContexMenuFrame_Close();
end

function ContexMenu_PetHandleSelf(order)
	if( order == nil ) then
		return;
	end
	
	local action = {};
	action[1] = "feed";
	action[2] = "dome";
	action[3] = "relax";
	action[4] = "detail";
	
	Pet:HandlePetMenuItemSelf(action[order]);
	
	ContexMenuFrame_Close();
end

function ContexMenu_OtherPlayer_Challenge()
	DataPool:Challenge();
end

function ContexMenu_OtherPlayer_FunChallenge()
	DataPool:FunChallenge();
end

function ContexMenu_PVP_Peace_Clicked()
	Player:ChangePVPMode( 0 );
	ContexMenuFrame_Close();
end

function ContexMenu_PVP_Moral_Clicked()
	Player:ChangePVPMode( 2 );
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_FreeforAll_Clicked()
	ShowAcceptChangePVPMode( 1 );
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_FreeforTeam_Clicked()
	ShowAcceptChangePVPMode( 3 );
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_FreeforGuild_Clicked()
	ShowAcceptChangePVPMode( 4 );
	ContexMenuFrame_Close();
end
function ContexMenu_AboutPK_Clicked()
	ShowAcceptChangePVPMode( 5 );
	ContexMenuFrame_Close();
end

function ContexMenu_PVP_Duel_Clicked()
	Player:PVP_Duel();
	ContexMenuFrame_Close();
end
function ContexMenu_PVP_Challenge_Clicked()
	if CheckPhoneMibaoAndMinorPassword() == 0 then
		ContexMenuFrame_Close();
		return
	end
	Player:PVP_Challenge( 1 );     --1为弹出宣战确认对话框
	ContexMenuFrame_Close();
end


function ContexMenu_ChangePVPMode_Clicked()	
    ShowChangePVPMode();
    --ContexMenuFrame_Close();
end


function ContexMenu_OnPrivate_FromInc()
	local name = DataPool:GetTeamMemberInfo(tonumber( currentSelectMember ));
	Talk:ContexMenuTalk( name );
	ContexMenuFrame_Close();
end

--add:lby20071207迷影跟踪聊天信息中查找28818
function ContexMenu_ChatBoard_LookPos_Clicked()
	ContexMenuFrame_Clicked();
	local szName = Talk:HandleMenuAction("Name");
	
	if(nil ~= szName) then
	
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			Friend:SetCurrentSelect( nIndex );
			DataPool:LookupOtherParticularInfo( szName );
		else
			DataPool:LookupOtherParticularInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end



--"官员列表":发送邮件--add by xindefeng
function ContexMenu_OfficialPopMenu_SendMail_Clicked()
	ContexMenuFrame_Close()	--关掉菜单

	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--获取对方名字
	if(nil ~= szName) then
		DataPool:OpenMail(szName)
	end
end

--"官员列表":私聊--add by xindefeng
function ContexMenu_OfficialPopMenu_PrivateTalk_Clicked()
	ContexMenuFrame_Close()	--关掉菜单
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--获取对方名字
	Talk:ContexMenuTalk(szName)
end

--"官员列表":查看详细--add by xindefeng
function ContexMenu_OfficialPopMenu_CheckInfo_Clicked()
	ContexMenuFrame_Close()	--关掉菜单
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--获取对方名字
	if(nil ~= szName) then
		if(Friend:IsPlayerIsFriend(szName) == 1) then	
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end	
end

--"官员列表":加为好友--add by xindefeng
function ContexMenu_OfficialPopMenu_AddFriend_Clicked()
	ContexMenuFrame_Close()	--关掉菜单
		
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--获取对方名字
	DataPool:AddFriendAndGrouping(szName)
end

--"官员列表":邀请入队--add by xindefeng
function ContexMenu_OfficialPopMenu_Invite_Clicked()
	ContexMenuFrame_Close()	--关掉菜单
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--获取对方名字
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end	
end

--"官员列表":申请入队--add by xindefeng
function ContexMenu_OfficialPopMenu_Apply_Clicked()
	ContexMenuFrame_Close()	--关掉菜单
	
	local szName = Guild:GetAnyGuildMembersInfo(tonumber(currentGuildListIndex), "Name")	--获取对方名字
	if(nil ~= szName) then
		Target:SendTeamApply(szName)
	end
end

function ContexMenu_FindFriend_VoteInfo_Talk_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	Talk:ContexMenuTalk( szName );
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_CheckInfo_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_AddFriend_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	DataPool:AddFriendAndGrouping(szName)
	ContexMenuFrame_Close()
end

function ContexMenu_FindFriend_VoteInfo_Invite_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_Apply_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	if(nil ~= szName) then
		Target:SendTeamApply(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_CFindFriend_VoteInfo_PingBi_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);
	FindFriendDataPool:ContexMenuPingbiOrTousu("PINGBI", szName);
	ContexMenuFrame_Close();
end

function ContexMenu_FindFriend_VoteInfo_Toushu_Clicked()
end

function ContexMenu_FindFriend_VoteInfo_LookPos_Clicked()
	ContexMenuFrame_Clicked();
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(g_Voteinfo_index);

	if(nil ~= szName) then

		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			Friend:SetCurrentSelect( nIndex );
			DataPool:LookupOtherParticularInfo( szName );
		else
			DataPool:LookupOtherParticularInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end


-- xiehong 2009-5-20 TrustFriend Begin---------------------------------

function ContexMenu_InviteToMyTeam()

	Friend : InviteTeam( g_Menu_ObjName );
	ContexMenuFrame_Close();
	
end

function ContextMenu_AddFriend()
	DataPool:AddFriendAndGrouping(g_Menu_ObjName)
	ContexMenuFrame_Close()	
end

function ContextMenu_WantToBeFriend()

	DataPool : InviteAddFriendByteam( g_Menu_ObjId );
	ContexMenuFrame_Close();
	
end

function ContexMenu_SetChatTarget()

	Talk:ContexMenuTalk( g_Menu_ObjName );
	ContexMenuFrame_Close();
	
end

function ContexMenu_SendMail()

	DataPool : OpenMail( g_Menu_ObjName );
	ContexMenuFrame_Close();
	
end

function ContexMenu_ShowInfo()

	if( Friend:IsPlayerIsFriend( g_Menu_ObjName ) == 1 ) then
		DataPool:ShowFriendInfo( g_Menu_ObjName );
	else
		DataPool:ShowChatInfo( g_Menu_ObjName );
	end
	
	ContexMenuFrame_Close();
	
end

-- xiehong 2009-5-20 TrustFriend End---------------------------------

function ContexMenu_TeamBoard_InviteAddFriend()
	if( g_TeamBoard_Guid == -1 ) then	
		return;
	end
	DataPool:InviteAddFriendByteam(g_TeamBoard_Guid);
	ContexMenuFrame_Close();
end

function ContexMenu_TeamBoard_SendMail()
	local name = Talk:HandleMenuAction("Name") ;
	DataPool:OpenMail( name );
	
	ContexMenuFrame_Close();
end

function ContexMenu_Disclosure_Clicked()
	ContexMenuFrame_Clicked();
	Target:ReportWaiguaForInfo();
	ContexMenuFrame_Close();
end
function ContexMenu_ChatBoard_Private_Talk_Clicked()
	ContexMenuFrame_Clicked();
	Talk:ContexMenuTalk();
	ContexMenuFrame_Close();
end


function ContexMenu_ChatBoard_PingBi_Clicked()
	ContexMenuFrame_Clicked();
	Talk:HandleMenuAction("PingBi");
	ContexMenuFrame_Close();
end

function ContexMenu_HuaShanLunJian_TopList_Benfu_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = XBW:GetMembersInfo(tonumber(currentRankListIndex));

	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			--Friend:SetCurrentSelect( nIndex );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
	ContexMenuFrame_Close();
end;

function ContexMenu_HuaShanLunJian_TopList_Talk_Clicked()
	ContexMenuFrame_Clicked();
	--local index = Guild:GetShowMembersIdx(tonumber(currentGuildListIndex));
	local szName = XBW:GetMembersInfo(tonumber(currentRankListIndex));

	if(nil ~= szName) then
		Talk:ContexMenuTalk( szName );
	end
	ContexMenuFrame_Close();
end;

function ContexMenu_HuaShanLunJian_TopList_Invite_Clicked()
	ContexMenuFrame_Clicked();
	local szName = XBW:GetMembersInfo(tonumber(currentRankListIndex));
	if(nil ~= szName) then
		Target:SendTeamRequest(szName);
	end
	ContexMenuFrame_Close();
end

function ContexMenu_HuaShanLunJian_TopList_Apply_Clicked()
	ContexMenuFrame_Clicked();
	local szName = XBW:GetMembersInfo(tonumber(currentRankListIndex));
	if(nil ~= szName) then
		Target:SendTeamApply(szName);
	end
	ContexMenuFrame_Close();
end


function ContexMenu_HuaShanLunJian_TopList_AddFriend_Clicked()
	 ContexMenuFrame_Clicked()
	 DataPool:AddFriendAndGrouping(XBW:GetMembersInfo(tonumber(currentRankListIndex)))
	 ContexMenuFrame_Close()
end


function ContexMenu_Tserver_PrivateChat_Clicked()
	local name = Target:GetName(); 
	local zwid = Target:GetData("ZONEWORLD"); 
	Talk:ContexMenuTalk( name, zwid);
	ContexMenuFrame_Close();
end


-------------------------------------------------------------------
--团队

function Union_Appoint_Clicked(appType)
	local squadIdx, memIdx = Raid:GetMemberIndexByGUID(g_CurSelRaidMember)
	if squadIdx ~= -1 and memIdx ~= -1 then
		Player:RaidAppointByIdx(appType, squadIdx, memIdx)
	end
	ContexMenuFrame_Close()
	g_CurSelRaidMember = ""
end

function Union_Leave_Clicked()
		Player:LeaveRiad()
		ContexMenuFrame_Close()
end

function Union_Kick_Clicked()
	local squadIdx, memIdx = Raid:GetMemberIndexByGUID(g_CurSelRaidMember)
	if squadIdx ~= -1 and memIdx ~= -1 then
		Player:KickRaidMemberByIdx(squadIdx, memIdx)
	end
	ContexMenuFrame_Close()
	g_CurSelRaidMember = ""
end

function ContexMenu_ApplyToRaid_Clicked()
	Target:SendRaidApplication()
	ContexMenuFrame_Close()
end

function ContexMenu_InviteToRaid_Clicked()
	Target:SendRaidInvitation()
	ContexMenuFrame_Close()
end

function ContexMenu_PVP_FreeforRaid_Clicked()
	ShowAcceptChangePVPMode(6)
	ContexMenuFrame_Close()
end

function UIRaidSquadWindow_CloseSquad_Clicked()
	SetShowState(g_RaidSquadIndex, -1)
	Raid:CloseRaidSquadWindowByIdx(g_RaidSquadIndex)
	ContexMenuFrame_Close()
end

function UIRaidSquadWindow_CloseAll_Clicked()
	Raid:CloseRaidSquadWindowByIdx(-1)
	ContexMenuFrame_Close()
end

function UISquadMemWindow_CloseMember_Clicked()
	Raid:CloseSquadMemWindowByGUID(g_CurSelRaidMember)
	ContexMenuFrame_Close()
	g_CurSelRaidMember = ""
end

function ContexMenu_OnPrivate_FromRaid()
	local name, zoneworldid = Raid:GetMemberNameByGUID(g_CurSelRaidMember)
	if( name == nil or name == "") then
		return
	end
	Talk:ContexMenuTalk(name, zoneworldid)
	ContexMenuFrame_Close()
	g_CurSelRaidMember = ""
end

function ContexMenu_AddFriend_FromRaid()
	local name, zoneworldid = Raid:GetMemberNameByGUID(g_CurSelRaidMember)
	if( name == nil or name == "") then
		return
	end
	DataPool:AddFriendAndGrouping(name, zoneworldid)
	ContexMenuFrame_Close()
	g_CurSelRaidMember = ""
end

function Union4_7_Clicked()
	Union_Kick_Clicked()
end

--function ContexMenu_AskAddFriend_FromRaid()
	--DataPool:InviteAddFriendByteam(g_CurSelRaidMember)
	--ContexMenuFrame_Close()
--end

function ContexMenu_ChatBoard_RiadInvite_Clicked()
	local szName = Talk:HandleMenuAction("Name")
	if(nil ~= szName) then
		Target:SendRaidInvitation(szName)
	end
	ContexMenuFrame_Close()
end

function ContexMenu_ChatBoard_RaidApply_Clicked()
	local szName = Talk:HandleMenuAction("Name")
	if(nil ~= szName) then
		Target:SendRaidApplication(szName)
	end
	ContexMenuFrame_Close()
end


function ContexMenu_Friend_RiadInvite_Clicked()
	local szName = DataPool:GetFriend(Friend:GetCurrentTeam(), Friend:GetCurrentSelect(), "NAME")
	-- local zoneWorldID = DataPool:GetFriend(Friend:GetCurrentTeam(), Friend:GetCurrentSelect(), "ZONEWORLDID")
	-- local selfZoneWorldID = DataPool:GetSelfZoneWorldID()
	-- if(nil ~= szName) then
	-- 	if tonumber(zoneWorldID) ~= -1 and  zoneWorldID ~= selfZoneWorldID then
	-- 		Target:SendRaidInvitation(szName .. "@" .. DataPool:GetServerName( zoneWorldID ))
	-- 	else
			Target:SendRaidInvitation(szName)
	-- 	end
	-- end
	ContexMenuFrame_Close()
end

function ContexMenu_Friend_RaidApply_Clicked()
	local szName = DataPool:GetFriend(Friend:GetCurrentTeam(), Friend:GetCurrentSelect(), "NAME")
	-- local zoneWorldID = DataPool:GetFriend(Friend:GetCurrentTeam(), Friend:GetCurrentSelect(), "ZONEWORLDID")
	-- local selfZoneWorldID = DataPool:GetSelfZoneWorldID()
	-- if(nil ~= szName) then
	-- 	if tonumber(zoneWorldID) ~= -1 and  zoneWorldID ~= selfZoneWorldID then
	-- 		Target:SendRaidApplication(szName .. "@" .. DataPool:GetServerName( zoneWorldID ))
	-- 	else
			Target:SendRaidApplication(szName)
	-- 	end
	-- end
	ContexMenuFrame_Close()
end

function ContexMenu_GuildList_RiadInvite_Clicked()
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name")
	if(nil ~= szName) then
		Target:SendRaidInvitation(szName)
	end
	ContexMenuFrame_Close()
end

function ContexMenu_GuildList_RaidApply_Clicked()
	local szName = Guild:GetMembersInfo(tonumber(currentGuildListIndex), "Name")
	if(nil ~= szName) then
		Target:SendRaidApplication(szName)
	end
	ContexMenuFrame_Close()
end

------------------------------------------------------------

function ContexMenu_IsCanUseRaid()
	local sceneLogicID = GetSceneID()
	local isFind = Raid:LuaFnIsDiffSceneRaid(sceneLogicID)
	if isFind ~= 1 then
		return 0
	end
	return 1
end
function ContexMenu_IsCanUseTeamDiffServer()
	local sceneLogicID = GetSceneID()
	local isFind = Raid:LuaFnIsDiffSceneTeam(sceneLogicID)
	if isFind ~= 1 then
		return 0
	end
	return 1
end

function ContexMenu_SecretChatBoard_Toushu_Clicked()
	ContexMenuFrame_Clicked();
	Talk:HandleMenuAction("ToushuSecret");
	ContexMenuFrame_Close();
end

