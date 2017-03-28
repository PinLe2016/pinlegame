--
-- Author: peter
-- Date: 2016-12-16 18:01:43
-- Date: 2016-12-16 17:57:38
--
--兑换帮助
local ForhelpLayer = class("ForhelpLayer", function()
            return display.newLayer("ForhelpLayer")
end)

function ForhelpLayer:ctor()

            self:setNodeEventEnabled(true)--layer添加监听

      
            self._tableTitle={
            "金币如何获取","封号解封方式","在线商城兑换","惊喜吧中奖","奖池规则", "惊喜吧年度活动规则说明","惊喜吧月度活动规则说明",
            "惊喜吧周活动规则说明","惊喜吧日活动规则说明","惊喜吧整点活动规则说明","惊喜吧热门活动规则说明",
            }
            self._neirong={
                                        "途径1:玩家通过参与金币奖池获取金币\
                                        \n途径2:玩家通过邀请好友获取金币\
                                        \n途径3:玩家通过被邀请人反馈获取金币\
                                        \n途径4:玩家通过签到获取金币",
                                        "玩家使用外挂或者第三方软件将被官方永久封禁",
                                        "点击商城，玩家通过消耗游戏内部金币换取",
                                        "惊喜吧活动结束，玩家在我的活动或者结束活动列表点击获奖名单，可查看自己是否中奖",

                                        "1、玩家通过点击奖池首图，选择游戏模式\
                                        \n2、选择打地鼠模式，进入游戏页面，连续敲打弹出的果冻图案获得打地鼠积分，积分越高，获得金币越多\
                                        \n3、选择拼图模式，进入游戏页面，将打乱的拼图恢复到原本位置，用时越短，获得金币越多\
                                        \n4、无论打地鼠模式还是拼图模式，每个奖池每天只有2次获得金币的机会，之后再次参与只能获得经验值\
                                        \n5、幸运卡可在大转盘中使用，使用后会有额外惊喜哟，幸运卡可通过“邀请好友”和“签到”两种方式获得",

                                        "1、年度大奖活动，活动周期1年，每位玩家有固定挑战次数，只取玩家单月单次最好成绩，最终结果按12个月的单次最好成绩累加排名。\
                                        \n2、每次参与都会扣除一定金币。\
                                        \n3、活动结束后由拼乐官方推送消息至中奖用户所注册的手机上,用户也可在“拼乐”微信公众号查询获奖名单。\
                                        \n4、个人信息请准确填写，奖品将按照用户所填写的个人信息进行发放。\
                                        \n5、中奖者的奖品以实物为准。特别说明：如因用户个人信息错误无效、手机关机等原因而造成10个工作日内无法取得联系则视为中奖者自动放弃该奖品，不予补发。\
                                        \n特此声明:拼乐Game应用内一切抽奖活动与苹果公司(Apple_Inc.)无关，最终解释权归北京拼乐网络技术有限公司所有。",

                                        "1、月度大奖活动，活动周期为28天，每位玩家有固定挑战次数，但只取玩家单周单次最好成绩，最终结果按照4个周的单次最好成绩累加排名。\
                                        \n2、每次参与都会扣除一定金币。\
                                        \n3、活动结束后由拼乐官方推送消息至中奖用户所注册的手机上，用户也可在“拼乐”微信公众号查询获奖名单。\
                                        \n4、个人信息请准确填写，奖品将按照用户所填写的个人信息进行发放。\
                                        \n5、中奖者的奖品以实物为准。特别说明：如因用户个人信息错误无效、手机关机等原因而造成10个工作日内无法取得联系则视为中奖者自动放弃该奖品，不予补发。\
                                        \n特此声明:拼乐Game应用内一切抽奖活动与苹果公司(Apple_Inc.)无关，最终解释权归北京拼乐网络技术有限公司所有。",


                                        "1、周度大奖活动，活动周期为7天，每位玩家有固定挑战次数，但只取玩家单天单次最好成绩，最终结果按照7天的单次最好成绩累加排名。\
                                        \n2、每次参与都会扣除一定金币。\
                                        \n3、活动结束后由拼乐官方推送消息至中奖用户所注册的手机上，用户也可在“拼乐”微信公众号查询获奖名单。\
                                        \n4、个人信息请准确填写，奖品将按照用户所填写的个人信息进行发放。\
                                        \n5、中奖者的奖品以实物为准。特别说明：如因用户个人信息错误无效、手机关机等原因而造成10个工作日内无法取得联系则视为中奖者自动放弃该奖品，不予补发。\
                                        \n特此声明:拼乐Game应用内一切抽奖活动与苹果公司(Apple_Inc.)无关，最终解释权归北京拼乐网络技术有限公司所有。",


                                        "1、每日活动，活动周期为24小时，每位玩家有固定挑战次数，最终结果按照当天所有成绩累加排名。\
                                        \n2、每次参与都会扣除一定金币。\
                                        \n3、活动结束后由拼乐官方推送消息至中奖用户所注册的手机上，用户也可在“拼乐”微信公众号查询获奖名单。\
                                        \n4、个人信息请准确填写，奖品将按照用户所填写的个人信息进行发放。\
                                        \n5、中奖者的奖品以实物为准。特别说明：如因用户个人信息错误无效、手机关机等原因而造成10个工作日内无法取得联系则视为中奖者自动放弃该奖品，不予补发。\
                                        \n特此声明:拼乐Game应用内一切抽奖活动与苹果公司(Apple_Inc.)无关，最终解释权归北京拼乐网络技术有限公司所有。",


                                        "1.整点活动，活动固定周期展示，每位玩家有固定挑战次数，最终结果按照周期内所有成绩累加排名。\
                                        \n2、每次参与都会扣除一定金币。\
                                        \n3、活动结束后由拼乐官方推送消息至中奖用户所注册的手机上，用户也可在“拼乐”微信公众号查询获奖名单。\
                                        \n4、个人信息请准确填写，奖品将按照用户所填写的个人信息进行发放。\
                                        \n5、中奖者的奖品以实物为准。特别说明：如因用户个人信息错误无效、手机关机等原因而造成10个工作日内无法取得联系则视为中奖者自动放弃该奖品，不予补发。\
                                        特此声明:拼乐Game应用内一切抽奖活动与苹果公司(Apple_Inc.)无关，最终解释权归北京拼乐网络技术有限公司所有。",


                                        "1、热门活动，活动固定周期展示，每位玩家有固定挑战次数，但只取玩家单天单次最好成绩，最终结果按照单天单次最好成绩累加排名。\
                                        \n2、每次参与都会扣除一定金币。\
                                        \n3、活动结束后由拼乐官方推送消息至中奖用户所注册的手机上，用户也可在“拼乐”微信公众号查询获奖名单。\
                                        \n4、个人信息请准确填写，奖品将按照用户所填写的个人信息进行发放。\
                                        \n5、中奖者的奖品以实物为准。特别说明：如因用户个人信息错误无效、手机关机等原因而造成10个工作日内无法取得联系则视为中奖者自动放弃该奖品，不予补发。\
                                        \n特此声明:拼乐Game应用内一切抽奖活动与苹果公司(Apple_Inc.)无关，最终解释权归北京拼乐网络技术有限公司所有。"

                                    }
            self:init()
end

function ForhelpLayer:init(  )

       self.forhelp= cc.CSLoader:createNode("ForhelpLayer.csb")
       self:addChild(self.forhelp)

       self.back_bt=self.forhelp:getChildByTag(672)   --  返回
       self.back_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       self.panel_bg=self.forhelp:getChildByTag(787)   --  面板
       self.panel_bg:setVisible(false)
       self.callback_bt=self.panel_bg:getChildByTag(788)   --  面板返回
       self.callback_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

        self._list=self.forhelp:getChildByTag(543)--列表
        self._list:setItemModel(self._list:getItem(0))
        self._list:removeAllItems()
       for i=1,11 do
            self._list:pushBackDefaultItem()
            local  cell = self._list:getItem(i-1)
            cell:setTag(i) 
            local  _title = cell:getChildByTag(670)
            _title:setString(self._tableTitle[i])

            cell:addTouchEventListener(function(sender, eventType  )
                                    self:callback(sender, eventType)
            end)
       end
end

function ForhelpLayer:callback( sender, eventType )
         local tag=sender:getTag()
          if eventType == ccui.TouchEventType.began then
                 
                 sender:getChildByTag(785):setVisible(true)
                return
          end
          sender:getChildByTag(785):setVisible(false)

          if eventType == ccui.TouchEventType.ended then
              self.panel_bg:setVisible(true)
              local  neitong_text1=self.panel_bg:getChildByTag(792)
              neitong_text1:scrollToTop (0.01,false)
              local neitong_text=neitong_text1:getChildByTag(793)
              self.panel_bg:setTouchEnabled(false)
              neitong_text1:setTouchEnabled(true)
              if tag<=4 then
                neitong_text1:setTouchEnabled(false)
                self.panel_bg:setTouchEnabled(true)
              end

              neitong_text:setString(self._neirong[tag])
          end
end



function ForhelpLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==672 then
            Util:all_layer_backMusic()
            
          	self:removeFromParent()
          elseif tag==788 then
            self.panel_bg:setVisible(false)
          end
end
function ForhelpLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        

                      end)
	
end

function ForhelpLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 cc.Director:getInstance():getTextureCache():removeAllTextures() 
end


return ForhelpLayer
