use world;
 
select * from hr;
alter table hr add column Attritioncount int after attrition;
alter table hr add column Work_life_balance_rating varchar(20);
alter table hr add column cf_year_since_last_promotion varchar(10);
alter table hr add column cf_jobsatisfaction varchar(20);
 
update hr set attritioncount =  ( 
case
     when Attrition = "Yes" then Attritioncount = 1
     else Attritioncount = 0
end);

update hr set work_life_balance_rating = (
case
	when worklifebalance = 4 then  'Excellent'
    when worklifebalance = 3 then  'Good'
    when worklifebalance = 2 then  'Average'
    else 'Poor'
end);

update hr set cf_year_since_last_promotion = (
case
    when YearsSinceLastPromotion between 1 and 3 then '1-3'
    when YearsSinceLastPromotion between 4 and 6 then '4-6'
    when YearsSinceLastPromotion between 7 and 9 then '7-9'
    when YearsSinceLastPromotion between 10 and 12 then '10-12'
    when YearsSinceLastPromotion between 13 and 15 then '13-15'
    when YearsSinceLastPromotion between 16 and 18 then '16-18'
    when YearsSinceLastPromotion between 19 and 21 then '19-21'
    when YearsSinceLastPromotion between 22 and 24 then '22-24'
    when YearsSinceLastPromotion between 25 and 27 then '25-27'
    when YearsSinceLastPromotion between 28 and 30 then '28-30'
    when YearsSinceLastPromotion between 31 and 33 then '31-33'
    when YearsSinceLastPromotion between 34 and 36 then '34-36'
    else '37+'
end);

update hr set cf_jobsatisfaction = (
case
    when jobsatisfaction >=3 then 'Satisfied'
    when jobsatisfaction <=2 then 'Not Satisfied'
end);
----------------------------------------------------------------------------------------##EDA##----------------------------------------------------------------------------------

#1KPI Average Attrition rate for all Departments
select * from hr;
select concat(round((sum(attritioncount)/count(employeenumber))*100,2),'%') as average_attrition_rate from hr;

#2KPI Average Hourly rate of Male Research Scientist
select jobrole,gender,round(avg(hourlyrate),0) as average_hourly_rate from hr group by gender,jobrole having jobrole = 'Research Scientist' and gender = 'Male';

#3KPI Attrition rate Vs Monthly income stats
select Department,concat(round((sum(attritioncount)/count(employeenumber))*100,2),'%') as attrition_rate,concat("$",format(sum(monthlyincome)/1000000,2),'M') as Monthly_Income from hr group by department order by Monthly_Income;

#4KPI Average working years for each Department
select Department,round(avg(totalworkingyears)) as Average_Working_Years from hr group by department;

#5KPI Job Role Vs Work life balance
select jobrole,Work_Life_Balance_Rating,count(employeenumber) as employee_count from hr group by jobrole,Work_Life_Balance_Rating order by jobrole,employee_count desc;

#6KPI Attrition rate Vs Year since last promotion relation
select cf_year_since_last_promotion,round(sum(attritioncount)/count(employeenumber)*100,2) as Attrition_Rate from hr group by cf_year_since_last_promotion order by attrition_Rate desc;

#7KPI Department wise No of Employees
select Department,count(employeenumber) as Count_Of_Employees from hr group by department;

#8KPI Count of Employees based on Educational Fields
Select Educationfield as Education_Field, count(Employeenumber) as Count_Of_Employees from hr group by educationfield;

#9KPI Gender based Percentage of Employee
select concat(round(((select count(employeenumber) from hr where gender = 'male')/count(employeenumber))*100,2),'%') as Male_Employee_percentage  from hr;
select concat(round(((select count(employeenumber) from hr where gender = 'Female')/count(employeenumber))*100,2),'%') as Female_Employee_Percentage from hr;

#10KPI Deptarment / Job Role wise job satisfaction
select department,jobrole,cf_jobsatisfaction,count(employeenumber) as Satisfaction_Count from hr group by department,jobrole,cf_jobsatisfaction order by department;
