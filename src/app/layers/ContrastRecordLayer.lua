--
-- Author: peter
-- Date: 2016-05-09 16:51:21
--
local ContrastRecordLayer = class("ContrastRecordLayer", function()
            return display.newLayer("ContrastRecordLayer")
end)
--标题 头像 名字 排名  等级
function ContrastRecordLayer:ctor(params)
       self.id=params.id--activityid
       self.title=params.title--标题
       self.head=params.head--hero 头像
       self.name=params.name -- hero名称
       self.rank=params.rank --hero 排名
       self.level=params.level --hero 等级
       self.heroid=params.heroid --hero ID 
       self.allscore=params.allscore --总积分
       self._type=params._type
       print("dsfdsfdsfdsg  ",self.id,"   ",self.heroid)
       Server:Instance():getactivitypointsdetail(self.id,self.heroid)  --对比排行榜HTTP
       self:setNodeEventEnabled(true)--layer添加监听
       --Server:Instance():getactivitybyid(self.id,1)
       
end
function ContrastRecordLayer:init(  )
	self.ContrastRecordLayer = cc.CSLoader:createNode("ContrastRecordLayer.csb");
    	self:addChild(self.ContrastRecordLayer)

    	local activitybyid=LocalData:Instance():get_getactivitybyid()
      local userdt = LocalData:Instance():get_userdata()--
    	local oneallntegral=self.ContrastRecordLayer:getChildByTag(119)
	oneallntegral:setString(activitybyid["mypoints"])--我的积分

	local heroallntegral=self.ContrastRecordLayer:getChildByTag(120)
	heroallntegral:setString(self.allscore)--hero总积分

    	local title_text=self.ContrastRecordLayer:getChildByTag(104)--标题
      title_text:setString(self.title)

      local level_text=self.ContrastRecordLayer:getChildByTag(105)--等级
      level_text:setString(userdt["grade"])

      local name_text=self.ContrastRecordLayer:getChildByTag(106)--名称  rankname
      name_text:setString(userdt["nickname"])

      local rank_text=self.ContrastRecordLayer:getChildByTag(107)--排名
      rank_text:setString(activitybyid["myrank"])

      local dengji_text=self.ContrastRecordLayer:getChildByTag(101)--等级
      dengji_text:setString(userdt["rankname"])

      local head_image=self.ContrastRecordLayer:getChildByTag(108)--头像
      head_image:loadTexture(LocalData:Instance():get_user_head())--(self.head)
	
      local _back=self.ContrastRecordLayer:getChildByTag(121)-- 返回
      _back:addTouchEventListener(function(sender, eventType  )
                 self:touch_callback(sender, eventType)
        end)
    	self.rank_list=self.ContrastRecordLayer:getChildByTag(109)--排行榜列表
      self.rank_list:setItemModel(self.rank_list:getItem(0))
      self.rank_list:removeAllItems()
	self:ContrastRecord_init()
end
function ContrastRecordLayer:touch_callback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                    return
            end
            local tag=sender:getTag()
            if tag==121 then --返回
               self:removeFromParent()
            end
               
        
end

function ContrastRecordLayer:ContrastRecord_init(  )
	self.rank_list:removeAllItems()
	self.list_table=LocalData:Instance():get_getactivitypointsdetail()
            local  mypointslist=self.list_table["mypointslist"]
            local  playerpointslist=self.list_table["playerpointslist"]
            local playernum=0
            local mynum=0
            if #playerpointslist==0 then
               playernum=0
            else
               playernum=playerpointslist[#playerpointslist]["cycle"]
            end
            if #mypointslist==0 then
              mynum=0
            else
              mynum=mypointslist[#mypointslist]["cycle"]
            end
            
            local count=mynum >= playernum and mynum or playernum  
            print("时间 ",count)
	for i=1,count do
            self.rank_list:pushBackDefaultItem()
		local  cell = self.rank_list:getItem(i-1)
            local retroactive_bt=cell:getChildByTag(909)  --补签
            retroactive_bt:setTag(i)
            retroactive_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                local _tag=sender:getTag()
                GameScene = require("app.scenes.GameScene")
                 local scene=GameScene.new({adid=self.id,type="daojishi",image=" ",cycle=_tag,heroid=self.heroid})  --daojishi
                 cc.Director:getInstance():pushScene(scene)
                 Server:Instance():getactivitybyid(self.id,_tag)
                 Server:Instance():getuserinfo() 
            end)


            if #mypointslist ~=0  then

                  local one_integral=cell:getChildByTag(117)--积分

                         one_integral:setVisible(false)--xin
                         self.labelAtlas1 = ccui.TextAtlas:create()
                         self.labelAtlas1:setPosition(cc.p(one_integral:getPositionX(),one_integral:getPositionY()))  
                         cell:addChild(self.labelAtlas1) 
                         self.labelAtlas1:setProperty(2222, "png/cou.png", 26, 35, "0")
             
                 for j=1,#mypointslist do 
                     


                        if mynum  ~=0 and tonumber(mypointslist[j]["cycle"]) == i then
                              
                                --one_integral:setString(mypointslist[j]["points"])--xin
                                 self.labelAtlas1:setString(tostring(mypointslist[j]["points"]))   --setProperty(mypointslist[j]["points"], "png/cou.png", 26, 35, "0")
                                 retroactive_bt:setVisible(false)
                                  break
                        else
                                --one_integral:setString("0")  --xin
                          
                               self.labelAtlas1:setString("0")  

                        end

                  end
            else
                  local one_integral=cell:getChildByTag(117)--积分
                  --one_integral:setString("0")

                   one_integral:setVisible(false)--xin
                   local labelAtlas1 = ccui.TextAtlas:create()
                   labelAtlas1:setPosition(cc.p(one_integral:getPositionX(),one_integral:getPositionY()))  
                   labelAtlas1:setProperty(0, "png/cou.png", 26, 35, "0")
                   cell:addChild(labelAtlas1) 


            end
           



		if #playerpointslist ~=0  then
      
         local hero_integral=cell:getChildByTag(116)--积分
                               hero_integral:setVisible(false)
                               --hero_integral:setString(playerpointslist[k]["points"])
                               local labelAtlas = ccui.TextAtlas:create()
                               labelAtlas:setProperty(0, "png/cou.png", 26, 35, "0")
                               labelAtlas:setPosition(cc.p(hero_integral:getPositionX(),hero_integral:getPositionY()))  
                               cell:addChild(labelAtlas) 

                  for k=1,#playerpointslist do
                   

              
                         if playernum ~= 0 and playerpointslist[k]["cycle"]  == i  then
                                  labelAtlas:setString(playerpointslist[k]["points"])
                             
                               break
                         else
                                -- local hero_integral=cell:getChildByTag(116)--积分
                                -- hero_integral:setString("0")
                                 --local hero_integral=cell:getChildByTag(116)--积分
                                 --hero_integral:setVisible(false)
                                 hero_integral:setString("0")
                                 -- local labelAtlas = ccui.TextAtlas:create()
                                 -- labelAtlas:setProperty(2, "png/cou.png", 26, 35, "0")
                                 -- labelAtlas:setPosition(cc.p(hero_integral:getPositionX(),hero_integral:getPositionY()))  
                                 -- cell:addChild(labelAtlas) 


                         end
                  end
           else
            -- local hero_integral=cell:getChildByTag(116)--积分
            --   hero_integral:setString("0")

               local hero_integral=cell:getChildByTag(116)--积分
               hero_integral:setVisible(false)
               --hero_integral:setString("0")
               local labelAtlas = ccui.TextAtlas:create()
               labelAtlas:setProperty(0, "png/cou.png", 26, 35, "0")
               labelAtlas:setPosition(cc.p(hero_integral:getPositionX(),hero_integral:getPositionY()))  
               cell:addChild(labelAtlas) 

          end
           
         
		


		local name_text=cell:getChildByTag(115)--时间
            local _ble={"月","周","天","天"}--年0  月1  周2  日  整点   热门5  （整点和热门没有）
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
function ContrastRecordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self,
                       function()
                        self:init()
                      end)
end

function ContrastRecordLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self)
end

return ContrastRecordLayer


