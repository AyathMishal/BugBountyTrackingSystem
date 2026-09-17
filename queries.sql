
SELECT
    v.vuln_id,
    v.title,
    av.old_severity,
    av.new_severity,
    bp.amount AS current_bounty,
    av.timestamp,
    av.changed_by_user
FROM Vulnerabilities v
JOIN Audit_Vulnerabilities av
    ON v.vuln_id = av.vuln_id
JOIN BountyPayouts bp
    ON v.vuln_id = bp.vuln_id
WHERE v.vuln_id = 1
AND av.operation_type = 'UPDATE'
ORDER BY av.timestamp;


SELECT

    vuln_id,

    old_status,

    new_status,

    operation_type,

    timestamp,

    changed_by_user

FROM Audit_Vulnerabilities

WHERE vuln_id = 1

ORDER BY timestamp;



SELECT

'Vulnerability Audit' AS audit_source,

vuln_id AS reference_id,

operation_type,

timestamp,

changed_by_user

FROM Audit_Vulnerabilities

WHERE changed_by_user='patch_manager'

UNION ALL

SELECT

'Bounty Audit',

payout_id,

operation_type,

timestamp,

changed_by_user

FROM Audit_BountyPayouts

WHERE changed_by_user='patch_manager'

ORDER BY timestamp;



SELECT

vuln_id,

ROUND(

AVG(

JULIANDAY(timestamp)

-

JULIANDAY(date_reported)

)

,

2

)

AS average_days

FROM Audit_Vulnerabilities

JOIN Vulnerabilities

USING(vuln_id)

GROUP BY vuln_id;



SELECT

payout_id,

old_amount,

new_amount,

old_status,

new_status,

timestamp,

changed_by_user

FROM Audit_BountyPayouts

WHERE DATE(timestamp)

BETWEEN

DATE('2026-07-20')

AND

DATE('2026-07-27')

ORDER BY timestamp;



DROP VIEW IF EXISTS vw_WhyProvenance;

CREATE VIEW vw_WhyProvenance AS
SELECT
    v.vuln_id,
    v.title,
    av.old_severity,
    av.new_severity,
    bp.amount AS current_bounty,
    av.timestamp,
    av.changed_by_user
FROM Vulnerabilities v
JOIN Audit_Vulnerabilities av
    ON v.vuln_id = av.vuln_id
JOIN BountyPayouts bp
    ON v.vuln_id = bp.vuln_id
WHERE av.operation_type = 'UPDATE';



DROP VIEW IF EXISTS vw_HowProvenance;

CREATE VIEW vw_HowProvenance AS
SELECT
    vuln_id,
    old_status,
    new_status,
    operation_type,
    timestamp,
    changed_by_user
FROM Audit_Vulnerabilities
ORDER BY vuln_id, timestamp;


DROP VIEW IF EXISTS vw_WhereProvenance;

CREATE VIEW vw_WhereProvenance AS

SELECT
    'Vulnerability' AS audit_source,
    vuln_id AS reference_id,
    operation_type,
    timestamp,
    changed_by_user
FROM Audit_Vulnerabilities

UNION ALL

SELECT
    'Bounty' AS audit_source,
    payout_id AS reference_id,
    operation_type,
    timestamp,
    changed_by_user
FROM Audit_BountyPayouts;
