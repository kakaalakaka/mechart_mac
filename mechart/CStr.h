/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CSTRME_H__
#define __CSTRME_H__
#pragma once
#include "stdafx.h"
#include "CPaint.h"
#include "CControl.h"
#include "CMathLib.h"

namespace MeLib
{
	class CStrMe
	{
	public:
        static double round(double x);
        static void Contact(wchar_t *str, const wchar_t *str1, const wchar_t *str2, const wchar_t *str3);
        static String ConvertAnchorToStr(const ANCHOR& anchor);
		static String ConvertBoolToStr(bool value);
		static String ConvertColorToStr(_int64 color);
		static String ConvertContentAlignmentToStr(ContentAlignmentA contentAlignment);
		static String ConvertCursorToStr(CursorsA cursor);
		static String ConvertDoubleToStr(double value);
		static String ConvertDockToStr(DockStyleA dock);
		static String ConvertFloatToStr(float value);
		static String ConvertFontToStr(FONT *font);
		static String ConvertHorizontalAlignToStr(HorizontalAlignA horizontalAlign);
		static String ConvertIntToStr(int value);
		static String ConvertLayoutStyleToStr(LayoutStyleA layoutStyle);
        static String ConvertLongToStr(_int64 value);
		static String ConvertPaddingToStr(const PADDING& padding);
		static String ConvertPointToStr(const POINT& mp);
		static String ConvertRectToStr(const RECT& rect);
		static String ConvertSizeToStr(const SIZE& size);
        static ANCHOR ConvertStrToAnchor(const String& str);
		static bool ConvertStrToBool(const String& str);
		static _int64 ConvertStrToColor(const String& str);
		static ContentAlignmentA ConvertStrToContentAlignment(const String& str);
		static CursorsA ConvertStrToCursor(const String& str);
		static DockStyleA ConvertStrToDock(const String& str);
		static double ConvertStrToDouble(const String& str);
        static double ConvertStrToDouble(const wchar_t *str);
		static float ConvertStrToFloat(const String& str);
		static FONT* ConvertStrToFont(const String& str);
		static HorizontalAlignA ConvertStrToHorizontalAlign(const String& str);
		static int ConvertStrToInt(const String& str);
        static int ConvertStrToInt(const wchar_t *str);
		static LayoutStyleA ConvertStrToLayoutStyle(const String& str);
        static _int64 ConvertStrToLong(const String& str);
        static _int64 ConvertStrToLong(const wchar_t *str);
		static PADDING ConvertStrToPadding(const String& str);
		static POINT ConvertStrToPoint(const String& str);
		static RECT ConvertStrToRect(const String& str);
		static SIZE ConvertStrToSize(const String& str);
        static VerticalAlignA ConvertStrToVerticalAlign(const String& str);
        static String ConvertVerticalAlignToStr(VerticalAlignA verticalAlign);
        static String GetFormatDate(const String& format, int year, int month, int day, int hour, int minute, int second);
		static void GetValueByDigit(double value, int digit, wchar_t *str);
		static void GetFormatDate(double date, wchar_t *str);
		static int HexToDec(const char *str, int length);
        static bool IsBlank(int c);
        static int IsNumeric(const string& str);
		static String Replace(const String& str, const String& src, const String& dest);
		static float SafeDoubleToFloat(double value, int digit);
		static vector<String> Split(const String& str, const String& pattern);
        static vector<String> Split(const String& str, const vector<String>& patterns);
		static void stringTowstring(String &strDest, const string& strSrc);
		static String ToLower(const String& str);
		static String ToUpper(const String& str);
		static void wstringTostring(string &strDest, const String& strSrc);
        static bool ValueEqual( const float &lhs, const float &rhs );
        static bool ValueEqual( const double &lhs, const double &rhs );
        static bool startswith(const string& str, const string& start);
        static bool startswith(const wstring& wstr, const wstring& wstart);
        static bool endswith(const string& str, const string& end);
        static bool endswith(const wstring& wstr, const wstring& wend);
        static string trim(const string& str);
        static wstring trim(const wstring& wstr);
	};
}
#endif
