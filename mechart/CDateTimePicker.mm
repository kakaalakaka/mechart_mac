#include "stdafx.h"
#include "CDateTimePicker.h"
using namespace MeLib;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DateTimePickerMe::DropDownButtonMouseDown( void *sender, const POINT& mp, MouseButtonsA button, int clicks, int delta, void *pInvoke )
{
	DateTimePickerMe *pThis = (DateTimePickerMe*)sender;
	if(pThis)
	{
		pThis->OnDropDownOpening();
	}
}

void DateTimePickerMe::SelectedTimeChanged( void *sender, void *pInvoke )
{
	DateTimePickerMe *pThis = (DateTimePickerMe*)sender;
	if(pThis)
	{
		pThis->OnSelectedTimeChanged();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DateTimePickerMe::DateTimePickerMe()
{
	m_calendar = 0;
	m_dropDownButton = 0;
	m_dropDownMenu = 0;
	m_customFormat = L"yyyy-MM-dd";
	m_dropDownButtonMouseDownEvent = &DropDownButtonMouseDown;
	m_selectedTimeChangedEvent = &SelectedTimeChanged;
}

DateTimePickerMe::~DateTimePickerMe()
{
	if (m_calendar)
	{
		if(m_selectedTimeChangedEvent)
		{
			m_calendar->UnRegisterEvent((void *)m_selectedTimeChangedEvent, EVENTID::SELECTEDTIMECHANGED);
			m_selectedTimeChangedEvent = 0;
		}
		m_calendar = 0;
	}
	if (m_dropDownButton)
	{
		if(m_dropDownButtonMouseDownEvent)
		{
			m_dropDownButton->UnRegisterEvent((void *)m_dropDownButtonMouseDownEvent, EVENTID::MOUSEDOWN);
			m_dropDownButtonMouseDownEvent = 0;
		}
		m_dropDownButton = 0;
	}
	if (m_dropDownMenu)
	{
		GetNative()->RemoveControl(m_dropDownMenu);
		delete m_dropDownMenu;
		m_dropDownMenu = 0;
	}
}

CCalendarMe* DateTimePickerMe::GetCalendar()
{
	return m_calendar;
}

String DateTimePickerMe::GetCustomFormat()
{
	return m_customFormat;
}

void DateTimePickerMe::SetCustomFormat( const String& customFormat )
{
	m_customFormat = customFormat;
}

CButtonMe* DateTimePickerMe::GetDropDownButton()
{
	return m_dropDownButton;
}

CMenuMe* DateTimePickerMe::GetDropDownMenu()
{
	return m_dropDownMenu;
}

bool DateTimePickerMe::ShowTime()
{
	return m_showTime;
}

void DateTimePickerMe::SetShowTime(bool showTime)
{
	m_showTime = showTime;
}

String DateTimePickerMe::GetControlType()
{
	return L"DateTimePicker";
}

void DateTimePickerMe::GetProperty( const String& name, String *value, String *type )
{
	if (name == L"customformat")
	{
		*type = L"string";
		*value = GetCustomFormat();
	}
	else if (name == L"showtime")
	{
		*type = L"bool";
		*value = CStrMe::ConvertBoolToStr(m_showTime);
	}
	else
	{
		CTextBoxMe::GetProperty(name, value, type);
	}
}

vector<String> DateTimePickerMe::GetPropertyNames()
{
	vector<String> propertyNames = CTextBoxMe::GetPropertyNames();
	propertyNames.push_back(L"CustomFormat");
	propertyNames.push_back(L"ShowTime");
	return propertyNames;
}

void DateTimePickerMe::OnDropDownOpening()
{
	//TODO
	if (!m_dropDownMenu)
	{
		CControlHostMe *host = GetNative()->GetHost();
		m_dropDownMenu = (CMenuMe*)host->CreateInternalControl(this, L"dropdownmenu");
		GetNative()->AddControl(m_dropDownMenu);
		if (!m_calendar)
		{
			m_calendar = new CCalendarMe();
			m_calendar->SetDock(DockStyleA_Fill);
			m_dropDownMenu->AddControl(m_calendar);
			m_calendar->SetSize(m_dropDownMenu->GetSize());
			m_calendar->RegisterEvent((void *)m_selectedTimeChangedEvent, EVENTID::SELECTEDTIMECHANGED, this);
		}
	}
	m_dropDownMenu->SetNative(GetNative());
	POINT pt = {0, GetHeight()};
	POINT point = PointToNative(pt);
	m_dropDownMenu->SetLocation(point);
	m_dropDownMenu->SetVisible(true);
	if (m_calendar)
	{
		m_calendar->SetMode(CalendarMode_Day);
	}
	m_dropDownMenu->BringToFront();
	m_dropDownMenu->Invalidate();
}

void DateTimePickerMe::OnLoad()
{
	CControlMe::OnLoad();
	if (!m_dropDownButton)
	{
		CControlHostMe *host = GetNative()->GetHost();
		m_dropDownButton = (CButtonMe*)host->CreateInternalControl(this, L"dropdownbutton");
		AddControl(m_dropDownButton);
		m_dropDownButton->RegisterEvent((void *)m_dropDownButtonMouseDownEvent, EVENTID::MOUSEDOWN, this);
	}
	if (m_dropDownMenu)
	{
		m_dropDownMenu->SetNative(GetNative());
	}
}

void DateTimePickerMe::OnSelectedTimeChanged()
{
	//TODO
	//EVENTID::SELECTEDTIMECHANGED
	CallEvents(EVENTID::VALUECHANGED);
	if (m_calendar)
	{
		CDayMe *selectedDay = m_calendar->GetSelectedDay();
		if (selectedDay)
		{
			CTimeDivMe *dir = m_calendar->GetTimeDiv();
			String buff = CStrMe::GetFormatDate(m_customFormat.c_str(), selectedDay->GetYear(), 
				selectedDay->GetMonth(), selectedDay->GetDay(), dir->GetHour(), dir->GetMinute(), dir->GetSecond());
			//wchar_t buff[128] = {0};
			//swprintf(buff, 127, m_customFormat.c_str(), selectedDay->GetYear(), 
			//	selectedDay->GetMonth(), selectedDay->GetDay(), dir->GetHour(), dir->GetMinute(), dir->GetSecond());
			SetText(buff);
			Invalidate();
		}
	}
}

void DateTimePickerMe::SetProperty( const String& name, const String& value )
{
	if (name == L"customformat")
	{
		SetCustomFormat(value);
	}
	else if (name == L"showtime")
	{
		m_showTime = CStrMe::ConvertStrToBool(value);
	}
	else
	{
		CTextBoxMe::SetProperty(name, value);
	}
}

void DateTimePickerMe::Update()
{
	CTextBoxMe::Update();
	int width = GetWidth();
	int height = GetHeight();
	if (m_dropDownButton)
	{
		int right = m_dropDownButton->GetWidth();
		POINT pt = {width - right, 0};
		m_dropDownButton->SetLocation(pt);
		SIZE sz = {right, height};
		m_dropDownButton->SetSize(sz);
		PADDING pd(0, 0, right, 0);
		SetPadding(pd);
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
