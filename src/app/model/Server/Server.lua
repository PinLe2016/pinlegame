Server = {}

function Server:new(o)  
    o = o or {}  
    setmetatable(o,self)  
    self.__index = self 
    return o  
end 

function Server:Instance()  
    if self.instance == nil then  
        self.instance =  self:new()
        -- self.url = "http://tank.g.catcap.cn/"
        -- self.secure_key = "CatCapTankDude"
        self.timediff = 0

    end
    return self.instance
end

function Server:Destory()
   self.instance = nil
end

function Server:time()
   return os.time() - self.timediff
end

function Server:setTime(time)
   self.timestamp = time
end



function Server:request_http(command , params , showMask)
    --print("requesting : " , command)
    if showMask==nil then showMask=true end
    params.showMask=showMask 
    local request = network.createHTTPRequest(function(event) self:on_request_finished_http(event,command) end, self.login_url , "POST")
    local params_encoded = json.encode(params)
    print(params_encoded)
    local timestamp = os.time()
    request:addPOSTValue("params" , params_encoded)
 
    request:addPOSTValue("hash" , crypto.md5(params_encoded))
    request:setTimeout(0.5)
    request:start()
    
    if showMask then self:show_mask_open() end

end

function Server:request(command , params, showMask)
    if showMask==nil then showMask=true end
    params=params or {}
    params.showMask=showMask
    print("-------- HttpOrSocket -------", HttpOrSocket,command) 
    if HttpOrSocket == "HTTP" then
        print("requesting : " , command)
        local request = network.createHTTPRequest(function(event) self:on_request_finished_http(event,command) end, self.url , "POST")
        local params_encoded = json.encode(params)
        print(params_encoded)
        local timestamp = os.time()
        request:addPOSTValue("params" , params_encoded)
        request:addPOSTValue("command" , command)
        request:addPOSTValue("timestamp" , timestamp)
        request:addPOSTValue("hash" , crypto.md5(self.secure_key .. timestamp .. params_encoded))
        request:setTimeout(0.5)
        request:start()
        
        if showMask then self:show_mask_open() end
    end

end

function Server:show_float_message(msg)
   local scene = display.getRunningScene()
   scene:pushFloating(msg,false)
end

function Server:show_float_reward(param)
   local scene = display.getRunningScene()
   scene:pushFloating_reward(param)
end



function Server:on_request_finished_http(event , command)
    local ok = (event.name == "completed")
    local request = event.request

    if not ok then
        -- 请求失败，显示错误代码和错误消息
        -- why the fuck request call this while not finished?
        -- print("not ok",request:getErrorCode(), request:getErrorMessage())
        return
    end

    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        self:show_mask_close()
        return
    end

    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    -- print("--- response string ---\n" , response)
    self.jsondata = json.decode(response)
    if self.jsondata == nil then
        print("response not a json string")
        print(response)
        self:show_float_message("服务器返回信息格式错误，无法解析",response)
        self:show_mask_close()
        return
    end

    io.writefile(cc.FileUtils:getInstance():getWritablePath() .."recv.lua", TableToString(recv,true,true))

    -- 保存到类方便调用
    self.data = json.decode(self.jsondata.data)
    self.params = json.decode(self.jsondata.params)
    self.last_command = command
    if (self.jsondata.timestamp) then
       	   self.timediff = os.time() - self.jsondata.timestamp
    end
    -- 调用回调方法
    local callback = loadstring("Server:Instance():" .. command .. "_callback()")
    callback()

    if self.params.showMask then  self:show_mask_close() end

  
end


require("app.model.Server.ServerLogin")





