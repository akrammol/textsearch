# text search

This application was generated with : java 8 , hibernate 5 , oracle 12c

It's well known that Oracle Text indexes perform best when all the data to be indexed is combined into a single index.
For Indexing data from multiple tables with Oracle Text, Oracle Text provides the MULTI_COLUMN_DATASTORE which will combine
data from multiple columns into a single index.
Effectively, it constructs a "virtual document" at indexing time, which might look something like:

<title>the big dog</title>

<body>the ginger cat smiles</body>

This virtual document can be indexed using either AUTO_SECTION_GROUP, or by explicitly defining sections for title and body, allowing
the query as expressed above. Note that we've used a column called "text" - this might have been a dummy column added to the table 
simply to allow us to create an index on it 
- or we could created the index on either of the "real" columns - title or body.

Create our own "virtual" documents using the USER_DATASTORE.
The user datastore allows us to specify a PL/SQL procedure which will be used to fetch the data to be indexed, returned in a CLOB,
or occasionally in a BLOB or VARCHAR2. This PL/SQL procedure is called once for each row in the table to be indexed, and is passed 
the ROWID value of the current row being indexed. The actual contents of the procedure is entirely up to the owner, but it is normal
to fetch data from one or more columns from database tables..

This application create a single Oracle Text index on the contents of multiple tables.
This example uses a USER_DATASTORE to create virtual documents "on the fly" for indexing
                 
****user running this example must have CTX_APP role and CREATE ANY DIRECTORY privacy****

you can search the word with this pattern , use % :
*searchterm  --> %searchterm
searchterm*  --> searchterm%
*searchterm* --> %searchterm%
search??term --> search%term

after update or insert new column in each table please sync the index:
-- prompt  > Sync the index
begin
  ctx_ddl.sync_index('text_index');
end;

## Development

To start your application , simply run main of App.

## Building for production

****At the first, please run the SQL file in root of the project, and read the comments of SQL file(serrala_text_search.sql).****
****Please change hibernate connection properties in hibernate.cfg.xml file (url, username, password, schema).****
 
### Packaging as jar

To build the final jar and optimize the textsearch application for production, run this command:

    ./mvn clean install

To ensure everything worked, run:

    java -jar target/*.jar
or

    java -jar textsearch-1.0-SNAPSHOTS.jar 

### Packaging as war

To package your application as a war in order to deploy it to an application server, run:

    ./mvn -Pprod,war clean verify



