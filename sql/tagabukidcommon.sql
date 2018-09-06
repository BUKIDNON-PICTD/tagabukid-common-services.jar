[getOrgUnit]
SELECT * FROM references_tblorganizationunit
WHERE (UPPER(name) LIKE $P{searchtext} 
OR UPPER(code) LIKE $P{searchtext})
ORDER BY name

[getOrgUnitByParent]
SELECT * FROM references_tblorganizationunit
WHERE (UPPER(name) LIKE $P{searchtext} 
OR UPPER(code) LIKE $P{searchtext})
AND parentorgunitid = $P{orgparentid}
ORDER BY name

[getOrgUnitByParents]
SELECT * FROM references_tblorganizationunit
WHERE (UPPER(name) LIKE $P{searchtext} 
OR UPPER(code) LIKE $P{searchtext})
${filter}
ORDER BY name

[getEntityPersonnel]
SELECT 
  e.*,ei.lastname,ei.firstname,ei.middlename, ei.gender, ei.birthdate, 
  (SELECT bldgno FROM entity_address WHERE objid=e.address_objid) as address_bldgno, 
  (SELECT bldgname FROM entity_address WHERE objid=e.address_objid) as address_bldgname,  
  (SELECT unitno FROM entity_address WHERE objid=e.address_objid) as address_unitno , 
  (SELECT street FROM entity_address WHERE objid=e.address_objid) as address_street ,  
  (SELECT subdivision FROM entity_address WHERE objid=e.address_objid) as address_subdivision, 
  (SELECT barangay_name FROM entity_address WHERE objid=e.address_objid) as address_barangay_name, 
  (SELECT city FROM entity_address WHERE objid=e.address_objid) as address_city, 
  (SELECT municipality FROM entity_address WHERE objid=e.address_objid) as address_municipality, 
  (SELECT province FROM entity_address WHERE objid=e.address_objid) as address_province 
FROM entity e 
${filter}
 


[lookupEmployeeJobPositionMaster]
SELECT * 
FROM references_tbljobposition 
WHERE `name` LIKE $P{searchtext} OR `code` LIKE $P{searchtext}

[getNatureofAppointment]
SELECT * FROM references_tblappointmententrycode
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

[getTranche]
SELECT * FROM hrmis_tblpayrollsalarytranche
WHERE isapproved = 1 AND name LIKE $P{searchtext}

[getVacantPlantilla1]
SELECT p."Id",p."ItemNo",
  o."OrgUnitId" AS org_objid,o."Entity_Name" AS org_name,o."Entity_AcronymAbbreviation" AS org_code,o."Entity_Description" AS org_description,
  j."Id" AS jobposition_objid,j."Entity_Name" AS jobposition_name,j."Entity_AcronymAbbreviation" AS jobposition_code,j."Entity_Description" AS jobposition_description,
  f."Id" AS finfund_objid,f."Entity_Name" AS finfund_name,f."Entity_AcronymAbbreviation" AS finfund_code,f."Entity_Description" AS finfund_description,
  a."Id" AS finaccounttitle_objid,a."Entity_Name" AS finaccounttitle_name,a."Entity_AcronymAbbreviation" AS finaccounttitle_code,a."Entity_Description" AS finaccounttitle_description,
  i."Id" AS incrementtype_objid,i."Entity_Name" AS incrementtype_name,i."Entity_AcronymAbbreviation" AS incrementtype_code,i."Entity_Description" AS incrementtype_description,
  c."Id" AS positionclassification_objid,c."Entity_Name" AS positionclassification_name,c."Entity_AcronymAbbreviation" AS positionclassification_code,c."Entity_Description" AS positionclassification_description,
  s."Id" AS postiionsubclassification_objid,s."Entity_Name" AS postiionsubclassification_name,s."Entity_AcronymAbbreviation" AS postiionsubclassification_code,s."Entity_Description" AS postiionsubclassification_description,
  p."Discriminator", pay."Id" AS paygradeandstepincrement_objid, pay."Grade" AS paygradeandstepincrement_grade, pay."Step" AS paygradeandstepincrement_step
FROM "hrmis"."tblEmploymentPlantilla" p
INNER JOIN "references"."tblOrganizationUnit" o ON o."OrgUnitId" = p."OrganizationUnitId"
INNER JOIN "references"."tblJobPosition" j ON j."Id" = p."JobPositionId"
INNER JOIN "references"."tblPayGradeAndStepIncrement" pay ON pay."Id" = j."PayGradeId"
INNER JOIN "references"."tblFinFund" f ON f."Id" = p."FundId"
INNER JOIN "references"."tblFinAccountTitle" a ON a."Id" = p."AccountTitleId"
LEFT JOIN "references"."tblEmptIncrementType" i ON i."Id" = p."IncrementTypeId"
LEFT JOIN "references"."tblEmptPositionServiceClassification" c ON c."Id" = p."PositionServiceClassificationId"
LEFT JOIN "references"."tblEmptPositionServiceSubClassification" s ON s."Id" = p."PositionServiceSubClassificationId"
LEFT JOIN "hrmis"."tblEmploymentPlantillaAppointmentGroupMember" mm ON mm."PlantillaId" = p."Id"
LEFT JOIN "hrmis"."tblEmploymentBatchPlantillaAppointment" bb ON bb."PlantillaGroupId" = mm."PlantillaAppointmentGroupId"
WHERE p."IsFunded" = true
AND o."OrgUnitId" = UUID($P{orgunitid})
AND p."Discriminator" = 'CasualPlantilla'
AND mm."Id" IS NULL

[getVacantCasualPlantilla]
SELECT	p.objid,
  p.itemno,
  o.orgunitid AS org_objid,
  o.name AS org_name,
  o.code AS org_code,
  o.description AS org_description,
  j.objid AS jobposition_objid,
  j.name AS jobposition_name,
  j.code AS jobposition_code,
  j.description AS jobposition_description,
  f.objid AS finfund_objid,
  f.name AS finfund_name,
  f.code AS finfund_code,
  f.description AS finfund_description,
  a.objid AS finaccounttitle_objid,
  a.name AS finaccounttitle_name,
  a.code AS finaccounttitle_code,
  a.description AS finaccounttitle_description,
  i.objid AS incrementtype_objid,
  i.name AS incrementtype_name,
  i.code AS incrementtype_code,
  i.description AS incrementtype_description,
  s.objid AS positionclassification_objid,
  s.name AS positionclassification_name,
  s.code AS positionclassification_code,
  s.description AS positionclassification_description,
  sc.objid AS postiionsubclassification_objid,
  sc.name AS postiionsubclassification_name,
  sc.code AS postiionsubclassification_code,
  sc.description AS postiionsubclassification_description,
  p.type, 
  pay.objid AS paygradeandstepincrement_objid, 
  pay.`grade` AS paygradeandstepincrement_grade, 
  pay.step AS paygradeandstepincrement_step
FROM hrmis_tblemploymentplantilla p
INNER JOIN references_tblorganizationunit o ON o.`orgunitid` = p.`org_orgunitid`
INNER JOIN references_tbljobposition j ON j.`objid` = p.`jobposition_objid`
INNER JOIN references_tblpaygradeandstepincrement pay ON pay.`objid` = j.`paygradeid`
INNER JOIN references_tblfinfund f ON f.`objid` = p.`fund_objid`
INNER JOIN references_tblfinaccounttitle a ON a.`objid` = p.`accounttitle_objid`
LEFT JOIN references_tblemptincrementtype i ON i.`objid` = p.`incrementtype_objid`
LEFT JOIN references_tblemptpositionserviceclassification s ON s.`objid` = p.`positionserviceclassification_objid`
LEFT JOIN references_tblemptpositionservicesubclassification sc ON sc.`objid` = p.`positionservicesubclassification_objid`
WHERE p.`isfunded` = TRUE 
AND p.type = 'casual'
AND o.orgunitid = $P{orgunitid}
AND (j.name LIKE $P{searchtext} OR o.itemno LIKE $P{searchtext})
AND p.`objid` NOT IN (
SELECT i.`plantilla_objid` FROM hrmis_appointmentcasualitems i
INNER JOIN hrmis_appointmentcasual a ON a.`objid` = i.`parentid`
WHERE NOW() BETWEEN a.`effectivefrom` AND a.`effectiveuntil` AND i.personnel_objid <> $P{personnelid})
ORDER BY p.itemno


[getPlantillaByIdx]
SELECT p."Id",p."ItemNo",
  o."OrgUnitId" AS org_objid,o."Entity_Name" AS org_name,o."Entity_AcronymAbbreviation" AS org_code,o."Entity_Description" AS org_description,
  j."Id" AS jobposition_objid,j."Entity_Name" AS jobposition_name,j."Entity_AcronymAbbreviation" AS jobposition_code,j."Entity_Description" AS jobposition_description,
  f."Id" AS finfund_objid,f."Entity_Name" AS finfund_name,f."Entity_AcronymAbbreviation" AS finfund_code,f."Entity_Description" AS finfund_description,
  a."Id" AS finaccounttitle_objid,a."Entity_Name" AS finaccounttitle_name,a."Entity_AcronymAbbreviation" AS finaccounttitle_code,a."Entity_Description" AS finaccounttitle_description,
  i."Id" AS incrementtype_objid,i."Entity_Name" AS incrementtype_name,i."Entity_AcronymAbbreviation" AS incrementtype_code,i."Entity_Description" AS incrementtype_description,
  c."Id" AS positionclassification_objid,c."Entity_Name" AS positionclassification_name,c."Entity_AcronymAbbreviation" AS positionclassification_code,c."Entity_Description" AS positionclassification_description,
  s."Id" AS postiionsubclassification_objid,s."Entity_Name" AS postiionsubclassification_name,s."Entity_AcronymAbbreviation" AS postiionsubclassification_code,s."Entity_Description" AS postiionsubclassification_description,
  p."Discriminator", pay."Id" AS paygradeandstepincrement_objid, pay."Grade" AS paygradeandstepincrement_grade, pay."Step" AS paygradeandstepincrement_step
FROM "hrmis"."tblEmploymentPlantilla" p
INNER JOIN "references"."tblOrganizationUnit" o ON o."OrgUnitId" = p."OrganizationUnitId"
INNER JOIN "references"."tblJobPosition" j ON j."Id" = p."JobPositionId"
INNER JOIN "references"."tblPayGradeAndStepIncrement" pay ON pay."Id" = j."PayGradeId"
INNER JOIN "references"."tblFinFund" f ON f."Id" = p."FundId"
INNER JOIN "references"."tblFinAccountTitle" a ON a."Id" = p."AccountTitleId"
LEFT JOIN "references"."tblEmptIncrementType" i ON i."Id" = p."IncrementTypeId"
LEFT JOIN "references"."tblEmptPositionServiceClassification" c ON c."Id" = p."PositionServiceClassificationId"
LEFT JOIN "references"."tblEmptPositionServiceSubClassification" s ON s."Id" = p."PositionServiceSubClassificationId"
LEFT JOIN "hrmis"."tblEmploymentPlantillaAppointmentGroupMember" mm ON mm."PlantillaId" = p."Id"
LEFT JOIN "hrmis"."tblEmploymentBatchPlantillaAppointment" bb ON bb."PlantillaGroupId" = mm."PlantillaAppointmentGroupId"
WHERE p."IsFunded" = true
AND p."Id" = UUID($P{plantillaid})
AND p."Discriminator" = 'CasualPlantilla'

[findPlantillaById]
SELECT	p.objid,
  p.itemno,
  o.orgunitid AS org_objid,
  o.name AS org_name,
  o.code AS org_code,
  o.description AS org_description,
  j.objid AS jobposition_objid,
  j.name AS jobposition_name,
  j.code AS jobposition_code,
  j.description AS jobposition_description,
  f.objid AS finfund_objid,
  f.name AS finfund_name,
  f.code AS finfund_code,
  f.description AS finfund_description,
  a.objid AS finaccounttitle_objid,
  a.name AS finaccounttitle_name,
  a.code AS finaccounttitle_code,
  a.description AS finaccounttitle_description,
  i.objid AS incrementtype_objid,
  i.name AS incrementtype_name,
  i.code AS incrementtype_code,
  i.description AS incrementtype_description,
  s.objid AS positionclassification_objid,
  s.name AS positionclassification_name,
  s.code AS positionclassification_code,
  s.description AS positionclassification_description,
  sc.objid AS postiionsubclassification_objid,
  sc.name AS postiionsubclassification_name,
  sc.code AS postiionsubclassification_code,
  sc.description AS postiionsubclassification_description,
  p.type, 
  pay.objid AS paygradeandstepincrement_objid, 
  pay.`grade` AS paygradeandstepincrement_grade, 
  pay.step AS paygradeandstepincrement_step
FROM hrmis_tblemploymentplantilla p
INNER JOIN references_tblorganizationunit o ON o.`orgunitid` = p.`org_orgunitid`
INNER JOIN references_tbljobposition j ON j.`objid` = p.`jobposition_objid`
INNER JOIN references_tblpaygradeandstepincrement pay ON pay.`objid` = j.`paygradeid`
INNER JOIN references_tblfinfund f ON f.`objid` = p.`fund_objid`
INNER JOIN references_tblfinaccounttitle a ON a.`objid` = p.`accounttitle_objid`
LEFT JOIN references_tblemptincrementtype i ON i.`objid` = p.`incrementtype_objid`
LEFT JOIN references_tblemptpositionserviceclassification s ON s.`objid` = p.`positionserviceclassification_objid`
LEFT JOIN references_tblemptpositionservicesubclassification sc ON sc.`objid` = p.`positionservicesubclassification_objid`
WHERE p.`isfunded` = TRUE 
AND p.type = 'casual'
AND p.objid = $P{plantillaid}


[getFund]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.name) - 1) ), node.name) AS `location`,node.*
FROM references_tblfinfund AS node,
        references_tblfinfund AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt 
AND node.lft NOT BETWEEN 
(SELECT lft FROM references_tblfinfund WHERE objid = 'bbf36e75-cf93-480e-bbf4-d99d5b2dcac5') AND 
(SELECT rgt FROM references_tblfinfund WHERE objid = 'bbf36e75-cf93-480e-bbf4-d99d5b2dcac5') 
AND node.name <> 'ROOT'
AND node.name LIKE $P{searchtext}
GROUP BY node.name
ORDER BY node.lft

[getParentFund]
SELECT * FROM references_tblfinfund
WHERE objid LIKE '79d3b1e6-1bfd-4345-ac35-5c25b80f4c18'

[getAccountTitle]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.name) - 1) ), node.name) AS `location`,node.*
FROM references_tblfinaccounttitle AS node,
        references_tblfinaccounttitle AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt AND node.name LIKE $P{searchtext}
AND node.name <> 'ROOT'
GROUP BY node.name
ORDER BY node.lft

[getJobPosition]
SELECT * FROM references_tbljobposition
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

[getIncrementType]
SELECT * FROM references_tblemptincrementtype
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

[getPositionServiceClassification]
SELECT * FROM references_tblemptpositionserviceclassification
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

[getPositionServiceSubClassification]
SELECT * FROM references_tblemptpositionservicesubclassification
WHERE positionserviceclassificationid = $P{parentid} AND (name LIKE $P{searchtext} OR code LIKE $P{searchtext})

[getEducationalInstitution]
SELECT * FROM references_tblinstitution 
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext} OR address_addressdetails LIKE $P{searchtext} 

[getTrainingCategory]
SELECT * FROM references_tbltrainingcategory 
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

[getRecognitionCategory]
SELECT * FROM references_tblrecognitioncategory 
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}






[initroot]
UPDATE ${tablename} SET lft = 1, rgt = 2 WHERE ${parentid} IS NULL

[setlftrgttonull]
UPDATE ${tablename} SET lft = NULL, rgt = NULL


[getnodes]
SELECT * FROM ${tablename} WHERE lft IS NULL

[findparent]
SELECT * FROM ${tablename} WHERE ${tblprimarykey} = $P{parentid} AND lft IS NOT NULL

[changeParentRight]
UPDATE ${tablename} SET rgt = rgt + 2 WHERE rgt > $P{myLeft}

[changeParentLeft]
UPDATE ${tablename} SET lft = lft + 2 WHERE lft > $P{myLeft}

[addChild]
UPDATE ${tablename} SET lft = $P{myLeft} + 1, rgt = $P{myLeft} + 2 WHERE ${tblprimarykey} = $P{objid}

[getCivilService]
SELECT * FROM references_tbleligibilitytype 
WHERE name LIKE $P{searchtext}

[getServiceRecordAction]
SELECT objid, name, code FROM `references_tblappointmententrycode`
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

UNION

SELECT objid, name, code FROM `references_tblemploymentseparationtype`
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

UNION

SELECT objid, circular_name AS name, circular_acronymabbreviation AS code FROM `hrmis_tblpayrollsalarytranche`
WHERE name LIKE $P{searchtext} OR circular_acronymabbreviation LIKE $P{searchtext}

UNION

SELECT objid, name, code FROM `references_tblemploymentstepincrementlongivitycircular`
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}

UNION

SELECT objid, name, objid AS code FROM `references_leave_type`
WHERE name LIKE $P{searchtext} OR objid LIKE $P{searchtext}

[getServiceRecordActionById]
SELECT objid, name, code FROM `references_tblappointmententrycode`
WHERE objid LIKE $P{objid}

UNION

SELECT objid, name, code FROM `references_tblemploymentseparationtype`
WHERE objid LIKE $P{objid}

UNION

SELECT objid, circular_name AS name, circular_acronymabbreviation AS code FROM `hrmis_tblpayrollsalarytranche`
WHERE objid LIKE $P{objid}

UNION

SELECT objid, name, code FROM `references_tblemploymentstepincrementlongivitycircular`
WHERE objid LIKE $P{objid}

UNION

SELECT objid, name, objid AS code FROM `references_leave_type`
WHERE objid LIKE $P{objid}

