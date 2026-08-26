local LuckyRedEnvelope = 1;
local MaxAmount = 0;
local GetAmount = 0;
local OwnerName = "";

local m_nRedenvelopeIndex = 0;
local m_nGuid = 0;
local m_uTime = 0;
local m_nChannel = 0;
local m_nChannelParam = 0;
local ChildList = {};
local m_nDistributeType = 0;

local m_nRecvCount = 0;
local nCount = 0;

function Redenvelope_PreLoad()
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("REDENVELOPE_LOG");
	this:RegisterEvent("REDENVELOPEMSG_CLICK");
end

function Redenvelope_OnLoad()

end

function Redenvelope_OnEvent(event)

	if event == "REDENVELOPEMSG_CLICK" then

		local ret,nIndex,nGuid,uTime,nChannel,nChannelParam,nCurrencyUnit = Lua_GetFirstRedEnvelopeMsg();

		if ret > 0 then
			m_nRedenvelopeIndex = nIndex;
			m_nGuid = nGuid;
			m_uTime = uTime;
			m_nChannel = nChannel;
			m_nChannelParam = nChannelParam;
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("TakeRedEnvelope");
				Set_XSCRIPT_ScriptID(890253);
				Set_XSCRIPT_Parameter(0,m_nRedenvelopeIndex);
				Set_XSCRIPT_Parameter(1,m_nGuid);
				Set_XSCRIPT_Parameter(2,m_uTime);
				Set_XSCRIPT_Parameter(3,m_nChannel);
				Set_XSCRIPT_Parameter(4,m_nChannelParam);
				Set_XSCRIPT_Parameter(5,nCurrencyUnit);
				Set_XSCRIPT_Parameter(6,0);--???????,???????,???
				Set_XSCRIPT_Parameter(7,0);--??????,???????
				Set_XSCRIPT_ParamCount(8);
			Send_XSCRIPT()
		end
		PushEvent("REDENVELOPEMSG_CLOSE")

		--同时打开历史界面
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("QueryRedEnvelope");
			Set_XSCRIPT_ScriptID(890253);
        	Set_XSCRIPT_Parameter(0,2);
        	Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT()

	elseif event == "REDENVELOPE_LOG" then

		GetAmount = tonumber( arg0 );
		m_nRedenvelopeIndex = tonumber( arg1 );
		nCount = tonumber( arg2 );
		m_nRecvCount = tonumber( arg3 );
		local m_nAmount = tonumber( arg4 );
		local m_nRecvAmount = tonumber( arg5 );
		local m_nCurrencyUnit = tonumber( arg6 );
		m_nDistributeType = tonumber( arg7 );
		OwnerName = tostring( arg8 );

		if this:IsVisible() then
			this:Hide();
		end

		if m_nCurrencyUnit == 1 then
			local text = ScriptGlobal_Format("#{HBXTS_221214_110}",m_nRecvCount,nCount,m_nRecvAmount,m_nAmount);
			Redenvelope_Text2:SetText(text);
		else
			local text = ScriptGlobal_Format("#{HBXTS_221214_111}",m_nRecvCount,nCount,m_nRecvAmount,m_nAmount);
			Redenvelope_Text2:SetText(text);
		end

		Redenvelope_Show(m_nCurrencyUnit);

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide();
	end

end

function Redenvelope_Show(currencyUnit)
	Redenvelope_Clear();

	if currencyUnit == 1 then
		local text = ScriptGlobal_Format("#{HBXTS_221214_61}",OwnerName);
		Redenvelope_DragTitle:SetText(text);
	
		if GetAmount > 0 then
			local text = ScriptGlobal_Format("#{HBXTS_221214_62}",GetAmount);
			Redenvelope_Text:SetText(text);
		else
			Redenvelope_Text:SetText("#{HBXTS_221214_63}");
		end

	else
		local text = ScriptGlobal_Format("#{HBXTS_221214_98}",OwnerName);
		Redenvelope_DragTitle:SetText(text);

		if GetAmount > 0 then
			local text = ScriptGlobal_Format("#{HBXTS_221214_99}",GetAmount);
			Redenvelope_Text:SetText(text);
		else
			Redenvelope_Text:SetText("#{HBXTS_221214_63}");
		end
	end

	for i = 1, 100 do
		local ret,nAmount,szCharName = Lua_GetRedEnvelopeLogDataByIndex(i - 1);
		if ret > 0 then
        	local bar = Redenvelope_List:AddChild("Redenvelope_List_Item");
        	if not bar then
            	break
        	end
        	bar:GetSubItem("Redenvelope_List_Name"):SetText(szCharName);

			if currencyUnit == 1 then
				local text = ScriptGlobal_Format("#{HBXTS_221214_66}",nAmount);
				bar:GetSubItem("Redenvelope_List_Money"):SetText(text);
			else
				local text = ScriptGlobal_Format("#{HBXTS_221214_103}",nAmount);
				bar:GetSubItem("Redenvelope_List_Money"):SetText(text);

			end
			bar:GetSubItem("Redenvelope_List_Image"):Hide();
			ChildList[i] = bar;

			if nAmount > MaxAmount and m_nDistributeType == 1 and m_nRecvCount == nCount then
				MaxAmount = nAmount;
				if ChildList[LuckyRedEnvelope] ~= nil then
					ChildList[LuckyRedEnvelope]:GetSubItem("Redenvelope_List_Image"):Hide();
					LuckyRedEnvelope = i;
					ChildList[LuckyRedEnvelope]:GetSubItem("Redenvelope_List_Image"):Show();
				else
					LuckyRedEnvelope = i;
					ChildList[LuckyRedEnvelope]:GetSubItem("Redenvelope_List_Image"):Show();
				end
			end
		end
	end

	this:Show();
end

function Redenvelope_RefreshLogData()
	Redenvelope_Clear();
	for i = 1, 100 do
		local ret,nAmount,szCharName = Lua_GetRedEnvelopeLogDataByIndex(i - 1);
		if ret > 0 then
        	local bar = Redenvelope_List:AddChild("Redenvelope_List_Item");
        	if not bar then
            	break
        	end
        	bar:GetSubItem("Redenvelope_List_Name"):SetText(szCharName);
			bar:GetSubItem("Redenvelope_List_Name"):SetProperty("AlwaysOnTop", "True");
        	bar:GetSubItem("Redenvelope_List_Money"):SetText(tostring(nAmount));
			bar:GetSubItem("Redenvelope_List_Money"):SetProperty("AlwaysOnTop", "True");
			bar:GetSubItem("Redenvelope_List_Image"):Hide();
			ChildList[i] = bar;

			if nAmount > MaxAmount and m_nDistributeType == 1 and m_nRecvCount == nCount then
				MaxAmount = nAmount;
				if ChildList[LuckyRedEnvelope] ~= nil then
					ChildList[LuckyRedEnvelope]:GetSubItem("Redenvelope_List_Image"):Hide();
					LuckyRedEnvelope = i;
					ChildList[LuckyRedEnvelope]:GetSubItem("Redenvelope_List_Image"):Show();
				else
					LuckyRedEnvelope = i;
					ChildList[LuckyRedEnvelope]:GetSubItem("Redenvelope_List_Image"):Show();
				end
			end
		end
	end
end

function Redenvelope_ButtonRefreshOnClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("QueryRedEnvelopeLog");
		Set_XSCRIPT_ScriptID(890253);
		Set_XSCRIPT_Parameter(0,m_nRedenvelopeIndex);
		Set_XSCRIPT_Parameter(1,m_nGuid);
		Set_XSCRIPT_Parameter(2,m_uTime);
		Set_XSCRIPT_Parameter(3,m_nChannel);
		Set_XSCRIPT_Parameter(4,m_nChannelParam);
		Set_XSCRIPT_ParamCount(5);
	Send_XSCRIPT()
end

function Redenvelope_Clear()
	Redenvelope_List:Clear();
    ChildList =  {};
	MaxAmount = 0;
end

function Redenvelope_ButtonCloseOnClicked()
	Redenvelope_Clear()
	m_nRedenvelopeIndex =  0;
	m_nGuid = 0;
	m_uTime = 0;
	m_nChannel = 0;
	m_nChannelParam = 0;
	m_nDistributeType = 0;

	LuckyRedEnvelope = 1;
	MaxAmount = 0;
	GetAmount = 0;
	OwnerName = "";
	
	this:Hide();
end

function Redenvelope_OnHidden()
end
