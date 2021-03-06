USE [db_ErrorWatch]
GO
/****** Object:  DatabaseRole [Admin]    Script Date: 1/11/2021 4:20:24 PM ******/
CREATE ROLE [Admin]
GO
/****** Object:  DatabaseRole [Employee]    Script Date: 1/11/2021 4:20:24 PM ******/
CREATE ROLE [Employee]
GO
/****** Object:  UserDefinedFunction [dbo].[f_thu]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_thu] (@ngay datetime)
returns nvarchar(10)
as
begin
declare @st nvarchar(10)
select @st=case datepart(dw,@ngay)
when 1 then N'chủ nhật'
when 2 then N'thứ hai'
when 3 then N'thứ ba'
when 4 then N'thứ tư'
when 5 then N'thứ năm'
when 6 then N'thứ sáu'
else N'thứ bảy'
end
return (@st) 
end
GO
/****** Object:  UserDefinedFunction [dbo].[timkiem_theten]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[timkiem_theten]
 (@giatri nvarchar(50))
 returns @ben table (Product_ID int,Product_Name nvarchar(100),Price float,Size int,Gender int, image nvarchar(max),desciption nvarchar(max),inventory_Number int, Manufacturer_ID int, Status bit,Created_date datetime,Updated_date datetime)

 as
 begin
 
 insert into @ben
 select Product_ID,Product_Name,Price,Size,Gender,image,desciption,inventory_Number,Manufacturer_ID,Status,Created_date,Updated_date
 from Products
 where Product_Name like '%'+@giatri+'%' 
 return
 end
GO
/****** Object:  UserDefinedFunction [dbo].[UF_Quantity_Of_Manufacturer]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[UF_Quantity_Of_Manufacturer]()

returns @kq table ( ProductName nvarchar(100),ManufacturerName nvarchar(100), Quantity int)
as
BEGIN
insert into @kq
	select  Products.Product_Name ,Manufacturers.Manufacturer_Name,Products.Inventory_Number
	from Products, Manufacturers
	where Products.Manufacturer_ID = Manufacturers.Manufacturer_ID
return
end
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderDetail_ID] [int] IDENTITY(1,1) NOT NULL,
	[Order_ID] [int] NULL,
	[Product_ID] [int] NULL,
	[Quantity] [int] NULL,
	[Created_date] [datetime] NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderDetail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_FullName] [nvarchar](100) NULL,
	[User_Name] [nvarchar](100) NULL,
	[User_Password] [nvarchar](100) NULL,
	[Email] [nvarchar](max) NULL,
	[Phone] [nvarchar](50) NULL,
	[Address] [nvarchar](max) NULL,
	[Avatar] [nvarchar](max) NULL,
	[Role] [int] NULL,
	[DayCreated] [datetime] NULL,
	[DayUpdated] [datetime] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Order_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Employee_ID] [int] NULL,
	[Note] [nvarchar](max) NULL,
	[Total] [float] NULL,
	[Status] [bit] NULL,
	[Created_date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Order_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[v9]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v9]
as
select Top(3) Users.User_ID,Users.User_FullName,Email,Phone, Sum(Quantity) as N'Số lượng' from Users inner join Orders on  
Users.User_ID = Orders.User_ID inner join OrderDetails on Orders.Order_ID = OrderDetails.Order_ID 
and Orders.Status = 'True' and Orders.Total > 100000000 group by Users.User_ID, Users.User_FullName, Email, Phone 
GO
/****** Object:  View [dbo].[statistic1]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[statistic1]
as
select Top(3) Users.User_ID,Users.User_FullName,Email,Phone, Sum(Quantity) as N'Số lượng', Total from Users inner join Orders on  
Users.User_ID = Orders.User_ID inner join OrderDetails on Orders.Order_ID = OrderDetails.Order_ID 
and Orders.Status = 'True' and Orders.Total > 100000000 group by Users.User_ID, Users.User_FullName, Email, Phone,Total order by Total desc
GO
/****** Object:  Table [dbo].[Products]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Product_ID] [int] IDENTITY(1,1) NOT NULL,
	[Product_Name] [nvarchar](100) NULL,
	[Price] [float] NULL,
	[Size] [int] NULL,
	[Gender] [int] NULL,
	[Image] [nvarchar](max) NULL,
	[Desciption] [nvarchar](max) NULL,
	[Inventory_Number] [int] NULL,
	[Manufacturer_ID] [int] NULL,
	[Status] [bit] NULL,
	[Created_date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Product_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[wth]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[wth] (masp,tensp,gia,tongtien)
as
select Products.Product_ID,Products.Product_Name,Products.Price,Products.Price*OrderDetails.Quantity
from Products,OrderDetails,Orders
where (Products.Product_ID=OrderDetails.Product_ID) and (OrderDetails.Order_ID=Orders.Order_ID)  and Quantity=(select MAX(Quantity) from OrderDetails) and (month(GETDATE())=month( Orders.Created_date))
GO
/****** Object:  View [dbo].[sellingProduct]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[sellingProduct] (masp,tensp,gia,tongtien)
as
select Products.Product_ID,Products.Product_Name,Products.Price,Products.Price*OrderDetails.Quantity
from Products,OrderDetails,Orders
where (Products.Product_ID=OrderDetails.Product_ID) and (OrderDetails.Order_ID=Orders.Order_ID)  and Quantity=(select MAX(Quantity) from OrderDetails) and (month(GETDATE())=month( Orders.Created_date))
GO
/****** Object:  View [dbo].[RenvenueForTheMonth]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[RenvenueForTheMonth]
as
select sum(Orders.Total) as N'Tổng doanh thu' from Orders ,OrderDetails 
where Orders.Order_ID = OrderDetails.Order_ID
and month(Orders.Created_date) = month(GETDATE()) and Status = 'True'
GO
/****** Object:  View [dbo].[v_chitietdonhang]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_chitietdonhang]
as
select distinct Orders.Order_ID,Products.Product_Name,OrderDetails.Quantity,Products.Price,Orders.Total,  Users.User_FullName 
from (((Orders
join OrderDetails on Orders.Order_ID= OrderDetails.Order_ID)
join Products on OrderDetails.Product_ID = Products.Product_ID)
join Users on Orders.User_ID = Users.User_ID)
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[Employee_ID] [int] IDENTITY(1,1) NOT NULL,
	[Employee_FullName] [nvarchar](100) NULL,
	[Email] [nvarchar](max) NULL,
	[Phone] [nvarchar](50) NULL,
	[Address] [nvarchar](max) NULL,
	[Avatar] [nvarchar](max) NULL,
	[Salary] [float] NULL,
	[DayCreated] [datetime] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_Users_Employee]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[V_Users_Employee]
as
select Orders.Order_ID, Users.User_FullName as N'Khách hàng', Employees.Employee_FullName as N'Nhân viên'
from ((Orders
join Users on  Orders.User_ID = Users.User_ID)
join Employees on Orders.Employee_ID = Employees.Employee_ID)
GO
/****** Object:  UserDefinedFunction [dbo].[UF_remaining_amount_Inventory]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[UF_remaining_amount_Inventory] (@ProductName nvarchar(max))
returns table
as 
	return(
	select (Products.Inventory_Number - OrderDetails.Quantity) as N'số lượng còn lại trong kho'
	from Products,OrderDetails
	where Products.Product_ID = OrderDetails.Product_ID and Products.Product_Name = @ProductName) 
GO
/****** Object:  View [dbo].[viewuser]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[viewuser] (User_ID,User_FullName,so_hoa_don,tongtien)
as
select Users.User_ID,User_FullName,COUNT(Orders.Order_ID),SUM(Orders.Total)
from Users,Orders
where (Users.User_ID=Orders.User_ID)  
and (Total=(select MAX(Total) from Orders)) 
and (month(GETDATE())=month( Orders.Created_date))
group by Users.User_ID,User_FullName
GO
/****** Object:  UserDefinedFunction [dbo].[RevenuePerEmployee]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[RevenuePerEmployee] (@name nvarchar(20))
returns table
as
	return (select distinct Employees.Employee_ID,Employees.Employee_FullName,
	sum(Orders.Total) as N'Total' 
	from Orders,Employees,OrderDetails 
	where Employees.Employee_ID = Orders.Employee_ID
	and OrderDetails.Order_ID = Orders.Order_ID 
	and Employees.Employee_FullName = @name and Orders.Status = 'True' 
	and month(Orders.Created_date) = month(GETDATE()) and Employees.Status = 'True'
	group by Employees.Employee_ID,Employees.Employee_FullName)
GO
/****** Object:  Table [dbo].[Carts]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carts](
	[Cart_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Product_ID] [int] NULL,
	[Quantity] [int] NULL,
	[Total] [float] NULL,
 CONSTRAINT [PK_Carts] PRIMARY KEY CLUSTERED 
(
	[Cart_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Manufacturers]    Script Date: 1/11/2021 4:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manufacturers](
	[Manufacturer_ID] [int] IDENTITY(1,1) NOT NULL,
	[Manufacturer_Name] [nvarchar](100) NULL,
	[Status] [bit] NULL,
	[Created_date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
 CONSTRAINT [PK_Manufacturers] PRIMARY KEY CLUSTERED 
(
	[Manufacturer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Carts] ON 

INSERT [dbo].[Carts] ([Cart_ID], [User_ID], [Product_ID], [Quantity], [Total]) VALUES (1, 6, 4, 1, 108901900)
INSERT [dbo].[Carts] ([Cart_ID], [User_ID], [Product_ID], [Quantity], [Total]) VALUES (2, 7, 5, 1, 102000000)
INSERT [dbo].[Carts] ([Cart_ID], [User_ID], [Product_ID], [Quantity], [Total]) VALUES (3, 11, 1, 1, 873000000)
SET IDENTITY_INSERT [dbo].[Carts] OFF
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([Employee_ID], [Employee_FullName], [Email], [Phone], [Address], [Avatar], [Salary], [DayCreated], [Status]) VALUES (1, N'Vũ Hoàng Nghĩa', N'vu.hoang.nghia@gmail.com', N'0348544392', N'Hà Nội', NULL, 8000000, CAST(N'2021-01-02T04:21:58.967' AS DateTime), 1)
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FullName], [Email], [Phone], [Address], [Avatar], [Salary], [DayCreated], [Status]) VALUES (2, N'Nguyễn Quốc Tỉnh', N'nguyen.quoc.tinh@gmail.com', N'0909876543', N'Hà Đông', NULL, 8000000, CAST(N'2021-01-02T04:22:12.573' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Employees] OFF
SET IDENTITY_INSERT [dbo].[Manufacturers] ON 

INSERT [dbo].[Manufacturers] ([Manufacturer_ID], [Manufacturer_Name], [Status], [Created_date], [Updated_date]) VALUES (1, N'Rolex', 1, CAST(N'2021-01-02T04:09:43.323' AS DateTime), NULL)
INSERT [dbo].[Manufacturers] ([Manufacturer_ID], [Manufacturer_Name], [Status], [Created_date], [Updated_date]) VALUES (2, N'Omega', 1, CAST(N'2021-01-02T04:09:48.483' AS DateTime), NULL)
INSERT [dbo].[Manufacturers] ([Manufacturer_ID], [Manufacturer_Name], [Status], [Created_date], [Updated_date]) VALUES (3, N'Seiko', 1, CAST(N'2021-01-02T04:10:27.660' AS DateTime), NULL)
INSERT [dbo].[Manufacturers] ([Manufacturer_ID], [Manufacturer_Name], [Status], [Created_date], [Updated_date]) VALUES (4, N'Timex', 1, CAST(N'2021-01-02T04:10:36.623' AS DateTime), NULL)
INSERT [dbo].[Manufacturers] ([Manufacturer_ID], [Manufacturer_Name], [Status], [Created_date], [Updated_date]) VALUES (5, N'Movado', 1, CAST(N'2021-01-02T04:10:47.290' AS DateTime), NULL)
INSERT [dbo].[Manufacturers] ([Manufacturer_ID], [Manufacturer_Name], [Status], [Created_date], [Updated_date]) VALUES (6, N'Hublot', 1, CAST(N'2021-01-02T04:11:04.993' AS DateTime), NULL)
INSERT [dbo].[Manufacturers] ([Manufacturer_ID], [Manufacturer_Name], [Status], [Created_date], [Updated_date]) VALUES (7, N'Tissot', 1, CAST(N'2021-01-02T04:11:15.260' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Manufacturers] OFF
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 

INSERT [dbo].[OrderDetails] ([OrderDetail_ID], [Order_ID], [Product_ID], [Quantity], [Created_date]) VALUES (1, 1, 1, 4, CAST(N'2021-01-02T04:31:20.667' AS DateTime))
INSERT [dbo].[OrderDetails] ([OrderDetail_ID], [Order_ID], [Product_ID], [Quantity], [Created_date]) VALUES (3, 3, 6, 3, CAST(N'2020-12-02T04:35:39.717' AS DateTime))
INSERT [dbo].[OrderDetails] ([OrderDetail_ID], [Order_ID], [Product_ID], [Quantity], [Created_date]) VALUES (4, 4, 4, 40, CAST(N'2021-01-04T21:15:01.880' AS DateTime))
INSERT [dbo].[OrderDetails] ([OrderDetail_ID], [Order_ID], [Product_ID], [Quantity], [Created_date]) VALUES (5, 5, 4, 5, CAST(N'2021-01-05T04:59:11.547' AS DateTime))
INSERT [dbo].[OrderDetails] ([OrderDetail_ID], [Order_ID], [Product_ID], [Quantity], [Created_date]) VALUES (6, 6, 3, 2, CAST(N'2021-01-09T10:56:02.787' AS DateTime))
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Order_ID], [User_ID], [Employee_ID], [Note], [Total], [Status], [Created_date], [Updated_date]) VALUES (1, 4, 1, N'Giao hàng nhanh giúp mình nhé', 3492000000, 1, CAST(N'2021-01-02T04:31:08.800' AS DateTime), NULL)
INSERT [dbo].[Orders] ([Order_ID], [User_ID], [Employee_ID], [Note], [Total], [Status], [Created_date], [Updated_date]) VALUES (3, 5, 2, N'Shop phục vụ tận tình mong giao hàng nhanh', 3600000000, 1, CAST(N'2020-12-02T04:35:26.043' AS DateTime), NULL)
INSERT [dbo].[Orders] ([Order_ID], [User_ID], [Employee_ID], [Note], [Total], [Status], [Created_date], [Updated_date]) VALUES (4, 6, 2, N'Giao hàng đúng hẹn nhé', 4356076000, 1, CAST(N'2021-01-04T21:13:31.130' AS DateTime), NULL)
INSERT [dbo].[Orders] ([Order_ID], [User_ID], [Employee_ID], [Note], [Total], [Status], [Created_date], [Updated_date]) VALUES (5, 7, 1, N'Shop phục vụ tốt mong sản phẩm cũng vậy', 544509500, 1, CAST(N'2021-01-05T04:58:06.833' AS DateTime), NULL)
INSERT [dbo].[Orders] ([Order_ID], [User_ID], [Employee_ID], [Note], [Total], [Status], [Created_date], [Updated_date]) VALUES (6, 8, 1, N'Mong chờ sản phẩm ', 222615000, 1, CAST(N'2021-01-09T10:55:13.937' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Orders] OFF
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Product_ID], [Product_Name], [Price], [Size], [Gender], [Image], [Desciption], [Inventory_Number], [Manufacturer_ID], [Status], [Created_date], [Updated_date]) VALUES (1, N'Đồng hồ Rolex Day Date 40mm 228235 Olive Green Dial Everose Gold', 873000000, 1, 1, N'rolex1.jpg', N'Hãng sản xuất: Rolex
Tình trạng :mới
Đồng hồ : Nam
Bộ sưu tập:Day Date II President
Serial No. : 228235 
Kích thước: 40 mm
Chất liệu thân đồng hồ: vàng hồng 18k
Bezel: vàng hồng 18k
Chức năng hiển thị: Giờ, Phút, Giây,Ngày
Loại máy: Automatic
Loại dây đeo: vàng hồng 18k
Mặt quay số: màu xanh
Khả năng chống nước: 100m', 26, 1, 1, CAST(N'2021-01-02T04:13:34.340' AS DateTime), NULL)
INSERT [dbo].[Products] ([Product_ID], [Product_Name], [Price], [Size], [Gender], [Image], [Desciption], [Inventory_Number], [Manufacturer_ID], [Status], [Created_date], [Updated_date]) VALUES (2, N'Đồng hồ Rolex Oyster Perpetual 40mm 228238 Yellow Gold Mặt Đen Cọc Số Kim Cương', 1030000000, 1, 1, N'rolex2.jpg', N'VỎ ĐỒNG HỒ
Oyster, 40 mm, vàng vàng
CẤU TRÚC OYSTER
Vỏ chính đơn khối, nút vặn nắp lưng và nút chỉnh lên dây
ĐƯỜNG KÍNH
40 mm
CHẤT LIỆU
vàng vàng 18 ct
VÀNH ĐỒNG HỒ
Rãnh
NÚT VẶN LÊN DÂY
Xoắn vít, hệ thống chống thấm nước 2 tầng Twinlock
MẶT KÍNH ĐỒNG HỒ
Ngọc bích chống trầy xước, ống kính cyclops trên hiển thị số ngày
CHỐNG THẤM NƯỚC
Khả năng chống thấm nước lên đến mức 100m/330 feet
BỘ CHUYỂN ĐỘNG
Perpetual, máy cơ, tự lên dây
CALIBRE
3255, Nhà sản xuất Rolex
ĐỘ CHÍNH XÁC
-2/+2 giây/ngày, sau khi lắp đặt hoàn chỉnh
CHỨC NĂNG
Kim giờ, kim phút, kim giây chính, hiển thị ngày và thứ tại màn hình phụ, tùy chỉnh nhanh không giới hạn. Cơ chế ngừng chỉnh để điều chỉnh thời gian chính xác
BỘ DAO ĐỘNG
Dây tóc xanh Parachrom thuận từ. Công nghệ Paraflex chống sốc cao
SỰ LÊN DÂY
Tự lên dây cót 2 chiều qua Perpetual rotor
DỰ TRỮ NĂNG LƯỢNG
Xấp xỉ 70 tiếng
DÂY ĐEO
President, mối nối 3 mảnh bán vòm
CHẤT LIỆU DÂY ĐEO
Vàng vàng 18 ct
KHÓA
Khóa vặn gập ẩn Crownclasp
MẶT SỐ
Bộ màu đen nạm kim cương
BỘ CHẠM NGỌC
10 viên kim cương hình khối chữ nhật
CHỨNG NHẬN
Độ chuẩn xác ưu việt (chứng nhận COSC + Rolex sau khi lắp đặt hoàn chỉnh)', 12, 1, 1, CAST(N'2021-01-02T04:14:09.207' AS DateTime), NULL)
INSERT [dbo].[Products] ([Product_ID], [Product_Name], [Price], [Size], [Gender], [Image], [Desciption], [Inventory_Number], [Manufacturer_ID], [Status], [Created_date], [Updated_date]) VALUES (3, N'Đồng hồ OMEGA DEVILLE PRESTIGE 424.12.33.20.55.001 WATCH 32.7MM', 111307500, 2, 0, N'omega1.jpg', N'The OMEGA De Ville Prestige “Butterfly” is a timepiece of true beauty that draws on the enchantment and aesthetics of nature.
This model features a white pearled mother-of-pearl dial with a unique polished butterfly pattern enhanced by a transferred outline against a matt background. There are eight diamond indexes and a date window at 6 o''clock.
The 32.7 mm stainless steel case is presented on a white satin-brushed leather strap. At the heart of this De Ville Prestige "Butterfly" is the Co-Axial calibre 2500.
Crystal: Domed, scratch-resistant sapphire crystal with anti-reflective treatment inside
Case: Steel
Dial colour: White
Water resistance: 3 bar (30 metres / 100 feet)
Case Diameter: 32.7 mm
Between Lugs: 16 mm
Self-winding chronometer, Co-Axial escapement movement with rhodium-plated finish.
Power reserve: 48 hours
Type: Self winding', 17, 2, 1, CAST(N'2021-01-02T04:14:52.353' AS DateTime), NULL)
INSERT [dbo].[Products] ([Product_ID], [Product_Name], [Price], [Size], [Gender], [Image], [Desciption], [Inventory_Number], [Manufacturer_ID], [Status], [Created_date], [Updated_date]) VALUES (4, N'Đồng hồ OMEGA DE VILLE 424.22.33.60.52.001 PRESTIGE WATCH 32.7MM', 108901900, 2, 0, N'omega2.jpg', N'DESCRIPTION
The OMEGA De Ville Prestige “Butterfly” is a timepiece of true beauty that draws on the enchantment and aesthetics of nature.
 
This model features a silvery diamond-set dial with a unique butterfly pattern achieved using a ramolayage, or "pounced ornament", technique. The 18K red gold bezel is mounted on a 32.7 mm stainless steel casebody and presented on a white satin-brushed leather strap. At the heart of this De Ville Prestige "Butterfly" is the OMEGA quartz calibre 4061.
 
All OMEGA watches are delivered with a 5-year warranty that covers the repair of any material or manufacturing defects. Please refer to the operating instructions for specific information about the warranty conditions and restrictions.
 
FEATURES
Diamonds
 
TECHNICAL DATA
Between lugs: 16 mm
Bracelet: leather strap
Case: Steel ‑ red gold
Case diameter: 32.7 mm
Dial colour: Silver
Crystal: Domed, scratch‑resistant sapphire crystal with anti‑reflective treatment inside
Water resistance: 3 bar (30 metres / 100 feet)
 
MOVEMENT
Calibre: Omega 4061
Quartz movement with "Long Life" feature to maximize the autonomy of the battery. Exclusive red Omega logo with rhodium plated parts and circular graining.
Battery life: 48 months
Type: Quartz', 56, 2, 1, CAST(N'2021-01-02T04:15:06.150' AS DateTime), NULL)
INSERT [dbo].[Products] ([Product_ID], [Product_Name], [Price], [Size], [Gender], [Image], [Desciption], [Inventory_Number], [Manufacturer_ID], [Status], [Created_date], [Updated_date]) VALUES (5, N'Đồng Hồ Nam Dây Kim Loại Movado 0606115 (38mm) - Mặt Đen', 102000000, 1, 1, N'movado1.jpg', N'Dây thép không gỉ sáng bóng, bền chắc
Mặt kính Sapphire chống trầy xước, độ cứng cao
Mặt đồng hồ đơn giản hóa vạch chia giờ, điểm nhấn 12h độc quyền
Khung viền bằng thép không gỉ siêu bền
Chống thấm nước 3 Bar hiểu quả, thoải mái sinh hoạt hằng ngày
Đồng Hồ Nam Dây Kim Loại Movado 0606115 (38mm) - Mặt Đen với sự đơn giản trong thiết kế, không quá cầu kỳ chi tiết, nhưng từng đường nét đều có thể cảm nhận được sự mềm mại, chính là truyền thống trong xu hướng thiết kế của đồng hồ Movado và cũng là phong cách độc nhất của thương hiệu.
Với biểu tượng xác định thời trang luôn đi theo motif chấm tròn ở vị trí 12h tượng trưng cho mặt trời vào lúc giữa trưa là  vẻ đẹp thuần khiết đến tuyệt vời. Sự truyền thống trong xu hướng thiết kế này đã được thương hiệu đăng ký độc quyền.
Chất lượng, độ bền là những yếu tố đã tạo nên danh tiếng cho đồng hồ Movado, do đó tất cả những phiên bản đồng hồ khi xuất xưởng đều phải trải qua những quy trình đánh giá, kiểm định chất lượng sản phẩm để đảm bảo chất lượng hàng đầu.
Để tạo nên sự sang trọng, quý giá trong những phiên bản đồng hồ Movado, hãng sản xuất đã sử dụng những chất liệu quý giá, có độ bền vượt trội, sử dụng xuyên suốt thời gian mà không bị hư hao.
Đồng hồ thu hút những tín đồ thời trang qua chính thiết kế đơn giản ở từng chi tiết nhỏ tuy nhiên vẫn không làm mất đi vẻ sang trọng, quý phái, thuần khiết. Người đeo có thể tự cảm nhận được sự tinh tế trong từng sản phẩm Movado.
Giá sản phẩm trên Tiki đã bao gồm thuế theo luật hiện hành. Tuy nhiên tuỳ vào từng loại sản phẩm hoặc phương thức, địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như phí vận chuyển, phụ phí hàng cồng kềnh, ...', 28, 5, 1, CAST(N'2021-01-02T04:17:15.000' AS DateTime), NULL)
INSERT [dbo].[Products] ([Product_ID], [Product_Name], [Price], [Size], [Gender], [Image], [Desciption], [Inventory_Number], [Manufacturer_ID], [Status], [Created_date], [Updated_date]) VALUES (6, N'Đồng hồ MOVADO 0606875 – NAM – KÍNH SAPPHIRE – AUTOMATIC – DÂY DA', 1200000000, 1, 1, N'movado2.jpg', N'Đồng hồ Movado 0606875 có thiết kế cổ điển khi mặt số tròn kết hợp với dây đeo da cao cấp màu đen mạnh mẽ, kim chỉ và vạch số được mạ vàng nổi bật trên nền số màu đen có họa tiết độc đáo như hình tượng mặt trời tỏa sáng, có ô lịch ngày vị trí 6h tinh tế.', 46, 5, 1, CAST(N'2021-01-02T04:17:52.303' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Products] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (1, N'Nguyễn Văn Mạnh', N'Admin', N'Error', N'i.am.error.7777@gmail.com', N'0358511226', N'Hà Nội', N'nvm.error.jpg', 2, CAST(N'2021-01-02T04:19:21.510' AS DateTime), NULL, 1)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (2, N'Vũ Hoàng Nghĩa', N'Employee1', N'123', N'v.hoang.nghia@gmail.com', N'0348544392', N'Hà Nội', NULL, 1, CAST(N'2021-01-02T04:20:21.167' AS DateTime), NULL, 1)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (3, N'Nguyễn Quốc Tỉnh', N'Employee2', N'123', N'Ng.Quoc.Tinh@gmail.com', N'0912345678', N'Hà Đông', NULL, 1, CAST(N'2021-01-02T04:20:57.303' AS DateTime), NULL, 1)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (4, N'Vũ Minh Hiếu', N'User1', N'123', N'vmh@gmail.com', N'0356711257', N'Hà Nội', NULL, 0, CAST(N'2021-01-02T04:23:22.760' AS DateTime), NULL, 0)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (5, N'Nguyễn Cao Hoàng Vương', N'User2', N'123', N'nchv@gmail.com', N'0354857126', N'Hà Nội', NULL, 0, CAST(N'2021-01-02T04:24:28.497' AS DateTime), NULL, 0)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (6, N'Trần Thị Thu Huyền', N'User3', N'123', N'ttth@gmail.com', N'0358476849', N'Sài Gòn', NULL, 0, CAST(N'2021-01-02T04:25:24.533' AS DateTime), NULL, 1)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (7, N'Nguyễn Phương Anh', N'User4', N'123', N'npa@gmail.com', N'0936846277', N'Hà Giang', NULL, 0, CAST(N'2021-01-02T04:26:08.080' AS DateTime), NULL, 1)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (8, N'Error Nguyen', N'User5', N'123', N'en@gmail.com', N'0347691483', N'New York', NULL, 0, CAST(N'2021-01-02T18:30:01.610' AS DateTime), NULL, 0)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (10, N'Nguyễn Đức Thắng', N'User6', N'123', N'm@gmail.com', N'0358511226', N'Error', NULL, 0, CAST(N'2021-01-04T00:34:17.823' AS DateTime), NULL, 0)
INSERT [dbo].[Users] ([User_ID], [User_FullName], [User_Name], [User_Password], [Email], [Phone], [Address], [Avatar], [Role], [DayCreated], [DayUpdated], [Status]) VALUES (11, N'Nguyễn Văn Hải', N'User7', N'123', N'nvh@gmail.com', N'0358511226', N'Hà Nội', NULL, 0, CAST(N'2021-01-04T00:36:20.420' AS DateTime), NULL, 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [DF_Employees_DayCreated]  DEFAULT (getdate()) FOR [DayCreated]
GO
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [DF_Employees_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Manufacturers] ADD  CONSTRAINT [DF_Manufacturers_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Manufacturers] ADD  CONSTRAINT [DF_Manufacturers_Created_date]  DEFAULT (getdate()) FOR [Created_date]
GO
ALTER TABLE [dbo].[OrderDetails] ADD  CONSTRAINT [DF_OrderDetails_Created_date_1]  DEFAULT (getdate()) FOR [Created_date]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Created_date_1]  DEFAULT (getdate()) FOR [Created_date]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Status_1]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Created_date_1]  DEFAULT (getdate()) FOR [Created_date]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Role]  DEFAULT ((0)) FOR [Role]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_DayCreated]  DEFAULT (getdate()) FOR [DayCreated]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD  CONSTRAINT [FK_Carts_Products] FOREIGN KEY([Product_ID])
REFERENCES [dbo].[Products] ([Product_ID])
GO
ALTER TABLE [dbo].[Carts] CHECK CONSTRAINT [FK_Carts_Products]
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD  CONSTRAINT [FK_Carts_Users] FOREIGN KEY([User_ID])
REFERENCES [dbo].[Users] ([User_ID])
GO
ALTER TABLE [dbo].[Carts] CHECK CONSTRAINT [FK_Carts_Users]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([Order_ID])
REFERENCES [dbo].[Orders] ([Order_ID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY([Product_ID])
REFERENCES [dbo].[Products] ([Product_ID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Products]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Employees] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employees] ([Employee_ID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Employees]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Users] FOREIGN KEY([User_ID])
REFERENCES [dbo].[Users] ([User_ID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Users]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Manufacturers] FOREIGN KEY([Manufacturer_ID])
REFERENCES [dbo].[Manufacturers] ([Manufacturer_ID])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Manufacturers]
GO
/****** Object:  StoredProcedure [dbo].[insert_product]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insert_product] 
(@name_P nvarchar(50), @price float, @size int, @gender int, @description nvarchar(255), @inventory_number int, @manu int, @status bit)
as
begin 
	insert into Products (Product_Name, Price, Size, Gender, Desciption, Inventory_Number, Manufacturer_ID, Status) values (@name_P, @Price, @Size, @Gender, @description, @Inventory_Number, @manu, @Status)
end 
GO
/****** Object:  StoredProcedure [dbo].[RevenueSelectTime]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[RevenueSelectTime]
@timeStart varchar(20),
@timeEnd varchar(20)
as
Begin
	if( @timeStart <= @timeEnd)
		begin
			select sum(Orders.Total)
			from OrderDetails,Orders  
			where OrderDetails.Order_ID = Orders.Order_ID and Orders.Status = 'True' and
			Orders.Created_date >= @timeStart and
			Orders.Created_date <= @timeEnd
		end
	else
		print N'Lỗi thời gian bắt đầu và kết thúc'
end
GO
/****** Object:  StoredProcedure [dbo].[RevenueSelectTimeAndProduct]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[RevenueSelectTimeAndProduct]
@timeStart nvarchar(500),
@timeEnd nvarchar(500),
@productName nvarchar(500)
as
Begin
	if(@timeStart <= @timeEnd)
		begin
			select sum(Products.Price*OrderDetails.Quantity) as N'Tổng doanh thu của sản phẩm'
			from OrderDetails, Orders, Products  
			where OrderDetails.Order_ID = Orders.Order_ID 
			and Orders.Created_date >= @timeStart 
			and Orders.Created_date <= @timeEnd
			and OrderDetails.Product_ID = Products.Product_ID
			and Products.Product_Name = @productName
			and Products.Status = 'True'
			and Orders.Status  = 'True' 
		end
	else
		print N'Lỗi thời gian bắt đầu hoặc kết thúc hoặc sản phẩm không tồn tại'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dashboard]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_dashboard]
(@sumUsers int output, @sumCarts int output, @sumOrders int output, @sumMoneys float output)
as
begin
select @sumUsers = count(User_ID) from Users
select @sumCarts = count(Cart_ID) from Carts
select @sumMoneys = sum(Total) from Orders
if(datename(dw,getdate())='Monday')
begin
select @sumOrders= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=0)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Tuesday')
begin
select @sumOrders= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=1)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Wednesday')
begin
select @sumOrders= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=2)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Thursday')
begin
select @sumOrders= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=3)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Friday')
begin
select @sumOrders= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=4)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Saturday')
begin
select @sumOrders= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=5)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Sunday')
begin
select @sumOrders= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=6)and(month(GETDATE())=month(Created_date))
end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dashboardindex]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_dashboardindex]
(@sumUserIndex int output, @sumCartIndex int output, @sumOrderIndex int output, @sumMoneyIndex float output)
as
begin
select @sumUserIndex = count(User_ID) from Users
select @sumCartIndex = count(Cart_ID) from Carts
select @sumMoneyIndex = sum(Total)/23000 from Orders
if(datename(dw,getdate())='Monday')
begin
select @sumOrderIndex= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=0)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Tuesday')
begin
select @sumOrderIndex= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=1)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Wednesday')
begin
select @sumOrderIndex= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=2)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Thursday')
begin
select @sumOrderIndex= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=3)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Friday')
begin
select @sumOrderIndex= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=4)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Saturday')
begin
select @sumOrderIndex= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=5)and(month(GETDATE())=month(Created_date))
end
else
if(datename(dw,getdate())='Sunday')
begin
select @sumOrderIndex= COUNT( Order_ID)
from Orders
where (DAY(GETDATE())-DAY(Created_date)>=0)and(DAY(GETDATE())-DAY(Created_date)<=6)and(month(GETDATE())=month(Created_date))
end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_search_User]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_search_User]
@userName nvarchar(20) = NULL
AS
Begin
	SELECT * FROM Users WHERE (@userName IS NULL OR User_Name LIKE '%' + @userName + '%')
end
GO
/****** Object:  StoredProcedure [dbo].[testosp4]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[testosp4]
@timeStart datetime,
@timeEnd datetime
as
Begin
	if( @timeStart <= @timeEnd)
		begin
			select Products.Product_Name 
			from Products where Product_ID in 
			(select OrderDetails.Product_ID from OrderDetails 
			where OrderDetails.Order_ID in 
			(select Orders.Order_ID from Orders
			where Orders.Status = 'True' and
			Orders.Created_date >= @timeStart and
			Orders.Created_date <= @timeEnd))
		end
	else
		print N'Lỗi thời gian bắt đầu và kết thúc'
end
GO
/****** Object:  StoredProcedure [dbo].[UnsoIdProducts]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UnsoIdProducts]
@timeStart varchar(20),
@timeEnd varchar(20)
as
Begin
	if( @timeStart <= @timeEnd)
		begin
			select Products.Product_ID,Products.Product_Name, Products.Price,Products.Inventory_Number 
			from Products where Product_ID not in 
			(select OrderDetails.Product_ID from OrderDetails 
			where OrderDetails.Order_ID in 
			(select Orders.Order_ID from Orders
			where Orders.Status = 'True' and
			Orders.Created_date >= @timeStart and
			Orders.Created_date <= @timeEnd))
		end
	else
		print N'Lỗi thời gian bắt đầu và kết thúc'
end
GO
/****** Object:  StoredProcedure [dbo].[UnsoldProducts]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UnsoldProducts]
@timeStart datetime,
@timeEnd datetime
as
Begin
	if( @timeStart <= @timeEnd)
		begin
			select Products.Product_ID,Products.Product_Name, 
			Products.Price,Products.Inventory_Number  
			from Products where Product_ID not in 
			(select OrderDetails.Product_ID from OrderDetails 
			where OrderDetails.Order_ID in 
			(select Orders.Order_ID from Orders
			where Orders.Status = 'True' and
			Orders.Created_date >= @timeStart and
			Orders.Created_date <= @timeEnd))
		end
	else
		print N'Lỗi thời gian bắt đầu và kết thúc'
end
GO
/****** Object:  StoredProcedure [dbo].[USP_SortTotalPrice]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[USP_SortTotalPrice] 
as
begin
	select  Users.User_ID ,Users.User_FullName ,Orders.Total 
	from ((Orders 
	join OrderDetails on Orders.Order_ID = OrderDetails.Order_ID)
	join Users on Orders.User_ID = Users.User_ID) 
	order by Orders.Total Desc
end
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateProfile]    Script Date: 1/11/2021 4:20:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[USP_UpdateProfile](@Fullname nvarchar(50), @UserName nvarchar(50), @UserPassword nvarchar(50), @Email nvarchar(max),@Phone nvarchar(30),@Address nvarchar(50),@Role int, @Status bit, @UserId int)
as
update Users
set User_FullName = @Fullname, User_Name= @UserName, User_Password= @UserPassword, Email = @Email, Phone=@Phone , Address = @Address,Role=@Role, Status = @Status
where User_ID = @UserId
GO
