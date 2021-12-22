use Northwind
Select CategoryName,ProductName
From Products join Categories
              on Products.CategoryID = Categories.CategoryID

Select c.CategoryID,CategoryName,ProductName
From Products p inner join Categories c
				on p.CategoryID = c.CategoryID

 --join = inner join tabloları birleştirirken hangi tabloyu önce yazdığının bir önemi yok
Select OrderID,CategoryName,ProductName   
From Categories c join Products p
				  on c.CategoryID = p.CategoryID
				  join [Order Details] od
				  on od.ProductID = p.ProductID

----------------------SORULAR------------------------------------------------

--Ürünleri tedarik edildikleri firmalar ile listeleyin(Firma Adi | Ürü Adi)
Select s.CompanyName,p.ProductName
From Suppliers s join Products p on s.SupplierID = p.SupplierID

--Beverages kategorisine ait ürünleri stok miktarları ile listeleyin
Select p.ProductName,p.UnitsInStock,c.CategoryName
From Categories c join Products p on c.CategoryID=p.CategoryID
Where c.CategoryName ='Beverages'

--Hangi siparişi hangi çalışanım hangi müşteriye satmıştır(SiparişID,ÇalişanAdiSoyadi,SirketAdi
Select Concat(e.FirstName,' ',e.LastName) as FullName,o.OrderID,c.CompanyName
From Employees e join Orders o on e.EmployeeID = o.EmployeeID
				 join Customers c on o.CustomerID = c.CustomerID

--Her bir çalışanın toplam ne kadar satış yaptığını listeleyiniz(fiyat - adet - indirim)
Select Concat(e.FirstName,e.LastName)as FullName,sum(od.UnitPrice*od.Quantity*(1-od.Discount)) as Ciro
From Employees e join Orders o on e.EmployeeID = o.EmployeeID
				 join [Order Details] od on o.OrderID = od.OrderID
				 join Products p on od.ProductID=p.ProductID
Group by Concat(e.FirstName,e.LastName)
Order by FullName
	
--Janet bugüne kadar hangi ürünleri satmış
Select distinct  e.FirstName,e.LastName,p.ProductName
From Employees e join Orders o on e.EmployeeID = o.EmployeeID
				 join [Order Details] od on o.OrderID = od.OrderID
				 join Products p on od.ProductID=p.ProductID
Where e.FirstName = 'Janet'

--Ürün çeşidi olarak incelendiğinde en fazla ürün aldığımız 3 toptancıya toplam kaç çeşit ürün alındığı bilgisi ile birlikte listeleyiniz
Select Top 3 s.CompanyName,Count(p.ProductID) as UrunCesitAdedi
From Products p join Suppliers s on p.SupplierID = s.SupplierID
Group by s.CompanyName
Order by 2 desc
 
--Şirket adında a geçen müşterilerin vermiş olduğu Nancy Andrew ve Janet tarafından onaylanmış speedy express firması ile taşınmamış siparişlere ne kadar kargo ücreti ödenmiştir?
Select c.CompanyName,Sum(o.Freight) KargoUcreti
From Employees e join Orders o on e.EmployeeID = o.EmployeeID
				 join Customers c on c.CustomerID = o.CustomerID
				 join Shippers s on s.ShipperID = o.ShipVia
Where c.CompanyName like '%A%' and e.FirstName in('Nancy','Andrew','Janet') and s.CompanyName !='Speedy Express'
Group by c.CompanyName
Order by 2 desc

--ODEV---

--1996 yılında firmamızdan urun almış müsteriler kimlerdir?
Select distinct c.CompanyName
From Customers c join Orders o on c.CustomerID = o.CustomerID
Where o.OrderID is not null and year(o.OrderDate) = '1996'

--Stokta olmayan ve tedavülden kalkmış ürünlerin tedarikçilerinin telefon numaralarını listeleyiniz
Select s.Phone
From Products p  join Suppliers s on p.SupplierID = s.SupplierID
Where (p.UnitsInStock =0 or p.UnitsInStock is null) and  p.Discontinued = 'true'

--Taşınan siparişlerin hangi kargo firması ile taşındığını kargo firmasının ismi ile belirtiniz.
Select distinct S.CompanyName
From Shippers s  join Orders o on s.ShipperID = o.ShipVia
Where o.ShippedDate is not null

--İndirimli gönderdiğim siparişlerdeki ürün adlarını, birim fiyatını ve indirim tutarını gösterin
Select p.ProductName,od.Quantity,od.UnitPrice,od.Discount,(od.UnitPrice *od.Quantity*od.Discount) as DiscountValue
From [Order Details] od  join Products p on od.ProductID = p.ProductID
where od.Discount != 0

--Amerikali tedarikçilerden alinmis olan urunleri gosteriniz...
Select *
From Products p full join Suppliers s on p.SupplierID = s.SupplierID
Where s.Country = 'USA'

--Speedy Express ile tasinmis olan siparisleri gosteriniz...
Select o.OrderID,o.OrderDate
From Orders o  join Shippers s on o.ShipVia = s.ShipperID
Where s.CompanyName = 'Speedy Express'
Order by o.OrderID

--Siparislerimin hangi müsteriye ait oldugunu listeleyiniz. Raporda OrderID ve Müsteri isimleri ve kontakt kuracagim kisinin ismi listelensin. 
Select o.OrderID,c.CompanyName,c.ContactName
From Orders o full join Customers c on o.CustomerID = c.CustomerID

--Siparis kalemlerindeki  ürünlerimin isimleri ve kaçar adet siparis verildigindi OrderId leri ile listeleyiniz
Select od.OrderID,o.OrderDate,p.ProductName,p.UnitsOnOrder
From [Order Details] od join Products p on od.ProductID = p.ProductID
					    join Orders o on od.OrderID = o.OrderID
Where p.UnitsOnOrder !=0

--Territories tablosundaki bölge tanimlarinin hangi bölgeye ait olduklarini bölgelerin isimleri ile listeleyiniz.
Select distinct t.TerritoryDescription,r.RegionDescription
From Territories t full join Region r on t.RegionID = r.RegionID
Order by t.TerritoryDescription

--Chai ürününü tedarik ettigim tedarikçimin ismini, adresini ve telefon numarasini listeleyiniz
Select s.CompanyName,s.[Address],s.Phone
From Products p join Suppliers s on p.SupplierID = s.SupplierID
Where p.ProductName = 'Chai'
