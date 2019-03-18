/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CCROSSLINEME_H__
#define __CCROSSLINEME_H__
#pragma once
#include "stdafx.h"
#include "CDiv.h"
#include "Enums.h"

namespace MeLib
{
    class CDivMe;
    
	class CCrossLineMe : CPropertyMe
	{
	protected:
		bool m_allowDoubleClick;
		bool m_allowUserPaint;
		AttachVScale m_attachVScale;
		_int64 m_lineColor;
	public:
		CCrossLineMe();
		virtual ~CCrossLineMe();
		virtual bool AllowDoubleClick();
		virtual void SetAllowDoubleClick(bool allowDoubleClick);
		virtual bool AllowUserPaint();
		virtual void SetAllowUserPaint(bool allowUserPaint);
		virtual AttachVScale GetAttachVScale();
		virtual void SetAttachVScale(AttachVScale attachVScale);
		virtual _int64 GetLineColor();
		virtual void SetLineColor(_int64 lineColor);
	public:
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnPaint(CPaintMe *paint, CDivMe *div, const RECT& rect);
		virtual void SetProperty(const String& name, const String& value);
	};
}
#endif
