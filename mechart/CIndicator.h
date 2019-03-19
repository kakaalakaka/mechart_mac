/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CINDICATOR_H__
#define __CINDICATOR_H__
#pragma once
#define FUNCTIONID_FUNCVAR 10
#define FUNCTIONID_FUNCTION 9
#define FUNCTIONID_VAR 10

#include "stdafx.h"
#include "CStr.h"
#include "CMathLib.h"
#include "Enums.h"
#include "CTable.h"
#include "CDiv.h"
#include "CBaseShape.h"

namespace MeLib
{
	class CIndicatorMe;
	class CMathElementMe;

	class CVariableMe
	{
	public:
		CVariableMe();
		virtual ~CVariableMe();
		BarShape *m_barShape;
		CCandleShapeMe *m_candleShape;
		String m_expression;
		int m_field;
		int m_fieldIndex;
		String m_fieldText;
		int m_functionID;
		String m_funcName;
		CIndicatorMe *m_indicator;
		int m_line;
		PointShape *m_pointShape;
		CPolylineShapeMe *m_polylineShape;
		String m_name;
		CVariableMe **m_parameters;
		int m_parametersLength;
		CMathElementMe **m_splitExpression;
		int m_splitExpressionLength;
		int *m_tempFields;
		int m_tempFieldsLength;
		int *m_tempFieldsIndex;
		int m_tempFieldsIndexLength;
		CTextShapeMe *m_textShape;
		int m_type;
		double m_value;
		void CreateTempFields(int count);
	};

	class CMathElementMe
	{
	public:
		CMathElementMe();
		CMathElementMe(int type, double value);
		virtual ~CMathElementMe();
		int m_type;
		double m_value;
		CVariableMe *m_var;
	};

	class CMathElementExMe : public CMathElementMe
	{
	public:
		CMathElementExMe *m_next;
		CMathElementExMe(int type, double value):CMathElementMe(type, value)
		{
			m_next = 0;
		}
		virtual ~CMathElementExMe()
		{
			if(m_next)
			{
				delete m_next;
				m_next = 0;
			}
		}
	};

	class CFunctionMe
	{
	public:
		CFunctionMe();
		virtual ~CFunctionMe();
		int m_ID;
		String m_name;
		bool m_type;
	public:
		virtual double OnCalculate(CVariableMe *var);
	};

	class CVarMe
    {
	public:
        vector<String> *m_list;
        map<String, String> *m_map;
        double m_num;
        String m_str;
        int m_type;
        CVarMe *m_parent;
	public:
        CVarMe()
        {
			m_list = 0;
			m_map = 0;
			m_parent = 0;
        }
        virtual ~CVarMe()
        {
			if (m_list)
            {
                delete m_list;
				m_list = 0;
            }
            if (m_map)
            {
                delete m_map;
				m_map = 0;
            }
            m_parent = 0;
        }
	public:
        virtual String GetText(CIndicatorMe *indicator, CVariableMe *name);
		virtual double GetValue(CIndicatorMe *indicator, CVariableMe *name);
		virtual double OnCreate(CIndicatorMe *indicator, CVariableMe *name, CVariableMe *value);
		virtual void SetValue(CIndicatorMe *indicator, CVariableMe *name, CVariableMe *value);
    };

	class CVarFactoryMe
	{
	public:
		virtual CVarMe* CreateVar()
		{
			return new CVarMe;
		}
	};

	class CIndicatorMe
	{
	protected:
        pthread_mutex_t mutex_x;
		map<String,double> m_defineParams;
		map<String, CFunctionMe*> m_functions;
		map<int, CFunctionMe*> m_functionsMap;
		int m_index;
		vector<CVariableMe*> m_lines;
		vector<_int64> m_systemColors;
		void *m_tag;
		map<String, CVariableMe*> m_tempFunctions;
        map<String, CVariableMe*> m_tempVariables;
		vector<CVariableMe*> m_variables;
		CVarFactoryMe *m_varFactory;
	protected:
		AttachVScale m_attachVScale;
		int m_break;
		CTableMe *m_dataSource;
		CDivMe *m_div;
		String m_name;
		double m_result;
        CVarMe m_resultVar;
	protected:
		void AnalysisVariables(String *sentence, int line, String funcName, String fieldText, bool isFunction);
		void AnalysisScriptLine(String line);
		double Calculate(CMathElementMe **expr, int exprLength);
		double CallFunction(CVariableMe *var);
		void DeleteTempVars();
		void DeleteTempVars(CVariableMe *var);
		_int64 GetColor(const String& strColor);
		LPDATA GetDatas(int fieldIndex, int mafieldIndex, int index, int n);
		float GetLineWidth(const String& strLine);
		int GetMiddleScript(const String& script, vector<String> *lines);
		int GetOperator(const String& op);
		bool IsNumeric(const String& str);
		String Replace(const String& parameter);
		CMathElementMe** SplitExpression(const String& expression, int *sLength);
		String* SplitExpression2(const String& expression, int *sLength);
	public:
		CIndicatorMe();
		virtual ~CIndicatorMe();
		map<String ,int> m_mainVariables;
		map<int, CVarMe*> m_tempVars;
		virtual AttachVScale GetAttachVScale();
		virtual void SetAttachVScale(AttachVScale attachVScale);
		virtual CTableMe* GetDataSource();
		virtual void SetDataSource(CTableMe *dataSource);
		virtual CDivMe* GetDiv();
		virtual void SetDiv(CDivMe *div);
		virtual int GetIndex();
		virtual String GetName();
		virtual void SetName(const String& name);
		virtual double GetResult();
		virtual void SetScript(const String& script);
		virtual vector<_int64> GetSystemColors();
		virtual void SetSystemColors(vector<_int64> systemColors);
		virtual void* GetTag();
		virtual void SetTag(void *tag);
		virtual CVarFactoryMe* GetVarFactory();
		virtual void SetVarFactory(CVarFactoryMe *varFactory);
	public:
		void AddFunction(CFunctionMe *function);
		double CallFunction(String funcName);
		void Clear();
		vector<CFunctionMe*> GetFunctions();
		vector<CBaseShapeMe*> GetShapes();
		String GetText(CVariableMe *var);
		double GetValue(CVariableMe *var);
		CVariableMe* GetVariable(const String& name);
        void Lock();
		void OnCalculate(int index);
		void RemoveFunction(CFunctionMe *function);
		void SetSourceField(const String& key, int value);
		void SetSourceValue(int index, const String& key, double value);
		void SetVariable(CVariableMe *variable, CVariableMe *parameter);
        void UnLock();
	protected:
		double ABS2(CVariableMe *var);
		double AMA(CVariableMe *var);
		double ACOS(CVariableMe *var);
		double ASIN(CVariableMe *var);
		double ATAN(CVariableMe *var);
		double AVEDEV(CVariableMe *var);
		int BARSCOUNT(CVariableMe *var);
		int BARSLAST(CVariableMe *var);
		int BETWEEN(CVariableMe *var);
		int BREAK(CVariableMe *var);
		double CEILING(CVariableMe *var);
		double CHUNK(CVariableMe *var);
		int CONTINUE(CVariableMe *var);
		double COS(CVariableMe *var);
		int COUNT(CVariableMe *var);
		int CROSS(CVariableMe *var);
		int CURRBARSCOUNT(CVariableMe *var);
		int DATE(CVariableMe *var);
		int DAY(CVariableMe *var);
		int DELETE2(CVariableMe *var);
		double DMA(CVariableMe *var);
		int DOTIMES(CVariableMe *var);
		int DOWHILE(CVariableMe *var);
		int DOWNNDAY(CVariableMe *var);
		double DRAWICON(CVariableMe *var);
		double DRAWKLINE(CVariableMe *var);
		double DRAWNULL(CVariableMe *var);
		double DRAWTEXT(CVariableMe *var);
		int EXIST(CVariableMe *var);
		double EMA(CVariableMe *var);
		int EVERY(CVariableMe *var);
		double EXPMEMA(CVariableMe *var);
		double EXP(CVariableMe *var);
		double FLOOR(CVariableMe *var);
		int FOR(CVariableMe *var);
		double FUNCTION(CVariableMe *var);
		double FUNCVAR(CVariableMe *var);
		double GET(CVariableMe *var);
		double HHV(CVariableMe *var);
		double HHVBARS(CVariableMe *var);
		int HOUR(CVariableMe *var);
		double IF(CVariableMe *var);
		double IFN(CVariableMe *var);
		double INTPART(CVariableMe *var);
		int LAST(CVariableMe *var);
		double LLV(CVariableMe *var);
		double LLVBARS(CVariableMe *var);
		double LOG(CVariableMe *var);
		double MA(CVariableMe *var);
		double MAX2(CVariableMe *var);
		double MEMA(CVariableMe *var);
		double MIN2(CVariableMe *var);
		int MINUTE(CVariableMe *var);
		double MOD(CVariableMe *var);
		int MONTH(CVariableMe *var);
		int NDAY(CVariableMe *var);
		int NOT(CVariableMe *var);
		double POLYLINE(CVariableMe *var);
		double POW(CVariableMe *var);
		int RAND(CVariableMe *var);
		double REF(CVariableMe *var);
		double RETURN(CVariableMe *var);
		double REVERSE(CVariableMe *var);
		double ROUND(CVariableMe *var);
		double SAR(CVariableMe *var);
		double SET(CVariableMe *var);
		int SIGN(CVariableMe *var);
		double SIN(CVariableMe *var);
		double SMA(CVariableMe *var);
		double SQRT(CVariableMe *var);
		double SQUARE(CVariableMe *var);
		double STD(CVariableMe *var);
		double STICKLINE(CVariableMe *var);
		double SUM(CVariableMe *var);
		double TAN(CVariableMe *var);
		int TIME(CVariableMe *var);
		int TIME2(CVariableMe *var);
		double TMA(CVariableMe *var);
		int UPNDAY(CVariableMe *var);
		double VALUEWHEN(CVariableMe *var);
		double VAR(CVariableMe *var);
		int WHILE(CVariableMe *var);
		double WMA(CVariableMe *var);
		int YEAR(CVariableMe *var);
		double ZIG(CVariableMe *var);
	public:
		int STR_CONTACT(CVariableMe *var);
		int STR_EQUALS(CVariableMe *var);
		int STR_FIND(CVariableMe *var);
		int STR_FINDLAST(CVariableMe *var);
		int STR_LENGTH(CVariableMe *var);
		int STR_SUBSTR(CVariableMe *var);
		int STR_REPLACE(CVariableMe *var);
		int STR_SPLIT(CVariableMe *var);
		int STR_TOLOWER(CVariableMe *var);
		int STR_TOUPPER(CVariableMe *var);
		int LIST_ADD(CVariableMe *var);
		int LIST_CLEAR(CVariableMe *var);
		int LIST_GET(CVariableMe *var);
		int LIST_INSERT(CVariableMe *var);
		int LIST_REMOVE(CVariableMe *var);
		int LIST_SIZE(CVariableMe *var);
		int MAP_CLEAR(CVariableMe *var);
		int MAP_CONTAINSKEY(CVariableMe *var);
		int MAP_GET(CVariableMe *var);
		int MAP_GETKEYS(CVariableMe *var);
		int MAP_REMOVE(CVariableMe *var);
		int MAP_SET(CVariableMe *var);
		int MAP_SIZE(CVariableMe *var);
	};
}
#endif
