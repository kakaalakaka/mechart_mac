/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CGRIDCELLME_H__
#define __CGRIDCELLME_H__
#pragma once
#include "stdafx.h"
#include "CProperty.h"
#include "CGridColumn.h"
#include "CGridRow.h"
#include "CGrid.h"
#include "CPaint.h"
#include "CControl.h"

namespace MeLib
{
	class CGridColumnMe;
	class CGridRowMe;
	class CGridMe;
    
    class GridCellStyle
    {
    protected:
        HorizontalAlignA m_align;
        bool m_autoEllipsis;
        _int64 m_backColor;
        FONT *m_font;
        _int64 m_foreColor;
    public:
        GridCellStyle();
        virtual ~GridCellStyle();
        virtual HorizontalAlignA GetAlign();
        virtual void SetAlign(HorizontalAlignA align);
        virtual bool AutoEllipsis();
        virtual void SetAutoEllipsis(bool autoEllipsis);
        virtual _int64 GetBackColor();
        virtual void SetBackColor(_int64 backColor);
        virtual FONT* GetFont();
        virtual void SetFont(FONT *font);
        virtual _int64 GetForeColor();
        virtual void SetForeColor(_int64 foreColor);
    public:
        void Copy(GridCellStyle *style);
    };
    
	class CGridCellMe : public CPropertyMe
	{
	protected:
		bool m_allowEdit;
		int m_colSpan;
		CGridColumnMe *m_column;
		CGridMe *m_grid;
		String m_name;
		CGridRowMe *m_row;
		int m_rowSpan;
		GridCellStyle *m_style;
		void *m_tag;
	public:
		CGridCellMe();
		virtual ~CGridCellMe();
		virtual bool AllowEdit();
		virtual void SetAllowEdit(bool allowEdit);
		virtual int GetColSpan();
		virtual void SetColSpan(int colSpan);
		virtual CGridColumnMe* GetColumn();
		virtual void SetColumn(CGridColumnMe *column);
		virtual CGridMe* GetGrid();
		virtual void SetGrid(CGridMe *grid);
		virtual String GetName();
		virtual void SetName(const String& name);
		virtual CGridRowMe* GetRow();
		virtual void SetRow(CGridRowMe *row);
		virtual int GetRowSpan();
		virtual void SetRowSpan(int rowSpan);
		virtual GridCellStyle* GetStyle();
		virtual void SetStyle(GridCellStyle *style);
		virtual void* GetTag();
		virtual void SetTag(void *tag);
		virtual String GetText();
		virtual void SetText(const String& text);
	public:
		virtual int CompareTo(CGridCellMe *cell);
		virtual bool GetBool();
		virtual double GetDouble();
		virtual float GetFloat();
		virtual int GetInt();
		virtual _int64 GetLong();
		virtual String GetPaintText();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual String GetString();
		virtual void OnAdd();
		virtual void OnPaint(CPaintMe *paint, const RECT& rect, const RECT& clipRect, bool isAlternate);
		virtual void OnRemove();
        virtual void SetBool(bool value);
        virtual void SetDouble(double value);
        virtual void SetFloat(float value);
        virtual void SetInt(int value);
        virtual void SetLong(_int64 value);
		virtual void SetProperty(const String& name, const String& value);
        virtual void SetString(const String& value);
	};
    
	class GridControlCell : public CGridCellMe
	{
	protected:
		CControlMe *m_control;
		ControlMouseEvent m_mouseDownEvent;
		ControlMouseEvent m_mouseMoveEvent;
		ControlMouseEvent m_mouseUpEvent;
	protected:
		static void ControlMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
		static void ControlMouseMove(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
		static void ControlMouseUp(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
	public:
		GridControlCell();
		virtual ~GridControlCell();
		virtual CControlMe* GetControl();
		virtual void SetControl(CControlMe *control);
		virtual String GetString();
		virtual String GetPaintText();
		virtual void OnAdd();
		virtual void OnControlMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnControlMouseMove(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnControlMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaint(CPaintMe *paint, const RECT& rect, const RECT& clipRect, bool isAlternate);
		virtual void OnPaintControl(CPaintMe *paint, const RECT& rect, const RECT& clipRect);
		virtual void OnRemove();
		virtual void SetString(const String& value);
	};
}

#endif
