/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CSPINME_H__
#define __CSPINME_H__
#pragma once
#include "stdafx.h"
#include "CStr.h"
#include "CTextBox.h"
#include "CButton.h"

namespace MeLib
{
    class CSpinMe : public CTextBoxMe
    {
    private:
        int m_timerID;
        int m_tick;
    protected:
        bool m_autoFormat;
        int m_digit;
        CButtonMe *m_downButton;
        ControlMouseEvent m_downButtonMouseDownEvent;
        ControlMouseEvent m_downButtonMouseUpEvent;
        bool m_isAdding;
        bool m_isReducing;
        double m_maximum;
        double m_minimum;
        bool m_showThousands;
        double m_step;
        CButtonMe *m_upButton;
        ControlMouseEvent m_upButtonMouseDownEvent;
        ControlMouseEvent m_upButtonMouseUpEvent;
        static void DownButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void DownButtonMouseUp(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void UpButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void UpButtonMouseUp(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
    public:
        CSpinMe();
        virtual ~CSpinMe();
        virtual bool AutoFormat();
        virtual void SetAutoFormat(bool autoFormat);
        virtual int GetDigit();
        virtual void SetDigit(int digit);
        virtual CButtonMe* GetDownButton();
        virtual bool IsAdding();
        virtual void SetIsAdding(bool isAdding);
        virtual bool IsReducing();
        virtual void SetIsReducing(bool isReducing);
        virtual double GetMaximum();
        virtual void SetMaximum(double maximum);
        virtual double GetMinimum();
        virtual void SetMinimum(double minimum);
        virtual bool ShowThousands();
        virtual void SetShowThousands(bool showThousands);
        virtual double GetStep();
        virtual void SetStep(double step);
        virtual void SetText(const String& text);
        virtual CButtonMe* GetUpButton();
        virtual double GetValue();
        virtual void SetValue(double value);
    public:
        void Add();
        String FormatNum(String inputText);
        virtual String GetControlType();
        virtual vector<String> GetEventNames();
        virtual void GetProperty(const String& name, String *value, String *type);
        virtual vector<String> GetPropertyNames();
        String GetValueByDigit(double value, int digit);
        virtual void OnChar(wchar_t ch);
        virtual void OnKeyDown(char key);
        virtual void OnLoad();
        virtual void OnMouseWheel(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnPaste();
        virtual void OnTimer(int timerID);
        virtual void OnValueChanged();
        void Reduce();
        virtual void SetProperty(const String& name, const String& value);
        void SetRegion();
        virtual void Update();
    };
}

#endif
