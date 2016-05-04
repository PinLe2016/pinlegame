
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
CONFIG_SCREEN_HEIGHT = 1136

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

--传输加密Key
MD5_KEY="PINLEGAME"
--版本号
PINLE_VERSION="3.0.0"

--消息处理方法枚举
G_NOTIFICATION_EVENT = {
	LOGIN_POST="login_post",--登陆
	SURPRIS_SCENE="SURPRIS_SCENE",--惊喜吧场景
	SURPRIS_LIST="SURPRIS_LIST", --获取惊喜吧列表
	SURPRIS_LIST_IMAGE="SURPRIS_LIST_IMAGE" --惊喜吧图片下载

	
}
