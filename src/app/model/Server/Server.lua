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
        -- self.login_url="http://123.57.136.223:1036/Default.aspx?"
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

function Server:show_float_message(msg)
   local scene = display.getRunningScene()
   scene:pushFloating(msg,false)
end



--版本接口请求
function Server:request_version(command , params)

    local platform=device.platform
    if platform=="mac" then platform="ios" end
    local  version_data=string.format("http://test.pinlegame.com/geturl.aspx?os=%s&ver=%s",platform,PINLE_VERSION)
    local request = network.createHTTPRequest(function(event) self:on_request_finished_version(event,command) end, version_data , "POST")
    local params_encoded = json.encode(params)

    request:setTimeout(0.5)
    request:start()

end

function Server:on_request_finished_version(event , command)
    local ok = (event.name == "completed")
    local request = event.request
    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        return
    end

    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    self.jsondata = response
    self.data=self.jsondata
    local callback = loadstring("Server:Instance():" .. command .. "_callback()")
    callback()
end


--数据接口
--[[
    --command --命名的方法字符转，用于回调
    -- params --传输数据
    -- functionname --拼乐数据文档后台区回调区分入口 以文档 functionname 值为准
]]
function Server:request_http(command , params)

    local parsms_md5={methodtype="json",createtime=os.time(),functionname=command,functionparams=params}
    local post_md5=json.encode(parsms_md5)
    local post_="PINLEGAME"..post_md5.."PINLEGAME"
    self.login_url=self.login_url.."type=json".."&key=PINLEGAME".."&md5="..crypto.md5(post_)
    local request = network.createHTTPRequest(function(event) self:on_request_finished_http(event,command) end, self.login_url , "POST")
    request:setPOSTData(post_md5)
    request:setTimeout(0.5)
    request:start()

end




function Server:on_request_finished_http(event , command)
    local ok = (event.name == "completed")
    local request = event.request

    if not ok then return end
    

    local code = request:getResponseStatusCode()

    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        return
    end

    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    -- print("--- response string ---\n" , response)
    self.jsondata = json.decode(response)
    -- dump(self.jsondata)
    if self.jsondata == nil then
        self:show_float_message("服务器返回信息格式错误，无法解析",response)
        return
    end
   
    -- 保存到类方便调用
    self.data = self.jsondata
    self.params = json.decode(self.jsondata.params)
    self.last_command = command
    if (self.jsondata.timestamp) then
       	   self.timediff = os.time() - self.jsondata.timestamp
    end

    -- 调用回调方法
    local callback = loadstring("Server:Instance():" .. command .. "_callback()")
    callback()
  
end


require("app.model.Server.ServerLogin")





