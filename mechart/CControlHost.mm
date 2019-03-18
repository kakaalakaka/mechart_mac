#include "stdafx.h"
#include "CControlHost.h"
using namespace MeLib;

CControlHostMe::CControlHostMe()
{

}

CControlHostMe::~CControlHostMe()
{

}

CNativeBaseMe* CControlHostMe::GetNative()
{
	return 0;
}

void CControlHostMe::SetNative( CNativeBaseMe *native )
{

}

void CControlHostMe::ActiveMirror()
{

}

bool CControlHostMe::AllowOperate()
{
	return true;
}

bool CControlHostMe::AllowPartialPaint()
{
	return true;
}

void CControlHostMe::BeginInvoke( CControlMe *control, void *args )
{

}

void CControlHostMe::Copy( string text )
{

}

CControlMe* CControlHostMe::CreateInternalControl( CControlMe *parent, const String& clsid )
{
	return 0;
}

CursorsA CControlHostMe::GetCursor()
{
	return CursorsA_Arrow;
}

int CControlHostMe::GetIntersectRect( RECT *lpDestRect, const RECT *lpSrc1Rect, const RECT *lpSrc2Rect )
{
	return 0;
}

POINT CControlHostMe::GetMousePoint()
{
	return POINT();
}

SIZE CControlHostMe::GetSize()
{
	return SIZE();
}

int CControlHostMe::GetUnionRect(RECT *lpDestRect, const RECT *lpSrc1Rect, const RECT *lpSrc2Rect )
{
	return 0;
}

void CControlHostMe::Invalidate()
{

}

void CControlHostMe::Invalidate( const RECT& rect )
{

}

void CControlHostMe::Invoke( CControlMe *control, void *args )
{

}

bool CControlHostMe::IsKeyPress( char key )
{
	return false;
}

string CControlHostMe::Paste()
{
	return "";
}

void CControlHostMe::SetAllowOperate( bool allowOperate )
{

}

void CControlHostMe::SetAllowPartialPaint( bool allowPartialPaint )
{

}

void CControlHostMe::SetCursor( CursorsA cursor )
{

}

void CControlHostMe::ShowToolTip( const String& text, const POINT& mp)
{

}

void CControlHostMe::StartTimer( int timerID, int interval )
{

}

void CControlHostMe::StopTimer( int timerID )
{

}
