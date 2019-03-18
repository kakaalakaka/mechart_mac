/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CCOMBOBOXME_H__
#define __CCOMBOBOXME_H__
#pragma once
#include "stdafx.h"
#include "CTextBox.h"
#include "CButton.h"
#include "CMenu.h"
#include "CMenuItem.h"

namespace MeLib
{
	class CComboBoxMe;
    
	class CComboBoxMenuMe : public CMenuMe
	{
	protected:
		CComboBoxMe *m_comboBox;
	public:
		CComboBoxMenuMe();
		virtual ~CComboBoxMenuMe();
		CComboBoxMe* GetComboBox();
		void SetComboBox(CComboBoxMe *comboBox);
		virtual bool OnAutoHide();
	};
    
	class CComboBoxMe : public CTextBoxMe
	{
	protected:
		CButtonMe* m_dropDownButton;
		ControlMouseEvent m_dropDownButtonMouseDownEvent;
		MenuItemMouseEvent m_menuItemClickEvent;
		CComboBoxMenuMe* m_dropDownMenu;
		static void DropDownButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
		static void MenuItemClick(void *sender, CMenuItemMe *item, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
	public:
		CComboBoxMe();
		virtual ~CComboBoxMe();
		virtual CButtonMe* GetDropDownButton();
		virtual CComboBoxMenuMe* GetDropDownMenu();
		virtual int GetSelectedIndex();
		virtual void SetSelectedIndex(int selectedIndex);
		virtual String GetSelectedText();
		virtual void SetSelectedText(const String& selectedText);
		virtual String GetSelectedValue();
		virtual void SetSelectedValue(const String& selectedValue);
	public:
		void AddItem(CMenuItemMe *item);
		void ClearItems();
		virtual String GetControlType();
        virtual vector<String> GetEventNames();
		vector<CMenuItemMe*> GetItems();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		void InsertItem(int index, CMenuItemMe *item);
        virtual void OnDropDownOpening();
        virtual void OnKeyDown(char key);
		virtual void OnLoad();
		virtual void OnSelectedIndexChanged();
		void RemoveItem(CMenuItemMe *item);
		virtual void SetProperty(const String& name, const String& value);
		virtual void Update();
	};
}

#endif
