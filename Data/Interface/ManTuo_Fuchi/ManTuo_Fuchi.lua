--关怀绝情谷
 
local g_ManTuo_Fuchi_Frame_UnifiedPosition 
local g_ManTuo_Fuchi_Client = {}
local g_ManTuo_Fuchi_Page1_Ctl = {}
local g_ManTuo_Fuchi_Page2_Ctl = {}
local g_ManTuo_Fuchi_Page3_Ctl = {}
local g_ManTuo_Fuchi_ClientBtn = {}
local g_ManTuo_Fuchi_ClientBtnTips = {}
local g_ManTuo_Fuchi_Page1_Award = {
    [1] = {id=30505283,num=2,bind=1,},
    [2] = {id=30008027,num=1,bind=1,},
    [3] = {id=30501361,num=1,bind=1,},
}
local g_ManTuo_Fuchi_Page2_Award = {
    [1] = {
            needlevel = 40,  
            iteminfo  ={ 
                [1] = {id=30505900,num=1,bind=1,},
                [2] = {id=30302573,num=1,bind=1,},
                [3] = {id=30900045,num=1,bind=1,},
            },
        }, 
    [2] = {
            needlevel = 50,  
            iteminfo  ={ 
                [1] = {id=30505801,num=10,bind=1,},
                [2] = {id=20310168,num=10,bind=1,},
                [3] = {id=30503149,num=1,bind=1,},
            },
        }, 
    [3] = {
            needlevel = 60,  
            iteminfo  ={ 
                [1] = {id=30505802,num=15,bind=1,},
                [2] = {id=10156003,num=1,bind=1,},
                [3] = {id=10156004,num=1,bind=1,},
            },
        }, 
    [4] = {
            needlevel = 70,  
            iteminfo  ={ 
                [1] = {id=30505803,num=20,bind=1,},
                [2] = {id=30501361,num=5,bind=1,},
                [3] = {id=20310114,num=10,bind=1,},
            },
        }, 
    [5] = {
            needlevel = 80,  
            iteminfo  ={ 
                [1] = {id=30505804,num=20,bind=1,},
                [2] = {id=20800013,num=20,bind=1,},
                [3] = {id=38002530,num=20,bind=1,},
            },
        }, 
    [6] = {
            needlevel = 90,  
            iteminfo  ={ 
                [1] = {id=50413004,num=1,bind=1,},
                [2] = {id=10124071,num=1,bind=1,},
                [3] = {id=10141933,num=1,bind=1,},
            },
        },     
}
local g_ManTuo_Fuchi_Page3_Award = {
    [1] = {
            needmoney = 860, 
            maxcount  = 5,
            mdidx     = 0, 
            iteminfo = {
                [1] = {id=50313004,num=2,bind=1,},
                [2] = {id=30008027,num=2,bind=1,}, 
            },
        }, 
    [2] = {
            needmoney = 2000, 
            maxcount  = 3,
            mdidx     = 1, 
            iteminfo = {
                [1] = {id=30900045,num=3,bind=1,},
                [2] = {id=30008048,num=1,bind=1,}, 
            },
        }, 
    [3] = {
            needmoney = 860, 
            maxcount  = 3,
            mdidx     = 2, 
            iteminfo = {
                [1] = {id=20310168,num=20,bind=1,},
                [2] = {id=30503133,num=3,bind=1,}, 
            },
        }, 
    [4] = {
            needmoney = 750, 
            maxcount  = 2,
            mdidx     = 3, 
            iteminfo = {
                [1] = {id=30502002,num=10,bind=1,},
                [2] = {id=20310116,num=5,bind=1,}, 
            },
        }, 
    [5] = {
            needmoney = 3800, 
            maxcount  = 2,
            mdidx     = 4, 
            iteminfo = {
                [1] = {id=20800013,num=20,bind=1,},
                [2] = {id=38002397,num=90,bind=1,}, 
            },
        }, 
    [6] = {
            needmoney = 6800, 
            maxcount  = 1,
            mdidx     = 5, 
            iteminfo = {
                [1] = {id=38002532,num=40,bind=1,},
                [2] = {id=38002397,num=180,bind=1,}, 
            },
        },     
}

local g_ManTuo_Fuchi_Page1_Flag = 0
local g_ManTuo_Fuchi_Page2_Flag = {}
local g_ManTuo_Fuchi_Page3_MDData = 0
local g_ManTuo_Fuchi_EndTime = 0
local g_Fuchi_EndYear= 0
local g_Fuchi_EndMonth= 0
local g_Fuchi_EndDay  = 0
local g_Fuchi_EndHour = 0
local g_ManTuo_Fuchi_CurPage = 1
function ManTuo_Fuchi_PreLoad()

	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("UNIT_LEVEL", true);
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("ADJEST_UI_POS",false) 
	this:RegisterEvent("GUANHUAIMTSZ_OPEN",true) 
	this:RegisterEvent("GUANHUAIMTSZ_REFRESH",true) 
	
end

function ManTuo_Fuchi_OnLoad()
	ManTuo_Fuchi_LoadControl()
	g_ManTuo_Fuchi_Frame_UnifiedPosition = ManTuo_Fuchi_FrameNULL:GetProperty("UnifiedPosition") 	
end

--=========
-- 装载控件
--=========
function ManTuo_Fuchi_LoadControl()     
    g_ManTuo_Fuchi_Client[1] = ManTuo_Fuchi_Client1
    g_ManTuo_Fuchi_Client[2] = ManTuo_Fuchi_Client2
    g_ManTuo_Fuchi_Client[3] = ManTuo_Fuchi_Client3

    g_ManTuo_Fuchi_ClientBtn[1] = ManTuo_Fuchi_Left_Buttontab01
    g_ManTuo_Fuchi_ClientBtn[2] = ManTuo_Fuchi_Left_Buttontab02
    g_ManTuo_Fuchi_ClientBtn[3] = ManTuo_Fuchi_Left_Buttontab03

    g_ManTuo_Fuchi_ClientBtnTips[1] = ManTuo_Fuchi_Left_Buttontab01_Tips
    g_ManTuo_Fuchi_ClientBtnTips[2] = ManTuo_Fuchi_Left_Buttontab02_Tips
    g_ManTuo_Fuchi_ClientBtnTips[3] = ManTuo_Fuchi_Left_Buttontab03_Tips

    g_ManTuo_Fuchi_Page1_Ctl.Action = {}
    g_ManTuo_Fuchi_Page1_Ctl.Action[1] = ManTuo_Fuchi_Act1Icon1
    g_ManTuo_Fuchi_Page1_Ctl.Action[2] = ManTuo_Fuchi_Act1Icon2
    g_ManTuo_Fuchi_Page1_Ctl.Action[3] = ManTuo_Fuchi_Act1Icon3
    g_ManTuo_Fuchi_Page1_Ctl.Btn       = ManTuo_Fuchi_Act1Btn 
    g_ManTuo_Fuchi_Page1_Ctl.BtnTips   = ManTuo_Fuchi_Act1Btn_Tips 
 
    g_ManTuo_Fuchi_Page2_Ctl[1] = {}
    g_ManTuo_Fuchi_Page2_Ctl[1].tubiaoicon   = ManTuo_Fuchi_Client2_Item1_Icon
    g_ManTuo_Fuchi_Page2_Ctl[1].mubiaotext   = ManTuo_Fuchi_Client2_Item1_Text
    g_ManTuo_Fuchi_Page2_Ctl[1].dangqiantext = ManTuo_Fuchi_Client2_Item1_Text2
    g_ManTuo_Fuchi_Page2_Ctl[1].action       = {}
    g_ManTuo_Fuchi_Page2_Ctl[1].action[1]    = ManTuo_Fuchi_Client2_Item1_Icon0
    g_ManTuo_Fuchi_Page2_Ctl[1].action[2]    = ManTuo_Fuchi_Client2_Item1_Icon1
    g_ManTuo_Fuchi_Page2_Ctl[1].action[3]    = ManTuo_Fuchi_Client2_Item1_Icon2
    g_ManTuo_Fuchi_Page2_Ctl[1].button       = ManTuo_Fuchi_Client2_Item1_OK
    g_ManTuo_Fuchi_Page2_Ctl[1].buttontips   = ManTuo_Fuchi_Client2_Item1_Tips
    g_ManTuo_Fuchi_Page2_Ctl[1].yidacheng    = ManTuo_Fuchi_Client2_Item1_Received
    
    g_ManTuo_Fuchi_Page2_Ctl[2] = {}
    g_ManTuo_Fuchi_Page2_Ctl[2].tubiaoicon   = ManTuo_Fuchi_Client2_Item2_Icon
    g_ManTuo_Fuchi_Page2_Ctl[2].mubiaotext   = ManTuo_Fuchi_Client2_Item2_Text
    g_ManTuo_Fuchi_Page2_Ctl[2].dangqiantext = ManTuo_Fuchi_Client2_Item2_Text2
    g_ManTuo_Fuchi_Page2_Ctl[2].action       = {}
    g_ManTuo_Fuchi_Page2_Ctl[2].action[1]    = ManTuo_Fuchi_Client2_Item2_Icon0
    g_ManTuo_Fuchi_Page2_Ctl[2].action[2]    = ManTuo_Fuchi_Client2_Item2_Icon1
    g_ManTuo_Fuchi_Page2_Ctl[2].action[3]    = ManTuo_Fuchi_Client2_Item2_Icon2
    g_ManTuo_Fuchi_Page2_Ctl[2].button       = ManTuo_Fuchi_Client2_Item2_OK
    g_ManTuo_Fuchi_Page2_Ctl[2].buttontips   = ManTuo_Fuchi_Client2_Item2_Tips
    g_ManTuo_Fuchi_Page2_Ctl[2].yidacheng    = ManTuo_Fuchi_Client2_Item2_Received
    
    g_ManTuo_Fuchi_Page2_Ctl[3] = {}
    g_ManTuo_Fuchi_Page2_Ctl[3].tubiaoicon   = ManTuo_Fuchi_Client2_Item3_Icon
    g_ManTuo_Fuchi_Page2_Ctl[3].mubiaotext   = ManTuo_Fuchi_Client2_Item3_Text
    g_ManTuo_Fuchi_Page2_Ctl[3].dangqiantext = ManTuo_Fuchi_Client2_Item3_Text2
    g_ManTuo_Fuchi_Page2_Ctl[3].action       = {}
    g_ManTuo_Fuchi_Page2_Ctl[3].action[1]    = ManTuo_Fuchi_Client2_Item3_Icon0
    g_ManTuo_Fuchi_Page2_Ctl[3].action[2]    = ManTuo_Fuchi_Client2_Item3_Icon1
    g_ManTuo_Fuchi_Page2_Ctl[3].action[3]    = ManTuo_Fuchi_Client2_Item3_Icon2
    g_ManTuo_Fuchi_Page2_Ctl[3].button       = ManTuo_Fuchi_Client2_Item3_OK
    g_ManTuo_Fuchi_Page2_Ctl[3].buttontips   = ManTuo_Fuchi_Client2_Item3_Tips
    g_ManTuo_Fuchi_Page2_Ctl[3].yidacheng    = ManTuo_Fuchi_Client2_Item3_Received
    
    g_ManTuo_Fuchi_Page2_Ctl[4] = {}
    g_ManTuo_Fuchi_Page2_Ctl[4].tubiaoicon   = ManTuo_Fuchi_Client2_Item4_Icon
    g_ManTuo_Fuchi_Page2_Ctl[4].mubiaotext   = ManTuo_Fuchi_Client2_Item4_Text
    g_ManTuo_Fuchi_Page2_Ctl[4].dangqiantext = ManTuo_Fuchi_Client2_Item4_Text2
    g_ManTuo_Fuchi_Page2_Ctl[4].action       = {}
    g_ManTuo_Fuchi_Page2_Ctl[4].action[1]    = ManTuo_Fuchi_Client2_Item4_Icon0
    g_ManTuo_Fuchi_Page2_Ctl[4].action[2]    = ManTuo_Fuchi_Client2_Item4_Icon1
    g_ManTuo_Fuchi_Page2_Ctl[4].action[3]    = ManTuo_Fuchi_Client2_Item4_Icon2
    g_ManTuo_Fuchi_Page2_Ctl[4].button       = ManTuo_Fuchi_Client2_Item4_OK
    g_ManTuo_Fuchi_Page2_Ctl[4].buttontips   = ManTuo_Fuchi_Client2_Item4_Tips
    g_ManTuo_Fuchi_Page2_Ctl[4].yidacheng    = ManTuo_Fuchi_Client2_Item4_Received
    
    g_ManTuo_Fuchi_Page2_Ctl[5] = {}
    g_ManTuo_Fuchi_Page2_Ctl[5].tubiaoicon   = ManTuo_Fuchi_Client2_Item5_Icon
    g_ManTuo_Fuchi_Page2_Ctl[5].mubiaotext   = ManTuo_Fuchi_Client2_Item5_Text
    g_ManTuo_Fuchi_Page2_Ctl[5].dangqiantext = ManTuo_Fuchi_Client2_Item5_Text2
    g_ManTuo_Fuchi_Page2_Ctl[5].action       = {}
    g_ManTuo_Fuchi_Page2_Ctl[5].action[1]    = ManTuo_Fuchi_Client2_Item5_Icon0
    g_ManTuo_Fuchi_Page2_Ctl[5].action[2]    = ManTuo_Fuchi_Client2_Item5_Icon1
    g_ManTuo_Fuchi_Page2_Ctl[5].action[3]    = ManTuo_Fuchi_Client2_Item5_Icon2
    g_ManTuo_Fuchi_Page2_Ctl[5].button       = ManTuo_Fuchi_Client2_Item5_OK
    g_ManTuo_Fuchi_Page2_Ctl[5].buttontips   = ManTuo_Fuchi_Client2_Item5_Tips
    g_ManTuo_Fuchi_Page2_Ctl[5].yidacheng    = ManTuo_Fuchi_Client2_Item5_Received
    
    g_ManTuo_Fuchi_Page2_Ctl[6] = {}
    g_ManTuo_Fuchi_Page2_Ctl[6].tubiaoicon   = ManTuo_Fuchi_Client2_Item6_Icon
    g_ManTuo_Fuchi_Page2_Ctl[6].mubiaotext   = ManTuo_Fuchi_Client2_Item6_Text
    g_ManTuo_Fuchi_Page2_Ctl[6].dangqiantext = ManTuo_Fuchi_Client2_Item6_Text2
    g_ManTuo_Fuchi_Page2_Ctl[6].action       = {}
    g_ManTuo_Fuchi_Page2_Ctl[6].action[1]    = ManTuo_Fuchi_Client2_Item6_Icon0
    g_ManTuo_Fuchi_Page2_Ctl[6].action[2]    = ManTuo_Fuchi_Client2_Item6_Icon1
    g_ManTuo_Fuchi_Page2_Ctl[6].action[3]    = ManTuo_Fuchi_Client2_Item6_Icon2
    g_ManTuo_Fuchi_Page2_Ctl[6].button       = ManTuo_Fuchi_Client2_Item6_OK
    g_ManTuo_Fuchi_Page2_Ctl[6].buttontips   = ManTuo_Fuchi_Client2_Item6_Tips
    g_ManTuo_Fuchi_Page2_Ctl[6].yidacheng    = ManTuo_Fuchi_Client2_Item6_Received
 
    g_ManTuo_Fuchi_Page3_Ctl[1] = {}
    g_ManTuo_Fuchi_Page3_Ctl[1].action       = {}
    g_ManTuo_Fuchi_Page3_Ctl[1].action[1]    = ManTuo_Fuchi_Client3_Bk1_Icon1
    g_ManTuo_Fuchi_Page3_Ctl[1].action[2]    = ManTuo_Fuchi_Client3_Bk1_Icon2
    g_ManTuo_Fuchi_Page3_Ctl[1].shoujiatext  = ManTuo_Fuchi_Client3_Bk1_Text1_1
    g_ManTuo_Fuchi_Page3_Ctl[1].shengyutext  = ManTuo_Fuchi_Client3_Bk1_Text1_2
    g_ManTuo_Fuchi_Page3_Ctl[1].button       = ManTuo_Fuchi_Client3_Bk1_Button1
    
    g_ManTuo_Fuchi_Page3_Ctl[2] = {}
    g_ManTuo_Fuchi_Page3_Ctl[2].action       = {}
    g_ManTuo_Fuchi_Page3_Ctl[2].action[1]    = ManTuo_Fuchi_Client3_Bk2_Icon1
    g_ManTuo_Fuchi_Page3_Ctl[2].action[2]    = ManTuo_Fuchi_Client3_Bk2_Icon2
    g_ManTuo_Fuchi_Page3_Ctl[2].shoujiatext  = ManTuo_Fuchi_Client3_Bk2_Text1_1
    g_ManTuo_Fuchi_Page3_Ctl[2].shengyutext  = ManTuo_Fuchi_Client3_Bk2_Text1_2
    g_ManTuo_Fuchi_Page3_Ctl[2].button       = ManTuo_Fuchi_Client3_Bk2_Button1
    
    g_ManTuo_Fuchi_Page3_Ctl[3] = {}
    g_ManTuo_Fuchi_Page3_Ctl[3].action       = {}
    g_ManTuo_Fuchi_Page3_Ctl[3].action[1]    = ManTuo_Fuchi_Client3_Bk3_Icon1
    g_ManTuo_Fuchi_Page3_Ctl[3].action[2]    = ManTuo_Fuchi_Client3_Bk3_Icon2
    g_ManTuo_Fuchi_Page3_Ctl[3].shoujiatext  = ManTuo_Fuchi_Client3_Bk3_Text1_1
    g_ManTuo_Fuchi_Page3_Ctl[3].shengyutext  = ManTuo_Fuchi_Client3_Bk3_Text1_2
    g_ManTuo_Fuchi_Page3_Ctl[3].button       = ManTuo_Fuchi_Client3_Bk3_Button1
    
    g_ManTuo_Fuchi_Page3_Ctl[4] = {}
    g_ManTuo_Fuchi_Page3_Ctl[4].action       = {}
    g_ManTuo_Fuchi_Page3_Ctl[4].action[1]    = ManTuo_Fuchi_Client3_Bk4_Icon1
    g_ManTuo_Fuchi_Page3_Ctl[4].action[2]    = ManTuo_Fuchi_Client3_Bk4_Icon2
    g_ManTuo_Fuchi_Page3_Ctl[4].shoujiatext  = ManTuo_Fuchi_Client3_Bk4_Text1_1
    g_ManTuo_Fuchi_Page3_Ctl[4].shengyutext  = ManTuo_Fuchi_Client3_Bk4_Text1_2
    g_ManTuo_Fuchi_Page3_Ctl[4].button       = ManTuo_Fuchi_Client3_Bk4_Button1
    
    g_ManTuo_Fuchi_Page3_Ctl[5] = {}
    g_ManTuo_Fuchi_Page3_Ctl[5].action       = {}
    g_ManTuo_Fuchi_Page3_Ctl[5].action[1]    = ManTuo_Fuchi_Client3_Bk5_Icon1
    g_ManTuo_Fuchi_Page3_Ctl[5].action[2]    = ManTuo_Fuchi_Client3_Bk5_Icon2
    g_ManTuo_Fuchi_Page3_Ctl[5].shoujiatext  = ManTuo_Fuchi_Client3_Bk5_Text1_1
    g_ManTuo_Fuchi_Page3_Ctl[5].shengyutext  = ManTuo_Fuchi_Client3_Bk5_Text1_2
    g_ManTuo_Fuchi_Page3_Ctl[5].button       = ManTuo_Fuchi_Client3_Bk5_Button1
    
    g_ManTuo_Fuchi_Page3_Ctl[6] = {}
    g_ManTuo_Fuchi_Page3_Ctl[6].action       = {}
    g_ManTuo_Fuchi_Page3_Ctl[6].action[1]    = ManTuo_Fuchi_Client3_Bk6_Icon1
    g_ManTuo_Fuchi_Page3_Ctl[6].action[2]    = ManTuo_Fuchi_Client3_Bk6_Icon2
    g_ManTuo_Fuchi_Page3_Ctl[6].shoujiatext  = ManTuo_Fuchi_Client3_Bk6_Text1_1
    g_ManTuo_Fuchi_Page3_Ctl[6].shengyutext  = ManTuo_Fuchi_Client3_Bk6_Text1_2
    g_ManTuo_Fuchi_Page3_Ctl[6].button       = ManTuo_Fuchi_Client3_Bk6_Button1
end

--=========
-- Event
--=========
function ManTuo_Fuchi_OnEvent(event) 
	if ( event == "UI_COMMAND" and tonumber(arg0) == 88892101 ) then
		if this:IsVisible() then
			ManTuo_Fuchi_Close()
			return
        end 
        g_ManTuo_Fuchi_EndTime    = Get_XParam_INT(0)
        --Lua_TDU_Log("g_ManTuo_Fuchi_EndTime:"..g_ManTuo_Fuchi_EndTime);
        g_ManTuo_Fuchi_Page1_Flag = Get_XParam_INT(1)
        for i = 1, table.getn(g_ManTuo_Fuchi_Page2_Ctl) do            
            g_ManTuo_Fuchi_Page2_Flag[i] = Get_XParam_INT(1+i)
            --Lua_TDU_Log("g_ManTuo_Fuchi_Page2_Flag:"..i..":"..g_ManTuo_Fuchi_Page2_Flag[i] );
        end
        g_ManTuo_Fuchi_Page3_MDData = Get_XParam_INT(8)
        --Lua_TDU_Log("g_ManTuo_Fuchi_Page3_MDData:"..g_ManTuo_Fuchi_Page3_MDData);
        g_ManTuo_Fuchi_CurPage = 1;
        ManTuo_Fuchi_Clicked(1)
        this:Show() 	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		ManTuo_Fuchi_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ManTuo_Fuchi_Close()
	elseif event == "ADJEST_UI_POS" then
        ManTuo_Fuchi_On_ResetPos()  
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 88892102 ) then
        g_ManTuo_Fuchi_EndTime    = Get_XParam_INT(0)
        --Lua_TDU_Log("g_ManTuo_Fuchi_EndTime:"..g_ManTuo_Fuchi_EndTime);
        g_ManTuo_Fuchi_Page1_Flag = Get_XParam_INT(1)
        for i = 1, table.getn(g_ManTuo_Fuchi_Page2_Ctl) do            
            g_ManTuo_Fuchi_Page2_Flag[i] = Get_XParam_INT(1+i)
            --Lua_TDU_Log("g_ManTuo_Fuchi_Page2_Flag:"..i..":"..g_ManTuo_Fuchi_Page2_Flag[i] );
        end
        g_ManTuo_Fuchi_Page3_MDData = Get_XParam_INT(8)
        --Lua_TDU_Log("g_ManTuo_Fuchi_Page3_MDData:"..g_ManTuo_Fuchi_Page3_MDData); 
        ManTuo_Fuchi_Clicked(1)
        --this:Show() 	
    elseif event == "UNIT_LEVEL" then
        if this:IsVisible() then
            ManTuo_Fuchi_SetClientRedPoint()
        else
            ManTuo_Fuchi_SetMainRedPoint()
        end
	end

end
 
--=========
-- 重置
--=========
function ManTuo_Fuchi_On_ResetPos()
	ManTuo_Fuchi_FrameNULL:SetProperty("UnifiedPosition", g_ManTuo_Fuchi_Frame_UnifiedPosition)
end

--=========
-- 关睜
--========= 
function ManTuo_Fuchi_Close()  
    g_ManTuo_Fuchi_CurPage = 1;
	this:Hide()
end

function ManTuo_Fuchi_Tab_Click( idx )
    for i = 1, 3 do
        g_ManTuo_Fuchi_ClientBtn[i]:SetProperty("Selected", "False");
    end
    g_ManTuo_Fuchi_CurPage = idx
    ManTuo_Fuchi_Clicked( 1 )     
end
--=========
-- 打开
--=========
function ManTuo_Fuchi_Clicked( isopen )   	
    --红点
    ManTuo_Fuchi_SetClientRedPoint()
    for i = 1, table.getn(g_ManTuo_Fuchi_Client) do
        if isopen == 1 then
            g_ManTuo_Fuchi_Client[i]:Hide()
        end
    end
    if g_ManTuo_Fuchi_CurPage == 1 then
        ManTuo_Fuchi_Fresh_Page1()
    elseif g_ManTuo_Fuchi_CurPage == 2 then
        ManTuo_Fuchi_Fresh_Page2()
    elseif g_ManTuo_Fuchi_CurPage == 3 then
        ManTuo_Fuchi_Fresh_Page3()
    end
    
    g_ManTuo_Fuchi_ClientBtn[g_ManTuo_Fuchi_CurPage]:SetProperty("Selected", "True");
    g_ManTuo_Fuchi_Client[g_ManTuo_Fuchi_CurPage]:Show()
end 

--=========
-- 红点
--=========
function ManTuo_Fuchi_SetClientRedPoint() 
    g_Fuchi_EndYear  = math.floor(g_ManTuo_Fuchi_EndTime/1000000) +2000
	g_Fuchi_EndMonth = math.mod(math.floor(g_ManTuo_Fuchi_EndTime/10000),100)
	g_Fuchi_EndDay   = math.mod(math.floor(g_ManTuo_Fuchi_EndTime/100),100) 
    g_Fuchi_EndHour  = math.mod(g_ManTuo_Fuchi_EndTime,100)  

    local isShowMainTips = 0
    --page1
    if g_ManTuo_Fuchi_Page1_Flag == 0 then
        g_ManTuo_Fuchi_ClientBtnTips[1]:Show()
        g_ManTuo_Fuchi_Page1_Ctl.BtnTips:Show() 
        isShowMainTips = 1
    else
        g_ManTuo_Fuchi_ClientBtnTips[1]:Hide()
        g_ManTuo_Fuchi_Page1_Ctl.BtnTips:Hide() 
    end
    --page2
    g_ManTuo_Fuchi_ClientBtnTips[2]:Hide()
    for i = 1, table.getn(g_ManTuo_Fuchi_Page2_Flag) do
        local myLevel = Player:GetData("LEVEL") 
        --Lua_TDU_Log("myLevel"..myLevel);
        if g_ManTuo_Fuchi_Page2_Flag[i] == 0 and myLevel >= g_ManTuo_Fuchi_Page2_Award[i].needlevel then
            ManTuo_Fuchi_Left_Buttontab02_Tips:Show()
            isShowMainTips = 1
        end
    end
    --page3
    g_ManTuo_Fuchi_ClientBtnTips[3]:Hide()
    for i = 1, table.getn(g_ManTuo_Fuchi_Page3_Award) do        
        local ybidx = g_ManTuo_Fuchi_Page3_Award[i].mdidx
        local buycount= math.floor(math.mod(g_ManTuo_Fuchi_Page3_MDData, math.pow(10,ybidx+1))/math.pow(10,ybidx))	 
        local remiancount =  g_ManTuo_Fuchi_Page3_Award[i].maxcount - buycount
        if remiancount > 0 and g_ManTuo_Fuchi_Page3_Award[i].needmoney <= 0 then          
            ManTuo_Fuchi_Left_Buttontab03_Tips:Show()  
            isShowMainTips = 1
        end
    end 
    Lua_ShowQuickEnterPointTip(7,isShowMainTips)
end

function ManTuo_Fuchi_Fresh_Page1() 
    for i = 1, table.getn(g_ManTuo_Fuchi_Page1_Ctl.Action) do
        local id = g_ManTuo_Fuchi_Page1_Award[i].id
        local num= g_ManTuo_Fuchi_Page1_Award[i].num
        local theAction = DataPool:CreateBindActionItemForShow(id, num)
	    if theAction:GetID() ~= 0 then
	    	g_ManTuo_Fuchi_Page1_Ctl.Action[i]:SetActionItem(theAction:GetID())
	    end
    end
    if g_ManTuo_Fuchi_Page1_Flag == 0 then 
        g_ManTuo_Fuchi_Page1_Ctl.Btn:SetText("#{MPFC_220622_104}") 
        g_ManTuo_Fuchi_Page1_Ctl.Btn:Enable() 
    else 
        g_ManTuo_Fuchi_Page1_Ctl.Btn:SetText("#{MPFC_220622_105}") 
        g_ManTuo_Fuchi_Page1_Ctl.Btn:Disable()
    end
    ManTuo_Fuchi_ActText1:SetText(ScriptGlobal_Format("#{MPFC_220622_14}", g_Fuchi_EndYear, g_Fuchi_EndMonth, g_Fuchi_EndDay, g_Fuchi_EndHour))
end
 
function ManTuo_Fuchi_Fresh_Page2()     
    ManTuo_Fuchi_Client2_Info:SetText(ScriptGlobal_Format("#{MPFC_220622_19}", g_Fuchi_EndYear, g_Fuchi_EndMonth, g_Fuchi_EndDay, g_Fuchi_EndHour))
    for i = 1, table.getn(g_ManTuo_Fuchi_Page2_Ctl) do
        for j = 1, table.getn(g_ManTuo_Fuchi_Page2_Ctl[i].action) do            
            local id = g_ManTuo_Fuchi_Page2_Award[i].iteminfo[j].id
            local num= g_ManTuo_Fuchi_Page2_Award[i].iteminfo[j].num 
            local theAction = DataPool:CreateBindActionItemForShow(id, num)
            if theAction:GetID() ~= 0 then          
	        	g_ManTuo_Fuchi_Page2_Ctl[i].action[j]:SetActionItem(theAction:GetID())
	        end
        end
        local myLevel = Player:GetData("LEVEL") 
        if myLevel >= g_ManTuo_Fuchi_Page2_Award[i].needlevel then            
            g_ManTuo_Fuchi_Page2_Ctl[i].mubiaotext:SetText(ScriptGlobal_Format("#{MPFC_220622_124}",g_ManTuo_Fuchi_Page2_Award[i].needlevel))
            g_ManTuo_Fuchi_Page2_Ctl[i].dangqiantext:SetText(ScriptGlobal_Format("#{MPFC_220622_23}",g_ManTuo_Fuchi_Page2_Award[i].needlevel,g_ManTuo_Fuchi_Page2_Award[i].needlevel))
            if g_ManTuo_Fuchi_Page2_Flag[i] == 0 then
                g_ManTuo_Fuchi_Page2_Ctl[i].buttontips:Show()
            else
                g_ManTuo_Fuchi_Page2_Ctl[i].buttontips:Hide()
            end
        else
            g_ManTuo_Fuchi_Page2_Ctl[i].mubiaotext:SetText(ScriptGlobal_Format("#{MPFC_220622_125}",g_ManTuo_Fuchi_Page2_Award[i].needlevel))
            g_ManTuo_Fuchi_Page2_Ctl[i].dangqiantext:SetText(ScriptGlobal_Format("#{MPFC_220622_23}",myLevel,g_ManTuo_Fuchi_Page2_Award[i].needlevel))
            g_ManTuo_Fuchi_Page2_Ctl[i].buttontips:Hide()
        end
        if g_ManTuo_Fuchi_Page2_Flag[i] == 0 then
            g_ManTuo_Fuchi_Page2_Ctl[i].yidacheng:Hide()
            --g_ManTuo_Fuchi_Page2_Ctl[i].button:SetText("#{MPFC_220622_25}")
            g_ManTuo_Fuchi_Page2_Ctl[i].button:Enable()
            g_ManTuo_Fuchi_Page2_Ctl[i].button:Show()
        else
            g_ManTuo_Fuchi_Page2_Ctl[i].yidacheng:Show()
            --g_ManTuo_Fuchi_Page2_Ctl[i].button:SetText("#{MPFC_220622_26}")
            g_ManTuo_Fuchi_Page2_Ctl[i].button:Disable()
            g_ManTuo_Fuchi_Page2_Ctl[i].button:Hide()

        end
    end
end

function ManTuo_Fuchi_Fresh_Page3() 
    ManTuo_Fuchi_Client3_Info_Text:SetText(ScriptGlobal_Format("#{MPFC_220622_68}", g_Fuchi_EndYear, g_Fuchi_EndMonth, g_Fuchi_EndDay, g_Fuchi_EndHour))
    for i = 1, table.getn(g_ManTuo_Fuchi_Page3_Ctl) do
        g_ManTuo_Fuchi_Page3_Ctl[i].shoujiatext:SetText(ScriptGlobal_Format("#{MPFC_220622_101}",g_ManTuo_Fuchi_Page3_Award[i].needmoney))      
        local ybidx = g_ManTuo_Fuchi_Page3_Award[i].mdidx
        local buycount= math.floor(math.mod(g_ManTuo_Fuchi_Page3_MDData, math.pow(10,ybidx+1))/math.pow(10,ybidx))	 
        local remiancount =  g_ManTuo_Fuchi_Page3_Award[i].maxcount - buycount
        --Lua_TDU_Log("remiancount"..remiancount);
        if remiancount > 0 then           
            g_ManTuo_Fuchi_Page3_Ctl[i].shengyutext:SetText(ScriptGlobal_Format("#{MPFC_220622_114}",remiancount))         
        else
            g_ManTuo_Fuchi_Page3_Ctl[i].shengyutext:SetText(ScriptGlobal_Format("#{MPFC_220622_115}",remiancount))         
        end
        for j = 1, table.getn(g_ManTuo_Fuchi_Page3_Ctl[i].action) do            
            local id = g_ManTuo_Fuchi_Page3_Award[i].iteminfo[j].id
            local num= g_ManTuo_Fuchi_Page3_Award[i].iteminfo[j].num
            local theAction = DataPool:CreateBindActionItemForShow(id, num)
	        if theAction:GetID() ~= 0 then
	        	g_ManTuo_Fuchi_Page3_Ctl[i].action[j]:SetActionItem(theAction:GetID())
	        end
        end
    end
end

function ManTuo_Fuchi_Client1_GetGift()
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("GetPage1Gift")
        Set_XSCRIPT_ScriptID( 888921 ) 
        Set_XSCRIPT_ParamCount( 0 ); 
    Send_XSCRIPT() 
end

function ManTuo_Fuchi_Client2OKClick(idx)
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("GetPage2Gift")
        Set_XSCRIPT_ScriptID( 888921 ) 
        Set_XSCRIPT_Parameter( 0, idx ); 
        Set_XSCRIPT_ParamCount( 1 ); 
    Send_XSCRIPT() 
end

function ManTuo_Fuchi_Client3_GetGift(idx)
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("GetPage3Gift")
        Set_XSCRIPT_ScriptID( 888921 ) 
        Set_XSCRIPT_Parameter( 0, idx ); 
        Set_XSCRIPT_Parameter( 1, 0 ); 
        Set_XSCRIPT_ParamCount( 2 ); 
    Send_XSCRIPT() 
end 

function ManTuo_Fuchi_Help_Client2_Clicked() 
end

function ManTuo_Fuchi_SetMainRedPoint()
    g_Fuchi_EndYear  = math.floor(g_ManTuo_Fuchi_EndTime/1000000) +2000
	g_Fuchi_EndMonth = math.mod(math.floor(g_ManTuo_Fuchi_EndTime/10000),100)
	g_Fuchi_EndDay   = math.mod(math.floor(g_ManTuo_Fuchi_EndTime/100),100) 
    g_Fuchi_EndHour  = math.mod(g_ManTuo_Fuchi_EndTime,100)   
    local isShowMainTips = 0
    --page1
    if g_ManTuo_Fuchi_Page1_Flag == 0 then 
        isShowMainTips = 1  
    end
    --page2 
    for i = 1, table.getn(g_ManTuo_Fuchi_Page2_Flag) do
        local myLevel = Player:GetData("LEVEL") 
        --Lua_TDU_Log("myLevel"..myLevel);
        if g_ManTuo_Fuchi_Page2_Flag[i] == 0 and myLevel >= g_ManTuo_Fuchi_Page2_Award[i].needlevel then 
            isShowMainTips = 1
        end
    end
    --page3 
    for i = 1, table.getn(g_ManTuo_Fuchi_Page3_Award) do        
        local ybidx = g_ManTuo_Fuchi_Page3_Award[i].mdidx
        local buycount= math.floor(math.mod(g_ManTuo_Fuchi_Page3_MDData, math.pow(10,ybidx+1))/math.pow(10,ybidx))	 
        local remiancount =  g_ManTuo_Fuchi_Page3_Award[i].maxcount - buycount
        if remiancount > 0 and g_ManTuo_Fuchi_Page3_Award[i].needmoney <= 0 then        
            isShowMainTips = 1
        end
    end 
    Lua_ShowQuickEnterPointTip(7,isShowMainTips)
end
