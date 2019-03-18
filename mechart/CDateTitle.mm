#include "stdafx.h"
#include "CDateTitle.h"
using namespace MeLib;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CDateTitleMe::CDateTitleMe(CCalendarMe *calendar)
{
    m_calendar = calendar;
    SetBackColor(COLOR_EMPTY);
    SetBorderColor(COLOR_EMPTY);
    FONT font(L"Simsun", 22, true, false, false);
    SetFont(&font);
    SIZE size = {180, 30};
    SetSize(size);
}

CDateTitleMe::~CDateTitleMe()
{
    m_calendar = 0;
}

CCalendarMe* CDateTitleMe::GetCalendar()
{
    return m_calendar;
}

void CDateTitleMe::SetCalendar(CCalendarMe *calendar)
{
    m_calendar = calendar;
}

String CDateTitleMe::GetControlType()
{
    return L"CDateTitleMe";
}

void CDateTitleMe::OnClick(const POINT& mp, MouseButtonsA button, int clicks, int delta)
{
    CButtonMe::OnClick(mp, button, clicks, delta);
    if (m_calendar)
    {
        switch (m_calendar->GetMode())
        {
            case CalendarMode_Day:
                m_calendar->SetMode(CalendarMode_Month);
                break;
                
            case CalendarMode_Month:
                m_calendar->SetMode(CalendarMode_Year);
                break;
        }
        m_calendar->Update();
        m_calendar->Invalidate();
    }
}

void CDateTitleMe::OnPaintForeground(CPaintMe *paint, const RECT& clipRect)
{
    if (m_calendar)
    {
        int width = GetWidth();
        int height = GetHeight();
        FONT *font = GetFont();
        wchar_t charText[100] = {0};
        switch (m_calendar->GetMode())
        {
            case CalendarMode_Day:
            {
                CMonthMe *month = m_calendar->GetMonth();
                swprintf(charText, 99, L"%d年%d月", month->GetYear(), month->GetMonth());
                break;
            }
            case CalendarMode_Month:
                swprintf(charText, 99, L"%d年", m_calendar->GetMonthDiv()->GetYear());
                break;
            case CalendarMode_Year:
            {
                int startYear = m_calendar->GetYearDiv()->GetStartYear();
                swprintf(charText, 99, L"%d年 - %d年", startYear, startYear + 12);
                break;
            }
        }
        String text(charText);
        SIZE size = paint->TextSize(text.c_str(), font);
        RECT rect;
        rect.left = (width - size.cx) / 2;
        rect.top = (height - size.cy) / 2;
        rect.right = rect.left + size.cx + 1;
        rect.bottom = rect.top + size.cy + 1;
        paint->DrawText(text.c_str(), GetPaintingForeColor(), font, rect);
    }
}
