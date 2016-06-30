
local UpgradeScene = class("UpgradeScene", function()
							  return display.newScene("UpgradeScene")
end)

require "lfs"

function UpgradeScene:ctor()
   -- 从服务器获取版本号，和本地版本号对比
    self:setNodeEventEnabled(true)--layer添加监听
   self.writablePath = cc.FileUtils:getInstance():getWritablePath()
   print("the writeable path is ")
   print(self.writablePath)
   -- UpgradeScene:mkDir(self.writablePath .. "upd")
   -- -- UpgradeScene:mkDir(self.writablePath .. "upd/res")
   -- UpgradeScene:mkDir(self.writablePath .. "upd/src")
   -- cc.FileUtils:getInstance():addSearchPath(self.writablePath .. "upd")
   -- -- cc.FileUtils:getInstance():addSearchPath(self.writablePath .. "upd/res")
   -- cc.FileUtils:getInstance():addSearchPath(self.writablePath .. "upd/src")
  --
   -- local path=self.writablePath.."upd/res/sound/background/a.png"
   -- UpgradeScene:file_createDic(path)
   -- UpgradeScene:create_file(path,self.writablePath )
    -- UpgradeScene:mkDir(self.writablePath .. path)
   -- 如果需要更新
   -- 生成本地文件列表
   -- 从服务器拉取列表
   -- 创建不存在的文件夹（如何保证创建顺序是正确的）
   -- 找到需要更新的文件列表，拉取文件到本地
   -- 全部拉取完成，改名
   -- local path=cc.FileUtils:getInstance():getWritablePath().."src"
   -- local path_1=cc.FileUtils:getInstance():fullPathForFilename("src")
   -- local path_2=cc.FileUtils:getInstance():fullPathForFilename("src/layers")
   -- local path_3=cc.FileUtils:getInstance():fullPathForFilename("Server.lua")
   -- -- local path_1=cc.FileUtils:getInstance():fullPathForFilename("src")

   -- dump(UpgradeScene:fileExists(path_2))
   -- dump(path_1)
   -- dump(package.path)
   -- dump(path_3)
   Server:Instance():getversion()
   -- Util:scene_control("MainInterfaceScene")


end



function UpgradeScene:request_pic(url,command)
    self.pic_url=url
    dump(url)
    local request = network.createHTTPRequest(function(event) self:on_request_finished_pic(event,command) end, url , "GET")
    request:setTimeout(0.5)
    request:start()

end

function UpgradeScene:on_request_finished_pic(event , command)


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
      local writablePath = cc.FileUtils:getInstance():getWritablePath()
    local dataRecv = request:getResponseData()
 
    local file_path = writablePath.."down_pic/".."version.zip"  


    local file = io.open( file_path, "w+b")
    if file then
        if file:write(dataRecv) == nil then
        -- self:show_error("can not save file : " .. file_path)
            print("can not save file")
            return false
        end
        io.close(file)
 
    end

    -- UpgradeScene:UnzipFile(file_path)
    -- print("------23---")
end

function UpgradeScene:update_res()
  print("-------233--4e--44-5--")
      local version= LocalData:Instance():get_version_date()
      -- dump(version)
      -- UpgradeScene:request_pic("http://www.pinlegame.com/download/3.0.0.zip")
    -- local assetsManager = cc.AssetsManager:new(PackageUrl,
    -- versionFileUrl,
    -- pathToSave)
    -- assetsManager:retain() --貌似没有这句话会蹦
    -- assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
    -- assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
    -- assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
    -- assetsManager:setConnectionTimeout(3)
    -- assetsManager:update() 
  --   local writablePath = cc.FileUtils:getInstance():getWritablePath()
  --  local pathToSave = writablePath.."down_pic"   
  -- local assetsManager = cc.AssetsManager:new("http://www.pinlegame.com/download/3.0.0.zip",    
  --             nil,    
  --             pathToSave)    
  -- assetsManager:retain()    
  -- assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )    
  -- assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)    
  -- assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )    
  -- assetsManager:setConnectionTimeout(3)    
  -- assetsManager:update()  
      
local function onProgress( percent )    
   local progress = string.format("downloading %d%%",percent)    
   title:setString(progress)    
end    
  
local function onSuccess()    
    title:setString("downloading ok")    
end  

end

               
   


function UpgradeScene:onEnter()
	 self:update_res()
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,function()
                          print("---e-e-e-ee----")
   											  self:update_res()
   											end)
 
end

function UpgradeScene:onExit()
   NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
end

-- function UpgradeScene:onCleanup()
-- end




function UpgradeScene:mkDir(path)
   if not UpgradeScene:fileExists(path) then
	  return lfs.mkdir(path)
   end
   return true
end

function UpgradeScene:fileExists(path)
   return cc.FileUtils:getInstance():isFileExist(path)
end


function UpgradeScene:UnzipFile(_path) 

  local writablePath = cc.FileUtils:getInstance():getWritablePath()
    if device.platform == "windows" then
        print(" UnzipFile  ")
        -- unzip test.zip -d /root/ 
        os.execute(" unzip \"" .. _path .."\" -d " ..writablePath.."down_pic")
    else
        os.execute("unzip  -p \"" .. _path .. "\"")
    end 
end 

-- --传入一个字符串和一个分隔符,返回一个分割数组
function UpgradeScene:lua_split(str, split_char)   
   local sub_str_tab = {};  
   while true do
	  local pos = string.find(str, split_char);    
	  if not pos then
		 local size_t = table.getn(sub_str_tab)  
		 table.insert(sub_str_tab,size_t+1,str);  
		 break;
	  end  
	  local sub_str = string.sub(str, 1, pos - 1);                
	  local size_t = table.getn(sub_str_tab)  
	  table.insert(sub_str_tab,size_t+1,sub_str);  
	  local t = string.len(str);  
	  str = string.sub(str, pos + 1, t);     
   end
   return sub_str_tab;  
end

function UpgradeScene:check_file_is_exist()
end

function UpgradeScene:create_file(path,beas_path)
   local file_list=self:lua_split(path,"/")
   local  wirte=beas_path
   dump(file_list)
   for i,v in ipairs(file_list) do
      wirte=wirte..v
  	  UpgradeScene:mkDir(wirte..v)
   end
end

function UpgradeScene:file_createDic(_path)
    -- 设置SD卡路径
    if device.platform == "windows" then
        os.execute("mkdir \"" .. _path .. "\"")
    else
        os.execute("mkdir -p \"" .. _path .. "\"")
    end
end 




-- function UpgradeScene:socket_off_line_dia()
--    -- dia
--    local dialog = display.newScale9Sprite("ui/thesystemwindow.png", display.cx, display.cy, cc.size(440, 300))
--    dialog:addTo(self, 100000001)
--    -- label
--    local our_label = cc.ui.UILabel.new({text = "服务器维护中，请稍后登录",
-- 										size = 26,
-- 										align = TEXT_ALIGN_LEFT,
-- 										font = "Arial",
-- 										color = cc.c3b(250,200,140),
-- 										x = dialog:getContentSize().width/2,
-- 										y = dialog:getContentSize().height*0.7
--    })
--    our_label:setAnchorPoint(0.5, 0.5)
--    our_label:setColor(cc.c3b(255, 241, 203))
--    our_label:addTo(dialog , 3)
--    -- btn
--    local btn_img = {normal = "ui/green_bg1.png", pressed = "ui/green_bg2.png",}
--    local btn_txt_list = {"确定", "取消"}
--    -- for i,v in ipairs(btn_img_list) do
--    for i=1,1 do
--       local btn = cc.ui.UIPushButton.new(btn_img)
-- 		 :setButtonLabel("normal", cc.ui.UILabel.new({
-- 							   UILabelType = 2,
-- 							   text = btn_txt_list[i],
-- 							   size = 24
-- 						}))
-- 		 :onButtonClicked(function(event)
-- 			   dialog:removeSelf()
-- 			   dialog = nil
-- 						 end)
-- 	  btn:setPosition(dialog:getContentSize().width/2, dialog:getContentSize().height*0.3)
-- 	  btn:addTo(dialog)
--    end
-- end



function UpgradeScene:decodeCSVFileTocsv_decode()

	print("@@@@@@@@@@@@@@@@@@@@@")

	local writablePath = cc.FileUtils:getInstance():getWritablePath()
	require "lfs"
  	lfs.mkdir(writablePath .. "csv_decode")

	local csvEncodePath=writablePath .. "upd/csv"
	for file in lfs.dir(writablePath .. "upd/csv") do
		if string.find(file,"csv") then 
			--print(file)
			local encodeText=cc.HelperFunc:getFileData(cc.FileUtils:getInstance():getWritablePath().."upd/csv/"..file)
			local decodeText=crypto.decryptXXTEA(encodeText, CSVKEY)
			io.writefile(cc.FileUtils:getInstance():getWritablePath().."csv_decode/"..file, decodeText or "can't decrypt " ,"w+")

		end 
	end

	print("@@@@@@@@@@@@@@@@@@@@@")
end



return UpgradeScene
