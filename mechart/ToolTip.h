/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __TOOLTIP_H__
#define __TOOLTIP_H__
#pragma once
#include "stdafx.h"
#include "CLabel.h"

namespace MeLib
{
    class ToolTipMe : public CLabelMe
    {
    private:
        int m_timerID;
    protected:
        int m_autoPopDelay;
        int m_initialDelay;
        POINT m_lastMousePoint;
        bool m_showAlways;
        bool m_useAnimation;
    protected:
        int m_remainAutoPopDelay;
        int m_remainInitialDelay;
    public:
        ToolTipMe();
        virtual ~ToolTipMe();
        virtual int GetAutoPopDelay();
        virtual void SetAutoPopDelay(int autoPopDelay);
        virtual int GetInitialDelay();
        virtual void SetInitialDelay(int initialDelay);
        virtual bool ShowAlways();
        virtual void SetShowAlways(bool showAlways);
        virtual bool UseAnimation();
        virtual void SetUseAnimation(bool useAnimation);
    public:
        virtual String GetControlType();
        virtual void GetProperty(const String& name, String *value, String *type);
        virtual vector<String> GetPropertyNames();
        virtual void Hide();
        virtual void OnLoad();
        virtual void OnTimer(int timerID);
        virtual void OnVisibleChanged();
        virtual void Show();
        virtual void SetProperty(const String& name, const String& value);
    };
}

#endif
