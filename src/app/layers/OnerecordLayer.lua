--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--   个人排行榜
local OnerecordLayer = class("OnerecordLayer", function()
            return display.newLayer("OnerecordLayer")
end)
function OnerecordLayer:move_layer(_layer)
     
    local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(1.5,cc.p(_layer:getPositionX(),curr_y))  
      local sque=transition.sequence({cc.EaseElasticOut:create(move)})
      _layer:runAction(sque)
end

--标题 活动类型 
function OnerecordLayer:ctor(params)
         self.type=params.type
         self.title=params.title
         self.id=params.id
         self._type=params._type
         self.phyimage=params._img
         Server:Instance():getactivitypointsdetail(self.id," ")  --个人记录排行榜HTTP
         self:setNodeEventEnabled(true)--layer添加监听
        -- Server:Instance():getactivitybyid(self.id,1)
end
function OnerecordLayer:init(  )
            self.fragment_sprite = cc.CSLoader:createNode("masklayer.csb")  
           self:addChild(self.fragment_sprite)

	self.OnerecordLayer = cc.CSLoader:createNode("OnerecordLayer.csb");
    	self:addChild(self.OnerecordLayer)
            self:move_layer(self.OnerecordLayer)

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
            if next(One_data) ==nil then
              return
            end
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
                              local _activitybyid=LocalData:Instance():get_getactivitybyid()
               local userdt = LocalData:Instance():get_userdata()
             if tonumber(_activitybyid["remaintimes"]) <=  0   then
                Server:Instance():prompt("您参与次数已经用完")
                return
             end
             print("金币数 "  ,tonumber(userdt["golds"]) ,"   ",  tonumber(_activitybyid["betgolds"]))
             if tonumber(userdt["golds"])  -    tonumber(_activitybyid["betgolds"])   <  0    then
                Server:Instance():prompt("金币不足，无法参与活动，快去奖池屯点金币吧！")
                return
             end
                            local _tag=sender:getTag()
                            -- GameScene = require("app.scenes.GameScene")
                            --  local scene=GameScene.new({adid=self.id,type="daojishi",image=" ",cycle=_tag,heroid=""})  --daojishi


                              local PhysicsScene = require("app.scenes.PhysicsScene")
                    -- Server:Instance():getactivityadlist(self.id)
                    local scene=PhysicsScene.new({id=self.id,cycle=_tag,heroid="",phyimage=self.phyimage})
                  



                             --Server:Instance():getactivitybyid(self.id,_tag)
                             --Server:Instance():getuserinfo() 
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
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self,
                       function()
                         print("个人记录")
                        self:init()
                      end)
end

function OnerecordLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self)
end


return OnerecordLayer