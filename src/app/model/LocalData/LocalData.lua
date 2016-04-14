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
   -- local scheduler = require("framework.scheduler")
   -- self.instance.handle=scheduler.scheduleGlobal(function() self:update() end, 1) -- 秒跳
   -- self.instance.handle_m=scheduler.scheduleGlobal(function() self:update_m() end, 60) -- 分跳
end
function LocalData:update_m()
    self:refresh_resources()
end

function LocalData:update()

end

function LocalData:Instance()  
    if self.instance == nil then  
	   self.instance =  self:new()
    end  
    return self.instance
end

function LocalData:Destory() 
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

    self.data = nil
    self.data = d
 
end

require("app.model.LocalData.LocalBuilding")



