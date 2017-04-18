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
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
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

         self.fragment_sprite = cc.CSLoader:createNode("masklayer.csb")  
           self:addChild(self.fragment_sprite)

    self.OnerecordLayer = cc.CSLoader:createNode("OnerecordLayer.csb");
        self:addChild(self.OnerecordLayer)
            self:move_layer(self.OnerecordLayer)
end
function OnerecordLayer:init(  )
           

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

                         local retroactive_bt=cell:getChildByName("Button_5")--getChildByTag(959)  --补签  Button_5

                        retroactive_bt:setTag(i)
                        retroactive_bt:addTouchEventListener(function(sender, eventType  )
                             if eventType ~= ccui.TouchEventType.ended then
                                    return
                            end
                              local _activitybyid=LocalData:Instance():get_getactivitybyid()
                               local userdt = LocalData:Instance():get_userdata()
                                self._tag=sender:getTag()
                             print("金币数 "  ,tonumber(userdt["golds"]) ,"   ",  tonumber(_activitybyid["betgolds"]))
                             self.p_point=0
                              for i=1,#One_data do
                                if One_data[i]["cycle"] == self._tag   then
                                   self.p_point= One_data[i]["points"]
                                end
                             end
                            print("dsfds  ",self.p_point)
                             if tonumber(userdt["golds"])  -    tonumber(_activitybyid["betgolds"])  -30   <  0  and  tonumber(self.p_point)  == 0  then
                                Server:Instance():prompt("金币不足，无法参与活动，快去奖池屯点金币吧！")
                                return
                             end
                             if tonumber(userdt["golds"])  -    tonumber(_activitybyid["betgolds"])     <  0  and  tonumber(self.p_point)  ~= 0  then
                                Server:Instance():prompt("金币不足，无法参与活动，快去奖池屯点金币吧！")
                                return
                             end
                            
                              local PhysicsScene = require("app.scenes.PhysicsScene")
                             local scene=PhysicsScene.new({id=self.id,cycle=self._tag,heroid="",phyimage=self.phyimage})
                             cc.Director:getInstance():pushScene(scene)
                        end)

                        
                        local integral_text=cell:getChildByTag(93)--积分
                       for j=1,#One_data do
                           if One_data[j]["cycle"]  ==i then
                             
                             integral_text:setString(One_data[j]["points"])
                               if tonumber(One_data[j]["remaintimes"])  <  0  or   tonumber(One_data[j]["remaintimes"])  ==   0  then
                                       retroactive_bt:setVisible(false)
                                end

                             break
                        else
                            -- local integral_text=cell:getChildByTag(93)--积分
                               integral_text:setString("0")
                              
                        end
                       end
                        if integral_text:getString()  ~= "0"  then
                            --retroactive_bt:setVisible(false)
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
            Server:Instance():getactivitybyid(self.id,0)
            self:removeFromParent()
            Util:all_layer_backMusic()

end
function OnerecordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self,
                       function()
                         print("个人记录")
                        self:init()
                      end)
         -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
         --               function()
         --                print("附近的撒娇范德萨发大放送")
         --                  local PhysicsScene = require("app.scenes.PhysicsScene")
         --                  local scene=PhysicsScene.new({id=self.id,cycle=self._tag,heroid="",phyimage=self.phyimage})
         --                  cc.Director:getInstance():pushScene(scene)

                      
         --              end)

end

function OnerecordLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self)
             -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
             cc.Director:getInstance():getTextureCache():removeAllTextures() 
end


return OnerecordLayer