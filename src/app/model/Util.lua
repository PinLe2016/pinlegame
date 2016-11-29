Util = {}

function Util:CenterNodeInParent(node, use_boundbox)
   local parent = node:getParent()
   local size = parent:getContentSize()
   if (use_boundbox) then
      size = parent:getCascadeBoundingBox()
   end
   node:setPosition(size.width / 2, size.height / 2)
end




-- 除头尾空格
function Util:trim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

-- 除头尾空格
function Util:sub_str (s,parm,parm1)
  local str=string.gsub(s, parm, "")
  return string.gsub(str, parm1, "")
end
--拆分字符串返回表
function Util:lua_string_split(str, split_char)      
 local sub_str_tab = {};  
 while (true) do          
 local pos = string.find(str, split_char);    
 if (not pos) then              
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



function Util:FormatTime(orginSecond)
   local d = orginSecond
   local h = math.floor(d/3600)
   local m = (d - h * 3600) / 60
   local s = (m - math.floor(m)) *60
   local hour = math.floor(h)
   if (hour < 10) then
	  hour = '0' .. hour
   end
   local minutes = math.floor(m)
   if (math.abs(minutes) < 10) then
	  minutes= '0' .. math.abs(minutes)
   end
   local second = math.floor(s)
   if (math.abs(second) < 10) then
	  second = '0' .. math.abs(second)
   end
   return string.format("%sh%sm%ss", hour, minutes, second)
end

-- 冒号格式时间显示
function Util:FormatTime_colon(orginSecond)

   local d = orginSecond
   local day  = math.floor(d/60/60/24)
   local h = math.floor((d/60/60)%24)
   local m = (d/60)%60
   local s = d%60
   local hour = math.floor(h)
   if (hour < 10) then
    hour = '0' .. hour
   end
   local minutes = math.floor(m)
   if (math.abs(minutes) < 10) then
    minutes= '0' .. math.abs(minutes)
   end
   local second = math.floor(s)
   if (math.abs(second) < 10) then
    second = '0' .. math.abs(second)
   end
    local _table={day.."天",hour.."小时",minutes.."分",second.."秒"}
    -- dump(_table)
   return _table--string.format("%s:%s:%s", hour, minutes, second)
end

-- 字符串拆成字符（中文）
function Util:UTF8ToCharArray(str)
   -- local UTF8ToCharArray = function(str)
   local charArray = {};
   local iStart = 0;
   local strLen = str:len();

   local function bit(b)
     return 2 ^ (b - 1);
   end

   local function hasbit(w, b)
     return w % (b + b) >= b;
   end

   local checkMultiByte = function(i)
     if (iStart ~= 0) then
         charArray[#charArray + 1] = str:sub(iStart, i - 1);
         iStart = 0;
     end        
   end
    
   for i = 1, strLen do
     local b = str:byte(i);
     local multiStart = hasbit(b, bit(7)) and hasbit(b, bit(8));
     local multiTrail = not hasbit(b, bit(7)) and hasbit(b, bit(8));

     if (multiStart) then
         checkMultiByte(i);
         iStart = i;
         
     elseif (not multiTrail) then
         checkMultiByte(i);
         charArray[#charArray + 1] = str:sub(i, i);
     end
   end

   -- process if last character is multi-byte
   checkMultiByte(strLen + 1);

   return charArray;
end

-- 判断是否有敏感词
function Util:isExistSensitiveWord(str)
  local sensitive_csv = LocalConfig:Instance():get_table("sensitiveWord")
  for i,v in ipairs(sensitive_csv) do
    local begin_, end_ = string.find(str, v.mask_word)
    if begin_ ~= nil then
      return true
    end
  end
  return false
end

-- 替换敏感词
function Util:filterSensitiveWord(str)
  local sensitive_csv = LocalConfig:Instance():get_table("sensitiveWord")
  local text = str
  for i,v in ipairs(sensitive_csv) do
    text = string.gsub(text, v.mask_word, "**")
  end
  return text
end



function Util:removeDirectory(path)
   local path = cc.FileUtils:getInstance():getWritablePath() .. path .. "/"
   cc.FileUtils:getInstance():removeDirectory(path)
end


--比较table
function Util:compareTables(table1 , table2)
    if type(table1)~="table"   or  type(table2)~="table"  then 
      printError("cant compare noTable value") 
      return nil
    end 

    if table1==table2 then 
      printError("table1 and table2 are the same refercence")
      return nil
    end


    local keys1=table.keys(table1)
    local keys2=table.keys(table2)

    if (#keys1) ~= (#keys2) then 
      return false 
    end 

    for k1,v1 in pairs(table1) do 
        
        local v2=table2[k1]
        if v2==nil then 
          return false 
        end 

        if type(v1)~=type(v2) then 
          return false 
        end

        if type(v1)=="function"  or type(v1)=="userdata" or type(v1)=="thread"   then 
          printError("sorry ,we cant compare tables include function , userdata or thread")
          return nil
        end

        if type(v1)=="table" then 
              local ret=Util:compareTables(v1,v2)
              if ret==false then 
                return false 
              end
        else 
              if v1~=v2 then 
                return false 
              end     
        end

   end

   return true

end


function Util:dumpTexture()
        print("\n___________________TextureData__________________________\n")
        print(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
        print("\n___________________TextureData__________________________\n")
end

function Util:scene_control(scene)
        local str_scene="app.scenes."..scene
        display.replaceScene(require(str_scene):new())
end
function Util:scene_controlid(scene,params)
        local str_scene="app.scenes."..scene
        display.replaceScene(require(str_scene).new(params))-- （.与：区别）
end



function Util:tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
--随机数
function Util:rand(  )
       return math.random(1000,9999)
end
function Util:getdays(  )
            local year,month = os.date("%Y", os.time()), os.date("%m", os.time())+1 -- 正常是获取服务器给的时间来算
            local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数
            return  dayAmount
end



--分享相关
--截屏功能
function Util:captureScreen()
    local file=cc.FileUtils:getInstance():getWritablePath().."screenshoot.jpg"

    if device.platform=="ios" then
      print("我累的去去")
      file=cc.FileUtils:getInstance():getWritablePath().."res/screenshoot.jpg"
    end
      display.captureScreen( function (bSuc, filePath)
                    --bSuc 截屏是否成功
                      --filePath 文件保存所在的绝对路径
                end, file)
      return file
end

--分享功能
function Util:share()
  -- Util:captureScreen()

  -- local file=cc.FileUtils:getInstance():getWritablePath().."screenshoot.jpg"
  local file="http://a3.qpic.cn/psb?/V12zPeTO3EhoPL/T4Jju1vCpHFsTbRl*uuO9YxUD*MKbQU*Hf.PZsgjaXg!/b/dHYBAAAAAAAA&ek=1&kp=1&pt=0&bo=gALAAwAAAAAFAGI!&sce=60-2-2&rf=viewer_311"--cc.FileUtils:getInstance():getWritablePath().."screenshoot.jpg"

  if device.platform=="ios" then
      file="res/screenshoot.jpg"
  end

   local login_info=LocalData:Instance():get_user_data()
   
   local share=cc.UM_Share:createWithShare(file,login_info["playerid"])
   share:addTo(display.getRunningScene(),1000)
   return share
end


-- --读取json 文件
function Util:read_json(path_json)

  local file_path=path_json
 
  -- if device.platform=="mac" then
  --   file_path=cc.FileUtils:getInstance():getWritablePath()..path_json
  -- end
  local fileStr = cc.HelperFunc:getFileData(file_path)
  -- dump(fileStr)
  local fileData = json.decode(fileStr)
  return fileData

end

--去除json 括号
function Util:remove_json_str(pathname)
  string.gsub(pathname, "%b()", "")
end

--日期转成时间戳
function Util:dateTotimestamp(birthday)
  local secondOfToday = os.time({day=birthday.day, month=birthday.month,
    year=birthday.year, hour=1, minute=0, second=0})

  dump(secondOfToday)
  return secondOfToday
end
--音乐
function Util:player_music(musicname,cycle ) --音乐名字，是否重播，是否设置禁止播放

    if LocalData:Instance():get_music() then
      audio.playMusic(G_SOUND[musicname],cycle)
    else
      print("抱歉无法播放音乐")
   end   
end
   --音乐
function Util:player_music_hit(musicname,cycle ) --音乐名字，是否重播，是否设置禁止播放

    if LocalData:Instance():get_music() then
      audio.playMusic(musicname,cycle)
    else
      print("抱歉无法播放音乐")
   end   

end

function Util:stop_music( musicname ) -- 停止播放音乐
    
     if not LocalData:Instance():get_music() then
       audio.stopMusic(G_SOUND[musicname])
    else
      print("抱歉无法关闭音乐")
   end   
end


return Util


