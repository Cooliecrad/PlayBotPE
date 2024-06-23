#include "foo.h"
bool foo_decl(const WorldModel *model, PlayerTask& task,
              int self_id, int target_id)
{
    return true;
}

BetterSkills_def(foo, bool, foo_decl, int)