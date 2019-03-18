#include "stdafx.h"
#include "CStr.h"
#include "CMathLib.h"

using namespace MeLib;

double CStrMe::round( double x )
{
	int sa = 0, si = 0;  
	if(x == 0.0)   
	{
		return 0.0; 
	}
	else    
	{
		if(x > 0.0)  
		{
			sa = (int)x;   
			si = (int)(x + 0.5);        
			if(sa == floor((double)si))   
			{
				return sa;    
			}
			else     
			{
				return sa + 1; 
			}
		}       
		else    
		{
			sa = (int)x;   
			si = (int)(x - 0.5);      
			if(sa == ceil((double)si))  
			{
				return sa;       
			}
			else         
			{
				return sa - 1;      
			}
		}
	}
}

void CStrMe::Contact( wchar_t *str, const wchar_t *str1, const wchar_t *str2, const wchar_t *str3 )
{
	*str = 0;
	wcscat(str, str1);
	if(wcslen(str2) > 0){
		wcscat(str, str2);
	}
	if(wcslen(str3) > 0){
		wcscat(str, str3);
	}
} 

String CStrMe::ConvertAnchorToStr( const ANCHOR& anchor )
{
	vector<String> list;
	if (anchor.left)
	{
		list.push_back(L"Left");
	}
	if (anchor.top)
	{
		list.push_back(L"Top");
	}
	if (anchor.right)
	{
		list.push_back(L"Right");
	}
	if (anchor.bottom)
	{
		list.push_back(L"Bottom");
	}
	String str;
	int count = (int)list.size();
	if (count > 0)
	{
		for (int i = 0; i < count; i++)
		{
			str = str + list[i];
			if (i != count - 1)
			{
				str = str + L",";
			}
		}
		return str;
	}
	return L"None";
}

String CStrMe::ConvertBoolToStr( bool value )
{
	if (!value)
	{
		return L"False";
	}
	return L"True";
}

String CStrMe::ConvertColorToStr( _int64 color )
{
	if (color == COLOR_EMPTY)
	{
		return L"Empty";
	}
	if (color == COLOR_CONTROL)
	{
		return L"Control";
	}
	if (color == COLOR_CONTROLBORDER)
	{
		return L"ControlBorder";
	}
	if (color == COLOR_CONTROLTEXT)
	{
		return L"ControlText";
	}
	if (color == COLOR_DISABLEDCONTROL)
	{
		return L"DisabledControl";
	}
	if (color == COLOR_DISABLEDCONTROLTEXT)
	{
		return L"DisabledControlText";
	}
	int a = 0;
	int r = 0;
	int g = 0;
	int b = 0;
	COLOR::ToARGB(0, color, &a, &r, &g, &b);
	if (a == 0xff)
	{
		wchar_t buff[64] = {0};
		swprintf(buff, 63, L"%d,%d,%d", r, g, b);
		return buff;
	}
	wchar_t buff[64] = {0};
	swprintf(buff, 63, L"%d,%d,%d,%d", a, r, g, b);
	return buff;
}

String CStrMe::ConvertContentAlignmentToStr( ContentAlignmentA contentAlignment )
{
	String str;
	if (contentAlignment == ContentAlignmentA_BottomCenter)
	{
		return L"BottomCenter";
	}
	if (contentAlignment == ContentAlignmentA_BottomLeft)
	{
		return L"BottomLeft";
	}
	if (contentAlignment == ContentAlignmentA_BottomRight)
	{
		return L"BottomRight";
	}
	if (contentAlignment == ContentAlignmentA_MiddleCenter)
	{
		return L"MiddleCenter";
	}
	if (contentAlignment == ContentAlignmentA_MiddleLeft)
	{
		return L"MiddleLeft";
	}
	if (contentAlignment == ContentAlignmentA_MiddleRight)
	{
		return L"MiddleRight";
	}
	if (contentAlignment == ContentAlignmentA_TopCenter)
	{
		return L"TopCenter";
	}
	if (contentAlignment == ContentAlignmentA_TopLeft)
	{
		return L"TopLeft";
	}
	if (contentAlignment == ContentAlignmentA_TopRight)
	{
		str = L"TopRight";
	}
	return str;
}

String CStrMe::ConvertCursorToStr( CursorsA cursor )
{
	String str;
    //if (cursor == CursorsA_AppStarting)
	//{
	//	return L"AppStarting";
	//}
	if (cursor == CursorsA_Arrow)
	{
		return L"Arrow";
	}
	if (cursor == CursorsA_Cross)
	{
		return L"Cross";
	}
	//if (cursor == CursorsA_Hand)
	//{
	//	return L"Hand";
	//}
//    if (cursor == CursorsA_Help)
//    {
//        return L"Help";
//    }
	if (cursor == CursorsA_IBeam)
	{
		return L"IBeam";
	}
	if (cursor == CursorsA_No)
	{
		return L"NO";
	}
	//if (cursor == CursorsA_SizeAll)
	//{
	//	return L"SizeAll";
	//}
	if (cursor == CursorsA_SizeNESW)
	{
		return L"SizeNESW";
	}
	if (cursor == CursorsA_SizeNS)
	{
		return L"SizeNS";
	}
	if (cursor == CursorsA_SizeNWSE)
	{
		return L"SizeNWSE";
	}
	if (cursor == CursorsA_SizeWE)
	{
		return L"SizeWE";
	}
//    if (cursor == CursorsA_UpArrow)
//    {
//        return L"UpArrow";
//    }
	if (cursor == CursorsA_WaitCursor)
	{
		str = L"WaitCursor";
	}
	return str;
}

String CStrMe::ConvertDockToStr( DockStyleA dock )
{
	String str;
	if (dock == DockStyleA_Bottom)
	{
		return L"Bottom";
	}
	if (dock == DockStyleA_Fill)
	{
		return L"Fill";
	}
	if (dock == DockStyleA_Left)
	{
		return L"Left";
	}
	if (dock == DockStyleA_None)
	{
		return L"None";
	}
	if (dock == DockStyleA_Right)
	{
		return L"Right";
	}
	if (dock == DockStyleA_Top)
	{
		str = L"Top";
	}
	return str;
}

String CStrMe::ConvertDoubleToStr( double value )
{
	wchar_t buff[256] = {0};
	swprintf(buff, 255, L"%f", value);
	return buff;
}

String CStrMe::ConvertFloatToStr( float value )
{
	wchar_t buff[256] = {0};
	swprintf(buff, 255, L"%f", value);
	return buff;
}

String CStrMe::ConvertFontToStr( FONT *font )
{
	vector<String> list;
	list.push_back(font->m_fontFamily);
	list.push_back(ConvertFloatToStr(font->m_fontSize));
	if (font->m_bold)
	{
		list.push_back(L"Bold");
	}
	if (font->m_underline)
	{
		list.push_back(L"UnderLine");
	}
	if (font->m_italic)
	{
		list.push_back(L"Italic");
	}
	if (font->m_strikeout)
	{
		list.push_back(L"Strikeout");
	}
	String str;
	int count = (int)list.size();
	if (count > 0)
	{
		for (int i = 0; i < count; i++)
		{
			str = str + list[i];
			if (i != count - 1)
			{
				str = str + L",";
			}
		}
	}
	return str;
}

String CStrMe::ConvertHorizontalAlignToStr( HorizontalAlignA horizontalAlign )
{
	if (horizontalAlign == HorizontalAlignA_Center)
	{
		return L"Center";
	}
	if (horizontalAlign == HorizontalAlignA_Right)
	{
		return L"Right";
	}
	if (horizontalAlign == HorizontalAlignA_Inherit)
	{
		return L"Inherit";
	}
	if (horizontalAlign == HorizontalAlignA_Left)
	{
		return L"Left";
	}
	return L"";
}

String CStrMe::ConvertIntToStr( int value )
{
	wchar_t buff[32] = {0};
	swprintf(buff, 31, L"%d", value);
	return buff;
}

String CStrMe::ConvertLongToStr( _int64 value )
{
	wchar_t buff[32] = {0};
	swprintf(buff, 31, L"%I64d", value);
	return buff;
}

String CStrMe::ConvertLayoutStyleToStr( LayoutStyleA layoutStyle )
{
	if (layoutStyle == LayoutStyleA_BottomToTop)
	{
		return L"BottomToTop";
	}
	if (layoutStyle == LayoutStyleA_LeftToRight)
	{
		return L"LeftToRight";
	}
	if (layoutStyle == LayoutStyleA_None)
	{
		return L"None";
	}
	if (layoutStyle == LayoutStyleA_RightToLeft)
	{
		return L"RightToLeft";
	}
	if (layoutStyle == LayoutStyleA_TopToBottom)
	{
		return L"TopToBottom";
	}
	return L"";
}

String CStrMe::ConvertPaddingToStr( const PADDING& padding )
{
	wchar_t buff[128] = {0};
	swprintf(buff, 127, L"%d,%d,%d,%d", padding.left, padding.top, padding.right, padding.bottom);
	return buff;
}

String CStrMe::ConvertPointToStr( const POINT& mp )
{
	wchar_t buff[128] = {0};
	swprintf(buff, 127, L"%d,%d", mp.x, mp.y);
	return buff;
}

String CStrMe::ConvertRectToStr( const RECT& rect )
{
	wchar_t buff[128] = {0};
	swprintf(buff, 127, L"%d,%d,%d,%d", rect.left, rect.top, rect.right, rect.bottom);
	return buff;
}

String CStrMe::ConvertSizeToStr( const SIZE& size )
{
	wchar_t buff[128] = {0};
	swprintf(buff, 127, L"%d,%d", size.cx, size.cy);
	return buff;
}

ANCHOR CStrMe::ConvertStrToAnchor( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	bool left = false;
	bool top = false;
	bool right = false;
	bool bottom = false;
	vector<String> vec = CStrMe::Split(str1, L",");
	for(vector<String>::iterator iter = vec.begin(); iter != vec.end(); iter++)
	{
		String str2 = *iter;
		if(str2 == L"left")
		{
			left = true;
		}
		else if(str2 == L"top")
		{
			top = true;
		}
		else if(str2 == L"right")
		{
			right = true;
		}
		else if(str2 == L"bottom")
		{
			bottom = true;
		}
	}
	ANCHOR anchor(left, top, right, bottom);
	return anchor;
}

bool CStrMe::ConvertStrToBool( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	if (str1 != L"true")
	{
		return false;
	}
	return true;
}

_int64 CStrMe::ConvertStrToColor( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	if (str1 != L"empty")
	{
		if (str1 == L"control")
		{
			return COLOR_CONTROL;
		}
		if (str1 == L"controlborder")
		{
			return COLOR_CONTROLBORDER;
		}
		if (str1 == L"controltext")
		{
			return COLOR_CONTROLTEXT;
		}
		if (str1 == L"disabledcontrol")
		{
			return COLOR_DISABLEDCONTROL;
		}
		if (str1 == L"disabledcontroltext")
		{
			return COLOR_DISABLEDCONTROLTEXT;
		}

		vector<String> strArray = CStrMe::Split(str1, L",");
		int result = 255;
		int num2 = 255;
		int num3 = 255;
		int num4 = 255;
        wchar_t *wp;
		if (strArray.size() == 3)
		{
			num2 = (int)wcstol(strArray[0].c_str(), &wp, 0);
			num3 = (int)wcstol(strArray[1].c_str(), &wp, 0);
			num4 = (int)wcstol(strArray[2].c_str(), &wp, 0);
            return (_int64)COLOR::ARGB(num2, num3, num4);
		}
		if (strArray.size() == 4)
		{
			result = (int)wcstol(strArray[0].c_str(), &wp, 0);
			num2 = (int)wcstol(strArray[1].c_str(), &wp, 0);
			num3 = (int)wcstol(strArray[2].c_str(), &wp, 0);
			num4 = (int)wcstol(strArray[3].c_str(), &wp, 0);
			return (_int64)COLOR::ARGB(result, num2, num3, num4);
		}
	}
	return COLOR_EMPTY;
}

ContentAlignmentA CStrMe::ConvertStrToContentAlignment( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	ContentAlignmentA middleCenter = ContentAlignmentA_MiddleCenter;
	if (str1 == L"bottomcenter")
	{
		return ContentAlignmentA_BottomCenter;
	}
	if (str1 == L"bottomleft")
	{
		return ContentAlignmentA_BottomLeft;
	}
	if (str1 == L"bottomright")
	{
		return ContentAlignmentA_BottomRight;
	}
	if (str1 == L"middlecenter")
	{
		return ContentAlignmentA_MiddleCenter;
	}
	if (str1 == L"middleleft")
	{
		return ContentAlignmentA_MiddleLeft;
	}
	if (str1 == L"middleright")
	{
		return ContentAlignmentA_MiddleRight;
	}
	if (str1 == L"topcenter")
	{
		return ContentAlignmentA_TopCenter;
	}
	if (str1 == L"topleft")
	{
		return ContentAlignmentA_TopLeft;
	}
	if (str1 == L"topright")
	{
		middleCenter = ContentAlignmentA_TopRight;
	}
	return middleCenter;
}

CursorsA CStrMe::ConvertStrToCursor( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	CursorsA arrow = CursorsA_Arrow;
//    if (str1 == L"appstarting")
//    {
//        return CursorsA_AppStarting;
//    }
	if (str1 == L"cross")
	{
		return CursorsA_Cross;
	}
	if (str1 == L"hand")
	{
		return CursorsA_Hand;
	}
//    if (str1 == L"help")
//    {
//        return CursorsA_Help;
//    }
	if (str1 == L"ibeam")
	{
		return CursorsA_IBeam;
	}
	if (str1 == L"no")
	{
		return CursorsA_No;
	}
//    if (str1 == L"sizeall")
//    {
//        return CursorsA_SizeAll;
//    }
	if (str1 == L"sizenesw")
	{
		return CursorsA_SizeNESW;
	}
	if (str1 == L"sizens")
	{
		return CursorsA_SizeNS;
	}
	if (str1 == L"sizenwse")
	{
		return CursorsA_SizeNWSE;
	}
	if (str1 == L"sizewe")
	{
		return CursorsA_SizeWE;
	}
//    if (str1 == L"uparrow")
//    {
//        return CursorsA_UpArrow;
//    }
	if (str1 == L"waitcursor")
	{
		arrow = CursorsA_WaitCursor;
	}
	return arrow;
}

DockStyleA CStrMe::ConvertStrToDock( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	DockStyleA none = DockStyleA_None;
	if (str1 == L"bottom")
	{
		return DockStyleA_Bottom;
	}
	if (str1 == L"fill")
	{
		return DockStyleA_Fill;
	}
	if (str1 == L"left")
	{
		return DockStyleA_Left;
	}
	if (str1 == L"right")
	{
		return DockStyleA_Right;
	}
	if (str1 == L"top")
	{
		none = DockStyleA_Top;
	}
	return none;
}

double CStrMe::ConvertStrToDouble( const String& str )
{
    wchar_t *wp;
	return wcstod(str.c_str(), &wp);
}

double CStrMe::ConvertStrToDouble( const wchar_t *str )
{
    wchar_t *wp;
	return wcstod(str, &wp);
}

float CStrMe::ConvertStrToFloat( const String& str )
{
    wchar_t *wp;
	return (float)wcstod(str.c_str(), &wp);
}

FONT* CStrMe::ConvertStrToFont( const String& str )
{
	vector<String> strArray = CStrMe::Split(str, L",");
	int length = (int)strArray.size();
	String fontFamily = L"SimSun";
	float fontSize = 12;
	bool bold = false;
	bool underline = false;
	bool italic = false;
	bool strikeout = false;
	if (length >= 1)
	{
		fontFamily = strArray[0];
	}
	if (length >= 2)
	{
		fontSize = CStrMe::ConvertStrToFloat(strArray[1]);
	}
	for (int i = 2; i < length; i++)
	{
		String str2 = CStrMe::ToLower(strArray[i]);
		if(str2 == L"bold")
		{
			bold = true;
		}
		else if(str2 == L"underline")
		{
			underline = true;
		}
		else if(str2 == L"italic")
		{
			italic = true;
		}
		else if(str2 == L"strikeout")
		{
			strikeout = true;
		}
	}
	FONT* font = new FONT(fontFamily, fontSize, bold, underline, italic, strikeout);
	return font;
}

HorizontalAlignA CStrMe::ConvertStrToHorizontalAlign( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	HorizontalAlignA center = HorizontalAlignA_Center;
	if (str1 == L"right")
	{
		return HorizontalAlignA_Right;
	}
	if (str1 == L"inherit")
	{
		return HorizontalAlignA_Inherit;
	}
	if (str1 == L"left")
	{
		center = HorizontalAlignA_Left;
	}
	return center;
}

int CStrMe::ConvertStrToInt( const String& str )
{
    wchar_t *wp;
	return (int)wcstol(str.c_str(), &wp, 0);
}

int CStrMe::ConvertStrToInt( const wchar_t *str )
{
    wchar_t *wp;
	return (int)wcstol(str, &wp, 0);
}

LayoutStyleA CStrMe::ConvertStrToLayoutStyle( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	LayoutStyleA none = LayoutStyleA_None;
	if (str1 == L"bottomtotop")
	{
		return LayoutStyleA_BottomToTop;
	}
	if (str1 == L"lefttoright")
	{
		return LayoutStyleA_LeftToRight;
	}
	if (str1 == L"righttoleft")
	{
		return LayoutStyleA_RightToLeft;
	}
	if (str1 == L"toptobottom")
	{
		none = LayoutStyleA_TopToBottom;
	}
	return none;
}

_int64 CStrMe::ConvertStrToLong( const String& str )
{
    wchar_t *wp;
	return wcstol(str.c_str(), &wp, 0);
}

_int64 CStrMe::ConvertStrToLong( const wchar_t *str )
{
    wchar_t *wp;
	return wcstol(str, &wp, 0);
}

PADDING CStrMe::ConvertStrToPadding( const String& str )
{
	int left = 0;
	int top = 0;
	int right = 0;
	int bottom = 0;
	vector<String> strArray = CStrMe::Split(str, L",");
	if (strArray.size() == 4)
	{
        wchar_t *wp;
		left = (int)wcstol(strArray[0].c_str(), &wp, 0);
		top = (int)wcstol(strArray[1].c_str(), &wp, 0);
		right = (int)wcstol(strArray[2].c_str(), &wp, 0);
		bottom = (int)wcstol(strArray[3].c_str(), &wp, 0);
	}
	PADDING padding(left, top, right, bottom);
	return padding; 
}

POINT CStrMe::ConvertStrToPoint( const String& str )
{
	int x = 0;
	int y = 0;
	vector<String> strArray = CStrMe::Split(str, L",");
	if (strArray.size() == 2)
	{
        wchar_t *wp;
		x = (int)wcstol(strArray[0].c_str(), &wp, 0);
		y = (int)wcstol(strArray[1].c_str(), &wp, 0);
	}
	POINT point = {x, y};
	return point;
}

RECT CStrMe::ConvertStrToRect( const String& str )
{
	int left = 0;
	int top = 0;
	int right = 0;
	int bottom = 0;
	vector<String> strArray = CStrMe::Split(str, L",");
	if (strArray.size() == 4)
	{
        wchar_t *wp;
		left = (int)wcstol(strArray[0].c_str(), &wp, 0);
		top = (int)wcstol(strArray[1].c_str(), &wp, 0);
		right = (int)wcstol(strArray[2].c_str(), &wp, 0);
		bottom = (int)wcstol(strArray[3].c_str(), &wp, 0);
	}
	RECT rect;
	rect.left = left;
	rect.top = top;
	rect.right = right;
	rect.bottom = bottom;
	return rect;
}

SIZE CStrMe::ConvertStrToSize( const String& str )
{
	int cx = 0;
	int cy = 0;
	vector<String> strArray = CStrMe::Split(str, L",");
	if (strArray.size() == 2)
	{
        wchar_t *wp;
		cx = (int)wcstol(strArray[0].c_str(), &wp, 0);
		cy = (int)wcstol(strArray[1].c_str(), &wp, 0);
	}
	SIZE size;
	size.cx = cx;
	size.cy = cy;
	return size;
}

VerticalAlignA CStrMe::ConvertStrToVerticalAlign( const String& str )
{
	String str1 = CStrMe::ToLower(str);
	VerticalAlignA middle = VerticalAlignA_Middle;
	if (str1 == L"bottom")
	{
		return VerticalAlignA_Bottom;
	}
	if (str1 == L"inherit")
	{
		return VerticalAlignA_Inherit;
	}
	if (str1 == L"top")
	{
		middle = VerticalAlignA_Top;
	}
	return middle;
}

String CStrMe::ConvertVerticalAlignToStr( VerticalAlignA verticalAlign )
{
	String str = L"";
	if (verticalAlign == VerticalAlignA_Bottom)
	{
		return L"Bottom";
	}
	if (verticalAlign == VerticalAlignA_Inherit)
	{
		return L"Inherit";
	}
	if (verticalAlign == VerticalAlignA_Middle)
	{
		return L"Middle";
	}
	if (verticalAlign == VerticalAlignA_Top)
	{
		str = L"Top";
	}
	return str;
}

void CStrMe::GetValueByDigit( double value, int digit, wchar_t *str )
{
	//if(!_isnan(value))
	{
		if(digit == 0)
		{
			double newValue = round(value);
			if(abs(newValue - value) < 1.0)
			{
				value = newValue;
			}
		}
		switch(digit)
		{
		case 0:
			swprintf(str, 99, L"%d", (int)value);
			break;
		case 1:
			swprintf(str, 99, L"%.f", value);
			break;
		case 2:
			swprintf(str, 99, L"%.2f", value);
			break;
		case 3:
			swprintf(str, 99, L"%.3f", value);
			break;
		case 4:
			swprintf(str, 99, L"%.4f", value);
			break;
		case 5:
			swprintf(str, 99, L"%.5f", value);
			break;
		case 6:
			swprintf(str, 99, L"%.6f", value);
			break;
		case 7:
			swprintf(str, 99, L"%.7f", value);
			break;
		case 8:
			swprintf(str, 99, L"%.8f", value);
			break;
		case 9:
			swprintf(str, 99, L"%.9f", value);
			break;
		}
		str = 0;
	}
}

void CStrMe::GetFormatDate( double date, wchar_t *str )
{
	int year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0, msecond = 0;
	CMathLibMe::M130(date, &year, &month, &day, &hour, &minute, &second, &msecond);
	if(hour > 0)
	{
		swprintf(str, 99, L"%02d:%02d:", hour, minute);
	}
	else
	{
		swprintf(str, 99, L"%04d-%02d-%02d", year, month, day);
	}
}

String CStrMe::GetFormatDate( const String& format, int year, int month, int day, int hour, int minute, int second )
{
	String result = format;
	static wchar_t strYear[100] = {0};
	static wchar_t strMonth[100] = {0};
	static wchar_t strDay[100] = {0};
	static wchar_t strHour[100] = {0};
	static wchar_t strMinute[100] = {0};
	static wchar_t strSecond[100] = {0};
	swprintf(strYear, 99, L"%d", year);
	swprintf(strMonth, 99, L"%02d", month);
	swprintf(strDay, 99, L"%02d", day);
	swprintf(strHour, 99, L"%d", hour);
	swprintf(strMinute, 99, L"%02d", minute);
	swprintf(strSecond, 99, L"%02d", second);
	if((int)format.find(L"yyyy") != -1)
	{
		result = Replace(result, L"yyyy", strYear);
	}
	if((int)format.find(L"MM") != -1)
	{
		result = Replace(result, L"MM", strMonth);
	}
	if((int)format.find(L"dd") != -1)
	{
		result = Replace(result, L"dd", strDay);
	}
	if((int)format.find(L"HH") != -1)
	{
		result = Replace(result, L"HH", strHour);
	}
	if((int)format.find(L"mm") != -1)
	{
		result = Replace(result, L"mm", strMinute);
	}
	if((int)format.find(L"ss") != -1)
	{
		result = Replace(result, L"ss", strSecond);
	}
	return result;
}

int CStrMe::HexToDec(const char *str, int length)
{
	int rslt = 0;  
	for (int i = 0; i < length; i++)  
	{  
		rslt += (str[i]) << (8 * (length - 1 - i));  

	}  
	return rslt;  
}

bool CStrMe::IsBlank(int c)
{
	if((c == ' ') || (c == '\t'))
	{
		return true;
	}
	else
	{
		return false;
	}
}

int CStrMe::IsNumeric(const string& str)
{
    if (str == "")
    {
        return 0;
    }
    int size = (int)str.size();
    int count = 0;
    int base = 10;
    char *ptr = new char[size + 1];
    strcpy(ptr, str.c_str());
    //memset(ptr, 0, size);
    //memcpy(ptr, str.c_str(), size);
    //str.copy(ptr, size, 0);
    int type = 0;
	/* skip blank */  
	while (IsBlank(*ptr)) 
	{  
		ptr++;  
	}  

	/* skip sign */  
	if (*ptr == '-' || *ptr == '+') 
	{
		ptr++;  
	}  
	/* first char should be digit or dot*/  
	if (isdigit(*ptr) || ptr[0]=='.') 
	{  
		if (ptr[0]!='.') 
		{
			/* handle hex numbers */  
			if (ptr[0] == '0' && ptr[1] && (ptr[1] == 'x' || ptr[1] == 'X')) 
			{
				type = 2;  
				base = 16;  
				ptr += 2;  
			}
			/* Skip any leading 0s */
			while (*ptr == '0')
			{  
				ptr++;  
			}
			/* Skip digit */  
			while (isdigit(*ptr) || (base == 16 && isxdigit(*ptr)))
			{  
				ptr++;  
			}  
		}  

		/* Handle dot */  
		if (base == 10 && *ptr && ptr[0] == '.')
		{  
			type = 3;  
			ptr++;  
		}  

		/* Skip digit */  
		while (type == 3 && base == 10 && isdigit(*ptr)) 
		{  
			ptr++;  
		}  

		/* if end with 0, it is number */  
		if (*ptr == 0)
		{
			//return (type > 0 ) ? type : 1;
			type = (type >0 ) ? type : 1;
		}
		else 
		{
			type = 0;
		}
	}
	return type;
}

String CStrMe::Replace( const String& str, const String& src, const String& dest )
{
	String newStr = str;
	String::size_type pos = 0;
	while( (pos = newStr.find(src, pos)) != string::npos )
	{
		newStr.replace(pos, src.length(), dest);
		pos += dest.length();
	}
	return newStr;
}

vector<String> CStrMe::Split( const String& str, const String& pattern )
{
	int pos = -1;
	vector<String> result;
	String newStr = str;
	newStr += pattern;
	int size = (int)str.size();
	for(int i = 0; i < size; i++)
	{
		pos = (int)newStr.find(pattern, i);
		if((int)pos <= size)
		{
			String s = newStr.substr(i, pos - i);
			if(s.length() > 0)
			{
				result.push_back(s);
			}
			i = pos + (int)pattern.size() - 1;
		}
	}
	return result;
}

vector<String> CStrMe::Split(const String& str, const vector<String>& patterns)
{
	int pos = -1;
	vector<String> result;
	int pattenSize = (int)patterns.size();
	if (pattenSize == 0)
	{
		result.push_back(str);
		return result;
	}
	int i = 0;
	int strSize = (int)str.size();
	while (i != strSize)
	{
		int flag = 0;
		while (i != strSize && flag == 0)
		{
			flag = 1;
			for (int x = 0; x < pattenSize; ++x)
			{
				String patten = patterns[x];
				if (str[i] == patten[0])
				{
					++i;
					flag = 0;
					break;
				}
			}
		}
		flag = 0;
		int j = i;
		while (j != strSize && flag == 0)
		{
			for (int x = 0; x < pattenSize; ++x)
			{
				String patten = patterns[x];
				if (str[j] == patten[0])
				{
					flag = 1;
					break;
				}
			}
			if (flag == 0)
			{
				++j;
			}
		}
		if (i != j)
		{
			result.push_back(str.substr(i, j - i));
			i = j;
		}
	}
	return result;
}

void CStrMe::stringTowstring( String &strDest, const string& strSrc )
{
    int size_s = (int)strSrc.length();
    if (size_s == 0)
    {
        return;
    }
    int size_d = size_s * 2;
    wchar_t *des = new wchar_t[size_d];
    memset(des, 0, size_d * sizeof(wchar_t));
    
    int s = 0, d = 0;
    bool toomuchbyte = true;
    
    while (s < size_s && d < size_d)
    {
        unsigned char c = strSrc[s];
        if ((c & 0x80) == 0)
        {
            des[d++] += strSrc[s++];
        }
        else if((c & 0xE0) == 0xC0)  ///< 110x-xxxx 10xx-xxxx
        {
            wchar_t &wideChar = des[d++];
            wideChar  = (strSrc[s + 0] & 0x3F) << 6;
            wideChar |= (strSrc[s + 1] & 0x3F);
            
            s += 2;
        }
        else if((c & 0xF0) == 0xE0)  ///< 1110-xxxx 10xx-xxxx 10xx-xxxx
        {
            wchar_t &wideChar = des[d++];
            
            wideChar  = (strSrc[s + 0] & 0x1F) << 12;
            wideChar |= (strSrc[s + 1] & 0x3F) << 6;
            wideChar |= (strSrc[s + 2] & 0x3F);
            
            s += 3;
        }
        else if((c & 0xF8) == 0xF0)  ///< 1111-0xxx 10xx-xxxx 10xx-xxxx 10xx-xxxx
        {
            wchar_t &wideChar = des[d++];
            
            wideChar  = (strSrc[s + 0] & 0x0F) << 18;
            wideChar  = (strSrc[s + 1] & 0x3F) << 12;
            wideChar |= (strSrc[s + 2] & 0x3F) << 6;
            wideChar |= (strSrc[s + 3] & 0x3F);
            
            s += 4;
        }
        else
        {
            wchar_t &wideChar = des[d++]; ///< 1111-10xx 10xx-xxxx 10xx-xxxx 10xx-xxxx 10xx-xxxx
            
            wideChar  = (strSrc[s + 0] & 0x07) << 24;
            wideChar  = (strSrc[s + 1] & 0x3F) << 18;
            wideChar  = (strSrc[s + 2] & 0x3F) << 12;
            wideChar |= (strSrc[s + 3] & 0x3F) << 6;
            wideChar |= (strSrc[s + 4] & 0x3F);
            s += 5;
        }
    }
    
    strDest = des;
    delete[] des;
    des = NULL;
    
    return;
}

String CStrMe::ToLower( const String& str )
{
    String lowerStr = str;
    transform(lowerStr.begin(), lowerStr.end(), lowerStr.begin(), ::tolower);
    return lowerStr;
}

String CStrMe::ToUpper( const String& str )
{
    String upperStr = str;
    transform(upperStr.begin(), upperStr.end(), upperStr.begin(), ::toupper);
    return upperStr;

}

void CStrMe::wstringTostring( string &strDest, const String& strSrc )
{
#if TARGET_RT_BIG_ENDIAN
    const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32BE);
#else
    const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32LE);
#endif
    @autoreleasepool {
        char* data = (char*)strSrc.data();
        unsigned size = strSrc.size() * sizeof(wchar_t);
        NSString* result = [[NSString alloc] initWithBytes:data length:size encoding:kEncoding_wchar_t];
        strDest = [result UTF8String];
    }
}

bool CStrMe::ValueEqual( const float &lhs, const float &rhs )
{
	return lhs - rhs >= -0.000001 && lhs - rhs <= 0.000001;
}

bool CStrMe::ValueEqual( const double &lhs, const double &rhs )
{
	return lhs - rhs >= -0.000001 && lhs - rhs <= 0.000001;
}

bool CStrMe::startswith(const string& str, const string& start)
{
	int srclen = (int)str.size();
	int startlen = (int)start.size();
	if(srclen >= startlen)
	{
		string temp = str.substr(0, startlen);
		if(temp == start)
		{
			return true;
		}
	}
	return false;
}

bool CStrMe::startswith(const wstring& wstr, const wstring& wstart)
{
	string str = "";
	string start = "";
	CStrMe::wstringTostring(str, wstr);
	CStrMe::wstringTostring(start, wstart);
	return startswith(str, start);
}

bool CStrMe::endswith(const string& str, const string& end)
{    
	int srclen = (int)str.size();
	int endlen = (int)end.size();
	if(srclen >= endlen)
	{
		string temp = str.substr(srclen - endlen, endlen);
		if(temp == end)
		{
			return true;
		}
	}
	return false;
}

bool CStrMe::endswith(const wstring& wstr, const wstring& wend)
{
	string str = "";
	string end = "";
	CStrMe::wstringTostring(str, wstr);
	CStrMe::wstringTostring(end, wend);
	return endswith(str, end);
}

string CStrMe::trim(const string& str)
{    
	string ret;
	//find the first position of not start with space or '\t'
	string::size_type pos_begin = str.find_first_not_of(" \t");
	if(pos_begin == string::npos)
	{
		return str;
	}
	//find the last position of end with space or '\t'
	string::size_type pos_end = str.find_last_not_of(" \t");
	if(pos_end == string::npos)
	{
		return str;
	}
	ret = str.substr(pos_begin, pos_end-pos_begin);
	return ret;
}

wstring CStrMe::trim(const wstring& wstr)
{
	string str = "";
	CStrMe::wstringTostring(str, wstr);
	string result = CStrMe::trim(str);
	String wResult = L"";
	CStrMe::stringTowstring(wResult, result);
	return wResult;
}

