//
// RaspiKey Copyright (c) 2019 George Samartzidis <samartzidis@gmail.com>. All rights reserved.
// You are not allowed to redistribute, modify or sell any part of this file in either 
// compiled or non-compiled form without the author's written permission.
//

#pragma once

#include <cstdint>
#include <cstddef>
#include <memory.h>
#include <sys/syslog.h>
#include <string>
#include <memory>
#include <vector>
#include <linux/limits.h>
#include "json.hpp"

// Global definitions
//
#define EVENT_DEV_PATH "/dev/input/event0"
#define HIDRAW_DEV_PATH "/dev/hidraw0"
#define HIDG_DEV_PATH "/dev/hidg0"

#define LOG_FILE_PATH "/tmp/raspikey.log"
#define DATA_DIR "/data"
#define DATA_ARCHIVE "/boot/data.tar.bz2"
#define VERSION "1.2.5"
//
//

namespace Globals
{	
	// Types
	//
	enum HidCodes : uint8_t
	{
		HidKeyB = 0x5,
		HidKeyP = 0x13,
		HidKeyS = 0x16,
		HidF1 = 0x3a,
		HidF2 = 0x3b,
		HidF3 = 0x3c,
		HidF4 = 0x3d,
		HidF5 = 0x3e,
		HidF6 = 0x3f,
		HidF7 = 0x40,
		HidF8 = 0x41,
		HidF9 = 0x42,
		HidF10 = 0x43,
		HidF11 = 0x44,
		HidF12 = 0x45,
		HidF13 = 0x68,
		HidF14 = 0x69,
		HidF15 = 0x6a,
		HidF16 = 0x6b,
		HidF17 = 0x6c,
		HidF18 = 0x6d,
		HidF19 = 0x6e,
		HidF20 = 0x6f,
		HidF21 = 0x70,
		HidF22 = 0x71,
		HidF23 = 0x72,
		HidF24 = 0x73,
		HidDel = 0x4c,
		HidBackspace = 0x2a,
		HidLeft = 0x50,
		HidHome = 0x4a,
		HidRight = 0x4f,
		HidEnd = 0x4d,
		HidUp = 0x52,
		HidPgUp = 0x4b,
		HidDown = 0x51,
		HidPgDown = 0x4e,
		HidEnter = 0x28,
		HidPrtScr = 0x46,
		HidScrLck = 0x47,
		HidPauseBreak = 0x48,
		HidInsert = 0x49,
		HidLCtrlMask = 0x1,
		HidRCtrlMask = 0x10,
		HidLAltMask = 0x4,
		HidRAltMask = 0x40,
		HidLCmdMask = 0x8,
		HidRCmdMask = 0x80
	};

	typedef struct HidgOutputReport
	{
		uint8_t ReportId;
		uint8_t Key;
	} tagHidgOutputReport;


	// Global variables
	//	
	extern char g_szModuleDir[PATH_MAX];
	//
	//

	// Global Functions
	//
	std::string FormatBuffer(const uint8_t* const buf, size_t len);

	inline int IsZeroBuffer(uint8_t* buf, size_t size)
	{
		return buf[0] == 0 && !memcmp(buf, buf + 1, size - 1);
	}

	template<typename ... Args> std::string FormatString(const char* const format, Args ... args)
	{
		size_t size = snprintf(nullptr, 0, format, args ...) + 1; // Extra space for '\0'
		std::unique_ptr<char[]> buf(new char[size]);

		snprintf(buf.get(), size, format, args ...);
		std::string res = std::string(buf.get(), buf.get() + size - 1); // We don't want the '\0' inside

		return res;
	}

	std::vector<std::string> Split(const std::string& s, char seperator);
	std::string& Ltrim(std::string &s);
	std::string& Rtrim(std::string &s);
	std::string& Trim(std::string &s);

	bool GetBtHidBatteryCapacity(const std::string& btaddress, int& capacity);
	long GetUptime();
	bool SetPiLedState(bool state, const char* led = "0");
	bool FileReadAllText(const std::string& path, std::string& text);
	bool FileWriteAllText(const std::string& path, const std::string& text);
	bool DeleteFile(const std::string& path);
}

