-------------------------------------- NORTHWIND ----------------------------------------------------

use northwind
-- wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
select p.productname as produkt, p.unitprice as cena, s.companyname as dostawca, 
    concat(s.address, ', ',s.city,', ', region, ', ',s.postalcode,', ', s.country) as [dane adresowe]
from products p 
    inner join suppliers s on p.supplierid = s.supplierid
where p.unitprice between 20 and 30
order by p.unitprice

-- wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Tradersʼ
select s.companyname as dostawca, p.productname as produkt, p.unitsinstock as [w magazynie], p.unitsonorder as [w zamówieniach]
from Products p
    inner join suppliers s on p.supplierid = s.supplierid
where s.companyname like '%Tokyo Traders%'

-- czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe
select c.companyname as klient, c.customerid as [ID klienta], concat(c.address, ', ', c.city,', ',c.region,', ',c.postalcode,', ',c.country) as [dane adresowe]
from customers c
    left outer join orders o on o.customerid = c.CustomerID and year(o.orderdate) = 1997
where orderid is null 

-- Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie ma w magazynie.
select s.companyname as dostawca, s.phone as [nr telefonu], p.productname as produkt, p.unitsinstock as [w magazynie]
from products p    
    inner join suppliers s on s.supplierid = p.SupplierID
where p.unitsinstock = 0

-- Wybierz zamówienia złożone w marcu 1997. Dla każdego takiego zamówienia wyświetl jego numer, datę złożenia zamówienia oraz nazwę i numer telefonu klienta
select o.orderid as [numer zamówienia], o.orderdate as [data złożenia zamówienia], c.companyname as [klient], c.phone as [numer telefonu]
from orders o
    inner join customers c on c.customerid = o.customerid 
        and year(o.orderdate) = 1997 
        and month(o.orderdate) = 3

-- wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, interesują nas
-- tylko produkty z kategorii ‘Meat/Poultryʼ
use northwind
select p.productname as produkt, p.unitprice as cena, c.categoryname as kategoria, 
    concat(s.address, ', ', s.city, ', ', s.region, ', ', s.postalcode, ', ', s.country) as [adres dostawcy]
from products p 
    inner join suppliers s on p.supplierid = s.SupplierID
    inner join categories c on p.categoryid = c.categoryid
where c.categoryname = 'Meat/Poultry' and p.unitprice between 20 and 30

-- wybierz nazwy i ceny produktów z kategorii ‘Confectionsʼ dla każdego produktu podaj nazwę dostawcy.
select p.productname as produkt, p.unitprice as cena, c.categoryname as kategoria, s.companyname as dostawca
from products p 
    inner join categories c on p.categoryid = c.CategoryID
    inner join suppliers s on p.supplierid = s.SupplierID
where c.categoryname = 'Confections'

-- dla każdego klienta podaj liczbę złożonych przez niego zamówień. Zbiór wynikowy powinien zawierać nazwę klienta, oraz liczbę zamówień
select c.companyname as klient, c.customerid as [ID klienta], count(o.orderid) as [liczba zamówień]
from orders o
    inner join customers c on c.customerid = o.CustomerID
group by c.companyname, c.customerid

-- Dla każdego klienta podaj liczbę złożonych przez niego zamówień w marcu 1997r
select c.companyname as klient, c.customerid as [ID klienta], count(o.orderid) as [liczba zamówień]
from orders o
    inner join customers c on c.customerid = o.CustomerID and month(o.orderdate) = 3 and year(o.orderdate) = 1997
group by c.companyname, c.customerid

-- Który ze spedytorów był najaktywniejszy w 1997 roku, podaj nazwę tego spedytora
select s.companyname as spedytor, count(o.orderid) as [liczba zamówień]
from orders o
    inner join shippers s on s.shipperid = o.ShipVia and year(o.shippeddate) = 1997
group by s.companyname

-- dla każdego zamówienia podaj wartość zamówionych produktów. Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta oraz wartość 
-- zamówionych produktów
select o.orderid as [numer zamówienia], o.orderdate as [data zamówienia], c.companyname as klient, 
    round(sum(od.unitprice*od.quantity*(1-od.discount)),2) as [wartość zamówienia]
from orders o
    inner join customers c on c.customerid = o.CustomerID
    inner join [order details] od on o.orderid = od.OrderID
group by o.orderid, o.orderdate, c.companyname

-- dla każdego zamówienia podaj jego pełną wartość (wliczając opłatę za przesyłkę). Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta
-- oraz pełną wartość zamówienia
select o.orderid as [numer zamówienia], o.orderdate as [data zamówienia], c.companyname as klient, 
    round((sum(od.unitprice*od.quantity*(1-od.discount)) + o.freight),2) as [wartość zamówienia]
from orders o
    inner join customers c on c.customerid = o.CustomerID
    inner join [order details] od on o.orderid = od.OrderID
group by o.orderid, o.orderdate, c.companyname, o.freight

-- wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confectionsʼ
select distinct c.companyname, c.phone
from customers c
    inner join orders o on c.customerid = o.CustomerID
    inner join [order details] od on o.orderid = od.OrderID
    inner join products p on p.productid = od.productid 
    inner join categories cat on cat.categoryid = p.categoryid and cat.categoryname = 'Confections'

--Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii ‘Confectionsʼ
select c.companyname, c.phone
from customers c
    left outer join orders o on c.customerid = o.CustomerID 
    left outer join [order details] od on o.orderid = od.OrderID
    left outer join products p on p.productid = od.productid 
    left outer join categories cat on cat.categoryid = p.categoryid
group by c.companyname, c.phone
EXCEPT -- > pierwszy select zwraca wszystkich klientów, drugi select zwraca klientów, którzy kupowali produkty z kategorii confections. 
-- aby otrzymać listę osób, które NIE kupowały z kategorii confections, musimy odjąć wszystkich klientow od tych, którzy kupowali za pomocą EXCEPT
select c.companyname, c.phone
from customers c
    join orders o on c.customerid = o.CustomerID 
    join [order details] od on o.orderid = od.OrderID
    join products p on p.productid = od.productid 
    join categories cat on cat.categoryid = p.categoryid 
where cat.categoryname = 'Confections'

    -- ALBO
select c.companyname, c.phone
from customers c -- -> nie trzeba tych wszystkich joinow
EXCEPT
select c.companyname, c.phone
from customers c
    join orders o on c.customerid = o.CustomerID 
    join [order details] od on o.orderid = od.OrderID
    join products p on p.productid = od.productid 
    join categories cat on cat.categoryid = p.categoryid 
where cat.categoryname = 'Confections' and year(o.orderdate) = 1997


-- Wybierz nazwy i numery telefonów klientów, którzy w 1997r nie kupowali produktów z kategorii ‘Confectionsʼ
select distinct c.companyname, c.phone
from customers c
    left outer join orders o on c.customerid = o.CustomerID
    left outer join [order details] od on o.orderid = od.OrderID
    left outer join products p on p.productid = od.productid 
    left outer join categories cat on cat.categoryid = p.categoryid
EXCEPT
select distinct c.companyname, c.phone
from customers c
    join orders o on c.customerid = o.CustomerID 
    join [order details] od on o.orderid = od.OrderID
    join products p on p.productid = od.productid 
    join categories cat on cat.categoryid = p.categoryid 
where cat.categoryname = 'Confections' and year(o.orderdate) = 1997

    -- ALBO
select distinct o.customerid, c.companyname, c.phone
from orders o
     join [order details] od on o.orderid = od.OrderID  and year(o.orderdate) = 1997
     join products p on p.productid = od.productid 
	 join categories cat on cat.categoryid = p.categoryid and cat.categoryname = 'Confections' 
	 right join customers c on c.customerid = o.customerid
where o.orderid is null

-- napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza northwind)
select s.employeeid as [id pracownika], (s.firstname + ' ' + s.lastname) as pracownik, b.employeeid as [id przełożonego], (b.firstname + ' ' + b.lastname) as przełożony
from employees s
    inner join employees b on s.reportsto = b.EmployeeID

-- napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych (baza northwind)
select b.employeeid as [id przełożonego], (b.firstname + ' ' + b.lastname) as przełożony
from employees b
    left outer join employees s on s.reportsto = b.EmployeeID
where s.reportsto is null

-- napisz polecenie, które wyświetla pracowników, którzy mają podwładnych (baza  northwind)
select distinct b.employeeid as [id przełożonego], (b.firstname + ' ' + b.lastname) as przełożony
from employees b
    inner join employees s on s.reportsto = b.EmployeeID

--------------------------------------- LBRARY ----------------------------------------------------
use library
-- napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
select concat(m.firstname, ' ', m.lastname) as [imię i nazwisko dziecka], j.birth_date as [data urodzenia]
from member m 
    inner join juvenile j on m.member_no = j.member_no
where j.adult_member_no is not null

-- napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
select t.title as tytuł, t.title_no as nr, c.isbn as isbn, c.on_loan [czy wypożyczone]
from title t   
    inner join copy c on c.title_no = t.title_no
where c.on_loan = 'Y'

-- podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao Teh Kingʼ. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką 
--zapłacono karę
select lh.member_no as [numer czytelnika], (m.firstname +' '+ m.lastname) as [imię i nazwisko], 
    datediff(DAY,lh.in_date,lh.due_date) as [opóźnienie], -- -> datediff zwraca różnicę między datami: datediff(day/month/year, start date, end date)
    lh.fine_assessed as [nałożona kara], lh.fine_paid as [zapłacona kara] 
from loanhist lh  
    inner join title t on lh.title_no = t.title_no
    inner join loan l on l.title_no = t.title_no
    inner join member m on l.member_no = m.member_no
 where t.title like '%Tao Teh King%' and fine_assessed is not null and lh.due_date > lh.in_date

-- Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych przez osobę o nazwisku: Stephen A. Graff
select r.isbn as isbn, (m.firstname + ' ' + m.lastname) as [imię i nazywisko]
from reservation r 
    inner join member m on r.member_no = m.member_no
where m.firstname = 'Stephen' and m.lastname = 'Graff'

-- napisz polecenie, które podaje listę książek wypożyczonych przez osobę o nazwisku: William Graff
select distinct lh.isbn as [numer isbn], lh.member_no as [numer czytelnika], (m.firstname + ' ' + m.lastname) as [imię i nazywisko]
from loanhist lh 
    inner join copy c on lh.copy_no = c.copy_no
    inner join loan l on c.copy_no = l.copy_no
    inner join member m on l.member_no = m.member_no
where m.firstname = 'William' and m.lastname = 'Graff'

-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres zamieszkania
-- dziecka
select concat(m.firstname, ' ', m.lastname) as [imię i nazwisko], j.birth_date as [data urodzenia], concat(a.street, ', ', a.city, ', ', a.state, ', ', a.zip) as adres
from member m
    inner join juvenile j on m.member_no = j.member_no
    inner join adult a on j.adult_member_no = a.member_no

-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania
-- dziecka oraz imię i nazwisko rodzica.
select concat(m.firstname, ' ', m.lastname) as [imię i nazwisko], j.birth_date as [data urodzenia], concat(a.street, ', ', a.city, ', ', a.state, ', ', a.zip) as adres,
    concat(me.firstname, ' ', me.lastname) as [dane rodzica]
from member m
    inner join juvenile j on m.member_no = j.member_no
    inner join adult a on j.adult_member_no = a.member_no
    inner join member me on me.member_no = j.adult_member_no

-- podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają więcej niż dwoje dzieci zapisanych do biblioteki
select (m.firstname + ' ' + m.lastname) as rodzic, a.state as stan, count(j.member_no) [liczba dzieci]
from member m 
    inner join adult a on a.member_no = m.member_no
    inner join juvenile j on m.member_no = j.adult_member_no
where a.state = 'AZ'
group by m.firstname, m.lastname, a.state
    having count(j.member_no) > 2

-- podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni (CA) i
-- mają więcej niż troje dzieci zapisanych do biblioteki
select (m.firstname + ' ' + m.lastname) as rodzic, a.state as stan, count(j.member_no) [liczba dzieci]
from member m 
    inner join adult a on a.member_no = m.member_no
    inner join juvenile j on m.member_no = j.adult_member_no
where a.state = 'AZ'
group by m.firstname, m.lastname, a.state
    having count(j.member_no) > 2
UNION
select (m.firstname + ' ' + m.lastname) as rodzic, a.state as stan, count(j.member_no) [liczba dzieci]
from member m 
    inner join adult a on a.member_no = m.member_no
    inner join juvenile j on m.member_no = j.adult_member_no
where a.state = 'CA'
group by m.firstname, m.lastname, a.state
    having count(j.member_no) > 3
order by stan
-- ALBO
use library
select (m.firstname + ' ' + m.lastname) as rodzic, a.state as stan, count(j.member_no) [liczba dzieci]
from member m 
    inner join adult a on a.member_no = m.member_no
    inner join juvenile j on m.member_no = j.adult_member_no
group by m.firstname, m.lastname, a.state
    having (count(j.member_no) > 2 and state = 'AZ') or (count(j.member_no) > 3 and state = 'CA')
order by stan
