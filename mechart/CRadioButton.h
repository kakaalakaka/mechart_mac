/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CRADIOBUTTONME_H__
#define __CRADIOBUTTONME_H__
#pragma once
#include "stdafx.h"
#include "CStr.h"
#include "CControl.h"
#include "CCheckBox.h"

namespace MeLib
{
	class CRadioButtonMe:public CCheckBoxMe
	{
	protected:
		String m_groupName;
	public:
		CRadioButtonMe();
		virtual ~CRadioButtonMe();
		virtual String GetGroupName();
		virtual void SetGroupName(const String& groupName);
	public:
		virtual String GetControlType();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnClick(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaintCheckButton(CPaintMe *paint, const RECT& clipRect);
		virtual void SetProperty(const String& name, const String& value);
		virtual void Update();
	};
}

#endif
