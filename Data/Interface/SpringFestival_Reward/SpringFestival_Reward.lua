--******************************
--打工兔
--******************************
local SpringFestival_Reward_Frame_UnifiedPosition;
local SFR_ClientNpcId = -1
local SFR_TitleCtrl = {}
local SFR_TitleRange = {
{0,3},{4,4},{5,7},{8,999999}
}
local SFR_GetImageCtrl = {}
local SFR_CUM_TipCtrl = {}
local SFR_ProcessCtrl
local SFR_LeiJiZhiMax = 8
local SFR_LeiJiZhiRange = {2,4,5,8}

function SpringFestival_Reward_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	--玩家切场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function SpringFestival_Reward_OnLoad()
	SpringFestival_Reward_Frame_UnifiedPosition = SpringFestival_RewardFrame:GetProperty("UnifiedPosition");
	SFR_TitleCtrl = {
		SpringFestival_Reward_Title1,
		SpringFestival_Reward_Title2, 
		SpringFestival_Reward_Title3, 
		SpringFestival_Reward_Title4
	}
	SFR_GetImageCtrl ={
		SpringFestival_Reward_CUM1BtnOK,
		SpringFestival_Reward_CUM2BtnOK,
		SpringFestival_Reward_CUM3BtnOK,
		SpringFestival_Reward_CUM4BtnOK
	}

	SFR_CUM_TipCtrl = {
		SpringFestival_Reward_CUM1_tips,
		SpringFestival_Reward_CUM2_tips,
		SpringFestival_Reward_CUM3_tips,
		SpringFestival_Reward_CUM4_tips
	}
	SFR_ProcessCtrl = SpringFestival_Reward_Progress
end

function SpringFestival_Reward_OnEvent(event)
  if ( event == "UI_COMMAND" and tonumber(arg0) == 81011501) then
  	local clientNpcId = Get_XParam_INT(0)
  	if clientNpcId >= 0 then
  		SFR_ClientNpcId = clientNpcId
			local objId = DataPool : GetNPCIDByServerID(SFR_ClientNpcId)
			if objId == -1 then
				return
			end
			this : CareObject( objId, 1, "SpringFestival_Reward" )
			this : Show()
			local leijizhivalue = Get_XParam_INT(1)
			local mflist = Get_XParam_INT(2)
			local bBaoJi = Get_XParam_INT(3)
			SpringFestival_Reward_Update(leijizhivalue, mflist)
			if bBaoJi~= nil and bBaoJi == 1 then
				SpringFestival_Reward_CUM_Animate:Show()
				SpringFestival_Reward_CUM_Animate:Play(true)
			else
				SpringFestival_Reward_CUM_Animate:Hide()
				SpringFestival_Reward_CUM_Animate:Play(false)
			end
		elseif clientNpcId == -2 then
			local leijizhivalue = Get_XParam_INT(1)
			local mflist = Get_XParam_INT(2)
			SpringFestival_Reward_Update(leijizhivalue, mflist)
		else
			this:Hide()
  	end
  elseif event=="HIDE_ON_SCENE_TRANSED"  then
  	SpringFestival_Reward_CloseUI()
  elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
  	SpringFestival_Reward_Frame_On_ResetPos()
  end

end

function SpringFestival_Reward_CloseUI()
	this:Hide()
end

function SpringFestival_RewardOnHiden()
	SpringFestival_Reward_CloseUI()
end
function SpringFestival_Reward_Frame_On_ResetPos()
	SpringFestival_RewardFrame:SetProperty("UnifiedPosition", SpringFestival_Reward_Frame_UnifiedPosition);
end

function SpringFestival_Reward_Update(leijizhivalue, mflist)
	local mfs = {0,0,0,0}
	for i=1,4 do
		mfs[i] = math.mod(mflist,10)
		mflist = math.floor(mflist/10)
	end

	for i=1,4 do
		if mfs[i] == 1 then
			SFR_GetImageCtrl[i]:Show()
		else
			SFR_GetImageCtrl[i]:Hide()
		end
	end

	if leijizhivalue > SFR_LeiJiZhiMax then
		leijizhivalue = SFR_LeiJiZhiMax
	end
	SpringFestival_Reward_CUMText:SetText( ScriptGlobal_Format( "#{CJDG_221110_100}", leijizhivalue) )

	for i=1,4 do
		if leijizhivalue >= SFR_LeiJiZhiRange[i] and mfs[i] == 0 then
			SFR_CUM_TipCtrl[i]:Show()
		else
			SFR_CUM_TipCtrl[i]:Hide()
		end
	end

	SFR_ProcessCtrl:SetProgress(tonumber(leijizhivalue), SFR_LeiJiZhiMax)
	for i=1,4 do
		SFR_TitleCtrl[i]:Hide()
	end
	for i=1,4 do
		if leijizhivalue >= SFR_TitleRange[i][1] and leijizhivalue <= SFR_TitleRange[i][2] then
			SFR_TitleCtrl[i]:Show()
			break;
		end
	end
end

function SpringFestival_Reward_OnRewardClick(nIdx)
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnGetLeiJiJiangLi")
		Set_XSCRIPT_ScriptID(810115);
		Set_XSCRIPT_Parameter(0,SFR_ClientNpcId);
		Set_XSCRIPT_Parameter(1,nIdx);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end
