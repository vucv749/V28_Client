
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";

local g_NeedClickHide = 0;
local g_FirstShow = 1;
local g_DressSuperToolTip2_Stars

function DressSuperToolTip2_PreLoad()
	this:RegisterEvent("SHOW_DRESS_SUPERTOOLTIP2");
end

function DressSuperToolTip2_OnLoad()
	DressSuperToolTip2_StaticPart_Money:SetClippedByParent(0);
		g_DressSuperToolTip2_Stars={
				DressSuperToolTip2_StaticPart_Star1,
				DressSuperToolTip2_StaticPart_Star2,
				DressSuperToolTip2_StaticPart_Star3,
				DressSuperToolTip2_StaticPart_Star4,
				DressSuperToolTip2_StaticPart_Star5,
				DressSuperToolTip2_StaticPart_Star6,
				DressSuperToolTip2_StaticPart_Star7,
				DressSuperToolTip2_StaticPart_Star8,
				DressSuperToolTip2_StaticPart_Star9,
		};
	for i=1,9 do
		g_DressSuperToolTip2_Stars[i]:Hide();
	end;
	--AxTrace(0, 2, "LoadSuperTooltips");
end										

function DressSuperToolTip2_OnEvent(event)

--	DressSuperToolTip2_StaticPart_Money:Hide();
	if(event == "SHOW_DRESS_SUPERTOOLTIP2") then
		if( arg0 == "1" and SuperTooltips2:IsPresent()) then
			
			SuperTooltips2:SendAskItemInfoMsg();
			DressSuperToolTip2_Update();
			_DressSuperToolTip2_:PositionSelf(0, 0, 1, 1);
			local rH = _DressSuperToolTip2_:GetProperty("AbsoluteHeight");
			DressSuperToolTip2_Frame:SetProperty("AbsoluteHeight", tostring(rH+5.0));

			if(g_FirstShow == 1) then 
				DressSuperToolTip2_Frame:CenterWindow();
				g_FirstShow = 0;
			end
		
			if IsWindowShow("SuperTooltip2") then
				CloseWindow("SuperTooltip2", true)
			end
			
			this:Show();
			return;
		else
			this:Hide();
			return;
		end
	end
	
	this:Hide();	
end

function DressSuperToolTip2_Update()
		g_NeedClickHide = 0;
		-- 先清繝以前显示的文字
		DressSuperToolTip2_ClearText();
		
		if(SuperTooltips2:IsTransferItem()) then
			g_NeedClickHide = 1;
		end
		
		local typeDesc = SuperTooltips2:GetTypeDesc();
		local nGemHoleCounts = SuperTooltips2:GetGemHoleCounts();
		local nMoney1, szMoneyDesc1 = SuperTooltips2:GetMoney1();
		local nMoney2, szMoneyDesc2 = SuperTooltips2:GetMoney2();
		local szPropertys = SuperTooltips2:GetPropertys();
		local szAuthor = SuperTooltips2:GetAuthorInfo();
		local szExplain = SuperTooltips2:GetExplain();
		local nYuanbaotrade = SuperTooltips2:GetYuanbaoTradeFlag();
		local nGoodsProtect = SuperTooltips2:GetGoodsProtect_Goods();
		----------------------------------------------------------------------
		--显示静态头
		local toDisplay = "DressSuperToolTip2_PageHeader";
		
		--加上类型描述
		if( typeDesc ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip2_ShortDesc";
		end
		
		--宝石部分
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0 ) then 
			toDisplay = toDisplay .. ";DressSuperToolTip2_GemPart";
		end
		
		--元宝交易
		if (nYuanbaotrade == 0) then
			toDisplay = toDisplay .. ";DressSuperToolTip2_StaticPart_Yuanbaojiaoyi";
			DressSuperToolTip2_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_87}");
		elseif (nYuanbaotrade == 2) then
			toDisplay = toDisplay .. ";DressSuperToolTip2_StaticPart_Yuanbaojiaoyi";
			DressSuperToolTip2_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_88}");
		end

		--金钱1
		if( nMoney1 ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip2_MoneyPart";
		end

		--金钱2
		if(nMoney2 ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip2_MoneyPart2";
		end
		
		--高级保护
		if nGoodsProtect == 1 then
			toDisplay = toDisplay .. ";DressSuperToolTip2_Protect_Text";
		end

		--属性
		if(szPropertys ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip2_Property";
		end

		--作犨
		if(szAuthor ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip2_Manufacturer_Frame";
		end

		--详细解释
		toDisplay = toDisplay .. ";DressSuperToolTip2_Explain";

		--显示组件内容
		_DressSuperToolTip2_:SetProperty("PageElements", toDisplay);
		
		----------------------------------------------------------------------
		--显示新的内容
		DressSuperToolTip2_StaticPart_Title:SetText(SuperTooltips2:GetTitle());
		DressSuperToolTip2_StaticPart_Item1:SetText(SuperTooltips2:GetDesc1());
		DressSuperToolTip2_StaticPart_Item2:SetText(SuperTooltips2:GetDesc2());
		DressSuperToolTip2_StaticPart_Item3:SetText(SuperTooltips2:GetDesc3());
		--DressSuperToolTip2_StaticPart_Item4:SetText(SuperTooltips2:GetDesc4());
		DressSuperToolTip2_StaticPart_Item4:SetText(SuperTooltips2:GetDesc4());
		local IsProtectd	=SuperTooltips2:GetDesc5();
		
		--SuperTooltip_StaticPart_Item5:SetText(SuperTooltips:GetDesc5());
		DressSuperToolTip2_StaticPart_Icon:SetImage(SuperTooltips2:GetIconName());
		DressSuperToolTip2_ShortDesc_Text:SetText(typeDesc);

		-- 显示雕纹
		local dwIcon = SuperTooltips2:GetDiaowenIcon()
		if (dwIcon ~= nil and dwIcon ~= "") then
			DressSuperToolTip2_StaticPart_DW:Show()
			DressSuperToolTip2_StaticPart_DW:SetProperty("Image", dwIcon)
		end
		
		-- 时装编号显示
		local szFashionNum = SuperTooltips2:GetFashionNumber();
		if (szFashionNum ~= nil and szFashionNum ~= "") then
			DressSuperToolTip2_StaticPart_FashionNum:Show()
			DressSuperToolTip2_StaticPart_FashionNum:SetText(szFashionNum)
		end
		
		-- 编号时装背景显示
		local DressIcon = SuperTooltips2:GetFashionNumberIcon()
		if (DressIcon ~= nil and DressIcon ~= "") then
			DressSuperToolTip2_FashionBK:Show()
			DressSuperToolTip2_FashionBK:SetProperty("Image", DressIcon)
		end
		
		if nGoodsProtect == 1 then
			DressSuperToolTip2_Protect_Text:SetText("#{GDWPBH_090507_4}")
		else
			DressSuperToolTip2_Protect_Text:SetText("")
		end
		
		--tongxi modify 显示星星		
		local qual =SuperTooltips2:GetEquipQual();
		if(type(qual) == "number" and tonumber(qual)>0)then
			local starNum	=	tonumber(qual);
			if(starNum<10) then
				for i=1,starNum do
					--AxTrace( 5,0,StrongLevel.."hehe" );
					if starNum <=4 then
						g_DressSuperToolTip2_Stars[i]:SetProperty("Animate", "Animate_StarNoFlash");
					else
						g_DressSuperToolTip2_Stars[i]:SetProperty("Animate", "Animate_Star");
					end
					g_DressSuperToolTip2_Stars[i]:Show();
				end;
				for i=starNum+1, 9 do
					g_DressSuperToolTip2_Stars[i]:SetProperty("Animate", "Animate_StarDark");
					g_DressSuperToolTip2_Stars[i]:Show();
				end
			end;
		end;
		if(IsProtectd=="1") then
			DressSuperToolTip2_StaticPart_Icon_Protected:Show();
		end;
		--modify end
		
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0) then
			if(nGemHoleCounts > 0) then 
				DressSuperToolTip2_StaticPart_Gem1:Show();
			end
			
			if(nGemHoleCounts > 1) then 
				DressSuperToolTip2_StaticPart_Gem2:Show();
			end
			
			if(nGemHoleCounts > 2) then 
				DressSuperToolTip2_StaticPart_Gem3:Show();
			end
		
			if(nGemHoleCounts > 3) then 
				DressSuperToolTip2_StaticPart_Gem4:Show();
			end
			
			local gemIcon = SuperTooltips2:GetGemIcon1();
			if(gemIcon ~= "") then
				DressSuperToolTip2_StaticPart_Gem1:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon2();
			if(gemIcon ~= "") then
				DressSuperToolTip2_StaticPart_Gem2:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon3();
			if(gemIcon ~= "") then
				DressSuperToolTip2_StaticPart_Gem3:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon4();
			if(gemIcon ~= "") then
				DressSuperToolTip2_StaticPart_Gem4:SetImage(gemIcon);
			end
			
		end
		
		if(nMoney1 ~= nil)  then
			DressSuperToolTip2_StaticPart_Money_Text:SetText(szMoneyDesc1);
			DressSuperToolTip2_StaticPart_Money:SetProperty("MoneyNumber", tostring(nMoney1));
		end
		
		if(nMoney2 ~= nil)  then
			DressSuperToolTip2_StaticPart_Money_Text_2:SetText(szMoneyDesc2);
			DressSuperToolTip2_StaticPart_Money_2:SetProperty("MoneyNumber", tostring(nMoney2));
		end
		
		if( szPropertys ~= nil) then
			DressSuperToolTip2_Property:SetText(szPropertys);
		end
		
		if(szAuthor ~= nil) then
			DressSuperToolTip2_Manufacturer:SetText(szAuthor);
		end

		DressSuperToolTip2_Explain:SetText(szExplain);
		
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清繝显示文本
--
function DressSuperToolTip2_ClearText()
		DressSuperToolTip2_StaticPart_Title:SetText("");
		DressSuperToolTip2_StaticPart_Item1:SetText("");
		DressSuperToolTip2_StaticPart_Item2:SetText("");
		DressSuperToolTip2_StaticPart_Item3:SetText("");
		DressSuperToolTip2_StaticPart_Item4:SetText("");
		DressSuperToolTip2_StaticPart_DW:SetImage("")
		DressSuperToolTip2_StaticPart_DW:Hide()
		DressSuperToolTip2_StaticPart_FashionNum:Hide()
		DressSuperToolTip2_StaticPart_FashionNum:SetText("");
		DressSuperToolTip2_FashionBK:SetImage("")
		DressSuperToolTip2_FashionBK:Hide()
		DressSuperToolTip2_Protect_Text:SetText("");
		DressSuperToolTip2_StaticPart_Gem1:SetImage("");
		DressSuperToolTip2_StaticPart_Gem2:SetImage("");
		DressSuperToolTip2_StaticPart_Gem3:SetImage("");
		DressSuperToolTip2_StaticPart_Gem4:SetImage("");
		DressSuperToolTip2_StaticPart_Gem1:Hide()
		DressSuperToolTip2_StaticPart_Gem2:Hide();
		DressSuperToolTip2_StaticPart_Gem3:Hide();
		DressSuperToolTip2_StaticPart_Gem4:Hide();
		
		DressSuperToolTip2_Explain:SetText("");
		DressSuperToolTip2_Property:SetText("");
		DressSuperToolTip2_Manufacturer:SetText("");
		DressSuperToolTip2_StaticPart_Icon_Protected:Hide();
		local starNum=9
		for i=1,starNum do
			g_DressSuperToolTip2_Stars[i]:Hide();
		end;
end

function DressSuperToolTip2_LClick()
	if( 1 == g_NeedClickHide and this:IsVisible()) then
		g_NeedClickHide = 0;
		this:Hide();
	end
end
