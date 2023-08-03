create table notes (
    id integer primary key autoincrement, 
    title varchar (200),
    note varchar(2500), 
    mood int,
    successcount int,
    created_time date,
    updated_time date
    )