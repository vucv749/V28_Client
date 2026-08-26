
local g_KunWu_Expedition_Result_Frame_UnifiedPosition
local g_KunWu_Expedition_Result_CurItemIndex = 1
local g_KunWu_Expedition_Result_CurTeamIndex = 0
local g_KunWu_Expedition_Result_Exp = 0
local g_KunWu_Expedition_Result_ExpItemId = 39920184
local g_KunWu_Expedition_Result_ItemNum = 0
local g_KunWu_Expedition_Result_PetRequiredTili = 50
local g_KunWu_Expedition_Result_PetIndex = -1
local g_KunWu_Expedition_Result_StartDispatchLevel = 0
function KunWu_Expedition_Result_PreLoad()
	this:RegisterEvent("OPEN_PET_PAIQIAN_RESULT")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("OPEN_PET_PAIQIAN_CANCEL")
end

function KunWu_Expedition_Result_OnLoad()
	g_KunWu_Expedition_Result_Frame_UnifiedPosition = KunWu_Expedition_ResultFrameBK:GetProperty("UnifiedPosition")

end

function KunWu_Expedition_Result_OnEvent(event)
	if event == "VIEW_RESOLUTION_CHANGED" then
		KunWu_Expedition_Result_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		KunWu_Expedition_Result_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		KunWu_Expedition_Result_Close()
	elseif event == "OPEN_PET_PAIQIAN_RESULT" then	
		KunWu_Expedition_Result_FinishImage:Show()
		KunWu_Expedition_Result_ReturnBK:Show()
		KKunWu_Expedition_Result_StopImage:Hide()
		KunWu_Expedition_Result_StopBK:Hide()
		g_KunWu_Expedition_Result_CurItemIndex = tonumber( arg0 )
		g_KunWu_Expedition_Result_CurTeamIndex = tonumber( arg1 )
		g_KunWu_Expedition_Result_Exp = tonumber( arg2 )
		g_KunWu_Expedition_Result_ItemNum = tonumber( arg3 )
		g_KunWu_Expedition_Result_PetIndex = tonumber( arg4 )
		g_KunWu_Expedition_Result_StartDispatchLevel = tonumber( arg5 )
		--PushDebugMessage("StartDispatchLevel:"..tostring(g_KunWu_Expedition_Result_StartDispatchLevel))
		this:Show()
		KunWu_Expedition_Result_Open()
	elseif event == "OPEN_PET_PAIQIAN_CANCEL" then	
		KunWu_Expedition_Result_FinishImage:Hide()
		KunWu_Expedition_Result_ReturnBK:Hide()
		KKunWu_Expedition_Result_StopImage:Show()
		KunWu_Expedition_Result_StopBK:Show()
		KunWu_Expedition_Result_Stop_EXP:SetText(ScriptGlobal_Format("#{ZSPQ_241216_89}",0))
		KunWu_Expedition_Result_CostShow()
		this:Show()
	end
	
end


function KunWu_Expedition_Result_Open()
	local nStatus,nParamIndex, nFinishTime = Pet:Lua_SelectPetDispatchItem(g_KunWu_Expedition_Result_CurItemIndex, g_KunWu_Expedition_Result_CurTeamIndex)

	local nFinishDescDic, nParam1, nParam2, nParam3 = Pet:GetDispatchTaskInfoByParamIndex(nParamIndex,1)
	if nFinishDescDic ~= nil then
		local descStr = "#{"..nFinishDescDic.."}"
		KunWu_Expedition_Result_Return_Story:SetText(ScriptGlobal_Format(descStr,nParam1,nParam2,nParam3))
	end
	KunWu_Expedition_Result_Return_AwardList:Clear()

	if g_KunWu_Expedition_Result_Exp >0 then
		KunWu_Expedition_Result_Return_EXP:Show()
		KunWu_Expedition_Result_Return_EXP:SetText(ScriptGlobal_Format("#{ZSPQ_241216_89}",g_KunWu_Expedition_Result_Exp))
		local theAction = DataPool:CreateBindActionItemForShow(g_KunWu_Expedition_Result_ExpItemId, 1)
		if theAction:GetID() ~= 0 then
			local ItemBar = KunWu_Expedition_Result_Return_AwardList:AddChild("KunWu_Expedition_Result_Return_AwardItemBK")
			ItemBar:GetSubItem("KunWu_Expedition_Result_Return_AwardItem"):SetActionItem(theAction:GetID())
		end
	else
		KunWu_Expedition_Result_Return_EXP:Hide()
	end

	
	for i = 1, g_KunWu_Expedition_Result_ItemNum do
		local nId,nNum = Pet:Lua_EnumPetDispatchRewardInfo(i-1)
		local theAction = DataPool:CreateBindActionItemForShow(nId, nNum)
		if theAction:GetID() ~= 0 then
			local ItemBar = KunWu_Expedition_Result_Return_AwardList:AddChild("KunWu_Expedition_Result_Return_AwardItemBK")
			ItemBar:GetSubItem("KunWu_Expedition_Result_Return_AwardItem"):SetActionItem(theAction:GetID())
		end
	end
	local nType = 1 
	if g_KunWu_Expedition_Result_CurItemIndex > 4 then
		nType = 2
	end
	local needTime = 30*60--Pet:GetDispatchNeedTime(nType,g_KunWu_Expedition_Result_StartDispatchLevel)
	local showmin = math.floor(needTime/60)
	local showsec = math.mod(needTime,60)

	local showhour = math.floor(showmin/60)
	showmin = math.mod(showmin,60)

	local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
	local szPetName = Pet:GetPetList_Appoint(g_KunWu_Expedition_Result_PetIndex)
	KunWu_Expedition_Result_Return_Cost:SetText(ScriptGlobal_Format("#{ZSPQ_241216_186}", nStr, g_KunWu_Expedition_Result_PetRequiredTili))
	KunWu_Expedition_Result_Return_Ending:SetText(ScriptGlobal_Format("#{ZSPQ_241216_127}", szPetName))
end


function KunWu_Expedition_Result_CostShow()
	local nStr = string.format("%02d:%02d:%02d", 0, 0, 0)
	KunWu_Expedition_Result_Stop_Cost:SetText(ScriptGlobal_Format("#{ZSPQ_241216_186}", nStr, g_KunWu_Expedition_Result_PetRequiredTili))
end

function KunWu_Expedition_Result_On_ResetPos()
	KunWu_Expedition_ResultFrameBK:SetProperty("UnifiedPosition", g_KunWu_Expedition_Result_Frame_UnifiedPosition)
end

function KunWu_Expedition_Result_Close()
	this:Hide()
end

function KunWu_Expedition_Result_OnHidden()
	g_KunWu_Expedition_Result_CurItemIndex = 1
	g_KunWu_Expedition_Result_CurTeamIndex = 0
	g_KunWu_Expedition_Result_Exp = 0
	g_KunWu_Expedition_Result_ItemNum = 0
	KunWu_Expedition_Result_Return_AwardList:Clear()
	g_KunWu_Expedition_Result_PetIndex = -1
	g_KunWu_Expedition_Result_StartDispatchLevel = 0
end