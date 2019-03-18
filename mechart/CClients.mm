
#include "stdafx.h"
#include "CClients.h"
#include "CClient.h"

namespace MeLibSock
{
    map<int, CClientMe*> m_clients;
    
    RecvMsg m_recvServerMsgCallBack = 0;
    
    WriteClientLog m_writeClientLogCallBack = 0;
    
    void CClientsMe::RecvServerMsg(int socketID, int localSID, const char *str, int len)
    {
        if(m_recvServerMsgCallBack)
        {
            m_recvServerMsgCallBack(socketID, localSID, str, len);
        }
    }
    
    void CClientsMe::WriteLog(int socketID, int localSID, int state, const char *log)
    {
        if(m_writeClientLogCallBack)
        {
            m_writeClientLogCallBack(socketID, localSID, state, log);
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    int CClientsMe::Close(int socketID)
    {
        map<int, CClientMe*>::iterator sIter = m_clients.find(socketID);
        if(sIter != m_clients.end())
        {
            CClientMe *client = sIter->second;
            int ret = client->Close(socketID);
            m_clients.erase(sIter);
            client = 0;
            return ret;
        }
        return -1;
    }
    
    int CClientsMe::Connect(int type, int proxyType, const char *ip, int port, const char *proxyIp, int proxyPort, const char *proxyUserName, const char *proxyUserPwd, const char *proxyDomain, int timeout)
    {
        CClientMe *client = new CClientMe(0,(long)proxyType, ip, port, proxyIp,proxyPort, proxyUserName, proxyUserPwd, proxyDomain, timeout);
        
        
//        CClientMe::CClientMe(long proxyType, string ip, u_short port, string proxyIp,
//                       u_short proxyPort, string proxyUserName, string proxyUserPwd,
//                       string proxyDomain, int timeout)
        ConnectStatus ret = client->Connect();
        if(ret != STATUS_CONNECT_SERVER_FAIL)
        {
            int socketID = (int)client->m_hSocket;
            m_clients[socketID] = client;
            client->m_writeLogEvent = WriteLog;
            client->m_recvEvent = RecvServerMsg;
            return socketID;
        }
        else
        {
            delete client;
            client = 0;
            return -1;
        }
    }
    
    void CClientsMe::RegisterLog(WriteClientLog writeLogCallBack)
    {
        m_writeClientLogCallBack = writeLogCallBack;
    }
    
    void CClientsMe::RegisterRecv(RecvMsg recvMsgCallBack)
    {
        m_recvServerMsgCallBack = recvMsgCallBack;
    }
    
    int CClientsMe::Send(int socketID, const char *str, int len)
    {
        return CClientMe::Send(socketID, str, len);
    }
}

