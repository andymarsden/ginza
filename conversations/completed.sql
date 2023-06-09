SELECT 
  reporting.dbo.MO_PERSONS.PERSON_ID, 
  COALESCE (
    DT_Person_Names_Main.FIRST_NAMES, 
    DT_Person_Names_Main.TITLE
  ) + ' ' + DT_Person_Names_Main.LAST_NAME, 
  reporting.dbo.MO_PERSONS.DATE_OF_BIRTH, 
  reporting.dbo.MO_WORKFLOW_STEPS.INCOMING_ON, 
  reporting.dbo.MO_WORKFLOW_STEPS.STARTED_ON, 
  reporting.dbo.MO_WORKFLOW_STEPS.COMPLETED_ON, 
  PREVIOUS_WORKFLOW_STEPS.WORKFLOW_STEP_ID, 
  PREVIOUS_WORKFLOW_STEP_TYPES.DESCRIPTION, 
  PREVIOUS_WORKFLOW_STEPS.COMPLETED_ON, 
  reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID, 
  DT_2360_DateCancelled.DateCancelled, 
  DT_2360_AbandonedCancelledReason.AbandonedCancelledReason, 
  COALESCE(
    COALESCE(
      DT_2326_CompletedDate.CompletedDate, 
      DT_2360_DateCompleted.DateCompleted
    ), 
    reporting.dbo.MO_WORKFLOW_STEPS.COMPLETED_ON
  ), 
  RESPONSIBLE_TEAM.NAME, 
  WORKFLOW_STEP_ASSIGNEE.FIRST_NAMES + ' ' + WORKFLOW_STEP_ASSIGNEE.LAST_NAMES, 
  reporting.dbo.MO_WORKFLOW_STEPS.STEP_STATUS, 
  NEXT_MO_WORKFLOW_STEP_TYPES.DESCRIPTION, 
  NEXT_MO_WORKFLOW_STEPS.STEP_STATUS 
FROM 
  (
    SELECT 
      FORM_ID, 
      DATE_ANSWER as DateCompleted 
    FROM 
      MO_FORM_DATE_ANSWERS fans 
      INNER JOIN MO_QUESTIONS ques ON fans.QUESTION_ID = ques.QUESTION_ID 
    WHERE 
      ques.QUESTION_ID = 130145
  ) DT_2360_DateCompleted 
  RIGHT OUTER JOIN reporting.dbo.MO_FORMS ON (
    reporting.dbo.MO_FORMS.FORM_ID = DT_2360_DateCompleted."FORM_ID"
  ) 
  RIGHT OUTER JOIN reporting.dbo.MO_WORKFLOW_STEPS ON (
    reporting.dbo.MO_FORMS.WORKFLOW_STEP_ID = reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID
  ) 
  LEFT OUTER JOIN reporting.dbo.MO_WORKFLOW_LINKS PREVIOUS_WORKFLOW_LINKS ON (
    PREVIOUS_WORKFLOW_LINKS.TARGET_STEP_ID = reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID
  ) 
  RIGHT OUTER JOIN reporting.dbo.MO_WORKFLOW_STEPS PREVIOUS_WORKFLOW_STEPS ON (
    PREVIOUS_WORKFLOW_STEPS.WORKFLOW_STEP_ID = PREVIOUS_WORKFLOW_LINKS.SOURCE_STEP_ID
  ) 
  INNER JOIN reporting.dbo.MO_WORKFLOW_STEP_TYPES PREVIOUS_WORKFLOW_STEP_TYPES ON (
    PREVIOUS_WORKFLOW_STEP_TYPES.WORKFLOW_STEP_TYPE_ID = PREVIOUS_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID
  ) 
  LEFT OUTER JOIN reporting.dbo.WORKERS WORKFLOW_STEP_ASSIGNEE ON (
    reporting.dbo.MO_WORKFLOW_STEPS.ASSIGNEE_ID = WORKFLOW_STEP_ASSIGNEE.ID
  ) 
  LEFT OUTER JOIN reporting.dbo.ORGANISATIONS RESPONSIBLE_TEAM ON (
    reporting.dbo.MO_WORKFLOW_STEPS.RESPONSIBLE_TEAM_ID = RESPONSIBLE_TEAM.ID
  ) 
  LEFT OUTER JOIN reporting.dbo.MO_WORKFLOW_LINKS ON (
    reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID = reporting.dbo.MO_WORKFLOW_LINKS.SOURCE_STEP_ID
  ) 
  LEFT OUTER JOIN reporting.dbo.MO_WORKFLOW_STEPS NEXT_MO_WORKFLOW_STEPS ON (
    reporting.dbo.MO_WORKFLOW_LINKS.TARGET_STEP_ID = NEXT_MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID
  ) 
  LEFT OUTER JOIN reporting.dbo.MO_WORKFLOW_STEP_TYPES NEXT_MO_WORKFLOW_STEP_TYPES ON (
    NEXT_MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID = NEXT_MO_WORKFLOW_STEP_TYPES.WORKFLOW_STEP_TYPE_ID
  ) 
  INNER JOIN reporting.dbo.MO_WORKFLOW_STEP_TYPES ON (
    reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID = reporting.dbo.MO_WORKFLOW_STEP_TYPES.WORKFLOW_STEP_TYPE_ID
  ) 
  LEFT OUTER JOIN reporting.dbo.MO_SUBGROUP_SUBJECTS ON (
    reporting.dbo.MO_SUBGROUP_SUBJECTS.SUBGROUP_ID = reporting.dbo.MO_WORKFLOW_STEPS.SUBGROUP_ID
  ) 
  RIGHT OUTER JOIN reporting.dbo.MO_PERSONS ON (
    reporting.dbo.MO_PERSONS.PERSON_ID = reporting.dbo.MO_SUBGROUP_SUBJECTS.SUBJECT_COMPOUND_ID
  ) 
  LEFT OUTER JOIN (
    SELECT 
      * 
    FROM 
      PERSON_NAMES 
    WHERE 
      PERSON_NAMES.NAME_CLASS_ID = 'MAIN' 
      AND PERSON_NAMES.END_DATE IS NULL
  ) DT_Person_Names_Main ON (
    reporting.dbo.MO_PERSONS.PERSON_ID = DT_Person_Names_Main.PERSON_ID
  ) 
  LEFT OUTER JOIN (
    SELECT 
      fla.FORM_ID, 
      mql.ANSWER as 'AbandonedCancelledReason' 
    FROM 
      MO_FORM_LOOKUP_ANSWERS fla 
      inner join MO_QUESTION_LOOKUPS mql ON fla.QUESTION_LOOKUP_ID = mql.QUESTION_LOOKUP_ID 
      inner join MO_QUESTIONS ques on fla.QUESTION_ID = ques.QUESTION_ID 
    WHERE 
      ques.QUESTION_ID = 130048
  ) DT_2360_AbandonedCancelledReason ON (
    reporting.dbo.MO_FORMS.FORM_ID = DT_2360_AbandonedCancelledReason."FORM_ID"
  ) 
  LEFT OUTER JOIN (
    SELECT 
      FORM_ID, 
      DATE_ANSWER as 'DateCancelled' 
    FROM 
      MO_FORM_DATE_ANSWERS fans 
      INNER JOIN MO_QUESTIONS ques ON fans.QUESTION_ID = ques.QUESTION_ID 
    WHERE 
      ques.QUESTION_ID = 130049
  ) DT_2360_DateCancelled ON (
    reporting.dbo.MO_FORMS.FORM_ID = DT_2360_DateCancelled."FORM_ID"
  ) 
  LEFT OUTER JOIN (
    SELECT 
      FORM_ID, 
      DATE_ANSWER as CompletedDate 
    FROM 
      MO_FORM_DATE_ANSWERS fans 
      INNER JOIN MO_QUESTIONS ques ON fans.QUESTION_ID = ques.QUESTION_ID 
    WHERE 
      ques.QUESTION_ID = 126647
  ) DT_2326_CompletedDate ON (
    reporting.dbo.MO_FORMS.FORM_ID = DT_2326_CompletedDate."FORM_ID"
  ) 
WHERE 
  (
    (
      (
        reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID = 1537 
        and reporting.dbo.MO_FORMS.TEMPLATE_ID IN (2326, 2360)
      ) 
      AND COALESCE(
        COALESCE(
          DT_2326_CompletedDate.CompletedDate, 
          DT_2360_DateCompleted.DateCompleted
        ), 
        reporting.dbo.MO_WORKFLOW_STEPS.COMPLETED_ON
      ) >= '2020-04-01T00:00:00'
    ) 
    OR (
      COALESCE(
        COALESCE(
          DT_2326_CompletedDate.CompletedDate, 
          DT_2360_DateCompleted.DateCompleted
        ), 
        reporting.dbo.MO_WORKFLOW_STEPS.COMPLETED_ON
      ) Is Null 
      AND (
        reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID = 1537 
        and reporting.dbo.MO_FORMS.TEMPLATE_ID IN (2326, 2360)
      )
    ) 
    OR (
      reporting.dbo.MO_WORKFLOW_STEPS.CANCELLED_ON Is Null 
      AND reporting.dbo.MO_WORKFLOW_STEP_TYPES.DESCRIPTION IN ('Adult Conversation Record') 
      AND reporting.dbo.MO_WORKFLOW_STEPS.STARTED_ON Is Null
    )
  ) 
