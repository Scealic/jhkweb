CREATE PROCEDURE [dbo].[VCS_Update_Component_SetLongDescription_v20261124] 

AS BEGIN

 
	SET NOCOUNT ON;

	WITH Calculated AS (
	SELECT 
	dbo.Component.Id, dbo.Component.LongDescription, NewLongDescription = LTRIM(
		RTRIM(
			CASE--Straights
				
				WHEN dbo.CategoryType.Id = 9 THEN
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
									
									WHEN dbo.ComponentModifier.Name = '-' 
									OR dbo.ComponentModifier.Name = '[ElementLookup]' THEN
										'' ELSE ' ' + dbo.ComponentModifier.Name 
										END,
								CASE
										
										WHEN dbo.ConnectionType.Name= '-' 
										OR dbo.ConnectionType.Name= '[ElementLookup]' THEN
											'' ELSE ' ' + dbo.ConnectionType.Name 
											END,
									CASE
											
											WHEN dbo.MainClass.Name = '-' 
											OR dbo.MainClass.Name = '[ElementLookup]' THEN
												'' ELSE ' ' + dbo.MainClass.Name 
												END,
										CASE
												
												WHEN dbo.MainClassModifier.NameAbbreviation = '-' THEN
												'' ELSE ' ' + dbo.MainClassModifier.NameAbbreviation 
												END,
										CASE
												
												WHEN dbo.ReducingClass.Name = '-' 
												OR dbo.ReducingClass.Name = '[ElementLookup]' THEN
													'' ELSE ' ' + dbo.ReducingClass.Name 
													END,
											CASE
													
													WHEN dbo.ReducingClassModifier.Name = '-' 
													OR dbo.ReducingClassModifier.Name = '[ElementLookup]' THEN
														'' ELSE ' ' + dbo.ReducingClassModifier.Name 
														END,
												CASE
														
														WHEN dbo.MainSchedule.NameAbbreviation = '-' THEN
														'' ELSE ' ' + dbo.MainSchedule.NameAbbreviation 
														END,
												CASE
														
														WHEN dbo.ReducingSchedule.Name = '-' 
														OR dbo.ReducingSchedule.Name = '[ElementLookup]' THEN
															'' ELSE ' ' + dbo.ReducingSchedule.Name 
															END,
													CASE
															
															WHEN dbo.MaterialType.NameAbbreviation = '-' THEN
															'' ELSE ' ' + dbo.MaterialType.NameAbbreviation 
															END,
													CASE
															
															WHEN dbo.MaterialCode.NameAbbreviation = '-' THEN
															'' ELSE ' ' + dbo.MaterialCode.NameAbbreviation 
															END,
													CASE
															
															WHEN dbo.MaterialSpecification.Name = '-' 
															OR dbo.MaterialSpecification.Name = '[ElementLookup]' THEN
																'' ELSE ' ' + dbo.MaterialSpecification.Name 
																END,
														CASE
																
																WHEN dbo.MaterialGrade.Name = '-' 
																OR dbo.MaterialGrade.Name = '[ElementLookup]' THEN
																	'' ELSE ' ' + dbo.MaterialGrade.Name 
																	END,
															CASE
																	
																	WHEN dbo.Finish.Name = '-' 
																	OR dbo.Finish.Name = '[ElementLookup]' THEN
																		'' ELSE ' ' + dbo.Finish.Name 
																		END,
																CASE
																		
																		WHEN dbo.BusinessModel.Name = '-' 
																		OR dbo.BusinessModel.Name = '[ElementLookup]' THEN
																			'' ELSE ' - ' + dbo.BusinessModel.Name 
																		END 
																			) ELSE CONCAT (
																			CASE-- Everything Else
																				
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
																									END,
																							CASE
																									
																									WHEN dbo.ConnectionType.Name= '-' 
																									OR dbo.ConnectionType.Name= '[ElementLookup]' THEN
																										'' ELSE ' ' + dbo.ConnectionType.Name 
																										END,
																								CASE
																										
																										WHEN dbo.MainClass.Name = '-' 
																										OR dbo.MainClass.Name = '[ElementLookup]' THEN
																											'' ELSE ' ' + dbo.MainClass.Name 
																											END,
																									CASE
																											
																											WHEN dbo.MainClassModifier.NameAbbreviation = '-' THEN
																											'' ELSE ' ' + dbo.MainClassModifier.NameAbbreviation 
																											END,
																									CASE
																											
																											WHEN dbo.ReducingClass.Name = '-' 
																											OR dbo.ReducingClass.Name = '[ElementLookup]' THEN
																												'' ELSE ' ' + dbo.ReducingClass.Name 
																												END,
																										CASE
																												
																												WHEN dbo.ReducingClassModifier.Name = '-' 
																												OR dbo.ReducingClassModifier.Name = '[ElementLookup]' THEN
																													'' ELSE ' ' + dbo.ReducingClassModifier.Name 
																													END,
																											CASE
																													
																													WHEN dbo.MainSchedule.NameAbbreviation = '-' THEN
																													'' ELSE ' ' + dbo.MainSchedule.NameAbbreviation 
																													END,
																											CASE
																													
																													WHEN dbo.ReducingSchedule.Name = '-' 
																													OR dbo.ReducingSchedule.Name = '[ElementLookup]' THEN
																														'' ELSE ' ' + dbo.ReducingSchedule.Name 
																														END,
																												CASE
																														
																														WHEN dbo.MaterialType.NameAbbreviation = '-' THEN
																														'' ELSE ' ' + dbo.MaterialType.NameAbbreviation 
																														END,
																												CASE
																														
																														WHEN dbo.MaterialCode.NameAbbreviation = '-' THEN
																														'' ELSE ' ' + dbo.MaterialCode.NameAbbreviation 
																														END,
																												CASE
																														
																														WHEN dbo.MaterialSpecification.Name = '-' 
																														OR dbo.MaterialSpecification.Name = '[ElementLookup]' THEN
																															'' ELSE ' ' + dbo.MaterialSpecification.Name 
																															END,
																													CASE
																															
																															WHEN dbo.MaterialGrade.Name = '-' 
																															OR dbo.MaterialGrade.Name = '[ElementLookup]' THEN
																																'' ELSE ' ' + dbo.MaterialGrade.Name 
																																END,
																														CASE
																																
																																WHEN dbo.Finish.Name = '-' 
																																OR dbo.Finish.Name = '[ElementLookup]' THEN
																																	'' ELSE ' ' + dbo.Finish.Name 
																																	END,
																															CASE
																																	
																																	WHEN dbo.BusinessModel.Name = '-' 
																																	OR dbo.BusinessModel.Name = '[ElementLookup]' THEN
																																		'' ELSE ' - ' + dbo.BusinessModel.Name 
																																	END 
																																	) 
																																END 
																																) 
																															) 
																														FROM
																															dbo.Component
																															LEFT JOIN dbo.Business ON dbo.Component.BusinessId = dbo.Business.Id
																															LEFT JOIN dbo.CatalogGroup ON dbo.Component.CatalogGroupId = dbo.CatalogGroup.Id
																															LEFT JOIN dbo.BusinessModel ON dbo.Component.BusinessModelId = dbo.BusinessModel.Id
																															LEFT JOIN dbo.Category ON dbo.Component.CategoryId = Category.Id
																															LEFT JOIN dbo.CategoryType ON dbo.Component.CategoryTypeId = dbo.CategoryType.Id
																															LEFT JOIN dbo.ComponentGroup ON dbo.Component.ComponentGroupId = dbo.ComponentGroup.Id
																															LEFT JOIN dbo.ComponentModifier ON Component.ComponentModifierId = dbo.ComponentModifier.Id
																															LEFT JOIN dbo.ConnectionType ON dbo.Component.ConnectionTypeId = dbo.ConnectionType.Id
																															LEFT JOIN dbo.FileNameModifier ON dbo.Component.FileNameModifierId = dbo.FileNameModifier.Id
																															LEFT JOIN dbo.FileType ON dbo.Component.FileTypeId = dbo.FileType.Id
																															LEFT JOIN dbo.Finish ON dbo.Component.FinishId = dbo.Finish.Id
																															LEFT JOIN dbo.MainClass ON dbo.Component.MainClassId = dbo.MainClass.Id
																															LEFT JOIN dbo.MainClassModifier ON Component.MainClassModifierId = MainClassModifier.Id
																															LEFT JOIN dbo.MainSchedule ON dbo.Component.MainScheduleId = dbo.MainSchedule.Id
																															LEFT JOIN dbo.MaterialCode ON dbo.Component.MaterialCodeId = dbo.MaterialCode.Id
																															LEFT JOIN dbo.MaterialGrade ON dbo.Component.MaterialGradeId = dbo.MaterialGrade.Id
																															LEFT JOIN dbo.MaterialSpecification ON dbo.Component.MaterialSpecificationId = MaterialSpecification.Id
																															LEFT JOIN dbo.MaterialType ON dbo.Component.MaterialTypeId = dbo.MaterialType.Id
																															LEFT JOIN dbo.ReducingClass ON dbo.Component.ReducingClassId = dbo.ReducingClass.Id
																															LEFT JOIN dbo.ReducingClassModifier ON dbo.Component.ReducingClassModifierId = dbo.ReducingClassModifier.Id
																															LEFT JOIN dbo.ReducingSchedule ON dbo.Component.ReducingScheduleId = dbo.ReducingSchedule.Id
																															LEFT JOIN dbo.SubCategory ON dbo.Component.SubCategoryId = dbo.SubCategory.Id
																															LEFT JOIN dbo.SubCategoryModifierAlpha ON dbo.Component.SubCategoryModifierAlphaId = dbo.SubCategoryModifierAlpha.Id
																															LEFT JOIN dbo.SubCategoryModifierBravo ON dbo.Component.SubCategoryModifierBravoId = dbo.SubCategoryModifierBravo.Id
																														LEFT JOIN dbo.Trade ON dbo.Component.TradeId = dbo.Trade.Id 
	)
	UPDATE Calculated
	SET LongDescription = NewLongDescription
	WHERE EXISTS (
		SELECT LongDescription COLLATE Latin1_General_BIN2
		EXCEPT
		SELECT NewLongDescription COLLATE Latin1_General_BIN2
	);
END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'KWDSS-10: writes only rows whose derived values changed. Replaces VCS_Update_Component_SetLongDescription once the trigger calls it.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'VCS_Update_Component_SetLongDescription_v20261124';

