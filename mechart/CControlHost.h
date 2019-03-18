/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CCONTROLHOSTME_H__
#define __CCONTROLHOSTME_H__
#pragma once
#include "stdafx.h"
#include "CControl.h"
#include "CPaint.h"
#include "CNativeBase.h"

namespace MeLib
{
	class CControlMe;
	class CNativeBaseMe;
    
	class CControlHostMe
	{
	public:
		CControlHostMe();
		virtual ~CControlHostMe();
		virtual CNativeBaseMe* GetNative();
		virtual void SetNative(CNativeBaseMe *native);
	public:
		virtual void ActiveMirror();
		virtual bool AllowOperate();
		virtual bool AllowPartialPaint();
		virtual void BeginInvoke(CControlMe *control, void *args);
		virtual void Copy(string text);
		virtual CControlMe* CreateInternalControl(CControlMe *parent, const String& clsid);
        virtual CursorsA GetCursor();
		virtual int GetIntersectRect(RECT *lpDestRect, const RECT *lpSrc1Rect, const RECT *lpSrc2Rect);
        virtual POINT GetMousePoint();
        virtual SIZE GetSize();
		virtual int GetUnionRect(RECT *lpDestRect, const RECT *lpSrc1Rect, const RECT *lpSrc2Rect);
		virtual void Invalidate();
        virtual void Invalidate(const RECT& rect);
		virtual void Invoke(CControlMe *control, void *args);
        virtual bool IsKeyPress(char key);
		virtual string Paste();
		virtual void SetAllowOperate(bool allowOperate);
		virtual void SetAllowPartialPaint(bool allowPartialPaint);
        virtual void SetCursor(CursorsA cursor);
		virtual void ShowToolTip(const String& text, const POINT& mp);
        virtual void StartTimer(int timerID, int interval);
        virtual void StopTimer(int timerID);
	};
}
#endif
