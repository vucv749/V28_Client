
local g_ScenIDTable = {}

local g_iRoleSel = 0;
local g_SceneRand = {20, 60, 100, 100, 100, 100, 100, 100, 100, 100}

function IsValInTable( Table, Val )
    
    for i, TempVal in Table do
        if TempVal == Val then
            return 1
        end
    end
    
    return 0
    
end

function RandDefaultScene( Count )
	local nAllRand = g_SceneRand[Count];
  if nAllRand ~= nil then
	 	local nRand= math.random( 0, nAllRand-1 )
    for i=1, table.getn( g_SceneRand ) do
   		if nRand < g_SceneRand[i] then
   			return i-1
   		end
   	end
  end
  
  return -1
end

function RandomTable( Count )

    local TempTable
    TempTable = {}
    local nCurCount = 0
    
    --先固定第一位
    local nDefaultScn = RandDefaultScene( Count )
    if nDefaultScn >= 0 then
    	table.insert( TempTable, nCurCount, nDefaultScn )
    	nCurCount = nCurCount + 1
    end
    
    for i=0, 1000 do
    
			local RandomIndex = math.random( 0, Count - 1 )
			local InTable = IsValInTable( TempTable, RandomIndex )
 
			if( 0 == InTable ) then
				table.insert( TempTable, nCurCount, RandomIndex )
    		nCurCount = nCurCount + 1
				--AxTrace( 1, 0, "insert RandomIndex="..RandomIndex )
			end
		
			if( Count == table.getn( TempTable ) ) then
		  	 g_ScenIDTable = TempTable		    
		    return
			end
		
    
    end
        
end


function LogonList_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("OPEN_ENTERING_SCENE_DLG");

	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
end

-- 注册onLoad事件
function LogonList_OnLoad()
	
	
	--this:Show();
end

-- OnEvent
function LogonList_OnEvent(event)

	--this:Show();
	--
	-- 打开界面事件.
	--
	if ( event == "OPEN_ENTERING_SCENE_DLG" ) then

		AxTrace( 0,0, "打开场景选择列表");
		AddEnterSceneInfo(tonumber(arg0));
		this:Show();
		return;
	end;

	if ( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		this:Hide();
		return;
	end;

	
		
end


function AddEnterSceneInfo(iRoleIndex)

	-- 记录当前选择的角色。
	g_iRoleSel = iRoleIndex;
	
	LogOnlist_ClearData();
	local iSceneCount  = GameProduceLogin:GetSceneInfoCount(iRoleIndex);
	local strSceneName = "";
	
	-- 得到选择的角色可以进入的场景信息
	for index =0 , iSceneCount-1 do
	 	g_ScenIDTable[ index ] = index	
	 	--strSceneName = GameProduceLogin:GetSceneInfo(iRoleIndex, index);
		--LogOnlist_List:AddItem( strSceneName, index, "FFFFFFFF", 4 );
	end
	
	RandomTable( iSceneCount )
	
	local TableSize = table.getn( g_ScenIDTable )
	for  i=0, TableSize-1 do
	    strSceneName = GameProduceLogin:GetSceneInfo(iRoleIndex, g_ScenIDTable[i] );
	    LogOnlist_List:AddItem( strSceneName, i, "FFFFFFFF", 4 );
	end
	
	LogOnlist_List:SetItemSelect( 0 )
	
end;

function LogOnlist_Choose_Click()

	-- 进入新手村。
	local iSceneIndex = LogOnlist_List:GetFirstSelectItem();
	iSceneIndex = g_ScenIDTable[ iSceneIndex ]
	
	GameProduceLogin:EnterNewRoleScene(g_iRoleSel, iSceneIndex);
	this:Hide();
end;

function LogOnlist_Refuse_Click()

	this:Hide();
end;


function LogOnlist_ClearData()

	LogOnlist_List:ClearListBox();

end;