local CU_MONEY			= 1	-- 钱
local CU_GOODBAD		= 2	-- 善恶值
local CU_MORALPOINT	= 3	-- 师德点
local CU_TICKET			= 4 -- 官票钱
local CU_YUANBAO		= 5	-- 元宝
local CU_ZENGDIAN		= 6 -- 赠点
local CU_MENPAI_POINT	= 7 -- 师门贡献度
local CU_MONEYJZ		= 8 -- 交子
local CU_BIND_YUANBAO	= 9 -- 绑定元宝
local CU_GIFTTOKEN	= 10 -- 返券

local g_pos1;
local g_pos2;
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";
local g_DressSuperToolTip_Stars;		

local g_nUnlockingTimeNeeded = 259200;

function DressSuperToolTip_GetUnlockingStr ( nUnlockElapsedTime )
	local nLeftTime = g_nUnlockingTimeNeeded - nUnlockElapsedTime;
	local strLeftTime = "";
		
	if( nLeftTime <= 0 ) then
		strLeftTime = "解锁成功！请重新登录或切换场景正式解锁。";
	else
		nLeftTime = math.ceil( nLeftTime/3600 );
		if( nLeftTime >= 24 ) then
			strLeftTime = ""..math.floor(nLeftTime/24).." 天";
			nLeftTime = math.mod(nLeftTime,24);
		end
		if( nLeftTime > 0 ) then 
			strLeftTime = strLeftTime.." "..nLeftTime.." 小时";					
		end
		
		strLeftTime = strLeftTime.."后正式解锁";
	end
	
	return strLeftTime;
end

function DressSuperToolTip_PreLoad()

	this:RegisterEvent("SHOW_DRESS_SUPERTOOLTIP");
	this:RegisterEvent("SHOW_SUPERTOOLTIP");

end

function DressSuperToolTip_OnLoad()
	DressSuperToolTip_StaticPart_Money:SetClippedByParent(0);
	DressSuperToolTip_StaticPart_Money_JiaoZi:SetClippedByParent(0);
	g_DressSuperToolTip_Stars={
				DressSuperToolTip_StaticPart_Star1,
				DressSuperToolTip_StaticPart_Star2,
				DressSuperToolTip_StaticPart_Star3,
				DressSuperToolTip_StaticPart_Star4,
				DressSuperToolTip_StaticPart_Star5,
				DressSuperToolTip_StaticPart_Star6,
				DressSuperToolTip_StaticPart_Star7,
				DressSuperToolTip_StaticPart_Star8,
				DressSuperToolTip_StaticPart_Star9,
		};
	for i=1,9 do
		g_DressSuperToolTip_Stars[i]:Hide();
	end;
end										

function DressSuperToolTip_OnEvent(event)

--	DressSuperToolTip_StaticPart_Money:Hide();
	if(event == "SHOW_DRESS_SUPERTOOLTIP") then
		if( arg0 == "1" and SuperTooltips:IsPresent()) then
			
			SuperTooltips:SendAskItemInfoMsg();
			if(DressSuperToolTip_Update()==1) then
				g_pos1, g_pos2 = _DressSuperToolTip_:PositionSelf(arg2, arg3, arg4, arg5);	
				this:Show();
			end;
			return;
		else
			this:Hide();
			return;

		end
	end
		
	if event == "SHOW_SUPERTOOLTIP" then
		local open = tonumber(arg0)
		if open == 0 then
			this:Hide();
		end
	end

	
end

function DressSuperToolTip_Update()
		-- 先清空以前显示的文字
		DressSuperToolTip_ClearText();
		
		local typeDesc = SuperTooltips:GetTypeDesc();
		local nGemHoleCounts = SuperTooltips:GetGemHoleCounts();
		local nMoney1, szMoneyDesc1 = SuperTooltips:GetMoney1();
		local nMoney2, szMoneyDesc2 = SuperTooltips:GetMoney2();
		local szPropertys = SuperTooltips:GetPropertys();
		local szAuthor = SuperTooltips:GetAuthorInfo();
		local szExplain = SuperTooltips:GetExplain();
		
		local unLockingElapsedTime	=SuperTooltips:GetPUnlockElapsedTime();
		local IsProtectd	=SuperTooltips:GetDesc5();
		local nYuanbaotrade = SuperTooltips:GetYuanbaoTradeFlag();
		local nGoodsProtect = SuperTooltips:GetGoodsProtect_Goods();
		----------------------------------------------------------------------
		--显示静态头
		local toDisplay = "";
		
		if(SuperTooltips:GetTitle()~="" and SuperTooltips:GetIconName()~="")then
			toDisplay = toDisplay .."DressSuperToolTip_PageHeader";
		end
		
		--剩余解锁时间
		if( IsProtectd == "1" and unLockingElapsedTime ~= 0) then
			toDisplay = toDisplay .. ";DressSuperToolTip_UnlockingTimePart";
		end
		
		
		--加上类型描述
		if( typeDesc ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip_ShortDesc";
		end
		
		--元宝交易
		if (nYuanbaotrade == 0) then
			toDisplay = toDisplay .. ";DressSuperToolTip_StaticPart_Yuanbaojiaoyi";
			DressSuperToolTip_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_87}");
		elseif (nYuanbaotrade == 2) then
			toDisplay = toDisplay .. ";DressSuperToolTip_StaticPart_Yuanbaojiaoyi";
			DressSuperToolTip_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_88}");
		end
		
		--宝石部分
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0 ) then 
			toDisplay = toDisplay .. ";DressSuperToolTip_GemPart";
		end
		--金钱1
		if( nMoney1 ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip_MoneyPart";
		end

		--金钱2
		if(nMoney2 ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip_MoneyPart_2";
		end
		
		--高级保护
		if nGoodsProtect == 1 then
			toDisplay = toDisplay .. ";DressSuperToolTip_Protect_Text";
		end

		--属性
		if(szPropertys ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip_Property";
		end

		--作者
		if(szAuthor ~= nil) then 
			toDisplay = toDisplay .. ";DressSuperToolTip_Manufacturer_Frame";
		end

		--详细解释
		toDisplay = toDisplay .. ";DressSuperToolTip_Explain";

		--显示组件内容
		if(toDisplay=="") then
			this:Hide();
			return 0;
		end;
		AxTrace( 8,0,toDisplay );
		_DressSuperToolTip_:SetProperty("PageElements",  toDisplay);
		
		----------------------------------------------------------------------
		--显示新的内容
		DressSuperToolTip_StaticPart_Title:SetText(SuperTooltips:GetTitle());
		DressSuperToolTip_StaticPart_Item1:SetText(SuperTooltips:GetDesc1());
		DressSuperToolTip_StaticPart_Item2:SetText(SuperTooltips:GetDesc2());
		DressSuperToolTip_StaticPart_Item3:SetText(SuperTooltips:GetDesc3());
		DressSuperToolTip_StaticPart_Item4:SetText(SuperTooltips:GetDesc4());
		--DressSuperToolTip_StaticPart_Item5:SetText(SuperTooltips:GetDesc5());
		DressSuperToolTip_StaticPart_Icon:SetImage(SuperTooltips:GetIconName());
		DressSuperToolTip_ShortDesc_Text:SetText(typeDesc);

		-- 显示雕纹
		local dwIcon = SuperTooltips:GetDiaowenIcon()
		if (dwIcon ~= nil and dwIcon ~= "") then
			DressSuperToolTip_StaticPart_DW:Show()
			DressSuperToolTip_StaticPart_DW:SetProperty("Image", dwIcon)
		end
		
		-- 时装编号显示
		local szFashionNum = SuperTooltips:GetFashionNumber();
		if (szFashionNum ~= nil and szFashionNum ~= "") then
			DressSuperToolTip_StaticPart_FashionNum:Show()
			DressSuperToolTip_StaticPart_FashionNum:SetText(szFashionNum)
		end
		
		-- 编号时装背景显示
		local DressIcon = SuperTooltips:GetFashionNumberIcon()
		if (DressIcon ~= nil and DressIcon ~= "") then
			DressSuperToolTip_FashionBK:Show()
			DressSuperToolTip_FashionBK:SetProperty("Image", DressIcon)
		end
		
		if( T300Func:IsNoDifOpen(0) == 1) then--宝石
			DressSuperToolTip_StaticPart_Gem1BK:Show()
			DressSuperToolTip_StaticPart_Gem2BK:Show()
			DressSuperToolTip_StaticPart_Gem3BK:Show()
			DressSuperToolTip_StaticPart_Gem4BK:Show()
		else
			DressSuperToolTip_StaticPart_Gem1BK:Hide()
			DressSuperToolTip_StaticPart_Gem2BK:Hide()
			DressSuperToolTip_StaticPart_Gem3BK:Hide()
			DressSuperToolTip_StaticPart_Gem4BK:Hide()
		end

		if( T300Func:IsNoDifOpen(1) == 1) then--雕文
			DressSuperToolTip_StaticPart_DWBK:Show()
		else
			DressSuperToolTip_StaticPart_DWBK:Hide()
		end
		

		if (IsProtectd == "1" and unLockingElapsedTime ~= 0) then		
			local strLeftTime = DressSuperToolTip_GetUnlockingStr(unLockingElapsedTime);		
			DressSuperToolTip_UnlockingTimePart:SetText("#b#cFFFF00"..strLeftTime);
			DressSuperToolTip_StaticPart_Icon_Protected : SetProperty("Image","set:CommonFrame6 image:NewLock");
		else
			DressSuperToolTip_UnlockingTimePart:SetText("");
			DressSuperToolTip_StaticPart_Icon_Protected : SetProperty("Image","set:UIIcons image:Icon_Lock");
		end
		
		if nGoodsProtect == 1 then
			DressSuperToolTip_Protect_Text:SetText("#{GDWPBH_090507_4}")
		else
			DressSuperToolTip_Protect_Text:SetText("")
		end

		--tongxi modify 显示星星
		--AxTrace( 5,0,StrongLevel );
		local qual =SuperTooltips:GetEquipQual();
		if(type(qual) == "number" and tonumber(qual)>0)then
			local starNum	=	tonumber(qual);
			if(starNum<10) then
				for i=1,starNum do
					--AxTrace( 5,0,StrongLevel.."hehe" );
					if starNum <=4 then
						g_DressSuperToolTip_Stars[i]:SetProperty("Animate", "Animate_StarNoFlash");
					else
						g_DressSuperToolTip_Stars[i]:SetProperty("Animate", "Animate_Star");
					end
					g_DressSuperToolTip_Stars[i]:Show();
				end;
				for i=starNum+1, 9 do
					g_DressSuperToolTip_Stars[i]:SetProperty("Animate", "Animate_StarDark");
					g_DressSuperToolTip_Stars[i]:Show();
				end
			end;
		end;
		if(IsProtectd=="1") then
			DressSuperToolTip_StaticPart_Icon_Protected:Show();
		end;
		--modify end
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0) then
			AxTrace(5,1,"nGemHoleCounts="..nGemHoleCounts)
			if(nGemHoleCounts > 0) then 
				DressSuperToolTip_StaticPart_Gem1:Show();
			end
			
			if(nGemHoleCounts > 1) then 
				DressSuperToolTip_StaticPart_Gem2:Show();
			end
			
			if(nGemHoleCounts > 2) then 
				DressSuperToolTip_StaticPart_Gem3:Show();
			end
			
			if(nGemHoleCounts > 3) then 
				DressSuperToolTip_StaticPart_Gem4:Show();
			end
			
			
			local gemIcon = SuperTooltips:GetGemIcon1();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				DressSuperToolTip_StaticPart_Gem1:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon2();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				DressSuperToolTip_StaticPart_Gem2:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon3();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				DressSuperToolTip_StaticPart_Gem3:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon4();
			
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				DressSuperToolTip_StaticPart_Gem4:SetProperty("ShortImage", gemIcon);
			end
			
		end
		if(nMoney1 ~= nil)  then
			DressSuperToolTip_StaticPart_Money_Text:SetText(szMoneyDesc1);
			DressSuperToolTip_SetupMoneyPart(1,nMoney1);
			
		end		
		if(nMoney2 ~= nil)  then
			DressSuperToolTip_StaticPart_Money_Text_2:SetText(szMoneyDesc2);
			DressSuperToolTip_SetupMoneyPart(2,nMoney2);
		end
		
		if( szPropertys ~= nil) then
			DressSuperToolTip_Property:SetText(szPropertys);
		end
		
		if(szAuthor ~= nil) then
			DressSuperToolTip_Manufacturer:SetText(szAuthor);
		end
		
		DressSuperToolTip_Explain:SetText(szExplain);
		
		AxTrace( 8,0,"Show tooltip  "..szExplain);

		return 1;
		
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清空显示文本
--
function DressSuperToolTip_ClearText()
		DressSuperToolTip_StaticPart_Title:SetText("");
		DressSuperToolTip_StaticPart_Item1:SetText("");
		DressSuperToolTip_StaticPart_Item2:SetText("");
		DressSuperToolTip_StaticPart_Item3:SetText("");
		DressSuperToolTip_StaticPart_Item4:SetText("");
		DressSuperToolTip_Protect_Text:SetText("");
		DressSuperToolTip_StaticPart_DW:SetImage("")
		DressSuperToolTip_StaticPart_DW:Hide()
		DressSuperToolTip_StaticPart_FashionNum:Hide()
		DressSuperToolTip_StaticPart_FashionNum:SetText("");
		DressSuperToolTip_FashionBK:SetImage("")
		DressSuperToolTip_FashionBK:Hide()
		local starNum=9
		for i=1,starNum do
			g_DressSuperToolTip_Stars[i]:Hide();
		end;
		DressSuperToolTip_StaticPart_Gem1:SetImage("");
		DressSuperToolTip_StaticPart_Gem2:SetImage("");
		DressSuperToolTip_StaticPart_Gem3:SetImage("");
		DressSuperToolTip_StaticPart_Gem4:SetImage("");
		DressSuperToolTip_StaticPart_Gem1:Hide();
		DressSuperToolTip_StaticPart_Gem2:Hide()
		DressSuperToolTip_StaticPart_Gem3:Hide()
		DressSuperToolTip_StaticPart_Gem4:Hide()
		DressSuperToolTip_Explain:SetText("");
		DressSuperToolTip_Property:SetText("");
		DressSuperToolTip_Manufacturer:SetText("");
		DressSuperToolTip_StaticPart_Icon_Protected:Hide();
end

function DressSuperToolTip_SetupMoneyPart(type,nPrice)
	local StaticPart_GB_Ctl;
	local StaticPart_Money_Ctl;
		--使用什么作为货币
	local nUnit =  SuperTooltips:GetMoney1Type();
	if(type==1)then
		StaticPart_GB_Ctl = DressSuperToolTip_StaticPart_GB;
		local isShowJiaoZi = SuperTooltips:GetIsShowJiaoZi();
		if ( CU_MONEYJZ == nUnit ) then
			isShowJiaoZi = 1;
		end
		if (isShowJiaoZi == 1) then
			DressSuperToolTip_StaticPart_Money:Hide();
			StaticPart_Money_Ctl = DressSuperToolTip_StaticPart_Money_JiaoZi;
		else
			DressSuperToolTip_StaticPart_Money_JiaoZi:Hide()
			StaticPart_Money_Ctl = DressSuperToolTip_StaticPart_Money;
		end
	else
		StaticPart_GB_Ctl = DressSuperToolTip_StaticPart_GB_2;
		StaticPart_Money_Ctl = DressSuperToolTip_StaticPart_Money_2;
	end

	if(nUnit==nil)then
		nUnit = CU_MONEY;
	end;
	if(CU_MONEY	== nUnit or CU_TICKET == nUnit or CU_MONEYJZ == nUnit)       then      --钱，官票钱, 交子
			StaticPart_GB_Ctl:Hide()
			StaticPart_Money_Ctl:Show();
			StaticPart_Money_Ctl:SetProperty("MoneyNumber", tostring(nPrice));

	elseif(CU_GOODBAD == nUnit) then			--善恶值
			
			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("善恶值:" .. tostring(nPrice) .. " 点")


	elseif(CU_MORALPOINT == nUnit)  then	--师德点

			StaticPart_GB_Ctl:Show()
			DressSuperToolTip_StaticPart_Money:Hide();
			StaticPart_GB_Ctl:SetText("师德点:" .. tostring(nPrice) .. " 点")

	elseif(CU_BIND_YUANBAO == nUnit) then	--绑定元宝

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("#{BDYB_090714_01}" .. tostring(nPrice))
			
	elseif(CU_GIFTTOKEN == nUnit) then	--返券

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("#{YBFQ_XML_1}" .. tostring(nPrice))

	elseif(CU_YUANBAO == nUnit) then	--元宝

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("元宝：" .. tostring(nPrice))

	elseif(CU_ZENGDIAN == nUnit) then	--赠点

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("赠点:" .. tostring(nPrice))

	elseif(CU_MENPAI_POINT == nUnit) then	--师门贡献度

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("门派贡献度:" .. tostring(nPrice))

	end	
	
end;
