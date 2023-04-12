-- Need to check no blanks on there own

SELECT        strategy_safeguarding_workflow.person_id, C_DT_PERSONS.FULL_NAME, strategy_safeguarding_workflow.assigned_team, strategy_safeguarding_workflow.assigned_worker, 
                         strategy_safeguarding_workflow.workflow_step_type, strategy_safeguarding_workflow.proposed_date, riskAssTypeAbuse.lookup_answer AS riskAssTypeAbuse, riskAssAbuseSource.lookup_answer AS riskAssAbuseSource, 
                         riskAssLocation.lookup_answer AS riskAssLocation, CASE WHEN riskAssTypeAbuse.lookup_answer IS NULL THEN 1 ELSE 0 END AS riskAssTypeAbuse_error, CASE WHEN riskAssTypeAbuse.lookup_answer IS NULL 
                         THEN 1 ELSE CASE WHEN riskAssAbuseSource.lookup_answer IS NULL THEN 1 ELSE CASE WHEN riskAssLocation.lookup_answer IS NULL THEN 1 ELSE 0 END END END AS Expr1, 
                         strategy_safeguarding_workflow.status
FROM            strategy_safeguarding_workflow INNER JOIN
                         adults_current_key_team ON strategy_safeguarding_workflow.person_id = adults_current_key_team.PERSON_ID INNER JOIN
                         C_DT_PERSONS ON strategy_safeguarding_workflow.person_id = C_DT_PERSONS.PERSON_ID LEFT OUTER JOIN
                             (SELECT        form_id, workflow_step_id, template_id, question_id, form_answer_row_id, short_text_answer, complex_answer_code, answer_datatype_code, long_text_answer, date_answer, lookup_answer, boolean_answer, 
                                                         [order], answer_validation_rule_id, answer_datatype, question_user_code, question_collection_id, version, title, question_user_code AS Expr1
                               FROM            adults_form_adult_safeguarding_enquiry_recording_110_rss AS adults_form_adult_safeguarding_enquiry_recording_110_rss_4
                               WHERE        (question_user_code = 'riskAssRiskRemain')) AS riskAssRiskRemain ON strategy_safeguarding_workflow.workflow_step_id = riskAssRiskRemain.workflow_step_id LEFT OUTER JOIN
                             (SELECT        form_id, workflow_step_id, template_id, question_id, form_answer_row_id, short_text_answer, complex_answer_code, answer_datatype_code, long_text_answer, date_answer, lookup_answer, boolean_answer, 
                                                         [order], answer_validation_rule_id, answer_datatype, question_user_code, question_collection_id, version, title, question_user_code AS Expr1
                               FROM            adults_form_adult_safeguarding_enquiry_recording_110_rss AS adults_form_adult_safeguarding_enquiry_recording_110_rss_3
                               WHERE        (question_user_code = 'riskAssRiskOutcome')) AS riskAssRiskOutcome ON strategy_safeguarding_workflow.workflow_step_id = riskAssRiskOutcome.workflow_step_id LEFT OUTER JOIN
                             (SELECT        form_id, workflow_step_id, template_id, question_id, form_answer_row_id, short_text_answer, complex_answer_code, answer_datatype_code, long_text_answer, date_answer, lookup_answer, boolean_answer, 
                                                         [order], answer_validation_rule_id, answer_datatype, question_user_code, question_collection_id, version, title, question_user_code AS Expr1
                               FROM            adults_form_adult_safeguarding_enquiry_recording_110_rss AS adults_form_adult_safeguarding_enquiry_recording_110_rss_2
                               WHERE        (question_user_code = 'detailsConcernLocation')) AS riskAssLocation ON strategy_safeguarding_workflow.workflow_step_id = riskAssLocation.workflow_step_id LEFT OUTER JOIN
                             (SELECT        form_id, workflow_step_id, template_id, question_id, form_answer_row_id, short_text_answer, complex_answer_code, answer_datatype_code, long_text_answer, date_answer, lookup_answer, boolean_answer, 
                                                         [order], answer_validation_rule_id, answer_datatype, question_user_code, question_collection_id, version, title, question_user_code AS Expr1
                               FROM            adults_form_adult_safeguarding_enquiry_recording_110_rss AS adults_form_adult_safeguarding_enquiry_recording_110_rss_1
                               WHERE        (question_user_code = 'detailsConcernAbuseSource')) AS riskAssAbuseSource ON strategy_safeguarding_workflow.workflow_step_id = riskAssAbuseSource.workflow_step_id LEFT OUTER JOIN
                             (SELECT        form_id, workflow_step_id, template_id, question_id, form_answer_row_id, short_text_answer, complex_answer_code, answer_datatype_code, long_text_answer, date_answer, lookup_answer, boolean_answer, 
                                                         [order], answer_validation_rule_id, answer_datatype, question_user_code, question_collection_id, version, title, question_user_code AS Expr1
                               FROM            adults_form_adult_safeguarding_enquiry_recording_110_rss
                               WHERE        (question_user_code = 'detailsConcernTypeAbuse')) AS riskAssTypeAbuse ON strategy_safeguarding_workflow.workflow_step_id = riskAssTypeAbuse.workflow_step_id
WHERE        (CASE WHEN riskAssTypeAbuse.lookup_answer IS NULL THEN 1 ELSE CASE WHEN riskAssAbuseSource.lookup_answer IS NULL THEN 1 ELSE CASE WHEN riskAssLocation.lookup_answer IS NULL 
                         THEN 1 ELSE 0 END END END = 1)
GROUP BY strategy_safeguarding_workflow.person_id, C_DT_PERSONS.FULL_NAME, strategy_safeguarding_workflow.assigned_team, strategy_safeguarding_workflow.assigned_worker, 
                         strategy_safeguarding_workflow.workflow_step_type, strategy_safeguarding_workflow.proposed_date, riskAssTypeAbuse.lookup_answer, riskAssAbuseSource.lookup_answer, riskAssLocation.lookup_answer, 
                         riskAssRiskOutcome.lookup_answer, riskAssRiskRemain.lookup_answer, strategy_safeguarding_workflow.status
HAVING        (strategy_safeguarding_workflow.proposed_date >= CONVERT(DATETIME, '2022-04-01 00:00:00', 102)) AND (strategy_safeguarding_workflow.workflow_step_type = 'Adult Safeguarding Enquiry') AND 
                         (strategy_safeguarding_workflow.status = 'completed')
