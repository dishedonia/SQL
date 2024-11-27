use library
-- 1.1 Napisz polecenie select za pomocą którego uzyskasz identyfikator/numer tytułu oraz tytuł książki
select title_no, title
from title
order by title

-- 1.2 napisz polecenie, które wybiera tytuł o numerze/identyfikatorze 10
select title_no, title
from title
    where title_no = 10

-- 1.3 napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i autora dla wszystkich książek, których autorem jest Charles Dickens lub Jane Austen
select title_no, author
from title
    where author in ('Charles Dickens', 'Jane Austen')
-- where author  like '%dickens%'or author like '%austen%' -> alternatywa
order by author

-- 2.1 napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich książek, których tytuły zawierających słowo 'adventure'
select title_no, title
from title
    where title like '%adventure%'

-- 2.2 Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę dla wszystkich książek, tore zostały zwrócone w listopadzie 2001
select member_no, fine_assessed, fine_paid 
from loanhist
    where month(out_date) = 11 
        and year(out_date) = 2001 
        and fine_assessed is not null 
        and fine_paid > 0

-- wariant: suma kar zapłaconych przez czytelnika w tym okresie
select member_no, sum(fine_paid) as [fine total]
from loanhist
    where month(out_date) = 11 and year(out_date) = 2001 
group by member_no, fine_assessed
    having sum(fine_paid) is not null

-- 2.3 napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy adult .
-- 1) wariant concat
select distinct concat(city, ', ', state) 
from adult
-- 2) wariant bez
select distinct city, state 
from adult
order by city

-- 2.4  Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w porządku alfabetycznym.
select title
from title
order by title

-- 3.1 napisz polecenie, które wybiera numer członka biblioteki ( member_no ), isbn książki ( isbn ) i wartość naliczonej kary (fine_assessed) z tablicy loanhist dla wszystkich wypożyczeń/zwrotów, dla których naliczono karę (wartość nie NULL w kolumnie fine_assessed )
select member_no, isbn as [isbn książki], fine_assessed
from loanhist
    where fine_assessed is not null
--group by member_no, isbn, fine_assessed
order by [isbn książki]

-- 3.2 o 3.3 zmodyfikuj poprzedni kod: stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny fine_assessed, stwórz alias tej kolumny
select member_no, isbn as [isbn książki], fine_assessed, fine_assessed * 2 as double_fine
from loanhist
    where fine_assessed is not null
--group by member_no, isbn, fine_assessed
order by [isbn książki]

-- 3.4 zmodyfikuj poprzedni kod: stwórz kolumnę o nazwie diff , zawierającą różnicę wartości w kolumnach double_fine i fine_assessed jest większa niż 3
-- 1) wariant 1
select member_no, isbn as [isbn książki], fine_assessed, fine_assessed * 2 as double_fine, fine_assessed * 2 - fine_assessed as diff
from loanhist
    where fine_assessed is not null and fine_assessed * 2 - fine_assessed > 3
--group by member_no, isbn, fine_assessed
order by diff
-- 2) wariant 2
select member_no, isbn, fine_assessed, 
    case  
        when fine_assessed is not null then fine_assessed*2  
        end double_fine, 
    case  
        when fine_assessed*2 - fine_assessed > 3 then fine_assessed*2 - fine_assessed 
        end diff 
from loanhist 
    where fine_assessed*2 - fine_assessed > 3
order by diff

-- 4.1 napisz polecenie, które generuje pojedynczą kolumnę, która zawiera kolumny: firstname (imię członka biblioteki), middleinitial (inicjał drugiego imienia) i lastname (nazwisko) z tablicy member dla wszystkich członków biblioteki, którzy nazywają się Anderson
select member_no, concat(firstname, middleinitial, lastname) as email_name
from member
    where lastname like '%Anderson%'
order by email_name

-- 4.2 zmodyfikuj polecenie, tak by zwróciło 'listę proponowanych loginów e-mail' utworzonych przez połączenie imienia członka biblioteki, z inicjałem drugiego imienia pierwszymi dwoma literami nazwiska (wszystko małymi małymi literami). wykorzystaj funkcję SUBSTRING do uzyskania części kolumny znakowej oraz LOWER do zwrócenia wyniku małymi literami. wykorzystaj operator (+) do połączenia napisów.
select member_no, lower(replace(firstname,' ','') + middleinitial + substring(lastname, 1,2)) as [lista proponowanych adresów email] -- -> replace, żeby uniknąć spacji w nazwie
from member
    where lastname like '%anderson%'
order by [lista proponowanych adresów email]

-- 5 Napisz polecenie, które wybiera title i title_no z tablicy title . wynikiem powinna być pojedyncza kolumna o formacie jak w przykładzie poniżej:
-- The title is: Poems, title number 7
-- czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o wyrażenie, które łączy 4 elementy:
-- stała znakowa ‘The title is:ʼ
-- wartość kolumny title
-- stała znakowa ‘title numberʼ
-- wartość kolumny title_no
select concat('The title is: ', title, ', title number '+ cast(title_no as varchar)) as Tytuł
from title