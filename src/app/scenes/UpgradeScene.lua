
local UpgradeScene = class("UpgradeScene", function()
							  return display.newScene("UpgradeScene")
end)

require "lfs"

function UpgradeScene:ctor()

  	--请求版本更新链接
  	Server:Instance():getversion()
end

function UpgradeScene:getVersionInfo()
  	local up_date=LocalData:Instance():get_version_date()
  	dump(up_date)
  	self.masterURL=up_date["masterURL"]
  	self.url=up_date["url"]
  	self:addChild(self:updateLayer())

end


function UpgradeScene:updateLayer()

	local targetPlatform = cc.Application:getInstance():getTargetPlatform()

	local lineSpace = 40
	local itemTagBasic = 1000
	local menuItemNames =
	{
	    "enter",
	    "reset",
	    "update",
	}

    local layer = cc.Layer:create()

    local support  = false
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) 
        or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) 
        or (cc.PLATFORM_OS_MAC  == targetPlatform) then
        support = true
    end

    -- if not support then
    --     print("Platform is not supported!")
    --     return layer
    -- end

   
    local isUpdateItemClicked = false
    local assetsManager       = nil
    local pathToSave          = ""

    local menu = cc.Menu:create()
    menu:setPosition(cc.p(0, 0))
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(24)

    local progressLable = cc.Label:createWithTTF("12334445","fonts/arial.ttf",30)
    progressLable:setAnchorPoint(cc.p(0.5, 0.5))
    progressLable:setPosition(cc.p(140,50))
    layer:addChild(progressLable)

    pathToSave = createDownloadDir()

    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            progressLable:setString("no new version")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            progressLable:setString("network error")
        end
    end

    local function onProgress( percent )
        local progress = string.format("downloading %d%%",percent)
        progressLable:setString(progress)
    end

    local function onSuccess()
        progressLable:setString("downloading ok")
    end

    local function getAssetsManager()--"https://raw.github.com/samuele3hu/AssetsManagerTest/master/package.zip"
        if nil == assetsManager then--"https://raw.github.com/samuele3hu/AssetsManagerTest/master/version"
            assetsManager = cc.AssetsManager:new(self.url,
                                           self.masterURL,
                                           pathToSave)
            -- assetsManager = cc.AssetsManager:new("https://raw.github.com/samuele3hu/AssetsManagerTest/master/package.zip",
            --                                "https://raw.github.com/samuele3hu/AssetsManagerTest/master/version",
            --                                pathToSave)
            assetsManager:retain()
            assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
            assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
            assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
            assetsManager:setConnectionTimeout(3)
        end

        return assetsManager
    end

    local function update(sender)
        progressLable:setString("")

        getAssetsManager():update()
    end

    local function reset(sender)
        progressLable:setString("")
        print("--删除--")
        deleteDownloadDir(pathToSave)

        getAssetsManager():deleteVersion()

        createDownloadDir()
    end

    local function reloadModule( moduleName )

        package.loaded[moduleName] = nil

        return require(moduleName)
    end

    local function enter(sender)

        if not isUpdateItemClicked then
            local realPath = pathToSave .. "/package"
            addSearchPath(realPath,true)
            -- local realPath_1 = pathToSave .. "/package/app"
            -- addSearchPath(realPath_1,true)
        end

        -- package.loaded["app.scenes.MainInterfaceScene"] = nil
   --      assetsManagerModule=require("AssetsManagerTest/AssetsManagerModule")
 		-- -- assetsManagerModule = reloadModule("AssetsManagerTest/AssetsManagerModule")
   --      assetsManagerModule.newScene(AssetsManagerTestMain)

            local login_info=LocalData:Instance():get_user_data()
    	
		  dump(login_info)
		  if login_info~=nil  then
		  	 -- Util:scene_control("MainInterfaceScene")
		  	 display.replaceScene(require("app/scenes/MainInterfaceScene"):new())
		      -- self:enterScene("MainInterfaceScene")
		      return
		  end
		   Util:scene_control("LoginScene")
		  -- self:enterScene("LoginScene")
    end

    local callbackFuncs =
    {
        enter,
        reset,
        update,
    }

    local function menuCallback(tag, menuItem)
        local scene = nil
        local nIdx = menuItem:getLocalZOrder() - itemTagBasic
        local ExtensionsTestScene = CreateExtensionsTestScene(nIdx)
        if nil ~= ExtensionsTestScene then
            cc.Director:getInstance():replaceScene(ExtensionsTestScene)
        end
    end

    for i = 1, table.getn(menuItemNames) do
        local item = cc.MenuItemFont:create(menuItemNames[i])
        item:registerScriptTapHandler(callbackFuncs[i])
        item:setPosition(320, 760 - i * lineSpace)
        -- if not support then
        --     item:setEnabled(false)
        -- end
        menu:addChild(item, itemTagBasic + i)
    end

    local function onNodeEvent(msgName)
        if nil ~= assetsManager then
            assetsManager:release()
            assetsManager = nil
        end
    end

    layer:registerScriptHandler(onNodeEvent)

    layer:addChild(menu)

    return layer
end



function UpgradeScene:start_game()
  
   if device.platform=="mac" then 
	self:decodeCSVFileTocsv_decode()
   end 

   if device.platform ~="mac" then 
   	--在热更新结束后重新加载一遍新拉下来的 src_encode.zip
	cc.LuaLoadChunksFromZIP("src_encode.zip")
   end 

   local scene = require "app.scenes.MainScene"
   display.replaceScene(scene:new())
end

function UpgradeScene:onEnter()
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.VERRSION, self,function()
   												-- local scene = require "app.scenes.GameScene"
   												-- local seq = transition.sequence({
   												-- 	  cc.DelayTime:create(1),
   												-- 	  cc.CallFunc:create(function()  
   												-- 			display.replaceScene(scene:new())
   												-- end )})
   												-- self:runAction(seq)
   												self:getVersionInfo()
   											end)
 
end

function UpgradeScene:onExit()
   NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.VERRSION, self)
   -- NotificationCenter:Instance():RemoveObserver("SOCKET_LINKED", self)
end

function UpgradeScene:onCleanup()
end

function UpgradeScene:create_dirs()
   for k,v in ipairs(self.rflist.dirPaths) do
	  self:mkDir(self.writablePath .. "/" .. v.name)
   end
end



function UpgradeScene:mkDir(path)
   if not UpgradeScene:fileExists(path) then
	  return lfs.mkdir(path)
   end
   return true
end

function UpgradeScene:fileExists(path)
   return cc.FileUtils:getInstance():isFileExist(path)
end






return UpgradeScene
