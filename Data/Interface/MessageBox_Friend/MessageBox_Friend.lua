
local InvitePlayer = { NAME = "", GUID = "" }
local g_MessageBox_Friend_Frame_UnifiedPosition;
function MessageBox_Friend_PreLoad()
	this:RegisterEvent("INVITE_ADD_ME_FRIEND");
		-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function MessageBox_Friend_OnLoad()
  g_MessageBox_Friend_Frame_UnifiedPosition=MessageBox_Friend_Frame:GetProperty("UnifiedPosition");
	InitPlayer();
	this:Hide();
end

function MessageBox_Friend_OnEvent(event)

	if ( event == "INVITE_ADD_ME_FRIEND" ) then
			InitPlayer();
			MessageBox_Friend_Text:Show();
	    InvitePlayer.NAME = tostring( arg0 );
	    InvitePlayer.GUID = tostring( arg1 );
	    MessageBox_Friend_Text:SetText("Ngﬂ∂i chΩi"..InvitePlayer.NAME.."Xin c·c h’ ﬂa h˜ v‡o danh s·ch h‰o hÊu");
			this:Show();
	end
		-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		MessageBox_Friend_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		MessageBox_Friend_Frame_On_ResetPos()
	end	
end


function MessageBox_Friend_Cancel_Clicked()
	this:Hide();
	InitPlayer();
end

function MessageBox_Friend_Detail_Clicked()

	if( Friend:IsPlayerIsFriend( InvitePlayer.NAME ) == 1 ) then	
		local nGroup,nIndex;
		nGroup,nIndex = DataPool:GetFriendByName( InvitePlayer.NAME );
		--Friend:SetCurrentSelect( nIndex );
		DataPool:ShowFriendInfo( InvitePlayer.NAME );
	else
		DataPool:ShowChatInfo( InvitePlayer.NAME );
	end

	--DataPool:ShowChatInfo( InvitePlayer.NAME );
	--AskDetailByGuid(InvitePlayer.GUID);
end

function MessageBox_Friend_Ok_Clicked()
	DataPool:AddFriend(0, InvitePlayer.NAME)
	this:Hide();
	InitPlayer();
end

function InitPlayer()
  InvitePlayer.NAME = "";
  InvitePlayer.GUID = "";
end

--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function MessageBox_Friend_Frame_On_ResetPos()
  MessageBox_Friend_Frame:SetProperty("UnifiedPosition", g_MessageBox_Friend_Frame_UnifiedPosition);
end
