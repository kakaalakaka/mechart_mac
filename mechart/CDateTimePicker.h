/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CDATETIMEPICKERME_H__
#define __CDATETIMEPICKERME_H__
#pragma once
#include "stdafx.h"
#include "CTextBox.h"
#include "CButton.h"
#include "CMenu.h"
#include "CMenuItem.h"
#include "CCalendar.h"

namespace MeLib
{
    class DateTimePickerMe : public CTextBoxMe
    {
    protected:
        CCalendarMe *m_calendar;
        String m_customFormat;
        CButtonMe *m_dropDownButton;
        ControlMouseEvent m_dropDownButtonMouseDownEvent;
		CMenuMe *m_dropDownMenu;
        ControlEvent m_selectedTimeChangedEvent;
		bool m_showTime;
        static void DropDownButtonMouseDown(void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke);
        static void SelectedTimeChanged(void *sender, void *pInvoke);
    public:
        DateTimePickerMe();
        virtual ~DateTimePickerMe();
        virtual CCalendarMe* GetCalendar();
        virtual String GetCustomFormat();
        virtual void SetCustomFormat(const String& customFormat);
        virtual CButtonMe* GetDropDownButton();
        virtual CMenuMe* GetDropDownMenu();
		virtual bool ShowTime();
		virtual void SetShowTime(bool showTime);
    public:
        virtual String GetControlType();
        virtual void GetProperty(const String& name, String *value, String *type);
        virtual vector<String> GetPropertyNames();
        virtual void OnDropDownOpening();
        virtual void OnLoad();
        virtual void OnSelectedTimeChanged();
        virtual void SetProperty(const String& name, const String& value);
        virtual void Update();
    };
}

#endif
