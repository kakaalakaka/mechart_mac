/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CSCROLLBARME_H__
#define __CSCROLLBARME_H__
#pragma once
#include "stdafx.h"
#include "CButton.h"
#import <mach/mach_time.h>

namespace MeLib
{
    class CScrollBarMe:public CControlMe
    {
    private:
        int m_tick;
        int m_timerID;
    protected:
        CButtonMe *m_addButton;
        int m_addSpeed;
        CButtonMe *m_backButton;
        int m_contentSize;
        bool m_isAdding;
        bool m_isReducing;
        int m_lineSize;
        int m_pageSize;
        int m_pos;
        CButtonMe *m_reduceButton;
        CButtonMe *m_scrollButton;
    protected:
        ControlMouseEvent m_addButtonMouseDownEvent;
        ControlMouseEvent m_addButtonMouseUpEvent;
        ControlMouseEvent m_reduceButtonMouseDownEvent;
        ControlMouseEvent m_reduceButtonMouseUpEvent;
        ControlEvent m_scrollButtonDraggingEvent;
        static void AddButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void AddButtonMouseUp(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void ReduceButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void ReduceButtonMouseUp(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void ScrollButtonDragging(void *sender, void *pInvoke);
    public:
        CScrollBarMe();
        virtual ~CScrollBarMe();
        virtual CButtonMe* GetAddButton();
        virtual int GetAddSpeed();
        virtual void SetAddSpeed(int addSpeed);
        virtual CButtonMe* GetBackButton();
        virtual int GetContentSize();
        virtual void SetContentSize(int contentWidth);
        virtual bool IsAdding();
        virtual void SetIsAdding(bool isAdding);
        virtual bool IsReducing();
        virtual void SetIsReducing(bool isReducing);
        virtual int GetLineSize();
        virtual void SetLineSize(int lineSize);
        virtual int GetPageSize();
        virtual void SetPageSize(int pageSize);
        virtual int GetPos();
        virtual void SetPos(int pos);
        virtual CButtonMe* GetReduceButton();
        virtual CButtonMe* GetScrollButton();
    public:
        virtual String GetControlType();
        virtual vector<String> GetEventNames();
        virtual void LineAdd();
        virtual void LineReduce();
        void OnAddButtonMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        void OnAddButtonMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnAddSpeedScrollEnd();
        virtual void OnAddSpeedScrollStart(uint64_t startTime, uint64_t nowTime, int start, int end);
        virtual int OnAddSpeedScrolling();
        virtual void OnDragScroll();
        virtual void OnLoad();
        void OnReduceButtonMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        void OnReduceButtonMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnScrolled();
        virtual void OnVisibleChanged();
        virtual void PageAdd();
        virtual void PageReduce();
        virtual void ScrollToBegin();
        virtual void ScrollToEnd();
        virtual void OnTimer(int timerID);
    };}

#endif
