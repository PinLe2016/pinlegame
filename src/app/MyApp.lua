
require("cocos.init")
require("framework.init")
require "lfs"
Util = require("app.model.Util")
require("config")
require("MobClickForLua")

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
    
   
   --生成DEVICE_ID
   self:init_userdefault()
   local writablePath = cc.FileUtils:getInstance():getWritablePath()
   local  path_res=writablePath.."down_pic"

   if device.platform=="android" then 
      MobClickForLua.startMobclick("57393a8ce0f55a5d76002008","")
    elseif device.platform=="ios" then
      print("12344555-------------------")
      path_res="down_pic"
      MobClickForLua.startMobclick("573c1df5e0f55afa04001f9f","")
    end

	    cc.FileUtils:getInstance():addSearchPath("res/")
      cc.FileUtils:getInstance():addSearchPath("res/csb")
      cc.FileUtils:getInstance():addSearchPath("res/cre")
     
  
      
   -- lfs.mkdir(writablePath .. "down_pic")
  Util:removeDirectory(path_res)
  lfs.mkdir(path_res)
  cc.FileUtils:getInstance():addSearchPath(path_res)
  
   cc.FileUtils:getInstance():addSearchPath("res/down_pic")

  dump(path_res)
  --self:enterScene("SurpriseScene")
 
   --self:enterScene("LoginScene")

      -- self:enterScene("MainInterfaceScene")
      --self:enterScene("PerInformationScene")
  -- self:enterScene("GameScene")  
  local login_info=LocalData:Instance():get_user_data()
    
  -- dump(login_info)
  if login_info~=nil  then
      self:enterScene("MainInterfaceScene")
      return
  end
  self:enterScene("LoginScene")
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
