-- Basic Queries

--Get all the members in CiTRA IIUM
SELECT m.fullname, m.course, m.designation, m.position, c.clubname FROM MEMBERS m
INNER JOIN clubs c ON m.clubid = c.clubid;

--Get members from IIUM Acoustic Band
SELECT m.fullname, m.course, m.designation, m.position, c.clubname FROM MEMBERS m
INNER JOIN clubs c ON m.clubid = c.clubid
WHERE c.clubid = 1;

--Get the Top Management for IIUM Acoustic Band
SELECT m.fullname, m.course, m.designation, m.position, c.clubname FROM MEMBERS m
INNER JOIN clubs c ON m.clubid = c.clubid
WHERE m.position != 'None';

--Get the staff assigned to IIUM Acoustic Band
SELECT s.staffid, s.fullfname, s.position, g.clubname, g.niche FROM STAFFS s
INNER JOIN (SELECT e.staffid, c.clubname, c.niche FROM club_staff_management e 
            INNER JOIN clubs c ON e.clubid = c.clubid WHERE e.clubid = 1) g 
ON s.staffid = g.staffid;

--Get all the staffs and the clubs they manage
SELECT s.staffid, s.fullname, s.position, g.clubname, g.niche FROM STAFFS s
LEFT OUTER JOIN (SELECT e.staffid, c.clubname, c.niche FROM club_staff_management e 
            INNER JOIN clubs c ON e.clubid = c.clubid) g 
ON s.staffid = g.staffid
ORDER BY s.staffid;

--Get all the applicants for Acoustic Band That is in processing
SELECT u.applicationid, u.fullname, u.email, u.age, u.matricno, u.course, u.kulliyah, u.application_status, c.clubname FROM user_application u 
INNER JOIN clubs c ON u.clubid = c.clubid
WHERE u.clubid = 1
AND u.application_status = 'processing';

--Get all the current active members of Acoustic Band Club
SELECT * FROM MEMBERS m
WHERE m.clubid = 1
AND m.status = 'active';

--Add a member to nasyeed club
INSERT INTO MEMBERS(USERID, CLUBID, FULLNAME, AGE, MATRICNO, COURSE, KULLIYAH, STATUS, DESIGNATION, POSITION) VALUES(5, 9, 'Rafiq Haikal Rosdin', 23, 162000, 'Engieering', 'KOE', 'active', 'Singer', 'None');
SELECT * FROM MEMBERS WHERE memberid = 13;

--Assign a staff to another club
INSERT INTO club_staff_management VALUES(1, 7);

--create a new application
INSERT INTO USER_APPLICATION(FULLNAME, EMAIL, AGE, MATRICNO, COURSE, KULLIYAH, CLUBID, application_status) VALUES('Muhammad Abrar', 'abrar@example.com', 25, 192003, 'Computer Science', 'KICT', 1, 'rejected');

--Remove a member from a club
DELETE FROM MEMBERS m WHERE m.memberid = 11;
   
   
                         
                                    