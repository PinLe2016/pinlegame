#include "lua_cocos2dx_custom.hpp"
#include "LaoHuJiDonghua.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cocos2dx_custom_LaoHuJiDonghua_setDate(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LaoHuJiDonghua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setDate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        int arg2;
        cocos2d::Vec2 arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LaoHuJiDonghua:setDate");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "LaoHuJiDonghua:setDate");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "LaoHuJiDonghua:setDate");

        ok &= luaval_to_vec2(tolua_S, 5, &arg3, "LaoHuJiDonghua:setDate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setDate'", nullptr);
            return 0;
        }
        cobj->setDate(arg0, arg1, arg2, arg3);
        return 0;
    }
    if (argc == 5) 
    {
        std::string arg0;
        std::string arg1;
        int arg2;
        cocos2d::Vec2 arg3;
        std::string arg4;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LaoHuJiDonghua:setDate");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "LaoHuJiDonghua:setDate");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "LaoHuJiDonghua:setDate");

        ok &= luaval_to_vec2(tolua_S, 5, &arg3, "LaoHuJiDonghua:setDate");

        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "LaoHuJiDonghua:setDate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setDate'", nullptr);
            return 0;
        }
        cobj->setDate(arg0, arg1, arg2, arg3, arg4);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:setDate",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setDate'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_setMaxtSpeed(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LaoHuJiDonghua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setMaxtSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "LaoHuJiDonghua:setMaxtSpeed");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setMaxtSpeed'", nullptr);
            return 0;
        }
        cobj->setMaxtSpeed(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:setMaxtSpeed",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setMaxtSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_setStartSpeed(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LaoHuJiDonghua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setStartSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "LaoHuJiDonghua:setStartSpeed");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setStartSpeed'", nullptr);
            return 0;
        }
        cobj->setStartSpeed(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:setStartSpeed",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_setStartSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_init(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LaoHuJiDonghua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_LaoHuJiDonghua_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_init'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_stopGo(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LaoHuJiDonghua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_LaoHuJiDonghua_stopGo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "LaoHuJiDonghua:stopGo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_stopGo'", nullptr);
            return 0;
        }
        cobj->stopGo(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:stopGo",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_stopGo'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_startGo(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LaoHuJiDonghua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_LaoHuJiDonghua_startGo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_startGo'", nullptr);
            return 0;
        }
        cobj->startGo();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:startGo",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_startGo'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_helloMsg(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LaoHuJiDonghua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_LaoHuJiDonghua_helloMsg'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_helloMsg'", nullptr);
            return 0;
        }
        std::string ret = cobj->helloMsg();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:helloMsg",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_helloMsg'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LaoHuJiDonghua",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_create'", nullptr);
            return 0;
        }
        LaoHuJiDonghua* ret = LaoHuJiDonghua::create();
        object_to_luaval<LaoHuJiDonghua>(tolua_S, "LaoHuJiDonghua",(LaoHuJiDonghua*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LaoHuJiDonghua:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cocos2dx_custom_LaoHuJiDonghua_constructor(lua_State* tolua_S)
{
    int argc = 0;
    LaoHuJiDonghua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_LaoHuJiDonghua_constructor'", nullptr);
            return 0;
        }
        cobj = new LaoHuJiDonghua();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"LaoHuJiDonghua");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LaoHuJiDonghua:LaoHuJiDonghua",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_LaoHuJiDonghua_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cocos2dx_custom_LaoHuJiDonghua_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LaoHuJiDonghua)");
    return 0;
}

int lua_register_cocos2dx_custom_LaoHuJiDonghua(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LaoHuJiDonghua");
    tolua_cclass(tolua_S,"LaoHuJiDonghua","LaoHuJiDonghua","cc.Layer",nullptr);

    tolua_beginmodule(tolua_S,"LaoHuJiDonghua");
        tolua_function(tolua_S,"new",lua_cocos2dx_custom_LaoHuJiDonghua_constructor);
        tolua_function(tolua_S,"setDate",lua_cocos2dx_custom_LaoHuJiDonghua_setDate);
        tolua_function(tolua_S,"setMaxtSpeed",lua_cocos2dx_custom_LaoHuJiDonghua_setMaxtSpeed);
        tolua_function(tolua_S,"setStartSpeed",lua_cocos2dx_custom_LaoHuJiDonghua_setStartSpeed);
        tolua_function(tolua_S,"init",lua_cocos2dx_custom_LaoHuJiDonghua_init);
        tolua_function(tolua_S,"stopGo",lua_cocos2dx_custom_LaoHuJiDonghua_stopGo);
        tolua_function(tolua_S,"startGo",lua_cocos2dx_custom_LaoHuJiDonghua_startGo);
        tolua_function(tolua_S,"helloMsg",lua_cocos2dx_custom_LaoHuJiDonghua_helloMsg);
        tolua_function(tolua_S,"create", lua_cocos2dx_custom_LaoHuJiDonghua_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LaoHuJiDonghua).name();
    g_luaType[typeName] = "LaoHuJiDonghua";
    g_typeCast["LaoHuJiDonghua"] = "LaoHuJiDonghua";
    return 1;
}
TOLUA_API int register_all_cocos2dx_custom(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_cocos2dx_custom_LaoHuJiDonghua(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

