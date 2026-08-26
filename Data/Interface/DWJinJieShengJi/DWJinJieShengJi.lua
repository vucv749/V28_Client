--½ø½×ºóµÄµñÎÆÉý¼¶
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_ServerObj = -1

local g_DWJinJieShengJi_Item = -1--???????,???????
local g_DWJinJieShengJi_GRID_SKIP = 182 --	G183 todo
local g_DWJinJieShengJi_Frame_UnifiedPosition;
local g_DWJinJieShengJi_TargetLevel = 0

--local g_UICOMMAND = 89030502
local g_curJinJieLevel = 0

local g_levelNames = {
	"#{DWJJ_240329_260}","#{DWJJ_240329_261}","#{DWJJ_240329_262}","#{DWJJ_240329_263}","#{DWJJ_240329_264}","#{DWJJ_240329_265}","#{DWJJ_240329_266}","#{DWJJ_240329_267}","#{DWJJ_240329_268}","#{DWJJ_240329_269}",
	"#{DWJJ_240329_270}","#{DWJJ_240329_271}","#{DWJJ_240329_272}","#{DWJJ_240329_273}","#{DWJJ_240329_274}","#{DWJJ_240329_275}","#{DWJJ_240329_276}","#{DWJJ_240329_277}","#{DWJJ_240329_278}","#{DWJJ_240329_279}",
	"#{DWJJ_240329_280}","#{DWJJ_240329_281}","#{DWJJ_240329_282}","#{DWJJ_240329_283}","#{DWJJ_240329_284}","#{DWJJ_240329_285}","#{DWJJ_240329_286}","#{DWJJ_240329_287}","#{DWJJ_240329_288}","#{DWJJ_240329_289}",
	"#{DWJJ_240329_290}","#{DWJJ_240329_291}","#{DWJJ_240329_292}","#{DWJJ_240329_293}","#{DWJJ_240329_294}","#{DWJJ_240329_295}","#{DWJJ_240329_296}","#{DWJJ_240329_297}","#{DWJJ_240329_298}","#{DWJJ_240329_299}",
	"#{DWJJ_240329_300}","#{DWJJ_240329_301}","#{DWJJ_240329_302}","#{DWJJ_240329_303}","#{DWJJ_240329_304}","#{DWJJ_240329_305}","#{DWJJ_240329_306}","#{DWJJ_240329_307}","#{DWJJ_240329_308}","#{DWJJ_240329_309}",
}

-- ÖÁ×ð½ð²ÏË¿
local g_DWQIANGHUA_ToolItem = 20310174

local g_LCS2JCS = 5
--=========================================================
-- ×¢²á´°¿Ú¹ØÐÄµÄËùÓÐÊÂ¼þ
--=========================================================
function DWJinJieShengJi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWJinJieShengJi")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("RESUME_ENCHASE_GEM",false)
	this:RegisterEvent("DWJINJIESHENGJI_UI_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	--Ôª±¦
	this:RegisterEvent("UPDATE_YUANBAO",false);
	this:RegisterEvent("UPDATE_BIND_YUANBAO",false);
	--°ó¶¨È·ÈÏ
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function DWJinJieShengJi_OnLoad()
	g_DWJinJieShengJi_Item = -1
	g_DWJinJieShengJi_Frame_UnifiedPosition=DWJinJieShengJi_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- ÊÂ¼þ´¦Àí
--=========================================================
function DWJinJieShengJi_OnEvent(event)

	-- if (event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND) then
	-- 	local xx = Get_XParam_INT(0)
	-- 	g_ServerObj = xx
	-- 	g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
	-- 	if g_CaredNpc == -1 then
	-- 		return
	-- 	end
	-- 	BeginCareObject_DWJinJieShengJi()
	-- 	DWJinJieShengJi_Clear()
	-- 	DWJinJieShengJi_UpdateBasic()
	-- 	this:Show()
	-- elseif (event == "DWJINJIESHENGJI_UI_CHANGE" and tonumber(arg0) == 1) then
	if (event == "DWJINJIESHENGJI_UI_CHANGE" and tonumber(arg0) == 2) then
		local xx = tonumber(arg1)
		g_ServerObj = xx
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			return
		end
		BeginCareObject_DWJinJieShengJi()
		DWJinJieShengJi_Clear()
		DWJinJieShengJi_UpdateBasic()
		--µ÷ û½çÃæÎ»ÖÃ
		if tostring(arg2) ~= nil then
			DWJinJieShengJi_Frame:SetProperty("UnifiedPosition", tostring(arg2));
		end
		this:Show()
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWJinJieShengJi_Item == tonumber(arg0)) then
			--DWJinJieShengJi_Resume_DWInfo()
			DWJinJieShengJi_Update(tonumber(arg0),0)
		end
		DWJinJieShengJi_UpdateBasic()
	elseif (event == "UPDATE_DWJinJieShengJi") then
		if arg0 ~= nil then
			DWJinJieShengJi_Update(arg0,1)
			DWJinJieShengJi_UpdateBasic()
		end
	elseif (event == "RESUME_ENCHASE_GEM") then
		if (arg0 ~= nil) then
			DWJinJieShengJi_Resume_DWInfo()
			DWJinJieShengJi_UpdateBasic()
		end
	--Å²×§
	elseif (event == "ADJEST_UI_POS" ) then
		DWJinJieShengJi_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWJinJieShengJi_Frame_On_ResetPos()
	--Ôª±¦
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWJinJieShengJi_UpdateBasic()
	elseif (event == "UPDATE_BIND_YUANBAO" and this:IsVisible()) then
		DWJinJieShengJi_UpdateBasic()

	end
end

--=========================================================
-- ¸üÐÂ»ù±¾ÏÔÊ¾ÐÅÏ¢
--=========================================================
function DWJinJieShengJi_UpdateBasic()
	--ÓµÓÐ°ó¶¨Ôª±¦
	--DWJinJieShengJi_Bangdingyuangbao_Text:SetText(tostring(Player:GetData("BIND_YUANBAO")));
	--ÓµÓÐÔª±¦
	DWJinJieShengJi_Yuanbao_Text:SetText(tostring(Player:GetData("YUANBAO")));
	--±³°üÄÚÎ´Ëø¶¨µÄ½ð²ÏË¿
	local toolNumInBag =  PlayerPackage:CountAvailableItemByIDTable(tonumber(g_DWQIANGHUA_ToolItem))
	DWJinJieShengJi_JCSown_Text:SetText(tostring(toolNumInBag))
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWJinJieShengJi_Clear()
	if g_DWJinJieShengJi_Item ~= -1 then
		DWJinJieShengJi_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWJinJieShengJi_Item, 0)
		g_DWJinJieShengJi_Item = -1
	end
	g_DWJinJieShengJi_TargetLevel = 0
	g_curJinJieLevel = 0
	--ÐèÒªµÄ½ð²ÏË¿ÊýÁ¿
	DWJinJieShengJi_JCSneed_Text:SetText("")
	DWJinJieShengJi_OK:Disable()


	DWJinJieShengJi_Type1_name:SetText("#{DWSJ_141202_51}")
	DWJinJieShengJi_Type1_Level:ResetList()
	DWJinJieShengJi_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--????
	DWJinJieShengJi_Type1_Level:SetCurrentSelect(0);
	DWJinJieShengJi_Type1_Info:SetText("")
	--°´Å¥ÏÔÊ¾
	DWJinJieShengJi_Type1_Leveltip:Show()
end

--=========================================================
-- ¸üÐÂ½çÃæ
--=========================================================
function DWJinJieShengJi_Update(itemIndex) 
	local index = tonumber(itemIndex)--????
	local theAction = EnumAction(index, "packageitem")
	if theAction:GetID() ~= 0 then
		--ÊÇ·ñÎªÊ´¿ÌÁËµñÎÆµÄ×°±¸
		local ret = LifeAbility:CanEquipDiaowen_JinJieShengJi(index)
		if ret == -1 then
			-- ·Ç×°±¸
			PushDebugMessage("#{DWJJ_240329_41}")
			return
		end
		if ret == -2 then
			-- ²»ÊÇÒ»¸öÒÑ¾­Ê´¿ÌÁËµñÎÆµÄ×°±¸
			PushDebugMessage("#{DWJJ_240329_41}")
			return
		end
		if ret == -3 then
			--Î´¿ªÆô½ø½×
			PushDebugMessage("#{DWJJ_240329_42}")
			return
		end
		-- if ret == -4 then
		-- 	--Âú¼¶
		-- 	return
		-- end
		--²»¼ì²â¼ÓËø

		-- Èç¹û¿ ¸ñÄÚÒÑ¾­ÓÐÍ¼ÑùÁË, Ìæ»»Ö®
		if g_DWJinJieShengJi_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWJinJieShengJi_Item, 0)
		end

		DWJinJieShengJi_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWJinJieShengJi_Item = index

		g_curJinJieLevel =  LifeAbility:GetDiaowenJinJieLevel(index)
		if g_curJinJieLevel < 1 then
			--Î´¿ªÆô½ø½×
			PushDebugMessage("#{DWJJ_240329_42}")
			return
		end
		--µñÎÆµÄµ±Ç°µÈ¼¶
		local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(g_DWJinJieShengJi_Item)
		local maxjinjieLevel =  LifeAbility:GetDiaowenJinJieShengJiMaxLevel()
		if not maxjinjieLevel then
			return 
		end
		local maxcandolevel = dwlevel*5+4
		DWJinJieShengJi_Type1_Leveltip:Hide()
		--¸üÐÂÂÒÆß°ËÔãµÄ¶«Î÷
		local msg1,msg2= LifeAbility:GetEquipDiaowen_AttrName(g_DWJinJieShengJi_Item)
		--Ãû³Æand so on
		if msg1~="" then
			--µ¥ÊôÐÔµñÎÆ
			local strname1 = ScriptGlobal_Format("#{DWSJ_141202_57}",msg1)
			DWJinJieShengJi_Type1_name:SetText(strname1)--"#cfff263"..
			--level
			if g_curJinJieLevel<=0 then return end;
			if g_curJinJieLevel==maxjinjieLevel then
				DWJinJieShengJi_Type1_Level:ResetList()
				DWJinJieShengJi_Type1_Level:AddTextItem("Dî Mãn C¤p" ,0)--?????
				DWJinJieShengJi_Type1_Level:SetCurrentSelect(0);
			else
				DWJinJieShengJi_Type1_Level:ResetList()
				DWJinJieShengJi_Type1_Level:AddTextItem("#{DWJJ_240329_164}" ,0)--????
				local idx = 1
				for i=g_curJinJieLevel+1,g_curJinJieLevel+10 do
					if i <= maxjinjieLevel and i <= maxcandolevel then
						DWJinJieShengJi_Type1_Level:AddTextItem(g_levelNames[i]
						 ,idx)
						idx = idx + 1
					else
						if dwlevel < 10 then
							DWJinJieShengJi_Type1_Level:AddTextItem("#{DWJJ_240329_248}",-1)
						end
						break
					end
				end
				DWJinJieShengJi_Type1_Level:SetCurrentSelect(0);
			end
			DWJinJieShengJi_Type1_Info:SetText("")
		end
		g_DWJinJieShengJi_TargetLevel = 0
		DWJinJieShengJi_JCSneed_Text:SetText("")
		DWJinJieShengJi_Type1_Leveltip:Enable()
		DWJinJieShengJi_OK:Enable()
	else
		DWJinJieShengJi_Clear()
	end
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWJinJieShengJi_Resume_DWInfo()
	if this:IsVisible() then
		DWJinJieShengJi_Clear()
	end
end

--=========================================================
-- È·¶¨Ö´ÐÐ¹¦ÄÜ
--=========================================================
function DWJinJieShengJi_OK_Clicked()
	-- °²È«Ê±¼ä
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{DWSJ_141202_20}")
		return
	end
--	--- ½ÇÉ«µ±Ç°Î´´¦ÓÚÈ«³ÁÃÔ»ò°ë³ÁÃÔ×´Ì¬£»
--	if IsInFatigueState() <= 0 then
--		PushDebugMessage( "#{GY_120202_33}" )
--		return
--	end
	-- ¶þ¼¶ÃÜÂë µç»°ÃÜ±£¼ì²é
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	if g_DWJinJieShengJi_Item==-1 then
		PushDebugMessage("#{DWJJ_240329_57}")
		return
	end

	local ret = LifeAbility:CanEquipDiaowen_JinJieShengJi(g_DWJinJieShengJi_Item)
	if ret == -1 then
		-- ·Ç×°±¸
		PushDebugMessage("#{DWJJ_240329_57}")
		return
	end
	if ret == -2 then
		-- ²»ÊÇÒ»¸öÒÑ¾­Ê´¿ÌÁËµñÎÆµÄ×°±¸
		PushDebugMessage("#{DWJJ_240329_57}")
		return
	end
	if ret == -3 then
		--Î´¿ªÆô½ø½×
		PushDebugMessage("#{DWJJ_240329_42}")
		return
	end
	if ret == -4 then
		--Âú¼¶
		PushDebugMessage("#{DWJJ_240329_58}")
		return
	end
	local curJinJieLevel =  LifeAbility:GetDiaowenJinJieLevel(g_DWJinJieShengJi_Item)
	if curJinJieLevel < 1 then
		--Î´¿ªÆô½ø½×
		--PushDebugMessage("#{DWJJ_240329_42}")
		return
	end
	if g_DWJinJieShengJi_TargetLevel < 1 then
		PushDebugMessage("#{DWJJ_240329_199}")
		return
	end
	if g_DWJinJieShengJi_TargetLevel <= curJinJieLevel  then
		PushDebugMessage("#{DWJJ_240329_199}")
		return
	end
	local diaowenID,dianwenLevel = LifeAbility:GetEquitDiaowenID(g_DWJinJieShengJi_Item)
	if curJinJieLevel >= dianwenLevel*5+4 then
		PushDebugMessage("#{DWJJ_240329_60}")
		return
	end

	--ÊÇ·ñÑ¡ÔñÁË°ó¶¨Ôª±¦/Ôª±¦Ö§¸¶È·ÈÏ
	local SelectOK= string.lower( DWJinJieShengJi_cost:GetProperty("Selected") )
	local confirmed = 0
	if SelectOK=="true" then
		confirmed = 0
	else
		confirmed = 1
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoDiaowenJinJieShengJi")
		Set_XSCRIPT_ScriptID(809272)
		Set_XSCRIPT_Parameter(0, g_ServerObj)
		Set_XSCRIPT_Parameter(1, g_DWJinJieShengJi_Item)
		Set_XSCRIPT_Parameter(2, confirmed) 
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_Parameter(4, g_DWJinJieShengJi_TargetLevel)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()

end
function DWJinJieShengJi_Type1_Changed()
	if g_DWJinJieShengJi_Item == -1 then
		return 
	end
	local sToLevelSel,iToLevelSel =  DWJinJieShengJi_Type1_Level:GetCurrentSelect()
	if iToLevelSel < 1 then
		DWJinJieShengJi_JCSneed_Text:SetText("")
		DWJinJieShengJi_Type1_Info:SetText("")
		g_DWJinJieShengJi_TargetLevel = 0
		return 
	end
	g_DWJinJieShengJi_TargetLevel = iToLevelSel+g_curJinJieLevel
	--¼ÆËãÐèÒªµÄ½ð²ÏË¿
	local totalNeedJCS,curLvExp = LifeAbility:GetDiaowenJinJieShengJiNeedJCSNum(g_DWJinJieShengJi_Item,g_DWJinJieShengJi_TargetLevel)
	local requireJCS = totalNeedJCS - curLvExp
	if requireJCS < curLvExp then
		return 
	end
	local requireZZJCS = math.ceil(requireJCS/g_LCS2JCS)
	DWJinJieShengJi_JCSneed_Text:SetText(requireZZJCS)
	--ÏÔÊ¾Éý¼¶ºóµÄÊôÐÔ¼Ó³É
	local attradd = LifeAbility:GetDiaowenJinJieAttrAdd(g_DWJinJieShengJi_Item,g_DWJinJieShengJi_TargetLevel)
	local msg1,msg2= LifeAbility:GetEquipDiaowen_AttrName(g_DWJinJieShengJi_Item)
	if attradd > 0  then
		local str = ScriptGlobal_Format("#{DWSJ_141202_59}",msg1,attradd)
		DWJinJieShengJi_Type1_Info:SetText(str)
	else
		DWJinJieShengJi_Type1_Info:SetText("")
	end
	
end



--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function DWJinJieShengJi_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒþ²Ø
--=========================================================
function DWJinJieShengJi_OnHiden()
	StopCareObject_DWJinJieShengJi()
	DWJinJieShengJi_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØÐÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
-- Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_DWJinJieShengJi()
	this:CareObject(g_CaredNpc, 1, "DWJinJieShengJi")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_DWJinJieShengJi()
	this:CareObject(g_CaredNpc, 0, "DWJinJieShengJi")
	g_CaredNpc = -1
	return
end


function DWJinJieShengJi_Frame_On_ResetPos()
  DWJinJieShengJi_Frame:SetProperty("UnifiedPosition", g_DWJinJieShengJi_Frame_UnifiedPosition);
end

function DWJinJieShengJi_ItemBtnRBClicked()
	DWJinJieShengJi_Resume_DWInfo()
end

function DWJinJieShengJi_ChangeTabIndex()
	--²ÎÊý2:1-Ç¿»¯¡¢2-Éý¼¶
	PushEvent("DWJINJIESHENGJI_UI_CHANGE", 1,g_ServerObj,DWJinJieShengJi_Frame:GetProperty("UnifiedPosition"))
	DWJinJieQianghua_Close()
end

function DWJinJieShengJi_Type1_Leveltip_Click()
	if g_DWJinJieShengJi_Item == -1 then
		PushDebugMessage("#{DWJJ_240329_57}")
		return
	end
end
