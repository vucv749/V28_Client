--***********************************************************************************************************************************************
-- 复活界面		
--注意，此界面为复活专用，请不要用来做其他用途
--***********************************************************************************************************************************************
local Current_status = 0;
local Current_Quest = -1;
-------------------------------------------------------------------------------------------------------------------------------------------------
--
-- 此处定义需要保存数据的局部变量
--

--------------------------------------------------------
-- 当前对话框的操作类型
local g_Event;

local Event_Relive = 0;
local Event_Callof = 1;
local g_newPlayerReliveSceneRes = {	--显示新手复活按钮副本 CLIENTRESID
      548
}
local g_relive_tjc_res = 618
local g_relive_dlsy_res = 639	-- 帝陵深渊场景资源id
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

	--拉人技能
	this:RegisterEvent("OPEN_CALLOF_PLAYER");
	
end

function Relive_OnLoad()
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function Relive_OnEvent(event)
	AxTrace( 0,0, "here");
	if ( event == "RELIVE_SHOW" ) then
		if Relive_IsSpecialSceneResID() == 1 then  
			Relive_Text:SetText("#{XSLDZ_180521_125}")
			Question_Text:SetText("#gFF0FA0复活");
			Relive_Release_Button:SetText("回营")
			Relive_Release_Button:Show()
			Relive_Release_Button:Enable()
			Relive_Time_Text : SetProperty("Timer",tostring(arg2)); 
			Question_Help:Disable();
			Question_Close:Disable();
			Relive_Fool_Button:Hide()
			--有复活按钮
			if ( arg1 == "1" ) then
				Relive_Relive_Button:Enable();
			--无复活按钮
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
			Relive_Text:SetText( "你已经死亡，但由于你对人间还有些许执念，你是继续等待还是灵魂出窍？" );
		end
		
--		Relive_Time_Text:SetText( arg2 );
		Relive_Time_Text : SetProperty("Timer",tostring(arg2));
		--有复活按钮
		if ( arg0 == "1" ) then
			Relive_Fool_Button:Enable();
		--无复活按钮
		else
			Relive_Fool_Button:Disable();
		end
		--有复活按钮
		if ( arg1 == "1" ) then
			Relive_Relive_Button:Enable();
		--无复活按钮
		else
			Relive_Relive_Button:Disable();
		end
		
		g_relive_SpecialItem = tonumber(arg3)
		Question_Help:Disable();
		Question_Close:Disable();
		Current_status = 0;
		Relive_Fool_Button:SetText("新手");
		Relive_Release_Button:SetText("出窍");
		Relive_Relive_Button:SetText("复活"); 
		Question_Text:SetText("#gFF0FA0复活");
		this:Show();
		g_Event = Event_Relive;

	elseif ( event == "RELIVE_HIDE" ) then
		Current_status = 0;
		this:Hide();

	elseif ( event == "RELIVE_REFESH_TIME" ) then
	
		Relive_Time_Text : SetProperty("Timer",tostring(arg0));
		Current_status = 0;
	
		
	elseif ( event == "OPEN_CALLOF_PLAYER" )  then
		
		Relive_Text:SetText(arg0 .. "拉你过去，是否同意啊？");
			
		Relive_Release_Button:SetText("确定");
		Relive_Relive_Button:SetText("取消");

		Question_Text:SetText("#gFF0FA0拉人");

		Relive_Time_Text:SetProperty("Timer",tostring( arg3 ));
		this:Show()
		g_Event = Event_Callof;
		
	end
end



--***********************************************************************************************************************************************
--
-- 点击出窍按钮
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
-- 点击复活按钮
--
--
--***********************************************************************************************************************************************
function Relive_Relive()

	if( g_Event == Event_Relive )  then
		if(Current_status == 1) then
			this:Hide();
			return;
		else
			-- 还魂灵露特写
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

--计时器＝0
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

-- 是否帝陵深渊场景
function Relive_IsDLSYScene()
	local curSceneID = GetSceneID()
	if (curSceneID == g_relive_dlsy_res) then
		return 1
	end

	return 0
end -- end func Relive_IsDLSYScene()

-- 是否爬塔夺宝场景
function Relive_IsPTDBScene()
	local curSceneID = GetSceneID()
	local isOk = PTDB:LuaFnIsPTDBScene(curSceneID)
	if (isOk > 0) then
		return 1
	end

	return 0
end -- end func Relive_IsPTDBScene()

-- 是否跨服日常BOSS
function Relive_IsKFRCBOSSScene()
	local curSceneID = GetSceneID()
	local isOk = KFRCBOSS:LuaFnIsCKFRCBOSSScene(curSceneID)
	if (isOk > 0) then
		return 1
	end

	return 0
end -- end func Relive_IsKFRCBOSSScene()