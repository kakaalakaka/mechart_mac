/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __DIVME_H__
#define __DIVME_H__
#pragma once
#include "stdafx.h"
#include "CControl.h"
#include "CScrollBar.h"
#include "CHScrollBar.h"
#include "CVScrollBar.h"
#import <mach/mach_time.h>

namespace MeLib
{
    class CHScrollBarMe;
    class CVScrollBarMe;
    
    class DivMe : public CControlMe
    {
    protected:
        bool m_allowDragScroll;
        CHScrollBarMe *m_hScrollBar;
        bool m_isDragScrolling;
        bool m_isDragScrolling2;
        bool m_readyToDragScroll;
        ControlKeyEvent m_scrollButtonKeyDownEvent;
        ControlMouseEvent m_scrollButtonMouseWheelEvent;
        bool m_showHScrollBar;
        bool m_showVScrollBar;
        POINT m_startMovePoint;
        int m_startMovePosX;
        int m_startMovePosY;
        uint64_t m_startMoveTime;
        CVScrollBarMe *m_vScrollBar;
        ControlEvent m_vScrollBarScrolledEvent;
        static void ScrollButtonKeyDown(void *sender, char key, void *pInvoke);
        static void ScrollButtonMouseWheel(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
    public:
        DivMe();
        virtual ~DivMe();
        virtual bool AllowDragScroll();
        virtual void SetAllowDragScroll(bool allowDragScroll);
        CHScrollBarMe* GetHScrollBar();
        virtual bool ShowHScrollBar();
        virtual void SetShowHScrollBar(bool showHScrollBar);
        virtual bool IsDragScrolling();
        virtual bool ShowVScrollBar();
        virtual void SetShowVScrollBar(bool showVScrollBar);
        virtual CVScrollBarMe* GetVScrollBar();
    public:
        virtual int GetContentHeight();
        virtual int GetContentWidth();
        virtual String GetControlType();
        virtual POINT GetDisplayOffset();
        virtual void GetProperty(const String& name, String *value, String *type);
        virtual vector<String> GetPropertyNames();
        virtual void LineDown();
        virtual void LineLeft();
        virtual void LineRight();
        virtual void LineUp();
        virtual void OnDragReady(POINT *startOffset);
        virtual void OnDragScrollEnd();
        virtual void OnDragScrolling();
        virtual bool OnDragScrollPermit();
        virtual void OnDragScrollStart();
        virtual void OnKeyDown(char key);
        virtual void OnMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnMouseMove(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnMouseWheel(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual bool OnPreviewsMouseEvent(int eventID, const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void PageDown();
        virtual void PageLeft();
        virtual void PageRight();
        virtual void PageUp();
        virtual void SetProperty(const String& name, const String& value);
        virtual void Update();
        virtual void UpdateScrollBar();
    };
}

#endif
