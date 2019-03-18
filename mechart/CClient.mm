#include "stdafx.h"
#include "CClient.h"


namespace MeLibSock
{
    void* RecvClient(void *lpParam)
    {
        CClientMe *client = (CClientMe*)lpParam;
        if(!client) return 0;
        int socket = client->m_hSocket;
        if(socket == -1)
        {
            client = 0;
            return 0;
        }
        char *str = 0;
        bool get = false;
        int head = 0, pos = 0, strRemain = 0, bufferRemain = 0, index = 0, len = 0;
        int intSize = sizeof(int);
        int socketID = (int)socket;
        char headStr[4];
        memset(headStr, '\0', 4);
        int headSize = 4;
        while(1)
        {
            char buffer[1024];
            memset(buffer, '\0', 1024);
            len = recv(socket, buffer, 1024, 0);
            if(len == 0 || len == -1)
            {
                if(client->m_recvEvent)
                {
                    char rmsg[1] = {(char)3};
                    client->m_recvEvent(socketID, socketID, rmsg, 1);
                }
                client->WriteLog(socketID, socketID, OWSOCK_LOGT_SOCKETERROR, "socket error");
                break;
            }
            index = 0;
            while(index < len)
            {
                int diffSize = 0;
                if(!get)
                {
                    diffSize = intSize - headSize;
                    if(diffSize == 0)
                    {
                        memcpy(&head, buffer + index, intSize);
                    }
                    else
                    {
                        for(int i = 0; i < diffSize; i++)
                        {
                            headStr[headSize + i] = buffer[i];
                        }
                        memcpy(&head, headStr, intSize);
                    }
                    if(str)
                    {
                        delete[] str;
                        str = 0;
                    }
                    str = new char[head];
                    memset(str, '\0', head);
                    if(diffSize > 0)
                    {
                        for(int i = 0; i < headSize; i++)
                        {
                            str[i] = headStr[i];
                        }
                        pos += headSize;
                        headSize = intSize;
                    }
                }
                bufferRemain = len - index;
                strRemain = head - pos;
                get = strRemain > bufferRemain;
                int remain = min(strRemain, bufferRemain);
                for(int i = 0; i < remain; i++)
                {
                    str[i + pos] = buffer[i + index];
                }
                pos += remain;
                index += remain;
                if(!get)
                {
                    if(client->m_recvEvent)
                    {
                        client->m_recvEvent(socketID, socketID, str, head);
                    }
                    head = 0;
                    pos = 0;
                    if(len - index == 0 || len - index >= intSize)
                    {
                        headSize = intSize;
                    }
                    else
                    {
                        headSize = bufferRemain - strRemain;
                        memcpy(headStr, buffer + index, headSize);
                        break;
                    }
                }
            }
        }
        close(socket);
        if(client->m_recvEvent)
        {
            char rmsg[1] = {(char)2};
            client->m_recvEvent(socketID, socketID, rmsg, 1);
        }
        client->WriteLog(socketID, socketID, OWSOCK_LOGT_SOCKETEXIT, "socket exit");
        client = 0;
        return 0;
    }
    
    /////////////////
    
    ConnectStatus CClientMe::ConnectStandard()
    {
        if(false)
        {
            for (res = res0; res; res = res->ai_next)
            {
                char ipv6_str_buf[INET6_ADDRSTRLEN] = { 0 };
                struct sockaddr_in6 *v6sa = (struct sockaddr_in6 *)res->ai_addr;
                v6sa->sin6_port = htons(m_port);
                inet_ntop(AF_INET6, &(v6sa->sin6_addr),
                          ipv6_str_buf, sizeof(ipv6_str_buf));
                int ret = connect(m_hSocket, res->ai_addr, res->ai_addrlen);
                if(ret >= 0)
                {
                    return STATUS_SUCCESS;
                }
                else
                {
                    return STATUS_CONNECT_SERVER_FAIL;
                }
            }
            return STATUS_CONNECT_SERVER_FAIL;
        }
        else
        {
            for (res = res0; res; res = res->ai_next)
            {
                char ipv4_str_buf[INET_ADDRSTRLEN] = { 0 };
                struct sockaddr_in *v4sa = (struct sockaddr_in *)res->ai_addr;
                v4sa->sin_port = htons(m_port);
                inet_ntop(AF_INET, &(v4sa->sin_addr),
                          ipv4_str_buf, sizeof(ipv4_str_buf));
                int ret = connect(m_hSocket, res->ai_addr, res->ai_addrlen);
                if(ret >= 0)
                {
                    return STATUS_SUCCESS;
                }
                else
                {
                    return STATUS_CONNECT_SERVER_FAIL;
                }
            }
            return STATUS_CONNECT_SERVER_FAIL;
            
        }
    }
    
    ConnectStatus CClientMe::ConnectByHttp()
    {
        char buf[512];
        if (m_proxyUserName != "")
        {
            string str;
            string strBase64;
            str = m_proxyUserName + ":" + m_proxyUserPwd;
        }
        else
        {
            sprintf(buf, "CONNECT %s:%d HTTP/1.1\r\nUser-Agent: MyApp/0.1\r\n\r\n", m_ip.c_str(), m_port);
        }
        send(m_hSocket, buf, (int)strlen(buf), 0);
        recv(m_hSocket, buf, sizeof(buf), 0);
        if (strstr(buf, "HTTP/1.0 200 Connection established") != 0)
        {
            return STATUS_SUCCESS;
        }
        else
        {
            return STATUS_CONNECT_SERVER_FAIL;
        }
    }
    
    ConnectStatus CClientMe::ConnectBySock4()
    {
        char buf[512];
        memset(buf, '\0', sizeof(buf));
        struct TSock4req1 *proxyreq;
        proxyreq = (struct TSock4req1*)buf;
        proxyreq->VN = 4;
        proxyreq->CD = 1;
        proxyreq->Port = ntohs(m_port);
        proxyreq->IPAddr = inet_addr(m_ip.c_str());
        send(m_hSocket, buf, 9, 0);
        struct TSock4ans1 *proxyans;
        proxyans = (struct TSock4ans1*)buf;
        memset(buf, '\0', sizeof(buf));
        recv(m_hSocket, buf, sizeof(buf), 0);
        if(proxyans->VN == 0 && proxyans->CD == 90)
        {
            return STATUS_SUCCESS;
        }
        else
        {
            return STATUS_CONNECT_SERVER_FAIL;
        }
    }
    
    ConnectStatus CClientMe::ConnectBySock5()
    {
        char buf[512];
        struct TSock5req1 *proxyreq1;
        proxyreq1 = (struct TSock5req1 *)buf;
        proxyreq1->Ver = 5;
        proxyreq1->nMethods = 1;
        proxyreq1->Methods = m_proxyUserName != "" ? 2 : 0;
        send(m_hSocket, buf, 3, 0);
        struct TSock5ans1 *proxyans1;
        proxyans1 = (struct TSock5ans1 *)buf;
        memset(buf, '\0', sizeof(buf));
        recv(m_hSocket, buf, sizeof(buf), 0);
        if(proxyans1->Ver != 5 || (proxyans1->Method != 0 && proxyans1->Method != 2))
        {
            return STATUS_CONNECT_SERVER_FAIL;
        }
        if(proxyans1->Method == 2)
        {
            int nUserLen = (int)m_proxyUserName.length();
            int nPassLen = (int)m_proxyUserPwd.length();
            buf[0] = 1;
            buf[1] = nUserLen;
            memcpy(buf + 2, m_proxyUserName.c_str(), nUserLen);
            buf[2 + nUserLen] = nPassLen;
            memcpy(buf + 3 + nUserLen, m_proxyUserPwd.c_str(), nPassLen);
            send(m_hSocket, buf, 3 + nUserLen + nPassLen, 0);
            struct TAuthans *authans;
            authans = (struct TAuthans *)buf;
            memset(buf, '\0', sizeof(buf));
            recv(m_hSocket, buf, sizeof(buf), 0);
            if(authans->Ver != 1 || authans->Status != 0)
            {
                return STATUS_CONNECT_SERVER_FAIL;
            }
        }
        memset(buf, '\0', sizeof(buf));
        struct TSock5req2 *proxyreq2;
        proxyreq2 = (struct TSock5req2 *)buf;
        proxyreq2->Ver = 5;
        proxyreq2->Cmd = 1;
        proxyreq2->Rsv = 0;
        proxyreq2->Atyp = 1;
        unsigned long tmpLong = inet_addr(m_ip.c_str());
        unsigned short port1 = ntohs(m_port);
        memcpy((char*)&proxyreq2->other, &tmpLong, 4);
        memcpy((char*)(&proxyreq2->other) + 4, &port1, 2);
        send(m_hSocket, buf, 10, 0);
        struct TSock5ans2 *proxyans2;
        memset(buf ,'\0', sizeof(buf));
        proxyans2 = (struct TSock5ans2 *)buf;
        recv(m_hSocket, buf, sizeof(buf), 0);
        if(proxyans2->Ver != 5 || proxyans2->Rep != 0)
        {
            return STATUS_CONNECT_SERVER_FAIL;
        }
        return STATUS_SUCCESS;
    }
    
    void CClientMe::CreateSocket()
    {
        if(m_hSocket)
        {
            close(m_hSocket);
            m_hSocket = 0;
        }
        if(!m_hSocket)
        {
            for (res = res0; res; res = res->ai_next)
            {
                m_hSocket = socket(res->ai_family,
                                   res->ai_socktype,
                                   res->ai_protocol);
                break;
            }
        }
    }
    
    ///////////////////////////////////////////////////////////
    
    string formatIPV4Address(struct in_addr ipv4Addr)
    {
        string address = "";
        
        char dstStr[INET_ADDRSTRLEN];
        char srcStr[INET_ADDRSTRLEN];
        memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
        if (inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL)
        {
            address = dstStr;
        }
        
        return address;
    }
    
    string formatIPV6Address(struct in6_addr ipv6Addr)
    {
        string address = "";
        char dstStr[INET6_ADDRSTRLEN];
        char srcStr[INET6_ADDRSTRLEN];
        memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
        if(inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL)
        {
            //        address = [NSString stringWithUTF8String:dstStr];
            address = dstStr;
        }
        
        return address;
    }
    
  
    
    CClientMe::CClientMe(int type, long proxyType, string ip, u_short port, string proxyIp,
                   u_short proxyPort, string proxyUserName, string proxyUserPwd,
                   string proxyDomain, int timeout)
    {
        m_blnProxyServerOk = true;
        m_proxyDomain = proxyDomain;
        m_proxyType = proxyType;
        m_hSocket = 0;
        m_ip = GetHostIP(ip.c_str());
        memset(&hints, 0, sizeof(hints));
        hints.ai_family = PF_UNSPEC;
        hints.ai_socktype = SOCK_STREAM;
        hints.ai_flags = AI_ALL;//AI_DEFAULT;//TODO
        getaddrinfo(m_ip.c_str(), NULL, &hints, &res0);
        m_port = port;
        m_proxyIp = proxyIp;
        m_proxyPort = proxyPort;
        m_proxyUserName = proxyUserName;
        m_proxyUserPwd = proxyUserPwd;
        m_recvEvent = 0;
        m_timeout = timeout;
        m_writeLogEvent = 0;
    }
    
    CClientMe::~CClientMe()
    {
        m_recvEvent = 0;
        m_writeLogEvent = 0;
    }
    
    int CClientMe::Close(int socketID)
    {
        int ret = 0;
        if(socketID != -1)
        {
            ret = close(socketID);
            if(m_recvEvent)
            {
                char rmsg[1] = {(char)2};
                m_recvEvent(socketID, socketID, rmsg, 1);
            }
            WriteLog(socketID, socketID, OWSOCK_LOGT_SOCKETEXIT, "socket exit");
        }
        return ret;
    }
    
    ConnectStatus CClientMe::Connect()
    {
        CreateSocket();
        if(m_proxyType > 0)
        {
            ConnectProxyServer();
        }
        if (!m_blnProxyServerOk)
        {
            return STATUS_NOT_CONNECT_PROXY;
        }
        ConnectStatus status = STATUS_CONNECT_SERVER_FAIL;
        if(m_proxyType == 0)
        {
            status = ConnectStandard();
        }
        else
        {
            int nTimeout = 5000;
            setsockopt(m_hSocket, SOL_SOCKET, SO_RCVTIMEO, (char *)&nTimeout, sizeof(int));
            fcntl(m_hSocket, F_SETFL, O_NONBLOCK);
            switch(m_proxyType)
            {
                case 1:
                    status = ConnectByHttp();
                    break;
                case 2:
                    status = ConnectBySock4();
                    break;
                case 3:
                    status = ConnectBySock5();
                    break;
            }
        }
        if(status == STATUS_SUCCESS)
        {
            pthread_t recvThread;
            pthread_create(&recvThread, 0, RecvClient, this);
            char submitStr[1024];
            memset(submitStr, '\0', 1024);
            submitStr[0] = 'm';
            submitStr[1] = 'i';
            submitStr[2] = 'a';
            submitStr[3] = 'o';
            Send(m_hSocket, submitStr, 1024);
        }
        return status;
    }
    
    ConnectStatus CClientMe::ConnectProxyServer()
    {
        return STATUS_CONNECT_PROXY_FAIL;
    }
    
    string CClientMe::GetHostIP(const char* ip)
    {
        char szIP[1024] = {0};
        //char *ptr, **pptr;
        struct hostent *hptr;
        //char str[32];
        hptr = gethostbyname(ip);
        if(hptr)
        {
            switch(hptr->h_addrtype)
            {
                case AF_INET:
                case AF_INET6:
                {
                    sprintf(szIP, "%d.%d.%d.%d", hptr->h_addr_list[0][0]&0x00ff,
                            hptr->h_addr_list[0][1]&0x00ff,
                            hptr->h_addr_list[0][2]&0x00ff,
                            hptr->h_addr_list[0][3]&0x00ff);
                }
                    break;
                default:
                    printf("unknown address type\n");
                    break;
            }
            return szIP;
        }
        return ip;
    }
    
    int CClientMe::Send(int socketID, const  char *str, int len)
    {
        return send(socketID, str, len, 0x8000);
    }
    
    void CClientMe::WriteLog(int socketID, int localSID, int state, const char *log)
    {
        if(m_writeLogEvent)
        {
            m_writeLogEvent(socketID, localSID, state, log);
        }
    }
}

