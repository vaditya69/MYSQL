create database sales; 
use sales;

create table sample_sales(
		order_date date,
        region char(10),
        represntative varchar(20),
        item varchar(20),
        units int,
        unit_cost int,
        total int
);

describe sample_sales;

insert into sample_sales values('2021-01-06','East','Jones','Pencil','95','1.99','189.05');
insert into sample_sales values('2021-01-23','Central','Kivell','Binder','50','19.99','999.5');
insert into sample_sales values('2021-02-09','Central','Jardine','Pencil','36','4.99','179.64');
insert into sample_sales values('2021-02-26','Central','Gill','Pen','27','19.99','539.73');
insert into sample_sales values('2021-03-15','West','Sorvino','Pencil','56','2.99','167.44');
insert into sample_sales values('2021-04-01','East','Jones','Binder','60','4.99','299.4');
insert into sample_sales values('2021-04-18','Central','Andrews','Pencil','75','1.99','149.25');
insert into sample_sales values('2021-05-05','Central','Jardine','Pencil','90','4.99','449.1');
insert into sample_sales values('2021-05-22','West','Thompson','Pencil','32','1.99','63.68');
insert into sample_sales values('2021-06-08','East','Jones','Binder','60','8.99','539.4');
insert into sample_sales values('2021-06-25','Central','Morgan','Pencil','90','4.99','449.1');
insert into sample_sales values('2021-07-12','East','Howard','Binder','29','1.99','57.71');
insert into sample_sales values('2021-07-29','East','Parent','Binder','81','19.99','1619.19');
insert into sample_sales values('2021-08-15','East','Jones','Pencil','35','4.99','174.65');
insert into sample_sales values('2021-09-01','Central','Smith','Desk','2','125','250');
insert into sample_sales values('2021-09-18','East','Jones','Pen Set','16','15.99','255.84');
insert into sample_sales values('2021-10-05','Central','Morgan','Binder','28','8.99','251.72');
insert into sample_sales values('2021-10-22','East','Jones','Pen','64','8.99','575.36');
insert into sample_sales values('2021-11-08','East','Parent','Pen','15','19.99','299.85');
insert into sample_sales values('2021-11-25','Central','Kivell','Pen Set','96','4.99','479.04');
insert into sample_sales values('2021-12-12','Central','Smith','Pencil','67','1.29','86.43');
insert into sample_sales values('2021-12-29','East','Parent','Pen Set','74','15.99','1183.26');
insert into sample_sales values('2022-01-15','Central','Gill','Binder','46','8.99','413.54');
insert into sample_sales values('2022-02-01','Central','Smith','Binder','87','15','1305');
insert into sample_sales values('2022-02-18','East','Jones','Binder','4','4.99','19.96');
insert into sample_sales values('2022-03-07','West','Sorvino','Binder','7','19.99','139.93');
insert into sample_sales values('2022-03-24','Central','Jardine','Pen Set','50','4.99','249.5');
insert into sample_sales values('2022-04-10','Central','Andrews','Pencil','66','1.99','131.34');
insert into sample_sales values('2022-04-27','East','Howard','Pen','96','4.99','479.04');
insert into sample_sales values('2022-05-14','Central','Gill','Pencil','53','1.29','68.37');
insert into sample_sales values('2022-05-31','Central','Gill','Binder','80','8.99','719.2');
insert into sample_sales values('2022-06-17','Central','Kivell','Desk','5','125','625');
insert into sample_sales values('2022-07-04','East','Jones','Pen Set','62','4.99','309.38');
insert into sample_sales values('2022-07-21','Central','Morgan','Pen Set','55','12.49','686.95');
insert into sample_sales values('2022-08-07','Central','Kivell','Pen Set','42','23.95','1005.9');
insert into sample_sales values('2022-08-24','West','Sorvino','Desk','3','275','825');
insert into sample_sales values('2022-09-10','Central','Gill','Pencil','7','1.29','9.03');
insert into sample_sales values('2022-09-27','West','Sorvino','Pen','76','1.99','151.24');
insert into sample_sales values('2022-10-14','West','Thompson','Binder','57','19.99','1139.43');
insert into sample_sales values('2022-10-31','Central','Andrews','Pencil','14','1.29','18.06');
insert into sample_sales values('2022-11-17','Central','Jardine','Binder','11','4.99','54.89');
insert into sample_sales values('2022-12-04','Central','Jardine','Binder','94','19.99','1879.06');
insert into sample_sales values('2022-12-21','Central','Andrews','Binder','28','4.99','139.72');



select * from sample_sales;

/*TO find out the sales in the eastern region */
select * from sample_sales
where region='East' and order_date <= '2021-01-23';

delete from sample_salescte where rownumber>1;

drop table sample_sales;

/*to find out the total sale done by each representative*/
select sum(total), represntative
from sample_sales 
group by represntative
order by sum(total) desc;

/*to find out the most sold item*/
select sum(units), item
from sample_sales
group by item
order by sum(units) desc;

/*to find out the most sale done in a single day*/
select order_date, count(order_date)
from sample_sales
group by order_date
having count(order_date)>1;



drop database sales;
/*-------------------------------------------*/



