#ifndef __BETTER_SKILLS_WRAPPER_VS2013_H__
#define __BETTER_SKILLS_WRAPPER_VS2013_H__

/**
* 下面会根据用户定义的参数数量来决定宏的参数，其中包含BetterSkills_def宏
* @brief BetterSkills装饰器-定义宏
* 完成用户函数、Lua与C++交互函数的定义。直接在.cpp/.c文件中使用本定义宏。
*/

// 声明用来临时储存参数的空间
#ifndef __BSKILLS_PARAMS_COUNT
#else
#if __BSKILLS_PARAMS_COUNT == 10
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3, _t4, _t5, _t6, _t7, _t8, _t9, _t10) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t10 ##_## _t9 ##_## _t8 ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
static _t4 __bskills_gen_4; \
static _t5 __bskills_gen_5; \
static _t6 __bskills_gen_6; \
static _t7 __bskills_gen_7; \
static _t8 __bskills_gen_8; \
static _t9 __bskills_gen_9; \
static _t10 __bskills_gen_10; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 9
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3, _t4, _t5, _t6, _t7, _t8, _t9) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t9 ##_## _t8 ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
static _t4 __bskills_gen_4; \
static _t5 __bskills_gen_5; \
static _t6 __bskills_gen_6; \
static _t7 __bskills_gen_7; \
static _t8 __bskills_gen_8; \
static _t9 __bskills_gen_9; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 8
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3, _t4, _t5, _t6, _t7, _t8) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t8 ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
static _t4 __bskills_gen_4; \
static _t5 __bskills_gen_5; \
static _t6 __bskills_gen_6; \
static _t7 __bskills_gen_7; \
static _t8 __bskills_gen_8; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 7
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3, _t4, _t5, _t6, _t7) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t7 ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
static _t4 __bskills_gen_4; \
static _t5 __bskills_gen_5; \
static _t6 __bskills_gen_6; \
static _t7 __bskills_gen_7; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 6
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3, _t4, _t5, _t6) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t6 ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
static _t4 __bskills_gen_4; \
static _t5 __bskills_gen_5; \
static _t6 __bskills_gen_6; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 5
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3, _t4, _t5) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t5 ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
static _t4 __bskills_gen_4; \
static _t5 __bskills_gen_5; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 4
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3, _t4) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t4 ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
static _t4 __bskills_gen_4; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 3
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2, _t3) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t3 ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
static _t3 __bskills_gen_3; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 2
#define BetterSkills_def(libname, ret_t, target_func, _t1, _t2) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t2 ##_## _t1) \
static _t1 __bskills_gen_1; \
static _t2 __bskills_gen_2; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 1
#define BetterSkills_def(libname, ret_t, target_func, _t1) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t ##_## _t1) \
static _t1 __bskills_gen_1; \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#elif __BSKILLS_PARAMS_COUNT == 0
#define BetterSkills_def(libname, ret_t, target_func) \
__bskills_ret_def(ret_t); \
__bskills_lib_loader_def(ret_t) \
bskills_p_receiver_def(__BSKILLS_PARAMS_COUNT) \
bskills_ret_extractor_def \
bskills_player_plan_def(target_func, __BSKILLS_PARAMS_COUNT) \
bskills_export_def(libname)

#endif

#endif

#endif