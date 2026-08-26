local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Biwuzhaoqin_Vote_TargetId = -1

local g_Biwuzhaoqin_Vote_listitem = {}

local g_Biwuzhaoqin_Vote_ButtonLastTime = 0
local g_Biwuzhaoqin_Vote_ButtonCDTime = 3000 --3s
local g_Biwuzhaoqin_Vote_guid = 0

--滚动条的位置
local g_Position_Scroll = 0;

function Biwuzhaoqin_Vote_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_BWZQ_SPONSORLIST",false)
	this:RegisterEvent("SCENE_TRANSED")

end

function Biwuzhaoqin_Vote_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Biwuzhaoqin_Vote_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Biwuzhaoqin_Vote_Frame:GetProperty("UnifiedYPosition");

end

function Biwuzhaoqin_Vote_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		Biwuzhaoqin_Vote_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		Biwuzhaoqin_Vote_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 79210702) then
		local bShow = Get_XParam_INT(0)
		if bShow == 1 then
			g_Biwuzhaoqin_Vote_guid = 0
			g_Biwuzhaoqin_Vote_TargetId = Get_XParam_INT(1);
			local ObjCaredID = DataPool : GetNPCIDByServerID(g_Biwuzhaoqin_Vote_TargetId);
			if ObjCaredID == -1 then
				return;
			end
			this:CareObject(ObjCaredID, 1, "Biwuzhaoqin_Vote");
			g_Position_Scroll = 0
			this:Show()
		elseif bShow == 2 then
			--刷新特效
			g_Biwuzhaoqin_Vote_guid = Get_XParam_INT(1)
		end
	elseif (event == "UPDATE_BWZQ_SPONSORLIST") then
		Biwuzhaoqin_Vote_Update()
	elseif( event == "SCENE_TRANSED" ) then		
		Biwuzhaoqin_Vote_OnClose()
	end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_Vote_ResetPos()
	Biwuzhaoqin_Vote_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Biwuzhaoqin_Vote_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function Biwuzhaoqin_Vote_OnClose()
	this:Hide()
end

function Biwuzhaoqin_Vote_Update()
	Biwuzhaoqin_Vote_List:Clear()

	local voteph = BWZQ:LuaFnGetVotePhrase()
	if voteph <= 0 then
		Biwuzhaoqin_Vote_ListTitle_Time:SetText("#{BWZQ_20230329_95}")
	elseif voteph == 1 then
		Biwuzhaoqin_Vote_ListTitle_Time:SetText("#{BWZQ_20230329_96}")
	elseif voteph == 2 then
		Biwuzhaoqin_Vote_ListTitle_Time:SetText("#{BWZQ_20230329_97}")
	end

	g_Biwuzhaoqin_Vote_listitem={}
	local tblinfo = LuaFnGetBWZQSponsorInfo()

	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end

	local ntbcount = table.getn(tblinfo)
	for i = 1, ntbcount do
		--第一列
		local bar1 = nil
		if i == 1 then
			bar1 = Biwuzhaoqin_Vote_List:AddChild("Biwuzhaoqin_Vote_ListItem")
		elseif i == 2 then
			bar1 = Biwuzhaoqin_Vote_List:AddChild("Biwuzhaoqin_Vote_ListItem2")
		elseif i == 3 then
			bar1 = Biwuzhaoqin_Vote_List:AddChild("Biwuzhaoqin_Vote_ListItem3")
		else
			bar1 = Biwuzhaoqin_Vote_List:AddChild("Biwuzhaoqin_Vote_ListItem4")
		end
		if not bar1 then
			break
		end
--		bar1:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
		local id 	    = tblinfo[i].id
		local guid 	    = tblinfo[i].guid
		local name      = tblinfo[i].name
		local level     = tblinfo[i].level
		local votecount    = tblinfo[i].votecount
	
		if guid == GetSelfGUID() then
			id = "#G"..id
			name = "#G"..name
			level = "#G"..level
			votecount = "#G"..votecount
		else
			id = "#cfff263"..id
			name = "#cfff263"..name
			level = "#cfff263"..level
			votecount = "#cfff263"..votecount
		end

		if i == 1 then
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_Name"):SetText(name)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_Level"):SetText(level)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_Count"):SetText(votecount)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_VoteButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_VoteClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_XinButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_XinClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_ChaButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_ChaClicked(%d)", i))
	    if g_Biwuzhaoqin_Vote_guid == guid then
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_Animate"):Show()
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_Animate"):Play(true)
	    	g_Biwuzhaoqin_Vote_guid = 0
	    end
	    g_Biwuzhaoqin_Vote_listitem[i] = bar1
	  elseif i == 2 then
	  	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_Name"):SetText(name)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_Level"):SetText(level)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_Count"):SetText(votecount)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_VoteButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_VoteClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_XinButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_XinClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_ChaButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_ChaClicked(%d)", i))
	    if g_Biwuzhaoqin_Vote_guid == guid then
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_Animate"):Show()
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem2_Animate"):Play(true)
	    	g_Biwuzhaoqin_Vote_guid = 0
	    end
	    g_Biwuzhaoqin_Vote_listitem[i] = bar1
	  elseif i == 3 then
	  	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_Name"):SetText(name)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_Level"):SetText(level)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_Count"):SetText(votecount)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_VoteButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_VoteClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_XinButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_XinClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_ChaButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_ChaClicked(%d)", i))
	    if g_Biwuzhaoqin_Vote_guid == guid then
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_Animate"):Show()
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem3_Animate"):Play(true)
	    	g_Biwuzhaoqin_Vote_guid = 0
	    end
	    g_Biwuzhaoqin_Vote_listitem[i] = bar1
	  else
	  	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_Name"):SetText(name)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_Level"):SetText(level)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_Count"):SetText(votecount)   
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_VoteButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_VoteClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_XinButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_XinClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_ChaButton"):SetEvent("Clicked", string.format("Biwuzhaoqin_Vote_ChaClicked(%d)", i))
	    bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_RankText"):SetText(i)
	    if g_Biwuzhaoqin_Vote_guid == guid then
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_Animate"):Show()
	    	bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem4_Animate"):Play(true)
	    	g_Biwuzhaoqin_Vote_guid = 0
	    end
	    g_Biwuzhaoqin_Vote_listitem[i] = bar1
	  end
        
		--bar1:GetSubItem("Biwuzhaoqin_Vote_ListItem_VoteButton"):Show()

  end

	Biwuzhaoqin_Vote_Level_AllNumber:SetText( ScriptGlobal_Format("#{BWZQ_20230329_94}",ntbcount) )
	Biwuzhaoqin_Vote_List:SetScrollPosition(g_Position_Scroll)
end

function Biwuzhaoqin_Vote_Refresh_Clicked()
	local curTime = OSAPI:GetTickCount();
	if ( curTime - g_Biwuzhaoqin_Vote_ButtonLastTime < g_Biwuzhaoqin_Vote_ButtonCDTime ) then   	 
		PushDebugMessage("#{BWZQ_20230329_103}");
		return
	end
	g_Biwuzhaoqin_Vote_ButtonLastTime = curTime;
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskVoteInfo" ); 	-- 函数名
		Set_XSCRIPT_ScriptID( 792107 );					-- 脚本编号
		Set_XSCRIPT_Parameter(0, g_Biwuzhaoqin_Vote_TargetId)
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
	g_Position_Scroll = Biwuzhaoqin_Vote_List:GetScrollPosition()
end
function Biwuzhaoqin_Vote_VoteClicked(nIdx)

	local tblinfo= LuaFnGetBWZQSponsorInfo()
	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end  
	local guid 	    = tblinfo[nIdx].guid
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnVote" ); 	-- 函数名
		Set_XSCRIPT_ScriptID( 792107 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0,guid)
		Set_XSCRIPT_Parameter(1,0)
		Set_XSCRIPT_ParamCount( 2 );						-- 参数个数
	Send_XSCRIPT()
	g_Position_Scroll = Biwuzhaoqin_Vote_List:GetScrollPosition()
end

function Biwuzhaoqin_Vote_XinClicked(nIdx)

	PushEvent("SHOW_BWZQ_SPONSOR_DETAIL", g_Biwuzhaoqin_Vote_TargetId, nIdx)
end

function Biwuzhaoqin_Vote_ChaClicked(nIdx)
	--查看投票详情
	local tblinfo= LuaFnGetBWZQSponsorInfo()
	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end
	local guid 	    = tblinfo[nIdx].guid
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnGetVoteList" ); 	-- 函数名
		Set_XSCRIPT_ScriptID( 792107 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0,g_Biwuzhaoqin_Vote_TargetId)
		Set_XSCRIPT_Parameter(1,guid)
		Set_XSCRIPT_ParamCount( 2 );						-- 参数个数
	Send_XSCRIPT()
	g_Position_Scroll = Biwuzhaoqin_Vote_List:GetScrollPosition()
end

function Biwuzhaoqin_Vote_Close()
	CloseWindow("Biwuzhaoqin_Vote_Rank", true)
	CloseWindow("Biwuzhaoqin_appearance", true)
	g_Biwuzhaoqin_Vote_guid = 0
	this:Hide()
end