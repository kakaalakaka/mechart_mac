#include "stdafx.h"
#include "CIndicator.h"

#define OP_ADD 0
#define OP_AND 1
#define OP_DIVIDE 2
#define OP_E 3
#define OP_GT 4
#define OP_GTE 5
#define OP_LB 6
#define OP_LT 7
#define OP_LTE 8
#define OP_MULTIPLY 9
#define OP_NE 10
#define OP_NULL -1
#define OP_OR 11
#define OP_RB 12
#define OP_SUB 13
#define OP_MOD 14
#define VARIABLE1 L"~"
#define VARIABLE2 L"◎"
#define VARIABLE3 L"?"
#define FUNCTIONS L"CURRBARSCOUNT,BARSCOUNT,DRAWKLINE,STICKLINE,VALUEWHEN,BARSLAST,DOWNNDAY,DRAWICON,DRAWNULL,FUNCTION,FUNCVAR,DRAWTEXT,POLYLINE,BETWEEN,CEILING,EXPMEMA,HHVBARS,INTPART,LLVBARS,DOTIMES,DOWHILE,CONTINUE,RETURN,REVERSE,AVEDEV,MINUTE,SQUARE,UPNDAY,DELETE,COUNT,CROSS,EVERY,EXIST,EXPMA,FLOOR,MONTH,ROUND,TIME2,WHILE,BREAK,CHUNK,ACOS,ASIN,ATAN,DATE,HOUR,LAST,MEMA,NDAY,RAND,SIGN,SQRT,TIME,YEAR,ABS,AMA,COS,DAY,DMA,EMA,EXP,HHV,IFF,IFN,LLV,LOG,MAX,MIN,MOD,NOT,POW,SIN,SMA,STD,SUM,TAN,REF,SAR,FOR,GET,SET,TMA,VAR,WMA,ZIG,IF,MA,STR.CONTACT,STR.EQUALS,STR.FIND,STR.FINDLAST,STR.LENGTH,STR.SUBSTR,STR.REPLACE,STR.SPLIT,STR.TOLOWER,STR.TOUPPER,LIST.ADD,LIST.CLEAR,LIST.GET,LIST.INSERT,LIST.REMOVE,LIST.SIZE,MAP.CLEAR,MAP.CONTAINSKEY,MAP.GET,MAP.GETKEYS,MAP.REMOVE,MAP.SET,MAP.SIZE"
#define FUNCTIONS_FIELD L"EXPMEMA,EXPMA,MEMA,AMA,DMA,EMA,SMA,SUM,SAR,TMA,WMA,MA"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wstring CVarMe::GetText(CIndicatorMe *indicator, CVariableMe *name)
{
    if (m_type != 1)
    {
        return CStrMe::ConvertDoubleToStr(m_num);
    }
    int size = (int)m_str.size();
    if (size > 0 && m_str[0] == L'\'')
    {
        return m_str.substr(1, size - 1);
    }
    return m_str;
}

double CVarMe::GetValue(CIndicatorMe *indicator, CVariableMe *name)
{
    if (m_type == 1)
    {
        return CStrMe::ConvertStrToDouble(CStrMe::Replace(m_str, L"'", L""));
    }
    return m_num;
}

double CVarMe::OnCreate(CIndicatorMe *indicator, CVariableMe *name, CVariableMe *value)
{
    double result = 0.0;
    int size = (int)value->m_expression.size();
    if (size > 0 && value->m_expression[0] == L'\'')
    {
        m_type = 1;
        m_str = value->m_expression.substr(1, size - 1);
        return result;
    }
    else if (value->m_expression == L"LIST")
    {
        m_type = 2;
        m_list->clear();
        return result;
    }
    else if (value->m_expression == L"MAP")
    {
        m_type = 3;
        m_map->clear();
        return result;
    }
    else
    {
        map<int, CVarMe*>::iterator sIter = indicator->m_tempVars.find(value->m_field);
        if(sIter != indicator->m_tempVars.end())
        {
            CVarMe *var = sIter->second;
            if (var->m_type == 1)
            {
                m_type = 1;
                m_str = var->m_str;
                return result;
            }
            m_type = 0;
            result = var->m_num;
            return result;
        }
        else
        {
            m_type = 0;
            result = indicator->GetValue(value);
            m_num = result;
        }
    }
    return result;
}

void CVarMe::SetValue(CIndicatorMe *indicator, CVariableMe *name, CVariableMe *value)
{
    if (m_type == 1)
    {
        m_str = indicator->GetText(value);
    }
    else
    {
        m_num = indicator->GetValue(value);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//IDA pass 20180827
CVariableMe::CVariableMe()
{
    m_barShape = 0;
    m_candleShape = 0;
    m_expression = L"";
    m_field = CTableMe::NULLFIELD();
    m_fieldIndex = -1;
    m_fieldText = L"";
    m_functionID = -1;
    m_funcName = L"";
    m_indicator = 0;
    m_line = -1;
    m_pointShape = 0;
    m_polylineShape = 0;
    m_name = L"";
    m_parameters = 0;
    m_parametersLength = 0;
    m_splitExpression  = 0;
    m_splitExpressionLength   = 0;
    m_tempFields  = 0;
    m_tempFieldsLength  = 0;
    m_tempFieldsIndex  = 0;
    m_tempFieldsIndexLength  = 0;
    m_textShape  = 0;
    m_type  = 0;
    m_value  = 0;
}

CVariableMe::~CVariableMe()
{
    m_barShape = 0;
    m_candleShape = 0;
    m_indicator = 0;
    m_pointShape = 0;
    m_polylineShape = 0;
    
    if(m_parameters && m_parametersLength > 0)
    {
        delete[] m_parameters;
    }
    m_parameters = 0;
    
    if(m_splitExpression && m_splitExpressionLength > 0)
    {
        delete[] m_splitExpression;
    }
    m_splitExpression  = 0;
    
    if(m_tempFields && m_tempFieldsLength > 0)
    {
        delete[] m_tempFields;
    }
    m_tempFields  = 0;
    
    if(m_tempFieldsIndex && m_tempFieldsIndexLength > 0)
    {
        delete[] m_tempFieldsIndex;
    }
    m_tempFieldsIndex  = 0;
    
    m_textShape  = 0;
}

void CVariableMe::CreateTempFields(int count)
{
    m_tempFields = new int[count];
    m_tempFieldsLength = count;
    m_tempFieldsIndex = new int[count];
    m_tempFieldsIndexLength = count;
    for (int i = 0; i < count; i++)
    {
        int autoField = m_indicator->GetDataSource()->AUTOFIELD();
        m_tempFields[i] = autoField;
        m_indicator->GetDataSource()->AddColumn(autoField);
        m_tempFieldsIndex[i] = m_indicator->GetDataSource()->GetColumnIndex(autoField);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CMathElementMe::CMathElementMe()
{
    m_type = 0;
    m_value = 0;
    m_var = 0;
}

CMathElementMe::CMathElementMe(int type, double value)
{
    m_type = type;
    m_value = value;
    m_var = 0;
}

CMathElementMe::~CMathElementMe()
{
    if(m_var)
    {
        delete m_var;
        m_var = 0;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CFunctionMe::CFunctionMe()
{
    m_ID = 0;
    m_name = L"";
    m_type = 0;
}

CFunctionMe::~CFunctionMe()
{
}

double CFunctionMe::OnCalculate(CVariableMe *var)
{
    return 0.0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void CIndicatorMe::AnalysisVariables(wstring *sentence, int line, wstring funcName, wstring fieldText, bool isFunction)
{
    vector<wstring> wordsList;
    int splitWordsSize = 0;
    wstring* splitWords = SplitExpression2(*sentence, &splitWordsSize);
    for (int i = 0; i < splitWordsSize; i++)
    {
        vector<wstring> separaters;
        separaters.push_back(L"◎");
        separaters.push_back(L":");
        vector<wstring> subWStr = CStrMe::Split(splitWords[i], separaters);
        int subWStrSize = (int)subWStr.size();
        for (int k = 0; k < subWStrSize; k++)
        {
            map<wstring, CFunctionMe*>::iterator sIter = m_functions.find(subWStr[k]);
            if(sIter != m_functions.end())
            {
                wordsList.push_back(subWStr[k]);
            }
        }
    }
    int wordsListSize = (int)wordsList.size();
    for (int f = 0; f < wordsListSize; f++)
    {
        CVariableMe *var;
        wstring word = wordsList[f];
        map<wstring, CFunctionMe*>::iterator sIter = m_functions.find(word);
        CFunctionMe *func = sIter->second;
        wstring fName = func->m_name;
        int funcID = func->m_ID;
        int funcType = func->m_type;
        wstring functionName = fName + L"(";
        for (int bIndex = (int)sentence->find(functionName); bIndex != -1; bIndex = (int)sentence->find(functionName, (int)sentence->find(var->m_name)))
        {
            int rightBracket = 0;
            int idx = 0;
            int count = 0;
            int senSize = (int)sentence->size();
            for(int i = 0; i < senSize; i++)
            {
                wchar_t ch = (*sentence)[i];
                if (idx >= bIndex)
                {
                    if(ch == L'(')
                    {
                        count++;
                    }
                    else if (ch == L')')
                    {
                        count--;
                        if (count == 0)
                        {
                            rightBracket = idx;
                            break;
                        }
                    }
                }
                idx++;
            }
            if (rightBracket == 0)
            {
                break;
            }
            wstring body = sentence->substr(bIndex, (rightBracket - bIndex) + 1);
            var = new CVariableMe();
            var->m_indicator = this;
            var->m_name = VARIABLE1 + CStrMe::ConvertIntToStr((int)m_variables.size());
            var->m_expression = body.substr(0, body.find(L'('));
            var->m_type = 0;
            var->m_functionID = funcID;
            var->m_fieldText = body;
            if (funcType == 1)
            {
                int field = m_dataSource->AUTOFIELD();
                var->m_field = field;
                m_dataSource->AddColumn(field);
            }
            m_variables.push_back(var);
            if (bIndex == 0 && isFunction)
            {
                var->m_funcName = funcName;
                var->m_line = line;
                var->m_fieldText = fieldText;
                m_lines.push_back(var);
                m_tempFunctions.insert(make_pair(funcName, var));
                isFunction = false;
            }
            int splitExpressionLength = 0;
            var->m_splitExpression = SplitExpression(var->m_expression, &splitExpressionLength);
            var->m_splitExpressionLength = splitExpressionLength;
            int startIndex = bIndex + (int)functionName.size();
            wstring subSentence = sentence->substr(startIndex, rightBracket - startIndex);
            map<wstring, CVariableMe*>::iterator sIter = m_tempFunctions.find(fName);
            if (((funcID == FUNCTIONID_FUNCTION)
                 && sIter != m_tempFunctions.end()
                 && (sIter->second->m_fieldText != L"")))
            {
                vector<wstring> fieldTexts = CStrMe::Split(sIter->second->m_fieldText, VARIABLE2);
                vector<wstring> transferParams = CStrMe::Split(subSentence, VARIABLE2);
                subSentence = L"";
                int transferParamsLen = (int)transferParams.size();
                for (int n = 0; n < transferParamsLen; n++)
                {
                    if (n == 0)
                    {
                        subSentence = L"FUNCVAR(";
                    }
                    subSentence = subSentence + fieldTexts[n] + VARIABLE2 + transferParams[n];
                    if (n != (transferParamsLen - 1))
                    {
                        subSentence = subSentence + VARIABLE2;
                    }
                    else
                    {
                        subSentence = subSentence + L")";
                    }
                }
            }
            AnalysisVariables(&subSentence, 0, L"", L"", false);
            vector<wstring> parameters = CStrMe::Split(subSentence, VARIABLE2);
            int paraSize = (int)parameters.size();
            if (paraSize > 0 && (int)parameters[0].size() > 0)
            {
                CVariableMe **parametersArr =  new CVariableMe*[paraSize];
                var->m_parameters = parametersArr;
                var->m_parametersLength = paraSize;
                for (int j = 0; j < paraSize; j++)
                {
                    wstring parameter = parameters[j];
                    parameter = Replace(parameter);
                    CVariableMe *pVar = new CVariableMe();
                    pVar->m_indicator = this;
                    pVar->m_expression = parameter;
                    pVar->m_name = VARIABLE1 + CStrMe::ConvertIntToStr((int)m_variables.size());
                    pVar->m_type = 1;
                    var->m_parameters[j] = pVar;
                    vector<CVariableMe*>::iterator sIterV = m_variables.begin();
                    for(; sIterV != m_variables.end(); ++sIterV)
                    {
                        CVariableMe *variable3 = (*sIterV);
                        if ((variable3->m_type == 2 && variable3->m_expression == parameters[j]) && variable3->m_field != CTableMe::NULLFIELD())
                        {
                            pVar->m_type = 2;
                            pVar->m_field = variable3->m_field;
                            pVar->m_fieldText = parameters[j];
                            break;
                        }
                    }
                    if (pVar->m_type == 1)
                    {
                        wstring varKey = parameter;
                        if (varKey.find(L"[REF]") == 0)
                        {
                            varKey = varKey.substr(5);
                        }
                        map<wstring, CVariableMe*>::iterator sIterTemp = m_tempVariables.find(varKey);
                        if(sIterTemp != m_tempVariables.end())
                        {
                            pVar->m_field = sIterTemp->second->m_field;
                        }
                        else
                        {
                            int varSize = (int)m_variables.size();
                            pVar->m_field = -(varSize);
                            m_tempVariables.insert(make_pair(varKey, pVar));
                        }
                    }
                    m_variables.push_back(pVar);
                    int splitExpressionLength = 0;
                    pVar->m_splitExpression = SplitExpression(parameter, &splitExpressionLength);
                    pVar->m_splitExpressionLength = splitExpressionLength;
                    if ((pVar->m_splitExpression && (pVar->m_splitExpressionLength == 2)) && ((*pVar->m_splitExpression)[0].m_var == pVar))
                    {
                        delete[] pVar->m_splitExpression;
                        pVar->m_splitExpression = 0;
                        pVar->m_splitExpressionLength = 0;
                    }
                }
            }
            *sentence = sentence->substr(0, bIndex) + var->m_name + sentence->substr(rightBracket + 1);
        }
    }
    wordsList.clear();
}

void CIndicatorMe::AnalysisScriptLine(wstring line)
{
    CVariableMe *script = new CVariableMe();
    script->m_indicator = this;
    bool isFunction = false;
    wstring sentence = line;
    wstring funcName = L"";
    wstring fieldText = L"";
    if(CStrMe::startswith(line, L"FUNCTION "))
    {
        int cindex = (int)sentence.find(L'(');
        funcName = sentence.substr(9, cindex - 9);
        int rindex = (int)sentence.find(L')');
        if (rindex - cindex > 1)
        {
            fieldText = sentence.substr(cindex + 1, (rindex - cindex) - 1);
            vector<wstring> pList = CStrMe::Split(fieldText, VARIABLE2);
            int pListSize = (int)pList.size();
            for (int i = 0; i < pListSize; i++)
            {
                wstring str = pList[i];
                if (str.find(L"[REF]") != -1)
                {
                    str = str.substr(5);
                }
                wstring pCmd = L"VAR(" + str + VARIABLE2 + L"0)";
                AnalysisVariables(&pCmd, 0, L"", L"", false);
            }
        }
        int lineSize = (int)sentence.size();
        int length = lineSize - rindex - 1;
        sentence = sentence.substr(rindex + 1, length);
        sentence = L"CHUNK" + sentence.substr(0, lineSize - 1) + L")";
        isFunction = true;
    }
    int lineCount = (int)m_lines.size();
    AnalysisVariables(&sentence, lineCount, funcName, fieldText, isFunction);
    script->m_line = lineCount;
    if (isFunction) {
        return;
    }
    wstring variable = L"";
    wstring parameter =  L"";
    wstring followParameters = L"";
    wstring op = L"";
    int strLineSize = (int)sentence.size();
    wchar_t *charArray =(wchar_t*)sentence.c_str();
    for(int i = 0 ; i < strLineSize; i++)
    {
        wchar_t ch = charArray[i];
        if ((ch != L':') && (ch != L'='))
        {
            if ((int)op.size() > 0) {
                break;
            }
        }
        else
        {
            wchar_t str[16] = {0};
            wcsncpy(str, &ch, 1);
            String newStr = String(str);
            op = op + newStr;
        }
    }
    int index = 0;
    if(op == L":=")
    {
        index = (int)sentence.find(L":=");
        variable = sentence.substr(0, index);
        index += 2;
        parameter = sentence.substr(index);
    }
    else if(op == L":")
    {
        index = (int)sentence.find(L":");
        variable = sentence.substr(0, index);
        index = index + 1;
        parameter = sentence.substr(index);
        followParameters = L"COLORAUTO";
        index = (int)sentence.find(VARIABLE2);
        if (index != -1)
        {
            followParameters = sentence.substr(index + 1);
            parameter = parameter.substr(0, index);
        }
    }
    else
    {
        parameter = sentence;
        vector<wstring> strs = CStrMe::Split(parameter, VARIABLE2);
        int strSize = (int)strs.size();
        if ((strSize > 1))
        {
            wstring strVar = strs[0];
            parameter = strVar;
            int idx = CStrMe::ConvertStrToInt(strVar.substr(1));
            if (idx < (int)m_variables.size())
            {
                CVariableMe *var = m_variables[idx];
                int startIndex = 0;
                if (!var->m_parameters)
                {
                    int size = (int)strs.size() - 1;
                    CVariableMe **arrayVar = new CVariableMe*[size];
                    var->m_parameters = arrayVar;
                    var->m_parametersLength = size;
                    startIndex = 0;
                }
                else
                {
                    int paraSize = var->m_parametersLength;
                    int arrSize = (paraSize + strSize) - 1;
                    CVariableMe **newParameters = new CVariableMe*[arrSize];
                    for (int k = 0; k < paraSize; k++)
                    {
                        newParameters[k] = var->m_parameters[k];
                    }
                    startIndex = paraSize;
                    var->m_parameters = newParameters;
                }
                for (int j = 1; j < strSize; j++)
                {
                    CVariableMe *newVar = new CVariableMe();
                    newVar->m_indicator = this;
                    newVar->m_type = 1;
                    newVar->m_expression = strs[j];
                    var->m_parameters[(startIndex + j) - 1] = newVar;
                }
            }
        }
    }
    script->m_expression = Replace(parameter);
    m_variables.push_back(script);
    m_lines.push_back(script);
    if (variable != L"")
    {
        script->m_type = 1;
        CVariableMe *pfunc = new CVariableMe();
        pfunc->m_indicator = this;
        pfunc->m_type = 2;
        int count = (int)m_variables.size();
        pfunc->m_name = VARIABLE1 + CStrMe::ConvertIntToStr(count);
        int field = -1;
        if(CStrMe::startswith(sentence, VARIABLE1))
        {
            bool isNum = IsNumeric(CStrMe::Replace(sentence, VARIABLE1, L""));
            if (isNum)
            {
                vector<CVariableMe*>::iterator sIter = m_variables.begin();
                for(; sIter != m_variables.end(); ++sIter)
                {
                    CVariableMe *var = *sIter;
                    if ((var->m_name == parameter) && (var->m_field != CTableMe::NULLFIELD()))
                    {
                        field = var->m_field;
                        break;
                    }
                }
            }
        }
        if (field == CTableMe::NULLFIELD())
        {
            field = m_dataSource->AUTOFIELD();
            m_dataSource->AddColumn(field);
        }
        else
        {
            script->m_type = 0;
        }
        pfunc->m_field = field;
        pfunc->m_expression = variable;
        int splitExpressioSize = 0;
        pfunc->m_splitExpression = SplitExpression(variable, &splitExpressioSize);
        pfunc->m_splitExpressionLength = splitExpressioSize;
        m_variables.push_back(pfunc);
        m_mainVariables.insert(make_pair(variable, field));
        script->m_field = field;
    }
    int parameterSize = (int)followParameters.size();
    if ((followParameters != L"") && (parameterSize > 0))
    {
        wstring newLine = L"";
        if (followParameters.find(L"COLORSTICK") != -1)
        {
            newLine = L"STICKLINE(1◎" + variable + L"◎0◎1◎2◎DRAWTITLE)";
        }
        else if (followParameters.find(L"CIRCLEDOT") != -1)
        {
            newLine = L"DRAWICON(1◎" + variable + L"◎CIRCLEDOT◎DRAWTITLE)";
        }
        else if (followParameters.find(L"POINTDOT") != -1)
        {
            newLine = L"DRAWICON(1◎" + variable + L"◎POINTDOT◎DRAWTITLE)";
        }
        else
        {
            newLine = L"POLYLINE(1◎" + variable + VARIABLE2 + followParameters + L"◎DRAWTITLE)";
        }
        AnalysisScriptLine(newLine);
    }
    int expressionSize = 0;
    script->m_splitExpression = SplitExpression(script->m_expression, &expressionSize);
    script->m_splitExpressionLength = expressionSize;
}

double CIndicatorMe::Calculate(CMathElementMe **expr, int exprLength)
{
    //double op = 0.0;
    int length = exprLength;
    CMathElementMe **optr = new CMathElementMe*[length];
    int optrLength = 1;
    CMathElementMe *exp = new CMathElementMe();
    exp->m_type = 3;
    optr[0] = exp;
    CMathElementMe **opnd = new CMathElementMe*[length];
    int opndLength = 0;
    int idx = 0;
    CMathElementMe *preLast = 0;
    while (idx < length && ((expr[idx]->m_type != 3) || (optr[optrLength - 1]->m_type != 3)))
    {
        CMathElementMe *Q2 = expr[idx];
        if ((Q2->m_type != 0) && (Q2->m_type != 3))
        {
            opnd[opndLength] = Q2;
            opndLength++;
            idx++;
            continue;
        }
        else
        {
            CMathElementMe *Q1 = optr[optrLength - 1];
            int precede = -1;
            if (Q2->m_type == 3)
            {
                if (Q1->m_type == 3)
                {
                    precede = 3;
                }
                else
                {
                    precede = 4;
                }
            }
            else
            {
                int q1Value = (int)Q1->m_value;
                int q2Value = (int)Q2->m_value;
                switch (q2Value)
                {
                    case 0:
                    case 1:
                    case 3:
                    case 4:
                    case 5:
                    case 7:
                    case 8:
                    case 10:
                    case 11:
                    case 13:
                    case 14:
                        if ((Q1->m_type == 3) || ((Q1->m_type == 0) && (q1Value == 6)))
                        {
                            precede = 7;
                        }
                        else
                        {
                            precede = 4;
                        }
                        break;
                    case 2:
                    case 9:
                        if ((Q1->m_type == 0) && ((q1Value == 9) || (q1Value == 2) || (q1Value == 12)))
                        {
                            precede = 4;
                        }
                        else
                        {
                            precede = 7;
                        }
                        break;
                    case 6:
                        precede = 7;
                        break;
                    case 12:
                        if ((Q1->m_type == 0) && (q1Value == 6))
                        {
                            precede = 3;
                        }
                        else
                        {
                            precede = 4;
                        }
                        break;
                }
            }
            switch (precede)
            {
                case 3:
                    optrLength--;
                    idx++;
                    break;
                case 5:
                case 6:
                    break;
                case 7:
                    optr[optrLength] = Q2;
                    optrLength++;
                    idx++;
                    break;
                case 4:
                    if (opndLength == 0)
                    {
                        return 0.0;
                    }
                    double op = Q1->m_value;
                    optrLength--;
                    double opnd1 = 0.0;
                    double opnd2 = 0.0;
                    CMathElementMe *last = opnd[(opndLength - 1)];
                    if (last->m_type == 2)
                    {
                        opnd2 = GetValue(last->m_var);
                    }
                    else
                    {
                        opnd2 = last->m_value;
                    }
                    if (opndLength > 1)
                    {
                        preLast = opnd[(opndLength - 2)];
                        if (preLast->m_type == 2)
                        {
                            opnd1 = GetValue(preLast->m_var);
                        }
                        else
                        {
                            opnd1 = preLast->m_value;
                        }
                        opndLength -= 2;
                    }
                    else
                    {
                        opndLength--;
                    }
                    double result = 0.0;
                    switch ((int)op)
                    {
                        case 0:
                            // 加
                            result = opnd1 + opnd2;
                            break;
                        case 13:
                            //减
                            result = opnd1 - opnd2;
                            break;
                        case 9:
                            //乘
                            result = opnd1 * opnd2;
                            break;
                        case 2:
                            //除
                            if (opnd2 == 0.0)
                            {
                                result = 0.0;
                            }
                            else
                            {
                                result = opnd1 / opnd2;
                            }
                            break;
                        case 14:
                            //取余
                            if (opnd2 == 0.0)
                            {
                                result = 0.0;
                            }
                            else
                            {
                                result = (int)opnd1 % (int)opnd2;
                            }
                            break;
                        case 5:
                            // 大于等于
                            result = opnd1 >= opnd2 ? 1 : 0;
                            break;
                        case 8:
                            // 小于等于
                            result = opnd1 <= opnd2 ? 1 : 0;
                            break;
                        case 10:
                            // 不等于
                            //result = opnd1 != opnd2 ? 1 : 0;
                            if (((last->m_var) && (last->m_var->m_functionID == -2))
                                || (preLast && (preLast->m_var) && (preLast->m_var->m_functionID == -2)))
                            {
                                if ((preLast) && (last->m_var) && (preLast->m_var))
                                {
                                    if (GetText(last->m_var) !=  GetText(preLast->m_var))
                                    {
                                        result = 1.0;
                                    }
                                }
                            }
                            else
                            {
                                result = opnd1 != opnd2 ? 1 : 0;
                            }
                            break;
                        case 3:
                            // 等于
                            if (((last->m_var) && (last->m_var->m_functionID == -2))
                                || ((preLast) && (preLast->m_var) && (preLast->m_var->m_functionID == -2)))
                            {
                                if ((preLast) && (last->m_var)
                                    && (preLast->m_var)) {
                                    if (GetText(last->m_var) == GetText(preLast->m_var))
                                    {
                                        result = 1.0;
                                    }
                                }
                            }else
                            {
                                result = opnd1 == opnd2 ? 1 : 0;
                            }
                            break;
                        case 4:
                            //大于
                            result = opnd1 > opnd2 ? 1 : 0;
                            break;
                        case 7:
                            //下于
                            result = opnd1 < opnd2 ? 1 : 0;
                            break;
                        case 1:
                            if ((opnd1 == 1.0) && (opnd2 == 1.0))
                            {
                                result = 1.0;
                            }
                            else
                            {
                                result = 0.0;
                            }
                            break;
                        case 11:
                            if ((opnd1 == 1.0) || (opnd2 == 1.0))
                            {
                                result = 1.0;
                            }
                            else
                            {
                                result = 0.0;
                            }
                            break;
                        case 6:
                        case 12:
                        default:
                            result = 0.0;
                            break;
                    }
                    if (m_break > 0)
                    {
                        return result;
                    }
                    CMathElementMe *expression = new CMathElementMe();
                    expression->m_type = 1;
                    expression->m_value = result;
                    opnd[opndLength] = expression;
                    opndLength++;
                    break;
            }
        }
    }
    if (opndLength <= 0)
    {
        return 0.0;
    }
    CMathElementMe *rlast = opnd[opndLength - 1];
    if (rlast->m_type == 2)
    {
        return GetValue(rlast->m_var);
    }
    return rlast->m_value;
}

double CIndicatorMe::CallFunction(CVariableMe *var)
{
    switch (var->m_functionID)
    {
        case 0:
            return (double)CURRBARSCOUNT(var);
        case 1:
            return (double)BARSCOUNT(var);
        case 2:
            return DRAWKLINE(var);
        case 3:
            return STICKLINE(var);
        case 4:
            return VALUEWHEN(var);
        case 5:
            return (double)BARSLAST(var);
        case 6:
            return (double)DOWNNDAY(var);
        case 7:
            return DRAWICON(var);
        case 8:
            return DRAWNULL(var);
        case 9:
            return FUNCTION(var);
        case 10:
            return FUNCVAR(var);
        case 11:
            return DRAWTEXT(var);
        case 12:
            return POLYLINE(var);
        case 13:
            return (double)BETWEEN(var);
        case 14:
            return CEILING(var);
        case 15:
            return EXPMEMA(var);
        case 16:
            return HHVBARS(var);
        case 17:
            return INTPART(var);
        case 18:
            return LLVBARS(var);
        case 19:
            return (double)DOTIMES(var);
        case 20:
            return (double)DOWHILE(var);
        case 21:
            return (double)CONTINUE(var);
        case 22:
            return RETURN(var);
        case 23:
            return REVERSE(var);
        case 24:
            return AVEDEV(var);
        case 25:
            return (double)MINUTE(var);
        case 26:
            return SQUARE(var);
        case 27:
            return (double)UPNDAY(var);
        case 28:
            return (double)DELETE2(var);
        case 29:
            return (double)COUNT(var);
        case 30:
            return (double)CROSS(var);
        case 31:
            return (double)EVERY(var);
        case 32:
            return (double)EXIST(var);
        case 33:
            return EMA(var);
        case 34:
            return FLOOR(var);
        case 35:
            return (double)MONTH(var);
        case 36:
            return ROUND(var);
        case 37:
            return TIME2(var);
        case 38:
            return (double)WHILE(var);
        case 39:
            return (double)BREAK(var);
        case 40:
            return CHUNK(var);
        case 41:
            return ACOS(var);
        case 42:
            return ASIN(var);
        case 43:
            return ATAN(var);
        case 44:
            return (double)DATE(var);
        case 45:
            return (double)HOUR(var);
        case 46:
            return (double)LAST(var);
        case 47:
            return MEMA(var);
        case 48:
            return (double)NDAY(var);
        case 49:
            return (double)RAND(var);
        case 50:
            return (double)SIGN(var);
        case 51:
            return SQRT(var);
        case 52:
            return TIME(var);
        case 53:
            return (double)YEAR(var);
        case 54:
            return ABS2(var);
        case 55:
            return AMA(var);
        case 56:
            return COS(var);
        case 57:
            return (double)DAY(var);
        case 58:
            return DMA(var);
        case 59:
            return EMA(var);
        case 60:
            return EXP(var);
        case 61:
            return HHV(var);
        case 62:
            return IF(var);
        case 63:
            return IFN(var);
        case 64:
            return LLV(var);
        case 65:
            return LOG(var);
        case 66:
            return MAX2(var);
        case 67:
            return MIN2(var);
        case 68:
            return MOD(var);
        case 69:
            return (double)NOT(var);
        case 70:
            return POW(var);
        case 71:
            return SIN(var);
        case 72:
            return SMA(var);
        case 73:
            return STD(var);
        case 74:
            return SUM(var);
        case 75:
            return TAN(var);
        case 76:
            return REF(var);
        case 77:
            return SAR(var);
        case 78:
            return (double)FOR(var);
        case 79:
            return GET(var);
        case 80:
            return SET(var);
        case 81:
            return TMA(var);
        case 82:
            return VAR(var);
        case 83:
            return WMA(var);
        case 84:
            return ZIG(var);
        case 85:
            return IF(var);
        case 86:
            return MA(var);
        case 87:
            return (double)STR_CONTACT(var);
        case 88:
            return (double)STR_EQUALS(var);
        case 89:
            return (double)STR_FIND(var);
        case 90:
            return (double)STR_FINDLAST(var);
        case 91:
            return (double)STR_LENGTH(var);
        case 92:
            return (double)STR_SUBSTR(var);
        case 93:
            return (double)STR_REPLACE(var);
        case 94:
            return (double)STR_SPLIT(var);
        case 95:
            return (double)STR_TOLOWER(var);
        case 96:
            return (double)STR_TOUPPER(var);
        case 97:
            return (double)LIST_ADD(var);
        case 98:
            return (double)LIST_CLEAR(var);
        case 99:
            return (double)LIST_GET(var);
        case 100:
            return (double)LIST_INSERT(var);
        case 101:
            return (double)LIST_REMOVE(var);
        case 102:
            return (double)LIST_SIZE(var);
        case 103:
            return (double)MAP_CLEAR(var);
        case 104:
            return (double)MAP_CONTAINSKEY(var);
        case 105:
            return (double)MAP_GET(var);
        case 106:
            return (double)MAP_GETKEYS(var);
        case 107:
            return (double)MAP_REMOVE(var);
        case 108:
            return (double)MAP_SET(var);
        case 109:
            return (double)MAP_SIZE(var);
    }
    map<int, CFunctionMe*>::iterator sIter = m_functionsMap.find(var->m_functionID);
    if(sIter != m_functionsMap.end())
    {
        return sIter->second->OnCalculate(var);
    }
    return 0.0;
}

_int64 CIndicatorMe::GetColor(const wstring& strColor)
{
    if(strColor == L"COLORRED")
    {
        return (_int64)COLOR::ARGB(255, 0, 0);
    }
    else if(strColor == L"COLORGREEN")
    {
        return (_int64)COLOR::ARGB(0, 255, 0);
    }
    else if(strColor == L"COLORBLUE")
    {
        return (_int64)COLOR::ARGB(0, 0, 255);
    }
    else if(strColor == L"COLORMAGENTA")
    {
        return (_int64)COLOR::ARGB(0xff, 0, 255);
    }
    else if(strColor == L"COLORYELLOW")
    {
        return (_int64)COLOR::ARGB(255, 255, 0);
    }
    else if(strColor == L"COLORLIGHTGREY")
    {
        return (_int64)COLOR::ARGB(211, 211, 211);
    }
    else if(strColor == L"COLORLIGHTRED")
    {
        return (_int64)COLOR::ARGB(255, 82, 82);
    }
    else if(strColor == L"COLORLIGHTGREEN")
    {
        return (_int64)COLOR::ARGB(144, 238, 144);
    }
    else if(strColor == L"COLORLIGHTBLUE")
    {
        return (_int64)COLOR::ARGB(173, 216, 230);
    }
    else if(strColor == L"COLORLIGHTBLUE")
    {
        return (_int64)COLOR::ARGB(173, 216, 230);
    }
    else if(strColor == L"COLORBLACK")
    {
        return (_int64)COLOR::ARGB(0, 0, 0);
    }
    else if(strColor == L"COLORWHITE")
    {
        return (_int64)COLOR::ARGB(255, 255, 255);
    }
    else if(strColor == L"COLORCYAN")
    {
        return (_int64)COLOR::ARGB(0, 255, 255);
    }
    else if(strColor == L"COLORAUTO")
    {
        int lineCount = 0;
        _int64 lineColor = COLOR_EMPTY;
        
        vector<CBaseShapeMe*> shapes = GetShapes();
        vector<CBaseShapeMe*>::iterator sIter = shapes.begin();
        for(; sIter != shapes.end(); ++sIter)
        {
            CBaseShapeMe *shape = (*sIter);
            if (typeid(*shape) == typeid(PolylineShape))
            {
                lineCount++;
            }
        }
        int systemColorsSize = (int)m_systemColors.size();
        if (systemColorsSize > 0)
        {
            lineColor = m_systemColors[lineCount % systemColorsSize];
        }
        return lineColor;
    }
    
    String colorString = strColor.substr(5);
    String strR = L"0x" + strColor.substr(0, 2);
    String strG = L"0x" + strColor.substr(2, 2);
    String strB = L"0x" + strColor.substr(4, 2);
    string strColorR = "";
    string strColorG = "";
    string strColorB = "";
    CStrMe::wstringTostring(strColorR, strR);
    CStrMe::wstringTostring(strColorG, strG);
    CStrMe::wstringTostring(strColorB, strB);
    
    int r = (int)strtol(strColorR.c_str(), NULL, 16);
    int g = (int)strtol(strColorG.c_str(), NULL, 16);
    int b = (int)strtol(strColorB.c_str(), NULL, 16);
    return (_int64)COLOR::ARGB(r, g, b);
}

LPDATA CIndicatorMe::GetDatas(int fieldIndex, int mafieldIndex, int index, int n)
{
    LPDATA lpdata;
    lpdata.mode = 1;
    if (index >= 0)
    {
        double value = m_dataSource->Get3(index, mafieldIndex);
        if (!m_dataSource->IsNaN(value))
        {
            lpdata.lastvalue = value;
            if (index >= n - 1)
            {
                double nValue = m_dataSource->Get3(index + 1 - n, fieldIndex);
                if (!m_dataSource->IsNaN(nValue))
                {
                    lpdata.first_value = nValue;
                }
            }
            return lpdata;
        }
        else
        {
            lpdata.mode = 0;
            int start = index - n + 2;
            if (start < 0)
            {
                start = 0;
            }
            for (int i = start; i <= index; i++)
            {
                double lValue = m_dataSource->Get3(i, fieldIndex);
                if (!m_dataSource->IsNaN(lValue))
                {
                    lpdata.sum += lValue;
                }
            }
        }
    }
    return lpdata;
}

float CIndicatorMe::GetLineWidth(const wstring& strLine)
{
    float num = 1;
    int lineSize = (int)strLine.size();
    if (lineSize > 9)
    {
        num = CStrMe::ConvertStrToFloat(strLine.substr(9));
    }
    return num;
}

int CIndicatorMe::GetMiddleScript(const wstring& script, vector<wstring>* lines)
{
    String script1 = CStrMe::Replace(script, L" AND ", L"&");
    String script2 = CStrMe::Replace(script1, L" OR ", L"|");
    String line = L"";
    bool isstr = false;
    wchar_t lh = L'0';
    bool isComment = false;
    bool functionBegin = false;
    int kh = 0;
    bool isReturn = false;
    bool isVar = false;
    bool isNewParam = false;
    bool isSet = false;
    wchar_t *charArray =(wchar_t*)script2.c_str();
    int size = (int)script2.size();
    wchar_t str[16] = {0};
    for(int i = 0; i < size; i ++)
    {
        wchar_t ch = charArray[i];
        // 65279非法字符
        if (ch != 65279)
        {
            if (ch == L'\'')
            {
                isstr = !isstr;
            }
            if (!isstr)
            {
                if (ch == L'{')
                {
                    int lineLength = (int)line.size();
                    if (lineLength == 0)
                    {
                        isComment = true;
                    }
                    else if (!isComment)
                    {
                        kh++;
                        if (functionBegin && (kh == 1))
                        {
                            line = line + L"(";
                        }
                        else if (line.find(L"ELSE") != -1)
                        {
                        }
                        else if (line.rfind(L")") == (lineLength - 1))
                        {
                            line = line.substr(0, lineLength - 1) + VARIABLE2 + L"CHUNK(";
                        }
                        else if (line.rfind(L"))◎ELSE") == (lineLength - 7))
                        {
                            line = line.substr(0, lineLength - 6) + VARIABLE2 + L"CHUNK(";
                        }
                    }
                }
                else if (ch == L'}')
                {
                    if (isComment)
                    {
                        isComment = false;
                    }
                    else
                    {
                        kh--;
                        if (functionBegin && (kh == 0))
                        {
                            int lineLength = (int)line.size();
                            if (lineLength > 0)
                            {
                                wchar_t ch3 = line[lineLength - 1];
                                String str3(&ch3);
                                if (str3 == VARIABLE2)
                                {
                                    line = line.substr(0, lineLength - 1);
                                }
                            }
                            line = line + L")";
                            lines->push_back(line);
                            functionBegin = false;
                            line = L"";
                        }
                        else if (kh == 0)
                        {
                            line = line + L"))";
                            lines->push_back(line);
                            line = L"";
                        }
                        else
                        {
                            line = line + L"))" + VARIABLE2;
                        }
                    }
                }
                else if (ch == L' ')
                {
                    int lineLength = (int)line.size();
                    if (line == L"CONST")
                    {
                        line = L"CONST ";
                    }
                    else if (line == L"FUNCTION")
                    {
                        line = L"FUNCTION ";
                        functionBegin = true;
                    }
                    // 20180603版本添加
                    else if ((!isReturn)
                             && (line.rfind(L"RETURN") == lineLength - 6)) {
                        if ((lineLength == 6)
                            || (line.rfind(L")RETURN") == lineLength - 7)
                            || (line.rfind(L"(RETURN") == lineLength - 7)
                            || (line.rfind(L"◎RETURN") == lineLength - 7)) {
                            line = line + L"(";
                            isReturn = true;
                        }
                    } else if ((!isVar)
                               && (line.rfind(L"VAR") == lineLength - 3)) {
                        if ((lineLength == 3)
                            || (line.rfind(L")VAR") == lineLength - 4)
                            || (line.rfind(L"(VAR") == lineLength - 4)
                            || (line.rfind(L"◎VAR") == lineLength - 4)) {
                            
                            line = line + L"(";
                            isVar = true;
                            isNewParam = true;
                        }
                    } else {
                        if ((isSet)
                            || (line.rfind(L"SET") != lineLength - 3))
                            continue;
                        if ((lineLength == 3)
                            || (line.rfind(L")SET") == lineLength - 4)
                            || (line.rfind(L"(SET") == lineLength - 4)
                            || (line.rfind(L"◎SET") == lineLength - 4)) {
                            
                            line = line.substr(0, lineLength - 3) + L"SET(";
                            isSet = true;
                            isNewParam = true;
                        }
                    }
                }
                else if (((ch != L'\t') && (ch != L'\r')) && ((ch != L'\n') && !isComment))
                {
                    if (ch == L'&')
                    {
                        if (lh != L'&')
                        {
                            wcsncpy(str, &ch, 1);
                            line = line + String(str);
                        }
                    }
                    else if (ch == L'|')
                    {
                        if (lh != L'|')
                        {
                            wcsncpy(str, &ch, 1);
                            line = line + String(str);
                        }
                    }
                    else if (ch == L'=')
                    {
                        if (isVar && isNewParam) {
                            isNewParam = false;
                            line = line + VARIABLE2;
                        } else if (isSet && isNewParam) {
                            isNewParam = false;
                            line = line + VARIABLE2;
                        } else if (lh != L'=' && lh != L'!') {
                            wcsncpy(str, &ch, 1);
                            line = line + String(str);
                        }
                    }
                    else if (ch == L'-')
                    {
                        wcsncpy(str, &lh, 1);
                        String strLh = String(str);
                        if ((strLh != VARIABLE2 && GetOperator(strLh) != -1) && strLh != L")")
                        {
                            line = line + strLh;
                        }
                        else
                        {
                            line = line + VARIABLE3;
                            lh = VARIABLE3[0];
                            continue;
                        }
                    }
                    else if (ch == L',')
                    {
                        isNewParam = true;
                        line = line + VARIABLE2;
                    }
                    else if (ch == L';')
                    {
                        if (isReturn) {
                            line = line + L")";
                            isReturn = false;
                        } else if (isVar) {
                            line = line + L")";
                            isVar = false;
                        } else if (isSet) {
                            line = line + L")";
                            isSet = false;
                        } else {
                            int lineLength = (int)line.length();
                            if (line.rfind(L"BREAK") == lineLength - 5) {
                                if ((line.rfind(L")BREAK") == lineLength - 6)
                                    || (line.rfind(L"(BREAK") == lineLength - 6)
                                    || (line.rfind(L"◎BREAK") == lineLength - 6)) {
                                    line = line + L"()";
                                }
                            } else if (line.rfind(L"CONTINUE") == lineLength - 8) {
                                if ((line.rfind(L")CONTINUE") == lineLength - 9)
                                    || (line.rfind(L"(CONTINUE") == lineLength - 9)
                                    || (line.rfind(L"◎CONTINUE") == lineLength - 9)) {
                                    
                                    line = line + L"()";
                                }
                            }
                        }
                        if (kh > 0)
                        {
                            line = line + VARIABLE2;
                        }
                        else
                        {
                            lines->push_back(line);
                            line = L"";
                        }
                    }
                    else if (ch == L'(')
                    {
                        {
                            int lineLength = (int)line.size();
                            if (kh > 0 && (line.rfind(L"))◎ELSEIF") == lineLength - 9))
                            {
                                line = line.substr(0, lineLength - 9) + L")" + VARIABLE2;
                            }
                            else
                            {
                                line = line + L"(";
                            }
                        }
                    }
                    else
                    {
                        wcsncpy(str, &ch, 1);
                        String newStr = CStrMe::ToUpper(String(str));
                        line = line + newStr;
                    }
                }
            }
            else
            {
                wcsncpy(str, &ch, 1);
                line = line + String(str);
            }
            lh = ch;
        }
    }
    return 0;
}

int CIndicatorMe::GetOperator(const wstring& op)
{
    if(op == L">=")
    {
        return 5;
    }
    else if(op == L"<=")
    {
        return 8;
    }
    else if(op == L"<>")
    {
        return 10;
    }
    else if(op == L"!")
    {
        return 10;
    }
    else if(op == L"+")
    {
        return 0;
    }
    else if(op == VARIABLE3)
    {
        return 13;
    }
    else if(op == L"*")
    {
        return 9;
    }
    else if(op == L"/")
    {
        return 2;
    }
    else if(op == L"(")
    {
        return 6;
    }
    else if(op == L")")
    {
        return 12;
    }
    else if(op == L"=")
    {
        return 3;
    }
    else if(op == L">")
    {
        return 4;
    }
    else if(op == L"<")
    {
        return 7;
    }
    else if(op == L"&")
    {
        return 1;
    }
    else if(op == L"|")
    {
        return 11;
    }
    else if(op == L"%")
    {
        return 14;
    }
    return -1;
}

//double CIndicatorMe::GetValue(CMathElementMe *exp)
//{
//    return 0;
//}

bool CIndicatorMe::IsNumeric(const wstring& str)
{
    string sstr = "";
    CStrMe::wstringTostring(sstr, str);
    return CStrMe::IsNumeric(sstr) > 0 ? true : false;
}

wstring CIndicatorMe::Replace(const wstring& parameter)
{
    int parameterLength = 0;
    wstring* splitParameters = SplitExpression2(parameter, &parameterLength);
    for (int i = 0; i < parameterLength; i++)
    {
        wstring key = splitParameters[i];
        map<wstring,double>::iterator sIter = m_defineParams.find(key);
        if(sIter != m_defineParams.end())
        {
            splitParameters[i] = CStrMe::ConvertDoubleToStr(sIter->second);
        }
        else
        {
            vector<CVariableMe*>::iterator sIterCv =  m_variables.begin();
            for(;sIterCv != m_variables.end(); ++sIterCv)
            {
                CVariableMe* variable = (*sIterCv);
                if (variable->m_type == 2 && variable->m_expression == key)
                {
                    splitParameters[i] = variable->m_name;
                    break;
                }
            }
        }
    }
    wstring newParameter = L"";
    for (int j = 0; j < parameterLength - 1; j++)
    {
        newParameter = newParameter + splitParameters[j];
    }
    return newParameter;
}

CMathElementMe** CIndicatorMe::SplitExpression(const wstring& expression, int *sLength)
{
    vector<wstring> lstItem;
    int expressionSize = (int)expression.size();
    int length = expressionSize;
    wstring item = L"";
    wstring ch = L"";
    bool isstr = false;
    while (length != 0)
    {
        ch = expression.substr(expressionSize - length, 1);
        if (ch == L"'")
        {
            isstr = !isstr;
        }
        if (isstr || (GetOperator(ch) == -1))
        {
            item = item + ch;
        }
        else
        {
            if (item != L"")
            {
                lstItem.push_back(item);
            }
            item = L"";
            int nextIndex = (expressionSize - length) + 1;
            wstring chNext = L"";
            if (nextIndex < (expressionSize - 1))
            {
                chNext = expression.substr(nextIndex, 1);
            }
            wstring unionText = ch + chNext;
            if ((unionText == L">=") || (unionText == L"<=") || (unionText == L"<>"))
            {
                lstItem.push_back(unionText);
                length--;
            }
            else
            {
                lstItem.push_back(ch);
            }
        }
        length--;
    }
    if (item != L"")
    {
        lstItem.push_back(item);
    }
    int lstSize = (int)lstItem.size();
    *sLength = lstSize + 1;
    CMathElementMe** exprs = new CMathElementMe*[*sLength];
    for (int i = 0; i < lstSize; i++)
    {
        CMathElementMe *expr = new CMathElementMe();
        wstring strExpr = lstItem[i];
        int op = GetOperator(strExpr);
        if (op != -1)
        {
            expr->m_type = 0;
            expr->m_value = op;
        }
        else
        {
            double result = 0.0;
            bool success = IsNumeric(strExpr);
            if(success)
            {
                result = CStrMe::ConvertStrToDouble(strExpr);
                expr->m_type = 1;
                expr->m_value = result;
            }
            else
            {
                vector<CVariableMe*>::iterator sIter = m_variables.begin();
                for(; sIter != m_variables.end(); ++sIter)
                {
                    CVariableMe *var = (*sIter);
                    if (var->m_name == strExpr || var->m_expression == strExpr)
                    {
                        expr->m_type = 2;
                        expr->m_var = var;
                        break;
                    }
                }
            }
        }
        exprs[i] = expr;
    }
    CMathElementMe *lExpr = new CMathElementMe();
    lExpr->m_type = 3;
    exprs[lstSize] = lExpr;
    return exprs;
}

wstring* CIndicatorMe::SplitExpression2(const wstring& expression, int *sLength)
{
    wstring *exprs;
    vector<wstring> lstItem;
    int expressionSize = (int)expression.size();
    int length = expressionSize;
    wstring item = L"";
    wstring ch = L"";
    bool isstr = false;
    while (length != 0)
    {
        ch = expression.substr(expressionSize - length, 1);
        if (ch == L"'")
        {
            isstr = !isstr;
        }
        if (isstr || (GetOperator(ch) == -1))
        {
            item = item + ch;
        }
        else
        {
            if (item != L"")
            {
                lstItem.push_back(item);
            }
            item = L"";
            int nextIndex = (expressionSize - length) + 1;
            wstring chNext = L"";
            if (nextIndex < expressionSize - 1)
            {
                chNext = expression.substr(nextIndex, 1);
            }
            wstring unionText = ch + chNext;
            if (unionText == L">=" || unionText == L"<=" || unionText == L"<>")
            {
                lstItem.push_back(unionText);
                length--;
            }
            else
            {
                lstItem.push_back(ch);
            }
        }
        length--;
    }
    if (item != L"")
    {
        lstItem.push_back(item);
    }
    int lstSize = (int)lstItem.size();
    exprs = new wstring[lstSize + 1];
    *sLength = lstSize + 1;
    for (int i = 0; i < lstSize; i++)
    {
        exprs[i] = lstItem[i];
    }
    exprs[lstSize] = L"#";
    return exprs;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CIndicatorMe::CIndicatorMe()
{
    m_break = 0;
    m_index = -1;
    m_attachVScale = AttachVScale_Left;
    m_dataSource = 0;
    m_div = 0;
    m_name = L"";
    m_result = 0;
    m_tag = 0;
    
    vector<wstring> functions = CStrMe::Split(FUNCTIONS, L",");
    vector<wstring> fieldFunctions = CStrMe::Split(FUNCTIONS_FIELD, L",");
    int iSize = (int)functions.size();
    int jSize = (int)fieldFunctions.size();
    for (int i = 0; i < iSize; i++)
    {
        int cType = 0;
        for (int j = 0; j < jSize; j++)
        {
            if (functions[i] == fieldFunctions[j])
            {
                cType = 1;
                break;
            }
        }
        CFunctionMe *function = new CFunctionMe();
        function->m_ID = i;
        function->m_name = functions[i];
        function->m_type = cType;
        m_functions.insert(make_pair(function->m_name, function));
        m_functionsMap.insert(make_pair(i, function));
    }
    m_systemColors.push_back(COLOR::ARGB(255, 255, 255));
    m_systemColors.push_back(COLOR::ARGB(255, 255, 0));
    m_systemColors.push_back(COLOR::ARGB(255, 0, 255));
    m_systemColors.push_back(COLOR::ARGB(0, 255, 0));
    m_systemColors.push_back(COLOR::ARGB(82, 255, 255));
    m_systemColors.push_back(COLOR::ARGB(255, 82, 82));
    m_varFactory = new CVarFactoryMe();
    mutex_x = PTHREAD_MUTEX_INITIALIZER;
}

CIndicatorMe::~CIndicatorMe()
{
    Clear();
    map<wstring, CFunctionMe*>::iterator iter1 = m_functions.begin();
    for(; iter1 != m_functions.end(); ++iter1)
    {
        delete iter1->second;
        iter1->second = 0;
    }
    m_functions.clear();
    m_functionsMap.clear();
    m_name = L"";
}

AttachVScale CIndicatorMe::GetAttachVScale()
{
    return m_attachVScale;
}

void CIndicatorMe::SetAttachVScale(AttachVScale attachVScale)
{
    m_attachVScale = attachVScale;
    vector<CVariableMe*>::iterator sIter = m_variables.begin();
    for(;sIter != m_variables.end(); ++sIter)
    {
        if((*sIter)->m_polylineShape)
        {
            (*sIter)->m_barShape->SetAttachVScale(attachVScale);
            (*sIter)->m_candleShape->SetAttachVScale(attachVScale);
            (*sIter)->m_polylineShape->SetAttachVScale(attachVScale);
            (*sIter)->m_textShape->SetAttachVScale(attachVScale);
        }
    }
}

CTableMe* CIndicatorMe::GetDataSource()
{
    return m_dataSource;
}

void CIndicatorMe::SetDataSource(CTableMe *dataSource)
{
    m_dataSource = dataSource;
}

CDivMe* CIndicatorMe::GetDiv()
{
    return m_div;
}

void CIndicatorMe::SetDiv(CDivMe *div)
{
    m_div = div;
    m_dataSource = m_div->GetChart()->GetDataSource();
}

int CIndicatorMe::GetIndex()
{
    return m_index;
}

wstring CIndicatorMe::GetName()
{
    return m_name;
}

void CIndicatorMe::SetName(const wstring& name)
{
    m_name = name;
}

double CIndicatorMe::GetResult()
{
    return m_result;
}

void CIndicatorMe::SetScript(const wstring& script)
{
    CIndicatorMe::Lock();
    m_lines.clear();
    m_defineParams.clear();
    vector<wstring> lines;
    GetMiddleScript(script, &lines);
    int linesCount = (int)lines.size();
    for (int i = 0; i < linesCount; i++)
    {
        wstring strLine = lines[i];
        if(CStrMe::startswith(strLine, L"FUNCTION"))
        {
            wstring funcName = CStrMe::ToUpper(strLine.substr(9, strLine.find(L'(')));
            CFunctionMe *function = new CFunctionMe();
            function->m_ID = FUNCTIONID_FUNCTION;
            function->m_name = funcName;
            AddFunction(function);
        }
        else if(CStrMe::startswith(strLine, L"CONST"))
        {
            vector<wstring> consts = CStrMe::Split(strLine.substr(6), L":");
            m_defineParams.insert(make_pair(consts[0], CStrMe::ConvertStrToDouble(consts[1])));
            lines.erase(lines.begin() + i);
            i--;
            linesCount--;
        }
    }
    linesCount = (int)lines.size();
    for (int i = 0; i < linesCount; i++) {
        AnalysisScriptLine(lines[i]);
    }
    lines.clear();
    CIndicatorMe::UnLock();
}

vector<_int64> CIndicatorMe::GetSystemColors()
{
    return m_systemColors;
}

void CIndicatorMe::SetSystemColors(vector<_int64> systemColors)
{
    m_systemColors = systemColors;
}

void* CIndicatorMe::GetTag()
{
    return m_tag;
}

void CIndicatorMe::SetTag(void *tag)
{
    m_tag = tag;
}

CVarFactoryMe* CIndicatorMe::GetVarFactory()
{
    return m_varFactory;
}

void CIndicatorMe::SetVarFactory(CVarFactoryMe *varFactory)
{
    m_varFactory = varFactory;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void CIndicatorMe::AddFunction(CFunctionMe *function)
{
    m_functions.insert(make_pair(function->m_name, function));
    m_functionsMap.insert(make_pair(function->m_ID, function));
}

double CIndicatorMe::CallFunction(String funcName)
{
    double result = 0;
    CIndicatorMe::Lock();
    vector<String> lines;
    GetMiddleScript(funcName, &lines);
    int linesSize = (int)lines.size();
    m_result = 0;
    for (int i = 0; i < linesSize; i++) {
        String str = lines[i];
        int cindex = (int)str.find(L"(");
        String upperName = CStrMe::ToUpper(str.substr(0, cindex));
        map<String, CVariableMe*>::iterator sIter = m_tempFunctions.find(upperName) ;
        if(sIter != m_tempFunctions.end())
        {
            CVariableMe *function =sIter->second;
            int rindex = (int)str.rfind(L")");
            CVariableMe *topVar = new CVariableMe();
            topVar->m_indicator = this;
            if (rindex - cindex > 1)
            {
                String pStr = str.substr(cindex + 1, rindex - cindex - 1);
                vector<String> pList = CStrMe::Split(pStr, VARIABLE2);
                vector<String> fieldTexts = CStrMe::Split(function->m_fieldText, VARIABLE2);
                int pListLen = (int)pList.size();
                if ((pListLen != 1) || (pList[0].length() != 0))
                {
                    int length = pListLen * 2;
                    CVariableMe **parametersArr = new CVariableMe*[length];
                    topVar->m_parameters = parametersArr;
                    topVar->m_parametersLength = length;
                    for (int j = 0; j < pListLen; j++)
                    {
                        String pName = fieldTexts[j];
                        String pValue = pList[j];
                        CVariableMe *varName = 0;
                        map<String, CVariableMe*>::iterator sIterTemp = m_tempVariables.find(pName);
                        if(sIterTemp != m_tempVariables.end())
                        {
                            varName = sIterTemp->second;
                        }
                        
                        CVariableMe *varValue = new CVariableMe();
                        varValue->m_indicator = this;
                        varValue->m_expression = pValue;
                        if(CStrMe::startswith(pValue, L"'") == 0)
                        {
                            varValue->m_type = 1;
                        }
                        else
                        {
                            varValue->m_type = 3;
                            varValue->m_value = CStrMe::ConvertStrToDouble(pValue.c_str());
                        }
                        topVar->m_parameters[(j * 2)] = varName;
                        topVar->m_parameters[(j * 2 + 1)] = varValue;
                    }
                    FUNCVAR(topVar);
                }
            }
            GetValue(function);
            if(topVar->m_parametersLength > 0)
            {
                for (int j = 0; j < topVar->m_parametersLength; j++)
                {
                    if (j % 2 == 0)
                    {
                        int id = topVar->m_parameters[j]->m_field;
                        map<int, CVarMe*>::iterator sIterVar = m_tempVars.find(id);
                        if(sIterVar != m_tempVars.end())
                        {
                            CVarMe *cVar = sIterVar->second;
                            if (cVar->m_parent) {
                                m_tempVars.insert(make_pair(id, cVar->m_parent));
                            }
                            else
                            {
                                m_tempVars.erase(sIterVar);
                            }
                            delete cVar;
                            cVar = 0;
                        }
                    }
                }
            }
        }
    }
    lines.clear();
    result = m_result;
    m_result = 0;
    CIndicatorMe::UnLock();
    return result;
}

void CIndicatorMe::Clear()
{
    CIndicatorMe::Lock();
    if (m_div)
    {
        vector<CBaseShapeMe*> shapes = GetShapes();
        vector<CBaseShapeMe*>::iterator sIter = shapes.begin();
        for(; sIter != shapes.end(); ++sIter)
        {
            m_div->RemoveShape(*sIter);
            m_div->GetTitleBar()->Titles.clear();
            //delete *sIter;
            *sIter = 0;
        }
        shapes.clear();
    }
    
    vector<CVariableMe*>::iterator sIter = m_variables.begin();
    for(; sIter != m_variables.end(); ++sIter)
    {
        CVariableMe *variable = (*sIter);
        if (variable->m_field >= 10000)
        {
            m_dataSource->RemoveColumn(variable->m_field);
            if (variable->m_tempFields)
            {
                int size = variable->m_tempFieldsLength;
                for (int i = 0; i < size; i++)
                {
                    if (variable->m_tempFields[i] >= 10000)
                    {
                        m_dataSource->RemoveColumn(variable->m_tempFields[i]);
                    }
                }
            }
        }
    }
    m_variables.clear();
    
    vector<CVariableMe*>::iterator iter3 = m_lines.begin();
    for(; iter3 != m_lines.end(); ++iter3)
    {
        delete *iter3;
        *iter3 = 0;
    }
    m_lines.clear();
    m_mainVariables.clear();
    m_defineParams.clear();
    map<wstring, CVariableMe*>::iterator sIterTempF = m_tempFunctions.begin();
    for(; sIterTempF != m_tempFunctions.end(); ++sIterTempF)
    {
        delete sIterTempF->second;
        sIterTempF->second = 0;
    }
    m_tempFunctions.clear();
    
    DeleteTempVars();
    map<wstring, CVariableMe*>::iterator sIterTempV = m_tempVariables.begin();
    for(; sIterTempV != m_tempVariables.end(); ++sIterTempV)
    {
        delete sIterTempV->second;
        sIterTempV->second = 0;
    }
    m_tempVariables.clear();
    CIndicatorMe::UnLock();
}

void CIndicatorMe::DeleteTempVars()
{
    map<int, CVarMe*>::iterator sIter = m_tempVars.begin();
    while(sIter != m_tempVars.end())
    {
        vector<int> removeIDs;
        map<int, CVarMe*>::iterator sIterInner = m_tempVars.begin();
        for(;sIterInner != m_tempVars.end(); ++sIterInner)
        {
            removeIDs.push_back(sIterInner->first);
        }
        int removeIDsSize = (int)removeIDs.size();
        for(int i = 0 ; i < removeIDsSize; i++)
        {
            int removeID = removeIDs[i];
            map<int, CVarMe*>::iterator sIteRemove = m_tempVars.find(removeID);
            if(sIteRemove != m_tempVars.end())
            {
                CVarMe *cVar = sIteRemove->second;
                if(cVar->m_parent)
                {
                    m_tempVars.insert(make_pair(removeID, cVar->m_parent));
                }
                else
                {
                    m_tempVars.erase(sIteRemove);
                }
                delete cVar;
                cVar = 0;
            }
        }
        removeIDs.clear();
        sIter = m_tempVars.begin();
    }
}

void CIndicatorMe::DeleteTempVars(CVariableMe *var)
{
    if (var->m_parameters && var->m_parametersLength > 0)
    {
        int length = var->m_parametersLength;
        for (int i = 0; i < length; i++)
        {
            CVariableMe *parameter = var->m_parameters[i];
            if (parameter->m_splitExpression && parameter->m_splitExpressionLength > 0)
            {
                CVariableMe *subVar = parameter->m_splitExpression[0]->m_var;
                if (subVar && ((subVar->m_functionID == FUNCTIONID_FUNCVAR) || (subVar->m_functionID == FUNCTIONID_VAR)))
                {
                    int sunLen = subVar->m_parametersLength;
                    for (int j = 0; j < sunLen; j++)
                    {
                        if ((j % 2) == 0)
                        {
                            CVariableMe sunVar = (*subVar->m_parameters)[j];
                            int field = sunVar.m_field;
                            if (sunVar.m_expression.find(L"[REF]") == 0)
                            {
                                int variablesSize = (int)m_variables.size();
                                for (int k = 0; k < variablesSize; k++)
                                {
                                    CVariableMe *variable = m_variables[k];
                                    if (variable->m_expression == sunVar.m_expression)
                                    {
                                        variable->m_field = field;
                                    }
                                }
                            }
                            else
                            {
                                map<int, CVarMe*>::iterator sIterV = m_tempVars.find(field);
                                if(sIterV != m_tempVars.end())
                                {
                                    CVarMe *cVar = sIterV->second;
                                    if (cVar->m_parent)
                                    {
                                        m_tempVars.insert(make_pair(field, cVar->m_parent));
                                    }
                                    else
                                    {
                                        m_tempVars.erase(sIterV);
                                    }
                                    delete cVar;
                                    cVar = 0;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

vector<CFunctionMe*> CIndicatorMe::GetFunctions()
{
    vector<CFunctionMe*> list;
    map<wstring, CFunctionMe*>::iterator sIter = m_functions.begin();
    for(;sIter != m_functions.end(); ++sIter)
    {
        list.push_back(sIter->second);
    }
    return list;
}

///获取图形列表
vector<CBaseShapeMe*> CIndicatorMe::GetShapes()
{
    vector<CBaseShapeMe*> list;
    vector<CVariableMe*>::iterator sIter = m_variables.begin();
    for(;sIter != m_variables.end(); ++sIter)
    {
        CVariableMe *variable = (*sIter);
        if(variable->m_barShape)
        {
            list.push_back(variable->m_barShape);
        }
        if(variable->m_candleShape)
        {
            list.push_back(variable->m_candleShape);
        }
        if(variable->m_polylineShape)
        {
            list.push_back(variable->m_polylineShape);
        }
        if(variable->m_textShape)
        {
            list.push_back(variable->m_textShape);
        }
    }
    return list;
}

wstring CIndicatorMe::GetText(CVariableMe *var)
{
    int size = (int)var->m_expression.size();
    if ((size > 0) && (var->m_expression[0] == L'\''))
    {
        //TODO
        return var->m_expression.substr(1, size - 2);
    }
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(var->m_field);
    if(sIter != m_tempVars.end())
    {
        CVarMe* var2 = sIter->second;
        return var2->GetText(this, var);
    }
    return CStrMe::ConvertDoubleToStr(GetValue(var));
}

double CIndicatorMe::GetValue(CVariableMe *var)
{
    switch (var->m_type)
    {
        case 0:
            return CallFunction(var);
            
        case 1:
        {
            map<int, CVarMe*>::iterator sIter = m_tempVars.find(var->m_field);
            if(sIter != m_tempVars.end())
            {
                CVarMe *var2 = sIter->second;
                return var2->GetValue(this, var);
            }
            
            int size = (int)var->m_expression.size();
            if (size > 0 && var->m_expression[0] == L'\'')
            {
                return CStrMe::ConvertStrToDouble(var->m_expression.substr(1, size - 2));
            }
            if (var->m_splitExpression && var->m_splitExpressionLength > 0)
            {
                return Calculate(var->m_splitExpression, var->m_splitExpressionLength);
            }
            return 0.0;
        }
        case 2:
            return m_dataSource->Get3(m_index, var->m_fieldIndex);
        case 3:
            return var->m_value;
    }
    return 0.0;
}

void CIndicatorMe::Lock()
{
    pthread_mutex_lock(&mutex_x);
}

void CIndicatorMe::OnCalculate(int index)
{
    CIndicatorMe::Lock();
    int lineSize = (int)m_lines.size();
    if (lineSize > 0)
    {
        vector<CVariableMe*>::iterator sIterLine = m_lines.begin();
        for(; sIterLine != m_lines.end(); ++sIterLine)
        {
            CVariableMe *sentence = (*sIterLine);
            if (sentence->m_field != -1)
            {
                sentence->m_fieldIndex = m_dataSource->GetColumnIndex(sentence->m_field);
            }
        }
        
        vector<CVariableMe*>::iterator sIterCV = m_variables.begin();
        for(; sIterCV != m_variables.end(); ++sIterCV)
        {
            CVariableMe *var = (*sIterCV);
            if (var->m_field != -1)
            {
                var->m_fieldIndex = m_dataSource->GetColumnIndex(var->m_field);
            }
            if (var->m_tempFields && var->m_tempFieldsLength > 0)
            {
                for (int j = 0; j < var->m_tempFieldsLength; j++)
                {
                    var->m_tempFieldsIndex[j] = m_dataSource->GetColumnIndex(var->m_tempFields[j]);
                }
            }
        }
        int rowCount = m_dataSource->RowsCount();
        for (int i = index; i < rowCount; i++)
        {
            m_index = i;
            int lineSize = (int)m_lines.size();
            for (int j = 0; j < lineSize; j++)
            {
                CVariableMe *sentence = m_lines[j];
                if ((sentence->m_funcName == L"") || ((sentence->m_funcName != L"") && (sentence->m_line != j)))
                {
                    double value = Calculate(sentence->m_splitExpression, sentence->m_splitExpressionLength);
                    if ((sentence->m_type == 1) && (sentence->m_field != CTableMe::NULLFIELD()))
                    {
                        m_dataSource->Set3(i, sentence->m_fieldIndex, value);
                    }
                }
            }
        }
    }
    CIndicatorMe::UnLock();
}

void CIndicatorMe::RemoveFunction(CFunctionMe *function)
{
    map<wstring, CFunctionMe*>::iterator sIter = m_functions.find(function->m_name);
    if(sIter != m_functions.end())
    {
        delete sIter->second;
        sIter->second = 0;
        m_functions.erase(sIter);
    }
    
    map<int, CFunctionMe*>::iterator sIterMap = m_functionsMap.find(function->m_ID);
    if(sIterMap != m_functionsMap.end())
    {
        delete sIterMap->second;
        sIterMap->second = 0;
        m_functionsMap.erase(sIterMap);
    }
}

void CIndicatorMe::SetSourceField(const wstring& key, int value)
{
    CVariableMe *pfunc = new CVariableMe();
    pfunc->m_indicator = this;
    pfunc->m_type = 2;
    pfunc->m_name = VARIABLE1 + CStrMe::ConvertIntToStr((int)m_variables.size());
    pfunc->m_expression = key;
    int sLength = 0;
    pfunc->m_splitExpression = SplitExpression(key, &sLength);
    pfunc->m_splitExpressionLength = sLength;
    pfunc->m_field = value;
    int columnIndex = m_dataSource->GetColumnIndex(value);
    if (columnIndex == -1)
    {
        m_dataSource->AddColumn(value);
    }
    m_variables.push_back(pfunc);
}

void CIndicatorMe::SetSourceValue(int index, const wstring& key, double value)
{
    CVariableMe *pfunc = 0;
    vector<CVariableMe*>::iterator sIterCV = m_variables.begin();
    for(; sIterCV != m_variables.end(); ++sIterCV)
    {
        CVariableMe *var = (*sIterCV);
        if ((var->m_type == 3) && (var->m_expression == key))
        {
            pfunc = var;
            break;
        }
    }
    
    if (pfunc)
    {
        m_dataSource->Set2(index, pfunc->m_field, value);
    }
}

void CIndicatorMe::SetVariable(CVariableMe *variable, CVariableMe *parameter)
{
    
    int type = variable->m_type;
    int field = variable->m_field;
    if(type == 2)
    {
        
        double value = GetValue(parameter);
        m_dataSource->Set3(m_index, variable->m_fieldIndex, value);
    }
    else
    {
        map<int, CVarMe*>::iterator sIter = m_tempVars.find(field);
        if(sIter != m_tempVars.end())
        {
            CVarMe *var = sIter->second;
            var->SetValue(this, variable, parameter);
            // TODO
            if (m_resultVar.m_str.length() > 0)
            {
                var->m_str = m_resultVar.m_str;
                m_resultVar.m_str = L"";
            }
        }
        else
        {
            variable->m_value = GetValue(parameter);
        }
    }
}

void CIndicatorMe::UnLock()
{
    pthread_mutex_unlock(&mutex_x);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double CIndicatorMe::ABS2(CVariableMe *var)
{
    return abs(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::ACOS(CVariableMe *var)
{
    return acos(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::AMA(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    double lastAma = 0.0;
    if (m_index > 0)
    {
        lastAma = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
    }
    double n = GetValue(var->m_parameters[1]);
    double ama = lastAma + (n * (close - lastAma));
    m_dataSource->Set3(m_index, var->m_fieldIndex, ama);
    return ama;
}

double CIndicatorMe::ASIN(CVariableMe *var)
{
    return asin(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::ATAN(CVariableMe *var)
{
    return atan(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::AVEDEV(CVariableMe *var)
{
    int p = (int)GetValue(var->m_parameters[1]);
    CVariableMe *cParam = var->m_parameters[0];
    int closeFieldIndex = cParam->m_fieldIndex;
    double close = GetValue(cParam);
    int closeField = cParam->m_field;
    if (closeFieldIndex == CTableMe::NULLFIELD())
    {
        if (var->m_tempFields)
        {
            var->CreateTempFields(1);
        }
        closeFieldIndex = var->m_tempFieldsIndex[0];
        closeField = var->m_tempFields[0];
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int size = 0;
    double *list = m_dataSource->DATA_ARRAY(closeField, m_index, p, &size);
    double avg = 0.0;
    if (list && size > 0)
    {
        double sum = 0.0;
        for (int i = 0; i < size; i++)
        {
            sum += list[i];
        }
        avg = sum / ((double)size);
    }
    return CMathLibMe::M002(close, list, size, avg);
}

int CIndicatorMe::BARSCOUNT(CVariableMe *var)
{
    return m_dataSource->RowsCount();
}

int CIndicatorMe::BARSLAST(CVariableMe *var)
{
    int result = 0;
    int index = m_index;
    for (int i = m_index; i >= 0; i--)
    {
        m_index = i;
        double value = GetValue(&(*var->m_parameters)[0]);
        if (value == 1.0) {
            break;
        }
        if (i == 0)
        {
            result = 0;
        }
        else
        {
            result++;
        }
    }
    m_index = index;
    return result;
}

int CIndicatorMe::BETWEEN(CVariableMe *var)
{
    double value = GetValue(var->m_parameters[0]);
    double min = GetValue(var->m_parameters[1]);
    double max = GetValue(var->m_parameters[2]);
    int result = 0;
    if ((result >= min) && (value <= max))
    {
        result = 1;
    }
    return result;
}

int CIndicatorMe::BREAK(CVariableMe *var)
{
    m_break = 2;
    return 0;
}

double CIndicatorMe::CEILING(CVariableMe *var)
{
    return ceil(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::CHUNK(CVariableMe *var)
{
    if (var->m_parametersLength > 0) {
        for (int i = 0; (m_break == 0) && (i < var->m_parametersLength); i++) {
            GetValue(var->m_parameters[i]);
        }
    }
    DeleteTempVars(var);
    return 0.0;
}

double CIndicatorMe::COS(CVariableMe *var)
{
    return cos(GetValue(var->m_parameters[0]));
}

int CIndicatorMe::CONTINUE(CVariableMe *var)
{
    m_break = 3;
    return 0;
}

int CIndicatorMe::COUNT(CVariableMe *var)
{
    int rowsCount = (int)GetValue(var->m_parameters[1]);
    if (rowsCount < 0)
    {
        rowsCount = m_dataSource->RowsCount();
    }
    else if (rowsCount > m_index + 1)
    {
        rowsCount = m_index + 1;
    }
    int tempIndex = m_index;
    int result = 0;
    for (int i = 0; i < rowsCount; i++)
    {
        if (GetValue(var->m_parameters[0]) > 0.0)
        {
            result++;
        }
        m_index--;
    }
    m_index = tempIndex;
    return result;
}

int CIndicatorMe::CROSS(CVariableMe *var)
{
    double x = GetValue(var->m_parameters[0]);
    double y = GetValue(var->m_parameters[1]);
    int result = 0;
    int tempIndex = m_index;
    m_index--;
    if (m_index < 0)
    {
        m_index = 0;
    }
    double lastX = GetValue(var->m_parameters[0]);
    double lastY = GetValue(var->m_parameters[1]);
    m_index = tempIndex;
    if ((x >= y) && (lastX < lastY))
    {
        result = 1;
    }
    return result;
}

int CIndicatorMe::CURRBARSCOUNT(CVariableMe *var)
{
    return m_index + 1;
}

int CIndicatorMe::DATE(CVariableMe *var)
{
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(m_dataSource->GetXValue(m_index), &year, &month, &day, &hour, &minute, &second, &ms);
    return (((year * 10000) + (month * 100)) + day);
}

int CIndicatorMe::DAY(CVariableMe *var)
{
    double num = m_dataSource->GetXValue(m_index);
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(num, &year, &month, &day, &hour, &minute, &second, &ms);
    return day;
}

int CIndicatorMe::DELETE2(CVariableMe *var)
{
    int pLen = var->m_parametersLength;
    for (int i = 0; i < pLen; i++) {
        CVariableMe *name = var->m_parameters[i];
        int id = name->m_field;
        map<int, CVarMe*>::iterator sIter = m_tempVars.find(id);
        if(sIter != m_tempVars.end())
        {
            CVarMe *cVar = sIter->second;
            if (cVar->m_parent)
            {
                m_tempVars.insert(make_pair(id, cVar->m_parent));
            }
            else
            {
                delete cVar;
                cVar = 0;
                m_tempVars.erase(sIter);
            }
        }
    }
    return 0;
    
}

double CIndicatorMe::DMA(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    double lastDma = 0.0;
    if (m_index > 0)
    {
        lastDma = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
    }
    double n = GetValue(var->m_parameters[1]);
    double result = (n * close) + ((1.0 - n) * lastDma);
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

int CIndicatorMe::DOTIMES(CVariableMe *var)
{
    int n = (int) GetValue(var->m_parameters[0]);
    int pLen = var->m_parametersLength;
    if (pLen > 1) {
        for (int i = 0; i < n; i++) {
            for (int j = 1; (m_break == 0) && (j < pLen); j++) {
                GetValue(var->m_parameters[j]);
            }
            if (m_break > 0) {
                if (m_break == 3) {
                    m_break = 0;
                    DeleteTempVars(var);
                } else {
                    m_break = 0;
                    DeleteTempVars(var);
                    break;
                }
            } else {
                DeleteTempVars(var);
            }
        }
    }
    return 0;
    
}

int CIndicatorMe::DOWHILE(CVariableMe *var)
{
    int pLen = var->m_parametersLength;
    if (pLen > 1) {
        for (;;) {
            for (int i = 0; (m_break == 0) && (i < pLen - 1); i++) {
                GetValue(var->m_parameters[i]);
            }
            if (m_break > 0) {
                if (m_break == 3) {
                    m_break = 0;
                    DeleteTempVars(var);
                } else {
                    m_break = 0;
                    DeleteTempVars(var);
                    break;
                }
            } else {
                double inLoop = GetValue(var->m_parameters[(pLen - 1)]);
                DeleteTempVars(var);
                if (inLoop <= 0.0) {
                    break;
                }
            }
        }
    }
    return 0;
}

int CIndicatorMe::DOWNNDAY(CVariableMe *var)
{
    int rowsCount = (int)GetValue(var->m_parameters[0]);
    if (rowsCount < 0)
    {
        rowsCount = m_dataSource->RowsCount();
    }
    else if (rowsCount > m_index + 1)
    {
        rowsCount = m_index + 1;
    }
    int tempIndex = m_index;
    int result = 1;
    for (int i = 0; i < rowsCount; i++)
    {
        double right = GetValue(var->m_parameters[0]);
        m_index--;
        double left = (m_index >= 0) ? GetValue(var->m_parameters[0]) : 0.0;
        if (right >= left)
        {
            result = 0;
            break;
        }
    }
    m_index = tempIndex;
    return result;
}

double CIndicatorMe::DRAWICON(CVariableMe *var)
{
    if (m_div)
    {
        CVariableMe *cond = var->m_parameters[0];
        CVariableMe *price = var->m_parameters[1];
        PolylineShape *polylineShape;
        if (var->m_polylineShape)
        {
            polylineShape = var->m_polylineShape;
        }
        else
        {
            wstring strColor = L"COLORAUTO";
            wstring strStyle = L"CIRCLEDOT";
            for (int i = 2; i < var->m_parametersLength; i++)
            {
                wstring strParam = var->m_parameters[i]->m_expression;
                if (CStrMe::startswith(strParam, L"COLOR"))
                {
                    strColor = strParam;
                    break;
                }
                if ((strParam == L"CIRCLEDOT") || (strParam == L"POINTDOT"))
                {
                    strStyle = strParam;
                    break;
                }
            }
            if (var->m_expression == L"DRAWICON")
            {
                strStyle = var->m_expression;
            }
            polylineShape = new PolylineShape();
            m_div->AddShape(polylineShape);
            _int64 color = GetColor(strColor);
            polylineShape->SetAttachVScale(m_attachVScale);
            polylineShape->SetFieldText(price->m_fieldText);
            polylineShape->SetColor(color);
            polylineShape->SetStyle(PolylineStyle_Cycle);
            var->CreateTempFields(1);
            var->m_polylineShape = polylineShape;
        }
        int size = (int)price->m_expression.size();
        if ((price->m_expression != L"") && (size > 0))
        {
            if (polylineShape->GetFieldName() == CTableMe::NULLFIELD())
            {
                if (price->m_field != CTableMe::NULLFIELD())
                {
                    polylineShape->SetFieldName(price->m_field);
                }
                else
                {
                    price->CreateTempFields(1);
                    polylineShape->SetFieldName(price->m_tempFields[0]);
                }
                for (int j = 2; j < var->m_parametersLength; j++)
                {
                    if ((var->m_parameters[j]->m_expression == L"DRAWTITLE") && (polylineShape->GetFieldText() != L""))
                    {
                        m_div->GetTitleBar()->Titles.push_back(new CTitleMe(polylineShape->GetFieldName(),
                                                                          polylineShape->GetFieldText(), polylineShape->GetColor(), 2, true));
                    }
                }
            }
            if (price->m_tempFields && price->m_tempFieldsLength > 0)
            {
                double value = GetValue(price);
                m_dataSource->Set3(m_index, price->m_tempFieldsIndex[0], value);
            }
        }
        double dCond = 1.0;
        if (((cond->m_expression != L"") && ((int)(cond->m_expression.size()) > 0)) && (cond->m_expression != L"1"))
        {
            dCond = GetValue(cond);
            if (dCond != 1.0)
            {
                m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], -10000.0);
            }
            else
            {
                m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], 1.0);
            }
        }
    }
    return 0.0;
}

double CIndicatorMe::DRAWKLINE(CVariableMe *var)
{
    if (m_div)
    {
        CVariableMe *high = var->m_parameters[0];
        CVariableMe *open = var->m_parameters[1];
        CVariableMe *low = var->m_parameters[2];
        CVariableMe *close = var->m_parameters[3];
        CandleShape *candleShape;
        if (!var->m_candleShape)
        {
            candleShape = new CandleShape();
            candleShape->SetHighFieldText(high->m_fieldText);
            candleShape->SetOpenFieldText(open->m_fieldText);
            candleShape->SetLowFieldText(low->m_fieldText);
            candleShape->SetCloseFieldText(close->m_fieldText);
            candleShape->SetAttachVScale(m_attachVScale);
            candleShape->SetStyle(CandleStyle_Rect);
            m_div->AddShape(candleShape);
            var->m_candleShape = candleShape;
        }
        else
        {
            candleShape = var->m_candleShape;
        }
        if ((high->m_expression != L"") && ((int)(high->m_expression.size()) > 0))
        {
            if (candleShape->GetHighField() == CTableMe::NULLFIELD())
            {
                if (high->m_field != -1)
                {
                    candleShape->SetHighField(high->m_field);
                }
                else
                {
                    high->CreateTempFields(1);
                    candleShape->SetHighField(high->m_tempFields[0]);
                }
            }
            if (high->m_tempFields)
            {
                double value = GetValue(high);
                m_dataSource->Set3(m_index, high->m_tempFieldsIndex[0], value);
            }
        }
        if ((open->m_expression != L"") && ((int)open->m_expression.size() > 0))
        {
            if (open->m_field != CTableMe::NULLFIELD())
            {
                candleShape->SetOpenField(open->m_field);
            }
            else
            {
                open->CreateTempFields(1);
                candleShape->SetOpenField(open->m_tempFields[0]);
            }
            if (open->m_tempFields)
            {
                double value = GetValue(open);
                m_dataSource->Set3(m_index, open->m_tempFieldsIndex[0], value);
            }
        }
        if ((low->m_expression != L"") && ((int)low->m_expression.size() > 0))
        {
            if (low->m_field != CTableMe::NULLFIELD())
            {
                candleShape->SetLowField(low->m_field);
            }
            else
            {
                low->CreateTempFields(1);
                candleShape->SetLowField(low->m_tempFields[0]);
            }
            if (low->m_tempFields)
            {
                double num3 = GetValue(low);
                m_dataSource->Set3(m_index, low->m_tempFieldsIndex[0], num3);
            }
        }
        if ((close->m_expression != L"") && ((int)close->m_expression.size() > 0))
        {
            if (close->m_field != CTableMe::NULLFIELD())
            {
                candleShape->SetCloseField(close->m_field);
            }
            else
            {
                close->CreateTempFields(1);
                candleShape->SetCloseField(close->m_tempFields[0]);
            }
            if (close->m_tempFields)
            {
                double value = GetValue(close);
                m_dataSource->Set3(m_index, close->m_tempFieldsIndex[0], value);
            }
        }
    }
    return 0.0;
}

double CIndicatorMe::DRAWNULL(CVariableMe *var)
{
    return m_dataSource->NaN;
}

double CIndicatorMe::DRAWTEXT(CVariableMe *var)
{
    if (m_div)
    {
        CVariableMe *cond = var->m_parameters[0];
        CVariableMe *price = var->m_parameters[1];
        CVariableMe *text = var->m_parameters[2];
        TextShape *textShape = 0;
        if (var->m_textShape)
        {
            textShape = var->m_textShape;
        }
        else
        {
            textShape = new TextShape();
            textShape->SetAttachVScale(m_attachVScale);
            textShape->SetText(GetText(text));
            var->CreateTempFields(1);
            textShape->SetStyleField(var->m_tempFields[0]);
            wstring strColor = L"COLORAUTO";
            for (int i = 3; i < var->m_parametersLength; i++)
            {
                wstring expression = var->m_parameters[i]->m_expression;
                if (CStrMe::startswith(expression, L"COLOR"))
                {
                    strColor = expression;
                    break;
                }
            }
            if (strColor != L"COLORAUTO")
            {
                textShape->SetForeColor(GetColor(strColor));
            }
            m_div->AddShape(textShape);
            var->m_textShape = textShape;
        }
        if ((price->m_expression != L"") && ((int)price->m_expression.size() > 0))
        {
            if (textShape->GetFieldName() == CTableMe::NULLFIELD())
            {
                if (price->m_field != CTableMe::NULLFIELD())
                {
                    textShape->SetFieldName(price->m_field);
                }
                else
                {
                    price->CreateTempFields(1);
                    textShape->SetFieldName(price->m_tempFields[0]);
                }
            }
            if (price->m_tempFields)
            {
                double value = GetValue(price);
                m_dataSource->Set3(m_index, price->m_tempFieldsIndex[0], value);
            }
        }
        double dCond = 1.0;
        if (((cond->m_expression != L"") && ((int)cond->m_expression.size() > 0)) && (cond->m_expression != L"1"))
        {
            dCond = GetValue(cond);
            if (dCond != 1.0)
            {
                m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], -10000.0);
            }
            else
            {
                m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], 0.0);
            }
        }
    }
    return 0.0;
}

int CIndicatorMe::EXIST(CVariableMe *var)
{
    int rowsCount = (int)GetValue(var->m_parameters[1]);
    if (rowsCount < 0)
    {
        rowsCount = m_dataSource->RowsCount();
    }
    else if (rowsCount > (m_index + 1))
    {
        rowsCount = m_index + 1;
    }
    int tempIndex = m_index;
    int result = 0;
    for (int i = 0; i < rowsCount; i++)
    {
        if (GetValue(var->m_parameters[0]) > 0.0)
        {
            result = 1;
            break;
        }
        m_index--;
    }
    m_index = tempIndex;
    return result;
}

double CIndicatorMe::EMA(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    double lastEma = 0.0;
    if (m_index > 0)
    {
        lastEma = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
    }
    int n = (int)GetValue(var->m_parameters[1]);
    double result = CMathLibMe::M006(n, close, lastEma);
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

int CIndicatorMe::EVERY(CVariableMe *var)
{
    int rowsCount = (int)GetValue(var->m_parameters[1]);
    if (rowsCount < 0)
    {
        rowsCount = m_dataSource->RowsCount();
    }
    else if (rowsCount > (m_index + 1))
    {
        rowsCount = m_index + 1;
    }
    int tempIndex = m_index;
    int result = 1;
    for (int i = 0; i < rowsCount; i++)
    {
        if (GetValue(var->m_parameters[0]) <= 0.0)
        {
            result = 0;
            break;
        }
        m_index--;
    }
    m_index = tempIndex;
    return result;
}

double CIndicatorMe::EXPMEMA(CVariableMe *var)
{
    CVariableMe *cParam = var->m_parameters[0];
    double close = GetValue(cParam);
    int closeFieldIndex = cParam->m_fieldIndex;
    int n = (int)GetValue(var->m_parameters[1]);
    if (!var->m_tempFields)
    {
        if (closeFieldIndex == CTableMe::NULLFIELD())
        {
            var->CreateTempFields(2);
        }
        else
        {
            var->CreateTempFields(1);
        }
    }
    if (var->m_tempFieldsLength == 2)
    {
        closeFieldIndex = var->m_tempFieldsIndex[1];
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int mafieldIndex = var->m_tempFieldsIndex[0];
    double ma = CMathLibMe::M003(m_index, n, close, GetDatas(closeFieldIndex, mafieldIndex, m_index - 1, n));
    m_dataSource->Set3(m_index, mafieldIndex, ma);
    double lastEMA = 0.0;
    if (m_index > 0)
    {
        lastEMA = m_dataSource->Get3(m_index, var->m_fieldIndex);
    }
    double result = CMathLibMe::M006(n, ma, lastEMA);
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

double CIndicatorMe::EXP(CVariableMe *var)
{
    return exp(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::FLOOR(CVariableMe *var)
{
    return floor(GetValue(var->m_parameters[0]));
}

int CIndicatorMe::FOR(CVariableMe *var)
{
    int pLen = var->m_parametersLength;
    if (pLen > 3) {
        int start = (int) GetValue(var->m_parameters[0]);
        int end = (int) GetValue(var->m_parameters[1]);
        int step = (int) GetValue(var->m_parameters[2]);
        if (step > 0) {
            for (int i = start; i < end; i += step) {
                for (int j = 3; j < pLen; j++) {
                    GetValue(var->m_parameters[j]);
                    if (m_break != 0) {
                        break;
                    }
                }
                if (m_break > 0) {
                    if (m_break == 3) {
                        m_break = 0;
                        DeleteTempVars(var);
                    } else {
                        m_break = 0;
                        DeleteTempVars(var);
                        break;
                    }
                } else {
                    DeleteTempVars(var);
                }
            }
        } else if (step < 0) {
            for (int i = start; i > end; i += step) {
                for (int j = 3; j < pLen; j++) {
                    if (m_break != 0) {
                        break;
                    }
                }
                if (m_break > 0) {
                    if (m_break == 3) {
                        m_break = 0;
                        DeleteTempVars(var);
                    } else {
                        m_break = 0;
                        DeleteTempVars(var);
                        break;
                    }
                } else {
                    DeleteTempVars(var);
                }
            }
        }
    }
    return 0;
}

double CIndicatorMe::FUNCTION(CVariableMe *var)
{
    m_result = 0.0;
    if (var->m_parameters) {
        int pLen = var->m_parametersLength;
        if (pLen > 0) {
            for (int i = 0; i < pLen; i++) {
                GetValue(var->m_parameters[i]);
            }
        }
    }
    String name = var->m_expression;
    map<wstring, CVariableMe*>::iterator sIter = m_tempFunctions.find(name);
    if (sIter != m_tempFunctions.end())
    {
        GetValue(sIter->second);
    }
    if (m_break == 1) {
        m_break = 0;
    }
    double result = m_result;
    m_result = 0.0;
    DeleteTempVars(var);
    return result;
}

double CIndicatorMe::FUNCVAR(CVariableMe *var)
{
    double result = 0.0;
    int pLen = var->m_parametersLength;
    map<CVarMe*, int> cVars;
    for (int i = 0; i < pLen; i++) {
        if (i % 2 == 0) {
            CVariableMe *name = var->m_parameters[i];
            CVariableMe *value = var->m_parameters[(i + 1)];
            int id = name->m_field;
            if ((int)name->m_expression.find(L"[REF]") == 0) {
                int variablesSize = (int)m_variables.size();
                for (int j = 0; j < variablesSize; j++) {
                    CVariableMe *variable = m_variables[j];
                    if (variable != name) {
                        if (variable->m_field == id) {
                            variable->m_field = value->m_field;
                        }
                    }
                }
            } else {
                CVarMe *newCVar = m_varFactory->CreateVar();
                result = newCVar->OnCreate(this, name, value);
                if (newCVar->m_type == 1)
                {
                    name->m_functionID = CTableMe::NULLFIELD();
                }
                cVars.insert(make_pair(newCVar, id));
            }
        }
    }
    map<CVarMe*, int>::iterator sIter = cVars.begin();
    for(; sIter != cVars.end(); ++sIter)
    {
        int id = sIter->second;
        CVarMe *newCVar = sIter->first;
        map<int, CVarMe*>::iterator sIter1 = m_tempVars.find(id);
        if(sIter1 != m_tempVars.end())
        {
            CVarMe *cVar = sIter1->second;
            newCVar->m_parent = cVar;
        }
        m_tempVars.insert(make_pair(id, newCVar));
    }
    cVars.clear();
    return result;
}

double CIndicatorMe::GET(CVariableMe *var)
{
    return GetValue(var->m_parameters[0]);
}

double CIndicatorMe::HHV(CVariableMe *var)
{
    int n = (int)GetValue(var->m_parameters[1]);
    CVariableMe *cParam = var->m_parameters[0];
    int closeFieldIndex = cParam->m_fieldIndex;
    int closeField = cParam->m_field;
    if (closeFieldIndex == CTableMe::NULLFIELD())
    {
        if (!cParam->m_tempFields)
        {
            cParam->CreateTempFields(0);
        }
        closeFieldIndex = cParam->m_tempFieldsIndex[0];
        closeField = cParam->m_tempFields[0];
        double close = GetValue(cParam);
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int length = 0;
    double* higharray = m_dataSource->DATA_ARRAY(closeField, m_index, n, &length);
    return CMathLibMe::GetMax(higharray, length);
}

double CIndicatorMe::HHVBARS(CVariableMe *var)
{
    int n = (int)GetValue(var->m_parameters[1]);
    CVariableMe *cParam = var->m_parameters[0];
    int closeField = cParam->m_field;
    if (cParam->m_fieldIndex == CTableMe::NULLFIELD())
    {
        if (!cParam->m_tempFields)
        {
            cParam->CreateTempFields(0);
        }
        closeField = cParam->m_tempFields[0];
        int closeFieldIndex = cParam->m_tempFieldsIndex[0];
        double close = GetValue(cParam);
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int length = 0;
    double* higharray = m_dataSource->DATA_ARRAY(closeField, m_index, n, &length);
    double result = 0.0;
    if (length <= 0)
    {
        return result;
    }
    int mIndex = 0;
    double close = 0.0;
    for (int i = 0; i < length; i++)
    {
        if (i == 0)
        {
            close = higharray[i];
            mIndex = 0;
        }
        else if (higharray[i] > close)
        {
            close = higharray[i];
            mIndex = i;
        }
    }
    return (length - mIndex - 1);
}

int CIndicatorMe::HOUR(CVariableMe *var)
{
    double num = m_dataSource->GetXValue(m_index);
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(num, &year, &month, &day, &hour, &minute, &second, &ms);
    return hour;
}

double CIndicatorMe::IF(CVariableMe *var)
{
    double result = 0.0;
    int length = var->m_parametersLength;
    for (int i = 0; i < length; i++)
    {
        result = GetValue(var->m_parameters[i]);
        if ((i % 2) != 0)
        {
            break;
        }
        if (result == 0.0)
        {
            i++;
        }
    }
    DeleteTempVars(var);
    return result;
}

double CIndicatorMe::IFN(CVariableMe *var)
{
    double result = 0.0;
    int length = var->m_parametersLength;
    for (int i = 0; i < length; i++)
    {
        result = GetValue(var->m_parameters[i]);
        if ((i % 2) != 0)
        {
            break;
        }
        if (result != 0.0)
        {
            i++;
        }
    }
    DeleteTempVars(var);
    return result;
}

double CIndicatorMe::INTPART(CVariableMe *var)
{
    double result = GetValue(var->m_parameters[0]);
    if (result == 0.0)
    {
        return result;
    }
    int intResult = (int)result;
    double sub = abs(result - intResult);
    if (sub >= 0.5)
    {
        if (result > 0.0)
        {
            result = intResult - 1;
        } else
        {
            result = intResult + 1;
        }
    }
    else
    {
        result = intResult;
    }
    return intResult;
}

int CIndicatorMe::LAST(CVariableMe *var)
{
    int n = (int)GetValue(var->m_parameters[1]);
    int m = (int)GetValue(var->m_parameters[2]);
    if (n < 0)
    {
        n = m_dataSource->RowsCount();
    }
    else if (n > (m_index + 1))
    {
        n = m_index + 1;
    }
    if (m < 0)
    {
        m = m_dataSource->RowsCount();
    }
    else if (m > (m_index + 1))
    {
        m = m_index + 1;
    }
    int tempIndex = m_index;
    int result = 1;
    for (int i = m; i < n; i++)
    {
        m_index = tempIndex - m;
        if (GetValue(var->m_parameters[0]) <= 0.0)
        {
            result = 0;
            break;
        }
    }
    m_index = tempIndex;
    return result;
}

double CIndicatorMe::LLV(CVariableMe *var)
{
    int n = (int)GetValue(var->m_parameters[1]);
    CVariableMe *cParam = var->m_parameters[0];
    int closeField = cParam->m_field;
    int closeFieldIndex = cParam->m_fieldIndex;
    if (closeField == CTableMe::NULLFIELD())
    {
        if (!cParam->m_tempFields)
        {
            cParam->CreateTempFields(0);
        }
        closeField = cParam->m_tempFields[0];
        closeFieldIndex = cParam->m_tempFieldsIndex[0];
        double close = GetValue(cParam);
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int length = 0;
    double* lowarray = m_dataSource->DATA_ARRAY(closeField, m_index, n, &length);
    return CMathLibMe::GetMin(lowarray, length);
}

double CIndicatorMe::LLVBARS(CVariableMe *var)
{
    int n = (int)GetValue(var->m_parameters[1]);
    CVariableMe *cParam = var->m_parameters[0];
    int closeField = cParam->m_field;
    int closeFieldIndex = cParam->m_fieldIndex;
    if (closeField == CTableMe::NULLFIELD())
    {
        if (!cParam->m_tempFields)
        {
            cParam->CreateTempFields(0);
        }
        closeField = cParam->m_tempFields[0];
        closeFieldIndex = cParam->m_tempFieldsIndex[0];
        double close = GetValue(cParam);
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int length = 0;
    double* lowarray = m_dataSource->DATA_ARRAY(closeField, m_index, n, &length);
    double result = 0.0;
    if (length <= 0)
    {
        return result;
    }
    int mIndex = 0;
    double close = 0.0;
    for (int i = 0; i < length; i++)
    {
        if (i == 0)
        {
            close = lowarray[i];
            mIndex = 0;
        }
        else if (lowarray[i] < close)
        {
            close = lowarray[i];
            mIndex = i;
        }
    }
    return (length - mIndex - 1);
}

double CIndicatorMe::LOG(CVariableMe *var)
{
    return log10(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::MA(CVariableMe *var)
{
    CVariableMe *cParam = var->m_parameters[0];
    double close = GetValue(cParam);
    int n = (int)GetValue(var->m_parameters[1]);
    int closeFieldIndex = cParam->m_fieldIndex;
    if (closeFieldIndex == CTableMe::NULLFIELD())
    {
        if (!var->m_tempFields)
        {
            var->CreateTempFields(1);
        }
        closeFieldIndex = var->m_tempFieldsIndex[0];
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    double result = CMathLibMe::M003(m_index, n, close, GetDatas(closeFieldIndex, var->m_fieldIndex, m_index - 1, n));
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

double CIndicatorMe::MAX2(CVariableMe *var)
{
    double left = GetValue(var->m_parameters[0]);
    double right = GetValue(var->m_parameters[1]);
    if (left >= right)
    {
        return left;
    }
    return right;
}

double CIndicatorMe::MEMA(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    int n = (int)GetValue(var->m_parameters[1]);
    double lastMema = 0.0;
    if (m_index > 0)
    {
        lastMema = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
    }
    double result = CMathLibMe::M015(close, lastMema, n, 1);
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

double CIndicatorMe::MIN2(CVariableMe *var)
{
    double left = GetValue(var->m_parameters[0]);
    double right = GetValue(var->m_parameters[1]);
    if (left <= right)
    {
        return left;
    }
    return right;
}

int CIndicatorMe::MINUTE(CVariableMe *var)
{
    double num = m_dataSource->GetXValue(m_index);
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(num, &year, &month, &day, &hour, &minute, &second, &ms);
    return minute;
}

double CIndicatorMe::MOD(CVariableMe *var)
{
    double left = GetValue(var->m_parameters[0]);
    double right = GetValue(var->m_parameters[1]);
    if (right != 0.0)
    {
        return ((int)left % (int)right);
    }
    return 0.0;
}

int CIndicatorMe::MONTH(CVariableMe *var)
{
    double num = m_dataSource->GetXValue(m_index);
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(num, &year, &month, &day, &hour, &minute, &second, &ms);
    return month;
}

int CIndicatorMe::NDAY(CVariableMe *var)
{
    int rowsCount = (int)GetValue(var->m_parameters[2]);
    if (rowsCount < 0)
    {
        rowsCount = m_dataSource->RowsCount();
    }
    else if (rowsCount > (m_index + 1))
    {
        rowsCount = m_index + 1;
    }
    int tempIndex = m_index;
    int result = 1;
    for (int i = 0; i < rowsCount; i++)
    {
        if (GetValue(var->m_parameters[0]) <= GetValue(var->m_parameters[1]))
        {
            result = 0;
            break;
        }
        m_index--;
    }
    m_index = tempIndex;
    return result;
}

int CIndicatorMe::NOT(CVariableMe *var)
{
    if (GetValue(var->m_parameters[0]) == 0.0)
    {
        return 1;
    }
    return 0;
}

double CIndicatorMe::POLYLINE(CVariableMe *var)
{
    if (m_div)
    {
        CVariableMe *cond = var->m_parameters[0];
        CVariableMe *price = var->m_parameters[1];
        PolylineShape *polylineShape;
        if (!var->m_polylineShape)
        {
            wstring strColor = L"COLORAUTO";
            wstring strLineWidth = L"LINETHICK";
            bool dotLine = false;
            for (int i = 2; i < var->m_parametersLength; i++)
            {
                wstring expression = var->m_parameters[i]->m_expression;
                if (CStrMe::startswith(expression, L"COLOR"))
                {
                    strColor = expression;
                }
                else if (CStrMe::startswith(expression, L"LINETHICK"))
                {
                    strLineWidth = expression;
                }
                else if (CStrMe::startswith(expression, L"DOTLINE"))
                {
                    dotLine = true;
                }
            }
            polylineShape = new PolylineShape();
            m_div->AddShape(polylineShape);
            polylineShape->SetAttachVScale(m_attachVScale);
            polylineShape->SetColor(GetColor(strColor));
            polylineShape->SetWidth(GetLineWidth(strLineWidth));
            var->CreateTempFields(1);
            polylineShape->SetColorField(var->m_tempFields[0]);
            polylineShape->SetFieldText(price->m_fieldText);
            if (dotLine)
            {
                polylineShape->SetStyle(PolylineStyle_DotLine);
            }
            var->m_polylineShape = polylineShape;
        }
        else
        {
            polylineShape = var->m_polylineShape;
        }
        if ((price->m_expression != L"") && ((int)price->m_expression.size() > 0))
        {
            if (polylineShape->GetFieldName() == -1)
            {
                if (price->m_field != CTableMe::NULLFIELD())
                {
                    polylineShape->SetFieldName(price->m_field);
                }
                else
                {
                    price->CreateTempFields(1);
                    polylineShape->SetFieldName(price->m_tempFields[0]);
                }
                for (int j = 2; j < var->m_parametersLength; j++)
                {
                    if ((var->m_parameters[j]->m_expression == L"DRAWTITLE") && (polylineShape->GetFieldText() != L""))
                    {
                        m_div->GetTitleBar()->Titles.push_back(new CTitleMe(polylineShape->GetFieldName(), polylineShape->GetFieldText(), polylineShape->GetColor(), 2, true));
                    }
                }
            }
            if (price->m_tempFieldsIndex)
            {
                double value = GetValue(price);
                m_dataSource->Set3(m_index, price->m_tempFieldsIndex[0], value);
            }
        }
        double dCond = 1.0;
        if (((cond->m_expression != L"") && ((int)cond->m_expression.size() > 0)) && (cond->m_expression != L"1"))
        {
            dCond = GetValue(cond);
            if (dCond != 1.0)
            {
                m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], -10000.0);
            }
            else
            {
                m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], 1.0);
            }
        }
    }
    return 0.0;
}

double CIndicatorMe::POW(CVariableMe *var)
{
    double x = GetValue(var->m_parameters[0]);
    double y = GetValue(var->m_parameters[1]);
    return pow(x, y);
}

int CIndicatorMe::RAND(CVariableMe *var)
{
    int num = (int)GetValue(var->m_parameters[0]);
    return (rand() % (num + 1 - 0 + 1)) + 0;
}

double CIndicatorMe::REF(CVariableMe *var)
{
    int param = (int)GetValue(var->m_parameters[1]);
    param = m_index - param;
    double result = 0.0;
    if (param >= 0)
    {
        int index = m_index;
        m_index = param;
        result = GetValue(var->m_parameters[0]);
        m_index = index;
    }
    return result;
}

double CIndicatorMe::RETURN(CVariableMe *var)
{
    m_resultVar.m_list = 0;
    m_resultVar.m_map = 0;
    m_resultVar.m_num = 0;
    m_resultVar.m_type = 0;
    m_resultVar.m_parent = 0;
    m_resultVar.m_str = L"";
    m_result = GetValue(var->m_parameters[0]);
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(var->m_parameters[0]->m_field);
    if(sIter != m_tempVars.end())
    {
        m_resultVar.m_num = sIter->second->m_num;
        m_resultVar.m_type = sIter->second->m_type;
        m_resultVar.m_str = sIter->second->m_str;
    }
    else if (var->m_parameters[0]->m_expression.find(L'\'') == 0)
    {
        //m_resultVar = new CVarMe();
        m_resultVar.m_type = 1;
        m_resultVar.m_str = var->m_parameters[0]->m_expression;
    }
    m_break = 1;
    return m_result;
}

double CIndicatorMe::REVERSE(CVariableMe *var)
{
    return -GetValue(var->m_parameters[0]);
}

double CIndicatorMe::ROUND(CVariableMe *var)
{
    return CStrMe::round(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::SAR(CVariableMe *var)
{
    int n = (int)GetValue(var->m_parameters[2]);
    double s = GetValue(var->m_parameters[3]) / 100.0;
    double m = GetValue(var->m_parameters[4]) / 100.0;
    double high = 0.0;
    double low = 0.0;
    CVariableMe *hParam = var->m_parameters[0];
    CVariableMe *lParam = var->m_parameters[1];
    high = GetValue(hParam);
    low = GetValue(lParam);
    if (!var->m_tempFields)
    {
        if ((hParam->m_field == CTableMe::NULLFIELD()) || (lParam->m_field == CTableMe::NULLFIELD()))
        {
            var->CreateTempFields(4);
        }
        else
        {
            var->CreateTempFields(2);
        }
    }
    int highField = hParam->m_field;
    int highFieldIndex = hParam->m_fieldIndex;
    if (highField == CTableMe::NULLFIELD())
    {
        highField = var->m_tempFields[2];
        highFieldIndex = var->m_tempFieldsIndex[2];
        m_dataSource->Set3(m_index, highFieldIndex, high);
    }
    int lowField = lParam->m_field;
    int lowFieldIndex = lParam->m_fieldIndex;
    if (lowField == CTableMe::NULLFIELD())
    {
        lowField = var->m_tempFields[3];
        lowFieldIndex = var->m_tempFieldsIndex[3];
        m_dataSource->Set3(m_index, lowFieldIndex, low);
    }
    int highLength = 0;
    int lowLength = 0;
    double* high_list = m_dataSource->DATA_ARRAY(highField, m_index - 1, n, &highLength);
    double* low_list = m_dataSource->DATA_ARRAY(lowField, m_index - 1, n, &lowLength);
    double hhv = CMathLibMe::GetMax(high_list, highLength);
    double llv = CMathLibMe::GetMin(low_list, lowLength);
    int lastState = 0;
    double lastSar = 0.0;
    double lastAf = 0.0;
    if (m_index > 0)
    {
        lastState = (int)m_dataSource->Get3(m_index - 1, var->m_tempFieldsIndex[0]);
        lastSar = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
        lastAf = m_dataSource->Get3(m_index - 1, var->m_tempFieldsIndex[1]);
    }
    int state = 0;
    double af = 0.0;
    double sar = 0.0;
    CMathLibMe::M001(m_index, n, s, m, high, low, hhv, llv, lastState, lastSar, lastAf, &state, &af, &sar);
    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[1], af);
    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], (double)state);
    m_dataSource->Set3(m_index, var->m_fieldIndex, sar);
    return sar;
}

double CIndicatorMe::SET(CVariableMe *var)
{
    int pLen = var->m_parametersLength;
    for (int i = 0; i < pLen; i++) {
        if (i % 2 == 0) {
            CVariableMe *variable = var->m_parameters[i];
            CVariableMe *parameter = var->m_parameters[(i + 1)];
            SetVariable(variable, parameter);
        }
    }
    return 0.0;
}

int CIndicatorMe::SIGN(CVariableMe *var)
{
    double num = GetValue(var->m_parameters[0]);
    if (num > 0.0)
    {
        return 1;
    }
    if (num < 0.0)
    {
        return -1;
    }
    return 0;
}

double CIndicatorMe::SIN(CVariableMe *var)
{
    return sin(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::SMA(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    int n = (int)GetValue(var->m_parameters[1]);
    int m = (int)GetValue(var->m_parameters[2]);
    double lastSma = 0.0;
    if (m_index > 0)
    {
        lastSma = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
    }
    double result = CMathLibMe::M015(close, lastSma, n, m);
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

double CIndicatorMe::SQRT(CVariableMe *var)
{
    return sqrt(GetValue(var->m_parameters[0]));
}

double CIndicatorMe::SQUARE(CVariableMe *var)
{
    double num = GetValue(var->m_parameters[0]);
    return (num * num);
}

double CIndicatorMe::STD(CVariableMe *var)
{
    int p = (int)GetValue(var->m_parameters[1]);
    CVariableMe *cParam = var->m_parameters[0];
    double close = GetValue(cParam);
    int closeField = cParam->m_field;
    int closeFieldIndex = cParam->m_fieldIndex;
    if (closeField == CTableMe::NULLFIELD())
    {
        if (!var->m_tempFields)
        {
            var->CreateTempFields(1);
        }
        closeField = var->m_tempFields[0];
        closeFieldIndex = var->m_tempFieldsIndex[0];
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int length = 0;
    double* list = m_dataSource->DATA_ARRAY(closeField, m_index, p, &length);
    double avg = 0.0;
    double sum = 0.0;
    if (list && length > 0)
    {
        for (int i = 0; i < length; i++)
        {
            sum += list[i];
        }
        avg = sum / ((double)length);
    }
    return CMathLibMe::M007(list, length, avg, 1.0);
}

double CIndicatorMe::STICKLINE(CVariableMe *var)
{
    if (m_div)
    {
        CVariableMe *cond = var->m_parameters[0];
        CVariableMe *price1 = var->m_parameters[1];
        CVariableMe *price2 = var->m_parameters[2];
        CVariableMe *width = var->m_parameters[3];
        CVariableMe *empty = var->m_parameters[4];
        BarShape *barShape = 0;
        if (var->m_barShape)
        {
            barShape = var->m_barShape;
        }
        else
        {
            barShape = new BarShape();
            m_div->AddShape(barShape);
            barShape->SetAttachVScale(m_attachVScale);
            barShape->SetFieldText(price1->m_fieldText);
            barShape->SetFieldText2(price2->m_fieldText);
            CVariableMe *color = 0;
            for (int i = 5; i < var->m_parametersLength; i++)
            {
                if (CStrMe::startswith(var->m_parameters[i]->m_expression, L"COLOR"))
                {
                    color = var->m_parameters[i];
                    break;
                }
            }
            if (color)
            {
                barShape->SetUpColor(GetColor(color->m_expression));
                barShape->SetDownColor(GetColor(color->m_expression));
            }
            else
            {
                barShape->SetUpColor(COLOR::ARGB(255, 82, 82));
                barShape->SetDownColor(COLOR::ARGB(82, 255, 255));
            }
            barShape->SetStyle(BarStyle_Line);
            var->CreateTempFields(1);
            barShape->SetStyleField(var->m_tempFields[0]);
            barShape->SetLineWidth((int)CStrMe::round(CStrMe::ConvertStrToDouble(width->m_expression)));
            var->m_barShape = barShape;
        }
        if ((price1->m_expression != L"") && ((int)price1->m_expression.size() > 0))
        {
            if (barShape->GetFieldName() == CTableMe::NULLFIELD())
            {
                if (price1->m_field != CTableMe::NULLFIELD())
                {
                    barShape->SetFieldName(price1->m_field);
                }
                else
                {
                    price1->CreateTempFields(1);
                    barShape->SetFieldName(price1->m_tempFields[0]);
                }
                for (int j = 5; j < var->m_parametersLength; j++)
                {
                    if (var->m_parameters[j]->m_expression == L"DRAWTITLE")
                    {
                        if (barShape->GetFieldText() != L"")
                        {
                            m_div->GetTitleBar()->Titles.push_back(new CTitleMe(barShape->GetFieldName(),
                                                                              barShape->GetFieldText(), barShape->GetDownColor(), 2, true));
                        }
                        break;
                    }
                }
            }
            if (price1->m_tempFieldsIndex)
            {
                double value = GetValue(price1);
                m_dataSource->Set3(m_index, price1->m_tempFieldsIndex[0], value);
            }
        }
        if (((price2->m_expression != L"") && ((int)price2->m_expression.size() > 0)) && (price2->m_expression != L"0"))
        {
            if (price2->m_field != CTableMe::NULLFIELD())
            {
                barShape->SetFieldName2(price2->m_field);
            }
            else
            {
                price2->CreateTempFields(1);
                barShape->SetFieldName2(price2->m_tempFields[0]);
            }
            if (price2->m_tempFieldsIndex)
            {
                double value = GetValue(price2);
                m_dataSource->Set3(m_index, price2->m_tempFieldsIndex[0], value);
            }
        }
        double dCond = 1.0;
        if (((cond->m_expression != L"") && ((int)cond->m_expression.size() > 0)) && (cond->m_expression != L"1"))
        {
            dCond = GetValue(cond);
            if (dCond != 1.0)
            {
                m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], -10000.0);
            }
            else
            {
                int dEmpty = 2;
                if ((empty->m_expression != L"") && ((int)empty->m_expression.size() > 0))
                {
                    dEmpty = (int)GetValue(empty);
                    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], (double)dEmpty);
                }
            }
        }
    }
    return 0.0;
}

double CIndicatorMe::SUM(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    int closeFieldIndex = var->m_parameters[0]->m_fieldIndex;
    if (closeFieldIndex == CTableMe::NULLFIELD())
    {
        if (!var->m_tempFields)
        {
            var->CreateTempFields(1);
        }
        closeFieldIndex = var->m_tempFieldsIndex[0];
        m_dataSource->Set3(m_index, closeFieldIndex, close);
    }
    int n = (int)GetValue(var->m_parameters[1]);
    if (n == 0)
    {
        n = m_index + 1;
    }
    double result = CMathLibMe::M004(m_index, n, close, GetDatas(closeFieldIndex, var->m_fieldIndex, m_index - 1, n));
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

double CIndicatorMe::TAN(CVariableMe *var)
{
    return tan(GetValue(var->m_parameters[0]));
}

int CIndicatorMe::TIME(CVariableMe *var)
{
    double num = m_dataSource->GetXValue(m_index);
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(num, &year, &month, &day, &hour, &minute, &second, &ms);
    return ((hour * 100) + minute);
}

int CIndicatorMe::TIME2(CVariableMe *var)
{
    double num = m_dataSource->GetXValue(m_index);
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(num, &year, &month, &day, &hour, &minute, &second, &ms);
    return (((hour * 10000) + (minute * 100)) + second);
}

double CIndicatorMe::TMA(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    int n = (int)GetValue(var->m_parameters[1]);
    int m = (int)GetValue(var->m_parameters[2]);
    double lastTma = 0.0;
    if (m_index > 0)
    {
        lastTma = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
    }
    double result = (n * lastTma) + (m * close);
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

int CIndicatorMe::UPNDAY(CVariableMe *var)
{
    int rowsCount = (int)GetValue(var->m_parameters[0]);
    if (rowsCount < 0)
    {
        rowsCount = m_dataSource->RowsCount();
    }
    else if (rowsCount > m_index + 1)
    {
        rowsCount = m_index + 1;
    }
    int tempIndex = m_index;
    int result = 1;
    for (int i = 0; i < rowsCount; i++)
    {
        double right = GetValue(var->m_parameters[0]);
        m_index--;
        double left = (m_index >= 0) ? GetValue(var->m_parameters[0]) : 0.0;
        if (right <= left)
        {
            result = 0;
            break;
        }
    }
    m_index = tempIndex;
    return result;
}

double CIndicatorMe::VALUEWHEN(CVariableMe *var)
{
    int rowsCount = m_dataSource->RowsCount();
    int tempIndex = m_index;
    double result = 0.0;
    for (int i = 0; i < rowsCount; i++)
    {
        if (GetValue(var->m_parameters[0]) == 1.0)
        {
            result = GetValue(var->m_parameters[1]);
            break;
        }
        m_index--;
    }
    m_index = tempIndex;
    return result;
}

double CIndicatorMe::VAR(CVariableMe *var)
{
    double result = 0.0;
    int pLen = var->m_parametersLength;
    for (int i = 0; i < pLen; i++) {
        if (i % 2 == 0) {
            CVariableMe *name = var->m_parameters[i];
            CVariableMe *value = var->m_parameters[(i + 1)];
            int id = name->m_field;
            CVarMe *newCVar = m_varFactory->CreateVar();
            result = newCVar->OnCreate(this, name, value);
            if (newCVar->m_type == 1)
            {
                name->m_functionID = -1;
            }
            
            map<int, CVarMe*>::iterator sIter = m_tempVars.find(id);
            if (sIter != m_tempVars.end())
            {
                CVarMe *cVar = sIter->second;
                newCVar->m_parent = cVar;
            }
            m_tempVars.insert(make_pair(id, newCVar));
        }
    }
    return result;
}

int CIndicatorMe::WHILE(CVariableMe *var)
{
    int pLen = var->m_parametersLength;
    if (pLen > 1) {
        while (GetValue(var->m_parameters[0]) > 0.0) {
            for (int i = 1; (m_break == 0) && (i < pLen); i++) {
                GetValue(var->m_parameters[i]);
            }
            if (m_break > 0) {
                if (m_break == 3) {
                    m_break = 0;
                    DeleteTempVars(var);
                } else {
                    m_break = 0;
                    DeleteTempVars(var);
                    break;
                }
            } else {
                DeleteTempVars(var);
            }
        }
    }
    return 0;
}

double CIndicatorMe::WMA(CVariableMe *var)
{
    double close = GetValue(var->m_parameters[0]);
    int n = (int) GetValue(var->m_parameters[1]);
    int m = (int) GetValue(var->m_parameters[2]);
    double lastWma = 0.0;
    if (m_index > 0) {
        lastWma = m_dataSource->Get3(m_index - 1, var->m_fieldIndex);
    }
    double result = CMathLibMe::M005(n, m, close, lastWma);
    m_dataSource->Set3(m_index, var->m_fieldIndex, result);
    return result;
}

int CIndicatorMe::YEAR(CVariableMe *var)
{
    double num = m_dataSource->GetXValue(m_index);
    int year = 0;
    int month = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int second = 0;
    int ms = 0;
    CMathLibMe::M130(num, &year, &month, &day, &hour, &minute, &second, &ms);
    return year;
}

double CIndicatorMe::ZIG(CVariableMe *var)
{
    double sxp = 0.0;
    double exp = 0.0;
    int state = 0;
    int sxi = 0;
    int exi = 0;
    double p = GetValue(var->m_parameters[1]);
    CVariableMe *cParam = var->m_parameters[0];
    double close = GetValue(cParam);
    int fieldIndex = cParam->m_fieldIndex;
    if (!var->m_tempFields)
    {
        if (fieldIndex == -1)
        {
            var->CreateTempFields(6);
        }
        else
        {
            var->CreateTempFields(5);
        }
    }
    if (fieldIndex == -1)
    {
        fieldIndex = var->m_tempFieldsIndex[5];
        m_dataSource->Set3(m_index, fieldIndex, close);
    }
    if (m_index > 0)
    {
        state = (int)m_dataSource->Get3(m_index - 1, var->m_tempFieldsIndex[0]);
        exp = m_dataSource->Get3(m_index - 1, var->m_tempFieldsIndex[1]);
        sxp = m_dataSource->Get3(m_index - 1, var->m_tempFieldsIndex[2]);
        sxi = (int)m_dataSource->Get3(m_index - 1, var->m_tempFieldsIndex[3]);
        exi = (int)m_dataSource->Get3(m_index - 1, var->m_tempFieldsIndex[4]);
    }
    int cStart = -1;
    int cEnd = -1;
    double k = 0.0;
    double b = 0.0;
    CMathLibMe::M013(m_index, close, p, &sxp, &sxi, &exp, &exi, &state, &cStart, &cEnd, &k, &b);
    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[0], (double)state);
    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[1], exp);
    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[2], sxp);
    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[3], (double)sxi);
    m_dataSource->Set3(m_index, var->m_tempFieldsIndex[4], (double)exi);
    if ((cStart != -1) && (cEnd != -1))
    {
        return 1.0;
    }
    return 0.0;
}

int CIndicatorMe::STR_CONTACT(CVariableMe *var)
{
    int pLen = var->m_parametersLength;
    String text = L"'";
    for (int i = 1; i < pLen; i++) {
        text = text + GetText(var->m_parameters[i]);
    }
    text = text + L"'";
    m_resultVar.m_type = 1;
    m_resultVar.m_str = text;
    return 0;
    
}

int CIndicatorMe::STR_EQUALS(CVariableMe *var)
{
    int result = 0;
    if (GetText(var->m_parameters[0]) == (GetText(var->m_parameters[1]))) {
        result = 1;
    }
    return result;
}

int CIndicatorMe::STR_FIND(CVariableMe *var)
{
    return (int)GetText(var->m_parameters[0]).find(
                                                   GetText(var->m_parameters[1]));
}

int CIndicatorMe::STR_FINDLAST(CVariableMe *var)
{
    return (int)GetText(var->m_parameters[0]).rfind(
                                                    GetText(var->m_parameters[1]));
}

int CIndicatorMe::STR_LENGTH(CVariableMe *var)
{
    return (int)GetText(var->m_parameters[0]).size();
}

int CIndicatorMe::STR_SUBSTR(CVariableMe *var)
{
    int pLen = var->m_parametersLength;
    if (pLen == 2)
    {
        m_resultVar.m_type = 1;
        String result = GetText(var->m_parameters[0]);
        int value = (int)GetValue(var->m_parameters[1]);
        int size = (int)result.size();
        m_resultVar.m_str = (L"'" + result.substr(value, size - value) + L"'");
    }
    else if (pLen >= 3)
    {
        m_resultVar.m_type = 1;
        m_resultVar.m_str = (L"'" + GetText(var->m_parameters[0]).substr((int)GetValue(var->m_parameters[1]),
                                                                         (int)GetValue(var->m_parameters[1]) + (int)GetValue(var->m_parameters[2])) + L"'");
    }
    return 0;
}

int CIndicatorMe::STR_REPLACE(CVariableMe *var)
{
    m_resultVar.m_type = 1;
    m_resultVar.m_str = (L"'" + CStrMe::Replace(GetText(var->m_parameters[0]), GetText(var->m_parameters[1]),
                                              GetText(var->m_parameters[2])) + L"'");
    return 1;
}

int CIndicatorMe::STR_SPLIT(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int id = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(id);
    if(sIter != m_tempVars.end())
    {
        vector<wstring> *list = sIter->second->m_list;
        list->clear();
        vector<wstring> strs = CStrMe::Split(GetText(var->m_parameters[1]), GetText(var->m_parameters[2]));
        int strsSize = (int)strs.size();
        for (int i = 0; i < strsSize; i++) {
            if ((int)strs[i].size() > 0) {
                list->push_back(strs[i]);
            }
        }
        return 1;
    }
    return 0;
}

int CIndicatorMe::STR_TOLOWER(CVariableMe *var)
{
    m_resultVar.m_type = 1;
    m_resultVar.m_str = CStrMe::ToLower(GetText(var->m_parameters[0]));
    return 0;
}

int CIndicatorMe::STR_TOUPPER(CVariableMe *var)
{
    m_resultVar.m_type = 1;
    m_resultVar.m_str = CStrMe::ToUpper(GetText(var->m_parameters[0]));
    return 0;
}

int CIndicatorMe::LIST_ADD(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int listName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(listName);
    if(sIter != m_tempVars.end())
    {
        vector<String> *list = sIter->second->m_list;
        int pLen = var->m_parametersLength;
        for (int i = 1; i < pLen; i++) {
            list->push_back(GetText(var->m_parameters[i]));
        }
        return 1;
    }
    return 0;
}

int CIndicatorMe::LIST_CLEAR(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int listName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(listName);
    if(sIter != m_tempVars.end())
    {
        sIter->second->m_list->clear();
        return 1;
    }
    return 0;
    
}

int CIndicatorMe::LIST_GET(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[1];
    int listName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(listName);
    if(sIter != m_tempVars.end())
    {
        vector<wstring> *list = sIter->second->m_list;
        int index = (int) GetValue(var->m_parameters[2]);
        if (index < (int)list->size()) {
            wstring strValue =  (*list)[index];
            CVariableMe *variable = var->m_parameters[0];
            int id = variable->m_field;
            int type = variable->m_type;
            double value = CStrMe::ConvertStrToDouble(strValue);
            switch (type) {
                case 2:
                    m_dataSource->Set3(m_index, variable->m_fieldIndex, value);
                    break;
                default:
                    map<int, CVarMe*>::iterator sIter1 = m_tempVars.find(id);
                    if(sIter1 != m_tempVars.end())
                    {
                        CVariableMe *newVar = new CVariableMe();
                        newVar->m_indicator = this;
                        newVar->m_type = 1;
                        newVar->m_expression = (L"'" + strValue + L"'");
                        sIter1->second->SetValue(this, variable, newVar);
                    }
                    break;
            }
        }
        return 1;
    }
    return 0;
    
}

int CIndicatorMe::LIST_INSERT(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int listName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(listName);
    if(sIter != m_tempVars.end())
    {
        vector<wstring> *list = sIter->second->m_list;
        list->insert(list->begin() + (int) GetValue(var->m_parameters[1]), GetText(var->m_parameters[2]));
        return 1;
    }
    return 0;
    
}

int CIndicatorMe::LIST_REMOVE(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int listName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(listName);
    if(sIter != m_tempVars.end())
    {
        vector<wstring> *list = sIter->second->m_list;
        list->erase(list->begin() + (int) GetValue(var->m_parameters[1]));
        return 1;
    }
    return 0;
    
}

int CIndicatorMe::LIST_SIZE(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int listName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(listName);
    if(sIter != m_tempVars.end())
    {
        vector<wstring> *list = sIter->second->m_list;
        return (int)list->size();
    }
    return 0;
}

int CIndicatorMe::MAP_CLEAR(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int mapName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(mapName);
    if(sIter != m_tempVars.end())
    {
        map<wstring, wstring> *map = sIter->second->m_map;
        map->clear();
        return 1;
    }
    return 0;
}

int CIndicatorMe::MAP_CONTAINSKEY(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int mapName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(mapName);
    if(sIter != m_tempVars.end())
    {
        map<wstring, wstring> *map = sIter->second->m_map;
        if(map->find(GetText(var->m_parameters[1])) != map->end()){
            return 1;
        }
    }
    return 0;
}

int CIndicatorMe::MAP_GET(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[1];
    int mapName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(mapName);
    map<wstring, wstring>::iterator sIter1;
    map<int, CVarMe*>::iterator sIter2;
    if(sIter != m_tempVars.end())
    {
        map<wstring, wstring> *map = sIter->second->m_map;
        wstring key = GetText(var->m_parameters[2]);
        sIter1 = map->find(key);
        if(sIter1 != map->end())
        {
            wstring strValue = sIter1->second;
            CVariableMe *variable = var->m_parameters[0];
            int id = variable->m_field;
            int type = variable->m_type;
            double value = CStrMe::ConvertStrToDouble(strValue);
            switch (type) {
                case 2:
                    m_dataSource->Set3(m_index, variable->m_fieldIndex, value);
                    break;
                default:
                    sIter2 = m_tempVars.find(id);
                    if(sIter2 != m_tempVars.end())
                    {
                        CVarMe *otherCVar = sIter2->second;
                        CVariableMe *newVar = new CVariableMe();
                        newVar->m_indicator = this;
                        newVar->m_type = 1;
                        newVar->m_expression = (L"'" + strValue + L"'");
                        otherCVar->SetValue(this, variable, newVar);
                    }
                    break;
            }
        }
        return 1;
    }
    return 0;
    
}

int CIndicatorMe::MAP_GETKEYS(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[1];
    int mapName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(mapName);
    map<wstring, wstring>::iterator sIter1;
    if(sIter != m_tempVars.end())
    {
        int listName = var->m_parameters[0]->m_field;
        map<int, CVarMe*>::iterator sIter2 = m_tempVars.find(listName);
        if(sIter2 != m_tempVars.end())
        {
            map<wstring, wstring> *map = sIter->second->m_map;
            vector<wstring> *list = sIter->second->m_list;
            list->clear();
            sIter1 = map->begin();
            for(; sIter1 != map->end(); ++sIter1){
                list->push_back(sIter1->first);
            }
            return 1;
        }
    }
    return 0;
}

int CIndicatorMe::MAP_REMOVE(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int mapName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(mapName);
    map<wstring, wstring>::iterator sIter1;
    if(sIter != m_tempVars.end())
    {
        map<wstring, wstring> *map = sIter->second->m_map;
        sIter1 = map->find(GetText(var->m_parameters[1]));
        if(sIter1 != map->end())
        {
            map->erase(sIter1);
            return 1;
        }
    }
    return 0;
    
}

int CIndicatorMe::MAP_SET(CVariableMe *var)
{
    CVariableMe *pName = var->m_parameters[0];
    int mapName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(mapName);
    map<wstring, wstring>::iterator sIter1;
    if(sIter != m_tempVars.end())
    {
        map<wstring, wstring> *map = sIter->second->m_map;
        sIter1 = map->find(GetText(var->m_parameters[1]));
        if(sIter1 != map->end())
        {
            sIter1->second = GetText(var->m_parameters[2]);
            return 1;
        }
    }
    return 0;
    
}

int CIndicatorMe::MAP_SIZE(CVariableMe *var)
{
    int size = 0;
    CVariableMe *pName = var->m_parameters[0];
    int mapName = pName->m_field;
    map<int, CVarMe*>::iterator sIter = m_tempVars.find(mapName);
    if(sIter != m_tempVars.end())
    {
        map<wstring, wstring> *map = sIter->second->m_map;
        size = (int)map->size();
    }
    return size;
    
}
