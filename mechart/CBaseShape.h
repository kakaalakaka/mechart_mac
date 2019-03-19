/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CBASESHAPEME_H__
#define __CBASESHAPEME_H__
#pragma once
#include "stdafx.h"
#include "CPaint.h"
#include "Enums.h"
#include "CChart.h"
#include "CDiv.h"
#include "CTable.h"

namespace MeLib
{
	class CDivMe;
	class CChartMe;
	class CBaseShapeMe : CPropertyMe
	{
	protected:
		bool m_allowUserPaint;
		AttachVScale m_attachVScale;
	protected:
		bool m_selected;
		bool m_visible;
		int m_zOrder;
	public:
		CBaseShapeMe();
		virtual ~CBaseShapeMe();
		virtual bool AllowUserPaint();
		virtual void SetAllowUserPaint(bool allowUserPaint);
		virtual AttachVScale GetAttachVScale();
		virtual void SetAttachVScale(AttachVScale attachVScale);
		virtual bool IsSelected();
		virtual void SetSelected(bool selected);
		virtual bool IsVisible();
		virtual void SetVisible(bool visible);
		virtual int GetZOrder();
		virtual void SetZOrder(int zOrder);
	public:
		virtual int GetBaseField();
		virtual String GetFieldText(int fieldName);
		virtual int* GetFields(int *length);
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnPaint(CPaintMe *paint, CDivMe *div, const RECT& rect);
		virtual void SetProperty(const String& name, const String& value);
		virtual _int64 GetSelectedColor();
	};
    
	class CCandleShapeMe:public CBaseShapeMe
	{
	protected:
		int m_closeField;
		String m_closeFieldText;
		int m_colorField;
		_int64 m_downColor;
		int m_highField;
		String m_highFieldText;
		int m_lowField;
		String m_lowFieldText;
		int m_openField;
		String m_openFieldText;
		bool m_showMaxMin;
		CandleStyle m_style;
		int m_styleField;
		_int64 m_tagColor;
		_int64 m_upColor;
	public:
		CCandleShapeMe();
		int GetCloseField();
		void SetCloseField(int closeField);
		String GetCloseFieldText();
		void SetCloseFieldText(const String& closeFieldText);
		int GetColorField();
		void SetColorField(int colorField);
		_int64 GetDownColor();
		void SetDownColor(_int64 downColor);
		int GetHighField();
		void SetHighField(int highField);
		String GetHighFieldText();
		void SetHighFieldText(const String& highFieldText);
		int GetLowField();
		void SetLowField(int lowField);
		String GetLowFieldText();
		void SetLowFieldText(const String& lowFieldText);
		int GetOpenField();
		void SetOpenField(int openField);
		String GetOpenFieldText();
		void SetOpenFieldText(const String& openFieldText);
		bool GetShowMaxMin();
		void SetShowMaxMin(bool showMaxMin);
		CandleStyle GetStyle();
		void SetStyle(CandleStyle style);
		int GetStyleField();
		void SetStyleField(int styleField);
		_int64 GetTagColor();
		void SetTagColor(_int64 tagColor);
		_int64 GetUpColor();
		void SetUpColor(_int64 upColor);
	public:
		virtual int GetBaseField();
		virtual String GetFieldText(int fieldName);
		virtual int* GetFields(int *length);
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual _int64 GetSelectedColor();
		virtual void SetProperty(const String& name, const String& value);
	};
    
	class BarShape:public CBaseShapeMe
	{
	protected:
		int m_colorField;
		_int64 m_downColor;
		int m_fieldName;
		int m_fieldName2;
		String m_fieldText;
		String m_fieldText2;
		float m_lineWidth;
		BarStyle m_style;
		int m_styleField;
		_int64 m_upColor;
	public:
		BarShape();
		int GetColorField();
		void SetColorField(int colorField);
		_int64 GetDownColor();
		void SetDownColor(_int64 downColor);
		int GetFieldName();
		void SetFieldName(int fieldName);
		int GetFieldName2();
		void SetFieldName2(int fieldName2);
		String GetFieldText();
		void SetFieldText(const String& fieldText);
		String GetFieldText2();
		void SetFieldText2(const String& fieldText2);
		float GetLineWidth();
		void SetLineWidth(float lineWidth);
		BarStyle GetStyle();
		void SetStyle(BarStyle style);
		int GetStyleField();
		void SetStyleField(int styleField);
		_int64 GetUpColor();
		void SetUpColor(_int64 upColor);
	public:
		virtual int GetBaseField();
		virtual String GetFieldText(int fieldName);
		virtual int* GetFields(int *length);
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual _int64 GetSelectedColor();
		virtual void SetProperty(const String& name, const String& value);
	};
    
	class CPolylineShapeMe:public CBaseShapeMe
	{
	protected:
		_int64 m_color;
		int m_colorField;
		int m_fieldName;
		String m_fieldText;
		_int64 m_fillColor;
		PolylineStyle m_style;
		float m_width;
	public:
		CPolylineShapeMe();
		_int64 GetColor();
		void SetColor(_int64 color);
		int GetColorField();
		void SetColorField(int colorField);
		int GetFieldName();
		void SetFieldName(int fieldName);
		String GetFieldText();
		void SetFieldText(const String& fieldText);
		_int64 GetFillColor();
		void SetFillColor(_int64 fillColor);
		PolylineStyle GetStyle();
		void SetStyle(PolylineStyle style);
		float GetWidth();
		void SetWidth(float width);
	public:
		virtual int GetBaseField();
		virtual String GetFieldText(int fieldName);
		virtual int* GetFields(int *length);
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual _int64 GetSelectedColor();
		virtual void SetProperty(const String& name, const String& value);
	};
    
	class CTextShapeMe:public CBaseShapeMe
	{
	protected:
		int m_colorField;
		int m_fieldName;
		FONT *m_font;
		_int64 m_foreColor;
		int m_styleField;
		String m_text;
	public:
		CTextShapeMe();
		virtual ~CTextShapeMe();
		int GetColorField();
		void SetColorField(int colorField);
		int GetFieldName();
		void SetFieldName(int fieldName);
		FONT* GetFont();
		void SetFont(FONT *font);
		_int64 GetForeColor();
		void SetForeColor(_int64 foreColor);
		int GetStyleField();
		void SetStyleField(int styleField);
		String GetText();
		void SetText(const String& text);
	public:
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void SetProperty(const String& name, const String& value);
	};
}
#endif
