
local g_WorldReference_Frame_UnifiedXPosition;
local g_WorldReference_Frame_UnifiedYPosition;

function WorldReference_PreLoad()
    --AxTrace( 0, 0, "WorldReference_PreLoad" )
    this:RegisterEvent("OPEN_WORLDREFERENCE")
    this:RegisterEvent("OPEN_WORLDREFERENCE_TIME")
    this:RegisterEvent("OPEN_PKDESC")
    this:RegisterEvent("WR_SHOWBOSSINFO")
    this:RegisterEvent("OPEN_MONSTER_TABLE")
    
    this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function WorldReference_OnLoad()

g_WorldReference_Frame_UnifiedXPosition	= WorldReference_Frame:GetProperty("UnifiedXPosition");
g_WorldReference_Frame_UnifiedYPosition	= WorldReference_Frame:GetProperty("UnifiedYPosition");

end

function WorldReference_OpenPKDesc()
    WorldReferenceGreeting_Desc:ClearAllElement()
    --WorldReference_PageHeader:SetText("#{INTERFACE_XML_39}")
    WorldReference_PageHeader:SetText("V« PK")
    WorldReferenceGreeting_Desc:AddTextElement( "#{PK_HELP_001}")
    this:Show();
end

--=========================================================
-- ÊÂ¼þ´¦Àí
--=========================================================
function WorldReference_OnEvent(event)
    WorldReference_PageHeader:SetText("#{INTERFACE_XML_39}")

	if(event == "OPEN_WORLDREFERENCE") then
      WorldReference_DispatchMainPage()
	end

	if(event == "OPEN_WORLDREFERENCE_TIME") then
	  local Date = tostring( arg0 )
	  AxTrace( 0, 0, Date )
	  WorldReference_DispatchServerTime( Date )
	end

	if(event == "OPEN_PKDESC") then
        WorldReference_OpenPKDesc()
	end

	if(event == "WR_SHOWBOSSINFO") then
        WorldReference_OpenBossInfo( arg0 )
	end

	if(event == "OPEN_MONSTER_TABLE") then
     WorldReferenceGreeting_Desc:ClearAllElement()
     WorldReference_DispatchMonsterTable()
     this:Show();
	end
	
	if( event == "ADJEST_UI_POS" ) then
		WorldReference_ResetPos()
	end

	if( event == "VIEW_RESOLUTION_CHANGED" ) then
		WorldReference_ResetPos()
	end

end

--=========================================================
-- ¹Ø± ÏàÓ¦
--=========================================================
function WorldReference_Close()
end

--=========================================================
-- ÏÔÊ¾ÈÎÎñÁÐ±í
--=========================================================
function WorldReference_EventListUpdate()
end

--=========================================================
-- ÏÔÊ¾ÈÎÎñÐÅÏ¢
--=========================================================
function WorldReference_WorldReferenceInfoUpdate()
end

--=========================================================
--ContinueÈÎÎñµÄ¶Ô»°¿ò
--=========================================================
function WorldReference_MissionContinueUpdate(bDone)
end

--=========================================================
--Ê È¡½±ÀøÎïÆ·µÄ¶Ô»°¿ò
--=========================================================
function WorldReference_MissionRewardUpdate()
end

--=========================================================
--ÏÔÊ¾Ê×Ò³
--=========================================================
function WorldReference_DispatchMainPage()

	WorldReferenceGreeting_Desc:ClearAllElement();
	WRCollectVisiableContex( 0 )

	local NumVisiable = tonumber( WRGetVisiableContexCount() )

	WorldReferenceGreeting_Desc:AddTextElement( "Nh¾ rõ M²i Ðáo mµt cái Tân Ðích C¤p B§c Tñu Tá Khai Ngã ðªn xem, ta s¨ nói cho Nhî r¤t nhi«u giang h° giæa chuy®n tình.")

	for i=0, NumVisiable-1 do
	    local VisiableID = WRGetVisiableContexID( i )
	    if( -1 ~= VisiableID ) then
	        --local strContex = WRGetVisiableContex( 0, VisiableID )
	        local strContex = WRGetTitle( 0, VisiableID )
	        local strTemp = strContex.."&0,"..(VisiableID+1).."$0"
	        WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
	    end

	end

--	WorldReference_Frame_Debug:SetText("½­ºþÖ¸ÄÏ")

	this:Show();
end

function WorldReference_DispatchTable( TableID )
    WorldReferenceGreeting_Desc:ClearAllElement();

	WRCollectVisiableContex( TableID )   --?????
	local NumVisiable = tonumber( WRGetVisiableContexCount() )
	if(NumVisiable>0 and TableID == 1)then
		local strTemp = "Xem xét Khä tiªp nh§n chÑc vø Vø".."&"..TableID..","..(-1).."$0"
	        WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
	end
	for i=0, NumVisiable-1 do
	    local VisiableID = WRGetVisiableContexID( i )
	    if( -1 ~= VisiableID ) then
	        local strTitle = WRGetTitle( TableID, VisiableID )
	        AxTrace( 0, 0, "strTitle="..strTitle )

	        local strTemp = strTitle.."&"..TableID..","..(VisiableID).."$0"
	        WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
	    end

	end

    local strBack = "Quay ð¥u Di®p".."&0,0".."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack );
end

--=========================================================
--ÏÔÊ¾ÈÎÎñÒ³
--=========================================================
function WorldReference_DispatchMissionTable()
    WorldReference_DispatchTable( 1 )
end

--=========================================================
--ÏÔÊ¾¹ÖÎïÒ³
--=========================================================
function WorldReference_DispatchMonsterTable()
    WorldReference_DispatchTable( 2 )
end

--=========================================================
--ÏÔÊ¾"ÆäËû"Ò³
--=========================================================
function WorldReference_DispatchOtherTable()
    WorldReference_DispatchTable( 5 )
end

--=========================================================
--ÏÔÊ¾BOSSÊ×Ò³
--=========================================================
function WorldReference_DispatchBossTable()

	WorldReferenceGreeting_Desc:ClearAllElement();

	local menuLevel = -1
	local parentId = -1

	WRCollectVisiableContex( 3 )
	local NumVisiable = tonumber( WRGetVisiableContexCount() )

	for i=0, NumVisiable-1 do
		local VisiableID = WRGetVisiableContexID( i )
		if -1 ~= VisiableID then
			menuLevel,parentId = WRBOSSTblGetContexInfo( VisiableID )
			if -1 == parentId then
				local strTitle = WRGetTitle( 3, VisiableID )
				local strTemp = strTitle.."&"..(3)..","..VisiableID.."$0"
				WorldReferenceGreeting_Desc:AddOptionElement( strTemp )
			end
		end
	end

	local strBack = "Quay ð¥u Di®p".."&0,0".."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack )

end

--·ÖÅÉ ÊºÅ°²È« ×ÓÏîµÄº¯Êý
function WorldReference_DispatchContexAccount(TableID, ContexID)
  	WorldReferenceGreeting_Desc:ClearAllElement()
  	if( ContexID < 0) then
  		WRCollectVisiableContexEx( TableID, -ContexID, 0 )		--???
  	else
  		WRCollectVisiableContexEx( TableID, ContexID, 1 )   --???????
  	end
		local NumVisiable = tonumber( WRGetVisiableContexCount() )
		local VisiableID =-1;
		for i=0, NumVisiable-1 do
	     VisiableID = WRGetVisiableContexID( i )
	     if( -1 ~= VisiableID ) then
        local strTitle = WRGetVisiableContex( TableID, VisiableID )
        --AxTrace( 0, 0, "strTitle="..strTitle )
        if WRGetContexType( TableID, VisiableID ) == 3 then
        	WorldReferenceGreeting_Desc:AddTextElement( strTitle );
        else
          local strTemp = strTitle.."&"..TableID..","..(VisiableID).."$0"
        	WorldReferenceGreeting_Desc:AddOptionElement( strTemp );
        end
	    end
		end
		local strBack;
		--VisiableID = WRGetVisiableContexID( 0 )
    if VisiableID ~= -1  and WRGetContexType( TableID, VisiableID ) > 1 then
    	strBack = "Trên mµt".."&"..TableID..","..(-VisiableID).."$0"
    else
    	strBack = "Quay ð¥u Di®p".."&0,0".."$0"
    end
		WorldReferenceGreeting_Desc:AddOptionElement( strBack );
end

--=========================================================
--´¦Àíµã»÷BOSS±íÖÐÄ³Ò»ÏîµÄÊÂ¼þ....
--=========================================================
function WorldReference_BOSSOptionClicked( Data2 )

	WorldReferenceGreeting_Desc:ClearAllElement()

	local menuLevel = -1
	local parentId = -1

	--Èç¹ûµãµÄÊÇ·µ»ØÉÏ¼¶²Ëµ¥µÄÑ¡Ïî....ÔòÏàµ±ÓÚµã»÷-Date2²Ëµ¥....
	if Data2 < 0 then
		Data2 = -Data2
	end

	--»ñÈ¡ËùÑ¡ÌõÄ¿µÄÐÅÏ¢....
	menuLevel,parentId = WRBOSSTblGetContexInfo( Data2 )

	--Èç¹ûÑ¡µÄ²»ÊÇ²Ëµ¥¶øÊÇÎÄ×ÖÃèÊöÏîÔòÏÔÊ¾ÄÚÈÝ....
	if menuLevel == -1 then

		--¼ÓÈëÄÚÈÝÎÄ×Ö....
    local strContex = WRGetVisiableContex( 3, Data2 )
    WorldReferenceGreeting_Desc:AddTextElement( strContex )

	else --??????????????Title....

		--Ê ¼¯¸¸ÏîIDÎªData2µÄ¿ÉÏîÄ¿....
		WRBOSSTblCollectVisiableContex( Data2 )

		--¼ÓÈëÏîÄ¿µ½½çÃæÖÐ....
		local NumVisiable = WRGetVisiableContexCount()
		for i=0, NumVisiable-1 do
	    local VisiableID = WRGetVisiableContexID( i )
	    if -1 ~= VisiableID then
				local strTitle = WRGetTitle( 3, VisiableID )
				local strTemp = strTitle.."&"..(3)..","..VisiableID.."$0"
				WorldReferenceGreeting_Desc:AddOptionElement( strTemp )
	    end
		end

	end

	--¼ÓÈë·µ»ØÉÏ²ãµÄÑ¡Ïî....
	local strBack
	if -1 == parentId then
			strBack = "Trên mµt".."&0,"..(3).."$0"
	else
		strBack = "Trên mµt".."&3,"..-parentId.."$0"
	end
	WorldReferenceGreeting_Desc:AddOptionElement( strBack )

end

--=========================================================
--ÏÔÊ¾Ê±¼ä
--=========================================================
function WorldReference_DispatchServerTime( strDate )
    WorldReferenceGreeting_Desc:ClearAllElement()

    WorldReferenceGreeting_Desc:AddTextElement( strDate )

    local strBack = "Quay ð¥u Di®p".."&0,"..(0).."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack );
end

function WorldReference_DispatchContex( TableID, ContexIndex )
    if( TableID == 1 and ContexIndex == -1) then   --????
            	--´ò¿ª¿É½ÓÈÎÎñÁÐ±í
		ToggleMissionOutLine();
		return
    end
    WorldReferenceGreeting_Desc:ClearAllElement()
    local strContex = WRGetVisiableContex( TableID, ContexIndex )
    WorldReferenceGreeting_Desc:AddTextElement( strContex )

    local strBack = "Trên mµt".."&0,"..TableID.."$0"
	WorldReferenceGreeting_Desc:AddOptionElement( strBack );

end

--=========================================================
-- Ñ¡ÔñÒ»¸öÈÎÎñ
--=========================================================
function WorldReferenceOption_Clicked()

	--ÎÄ×ÖµÄ¸ñÊ½ÊÇ
	--QuestGreeting_option_03&211207,0
	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");

	local strOptionID = -1;
	local strOptionExtra1 = string.sub(arg0, pos2+1,pos3-1 );
	local strOptionExtra2 = string.sub(arg0, pos4+1);

    local Data1 = tonumber( strOptionExtra1 )      --Data1?????
    local Data2 = tonumber( strOptionExtra2 )      --Data2??????index


    if( Data1 == 0 ) then       --??
        if( Data2 == 0 ) then   --??
            WorldReference_DispatchMainPage()
        end

        if( Data2 == 1 ) then   --???
            WorldReference_DispatchMissionTable()
        end

        if( Data2 == 2 ) then   --??
            WorldReference_DispatchMonsterTable()
        end
        if( Data2 == 3 ) then   --BOSS
            WorldReference_DispatchBossTable()
        end

        if( Data2 == 4 ) then   --??
            WRAskTime()
        end

        if( Data2 == 5 ) then   --???
            WorldReference_DispatchOtherTable()
        end
        
        if (Data2 == 6) then	--????
   				PushEvent("OPEN_AGREEMENT_SECOND_UI", 0, 0, 0)
   				this:Hide();
   				return;
  	 		end
    		
	   		if (Data2 == 7) then	--????
   				PushEvent("OPEN_AGREEMENT_SECOND_UI", 1, 0, 0)
   				this:Hide();
  	 			return;
	   		end

        if( Data2 > 8 ) then
            WorldReference_DispatchContex( Data1, Data2 - 1 )
        end

    elseif( Data1 == 3 ) then	--BOSS?????????????????....
    	WorldReference_BOSSOptionClicked(Data2);
    elseif( Data1 == 8 ) then	--????????
    	WorldReference_DispatchContexAccount(Data1, Data2);
    else
			WorldReference_DispatchContex( Data1, Data2 )   --????????
    end

end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_WorldReference(objCaredId)
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_WorldReference(objCaredId)
end

--=========================================================
--ÏÔÊ¾Ä³¸öBOSSµÄÐÅÏ¢....
--=========================================================
function WorldReference_OpenBossInfo( BossId )

	WorldReference_BOSSOptionClicked( tonumber(BossId) )
	this:Show();

end

function WorldReference_ResetPos()
	WorldReference_Frame:SetProperty("UnifiedXPosition", g_WorldReference_Frame_UnifiedXPosition);
	WorldReference_Frame:SetProperty("UnifiedYPosition", g_WorldReference_Frame_UnifiedYPosition);

end
