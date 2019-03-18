/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CWINDOWME_H__
#define __CWINDOWME_H__
#pragma once
#include "stdafx.h"
#include "CButton.h"
#include "CWindowFrame.h"

namespace MeLib
{
	class CWindowFrameMe;
    
	typedef void (*WindowClosingEvent)(void*, bool*, void*);
    
	class CWindowMe : public CControlMe
	{
	protected:
		int m_borderWidth;
		bool m_canResize;
		int m_captionHeight;
		CWindowFrameMe *m_frame;
		bool m_isDialog;
		int m_resizePoint;
		_int64 m_shadowColor;
		int m_shadowSize;
		POINT m_startMousePoint;
		RECT m_startRect;
	protected:
		void CallWindowClosingEvents(int eventID, bool *cancel);
        CursorsA GetResizeCursor(int state);
		vector<RECT> GetResizePoints();
		int GetResizeState();
	public:
		CWindowMe();
		virtual ~CWindowMe();
		virtual int GetBorderWidth();
		virtual void SetBorderWidth(int borderWidth);
		virtual int GetCaptionHeight();
		virtual void SetCaptionHeight(int captionHeight);
		virtual bool CanResize();
		virtual void SetCanResize(bool canResize);
		virtual CWindowFrameMe* GetFrame();
		virtual void SetFrame(CWindowFrameMe *frame);
		virtual bool IsDialog();
		virtual _int64 GetShadowColor();
		virtual void SetShadowColor(_int64 shadowColor);
		virtual int GetShadowSize();
		virtual void SetShadowSize(int shadowSize);
	public:
		virtual void BringToFront();
		virtual void Close();
		virtual String GetControlType();
		RECT GetDynamicPaintRect();
        virtual vector<String> GetEventNames();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual bool OnDragBegin();
		virtual void OnDragReady(POINT *startOffset);
		virtual void OnMouseDown(POINT mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseMove(POINT mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseUp(POINT mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
		virtual void OnVisibleChanged();
		virtual void OnWindowClosing(bool *cancel);
		virtual void OnWindowClosed();
		virtual void SendToBack();
		virtual void SetProperty(const String& name, const String& value);
		virtual void ShowDialog();
	};
}
#endif
