LocalData = {}

function LocalData:new(o)  
    o = o or {}  
    setmetatable(o,self)  
    self.__index = self 
    -- init func
    self.data = require("app.model.LocalData.Data")
    -- 全局UPDATE刷新资源，等于同时实现心跳
    return o
end 

function LocalData:start_scheduler()
   local scheduler = require("framework.scheduler")
   self.instance.handle=scheduler.scheduleGlobal(function() self:update() end, 1) -- 秒跳
   self.instance.handle_m=scheduler.scheduleGlobal(function() self:update_m() end, 60) -- 分跳
end
function LocalData:update_m()
    self:refresh_resources()
end

function LocalData:update()
    -- todo 这个应该不用遮罩挡住用户操作吧
    -- self:refresh_resources()
    self:refresh_buildings()
    self:refresh_tech()
    -- self:refresh_match()
    -- print("--22222---")
    self:refresh_buff()
    -- 这个是判断到了12点刷新vip等级的功能
    self:refresh_vip()
    --- 全局记录上浮
    self:refresh_flooting()
    CityBuildingManager:Instance():refresh()
end

function LocalData:Instance()  
    if self.instance == nil then  
	   self.instance =  self:new()
    end  
    return self.instance
end

function LocalData:Destory() 
     local scheduler = require("framework.scheduler")
     if self.instance and self.instance.handle  then
            scheduler.unscheduleGlobal(self.instance.handle) 
            scheduler.unscheduleGlobal(self.instance.handle_m)   
     end
    
    self.instance =  nil
end

-- for debug , no use
function LocalData:dump()
    print("\n------ dump data ------\n")
    print_lua_table(self.data)
    print("\n---- end dump data ----\n")
end

function LocalData:save()
    local str = json.encode(self.data)
    print("encoded:", str)
    cc.UserDefault:getInstance():setStringForKey("user_data" , str)
end

function LocalData:load()
    local str = cc.UserDefault:getInstance():getStringForKey("user_data")
    -- print("load encoded str:" , str)
    local d = json.decode(str)
    -- print("decoded" , d)
    -- print("load user_id from default:",d.id)
    -- print_lua_table(d)
    self.data = nil
    self.data = d
    print("load user_id from default:",self.data.id)
end

require("app.model.LocalData.LocalBuilding")
require("app.model.LocalData.LocalChapter")
require("app.model.LocalData.LocalEquipment")
require("app.model.LocalData.LocalGacha")
require("app.model.LocalData.LocalItem")
require("app.model.LocalData.LocalMail")
require("app.model.LocalData.LocalMarch")
require("app.model.LocalData.LocalSkill")
require("app.model.LocalData.LocalTank")
require("app.model.LocalData.LocalTech")
require("app.model.LocalData.LocalUser")
require("app.model.LocalData.LocalWorld")
require("app.model.LocalData.LocalAdventure")
require("app.model.LocalData.LocalFriends")
require("app.model.LocalData.LocalResources")
require("app.model.LocalData.LocalBuff")
require("app.model.LocalData.LocalLeague")
require("app.model.LocalData.LocalVIP")
require("app.model.LocalData.LocalTask")
require("app.model.LocalData.LocalArena")
require("app.model.LocalData.LocalChat")
require("app.model.LocalData.LocalCommonal")
require("app.model.LocalData.LocalNotice")
require("app.model.LocalData.LocalEnemyAttack")
require("app.model.LocalData.LocalWaitingQueue")
require("app.model.LocalData.LocalAboutEvent")
require("app/layers/GlobalFlooting")
require("app.model.LocalData.LocalLogin")
require("app.model.LocalData.LocalPrizeNotice")


