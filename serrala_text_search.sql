-- prompt  > Create a single Oracle Text index on the contents of multiple tables.
-- prompt  > This example uses a USER_DATASTORE to create virtual documents "on the fly" for indexing

-- prompt  > user running this example must have CTX_APP role and CREATE ANY DIRECTORY priv

-- prompt  > We have 3 tables:
-- prompt  >   A has tow VARCHAR2 column : name and description
-- prompt  >   B has tow VARCHAR2 column : name and description
-- prompt  >   C has tow VARCHAR2 column : name and description

drop table A;
drop table B;
drop table C;

create table A
(
  id              number primary key,
  COL_NAME        varchar2(2000),
  COL_DESCRIPTION varchar2(2000)
);
create table B
(
  id              number primary key,
  COL_NAME        varchar2(2000),
  COL_DESCRIPTION varchar2(2000)
);
create table C
(
  id              number primary key,
  COL_NAME        varchar2(2000),
  COL_DESCRIPTION varchar2(2000)
);


-- prompt  > need a directory only for BFILENAME. Make sure this directory exists and contains

insert into A values (1, 'john smith', ' john smith description');
insert into B values (1, 'fred bloggs', 'fred bloggs description');
insert into C values (1, 'john doe', 'john doe description');

drop table text;

create table text
(
  id       number,
  tab_id   varchar2(30),
  dummy    char(1)
)
/

-- prompt  > Create the text table with one row per donor table
-- prompt  > We will just have a 'X' in the dummy column

insert into text (  select id, 'A', 'X'  from A);
insert into text (  select id, 'B', 'X'  from B);
insert into text (  select id, 'C', 'X'  from C);

-- prompt  > Now create a user datastore which will fetch all the relevant data for indexing

begin
  ctx_ddl.drop_preference('serrala_pro_uds');
end;
begin
  ctx_ddl.create_preference('serrala_pro_uds', 'user_datastore');
end;

begin
  ctx_ddl.set_attribute('serrala_pro_uds', 'procedure', 'serrala_ds_procedure');
end;

-- prompt  > A simple policy is needed to process the binary documents in the user datastore

begin
  ctx_ddl.create_policy('serrala_pol', 'ctxsys.auto_filter');
end;

-- prompt  > Create the actual user datastore procedure

create or replace procedure serrala_ds_procedure(rid in rowid,
                                                      tlob in out NOCOPY clob) is

  v_id number;
  v_tab_id varchar2(30);

begin
  -- We need to find out where this row comes from
  select id,
         tab_id
         into v_id, v_tab_id
  from text
  where rowid = rid;

  case v_tab_id
    when 'A' then

      -- For A we use a simple join to fetch data from B, using the ID we get from text
      select '<name>' || COL_NAME || '</name><description>' || COL_DESCRIPTION || '</description>' into tlob
      from A,
           text tt
      where tt.rowid = rid
        and A.id = tt.id;

    when 'B' then

      -- For B we have a varchar column. The same technique as A will work.

      select '<name>' || COL_NAME || '</name><description>' || COL_DESCRIPTION || '</description>' into tlob
      from B,
           text tt
      where tt.rowid = rid
        and B.id = tt.id;


    when 'C' then

      -- For B we have a varchar column. The same technique as A will work.

      select '<name>' || COL_NAME || '</name><description>' || COL_DESCRIPTION || '</description>' into tlob
      from C,
           text tt
      where tt.rowid = rid
        and C.id = tt.id;

    end case;

end;
/
-- list
-- show errors

-- prompt  > AUTO_SECTION_GROUP will automatically identify all sections created by user datastore (one per column)
-- prompt  > for better performance we could explicitly define field sections for each column
-- prompt  > the create index statement

begin
  ctx_ddl.drop_section_group('serrala_pro_sg');
end;
begin
  ctx_ddl.create_section_group('serrala_pro_sg', 'auto_section_group');
end;

-- Following not allowed with AUTO_SECTION_GROUP. Could use it with BASIC_ or HTML_SECTION_GROUP
-- exec ctx_ddl.add_sdata_section(  'serrala_pro_sg', 'COL_NAME', 'COL_DESCRIPTION', 'NUMBER' );

-- prompt  > Create the triggers which keep the main table updated.
-- prompt  > We need an insert and update trigger for each table

-- prompt  > Insert Triggers
-- prompt  > these just insert the ID and tab identifier, and 'X' into the dummy column
-- prompt  > the user datastore will automatically pick up the actual data for indexing

create or replace trigger serrala_pro_trig1i_uds
  after insert
  on A
  for each row
begin
  insert into text
  values (:new.id, 'A', 'X');
end;
/
create or replace trigger serrala_pro_trig2i_uds
  after insert
  on B
  for each row
begin
  insert into text
  values (:new.id, 'B', 'X');
end;
/
create or replace trigger serrala_pro_trig3i_uds
  after insert
  on C
  for each row
begin
  insert into text
  values (:new.id, 'C', 'X');
end;
/

-- prompt  > Update Triggers:

--  WARNING: we assume "ID" never changes. If this is not the case, alter the trigger appropriately

create or replace trigger serrala_pro_trig1u_uds
  after update
  on A
  for each row
begin
  if :new.COL_NAME != :old.COL_NAME then
    update text tt
    set dummy = dummy
    where tt.id = :new.id
      and tab_id = 'A';
  end if;
  if :new.COL_DESCRIPTION != :old.COL_DESCRIPTION then
    update text tt
    set dummy = dummy
    where tt.id = :new.id
      and tab_id = 'A';
  end if;
end;
/
create or replace trigger serrala_pro_trig2u_uds
  after update
  on B
  for each row
begin
  if :new.COL_NAME != :old.COL_NAME then
    update text tt
    set dummy = dummy
    where tt.id = :new.id
      and tab_id = 'B';
  end if;
  --  column D is a CLOB
  if dbms_lob.compare(:new.COL_DESCRIPTION, :old.COL_DESCRIPTION) != 0 then
    update text tt
    set dummy = dummy
    where tt.id = :new.id
      and tab_id = 'B';
  end if;
end;
/
create or replace trigger serrala_pro_trig3u_uds
  after update
  on C
  for each row
begin
  if :new.COL_NAME != :old.COL_NAME then
    update text tt
    set dummy = dummy
    where tt.id = :new.id
      and tab_id = 'C';
  end if;
  if dbms_lob.compare(:new.COL_DESCRIPTION, :old.COL_DESCRIPTION) != 0 then
    update text tt
    set dummy = dummy
    where tt.id = :new.id
      and tab_id = 'C';
  end if;
end;
/

-- prompt  > Now we can create the index (at last)
-- prompt  > It makes no difference which column we create the index on,
-- prompt  > we could have included a "dummy" column for this purpose if we wanted

-- prompt  > drop index text_index (don't need this if we've dropped the table)

create index text_index on text (dummy)
  indextype is ctxsys.context
  parameters ( 'datastore serrala_pro_uds section group serrala_pro_sg' )
/

-- prompt  > Check for any filtering or datastore errors

select * from ctx_user_index_errors;

-- prompt  > Try some queries

select id, tab_id
from text
where contains(dummy, 'john') > 0;
select id, tab_id
from text
where contains(dummy, 'john within col_name') > 0;
select id, tab_id
from text
where contains(dummy, 'document within col_name') > 0;

-- prompt  > Add some new data

insert into A values (3, 'Andrew johnson', 3);

-- prompt  > Sync the index

begin
  ctx_ddl.sync_index('text_index');
end;

-- prompt  > Search for the new data

select id, tab_id
from text
where contains(dummy, 'andrew') > 0;

-- prompt  > Update the name column in table B

update B
set COL_NAME = 'fred johnson';

-- prompt  > Sync the index

begin
  ctx_ddl.sync_index('text_index');
end;

-- prompt  > Search for the new data

select (ROWIDTOCHAR(ROWID)) AS r,id, tab_id
from text
where contains(dummy, 'johnson within name') > 0 ;


-- prompt  > Search for the new data , select in text table and call procedure, return result list.

create  function FUNC_SEARCH (TABLE_ID IN VARCHAR2,SEARCH_TERM IN VARCHAR2) RETURN CLOB
as
  V_ROWID   VARCHAR2 (250);
  V_ID      NUMBER (20);
  V_TLOB CLOB :=NULL;
  CURSOR C_ROWID IS
    SELECT (ROWIDTOCHAR (ROWID)) AS R, ID
    FROM TEXT
    WHERE     CONTAINS (DUMMY, SEARCH_TERM) > 0
      AND TAB_ID = TABLE_ID;
BEGIN
  OPEN C_ROWID;

  LOOP
    FETCH C_ROWID INTO V_ROWID,V_ID;

    EXIT WHEN C_ROWID%NOTFOUND;

    BEGIN

      SERRALA_DS_PROCEDURE ( V_ROWID,V_TLOB);
      return V_TLOB;

    END;
  END LOOP;

  CLOSE C_ROWID;
END FUNC_SEARCH;
/
