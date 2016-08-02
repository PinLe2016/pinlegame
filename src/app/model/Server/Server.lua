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
        self.login_url=""
        self.writablePath = cc.FileUtils:getInstance():getWritablePath()
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
   local scene = cc.Director:getInstance():getRunningScene()
--addTo(scene)
-- if cc.Director:getInstance():getRunningScene() then
--     print("的房价是否都是SDFDS")
--     cc.Director:getInstance():replaceScene(scene)
-- else
--     cc.Director:getInstance():runWithScene(scene)
-- end
   scene:pushFloating(msg)
end

function Server:show_http_buffer(is_buffer)
 
    display.getRunningScene():push_buffer(is_buffer)
end




--版本接口请求
function Server:request_version(command , params)

    local platform=device.platform
    if platform=="mac" then platform="ios" end
    local url="http://test.pinlegame.com/geturl.aspx?os=%s&ver=%s"
    if IS_RELEASE then
          url="http://www.pinlegame.com/geturl.aspx?os=%s&ver=%s"
    end
    local  version_data=string.format(url,platform,PINLE_VERSION)
    dump(version_data)
    local request = network.createHTTPRequest(function(event) self:on_request_finished_version(event,command) end, version_data , "POST")
    -- local params_encoded = json.encode(params)

    request:setTimeout(0.5)
    request:start()

end

function Server:on_request_finished_version(event , command)

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
    self.jsondata = response
    self.data=self.jsondata
    local callback = loadstring("Server:Instance():" .. command .. "_callback()")
    callback()
end


--数据接口
--[[
    --command --命名的方法字符转，用于回调 以文档 functionname 值为准
    -- params --传输数据
]]
function Server:request_http(command , params)
    self:show_http_buffer(true)-- 传输动画
    local parsms_md5={methodtype="json",createtime=os.time(),functionname=command,functionparams=params}
    local post_md5=json.encode(parsms_md5)
    local post_=MD5_KEY..post_md5..MD5_KEY
    local _key="PINLEGAME"
    local login_info=LocalData:Instance():get_user_data()
    local md5=crypto.md5(post_)
 
    if login_info and command~="login" and command~="sendmessage" and command~="changepassword" and command~="reg" and command~="getversion" then

        _key=login_info["loginname"]
        md5=_key..login_info["loginkey"]
        md5=crypto.md5(tostring(md5))

    end
    if self.login_url=="" then
        self.login_url="http://123.57.136.223:2036/Default.aspx?"
            print("版本链接")
    end
    -- dump(self.login_url)
    local login_url=self.login_url.."type=json".."&key=".._key.. "&md5="..md5
    print("---url---",login_url,post_md5)
    local request = network.createHTTPRequest(function(event) self:on_request_finished_http(event,command) end, login_url , "POST")
    self.params=params
    
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
    self:show_http_buffer(false)-- 传输动画
    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseData()
   
    self.jsondata = json.decode(response)
    -- dump(self.jsondata)
    if self.jsondata == nil then
        self:show_float_message("服务器返回信息格式错误，无法解析",response)
        return
    end

    -- 保存到类方便调用
    self.data = self.jsondata
    -- self.params = json.decode(self.jsondata.params)
    self.last_command = command
    if (self.jsondata.timestamp) then
       	   self.timediff = os.time() - self.jsondata.timestamp
    end

    if tonumber(self.data["err_code"])==16 then
         Util:scene_control("LoginScene")
         return
    end
    -- 调用回调方法
    local callback = loadstring("Server:Instance():" .. command .. "_callback()")
    callback()
end



--下载图片

function Server:request_pic(url,command)
    self.pic_url=url
    local request = network.createHTTPRequest(function(event) self:on_request_finished_pic(event,command) end, url , "GET")
    request:setTimeout(0.5)
    request:start()

end

function Server:on_request_finished_pic(event , command)
    local ok = (event.name == "completed")
    local request = event.request

    if not ok then return end

    local code = request:getResponseStatusCode()

    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        -- self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        return
    end
    local dataRecv = request:getResponseData()
    -- local fileObject = self.download_file_list[self.download_progress]
  
    local str=Util:sub_str(command["command"], "/",":")    
    -- dump(str)--.."res/pic/"
    local file_path = self.writablePath.."down_pic/"..str  

    -- if device.platform=="ios" or device.platform=="mac" then
    --     print("下载图片走这里？")
    --     file_path=self.writablePath.."res/down_pic/"..str
    -- end
    local file = io.open( file_path, "w+b")
    if file then
        if file:write(dataRecv) == nil then
        -- self:show_error("can not save file : " .. file_path)
            print("can not save file")
            return false
        end
        io.close(file)
 
    end
    if tonumber(command["max_pic_idx"])== tonumber(command["curr_pic_idx"]) then
        NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.SURPRIS_LIST)
    end


end


--活动下载图片

function Server:actrequest_pic(url,command)
    self.pic_url=url
    local request = network.createHTTPRequest(function(event) self:acton_request_finished_pic(event,command) end, url , "GET")
    request:setTimeout(0.5)
    request:start()

end

function Server:acton_request_finished_pic(event , command)
    local ok = (event.name == "completed")
    local request = event.request

    if not ok then return end

    local code = request:getResponseStatusCode()

    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        -- self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        return
    end
    local dataRecv = request:getResponseData()
    -- local fileObject = self.download_file_list[self.download_progress]
  
    local str=Util:sub_str(command["imgurl"], "/",":")    
    -- dump(str)
    local file_path = self.writablePath.."down_pic/"..str

    -- if device.platform=="ios" or device.platform=="mac" then
    --     file_path=self.writablePath.."res/down_pic/"..str
    -- end
    dump(file_path)
    local file = io.open( file_path, "w+b")
    if file then
        if file:write(dataRecv) == nil then
        -- self:show_error("can not save file : " .. file_path)
            print("can not save file")
            return false
        end
        io.close(file)
 
    end
        NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.ACTIVITYYADLISTPIC_LAYER_IMAGE)


end
--奖池下载
function Server:jackpot_pic(url,command)
    self.pic_url=url
    local request = network.createHTTPRequest(function(event) self:jackpot_request_finished_pic(event,command) end, url , "GET")
    request:setTimeout(0.5)
    request:start()

end

function Server:jackpot_request_finished_pic(event , command)

    local ok = (event.name == "completed")
    local request = event.request

    if not ok then return end

    local code = request:getResponseStatusCode()

    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        -- self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        return
    end
    local dataRecv = request:getResponseData()
    -- local fileObject = self.download_file_list[self.download_progress]
    local str=Util:sub_str(command["imageurl"], "/",":")    
    -- dump(str)--"res/pic/"..
    local file_path = self.writablePath.."down_pic/"..str

    -- if device.platform=="ios" or device.platform=="mac" then
    --     print("11111")
    --     file_path=self.writablePath.."res/down_pic/"..str
    -- end

    local file = io.open( file_path, "w+b")
    if file then
        if file:write(dataRecv) == nil then
        -- self:show_error("can not save file : " .. file_path)
            print("can not save file")
            return false
        end
        io.close(file)
 
    end
        if tonumber(command["max_pic_idx"])== tonumber(command["curr_pic_idx"]) then
        NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_PIC_POST)
    end
        


end


--奖池详情界面
function Server:jackpotlayer_pic(url,command) 
    self.pic_url=url
    -- dump(self.pic_url)
    local request = network.createHTTPRequest(function(event) self:jackpotlayer_request_finished_pic(event,command) end, url , "GET")
    request:setTimeout(0.5)
    request:start()
end

function Server:jackpotlayer_request_finished_pic(event , command)
    local ok = (event.name == "completed")
    local request = event.request

    if not ok then return end

    local code = request:getResponseStatusCode()

    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        -- self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        return
    end

    local dataRecv = request:getResponseData()
    -- local fileObject = self.download_file_list[self.download_progress]
    local str=Util:sub_str(command["imageurl"], "/",":")    
    -- dump(str)--"res/pic/".."res/"..
    local file_path = self.writablePath.."down_pic/"..str
    
    -- if device.platform=="ios" or device.platform=="mac"  then
    --     file_path=self.writablePath.."res/down_pic/"..str
    -- end

    local file = io.open( file_path, "w+b")
    if file then
        if file:write(dataRecv) == nil then
        -- self:show_error("can not save file : " .. file_path)
            print("can not save file")
            return false
        end
        io.close(file)
 
    end
        if tonumber(command["max_pic_idx"])== tonumber(command["curr_pic_idx"]) then
        NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST)
    end
        


end




require("app.model.Server.ServerLogin")
require("app.model.Server.ServerSurprise")
require("app.model.Server.ServerUserData")   
require("app.model.Server.ServerJackpot") 
require("app.model.Server.ServerFriends") 



