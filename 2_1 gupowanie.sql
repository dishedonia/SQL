use northwind

-- Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia w tablicy order details i zwraca wynik posortowany w malejącej kolejności (wg wartości sprzedaży).
select orderid, round(sum(unitprice*quantity*(1-discount)),2) as [wartość zamowienia]
from [order details]
group by OrderID
order by [wartość zamowienia] desc

-- zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10 wierszy
select top 10 orderid, round(sum(unitprice*quantity*(1-discount)),2) as [wartość zamowienia]
from [order details]
group by OrderID
order by [wartość zamowienia] desc

-- Podaj liczbę zamówionych jednostek produktów dla produktów, dla których productid jest mniejszy niż 3
select productid, sum(quantity) as zamówione
from [Order Details]
group by ProductID
    having productid < 3

-- zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę zamówionych jednostek produktu dla wszystkich produktów
select productid, sum(quantity) as zamówione
from [Order Details]
group by productid

-- podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których łączna liczba zamawianych jednostek produktów jest większa niż 250
select orderid, round(sum(unitprice*quantity*(1-discount)),2) as [wartość zamówienia], sum(quantity) as [zamówione jednostki]
from [Order Details]
group by orderid
    having sum(quantity) > 250

-- dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień
--1)
select employeeid as pracownik, count(orderid) as [liczba osbłużonych zamówień]
from Orders
group by EmployeeID
--2) wariant z joinami
select o.employeeid, concat(e.firstname,' ', e.lastname) as pracownik, count(o.orderid) as [liczba obsłużonych zamówień]
from Orders o 
    inner join employees e on o.employeeid = e.employeeid
group by o.employeeid, concat(e.firstname,' ', e.lastname)

-- dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" dla przewożonych przez niego zamówień
--1)
select shipvia as przewoźnik, sum(freight) as [łączne opłaty za przesyłkę]
from Orders
group by shipvia
--2) wariant z joinami
select s.companyname as przewoźnik, sum(o.freight) as [łączne opłaty za przesyłkę]
from orders o
    inner join shippers s on o.shipvia = s.shipperid
group by s.companyname

-- Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" przewożonych przez niego zamówień w latach o 1996 do 1997
select shipvia as przewoźnik, sum(freight) as [łączne opłaty za przesyłkę], year(shippeddate) as [rok przesyłki]
from Orders
group by shipvia, year(shippeddate)
    having year(shippeddate) between 1996 and 1997
order by shipvia
--2) wariant z joinami
select s.companyname as przewoźnik, sum(o.freight) as [łączne opłaty za przesyłkę], year(o.shippeddate) as [rok przesyłki]
from orders o
    inner join shippers s on o.shipvia = s.shipperid
group by s.companyname, year(o.shippeddate)
    having year(o.shippeddate) between 1996 and 1997
order by s.companyname

--  Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z podziałem na lata i miesiące
--1)
select employeeid as pracownik, count(orderid) as [suma obsłużonych zamówień], year(orderdate) as rok, month(orderdate) as miesiąc
from Orders
group by employeeid, year(orderdate), month(orderdate)
--2) wariant z joinami i nazwami msc
select concat(e.firstname, ' ', e.lastname) as pracownik, o.employeeid as [ID pacownika], count(o.orderid) as [suma obsłużonych zamówień], 
        year(o.orderdate) as rok,
    case
        when month(o.orderdate) = 1 then 'styczeń'
        when month(o.orderdate) = 2 then 'luty'
        when month(o.orderdate) = 3 then 'marzec'
        when month(o.orderdate) = 4 then 'kwiecień'
        when month(o.orderdate) = 5 then 'maj'
        when month(o.orderdate) = 6 then 'czerwiec'
        when month(o.orderdate) = 7 then 'lipiec'
        when month(o.orderdate) = 8 then 'sierpień'
        when month(o.orderdate) = 9 then 'wrzesień'
        when month(o.orderdate) = 10 then 'paźdiernink'
        when month(o.orderdate) = 11 then 'listopad'
        when month(o.orderdate) = 12 then 'grudzień'
        end miesiąc
from orders o
    inner join employees e on o.employeeid = e.EmployeeID
group by o.employeeid, year(o.orderdate), month(o.orderdate), concat(e.firstname, ' ', e.lastname)

-- Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej kategorii
--1)
select categoryid as kategoria, max(unitprice) as [maksymalna cena], min(unitprice) as [minimalna cena]
from Products
group by categoryid
--2) wariant z joinami
select p.categoryid as [ID kategorii], c.categoryname as kategoria, max(p.unitprice) as [maksymalna cena], min(p.unitprice) as [minimalna cena]
from products p 
    inner join categories c on c.categoryid = p.CategoryID
group by p.categoryid, c.categoryname
