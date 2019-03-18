/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CLIENT_H__
#define __CLIENT_H__
#pragma once
#include "stdafx.h"
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include<fcntl.h>
#include "CBase64.h"
#include "CClients.h"
using namespace std;

#define OWSOCK_LOGT_SOCKETACCEPT 1
#define OWSOCK_LOGT_SOCKETEXIT 2
#define OWSOCK_LOGT_SOCKETERROR 3

namespace MeLibSock
{
	enum ConnectStatus
	{
		STATUS_SUCCESS,
		STATUS_CONNECT_PROXY_FAIL,
		STATUS_NOT_CONNECT_PROXY,
		STATUS_CONNECT_SERVER_FAIL
	};
    
    struct TSock4req1
	{
		char VN;
		char CD;
		unsigned short Port;
		unsigned long IPAddr;
		char other;
	};
    
	struct TSock4ans1
	{
		char VN;
		char CD;
	};
    
	struct TSock5req1
	{
		char Ver;
		char nMethods;
		char Methods;
	};
    
	struct TSock5ans1
	{
		char Ver;
		char Method;
	};
    
	struct TSock5req2
	{
		char Ver;
		char Cmd;
		char Rsv;
		char Atyp;
		char other;
	};
    
	struct TSock5ans2
	{
		char Ver;
		char Rep;
		char Rsv;
		char Atyp;
		char other;
	};
    
	struct TAuthreq
	{
		char Ver;
		char Ulen;
		char Name;
		char PLen;
		char Pass;
	};
    
	struct TAuthans
	{
		char Ver;
		char Status;
	};
    
	class CClientMe
	{
	protected:
		bool m_blnProxyServerOk;
        struct addrinfo hints;
        struct addrinfo *res;
        struct addrinfo *res0;
		string m_ip;
		u_short m_port;
		string m_proxyDomain;
		long m_proxyType;
		string m_proxyIp;
		u_short m_proxyPort;
		string m_proxyUserName;
		string m_proxyUserPwd;
        int m_timeout;
    protected:
		ConnectStatus ConnectStandard();
        ConnectStatus ConnectByHttp();
		ConnectStatus ConnectBySock4();
		ConnectStatus ConnectBySock5();
		void CreateSocket();
	public:
        struct sockaddr_in m_addr;
		int m_hSocket;
		RecvMsg m_recvEvent;
        int m_type;
		WriteClientLog m_writeLogEvent;
	public:
		CClientMe(int type, long proxyType, string ip, u_short port, string proxyIp, u_short proxyPort, string proxyUserName, string proxyUserPwd, string proxyDomain, int timeout);
		virtual ~CClientMe();
    public:
		int Close(int socketID);
		ConnectStatus Connect();
		ConnectStatus ConnectProxyServer();
        static string GetHostIP(const char* ip);
		static int Send(int socketID, const char *str, int len);
        int SendTo(const char *str, int len);
		void WriteLog(int socketID, int localSID, int state, const char *log);
	};
}

#endif
