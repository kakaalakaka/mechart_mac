/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CSPLITLAYOUTDIVME_H__
#define __CSPLITLAYOUTDIVME_H__
#pragma once
#include "stdafx.h"
#include "CButton.h"
#include "Div.h"
#include "CLayoutDiv.h"
#include "CTableLayoutDiv.h"

namespace MeLib
{
	class CSplitLayoutDivMe : public CLayoutDivMe
	{
	protected:
		CControlMe *m_firstControl;
		SIZE m_oldSize;
		CControlMe *m_secondControl;
		SizeTypeA m_splitMode;
		float m_splitPercent;
		CButtonMe *m_splitter;
		ControlEvent m_splitterDraggingEvent;
		static void SplitterDragging(void *sender, void *pInvoke);
	public:
		CSplitLayoutDivMe();
		virtual ~CSplitLayoutDivMe();
		virtual CControlMe* GetFirstControl();
		virtual void SetFirstControl(CControlMe *firstControl);
		virtual CControlMe* GetSecondControl();
		virtual void SetSecondControl(CControlMe *secondControl);
		virtual SizeTypeA GetSplitMode();
		virtual void SetSplitMode(SizeTypeA splitMode);
		virtual CButtonMe* GetSplitter();
	public:
		virtual String GetControlType();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		void OnSplitterDragging();
		virtual void OnLoad();
		virtual bool OnResetLayout();
		virtual void Update();
		virtual void SetProperty(const String& name, const String& value);
	};
}

#endif
