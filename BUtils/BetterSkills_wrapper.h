/**
* @name BetterSkills ——— 更好的技能
* @author Cooliecrad - Ptil0psis@outlook.com
*
* @brief 针对SOM3调用用户自定义技能时，无法给技能传递参数的解决方案
* 用户需要为项目提前引入Lua语言的静态库，然后使用装饰器即可。
*
* @note 如何使用：
* Step1. 需要lua5.1的源代码，完成构建，并且正确的被BetterSkills_wrapper.h引用
* Step2. 开发者需要在自己的Skill中使用BetterSkills_def宏（在.c/.cpp文件末尾）和
* BetterSkills_decl宏（在.h/.hpp文件中，如果有，否则也在.c/.cpp文件中）。使用这两个
* 宏时，请保证BetterSkills_decl在BetterSkills_def前使用。
* 
* @example 使用案例：用户想要定义一个Skill，叫做foo。其接收Play传递的target_id参数，
* 类型为int。Skill向Play返回一个bool型参数。用户使用VS2013来开发。
* 下面是使用案例（也可以参考./example）:
*
*
* ***** 文件结构 ***************************************************************
* - lualib/
*   - lua.h
*   - lauxlib.h
*   ...lua5.1的源文件
*
* - BUtils/
*   - BetterSkills_wrapper.h
*   ...BUtils的源文件
*
* - Foo/
*   - foo.h
*   - foo.cpp
*
* ***** ./foo.h ***************************************************************
* #ifndef __FOO_H__
* #define _FOO_H__
*
* #define __BSKILLS_PARAMS_COUNT 1
* #include "BUtils/BetterSkills_wrapper.h"
* BetterSkills_decl(foo)
*
* #endif
*
* ***** ./foo.cpp *************************************************************
* #include "foo.h"
* bool foo_decl(const WorldModel *model, PlayerTask& task,
*               int self_id, int target_id)
* {
*     return true;
* }
* BetterSkills_def(foo, bool, foo_decl, int)
*
*
* @def LUA:导入的参数对lua参数类型的支持程度
*      Type    |   Support
*      nil            √
*    boolean          √
*    number           √
*    string           √
*   function     only c function
*   userdata          √
*    thread           ×
*    table            ×
*
* @def CPP:导入的参数支持作为参数的C常用数据类型
*        Type      |   Support
*        bool             √
*        int           warning
*      int64_t            √
*      uintXX_t           x
*       char *            √
*       string            √
*       float          warning
*       double            √
*
*
* @def LUA:导出的返回值对lua参数类型的支持程度
*      Type    |   Support
*      nil            √        *需要特殊定义
*    boolean          √
*    number           √
*    string           √
*   function          ×
*   userdata          ×
*    thread           ×
*    table            ×
*
* @def CPP:导出的返回值支持作为参数的C常用数据类型
*        Type      |   Support
*        void             √        *需要特殊定义
*        bool             √
*        int           warning
*      int64_t            √
*      uintXX_t           x
*       char *            √
*       string            √
*       float          warning
*       double            √
*/
#ifndef __BETTER_SKILLS_WRAPPER_H__
#define __BETTER_SKILLS_WRAPPER_H__


extern "C"{
#include "lualib/lua.h"
#include "lualib/lauxlib.h"
}

#include <cstdint>
#include <string>

// 判断某些没有变长参数特性的预处理器的情况
// 目前已知VS2013的VC++预处理器并不支持变长参数特性
#ifdef _MSC_VER
#if _MSC_VER <= 1800
#define __BSKILLS_NO_VA_ARGS__ // 预处理器不支持变参宏
#endif
#endif

#ifndef __BSKILLS_NO_VA_ARGS__
#include "__BetterSkills_wrapper_cpp11.h" // 支持变长参数的版本
#else
#include "__BetterSkills_wrapper_vs2013.h" // 不支持变长参数的版本
#endif

// 用于连接参数的宏
#define _bskills_contact(a, b) __bskills_contact(a, b)
#define __bskills_contact(a, b) a ## b

namespace BetterSkills {
    // 解析参数的函数
    void __lua_toctype(lua_State *L, int index, bool& dst);
    void __lua_toctype(lua_State *L, int index, lua_CFunction& dst);
    void __lua_toctype(lua_State *L, int index, int& dst);
    void __lua_toctype(lua_State *L, int index, lua_Integer& dst);
    void __lua_toctype(lua_State *L, int index, char*& dst);
    void __lua_toctype(lua_State *L, int index, std::string& dst);
    void __lua_toctype(lua_State *L, int index, float& dst);
    void __lua_toctype(lua_State *L, int index, lua_Number& dst);

    void __lua_ret_extractor(lua_State *L, bool value);
    //void __lua_ret_extractor(lua_State *L, int value);
    void __lua_ret_extractor(lua_State *L, lua_Integer value);
    void __lua_ret_extractor(lua_State *L, const char* value);
    void __lua_ret_extractor(lua_State *L, const std::string& value);
    void __lua_ret_extractor(lua_State *L, float value);
    void __lua_ret_extractor(lua_State *L, lua_Number& value);
};


//-----------------------------------------------------------------------------
// Lua部分：用于加载库的函数的宏

// 加载库的函数的声明
#define bskills_lib_loader_decl
extern "C" int lua_lib_loader(lua_State *L);

// 用来储存返回值的空间分配
#ifdef __BSKILLS_RETURN_VOID
#define __bskills_ret_def(ret_t)
#else
#define __bskills_ret_def(ret_t) static ret_t __bskills_gen_ret;
#endif

// 加载库的函数的定义
#define __bskills_lib_loader_def(identi) \
int lua_lib_loader(lua_State *L) \
{\
    lua_pushstring(L, # identi);\
    return 1;\
}\


//-----------------------------------------------------------------------------
// Lua部分：传入参数的宏

// 接收虚拟栈传入的参数
#define bskills_recv_params(x) _bskills_contact(__bskills_recv_params, x)
#define __bskills_recv_params10 \
BetterSkills::__lua_toctype(L, -10, __bskills_gen_10); __bskills_recv_params9
#define __bskills_recv_params9 \
BetterSkills::__lua_toctype(L, -9, __bskills_gen_9); __bskills_recv_params8
#define __bskills_recv_params8 \
BetterSkills::__lua_toctype(L, -8, __bskills_gen_8); __bskills_recv_params7
#define __bskills_recv_params7 \
BetterSkills::__lua_toctype(L, -7, __bskills_gen_7); __bskills_recv_params6
#define __bskills_recv_params6 \
BetterSkills::__lua_toctype(L, -6, __bskills_gen_6); __bskills_recv_params5
#define __bskills_recv_params5 \
BetterSkills::__lua_toctype(L, -5, __bskills_gen_5); __bskills_recv_params4
#define __bskills_recv_params4 \
BetterSkills::__lua_toctype(L, -4, __bskills_gen_4); __bskills_recv_params3
#define __bskills_recv_params3 \
BetterSkills::__lua_toctype(L, -3, __bskills_gen_3); __bskills_recv_params2
#define __bskills_recv_params2 \
BetterSkills::__lua_toctype(L, -2, __bskills_gen_2); __bskills_recv_params1
#define __bskills_recv_params1 \
BetterSkills::__lua_toctype(L, -1, __bskills_gen_1);
#define __bskills_recv_params0 

// 生成导出到lua语言中传递参数的lua_p_receiver函数的声明
#define bskills_p_receiver_decl \
extern "C" int lua_p_receiver(lua_State *L);

// 生成导出到lua语言中传递参数的lua_p_receiver函数的定义
#ifdef __BSKILLS_RETURN_VOID
#define bskills_p_receiver_def(x)\
int lua_p_receiver(lua_State *L) \
{\
    bskills_recv_params(x)\
    return 0;\
}
#else
#define bskills_p_receiver_def(x)\
int lua_p_receiver(lua_State *L) \
{\
    bskills_recv_params(x)\
    return 0;\
}
#endif

//-----------------------------------------------------------------------------
// Lua部分：lua语言中提取返回值的函数的宏

// 生成提取返回值函数的声明的宏
#define bskills_ret_extractor_decl \
extern "C" int lua_ret_extractor(lua_State *L);

// 生成提取返回值函数的定义的宏
#ifdef __BSKILLS_RETURN_VOID
#define bskills_ret_extractor_def
int lua_ret_extractor(lua_State *L) \
{ \
    return 1; \
}
#else
#define bskills_ret_extractor_def \
int lua_ret_extractor(lua_State *L) \
{ \
    BetterSkills::__lua_ret_extractor(L, __bskills_gen_ret); \
    return 1; \
}
#endif


//-----------------------------------------------------------------------------
// Lua部分：lua语言中导入库的函数的宏

// 生成导出到lua语言中导出库的函数的声明
#define bskills_export_decl(libname)\
extern "C"_declspec(dllexport) \
int luaopen_ ## libname (lua_State *L);

// Lua语言传递参数使用的函数名称定义
#define BSKILLS_LOAD_FUNCNAME "load" // 加载函数，第一次加载时触发，传递函数信息
#define BSKILLS_SEND_FUNCNAME "send" // 传递参数的函数
#define BSKILLS_EXT_FUNCNAME "extract" // 传递返回值的函数
// 生成导出到lua语言中导出库的函数的定义
#define bskills_export_def(libname)\
int luaopen_ ## libname (lua_State *L)\
{\
    static const char __libname[] = { # libname };\
    static luaL_Reg CFuncTable[] = {{BSKILLS_SEND_FUNCNAME, lua_p_receiver},\
                                    {BSKILLS_LOAD_FUNCNAME, lua_lib_loader},\
                                    {BSKILLS_EXT_FUNCNAME, lua_ret_extractor}};\
    luaL_register(L, __libname, CFuncTable);\
    return 1;\
}


//-----------------------------------------------------------------------------
// PlayBot部分：从player_plan函数中调入用户函数的宏

// 加载参数
#define bskills_load_params(func, x) _bskills_contact(__bskills_load_params, x)(func)
#define __bskills_load_params10(func)\
func(model, task, robot_id, __bskills_gen_10, __bskills_gen_9, __bskills_gen_8, __bskills_gen_7, __bskills_gen_6, __bskills_gen_5, __bskills_gen_4, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1)
#define __bskills_load_params9(func)\
func(model, task, robot_id, __bskills_gen_9, __bskills_gen_8, __bskills_gen_7, __bskills_gen_6, __bskills_gen_5, __bskills_gen_4, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1)
#define __bskills_load_params8(func)\
func(model, task, robot_id, __bskills_gen_8, __bskills_gen_7, __bskills_gen_6, __bskills_gen_5, __bskills_gen_4, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1)
#define __bskills_load_params7(func)\
func(model, task, robot_id, __bskills_gen_7, __bskills_gen_6, __bskills_gen_5, __bskills_gen_4, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1) 
#define __bskills_load_params6(func)\
func(model, task, robot_id, __bskills_gen_6, __bskills_gen_5, __bskills_gen_4, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1)
#define __bskills_load_params5(func)\
func(model, task, robot_id, __bskills_gen_5, __bskills_gen_4, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1)
#define __bskills_load_params4(func)\
func(model, task, robot_id, __bskills_gen_4, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1)
#define __bskills_load_params3(func)\
func(model, task, robot_id, __bskills_gen_3, __bskills_gen_2, __bskills_gen_1) 
#define __bskills_load_params2(func)\
func(model, task, robot_id, __bskills_gen_2, __bskills_gen_1)
#define __bskills_load_params1(func)\
func(model, task, robot_id, __bskills_gen_1)
#define __bskills_load_params0(func)\
func(model, task, robot_id)

// 生成原始的player_plan函数声明
#define bskills_player_plan_decl \
extern "C"_declspec(dllexport) \
PlayerTask player_plan(const WorldModel* model, int robot_id);

// 生成原始的player_plan函数定义
#ifdef __BSKILLS_RETURN_VOID
#define bskills_player_plan_def(func, x)\
PlayerTask player_plan(const WorldModel* model, int robot_id) \
{\
    PlayerTask task; \
    bskills_load_params(func, x); \
    return task; \
}
#else
#define bskills_player_plan_def(func, x)\
PlayerTask player_plan(const WorldModel* model, int robot_id) \
{\
    PlayerTask task; \
    __bskills_gen_ret = bskills_load_params(func, x); \
    return task; \
}
#endif

/**
* @brief BetterSkills装饰器-声明宏
* 完成用户函数、Lua与C++交互函数的声明。如果用户有头文件，应该在头文件中引入此宏。
* 如果用户只有.cpp/.c文件，直接在源代码中使用本声明宏。
*/
#define BetterSkills_decl(libname) \
bskills_lib_loader_decl \
bskills_p_receiver_decl \
bskills_ret_extractor_decl \
bskills_player_plan_decl \
bskills_export_decl(libname)

#endif