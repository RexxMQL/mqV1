//+------------------------------------------------------------------+
//| C_ZeroMQ_Connector – wrapper ZMQ PUB/SUB & PUSH/PULL             |
//+------------------------------------------------------------------+
#pragma once
#include <WinAPI\windows.h>

// ------>>>  IMPORT fungsi dasar libzmq  ---------------------------
#import "libzmq.dll"
   void*  zmq_ctx_new();
   void*  zmq_socket(void*, int);
   int    zmq_connect(void*, const char*);
   int    zmq_bind(void*, const char*);
   int    zmq_setsockopt(void*, int, const void*, size_t);
   int    zmq_send(void*, const void*, size_t, int);
   int    zmq_recv(void*,       void*, size_t, int);
   int    zmq_close(void*);
   int    zmq_ctx_term(void*);
#import
#define ZMQ_PUB   1
#define ZMQ_SUB   2
#define ZMQ_PUSH  8
#define ZMQ_PULL  7
#define ZMQ_SUBSCRIBE 6

class CZeroMQ_Connector
  {
  private:
     void *context, *sock_pub, *sock_pull;
     string pub_endpoint, pull_endpoint;
  public:
     void  Setup(string pubURL,string pullURL)
     {
        pub_endpoint  = pubURL;
        pull_endpoint = pullURL;
        context = zmq_ctx_new();

        sock_pub  = zmq_socket(context,ZMQ_PUB);
        zmq_setsockopt(sock_pub,ZMQ_SNDHWM,0,0);
        zmq_bind(sock_pub,pub_endpoint);

        sock_pull = zmq_socket(context,ZMQ_PULL);
        zmq_connect(sock_pull,pull_endpoint);
     }
     // --------------------------------------------------------------
     void PublishMarketData()
     {
        // kirim OHLC/indikator sederhana tiap bar terakhir
        MqlRates r[];
        if(CopyRates(_Symbol,PERIOD_CURRENT,0,1,r)<=0) return;

        string payload=StringFormat(
          "{\"symbol\":\"%s\",\"time\":%I64u,\"open\":%.2f,"
          "\"high\":%.2f,\"low\":%.2f,\"close\":%.2f,\"volume\":%d}",
          _Symbol,(long)r[0].time,r[0].open,r[0].high,
          r[0].low,r[0].close,(int)r[0].tick_volume
        );
        zmq_send(sock_pub,StringToCharArray(payload,CP_UTF8),StringLen(payload),0);
     }
     // --------------------------------------------------------------
     bool PullCommand(string &out)
     {
        uchar buf[256];
        int   n = zmq_recv(sock_pull,buf,256,1);   // non‑blocking
        if(n<=0) return false;
        ArrayResize(buf,n);  out = CharArrayToString(buf,0,n,CP_UTF8);
        return true;
     }
     // --------------------------------------------------------------
     void Close()
     {
        zmq_close(sock_pub);
        zmq_close(sock_pull);
        zmq_ctx_term(context);
     }
  };
