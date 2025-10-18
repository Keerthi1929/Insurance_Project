create database sql_project1;
use sql_project1;

#----------------------1-No of Invoice by Accnt Exec-----------------------#
select * from invoice;
select `Account Executive`,income_class,count(ï»¿invoice_number)invoice_count 
from invoice
group by 1,2;

#----------------------2-Yearly Meeting Count------------------------------#
select right(meeting_date,4)year,count(`account executive`)meetingcount from meeting
group by 1
limit 2;

#---------------------- Stage Funnel by Revenue----------------------------#
select stage,sum(revenue_amount)sum_revenue_ammount from opportunity
group by 1;

#----------------------  No of meeting By Account Exe----------------------#
select `account executive`,count(meeting_date)no_meeting from meeting
group by 1;

#----------------------- Opportunity by revenue top 4 --------------------#
select ï»¿opportunity_name,sum(revenue_amount)sum_revenue_amount from opportunity
group by 1
order by 2 desc
limit 4;

#----------------------- Top oppurtunities -------------------------------#
select count(ï»¿opportunity_name)Total_opportunities from opportunity;

#----------------------- Top Open Opportunities -------------------------#
select count(ï»¿opportunity_name)Total_opportunities from opportunity
where stage not in ('Negotiate');

#------------------Cross Sell-----------------#
select * from cross_sell;
#------------------New------------------------#
select * from New;
#----------------Renwal-----------------------#
select * from renewal;
#----------------Achivement_%----------------#
select * from `Achievement_%`;






#----------------------- 1Cross Sell--Target,Achive,new -----------------#
create table cross_sell(Target Text,Achived Text,Invoice Text);
insert into cross_sell(target,achived,invoice)
select
(select concat(round(sum(`Cross sell bugdet`)/1000000,2),'M')
from `individual budgets`) as Target,
(select concat(round(sum(b_amount)/1000000,2),'M') from
(select sum(b.amount)b_amount from
brokerage b
where b.income_class = "Cross Sell"
union all
select sum(f.amount) from
fees f
where f.income_class = "Cross Sell")as ab) as Achived,
(select concat(round(sum(amount)/1000000,2),'M') from invoice
where income_class = "Cross Sell") as Invoice;

select * from cross_sell;

#----------------------- 2New --Target,Achive,new -----------------------#
create table New(Target text,Achived text,Invoice text);

insert into new(target,achived,invoice)
select
(select concat(round(sum(`New Budget`)/1000000,2),'M') from `individual budgets`)Target,
(select concat(round(sum(b_amount)/1000000,2),'M') from(
select sum(b.amount)b_amount 
from brokerage b
where b.income_class = 'New'
union all
select sum(f.amount)
from fees f
where f.income_class = 'New')abc) as Achived,
(select concat(round(sum(amount)/1000000,2),'M') from invoice
where income_class = 'New')Invoice;

select * from new;

#----------------------- 3Renewal --Target,Achive,new -----------------------#
create table Renewal(Target text,Achived text,Invoice text);

insert into renewal(Target,Achived,Invoice)
select
(select concat(round(sum(`Renewal Budget`)/1000000),'M') from `individual budgets`)Target,
(select concat(round(sum(b_amount)/1000000,2),'M') from(
select sum(b.amount)b_amount from brokerage b
where b.income_class = 'Renewal'
union all
select sum(f.amount) from fees f
where f.income_class = 'Renewal')abc)Achived,
(select concat(round(sum(amount)/1000000,2),'M') from invoice where income_class = 'Renewal')Invoice;

select * from Renewal;
#----------------------------------------------------------------------------------------------------------------#
create table `Achievement_%`(`Cross_sell_Placed_Achivement_%` text,
							`Cross_Sell_Invoice_Achivement_%` text,
                            `New_Placed_Achivement_%` text,
							`New_Invoice_Achivement_%` text,
                            `Renewal_Placed_Achivement_%` text,
							`Renewal_Invoice_Achivement_%` text);

#-------------------------------Cross sell placed Achivement %----------------------------------------------------#
insert into `Achievement_%`(`Cross_sell_Placed_Achivement_%`,
							`Cross_Sell_Invoice_Achivement_%`,
                            `New_Placed_Achivement_%` ,
							`New_Invoice_Achivement_%`,
                            `Renewal_Placed_Achivement_%`,
							`Renewal_Invoice_Achivement_%`)
select concat(round(
(((select sum(amount) from brokerage where income_class = 'Cross Sell') +
(select sum(amount) from fees where income_class = 'Cross Sell')
)/(select sum(`Cross sell bugdet`) from `individual budgets`))*100,2),'%▼')`Cross_sell_placed_%`,
#------------------------------- Cross sell invoice Achivement %---------------------------------------------------#
concat(round(
((select sum(amount) from invoice where income_class = 'Cross Sell')/
(select sum(`Cross sell bugdet`) from `individual budgets`))*100,2),'%▼')`Cross_sell_Invoice_%`,
#------------------------------ New Placed Achivement %----------------------------------------------------------#
concat(round(
(((select sum(amount) from brokerage where income_class = 'New') +
(select sum(amount) from fees where income_class = 'New')
)/(select sum(`New Budget`) from `individual budgets`))*100,2),'%▼')`New_placed_%`,
#------------------------------ New Invoice Achivement %---------------------------------------------------------#
concat(round(
((select sum(amount) from invoice where income_class = 'New')/
(select sum(`New Budget`) from `individual budgets`))*100,2),'%▼')`New_Invoice_%`,
#------------------------------ Renewal Placed Achivement %------------------------------------------------------#
concat(round(
(((select sum(amount) from brokerage where income_class = 'Renewal') +
(select sum(amount) from fees where income_class = 'Renewal')
)/(select sum(`Renewal Budget`) from `individual budgets`))*100,2),'%▲')`Renewal_placed_%`,
#------------------------------ Renewal Invoice Achivement %-----------------------------------------------------#
concat(round(
((select sum(amount) from invoice where income_class = 'Renewal')/
(select sum(`Renewal Budget`) from `individual budgets`))*100,2),'%▼')`Renewal_Invoice_%`;
#---------------------------------------------------------------------------------------------------------------#


