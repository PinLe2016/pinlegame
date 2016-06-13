--
-- Author: peter
-- Date: 2016-06-02 10:39:24
--
--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--   个人排行榜
local JackpotLayer = class("JackpotLayer", function()
            return display.newLayer("JackpotLayer")
end)
--标题 活动类型 
function JackpotLayer:ctor(params)
         self.id=params.id
         Server:Instance():getgoldspooladlist(self.id)  --
         Server:Instance():getgoldspoolbyid(self.id)

         self:setNodeEventEnabled(true)--layer添加监听

         self.secondOne = 0
         self.time=0
          self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
            self:update(dt)
      end)
end
function JackpotLayer:init(  )

  	  self.JackpotScene = cc.CSLoader:createNode("JackpotScene.csb")
        self:addChild(self.JackpotScene)
        
        self.advertiPv=self.JackpotScene:getChildByTag(151)
        local advertiPa=self.advertiPv:getChildByTag(152)

        local  list_table=LocalData:Instance():get_getgoldspoollistbale()
        
        local  jaclayer_data=list_table["ads"]
        self.advertiPv:addEventListener(function(sender, eventType  )
                 if eventType == ccui.PageViewEventType.turning then
                   
                    local  _id=jaclayer_data[1]["adid"]
                    Util:scene_controlid("GameScene",{adid=_id,type="audition",image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})
                    LocalData:Instance():set_actid({act_id=_id,image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})--保存数据
                end
        end)

        local _advertiImg=advertiPa:getChildByTag(155)
        _advertiImg:loadTexture(tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":")))--
        if #jaclayer_data>=2 then
             for i=2,#jaclayer_data do
                  local  call=advertiPa:clone() 
                  local advertiImg=call:getChildByTag(155)
                  advertiImg:loadTexture(tostring(Util:sub_str(jaclayer_data[i]["imgurl"], "/",":")))--
                  self.advertiPv:addPage(call)   --
            end
        end
       
        --self.PageView_head:scrollToPage(self._index)   --拿到需要索引的图
        
         local left_bt=self.JackpotScene:getChildByTag(154)  --减
         left_bt:setTouchSwallowEnabled(true)
         left_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                self.advertiPv:scrollToPage(self.advertiPv:getCurPageIndex()-1)
              
        end)
        local right_bt=self.JackpotScene:getChildByTag(153)  --加
        right_bt:setTouchSwallowEnabled(true)
        right_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                 self.advertiPv:scrollToPage(self.advertiPv:getCurPageIndex()+1)
                
        end)
         local back=self.JackpotScene:getChildByTag(137)  --返回
         back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                if self.JackpotScene then
                   self.JackpotScene:removeFromParent()
                end
                
        end)

          self:information()
          self:audition()

end
function JackpotLayer:information( )
             local  list_table=LocalData:Instance():get_getgoldspoolbyid()
             dump(list_table)
             local title=self.JackpotScene:getChildByTag(138)  --标题
             title:setString(list_table["title"])

             local gold=self.JackpotScene:getChildByTag(140)  --剩余金币
             gold:setString(list_table["remaingolds"])

             local car_num=self.JackpotScene:getChildByTag(33)  --翻倍卡数量
             car_num:setString(list_table["doublecardamount"])

             local began_bt=self.JackpotScene:getChildByTag(46)  --开始
             began_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
             local ordinary_bt=self.JackpotScene:getChildByTag(44)  --普通
             ordinary_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
              local special_bt=self.JackpotScene:getChildByTag(45)  --翻倍
             special_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
end

function JackpotLayer:touch_callback( sender, eventType )
      if eventType ~= ccui.TouchEventType.ended then
         return
      end
      local tag=sender:getTag()
      if tag==46 then --开始
            print("开始")
            self:scheduleUpdate()
      elseif tag==44 then
            print("普通")
            self:unscheduleUpdate()
      elseif tag==45 then
            print("翻倍")
      end
end

--劲舞团
function JackpotLayer:audition(  )
      local progress_bg=self.JackpotScene:getChildByTag(40)  --滑动条
      self.w_size=progress_bg:getContentSize().width
      self.progress_bt=self.JackpotScene:getChildByTag(41) 
      self.position_x=self.progress_bt:getPositionX()
      self.po_x=self.progress_bt:getPositionX()+ self.w_size

end

--劲舞团 帧运动
function JackpotLayer:update(dt)
      if self.progress_bt:getPositionX()>=self.po_x-5 then
         self.time=  -1
      elseif self.progress_bt:getPositionX()<=self.position_x then
         self.time= 1
      end
      self.progress_bt:setPositionX(self.progress_bt:getPositionX() +self.time )
     
end
--下载图片
function JackpotLayer:init_pic(  )
          local  list_table=LocalData:Instance():get_getgoldspoollistbale()
          local  jaclayer_data=list_table["ads"]
          for i=1,#jaclayer_data do
	          	local _table={}
	            _table["imgurl"]=jaclayer_data[i]["imgurl"]
         	            _table["max_pic_idx"]=#jaclayer_data
         	            _table["curr_pic_idx"]=i
                       Server:Instance():jackpotlayer_pic(jaclayer_data[i]["imgurl"],_table) --下载图片
          end
         

end
function JackpotLayer:back( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
          

end
function JackpotLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST, self,
                       function()
                       self:init_pic()
                      end)
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST, self,
                       function()
                      self:init()
                      end)
end

function JackpotLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST, self)
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST, self)
end


return JackpotLayer