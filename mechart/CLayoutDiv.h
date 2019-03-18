/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CLAYOUTDIVME_H__
#define __CLAYOUTDIVME_H__
#pragma once
#include "stdafx.h"
#include "CButton.h"
#include "Div.h"

namespace MeLib
{
    class CLayoutDivMe : public DivMe
    {
    protected:
        bool m_autoWrap;
        LayoutStyleA m_layoutStyle;
    public:
        CLayoutDivMe();
        virtual ~CLayoutDivMe();
        virtual bool AutoWrap();
        virtual void SetAutoWrap(bool autoWrap);
        virtual LayoutStyleA GetLayoutStyle();
        virtual void SetLayoutStyle(LayoutStyleA layoutStyle);
    public:
        virtual String GetControlType();
        virtual void GetProperty(const String& name, String *value, String *type);
        virtual vector<String> GetPropertyNames();
        virtual bool OnResetLayout();
        virtual void SetProperty(const String& name, const String& value);
        virtual void Update();
    };
}

#endif
