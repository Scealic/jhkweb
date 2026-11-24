CREATE PROCEDURE [dbo].[VCS_Update_Component_SetShortDescription_v20261124] 

AS BEGIN

 
	SET NOCOUNT ON;

	WITH Calculated AS (
	SELECT 
	dbo.Component.Id, dbo.Component.ShortDescription, NewShortDescription = LTRIM(
		RTRIM(
			CONCAT (
				CASE
						
						WHEN dbo.Category.Name = '-' 
						OR dbo.Category.Name = '[ElementLookup]' THEN
							'' ELSE dbo.Category.Name 
							END,
					CASE
							
							WHEN dbo.SubCategory.Name = '-' 
							OR dbo.SubCategory.Name = '[ElementLookup]' THEN
								'' ELSE ' ' + dbo.SubCategory.Name 
								END,
						CASE
								
								WHEN dbo.SubCategoryModifierAlpha.Name = '-' 
								OR dbo.SubCategoryModifierAlpha.Name = '[ElementLookup]' THEN
									'' ELSE ' ' + dbo.SubCategoryModifierAlpha.Name 
									END,
							CASE
									
									WHEN dbo.SubCategoryModifierBravo.Name = '-' 
									OR dbo.SubCategoryModifierBravo.Name = '[ElementLookup]' THEN
										'' ELSE ' ' + dbo.SubCategoryModifierBravo.Name 
										END,
								CASE
										
										WHEN dbo.ComponentModifier.Name = '-' 
										OR dbo.ComponentModifier.Name = '[ElementLookup]' THEN
											'' ELSE ' ' + dbo.ComponentModifier.Name 
										END 
										) 
									) 
								) 
							FROM
								dbo.Component
								LEFT JOIN dbo.Category ON dbo.Component.CategoryId = Category.Id
								LEFT JOIN dbo.ComponentModifier ON Component.ComponentModifierId = dbo.ComponentModifier.Id
								LEFT JOIN dbo.SubCategory ON dbo.Component.SubCategoryId = dbo.SubCategory.Id
								LEFT JOIN dbo.SubCategoryModifierAlpha ON dbo.Component.SubCategoryModifierAlphaId = dbo.SubCategoryModifierAlpha.Id
							LEFT JOIN dbo.SubCategoryModifierBravo ON dbo.Component.SubCategoryModifierBravoId = dbo.SubCategoryModifierBravo.Id 
	)
	UPDATE Calculated
	SET ShortDescription = NewShortDescription
	WHERE EXISTS (
		SELECT ShortDescription COLLATE Latin1_General_BIN2
		EXCEPT
		SELECT NewShortDescription COLLATE Latin1_General_BIN2
	);
END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'KWDSS-10: writes only rows whose derived values changed. Replaces VCS_Update_Component_SetShortDescription once the trigger calls it.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'VCS_Update_Component_SetShortDescription_v20261124';

