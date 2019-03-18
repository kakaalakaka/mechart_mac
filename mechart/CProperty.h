/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CPROPERTYME_H__
#define __CPROPERTYME_H__
#pragma once
#include "stdafx.h"

namespace MeLib
{
	class CPropertyMe
	{
	public:
		virtual void GetProperty(const String& name, String *value, String *type)
		{
		}
		virtual vector<String> GetPropertyNames()
		{
			vector<String> propertyNames;
			return propertyNames;
		}
		virtual void SetProperty(const String& name, const String& value)
		{
		}
	};
}
#endif
