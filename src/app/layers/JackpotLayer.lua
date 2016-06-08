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
                     print("开心",_id)
                    --Util:scene_controlid("GameScene",{id=_id})
                    --Server:Instance():getgoldspoolbyid(_id)
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
       
 --           self.sequence_list=self.JackpotScene:getChildByTag(160)--奖池列表
	-- self.sequence_list:setItemModel(self.sequence_list:getItem(0))
	-- self.sequence_list:removeAllItems()

	 -- for i=1,self.jac_data_num do
	 --          	self.jackpot_ListView:pushBackDefaultItem()
	 --          	local  cell = self.jackpot_ListView:getItem(i-1)
	 --            cell:setTag(i)
	 -- end



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