/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CMENUITEMME_H__
#define __CMENUITEMME_H__
#pragma once
#include "stdafx.h"
#include "CButton.h"
#include "CMenu.h"

namespace MeLib
{
	class CMenuMe;
    
	class CMenuItemMe : public CButtonMe
	{
	protected:
		bool m_checked;
		CMenuMe *m_dropDownMenu;
		CMenuItemMe *m_parentItem;
		CMenuMe *m_parentMenu;
		String m_value;
	public:
		vector<CMenuItemMe*> m_items;
		CMenuItemMe();
		CMenuItemMe(const String& text);
		virtual ~CMenuItemMe();
		virtual bool IsChecked();
		virtual void SetChecked(bool checked);
		virtual CMenuMe* GetDropDownMenu();
		virtual void SetDropDownMenu(CMenuMe *dropDownMenu);
		virtual CMenuItemMe* GetParentItem();
		virtual void SetParentItem(CMenuItemMe *parentItem);
		virtual CMenuMe* GetParentMenu();
		virtual void SetParentMenu(CMenuMe *parentMenu);
		virtual String GetValue();
		virtual void SetValue(const String& value);
	public:
		void AddItem(CMenuItemMe *item);
		void ClearItems();
		virtual String GetControlType();
		vector<CMenuItemMe*> GetItems();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		void InsertItem(int index, CMenuItemMe *item);
		virtual void OnAddingItem(int index);
		virtual void OnClick(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseMove(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
		virtual void OnRemovingItem();
		void RemoveItem(CMenuItemMe *item);
		virtual void SetProperty(const String& name, const String& value);
	};
}

#endif
