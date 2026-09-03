
local g_MoneyType=-1;

local PS_IMMITBASE			= 1;
local PS_IMMIT					= 2;
local PS_DRAW						= 3;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Input_PreLoad()
	this:RegisterEvent("PS_INPUT_MONEY");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_SHOP_MAG");
end

--===============================================
-- OnLoad
--===============================================
function PS_Input_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_Input_OnEvent(event)

	if(event == "PS_INPUT_MONEY") then
		--Íæ¼ÒÉÌµê³åÈë±¾½ð
		if (arg0 == "immitbase") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMITBASE;
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("base","self");

			PS_Input_DragTitle:SetText("#gFF0FA0NÕp");
			PS_Input_Accept:SetText("NÕp");
			PS_Input_Warning:SetText("V¯n nÕp t¯i thi¬u là 10#-02#rV¯n c½ bän hi®n tÕi:".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(nBaseMoney));
			PS_Input_Text1:SetText("NÕp v¯n: ");
			PS_Input_Text2:SetText("Vàng: ");
			
			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			
		--Íæ¼ÒÉÌµê³åÈë
		elseif (arg0 == "immit") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMIT;
			PS_Input_DragTitle:SetText("#gFF0FA0 nh§p vào ti«n lþi nhu§n");
			PS_Input_Accept:SetText("NÕp");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("input_profit","self");
			local szCom = PlayerShop:GetCommercialFactor()

			local szInfo = "S¯ ti«n lþi nhu§n nh§p vào không ðßþc th¤p h½n s¯ vàng hi®n có: s¯ vàng hi®n có: 30" .. "#-02" .. " x Ði¬m thß½ng nghi®p x s¯ qu¥y hàng, ði¬m thß½ng nghi®p hi®n tÕi là  ".. szCom .. ", c¥n nÕp ít nh¤t ".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04";
			PS_Input_Warning:SetText(szInfo);
			
			PS_Input_Text1:SetText("Xin nh§p vào ti«n lþi nhu§n:");
			PS_Input_Text2:SetText("QuÛ lþi nhu§n hi®n tÕi: ");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");

		--Íæ¼ÒÉÌµêÈ¡³ö
		elseif (arg0 == "draw") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_DRAW;
			PS_Input_DragTitle:SetText("#gFF0FA0Rút ti«n lþi nhu§n");
			PS_Input_Accept:SetText("Lînh");

			PS_Input_Warning:SetText("#{SHOPTIPS_090205_2}");--[tx44221]

			PS_Input_Text1:SetText("Mu¯n rút ti«n lþi nhu§n: ");
			PS_Input_Text2:SetText("QuÛ lþi nhu§n hi®n tÕi: ");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
		end		
		PS_Input_Frame:SetForce();
		PS_Input_Gold:SetText("");
		PS_Input_Silver:SetText("");
		PS_Input_CopperCoin:SetText("");
		
	elseif ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Input");
		end	
	
	elseif( event == "PS_CLOSE_SHOP_MAG" )    then
	
		if( this:IsVisible() )   then
			this:Hide();
			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Input");
		end
		
	end	
	
end

--===============================================
-- Accept
--===============================================
function PS_Input_Accept_Clicked()
	local szGold = PS_Input_Gold:GetText();
	local szSilver = PS_Input_Silver:GetText();
	local szCopperCoin = PS_Input_CopperCoin:GetText();
	
	--ÔÚ³ÌÐòÀïÍ·ÔÙ¼ì²âÊäÈë×Ö·ûµÄÓÐÐ§ÐÔºÍÊýÖµ
	local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	if(bAvailability == true) then
	
		if( g_nSaveOrGetMoney == PS_IMMITBASE ) then
			--³äÈë±¾½ð
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immitbase",nMoney)
			if( szResult == "ok" )   then
				this:Hide();
				--È¡Ïû¹ØÐÄ
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nMoney);
				
			elseif(szResult == "few" )  then
				

			elseif(szResult == "more" )  then
				this:Hide();
				--È¡Ïû¹ØÐÄ
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_IMMIT ) then
			--³äÈë
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immit",nMoney);
			
			if( szResult == "ok" )   then
				this:Hide();
				--È¡Ïû¹ØÐÄ
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nMoney);
			
			elseif(szResult == "few" )  then
				
			
			elseif(szResult == "more" )  then
				this:Hide();
				--È¡Ïû¹ØÐÄ
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_DRAW ) then
			--Ö§È¡
			PlayerShop:ApplyMoney("draw_ok",nMoney);
			this:Hide();
			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Input");
			
		end
	end
end

--===============================================
-- Cancel
--===============================================
function PS_Input_Cancel_Clicked()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Input");
end


--===============================================
-- OnHiden
--===============================================
function PS_Input_Frame_OnHiden()
	PS_Input_Gold:SetProperty("DefaultEditBox", "False");
	PS_Input_Silver:SetProperty("DefaultEditBox", "False");
	PS_Input_CopperCoin:SetProperty("DefaultEditBox", "False");
end

