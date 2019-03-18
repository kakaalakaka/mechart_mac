/**
 *  @file
 *  @copyright defined in mechart_mac/LICENSE
 */

#ifndef __CGRIDENUMSME_H__
#define __CGRIDENUMSME_H__
#pragma once
#include "stdafx.h"

namespace MeLib
{
    enum GridColumnSortMode
	{
		GridColumnSortMode_Asc,
		GridColumnSortMode_Desc,
		GridColumnSortMode_None
	};
    
    enum GridSelectionMode
	{
		GridSelectionMode_SelectCell,
		GridSelectionMode_SelectFullColumn,
		GridSelectionMode_SelectFullRow,
		GridSelectionMode_SelectNone
	};
    
    enum GridCellEditMode
	{
        GridCellEditMode_DoubleClick,
        GridCellEditMode_None,
        GridCellEditMode_SingleClick
	};
}

#endif
