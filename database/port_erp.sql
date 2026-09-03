create database port_erp;
use port_erp;

drop database port_erp;

--------------------------------------------------- TABLES ---------------------------------------------------

-- ROLE TABLE
create table role(
    role_id int primary key auto_increment,
    role_name enum('Administrator', 'Port Manager', 'Ship Operator', 'Dock Manager', 'Cargo Handler') not null
);

-- USER TABLE
create table user(
	user_id int primary key auto_increment,
    name varchar(100) not null,
    email varchar(100) unique not null,
    password varchar(255) not null,
    status enum('Active', 'Inactive'),
	role_id int null,
    foreign key(role_id) references role(role_id) on delete set null
);

-- SHIP TABLE
create table ship(
	ship_id int primary key auto_increment,
	ship_name varchar(100) not null,
	arrival_date datetime not null,
	departure_date datetime not null,
	status enum('Anchored', 'Docked', 'Departed'),
	operator_id int null,
	foreign key (operator_id) references user(user_id) on delete set null
);

-- DOCK TABLE
create table dock (
    dock_id int auto_increment primary key,
    dock_name varchar(50) not null,
    status enum('Available','Occupied','Under Maintenance')
);

-- DOCK ALLOCATION TABLE
create table dock_allocation(
	allocation_id int primary key auto_increment,
	ship_id int,
    foreign key(ship_id) references ship(ship_id) on delete cascade,
	dock_id int,
    foreign key(dock_id) references dock(dock_id) on delete cascade,
    allocation_time datetime not null,
    release_time datetime null
);

-- CONTAINER TABLE
create table container(
	container_id int primary key auto_increment, 
	container_type enum('Dry', 'Reefer', 'Open Top', 'Tank'),
	status enum('Loaded','Empty','In Transit'),
	ship_id int,
	foreign key (ship_id) references ship(ship_id) on delete cascade
);

-- CARGO TABLE
create table cargo(
    cargo_id int primary key auto_increment,
    container_id int,
    foreign key(container_id) references container(container_id) on delete cascade,
    description varchar(200) not null,
    weight decimal(10,2) not null,
    status enum('Loaded','Unloaded','In Transit')
);

-- CARGO MOVEMENT TABLE
create table cargo_movement(
    movement_id int primary key auto_increment,
    cargo_id int,
    foreign key(cargo_id) references cargo(cargo_id) on delete cascade,
    movement_type enum('Load','Unload','Transfer'),
    movement_date datetime not null,
    handled_by int null,
    foreign key(handled_by) references user(user_id) on delete set null
);

-- SECURITY LOG TABLE
create table security_log(
	log_id int primary key auto_increment,
	user_id int null,
	foreign key(user_id) references user(user_id) on delete set null,
	entry_time datetime not null,
	exit_time datetime
);

--------------------------------------------------- LOGIC ---------------------------------------------------

----------------- ROLE -----------------
-- ADD ROLE PROCEDURE
delimiter &&
create procedure add_role(
    in current_role_name varchar(50),
    in new_role_name varchar(50)
)
begin
    declare enum_list text;
    if current_role_name = 'Administrator' then
        select column_type into enum_list from information_schema.columns where table_name = 'role' and column_name = 'role_name';
        if enum_list not like concat('%', new_role_name, '%') then
            set @sql = concat('alter table role modify role_name enum(',replace(replace(enum_list, 'enum(', ''), ')', ''),',', '"', new_role_name, '"',')');
            prepare stmt from @sql;
            execute stmt;
            deallocate prepare stmt;
        end if;
        insert into role (role_name) values (new_role_name);
    else
        signal sqlstate '45000' set message_text = 'Only Admin Can Add Roles';
    end if;
end &&
delimiter ;

-- UPDATE ROLE NAME PROCEDURE
delimiter &&
create procedure update_role_name(
    in current_role_name varchar(50),
    in given_role_id int,
    in new_role_name varchar(50)
)
begin
    declare enum_list text;
    if current_role_name = 'Administrator' then
        select column_type into enum_list from information_schema.columns where table_name = 'role' and column_name = 'role_name';
        if enum_list not like concat('%', new_role_name, '%') then
            set @sql = concat('alter table role modify role_name enum(',replace(replace(enum_list, 'enum(', ''), ')', ''),',', '"', new_role_name, '"',')');
            prepare stmt from @sql;
            execute stmt;
            deallocate prepare stmt;
        end if;
        update role set role_name = new_role_name where role_id = given_role_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admin Can Update Roles';
    end if;
end &&
delimiter ;

-- DELETE ROLE PROCEDURE
delimiter &&
create procedure delete_role(
    in current_role_name varchar(50),
    in delete_role_id int
)
begin
    declare new_enum text;
    if current_role_name = 'Administrator' then
        if not exists (select 1 from role where role_id = delete_role_id) then
            signal sqlstate '45000' set message_text = 'Role ID Not Found';
        else
            delete from role where role_id = delete_role_id;
            select group_concat(distinct concat('"', role_name, '"')) into new_enum from role;
            if new_enum is not null then
                set @sql = concat('alter table role modify role_name enum(',new_enum,')');
                prepare stmt from @sql;
                execute stmt;
                deallocate prepare stmt;
            end if;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin Can Delete Roles';
    end if;
end &&
delimiter ;

-- SHOW ROLE FUNCTION
delimiter &&
create function show_roles(
    current_role_name varchar(50)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name = 'Administrator' then
        select concat('[',ifnull(group_concat(json_object('role_id', role_id,'role_name', role_name)),''),']') into result from role;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin Can View Roles';
    end if;
end &&
delimiter ;
delimiter &&

-- SEARCH ROLE FUNCTION
delimiter &&
create function search_roles(
    current_role_name varchar(50),
    search_keyword varchar(50)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name = 'Administrator' then
        select concat('[',ifnull(group_concat(json_object('role_id', role_id,'role_name', role_name)),''),']') into result from role where role_name like concat('%', search_keyword, '%');
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin Can Search Roles';
    end if;
end &&
delimiter ;


----------------- USER -----------------
-- USER LOGIN PROCEDURE
delimiter &&
create procedure user_login( 
    in given_user_email varchar(100),
    in given_user_password varchar(255)
)
begin
    declare current_user_id int;
    select user_id into current_user_id from user where email = given_user_email and password = sha2(given_user_password, 256) and status = 'Active';

    if current_user_id is null then
        signal sqlstate '45000' set message_text = 'Invalid Login Credentials';
    else
        call user_login_log(current_user_id);
        select "Successfully Logged In...";
    end if;
end && 
delimiter ;

-- USER LOGOUT PROCEDURE
delimiter &&
create procedure user_logout(
    in current_user_id int
)
begin
    declare logout_user_id int;
    select user_id into logout_user_id from user where user_id = current_user_id;

    if logout_user_id is null then
        signal sqlstate '45000' set message_text = 'Invalid User';
    else
        call user_logout_log(current_user_id);
        select "Successfully Logged Out...";
    end if;
end && 
delimiter ;

-- ADD USER PROCEDURE
delimiter &&
create procedure add_user(
	in current_role_name varchar(100),
    in u_name varchar(100),
    in u_email varchar(100),
    in u_password varchar(255),
    in u_role int
)
begin
    if current_role_name = 'Administrator' then
		insert into user (name, email, password, role_id) values (u_name, u_email, sha2(u_password, 256), u_role);
    else
        signal sqlstate '45000' set message_text = 'Only Admins Can Add Users';
    end if;
end &&
delimiter ;

-- USER STATUS ACTIVE TRIGGER
delimiter &&
create trigger user_status_active
before insert on user
for each row
begin
    if new.status is null or new.status not in ('Active','Inactive') then
        set new.status = 'Active';
    end if;
end &&
delimiter ;

-- USER STATUS PROCEDURE
delimiter &&
create procedure set_user_status(
    in current_role_name varchar(100),
    in given_user_id int,
    in new_user_status varchar(10)
)
begin
    if current_role_name = 'Administrator' then
        if new_user_status in ('Active', 'Inactive') then
            update user set status = new_user_status where user_id = given_user_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin Can Change Status';
    end if;
end &&
delimiter ;

-- EDIT USER DETAILS PROCEDURE
delimiter &&
create procedure edit_user_details(
    in current_role_name varchar(100),
    in given_user_id int,
    in new_user_name varchar(100),
    in new_user_email varchar(100),
    in new_user_password varchar(255),
    in new_role_id int
)
begin
    if current_role_name = 'Administrator' then
        update user set name = ifnull(new_user_name, name),email = ifnull(new_user_email, email),password = ifnull(sha2(new_user_password, 256), password),role_id = ifnull(new_role_id, role_id) where user_id = given_user_id;
    elseif current_role_name in ('Port Manager','Ship Operator','Dock Manager','Cargo Handler') then
        if new_role_id is not null then
            signal sqlstate '45000' set message_text = 'Only Admin Can Change Roles';
        else
            update user set name = ifnull(new_user_name, name),email = ifnull(new_user_email, email),password = ifnull(sha2(new_user_password, 256), password) where user_id = given_user_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Invalid Role';
    end if;
end &&
delimiter ;

-- SHOW USERS FUNCTION
delimiter &&
create function show_users(
    current_role_name varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name = 'Administrator' then
		select CONCAT('[',GROUP_CONCAT(JSON_OBJECT('user_id', u.user_id,'name', u.name,'email', u.email,'password', u.password,'status', u.status,'role_name', r.role_name)),']') into result from user u join role r on u.role_id = r.role_id;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admins Can View Users';
    end if;
end &&
delimiter ;

-- SEARCH USERS FUNCTION
delimiter &&
create function search_users(
    current_role_name varchar(100),
    search_text varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name = 'Administrator' then
        select concat('[',group_concat(json_object('user_id', u.user_id,'name', u.name,'email', u.email,'password', u.password,'status', u.status,'role_name', r.role_name)),']') into result from user u join role r on u.role_id = r.role_id where u.name like concat('%', search_text, '%') or u.email like concat('%', search_text, '%') or u.status like concat('%', search_text, '%') or r.role_name  like concat('%', search_text, '%');
        if result is null then
            return '[]';
        end if;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admins Can Search Users';
    end if;
end &&
delimiter ;


----------------- SHIP -----------------
-- REGISTER SHIP PROCEDURE
delimiter &&
create procedure register_ship(
    in current_role_name varchar(100),
    in given_ship_name varchar(100),
    in given_ship_arrival_date datetime,
    in given_ship_departure_date datetime,
    in given_ship_operator int
)
begin
    if current_role_name = 'Administrator' or current_role_name = 'Port Manager' or current_role_name = 'Ship Operator' then
        insert into ship (ship_name,arrival_date,departure_date,operator_id) values (given_ship_name,given_ship_arrival_date,given_ship_departure_date,given_ship_operator);
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Ship Operator Can Register Ships';
    end if;
end &&
delimiter ;

-- SHIP STATUS ANCHORED TRIGGER
delimiter &&
create trigger ship_status_anchored
before insert on ship
for each row
begin
    if new.status is null or new.status not in ('Anchored','Docked','Departed') then
        set new.status = 'Anchored';
    end if;
end &&
delimiter ;

-- SHIP STATUS PROCEDURE
delimiter &&
create procedure set_ship_status(
    in current_role_name varchar(100),
    in given_ship_id int,
    in new_ship_status varchar(20)
)
begin
    if current_role_name in ('Administrator','Port Manager','Ship Operator') then
        if new_ship_status in ('Anchored','Docked','Departed') then
            update ship set status = new_ship_status where ship_id = given_ship_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Ship Operator Can Update Ship Status';
    end if;
end &&
delimiter ;

-- EDIT SHIP DETAILS PROCEDURE
delimiter &&
create procedure edit_ship_details(
    in current_role_name varchar(100),
    in given_ship_id int,
    in new_ship_name varchar(100),
    in new_arrival_date datetime,
    in new_departure_date datetime,
    in new_operator_id int
)
begin
    if current_role_name in ('Administrator','Port Manager','Ship Operator') then
        update ship set ship_name = ifnull(new_ship_name, ship_name),arrival_date = ifnull(new_arrival_date, arrival_date),departure_date = ifnull(new_departure_date, departure_date),operator_id = ifnull(new_operator_id, operator_id) where ship_id = given_ship_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Ship Operator Can Edit Ship';
    end if;
end &&
delimiter ;

-- DELETE SHIP PROCEDURE
delimiter &&
create procedure delete_ship(
    in current_role_name varchar(100),
    in delete_ship_id int
)
begin
    if current_role_name = 'Administrator' or current_role_name = 'Port Manager' or current_role_name = 'Ship Operator' then
        if not exists (select 1 from ship where ship_id = delete_ship_id) then 
            signal sqlstate '45000' set message_text = 'Ship ID Not Found';
        else
            delete from ship where ship_id = delete_ship_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Edit Ship Operator';
    end if;
end &&
delimiter ;

-- SHOW SHIP FUNCTION
delimiter &&
create function show_ships(
    current_role_name varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name = 'Administrator' or current_role_name = 'Port Manager' or current_role_name = 'Ship Operator' then
		select CONCAT('[',GROUP_CONCAT(JSON_OBJECT('ship_id', s.ship_id,'ship_name', s.ship_name,'arrival_date', s.arrival_date,'departure_date', s.departure_date,'status', s.status,'user_name', u.name,'role_name', r.role_name)),']') into result from ship s join user u on s.operator_id = u.user_id join role r on u.role_id = r.role_id;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Ship Operator, Port Manager Can View Ships';
    end if;
end &&
delimiter ;

-- SEARCH SHIP FUNCTION
delimiter &&
create function search_ships(
    current_role_name varchar(50),
    search_keyword varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Ship Operator','Port Manager') then
        select concat('[',ifnull(group_concat(json_object('ship_id', s.ship_id,'ship_name', s.ship_name,'arrival_date', s.arrival_date,'departure_date', s.departure_date,'status', s.status,'operator_id', s.operator_id,'user_name', u.name,'role_name', r.role_name)),''),']') into result from ship s join user u on s.operator_id = u.user_id join role r on u.role_id = r.role_id where cast(s.ship_id as char) like concat('%', search_keyword, '%') or s.ship_name like concat('%', search_keyword, '%') or cast(s.arrival_date as char) like concat('%', search_keyword, '%') or cast(s.departure_date as char) like concat('%', search_keyword, '%') or s.status like concat('%', search_keyword, '%') or cast(s.operator_id as char) like concat('%', search_keyword, '%') or r.role_name like concat('%', search_keyword, '%');
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Ship Operator, Port Manager Can Search Ships';
    end if;
end &&
delimiter ;


----------------- DOCK -----------------
-- ADD DOCK PROCEDURE
delimiter &&
create procedure add_dock(
    in current_role_name varchar(100),
    in given_dock_name varchar(100)
)
begin
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        insert into dock (dock_name) values (given_dock_name);
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Add Docks';
    end if;
end &&
delimiter ;

-- DOCK STATUS AVAILABLE TRIGGER
delimiter &&
create trigger dock_status_available
before insert on dock
for each row
begin
    if new.status is null or new.status not in ('Available','Occupied','Under Maintenance') then
        set new.status = 'Available';
    end if;
end &&
delimiter ;

-- DOCK STATUS PROCEDURE
delimiter &&
create procedure set_dock_status(
    in current_role_name varchar(100),
    in given_dock_id int,
    in new_dock_status varchar(50)
)
begin
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        if new_dock_status in ('Available','Occupied','Under Maintenance') then
            update dock set status = new_dock_status where dock_id = given_dock_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Update Dock Status';
    end if;
end &&
delimiter ;

-- EDIT DOCK DETAILS PROCEDURE
delimiter &&
create procedure edit_dock_details(
    in current_role_name varchar(100),
    in given_dock_id int,
    in new_dock_name varchar(100)
)
begin
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        update dock set dock_name = ifnull(new_dock_name, dock_name) where dock_id = given_dock_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Edit Dock';
    end if;
end &&
delimiter ;

-- DELETE DOCK PROCEDURE
delimiter &&
create procedure delete_dock(
    in current_role_name varchar(100),
    in delete_dock_id int
)
begin
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        if not exists (select 1 from dock where dock_id = delete_dock_id) then 
            signal sqlstate '45000' set message_text = 'Dock ID Not Found';
        else
            delete from dock where dock_id = delete_dock_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Update Dock Status';
    end if;
end &&
delimiter ;

-- SHOW DOCK FUNCTION
delimiter &&
create function show_docks(
    current_role_name varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        select CONCAT('[',GROUP_CONCAT(JSON_OBJECT('dock_id', d.dock_id,'dock_name', d.dock_name,'status', d.status)),']') into result from dock d;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Update Dock Status';
    end if;
end &&
delimiter ;

-- SEARCH DOCK FUNCTION
delimiter &&
create function search_docks(
    current_role_name varchar(100),
    search_text varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        select CONCAT('[',GROUP_CONCAT(JSON_OBJECT('dock_id', d.dock_id,'dock_name', d.dock_name,'status', d.status)),']') into result from dock d where (search_text is null or d.dock_name like CONCAT('%', search_text, '%') or d.status like CONCAT('%', search_text, '%'));
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Update Dock Status';
    end if;
end &&
delimiter ;


----------------- DOCK ALLOCATION -----------------
-- ADD DOCK ALLOCATION PROCEDURE
delimiter &&
create procedure add_dock_allocation(
    in current_role_name varchar(100),
    in given_ship_id int,
    in given_dock_id int
)
begin
    declare dock_status text;
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        select status into dock_status from dock where dock_id = given_dock_id;
        if dock_status = 'Available' then
            insert into dock_allocation (ship_id,dock_id,allocation_time) values (given_ship_id,given_dock_id,now());
            update dock set status = 'Occupied' where dock_id = given_dock_id;
            update ship set status = 'Docked' where ship_id = given_ship_id;
        else
            signal sqlstate '45000' set message_text = 'Dock Status Not Available';
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Allocate Docks';
    end if;
end &&
delimiter ;

-- UPDATE RELEASE TIME PROCEDURE
delimiter &&
create procedure update_dock_allocation_release_time(
    in current_role_name varchar(100),
    in given_allocation_id int,
    in given_dock_id int,
    in given_ship_id int
)
begin
    declare dock_status text;
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        select status into dock_status from dock where dock_id = given_dock_id;
        if dock_status = 'Occupied' then
            update dock_allocation set release_time = now() where allocation_id = given_allocation_id;
            update dock set status = 'Available' where dock_id = given_dock_id;
            update ship set status = 'Departed' where ship_id = given_ship_id;
        else
            signal sqlstate '45000' set message_text = 'Dock Status Not Occupied';
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Update Release Time Of Allocated Docks';
    end if;
end &&
delimiter ;

-- UPDATE DOCK ALLOCATION DETAILS PROCEDURE
delimiter &&
create procedure update_dock_allocation_details(
    in current_role_name varchar(100),
    in given_allocation_id int,
    in given_ship_id int,
    in given_dock_id int,
    in given_allocation_time datetime
)
begin
    declare old_ship_id int;
    declare old_dock_id int;

    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        select ship_id into old_ship_id from dock_allocation where allocation_id = given_allocation_id;
        select dock_id into old_dock_id from dock_allocation where allocation_id = given_allocation_id;

        update dock_allocation set ship_id = ifnull(given_ship_id, ship_id),dock_id = ifnull(given_dock_id, dock_id),allocation_time = ifnull(given_allocation_time, allocation_time) where allocation_id = given_allocation_id;

        if old_ship_id is not null and old_ship_id <> given_ship_id then update ship set status = 'Anchored' where ship_id = old_ship_id;
        end if;

        if old_dock_id is not null and old_dock_id <> given_dock_id then update dock set status = 'Available' where dock_id = old_dock_id;
        end if;
        update ship set status = 'Docked' where ship_id = given_ship_id;
        update dock set status = 'Occupied' where dock_id = given_dock_id;

    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Update Allocated Docks';
    end if;
end &&
delimiter ;

-- UPDATE ALLOCATED RELEASE TIME PROCEDURE
delimiter &&
create procedure update_allocated_release_time(
    in current_role_name varchar(100),
    in given_allocation_id int,
    in given_release_time datetime
)
begin
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        update dock_allocation set release_time = ifnull(given_release_time, release_time) where allocation_id = given_allocation_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Update Allocated Docks';
    end if;
end &&
delimiter ;

-- DELETE DOCK ALLOCATION PROCEDURE
delimiter &&
create procedure delete_dock_allocation(
    in current_role_name varchar(100),
    in delete_allocation_id int
)
begin
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        if not exists (select 1 from dock_allocation where allocation_id = delete_allocation_id) then 
            signal sqlstate '45000' set message_text = 'Dock Allocation ID Not Found';
        else
            delete from dock_allocation where allocation_id = delete_allocation_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can Delete Allocated Docks';
    end if;
end &&
delimiter ;

-- SHOW DOCK ALLOCATION FUNCTION
delimiter &&
create function show_dock_allocations(
    current_role_name varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        select CONCAT('[',IFNULL(GROUP_CONCAT(JSON_OBJECT('allocation_id', da.allocation_id, 'ship_name', s.ship_name,'dock_name', d.dock_name,'allocation_time', da.allocation_time,'release_time', da.release_time)),''),']') into result from dock_allocation da join ship s on da.ship_id = s.ship_id join dock d on da.dock_id = d.dock_id;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admins, Port Manager, Dock Manager Can View Allocated Docks';
    end if;
end &&
delimiter ;

-- SEARCH DOCK ALLOCATION FUNCTION
delimiter &&
create function search_dock_allocations(
    current_role_name varchar(100),
    search_text varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Dock Manager') then
        select CONCAT('[',IFNULL(GROUP_CONCAT(JSON_OBJECT('allocation_id', da.allocation_id, 'ship_name', s.ship_name,'dock_name', d.dock_name,'allocation_time', da.allocation_time,'release_time', da.release_time)),''),']') into result from dock_allocation da join ship s on da.ship_id = s.ship_id join dock d on da.dock_id = d.dock_id where search_text is null or cast(da.allocation_id as char) like concat('%', search_text, '%') or s.ship_name like concat('%', search_text, '%') or d.dock_name like concat('%', search_text, '%') or cast(da.allocation_time as char) like concat('%', search_text, '%') or cast(da.release_time as char) like concat('%', search_text, '%');
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Dock Manager Can Search Allocated Docks';
    end if;
end &&
delimiter ;


----------------- CONTAINER -----------------
-- ADD CONTAINER PROCEDURE
delimiter &&
create procedure add_container(
    in current_role_name varchar(50),
    in given_container_type varchar(50)
)
begin
    if current_role_name in ('Administrator', 'Ship Operator','Port Manager') then
        insert into container (container_type) values (given_container_type);
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Add Container';
    end if;
end &&
delimiter ;

-- ASSIGN CONTAINER TO SHIP PROCEDURE
delimiter &&
create procedure assign_container_to_ship(
    in current_role_name varchar(50),
    in given_container_id int,
    in new_ship_id int
)
begin
    if current_role_name in ('Administrator', 'Ship Operator','Port Manager') then
        update container set ship_id = new_ship_id where container_id = given_container_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Add Container';
    end if;
end &&
delimiter ;

-- ADD CONTAINER TYPE PROCEDURE
delimiter &&
create procedure add_container_type(
    in current_role_name varchar(50),
    in new_container_type varchar(50)
)
begin
    declare enum_list text;
    if current_role_name in ('Administrator', 'Ship Operator','Port Manager') then
        select column_type into enum_list from information_schema.columns where table_name = 'container' and column_name = 'container_type';
        if enum_list not like concat('%', new_container_type, '%') then
            set @sql = concat('alter table container modify container_type enum(',replace(replace(enum_list, 'enum(', ''), ')',''),',', '"', new_container_type,'"',')');
            prepare stmt from @sql;
            execute stmt;
            deallocate prepare stmt;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Add Container Type';
    end if;
end &&
delimiter ;

-- CONTAINER STATUS EMPTY TRIGGER
delimiter &&
create trigger container_status_empty
before insert on container
for each row
begin
    if new.status is null then
        set new.status = 'Empty';
    end if;
end &&
delimiter ;

-- CONTAINER STATUS PROCEDURE
delimiter &&
create procedure set_container_status(
    in current_role_name varchar(50),
    in given_container_id int,
    in new_container_status varchar(50)
)
begin
    if current_role_name in ('Administrator','Port Manager','Ship Operator') then
        if new_container_status in ('Loaded','Empty','In Transit') then
            update container set status = new_container_status where container_id = given_container_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Update Status';
    end if;
end &&
delimiter ;

-- EDIT CONTAINER DETAILS PROCEDURE
delimiter &&
create procedure edit_container_details(
    in current_role_name varchar(50),
    in given_container_id int,
    in new_container_type varchar(50),
    in new_ship_id int
)
begin
    if current_role_name in ('Administrator','Port Manager','Ship Operator') then
        update container set container_type = new_container_type,ship_id = new_ship_id where container_id = given_container_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Edit Container';
    end if;
end &&
delimiter ;

-- DELETE CONTAINER PROCEDURE
delimiter &&
create procedure delete_container(
    in current_role_name varchar(50),
    in given_container_id int
)
begin
    if current_role_name in ('Administrator','Port Manager','Ship Operator') then
        if not exists (select 1 from container where container_id = given_container_id) then
            signal sqlstate '45000' set message_text = 'Container ID Not Found';
        else
            delete from container where container_id = given_container_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Delete Container';
    end if;
end &&
delimiter ;

-- SHOW CONTAINER FUNCTION
delimiter &&
create function show_containers(
    current_role_name varchar(50)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Ship Operator') then
        select concat('[', group_concat(json_object('container_id', c.container_id,'container_type', c.container_type,'status', c.status,'ship_name', s.ship_name,'ship_status', s.status,'user_name', u.name,'role_name', r.role_name)),']') into result from container c left join ship s on c.ship_id = s.ship_id left join user u on s.operator_id = u.user_id left join role r on u.role_id = r.role_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can View Container';
    end if;

    return result;
end &&
delimiter ;

-- SEARCH CONTAINER FUNCTION
delimiter &&
create function search_containers(
    current_role_name varchar(50),
    search_text varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Ship Operator') then
        select concat('[', group_concat(json_object('container_id', c.container_id,'container_type', c.container_type,'status', c.status,'ship_name', s.ship_name,'ship_status', s.status,'user_name', u.name,'role_name', r.role_name)),']') into result from container c left join ship s on c.ship_id = s.ship_id left join user u on s.operator_id = u.user_id left join role r on u.role_id = r.role_id where c.container_type like concat('%', search_text, '%') or c.status like concat('%', search_text, '%') or s.ship_name like concat('%', search_text, '%') or s.status like concat('%', search_text, '%') or u.name like concat('%', search_text, '%') or r.role_name like concat('%', search_text, '%') or cast(c.container_id as char) like concat('%', search_text, '%');
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Ship Operator, Port Manager Can Search Container';
    end if;
    return result;
end &&
delimiter ;


----------------- CARGO -----------------
-- ADD CARGO PROCEDURE
delimiter &&
create procedure add_cargo(
    in current_role_name varchar(50),
    in given_container_id int,
    in given_cargo_description varchar(200),
    in given_cargo_weight decimal(10,2)
)
begin
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        if given_cargo_weight <= 0 then
            signal sqlstate '45000' set message_text = 'Weight Must Be More Than Zero';
        else
            insert into cargo(container_id,description, weight) values (given_container_id,given_cargo_description, given_cargo_weight);
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can Add Cargo';
    end if;
end &&
delimiter ;

-- CARGO STATUS UNLOADED TRIGGER
delimiter &&
create trigger cargo_status_unloaded
before insert on cargo
for each row
begin
    if new.status is null or new.status not in ('Loaded','Unloaded','In Transit') then
        set new.status = 'Unloaded';
    end if;
end &&
delimiter ;

-- CARGO STATUS PROCEDURE
delimiter &&
create procedure set_cargo_status(
    in current_role_name varchar(50),
    in given_cargo_id int,
    in new_cargo_status varchar(50),
    in given_user_id int
)
begin
	declare last_id int;
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        if new_cargo_status in ('Loaded','Unloaded','In Transit') then
            update cargo set status = new_cargo_status where cargo_id = given_cargo_id;
            SELECT MAX(movement_id) INTO last_id FROM cargo_movement;
            update cargo_movement set handled_by = given_user_id where movement_id = last_id;
        end if;
    else
        signal sqlstate '45000' 
        set message_text = 'Only Admin, Port Manager, Cargo Handler Can Update Cargo Status';
    end if;
end &&
delimiter ;

-- EDIT CARGO DETAILS PROCEDURE
delimiter &&
create procedure edit_cargo_details(
    in current_role_name varchar(50),
    in given_cargo_id int,
    in given_container_id int,
    in new_cargo_weight decimal(10,2),
    in new_cargo_description varchar(200)
)
begin
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        if new_cargo_weight is not null and new_cargo_weight >= 0 then
            update cargo set container_id = ifnull(given_container_id, container_id),weight = ifnull(new_cargo_weight, weight),description = ifnull(new_cargo_description, description) where cargo_id = given_cargo_id;
        else
            signal sqlstate '45000' set message_text = 'Invalid Weight';
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can Update Cargo Details';
    end if;
end &&
delimiter ;

-- DELETE CARGO PROCEDURE
delimiter &&
create procedure delete_cargo(
    in current_role_name varchar(50),
    in given_cargo_id int
)
begin
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        if not exists (select 1 from cargo where cargo_id = given_cargo_id) then 
            signal sqlstate '45000' set message_text = 'Cargo ID Not Found';
        else
            delete from cargo where cargo_id = given_cargo_id;
        end if;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can Delete Cargo';
    end if;
end &&
delimiter ;

-- SHOW CARGO FUNCTION
delimiter &&
create function show_cargo(
    current_role_name varchar(50)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        select concat('[',ifnull(group_concat(json_object('cargo_id', c.cargo_id,'description', c.description,'weight', c.weight,'cargo_status', c.status,'container_type', ct.container_type,'container_status', ct.status,'ship_name', s.ship_name,'ship_status', s.status,'dock_name', d.dock_name,'dock_status', d.status)),''),']') into result from cargo c left join container ct on c.container_id = ct.container_id left join ship s on ct.ship_id = s.ship_id left join dock_allocation da on s.ship_id = da.ship_id left join dock d on da.dock_id = d.dock_id;
        if result is null then
            return '[]';
        end if;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can View Cargo';
    end if;
end &&
delimiter ;

-- SEARCH CARGO FUNCTION
delimiter &&
create function search_cargo(
    current_role_name varchar(50),
    search_text varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        select concat('[',group_concat(json_object('cargo_id', c.cargo_id,'description', c.description,'weight', c.weight,'cargo_status', c.status,'container_type', ct.container_type,'container_status', ct.status,'ship_name', s.ship_name,'ship_status', s.status,'dock_name', d.dock_name,'dock_status', d.status)),']') into result from cargo c left join container ct on c.container_id = ct.container_id left join ship s on ct.ship_id = s.ship_id left join dock_allocation da on s.ship_id = da.ship_id left join dock d on da.dock_id = d.dock_id where c.description like concat('%',search_text,'%') or c.status like concat('%',search_text,'%') or ct.container_type like concat('%',search_text,'%') or ct.status like concat('%',search_text,'%') or s.ship_name like concat('%',search_text,'%') or s.status like concat('%',search_text,'%') or d.dock_name like concat('%',search_text,'%') or d.status like concat('%',search_text,'%');
        if result is null then
            return '[]';
        end if;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can Search Cargo';
    end if;
end &&
delimiter ;

----------------- CARGO MOVEMENT -----------------
-- ADD CARGO MOVEMENT PROCEDURE
delimiter &&
create procedure add_cargo_movement(
    in current_role_name varchar(50),
    in given_cargo_id int,
    in given_movement_type varchar(50),
    in given_user_id int
)
begin
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        if given_movement_type in ('Load','Unload','Transfer') then
            insert into cargo_movement(cargo_id,movement_type,movement_date,handled_by) values (given_cargo_id, given_movement_type, now(), given_user_id);
        end if;
    else
        signal sqlstate '45000' set message_text =  'Only Admin, Port Manager, Cargo Handler Can Add Cargo Movement';
    end if;
end &&
delimiter ;

-- UPDATE CARGO MOVEMENT STATUS TRIGGER
delimiter &&
create trigger update_cargo_movement_status
after update on cargo
for each row
begin
    if old.status <> new.status then
        insert into cargo_movement(cargo_id,movement_type,movement_date) values(new.cargo_id,case when new.status = 'Loaded' then 'Load' when new.status = 'Unloaded' then 'Unload' when new.status = 'In Transit' then 'Transfer' end, now());
    end if;
end &&
delimiter ;

-- DELETE CARGO MOVEMENT TRIGGER
delimiter &&
create trigger delete_cargo_movement
after delete on cargo
for each row
begin 
    delete from cargo_movement where cargo_id = old.cargo_id;
end &&
delimiter ;

-- UPDATE CARGO MOVEMENT DETAILS PROCEDURE
delimiter &&
create procedure update_cargo_movement_details(
    in current_role_name varchar(50),
    in given_movement_id int,
    in given_cargo_id int,
    in new_movement_date datetime,
    in new_handled_by varchar(50)
)
begin
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        update cargo_movement set movement_date = new_movement_date,handled_by = new_handled_by,cargo_id = given_cargo_id where movement_id = given_movement_id;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can Update Cargo Movement';
    end if;
end &&
delimiter ;

-- VIEW CARGO MOVEMENT FUNCTION
delimiter &&
create function view_cargo_movement(
    current_role_name varchar(50)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        select concat('[',group_concat(json_object('movement_id', m.movement_id,'movement_type', m.movement_type,'movement_date', m.movement_date,'handled_by', u.name,'cargo_description', c.description,'cargo_status', c.status)),']') into result from cargo_movement m join cargo c on m.cargo_id = c.cargo_id left join user u on m.handled_by = u.user_id;
        if result is null then
            return '[]';
        end if;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can View Cargo Movement';
    end if;
end &&
delimiter ;

-- SEARCH CARGO MOVEMENT FUNCTION
delimiter &&
create function search_cargo_movement(
    current_role_name varchar(50),
    search_text varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager','Cargo Handler') then
        select concat('[',group_concat(json_object('movement_id', m.movement_id,'movement_type', m.movement_type,'movement_date', m.movement_date,'handled_by', u.name,'cargo_description', c.description,'cargo_status', c.status)),']') into result from cargo_movement m join cargo c on m.cargo_id = c.cargo_id left join user u on m.handled_by = u.user_id where m.movement_type like concat('%',search_text,'%') or c.description like concat('%',search_text,'%') or c.status like concat('%',search_text,'%') or u.name like concat('%',search_text,'%');
        if result is null then
            return '[]';
        end if;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager, Cargo Handler Can Search Cargo Movement';
    end if;
end &&
delimiter ;


----------------- SECURITY LOG -----------------
-- SECURITY LOGIN PROCEDURE 
delimiter &&
create procedure user_login_log( 
    in given_user_id int
)
begin
    insert into security_log(user_id, entry_time) values(given_user_id, now());
end && 
delimiter ; 

-- SECURITY LOGOUT PROCEDURE 
delimiter &&
create procedure user_logout_log( 
    in given_user_id int
)
begin
    update security_log set exit_time = now() where user_id = given_user_id and exit_time is null;
end && 
delimiter ;

-- VIEW SECURITY LOG FUNCTION
delimiter &&
create function view_security_log(
    current_role_name varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager') then
        select CONCAT('[',IFNULL(GROUP_CONCAT(JSON_OBJECT('log_id', sl.log_id,'user_id', sl.user_id,'entry_time', sl.entry_time,'exit_time', sl.exit_time)),''),']') into result from security_log sl;
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager Can View Security Log';
    end if;
end &&
delimiter ;

-- SEARCH SECURITY LOG FUNCTION
delimiter &&
create function search_security_log(
    current_role_name varchar(100),
    search_text varchar(100)
)
returns text
deterministic
begin
    declare result text;
    if current_role_name in ('Administrator','Port Manager') then        
        select CONCAT('[',IFNULL(GROUP_CONCAT(JSON_OBJECT('log_id', sl.log_id,'user_id', sl.user_id,'entry_time', sl.entry_time,'exit_time', sl.exit_time)),''),']') into result from security_log sl where search_text is null or cast(sl.log_id as char) like concat('%', search_text, '%') or cast(sl.user_id as char) like concat('%', search_text, '%') or cast(sl.entry_time as char) like concat('%', search_text, '%') or cast(sl.exit_time as char) like concat('%', search_text, '%');
        return result;
    else
        signal sqlstate '45000' set message_text = 'Only Admin, Port Manager Can Search Security Log';
    end if;
end &&
delimiter ;


-- =========================================================
-- Run these commands to get the data
-- =========================================================


-- =========================================================
-- 1. ROLES
-- =========================================================

INSERT INTO role (role_name) VALUES
('Administrator'),
('Port Manager'),
('Ship Operator'),
('Dock Manager'),
('Cargo Handler');


-- =========================================================
-- 2. USERS - 10 USERS
-- =========================================================

INSERT INTO user (name, email, password, status, role_id) VALUES
('Admin User', 'admin@porterp.com', SHA2('admin123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Administrator')),

('Rajesh Sharma', 'rajesh@porterp.com', SHA2('raj123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Port Manager')),

('Amit Patel', 'amit@porterp.com', SHA2('amit123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Ship Operator')),

('Vikram Singh', 'vikram@porterp.com', SHA2('vikram123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Ship Operator')),

('Neha Joshi', 'neha@porterp.com', SHA2('neha123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Dock Manager')),

('Priya Mehta', 'priya@porterp.com', SHA2('priya123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Cargo Handler')),

('Rohit Verma', 'rohit@porterp.com', SHA2('rohit123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Cargo Handler')),

('Karan Shah', 'karan@porterp.com', SHA2('karan123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Port Manager')),

('Anjali Gupta', 'anjali@porterp.com', SHA2('anjali123',256), 'Inactive',
    (SELECT role_id FROM role WHERE role_name='Dock Manager')),

('Suresh Kumar', 'suresh@porterp.com', SHA2('suresh123',256), 'Active',
    (SELECT role_id FROM role WHERE role_name='Cargo Handler'));


-- =========================================================
-- 3. SHIPS - 10 SHIPS
-- =========================================================

INSERT INTO ship
(ship_name, arrival_date, departure_date, status, operator_id)
VALUES

('MV Ocean Star', '2026-09-01 08:00:00',
 '2026-09-02 18:00:00', 'Departed', 3),

('MV Sea Pearl', '2026-09-03 09:30:00',
 '2026-09-05 20:00:00', 'Docked', 4),

('MV Blue Horizon', '2026-09-04 07:00:00',
 '2026-09-06 19:00:00', 'Docked', 3),

('MV Eastern Wind', '2026-09-05 10:00:00',
 '2026-09-07 18:30:00', 'Anchored', 4),

('MV Golden Wave', '2026-09-06 11:30:00',
 '2026-09-08 21:00:00', 'Anchored', 3),

('MV Pacific Queen', '2026-09-07 06:30:00',
 '2026-09-09 17:00:00', 'Docked', 4),

('MV Indian Ocean', '2026-09-08 12:00:00',
 '2026-09-10 22:00:00', 'Anchored', 3),

('MV Cargo Express', '2026-09-09 08:45:00',
 '2026-09-11 20:30:00', 'Anchored', 4),

('MV Neptune', '2026-09-10 09:15:00',
 '2026-09-12 19:30:00', 'Anchored', 3),

('MV Royal Merchant', '2026-09-11 13:00:00',
 '2026-09-13 21:30:00', 'Anchored', 4);


-- =========================================================
-- 4. DOCKS - 10 DOCKS
-- =========================================================

INSERT INTO dock (dock_name, status) VALUES
('Dock A1', 'Occupied'),
('Dock A2', 'Occupied'),
('Dock A3', 'Available'),
('Dock A4', 'Available'),
('Dock B1', 'Occupied'),
('Dock B2', 'Available'),
('Dock B3', 'Under Maintenance'),
('Dock C1', 'Occupied'),
('Dock C2', 'Available'),
('Dock C3', 'Occupied');


-- =========================================================
-- 5. CONTAINERS - 10 CONTAINERS
-- =========================================================

INSERT INTO container (container_type, status, ship_id) VALUES
('Dry', 'Loaded', 1),
('Reefer', 'Loaded', 2),
('Dry', 'In Transit', 3),
('Open Top', 'Empty', 4),
('Tank', 'Loaded', 5),
('Dry', 'Loaded', 6),
('Reefer', 'In Transit', 7),
('Open Top', 'Empty', 8),
('Dry', 'Loaded', 9),
('Tank', 'In Transit', 10);


-- =========================================================
-- 6. CARGO - 10 CARGO RECORDS
-- =========================================================

INSERT INTO cargo
(container_id, description, weight, status)
VALUES
(1, 'Electronic Components', 12500.50, 'Loaded'),
(2, 'Frozen Food Products', 18750.00, 'Loaded'),
(3, 'Automobile Spare Parts', 9800.75, 'In Transit'),
(4, 'Construction Equipment', 22000.00, 'Unloaded'),
(5, 'Industrial Chemicals', 15600.25, 'Loaded'),
(6, 'Textile Products', 8400.50, 'Loaded'),
(7, 'Frozen Seafood', 13250.00, 'In Transit'),
(8, 'Steel Machinery Parts', 19500.75, 'Unloaded'),
(9, 'Consumer Electronics', 11200.00, 'Loaded'),
(10, 'Petroleum Products', 25000.00, 'In Transit');


-- =========================================================
-- 7. DOCK ALLOCATIONS - 10 RECORDS
-- =========================================================

INSERT INTO dock_allocation
(ship_id, dock_id, allocation_time, release_time)
VALUES

(1, 1, '2026-09-01 09:00:00', '2026-09-02 17:00:00'),

(2, 2, '2026-09-03 10:00:00', NULL),

(3, 5, '2026-09-04 08:00:00', NULL),

(4, 3, '2026-09-05 11:00:00', NULL),

(5, 4, '2026-09-06 12:00:00', NULL),

(6, 8, '2026-09-07 07:30:00', NULL),

(7, 6, '2026-09-08 13:00:00', NULL),

(8, 9, '2026-09-09 09:30:00', NULL),

(9, 10, '2026-09-10 10:00:00', NULL),

(10, 1, '2026-09-11 14:00:00', NULL);


-- =========================================================
-- 8. CARGO MOVEMENTS - 10 RECORDS
-- =========================================================

INSERT INTO cargo_movement
(cargo_id, movement_type, movement_date, handled_by)
VALUES

(1, 'Load', '2026-09-01 10:00:00', 6),

(2, 'Load', '2026-09-03 12:30:00', 7),

(3, 'Transfer', '2026-09-04 14:00:00', 6),

(4, 'Unload', '2026-09-05 15:00:00', 7),

(5, 'Load', '2026-09-06 13:00:00', 10),

(6, 'Load', '2026-09-07 11:00:00', 6),

(7, 'Transfer', '2026-09-08 16:30:00', 7),

(8, 'Unload', '2026-09-09 17:00:00', 10),

(9, 'Load', '2026-09-10 12:00:00', 6),

(10, 'Transfer', '2026-09-11 18:00:00', 7);


-- =========================================================
-- 9. SECURITY LOGS - 10 RECORDS
-- =========================================================

INSERT INTO security_log
(user_id, entry_time, exit_time)
VALUES

(1, '2026-09-01 08:00:00', '2026-09-01 17:00:00'),

(2, '2026-09-01 08:30:00', '2026-09-01 18:00:00'),

(3, '2026-09-02 09:00:00', '2026-09-02 17:30:00'),

(4, '2026-09-02 09:15:00', '2026-09-02 18:00:00'),

(5, '2026-09-03 08:00:00', '2026-09-03 16:30:00'),

(6, '2026-09-03 08:45:00', '2026-09-03 17:00:00'),

(7, '2026-09-04 09:00:00', '2026-09-04 18:30:00'),

(8, '2026-09-04 08:30:00', '2026-09-04 17:30:00'),

(9, '2026-09-05 09:15:00', '2026-09-05 18:00:00'),

(10, '2026-09-05 08:00:00', '2026-09-05 17:00:00');

