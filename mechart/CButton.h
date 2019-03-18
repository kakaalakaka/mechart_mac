/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CBUTTONME_H__
#define __CBUTTONME_H__
#pragma once
#include "stdafx.h"
#include "CStr.h"

namespace MeLib
{
	class CButtonMe:public CControlMe
	{
	protected:
		String m_disabledBackImage;
		String m_hoveredBackImage;
		String m_pushedBackImage;
		ContentAlignmentA m_textAlign;
	protected:
		virtual _int64 GetPaintingBackColor();
		virtual String GetPaintingBackImage();
	public:
		CButtonMe();
		virtual ~CButtonMe();
		virtual String GetDisabledBackImage();
		virtual void SetDisabledBackImage(const String& disabledBackImage);
		virtual String GetHoveredBackImage();
		virtual void SetHoveredBackImage(const String& hoveredBackImage);
		virtual String GetPushedBackImage();
		virtual void SetPushedBackImage(const String& pushedBackImage);
		virtual ContentAlignmentA GetTextAlign();
		virtual void SetTextAlign(ContentAlignmentA textAlign);
	public:
		virtual String GetControlType();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseEnter(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseLeave(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
		virtual void SetProperty(const String& name, const String& value);
	};
}

#endif
