/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CTEXTBOXME_H__
#define __CTEXTBOXME_H__
#pragma once
#include "stdafx.h"
#include "CHScrollBar.h"
#include "CVScrollBar.h"
#include "Div.h"
#include <stack>

namespace MeLib
{
	struct WordLine
	{
	public:
		int m_end;
		int m_start;
		WordLine(int start, int end)
		{
			m_start = start;
			m_end = end;
		}
	};
    
    class CTextBoxMe : public DivMe
    {
    private:
        int m_tick;
        int m_timerID;
    protected:
        bool m_isKeyDown;
        bool m_isMouseDown;
        int m_lineHeight;
        vector<WordLine> m_lines;
        bool m_multiline;
        int m_offsetX;
        wchar_t m_passwordChar;
        vector<RECTF> m_ranges;
        stack<String> m_redoStack;
        bool m_readOnly;
        bool m_rightToLeft;
        _int64 m_selectionBackColor;
        _int64 m_selectionForeColor;
        int m_selectionLength;
        int m_selectionStart;
        bool m_showCursor;
        int m_startMovingIndex;
        int m_stopMovingIndex;
        String m_tempText;
        _int64 m_tempTextForeColor;
        HorizontalAlignA m_textAlign;
        bool m_textChanged;
        int TICK;
        stack<String> m_undoStack;
        vector<SIZEF> m_wordsSize;
        bool m_wordWrap;
        void CursorDown();
        void CursorEnd();
        void CursorHome();
        void CursorLeft();
        void CursorRight();
        void CursorUp();
        void DeleteWord();
        void InsertWord(const String& str);
        bool IsLineVisible(int index, double visiblePercent);
        void SetMovingIndex(int sIndex, int eIndex);
    public:
        CTextBoxMe();
        virtual ~CTextBoxMe();
        virtual int GetLinesCount();
        virtual int GetLineHeight();
        virtual void SetLineHeight(int lineHeight);
        virtual vector<WordLine> GetLines();
        virtual bool IsMultiline();
        virtual void SetMultiline(bool multiline);
        virtual wchar_t GetPasswordChar();
        virtual void SetPasswordChar(wchar_t passwordChar);
        virtual bool IsReadOnly();
        virtual void SetReadOnly(bool readOnly);
        virtual bool IsRightToLeft();
        virtual void SetRightToLeft(bool rightToLeft);
        virtual _int64 GetSelectionBackColor();
        virtual void SetSelectionBackColor(_int64 selectionBackColor);
        virtual _int64 GetSelectionForeColor();
        virtual void SetSelectionForeColor(_int64 selectionForeColor);
        virtual int GetSelectionLength();
        virtual void SetSelectionLength(int selectionLength);
        virtual int GetSelectionStart();
        virtual void SetSelectionStart(int selectionStart);
        virtual String GetTempText();
        virtual void SetTempText(const String& tempText);
        virtual _int64 GetTempTextForeColor();
        virtual void SetTempTextForeColor(_int64 tempTextForeColor);
        virtual HorizontalAlignA GetTextAlign();
        virtual void SetTextAlign(HorizontalAlignA textAlign);
        virtual bool IsWordWrap();
        virtual void SetWordWrap(bool wordWrap);
    public:
        bool CanRedo();
        bool CanUndo();
        void ClearRedoUndo();
        virtual int GetContentHeight();
        virtual int GetContentWidth();
        virtual String GetControlType();
        virtual void GetProperty(const String& name, String *value, String *type);
        virtual vector<String> GetPropertyNames();
        String GetSelectionText();
        virtual void OnChar(wchar_t ch);
        virtual void OnCopy();
        virtual void OnCut();
        virtual void OnGotFocus();
        virtual void OnKeyDown(char key);
        virtual void OnKeyUp(char key);
        virtual void OnLostFocus();
        virtual void OnMouseDown(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnMouseMove(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnMouseUp(const POINT& mp, MouseButtonsA button, int clicks, int delta);
        virtual void OnPaintForeground(CPaintMe *paint, const RECT& clipRect);
        virtual void OnPaste();
        virtual void OnSizeChanged();
        virtual void OnTabStop();
        virtual void OnTextChanged();
        virtual void OnTimer(int timerID);
        void Redo();
        void SelectAll();
        virtual void SetProperty(const String& name, const String& value);
        void Undo();
        virtual void Update();
    };
}

#endif
