/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CGROUPBOXME_H__
#define __CGROUPBOXME_H__
#pragma once
#include "stdafx.h"
#include "Div.h"

namespace MeLib
{
    class CGroupBoxMe : public DivMe
    {
    public:
        CGroupBoxMe();
        virtual ~CGroupBoxMe();
    public:
        virtual String GetControlType();
        virtual void OnPaintBorder(CPaintMe *paint, const RECT& clipRect);
        virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
};
}
#endif
