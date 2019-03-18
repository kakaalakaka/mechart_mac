/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CNATIVEBASEME_H__
#define __CNATIVEBASEME_H__
#pragma once
#include "stdafx.h"
#include "CPaint.h"
#include "CControlHost.h"

namespace MeLib
{
    enum SORTTYPE
	{
		SORTTYPE_NONE,
		SORTTYPE_ASC,
		SORTTYPE_DESC
	};
    
	class CControlMe;
	class CControlHostMe;
	class CNativeBaseMe
	{
	protected:
		bool m_allowScaleSize;
		SIZE m_displaySize;
		POINT m_drawBeginPoint;
		RECT m_dragBeginRect;
        CControlMe *m_exportingControl;
		POINT m_dragStartOffset;	
		CControlHostMe *m_host;
		CNativeBaseMe *m_mirrorHost;
        MirrorMode m_mirrorMode;
		float m_opacity;
		CPaintMe *m_paint;
		POINT m_mouseDownPoint;
		String m_resourcePath;
        int m_rotateAngle;
		SIZE m_scaleSize;
		map<int, CControlMe*> m_timers;
		CControlMe* FindControl(const POINT& mp, vector<CControlMe*> *controls);
		CControlMe* FindControl(const String& name, vector<CControlMe*> *controls);
		CControlMe* FindPreviewsControl(CControlMe *control);
		CControlMe* FindWindow(CControlMe *control);
		float GetPaintingOpacity(CControlMe *control);
		String GetPaintingResourcePath(CControlMe *control);
		bool GetSortedControls(CControlMe *parent, vector<CControlMe*> *sortedControls);
        void GetTabStopControls(CControlMe *control, vector<CControlMe*> *tabStopControls);
		bool IsPaintEnabled(CControlMe *control);
		void RenderControls(const RECT& rect, vector<CControlMe*> *controls, String resourcePath, float opacity);
		void SetCursor(CControlMe *control);
		void SetPaint(int offsetX, int offsetY, const RECT& clipRect, String resourcePath, float opacity);
	public:
		vector<CControlMe*> m_controls;
		vector<CNativeBaseMe*> m_mirrors;
		CControlMe *m_draggingControl;
		CControlMe *m_focusedControl;
		CControlMe *m_mouseDownControl;
		CControlMe *m_mouseMoveControl;
		CNativeBaseMe();
		virtual ~CNativeBaseMe();
		bool AllowScaleSize();
		void SetAllowScaleSize(bool allowScaleSize);
        CursorsA GetCursor();
        void SetCursor(CursorsA cursor);
		SIZE GetDisplaySize();
		void SetDisplaySize(SIZE displaySize);
		CControlMe* GetFocusedControl();
		void SetFocusedControl(CControlMe *focusedControl);
		CControlHostMe* GetHost();
		void SetHost(CControlHostMe *host);
		CControlMe* GetHoveredControl();
		CNativeBaseMe* GetMirrorHost();
        MirrorMode GetMirrorMode();
        void SetMirrorMode(MirrorMode mirrorMode);
		POINT GetMousePoint();
		float GetOpacity();
		void SetOpacity(float opacity);
		CPaintMe* GetPaint();
		void SetPaint(CPaintMe *paint);
		CControlMe* GetPushedControl();
		String GetResourcePath();
		void SetResourcePath(const String& resourcePath);
        int GetRotateAngle();
        void SetRotateAngle(int rotateAngle);
		SIZE GetScaleSize();
		void SetScaleSize(SIZE scaleSize);
	public:
		void AddControl(CControlMe *control);
		void AddMirror(CNativeBaseMe *mirrorHost, CControlMe *control);
		void BringToFront(CControlMe *control);
		void CancelDragging();
		void ClearControls();
		int ClientX(CControlMe *control);
		int ClientY(CControlMe *control);
		bool ContainsControl(CControlMe *control);
		CControlMe* FindControl(const POINT& mp);
		CControlMe* FindControl(const POINT& mp, CControlMe *parent);
		CControlMe* FindControl(const String& name);
		vector<CControlMe*> GetControls();
		void InsertControl(int index, CControlMe *control);
		void Invalidate();
        void Invalidate(CControlMe *control);
		void Invalidate(const RECT& rect);
        bool OnChar(wchar_t key);
        void OnDoubleClick(MouseButtonsA button, int clicks, int delta);
        void OnKeyDown(char key);
        void OnKeyUp(char key);
        void OnMouseDown(MouseButtonsA button, int clicks, int delta);
        void OnMouseLeave(MouseButtonsA button, int clicks, int delta);
        void OnMouseMove(MouseButtonsA button, int clicks, int delta);
        void OnMouseUp(MouseButtonsA button, int clicks, int delta);
        void OnMouseWheel(MouseButtonsA button, int clicks, int delta);
		void OnPaint(const RECT& rect);
        bool OnPreviewsKeyEvent(int eventID, char key);
        bool OnPreviewsMouseEvent(int eventID, CControlMe *control, const POINT& mp, MouseButtonsA button, int clicks, int delta);
		void OnResize();
		void OnTimer(int timerID);
        virtual void OnTouchBegin(vector<CTouch> *touches);
        virtual void OnTouchCancel(vector<CTouch> *touches);
        virtual void OnTouchEnd(vector<CTouch> *touches);
        virtual void OnTouchMove(vector<CTouch> *touches);
        void RemoveControl(CControlMe *control);
		void RemoveMirror(CControlMe *control);
		void SendToBack(CControlMe *control);
        void SetAlign(vector<CControlMe*> *controls);
		void SetAnchor(vector<CControlMe*> *controls, SIZE oldSize);
		void SetDock(vector<CControlMe*> *controls);
		void StartTimer(CControlMe *control, int timerID, int interval);
		void StopTimer(int timerID);
		void Update();
	};
}
#endif
