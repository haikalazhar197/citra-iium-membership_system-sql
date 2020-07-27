
-- Procedures and Functions

--Procedure to create new user and membership on accepted application
-- Accepts The application ID 
-- Generates a random password for the user
-- Create a membership field on the members table
CREATE OR REPLACE PROCEDURE
register_new_member(v_applicationid user_application.applicationid%TYPE)
AS
    v_randompass            users.userpassword%TYPE;
    v_userid                users.userid%TYPE;
    v_email                 users.email%TYPE;
    v_displayname           users.displayname%TYPE;
    v_memberid              members.memberid%TYPE;
    v_clubid                members.clubid%TYPE;
    v_fullname              members.fullname%TYPE;
    v_age                   members.age%TYPE;
    v_matricno              members.matricno%TYPE;
    v_course                members.course%TYPE;
    v_kulliyah              members.kulliyah%TYPE;
    v_status                members.status%TYPE;
    v_designation           members.designation%TYPE;
    v_position              members.position%TYPE;
    v_application_status    user_application.application_status%TYPE;
BEGIN
    -- get the application
    SELECT fullname, email, age, matricno, course, kulliyah, clubid, application_status
    INTO v_fullname, v_email, v_age, v_matricno, v_course, v_kulliyah, v_clubid, v_application_status
    FROM user_application
    WHERE applicationid = v_applicationid;
    DBMS_OUTPUT.PUT_LINE(v_fullname || ' ' || v_email || ' ' || v_age || ' ' || v_matricno || ' ' || v_course || ' ' || v_kulliyah || ' ' || v_clubid || ' ' || v_application_status);
    
    -- check if the application is not already rejected or accepted
    IF v_application_status = 'processing' THEN
        DBMS_OUTPUT.PUT_LINE('Executing process');
        
        -- generate random password for the user
        SELECT dbms_random.string('A', 10) INTO v_randompass FROM dual;
        DBMS_OUTPUT.PUT_LINE(v_randompass);
        
        -- create new user and retrieve the the users id
        INSERT INTO USERS(displayname, email, userpassword) VALUES(v_fullname, v_email, v_randompass);
        SELECT user_id_seq.currval INTO v_userid FROM DUAL;
        DBMS_OUTPUT.PUT_LINE(v_userid);
        
        -- create a new membership for the user 
        INSERT INTO MEMBERS(userid, clubid, fullname, age, matricno, course, kulliyah, status, designation, position) 
        VALUES(v_userid, v_clubid, v_fullname, v_age, v_matricno, v_course, v_kulliyah, 'active', 'member', 'None');
        
        -- change the status of the application to accpeted.
        UPDATE user_application 
        SET application_status = 'accepted'
        WHERE applicationid = v_applicationid;
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not executing the process');
    END IF;
END;    
/

EXEC register_new_member(1);
    


--Procedure to change the status of member from active to inactive for members that has more than 5 years of study
CREATE OR REPLACE PROCEDURE
change_status
AS
    v_memberid          members.memberid%TYPE;
    v_matricno          members.matricno%TYPE;
    CURSOR mem_cursor IS
    SELECT memberid, matricno
    FROM members;
BEGIN
    OPEN mem_cursor;
    
    LOOP
        FETCH mem_cursor INTO v_memberid, v_matricno;
        EXIT WHEN mem_cursor%NOTFOUND;
        
        IF v_matricno < 150000 THEN
            UPDATE members SET STATUS = 'inactive' WHERE memberid = v_memberid;
            DBMS_OUTPUT.PUT_LINE('The status for ' || v_memberid || ' is changed to inactive');
        END IF;
        
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_memberid) || ' ' || TO_CHAR(v_matricno));
    END LOOP;
    CLOSE mem_cursor;
END;
/

--Function to get the number of members younger than a provided age for a given club
CREATE OR REPLACE FUNCTION
get_member_in(member_age IN NUMBER, club_name IN VARCHAR2)
    RETURN NUMBER
AS
    v_age      members.age%TYPE;
    v_membercount   NUMBER;
    CURSOR mem_cursor IS
    SELECT age FROM members
    WHERE clubid 
    IN (SELECT clubid FROM clubs WHERE clubname = club_name);
BEGIN
    v_membercount := 0;
    OPEN mem_cursor;
    
    LOOP
        FETCH mem_cursor INTO v_age;
        EXIT WHEN mem_cursor%NOTFOUND;
        
        IF v_age < member_age THEN
            v_membercount := v_membercount + 1;
        END IF;   
    END LOOP;
    
    CLOSE mem_cursor;
    RETURN(v_membercount);
END;
/

-- Testing the function by getting the number of members in IIUM Acousstic Band who is below the age of 26
DECLARE
    v_number_mem    NUMBER(10);
BEGIN 
    v_number_mem := get_member_in(26, 'IIUM Acousstic Band');
    DBMS_OUTPUT.PUT_LINE(v_number_mem);
END;
/


--Function to retrieve the total number of active student in a given club
CREATE OR REPLACE FUNCTION
retrieve_active_member_in(club_name IN VARCHAR2)
RETURN NUMBER
IS
    v_number_of_members     NUMBER(10);
BEGIN
    SELECT COUNT(memberid) INTO v_number_of_members 
    FROM members
    WHERE CLUBID IN 
    (SELECT clubid FROM CLUBS WHERE clubname = club_name);
    
    RETURN(v_number_of_members);
END;
/

-- Testing the function by getting the number of active members in IIUM Acousstic Band
DECLARE 
    v_number_of_members     NUMBER(10);
BEGIN
    v_number_of_members := retrieve_active_member_in('IIUM Acousstic Band');
    DBMS_OUTPUT.PUT_LINE('Number of active members in IIUM Acoustic Band is ' || v_number_of_members);
END;
/