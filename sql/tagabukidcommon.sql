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