#include "ps_file_log.h"

#include <sstream>

using namespace std;

FileLogger::FileLogger(const char *filename, const char *log_tag,
                       bool need_refresh)
{
    fp = fopen(filename, need_refresh ? "w" : "a");
    this->log_tag = log_tag;
}

void FileLogger::print(const char *tag, const char *log)
{
    #ifdef _DEBUG
    stringstream ss;
    ss << '[' << tag << " | " << log_tag << "]" << log << '\n';
    std::string bf {ss.str()};

    fwrite(bf.c_str(), sizeof(char), bf.length(), fp);
    fflush(fp);
    #endif
}
