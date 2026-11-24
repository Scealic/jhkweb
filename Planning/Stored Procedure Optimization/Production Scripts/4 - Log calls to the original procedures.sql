-- KWDSS-10: record every call to the three original VCS_Update_Component_Set* procedures, to find out
-- whether anything other than the old trigger (Access, a v4 install, a script) still uses them.
-- Run against VCS Content. Each procedure keeps its body unchanged; one INSERT is added at the start.
-- Read the log with:
--   SELECT ProcedureName, LoginName, ApplicationName, HostName, COUNT(*) AS Calls, MIN(CalledUtc) AS FirstCall, MAX(CalledUtc) AS LastCall
--   FROM dbo.ProcedureCallLog GROUP BY ProcedureName, LoginName, ApplicationName, HostName ORDER BY LastCall DESC;
-- Undo with "5 - Remove the call logging.sql".
IF OBJECT_ID(N'dbo.ProcedureCallLog', N'U') IS NULL
CREATE TABLE dbo.ProcedureCallLog (
	Id              INT IDENTITY (1, 1) NOT NULL CONSTRAINT PK_ProcedureCallLog PRIMARY KEY,
	ProcedureName   SYSNAME        NOT NULL,
	LoginName       NVARCHAR (128) NOT NULL CONSTRAINT DF_ProcedureCallLog_LoginName DEFAULT (SYSTEM_USER),
	ApplicationName NVARCHAR (128) NULL     CONSTRAINT DF_ProcedureCallLog_ApplicationName DEFAULT (APP_NAME()),
	HostName        NVARCHAR (128) NULL     CONSTRAINT DF_ProcedureCallLog_HostName DEFAULT (HOST_NAME()),
	CalledUtc       DATETIME2 (0)  NOT NULL CONSTRAINT DF_ProcedureCallLog_CalledUtc DEFAULT (SYSUTCDATETIME())
);
GO
CREATE OR ALTER PROCEDURE [dbo].[VCS_Update_Component_SetFilePathAndName] 

AS BEGIN
	INSERT dbo.ProcedureCallLog (ProcedureName) VALUES (N'VCS_Update_Component_SetFilePathAndName');

 
	UPDATE dbo.Component 
	SET dbo.Component.FilePath = LTRIM(
		RTRIM(
			CASE
					
					WHEN dbo.FileType.Extension = 'rfa' THEN
					'UNIFI' ELSE
					CASE--- Master Database 2022
						
						WHEN CAST ( dbo.Trade.Id AS INT ) = 2 THEN
						CONCAT (
						CASE
								
								WHEN dbo.Component.IsProjectSpecific = '1' THEN
								'\\vcdetailing\FABmep\DB\JHK Master Database 2022 (WIP)\ITEMS\' + dbo.Trade.Name + '\' + 'Projects' 
							END,
						CASE
								
								WHEN dbo.Business.Name = '' 
								AND dbo.Component.IsProjectSpecific = '0' THEN
									'\\vcdetailing\FABmep\DB\JHK Master Database 2022 (WIP)\ITEMS\' + dbo.Trade.Name + '\' + 'Generic' 
									END,
							CASE
									
									WHEN dbo.Business.Name != '' 
									AND dbo.Component.IsProjectSpecific = '0' THEN
										'\\vcdetailing\FABmep\DB\JHK Master Database 2022 (WIP)\ITEMS\' + dbo.Trade.Name + '\' + dbo.Business.Name 
										END,
								CASE
										
										WHEN dbo.CatalogGroup.Name = '-' 
										OR dbo.CatalogGroup.Name = '[ElementLookup]' THEN
											'' ELSE '\' + dbo.CatalogGroup.Name 
										END 
										) --- SM DATABASE
										
										WHEN CAST ( dbo.Trade.Id AS INT ) = 4 THEN
										CONCAT (
										CASE
												
												WHEN dbo.Component.IsProjectSpecific = '1' THEN
												'\\vcdetailing\FABmep\DB\JHK SM Database (WIP)\ITEMS\' + dbo.Trade.Name + '\' + 'Projects' 
											END,
										CASE
												
												WHEN dbo.Business.Name = '' 
												AND dbo.Component.IsProjectSpecific = '0' THEN
													'\\vcdetailing\FABmep\DB\JHK SM Database (WIP)\ITEMS\' + dbo.Trade.Name + '\' + 'Fabricated' 
													END,
											CASE
													
													WHEN dbo.Business.Name != '' 
													AND dbo.Component.IsProjectSpecific = '0' THEN
														'\\vcdetailing\FABmep\DB\JHK SM Database (WIP)\ITEMS\' + dbo.Trade.Name + '\' + dbo.Business.Name 
														END,
												CASE
														
														WHEN dbo.CatalogGroup.Name = '-' 
														OR dbo.CatalogGroup.Name = '[ElementLookup]' THEN
															'' ELSE '\' + dbo.CatalogGroup.Name 
														END 
														) 
													END 
													END 
													) 
												),
												dbo.Component.FileName = LTRIM(
													RTRIM(
														CASE-- RFA
															
															WHEN dbo.FileType.Extension = 'rfa' THEN
															CONCAT (
															CASE
																	
																	WHEN dbo.Category.Name = '-' 
																	OR dbo.Category.Name = '[ElementLookup]' THEN
																		'' ELSE dbo.Category.Name + ' ' 
																		END,
																CASE
																		
																		WHEN dbo.SubCategory.Name = '-' 
																		OR dbo.SubCategory.Name = '[ElementLookup]' THEN
																			'' ELSE dbo.SubCategory.Name + ' ' 
																			END,
																	CASE
																			
																			WHEN dbo.SubCategoryModifierAlpha.Name = '-' 
																			OR dbo.SubCategoryModifierAlpha.Name = '[ElementLookup]' THEN
																				'' ELSE dbo.SubCategoryModifierAlpha.Name + ' ' 
																				END,
																		CASE
																				
																				WHEN dbo.SubCategoryModifierBravo.Name = '-' 
																				OR dbo.SubCategoryModifierBravo.Name = '[ElementLookup]' THEN
																					'' ELSE dbo.SubCategoryModifierBravo.Name + ' ' 
																					END,
																			CASE
																					
																					WHEN dbo.ConnectionType.Name = '-' 
																					OR dbo.ConnectionType.Name = '[ElementLookup]' THEN
																						'' ELSE dbo.ConnectionType.Name + ' ' 
																						END,
																				CASE
																						
																						WHEN dbo.MaterialType.NameAbbreviation = '-' THEN
																						'' ELSE dbo.MaterialType.NameAbbreviation + ' ' 
																						END,
																				CASE
																						
																						WHEN dbo.MaterialCode.NameAbbreviation = '-' THEN
																						'' ELSE dbo.MaterialCode.NameAbbreviation + ' ' 
																						END,
																				CASE
																						
																						WHEN dbo.MaterialSpecification.Name = '-' 
																						OR dbo.MaterialSpecification.Name = '[ElementLookup]' THEN
																							'' ELSE dbo.MaterialSpecification.Name + ' ' 
																							END,
																					CASE
																							
																							WHEN dbo.MaterialGrade.Name = '-' 
																							OR dbo.MaterialGrade.Name = '	[ElementLookup]' THEN
																								'' ELSE dbo.MaterialGrade.Description + ' ' 
																								END,
																						CASE
																								
																								WHEN dbo.Finish.Name = '-' 
																								OR dbo.Finish.Name = '[ElementLookup]' THEN
																									'' ELSE dbo.Finish.NameAbbreviation + ' ' 
																									END,
																							CASE
																									
																									WHEN dbo.MainSchedule.NameAbbreviation = '-' THEN
																									'' ELSE dbo.MainSchedule.NameAbbreviation + ' ' 
																									END,
																							CASE
																									
																									WHEN dbo.ComponentModifier.Name = '-' 
																									OR dbo.ComponentModifier.Name = '[ElementLookup]' THEN
																										'' ELSE dbo.ComponentModifier.Name + ' ' 
																										END,
																								CASE
																										
																										WHEN dbo.MainClass.Name = '-' 
																										OR dbo.MainClass.Name = '[ElementLookup]' THEN
																											'' ELSE dbo.MainClass.Name + ' ' 
																											END,
																									CASE
																											
																											WHEN dbo.FileNameModifier.Name = '-' 
																											OR dbo.FileNameModifier.Name = '[ElementLookup]' THEN
																												'' ELSE dbo.FileNameModifier.Name + ' ' 
																												END,
																										CASE
																												
																												WHEN dbo.Business.Name = '-' 
																												OR dbo.Business.Name = '[ElementLookup]' THEN
																													'' 
																													WHEN dbo.Business.Name = '' THEN
																													'' ELSE dbo.Business.Name + ' ' 
																												END,
																											CASE
																													
																													WHEN dbo.BusinessModel.Name = '-' 
																													OR dbo.BusinessModel.Name = '[ElementLookup]' THEN
																														'' ELSE '- ' + dbo.BusinessModel.Name 
																													END 
																													) 
																													WHEN CAST ( dbo.CategoryType.ProductRange AS INT ) = 1 THEN
																													CONCAT (
																													CASE
																															
																															WHEN dbo.Category.Name = '-' 
																															OR dbo.Category.Name = '[ElementLookup]' THEN
																																'' ELSE dbo.Category.Name + ' ' 
																																END,
																														CASE
																																
																																WHEN dbo.SubCategory.Name = '-' 
																																OR dbo.SubCategory.Name = '[ElementLookup]' THEN
																																	'' ELSE dbo.SubCategory.Name + ' ' 
																																	END,
																															CASE
																																	
																																	WHEN dbo.SubCategoryModifierAlpha.Name = '-' 
																																	OR dbo.SubCategoryModifierAlpha.Name = '[ElementLookup]' THEN
																																		'' ELSE dbo.SubCategoryModifierAlpha.Name + ' ' 
																																		END,
																																CASE
																																		
																																		WHEN dbo.SubCategoryModifierBravo.Name = '-' 
																																		OR dbo.SubCategoryModifierBravo.Name = '[ElementLookup]' THEN
																																			'' ELSE dbo.SubCategoryModifierBravo.Name + ' ' 
																																			END,
																																	CASE
																																			
																																			WHEN dbo.ConnectionType.Name = '-' 
																																			OR dbo.ConnectionType.Name = '[ElementLookup]' THEN
																																				'' ELSE dbo.ConnectionType.Name + ' ' 
																																				END,
																																		CASE
																																				
																																				WHEN dbo.MainClass.Name = '-' 
																																				OR dbo.MainClass.Name = '[ElementLookup]' THEN
																																					'' ELSE dbo.MainClass.Name + ' ' 
																																					END,
																																			CASE
																																					
																																					WHEN dbo.MainClassModifier.NameAbbreviation = '-' THEN
																																					'' ELSE dbo.MainClassModifier.NameAbbreviation + ' ' 
																																					END,
																																			CASE
																																					
																																					WHEN dbo.ReducingClass.Name = '-' 
																																					OR dbo.ReducingClass.Name = '[ElementLookup]' THEN
																																						'' ELSE dbo.ReducingClass.Name + ' ' 
																																						END,
																																				CASE
																																						
																																						WHEN dbo.ReducingClassModifier.Name = '-' 
																																						OR dbo.ReducingClassModifier.Name = '[ElementLookup]' THEN
																																							'' ELSE dbo.ReducingClassModifier.Name + ' ' 
																																							END,
																																					CASE
																																							
																																							WHEN dbo.MainSchedule.NameAbbreviation = '-' THEN
																																							'' ELSE dbo.MainSchedule.NameAbbreviation + ' ' 
																																							END,
																																					CASE
																																							
																																							WHEN dbo.ReducingSchedule.Name = '-' 
																																							OR dbo.ReducingSchedule.Name = '[ElementLookup]' THEN
																																								'' ELSE dbo.ReducingSchedule.Name + ' ' 
																																								END,
																																							CASE-- Add logic for if materialtype name is hypen return null
																																								
																																								WHEN dbo.MaterialType.NameAbbreviation = '-' THEN
																																								'' ELSE dbo.MaterialType.NameAbbreviation + ' ' 
																																								END,
																																							CASE-- Add logic for if MaterialCode name is hypen return null
																																								
																																								WHEN dbo.MaterialCode.NameAbbreviation = '-' THEN
																																								'' ELSE dbo.MaterialCode.NameAbbreviation + ' ' 
																																								END,
																																						CASE
																																								
																																								WHEN dbo.MaterialSpecification.Name = '-' 
																																								OR dbo.MaterialSpecification.Name = '[ElementLookup]' THEN
																																									'' ELSE dbo.MaterialSpecification.Name + ' ' 
																																									END,
																																							CASE
																																									
																																									WHEN dbo.MaterialGrade.Name = '-' 
																																									OR dbo.MaterialGrade.Name = '[ElementLookup]' THEN
																																										'' ELSE dbo.MaterialGrade.Description + ' ' 
																																										END,
																																								CASE
																																										
																																										WHEN dbo.Finish.Name = '-' 
																																										OR dbo.Finish.Name = '[ElementLookup]' THEN
																																											'' ELSE dbo.Finish.Name + ' ' 
																																											END,
																																									CASE
																																											
																																											WHEN dbo.ComponentModifier.Name = '-' 
																																											OR dbo.ComponentModifier.Name = '[ElementLookup]' THEN
																																												'' ELSE dbo.ComponentModifier.Name + ' ' 
																																												END,
																																										CASE
																																												
																																												WHEN dbo.FileNameModifier.Name = '-' 
																																												OR dbo.FileNameModifier.Name = '[ElementLookup]' THEN
																																													'' ELSE dbo.FileNameModifier.Name + ' ' 
																																													END,
																																											CASE
																																													
																																													WHEN dbo.BusinessModel.Name = '-' 
																																													OR dbo.BusinessModel.Name = '[ElementLookup]' THEN
																																														'' ELSE '- ' + dbo.BusinessModel.Name 
																																													END 
																																													) -- Flanges
																																													
																																													WHEN CAST ( dbo.CategoryType.ProductRange AS INT ) = 3 THEN
																																													CONCAT (
																																													CASE
																																															
																																															WHEN dbo.Category.Name = '-' 
																																															OR dbo.Category.Name = '[ElementLookup]' THEN
																																																'' ELSE dbo.Category.Name + ' ' 
																																																END,
																																														CASE
																																																
																																																WHEN dbo.SubCategory.Name = '-' 
																																																OR dbo.SubCategory.Name = '[ElementLookup]' THEN
																																																	'' ELSE dbo.SubCategory.Name + ' ' 
																																																	END,
																																															CASE
																																																	
																																																	WHEN dbo.SubCategoryModifierAlpha.Name = '-' 
																																																	OR dbo.SubCategoryModifierAlpha.Name = '[ElementLookup]' THEN
																																																		'' ELSE dbo.SubCategoryModifierAlpha.Name + ' ' 
																																																		END,
																																																CASE
																																																		
																																																		WHEN dbo.SubCategoryModifierBravo.Name = '-' 
																																																		OR dbo.SubCategoryModifierBravo.Name = '[ElementLookup]' THEN
																																																			'' ELSE dbo.SubCategoryModifierBravo.Name + ' ' 
																																																			END,
																																																	CASE
																																																			
																																																			WHEN dbo.ConnectionType.Name = '-' 
																																																			OR dbo.ConnectionType.Name = '[ElementLookup]' THEN
																																																				'' ELSE dbo.ConnectionType.Name + ' ' 
																																																				END,
																																																		CASE
																																																				
																																																				WHEN dbo.MaterialType.NameAbbreviation = '-' THEN
																																																				'' ELSE dbo.MaterialType.NameAbbreviation + ' ' 
																																																				END,
																																																		CASE
																																																				
																																																				WHEN dbo.MaterialCode.NameAbbreviation = '-' THEN
																																																				'' ELSE dbo.MaterialCode.NameAbbreviation + ' ' 
																																																				END,
																																																		CASE
																																																				
																																																				WHEN dbo.MaterialSpecification.Name = '-' 
																																																				OR dbo.MaterialSpecification.Name = '[ElementLookup]' THEN
																																																					'' ELSE dbo.MaterialSpecification.Name + ' ' 
																																																					END,
																																																			CASE
																																																					
																																																					WHEN dbo.MaterialGrade.Name = '-' 
																																																					OR dbo.MaterialGrade.Name = '[ElementLookup]' THEN
																																																						'' ELSE dbo.MaterialGrade.Description + ' ' 
																																																						END,
																																																				CASE
																																																						
																																																						WHEN dbo.MainClass.Name = '-' 
																																																						OR dbo.MainClass.Name = '[ElementLookup]' THEN
																																																							'' ELSE dbo.MainClass.Name + ' ' 
																																																							END,
																																																					CASE
																																																							
																																																							WHEN dbo.MainClassModifier.NameAbbreviation = '-' THEN
																																																							'' ELSE dbo.MainClassModifier.NameAbbreviation + ' ' 
																																																							END,
																																																					CASE
																																																							
																																																							WHEN dbo.MainSchedule.NameAbbreviation = '-' THEN
																																																							'' ELSE dbo.MainSchedule.NameAbbreviation + ' ' 
																																																							END,
																																																					CASE
																																																							
																																																							WHEN dbo.ReducingSchedule.Name = '-' 
																																																							OR dbo.ReducingSchedule.Name = '[ElementLookup]' THEN
																																																								'' ELSE dbo.ReducingSchedule.Name + ' ' 
																																																								END,
																																																						CASE
																																																								
																																																								WHEN dbo.Finish.Name = '-' 
																																																								OR dbo.Finish.Name = '[ElementLookup]' THEN
																																																									'' ELSE dbo.Finish.Name + ' ' 
																																																									END,
																																																							CASE
																																																									
																																																									WHEN dbo.ComponentModifier.Name = '-' 
																																																									OR dbo.ComponentModifier.Name = '[ElementLookup]' THEN
																																																										'' ELSE dbo.ComponentModifier.Name + ' ' 
																																																										END,
																																																								CASE
																																																										
																																																										WHEN dbo.FileNameModifier.Name = '-' 
																																																										OR dbo.FileNameModifier.Name = '[ElementLookup]' THEN
																																																											'' ELSE dbo.FileNameModifier.Name + ' ' 
																																																											END,
																																																									CASE
																																																											
																																																											WHEN dbo.BusinessModel.Name = '-' 
																																																											OR dbo.BusinessModel.Name = '[ElementLookup]' THEN
																																																												'' ELSE '- ' + dbo.BusinessModel.Name 
																																																											END 
																																																											) -- Gaskets
																																																											
																																																											WHEN CAST ( dbo.CategoryType.ProductRange AS INT ) = 4 THEN
																																																											CONCAT (
																																																											CASE
																																																													
																																																													WHEN dbo.Category.Name = '-' 
																																																													OR dbo.Category.Name = '[ElementLookup]' THEN
																																																														'' ELSE dbo.Category.Name + ' ' 
																																																														END,
																																																												CASE
																																																														
																																																														WHEN dbo.SubCategory.Name = '-' 
																																																														OR dbo.SubCategory.Name = '[ElementLookup]' THEN
																																																															'' ELSE dbo.SubCategory.Name + ' ' 
																																																															END,
																																																													CASE
																																																															
																																																															WHEN dbo.SubCategoryModifierAlpha.Name = '-' 
																																																															OR dbo.SubCategoryModifierAlpha.Name = '[ElementLookup]' THEN
																																																																'' ELSE dbo.SubCategoryModifierAlpha.Name + ' ' 
																																																																END,
																																																														CASE
																																																																
																																																																WHEN dbo.SubCategoryModifierBravo.Name = '-' 
																																																																OR dbo.SubCategoryModifierBravo.Name = '[ElementLookup]' THEN
																																																																	'' ELSE dbo.SubCategoryModifierBravo.Name + ' ' 
																																																																	END,
																																																															CASE
																																																																	
																																																																	WHEN dbo.ConnectionType.Name = '-' 
																																																																	OR dbo.ConnectionType.Name = '[ElementLookup]' THEN
																																																																		'' ELSE dbo.ConnectionType.Name + ' ' 
																																																																		END,
																																																																CASE
																																																																		
																																																																		WHEN dbo.MaterialType.NameAbbreviation = '-' THEN
																																																																		'' ELSE dbo.MaterialType.NameAbbreviation + ' ' 
																																																																		END,
																																																																CASE
																																																																		
																																																																		WHEN dbo.MaterialCode.NameAbbreviation = '-' THEN
																																																																		'' ELSE dbo.MaterialCode.NameAbbreviation + ' ' 
																																																																		END,
																																																																CASE
																																																																		
																																																																		WHEN dbo.MaterialSpecification.Name = '-' 
																																																																		OR dbo.MaterialSpecification.Name = '[ElementLookup]' THEN
																																																																			'' ELSE dbo.MaterialSpecification.Name + ' ' 
																																																																			END,
																																																																	CASE
																																																																			
																																																																			WHEN dbo.MaterialGrade.Name = '-' 
																																																																			OR dbo.MaterialGrade.Name = '[ElementLookup]' THEN
																																																																				'' ELSE dbo.MaterialGrade.Description + ' ' 
																																																																				END,
																																																																		CASE
																																																																				
																																																																				WHEN dbo.MainSchedule.NameAbbreviation = '-' THEN
																																																																				'' ELSE dbo.MainSchedule.NameAbbreviation + ' ' 
																																																																				END,
																																																																		CASE
																																																																				
																																																																				WHEN dbo.ComponentModifier.Name = '-' 
																																																																				OR dbo.ComponentModifier.Name = '[ElementLookup]' THEN
																																																																					'' ELSE dbo.ComponentModifier.Name + ' ' 
																																																																					END,
																																																																			CASE
																																																																					
																																																																					WHEN dbo.MainClass.Name = '-' 
																																																																					OR dbo.MainClass.Name = '[ElementLookup]' THEN
																																																																						'' ELSE dbo.MainClass.Name + ' ' 
																																																																						END,
																																																																				CASE
																																																																						
																																																																						WHEN dbo.FileNameModifier.Name = '-' 
																																																																						OR dbo.FileNameModifier.Name = '[ElementLookup]' THEN
																																																																							'' ELSE dbo.FileNameModifier.Name + ' ' 
																																																																							END,
																																																																					CASE
																																																																							
																																																																							WHEN dbo.BusinessModel.Name = '-' 
																																																																							OR dbo.BusinessModel.Name = '[ElementLookup]' THEN
																																																																								'' ELSE '- ' + dbo.BusinessModel.Name 
																																																																							END 
																																																																							) -- All Others
																																																																							ELSE CONCAT (
																																																																							CASE
																																																																									
																																																																									WHEN dbo.Category.Name = '-' 
																																																																									OR dbo.Category.Name = '[ElementLookup]' THEN
																																																																										'' ELSE dbo.Category.Name + ' ' 
																																																																										END,
																																																																								CASE
																																																																										
																																																																										WHEN dbo.SubCategory.Name = '-' 
																																																																										OR dbo.SubCategory.Name = '[ElementLookup]' THEN
																																																																											'' ELSE dbo.SubCategory.Name + ' ' 
																																																																											END,
																																																																									CASE
																																																																											
																																																																											WHEN dbo.SubCategoryModifierAlpha.Name = '-' 
																																																																											OR dbo.SubCategoryModifierAlpha.Name = '[ElementLookup]' THEN
																																																																												'' ELSE dbo.SubCategoryModifierAlpha.Name + ' ' 
																																																																												END,
																																																																										CASE
																																																																												
																																																																												WHEN dbo.SubCategoryModifierBravo.Name = '-' 
																																																																												OR dbo.SubCategoryModifierBravo.Name = '[ElementLookup]' THEN
																																																																													'' ELSE dbo.SubCategoryModifierBravo.Name + ' ' 
																																																																													END,
																																																																											CASE
																																																																													
																																																																													WHEN dbo.ConnectionType.Name = '-' 
																																																																													OR dbo.ConnectionType.Name = '[ElementLookup]' THEN
																																																																														'' ELSE dbo.ConnectionType.Name + ' ' 
																																																																														END,
																																																																												CASE
																																																																														
																																																																														WHEN dbo.MaterialType.NameAbbreviation = '-' THEN
																																																																														'' ELSE dbo.MaterialType.NameAbbreviation + ' ' 
																																																																														END,
																																																																												CASE
																																																																														
																																																																														WHEN dbo.MaterialCode.NameAbbreviation = '-' THEN
																																																																														'' ELSE dbo.MaterialCode.NameAbbreviation + ' ' 
																																																																														END,
																																																																												CASE
																																																																														
																																																																														WHEN dbo.MaterialSpecification.Name = '-' 
																																																																														OR dbo.MaterialSpecification.Name = '[ElementLookup]' THEN
																																																																															'' ELSE dbo.MaterialSpecification.Name + ' ' 
																																																																															END,
																																																																													CASE
																																																																															
																																																																															WHEN dbo.MaterialGrade.Name = '-' 
																																																																															OR dbo.MaterialGrade.Name = '[ElementLookup]' THEN
																																																																																'' ELSE dbo.MaterialGrade.Description + ' ' 
																																																																																END,
																																																																														CASE
																																																																																
																																																																																WHEN dbo.MainClass.Name = '-' 
																																																																																OR dbo.MainClass.Name = '[ElementLookup]' THEN
																																																																																	'' ELSE dbo.MainClass.Name + ' ' 
																																																																																	END,
																																																																															CASE
																																																																																	
																																																																																	WHEN dbo.MainClassModifier.NameAbbreviation = '-' THEN
																																																																																	'' ELSE dbo.MainClassModifier.NameAbbreviation + ' ' 
																																																																																	END,
																																																																															CASE
																																																																																	
																																																																																	WHEN dbo.MainSchedule.NameAbbreviation = '-' THEN
																																																																																	'' ELSE dbo.MainSchedule.NameAbbreviation + ' ' 
																																																																																	END,
																																																																															CASE
																																																																																	
																																																																																	WHEN dbo.ReducingSchedule.NameAbbreviation = '-' THEN
																																																																																	'' ELSE dbo.ReducingSchedule.NameAbbreviation + ' ' 
																																																																																	END,
																																																																															CASE
																																																																																	
																																																																																	WHEN dbo.Finish.Name = '-' 
																																																																																	OR dbo.Finish.Name = '[ElementLookup]' THEN
																																																																																		'' ELSE dbo.Finish.Name + ' ' 
																																																																																		END,
																																																																																CASE
																																																																																		
																																																																																		WHEN dbo.ComponentModifier.Name = '-' 
																																																																																		OR dbo.ComponentModifier.Name = '[ElementLookup]' THEN
																																																																																			'' ELSE dbo.ComponentModifier.Name + ' ' 
																																																																																			END,
																																																																																	CASE
																																																																																			
																																																																																			WHEN dbo.FileNameModifier.Name = '-' 
																																																																																			OR dbo.FileNameModifier.Name = '[ElementLookup]' THEN
																																																																																				'' ELSE dbo.FileNameModifier.Name + ' ' 
																																																																																				END,
																																																																																		CASE
																																																																																				
																																																																																				WHEN dbo.BusinessModel.Name = '-' 
																																																																																				OR dbo.BusinessModel.Name = '[ElementLookup]' THEN
																																																																																					'' ELSE '- ' + dbo.BusinessModel.Name 
																																																																																				END 
																																																																																				) 
																																																																																			END 
																																																																																			) 
																																																																																		) + '.' + dbo.FileType.Extension 
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
END
GO
CREATE OR ALTER PROCEDURE [dbo].[VCS_Update_Component_SetLongDescription] 

AS BEGIN
	INSERT dbo.ProcedureCallLog (ProcedureName) VALUES (N'VCS_Update_Component_SetLongDescription');

 
	UPDATE dbo.Component 
	SET dbo.Component.LongDescription = LTRIM(
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
END
GO
CREATE OR ALTER PROCEDURE [dbo].[VCS_Update_Component_SetShortDescription] 

AS BEGIN
	INSERT dbo.ProcedureCallLog (ProcedureName) VALUES (N'VCS_Update_Component_SetShortDescription');

 
	UPDATE dbo.Component 
	SET dbo.Component.ShortDescription = LTRIM(
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
END
GO
