local g_State;
--用于领取提示的时间间隔
local g_Notes = {"#{XRLJ_100104_1}","#{XRLJ_100104_2}","#{XRLJ_100104_3}","#{XRLJ_100104_10}","#{XRLJ_100104_15}","#{XRLJ_100104_16}","#{XRLJ_100104_17}","#{XRLJ_100104_18}","#{XRLJ_100104_19}",}
function FreshmanWatch_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OPEN_NORMAL_WATCH");
	this:RegisterEvent("COUNTDOWN_10SEC");
	this:RegisterEvent("SWITCH_MENU_BUTTON")
end

function FreshmanWatch_OnLoad()
	FreshmanWatch_UpdatePos()
end

function FreshmanWatch_OnEvent(event)
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 889103 ) then
			local state = Get_XParam_INT(0)
			local countDownMinute = Get_XParam_INT(1)
			local isPlayerJustLogin = Get_XParam_INT(2)--表示该UICommand是玩家登陆时发送的，还是领奖成功后发送的
			g_State = state
			if state == 0 then
				this:Hide();
				FreshmanWatch_Time_Text:SetProperty("Timer",tostring(0));
				FreshmanWatch_Time_Text1:SetProperty("Timer",tostring(0));
				FlashPacketButton()
				return
			end
			this:Show();
			if countDownMinute == 0 then
				FreshmanWatch_TimeOut()
			else
				FreshmanWatch_Info:SetText("#{XRLJ_100104_5}")
				FreshmanWatch_Receive:Hide();
				FreshmanWatch_Text:Hide()
				FreshmanWatch_Mini:Show()
				FreshmanWatch_Min_Bk:Show()
				FreshmanWatch_Time_Text1:SetProperty("Timer",tostring(countDownMinute*60 - 10));
				FreshmanWatch_Time_Text:SetProperty("Timer",tostring(countDownMinute*60));
				FreshmanWatch_Time_Text:SetProperty("Flash",tostring(0));--停止闪烁
				FreshmanWatch_Time_Text:SetProperty("TextColor","ff00ffff");--颜色改回蓝色
				--弹出新手指引以及背包闪烁，只能在领奖后才发生
				if state == 3 and isPlayerJustLogin ~= 1 then --第二次领到坐骑后，需要弹出新手指引界面
					OpenFreshmanIntro(10) --弹出的是第10套新手指引
				end
				if state ~= 1  and isPlayerJustLogin ~= 1 then
					FlashPacketButton()
					this:Hide()
				end
			end
	elseif ( event == "OPEN_NORMAL_WATCH") then
		this:Show()
	elseif ( event == "COUNTDOWN_10SEC") then--倒数最后十秒变色、闪烁
		FreshmanWatch_Time_Text:SetProperty("TextColor","ffff0000");
    	FreshmanWatch_Time_Text:SetProperty("Flash",tostring(1));
	end
	
	if event == "SWITCH_MENU_BUTTON" then
		FreshmanWatch_UpdatePos()
	end
end

function FreshmanWatch_TimeOut()
    if g_State >= 1 and g_State <=9 then
		FreshmanWatch_Info:SetText(g_Notes[g_State])
	else
		FreshmanWatch_Info:SetText("#{XRLJ_100104_4}")
	end
	FreshmanWatch_Time_Text:SetProperty("Timer",tostring(0));
	FreshmanWatch_Time_Text1:SetProperty("Timer",tostring(0));
	FreshmanWatch_Receive:Show();
	FreshmanWatch_Min_Bk:Hide()
	FreshmanWatch_Mini:Hide()
	FreshmanWatch_Text:Show()
	PushDebugMessage("#{XRLJ_100104_13}")
	PushDebugMessage("#{XRLJ_100104_14}")
	Sound:PlayUISound(38);
end

function FreshmanWatch_Bn2Click()
    local isInHell = IsInHell()
    if isInHell == 1 then--在地府中不能领取奖品
    	return
    end
	Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "TakeGift" )
			Set_XSCRIPT_ScriptID( 889103 )
			Set_XSCRIPT_Parameter( 0, g_State )
			Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function FreshmanWatch_Min()
	this:Hide()
	DataPool:ShowMiniWatch()
end

function FreshmanWatch_TimeOut1()
	 CountDown10Sec()
end

function FreshmanWatch_UpdatePos()
	if IsWindowShow("MainMenuBar_4") == true then
		FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-75.000000},{1.000000,-240.000000}}")		
	elseif IsWindowShow("MainMenuBar_2") == true then
		FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-75.000000},{1.000000,-203.000000}}")
	else
		FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-75.000000},{1.000000,-170.000000}}")
	end
	FreshmanWatch_Info:SetText(FreshmanWatch_Info:GetText())
end