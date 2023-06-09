/* ASSESSMENTS ONGOING*/

SELECT
  reporting.dbo.MO_PERSONS.PERSON_ID,
  reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_ID,
  COALESCE(WORKFLOW_STEP_END_DATES.DATE_ANSWER,reporting.dbo.MO_WORKFLOW_STEPS.COMPLETED_ON),
  DT_NHS_NUMBER.reference,
  COALESCE (DT_Person_Names_Main.FIRST_NAMES, DT_Person_Names_Main.TITLE) + ' ' + DT_Person_Names_Main.LAST_NAME,
  COALESCE (DT_Person_Names_Main.FIRST_NAMES, DT_Person_Names_Main.TITLE) + ' ' + DT_Person_Names_Main.LAST_NAME,
  reporting.dbo.MO_PERSONS.DATE_OF_BIRTH,
  reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID,
  reporting.dbo.MO_WORKFLOW_STEP_TYPES.DESCRIPTION,
  WORKFLOW_STEP_ASSIGNEE.FIRST_NAMES + ' ' + WORKFLOW_STEP_ASSIGNEE.LAST_NAMES,
  RESPONSIBLE_TEAM.NAME,
  PREVIOUS_WORKFLOW_LINKS.SOURCE_STEP_ID,
  coalesce(PREVIOUS_WORKFLOW_STEP_TYPES.DESCRIPTION, 'N/A')
,
  COALESCE(PREVIOUS_WORKFLOW_STEPS.STARTED_ON,reporting.dbo.MO_WORKFLOW_STEPS.STARTED_ON),
  reporting.dbo.MO_WORKFLOW_STEPS.INCOMING_ON

,
  COALESCE(reporting.dbo.MO_WORKFLOW_STEPS.ASSIGNMENT_DATETIME,reporting.dbo.MO_WORKFLOW_STEPS.INCOMING_ON),
  COALESCE(WORKFLOW_STEP_START_DATES.DATE_ANSWER,reporting.dbo.MO_WORKFLOW_STEPS.STARTED_ON),
  DATEDIFF(d,COALESCE(reporting.dbo.MO_WORKFLOW_STEPS.ASSIGNMENT_DATETIME,reporting.dbo.MO_WORKFLOW_STEPS.INCOMING_ON),COALESCE(WORKFLOW_STEP_START_DATES.DATE_ANSWER,reporting.dbo.MO_WORKFLOW_STEPS.STARTED_ON)),
  reporting.dbo.MO_WORKFLOW_STEPS.STEP_STATUS,
  DATEDIFF(d,COALESCE(PREVIOUS_WORKFLOW_STEPS.STARTED_ON,reporting.dbo.MO_WORKFLOW_STEPS.STARTED_ON),GETDATE()),
  DATEDIFF(d,COALESCE(WORKFLOW_STEP_START_DATES.DATE_ANSWER,reporting.dbo.MO_WORKFLOW_STEPS.STARTED_ON),GETDATE())
FROM
  ( 
  SELECT 
 frms.WORKFLOW_STEP_ID,
min(fda.DATE_ANSWER) as DATE_ANSWER
--CONVERT(date,CAST(min(fda.DATE_ANSWER) as varchar),13) as DATE_ANSWER

FROM MO_FORM_DATE_ANSWERS fda
INNER JOIN
(


SELECT TEMPLATE_ID, QUESTION_ID
FROM MO_QUESTIONS
WHERE 

(TEMPLATE_ID = 398  AND QUESTION_USER_CODE = 'dateReferral')
OR
(TEMPLATE_ID = 300  AND QUESTION_USER_CODE = 'assStartDate')
OR
(TEMPLATE_ID = 466  AND QUESTION_USER_CODE = 'assStartDate')
OR
(TEMPLATE_ID = 475  AND QUESTION_USER_CODE = 'assessmentStartDate')
OR
(TEMPLATE_ID = 504  AND QUESTION_USER_CODE = 'assessmentStartDate')
OR
(TEMPLATE_ID = 1865  AND QUESTION_USER_CODE = 'assStartDate')
OR
(TEMPLATE_ID = 1982  AND QUESTION_USER_CODE = 'assStartDate')
OR
(TEMPLATE_ID = 398  AND QUESTION_USER_CODE = 'dateAssessment')
OR
(TEMPLATE_ID = 210  AND QUESTION_USER_CODE = 'contactDateTime') -- Contacts
OR
(TEMPLATE_ID = 210  AND QUESTION_USER_CODE = 'contactDate') -- Contacts
OR
(TEMPLATE_ID = 1716  AND QUESTION_USER_CODE = 'assStartDate') --Carers_Assessment
OR
(TEMPLATE_ID = 466 AND QUESTION_USER_CODE = 'assStartDate') --"Combined Needs Assessment and Support Plan"
OR
(TEMPLATE_ID = 210 AND QUESTION_USER_CODE = 'contactDateTime') --"Adult Contact (Safeguarding)"
OR
(TEMPLATE_ID = 1872 AND QUESTION_USER_CODE = 'reviewDate') --"Adult Care and Support Plan Unscheduled Review"
OR
(TEMPLATE_ID = 288 AND QUESTION_USER_CODE = 'reviewDate') --"Adult Care and Support Plan Review"
OR
(TEMPLATE_ID = 1969  AND QUESTION_USER_CODE = 'reablementStart') --"Reablement Summary"
OR 
(TEMPLATE_ID = 2065  AND QUESTION_USER_CODE = 'contactDate') --"Adult Contact – Reablement (Allied Healthcare)"

) ques

on fda.QUESTION_ID = ques.QUESTION_ID

INNER JOIN MO_FORMS frms on fda.FORM_ID = frms.FORM_ID

GROUP BY frms.WORKFLOW_STEP_ID

  )  WORKFLOW_STEP_START_DATES RIGHT OUTER JOIN reporting.dbo.MO_WORKFLOW_STEPS ON (WORKFLOW_STEP_START_DATES.WORKFLOW_STEP_ID=reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID)
   LEFT OUTER JOIN reporting.dbo.MO_WORKFLOW_LINKS  PREVIOUS_WORKFLOW_LINKS ON (PREVIOUS_WORKFLOW_LINKS.TARGET_STEP_ID=reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID)
   RIGHT OUTER JOIN reporting.dbo.MO_WORKFLOW_STEPS  PREVIOUS_WORKFLOW_STEPS ON (PREVIOUS_WORKFLOW_STEPS.WORKFLOW_STEP_ID=PREVIOUS_WORKFLOW_LINKS.SOURCE_STEP_ID)
   INNER JOIN reporting.dbo.MO_WORKFLOW_STEP_TYPES  PREVIOUS_WORKFLOW_STEP_TYPES ON (PREVIOUS_WORKFLOW_STEP_TYPES.WORKFLOW_STEP_TYPE_ID=PREVIOUS_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID)
   LEFT OUTER JOIN reporting.dbo.WORKERS  WORKFLOW_STEP_ASSIGNEE ON (reporting.dbo.MO_WORKFLOW_STEPS.ASSIGNEE_ID=WORKFLOW_STEP_ASSIGNEE.ID)
   LEFT OUTER JOIN reporting.dbo.ORGANISATIONS  RESPONSIBLE_TEAM ON (reporting.dbo.MO_WORKFLOW_STEPS.RESPONSIBLE_TEAM_ID=RESPONSIBLE_TEAM.ID)
   INNER JOIN reporting.dbo.MO_WORKFLOW_STEP_TYPES ON (reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID=reporting.dbo.MO_WORKFLOW_STEP_TYPES.WORKFLOW_STEP_TYPE_ID)
   LEFT OUTER JOIN reporting.dbo.MO_SUBGROUP_SUBJECTS ON (reporting.dbo.MO_SUBGROUP_SUBJECTS.SUBGROUP_ID=reporting.dbo.MO_WORKFLOW_STEPS.SUBGROUP_ID)
   RIGHT OUTER JOIN reporting.dbo.MO_PERSONS ON (reporting.dbo.MO_PERSONS.PERSON_ID=reporting.dbo.MO_SUBGROUP_SUBJECTS.SUBJECT_COMPOUND_ID)
   LEFT OUTER JOIN ( 
  SELECT id, person_id, CASE WHEN isnumeric(reference) = 1 THEN reference ELSE '0' END as reference
FROM person_references


WHERE REFERENCE_TYPE_ID IN ('NHS','NHS1')
  )  DT_NHS_NUMBER ON (DT_NHS_NUMBER.person_id=reporting.dbo.MO_PERSONS.PERSON_ID)
   LEFT OUTER JOIN ( 
  SELECT *

FROM PERSON_NAMES

WHERE PERSON_NAMES.NAME_CLASS_ID = 'MAIN' AND PERSON_NAMES.END_DATE IS NULL
  )  DT_Person_Names_Main ON (reporting.dbo.MO_PERSONS.PERSON_ID=DT_Person_Names_Main.PERSON_ID)
   LEFT OUTER JOIN ( 
  SELECT
 frms.WORKFLOW_STEP_ID,
 min(fda.DATE_ANSWER) as DATE_ANSWER
 --CONVERT(date,CAST(min(fda.DATE_ANSWER) as varchar),13) as DATE_ANSWER
FROM MO_FORM_DATE_ANSWERS fda
INNER JOIN
(


SELECT TEMPLATE_ID, QUESTION_ID
FROM MO_QUESTIONS
WHERE 

(TEMPLATE_ID = 300  AND QUESTION_USER_CODE = 'completionDate') -- Adult Needs Assessment
OR
(TEMPLATE_ID = 398 AND QUESTION_USER_CODE = 'completionDateTime')
OR
(TEMPLATE_ID = 455 AND QUESTION_USER_CODE = 'completionDate') --" Adult Public Healh Wellbeing and Screening"
OR
(TEMPLATE_ID = 458  AND QUESTION_USER_CODE = 'dateCompleted')  -- "Adult Consent and Capacity"
OR
(TEMPLATE_ID = 466  AND QUESTION_USER_CODE = 'completionDate') --"Combined Needs Assessment and Support Plan"
OR
(TEMPLATE_ID = 467  AND QUESTION_USER_CODE = 'reviewEnd')
OR
(TEMPLATE_ID = 475  AND QUESTION_USER_CODE = 'completionDate')
OR
(TEMPLATE_ID = 504  AND QUESTION_USER_CODE = 'completionDate')
OR
(TEMPLATE_ID = 518  AND QUESTION_USER_CODE = 'assessmentEndDate')
OR
(TEMPLATE_ID = 1715 AND QUESTION_USER_CODE = 'completionDate') --Carers Support Plan Review
OR 
(TEMPLATE_ID = 1716  AND QUESTION_USER_CODE = 'completionDate')
OR
(TEMPLATE_ID = 1717 AND QUESTION_USER_CODE = 'completionDate') -- "Adult Carer's SupportPlan"
OR
(TEMPLATE_ID = 1865  AND QUESTION_USER_CODE = 'completionDate')
OR
(TEMPLATE_ID = 1969 AND QUESTION_USER_CODE = 'ReablementEnd') --"Reablement Summary"
OR
(TEMPLATE_ID = 1982  AND QUESTION_USER_CODE = 'completionDate')
--OR
--(TEMPLATE_ID = 2026 AND QUESTION_USER_CODE = 'completedDate') -- "Hospital Notifications"
OR
(TEMPLATE_ID = 2065 AND QUESTION_USER_CODE = 'completionDate') --" Adult Contact – Reablement (Allied Healthcare)"
OR
(TEMPLATE_ID = 2143 AND QUESTION_USER_CODE = 'completionDateTime') --Adult Contact(Safeguarding)
OR
(TEMPLATE_ID = 2160  AND QUESTION_USER_CODE = 'completionDate') -- New Adults Needs Assessment

) ques

on fda.QUESTION_ID = ques.QUESTION_ID

INNER JOIN MO_FORMS frms on fda.FORM_ID = frms.FORM_ID

GROUP BY frms.WORKFLOW_STEP_ID

  )  WORKFLOW_STEP_END_DATES ON (WORKFLOW_STEP_END_DATES.WORKFLOW_STEP_ID=reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_ID)
  
WHERE
  ( reporting.dbo.MO_WORKFLOW_STEPS.WORKFLOW_STEP_TYPE_ID  IN (104, 229, 320, 496, 530, 562, 1017, 1019,1055) and reporting.dbo.MO_WORKFLOW_STEPS.STEP_STATUS NOT IN('CANCELLED','PROPOSED','COMPLETED')  )
OPTION (USE HINT ('FORCE_LEGACY_CARDINALITY_ESTIMATION'))
