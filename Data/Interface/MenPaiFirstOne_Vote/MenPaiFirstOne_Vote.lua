--活跃积分商店 
local g_MenPaiFirstOne_Vote_Frame_UnifiedXPosition
local g_MenPaiFirstOne_Vote_Frame_UnifiedYPosition   
local g_MenPaiFirstOne_Vote_listitem = {}
local g_MenPaiFirstOne_Vote_LevelType = 0
local g_EventIndex = -1 --当前选中的选项
local g_MenPaiFirstOne_Vote_ButtonCDTime = 4; --按钮冷却时间
local g_MenPaiFirstOne_Vote_ButtonLastTime = 0; 
local g_MenPaiFirstOne_Vote_TargetId = -1; 
local objCared =-1
local g_MenPaiFirstOne_Vote_IsBaoMing = 0
local g_MenPaiFirstOne_Vote_IsTouPiao = 0
local g_MenPaiFirstOne_Vote_IsBaoMingEndVoteBeg = 0
local g_MenPaiFirstOne_Vote_LevelTypeStr ={
	[0] = "#{JXGZ_220427_48}",
	[1] = "#{JXGZ_220427_47}",
	[2] = "#{JXGZ_220427_46}",
}
local g_MenPaiFirstOne_Vote_LevelTab = {
    [1] = {min=60,max=119,type=0,},
    [2] = {min=80,max=89,type=0,},
    [3] = {min=90,max=119,type=0,},
}
local g_MenPaiFirstOne_Vote_Levelchk = { 
}
function MenPaiFirstOne_Vote_PreLoad()

	this:RegisterEvent("OPEN_DDZ_CHARINFO", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("ADJEST_UI_POS",false)  
	this:RegisterEvent("OBJECT_CARED_EVENT",false)  
	this:RegisterEvent("UI_COMMAND");
	
end

function MenPaiFirstOne_Vote_OnLoad() 
	g_MenPaiFirstOne_Vote_Frame_UnifiedXPosition = MenPaiFirstOne_Vote_Frame:GetProperty("UnifiedXPosition") 
	g_MenPaiFirstOne_Vote_Frame_UnifiedYPosition = MenPaiFirstOne_Vote_Frame:GetProperty("UnifiedYPosition") 
	MenPaiFirstOne_Vote_List:Clear(); 
	g_MenPaiFirstOne_Vote_Levelchk[1] = MenPaiFirstOne_Vote_Level1  
	g_MenPaiFirstOne_Vote_Levelchk[2] = MenPaiFirstOne_Vote_Level2  
	g_MenPaiFirstOne_Vote_Levelchk[3] = MenPaiFirstOne_Vote_Level3 
end
 
--=========
-- Event
--=========
function MenPaiFirstOne_Vote_OnEvent(event) 
	if event == "OPEN_DDZ_CHARINFO"  then --  
		if tonumber(arg0) > 0 then
			g_MenPaiFirstOne_Vote_TargetId = tonumber(arg0) 
		end  
		g_MenPaiFirstOne_Vote_IsBaoMing = math.floor(tonumber(arg1)/100)
		g_MenPaiFirstOne_Vote_IsTouPiao = math.mod(tonumber(math.floor(tonumber(arg1)/10)),10)
		g_MenPaiFirstOne_Vote_IsBaoMingEndVoteBeg = math.mod(tonumber(arg1),10)
		if not this:IsVisible() then
			MenPaiFirstOne_Vote_SetLevelType()     
        end   
		 
		MenPaiFirstOne_Vote_Open()   
		if g_MenPaiFirstOne_Vote_TargetId > 0 then
			objCared = DataPool : GetNPCIDByServerID(g_MenPaiFirstOne_Vote_TargetId)
			this:CareObject(objCared, 1, "MenPaiFirstOne_Vote");	
		end
		if not this:IsVisible() then
			this:Show()
			return
        end   
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		MenPaiFirstOne_Vote_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		MenPaiFirstOne_Vote_Close()
	elseif event == "ADJEST_UI_POS" then
		MenPaiFirstOne_Vote_On_ResetPos() 
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			--取消关心
			this:CareObject(objCared, 0, "MenPaiFirstOne_Vote");
		end	
	end
end
 
--=========
-- 重置
--=========
function MenPaiFirstOne_Vote_On_ResetPos()
	MenPaiFirstOne_Vote_Frame:SetProperty("UnifiedXPosition", g_MenPaiFirstOne_Vote_Frame_UnifiedXPosition)
	MenPaiFirstOne_Vote_Frame:SetProperty("UnifiedYPosition", g_MenPaiFirstOne_Vote_Frame_UnifiedYPosition)
end
 
--=========
-- 关闭
--=========
function MenPaiFirstOne_Vote_Close() 
	g_MenPaiFirstOne_Vote_LevelType = 0
	this:CareObject(objCared, 0, "MenPaiFirstOne_Vote");
	this:Hide()
end 
--=========
-- 打开
--=========
function MenPaiFirstOne_Vote_Open()  
    for i = 1, table.getn(g_MenPaiFirstOne_Vote_listitem) do
		if g_MenPaiFirstOne_Vote_listitem[i] ~= nil then
			g_MenPaiFirstOne_Vote_listitem[i] = nil
		end
    end
    
    MenPaiFirstOne_Vote_List:Clear()
    local tblinfo= Lua_GetDDZCharInfo(g_MenPaiFirstOne_Vote_LevelType)
	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end  
	MenPaiFirstOne_Vote_MyInfoBK:Hide() 
	if g_MenPaiFirstOne_Vote_IsTouPiao == 0 and g_MenPaiFirstOne_Vote_IsBaoMing == 0 and g_MenPaiFirstOne_Vote_IsBaoMingEndVoteBeg == 0 then
		MenPaiFirstOne_Vote_List_Finish:SetText("#{JXGZ_220427_101}")
		MenPaiFirstOne_Vote_List_Finish:Show()
		MenPaiFirstOne_Vote_ListTitle_Time:SetText("#{JXGZ_220427_67}")
		MenPaiFirstOne_Vote_ListTitle_Time:Show()
		MenPaiFirstOne_Vote_Level_AllNumber:Hide()
		MenPaiFirstOne_Vote_MyInfo_GetButton:Show()
		MenPaiFirstOne_Vote_MyInfo_Voting:Hide()
	elseif g_MenPaiFirstOne_Vote_IsBaoMing == 1 then
		MenPaiFirstOne_Vote_List_Finish:Hide()
		MenPaiFirstOne_Vote_ListTitle_Time:SetText("#{JXGZ_220427_65}")
		MenPaiFirstOne_Vote_ListTitle_Time:Show()
		MenPaiFirstOne_Vote_Level_AllNumber:Show()
		MenPaiFirstOne_Vote_MyInfo_GetButton:Hide()
		MenPaiFirstOne_Vote_MyInfo_Voting:Hide()
	elseif g_MenPaiFirstOne_Vote_IsTouPiao == 1 then
		MenPaiFirstOne_Vote_List_Finish:Hide()
		MenPaiFirstOne_Vote_ListTitle_Time:SetText("#{JXGZ_220427_66}")
		MenPaiFirstOne_Vote_ListTitle_Time:Show("#{JXGZ_220427_66}")
		MenPaiFirstOne_Vote_MyInfo_Voting:Show()
		MenPaiFirstOne_Vote_MyInfo_GetButton:Hide()	
	elseif g_MenPaiFirstOne_Vote_IsBaoMingEndVoteBeg == 1 then
		MenPaiFirstOne_Vote_List_Finish:SetText("#{JXGZ_220427_120}")
		MenPaiFirstOne_Vote_List_Finish:Show()
		MenPaiFirstOne_Vote_MyInfo_Voting:Hide()
		MenPaiFirstOne_Vote_MyInfo_GetButton:Hide()	
		MenPaiFirstOne_Vote_ListTitle_Time:Hide()
	end 
	MenPaiFirstOne_Vote_MyInfo_NOBK:Show()
	MenPaiFirstOne_Vote_MyInfoBK:Hide()
	MenPaiFirstOne_Vote_MyInfo_NO:SetText(ScriptGlobal_Format("#{JXGZ_220427_102}", g_MenPaiFirstOne_Vote_LevelTypeStr[g_MenPaiFirstOne_Vote_LevelType]))
    for i = 1, table.getn(tblinfo) do
		--第一列
		local bar1 = MenPaiFirstOne_Vote_List:AddChild("MenPaiFirstOne_Vote_ListItem")
		if not bar1 then
    	   break
		end
		bar1:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
        local id 	    = tblinfo[i].id
		local guid 	    = tblinfo[i].guid
		local level     = tblinfo[i].level
		local ticket    = tblinfo[i].ticket
		local name      = tblinfo[i].name 
        bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_Rank"):SetText(i)   
        bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_Name"):SetText(name)   
        bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_Level"):SetText(level)   
        bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_Count"):SetText(ticket)   
        bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_VoteButton"):SetEvent("MouseLButtonDown", string.format("MenPaiFirstOne_Vote_Clicked(%d)", i))   
        g_MenPaiFirstOne_Vote_listitem[i] = bar1
        
		if guid == GetSelfGUID() then
			MenPaiFirstOne_Vote_MyInfoBK:Show() 
			MenPaiFirstOne_Vote_MyInfo_NOBK:Hide()  
			bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_VoteButton"):Hide()
			MenPaiFirstOne_Vote_MyInfo_Rank:SetText(i)	
			MenPaiFirstOne_Vote_MyInfo_Name:SetText(name)	
			MenPaiFirstOne_Vote_MyInfo_Level:SetText(level)	
			MenPaiFirstOne_Vote_MyInfo_Count:SetText(ticket)				
		end
		
		if g_MenPaiFirstOne_Vote_IsTouPiao == 1 and guid ~= GetSelfGUID() then
			bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_VoteButton"):Show()
		else
			bar1:GetSubItem("MenPaiFirstOne_Vote_ListItem_VoteButton"):Hide()
		end
    end
     
    MenPaiFirstOne_Vote_Level_AllNumber:SetText( ScriptGlobal_Format("#{JXGZ_220427_85}",table.getn(tblinfo)) )
end

--=========
-- 投票
--=========
function MenPaiFirstOne_Vote_Clicked(index)
	local tblinfo= Lua_GetDDZCharInfo(g_MenPaiFirstOne_Vote_LevelType)
	
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end  
	local guid 	    = tblinfo[index].guid
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name( "TouPiao" ); 	-- 函数名
	Set_XSCRIPT_ScriptID( 893223 );						-- 脚本编号
	Set_XSCRIPT_Parameter(0,guid)
    Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
    Send_XSCRIPT()
end
--=========
-- 刷新
--=========
function MenPaiFirstOne_Refresh_Clicked()
    local curTime = OSAPI:GetTickCount();
	if ( curTime - g_MenPaiFirstOne_Vote_ButtonLastTime < g_MenPaiFirstOne_Vote_ButtonCDTime * 1000) then   	 
   	    PushDebugMessage("#{JXGZ_220427_57}"); --不可连续点击，请稍等片刻后再点击
		return
	end
	g_MenPaiFirstOne_Vote_ButtonLastTime = curTime;
	Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name( "AskTouPiaoInfo" ); 	-- 函数名
	Set_XSCRIPT_ScriptID( 893223 );						-- 脚本编号
	Set_XSCRIPT_Parameter(0, g_MenPaiFirstOne_Vote_TargetId)
    Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
    Send_XSCRIPT()
end
--=========
-- 切换级别
--=========
function MenPaiFirstOne_Vote_LevelType_Clicked(index)
    g_MenPaiFirstOne_Vote_LevelType = index
    MenPaiFirstOne_Vote_Open()
end 

--=========
-- 预览奖励
--=========
function MenPaiFirstOne_Vote_YuLanAward_Clicked() 
	PushEvent("OPEN_DDZ_AWARD")
end 

--=========
-- 领取奖励
--=========
function MenPaiFirstOne_Vote_GetAward_Clicked() 
	if Lua_DDZCharIsCanGetAward() == 0 then
		return
	end
	Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name( "GetAward" ); 	-- 函数名
    Set_XSCRIPT_ScriptID( 893223 );						-- 脚本编号
    Set_XSCRIPT_ParamCount( 0 );						-- 参数个数
    Send_XSCRIPT()
end 

--=========
-- help
--=========
function MenPaiFirstOne_Vote_Help_Clicked()  
    PushEvent("CCSHOP_HELP", 6)
end 

function  MenPaiFirstOne_Vote_SetLevelType()
	for i = 1, table.getn(g_MenPaiFirstOne_Vote_Levelchk) do 
		g_MenPaiFirstOne_Vote_Levelchk[i]:SetProperty("Selected", "False")
	end

	local myLevel = Player:GetData("LEVEL")
	for i = 1, table.getn(g_MenPaiFirstOne_Vote_LevelTab) do
		if  myLevel >= g_MenPaiFirstOne_Vote_LevelTab[i].min and  
			myLevel <= g_MenPaiFirstOne_Vote_LevelTab[i].max then
				g_MenPaiFirstOne_Vote_LevelType = g_MenPaiFirstOne_Vote_LevelTab[i].type
				g_MenPaiFirstOne_Vote_Levelchk[i]:SetProperty("Selected", "True")
				return
		end
	end
	g_MenPaiFirstOne_Vote_LevelType = 0
end