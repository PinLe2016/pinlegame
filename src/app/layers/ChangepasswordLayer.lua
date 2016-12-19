--
-- Author: peter
-- Date: 2016-12-16 17:57:38
--
--修改密码
local ChangepasswordLayer = class("ChangepasswordLayer", function()
            return display.newLayer("ChangepasswordLayer")
end)

function ChangepasswordLayer:ctor()

            self:setNodeEventEnabled(true)--layer添加监听
            
            self:init()
           
            
end

function ChangepasswordLayer:init(  )
      local  userdata = LocalData:Instance():get_user_data()
      self.loginname=userdata["loginname"]

       self.changepassword= cc.CSLoader:createNode("ChangepasswordLayer.csb")
       self:addChild(self.changepassword)

       local _loginname=self.changepassword:getChildByTag(498)   --   手机号
       _loginname:setString(tostring(self.loginname))
       self.back_bt=self.changepassword:getChildByTag(208)   --  返回
       self.back_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       self._bt=self.changepassword:getChildByTag(206)   --   提交
       self._bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       self._oldpassword=self.changepassword:getChildByTag(78)   --   旧密码
       self._password=self.changepassword:getChildByTag(79)   --   新密码
       self.again_password=self.changepassword:getChildByTag(80)   --   再次新密码


end


function ChangepasswordLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==208 then
          	self:removeFromParent()
          elseif tag==206 then
            self:pass()
          end
         
end
function ChangepasswordLayer:pass( )
                  local _oldpassword=self._oldpassword:getString()     
                  local _password=self._password:getString()
                  local again_password=self.again_password:getString()   
                  print("修改密码",_oldpassword," ",_password," ",again_password)
                  if _password  ~= again_password    then
                      Server:Instance():prompt("两次密码输入不一样")
                            return
                  end
                  if (_oldpassword=="请输入原密码请"  or  _oldpassword== "")  or  (_password=="请输入新密码"  or  _password== "")  or  (again_password=="再次输入新密码"  or  again_password== "") then  --
                            Server:Instance():prompt("请您完善信息")
                            return
                  end

                Server:Instance():changepassword(self.loginname,_password," ",2,_oldpassword)  --(1  忘记密码)
end


function ChangepasswordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        

                      end)
	
end

function ChangepasswordLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 
end


return ChangepasswordLayer
