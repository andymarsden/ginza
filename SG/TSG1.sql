SELECT        strategy_safeguarding_workflow.person_id, C_DT_PERSONS.FULL_NAME, strategy_safeguarding_workflow.assigned_team, strategy_safeguarding_workflow.assigned_worker, 
                         strategy_safeguarding_workflow.workflow_step_type, strategy_safeguarding_workflow.proposed_date, adults_form_adult_safeguarding_concern_106.advocateName, 
                         adults_form_adult_safeguarding_concern_106.requireIndependentAdvocate, adults_form_adult_safeguarding_concern_106.doubtCapacityConsent
FROM            strategy_safeguarding_workflow INNER JOIN
                         adults_form_adult_safeguarding_concern_106 ON strategy_safeguarding_workflow.workflow_step_id = adults_form_adult_safeguarding_concern_106.workflow_step_id INNER JOIN
                         adults_current_key_team ON strategy_safeguarding_workflow.person_id = adults_current_key_team.PERSON_ID INNER JOIN
                         C_DT_PERSONS ON strategy_safeguarding_workflow.person_id = C_DT_PERSONS.PERSON_ID
WHERE        (strategy_safeguarding_workflow.proposed_date >= CONVERT(DATETIME, '2022-04-01 00:00:00', 102)) AND (adults_form_adult_safeguarding_concern_106.doubtCapacityConsent = 'Yes') AND 
                         (adults_form_adult_safeguarding_concern_106.requireIndependentAdvocate = 'No')
