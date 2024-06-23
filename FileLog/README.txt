FileLog 简单的打印日志到文件

C++示例：

#include "FileLog/ps_file_log.h" // 引用
static FileLogger logger {"Skills.log", "PsRecvBall"}; // 创建logger

logger.debug("%1, %2", "Hello", "World"); // 使用