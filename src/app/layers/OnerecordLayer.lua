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
          Server:Instance():getactivitybyid(self.id,1)
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
  -- dump(self.list_table)
            local  One_data=self.list_table["mypointslist"]
            -- if next(One_data) ==nil then
            --   return
            -- end
            local num=One_data[#One_data]["cycle"]
            if num==0 then
                return
            end
            for i=1,num do
                  self.rank_list:pushBackDefaultItem()
            	local  cell = self.rank_list:getItem(i-1)

                         local retroactive_bt=cell:getChildByTag(959)  --补签

                        retroactive_bt:setTag(i)
                        retroactive_bt:addTouchEventListener(function(sender, eventType  )
                             if eventType ~= ccui.TouchEventType.ended then
                                    return
                            end
                            local _tag=sender:getTag()
                            GameScene = require("app.scenes.GameScene")
                             local scene=GameScene.new({adid=self.id,type="daojishi",image=" ",cycle=_tag,heroid=""})  --daojishi
                             cc.Director:getInstance():pushScene(scene)
                        end)

                        
                        local integral_text=cell:getChildByTag(93)--积分
                       for j=1,#One_data do
                           if One_data[j]["cycle"]  ==i then
                             
                             integral_text:setString(One_data[j]["points"])

                             break
                        else
                            -- local integral_text=cell:getChildByTag(93)--积分
                               integral_text:setString("0")
                              
                        end
                       end
                        if integral_text:getString()  ~= "0" then
                            retroactive_bt:setVisible(false)
                        end
            	
	            local time_text=cell:getChildByTag(95)--时间
                    if self._type<3 then
                            local  tpy=_ble[tonumber(self._type)+1]
                            time_text:setString("第"  .. i  ..  tpy)
                    elseif self._type==5 then
                            time_text:setString("第"  .. i  ..  "天")   --热门
                    else
                             time_text:setString("第"  .. i  ..  "天")  --零时
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