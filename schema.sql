PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Hackers (
    hacker_id INTEGER PRIMARY KEY AUTOINCREMENT,
    handle TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    reputation_score INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Admins (

    admin_id INTEGER PRIMARY KEY AUTOINCREMENT,

    full_name TEXT NOT NULL,

    username TEXT NOT NULL UNIQUE,

    role TEXT NOT NULL

);

INSERT INTO Admins
(full_name, username, role)
VALUES

('Alice Johnson','security_admin','Security Analyst'),

('Bob Smith','patch_manager','Patch Manager'),

('Charlie Lee','finance_admin','Finance Manager');



CREATE TABLE IF NOT EXISTS Assets (
    asset_id INTEGER PRIMARY KEY AUTOINCREMENT,
    asset_name TEXT NOT NULL,
    asset_type TEXT NOT NULL,
    criticality TEXT NOT NULL CHECK (
        criticality IN ('Low','Medium','High','Critical')
    )
);

CREATE TABLE IF NOT EXISTS Vulnerabilities (

    vuln_id INTEGER PRIMARY KEY AUTOINCREMENT,

    hacker_id INTEGER NOT NULL,

    asset_id INTEGER NOT NULL,

    title TEXT NOT NULL,

    severity_score REAL NOT NULL CHECK
    (
        severity_score BETWEEN 0 AND 10
    ),

    severity_level TEXT NOT NULL CHECK
(
    severity_level IN
    (
        'Low',
        'Medium',
        'High',
        'Critical'
    )
),

    status TEXT NOT NULL CHECK
    (
        status IN
        (
            'Reported',
            'Verified',
            'Patched',
            'Closed'
        )
    ),

    date_reported DATE NOT NULL,

    FOREIGN KEY(hacker_id)
        REFERENCES Hackers(hacker_id),

    FOREIGN KEY(asset_id)
        REFERENCES Assets(asset_id)

);

CREATE TABLE IF NOT EXISTS Patches (

    patch_id INTEGER PRIMARY KEY AUTOINCREMENT,

    vuln_id INTEGER NOT NULL,

    admin_id INTEGER NOT NULL,

    date_applied DATE,

    patch_notes TEXT,

    FOREIGN KEY(vuln_id)
        REFERENCES Vulnerabilities(vuln_id),

    FOREIGN KEY(admin_id)
        REFERENCES Admins(admin_id)

);

CREATE TABLE IF NOT EXISTS BountyPayouts (

    payout_id INTEGER PRIMARY KEY AUTOINCREMENT,

    vuln_id INTEGER NOT NULL,

    amount REAL NOT NULL,

    payment_date DATE,

    status TEXT NOT NULL CHECK
    (
        status IN
        (
            'Pending',
            'Approved',
            'Paid'
        )
    ),

    FOREIGN KEY(vuln_id)
        REFERENCES Vulnerabilities(vuln_id)

);

CREATE TABLE IF NOT EXISTS CurrentUser (

    session_id INTEGER PRIMARY KEY,

    admin_id INTEGER NOT NULL,

    FOREIGN KEY(admin_id)
        REFERENCES Admins(admin_id)

);

INSERT INTO CurrentUser
VALUES
(
1,
1
);

CREATE TABLE IF NOT EXISTS Audit_Vulnerabilities (

    log_id INTEGER PRIMARY KEY AUTOINCREMENT,

    vuln_id INTEGER NOT NULL,

    old_severity REAL,

    new_severity REAL,

    old_status TEXT,

    new_status TEXT,

    operation_type TEXT NOT NULL,

    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,

    changed_by_user TEXT,

    FOREIGN KEY(vuln_id)
        REFERENCES Vulnerabilities(vuln_id)

);

CREATE TABLE IF NOT EXISTS Audit_BountyPayouts (

    log_id INTEGER PRIMARY KEY AUTOINCREMENT,

    payout_id INTEGER NOT NULL,

    old_amount REAL,

    new_amount REAL,

    old_status TEXT,

    new_status TEXT,

    operation_type TEXT NOT NULL,

    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,

    changed_by_user TEXT,

    FOREIGN KEY(payout_id)
        REFERENCES BountyPayouts(payout_id)

);

CREATE TRIGGER trg_vulnerability_insert

AFTER INSERT ON Vulnerabilities

BEGIN

INSERT INTO Audit_Vulnerabilities
(

vuln_id,

old_severity,

new_severity,

old_status,

new_status,

operation_type,

changed_by_user

)

VALUES
(

NEW.vuln_id,

NULL,

NEW.severity_score,

NULL,

NEW.status,

'INSERT',

(
SELECT username
FROM Admins
WHERE admin_id =
(
SELECT admin_id
FROM CurrentUser
LIMIT 1
)
)

);

END;

CREATE TRIGGER trg_vulnerability_update

AFTER UPDATE

ON Vulnerabilities

BEGIN

INSERT INTO Audit_Vulnerabilities
(

vuln_id,

old_severity,

new_severity,

old_status,

new_status,

operation_type,

changed_by_user

)

VALUES
(

OLD.vuln_id,

OLD.severity_score,

NEW.severity_score,

OLD.status,

NEW.status,

'UPDATE',

(
SELECT username
FROM Admins
WHERE admin_id =
(
SELECT admin_id
FROM CurrentUser
LIMIT 1
)
)
);
END;

CREATE TRIGGER trg_bounty_insert

AFTER INSERT

ON BountyPayouts

BEGIN

INSERT INTO Audit_BountyPayouts
(
payout_id,
old_amount,
new_amount,
old_status,
new_status,
operation_type,
changed_by_user
)
VALUES
(
NEW.payout_id,
NULL,
NEW.amount,
NULL,
NEW.status,
'INSERT',
(
SELECT username
FROM Admins
WHERE admin_id =
(
SELECT admin_id
FROM CurrentUser
LIMIT 1
)
)
);
END;

CREATE TRIGGER trg_bounty_update

AFTER UPDATE

ON BountyPayouts

BEGIN

INSERT INTO Audit_BountyPayouts
(

payout_id,

old_amount,

new_amount,

old_status,

new_status,

operation_type,

changed_by_user

)

VALUES
(

OLD.payout_id,

OLD.amount,

NEW.amount,

OLD.status,

NEW.status,

'UPDATE',

(
SELECT username
FROM Admins
WHERE admin_id =
(
SELECT admin_id
FROM CurrentUser
LIMIT 1
)
)

);
END;


INSERT INTO Hackers (handle, email, reputation_score) VALUES
('ZeroCool', 'zerocool@email.com', 980),
('CyberGhost', 'cyberghost@email.com', 740),
('NightFox', 'nightfox@email.com', 650);
INSERT INTO Hackers (handle, email, reputation_score) VALUES
('NullByte','nullbyte@email.com',870),
('RootKit','rootkit@email.com',930),
('ShadowHex','shadowhex@email.com',520),
('CryptoKnight','cryptoknight@email.com',790),
('DarkPacket','darkpacket@email.com',610),
('BinaryStorm','binarystorm@email.com',450),
('ExploitX','exploitx@email.com',995),
('GhostShell','ghostshell@email.com',710);

INSERT INTO Assets (asset_name, asset_type, criticality) VALUES
('Main Website', 'Web Application', 'Critical'),
('Customer API', 'REST API', 'High'),
('Employee Portal', 'Internal System', 'Medium');
INSERT INTO Assets (asset_name, asset_type, criticality) VALUES
('Payment Gateway','Web Application','Critical'),
('Authentication Server','Server','Critical'),
('Mobile Banking App','Mobile App','High'),
('Admin Dashboard','Web Portal','Critical'),
('Cloud Storage','Cloud','High'),
('Internal HR System','Internal System','Medium'),
('Email Server','Mail Server','Medium');

INSERT INTO Vulnerabilities
(hacker_id,asset_id,title,severity_score,severity_level,status,date_reported)
VALUES

(1,2,'SQL Injection in Login API',9.8,'Critical','Reported','2026-07-01'),

(2,1,'Stored Cross Site Scripting',8.4,'High','Verified','2026-07-03'),

(3,4,'Authentication Bypass',9.5,'Critical','Patched','2026-07-05'),

(4,5,'Privilege Escalation',9.1,'Critical','Reported','2026-07-06'),

(5,3,'Remote Code Execution',10,'Critical','Verified','2026-07-07'),

(6,6,'Directory Traversal',7.4,'High','Closed','2026-07-08'),

(7,7,'Broken Access Control',8.6,'High','Reported','2026-07-10'),

(8,8,'Sensitive Information Disclosure',6.9,'Medium','Verified','2026-07-12'),

(9,9,'Insecure Direct Object Reference',8.8,'High','Patched','2026-07-15'),

(10,10,'Command Injection',9.7,'Critical','Reported','2026-07-17');

INSERT INTO Patches
(vuln_id,admin_id,date_applied,patch_notes)
VALUES

(3,2,'2026-07-08',
'Authentication module updated.'),

(6,2,'2026-07-10',
'Directory validation added.'),

(9,2,'2026-07-18',
'Authorization logic rewritten.');

INSERT INTO BountyPayouts
(vuln_id,amount,payment_date,status)
VALUES

(1,2500,'2026-07-20','Approved'),

(2,1800,'2026-07-19','Paid'),

(3,3000,'2026-07-09','Paid'),

(4,2200,'2026-07-22','Pending'),

(5,5000,'2026-07-21','Approved'),

(6,1200,'2026-07-12','Paid'),

(7,2600,'2026-07-25','Pending'),

(8,900,'2026-07-24','Approved'),

(9,2800,'2026-07-19','Paid'),

(10,4500,'2026-07-27','Pending');



UPDATE CurrentUser
SET admin_id = 1;

UPDATE Vulnerabilities
SET severity_score = 9.9,
    status = 'Verified'
WHERE vuln_id = 1;


UPDATE CurrentUser
SET admin_id = 2;

UPDATE Vulnerabilities
SET status = 'Patched'
WHERE vuln_id = 1;



UPDATE CurrentUser
SET admin_id = 3;

UPDATE BountyPayouts
SET amount = 3500,
    status = 'Paid'
WHERE payout_id = 1;