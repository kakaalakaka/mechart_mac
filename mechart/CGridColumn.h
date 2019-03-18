/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CGRIDCOLUMNME_H__
#define __CGRIDCOLUMNME_H__
#pragma once
#include "stdafx.h"
#include "CGridEnums.h"
#include "CGrid.h"
#include "CButton.h"

namespace MeLib
{
	class CGridMe;
    
    class CGridColumnMe : public CButtonMe
    {
    protected:
        bool m_allowSort;
        bool m_allowResize;
        HorizontalAlignA m_cellAlign;
        String m_columnType;
        bool m_frozen;
        CGridMe *m_grid;
        RECT m_headerRect;
        int m_index;
        GridColumnSortMode m_sortMode;
    protected:
        int m_beginWidth;
        POINT m_mouseDownPoint;
        int m_resizeState;
    public:
        CGridColumnMe();
        CGridColumnMe(const String& text);
        virtual ~CGridColumnMe();
        virtual bool AllowResize();
        virtual void SetAllowResize(bool allowResize);
        virtual bool AllowSort();
        virtual void SetAllowSort(bool allowSort);
        virtual HorizontalAlignA GetCellAlign();
        virtual void SetCellAlign(HorizontalAlignA cellAlign);
        virtual String GetColumnType();
        virtual void SetColumnType(String columnType);
        virtual bool IsFrozen();
        virtual void SetFrozen(bool frozen);
        virtual CGridMe* GetGrid();
        virtual void SetGrid(CGridMe *grid);
        virtual RECT GetHeaderRect();
        virtual void SetHeaderRect(RECT headerRect);
        virtual int GetIndex();
        virtual void SetIndex(int index);
        virtual GridColumnSortMode GetSortMode();
        virtual void SetSortMode(GridColumnSortMode sortMode);
    public:
        virtual String GetControlType();
        virtual void GetProperty(const String& name, String *value, String *type);
        virtual vector<String> GetPropertyNames();
        virtual void OnClick(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual bool OnDragBegin();
        virtual void OnDragging();
        virtual void OnMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnMouseMove(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
        virtual void SetProperty(const String& name, const String& value);
    };
}

#endif
