/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CCLIENTSME_H__
#define __CCLIENTSME_H__
#pragma once
#include "stdafx.h"

using namespace std;


namespace MeLibSock
{
	typedef void (*RecvMsg)(int socketID, int localSID, const char *str, int len);
    
	typedef void (*WriteClientLog)(int socketID, int localSID, int state, const char *log);
    
	class CClientsMe
	{
	public:
		static void RecvServerMsg(int socketID, int localSID, const char *str, int len);
		static void WriteLog(int socketID, int localSID, int state, const char *log);
	public:
		static int Close(int socketID);
		static int Connect(int type, int proxyType, const char *ip, int port, const char *proxyIp, int proxyPort, const char *proxyUserName, const char *proxyUserPwd, const char *proxyDomain, int timeout);
		static void RegisterLog(WriteClientLog writeLogCallBack);
		static void RegisterRecv(RecvMsg recvMsgCallBack);
		static int Send(int socketID, const char *str, int len);
        static int SendTo(int socketID, const char *str, int len);
	};
}

#endif
