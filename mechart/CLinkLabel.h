/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CLINKLABELME_H__
#define __CLINKLABELME_H__
#pragma once
#include "stdafx.h"
#include "CLabel.h"

namespace MeLib
{
    enum LinkBehaviorA
	{
		LinkBehaviorA_AlwaysUnderLine,
		LinkBehaviorA_HoverUnderLine,
		LinkBehaviorA_NeverUnderLine
	};
    
	class CLabelMe;
    
	class CLinkLabelMe : public CLabelMe
	{
	protected:
		_int64 m_activeLinkColor;
		_int64 m_disabledLinkColor;
		LinkBehaviorA m_linkBehavior;
		_int64 m_linkColor;
		bool m_linkVisited;
		bool m_visited;
		_int64 m_visitedLinkColor;
	protected:
		virtual _int64 GetPaintingLinkColor();
	public:
		CLinkLabelMe();
		virtual ~CLinkLabelMe();
		virtual _int64 GetActiveLinkColor();
		virtual void SetActiveLinkColor(_int64 activeLinkColor);
		virtual _int64 GetDisabledLinkColor();
		virtual void SetDisabledLinkColor(_int64 disabledLinkColor);
		virtual LinkBehaviorA GetLinkBehavior();
		virtual void SetLinkBehavior(LinkBehaviorA linkBehavior);
		virtual _int64 GetLinkColor();
		virtual void SetLinkColor(_int64 linkColor);
		virtual bool IsLinkVisited();
		virtual void SetLinkVisited(bool linkVisited);
		virtual _int64 GetVisitedLinkColor();
		virtual void SetVisitedLinkColor(_int64 visitedLinkColor);
	public:
		virtual String GetControlType();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void OnClick(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseEnter(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseLeave(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
		virtual void SetProperty(const String& name, const String& value);
	};
}
#endif
