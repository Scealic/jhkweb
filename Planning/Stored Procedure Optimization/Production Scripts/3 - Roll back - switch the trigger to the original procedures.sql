-- KWDSS-10: point the Component trigger at the original procedures.
-- Run against VCS Content after the three create scripts. Only the procedure names differ from the trigger in production.
ALTER TRIGGER [dbo].[Trig_Component_SetDerivedFieldsOnInsertAndUpdate]
ON [dbo].[Component]
WITH EXECUTE AS CALLER
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON

	IF TRIGGER_NESTLEVEL() > 1
		RETURN

	EXECUTE [dbo].[VCS_Update_Component_SetFilePathAndName]
	EXECUTE [dbo].[VCS_Update_Component_SetLongDescription]
	EXECUTE [dbo].[VCS_Update_Component_SetShortDescription]
END
GO
