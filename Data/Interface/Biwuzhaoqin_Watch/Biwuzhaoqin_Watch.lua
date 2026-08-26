
--比武招亲

local g_unifiedposistion

local g_StageEnum = {
["free"] = 0,
["waitsponsor"] = 1,
["waitwinner"] = 2,
["waitchallenger"] = 3,
["pk"] = 4,
["1v1over"] = 5,
["finalpkpre"] = 6,
["finalpk"] = 7,
["finalpkover"] = 8,
["gameover"] = 9,
["terminate"] = 10,	--被迫终止
}

local g_dir_type = {
	[1]	= {x=109, z=87, h=400, p=-30},	-- 朝西
	[2]	= {x=81, z=87, h=400, p=-30},		-- 朝东
	[3]	= {x=0, z=0},			-- 主视角
}

function Biwuzhaoqin_Watch_PreLoad()
	this:RegisterEvent("BWZQ_BATTLE_LIVEINFO",false)
	this:RegisterEvent("BWZQ_BATTLE_LIVEINFO_MIN",false)
	this:RegisterEvent("BWZQ_BATTLE_LIVEINFO_BIG",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("CLOSE_BATTLELIVE_WINDOWS",false)
end

function Biwuzhaoqin_Watch_OnLoad()
	g_unifiedposistion	= Biwuzhaoqin_Watch_Frame:GetProperty("UnifiedPosition")
end

function Biwuzhaoqin_Watch_OnEvent(event)
	if event == "BWZQ_BATTLE_LIVEINFO" then
		if (IsWindowShow("Biwuzhaoqin_Watch_Mini")) then
		else
			Biwuzhaoqin_Watch_OnUpdate()
		end
	elseif event == "BWZQ_BATTLE_LIVEINFO_BIG" then
		Biwuzhaoqin_Watch_OnUpdate()
		this:Show()
	elseif event == "BWZQ_BATTLE_LIVEINFO_MIN" then
		this:Hide()
	elseif event == "ADJEST_UI_POS" then
		Biwuzhaoqin_Watch_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Biwuzhaoqin_Watch_ResetPos()
	elseif event == "SCENE_TRANSED" then
		Biwuzhaoqin_Watch_CloseWindow()
	elseif event == "CLOSE_BATTLELIVE_WINDOWS" then
		Biwuzhaoqin_Watch_CloseWindow()
		nIdx = 3
		BWZQ:SetPlayerWatchPosDirection(nIdx,g_dir_type[nIdx].x,g_dir_type[nIdx].z)
	end
end

--================================================
-- 显示信息
--================================================
function Biwuzhaoqin_Watch_OnUpdate()

	local sponsorname,winnername,challengername,status,lefttime,count = BWZQ:LuaFnGetBattleLiveInfo()

	if sponsorname == nil then
		return
	end

	--发起者
	Biwuzhaoqin_Watch_Text3:SetText("#cfff263"..sponsorname)
	if winnername == nil or winnername =="" then
		Biwuzhaoqin_Watch_Text5:SetText("#{BWZQ_20230329_204}")
	else
		Biwuzhaoqin_Watch_Text5:SetText("#cfff263"..winnername)
	end
	if challengername == nil or challengername =="" then
		Biwuzhaoqin_Watch_Text7:SetText("#{BWZQ_20230329_207}")
	else
		Biwuzhaoqin_Watch_Text7:SetText("#cfff263"..challengername)
	end
--	PushDebugMessage("status="..status.." lefttime="..lefttime.." count="..count)
	if lefttime > 0 then
		Biwuzhaoqin_Watch_WatchText:Show()
		Biwuzhaoqin_Watch_WatchText:SetProperty("Timer", lefttime)
	end

	if status == g_StageEnum["waitwinner"] then
		Biwuzhaoqin_Watch_Text4:SetText("#{BWZQ_20230329_365}")
		Biwuzhaoqin_Watch_Text6:SetText("")
	elseif status == g_StageEnum["waitchallenger"] then
		Biwuzhaoqin_Watch_Text4:SetText("#{BWZQ_20230329_362}")
		Biwuzhaoqin_Watch_Text6:SetText("")
	elseif status == g_StageEnum["pk"] then
		Biwuzhaoqin_Watch_Text4:SetText("#{BWZQ_20230329_363}")
		Biwuzhaoqin_Watch_Text6:SetText("")
	elseif status == g_StageEnum["1v1over"] then
		Biwuzhaoqin_Watch_Text4:SetText("#{BWZQ_20230329_364}")
		Biwuzhaoqin_Watch_Text6:SetText("")
	elseif status == g_StageEnum["finalpkpre"] then
		Biwuzhaoqin_Watch_Text4:SetText("#{BWZQ_20230329_366}")
		Biwuzhaoqin_Watch_Text6:SetText("#{BWZQ_20230329_372}")
	elseif status == g_StageEnum["finalpk"] then
		Biwuzhaoqin_Watch_Text4:SetText("#{BWZQ_20230329_366}")
		Biwuzhaoqin_Watch_Text6:SetText("")
	else
		Biwuzhaoqin_Watch_Text4:SetText("")
		Biwuzhaoqin_Watch_Text6:SetText("")
	end

end

function Biwuzhaoqin_Watch_OnTimerEnd()
	Biwuzhaoqin_Watch_WatchText:SetText("00:00")
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_Watch_ResetPos()
	Biwuzhaoqin_Watch_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

--================================================
-- 关闭界面
--================================================
function Biwuzhaoqin_Watch_CloseWindow()
	this:Hide()
	BWZQ:CancelGMWatch()
end

function Biwuzhaoqin_Watch_OnShowTinyUI()
	this:Hide()
	OpenWindow( "Biwuzhaoqin_Watch_Mini" );
end

function Biwuzhaoqin_Watch_CameraClicked(nIdx)
	--1：朝西，2：朝东，3：角色视角
	if nIdx >= 1 and nIdx <= 2 then
		BWZQ:SetPlayerWatchPosDirection(nIdx,g_dir_type[nIdx].x,g_dir_type[nIdx].z,g_dir_type[nIdx].h,g_dir_type[nIdx].p)
		PushEvent("UI_COMMAND", 1000)
	elseif nIdx == 3 then
		BWZQ:SetPlayerWatchPosDirection(nIdx,g_dir_type[nIdx].x,g_dir_type[nIdx].z)
	end
end