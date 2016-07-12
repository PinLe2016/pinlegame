--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--   个人排行榜
local OnerecordLayer = class("OnerecordLayer", function()
            return display.newLayer("OnerecordLayer")
end)
--标题 活动类型 
function OnerecordLayer:ctor(params)
         self.type=params.type
         self.title=params.title
         self.id=params.id
         self._type=params._type
         Server:Instance():getactivitypointsdetail(self.id," ")  --个人记录排行榜HTTP
         self:setNodeEventEnabled(true)--layer添加监听
end
function OnerecordLayer:init(  )
	self.OnerecordLayer = cc.CSLoader:createNode("OnerecordLayer.csb");
    	self:addChild(self.OnerecordLayer)

    	local title_text=self.OnerecordLayer:getChildByTag(87)--标题
            title_text:setString(self.title)

            local back_bt=self.OnerecordLayer:getChildByTag(88)--返回
            back_bt:addTouchEventListener(function(sender, eventType  )
                                    self:back(sender, eventType)
                        end)

            self.rank_list=self.OnerecordLayer:getChildByTag(90)--个人记录排行榜列表
            self.rank_list:setItemModel(self.rank_list:getItem(0))
            self.rank_list:removeAllItems()

            self:Onerecord_init()

end
function OnerecordLayer:Onerecord_init(  )
     local _ble={"月","周","天","天"}
	self.rank_list:removeAllItems()
	self.list_table=LocalData:Instance():get_getactivitypointsdetail()
  dump(self.list_table)
            local  One_data=self.list_table["mypointslist"]
            if next(One_data) ==nil then
              return
            end
            local num=One_data[#One_data]["cycle "]
            for i=1,#One_data do
                  self.rank_list:pushBackDefaultItem()
            	local  cell = self.rank_list:getItem(i-1)
            	if One_data[i]["cycle"]  ==i then
            		 local integral_text=cell:getChildByTag(93)--积分
	           		 integral_text:setString(One_data[i]["points"])
	            else
	            	 local integral_text=cell:getChildByTag(93)--积分
	                   integral_text:setString("0")
            	end
            	
	            local time_text=cell:getChildByTag(95)--时间
                    if self._type<3 then
                            local  tpy=_ble[tonumber(self._type)+1]
                            name_text:setString("第"  .. i  ..  tpy)
                    elseif self._type==5 then
                            name_text:setString("第"  .. i  ..  "天")   --热门
                    else
                             name_text:setString("第"  .. i  ..  "天")  --零时
                     end
	            
            end

end
function OnerecordLayer:back( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            
            self:removeFromParent()

end
function OnerecordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.ONERECORD_LAYER_IMAGE, self,
                       function()
                        self:init()
                      end)
end

function OnerecordLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ONERECORD_LAYER_IMAGE, self)
end


return OnerecordLayer