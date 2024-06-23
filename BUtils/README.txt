BetterSkills ——— 更好的技能
@author Cooliecrad - Ptil0psis@outlook.com

*******************************************************************************
@brief 针对SOM3调用用户自定义技能时，无法给技能传递参数的解决方案
用户需要为项目提前引入Lua语言的静态库，然后使用装饰器即可。

@note 如何使用：
Step1. 需要lua5.1的源代码，完成构建，并且正确的被BetterSkills_wrapper.h引用
Step2. 开发者需要在自己的Skill中使用BetterSkills_def宏（在.c/.cpp文件末尾）和
BetterSkills_decl宏（在.h/.hpp文件中，如果有，否则也在.c/.cpp文件中）。使用这两个
宏时，请保证BetterSkills_decl在BetterSkills_def前使用。

@example 使用案例：用户想要定义一个Skill，叫做foo。其接收Play传递的target_id参数，
类型为int。Skill向Play返回一个bool型参数。用户使用VS2013来开发。
下面是使用案例（也可以参考./example）:


***** 文件结构 *****************************************************************
- lualib/
  - lua.h
  - lauxlib.h
  ...lua5.1的源文件

- BUtils/
  - BetterSkills_wrapper.h
  ...BUtils的源文件

- Foo/
  - foo.h
  - foo.cpp

***** ./foo.h ***************************************************************** 
#ifndef __FOO_H__
#define _FOO_H__

#define __BSKILLS_PARAMS_COUNT 1
#include "BUtils/BetterSkills_wrapper.h"
BetterSkills_decl(foo)

#endif

***** ./foo.cpp ***************************************************************
#include "foo.h"
bool foo_decl(const WorldModel* model, PlayerTask& task,
              int self_id, int target_id)
{
    return true;
}

BetterSkills_def(foo, bool, foo_decl, int)

*******************************************************************************

@def LUA:导入的参数对lua参数类型的支持程度
     Type    |   Support
     nil            √
   boolean          √
   number           √
   string           √
  function     only c function
  userdata          √
   thread           ×
   table            ×

@def CPP:导入的参数支持作为参数的C常用数据类型
       Type      |   Support
       bool             √
       int           warning
     int64_t            √
     uintXX_t           x
      char*             √
      string            √
      float          warning
      double            √


@def LUA:导出的返回值对lua参数类型的支持程度
     Type    |   Support
     nil            √        需要特殊定义
   boolean          √
   number           √
   string           √
  function          ×
  userdata          ×
   thread           ×
   table            ×

@def CPP:导出的返回值支持作为参数的C常用数据类型
       Type      |   Support
       void             √        需要特殊定义
       bool             √
       int           warning
     int64_t            √
     uintXX_t           x
      char*             √
      string            √
      float          warning
      double            √