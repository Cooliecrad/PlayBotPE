#include "ps_format.h"

// #define _DEBUG

enum FLoggerLevel
{
    FLoggerDebug,
    FLoggerInfo,
    FLoggerWarn,
    FLoggerError,
};

class FileLogger
{
public:
    FileLogger(const char *filename, const char *log_tag,
               bool need_refresh = false);

    void print(const char *tag, const char *log);
    void print(const char *tag, const std::string& log) {print(tag, log.c_str());}

    template<typename ... Args>
    void print(const char *tag, const char *format,
               const Args& ... args)
    {
        #ifdef _DEBUG
        std::string str {format_string(format, args ...)};
        print(tag, str.c_str());
        #endif
    }

    void debug(const char* log) {print("Debug", log);}
    void debug(const std::string& log) {print("Debug", log);}
    template<typename ... Args>
    void debug(const  char* format, const Args& ... args)
    {
        print("Debug", format, args ...);
    }

    void info(const char* log) {print("Info", log);}
    void info(const std::string log) {print("Info", log);}
    template<typename ... Args>
    void info(const  char* format, const Args& ... args)
    {
        print("Info", format, args ...);
    }


    void warn(const char* log) {print("Warn", log);}
    void warn(const std::string& log) {print("Warn", log);}
    template<typename ... Args>
    void warn(const  char* format, const Args& ... args)
    {
        print("Warn", format, args ...);
    }

    void error(const char* log) {print("Error", log);}
    void error(const std::string& log) {print("Error", log);}
    template<typename ... Args>
    void error(const  char* format, const Args& ... args)
    {
        print("Error", format, args ...);
    }

    ~FileLogger() {fclose(fp);}
private:
    FILE *fp;
    const char *log_tag;
};