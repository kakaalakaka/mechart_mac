#include "stdafx.h"
#include "CBandedGridColumn.h"

namespace MeLib
{
	CBandedGridColumnMe::CBandedGridColumnMe()
	{
		m_band = 0;
	}
	
	CBandedGridColumnMe::~CBandedGridColumnMe()
	{
		m_band = 0;
	}
	
	CGridBandMe* CBandedGridColumnMe::GetBand()
	{
		return m_band;
	}

	void CBandedGridColumnMe::SetBand(CGridBandMe *band)
	{
		m_band = band;
	}

	String CBandedGridColumnMe::GetControlType()
	{
		return L"CBandedGridColumnMe";
	}
	
	bool CBandedGridColumnMe::OnDragBegin()
	{
		return CGridColumnMe::m_resizeState == 0;
	}

	void CBandedGridColumnMe::OnMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta)
	{
		CControlMe::CallMouseEvents(EVENTID::MOUSEDOWN, mp, button, clicks, delta);
		if (m_band && button == MouseButtonsA_Left && clicks == 1 && AllowResize())
		{
			vector<CBandedGridColumnMe*> columns = m_band->GetColumns();
			int columnsSize = (int)columns.size();
			int index = -1;
			for (int i = 0; i < columnsSize; i++)
			{
				if (this == columns[i])
				{
					index = i;
					break;
				}
			}
			if (index > 0 && mp.x < 5)
			{
				CGridColumnMe::m_resizeState = 1;
				CGridColumnMe::m_beginWidth = columns[index - 1]->GetWidth();
			}
			else if (index < columnsSize - 1 && mp.x > GetWidth() - 5)
			{
				CGridColumnMe::m_resizeState = 2;
				CGridColumnMe::m_beginWidth = GetWidth();
			}
			CGridColumnMe::m_mouseDownPoint = GetNative()->GetMousePoint();
		}
		Invalidate();		
	}

	void CBandedGridColumnMe::OnMouseMove(const POINT& mp, MouseButtonsA button, int clicks, int delta)
	{
		CControlMe::CallMouseEvents(EVENTID::MOUSEMOVE, mp, button, clicks, delta);
		CGridMe* grid = GetGrid();
		if (m_band && grid && AllowResize())
		{
			vector<CBandedGridColumnMe*> columns = m_band->GetColumns();
			int count = (int)columns.size();
			int index = -1;
			int width = GetWidth();
			for (int i = 0; i < count; i++)
			{
				if (this == columns[i])
				{
					index = i;
					break;
				}
			}
			if (CGridColumnMe::m_resizeState > 0)
			{
				POINT curPoint = GetNative()->GetMousePoint();
				int newWidth = CGridColumnMe::m_beginWidth + (curPoint.x - m_mouseDownPoint.x);
				if (newWidth > 0)
				{
					if (CGridColumnMe::m_resizeState == 1)
					{
						CBandedGridColumnMe* leftColumn = columns[index - 1];
						int leftWidth = leftColumn->GetWidth();
						leftColumn->SetWidth(newWidth);
						width += leftWidth - newWidth;
						SetWidth(width);
					}
					else if (CGridColumnMe::m_resizeState == 2)
					{
						CBandedGridColumnMe* rightColumn = columns[index + 1];
						int rightWidth = rightColumn->GetWidth() + width - newWidth;
						SetWidth(newWidth);
						rightColumn->SetWidth(rightWidth);
					}
				}
				grid->Invalidate();
			}
			else
			{
				CursorsA cursor = GetCursor();
				CursorsA sizeWE = cursor;
				if ((index > 0 && mp.x < 5) || (index < count - 1 && mp.x > width - 5))
				{
					sizeWE = CursorsA_SizeWE;
				}
				else
				{
					sizeWE = CursorsA_Arrow;
				}
				if (cursor != sizeWE)
				{
					SetCursor(sizeWE);
					Invalidate();
				}
				if (!IsDragging())
				{
					SetCursor(CursorsA_Arrow);
				}
			}
		}		
	}
}
