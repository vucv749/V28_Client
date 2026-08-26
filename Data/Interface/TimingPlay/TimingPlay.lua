local g_TimingPlay_UnifiedPosition 
local g_TimingPlay_CurPage = 1
local g_TimingPlay_ShowNextIdx = -1
local g_TimingPlay_PerPageCount = 4
local g_TimingPlay_Total = 0 
local g_TimingPlay_Ctl = {}
local g_TimingPlay_red = 0 
local g_TimingPlay_GiftMD = 0
local g_TimingPlay_SvtTime = 0
local g_TimingPlay_EndTime = 0
--=========
-- PreLoad()
--=========
function TimingPlay_PreLoad()

	this:RegisterEvent("UI_COMMAND", true)--打开or刷新界面
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false) 
	this:RegisterEvent("OPENJIANGSHUJISHI",true) 
	this:RegisterEvent("UPDATE_MISSION",true) 
	this:RegisterEvent("UPDATE_MISSION_TRACK",true) 
end

--=========
-- OnLoad()
--=========
function TimingPlay_OnLoad() 
	g_TimingPlay_UnifiedPosition = TimingPlay_Frame:GetProperty("UnifiedPosition")
	TimingPlay_LoadControl()
end

--=========
-- Event
--=========
function TimingPlay_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99851701) then 
		g_TimingPlay_SvtTime	= Get_XParam_INT(0) 
		g_TimingPlay_EndTime	= Get_XParam_INT(1) 
		TimingPlay_GetCurPage() 
		TimingPlay_Open()
		this:Show()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		TimingPlay_OnHiden()
	elseif event == "VIEW_RESOLUTION_CHANGED" then	
		TimingPlay_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
        TimingPlay_On_ResetPos()  
	end

end

function TimingPlay_OnHiden() 
	g_TimingPlay_Total 	= 0
	g_TimingPlay_CurPage  = 1
	this:Hide()
end

--=========
-- 重置
--=========
function TimingPlay_On_ResetPos()

	TimingPlay_Frame:SetProperty("UnifiedPosition", g_TimingPlay_UnifiedPosition)

end

--=========
-- 装载控件
--=========
function TimingPlay_LoadControl() 
	g_TimingPlay_Ctl[1] = {
		img		= TimingPlay_TextBK1, 
		status 	= TimingPlay_TextBK1_Info2, 
		Desc  	= TimingPlay_TextBK1_Info,
		redPoint= TimingPlay_TextBK1_Tips,
		NestImg = TimingPlay_TextBK1_Star,		
		LockImg = TimingPlay_TextBK1_BK,  		
		Btn		= TimingPlay_TextBK1_Mask, 
	}
	g_TimingPlay_Ctl[2] = {
		img		= TimingPlay_TextBK2, 
		status 	= TimingPlay_TextBK2_Info2, 
		Desc  	= TimingPlay_TextBK2_Info,
		redPoint= TimingPlay_TextBK2_Tips,
		NestImg = TimingPlay_TextBK2_Star,  
		LockImg = TimingPlay_TextBK2_BK,  
		Btn		= TimingPlay_TextBK2_Mask,  
	}
	g_TimingPlay_Ctl[3] = {
		img		= TimingPlay_TextBK3, 
		status 	= TimingPlay_TextBK3_Info2, 
		Desc  	= TimingPlay_TextBK3_Info,
		redPoint= TimingPlay_TextBK3_Tips,
		NestImg = TimingPlay_TextBK3_Star,  
		LockImg = TimingPlay_TextBK3_BK,  
		Btn		= TimingPlay_TextBK3_Mask, 
	}
	g_TimingPlay_Ctl[4] = {
		img		= TimingPlay_TextBK4, 
		status 	= TimingPlay_TextBK4_Info2, 
		Desc  	= TimingPlay_TextBK4_Info,
		redPoint= TimingPlay_TextBK4_Tips,
		NestImg = TimingPlay_TextBK4_Star,  
		LockImg = TimingPlay_TextBK4_BK, 
		Btn		= TimingPlay_TextBK4_Mask, 
	}
end

--=========
-- 打开
--=========
function TimingPlay_Open()  
	local dpEndYear= math.floor(g_TimingPlay_EndTime/1000000)
	local dpEndMon = math.mod(math.floor(g_TimingPlay_EndTime/10000),100)
	local dpEndDay =math.mod(math.floor(g_TimingPlay_EndTime/100),100) 
	local dpEndHour = math.mod(math.floor(g_TimingPlay_EndTime),100)  

	local dexpText 		= ScriptGlobal_Format("#{JZF_230821_12}", dpEndMon,dpEndDay)
		
	TimingPlay_Info:SetText(dexpText)

	local infotbl = Lua_GetTeSeServerData()
	if type(infotbl) ~= "table" then
		return
	end
	g_TimingPlay_Total = table.getn(infotbl)
    
    if g_TimingPlay_CurPage == 1 then
        TimingPlay_UpPage:Disable()
    else
        TimingPlay_UpPage:Enable()
    end

    if g_TimingPlay_CurPage*g_TimingPlay_PerPageCount >= g_TimingPlay_Total then
        TimingPlay_DownPage:Disable()
    else
        TimingPlay_DownPage:Enable()
    end

	for i = 1, g_TimingPlay_PerPageCount do
		g_TimingPlay_Ctl[i].img:Hide()
		g_TimingPlay_Ctl[i].NestImg:Hide() 
		g_TimingPlay_Ctl[i].LockImg:Hide()
		local ncuridx = (g_TimingPlay_CurPage - 1)*g_TimingPlay_PerPageCount + i
		if ncuridx > g_TimingPlay_Total or ncuridx <= 0 then
			continue
		end 

		local curDay 	= g_TimingPlay_SvtTime 
		local opentime  = Lua_GetTeSeServerOpenTime(infotbl[ncuridx].FuncID)
		if curDay >= opentime then 
			local year = math.floor(opentime/10000)
			local month = math.mod(math.floor(opentime/100),100)
			local day   = math.mod(opentime,100)			
			local strtime = ScriptGlobal_Format("#{JZF_230821_28}",month,day)
            g_TimingPlay_Ctl[i].status:SetText(strtime)	   
			g_TimingPlay_Ctl[i].NestImg:Hide()
			g_TimingPlay_Ctl[i].LockImg:Hide()
		else			
			local year = math.floor(opentime/10000)
			local month = math.mod(math.floor(opentime/100),100)
			local day   = math.mod(opentime,100)			
			local strtime = ScriptGlobal_Format("#{JZF_230821_48}",month,day)
            g_TimingPlay_Ctl[i].status:SetText(strtime)	   
			if g_TimingPlay_ShowNextIdx == ncuridx then				
				g_TimingPlay_Ctl[i].NestImg:Show()				
			else				
				g_TimingPlay_Ctl[i].NestImg:Hide()				
			end	
			if year >= 2099 then
				g_TimingPlay_Ctl[i].status:SetText("#{JZF_230821_29}")	
			end	
			g_TimingPlay_Ctl[i].LockImg:Show()
        end 
        g_TimingPlay_Ctl[i].Desc:SetText(infotbl[ncuridx].Desc)  
		g_TimingPlay_Ctl[i].img:Show()
		g_TimingPlay_Ctl[i].img:SetProperty("Image",infotbl[ncuridx].img);   
		g_TimingPlay_Ctl[i].Btn:SetProperty("HoverImage", infotbl[ncuridx].Hoverimg); 
		g_TimingPlay_Ctl[i].Btn:SetProperty("PushedImage", infotbl[ncuridx].Pushimg); 

	 
	end 
	 
	local totoalpage = 0
	if math.mod(g_TimingPlay_Total,g_TimingPlay_PerPageCount) == 0 then
		totoalpage = math.floor(g_TimingPlay_Total/g_TimingPlay_PerPageCount)
	else
		totoalpage = math.floor(g_TimingPlay_Total/g_TimingPlay_PerPageCount) + 1
	end
	local strpage = ScriptGlobal_Format("#{DWQ_210428_20}",g_TimingPlay_CurPage,totoalpage) 
end 
    
function TimingPlay_PageDown()
    if g_TimingPlay_CurPage*g_TimingPlay_PerPageCount < g_TimingPlay_Total then
        g_TimingPlay_CurPage = g_TimingPlay_CurPage + 1
        TimingPlay_Open()
    end
end

function TimingPlay_PageUp()
    if g_TimingPlay_CurPage > 1 then
        g_TimingPlay_CurPage = g_TimingPlay_CurPage - 1
        TimingPlay_Open()
    end
end

function TimingPlay_Click(idx) 
	local infotbl = Lua_GetTeSeServerData()
	if type(infotbl) ~= "table" then
		return
	end
	local idx = (g_TimingPlay_CurPage - 1)*g_TimingPlay_PerPageCount + idx
	local curDay 	= g_TimingPlay_SvtTime
	local opentime  = Lua_GetTeSeServerOpenTime(infotbl[idx].FuncID) 
	local year = math.floor(opentime/10000)
	local month = math.mod(math.floor(opentime/100),100)
	local day   = math.mod(opentime,100)			
	if year >= 2099 then
		PushDebugMessage("敬请期待")
		return
	end
	if opentime > curDay then
		local strtime = ScriptGlobal_Format("#{JZF_230821_27}",month,day)
		PushDebugMessage(strtime)
		return
    end  	
    PushEvent("OPENJIANGSHUJISHI_POPUP", idx) 
end

function TimingPlay_GetCurPage()
	local infotbl = Lua_GetTeSeServerData()
	if type(infotbl) ~= "table" then
		return
	end 
	g_TimingPlay_Total = table.getn(infotbl) 
	g_TimingPlay_ShowNextIdx = -1
	local ncurpage = 1
	for i = 1, table.getn(infotbl) do		
		local curDay 	= g_TimingPlay_SvtTime
		local opentime  = Lua_GetTeSeServerOpenTime(infotbl[i].FuncID)
		if opentime > curDay then
			g_TimingPlay_ShowNextIdx = i
			g_TimingPlay_CurPage = ncurpage 			 
			return 
		end
		if math.mod(i,g_TimingPlay_PerPageCount) == 0 then
			ncurpage = ncurpage + 1
		end
	end
	if g_TimingPlay_ShowNextIdx == -1 then 
		if math.mod(g_TimingPlay_Total,g_TimingPlay_PerPageCount) == 0 then
			g_TimingPlay_CurPage = math.floor(g_TimingPlay_Total/g_TimingPlay_PerPageCount)
		else
			g_TimingPlay_CurPage = math.floor(g_TimingPlay_Total/g_TimingPlay_PerPageCount) + 1
		end
	end			 
end