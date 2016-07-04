
require("cocos.init")
require("framework.init")
require "lfs"
Util = require("app.model.Util")
require("config")
require("MobClickForLua")
require "AssetsManagerTest/AssetsManagerTest"

local MyApp = class("MyApp", cc.mvc.AppBase)
PINLE_CHANNEL_ID="DVE"

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
   cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 1136, cc.ResolutionPolicy.EXACT_FIT)

   -- local pinle_loclation=cc.PinLe_platform:Instance()
   -- pinle_loclation:getLocation()
    Server:Instance():version_login_url()
    
   -- print("入口后台差异检测测试---")
   --生成DEVICE_ID
   self:init_userdefault()
   local writablePath = cc.FileUtils:getInstance():getWritablePath()
   local  path_res=writablePath.."down_pic"

   if device.platform=="android" then 
      MobClickForLua.startMobclick("57393a8ce0f55a5d76002008","")
       Util:removeDirectory(path_res)
    elseif device.platform=="ios" or device.platform=="mac" then
      -- MobClickForLua.startMobclick("573c1df5e0f55afa04001f9f","")
    end

	    cc.FileUtils:getInstance():addSearchPath("res/")
      cc.FileUtils:getInstance():addSearchPath("res/csb")
      cc.FileUtils:getInstance():addSearchPath("res/cre")
      cc.FileUtils:getInstance():addSearchPath("res/down_pic")
      
      --热更路径
      local realPath = createDownloadDir() .. "/package"
      addSearchPath(realPath,true)
      
   -- lfs.mkdir(writablePath .. "down_pic")
  Util:removeDirectory("down_pic")
  lfs.mkdir(path_res)
  cc.FileUtils:getInstance():addSearchPath(path_res)
  
 
  local login_info=LocalData:Instance():get_user_data()
    
  -- dump(login_info)
  if login_info~=nil  then
      Util:scene_control("MainInterfaceScene")
      return
  end
  Util:scene_control("LoginScene")
  -- Util:scene_control("UpgradeScene")
  -- AssetsManagerTestMain()
   --  local  scene =AssetsManagerTestMain()
   -- cc.Director:getInstance():replaceScene(scene)

end


function MyApp:init_userdefault()

   local device_id = cc.UserDefault:getInstance():getStringForKey("device_id")
   if device_id == "" then
    -- create random number
    -- math.newrandomseed()
    local rand = math.random(9999999)
    -- get os time
    local t = os.time()
    -- put them together
    -- device_id = crypto.md5( device.getOpenUDID() ..  rand  .. t )
    device_id = crypto.md5( rand  .. t .. os.clock())
    cc.UserDefault:getInstance():setStringForKey("device_id" , device_id)
   end
   print("create device_id " .. device_id)
end

return MyApp
