SELECT        dbo.strategy_safeguarding_workflow.person_id, dbo.C_DT_PERSONS.FULL_NAME, dbo.strategy_safeguarding_workflow.assigned_team, dbo.strategy_safeguarding_workflow.assigned_worker, 
                         dbo.strategy_safeguarding_workflow.workflow_step_type, dbo.strategy_safeguarding_workflow.proposed_date, dbo.adults_form_adult_safeguarding_concern_106.advocateName, 
                         dbo.adults_form_adult_safeguarding_concern_106.doubtCapacityConsent, dbo.adults_form_adult_safeguarding_concern_106.requireIndependentAdvocate, dbo.adults_form_adult_safeguarding_concern_106.advocate
FROM            dbo.strategy_safeguarding_workflow INNER JOIN
                         dbo.adults_form_adult_safeguarding_concern_106 ON dbo.strategy_safeguarding_workflow.workflow_step_id = dbo.adults_form_adult_safeguarding_concern_106.workflow_step_id INNER JOIN
                         dbo.adults_current_key_team ON dbo.strategy_safeguarding_workflow.person_id = dbo.adults_current_key_team.PERSON_ID INNER JOIN
                         dbo.C_DT_PERSONS ON dbo.strategy_safeguarding_workflow.person_id = dbo.C_DT_PERSONS.PERSON_ID
WHERE        (dbo.strategy_safeguarding_workflow.proposed_date >= CONVERT(DATETIME, '2022-04-01 00:00:00', 102)) AND (dbo.adults_form_adult_safeguarding_concern_106.doubtCapacityConsent = 'Yes') AND 
                         (dbo.adults_form_adult_safeguarding_concern_106.requireIndependentAdvocate = 'No') AND (dbo.adults_form_adult_safeguarding_concern_106.advocate = 'No additional support' OR
                         dbo.adults_form_adult_safeguarding_concern_106.advocate IS NULL)
