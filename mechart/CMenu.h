/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CMENUME_H__
#define __CMENUME_H__
#pragma once
#include "stdafx.h"
#include "CLayoutDiv.h"
#include "CMenuItem.h"

namespace MeLib
{
	class CMenuItemMe;
    
	typedef void (*MenuItemMouseEvent)(void*, CMenuItemMe*, const POINT& mp, MouseButtonsA button, int clicks, int delta, void*);
    
	class CMenuMe : public CLayoutDivMe
	{
    private:
       int m_timerID;
	protected:
        bool m_autoHide;
		CMenuItemMe *m_parentItem;
		bool m_popup;
		void Adjust(CMenuMe *menu);
		bool CheckDivFocused(vector<CMenuItemMe*> items);
		bool CheckFocused(CControlMe *control);
		bool CloseMenus(vector<CMenuItemMe*> items);
	protected:
		void CallMenuItemMouseEvent(int eventID, CMenuItemMe *item, const POINT& mp, MouseButtonsA button, int clicks, int delta);
	public:
		vector<CMenuItemMe*> m_items;
		CMenuMe();
		virtual ~CMenuMe();
        bool AutoHide();
        void SetAutoHide(bool autoHide);
		virtual CMenuItemMe* GetParentItem();
		virtual void SetParentItem(CMenuItemMe *parentItem);
		virtual bool IsPopup();
		virtual void SetPopup(bool popup);
	public:
		void AddItem(CMenuItemMe *item);
		void ClearItems();
		virtual CMenuMe* CreateDropDownMenu();
		virtual String GetControlType();
        virtual vector<String> GetEventNames();
		vector<CMenuItemMe*> GetItems();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		void InsertItem(int index, CMenuItemMe *item);
		virtual bool OnAutoHide();
		virtual void OnLoad();
		virtual void OnMenuItemClick(CMenuItemMe *item, const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMenuItemMouseMove(CMenuItemMe *item, const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnTimer(int timerID);
		virtual void OnVisibleChanged();
		void RemoveItem(CMenuItemMe *item);
		virtual void SetProperty(const String& name, const String& value);
	};
}

#endif
