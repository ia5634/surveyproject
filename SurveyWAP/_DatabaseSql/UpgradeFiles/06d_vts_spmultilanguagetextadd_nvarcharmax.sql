USE [DBname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spMultiLanguageTextAdd]    Script Date: 8/20/2017 09:11:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Survey Project: (c) 2017, W3DevPro TM (https://github.com/surveyproject)

	NSurvey - The web survey and form engine
	Copyright (c) 2004, 2005 Thomas Zumbrunn. (http://www.nsurvey.org)

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

/// <summary>
///  Moves an answer's positions up 
/// </summary>
/// <param name="@AnswerID">
/// ID of the answer to move one position up
/// </param>
*/
ALTER PROCEDURE [dbo].[vts_spMultiLanguageTextAdd] 
@LanguageItemId int,
@LanguageCode varchar(10),
@LanguageMessageTypeId int,
@ItemText nvarchar(max)
AS
INSERT INTO [vts_tbMultiLanguageText](LanguageItemId ,LanguageCode,LanguageMessageTypeId,ItemText)
VALUES (@LanguageItemId ,@LanguageCode,@LanguageMessageTypeId,@ItemText)


