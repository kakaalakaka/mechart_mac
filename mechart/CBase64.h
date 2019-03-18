/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CBASE_H__
#define __CBASE_H__
#pragma once
#include "stdafx.h"
#include <string>
using namespace std;

namespace MeLibSock
{
	class CBase64
	{
	protected:
		CBase64();
	public:
		virtual ~CBase64();
		static string Encode(const unsigned char *Data,int DataByte);
		static string Decode(const char *Data,int DataByte,int& OutByte);
	};
}

#endif
