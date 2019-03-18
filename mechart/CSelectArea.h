/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CSELECTAREAME_H__
#define __CSELECTAREAME_H__
#pragma once
#include "stdafx.h"
#include "CDiv.h"

namespace MeLib
{
    class CDivMe;
    
	class CSelectAreaMe : public CPropertyMe
	{
	protected:
		bool m_allowUserPaint;
		_int64 m_backColor;
		RECT m_bounds;
		bool m_canResize;
		bool m_enabled;
		_int64 m_lineColor;
		bool m_visible;
	public:
		CSelectAreaMe();
		virtual ~CSelectAreaMe();
		virtual bool AllowUserPaint();
		virtual void SetAllowUserPaint(bool allowUserPaint);
		virtual _int64 GetBackColor();
		virtual void SetBackColor(_int64 backColor);
		virtual RECT GetBounds();
		virtual void SetBounds(RECT bounds);
		virtual bool CanResize();
		virtual void SetCanResize(bool canResize);
		virtual bool IsEnabled();
		virtual void SetEnabled(bool enabled);
		virtual _int64 GetLineColor();
		virtual void SetLineColor(_int64 lineColor);
		virtual bool IsVisible();
		virtual void SetVisible(bool visible);
	public:
		virtual void Close();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnPaint(CPaintMe *paint, CDivMe *div, const RECT& rect);
		virtual void SetProperty(const String& name, const String& value);
        
	};
}
#endif
