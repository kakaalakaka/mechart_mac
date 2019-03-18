/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CTABCONTROLME_H__
#define __CTABCONTROLME_H__
#pragma once
#include "stdafx.h"
#include "CStr.h"
#include "Div.h"
#include "CTabPage.h"

namespace MeLib
{
    enum TabPageLayout
	{
		TabPageLayout_Bottom,
		TabPageLayout_Left,
		TabPageLayout_Right,
		TabPageLayout_Top
	};
	
	class CTabPageMe;
    
	class CTabControlMe:public DivMe
	{
    private:
		int m_timerID;        
	protected:
		int m_animationState;
		TabPageLayout m_layout;
		int m_selectedIndex;

		bool m_useAnimation;
		void DrawMoving();
		int GetTabPageIndex(CTabPageMe *tabPage);
	public:
		vector<CTabPageMe*> m_tabPages;
		CTabControlMe();
		virtual ~CTabControlMe();
		virtual TabPageLayout GetLayout();
		virtual void SetLayout(TabPageLayout layout);
		virtual int GetSelectedIndex();
		virtual void SetSelectedIndex(int selectedIndex);
		virtual CTabPageMe* GetSelectedTabPage();
		virtual void SetSelectedTabPage(CTabPageMe *selectedTabPage);
		virtual bool UseAnimation();
		virtual void SetUseAnimation(bool useAnimation);
	public:
		virtual void AddControl(CControlMe *control);
        virtual void ClearControls();
		virtual String GetControlType();
        virtual vector<String> GetEventNames();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void InsertControl(int index, CControlMe *control);
        virtual void OnDragTabHeaderBegin(CTabPageMe *tabPage);
        virtual void OnDragTabHeaderEnd(CTabPageMe *tabPage);
        virtual void OnDraggingTabHeader(CTabPageMe *tabPage);
		virtual void OnLoad();
		virtual void OnSelectedTabPageChanged();
		virtual void OnTimer(int timerID);
		virtual void RemoveControl(CControlMe *control);
		virtual void SetProperty(const String& name, const String& value);
		virtual void Update();
	};
}

#endif
