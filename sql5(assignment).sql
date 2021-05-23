create database assignment;
use assignment;
/* creating tables*/
create table note(note_id int,note_title varchar(20),note_content varchar(80),note_status varchar(80),note_creation_date date);
create table users(user_id int, user_name varchar(20), user_added_date date, user_password varchar(80), user_mobile long);
create table category(category_id int, category_name varchar(20), category_descr varchar(80), category_creation_date date, category_creator varchar(80));
create table reminder(reminder_id int, reminder_name varchar(20), reminder_descr varchar(80), reminder_type varchar(80), reminder_creation_date date, reminder_creator varchar(20));
create table usernote(usernote_id int, user_id int, note_id int);
create table notecategory(notecategory_id int, note_id int, category_id int);
create table notereminder(notereminder_id int, note_id int, reminder_id int);
/*inserting into tables*/

insert into users values(1, 'adi', '1995-12-12', 'venna', '123659633');
insert into users values(2, 'siri', '1996-11-04', 'yasa', '2438247');
insert into users values(3, 'amith', '1991-10-2', 'ravula', '9856321');

insert into note values(1, 'Note1', 'Note1-content', 'Inprogress', '2021-01-03');
insert into note values(2, 'Note2', 'Note2-content', 'Inactive', '2021-02-13');
insert into note values(3, 'Note3', 'Note3-content', 'active', '2021-03-05');
insert into note values(4, 'Note4', 'Note4-content', 'active', '2021-03-17');

insert into category values(1,'Category1', 'Category1-desc', '2020-01-06','creater1');
insert into category values(2,'Category2', 'Category2-desc', '2021-02-17','creater2');
insert into category values(3,'Category3', 'Category3-desc', '2021-02-25','creater3');
insert into category values(4,'Category4', 'Category4-desc', '2021-03-02','creater4');

insert into reminder values(1,'rem1', 'rem1-desc', 'erveryday', '2020-12-18', 'reminder1');
insert into reminder values(2,'rem2', 'rem2-desc', 'oneday', '2020-12-31', 'reminder2');
insert into reminder values(3,'rem3', 'rem3-desc', 'erveryday', '2021-01-26', 'reminder3');
insert into reminder values(4,'rem4', 'rem4-desc', 'oneday', '2021-02-14', 'reminder4');

insert into usernote values(1,1,1);
insert into usernote values(2,2,2);
insert into usernote values(3,3,3);

insert into notecategory values(1,1,1);
insert into notecategory values(2,2,2);
insert into notecategory values(3,3,3);
insert into notecategory values(4,4,4);

insert into notereminder values(1,1,1);
insert into notereminder values(2,2,2);
insert into notereminder values(3,3,3);
insert into notereminder values(4,4,4);

/*Fetch the row from User table based on Id and Password.*/
select * from Users where user_id=1 and user_password='venna';
/*Fetch all the rows from Note table based on the field note_creation_date */
select * from note where note_creation_date='2021-03-05';
/*Fetch all the Categories created after the particular Date.*/
select * from category where category_creation_date>'2021-02-17';
/*Fetch all the Note ID from UserNote table for a given User.*/
select note_id from Usernote where user_id=2;
/*Write Update query to modify particular Note for the given note Id.*/
update note  set  note_title='upnote2',note_content='upnote2-content' where note_id=2;
select * from note;
/*Fetch the reminder details for a given reminder id.*/
select * from reminder where reminder_id=3;

/*Fetch all the Notes from the Note table by a particular User*/
    /*1-way*/
select note.note_id,note.note_title,note.note_content,note.note_status,note.note_creation_date from  note INNER JOIN  usernote on note.note_id=usernote.user_id where note.note_id=2;
    /*2-way*/
select * from note where note_id =(select user_id from usernote where note_id=2);

/*Fetch all the Notes from the Note table for a particular Category.*/
select * from note where note_id =(select note_id from notecategory where category_id=2);
/*select * from note where note_id =(select notecategory_id from notecategory where note_id=2);*/
 
 /*Fetch all the reminder details for a given note id.*/
 select * from reminder where reminder_id=(select reminder_id from notereminder where note_id=2);
 
/*Write a query to create a new Note from particular User (Use Note and UserNote tables - insert statement).*/
INSERT INTO note VALUES(5,'Note5', 'Note5-content','active','2021-3-18');
INSERT INTO usernote VALUES(5,5,5);

 /*Write a query to create a new Note from particular User to particular Category(Use Note and NoteCategory tables - insert statement)*/
INSERT INTO note VALUES(6,'Note6', 'Note6-content','inactive' , '2021-3-19');
INSERT INTO notecategory VALUES(5,5,5);

/*Write a query to set a reminder for a particular note (Use Reminder and NoteReminder tables - insert statement)*/
INSERT INTO reminder VALUES(5,'rem5', 'rem5-desc', 'everyday', '2021-03-14', 'reminder5');
INSERT INTO notereminder VALUES(5,5,5);

/*Write a query to delete particular Note added by a User(Note and UserNote tables - delete statement)*/
DELETE FROM users,usernote USING users INNER JOIN usernote on (users.user_id = usernote.user_id) WHERE users.user_id=2;

/*Write a query to delete particular Note from particular Category(Note and NoteCategory tables - delete statement)*/
DELETE FROM note,notecategory USING note INNER JOIN notecategory on (note.note_id = notecategory.note_id) WHERE note.note_id=2;

/*Create a trigger to delete all matching records from UserNote, NoteReminder and NoteCategory table when :
1. A particular note is deleted from Note table (all the matching records from UserNote, NoteReminder and NoteCategory should be removed automatically)*/
      delimiter //
      CREATE TRIGGER note_delete_trigger 
	  BEFORE DELETE on note 
      FOR EACH ROW 
      Begin
      DELETE FROM notecategory WHERE note_id = OLD.note_id;
      DELETE FROM usernote WHERE note_id = OLD.note_id;
      DELETE FROM notereminder WHERE note_id = OLD.note_id;
      end; //
      delimiter ;
      
      delete from note where note_id=3;
  
/*2. A particular user is deleted from User table (all the matching notes should be removed automatically)*/
      delimiter //
      CREATE TRIGGER user_delete_trigger 
      BEFORE DELETE on User 
      FOR EACH ROW 
      Begin
      DELETE FROM notecategory WHERE note_id = OLD.users_id;
      DELETE from notereminder where note_id = OLD.users_id;
      DELETE from usernote where note_id = OLD.users_id;
      end; //
      delimiter ;
      
      delete from users where user_id=1;
