/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CDIVME_H__
#define __CDIVME_H__
#pragma once
#include "stdafx.h"
#include "CPaint.h"
#include "Enums.h"
#include "CCrossLine.h"
#include "CCrossLineTip.h"
#include "CScaleGrid.h"
#include "CChart.h"
#include "CVScale.h"
#include "CSelectArea.h"
#include "CToolTip.h"
#include "CTitleBar.h"
#include "CHScale.h"
#include "CPlot.h"
#include "CBaseShape.h"

namespace MeLib
{
	class CChartMe;
    class CCrossLineMe;
    class CCrossLineTipMe;
    class CToolTipMe;
	class CPlotMe;
	class CBaseShapeMe;
    class CHScaleMe;
	class CNativeBaseMe;
    class CScaleGridMe;
    class CSelectAreaMe;
    class CVScaleMe;
	class CDivMe : public CPropertyMe
	{
	protected:
		bool m_allowUserPaint;
		_int64 m_backColor;
		_int64 m_borderColor;
		CChartMe *m_chart;
		CCrossLineMe *m_crossLine;
		FONT *m_font;
		CScaleGridMe *m_hGrid;
		CHScaleMe *m_hScale;
		CVScaleMe *m_leftVScale;
		POINT m_location;
		vector<CPlotMe*> m_plots;
		int m_px;
		int m_py;
		CVScaleMe *m_rightVScale;
		CSelectAreaMe *m_selectArea;
		bool m_selected;
		vector<CBaseShapeMe*> m_shapes;
		bool m_showSelect;
		SIZE m_size;
		CTitleBarMe *m_title;
		CToolTipMe *m_toolTip;
		int m_verticalPercent;
		CScaleGridMe *m_vGrid;
		int m_workingAreaHeight;
	public:
		static bool ShapesAsc(CBaseShapeMe *x, CBaseShapeMe *y);
		static bool ShapesDesc(CBaseShapeMe *x, CBaseShapeMe *y);
		static bool PlotsAsc(CPlotMe *x, CPlotMe *y);
		static bool PlotsDesc(CPlotMe *x, CPlotMe *y);
	public:
		CDivMe();
		virtual ~CDivMe();
		virtual bool AllowUserPaint();
		virtual void SetAllowUserPaint(bool allowUserPaint);
		virtual _int64 GetBackColor();
		virtual void SetBackColor(_int64 backColor);
		virtual _int64 GetBorderColor();
		virtual void SetBorderColor(_int64 borderColor);
		virtual int GetBottom();
		virtual RECT GetBounds();
		virtual void SetBounds(RECT bounds);
		virtual CCrossLineMe* GetCrossLine();
		virtual void SetCrossLine(CCrossLineMe *crossLine);
		virtual FONT* GetFont();
		virtual void SetFont(FONT *font);
		virtual int GetHeight();
		virtual CScaleGridMe* GetHGrid();
		virtual void SetHGrid(CScaleGridMe *hGrid);
		virtual CHScaleMe* GetHScale();
		void SetHScale(CHScaleMe *hScale);
		virtual CChartMe* GetChart();
		virtual void SetChart(CChartMe *chart);
		virtual int GetLeft();
		virtual CVScaleMe* GetLeftVScale();
		virtual void SetLeftVScale(CVScaleMe *leftVScale);
		virtual POINT GetLocation();
		virtual int GetPx();
		virtual void SetPx(int px);
		virtual int GetPy();
		virtual void SetPy(int py);
		virtual int GetRight();
		virtual CVScaleMe* GetRightVScale();
		virtual void SetRightVScale(CVScaleMe *rightVScale);
		CSelectAreaMe* GetSelectArea();
		virtual void SetSelectArea(CSelectAreaMe *selectArea);
		virtual bool IsSelected();
		virtual void SetSelected(bool selected);
		virtual bool IsShowSelect();
		virtual void SetShowSelect(bool showSelect);
		virtual CTitleBarMe* GetTitleBar();
		virtual void SetTitleBar(CTitleBarMe *title);
		virtual CToolTipMe* GetToolTip();
		virtual void SetToolTip(CToolTipMe *toolTip);
		virtual int GetTop();
		virtual int GetVerticalPercent();
		virtual void SetVerticalPercent(int verticalPercent);
		virtual CScaleGridMe* GetVGrid();
		virtual void SetVGrid(CScaleGridMe *vGrid);
		virtual int GetWidth();
		virtual int GetWorkingAreaHeight();
		virtual void SetWorkingAreaHeight(int workingAreaHeight);
	public:
		void AddPlot(CPlotMe *plot);
		void AddShape(CBaseShapeMe *shape);
		bool ContainsShape(CBaseShapeMe *shape);
		vector<CPlotMe*> GetPlots(SORTTYPE sortType);
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnPaint(CPaintMe *paint, const RECT& rect);
		virtual void SetProperty(const String& name, const String& value);
		void RemovePlot(CPlotMe *plot);
		void RemoveShape(CBaseShapeMe *shape);
		vector<CBaseShapeMe*> GetShapes(SORTTYPE sortType);
		CVScaleMe* GetVScale(AttachVScale attachVScale);
	};
}
#endif
