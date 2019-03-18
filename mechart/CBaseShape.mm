#include "stdafx.h"
#include "CBaseShape.h"

namespace MeLib
{
	CBaseShapeMe::CBaseShapeMe()
	{
		m_allowUserPaint = false;
		m_attachVScale = AttachVScale_Left;
		m_selected = false;
		m_visible = true;
		m_zOrder = 0;
	}

	CBaseShapeMe::~CBaseShapeMe()
	{		
	}

	bool CBaseShapeMe::AllowUserPaint()
	{
		return m_allowUserPaint;
	}

	void CBaseShapeMe::SetAllowUserPaint(bool allowUserPaint)
	{
		m_allowUserPaint = allowUserPaint;
	}
	
	AttachVScale CBaseShapeMe::GetAttachVScale()
	{
		return m_attachVScale;
	}
	
	void CBaseShapeMe::SetAttachVScale(AttachVScale attachVScale)
	{
		m_attachVScale = attachVScale;
	}
	
	bool CBaseShapeMe::IsSelected()
	{
		return m_selected;
	}
	
	void CBaseShapeMe::SetSelected(bool selected)
	{
		m_selected = selected;
	}
	
	bool CBaseShapeMe::IsVisible()
	{
		return m_visible;
	}
	
	void CBaseShapeMe::SetVisible(bool visible)
	{
		m_visible = visible;
	}
	
	int CBaseShapeMe::GetZOrder()
	{
		return m_zOrder;
	}
	
	void CBaseShapeMe::SetZOrder(int zOrder)
	{
		m_zOrder = zOrder;
	}
	
	int CBaseShapeMe::GetBaseField()
	{
		return CTableMe::NULLFIELD();
	}
	
	String CBaseShapeMe::GetFieldText(int fieldName)
	{
		return L"";
	}
	
	int* CBaseShapeMe::GetFields(int *length)
	{
		return NULL;
	}
	
	void CBaseShapeMe::GetProperty(const String& name, String *value, String *type)
	{
		if(name == L"allowuserpaint") 
		{
            *type = L"bool";
            *value = CStrMe::ConvertBoolToStr(AllowUserPaint());
        } 
		else if(name == L"attachvscale") 
		{
            *type = L"enum:AttachVScale";
            if(GetAttachVScale() == AttachVScale_Left) 
			{
                *value = L"Left";
            } 
			else 
			{
                *value = L"Right";
            }
        } 
		else if(name == L"selected") 
		{
            *type = L"bool";
            *value = CStrMe::ConvertBoolToStr(IsSelected());
        } 
		else if(name == L"visible") 
		{
            *type = L"bool";
            *value = CStrMe::ConvertBoolToStr(IsVisible());
        } 
		else if(name == L"zorder") 
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetZOrder());
        } 
		else 
		{
            *type = L"undefined";
            *value = L"";
        }		
	}
	
	vector<String> CBaseShapeMe::GetPropertyNames()
	{
		vector<String> propertyNames;
		propertyNames.push_back(L"AllowUserPaint");
		propertyNames.push_back(L"AttachVScale");
		propertyNames.push_back(L"Selected");
		propertyNames.push_back(L"Visible");
		propertyNames.push_back(L"ZOrder");
        return propertyNames;
	}
	
	_int64 CBaseShapeMe::GetSelectedColor()
	{
		return 0;
	}
	
	void CBaseShapeMe::OnPaint(CPaintMe *paint, CDivMe *div, const RECT& rect)
	{
		
	}
	
	void CBaseShapeMe::SetProperty(const String& name, const String& value)
	{
		String szName = CStrMe::ToLower(name);
		if(szName == L"allowuserpaint") 
		{
			SetAllowUserPaint(CStrMe::ConvertStrToBool(value));
		}
		else if(szName == L"attachvscale") 
		{
			String szValue = CStrMe::ToLower(value);
            if(szValue == L"left")
			{
                SetAttachVScale(AttachVScale_Left);
            } 
			else 
			{
                SetAttachVScale(AttachVScale_Right);
            }
		}
		else if(szName == L"selected") 
		{
			SetSelected(CStrMe::ConvertStrToBool(value));
		}
		else if(szName == L"visible") 
		{
			SetVisible(CStrMe::ConvertStrToBool(value));
		}
		else if(szName == L"zorder") 
		{
			SetZOrder(CStrMe::ConvertStrToInt(value));
		}
	}
		
	///////////////////////////////////////////////////////////	///////////////////////////////////////////////////////////////////////////////////

	CandleShape::CandleShape()
	{
		m_closeField = CTableMe::NULLFIELD();
		m_closeFieldText = L"";
		m_colorField = CTableMe::NULLFIELD();
		m_downColor = COLOR::ARGB(84, 255, 255);
        m_highField = CTableMe::NULLFIELD();
		m_highFieldText = L"";
        m_lowField = CTableMe::NULLFIELD();
		m_lowFieldText = L"";
        m_openField = CTableMe::NULLFIELD();
		m_openFieldText = L"";
        m_showMaxMin = true;
		m_style = CandleStyle_Rect;
		m_styleField = CTableMe::NULLFIELD();
        m_tagColor = COLOR::ARGB(255, 255, 255);
        m_upColor = COLOR::ARGB(255, 82, 82);
        m_zOrder = 1;
	}

	int CandleShape::GetCloseField()
	{
		return m_closeField;
	}
		
	void CandleShape::SetCloseField(int closeField)
	{
		m_closeField = closeField;
	}
	
	String CandleShape::GetCloseFieldText()
	{
		return m_closeFieldText;
	}
	
	void CandleShape::SetCloseFieldText(const String& closeFieldText)
	{
		m_closeFieldText = closeFieldText;
	}
	
	int CandleShape::GetColorField()
	{
		return m_colorField;
	}
	
	void CandleShape::SetColorField(int colorField)
	{
		m_colorField = colorField;
	}
	
	_int64 CandleShape::GetDownColor()
	{
		return m_downColor;
	}
	
	void CandleShape::SetDownColor(_int64 downColor)
	{
		m_downColor = downColor;
	}
	
	int CandleShape::GetHighField()
	{
		return m_highField;
	}
		
	void CandleShape::SetHighField(int highField)
	{
		m_highField = highField;
	}
	
	String CandleShape::GetHighFieldText()
	{
		return m_highFieldText;
	}
	
	void CandleShape::SetHighFieldText(const String& highFieldText)
	{
		m_highFieldText = highFieldText;
	}
	
	int CandleShape::GetLowField()
	{
		return m_lowField;
	}
	
	void CandleShape::SetLowField(int lowField)
	{
		m_lowField = lowField;
	}
	
	String CandleShape::GetLowFieldText()
	{
		return m_lowFieldText;
	}
	
	void CandleShape::SetLowFieldText(const String& lowFieldText)
	{
		m_lowFieldText = lowFieldText;
	}
	
	int CandleShape::GetOpenField()
	{
		return m_openField;
	}
	
	void CandleShape::SetOpenField(int openField)
	{
		m_openField = openField;
	}
	
	String CandleShape::GetOpenFieldText()
	{
		return m_openFieldText;
	}
	
	void CandleShape::SetOpenFieldText(const String& openFieldText)
	{
		m_openFieldText = openFieldText;
	}
	
	bool CandleShape::GetShowMaxMin()
	{
		return m_showMaxMin;
	}
	
	void CandleShape::SetShowMaxMin(bool showMaxMin)
	{
		m_showMaxMin = showMaxMin;
	}
	
	CandleStyle CandleShape::GetStyle()
	{
		return m_style;
	}
	
	void CandleShape::SetStyle(CandleStyle style)
	{
		m_style = style;
	}
	
	int CandleShape::GetStyleField()
	{
		return m_styleField;
	}
	
	void CandleShape::SetStyleField(int styleField)
	{
		m_styleField = styleField;
	}
		
	_int64 CandleShape::GetTagColor()
	{
		return m_tagColor;
	}
	
	void CandleShape::SetTagColor(_int64 tagColor)
	{
		m_tagColor = tagColor;
	}
	
	_int64 CandleShape::GetUpColor()
	{
		return m_upColor;
	}
	
	void CandleShape::SetUpColor(_int64 upColor)
	{
		m_upColor = upColor;
	}
	
	int CandleShape::GetBaseField()
	{
		return m_closeField;
	}
	
	String CandleShape::GetFieldText(int fieldName)
	{
		return fieldName == m_closeField ? GetCloseFieldText() :
			(fieldName == m_highField ? GetHighFieldText() : (
			fieldName == m_lowField ? GetLowFieldText() : (
			fieldName == m_openField ? GetOpenFieldText() : L"")));
	}
	
	int* CandleShape::GetFields(int *length)
	{
		*length = 4;
		int *fields = new int[4];
		fields[0] = m_closeField;
		fields[1] = m_openField;
		fields[2] = m_highField;
		fields[3] = m_lowField;
		return fields;
	}
	
	void CandleShape::GetProperty(const String& name, String *value, String *type)
	{
		String szName = CStrMe::ToLower(name);
		
		if(szName == L"closefield")
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetCloseField());
        } 
		else if(szName == L"colorfield")
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetColorField());
        } 
		else if(szName == L"closefieldtext")
		{
            *type = L"string";
            *value = GetCloseFieldText();
        } 
		else if(szName == L"downcolor")
		{
            *type = L"color";
            *value = CStrMe::ConvertColorToStr(GetDownColor());
        } 
		else if(szName == L"highfield") 
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetHighField());
        } 
		else if(szName == L"highfieldtext") 
		{
            *type = L"string";
            *value = GetHighFieldText();
        } 
		else if(szName == L"lowfield") 
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetLowField());
        } 
		else if(szName == L"lowfieldtext") 
		{
            *type = L"string";
            *value = GetLowFieldText();
        } 
		else if(szName == L"openfield") 
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetOpenField());
        } 
		else if(szName == L"openfieldtext") 
		{
            *type = L"string";
            *value = GetOpenFieldText();
        } 
		else if(szName == L"showmaxmin") 
		{
            *type = L"bool";
            *value = CStrMe::ConvertBoolToStr(GetShowMaxMin());
        } 
		else if(szName == L"style") 
		{
            *type = L"enum:CandleStyle";
            CandleStyle style = GetStyle();
			if(style == CandleStyle_American) 
			{
                *value = L"American";
            } 
			else if(style == CandleStyle_CloseLine) 
			{
                *value = L"CloseLine";
            } 
			else if(style == CandleStyle_Tower) 
			{
                *value = L"Tower";
            } 
			else 
			{
                *value = L"Rect";
            }
        } 
		else if(szName == L"stylefield") 
		{
			*type = L"int";
            *value = CStrMe::ConvertIntToStr(GetStyleField());
        } 
		else if(szName == L"tagcolor") 
		{
            *type = L"double";
            *value = CStrMe::ConvertDoubleToStr((double)GetTagColor());
        } 
		else if(szName == L"upcolor") 
		{
            *type = L"color";
            *value = CStrMe::ConvertDoubleToStr((double)GetUpColor());
        }
		else 
		{
            CBaseShapeMe::GetProperty(name, value, type);
        }
	}
	
	vector<String> CandleShape::GetPropertyNames()
	{
		vector<String> propertyNames;
		propertyNames.push_back(L"CloseField");
		propertyNames.push_back(L"ColorField");
		propertyNames.push_back(L"CloseFieldText");
		propertyNames.push_back(L"DownColor");
		propertyNames.push_back(L"HighFieldText");
		propertyNames.push_back(L"LowField");
		propertyNames.push_back(L"LowFieldText");
		propertyNames.push_back(L"OpenField");
		propertyNames.push_back(L"OpenFieldText");
		propertyNames.push_back(L"ShowMaxMin");
		propertyNames.push_back(L"Style");
		propertyNames.push_back(L"StyleField");
		propertyNames.push_back(L"TagColor");
		propertyNames.push_back(L"UpColor");
        return propertyNames;
	}
	
	_int64 CandleShape::GetSelectedColor()
	{
		return m_downColor;
	}
	
	void CandleShape::SetProperty(const String& name, const String& value)
	{
		String szName = CStrMe::ToLower(name);
		if(szName == L"closefield")
		{
            SetCloseField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"colorfield")
		{
            SetColorField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"closefieldtext")
		{
			SetCloseFieldText(value);
        } 
		else if(szName == L"downcolor")
		{
            SetDownColor(CStrMe::ConvertStrToColor(value));
        } 
		else if(szName == L"highfield") 
		{
            SetHighField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"highfieldtext") 
		{
            SetHighFieldText(value);
        } 
		else if(szName == L"lowfield") 
		{
            SetLowField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"lowfieldtext") 
		{
            SetLowFieldText(value);
        } 
		else if(szName == L"openfield") 
		{
			SetOpenField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"openfieldtext") 
		{
            SetOpenField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"showmaxmin") 
		{
            SetShowMaxMin(CStrMe::ConvertStrToBool(value));
        } 
		else if(szName == L"style") 
		{
			String szValue = CStrMe::ToLower(value);
            if(szValue == L"american")
			{
				SetStyle(CandleStyle_American);
            } 
			else if(szValue == L"closeline")
			{
				SetStyle(CandleStyle_CloseLine);
            } 
			else if(szValue == L"tower")
			{
				SetStyle(CandleStyle_Tower);
            } 
			else 
			{
				SetStyle(CandleStyle_Rect);
            }      
        } 
		else if(szName == L"stylefield") 
		{
            SetStyleField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"tagcolor") 
		{
            SetTagColor(CStrMe::ConvertStrToColor(value));
        } 
		else if(szName == L"upcolor") 
		{
            SetUpColor(CStrMe::ConvertStrToColor(value));
        }
		else 
		{
            CBaseShapeMe::SetProperty(name, value);
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	BarShape::BarShape()
	{
		m_colorField = CTableMe::NULLFIELD();
        m_downColor = COLOR::ARGB(84, 255, 255);
        m_fieldName = CTableMe::NULLFIELD();
        m_fieldName2 = CTableMe::NULLFIELD();
        m_fieldText = L"";
        m_fieldText2 = L"";
        m_lineWidth = 1.0;
		m_style = BarStyle_Rect;
        m_styleField = CTableMe::NULLFIELD();
        m_upColor = COLOR::ARGB(255, 82, 82);
        SetZOrder(0);
	}
	
	int BarShape::GetColorField()
	{
		return m_colorField;
	}
	
	void BarShape::SetColorField(int colorField)
	{
		m_colorField = colorField;
	}
	
	_int64 BarShape::GetDownColor()
	{
		return m_downColor;
	}
	
	void BarShape::SetDownColor(_int64 downColor)
	{
		m_downColor = downColor;
	}
	
	int BarShape::GetFieldName()
	{
		return m_fieldName;
	}
	
	void BarShape::SetFieldName(int fieldName)
	{
		m_fieldName = fieldName;
	}
	
	int BarShape::GetFieldName2()
	{
		return m_fieldName2;
	}
	
	void BarShape::SetFieldName2(int fieldName2)
	{
		m_fieldName2 = fieldName2;
	}
	
	String BarShape::GetFieldText()
	{
		return m_fieldText;
	}
	
	void BarShape::SetFieldText(const String& fieldText)
	{
		m_fieldText = fieldText;
	}
	
	String BarShape::GetFieldText2()
	{
		return m_fieldText2;
	}
	
	void BarShape::SetFieldText2(const String& fieldText2)
	{
		m_fieldText2 = fieldText2;
	}
	
	float BarShape::GetLineWidth()
	{
		return m_lineWidth;
	}
	
	void BarShape::SetLineWidth(float lineWidth)
	{
		m_lineWidth = lineWidth;
	}
	
	BarStyle BarShape::GetStyle()
	{
		return m_style;
	}
	
	void BarShape::SetStyle(BarStyle style)
	{
		m_style = style;
	}
	
	int BarShape::GetStyleField()
	{
		return m_styleField;
	}
	
	void BarShape::SetStyleField(int styleField)
	{
		m_styleField = styleField;
	}
	
	_int64 BarShape::GetUpColor()
	{
		return m_upColor;
	}
	
	void BarShape::SetUpColor(_int64 upColor)
	{
		m_upColor = upColor;
	}
	
	int BarShape::GetBaseField()
	{
		return m_fieldName;	
	}
	
	String BarShape::GetFieldText(int fieldName)
	{
		return fieldName == m_fieldName ? GetFieldText() : (fieldName == m_fieldName2 ? GetFieldText2() : L"");
	}
	
	int* BarShape::GetFields(int *length)
	{
		if(m_fieldName2 == CTableMe::NULLFIELD())
		{
			*length = 1;
			int *fields = new int[1];
			fields[0] = m_fieldName;
			return fields;
		}
		else
		{
			*length = 2;
			int *fields = new int[2];
			fields[0] = m_fieldName;
			fields[1] = m_fieldName2;
			return fields;
		}
	}
	
	void BarShape::GetProperty(const String& name, String *value, String *type)
	{
		String szName = CStrMe::ToLower(name);
		
		if(szName == L"colorfield")
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetColorField());
        } 
		else if(szName == L"downcolor")
		{
            *type = L"color";
            *value = CStrMe::ConvertColorToStr(GetDownColor());
        } 
		else if(szName == L"fieldname")
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetFieldName());
        } 
		else if(szName == L"fieldname2")
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetFieldName2());
        } 
		else if(szName == L"fieldtext")
		{
            *type = L"string";
            *value = GetFieldText();
        } 
		else if(szName == L"fieldtext2")
		{
            *type = L"string";
            *value = GetFieldText2();
        } 
		else if(szName == L"linewidth")
			{
            *type = L"float";
            *value = CStrMe::ConvertFloatToStr(GetLineWidth());
        } 
		else if(szName == L"style")
		{
            *type = L"enum:BarStyle";
            BarStyle style = GetStyle();
			if(style == BarStyle_Line) 
			{
                *value = L"Line";
            } else {
                *value = L"Rect";
            }
        } 
		else if(szName == L"stylefield")
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetStyleField());
        } 
		else if(szName == L"upcolor")
		{
            *type = L"double";
            *value = CStrMe::ConvertColorToStr(GetUpColor());
        } 
		else 
		{
            CBaseShapeMe::GetProperty(name, value, type);
        }
	}
	
	vector<String> BarShape::GetPropertyNames()
	{
		vector<String> propertyNames;
		propertyNames.push_back(L"ColorField");
		propertyNames.push_back(L"DownColor");
		propertyNames.push_back(L"FieldName");
		propertyNames.push_back(L"FieldName2");
		propertyNames.push_back(L"FieldText");
		propertyNames.push_back(L"FieldText2");
		propertyNames.push_back(L"LineWidth");
		propertyNames.push_back(L"Style");
		propertyNames.push_back(L"StyleField");
		propertyNames.push_back(L"UpColor");
        return propertyNames;
	}
	
	_int64 BarShape::GetSelectedColor()
	{
		return m_downColor;
	}
	
	void BarShape::SetProperty(const String& name, const String& value)
	{
		String szName = CStrMe::ToLower(name);
		
		if(szName == L"colorfield")
		{
            SetColorField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"downcolor")
		{
            SetDownColor(CStrMe::ConvertStrToColor(value));
        } 
		else if(szName == L"fieldname")
		{
            SetFieldName(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"fieldname2")
		{
            SetFieldName2(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"fieldtext")
		{
            SetFieldText(value);
        } 
		else if(szName == L"fieldtext2")
		{
            SetFieldText2(value);
        } 
		else if(szName == L"linewidth")
		{
            SetLineWidth(CStrMe::ConvertStrToFloat(value));
        } 
		else if(szName == L"style")
		{
			String szValue = CStrMe::ToLower(value);
            if(szValue == L"line") 
			{
				SetStyle(BarStyle_Line);
            } 
			else 
			{
				SetStyle(BarStyle_Rect);
            }
        } 
		else if(szName == L"stylefield")
		{
            SetStyleField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"upcolor")
		{
            SetUpColor(CStrMe::ConvertStrToColor(value));
        } 
		else 
		{
            CBaseShapeMe::SetProperty(name, value);
        }	
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	PolylineShape::PolylineShape()
	{
		m_color = COLOR::ARGB(255, 255, 255);
		m_colorField = CTableMe::NULLFIELD();
        m_fieldName = CTableMe::NULLFIELD();
        m_fieldText = L"";
        m_fillColor = COLOR_EMPTY;
		m_style = PolylineStyle_SolidLine;
        m_width = 1.0;
        SetZOrder(2);
	}
	
	_int64 PolylineShape::GetColor()
	{
		return m_color;
	}
	
	void PolylineShape::SetColor(_int64 color)
	{
		m_color = color;
	}

	int PolylineShape::GetColorField()
	{
		return m_colorField;
	}

	void PolylineShape::SetColorField(int colorField)
	{
		m_colorField = colorField;
	}
	
	int PolylineShape::GetFieldName()
	{
		return m_fieldName;
	}
	
	void PolylineShape::SetFieldName(int fieldName)
	{
		m_fieldName = fieldName;
	}
	
	String PolylineShape::GetFieldText()
	{
		return m_fieldText;
	}
	
	void PolylineShape::SetFieldText(const String& fieldText)
	{
		m_fieldText = fieldText;
	}
	
	_int64 PolylineShape::GetFillColor()
	{
		return m_fillColor;
	}
	
	void PolylineShape::SetFillColor(_int64 fillColor)
	{
		m_fillColor = fillColor;
	}
	
	PolylineStyle PolylineShape::GetStyle()
	{
		return m_style;
	}
	
	void PolylineShape::SetStyle(PolylineStyle style)
	{
		m_style = style;
	}
	
	float PolylineShape::GetWidth()
	{
		return m_width;
	}

	void PolylineShape::SetWidth(float width)
	{
		m_width = width;
	}

	int PolylineShape::GetBaseField()
	{
		return m_fieldName;
	}
	
	String PolylineShape::GetFieldText(int fieldName)
	{
        return fieldName == m_fieldName ? GetFieldText() : L"";
	}
	
	int* PolylineShape::GetFields(int *length)
	{
		*length = 1;
		int *fields = new int[1];
		fields[0] = m_fieldName;
		return fields;
	}
	
	void PolylineShape::GetProperty(const String& name, String *value, String *type)
	{
		String szName = CStrMe::ToLower(name);		
		if(szName == L"color")
		{
            *type = L"color";
            *value = CStrMe::ConvertColorToStr(GetColor());
        } 
		else if(szName == L"colorfield")
		{
           * type = L"int";
            *value = CStrMe::ConvertIntToStr(GetColorField());
        } 
		else if(szName == L"fieldname")
		{
            *type = L"int";
            *value = CStrMe::ConvertIntToStr(GetFieldName());
        } 
		else if(szName == L"fieldtext")
		{
            *type = L"string";
            *value = GetFieldText();
        }
		else if(szName == L"fillcolor")
		{
            *type = L"color";
            *value = CStrMe::ConvertColorToStr(GetFillColor());
        }
		else if(szName == L"style") 
		{
            *type = L"enum:PolylineStyle";
            PolylineStyle style = GetStyle();
			if(style == PolylineStyle_Cycle) 
			{
                *value = L"Cycle";
            } 
			else if(style == PolylineStyle_DashLine) 
			{
                *value = L"DashLine";
            } 
			else if(style == PolylineStyle_DotLine) 
			{
                *value = L"DotLine";
            } 
			else 
			{
                *value = L"SolidLine";
            }
        } 
		else if(szName == L"width")
		{
            *type = L"float";
            *value = CStrMe::ConvertFloatToStr(GetWidth());
        }
		else
		{
            CBaseShapeMe::GetProperty(name, value, type);
        }
	}

	vector<String> PolylineShape::GetPropertyNames()
	{
		vector<String> propertyNames;
		propertyNames.push_back(L"Color");
		propertyNames.push_back(L"ColorField");
		propertyNames.push_back(L"FieldName");
		propertyNames.push_back(L"FieldText");
		propertyNames.push_back(L"FillColor");
		propertyNames.push_back(L"Style");
		propertyNames.push_back(L"Width");
        return propertyNames;
	}

	_int64 PolylineShape::GetSelectedColor()
	{
		return m_color;
	}

	void PolylineShape::SetProperty(const String& name, const String& value)
	{
		String szName = CStrMe::ToLower(name);		
		if(szName == L"color")
		{
            SetColor(CStrMe::ConvertStrToColor(value));
        } 
		else if(szName == L"colorfield")
		{
            SetColorField(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"fieldname")
		{
            SetFieldName(CStrMe::ConvertStrToInt(value));
        } 
		else if(szName == L"fieldtext")
		{
			SetFieldText(value);
        }
		else if(szName == L"fillcolor")
		{
            SetFillColor(CStrMe::ConvertStrToColor(value));
        }
		else if(szName == L"style") 
		{
            String szValue = CStrMe::ToLower(value);
            if(szValue == L"cyle") 
			{
				SetStyle(PolylineStyle_Cycle);
            } 
			else if(szValue == L"dashline")
			{
				SetStyle(PolylineStyle_DashLine);
            } 
			else if(szValue == L"dotline")
			{
				SetStyle(PolylineStyle_DotLine);
            } 
			else 
			{
				SetStyle(PolylineStyle_SolidLine);
            }
        } 
		else if(szName == L"width")
		{
            SetWidth(CStrMe::ConvertStrToFloat(value));
        }
		else
		{
            CBaseShapeMe::SetProperty(name, value);
        }
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	TextShape::TextShape()
	{
		m_colorField = CTableMe::NULLFIELD();
		m_fieldName = CTableMe::NULLFIELD();
		m_font = new FONT();
		m_foreColor = COLOR::ARGB(255, 255, 255);
		m_styleField = CTableMe::NULLFIELD();
		SetZOrder(4);
	}
	
	TextShape::~TextShape()
	{
		if(m_font)
		{
			delete m_font;
		}
		m_font = 0;
	}
	
	int TextShape::GetColorField()
	{
		return m_colorField;
	}
	
	void TextShape::SetColorField(int colorField)
	{
		m_colorField = colorField;
	}
	
	int TextShape::GetFieldName()
	{
		return m_fieldName;
	}
	
	void TextShape::SetFieldName(int fieldName)
	{
		m_fieldName = fieldName;
	}
	
	FONT* TextShape::GetFont()
	{
		return m_font;
	}
	
	void TextShape::SetFont(FONT *font)
	{
		m_font->Copy(font);
	}
	
	_int64 TextShape::GetForeColor()
	{
		return m_foreColor;
	}
	
	void TextShape::SetForeColor(_int64 foreColor)
	{
		m_foreColor = foreColor;
	}
	
	int TextShape::GetStyleField()
	{
		return m_styleField;
	}

	void TextShape::SetStyleField(int styleField)
	{
		m_styleField = styleField;
	}
	
	String TextShape::GetText()
	{
		return m_text;
	}
	
	void TextShape::SetText(const String& text)
	{
		m_text = text;
	}
	
	void TextShape::GetProperty(const String& name, String *value, String *type)
	{
		String szName = CStrMe::ToLower(name);
		
		if(szName == L"colorfield")
		{
			*type = L"int";
			*value = CStrMe::ConvertIntToStr(GetColorField());
		} 
		else if(szName == L"fieldname")
		{
			*type = L"int";
			*value = CStrMe::ConvertIntToStr(GetFieldName());
		} 
		else if(szName == L"font")
		{
			*type = L"font";
			*value = CStrMe::ConvertFontToStr(GetFont());
		} 
		else if(szName == L"forecolor")
		{
			*type = L"color";
			*value = CStrMe::ConvertColorToStr(GetForeColor());
		} 
		else if(szName == L"stylefield")
		{
			*type = L"int";
			*value = CStrMe::ConvertIntToStr(GetStyleField());
		} 
		else if(szName == L"text")
		{
			*type = L"string";
			*value = GetText();
		} 
		else 
		{
			CBaseShapeMe::GetProperty(name, value, type);
		}
	}
	
	vector<String> TextShape::GetPropertyNames()
	{
		 vector<String> propertyNames;
		 propertyNames.push_back(L"ColorField");
		 propertyNames.push_back(L"FieldName");
		 propertyNames.push_back(L"Font");
		 propertyNames.push_back(L"ForeColor");
		 propertyNames.push_back(L"StyleField");
		 propertyNames.push_back(L"Text");
		return propertyNames;
	}
	
	void TextShape::SetProperty(const String& name, const String& value)
	{
		String szName = CStrMe::ToLower(name);
		
		if(szName == L"colorfield")
		{
			SetColorField(CStrMe::ConvertStrToInt(value));
		} 
		else if(szName == L"fieldname")
		{
			SetFieldName(CStrMe::ConvertStrToInt(value));
		}
		else if(szName == L"font")
		{
			SetFont(CStrMe::ConvertStrToFont(value));
		}
		else if(szName == L"forecolor")
		{
			SetForeColor(CStrMe::ConvertStrToColor(value));
		}
		else if(szName == L"stylefield")
		{
			SetStyleField(CStrMe::ConvertStrToInt(value));
		}
		else if(szName == L"text")
		{
			SetText(value);
		} 
		else 
		{
			CBaseShapeMe::SetProperty(name, value);
		}
	}
}
