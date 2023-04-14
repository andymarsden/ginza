SELECT        MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID AS workflow_step_id, MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID AS form_id, MO_FORMS.TEMPLATE_ID AS template_id, dt_start_dates.answer AS start_date, 
                         dt_end_dates.answer AS end_date
FROM            _lcc_workflow_config INNER JOIN
                         MO_WORKFLOW_STEPS INNER JOIN
                         MO_FORMS ON MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID = MO_FORMS.WORKFLOW_STEP_ID ON _lcc_workflow_config.config_2 = MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID LEFT OUTER JOIN
                             (SELECT        MO_WORKFLOW_STEPS_2.WORKFLOW_STEP_ID AS workflow_step_id, MO_WORKFLOW_STEPS_2.WORKFLOW_STEP_TYPE_ID AS workflow_step_type, MO_FORM_DATE_ANSWERS_2.FORM_ID AS form_id, 
                                                         MO_QUESTIONS_2.TEMPLATE_ID AS template_id, _lcc_form_config_2.mapping AS mapped_field, MO_FORM_DATE_ANSWERS_2.DATE_ANSWER AS answer
                               FROM            MO_FORM_DATE_ANSWERS AS MO_FORM_DATE_ANSWERS_2 INNER JOIN
                                                         MO_QUESTIONS AS MO_QUESTIONS_2 ON MO_FORM_DATE_ANSWERS_2.QUESTION_ID = MO_QUESTIONS_2.QUESTION_ID INNER JOIN
                                                         MO_FORMS AS MO_FORMS_2 ON MO_FORM_DATE_ANSWERS_2.FORM_ID = MO_FORMS_2.FORM_ID INNER JOIN
                                                         MO_WORKFLOW_STEPS AS MO_WORKFLOW_STEPS_2 ON MO_FORMS_2.WORKFLOW_STEP_ID = MO_WORKFLOW_STEPS_2.WORKFLOW_STEP_ID INNER JOIN
                                                         _lcc_form_config AS _lcc_form_config_2 ON MO_QUESTIONS_2.TEMPLATE_ID = _lcc_form_config_2.template_id AND MO_QUESTIONS_2.QUESTION_USER_CODE = _lcc_form_config_2.form_field INNER JOIN
                                                         _lcc_workflow_config AS _lcc_workflow_config_2 ON _lcc_workflow_config_2.config_2 = MO_WORKFLOW_STEPS_2.WORKFLOW_STEP_TYPE_ID
                               WHERE        (_lcc_form_config_2.mapping = 'completion_date') AND (_lcc_form_config_2.is_active = 1)) AS dt_end_dates ON MO_FORMS.FORM_ID = dt_end_dates.form_id LEFT OUTER JOIN
                             (SELECT        MO_WORKFLOW_STEPS_1.WORKFLOW_STEP_ID AS workflow_step_id, MO_WORKFLOW_STEPS_1.WORKFLOW_STEP_TYPE_ID AS workflow_step_type, MO_FORM_DATE_ANSWERS_1.FORM_ID AS form_id, 
                                                         MO_QUESTIONS_1.TEMPLATE_ID AS template_id, _lcc_form_config_1.mapping AS mapped_field, MO_FORM_DATE_ANSWERS_1.DATE_ANSWER AS answer
                               FROM            MO_FORM_DATE_ANSWERS AS MO_FORM_DATE_ANSWERS_1 INNER JOIN
                                                         MO_QUESTIONS AS MO_QUESTIONS_1 ON MO_FORM_DATE_ANSWERS_1.QUESTION_ID = MO_QUESTIONS_1.QUESTION_ID INNER JOIN
                                                         MO_FORMS AS MO_FORMS_1 ON MO_FORM_DATE_ANSWERS_1.FORM_ID = MO_FORMS_1.FORM_ID INNER JOIN
                                                         MO_WORKFLOW_STEPS AS MO_WORKFLOW_STEPS_1 ON MO_FORMS_1.WORKFLOW_STEP_ID = MO_WORKFLOW_STEPS_1.WORKFLOW_STEP_ID INNER JOIN
                                                         _lcc_form_config AS _lcc_form_config_1 ON MO_QUESTIONS_1.TEMPLATE_ID = _lcc_form_config_1.template_id AND MO_QUESTIONS_1.QUESTION_USER_CODE = _lcc_form_config_1.form_field INNER JOIN
                                                         _lcc_workflow_config AS _lcc_workflow_config_1 ON _lcc_workflow_config_1.config_2 = MO_WORKFLOW_STEPS_1.WORKFLOW_STEP_TYPE_ID
                               WHERE        (_lcc_form_config_1.mapping = 'start_date') AND (_lcc_form_config_1.is_active = 1)) AS dt_start_dates ON MO_FORMS.FORM_ID = dt_start_dates.form_id
