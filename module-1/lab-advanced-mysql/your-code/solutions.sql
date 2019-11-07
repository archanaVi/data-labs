
#LAB - ADVANCED MYSQL

#Challenge1

use publications;

SELECT t.title,t.title_id,a.au_id,a.au_lname,a.au_fname,s.qty,t.price,t.royalty,ta.royaltyper
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=t.title_id


#STEP 1 : Calculate the royalty of each sale for each author and the advance for each author and publication

SELECT t.title_id,a.au_id,round((s.qty*t.price*t.royalty/100*ta.royaltyper/100),2) as total_royalty, round((t.advance*ta.royaltyper/100),0) as advance
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=t.title_id


#STEP 2 : Aggregate the total royalties for each title and author

select title_id,au_id,sum(total_royalty) as sum_royalty,advance
from (SELECT t.title_id,a.au_id,round((s.qty*t.price*t.royalty/100*ta.royaltyper/100),2) as total_royalty, round((t.advance*ta.royaltyper/100),0) as advance
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=t.title_id
) nt
group by title_id, au_id;

#STEP 3: Calculate the total profits of each author

SELECT au_id,sum(sum_royalty+advance) as total_profit
from(
select title_id,au_id,sum(total_royalty) as sum_royalty,advance
from (SELECT t.title_id,a.au_id,round((s.qty*t.price*t.royalty/100*ta.royaltyper/100),2) as total_royalty, round((t.advance*ta.royaltyper/100),0) as advance
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=t.title_id
) nt
group by title_id, au_id
) nt2
group by au_id
order by total_profit desc;




---------------------

correction du prof

#Challenge 1, step 3

select au_id, sum(ssr+sales_advance) total_profit
from
(select title_id,au_id,sum(sales_royalty) as ssr, sales_advance
from
(select ta.title_id, ta.au_id, t.price*s.qty*t.royalty*ta.royaltyper/10000 as sales_royalty, t.advance*ta.royaltyper/100 as sales_advance
from titleauthor ta
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=ta.title_id
order by ta.title_id, ta.au_id) new_temporary
group by title_id,au_id) second_temporary
group by au_id
order by total_profit desc

##

#Challenge2 step1
create temporary table new_temp(
select ta.title_id, ta.au_id, t.price*s.qty*t.royalty*ta.royaltyper/10000 as sales_royalty, t.advance*ta.royaltyper/100 as sales_advance
from titleauthor ta
inner join titles t on t.title_id=ta.title_id
inner join sales s on s.title_id=ta.title_id
order by ta.title_id, ta.au_id);

# Challenge 2 Step 2
create temporary table second_temp
(select title_id,au_id,sum(sales_royalty) as ssr, sales_advance
from
new_temp
group by title_id,au_id);
select au_id, sum(ssr+sales_advance) total_profit
from second_temp
group by au_id
order by total_profit desc;

#Challenge 2 step3
create table new_table(
select au_id, sum(ssr+sales_advance) total_profit
from second_temp
group by au_id
order by total_profit desc)









