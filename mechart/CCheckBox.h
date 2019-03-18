/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CCHECKBOXME_H__
#define __CCHECKBOXME_H__
#pragma once
#include "stdafx.h"
#include "CStr.h"
#include "CButton.h"

namespace MeLib
{
	class CCheckBoxMe : public CButtonMe
	{
	protected:
		HorizontalAlignA m_buttonAlign;
		_int64 m_buttonBackColor;
		_int64 m_buttonBorderColor;
		SIZE m_buttonSize;
		bool m_checked;
		String m_checkedBackImage;
		String m_checkHoveredBackImage;
		String m_checkPushedBackImage;
		String m_disableCheckedBackImage;
	protected:
		virtual _int64 GetPaintingBackColor();
		virtual _int64 GetPaintingButtonBackColor();
		virtual _int64 GetPaintingButtonBorderColor();
		virtual String GetPaintingBackImage();
	public:
		CCheckBoxMe();
		virtual ~CCheckBoxMe();
		virtual HorizontalAlignA GetButtonAlign();
		virtual void SetButtonAlign(HorizontalAlignA buttonAlign);
		virtual _int64 GetButtonBackColor();
		virtual void SetButtonBackColor(_int64 buttonBackColor);
		virtual _int64 GetButtonBorderColor();
		virtual void SetButtonBorderColor(_int64 buttonBorderColor);
		virtual SIZE GetButtonSize();
		virtual void SetButtonSize(SIZE buttonSize);
		virtual bool IsChecked();
		virtual void SetChecked(bool checked);
		virtual String GetCheckedBackImage();
		virtual void SetCheckedBackImage(const String& checkedBackImage);
		virtual String GetCheckHoveredBackImage();
		virtual void SetCheckHoveredBackImage(const String& checkHoveredBackImage);
		virtual String GetCheckPushedBackImage();
		virtual void SetCheckPushedBackImage(const String& checkPushedBackImage);
		virtual String GetDisableCheckedBackImage();
		virtual void SetDisableCheckedBackImage(const String& disableCheckedBackImage);
	public:
		virtual String GetControlType();
        virtual vector<String> GetEventNames();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnCheckedChanged();
		virtual void OnClick(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaintBackground(CPaintMe *paint, const RECT& clipRect);
		virtual void OnPaintCheckButton(CPaintMe *paint, const RECT& clipRect);
		virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
		virtual void SetProperty(const String& name, const String& value);
	};
}

#endif
