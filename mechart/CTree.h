/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CTREEME_H__
#define __CTREEME_H__
#pragma once
#include "stdafx.h"
#include "CGrid.h"
#include "CGridColumn.h"
#include "CGridRow.h"
#include "CGridCell.h"
#include "CGridCellExtends.h"
#include "CTreeNode.h"

namespace MeLib
{
	class CTreeNodeMe;
    
	class CTreeMe:public CGridMe
	{
	protected:
		bool m_checkBoxes;
		SIZE m_checkBoxSize;
		String m_checkedImage;
		String m_collapsedNodeImage;
		String m_expendedNodeImage;
		CTreeNodeMe *m_movingNode;
		SIZE m_nodeSize;
		String m_unCheckedImage;
	public:
		vector<CTreeNodeMe*> m_nodes;
		CTreeMe();
		virtual ~CTreeMe();
		virtual bool HasCheckBoxes();
		virtual void SetCheckBoxes(bool checkBoxes);
		virtual SIZE GetCheckBoxSize();
		virtual void SetCheckBoxSize(SIZE checkBoxSize);
		virtual String GetCheckedImage();
		virtual void SetCheckedImage(const String& checkedImage);
		virtual String GetCollapsedNodeImage();
		virtual void SetCollapsedNodeImage(const String& collapsedNodeImage);
		virtual String GetExpendedNodeImage();
		virtual void SetExpendedNodeImage(const String& expendedNodeImage);
		virtual SIZE GetNodeSize();
		virtual void SetNodeSize(SIZE nodeSize);
		virtual vector<CTreeNodeMe*> GetSelectedNodes();
		virtual void SetSelectedNodes(vector<CTreeNodeMe*> selectedNodes);
		virtual String GetUnCheckedImage();
		virtual void SetUnCheckedImage(const String& unCheckedImage);
	public:
		void AppendNode(CTreeNodeMe *node);
		void ClearNodes();
		void Collapse();
		void CollapseAll();
		void Expend();
		void ExpendAll();
		vector<CTreeNodeMe*> GetChildNodes();
		virtual String GetControlType();
		int GetNodeIndex(CTreeNodeMe *node);
		virtual void GetProperty(const String& name, String *value, String *type);
		virtual vector<String> GetPropertyNames();
		void InsertNode(int index, CTreeNodeMe *node);
		virtual void OnCellMouseDown(CGridCellMe *cell, const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnCellMouseMove(CGridCellMe *cell, const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnCellMouseUp(CGridCellMe *cell, const POINT& mp, MouseButtonsA button, int clicks, int delta);
		virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
		virtual void OnPaintEditTextBox(CGridCellMe *cell, CPaintMe *paint, const RECT& rect, const RECT& clipRect);
		void RemoveNode(CTreeNodeMe *node);
		virtual void SetProperty(const String& name, const String& value);
	};
}

#endif
