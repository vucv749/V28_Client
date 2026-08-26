local objCared = -1;								--关心NPC的Obj的编号（Server传过来）

--UI
local g_CoupleZone_Zhanbu_UI_Animate = ""
local g_CoupleZone_Zhanbu_UI_ActionButton = ""

--UI Editable
local g_CoupleZone_Zhanbu_UI_TitleImg = ""
local g_CoupleZone_Zhanbu_UI_Text = ""


local g_CoupleZone_Zhanbu_UICommand_OpenScry = 99832404
local g_CoupleZone_Zhanbu_UICommand_UpdateRedPoint = 99832403

local g_CoupleZone_Zhanbu_Frame_UnifiedXPosition = 0
local g_CoupleZone_Zhanbu_Frame_UnifiedYPosition = 0

local g_CoupleZone_Zhanbu_IsDebug = 0

local g_CoupleZone_Zhanbu_Info = 
{
	[1] = { tips1 = "#{QLKJ_230331_39}", tips2 = "#{QLKJ_230331_43}", imgset = "set:CoupleZone3 image:Zhanbu_Image1"  },
	[2] = { tips1 = "#{QLKJ_230331_40}", tips2 = "#{QLKJ_230331_44}", imgset = "set:CoupleZone3 image:Zhanbu_Image2"  },
	[3] = { tips1 = "#{QLKJ_230331_41}", tips2 = "#{QLKJ_230331_45}", imgset = "set:CoupleZone3 image:Zhanbu_Image3"  },
	[4] = { tips1 = "#{QLKJ_230331_42}", tips2 = "#{QLKJ_230331_46}", imgset = "set:CoupleZone3 image:Zhanbu_Image4"  },
}

local g_CoupleZone_Zhanbu_Animate_Time = 5*1000  --毫秒

--!!!reloadscript =CoupleZone_Zhanbu

function CoupleZone_Zhanbu_Debug(str)
	if g_CoupleZone_Zhanbu_IsDebug == 1 then
		PushDebugMessage(str)
		Lua_TDU_Log("CoupleZone_Zhanbu_Debug : "..str)
	end
end

function CoupleZone_Zhanbu_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS");	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("UPDATE_COUPLEZONE_SCRY") 
	this:RegisterEvent("UPDATE_COUPLEZONE_REDPOINT")
end

function CoupleZone_Zhanbu_OnLoad()
	
	g_CoupleZone_Zhanbu_Frame_UnifiedXPosition = CoupleZone_Zhanbu_Frame:GetProperty("UnifiedXPosition")
	g_CoupleZone_Zhanbu_Frame_UnifiedYPosition = CoupleZone_Zhanbu_Frame:GetProperty("UnifiedYPosition")	
	
	g_CoupleZone_Zhanbu_UI_TitleImg = CoupleZone_Zhanbu_Result
	g_CoupleZone_Zhanbu_UI_Text = CoupleZone_Zhanbu_Text2
	g_CoupleZone_Zhanbu_UI_Animate = CoupleZone_Zhanbu_Animate
	--g_CoupleZone_Zhanbu_UI_ActionButton = CoupleZone_Zhanbu_Icon

end

function CoupleZone_Zhanbu_OnEvent(event)
	
	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		CoupleZone_Zhanbu_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CoupleZone_Zhanbu_Frame_On_ResetPos()
		--切场景
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		CoupleZone_Zhanbu_OnHidden()
	end	
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_Zhanbu_UICommand_OpenScry) then
		
		local scryResult = Get_XParam_INT( 0 )
		local param = Get_XParam_INT( 1 )
		if param ~= 1 then
			return
		end
		
		local awardShowId =  0
		local awardShowNum =  0
		if scryResult <= 0 or scryResult > table.getn(g_CoupleZone_Zhanbu_Info) then
			return
		end
		---SetTimer("CoupleZone_Zhanbu","CoupleZone_Zhanbu_Animate_Close()", g_CoupleZone_Zhanbu_Animate_Time)
		---CoupleZone_Zhanbu_AnimateShow()
		CoupleZone_Zhanbu_OnShow(scryResult, awardShowId, awardShowNum)
	end
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_Zhanbu_UICommand_UpdateRedPoint) then
		
		
	end	
	
	

	
end

function CoupleZone_Zhanbu_Animate_Close()
    KillTimer("CoupleZone_Zhanbu_Animate_Close()")
    --停止动画
    g_CoupleZone_Zhanbu_UI_Animate:Play(false)
	--g_CoupleZone_Zhanbu_UI_Animate:Hide()
	PushEvent("UPDATE_COUPLEZONE_SCRY")
end

function CoupleZone_Zhanbu_AnimateShow()
	g_CoupleZone_Zhanbu_UI_Animate:Show()
	g_CoupleZone_Zhanbu_UI_Animate:Play(true)
end

function CoupleZone_Zhanbu_OnShow(scryResult, awardShowId, awardShowNum)
	
	CoupleZone_Zhanbu_Debug("CoupleZone_Zhanbu_OnShow")
	
	g_CoupleZone_Zhanbu_UI_TitleImg:SetProperty("Image",g_CoupleZone_Zhanbu_Info[scryResult].imgset)
	g_CoupleZone_Zhanbu_UI_Text:SetText(g_CoupleZone_Zhanbu_Info[scryResult].tips2)

	--local theAction = DataPool:CreateBindActionItemForShow(awardShowId, awardShowNum)
	--if theAction:GetID() ~= 0 then
	--	g_CoupleZone_Zhanbu_UI_ActionButton:SetActionItem(theAction:GetID())
	--	g_CoupleZone_Zhanbu_UI_ActionButton:Show()
	--else
	--	g_CoupleZone_Zhanbu_UI_ActionButton:Hide()
	--end	
	
	this:Show()
end

function CoupleZone_Zhanbu_AskCoupleZone_ZhanbuData()
	CoupleZone_Zhanbu_Debug("CoupleZone_Zhanbu_AskCoupleZone_ZhanbuData")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnAskCoupleZone_ZhanbuData" ); 		-- 函数名
		Set_XSCRIPT_ScriptID( 998324 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1);    					-- 请求类型  1  打开空间主界面前请求
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end


function CoupleZone_Zhanbu_OnClose()
	CoupleZone_Zhanbu_Debug("CoupleZone_Zhanbu_OnClose")
	CoupleZone_Zhanbu_Clear()
	CoupleZone_Zhanbu_OnHidden()
end

function CoupleZone_Zhanbu_Clear()
	CoupleZone_Zhanbu_Debug("CoupleZone_Zhanbu_Clear")
end

function CoupleZone_Zhanbu_OnHidden()
--	CoupleZone_Zhanbu_Debug("CoupleZone_Zhanbu_OnHidden")
	this:Hide()
end



--================================================
-- 恢复界面的默认相对位置
--================================================
function CoupleZone_Zhanbu_Frame_On_ResetPos()
	CoupleZone_Zhanbu_Frame : SetProperty("UnifiedXPosition", g_CoupleZone_Zhanbu_Frame_UnifiedXPosition);
	CoupleZone_Zhanbu_Frame : SetProperty("UnifiedYPosition", g_CoupleZone_Zhanbu_Frame_UnifiedYPosition);
end


--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_CoupleZone_Zhanbu(objCaredId)
	this:CareObject(objCaredId, 1, "CoupleZone_Zhanbu");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_CoupleZone_Zhanbu(objCaredId)
	this:CareObject(objCaredId, 0, "CoupleZone_Zhanbu");
	objCared = -1;
end