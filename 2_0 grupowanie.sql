use northwind
-- podaj liczbę produktów o cenach mniejszych niż 10 lub większych niż 20
select count(*) as ile
from Products
    where unitprice > 20 or unitprice < 10

-- Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20
select max(unitprice) as max_unitprice
from products
    where unitprice < 20

-- Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o produktach sprzedawanych w butelkach (‘bottleʼ)
select max(unitprice) as [max unitprice], min(unitprice) as [min unitprice], avg(unitprice) as [avg unitprice]
from Products
    where QuantityPerUnit like '%bottle%'

-- Wypisz informację o wszystkich produktach o cenie powyżej średniej
select round(avg(unitprice),2)
from products -- -> sprawdzenie, ile wynosi avg unitprice

select productid, productname, unitprice, unitsinstock, UnitsOnOrder
from products
    where unitprice > 28.87
order by unitprice

-- podaj sumę/wartość zamówienia o numerze 10250
select round(sum(unitprice*quantity*(1-discount)),2) as [wartość zamówienia]
from [order details]
    where orderid = 10250

-- podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select orderid, max(unitprice) as [max]
from [Order details]
group by orderid

--  Posortuj zamówienia wg maksymalnej ceny produktu
select orderid, max(unitprice) as [max]
from [Order details]
group by orderid
order by max

-- Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
select orderid, max(unitprice) as max, min(unitprice) as min 
from [Order Details]
group by OrderID

-- Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
select shipvia as spedytor, count(orderid)
from Orders
group by shipvia

-- 2) wariant z joinami
select s.companyname as spedytor, count(o.orderid) as [liczba zamówień]
from orders o
    inner join shippers s on o.shipvia = s.shipperid
group by s.companyname

-- który ze spedytorów był najaktywniejszy w 1997 roku
select shipvia as spedytor, count(orderid) as [liczba zamówień]
from Orders
    where year(shippeddate) = 1997
group by shipvia

--2) wariant z joinami
select s.companyname as spedytor, count(o.orderid) as [liczba zamówień]
from orders o
    inner join shippers s on o.shipvia = s.ShipperID
    where year(o.shippeddate) = 1997
group by s.companyname

-- wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
select orderid, count(*) as [total qty]
from [order details]
group by OrderID
    having count(*) > 5

-- wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
select customerid, count(*) [total orders], sum(freight) as [freight], year(orderdate) as [order date]
from Orders
group by CustomerID, year(orderdate)
    having count(*) > 8 and year(orderdate) = 1998
order by sum(freight) desc