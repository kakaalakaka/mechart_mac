/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CMATHLIBME_H__
#define __CMATHLIBME_H__
#pragma once
#include "stdafx.h"

namespace MeLib
{
	struct LPDATA
	{
	public:
		LPDATA()
		{
		};
		double lastvalue;
		double first_value;
		int mode;
		double sum;
	};
    
    class CMathLibMe
    {
    public:
        static void M001(int index, int n, double s, double m, double high, double low, double hhv, double llv, int last_state, double last_sar, double last_af, int *state, double *af, double *sar);
        static double M002(double value, double *listForAvedev, int listForAvedev_length, double avg);
        static double M003(int index, int n, double value, struct LPDATA last_MA);
        static double M004(int index, int n, double value, struct LPDATA last_SUM);
        static double M005(int n, int weight, double value, double lastWMA);
        static double M006(int n, double value, double lastEMA);
        static double M007(double *list, int length, double avg,  double standardDeviation);
        static double GetMin(double *list, int length);
        static double GetMax(double *list, int length);
        static double M010(double *list, int length);
        static double M011(double *list, int length);
        static int M012(double min, double max, int yLen, int maxSpan, int minSpan, int defCount, double *step, int *digit);
        static void M013(int index, double close, double p, double *sxp, int *sxi, double *exp, int *exi, int *state, int *cStart, int *cEnd, double *k, double *b);
        static void M014(double *list, int length, float *k, float *b);
        static double M015(double close, double lastSma, int n, int m);
        static double M016(double close, double open);
        static double M017(double close);
        static double M018(double close, double high, double low);
        static double M019(double volume);
        static double M020(double* list, int length);
        static double M021(double* list, int length);
        static double M022(double* list, int length);
        static double M023(double* list, int length);
        static double M024(double* list, int length);
        static double M025(double* list, int length);
        static double M026(double* list, int length);
        static double M027(double* list, int length);
        static double M028(int x, int y, double k, double b);
        static double M029(double close, int m);
        static double M030(double close, int m, int n);
        static double M031(double high, double low);
        static double M032(double close, double volume);
        static double M033(double up, double down);
        static double M034(double ma);
        static double M035(double ema);
        static double M036(double tma);
        static double M037(double ama);
        static double M038(double sma);
        static double M039(double sd);
        static double M040(int x1, int y1, int x2, int y2);
        static double M041(int x1, int y1, int x2, int y2, int x3, int y3);
        static double M042(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4);
        static double M043(int index);
        static double M044(int index);
        static double M045(double* list1, int length1, double* list2, int length2);
        static double M046(double* list1, int length1, double* list2, int length2);
        static double M047(double* list1, int length1, double* list2, int length2);
        static double M048(double* list1, int length1, double* list2, int length2);
        static double M049(double* list1, int length1, double* list2, int length2);
        static double M050(double* list1, int length1, double* list2, int length2);
        static double M051(double* list1, int length1, double* list2, int length2);
        static double M052(double* list1, int length1, double* list2, int length2);
        static double M053(double* list1, int length1, double* list2, int length2);
        static double M054(int x, int y, double k, double b);
        static double M055(int x, int y, double k, double b);
        static double M056(int x, int y, double k, double b);
        static double M057(double close);
        static double M058(double close);
        static double M059(double close);
        static double M060(double close);
        static double M061(double close);
        static double M062(double close);
        static double M063(double close, double open);
        static double M064(double close, double open);
        static double M065(double close, double open);
        static double M066(double close, double open);
        static double M067(double close, double open);
        static double M068(double close, double open);
        static double M069(double close, double open);
        static double M070(double close, double open);
        static double M071(double close, double open);
        static double M072(double up, double down);
        static double M073(double up, double down);
        static double M074(double up, double down);
        static double M075(double up, double down);
        static double M076(double up, double down);
        static double M077(double up, double down);
        static double M078(double up, double down);
        static double M079(int x1, int y1, int x2, int y2);
        static double M080(int x1, int y1, int x2, int y2);
        static double M081(int x1, int y1, int x2, int y2);
        static double M082(int x1, int y1, int x2, int y2);
        static double M083(int x, int y, double k, double b);
        static double M084(int x, int y, double k, double b);
        static double M085(int x, int y, double k, double b);
        static double M086(double close, double high, double low, double open);
        static double M087(double close, double high, double low, double open);
        static double M088(double close, double high, double low, double open);
        static double M089(double close, double high, double low, double open);
        static double M090(double close, double high, double low, double open);
        static double M091(float x1, float y1, float x2, float y2, float oX, float oY);
        static double M092(double close, double high, double low, double open);
        static double M093(int n, int weight, double value, double lastWMA);
        static double M094(int n, int weight, double value, double lastWMA);
        static double M095(int n, int weight, double value, double lastWMA);
        static double M096(int n, double value, double lastEMA);
        static double M097(int n, double value, double lastEMA);
        static double M098(int n, double value, double lastEMA);
        static double M099(int index, int n, double value);
        static double M100(int index, int n, double value);
        static double M101(int index, int n, double value);
        static double M102(int index, int n, double value);
        static double M103(int n, int weight, double value, double lastWMA);
        static double M104(int n, int weight, double value, double lastWMA);
        static void M105(int x1, int y1, int x2, int y2, int *x, int *y, int *w, int *h);
        static double M106(float x1,  float y1,  float x2,  float y2,  float oX,  float oY);
        static void M107(float x1,  float y1,  float x2,  float y2,  float oX,  float oY,  float *k,  float *b);
        static void M108(float width,  float height,  float *a,  float *b);
        static bool M109(float x, float y, float oX, float oY, float a, float b);
        static void M110(float x1, float y1, float x2, float y2, float x3, float y3, float *oX, float *oY, float *r);
        static double M111();
        static int M112(int index);
        static double M114(int index);
        static double M115(int index);
        static double M116(int index);
        static double M117(int index);
        static double M119(int x);
        static double M120(int y);
        static double M121(int x, int y);
        static double M122(int x, int y, int width);
        static double M123(int slope);
        static void M124(float x1, float y1, float x2, float y2, float x3, float y3, float *x4, float *y4);
        static double M125(float x1, float y1, float x2, float y2);
        static double M126(int tm_hour, int tm_min, int tm_sec);
        static double M127(int tm_year, int tm_mon, int tm_mday);
        static double M128(double num);
        static double M129(int tm_year, int tm_mon, int tm_mday, int tm_hour, int tm_min, int tm_sec, int tm_msec);
        static void M130(double num, int *tm_year, int *tm_mon, int *tm_mday, int *tm_hour, int *tm_min, int *tm_sec, int *tm_msec);
        static int M131();
        static void M132(RECT *bounds, SIZE *parentSize, SIZE *oldSize, bool anchorLeft, bool anchorTop, bool anchorRight, bool anchorBottom);
        static void M133(RECT *bounds, RECT *spaceRect, SIZE *cSize, int dock);
        static void M135(int layoutStyle, RECT *bounds, PADDING *padding,
                                                  PADDING *margin, int left, int top, int width, int height,
                                                  int tw, int th, POINT *headerLocation);
        static bool M136(RECT *bounds, int rowHeight, int scrollV, double visiblePercent, int cell, int floor);
        static void M137(int resizePoint, int *left, int *top, int *right, int *bottom, POINT *nowPoint, POINT *startMousePoint);
        static bool IsLineVisible(int indexTop, int indexBottom, int cell, int floor, int lineHeight, double visiblePercent);
    };
}
#endif
