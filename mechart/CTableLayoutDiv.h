/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CTABLELAYOUTDIVME_H__
#define __CTABLELAYOUTDIVME_H__
#pragma once
#include "stdafx.h"
#include "Div.h"

namespace MeLib
{
	typedef enum SizeTypeA
	{
		SizeTypeA_AbsoluteSize,
		SizeTypeA_AutoFill,
		SizeTypeA_PercentSize
	};

	class CColumnStyleMe : public CPropertyMe
	{
	protected:
		SizeTypeA m_sizeType;
		float m_width;
	public:
		CColumnStyleMe(SizeTypeA sizeType, float width);
		virtual ~CColumnStyleMe();
		virtual SizeTypeA GetSizeType();
		virtual void SetSizeTypeA(SizeTypeA  sizeType);
		virtual float GetWidth();
		virtual void SetWidth(float width);
	public:
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void SetProperty(const String& name, const String& value);
	};

	class CRowStyleMe : public CPropertyMe
	{
	protected:
		float m_height;
		SizeTypeA m_sizeType;
	public:
		CRowStyleMe(SizeTypeA sizeType, float height);
		virtual ~CRowStyleMe();
		virtual float GetHeight();
		virtual void SetHeight(float height);
		virtual SizeTypeA GetSizeType();
		virtual void SetSizeTypeA(SizeTypeA  sizeType);
	public:
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual void SetProperty(const String& name, const String& value);
	};
    
	class CTableLayoutDivMe : public DivMe
	{
	protected:
		vector<int> m_columns;
		int m_columnsCount;
		vector<int> m_rows;
		int m_rowsCount;
		vector<CControlMe*> m_tableControls;
	public:
		vector<CColumnStyleMe> m_columnStyles;
		vector<CRowStyleMe> m_rowStyles;
		CTableLayoutDivMe();
		virtual ~CTableLayoutDivMe();
		virtual int GetColumnsCount();
		virtual void SetColumnsCount(int columnsCount);
		virtual int GetRowsCount();
		virtual void SetRowsCount(int rowsCount);
	public:
        virtual void AddControl(CControlMe *control);
		virtual void AddControl(CControlMe *control, int column, int row);
		virtual String GetControlType();
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		virtual bool OnResetLayout();
		virtual void RemoveControl(CControlMe *control);
		virtual void SetProperty(const String& name, const String& value);
		virtual void Update();
	};
}

#endif
