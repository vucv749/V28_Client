local g_CJ_Backpack_UnifiedPosition;
local g_ExeScript = 999340
local g_UI_Items = {}
--local g_UICOMMAND = 99934001

local g_TLCJ_EQUIPSLOT_NUM = 13
local g_TLCJ_SKILLSLOT_NUM = 5
local g_TLCJ_SKILLBAG_NUM = 12


local g_EquipSlotMap = {
    [1] = 1, --??
    [2] = 15,--??
    [3] = 2, --??
    [4] = 14, --??
    [5] = 3, --??
    [6] = 5, --??
    [7] = 4, --??
    [8] = 0, --??
    [9] = 7, --??
    [10] = 6,--??
    [11] = 6,--?? ?????11
    [12] = 12,--??
    [13] = 12,--??
} 

local g_menpaiImage = { 
    [0] = "set:CJ_Image image:CJ_SL",
    [1] = "set:CJ_Image image:CJ_MJ",
    [2] = "set:CJ_Image image:CJ_GB",
    [3] = "set:CJ_Image image:CJ_WD",
    [4] = "set:CJ_Image image:CJ_EM",
    [5] = "set:CJ_Image image:CJ_XX",
    [6] = "set:CJ_Image image:CJ_TL",
    [7] = "set:CJ_Image image:CJ_TS",
    [8] = "set:CJ_Image image:CJ_XY",

    [10] = "set:CJ_Image image:CJ_MT",
    [11] = "set:CJ_Image image:CJ_ERG",
}

local g_RequireExperience =0

function CJ_Backpack_PreLoad()
	--this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("TLCJ_OPENPLAYERBAG")
	--Àë¿ª³¡¾°£¬×Ô¶¯¹Ø± 
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

    this:RegisterEvent("UNIT_HP",false);
	this:RegisterEvent("UNIT_MAX_HP",false);
	this:RegisterEvent("UNIT_MP",false);
	this:RegisterEvent("UNIT_MAX_MP",false);
	this:RegisterEvent("UNIT_RAGE",false);			-- ????
	this:RegisterEvent("UNIT_ENG",false);			-- ????
	this:RegisterEvent("UNIT_MAX_ENG",false);			-- ????

	-- this:RegisterEvent("UNIT_EXP",false);
	-- this:RegisterEvent("UNIT_LEVEL",false);
	-- this:RegisterEvent("UNIT_MAX_EXP",false);
	this:RegisterEvent("TLCJ_BASEATTRUPDATE",false);
    
	this:RegisterEvent("UNIT_STR",false);
	this:RegisterEvent("UNIT_SPR",false);
	this:RegisterEvent("UNIT_CON",false);
	this:RegisterEvent("UNIT_INT",false);
	this:RegisterEvent("UNIT_DEX",false);
	--this:RegisterEvent("UNIT_POINT_REMAIN",false);
	-- this:RegisterEvent("UNIT_XIULIAN_STR",false);
	-- this:RegisterEvent("UNIT_XIULIAN_SPR",false);
	-- this:RegisterEvent("UNIT_XIULIAN_CON",false);
	-- this:RegisterEvent("UNIT_XIULIAN_INT",false);
	-- this:RegisterEvent("UNIT_XIULIAN_DEX",false);

	this:RegisterEvent("UNIT_ATT_PHYSICS",false);
	this:RegisterEvent("UNIT_ATT_MAGIC",false);
	this:RegisterEvent("UNIT_DEF_PHYSICS",false);
	this:RegisterEvent("UNIT_DEF_MAGIC",false);
	this:RegisterEvent("UNIT_HIT",false);
	this:RegisterEvent("UNIT_MISS",false);
	this:RegisterEvent("UNIT_CRITICAL_ATTACK",false);
	this:RegisterEvent("UNIT_CRITICAL_DEFENCE",false);
	--this:RegisterEvent("CUR_TITLE_CHANGED",false); 		--µ±Ç°³ÆºÅ¸Ä±ä
	-- this:RegisterEvent("UNIT_XIULIAN_ATT_PHYSICS",false);
	-- this:RegisterEvent("UNIT_XIULIAN_ATT_MAGIC",false);
	-- this:RegisterEvent("UNIT_XIULIAN_DEF_PHYSICS",false);
	-- this:RegisterEvent("UNIT_XIULIAN_DEF_MAGIC",false);
	-- this:RegisterEvent("UNIT_XIULIAN_HIT",false);
	-- this:RegisterEvent("UNIT_XIULIAN_MISS",false);

	this:RegisterEvent("UNIT_DEF_COLD",false);				--????
	this:RegisterEvent("UNIT_DEF_FIRE",false);
	this:RegisterEvent("UNIT_DEF_LIGHT",false);
	this:RegisterEvent("UNIT_DEF_POSION",false);
	this:RegisterEvent("UNIT_MENPAI",false);

	this:RegisterEvent("UNIT_ATT_COLD",false);				--????
	this:RegisterEvent("UNIT_ATT_FIRE",false);
	this:RegisterEvent("UNIT_ATT_LIGHT",false);
	this:RegisterEvent("UNIT_ATT_POSION",false);

	this:RegisterEvent("UNIT_RESISTOTHER_COLD",false);			--????
	this:RegisterEvent("UNIT_RESISTOTHER_FIRE",false);
	this:RegisterEvent("UNIT_RESISTOTHER_LIGHT",false);
	this:RegisterEvent("UNIT_RESISTOTHER_POSION",false);

end
function CJ_Backpack_OnLoad()	
	g_CJ_Backpack_UnifiedPosition  =CJ_Backpack_Frame:GetProperty("UnifiedPosition");
    g_UI_Items.equipslots = {}
    for i = 1, g_TLCJ_EQUIPSLOT_NUM do
        g_UI_Items.equipslots[i] =  _G[string.format( "CJ_Backpack_Equip_%d",i)]
        g_UI_Items.equipslots[i]:SetProperty("DragAcceptName", "JA"..tostring(i))
        g_UI_Items.equipslots[i]:SetProperty("DraggingEnabled", "True")
    end

    -- g_UI_Items.skillslots = {}
    -- g_UI_Items.skillslots[1] =  CJ_Backpack_Skill_ControlType_Item_1
    -- g_UI_Items.skillslots[2] =  CJ_Backpack_Skill_ControlType_Item_2
    -- g_UI_Items.skillslots[3] =  CJ_Backpack_Skill_NormalType_Item_1
    -- g_UI_Items.skillslots[4] =  CJ_Backpack_Skill_NormalType_Item_2
    -- g_UI_Items.skillslots[5] =  CJ_Backpack_Skill_NormalType_Item_3
    -- for i = 1, g_TLCJ_SKILLSLOT_NUM do
    --     g_UI_Items.skillslots[i]:SetProperty("DragAcceptName", "JB"..tostring(i))
    --     g_UI_Items.skillslots[i]:SetProperty("DraggingEnabled", "True")
    -- end


    -- g_UI_Items.skillbags = {}
    -- for i = 1, g_TLCJ_SKILLBAG_NUM do
    --     g_UI_Items.skillbags[i] =  _G[string.format( "CJ_Backpack_SkillBag_Item%d",i)]
    --     g_UI_Items.skillbags[i]:SetProperty("DragAcceptName", "JE"..tostring(i))
    --     g_UI_Items.skillbags[i]:SetProperty("DraggingEnabled", "True")
    -- end
end

function CJ_Backpack_OnEvent(event)

	-- if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
		
	-- end
	if event ==  "TLCJ_OPENPLAYERBAG" then
        if tonumber(arg0) == 0 then
            CJ_Backpack_Open()
         elseif  tonumber(arg0) == 1 then
                CJ_Backpack_SetAllActionBtn()
        elseif tonumber(arg0) == 2 then
                --Ö»Ë¢ÐÂ²¿·Ö
                if tonumber(arg1) > 0 then
                    CJ_Backpack_RefreshBag(tonumber(arg1))
                end
        elseif tonumber(arg0) == 4 then
                --Ö»Ë¢ÐÂ²¿·Ö
                CJ_Backpack_RefreshBag(1)
        end
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		CJ_Backpack_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CJ_Backpack_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
    end
    

    --ÒÔÏÂÊÂ¼þÏÞÓÚ´°¿Ú´ò¿ªÊ±
	if(this:IsVisible()) then
        local nNumber=0;
		local nMaxnumber=0;
		local strName;
        if event == "TLCJ_BASEATTRUPDATE" and arg0 == "menpai" then
            --µÃµ½ÃÅÅÉ
            nNumber =  TLCJ:GetData( "MENPAI" );
            --local LevelText = GetMenpaiByID(nNumber);
            --LevelText = "#cC8B88E"..LevelText;
            --CJ_Backpack_MenPai_Num:SetText( LevelText );
            if g_menpaiImage[nNumber] then
                CJ_Backpack_MenPaiImage:SetProperty("Image",g_menpaiImage[nNumber])
            end
        elseif   event == "TLCJ_BASEATTRUPDATE" and arg0 == "level" then
            -- µÃµ½µÈ¼¶
            nNumber =  TLCJ:GetData( "LEVEL" );
            local LevelText = tostring( nNumber ).." C¤p";
            LevelText = "#cC8B88E"..LevelText;
            CJ_Backpack_Level_Num:SetText( LevelText );
            -- -- µÃµ½µ±Ç°¾­Ñé
            local g_CurExperience = TLCJ:GetData("EXP");
            local CurExpText = tostring( g_CurExperience );
            -- CurExpText = "#cC8B88E"..CurExpText;
            -- SelfEquip_Exp2:SetText( CurExpText );
            -- -- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
            g_RequireExperience = TLCJ:GetData("NEEDEXP");
            local NeedExpText =  tostring( g_RequireExperience );
            NeedExpText = "#cC8B88E"..CurExpText.."/"..NeedExpText;
            CJ_Backpack_NextLVNeed_Num:SetText( NeedExpText );
            CJ_Backpack_Level_EXPLace:SetProgress(g_CurExperience,g_RequireExperience)
        elseif   event == "TLCJ_BASEATTRUPDATE" and arg0 == "exp" then
              -- -- µÃµ½µ±Ç°¾­Ñé
              local g_CurExperience = TLCJ:GetData("EXP");
              local CurExpText = tostring( g_CurExperience );
              -- CurExpText = "#cC8B88E"..CurExpText;
              -- SelfEquip_Exp2:SetText( CurExpText );
              -- -- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
              local NeedExpText =  tostring( g_RequireExperience );
              NeedExpText = "#cC8B88E"..CurExpText.."/"..NeedExpText;
              CJ_Backpack_NextLVNeed_Num:SetText( NeedExpText );
             CJ_Backpack_Level_EXPLace:SetProgress(g_CurExperience,g_RequireExperience)
        end
        -- Ñª
        if((event == "UNIT_HP" or event == "UNIT_MAX_HP")  and arg0 == "player") then
            nNumber = Player:GetData("HP");
            nMaxnumber = Player:GetData( "MAXHP" );

            local strHpText = tostring( nNumber ).."/"..tostring( nMaxnumber );
            CJ_Backpack_HP_Num:SetText( strHpText );
        -- -- mana
        -- elseif((event == "UNIT_MP" or event == "UNIT_MAX_MP")  and arg0 == "player") then
        --     nNumber = Player:GetData( "MP" );
        --     nMaxnumber = Player:GetData( "MAXMP" );

        --     local strMpText = tostring( nNumber ).."/"..tostring( nMaxnumber ) ;
        --     strMpText = "#cFAFFA4"..strMpText;
        --     SelfEquip_MP:SetText( strMpText );

        -- -- Å­Æø
        -- elseif((event == "UNIT_RAGE" )  and arg0 == "player") then
        --     -- Å­Æø

		--STR
        elseif(event == "UNIT_STR" and arg0 == "player") then
            nNumber = Player:GetData("STR");
            CJ_Backpack_Str_Num:SetText( tostring( nNumber ) );
        --SPR
        elseif(event == "UNIT_SPR" and arg0 == "player") then
            nNumber = Player:GetData("SPR");
            CJ_Backpack_Nimbus_Num:SetText( tostring( nNumber ) );
        --CON
        elseif(event == "UNIT_CON" and arg0 == "player") then
            nNumber = Player:GetData("CON");
            CJ_Backpack_PhysicalStrength_Num:SetText( tostring( nNumber ) );
        --INT
        elseif(event == "UNIT_INT" and arg0 == "player") then
            nNumber = Player:GetData("INT");
            CJ_Backpack_Stability_Num:SetText( tostring( nNumber ) );

        --DEX
        elseif(event == "UNIT_DEX" and arg0 == "player") then
            nNumber = Player:GetData("DEX");
            CJ_Backpack_Footwork_Num:SetText( tostring( nNumber ) );
        --ATT_PHYSICS
        elseif(event == "UNIT_ATT_PHYSICS" and arg0 == "player") then
            nNumber = Player:GetData("ATT_PHYSICS");
            CJ_Backpack_Perporty1_Num:SetText( tostring( nNumber ) );
        --DEF_PHYSICS
        elseif(event == "UNIT_DEF_PHYSICS" and arg0 == "player") then
            nNumber = Player:GetData("DEF_PHYSICS");
            if nNumber > 999999 then --?????? modified by hukai
                CJ_Backpack_Perporty3_Num:SetText( "??????" );
            else
                CJ_Backpack_Perporty3_Num:SetText( tostring( nNumber ) );
            end
        --ATT_MAGIC
        elseif(event == "UNIT_ATT_MAGIC" and arg0 == "player") then
            nNumber = Player:GetData("ATT_MAGIC");
            CJ_Backpack_Perporty2_Num:SetText( tostring( nNumber ) );
        --DEF_MAGIC
        elseif(event == "UNIT_DEF_MAGIC" and arg0 == "player") then
            nNumber = Player:GetData("DEF_MAGIC");
            if nNumber > 999999 then --?????? modified by hukai
                CJ_Backpack_Perporty4_Num:SetText( "??????" );
            else
                CJ_Backpack_Perporty4_Num:SetText( tostring( nNumber ) );
            end
        --UNIT_MISS
        elseif(event == "UNIT_MISS" and arg0 == "player") then
            nNumber = Player:GetData("MISS");
            CJ_Backpack_Perporty6_Num:SetText( tostring( nNumber ) );
        --UNIT_HIT
        elseif(event == "UNIT_HIT" and arg0 == "player") then
            nNumber = Player:GetData("HIT");
            CJ_Backpack_Perporty5_Num:SetText( tostring( nNumber ) );
        --UNIT_CRITICAL_ATTACK
        elseif(event == "UNIT_CRITICAL_ATTACK" and arg0 == "player") then
            nNumber = Player:GetData("CRITICALATTACK");
            CJ_Backpack_Perporty7_Num:SetText( tostring( nNumber ) );
        --UNIT_CRITICAL_DEFENCE
        elseif(event == "UNIT_CRITICAL_DEFENCE" and arg0 == "player") then
            nNumber = Player:GetData("CRITICALDEFENCE");
            CJ_Backpack_Perporty8_Num:SetText( tostring( nNumber ) );
        --±ù·ÀÓù
        elseif(event == "UNIT_DEF_COLD" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --»ð·ÀÓù
        elseif(event == "UNIT_DEF_FIRE" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --µç·ÀÓù
        elseif(event == "UNIT_DEF_LIGHT" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --¶¾·ÀÓù
        elseif(event == "UNIT_DEF_POSION" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --¼õ±ù¿¹
        elseif(event == "UNIT_RESISTOTHER_COLD" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --¼õ»ð¿¹
        elseif(event == "UNIT_RESISTOTHER_FIRE" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --¼õµç¿¹
        elseif(event == "UNIT_RESISTOTHER_LIGHT" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --¼õ¶¾¿¹
        elseif(event == "UNIT_RESISTOTHER_POSION" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();

        --±ù¹¥»÷
        elseif(event == "UNIT_ATT_COLD" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();
        --»ð¹¥»÷
        elseif(event == "UNIT_ATT_FIRE" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();
        --µç¹¥»÷
        elseif(event == "UNIT_ATT_LIGHT" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();
        --¶¾¹¥»÷
        elseif(event == "UNIT_ATT_POSION" and arg0 == "player") then
            CJ_Backpack_SetStateTooltip();
        --Ö±½Ó¹¥»÷(Ç¿»¯)
        -- elseif(event == "UNIT_ENCHANCE_ATT" and arg0 == "player") then
        --     CJ_Backpack_SetStateTooltip();
        -- --Ö±½Ó·ÀÓù(Ç¿»¯)
        -- elseif(event == "UNIT_ENCHANCE_DEF" and arg0 == "player") then
        -- CJ_Backpack_SetStateTooltip();
         end
    end

end

-- TLCJ_ITEMCONTAINER_INVALID = 0,
-- TLCJ_ITEMCONTAINER_EQUIPSLOT = 1,
-- TLCJ_ITEMCONTAINER_SKILLSLOT = 2,
-- TLCJ_ITEMCONTAINER_EUIQPBAG = 3,
-- TLCJ_ITEMCONTAINER_ITEMBAG = 4,
-- TLCJ_ITEMCONTAINER_SKILLBAG = 5,
-- TLCJ_ITEMCONTAINER_DROPBAG = 6,

function CJ_Backpack_Open()

    CJ_Backpack_SetAllActionBtn()
    CJ_Backpack_OnUpdateShow()
    this:Show()
end

function CJ_Backpack_SetAllActionBtn()
    local theAction = nil
    local actionBtn = nil
    --×°±¸Î»
    for i = 1, g_TLCJ_EQUIPSLOT_NUM do
        theAction = Lua_CreateChiJiAction(1,i-1)
        actionBtn = g_UI_Items.equipslots[i]
        if theAction:GetID() ~= 0 and actionBtn ~= nil then
            actionBtn:SetActionItem(theAction:GetID())
        else
            actionBtn:SetActionItem(-1)
        end
    end
    -- --¼¼ÄÜ²Û
    -- for i = 1, g_TLCJ_SKILLSLOT_NUM do
    --     theAction = Lua_CreateChiJiAction(2,i-1)
    --     actionBtn = g_UI_Items.skillslots[i]
    --     if theAction:GetID() ~= 0 and actionBtn ~= nil then
    --         actionBtn:SetActionItem(theAction:GetID())
    --         LuaSetTLCJSkillBar(i-1,theAction:GetID())
    --     else
    --         actionBtn:SetActionItem(-1)
    --         LuaSetTLCJSkillBar(i-1,-1)
    --     end
    -- end
    --  --¼¼ÄÜ°ü
    --  for i = 1, g_TLCJ_SKILLBAG_NUM do
    --     theAction = Lua_CreateChiJiAction(5,i-1)
    --     actionBtn = g_UI_Items.skillbags[i]
    --     if theAction:GetID() ~= 0 and actionBtn ~= nil then
	-- 		theAction:SetLockStatus(1)
    --         actionBtn:SetActionItem(theAction:GetID())
    --     else
    --         actionBtn:SetActionItem(-1)
    --     end
    -- end
end
function  CJ_Backpack_RefreshBag(bagType)
    local theAction = nil
    local actionBtn = nil
    if bagType == 1 then
        --×°±¸Î»
        for i = 1, g_TLCJ_EQUIPSLOT_NUM do
            theAction = Lua_CreateChiJiAction(1,i-1)
            actionBtn = g_UI_Items.equipslots[i]
            if theAction:GetID() ~= 0 and actionBtn ~= nil then
                actionBtn:SetActionItem(theAction:GetID())
            else
                actionBtn:SetActionItem(-1)
            end
        end
        LifeAbility:ShowSuperToolTip(1, false);
    end
end

--µã»÷×°±¸²Û
function CJ_Backpack_Equip_Click( nPos,bClicked )
    if nPos < 1 or nPos > g_TLCJ_EQUIPSLOT_NUM or bClicked==1 then
        return 
    end
    local actionBtn = g_UI_Items.equipslots[nPos]
    if actionBtn:GetActionItem() < 1 then
        return 
    end
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name( "UseItem" )
        Set_XSCRIPT_ScriptID(g_ExeScript)
        Set_XSCRIPT_Parameter(0,1);
        Set_XSCRIPT_Parameter(1,nPos-1);
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()  
end
--µã»÷¼¼ÄÜ²Û
-- function CJ_Backpack_Skill_Click( nPos,bClicked )
--     if nPos < 1 or nPos > g_TLCJ_SKILLSLOT_NUM then
--         return 
--     end
--     local actionBtn = g_UI_Items.skillslots[nPos]
--     if actionBtn:GetActionItem() < 1 then
--         return 
--     end
--     if bClicked == 1 then
--         actionBtn:DoAction();
--     else
--         if LuaIsFighting() == 1 then
--             PushDebugMessage(" ½¶·×´Ì¬ÖÐ£¬ÎÞ·¨½øÐÐ´Ë²Ù×÷¡£")
--             return 
--         end
--         Clear_XSCRIPT()
--         Set_XSCRIPT_Function_Name( "UseItem" )
--         Set_XSCRIPT_ScriptID(g_ExeScript)
--         Set_XSCRIPT_Parameter(0,2);
--         Set_XSCRIPT_Parameter(1,nPos-1);
--         Set_XSCRIPT_ParamCount(2)
--         Send_XSCRIPT()
--     end
-- end


--µã»÷¼¼ÄÜ°ü
-- function CJ_Backpack_Skill_Item_Click(nPos,bClicked)
--     local  actionBtn = g_UI_Items.skillbags[nPos]
--     if actionBtn:GetActionItem() < 1 then
--         return 
--     end
--     if LuaIsFighting() == 1 then
-- 		PushDebugMessage(" ½¶·×´Ì¬ÖÐ£¬ÎÞ·¨½øÐÐ´Ë²Ù×÷¡£")
--         return 
--     end
--     Clear_XSCRIPT()
--     Set_XSCRIPT_Function_Name( "UseItem" )
--     Set_XSCRIPT_ScriptID(g_ExeScript)
--     Set_XSCRIPT_Parameter(0,5);
--     Set_XSCRIPT_Parameter(1,nPos-1);
--     Set_XSCRIPT_ParamCount(2)
--     Send_XSCRIPT()  
-- end


-- ¸üÐÂÖ÷½Ç»ù±¾ÐÅÏ¢
function CJ_Backpack_OnUpdateShow()
	local nNumber=0;
	local nMaxnumber=0;
	local strName;

    
	-- µÃµ½×Ô¼ºµÄÃû×Ö
    strName = Player:GetName();
    CJ_Backpack_ShuXingTitle:SetText("#gFF0FA0".. strName );

    -- µÃµ½ÑªÖµ
    nNumber = Player:GetData("HP");
    nMaxnumber = Player:GetData( "MAXHP" );
    local HPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
    CJ_Backpack_HP_Num:SetText( HPText );


	-- -- µÃµ½Ä§·¨Öµ
	-- nNumber = Player:GetData( "MP" );
	-- nMaxnumber = Player:GetData( "MAXMP" );

	-- local MPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	-- MPText = "#cFAFFA4"..MPText;
	-- SelfEquip_MP:SetText( MPText );
    
	-- -- Å­Æø
	-- local menpai = Player:GetData("MEMPAI");
	-- if 13 ~= menpai then
	--   nNumber = Player:GetData("RAGE");
	--   nMaxnumber = Player:GetData("MAXRAGE");
	--   local RageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	--   RageText = "#cFAFFA4"..RageText;
	-- 	SelfEquip_SP:SetText( RageText );	
	-- 	SelfEquip_SP_Text:SetText("#{INTERFACE_XML_481}")
	-- else
	--   nNumber = Player:GetData("ENG");
	--   nMaxnumber = Player:GetData("MAXENG");
	--   local RageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	--   RageText = "#cFAFFA4"..RageText;
	-- 	SelfEquip_SP:SetText( RageText );	
	-- 	SelfEquip_SP_Text:SetText("¹²Çé:")
	-- 	SelfEquip_SP_Text:SetToolTip("#{THJN_191001_01}")
	-- end


	-- -- µÃµ½µ±Ç°¾­Ñé
	local g_CurExperience = TLCJ:GetData("EXP");
	local CurExpText = tostring( g_CurExperience );
	-- CurExpText = "#cC8B88E"..CurExpText;
	-- SelfEquip_Exp2:SetText( CurExpText );

	-- -- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
	 g_RequireExperience = TLCJ:GetData("NEEDEXP");
	local NeedExpText =  tostring( g_RequireExperience );
	NeedExpText = "#cC8B88E"..CurExpText.."/"..NeedExpText;
	CJ_Backpack_NextLVNeed_Num:SetText( NeedExpText );
    CJ_Backpack_Level_EXPLace:SetProgress(g_CurExperience,g_RequireExperience)

	-- ¸ù¾Ý¾­Ñé½ûÖ¹»ò ß´ò¿ªÉý¼¶
	-- if(g_CurExperience >= g_RequireExperience) then

	-- 	SelfEquip_UpLevel:Enable();
	-- else

	-- 	SelfEquip_UpLevel:Disable();
	-- end

	-- µÃµ½µÈ¼¶
	nNumber =  TLCJ:GetData( "LEVEL" );
	local LevelText = tostring( nNumber ).." C¤p";
	LevelText = "#cC8B88E"..LevelText;
	CJ_Backpack_Level_Num:SetText( LevelText );

    --µÃµ½ÃÅÅÉ
    nNumber =  TLCJ:GetData( "MENPAI" );
	-- local LevelText = GetMenpaiByID(nNumber);
	-- LevelText = "#cC8B88E"..LevelText;
	--CJ_Backpack_MenPai_Num:SetText( LevelText );
    if g_menpaiImage[nNumber] then
        CJ_Backpack_MenPaiImage:SetProperty("Image",g_menpaiImage[nNumber])
    end
    -- Á¦Á¿
    nNumber = Player:GetData("STR");
    local StrText = tostring( nNumber );
    --StrText = "#DED784"..StrText;
	CJ_Backpack_Str_Num:SetText( StrText );

	-- ÁéÆø
    nNumber = Player:GetData("SPR");
    local SprText = tostring( nNumber );
    --SprText = "#DED784"..SprText;
     CJ_Backpack_Nimbus_Num:SetText( SprText );

	-- ÌåÖÊ
	nNumber = Player:GetData("CON");
	local ConText = tostring( nNumber );
	CJ_Backpack_PhysicalStrength_Num:SetText( ConText );

	-- ¶¨Á¦
	nNumber = Player:GetData("INT");
	CJ_Backpack_Stability_Num:SetText( tostring( nNumber ) );

	-- Éí·¨
	nNumber = Player:GetData("DEX");
	CJ_Backpack_Footwork_Num:SetText( tostring( nNumber ) );


	-- ÎïÀí¹¥»÷
	nNumber = Player:GetData("ATT_PHYSICS");
	CJ_Backpack_Perporty1_Num:SetText( tostring( nNumber ) );

	-- ÎïÀí·ÀÓù
	nNumber = Player:GetData("DEF_PHYSICS");
	if nNumber > 999999 then --?????? modified by hukai
		CJ_Backpack_Perporty3_Num:SetText( "??????" );
	else
		CJ_Backpack_Perporty3_Num:SetText( tostring( nNumber ) );
	end

	-- Ä§·¨¹¥»÷
	nNumber = Player:GetData("ATT_MAGIC");
	CJ_Backpack_Perporty2_Num:SetText( tostring( nNumber ) );

	-- Ä§·¨·ÀÓù
	nNumber = Player:GetData("DEF_MAGIC");
	if nNumber > 999999 then --?????? modified by hukai
		CJ_Backpack_Perporty4_Num:SetText( "??????" );
	else
		CJ_Backpack_Perporty4_Num:SetText( tostring( nNumber ) );
	end

	-- ÉÁ±ÜÂÊ
	nNumber = Player:GetData("MISS");
	CJ_Backpack_Perporty6_Num:SetText( tostring( nNumber ) );

	-- ÃüÖÐÂÊ
	nNumber = Player:GetData("HIT");
	CJ_Backpack_Perporty5_Num:SetText( tostring( nNumber ) );

    	-- »áÐÄ¹¥»÷
	nNumber = Player:GetData("CRITICALATTACK");
	CJ_Backpack_Perporty7_Num:SetText( tostring( nNumber ) );

	-- »áÐÄ·ÀÓù
	nNumber = Player:GetData("CRITICALDEFENCE");
	CJ_Backpack_Perporty8_Num:SetText( tostring( nNumber ) );

    CJ_Backpack_SetStateTooltip()
end

--¹Ø± 
-- function CJ_Backpack_Leave_Clicked()
--     if TLCJ:IsInTLCJScene() > 0 then
-- 		Clear_XSCRIPT()
--         Set_XSCRIPT_Function_Name( "ClientAskLeave" )
--         Set_XSCRIPT_ScriptID(999321)
--         Set_XSCRIPT_Parameter(0,0)
--         Set_XSCRIPT_ParamCount(1)
--         Send_XSCRIPT()
-- 	end
-- end
function CJ_Backpack_Close_OnClicked()
    this:Hide()
end

function CJ_Backpack_On_ResetPos()
	CJ_Backpack_Frame:SetProperty("UnifiedPosition", g_CJ_Backpack_UnifiedPosition);
end


---------------------------------------------------------------------------------
--
-- ÉèÖÃ×´Ì¬tooltip
--
function CJ_Backpack_SetStateTooltip()


	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceDefine  		= Player:GetData( "DEFENCECOLD" );
	local iFireDefine 		= Player:GetData( "DEFENCEFIRE" );
	local iThunderDefine	= Player:GetData( "DEFENCELIGHT" );
	local iPoisonDefine		= Player:GetData( "DEFENCEPOISON" );

	--²»ÏÔÊ¾¸º¿¹ÐÔ
	if (iIceDefine ~= nil and iIceDefine < 0) then
		iIceDefine = 0
	end
	if (iFireDefine ~= nil and iFireDefine < 0) then
		iFireDefine = 0
	end
	if (iThunderDefine ~= nil and iThunderDefine < 0) then
		iThunderDefine = 0
	end
	if (iPoisonDefine ~= nil and iPoisonDefine < 0) then
		iPoisonDefine = 0
	end

	local iIceAttack  		= Player:GetData( "ATTACKCOLD" );
	local iFireAttack 		= Player:GetData( "ATTACKFIRE" );
	local iThunderAttack	= Player:GetData( "ATTACKLIGHT" );
	local iPoisonAttack		= Player:GetData( "ATTACKPOISON" );

	local iIceResistOther	= Player:GetData( "RESISTOTHERCOLD" );
	local iFireResistOther= Player:GetData( "RESISTOTHERFIRE" );
	local iThunderResistOther	= Player:GetData( "RESISTOTHERLIGHT" );
	local iPoisonResistOther= Player:GetData( "RESISTOTHERPOISON" );

	local iIceResistLimit = Player:GetData("SUBRESISTLIMITCOLD")
	local iFireResistLimit = Player:GetData("SUBRESISTLIMITFIRE")
	local iThunderResistLimit = Player:GetData("SUBRESISTLIMITLIGHT")
	local iPoisonResistLimit = Player:GetData("SUBRESISTLIMITPOISON")


	CJ_Backpack_IceFastness:SetToolTip("Bång công:"..tostring(iIceAttack).."#rBång Kháng:"..tostring(iIceDefine).."#rGiäm Bång Kháng:"..tostring(iIceResistOther).."#{JKXX_091228_1}"..tostring(iIceResistLimit));
	CJ_Backpack_FireFastness:SetToolTip("Höa công:"..tostring(iFireAttack).."#rHoä Kháng:"..tostring(iFireDefine).."#rGiäm Hoä Kháng:"..tostring(iFireResistOther) .."#{JKXX_091228_2}"..tostring(iFireResistLimit));
	CJ_Backpack_ThunderFastness:SetToolTip("Huy«n công:"..tostring(iThunderAttack).."#rHuy«n Kháng:"..tostring(iThunderDefine).."#rGiäm Huy«n Kháng:"..tostring(iThunderResistOther).."#{JKXX_091228_3}"..tostring(iThunderResistLimit) );
	CJ_Backpack_PoisonFastness:SetToolTip("Ðµc công:"..tostring(iPoisonAttack).."#rÐµc Kháng:"..tostring(iPoisonDefine).."#rGiäm Ðµc Kháng:"..tostring(iPoisonResistOther) .."#{JKXX_091228_4}"..tostring(iPoisonResistLimit));
		
end
