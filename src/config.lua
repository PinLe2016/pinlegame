
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
PINLE_VERSION="3.1.0"

--公共
 qqqq=0
 dialogdetermine=0  --弹出提示框

--测试版本还是正式版本标记
IS_RELEASE=true --false 测试版 ，true 正式版

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
GameScene = require("app.scenes.GameScene")
MainInterfaceScene = require("app.scenes.MainInterfaceScene")--主界面
SurpriseScene = require("app.scenes.SurpriseScene")--惊喜吧




--消息处理方法枚举
G_NOTIFICATION_EVENT = {
	LOGIN_POST=							"login_post",--登陆
	REG=								"REG",--注册
	SURPRIS_SCENE=						"SURPRIS_SCENE",--惊喜吧场景
	SURPRIS_LIST=						"SURPRIS_LIST", --获取惊喜吧列表
	SURPRIS_LIST_IMAGE=					"SURPRIS_LIST_IMAGE",--惊喜吧图片下载
	DETAILS_LAYER_IMAGE=				"DETAILS_LAYER_IMAGE", --活动详情
	RANK_LAYER_IMAGE   =				"RANK_LAYER_IMAGE" ,--排行榜
	ONERECORD_LAYER_IMAGE=				"ONERECORD_LAYER_IMAGE" ,--个人记录排行榜
	CONTRASRECORD_LAYER_IMAGE=			"CONTRASRECORD_LAYER_IMAGE" ,--对比积分排行榜
	LAOHUJI_LAYER_IMAGE=				"LAOHUJI_LAYER_IMAGE" ,--老虎机
	USERINFOINIT_LAYER_IMAGE=			"USERINFOINIT_LAYER_IMAGE", --个人信息初始化数据
	USERINFO_LAYER_IMAGE=				"USERINFO_LAYER_IMAGE", --个人信息修改
	ACTIVITYYADLIST_LAYER_IMAGE=		"ACTIVITYYADLIST_LAYER_IMAGE", --获取指定活动的广告列表 
	ACTIVITYYADLISTPIC_LAYER_IMAGE=		"ACTIVITYYADLISTPIC_LAYER_IMAGE", --下载指定活动的广告列表 
	JACKPOTLIST_POST=					"JACKPOTLIST_POST", --下载指定奖池的广告列表 
	JACKPOTLIST_PIC_POST=				"JACKPOTLIST_PIC_POST", --下载指定奖池的广告列表图片 
	JACKPOTLIST_INFOR_POST=				"JACKPOTLIST_INFOR_POST", --获取金币奖池的广告列表
	JACKPOTLISTPIC_INFOR_POST=			"JACKPOTLISTPIC_INFOR_POST", --获取金币奖池的广告列表
	GOLDSPOOLBYID_POST=					"CHECKINHISTORY_POST", --   获取指定金币奖池详情  getrecentgoldslist
	RECENTGOLDSLIST_POST=				"RECENTGOLDSLIST_POST", --获取最近10次金币奖池金币奖励接口  getrecentgoldslist
	CHECK_POST=							"CHECK_POST", --签到
	GAMERECORD_POST=					"GAMERECORD_POST", --拼图结束后上传数据  set_getcheckinhistory
	CHECKINHISTORY_POST=				"CHECKINHISTORY_POST", --签到历史   
	FRIENDLIST_POST=					"FRIENDLIST_POST", --查询好友列表  getfriendlist 
	POOL_RANDOM_GOLDS=					"poolrandomgolds",--奖池劲舞团每次随机获取金币信息 getgoldspoolrandomgolds
	ACTIVITYCODE=						"ACTIVITYCODE",--活动吗  Activity code
	VERRSION=							"VERRSION",--活动吗  热更新消息
	REGISTRATIONCODE=					"REGISTRATIONCODE",--注册的验证码
	PASSWOEDCHANGE=					"PASSWOEDCHANGE",--注册的验证码
	WINNERS=					            "WINNERS",--获奖名单 
	INVITATION_POLITE=					            "INVITATION_POLITE",--邀请有礼
	FRIENDSLEVELUP=					            "FRIENDSLEVELUP",--一键领取
	BACKSUPPOR=					            "BACKSUPPOR",--参与卷返回
	STECODE=								"setinvitecode",--邀请码刷新
	EMAILADDRESS=							"EMAILADDRESS",--初始化邮件地址
	JIGSAWCOUNT=							"JIGSAWCOUNT",--  点击弹出框确定
	AUTOMATICPUZZLE=						"AUTOMATICPUZZLE",--  点击弹出框确定自动拼图
	PRIZEPOOLDETAILS=						"PRIZEPOOLDETAILS",   --切换奖池详情
	VERSION_LINK=							"VERSION_LINK" ,  --游戏链接  affichelist
	AFFICHLIST=							"AFFICHLIST" ,  --邮件列表  
	AFFICHDETAIL=							"AFFICHDETAIL"  ,--邮件详情 delaffichebyid
	DELAFFICHEBYID=							"DELAFFICHEBYID" ,--删除邮件 getaffichedetail
	TAFFICHEDETAIL=							"TAFFICHEDETAIL"  , --领取邮件奖励 
	FEEDBACK=							"FEEDBACK"   ,--玩家反馈  feedback 
	TFEDBACK=							"TFEDBACK"  , --   gettasklist
	GETTASKLIST=							"GETTASKLIST"  , --   获取任务列表 
	TASKTARGETRECORD=					 "TASKTARGETRECORD"  , --   领取任务列表 settasktargetrecord
	PERFECT=					 "PERFECT"  , --   领取任务列表 perfect

}

G_SOUND={
	ACTIVITY="sound/background/activity.mp3",
	GAMEBG="sound/background/gameBg.mp3",
	MENUMUSIC="sound/background/menumusic.mp3",
	PERSONALCHAGE="sound/background/personalchage.mp3",

	--音效
	COUNTDOWN="sound/effect/321.mp3",
	BACK="sound/effect/back.mp3",
	BUTTON="sound/effect/button.mp3",
	CANCEL="sound/effect/cancel.mp3",
	DROPPIC="sound/effect/droppic.mp3",
	ERROR="sound/effect/error.mp3",
	FALLMONEY="sound/effect/fallmoney.mp3",
	LOGO="sound/effect/logo.mp3",
	LOST="sound/effect/lost.mp3",
	MOVE="sound/effect/move.mp3",
	PAGECHANGE="sound/effect/pagechange.mp3",
	PAGEPLAY="sound/effect/pageplay.mp3",
	PREVIEW="sound/effect/preview.mp3",
	SETTING="sound/effect/setting.mp3",
	WIN="sound/effect/win.mp3",
	--弹球音效
	PHYSICS="sound/effect/click.mp3",
}

































