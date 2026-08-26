--UI COMMAND ID 198122

local g_clientNpcId = -1;

local g_ExchangeMaxBangGong = 200; --可以兑换的帮贡上限
local g_ExchangeMinBangGong = 10;	--可以兑换的帮贡下限

local g_GoldTicket_TabelIndex = 40004517;
local g_Huoyuezhiduixian_Money = 0 -- 今日可兑换金币值
local g_Huoyuezhiduixian_GetMoney = 0 -- 今日已兑换金币值
local g_Huoyuezhiduixian_HuoYueZhi = 0
local g_Huoyuezhiduixian_MoneyInTicket = 0
local g_Huoyuezhiduixian_DuixianMax = 2500000

function Huoyuezhiduixian_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	--this:RegisterEvent("UNIT_GUILDPOINT"); --帮贡界面没有实时刷新机制，人物属性和会员管理界面都没有

end

function Huoyuezhiduixian_OnLoad()
end

function Huoyuezhiduixian_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 198122) then
		if this : IsVisible() then									-- 如果界面开着，则不处理
			return
		end
		
		Huoyuezhiduixian_Clear()
		
		g_Huoyuezhiduixian_GetMoney = Get_XParam_INT(0)
		
		-- 今日活跃值
		g_Huoyuezhiduixian_HuoYueZhi = Get_XParam_INT(1)
		Huoyuezhiduixian_Text3:SetText("#{XHYZ_XML_7}"..tostring(g_Huoyuezhiduixian_HuoYueZhi))

		local npcObjId = Get_XParam_INT(2)
		
		-- 商会金币数量
		g_Huoyuezhiduixian_MoneyInTicket = Get_XParam_INT(3)
		local nPonit = PlayerPackage:GetGoldTickValueByIndex(g_GoldTicket_TabelIndex);
		if nPonit <= 0 then 
			nPonit = g_Huoyuezhiduixian_MoneyInTicket
		end
		Huoyuezhiduixian_Text1:SetText("#{XHYZ_XML_8}".."#{_MONEY"..nPonit.."}")
		
		-- 说明文字
		g_Huoyuezhiduixian_Money = g_Huoyuezhiduixian_DuixianMax - g_Huoyuezhiduixian_GetMoney --g_Huoyuezhiduixian_HuoYueZhi * 10000 / 2 - g_Huoyuezhiduixian_GetMoney
		if g_Huoyuezhiduixian_Money > g_Huoyuezhiduixian_HuoYueZhi * 10000 / 2 then
			g_Huoyuezhiduixian_Money = g_Huoyuezhiduixian_HuoYueZhi * 10000 / 2
		end
		--local str = ScriptGlobal_Format("#{XHYZ_XML_5}", g_Huoyuezhiduixian_HuoYueZhi, g_Huoyuezhiduixian_DuixianMax, g_Huoyuezhiduixian_GetMoney)
		local str = ScriptGlobal_Format("#{XHYZ_XML_5}", g_Huoyuezhiduixian_GetMoney)
		--if g_Huoyuezhiduixian_GetMoney <= 0 then
		--	str = ScriptGlobal_Format("#{XHYZ_XML_9}", g_Huoyuezhiduixian_HuoYueZhi, g_Huoyuezhiduixian_Money)
		--end
		Huoyuezhiduixian_Text4:SetText(str)
		
		OpenWindow("Packet")--打开背包

		this : Show()
		
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("未发现 NPC")
			Huoyuezhiduixian_Close()
			return
		end

		this : CareObject( g_clientNpcId, 1, "Huoyuezhiduixian" )
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			Huoyuezhiduixian_Close()
		end

--	elseif (event == "UNIT_GUILDPOINT" and this:IsVisible()) then
--
--		Huoyuezhiduixian_Moral_Value:SetProperty("DefaultEditBox", "True");
--		Huoyuezhiduixian_Moral_Value:SetSelected( 0, -1 )
--		Huoyuezhiduixian_Text1:SetText("#{BGCH_8901_23}"..tostring(Player:GetData("GUILDPOINT")))

	end

end

function Huoyuezhiduixian_Cancel_Clicked()
	Huoyuezhiduixian_Close()
end

function Huoyuezhiduixian_Clear()

	Huoyuezhiduixian_Moral_Value:SetProperty("DefaultEditBox", "True");
	Huoyuezhiduixian_Moral_Value:SetSelected( 0, -1 )
	Huoyuezhiduixian_Moral_Value:SetText("0")
	Huoyuezhiduixian_Moral_Value2:SetText("0");
	Huoyuezhiduixian_Moral_Value3:SetText("0");
		
end

function Huoyuezhiduixian_Close()
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "Huoyuezhiduixian")
	g_clientNpcId = -1
	Huoyuezhiduixian_Clear()
	
	Huoyuezhiduixian_Moral_Value:SetProperty("DefaultEditBox", "False");
	Huoyuezhiduixian_Moral_Value2:SetProperty("DefaultEditBox", "False");
	Huoyuezhiduixian_Moral_Value3:SetProperty("DefaultEditBox", "False");
end

function Huoyuezhiduixian_Count_Change()
	local str = Huoyuezhiduixian_Moral_Value:GetText()
	local strNumber = 0;

	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end

	str = tostring( strNumber );
	Huoyuezhiduixian_Moral_Value:SetTextOriginal( str );
end

function Huoyuezhiduixian_CheckIfOK(idx)
	local nNum = nil;
	local szErr = nil ;
	local Ctl = nil;
	if(idx == 1)then
		nNum = tonumber(Huoyuezhiduixian_Moral_Value : GetText());
		Ctl = Huoyuezhiduixian_Moral_Value;
		szErr = "";
	elseif(idx == 2) then
		nNum = tonumber(Huoyuezhiduixian_Moral_Value2 : GetText());
		Ctl = Huoyuezhiduixian_Moral_Value2;
		szErr = "只允许输入小于100的值！";
	elseif(idx == 3) then
		nNum = tonumber(Huoyuezhiduixian_Moral_Value3 : GetText());
		Ctl = Huoyuezhiduixian_Moral_Value3;
		szErr = "只允许输入小于100的值！";
	end
	
	if (szErr == nil or Ctl == nil) then
		return
	end
	
	if (nNum == nil) then
		nNum = 0;
	end
	
	nNum = tostring(nNum);
	if(nNum ~= Ctl : GetText())then
		Ctl:SetText(nNum);
	end
end

function Huoyuezhiduixian_ResetSelect(idx)
	if(idx==1) then
		Huoyuezhiduixian_Moral_Value:SetSelected( 0, -1 );
	elseif(idx==2) then
		Huoyuezhiduixian_Moral_Value2:SetSelected( 0, -1 );
	else
		Huoyuezhiduixian_Moral_Value3:SetSelected( 0, -1 );
	end
end

function Huoyuezhiduixian_OK_Clicked()

	local nGlod = tonumber(Huoyuezhiduixian_Moral_Value:GetText());
	local nSilver = tonumber(Huoyuezhiduixian_Moral_Value2:GetText());
	local nCopperCoin = tonumber(Huoyuezhiduixian_Moral_Value3:GetText());
	
	if (nGlod == nil or nSilver == nil or nCopperCoin == nil) then
		PushDebugMessage("#{HYZ_091118_9}")
		return
	end
	
	local bAvailability, nMoney = Bank:GetInputMoney(nGlod, nSilver, nCopperCoin);
	if (bAvailability ~= true or nMoney <= 0) then
		PushDebugMessage("#{HYZ_091118_9}")
		return;
	end

	--if nMoney > g_Huoyuezhiduixian_Money then
		--if g_Huoyuezhiduixian_GetMoney <= 0 then
		--	PushDebugMessage(ScriptGlobal_Format("#{HYZ_091118_20}", g_Huoyuezhiduixian_HuoYueZhi, g_Huoyuezhiduixian_Money))
		--else
	--		PushDebugMessage(ScriptGlobal_Format("#{HYZ_091118_13}", g_Huoyuezhiduixian_HuoYueZhi, g_Huoyuezhiduixian_Money, g_Huoyuezhiduixian_GetMoney))
		--end
	--	return
	--end
	
	local nPonit = PlayerPackage:GetGoldTickValueByIndex(g_GoldTicket_TabelIndex);
	if nPonit <= 0 then 
		nPonit = g_Huoyuezhiduixian_MoneyInTicket
	end

	if nPonit == 0 then
		PushDebugMessage("#{HYZ_091118_10}")
		return
	end
	
	if nMoney > nPonit then
		PushDebugMessage("#{HYZ_091118_15}")
		return
	end

	Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Huoyuezhiduixian" )
			Set_XSCRIPT_ScriptID( 889203 )
			Set_XSCRIPT_Parameter( 0, nMoney )
			Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	Huoyuezhiduixian_Close()
end

--=============================================
--
--=============================================
function Huoyuezhiduixian_Max_Clicked()

	local nPonit = PlayerPackage:GetGoldTickValueByIndex(g_GoldTicket_TabelIndex);
	if nPonit <= 0 then 
		nPonit = g_Huoyuezhiduixian_MoneyInTicket
	end
	local nShow = g_Huoyuezhiduixian_Money 
	if nShow > nPonit then
		nShow = nPonit
	end
	
	local nGlod = math.floor(nShow / 10000)
	local nSilver = math.floor( math.mod(nShow / 100, 100) )
	local nCopperCoin = math.floor( math.mod(nShow, 100) )
	
	Huoyuezhiduixian_Moral_Value:SetProperty("DefaultEditBox", "True");
	Huoyuezhiduixian_Moral_Value:SetSelected( 0, -1 );
	
	Huoyuezhiduixian_Moral_Value:SetText(tostring(nGlod))
	Huoyuezhiduixian_Moral_Value2:SetText(tostring(nSilver));
	Huoyuezhiduixian_Moral_Value3:SetText(tostring(nCopperCoin));
	
end


