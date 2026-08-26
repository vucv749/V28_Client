local g_TimingPlay_Info_UnifiedPosition   
local g_TimingPlay_Info_nSelectIndex = 0; 
--=========
-- PreLoad()
--=========
function TimingPlay_Info_PreLoad() 
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false) 
	this:RegisterEvent("OPENJIANGSHUJISHI_POPUP",true)  
end

--=========
-- OnLoad()
--=========
function TimingPlay_Info_OnLoad() 
	g_TimingPlay_Info_UnifiedPosition = TimingPlay_Info_Frame:GetProperty("UnifiedPosition")
	TimingPlay_Info_LoadControl()
end

--=========
-- Event
--=========
function TimingPlay_Info_OnEvent(event)

	if event == "OPENJIANGSHUJISHI_POPUP" then		
		g_TimingPlay_Info_nSelectIndex = tonumber(arg0) 	
		if this:IsVisible() then
			TimingPlay_Info_OnHiden() 
        end     
		TimingPlay_Info_Open()
		this:Show()
	elseif event == "HIDE_ON_SCENE_TRANSED" then

		TimingPlay_Info_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then
	
		TimingPlay_Info_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

        TimingPlay_Info_On_ResetPos() 
        
	end

end

function TimingPlay_Info_OnHiden()   
	this:Hide()
end

--=========
-- 重置
--=========
function TimingPlay_Info_On_ResetPos()

	TimingPlay_Info_Frame:SetProperty("UnifiedPosition", g_TimingPlay_Info_UnifiedPosition)

end

--=========
-- 装载控件
--=========
function TimingPlay_Info_LoadControl()   
end

--=========
-- 打开
--=========
function TimingPlay_Info_Open() 
	
	local infotbl = Lua_GetTeSeServerData()
	if type(infotbl) ~= "table" then
		return
	end 
	if g_TimingPlay_Info_nSelectIndex == nil  then
		PushDebugMessage("empty")
		return
	end
	
	if infotbl[g_TimingPlay_Info_nSelectIndex] == nil then
		PushDebugMessage("empty")
		return
	end
	TimingPlay_Info_DragTitle:SetText(infotbl[g_TimingPlay_Info_nSelectIndex].Title)
	STimingPlay_Info_tianzhan:SetText(infotbl[g_TimingPlay_Info_nSelectIndex].DetailDesc) 
	 
end  
 
