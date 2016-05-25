
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- display FPS stats on screen
DEBUG_FPS = false

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "portrait"

-- design resolution
CONFIG_SCREEN_WIDTH  = 640
CONFIG_SCREEN_HEIGHT = 960

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

--传输加密Key
MD5_KEY="PINLEGAME"
--版本号
PINLE_VERSION="3.0.0"


--四个公有文件引入
require("app.model.Server.Server")--请求文件
require("app.model.NotificationCenter")--消息文件
require("app.model.LocalData.LocalData")--数据文件
DetailsLayer = require("app.layers.DetailsLayer")--活动详情
ContrastRecordLayer = require("app.layers.ContrastRecordLayer")--对比积分排行榜
SurpriseOverScene = require("app.scenes.SurpriseOverScene")--惊喜吧结束界面
OnerecordLayer = require("app.layers.OnerecordLayer")--个人积分界面
RankinglistofactiviesLayer = require("app.layers.RankinglistofactiviesLayer")--排行榜界面
FloatingLayerEx = require("app.layers.FloatingLayer")--提示文件
MainInterfaceScene = require("app.scenes.MainInterfaceScene")--主界面
SurpriseScene = require("app.scenes.SurpriseScene")--惊喜吧




--消息处理方法枚举
G_NOTIFICATION_EVENT = {
	LOGIN_POST="login_post",--登陆
	SURPRIS_SCENE="SURPRIS_SCENE",--惊喜吧场景
	SURPRIS_LIST="SURPRIS_LIST", --获取惊喜吧列表
	SURPRIS_LIST_IMAGE="SURPRIS_LIST_IMAGE",--惊喜吧图片下载
	DETAILS_LAYER_IMAGE="DETAILS_LAYER_IMAGE", --活动详情
	RANK_LAYER_IMAGE   ="RANK_LAYER_IMAGE" ,--排行榜
	ONERECORD_LAYER_IMAGE="ONERECORD_LAYER_IMAGE" ,--个人记录排行榜
	CONTRASRECORD_LAYER_IMAGE="CONTRASRECORD_LAYER_IMAGE" ,--对比积分排行榜
	LAOHUJI_LAYER_IMAGE="LAOHUJI_LAYER_IMAGE" ,--老虎机
	USERINFOINIT_LAYER_IMAGE="USERINFOINIT_LAYER_IMAGE", --个人信息初始化数据
	USERINFO_LAYER_IMAGE="USERINFO_LAYER_IMAGE" --个人信息修改
}

