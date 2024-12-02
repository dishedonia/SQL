use northwind
-- . Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta.
select o.orderid as [id zamówienia], count(od.quantity) as [liczba zamówionych produktów], c.companyname as klient
from orders o
    inner join [order details] od on o.orderid = od.orderid 
    inner join customers c on o.customerid = c.CustomerID
group by o.orderid, c.companyname
order by o.orderid

-- dla każdego zamówienia podaj łączną wartość zamówionych produktów (wartość zamówienia bez opłaty za przesyłkę) oraz nazwę klienta.
select o.orderid as [id zamówienia], round(sum(unitprice*quantity*(1 - discount)),2) as [watość zamówienia], c.companyname as klient
from orders o
    inner join [order details] od on o.orderid = od.orderid 
    inner join customers c on o.customerid = c.CustomerID
group by o.orderid, c.companyname
order by o.orderid

-- Dla każdego zamówienia podaj łączną wartość tego zamówienia (wartość zamówienia wraz z opłatą za przesyłkę) oraz nazwę klienta.
select o.orderid as [id zamówienia], round(sum(unitprice*quantity*(1 - discount)) + o.freight,2) as [watość zamówienia z przesyłką], c.companyname as klient
from orders o
    inner join [order details] od on o.orderid = od.orderid 
    inner join customers c on o.customerid = c.CustomerID
group by o.orderid, c.companyname, o.freight
order by o.orderid

-- Zmodyfikuj poprzednie przykłady tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówień
select o.orderid as [id zamówienia], round(sum(unitprice*quantity*(1 - discount)) + o.freight,2) as [watość zamówienia z przesyłką], c.companyname as klient,
    concat(e.firstname,' ', e.lastname) as obsługa
from orders o
    inner join [order details] od on o.orderid = od.orderid 
    inner join customers c on o.customerid = c.CustomerID
    inner join employees e on e.employeeid = o.employeeid
group by o.orderid, c.companyname, o.freight, e.firstname, e.lastname
order by o.OrderID

-- podaj nazwy przewoźników, którzy w marcu 1998 przewozili produkty z kategorii 'Meat/Poultry'
select distinct s.companyname as przewoźnicy
from shippers s 
    inner join orders o on s.shipperid = o.shipvia 
    inner join [order details] od on o.orderid = od.orderid
    inner join products p on p.productid = od.productid 
    inner join categories c on c.categoryid = p.categoryid
where year(o.shippeddate) = 1998 and month(o.shippeddate) = 3 and c.categoryname = 'Meat/Poultry'

-- Podaj nazwy przewoźników, którzy w marcu 1997r nie przewozili produktów z kategorii 'Meat/Poultry'
select distinct s.companyname as przewoźnicy
from shippers s
    left outer join orders o on s.shipperid = o.shipvia
    left outer join [order details] od on o.orderid = od.orderid 
    left outer join products p on p.productid = od.ProductID
    left outer join categories c on c.categoryid = p.categoryid 
EXCEPT
select distinct s.companyname as przewoźnicy
from shippers s 
    inner join orders o on s.shipperid = o.shipvia 
    inner join [order details] od on o.orderid = od.orderid
    inner join products p on p.productid = od.productid 
    inner join categories c on c.categoryid = p.categoryid
where year(o.shippeddate) = 1997 and month(o.shippeddate) = 3 and c.categoryname = 'Meat/Poultry'

-- dla każdego przewoźnika podaj wartość produktów z kategorii 'Meat/Poultry' które ten przewoźnik przewiózł w marcu 1997
select s.companyname as przewoźnik, o.orderid as zamówienie, round(sum(od.unitprice*od.quantity*(1 - od.discount)),2) as [wartość produktów], o.shippeddate as [data wysyłki] 
from shippers s
    inner join orders o on s.shipperid = o.shipvia 
    inner join [order details] od on o.orderid = od.orderid 
    inner join products p on od.productid = p.productid 
    inner join categories c on p.categoryid = c.categoryid 
where year(shippeddate) = 1997 and month(shippeddate) = 3 and c.categoryname = 'Meat/Poultry'
group by s.companyname, o.orderid, o.shippeddate

-- dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów z tej kategorii.
select c.categoryname as [kategoria produktu], sum(od.quantity) as [suma zamówionych produktów]
from [order details] od 
    inner join products p on p.productid = od.productid 
    inner join categories c on c.categoryid = p.categoryid
group by c.categoryname

-- dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych w 1997r jednostek towarów z tej kategorii.
select c.categoryname as [kategoria produktu], sum(od.quantity) as [suma zamówionych produktów]
from [order details] od 
    inner join orders o on o.orderid = od.orderid
    inner join products p on p.productid = od.productid 
    inner join categories c on c.categoryid = p.categoryid
where year(o.orderdate) = 1997
group by c.categoryname

-- dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych towarów z tej kategorii.
select c.categoryname as [kategoria produktu], sum(od.quantity) as [suma zamówionych produktów], round(sum(od.unitprice*od.quantity*(1-discount)),2) as [łączna wartość zamówionych produktów]
from [order details] od 
    inner join products p on p.productid = od.productid 
    inner join categories c on c.categoryid = p.categoryid
group by c.categoryname

-- Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
select s.companyname as przewoźnik, count(*) as [liczba przewiezionych zamówień]
from shippers s 
    inner join orders o on o.shipvia = s.ShipperID
where year(o.shippeddate) = 1997
group by s.CompanyName

-- Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika
select s.companyname as przewoźnik, count(*) as [liczba przewiezionych zamówień]
from shippers s 
    inner join orders o on o.shipvia = s.ShipperID
where year(o.shippeddate) = 1997
group by s.CompanyName

-- dla każdego przewoźnika podaj łączną wartość "opłat za przesyłkę" przewożonych przez niego zamówień od '1998-05-03' do '1998-05-29'
select s.companyname as przewoźnik, sum(o.freight) as [wartość opłat za przesyłkę]
from orders o 
    inner join shippers s on s.shipperid = o.ShipVia
where o.shippeddate between '1998-05-03' and '1998-05-29'
group by s.companyname

-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika w maju 1996 -> w maju 96 nie było żadnych zamowień
select (e.firstname + ' ' + e.lastname) as pracownik, round(sum(od.unitprice*od.quantity*(1-od.discount)),2) as [łączna wartość zamówień]
from employees e 
    inner join orders o on o.employeeid = e.employeeid 
    inner join [order details] od on o.orderid = od.orderid 
where month(o.orderdate) = 5 and year(o.orderdate) = 1996
group by e.firstname, e.lastname

-- który z pracowników obsłużył największą liczbę zamówień w 1996r, podaj imię i nazwisko takiego pracownika
select (e.firstname + ' ' + e.lastname) as pracownik, count(o.orderid) as [liczba zamwówień]
from employees e 
    inner join orders o on e.employeeid = o.employeeid
where year(o.orderdate) = 1997
group by e.firstname, e.lastname 
order by [liczba zamwówień]

-- Który z pracowników był najaktywniejszy (obsłużył zamówienia o największej wartości) w 1996r, podaj imię i nazwisko takiego pracownika
select (e.firstname + ' ' + e.lastname) as pracownik, count(o.orderid) as [liczba zamwówień], 
    round(sum(od.unitprice*od.quantity*(1-od.discount)),2) as [wartość zamówień]
from employees e 
    inner join orders o on e.employeeid = o.employeeid
    inner join [order details] od on od.orderid = o.orderid
where year(o.orderdate) = 1997
group by e.firstname, e.lastname 
order by [wartość zamówień] desc

--  Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika
--Ogranicz wynik tylko do pracowników
--a) którzy mają podwładnych
select (e.firstname + ' ' + e.lastname) as pracowink, round(sum(od.unitprice*od.quantity*(1-od.discount)),2) as [wartość zamówień]
from employees e 
    inner join orders o on o.employeeid = e.employeeid
    inner join [order details] od on od.orderid = o.OrderID
    inner join employees emp on e.employeeid = emp.reportsto
group by e.firstname, e.lastname

--b) którzy nie mają podwładnych
select (e.firstname + ' ' + e.lastname) as pracowink, round(sum(od.unitprice*od.quantity*(1-od.discount)),2) as [wartość zamówień]
from employees e 
    left join orders o on o.employeeid = e.employeeid
    left join [order details] od on od.orderid = o.OrderID
    left join employees emp on e.employeeid = emp.reportsto
where emp.reportsto is null
group by e.firstname, e.lastname
order by [wartość zamówień]