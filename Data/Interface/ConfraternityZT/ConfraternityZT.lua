local g_ZTListType = 0;
local g_ConfraternityZT_Frame_UnifiedPosition;
function ConfraternityZT_PreLoad()
	this:RegisterEvent("GUILD_SHOW_GUILDBATTLE");	
	--this:RegisterEvent("GUILD_UPDATE_ENEMYLIST");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

function ConfraternityZT_OnLoad()
	g_ConfraternityZT_Frame_UnifiedPosition=ConfraternityZT_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityZT_OnEvent(event)
	if ( event == "GUILD_SHOW_GUILDBATTLE") then
		g_ZTListType = tonumber(arg0);
		ConfraternityZT_InitDlg();
		ConfraternityZT_UpdateDlg();
		this:Show()
	end
		-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityZT_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityZT_Frame_On_ResetPos()
	end
end

function ConfraternityZT_InitDlg()
	if(g_ZTListType == 0) then
		ConfraternityZT_DragTitle:SetText("#{BHXZ_081205_01}")
		ConfraternityZT_LookupButton:SetText("#{ConfraternityPK_XML_4}"); 
		ConfraternityZT_List_Text:SetText("#{ConfraternityPK_XML_2}");
		ConfraternityZT_StartBtn:Show();
		ConfraternityZT_JiezhanButton:Hide();
	else
		ConfraternityZT_DragTitle:SetText("#{BHXZ_081205_02}")
		ConfraternityZT_LookupButton:SetText("#{ConfraternityPK_XML_5}")
		ConfraternityZT_List_Text:SetText("#{ConfraternityPK_XML_11}");
		ConfraternityZT_StartBtn:Hide();
		ConfraternityZT_JiezhanButton:Show();
	end
end

function ConfraternityZT_UpdateDlg()
	ConfraternityZT_List:RemoveAllItem();
	local nNum = City:GetBattleNum(g_ZTListType);
	for i = 0 , nNum - 1 do
		local nGulidid 		= City:EnumBattleGuild(g_ZTListType,i,"guildid");
		local szGuildName = City:EnumBattleGuild(g_ZTListType,i,"name");
		local szLeftTime 	= City:EnumBattleGuild(g_ZTListType,i,"lefttime");
		ConfraternityZT_List:AddNewItem(nGulidid, 		0, i);
		ConfraternityZT_List:AddNewItem(szGuildName, 	1, i);
		ConfraternityZT_List:AddNewItem(szLeftTime, 	2, i);			
	end
end

function ConfraternityZT_StartBtn_Click()
	if(g_ZTListType == 0) then
		City:OpenAddBattleDlg();
	end
end

function ConfraternityZT_LookupButton_Click()
	if(g_ZTListType==nil)then
		return;
	end
	City:AskBattleList(1-g_ZTListType);
end

function ConfraternityZT_JiezhanButton_Click()
	local nSelected = ConfraternityZT_List:GetSelectItem();
	if(nSelected >= 0) then
		City:SelectGuildBattle(nSelected);
	end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function ConfraternityZT_Frame_On_ResetPos()
  ConfraternityZT_Frame:SetProperty("UnifiedPosition", g_ConfraternityZT_Frame_UnifiedPosition);
end