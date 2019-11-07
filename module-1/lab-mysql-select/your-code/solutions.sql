


#Challenge 1 : right way : we have relationship between the tables and we join them in one table
select  a.au_id as AUTHOR_ID, a.au_lname as LASTNAME, a.au_fname as FIRSTNAME, t.title as TITLE, p.pub_name as PUBLISHER
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on t.title_id=ta.title_id
inner join publishers p on p.pub_id=t.pub_id
order by a.au_id;
​
# Challenge 2
​
select  a.au_id as AUTHOR_ID, a.au_lname as LASTNAME, a.au_fname as FIRSTNAME, p.pub_name as PUBLISHER, count(t.title) as TITLE_COUNT
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on t.title_id=ta.title_id
inner join publishers p on p.pub_id=t.pub_id
group by a.au_id, p.pub_id # we need to group by both author_id and publisher to be able to have multiple rows with the same author_id or publisher
order by a.au_id desc;
​
create table challenge2
as (select  a.au_id as AUTHOR_ID, a.au_lname as LASTNAME, a.au_fname as FIRSTNAME, p.pub_name as PUBLISHER, count(t.title) as TITLE_COUNT
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on t.title_id=ta.title_id
inner join publishers p on p.pub_id=t.pub_id
group by a.au_id, p.pub_id # we need to group by both author_id and publisher to be able to have multiple rows with the same author_id or publisher
order by a.au_id desc);
​
select sum(TITLE_COUNT)
from challenge2;
​
select count(*)
from titleauthor;
​
#challenge3
select  a.au_id as AUTHOR_ID, a.au_lname as LASTNAME, a.au_fname as FIRSTNAME, count(s.title_id) as TOTAL
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
left join titles t on t.title_id=ta.title_id
left join sales s on s.title_id=t.title_id
group by a.au_id 
order by count(s.title_id) desc
limit 3;
​
#challenge4
select  a.au_id as AUTHOR_ID, a.au_lname as LASTNAME, a.au_fname as FIRSTNAME, coalesce(sum(t.ytd_sales),0) as TOTAL
from authors a
left join titleauthor ta on a.au_id=ta.au_id
left join titles t on t.title_id=ta.title_id
group by a.au_id 
order by sum(t.ytd_sales) desc;