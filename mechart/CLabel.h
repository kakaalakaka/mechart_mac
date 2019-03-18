/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CLABELME_H__
#define __CLABELME_H__
#pragma once
#include "stdafx.h"

namespace MeLib
{
	class CLabelMe : public CControlMe
	{
	protected:
		ContentAlignmentA m_textAlign;
	public:
		CLabelMe();
		virtual ~CLabelMe();
		virtual ContentAlignmentA GetTextAlign();
		virtual void SetTextAlign(ContentAlignmentA textAlign);
	public:
		virtual String GetControlType();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
		virtual void OnPrePaint(CPaintMe *paint, const RECT& clipRect);
		virtual void SetProperty(const String& name, const String& value);
	};
}
#endif
