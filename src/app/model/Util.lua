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
-- 冒号格式时间显示
function Util:FormatTime_colon_s(sorginSecond)

   local d = sorginSecond
   local nian=math.floor(d/60/60/24/365)
   local day  = math.floor(d/60/60/24%365)
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
    local _table={nian  ..   "年"  ..  day.."天",hour.."小时",minutes.."分",second.."秒"}
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

-- 冒号格式时间显示
function Util:FormatTime_colon_bar(_time)

   local d = _time
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
    local _table={day..":",hour..":",minutes..":",second}
    -- dump(_table)
   return _table--string.format("%s:%s:%s", hour, minutes, second)
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


function Util:FormatTime_colon_bar_time(_time)

   local d = _time
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
    local _table=day*24*60 + hour*60 +minutes
    -- dump(_table)
   return  _table--string.format("%s:%s:%s", hour, minutes, second)
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
        
        --display.replaceScene(cc.TransitionProgressInOut:create(0.3, require(str_scene):new()))
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
    local is_succ=false
    if device.platform=="ios" then
      file="res/screenshoot.jpg"
      
    end
      display.captureScreen( function (bSuc, filePath)
                    --bSuc 截屏是否成功
                      --filePath 文件保存所在的绝对路径
                    
                end, file)

      return file
end

--分享功能

--tyep 1 正常分享类型 2 去助力分享类型
function Util:share(_id,_loginname,type)
          local act_id=_id
          local loginname=_loginname

          local login_info=LocalData:Instance():get_user_data()
          local share_title=LocalData:Instance():get_share_title()
          local file --分享图片的链接
          local title--分享标题
          local content--分享内容
          local url --分享后微信跳转的URL

          dump(login_info)
          if type==1 then
              file="http://a3.qpic.cn/psb?/V12zPeTO3EhoPL/T4Jju1vCpHFsTbRl*uuO9YxUD*MKbQU*Hf.PZsgjaXg!/b/dHYBAAAAAAAA&ek=1&kp=1&pt=0&bo=gALAAwAAAAAFAGI!&sce=60-2-2&rf=viewer_311"--cc.FileUtils:getInstance():getWritablePath().."screenshoot.jpg"
              if device.platform=="ios" then
                  file="res/screenshoot.jpg"
              end
              title=share_title["title"]
              content=share_title["content"]
              url =string.format("http://playtest.pinlegame.com/Reg.aspx?InCode=%s",login_info["playerid"])
          else
              file="" --"助力链接图片"
              title="" --
              content="" --

              url="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx23e98e660f59078a&redirect_uri=http%3A%2F%2Fplaytest.pinlegame.com%2Fassist.html&response_type=code&"
              local complete_url=string.format("scope=snsapi_userinfo&state=%s|%s#wechat_redirect",act_id,_loginname)
              url=url..complete_url
          end
         
          
            
          
         
           local share=cc.UM_Share:createWithShare(file,"",title,content,url)

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
--音效
function Util:player_music(musicname,cycle ) --音乐名字，是否重播，是否设置禁止播放
    if LocalData:Instance():get_music() then
      audio.playSound(G_SOUND[musicname],cycle)
    else
      print("抱歉无法播放音乐")
   end   
end
   --音乐
function Util:player_music_hit(musicname,cycle ) --音乐名字，是否重播，是否设置禁止播放

    dump(LocalData:Instance():get_music_hit())
    if LocalData:Instance():get_music_hit() then
      audio.playMusic(G_SOUND[musicname],cycle)
    else
      print("抱歉无法播放音乐")
   end   

end

--关闭
function Util:stop_music( musicname ) -- 停止播放音乐
    
      if not LocalData:Instance():get_music_hit() then
       audio.stopMusic(G_SOUND[musicname])
     else
       print("抱歉无法关闭音乐")
    end   
end
--音效
function Util:player_music_new(musicname,cycle ) --音乐名字，是否重播，是否设置禁止播放
    if LocalData:Instance():get_music() then
      audio.playSound("sound/effect/"  ..  musicname,cycle)
    --else
     -- print("抱歉无法播放音乐")
   end   
end

function Util:all_layer_backMusic() -- 所有界面返回音效
  if LocalData:Instance():get_music() then
    audio.playSound("sound/effect/guanbi.mp3",false)
  end
end
--  增加光标
--  增加光标
function Util:function_keyboard(_parent,target,font_size,_color1,_color2,_color3)
        local alert = ccui.Text:create()
        alert:setString("|")
        -- alert:setFontName("png/chuti.ttf")
        local _guangbiao_x=target:getPositionX()
        alert:setPosition(target:getPositionX(),target:getPositionY()+5)
        alert:setFontName(font_TextName)
        alert:setFontSize(35)
        if not _color1 then
         alert:setColor(cc.c3b(0, 0, 0))
        else
          alert:setColor(cc.c3b(_color1, _color2, _color3))
        end
        
        _parent:addChild(alert)

       

        alert:setVisible(false)

        local function textFieldEvent(sender, eventType)  
              if eventType == ccui.TextFiledEventType.attach_with_ime then  
                  -- print("attach_with_ime") 
                   local  move=cc.Blink:create(1, 1)  
                   target:setPlaceHolder("")
                    local action = cc.RepeatForever:create(move)
                    alert:runAction(action) 
                  alert:setVisible(true)
              elseif eventType == ccui.TextFiledEventType.detach_with_ime then  
                  -- print("detach_with_ime") 
                  alert:stopAllActions() 
                  alert:setVisible(false)
              elseif eventType == ccui.TextFiledEventType.insert_text then  
                  -- print("insert_text")  
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str) --Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)    
              elseif eventType == ccui.TextFiledEventType.delete_backward then  
                  -- print("delete_backward")
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)      
      
        end  
      end
      target:addEventListener(textFieldEvent) 


end


function Util:fun_Strlen(str)

    local bytes = { string.byte(str, 1, #str) }
    local length, begin = 0, false
    for _, byte in ipairs(bytes) do
        if byte < 128 or byte >= 192 then
            begin = false
            length = length + 1
        elseif not begin then
            begin = true
            length = length + 1
        end
    end
    return length
end
function Util:function_advice_keyboard(_parent,target,font_size)
        local alert = ccui.Text:create()
        alert:setString("|")
        --alert:setFontName("png/chuti.ttf")
        local _guangbiao_x=target:getPositionX()
        alert:setPosition(target:getPositionX(),target:getPositionY())
        alert:setFontName(font_TextName)
        alert:setFontSize(30)
        alert:setColor(cc.c3b(0, 0, 0))
        _parent:addChild(alert)

       

        alert:setVisible(false)

        local function textFieldEvent(sender, eventType)  
              if eventType == ccui.TextFiledEventType.attach_with_ime then  
                  -- print("attach_with_ime") 
                   local  move=cc.Blink:create(1, 1)  
                   target:setPlaceHolder("")
                    local action = cc.RepeatForever:create(move)
                  --   alert:runAction(action) 
                  -- alert:setVisible(true)
              elseif eventType == ccui.TextFiledEventType.detach_with_ime then  
                  -- print("detach_with_ime") 
                  -- alert:stopAllActions() 
                  -- alert:setVisible(false)
              elseif eventType == ccui.TextFiledEventType.insert_text then  
                  -- print("insert_text")  
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str) --Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)    
              elseif eventType == ccui.TextFiledEventType.delete_backward then  
                  -- print("delete_backward")
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)      
      
        end  
      end
      target:addEventListener(textFieldEvent) 


end

function Util:getWeixinLoginDate()
  --is_weixin 字段，-1 代表未进行授权之前状态，0 代表授权成功，1 代表授权失败或者取消授权
          local user=
          {
              nickname=cc.UserDefault:getInstance():getStringForKey("name",""),
              unionid=cc.UserDefault:getInstance():getStringForKey("unionId",""),
              openid=cc.UserDefault:getInstance():getStringForKey("openId",""),
              headimgurl=cc.UserDefault:getInstance():getStringForKey("icon",""),
              is_weixin=cc.UserDefault:getInstance():getStringForKey("is_weixin","-1")
          }
          if device.platform=="android" then 
                user=
              {
                  nickname=cc.UserDefault:getInstance():getStringForKey("nickname",""),
                  unionid=cc.UserDefault:getInstance():getStringForKey("unionid",""),
                  openid=cc.UserDefault:getInstance():getStringForKey("openid",""),
                  headimgurl=cc.UserDefault:getInstance():getStringForKey("headimgurl",""),
                  is_weixin=cc.UserDefault:getInstance():getStringForKey("is_weixin","-1")
                  -- country=cc.UserDefault:getInstance():getStringForKey("country",""),
                  -- province=cc.UserDefault:getInstance():getStringForKey("province",""),
                  -- city=cc.UserDefault:getInstance():getStringForKey("city","")

              }
          end

            -- dump(user)
       if user["openid"]=="" then
           return nil
        end     
            
      return user
end

function Util:deleWeixinLoginDate()

          
      if device.platform=="android" then 

            cc.UserDefault:getInstance():setStringForKey("nickname","")
            cc.UserDefault:getInstance():setStringForKey("unionid","")
            cc.UserDefault:getInstance():setStringForKey("openid","")
            cc.UserDefault:getInstance():setStringForKey("headimgurl","")
            cc.UserDefault:getInstance():setStringForKey("is_weixin","-1")
            -- country=cc.UserDefault:getInstance():getStringForKey("country",""),
            -- province=cc.UserDefault:getInstance():getStringForKey("province",""),
            -- city=cc.UserDefault:getInstance():getStringForKey("city","")
      else
            cc.UserDefault:getInstance():setStringForKey("name","")
            cc.UserDefault:getInstance():setStringForKey("unionId","")
            cc.UserDefault:getInstance():setStringForKey("openId","")
            cc.UserDefault:getInstance():setStringForKey("icon","")
            cc.UserDefault:getInstance():setStringForKey("is_weixin","-1")
      end
            
end


function Util:weixinLogin()
    local weinxin=cc.UM_Share:create()
    weinxin:getlogin()
end

--  辨别字符串中中包含数字
function Util:judgeIsAllNumber(string)
          local isAllNum = false


          --先屏蔽加号和空格
          local s1, e1 = string.find(string, "+")
          local s2, e2 = string.find(string, " ")
          if s1 ~= nil or e1 ~= nil or  s2 ~= nil or e2 ~= nil then
          isAllNum = false
          else
          --判断是否有其他符号或者文字
          local n = tonumber(string)
          if n then
          -- print("this num is  ======= " .. n)
          if n<0 then
          --是负数，肯定有负号
          isAllNum = false
          else
          local pn = n --此处为取整数部分参见http://blog.csdn.net/daydayup_chf/article/details/46351947
          -- print("number int part ====== " .. pn)


          if pn == n then
          -- print("***********************")
          isAllNum = true
          else
          --不相等说明有小数点
          isAllNum = false
          end
          end
          else
          isAllNum = false
          -- print("this string is not a number !!!!!")
          end
          end


          -- --提示
          -- if isAllNum == false then
          -- -- print("not is all number !!!!!!!!!!!!")
          -- self:inputSysTips(InputIsNumber, displayCenter)
          -- end


          return isAllNum
end



--  过滤特殊字符
function Util:filter_spec_chars(s)  
    local ss = {}  
    for k = 1, #s do  
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
            table.insert(ss, string.char(c))  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2  
                    table.insert(ss, string.char(c,c1,c2))  
                end  
            end  
        end  
    end  
    return table.concat(ss)  
end  



-- 弹办弹出动作 
function Util:layer_action(object,parent,type)  

      if type=="open" then
          local actionTo = cc.ScaleTo:create(0.15, 1.1)
          local actionTo1 = cc.ScaleTo:create(0.1, 1)
          object:runAction(cc.Sequence:create(actionTo,actionTo1  ))
          return
      end

      local function stopAction()
            parent:removeFromParent()
      end
      local actionTo = cc.ScaleTo:create(0.1, 1.1)
      local actionTo1 = cc.ScaleTo:create(0.1, 0.7)
      local callfunc = cc.CallFunc:create(stopAction)
      object:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))

end

return Util


