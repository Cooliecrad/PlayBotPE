#ifndef __BETTER_SKILLS_WRAPPER_CPP11_H__
#define __BETTER_SKILLS_WRAPPER_CPP11_H__

// 计算参数宏
#define bskills_params_count(...)\
__bskills_params_count(-1, ## __VA_ARGS__, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
#define __bskills_params_count(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, COUNT, ...) COUNT

//-----------------------------------------------------------------------------
// 产生标识符
#define bskills_lib_loader_def(ret_t, ...) _bskills_contact(bskills_lib_loader_def, bskills_params_count(__VA_ARGS__))(ret_t, __VA_ARGS__)
#define bskills_lib_loader_def10(ret_t, _t10, _t9, _t8, _t7, _t6, _t5, _t4, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t10 ##_## _t9 ##_## _t8 ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def9(ret_t, _t9, _t8, _t7, _t6, _t5, _t4, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t9 ##_## _t8 ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def8(ret_t, _t8, _t7, _t6, _t5, _t4, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t8 ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def7(ret_t, _t7, _t6, _t5, _t4, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def6(ret_t, _t6, _t5, _t4, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def5(ret_t, _t5, _t4, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def4(ret_t, _t4, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def3(ret_t, _t3, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t3 ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def2(ret_t, _t2, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t2 ##_## _t1)
#define bskills_lib_loader_def1(ret_t, _t1)\
__bskills_lib_loader_def(ret_t ##_## _t1)
#define bskills_lib_loader_def0(ret_t)\
__bskills_lib_loader_def(ret_t)



//-----------------------------------------------------------------------------
// 声明变量
#define bskills_def_params(...) _bskills_contact(__bskills_def_params, bskills_params_count(__VA_ARGS__))(__VA_ARGS__)
#define __bskills_def_params10(_t0, ...)\
__bskills_def(_t0, 10) __bskills_def_params9(__VA_ARGS__)
#define __bskills_def_params9(_t0, ...)\
__bskills_def(_t0, 9) __bskills_def_params8(__VA_ARGS__)
#define __bskills_def_params8(_t0, ...)\
__bskills_def(_t0, 8) __bskills_def_params7(__VA_ARGS__)
#define __bskills_def_params7(_t0, ...)\
__bskills_def(_t0, 7) __bskills_def_params6(__VA_ARGS__)
#define __bskills_def_params6(_t0, ...)\
__bskills_def(_t0, 6) __bskills_def_params5(__VA_ARGS__)
#define __bskills_def_params5(_t0, ...)\
__bskills_def(_t0, 5) __bskills_def_params4(__VA_ARGS__)
#define __bskills_def_params4(_t0, ...)\
__bskills_def(_t0, 4) __bskills_def_params3(__VA_ARGS__)
#define __bskills_def_params3(_t0, ...)\
__bskills_def(_t0, 3) __bskills_def_params2(__VA_ARGS__)
#define __bskills_def_params2(_t0, ...)\
__bskills_def(_t0, 2) __bskills_def_params1(__VA_ARGS__)
#define __bskills_def_params1(_t0) __bskills_def(_t0, 1)
#define __bskills_def_params0()
// 声明单个变量
#define __bskills_def(_tp, _i) static _tp __bskills_gen_ ## _i;


/**
* @brief BetterSkills装饰器-定义宏
* 完成用户函数、Lua与C++交互函数的定义。直接在.cpp/.c文件中使用本定义宏。
*/
#define BetterSkills_def(libname, ret_t, target_func, ...) \
__bskills_ret_def(ret_t) \
bskills_lib_loader_def(ret_t, __VA_ARGS__) \
bskills_def_params(__VA_ARGS__) \
bskills_p_receiver_def(bskills_params_count(__VA_ARGS__)) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, bskills_params_count(__VA_ARGS__)) \
bskills_export_def(libname)


#endif