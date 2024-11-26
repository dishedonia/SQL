-- WSZYSTKIE ZADANIA Z PLIKU: 1_1_polecenie_select.pdf

use northwind
-- wybierz nazwy i adresy wszystkich klientów
select CompanyName as customer_info, concat(address, ', ', city, ', ', region, ', ', postalcode, ', ', country) as adres
from customers

-- wybierz naziwska i telefony wszystkich pracowników
select lastname nazwisko, homephone nr_telefonu
from employees
order by lastname asc

-- wybierz nazwy i ceny produktów
select productname produkt, unitprice price
from products
order by productname asc

-- podaj wszystkie kategorie produktów (nazwy i opisy)
select categoryname as kategoria_produktu, description as opis
from Categories
order by categoryname

-- podaj nazwy i adresy stron www dostawców
select companyname as nazwa, homepage as [adres web]
from Suppliers
order by companyname

--wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
select companyname, concat(address, ', ', city, ', ', region, ', ', postalcode, ', ', country) as adres
from Customers
where city = 'London'

-- wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii
select companyname, concat(address, ', ', city, ', ', region, ', ', postalcode, ', ', country) as adres
from customers
where country in ('France', 'Spain') 
order by country

-- wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
select productname as produkt, unitprice as price 
from Products
where unitprice between 20 and 30 
order by unitprice

-- Wybierz nazwy i ceny produktów z kategorii 'Meat/Poultry'
-- 1) wariant z selectami
select categoryid, categoryname
from categories
where categoryname = 'Meat/Poultry' ---> potrzebne, żeby sprawdzić, jaki 
select productname, unitprice, categoryid
from Products
where categoryid = '6'
-- 2) wariant z joinami
select p.productname, p.unitprice, c.categoryname
from products p 
    join categories c 
    on p.categoryid = c.categoryid
where c.categoryname = 'Meat/Poultry'
order by p.unitprice

-- wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders'
-- 1) wariant z selectami
select supplierid ID, companyname nazwa
from Suppliers
where companyname = 'Tokyo Traders' -- -> potrzebne, żeby sprawdzić, jakie ID ma Tokyo Traders
select productname as produkt, unitsinstock, supplierid ID
from Products
where supplierid = 4
order by unitsinstock
-- 2) wariant z joinami
select p.productname as produkt, p.unitsinstock as [stan magazynu], s.companyname
from products p 
    join suppliers s on p.supplierid = s.SupplierID
where s.companyname = 'Tokyo Traders'
order by p.unitsinstock

-- Wybierz nazwy produktów których nie ma w magazynie
select productname, unitsinstock
from Products
where unitsinstock = 0

-- szukamy informacji o produktach sprzedawanych w butelkach (‘bottleʼ)
select productname, unitsinstock, unitprice, quantityperunit
from Products
where quantityperunit like '%bottle%'
order by unitprice

-- wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę z zakresu od B do L
select concat(lastname, ' ', firstname) as employee, title
from Employees
where lastname like '[B-L]%'
order by lastname

-- wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę B lub L
select concat(lastname, ' ', firstname) as employee, title
from Employees
where lastname like '[BL]%'
order by lastname

-- Znajdź nazwy kategorii, które w opisie zawierają przecinek
select categoryname, description
from Categories
where description like '%,%'

-- znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo 'Store'
select companyname
from Customers
where companyname like '%store%'

-- szukamy informacji o produktach o cenach mniejszych niż 10 lub większych niż 20
select productname, unitprice
from products 
where unitprice < 10 or unitprice > 20
order by unitprice

--  Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
-- 1) z operatorem BETWEEN
select productname, unitprice
from Products
where (unitprice between 20 and 30) and unitprice not in (20, 30)
order by unitprice
-- 2) z operatorami <>
select productname, unitprice
from Products
where unitprice > 20 and unitprice < 30
order by unitprice

-- wybierz zamówienia złożone w 1997
select orderid, orderdate, shipname
from Orders
where year(orderdate) = 1997

-- Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem odbiorcy
-- jest Argentyna
select orderid, orderdate, customerid
from Orders
where shipcountry = 'Argentina' and shippeddate is null

-- wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w ramach danego kraju nazwy firm posortuj alfabetycznie
select companyname, country
from Customers
order by country, companyname

-- wybierz nazwy i kraje wszystkich klientów mających siedziby we Francji lub w Hiszpanii, wyniki posortuj według kraju, w ramach danego kraju nazwy firm posortuj
-- alfabetycznie
select companyname, country 
from Customers
where country in ('France', 'Spain')
order by country, companyname

-- wybierz zamówienia złożone w 1997 r. Wynik po sortuj malejąco wg numeru miesiąca, a w ramach danego miesiąca rosnąco według ceny za przesyłkę
select orderid, customerid, month(orderdate) as msc, freight
from Orders
where year(orderdate) = 1997
order by month(orderdate) desc, freight asc

-- Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 10250
select orderid, productid, unitprice, quantity, discount, round(unitprice*quantity*(1-discount),2) as [full price]
from [order details]
where orderid = 10250

-- napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą kolumnę zawierającą nr telefonu i nr faksu w formacie (numer telefonu i faksu mają być
-- oddzielone przecinkiem

select companyname, 
case 
    when phone is null then 'Nr telefonu: ' + 'NA' + ', '+ 'Nr fax: ' + fax -- -> warunek, gdy nie ma nr tel
    when fax is null then 'Nr telefonu: ' + phone + ', ' + 'Nr fax: ' + 'NA' -- -> warunek, gdy nie ma nr fax
    else ('Nr telefonu: ' + phone + ', ' + 'Nr fax: ' + fax) 
    end as contact
from suppliers