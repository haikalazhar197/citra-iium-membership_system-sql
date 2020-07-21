# CiTRA IIUM Membership System - SQL Scripts

## Description

This is the sql script used to create the database schema for the CiTRA IIUM membership system. This sql script is meant to run on
oracle databases; though the generic-ness of the commands used means that it can easily be migrated to other Relational Databases.

THis is a part of a project i.e. the "Citra IIUM membership system", and is intended to be used as reference for the database engineers of this project.

## Tables created by the script:

1. ### USERS

   - USERID: Unique ID for each user (Primary Key)
   - DISPLAYNAME: User's displayname
   - EMAIL: User's Email
   - USERPASSWORD: The encrypted password of the user.

2. ### CLUBS

   - CLUBID: Unique ID for each club (Primary Key)
   - CLUBNAME: Name of each club
   - NICHE: The niche for each club

3. ### STAFFS - The club's office level management

   - STAFFID: Unique ID for each staff (Primary Key)
   - USERID: Relation with USERS table i.e. Each staff is a user (Foreign Key)
   - FULLNAME: Full name of the staff
   - Position: The position of the staff

4. ### MEMBERS - The club's members

   - MEMBERID: Unique ID for each member (Primary Key)
   - USERID: Relation with USERS table i.e. Each membership belongs to a user (Foreign Key)
   - CLUBID: Relation with CLUBS table i.e. Each membership belongs to a club (Foreign Key)
   - FULLNAME: Full name of member
   - AGE: Age of the member
   - MATRICNO: Member's matric No; business constraint i.e. Every member of a club must be a student
   - COURSE: Course that the member is currently taking
   - KULLIYAH: the Kulliyah or Faculty of the member
   - STATUS: Status of the membership E.g. active, inactive, terminated, etc.
   - DESIGNATION: The assigned task from the club E.g. Musician
   - POSITION: Management position that the member currently holds.

5. ### CLUB_STAFF_MANAGEMENT - Table that connects staff to clubs (one to many)

   - CLUBID: Clubs (Foreign Key)
   - STAFFID: Staff (Foreign Key)

6. ### USER_APPLICATION - New application to get into the clubs
   - APPLICATIONID: Unique ID for each application made (Primary Key)
   - FULLNAME: Full name of applicant
   - EMAIL: Email address for applicants - used to create an account if accepted
   - AGE: Age of the applicant
   - MATRICNO: Matric No of the applicant - must be a student
   - COURSE: Course that the member is currently taking
   - KULLIYAH: the Kulliyah or Faculty of the member
   - CLUBID: Club that this application is attached to (Foreign Key)
   - APPLICATION_STATUS: Status of this application E.g. accpeted, rejected, or processing; defaults to processing?

## Additional Notes

1. Includes script that populates data for each table - 10 data entries each (20 for USERS table)
2. Requires a database to run the script - Preferabaly ORACLE database
