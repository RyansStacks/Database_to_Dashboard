CREATE TABLE d_customers_race
AS
select race,
count(customer_id)
from customers
group by race;

CREATE TABLE d_customers_ages_bin
AS
with table1 as 
(select dob,
 extract(year from now()) - extract(year from dob) as age
from customers),
table2 as
(select 
 case 
 when table1.age > 0  and table1.age <= 18 then '0 - 18'
 when table1.age > 18  and table1.age <= 35 then '18 - 35'
 when table1.age > 35 and table1.age <= 55 then '35 - 55'
 when table1.age > 55 and table1.age <= 75 then '55 - 75'
 when table1.age > 75 then '75 or greater'
 end as age_groups,
 count(table1.dob) as freq
from customers, table1
 group by age_groups)
select *
from table2;

CREATE TABLE d_customers_gender
AS
select gender,
count(customer_id)
from customers
group by gender;

CREATE TABLE d_customers_geography
AS
select customer_id, lat, lon
from customers 
left outer join addresses
on customers.address_id = addresses.address_id;

CREATE TABLE d_customers_purchasing
AS
select foo.total_orders,
count(foo.total_orders)
from 
(select customers.customer_id,
count(orders.order_id) as total_orders
from orders
left outer join customers
on orders.customer_id = customers.customer_id
group by customers.customer_id) as foo
group by foo.total_orders
order by foo.total_orders;

CREATE TABLE d_customers_panels
AS
select foo.panel,
avg(foo.total_number) average_number
from
(select orders.customer_id,
orders.panel,
count(orders.panel)as total_number
from orders
group by orders.customer_id,
orders.panel) as foo
group by foo.panel;

CREATE TABLE d_orders_panels
AS
select orders.panel,
count(orders.panel_id)
from orders
left outer join panels
on orders.panel_id = panels.panel_id
group by orders.panel;

CREATE TABLE d_orders_panels_charges
AS
select orders.panel,
count(panels.cost)as total_revenue
from orders
left outer join panels
on orders.panel_id = panels.panel_id
group by orders.panel;

CREATE TABLE d_orders_customers_expenditures_total
AS
select orders.customer_id,
sum(panels.cost)
from orders
left outer join panels
on orders.panel_id = panels.panel_id
group by orders.customer_id;


CREATE TABLE d_orders_customers_expenditures_avg
AS
select avg(num_panels)
from
(select orders.customer_id,
count (orders.panel) as num_panels
from orders
left outer join panels
on orders.panel_id = panels.panel_id
group by orders.customer_id) as foo;  

CREATE TABLE d_accounting_expenses_all
AS
with overhead as
(select sum(salary) as overhead
from employees),
expenses as
(select sum(electric + water  + waste) as expenses
from expenses)
select overhead.overhead+expenses.expenses 
as total_expenses
from overhead, expenses;

CREATE TABLE d_accounting_revenue_all
AS
select sum(cast(panels.cost as numeric)) as Revenue
from panels
left outer join orders
on panels.panel_id = orders.panel_id;

CREATE TABLE d_accounting_profit_all
AS
with overhead as
(select sum(salary) as overhead
from employees),
expenses as
(select sum(electric + water  + waste) as expenses
from expenses),
revenue as
(select sum(cast(cost as numeric)) as revenue
from orders
left outer join panels
on orders.panel_id = panels.panel_id)
select (revenue.revenue - (overhead.overhead+expenses.expenses))
as total_profit
from revenue, overhead, expenses;

CREATE TABLE d_accounting_expenses_lab
AS
with overhead as
(select sum(salary) as overhead,
 lab_id as employee_lab
from employees
group by employee_lab),
expenses as
(select sum(electric + water  + waste) as expenses
from expenses)
select overhead.employee_lab,
(overhead.overhead+expenses.expenses)
as total_expenses
from overhead, expenses;

CREATE TABLE d_accounting_revenue_lab
AS
select 
orders.lab_id,
sum(cast(panels.cost as numeric)) as Revenue
from panels
left outer join orders
on panels.panel_id = orders.panel_id
left outer join laboratories
on orders.lab_id = laboratories.lab_id
group by orders.lab_id;

CREATE TABLE d_accounting_profit_lab
AS
with overhead as
(select sum(salary) as overhead,
 lab_id as employee_lab
from employees
group by employee_lab),
expenses as
(select sum(electric + water  + waste) as expenses
from expenses),
sales as
(select 
orders.lab_id,
sum(cast(panels.cost as numeric)) as revenue
from panels
left outer join orders
on panels.panel_id = orders.panel_id
left outer join laboratories
on orders.lab_id = laboratories.lab_id
group by orders.lab_id)
select sales.revenue - (overhead.overhead + expenses.expenses) 
as total_profit
from sales, overhead, expenses;

CREATE TABLE d_productivity_results_ytd
AS
select count(*)
from patient_results;

CREATE TABLE d_productivity_results_labs_ytd
AS
select laboratories.names,
count(*)
from patient_results
left outer join laboratories
on patient_results.lab_id = laboratories.lab_id
group by laboratories.names;

CREATE TABLE d_productivity_results_all_monthly
AS
select extract(month from patient_results.date) as month,
count(*)
from patient_results
left outer join laboratories
on patient_results.lab_id = laboratories.lab_id
group by month;

CREATE TABLE d_estimates_profits_monthly
AS
with overhead as
(select sum(salary) as overhead
from employees),
expenses as
(select sum(electric + water  + waste) as expenses,
 row_number() over (partition by expenses.month) as month
from expenses
group by month),
revenue as
(select sum(cast(cost as numeric)) as revenue
from orders
left outer join panels
on orders.panel_id = panels.panel_id),
profit as
(select row_number() over (partition by expenses.month) as month,
(revenue.revenue - (overhead.overhead+expenses.expenses))
as total_profit
from revenue, overhead, expenses) 
select profit.month,
profit.total_profit,
avg(profit.total_profit) 
over (order by profit.month) as SMA
from profit
group by profit.month,
profit.total_profit;

CREATE TABLE d_employees_race
AS
select race,
count(employee_id)
from employees
group by race;

CREATE TABLE d_employees_ages_binned
AS
with table1 as 
(select 
(case when foo.age < 18 then '0 - 18'
when foo.age >= 18 and foo.age < 30 then '18 - 35'
when foo.age >= 30 and foo.age < 55 then '30 - 55'
when foo.age >= 55 and foo.age < 75 then '55 - 75'
when foo.age >= 75 then '75 - 100'
end) as ages,
count(foo.dob) 
from 
(select (extract(year from now())-extract(year from dob)) as age,
 dob
 from employees) as foo
 group by ages
 order by ages),
 table2 as 
 (select count(employee_id) as total
 from employees)
 select ages,
 cast(table1.count as numeric)/cast(table2.total as numeric) as prop
 from table1, table2;

CREATE TABLE d_employees_gender
AS
select gender,
count(employee_id)
from employees
group by gender;

CREATE TABLE d_employees_surveys
AS
select employee_surveys.employee_id,
avg(pay),
avg(manager),
avg(work_volume),
avg(available_tools),
avg(overall)
from employee_surveys
group by employee_surveys.employee_id;

CREATE TABLE d_laboratories_cities
AS
select city,
state
from laboratories;

CREATE TABLE d_employees_demographics
AS
select city,
race, 
gender
from employees
left outer join laboratories
on employees.lab_id = laboratories.lab_id
group by city, race, gender
order by city;

CREATE TABLE d_reference_2sd
AS
select tests,
avg(results) - (2 * stddev(results)) as Lower_2SD,
avg(results) as avg_result,
avg(results) + (2 * stddev(results)) as Upper_2SD
from patient_results
group by tests;

CREATE TABLE d_reference_outliers_tests
AS
with actual as 
(select tests,
results
from patient_results),
reference as
(select tests,
avg(results) - (2 * stddev(results)) as lower_2SD,
avg(results) + (2 * stddev(results)) as upper_2SD
from patient_results
group by tests),
alert as
(select actual.tests,
(case
when actual.results - reference.lower_2SD < 0 then 'low'
when reference.upper_2SD - actual.results < 0  then 'high'
else 'normal'
end) as alert
from actual
left outer join reference
on reference.tests = actual.tests),
normal as
(select tests,
count(alert.alert) as alert_num
from alert
group by tests, alert.alert
having alert.alert = 'normal'),
high as
(select tests,
count(alert.alert) as alert_num
from alert
group by tests, alert.alert
having alert.alert = 'high'),
low as
(select tests,
count(alert.alert) as alert_num
from alert
group by tests, alert.alert
having alert.alert = 'low')
select normal.tests,
(low.alert_num/
sum (low.alert_num+normal.alert_num+high.alert_num))
as low_prop,
(normal.alert_num/
sum (low.alert_num+normal.alert_num+high.alert_num))
as normal_prop,
(high.alert_num /
sum (low.alert_num+normal.alert_num+high.alert_num))
as high_prop
from normal, high, low
group by normal.tests,
low.alert_num,
normal.alert_num,
high.alert_num;

CREATE TABLE d_reference_gender
AS
with female as
(select tests,
avg(results) as avg_female_result
from patient_results
left outer join customers
on patient_results.customer_id = customers.customer_id
group by tests, gender
having gender = 'Female'),
male as
(select tests,
avg(results) as avg_male_result
from patient_results
left outer join customers
on patient_results.customer_id = customers.customer_id
group by tests, gender
having gender = 'Male')
select female.tests,
female.avg_female_result,
male.avg_male_result
from female
left outer join male
on female.tests = male.tests;

CREATE TABLE d_reference_race
AS
with caucasian as
(select tests,
avg(results) as avg_caucasian_result
from patient_results
left outer join customers
on patient_results.customer_id = customers.customer_id
group by tests, race
having race = 'Caucasian'),
hispanic as
(select tests,
avg(results) as avg_hispanic_result
from patient_results
left outer join customers
on patient_results.customer_id = customers.customer_id
group by tests, race
having race = 'Hispanic'),
AA as
(select tests,
avg(results) as avg_African_American_result
from patient_results
left outer join customers
on patient_results.customer_id = customers.customer_id
group by tests, race
having race = 'African American'),
asian as
(select tests,
avg(results) as avg_asian_result
from patient_results
left outer join customers
on patient_results.customer_id = customers.customer_id
group by tests, race
having race = 'Asian')
select caucasian.tests,
caucasian.avg_caucasian_result,
hispanic.avg_hispanic_result,
AA.avg_African_American_result,
asian.avg_asian_result
from caucasian
left outer join AA
on caucasian.tests = AA.tests
left outer join hispanic
on AA.tests = hispanic.tests
left outer join asian
on hispanic.tests = asian.tests;

