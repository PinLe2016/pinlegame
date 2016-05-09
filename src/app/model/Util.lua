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
-- function Util:scene_controlid(scene,id)
--         local str_scene="app.scenes."..scene
--         display.replaceScene(require(str_scene):new({id = id}))
-- end

function Util:tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

return Util
