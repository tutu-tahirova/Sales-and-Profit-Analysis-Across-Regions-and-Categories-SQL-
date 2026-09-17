CREATE TABLE orders (
    row_id INTEGER,
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales NUMERIC,
    quantity INTEGER,
    discount NUMERIC,
    profit NUMERIC
);
SELECT * --orders cedveline umumi olaraq baxdim 
FROM orders
LIMIT 10;
--Q1: Table profil
Select count(*) as total_rows,--ümumi sətir sayı
count(Distinct customer_id) as distinct_customers, --fərqli müştərilərin sayı
count(distinct product_id) as distint_products, --fərqli məhsul sayı
min(order_date) as min_order_date, --ən köhnə sifariş tarixi
max(order_date) as max_order_date -- ən yeni sifariş tarixi
from orders;
--Q2:Null count hər sütun üzrə neçə null olduğunu göstərir
select
sum(case when row_id is null then 1 else 0 End ) as row_id_nulls,
sum(case when order_id is null then 1 else 0 end ) as order_id_nulls,
sum(case when order_date is null then 1 else 0 end) as order_date_nulls,
sum(case when ship_date is null then 1 else 0 end ) as ship_date_nulls,
sum(case when ship_mode is null then 1 else 0 end ) as ship_mode_nulls,
sum(case when customer_id is null then 1 else 0 end ) as customer_id_nulls,
sum(case when customer_name is null then 1 else 0 end ) as customer_name_nulls,
sum(case when segment is null then 1 else 0 end ) as segment_nulls,
sum(case when country is null then 1 else 0 end ) as country_nulls,
sum(case when city is null then 1 else 0 end ) as city_nulls,
sum(case when state is null then 1 else 0 end ) as state_nulls,
sum(case when postal_code is null then 1 else 0 end ) as postal_code_nulls,
sum(case when region is null then 1 else 0 end ) as region_nulls,
sum(case when product_id is null then 1 else 0 end ) as product_id_nulls,
sum(case when category is null then 1 else 0 end ) as category_nulls,
sum(case when sub_category is null then 1 else 0 end ) as sub_category_nulls,
sum(case when product_name is null then 1 else 0 end ) as product_name_nulls,
sum(case when sales is null then 1 else 0 end ) as sales_nulls,
sum(case when quantity is null then 1 else 0 end ) as quantity_nulls,
sum(case when discount is null then 1 else 0 end ) as disount_nulls,
sum(case when profit is null then 1 else 0 end ) as profit_nulls
from orders;
--Q3:Duplikat sətirlər
select order_id,product_id, count(*) as say -- eyni order id daxilinde iki eyni product id sətri olmamalıdır,əgər bir məhsuldan iki dənədirsə quantity hissəsinə 2 yazılır,əks halda duplikat sayılır
from orders
group by order_id,product_id
having count(*)>1;
--Q4:Orta catdirilma muddetinin tapilmasi
select ship_mode,round(avg(julianday(ship_date)-julianday(order_date)),2) as avg_days_to_ship --çatdırılma tarixindən sifariş tarixini çıxıb çatdırılma müddətini alırıq və çatdırılma növünə görə qruplaşdırırıq
from orders
group by ship_mode;
--Q5:Region və kateqoriyalara görə qruplaşdırma
select region,category,sub_category, -- melumat evvelce regionlara,sonra categoriyalara daha sonra ise alt kateqoriyalara gore qruplasdirilir
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit,
round(sum(profit)/sum(sales),4) as profit_margin
from orders
group by region,category,sub_category
order by total_profit asc;
--Q6:Ən yüksək və ən az 5 gəlir
with subcat_profit as (select sub_category,sum(profit) as total_profit 
from orders
group by sub_category), -- her bir alt kateqoriyanin umumi gelirini tapiriq ve bunu bir subquery kimi yaziriq
ranked as (select sub_category,total_profit,
rank() over (order by total_profit desc) as rank_desc,
rank() over (order by total_profit asc) as rank_asc
from subcat_profit) -- indi isə gəlirləri rank() funksiyasi ile sıralamalıyıq və subquery nin içinde bir dene de subquery yazırıq
select sub_category,total_profit,'Top' as type from ranked where rank_desc<=5
union ALL -- indi iki cədvəli union all ilə alt alta birləşdiririk top 5 lə bottom 5 i
select sub_category,total_profit,'Bottom' as type from ranked where rank_asc<=5;
--Q7:Diapazonlar
select case when discount=0 then '0%'
when discount>0 and discount<=0.20 then '1-20%'
when discount>0.20 and discount<0.40 then '21-40%'
else '41%+' -- endirim faizlerini diapazonlara ayiririq
end as discount_band,
count(*) as order_count, --hər diapazon üzrə sifaris sayini orta geliri ve umumi geliri hesablayiriq
round(avg(profit),2) as avg_profit,
round(sum(profit),2) as total_profit
from orders
group by discount_band;
--Q8:İlləri müqayisə etmək
with yearly_sales As (select substr(order_date,-4) as year,sum(sales) as total_sales
from orders 
group by year) -- date dən ili çıxardırıq(sondan 4 rəqəmi kəsərək) və illərə görə satışları qruplaşdırıb subquery yaradırıq
select year,total_sales,
lag(total_sales,1) over (order by year asc) as previous_year_sales,--lag əvvəlki sətri cari sətrin yanına gətirir
total_sales-lag(total_sales,1) over (order by year asc) as abs_change,-- artımı tapmaq üçün bu ilin satışından keçən ilin satışını çıxırıq
(total_sales-lag(total_sales,1) over (order by year asc))/lag(total_sales,1) over (order by year asc)*100 as pct_change --bu isə faizlə artıb azalmanı göstərir
from yearly_sales;
--Q9:zerer eden kateqoriyalarin umumi dovriyyedeki payi
with total_rev as (select sum(sales) as grand_total_sales --butun sirketin umumi satisi hesablanir
from orders),subcat as (select sub_category,sum(sales) as sub_sales,sum(profit) as sub_profit
from orders
group by sub_category
having sum(profit)<0)-- yalniz zererde olan kateqoriyalar secilir
select s.sub_category,s.sub_profit as total_profit,s.sub_sales as sub_sales,(s.sub_sales/t.grand_total_sales)*100 as revenue_share_pct --zererde olan alt kateqoriyalarin satisini umumi satisa bolub neqeder paya malik olduqlarina baxiriq
from subcat s --cross joinle grand total sale i diger cedvelin her setrinin yanina yapisdirir
cross join total_rev t;
--Q10:omurluk gelir getiren top 10 musteri
select customer_id,customer_name,
sum(profit) as lifetime_profit, --her bir musteriye gore geliri sayi ve order valueni qruplasdirdim
count(distinct order_id) as order_count,
round(sum(sales)/count(distinct order_id),2) as avg_order_value --orta sifaris deyerini tapmaq üçün umumi satisi sifaris sayina boluruk
from orders
group by customer_id,customer_name
order by lifetime_profit DESC --azalan sira ile duzuruk 10 a qeder
limit 10;
--Bonus 2
with subcat_region_profit As (
select sub_category,region,sum(profit) as region_profit
from orders
group by sub_category,region) -- alt kateqoriya ve regiona gore gelirleri qruplsdiririq
select DISTINCT a.sub_category
from subcat_region_profit a
join subcat_region_profit b
on a.sub_category=b.sub_category --kateqoriya ortaq oldugu ucun eyni kateqoriyalara oz ozune join ederek baxa bilerik
where a.region_profit>0 and b.region_profit<0;-- birinde faydali digerinde zererli olan olan kateqoriyalari cixardir
--bonus 3
with yearly_sales as (
select substr(order_date,-4) as year,
sum(sales) as total_sales
from orders
group by year)
Select year,round(total_sales,2) as yearly_sales,
round(sum(total_sales) over (order by year asc rows between unbounded preceding and current row),2) as cumulative_sales
from yearly_sales; --her ilin qarsisinda hemin ile qeder ve hemin il de daxil butun satislarin cemi toplanir
--bonus 4
Explain query plan -- scan ordersde cedvel basdan sona oxunur scan edilir eger sutunlara index qoysaydiq bu proses daha suretli gederdi 
SELECT 
    region,
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM orders
GROUP BY region, category, sub_category --melumatlari muxtelif kateqoriyalar uzre qruplasdirmaq ucun yaddasda muveqqeti olaraq agac strukturu yaradilir 
ORDER BY total_profit ASC;-- neticeleri artan veya azalan sirayla duzmek ucun yene de b tree strukturu istifade olunur 