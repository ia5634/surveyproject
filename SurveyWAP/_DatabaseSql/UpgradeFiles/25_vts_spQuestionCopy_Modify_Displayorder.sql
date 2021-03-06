USE [sp25dev]
GO
/****** Object:  StoredProcedure [dbo].[vts_spQuestionCopy]    Script Date: 3/24/2020 11:10:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Survey Project: (c) 2016, Fryslan Webservices TM (http://survey.codeplex.com)

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
/// Copy an existing question to another survey
/// </summary>
*/
ALTER PROCEDURE [dbo].[vts_spQuestionCopy]
				@QuestionID int, 
				@NewSurveyID int,
				@DisplayOrder int,
				@PageNumber int,
				@QuestionCopyID int output
AS

BEGIN TRANSACTION CopyQuestion

INSERT INTO vts_tbQuestion  
	(ParentQuestionId, 
	SurveyID,
	LibraryID,
	SelectionModeId, 
	LayoutModeId, 
	DisplayOrder,
	PageNumber, 
	MinSelectionRequired, 
	MaxSelectionAllowed, 
	RatingEnabled,
	ColumnsNumber,
	RandomizeAnswers,
	QuestionText,
	QuestionPipeAlias,
	QuestionIDText,
	HelpText,
	Alias,
	QuestiongroupID,
	ShowHelpText)
SELECT      
	ParentQuestionId, 
	@NewSurveyID,
	null, 
	SelectionModeId, 
	LayoutModeId, 
	@DisplayOrder,
	@PageNumber, 
	MinSelectionRequired, 
	MaxSelectionAllowed, 
	RatingEnabled,
	ColumnsNumber,
	RandomizeAnswers,
	QuestionText,
	QuestionPipeAlias,
	QuestionIDText,
	HelpText,
	Alias,
	QuestionGroupID,
	ShowHelpText
FROM vts_tbQuestion WHERE QuestionID = @QuestionID

-- Check if the cloned question was created
IF @@rowCount <> 0
BEGIN
	-- Clone the question's answers
	set @QuestionCopyID = Scope_Identity()

	INSERT INTO vts_tbMultiLanguageText(LanguageItemID, LanguageCode, LanguageMessageTypeID, ItemText)
		SELECT @QuestionCopyID as LanguageItemID, LanguageCode, LanguageMessageTypeID, ItemText
		FROM vts_tbMultiLanguageText
		WHERE LanguageItemID = @QuestionID AND LanguageMessageTypeID in(3,10,11,12)	

	exec vts_spQuestionChildsClone @QuestionID, @QuestionCopyID, @NewSurveyID
	
	UPDATE vts_tbQuestion 
		SET -- DisplayOrder = @DisplayOrder, 
			LibraryID = NULL,
			PageNumber = @PageNumber 
	WHERE SurveyID = @NewSurveyID AND ParentQuestionid = @QuestionCopyID

	exec vts_spAnswersCloneByQuestionId @QuestionID, @QuestionCopyID

	exec vts_spQuestionSectionOptionClone @QuestionId, @QuestionCopyId

	-- Update the display order
	UPDATE vts_tbQuestion 
	SET DisplayOrder = DisplayOrder + 1 
	WHERE 
		SurveyID = @NewSurveyID 
		AND ( (QuestionID<>@QuestionCopyID AND ParentQuestionID is null) 
		-- OR (ParentQuestionID is not null AND ParentQuestionID <> @QuestionCopyID)
		) 
		AND DisplayOrder >= @DisplayOrder
END

COMMIT TRANSACTION CopyQuestion



