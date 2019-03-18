/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __ENUMS_H__
#define __ENUMS_H__
#pragma once
#include "stdafx.h"

namespace MeLib
{
    enum ActionType
	{
		ActionType_AT1 = 1,
		ActionType_AT2 = 2,
		ActionType_AT3 = 3,
		ActionType_AT4 = 4,
		ActionType_MOVE = 0,
		ActionType_NO = -1
	};
    
	enum AttachVScale
	{
		AttachVScale_Left,
		AttachVScale_Right
	};
    
	enum BarStyle
	{
		BarStyle_Line,
		BarStyle_Rect
	};
    
	enum CandleStyle
	{
		CandleStyle_American,
		CandleStyle_CloseLine,
		CandleStyle_Rect,
		CandleStyle_Tower
	};
    
	enum CrossLineMoveMode
	{
		CrossLineMoveMode_AfterClick,
		CrossLineMoveMode_FollowMouse
	};
    
	enum DateType
	{
		DateType_Day = 2,
		DateType_Hour = 3,
		DateType_Millisecond = 6,
		DateType_Minute = 4,
		DateType_Month = 1,
		DateType_Second = 5,
		DateType_Year = 0
	};
    
	enum HScaleType
	{
		HScaleType_Date,
		HScaleType_Number
	};
    
	enum NumberStyle
	{
		NumberStyle_Standard,
		NumberStyle_Underline
	};
    
	enum PolylineStyle
	{
		PolylineStyle_Cycle,
		PolylineStyle_DashLine,
		PolylineStyle_DotLine,
		PolylineStyle_SolidLine
	};
    
	enum ScrollType
	{
		ScrollType_None,
		ScrollType_Left,
		ScrollType_Right,
		ScrollType_ZoomIn,
		ScrollType_ZoomOut
	};
    
	enum SelectPoint
	{
		SelectPoint_Ellipse,
		SelectPoint_Rect
	};
    
	enum TextMode
	{
		TextMode_Field,
		TextMode_Full,
		TextMode_None,
		TextMode_Value
	};
    
	enum VScaleSystem
	{
		VScaleSystem_Logarithmic,
		VScaleSystem_Standard
	};
    
	enum VScaleType
	{
		VScaleType_Divide,
		VScaleType_EqualDiff,
		VScaleType_EqualRatio,
		VScaleType_GoldenRatio,
		VScaleType_Percent
	};
}
#endif
