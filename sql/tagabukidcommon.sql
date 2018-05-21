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
  e.*, ei.gender, ei.birthdate, 
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
WHERE isapproved = 1 AND entity_name LIKE $P{searchtext}

[getVacantPlantilla]
SELECT p."Id",p."ItemNo",
  o."OrgUnitId" AS org_objid,o."Entity_Name" AS org_name,o."Entity_AcronymAbbreviation" AS org_code,o."Entity_Description" AS org_description,
  j."Id" AS jobposition_objid,j."Entity_Name" AS jobposition_name,j."Entity_AcronymAbbreviation" AS jobposition_code,j."Entity_Description" AS jobposition_description,
  f."Id" AS finfund_objid,f."Entity_Name" AS finfund_name,f."Entity_AcronymAbbreviation" AS finfund_code,f."Entity_Description" AS finfund_description,
  a."Id" AS finaccounttitle_objid,a."Entity_Name" AS finaccounttitle_name,a."Entity_AcronymAbbreviation" AS finaccounttitle_code,a."Entity_Description" AS finaccounttitle_description,
  i."Id" AS incrementtype_objid,i."Entity_Name" AS incrementtype_name,i."Entity_AcronymAbbreviation" AS incrementtype_code,i."Entity_Description" AS incrementtype_description,
  c."Id" AS positionclassification_objid,c."Entity_Name" AS positionclassification_name,c."Entity_AcronymAbbreviation" AS positionclassification_code,c."Entity_Description" AS positionclassification_description,
  s."Id" AS postiionsubclassification_objid,s."Entity_Name" AS postiionsubclassification_name,s."Entity_AcronymAbbreviation" AS postiionsubclassification_code,s."Entity_Description" AS postiionsubclassification_description,
  p."Discriminator"
FROM "hrmis"."tblEmploymentPlantilla" p
INNER JOIN "references"."tblOrganizationUnit" o ON o."OrgUnitId" = p."OrganizationUnitId"
INNER JOIN "references"."tblJobPosition" j ON j."Id" = p."JobPositionId"
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


[getFund]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.name) - 1) ), node.name) AS `location`,node.*
FROM references_tblfinfund AS node,
        references_tblfinfund AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt AND node.name LIKE $P{searchtext}
GROUP BY node.name
ORDER BY node.lft

[getAccountTitle]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.name) - 1) ), node.name) AS `location`,node.*
FROM references_tblfinaccounttitle AS node,
        references_tblfinaccounttitle AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt AND node.name LIKE $P{searchtext}
GROUP BY node.name
ORDER BY node.lft

[getJobPosition]
SELECT * FROM references_tbljobposition
WHERE name LIKE $P{searchtext} OR code LIKE $P{searchtext}


[findroot]
SELECT * FROM ${tablename} WHERE parentid IS NULL

[initroot]
UPDATE ${tablename} SET lft = 1, rgt = 2

[getnodes]
SELECT * FROM ${tablename} WHERE parentid IS NOT NULL

[findparent]
SELECT * FROM ${tablename} WHERE objid = $P{parentid}

[changeParentRight]
UPDATE ${tablename} SET rgt = rgt + 2 WHERE rgt > $P{myLeft}

[changeParentLeft]
UPDATE ${tablename} SET lft = lft + 2 WHERE lft > $P{myLeft}

[addChild]
UPDATE ${tablename} o SET o.lft = $P{myLeft} + 1, o.rgt = $P{myLeft} + 2 WHERE o.objid = $P{objid}
