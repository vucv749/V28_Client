local Redenvelope_Message_Frame_UnifiedPosition;
local m_NormalButton;

local ReceivedLimit = 20;

local DiFu_Scene_Id = 77; --地府场景ID

local BroadCastStr = 
{
	[0] =
	{	Cipher={[1]="#{HBXTS_221214_49}",[2]="#{HBXTS_221214_83}"},
		NoCipher={[1]="#{HBXTS_221214_48}",[2]="#{HBXTS_221214_82}"}
	},
	[1] =
	{	Cipher={[1]="#{HBXTS_221214_47}",[2]="#{HBXTS_221214_81}"},
		NoCipher={[1]="#{HBXTS_221214_46}",[2]="#{HBXTS_221214_80}"}
	},
	[2] =
	{	Cipher={[1]="#{HBXTS_221214_41}",[2]="#{HBXTS_221214_79}"},
		NoCipher={[1]="#{HBXTS_221214_40}",[2]="#{HBXTS_221214_78}"}
	},

}

local CurrencyUnitImage =
{
	[1] =  {PushedImage = "set:Redenvelope image:Button_Gold_Pushed",NormalImage = "set:Redenvelope image:Button_Gold_Normal",HoverImage = "set:Redenvelope image:Button_Gold_Hover"},
    [2] =  {PushedImage = "set:Redenvelope image:Button_Yuanbao_Pushed",NormalImage = "set:Redenvelope image:Button_Yuanbao_Normal",HoverImage = "set:Redenvelope image:Button_Yuanbao_Hover"},
}


local ChannelImage = 
{
	[0] =  "set:Redenvelope image:Button_World",
	[1] =  "set:Redenvelope image:Button_City",
	[2] =  "set:Redenvelope image:Button_Union",
}

local Animate =
{
	[1] =  "Redenvelope_GoldButton",
	[2] =  "Redenvelope_YuanbaoButton",
}


local CipherStr =
{
	[1] = "齐心协力，共战江湖！",
	[2] = "天龙之内皆兄弟！",
	[3] = "情义撒江湖，千金不贵！",
	[4] = "豪气一掷，好运连来！",
	[5] = "鲜衣怒马，永远少侠！",
	[6] = "愿得一人心，白首不分离",
	[7] = "有此同心结义，江湖何处寂寥？",
	[8] = "良师得璞玉，桃李遇春",
}

function Redenvelope_Message_PreLoad()
	this:RegisterEvent("REDENVELOPEMSG");
	this:RegisterEvent("REDENVELOPEMSG_CLOSE");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
    --玩家切场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
end

function Redenvelope_Message_OnLoad()
	Redenvelope_Message_Frame_UnifiedPosition = Redenvelope_Message_Frame:GetProperty("UnifiedPosition");
	m_NormalButton = Redenvelope_Message_Button_Action1_Mask;
	m_NormalButton:Hide();

end

function Redenvelope_Message_OnEvent(event)

	if event == "REDENVELOPEMSG" then
		local m_szCharName = tostring( arg1 );
		local m_nCipherIndex = tonumber( arg2 );
		local m_nChannel = tonumber( arg3 );
		local m_nCurrencyUnit = tonumber( arg4 );
		local m_RedEnvelopeMD = tonumber( arg5 );

		local tips;
		local text;

		if this:IsVisible() then
			return;
		end

		if DataPool:Lua_IsInTServer() == 1 then
			Redenvelope_Message_HideButton(0);
			return;
		end

		local curSceneID = GetSceneID();
		if (curSceneID == DiFu_Scene_Id) then
			return;
		end

		if m_nCipherIndex > 0 then
			tips = BroadCastStr[m_nChannel].Cipher
			text = ScriptGlobal_Format(tips[m_nCurrencyUnit], m_szCharName,CipherStr[m_nCipherIndex]);
		else
			tips = BroadCastStr[m_nChannel].NoCipher
			text = ScriptGlobal_Format(tips[m_nCurrencyUnit], m_szCharName);
		end

		local nTemp = math.floor(m_RedEnvelopeMD / 1000000);
		local nTakeMoneyCount = math.mod(nTemp, 100);

		local nTemp = math.floor(m_RedEnvelopeMD / 10000);
		local nTakeYuanBaoCount = math.mod(nTemp, 100);

		if nTakeMoneyCount >= ReceivedLimit and m_nCurrencyUnit == 1 then
			Lua_RefreshRedEnvelopeMsgData();
			return;
		end

		if nTakeYuanBaoCount >= ReceivedLimit and m_nCurrencyUnit == 2 then
			Lua_RefreshRedEnvelopeMsgData();
			return;
		end

		PushDebugMessage(text);

		Redenvelope_Message_Button_Action1_Mask:SetProperty("PushedImage",CurrencyUnitImage[m_nCurrencyUnit].PushedImage)
		Redenvelope_Message_Button_Action1_Mask:SetProperty("NormalImage",CurrencyUnitImage[m_nCurrencyUnit].NormalImage)
		Redenvelope_Message_Button_Action1_Mask:SetProperty("HoverImage",CurrencyUnitImage[m_nCurrencyUnit].HoverImage)

		Redenvelope_Message_Button_Action1_Image:SetProperty("Image",ChannelImage[m_nChannel]);

		Redenvelope_Message_Button_Action1_Animate:SetProperty("Animate",Animate[m_nCurrencyUnit]);

		Redenvelope_Message_Show();

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89025303) then
		--原先涉及到提示排队和MD更新,后来不要了,结构不大改了
		Lua_RefreshRedEnvelopeMsgData();
    -- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		Redenvelope_Message_Frame_On_ResetPos();

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Redenvelope_Message_Frame_On_ResetPos();

	elseif (event == "REDENVELOPEMSG_CLOSE") then
		Redenvelope_Message_HideButton(0);
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		Redenvelope_Message_HideButton(0);
	end

end

function Redenvelope_Message_Frame_On_ResetPos()

    Redenvelope_Message_Frame:SetProperty("UnifiedPosition", Redenvelope_Message_Frame_UnifiedPosition);

end

function Redenvelope_Message_Show()

	if not this:IsVisible() then
		m_NormalButton:Show();
		Redenvelope_Message_Button_Action1_Watch:SetProperty("Timer","10");
		this:Show();
	end
end

function Redenvelope_Message_HideButton(hide_type)

	if hide_type == 0 then
		m_NormalButton:Hide();
		Redenvelope_Message_UpdateMD();
	end

	if not m_NormalButton:IsVisible() then
		this:Hide();
	end

end


function Redenvelope_Message_ButtonOnClicked()

	PushEvent("REDENVELOPEMSG_CLICK");

end

function Redenvelope_Message_UpdateMD()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UpdateRedEnvelopeMD")
		Set_XSCRIPT_ScriptID(890253)
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()

end


