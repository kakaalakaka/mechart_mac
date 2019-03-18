/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CWINDOWFRAMEME_H__
#define __CWINDOWFRAMEME_H__
#pragma once
#include "stdafx.h"
#include "CWindow.h"

namespace MeLib
{
	class CWindowFrameMe : public CControlMe
	{
	protected:
	public:
		CWindowFrameMe();
		virtual ~CWindowFrameMe();
	public:
		virtual bool ContainsPoint(const POINT& point);
		virtual String GetControlType();
		virtual void Invalidate();
		virtual void OnPaintBackground(CPaintMe *paint, const RECT& clipRect);
	};
}
#endif
