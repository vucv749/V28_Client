-- [2022Q3]拉镖周常活动设计
-- 运镖界面

local g_UnifiedXPosition = 0
local g_UnifiedYPosition = 0

-- 倒计时
local g_LeftTime = 0

-- 镖车类型
local g_CarType = 0

-- 镖车数据
local g_CarData = 
{
	[1] = {money = 100000, sname="#{LBZC_220810_68}", dsname="#{LBZC_220810_73}", cname="#{LBZC_220810_78}", 
		tname={{2,"#{LBZC_220810_144}",},{7,"#{LBZC_220810_145}",},{8,"#{LBZC_220810_146}",},{0,"#{LBZC_220810_73}",},}, },
	[2] = {money = 200000, sname="#{LBZC_220810_69}", dsname="#{LBZC_220810_75}", cname="#{LBZC_220810_79}", 
		tname={{2,"#{LBZC_220810_147}",},{24,"#{LBZC_220810_148}",},{26,"#{LBZC_220810_149}",},{27,"#{LBZC_220810_75}",},}, },
	[3] = {money = 400000, sname="#{LBZC_220810_70}", dsname="#{LBZC_220810_74}", cname="#{LBZC_220810_80}", 
		tname={{2,"#{LBZC_220810_150}",},{6,"#{LBZC_220810_151}",},{5,"#{LBZC_220810_152}",},{1,"#{LBZC_220810_74}",},}, },
}

--**********************************
-- PreLoad()
--**********************************
function Labiao_PreLoad()
		this:RegisterEvent("UI_COMMAND")		
		this:RegisterEvent("ADJEST_UI_POS")
		this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

--**********************************
-- OnLoad()
--**********************************
function Labiao_OnLoad()
		g_UnifiedXPosition = Labiao_Frame:GetProperty("UnifiedXPosition")
		g_UnifiedYPosition = Labiao_Frame:GetProperty("UnifiedYPosition")		
		Labiao_MiniOpenClicked()
end

--**********************************
-- ResetPos()
--**********************************
function Labiao_ResetPos()
		Labiao_Frame : SetProperty("UnifiedXPosition", g_UnifiedXPosition)
		Labiao_Frame : SetProperty("UnifiedYPosition", g_UnifiedYPosition)	
end

--**********************************
-- OnEvent()
--**********************************
function Labiao_OnEvent(event)

		if event == "UI_COMMAND" and arg0 == "88816201" then
				if Get_XParam_INT(0) == 1 then-- 打开
						local cartype = tonumber(Get_XParam_INT(1))
						local clientId = tonumber(Get_XParam_INT(2))
						local x = tonumber(Get_XParam_INT(3))
						local z = tonumber(Get_XParam_INT(4))
						local isRobed = tonumber(Get_XParam_INT(5))
						local lefttime = tonumber(Get_XParam_INT(6))
						Labiao_OnShow(cartype, clientId, x, z, isRobed, lefttime)
				elseif Get_XParam_INT(0) == 2 then-- 关闭				
						if this:IsVisible() then
								Labiao_OnClose()
						end						
				end				
		elseif( event == "ADJEST_UI_POS" ) then	
				Labiao_ResetPos()		
		elseif (event == "VIEW_RESOLUTION_CHANGED") then	
				Labiao_ResetPos()
		end
end

--**********************************
-- OnShow()
--**********************************
function Labiao_OnShow(cartype, clientId, x, z, isRobed, lefttime)

		local tCarData = g_CarData[cartype]
		if tCarData == nil then
				return
		end
		
		g_CarType = cartype

		-- 标题
		Labiao_DragTitle:SetText(ScriptGlobal_Format("#{LBZC_220810_62}",tCarData.cname))
		
		-- 起点
		Labiao_Qidian:SetText(ScriptGlobal_Format("#{LBZC_220810_67}",tCarData.sname))
			
		-- 当前目标
		local scenenum = table.getn(tCarData.tname)
		for i=1,scenenum do
			local target = tCarData.tname[i]
			if target~=nil and target[1] == clientId then
				if i == scenenum then
					Labiao_Text7:SetText("#{LBZC_220810_159}")
				else
					Labiao_Text7:SetText("#{LBZC_220810_142}")
				end
				Labiao_Biaoshi:SetText(ScriptGlobal_Format("#{LBZC_220810_143}",target[2]))
			end
		end
		
		-- 超时或已劫镖
		if lefttime <= 0 or isRobed > 0 then
				-- 倒计时
				Labiao_TimeBK:Hide()
				Labiao_Time_OverText:Show()
				if g_CarType == 1 then
					Labiao_Time_OverText:SetText(ScriptGlobal_Format("#{LBZC_220810_160}",tCarData.dsname))
				else
					Labiao_Time_OverText:SetText(ScriptGlobal_Format("#{LBZC_220810_90}",tCarData.dsname))
				end
				KillTimer("Labiao_ShowCountDownProc()")
				-- 收益
				Labiao_Shouyi:SetText("#{LBZC_220810_89}")
				-- 镖车位置
				Labiao_Weizhi:SetText("#{LBZC_220810_161}")
				-- 失败图片
				Labiao_Fail_Null:Show()
		else
				-- 倒计时
				local min = math.floor(lefttime/60)
				local sec = math.mod(lefttime,60)
				local szTime = ""
				if min > 0 then
					szTime = ScriptGlobal_Format("#{LBZC_220810_157}",tonumber(min),tonumber(sec))
				else
					szTime = ScriptGlobal_Format("#{LBZC_220810_158}",tonumber(sec))
				end
				Labiao_Time_OverText:Hide()
				Labiao_TimeBK:Show()
				Labiao_Leave:SetText("#{LBZC_220810_85}"..szTime)
				g_LeftTime = lefttime
				KillTimer("Labiao_ShowCountDownProc()")
				SetTimer("Labiao","Labiao_ShowCountDownProc()", 1000)
				-- 收益
				Labiao_Shouyi:SetText(ScriptGlobal_Format("#{LBZC_220810_82}",tCarData.money))
				-- 镖车位置
				local curname = GetSceneNameByResID(clientId)
				Labiao_Weizhi:SetText(ScriptGlobal_Format("#{LBZC_220810_84}",curname,x,z,clientId))
				-- 失败图片
				Labiao_Fail_Null:Hide()
		end
				
		-- 显示界面					
		this:Show()
		
end

--**********************************
-- 关闭界面
--**********************************
function Labiao_OnClose()
		KillTimer("Labiao_ShowCountDownProc()")
		this:Hide()
end

--**********************************
-- OnHiden()
--**********************************
function Labiao_OnHiden()
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnCloseUI")
			Set_XSCRIPT_ScriptID(888160)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()		
end

function Labiao_ShowCountDownProc()	
	if g_LeftTime <= 0 then
		-- 倒计时
		Labiao_TimeBK:Hide()
		Labiao_Time_OverText:Show()
		if g_CarData[g_CarType] ~= nil then
			if g_CarType == 1 then
				Labiao_Time_OverText:SetText(ScriptGlobal_Format("#{LBZC_220810_160}",g_CarData[g_CarType].dsname))
			else
				Labiao_Time_OverText:SetText(ScriptGlobal_Format("#{LBZC_220810_90}",g_CarData[g_CarType].dsname))
			end
		else
			Labiao_Time_OverText:SetText("")
		end
		KillTimer("Labiao_ShowCountDownProc()")
		-- 收益
		Labiao_Shouyi:SetText("#{LBZC_220810_89}")
		-- 镖车位置
		Labiao_Weizhi:SetText("#{LBZC_220810_161}")
		-- 失败图片
		Labiao_Fail_Null:Show()
		return
	end	
	g_LeftTime = g_LeftTime - 1
	local min = math.floor(g_LeftTime/60)
	local sec = math.mod(g_LeftTime,60)
	local szTime = ""
	if min > 0 then
		szTime = ScriptGlobal_Format("#{LBZC_220810_157}",tonumber(min),tonumber(sec))
	else
		szTime = ScriptGlobal_Format("#{LBZC_220810_158}",tonumber(sec))
	end
	Labiao_Time_OverText:Hide()
	Labiao_TimeBK:Show()
	Labiao_Leave:SetText("#{LBZC_220810_85}"..szTime)
end

--**********************************
-- open()
--**********************************
function Labiao_MiniOpenClicked()

		Labiao_FrameBK:Show()
		Labiao_Down:Show()
		Labiao_Up:Hide()
		
end	

--**********************************
-- close()
--**********************************
function Labiao_MiniCloseClicked()

		Labiao_FrameBK:Hide()
		Labiao_Down:Hide()
		Labiao_Up:Show()
		
end	
