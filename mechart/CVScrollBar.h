/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CVSCROLLBARME_H__
#define __CVSCROLLBARME_H__
#pragma once
#include "stdafx.h"
#include "CScrollBar.h"

namespace MeLib
{
	class CVScrollBarMe:public CScrollBarMe
	{
	protected:
        ControlMouseEvent m_backButtonMouseDownEvent;
		ControlMouseEvent m_backButtonMouseUpEvent;
		static void BackButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
		static void BackButtonMouseUp(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
	public:
		CVScrollBarMe();
		virtual ~CVScrollBarMe();
		virtual String GetControlType();
		void OnBackButtonMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		void OnBackButtonMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnDragScroll();
		virtual void OnLoad();
		virtual void Update();
	};
}

#endif
