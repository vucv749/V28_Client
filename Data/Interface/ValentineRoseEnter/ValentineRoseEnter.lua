----------------------
-- ValentineRoseEnter ---
----------------------

local g_Cooldown = 4*1000		--4s????
local g_InCooldown = 0			--?????

local g_PlayWarning = 10*1000		--10s??????
local g_InPlayWarning = 1			--???????

local g_LevelLimit = 15	--?????????

--===============================================
-- PreLoad()
--===============================================
function ValentineRoseEnter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_TLBB_MAIN")
	this:RegisterEvent("HIDE_THIS_UI")
end

--===============================================
-- OnLoad()
--===============================================
function ValentineRoseEnter_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function ValentineRoseEnter_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89104901) then
		local bFlash = Get_XParam_INT(0)
		ValentineRoseEnter_ShowIcon(bFlash)
	end
	
	if ( event == "HIDE_TLBB_MAIN" ) then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	if event == "HIDE_THIS_UI" then
		if this:IsVisible() then
			this:Hide()
		end
	end
end

--===============================================
-- OnShow()
--===============================================
function ValentineRoseEnter_ShowIcon(bFlash)
	if bFlash == nil then
		return
	end
	
	--关睜界面
	if bFlash == 2 then
		if this:IsVisible() then
			this:Hide()
		end
	elseif bFlash == 0 or bFlash == 1 then--????
		if this:IsVisible() then
			--不处理
		else
			--界面显示
			this:Show()
				
			--闪烁时间判断
			if bFlash == 1 then
				--图标闪烁			
				ValentineRoseEnter_Icon : PlayWarning( 1 )
				--开启tips
				--local fX, fY = this:GetChildOffset("PlayerFrame_SongjincansiButton")
				--OpenFreshManGuide(1, 92, fX + 39, fY + 39, "ValentineRoseEnter", "northeast")
				ValentineRoseEnter_Icon : SetToolTip("")
				--设置闪烁冷却时间
				g_InPlayWarning = 1
				SetTimer("ValentineRoseEnter", "ValentineRoseEnter_g_PlayWarning()",g_PlayWarning)
			end
		end
	end
end

--===============================================
-- OnClick()
--===============================================
function ValentineRoseEnter_OnClick()
	--等级判断
	local nLevel = Player:GetData( "LEVEL" )
	if( nLevel < g_LevelLimit ) then
		PushDebugMessage("#{MGCQ_151230_02}")--?????15?,???????????
		return
	end
	
	--图标闪烁消失			
	ValentineRoseEnter_Icon : PlayWarning( 0 )
	--浮动tips消失
	--if "ValentineRoseEnter" == GetFreshManGuideOwner() then
	--	CloseFreshManGuide()      --当引导ui指向本界面,才需要响应
	--end
	ValentineRoseEnter_Icon : SetToolTip("#{MGCQ_151230_03}")
	
	--判断排行榜窗口是否打开
	if(IsWindowShow("ValentineRoseTopList")) then
		CloseWindow("ValentineRoseTopList", true)
		return
	end
	
	--判断冷却时间
	if g_InCooldown == 0 then--??????
		--请求服务器数据
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ClientAskRoseTopList" )
			Set_XSCRIPT_ScriptID( 891049 )--??????:891049
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		--设置冷却时间
		g_InCooldown = 1
		SetTimer("ValentineRoseEnter", "ValentineRoseEnter_g_Cooldown()",g_Cooldown)
	else--??????
		PushDebugMessage("#{MGCQ_151230_01}")--????????,???????
	end
end

--===============================================
-- 冷却计时结束()
--===============================================
function ValentineRoseEnter_g_Cooldown()
	g_InCooldown = 0
	KillTimer("ValentineRoseEnter_g_Cooldown()")
end

--===============================================
-- 闪烁计时结束()
--===============================================
function ValentineRoseEnter_g_PlayWarning()
	--图标闪烁消失			
	ValentineRoseEnter_Icon : PlayWarning( 0 )
	--浮动tips消失
	--if "ValentineRoseEnter" == GetFreshManGuideOwner() then
	--	CloseFreshManGuide()      --当引导ui指向本界面,才需要响应
	--end
	ValentineRoseEnter_Icon : SetToolTip("#{MGCQ_151230_03}")
	--闪烁计时停止
	g_InPlayWarning = 0
	KillTimer("ValentineRoseEnter_g_PlayWarning()")
end
