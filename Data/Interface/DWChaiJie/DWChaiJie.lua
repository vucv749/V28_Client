--****************************
--µñÎÆ²ğ½â
--****************************
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWChaiJie_Item = -1

local g_DWChaiJie_Frame_UnifiedPosition;

local g_DWChaiJie_Confirmed = 0


--²ğ½âĞÅÏ¢
local g_DWChaiJieInfo={
	[2]={kangxing={28,2},jiankang={84,6},normal={28,2}},
	[3]={kangxing={154,11},jiankang={462,33},normal={154,11}},
	[4]={kangxing={854,61},jiankang={2562,183},normal={854,61}},
	[5]={kangxing={2072,148},jiankang={6216,444},normal={2072,148}},
	[6]={kangxing={4382,313},jiankang={13146,939},normal={4382,313}},
	[7]={kangxing={8358,597},jiankang={25074,1791},normal={8358,597}},
	[8]={kangxing={19712,1408},jiankang={59136,4224},normal={19712,1408}},
	[9]={kangxing={48944,3496},jiankang={146832,10488},normal={48944,3496}},
	[10]={kangxing={87164,6226},jiankang={261492,18678},normal={98924,7066}},
}

--=========================================================
-- ×¢²á´°¿Ú¹ØĞÄµÄËùÓĞÊÂ¼ş
--=========================================================
function DWChaiJie_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWCHAIJIE")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--Ôª±¦
	this:RegisterEvent("UPDATE_YUANBAO");
	--²ğ½âÈ·ÈÏ
	this:RegisterEvent("SURE_DWCHAIJIE");
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function DWChaiJie_OnLoad()
	g_DWChaiJie_Item = -1
	g_DWChaiJie_Confirmed = 0

	g_DWChaiJie_Frame_UnifiedPosition=DWChaiJie_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- ÊÂ¼ş´¦Àí
--=========================================================
function DWChaiJie_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20140612) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u máy chü có v¤n ğ«")
			return
		end
		BeginCareObject_DWChaiJie()
		DWChaiJie_Clear()
		DWChaiJie_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWChaiJie_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWChaiJie_Item == tonumber(arg0)) then
			DWChaiJie_Resume_DWInfo()
		end
	elseif (event == "UPDATE_DWCHAIJIE" and this:IsVisible() ) then
		if arg0 ~= nil then
			DWChaiJie_Update(arg0)
			DWChaiJie_UpdateBasic()
		end
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if (arg0 ~= nil) then
			DWChaiJie_Resume_DWInfo()
			DWChaiJie_UpdateBasic()
		end
	--Å²×§
	elseif (event == "ADJEST_UI_POS" ) then
		DWChaiJie_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWChaiJie_Frame_On_ResetPos()
	--Ôª±¦
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWChaiJie_UpdateBasic()
	elseif (event == "SURE_DWCHAIJIE") then
		g_DWChaiJie_Confirmed = 1
	end
end

--=========================================================
-- ¸üĞÂ»ù±¾ÏÔÊ¾ĞÅÏ¢
--=========================================================
function DWChaiJie_UpdateBasic()
	DWChaiJie_SelfYuanBao:SetText(tostring(Player:GetData("YUANBAO")));
end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function DWChaiJie_Clear()
	if g_DWChaiJie_Item ~= -1 then
		DWChaiJie_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWChaiJie_Item, 0)
		g_DWChaiJie_Item = -1
	end

--	DWChaiJie_UpdateBasic()
	g_DWChaiJie_Confirmed = 0
	DWChaiJie_NeedYuanBao:SetText("")
	DWChaiJie_Quantity:SetText("")
end

--=========================================================
-- ¸üĞÂ½çÃæ
--=========================================================
function DWChaiJie_Update(itemIndex)
	g_DWChaiJie_Confirmed = 0
	local index = tonumber(itemIndex)--????
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñÎªµñÎÆ, Èç¹û²»ÊÇ, Ö±½Óreturn
		local nDiaoWenID,nDiaoWenLevel,nDiaoWenType=LifeAbility:GetDiaowenId(index)--????????
		if nDiaoWenID == -1 then
			PushDebugMessage("#{DWCJJ_140606_11}")
			return
		end
		local jinjieLevel =  LifeAbility:GetDiaowenJinJieLevel(index)
		if jinjieLevel > 0 then
			PushDebugMessage("#{DWJJ_240329_150}")
			return
		end

		-- ÅĞ¶ÏÎïÆ·ÊÇ·ñ¼ÓËø(ÔÚ â¸öÂß¼­Ö®Ç°³ÌĞòÒÑ¾­ÅĞ¶ÏÁË)
		if PlayerPackage:IsLock(index) == 1 then
			PushDebugMessage("#{DWCJJ_140606_12}")
			return
		end
		if not g_DWChaiJieInfo[nDiaoWenLevel] then
			PushDebugMessage("#{DWCJJ_140606_11}")
			return
		end

		-- Èç¹û¿ ¸ñÄÚÒÑ¾­ÓĞÍ¼ÑùÁË, Ìæ»»Ö®
		if g_DWChaiJie_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWChaiJie_Item, 0)
		end
		DWChaiJie_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWChaiJie_Item = index

		if nDiaoWenType==1 then
			DWChaiJie_NeedYuanBao:SetText(g_DWChaiJieInfo[nDiaoWenLevel].normal[1])
			DWChaiJie_Quantity:SetText(g_DWChaiJieInfo[nDiaoWenLevel].normal[2])
		elseif nDiaoWenType==2 then--??
			DWChaiJie_NeedYuanBao:SetText(g_DWChaiJieInfo[nDiaoWenLevel].jiankang[1])
			DWChaiJie_Quantity:SetText(g_DWChaiJieInfo[nDiaoWenLevel].jiankang[2])
		elseif nDiaoWenType==3 then
			DWChaiJie_NeedYuanBao:SetText(g_DWChaiJieInfo[nDiaoWenLevel].kangxing[1])
			DWChaiJie_Quantity:SetText(g_DWChaiJieInfo[nDiaoWenLevel].kangxing[2])
		end
	else
		DWChaiJie_Clear()
	end
end

--=========================================================
-- È¡³ö´°¿ÚÄÚ·ÅÈëµÄÎïÆ·
--=========================================================
function DWChaiJie_Resume_DWInfo()
	if this:IsVisible() then
		DWChaiJie_Clear()
	end
end

--=========================================================
-- È·¶¨Ö´ĞĞ¹¦ÄÜ
--=========================================================
function DWChaiJie_OK_Clicked()
	-- °²È«Ê±¼ä
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{DWCJJ_140606_21}")
	-- 	return
	-- end
	--- ½ÇÉ«µ±Ç°Î´´¦ÓÚÈ«³ÁÃÔ»ò°ë³ÁÃÔ×´Ì¬£»
	-- if IsInFatigueState() <= 0 then
	-- 	PushDebugMessage( "#{GY_120202_33}" )
	-- 	return
	-- end
	-- ¶ş¼¶ÃÜÂë µç»°ÃÜ±£¼ì²é
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	if g_DWChaiJie_Item==-1 then
		PushDebugMessage("#{DWCJJ_140606_13}")
		return
	end
	local nDiaoWenID,nDiaoWenLevel,nDiaoWenType=LifeAbility:GetDiaowenId(g_DWChaiJie_Item)--????????
	if nDiaoWenID == -1 then
		PushDebugMessage("#{DWCJJ_140606_13}")
		return
	end
	-- ÅĞ¶ÏÎïÆ·ÊÇ·ñ¼ÓËø(ÔÚ â¸öÂß¼­Ö®Ç°³ÌĞòÒÑ¾­ÅĞ¶ÏÁË)
	if PlayerPackage:IsLock(g_DWChaiJie_Item) == 1 then
		PushDebugMessage("#{DWCJJ_140606_14}")
		return
	end
	if not g_DWChaiJieInfo[nDiaoWenLevel] then
		PushDebugMessage("#{DWCJJ_140606_11}")
		return
	end
	local needYB=0
	if nDiaoWenType==1 then
		needYB=g_DWChaiJieInfo[nDiaoWenLevel].normal[1]
	elseif nDiaoWenType==2 then--??
		needYB=g_DWChaiJieInfo[nDiaoWenLevel].jiankang[1]
	elseif nDiaoWenType==3 then
		needYB=g_DWChaiJieInfo[nDiaoWenLevel].kangxing[1]
	end
	local nCurYB=tonumber(Player:GetData("YUANBAO"))
	if nCurYB<needYB then
		PushDebugMessage("#{DWCJJ_140606_15}")
		return
	end
--	PushDebugMessage("sure="..g_DWChaiJie_Confirmed)
	if g_DWChaiJie_Confirmed==1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoDiaoWenChaiJie")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_DWChaiJie_Item)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	else
		--Ïû·ÑÉÏÏŞ ±³°ü¿ ¼ä ·şÎñÆ÷¶ËÅĞ¶Ï
		--²ß»®¼á³Ö¶ş´ÎÈ·ÈÏ¿òµÄÎ»ÖÃ£¬Ö»ÄÜ·­À´¸²È¥´«°üÁË
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CheckDiaoWenChaiJie")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_DWChaiJie_Item)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end

end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function DWChaiJie_Close()
	this:Hide()
	return
end

--=========================================================
-- ½çÃæÒş²Ø
--=========================================================
function DWChaiJie_OnHiden()
	StopCareObject_DWChaiJie()
	DWChaiJie_Clear()
	return
end

--=========================================================
-- ¿ªÊ¼¹ØĞÄNPC£¬
-- ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
-- Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_DWChaiJie()
	this:CareObject(g_CaredNpc, 1, "DWChaiJie")
	return
end

--=========================================================
-- Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_DWChaiJie()
	this:CareObject(g_CaredNpc, 0, "DWChaiJie")
	g_CaredNpc = -1
	return
end


function DWChaiJie_Frame_On_ResetPos()
  DWChaiJie_Frame:SetProperty("UnifiedPosition", g_DWChaiJie_Frame_UnifiedPosition);
end

function DWChaiJie_ItemBtnRBClicked()
	DWChaiJie_Resume_DWInfo()
end
