/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CHSCROLLBARME_H__
#define __CHSCROLLBARME_H__
#pragma once
#include "stdafx.h"
#include "CScrollBar.h"

namespace MeLib
{
	class CHScrollBarMe:public CScrollBarMe
	{
	protected:
        ControlMouseEvent m_backButtonMouseDownEvent;
		ControlMouseEvent m_backButtonMouseUpEvent;
		static void BackButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
		static void BackButtonMouseUp(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
	public:
		CHScrollBarMe();
		virtual ~CHScrollBarMe();
		virtual String GetControlType();
		void OnBackButtonMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		void OnBackButtonMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnDragScroll();
		virtual void OnLoad();
		virtual void Update();
	};
}

#endif
