USE [master]
GO
/****** Object:  Database [Cinema]    Script Date: 5/28/2023 5:29:26 PM ******/
CREATE DATABASE [Cinema]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Cinema', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.LONGVU\MSSQL\DATA\Cinema.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Cinema_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.LONGVU\MSSQL\DATA\Cinema_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Cinema] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Cinema].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Cinema] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Cinema] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Cinema] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Cinema] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Cinema] SET ARITHABORT OFF 
GO
ALTER DATABASE [Cinema] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Cinema] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Cinema] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Cinema] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Cinema] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Cinema] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Cinema] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Cinema] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Cinema] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Cinema] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Cinema] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Cinema] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Cinema] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Cinema] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Cinema] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Cinema] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Cinema] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Cinema] SET RECOVERY FULL 
GO
ALTER DATABASE [Cinema] SET  MULTI_USER 
GO
ALTER DATABASE [Cinema] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Cinema] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Cinema] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Cinema] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Cinema] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Cinema] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Cinema', N'ON'
GO
ALTER DATABASE [Cinema] SET QUERY_STORE = OFF
GO
USE [Cinema]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_AdminLogin]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_AdminLogin](@User_ID nvarchar(50), @Password nvarchar(50))
returns @table table (User_ID nvarchar(50), User_Name nvarchar(50), Admin_Role nvarchar(50))
begin
	insert into @table(User_ID, User_Name, Admin_Role)
	select A.User_ID, A.Name, Role
	from User_Information A inner join Admin B on A.User_ID = B.User_ID
	where A.User_ID = @User_ID and B.Password = @Password
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_BookedSeats]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_BookedSeats](@ShowTime_ID nvarchar(50))
returns @table table (Seat int)
begin
	insert into @table(Seat)
	select Seat 
	from Reservation A inner join ShowTime B on A.ShowTime_ID = B.ShowTime_ID 
	where A.ShowTime_ID = @ShowTime_ID
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CustomerLogin]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_CustomerLogin](@User_ID nvarchar(50), @Password nvarchar(50))
returns @table table (User_ID nvarchar(50), User_Name nvarchar(50), Balance int, Point int, isVip bit)
begin
	insert into @table(User_ID, User_Name, Balance, Point, isVip)
	select A.User_ID, A.Name, Balance, Point, isVip
	from User_Information A inner join Customer B on A.User_ID = B.User_ID
	where A.User_ID = @User_ID and B.Password = @Password
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_ShowTimeByActor]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_ShowTimeByActor](@Actor_Name nvarchar(50))
returns @table table (ShowTime_ID nvarchar(50), Movie_Title nvarchar(50), Total_Cost int, Main_Actor nvarchar(50), Director nvarchar(50), Date date, Start_Time time(7), End_Time time(7))
begin
	insert into @table(ShowTime_ID, Movie_Title, Total_Cost, Main_Actor, Director, Date, Start_Time, End_Time)
	select ShowTime_ID, Movie_Title, Total_Cost, Main_Actor, Director, Date, Start_Time, End_Time
	from ShowTime A inner join Movie B on A.Movie_ID = B.Movie_ID
	where B.Main_Actor = @Actor_Name and Date >= GETDATE()
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_ShowTimeByCompany]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_ShowTimeByCompany](@Company nvarchar(50))
returns @table table (ShowTime_ID nvarchar(50), Movie_Title nvarchar(50), Total_Cost int, Main_Actor nvarchar(50), Director nvarchar(50), Date date, Start_Time time(7), End_Time time(7))
begin
	insert into @table(ShowTime_ID, Movie_Title, Total_Cost, Main_Actor, Director, Date, Start_Time, End_Time)
	select ShowTime_ID, Movie_Title, Total_Cost, Main_Actor, Director, Date, Start_Time, End_Time
	from ShowTime A inner join Movie B on A.Movie_ID = B.Movie_ID inner join Company C on B.Company_ID = C.Company_ID
	where C.Name = @Company and Date >= GETDATE()
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_ShowTimeByScreen]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- In ra những phim theo độ phân giải màn hình
create   function [dbo].[Fn_ShowTimeByScreen](@Screen_Resolution nvarchar(50))
returns @table table (ShowTime_ID nvarchar(50), Movie_Title nvarchar(50), Total_Cost int, Main_Actor nvarchar(50), Director nvarchar(50), Date date, Start_Time time(7), End_Time time(7))
begin
	insert into @table(ShowTime_ID, Movie_Title, Total_Cost, Main_Actor, Director, Date, Start_Time, End_Time)
	select ShowTime_ID, Movie_Title, Total_Cost, Main_Actor, Director, Date, Start_Time, End_Time
	from (ShowTime A inner join Room B on A.Room_ID = B.Room_ID) inner join Movie C on A.Movie_ID = C.Movie_ID
	where A.Room_ID = B.Room_ID and B.Screen_Resolution = @Screen_Resolution and Date >= GETDATE()
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_SumTotalCost]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_SumTotalCost] (@ShowTime_ID nvarchar(50), @User_ID nvarchar(50), @Count int)
returns @table table (Total int)
begin
	declare @Total int
	declare @Total_Cost int
	declare @Point int

	select @Total_Cost = Total_Cost
	from ShowTime st
	where st.ShowTime_ID = @ShowTime_ID

	select @Point = Point
	from Customer cus
	where cus.User_ID = @User_ID

	if (@Point >= 100)
		set @Total = @Total_Cost * @Count * 0.8
	else if ((100 - @Point) / 10 >= @Count)
		set @Total = @Total_Cost * @Count
	else
		set @Total = ((100 - @Point) / 10) * @Total_Cost + (@Count - (100 - @Point) / 10) * @Total_Cost * 0.8
	insert into @table(Total)
	select @Total
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_UserBooked]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_UserBooked](@User_ID nvarchar(50))
returns @table table (Reservation_ID nvarchar(50), Movie_Title nvarchar(50), Seat int, Date date, Start_Time time(7), End_Time time(7), Room nvarchar(50))
begin
	insert into @table(Reservation_ID, Movie_Title, Seat, Date, Start_Time, End_Time, Room)
	select Reservation_ID, Movie_Title, Seat, Date, Start_Time, End_Time, Room_ID
	from Reservation A inner join ShowTime B on A.ShowTime_ID = B.ShowTime_ID inner join Movie C on B.Movie_ID = C.Movie_ID
	where A.User_ID = @User_ID
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_UserCommented]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Fn_UserCommented] (@ID nvarchar(50))
returns @table table (Reservation_ID nvarchar(50), Movie_Title nvarchar(50), Rating_Point int, Comment nvarchar(50))
begin
	insert into @table (Reservation_ID, Movie_Title, Rating_Point, Comment)
	select A.Reservation_ID, D.Movie_Title, A.Rating_Point, A.Comment
	from Review A join Reservation B
	on A.Reservation_ID = B.Reservation_ID
	join ShowTime C on B.ShowTime_ID = C.ShowTime_ID
	join Movie D on C.Movie_ID = D.Movie_ID
	where B.User_ID = @ID
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_UserInformation]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[Fn_UserInformation] (@ID nvarchar(50))
returns @table table(UserName nvarchar(50), Balance int, Point int, isVIP bit, Expense int)
begin
	declare @temp int
	select @temp = SUM(A.Paid)
	from Reservation A
	where A.User_ID = @ID
	Group by A.User_ID

	insert into @table(UserName, Balance, Point, isVIP, Expense)
	select B.Name, Balance, Point, isVIP, @temp as Expense
	from Customer A inner join User_Information B on A.User_ID = B.User_ID 
	where A.User_ID = @ID
	return
end
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[User_ID] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Balance] [int] NOT NULL,
	[Point] [int] NOT NULL,
	[isVIP] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_Information]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Information](
	[User_ID] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_User_Information] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_AllCustomers]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[View_AllCustomers] as
select A.User_ID, Name, Email, Address, Phone, Point, isVip
from Customer A inner join User_Information B on A.User_ID = B.User_ID
GO
/****** Object:  Table [dbo].[Admin]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admin](
	[User_ID] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Role] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_AllEmployees]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[View_AllEmployees] as
select A.User_ID, A.Name, A.Email, A.Address, A.Phone, B.Role
from User_Information A inner join Admin B on A.User_ID = B.User_ID
GO
/****** Object:  Table [dbo].[Movie]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movie](
	[Movie_ID] [nvarchar](50) NOT NULL,
	[Movie_Title] [nvarchar](50) NOT NULL,
	[Movie_Cost] [int] NOT NULL,
	[Runtime] [time](7) NOT NULL,
	[Main_Actor] [nvarchar](50) NOT NULL,
	[Director] [nvarchar](50) NOT NULL,
	[Company_ID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Movie] PRIMARY KEY CLUSTERED 
(
	[Movie_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShowTime]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShowTime](
	[ShowTime_ID] [nvarchar](50) NOT NULL,
	[Movie_ID] [nvarchar](50) NOT NULL,
	[Date] [date] NOT NULL,
	[Start_Time] [time](7) NOT NULL,
	[End_Time] [time](7) NULL,
	[Current_Seats] [int] NOT NULL,
	[Quality_Cost] [int] NULL,
	[Total_Cost] [int] NULL,
	[Room_ID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ShowTime] PRIMARY KEY CLUSTERED 
(
	[ShowTime_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation](
	[Reservation_ID] [int] NOT NULL,
	[User_ID] [nvarchar](50) NOT NULL,
	[ShowTime_ID] [nvarchar](50) NOT NULL,
	[Seat] [int] NOT NULL,
	[Paid] [int] NULL,
 CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED 
(
	[Reservation_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Review]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[Reservation_ID] [int] NOT NULL,
	[Rating_Point] [int] NOT NULL,
	[Comment] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_Comments]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[View_Comments] as
select Movie_Title, User_ID, Rating_Point, Comment
from Reservation re inner join Review rev on re.Reservation_ID = rev.Reservation_ID
inner join ShowTime st on re.ShowTime_ID = st.ShowTime_ID
inner join Movie mv on st.Movie_ID = mv.Movie_ID
GO
/****** Object:  View [dbo].[View_ShowingInDay]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[View_ShowingInDay] as
select st.ShowTime_ID, mv.Movie_Title, st.Total_Cost, mv.Main_Actor, mv.Director, st.Date, st.Start_Time, st.End_Time
from Movie mv
INNER JOIN ShowTime st ON mv.Movie_ID = st.Movie_ID
where st.Date = CONVERT(date, GETDATE())
GO
/****** Object:  View [dbo].[View_ComingShowing]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[View_ComingShowing] as
select st.ShowTime_ID, mv.Movie_Title, st.Total_Cost, mv.Main_Actor, mv.Director, st.Date, st.Start_Time, st.End_Time
from Movie mv
INNER JOIN ShowTime st ON mv.Movie_ID = st.Movie_ID
where st.Date > CONVERT(date, GETDATE());
GO
/****** Object:  View [dbo].[View_ClosedShowing]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[View_ClosedShowing] as
select st.ShowTime_ID, mv.Movie_Title, st.Total_Cost, mv.Main_Actor, mv.Director, st.Date, st.Start_Time, st.End_Time
from Movie mv
INNER JOIN ShowTime st ON mv.Movie_ID = st.Movie_ID
where st.Date <= CONVERT(date, GETDATE())
AND st.End_Time <= CONVERT(time, GETDATE());
GO
/****** Object:  Table [dbo].[Company]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[Company_ID] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[Company_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Room]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[Room_ID] [nvarchar](50) NOT NULL,
	[MaxSeats] [int] NOT NULL,
	[Screen_Resolution] [nvarchar](50) NOT NULL,
	[Audio_Quality] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[Room_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Admin] ([User_ID], [Password], [Role]) VALUES (N'admin', N'Q1', N'Manager')
INSERT [dbo].[Admin] ([User_ID], [Password], [Role]) VALUES (N'User2', N'hahaha', N'Employee')
INSERT [dbo].[Admin] ([User_ID], [Password], [Role]) VALUES (N'User3', N'whoareyou', N'Employee')
INSERT [dbo].[Admin] ([User_ID], [Password], [Role]) VALUES (N'User4', N'haoquangrucro', N'Employee')
INSERT [dbo].[Admin] ([User_ID], [Password], [Role]) VALUES (N'User5', N'culaoxacsong', N'Employee')
INSERT [dbo].[Admin] ([User_ID], [Password], [Role]) VALUES (N'User6', N'toiyeukhoahoc', N'Employee')
GO
INSERT [dbo].[Company] ([Company_ID], [Name], [Email], [Phone], [Address]) VALUES (N'CP1', N'Disney', N'disney@gmail.com', N'082351124', N'S1 VVN')
INSERT [dbo].[Company] ([Company_ID], [Name], [Email], [Phone], [Address]) VALUES (N'CP2', N'Marvel Studios', N'marvel@gmail.com', N'027141245', N'S2 VVN')
INSERT [dbo].[Company] ([Company_ID], [Name], [Email], [Phone], [Address]) VALUES (N'CP3', N'Warner Bros', N'warner@gmail.com', N'023572522', N'S3 VVN')
INSERT [dbo].[Company] ([Company_ID], [Name], [Email], [Phone], [Address]) VALUES (N'CP4', N'Universal Pictures', N'universal@gmail.com', N'023572352', N'S4 VVN')
INSERT [dbo].[Company] ([Company_ID], [Name], [Email], [Phone], [Address]) VALUES (N'CP5', N'Paramount Pictures', N'paramount@gmail.com', N'023571251', N'S5 VVN')
INSERT [dbo].[Company] ([Company_ID], [Name], [Email], [Phone], [Address]) VALUES (N'CP6', N'Galaxy', N'galaxy@gmail.com', N'023572352', N'S6 VVN')
INSERT [dbo].[Company] ([Company_ID], [Name], [Email], [Phone], [Address]) VALUES (N'CP7', N'Hahaha', N'heheh@gmail.com', N'082523512', N'S7 VVN')
GO
INSERT [dbo].[Customer] ([User_ID], [Password], [Balance], [Point], [isVIP]) VALUES (N'test', N'Q1', 4163155, 130, 1)
INSERT [dbo].[Customer] ([User_ID], [Password], [Balance], [Point], [isVIP]) VALUES (N'longvu', N'Q1', 380000, 30, 0)
INSERT [dbo].[Customer] ([User_ID], [Password], [Balance], [Point], [isVIP]) VALUES (N'lynkdoll0122', N'nhan1111', 100000, 0, 0)
GO
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M1', N'Cù Lao Xác Sống', 60000, CAST(N'01:30:00' AS Time), N'Chipu', N'Jack', N'CP1')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M10', N'The Super Mario Bros', 80000, CAST(N'02:30:00' AS Time), N'Mario', N'Aaron Horvath', N'CP4')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M11', N'The Saw 7', 60000, CAST(N'01:30:00' AS Time), N'Rolnado', N'Lệ Tổ', N'CP3')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M12', N'Tự Tình', 50000, CAST(N'01:30:00' AS Time), N'Linh Ka', N'Chipu', N'CP4')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M2', N'Hào Quang Rực Rỡ', 40000, CAST(N'02:00:00' AS Time), N'Trấn Thành', N'Đàm Vĩnh Hưng', N'CP2')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M3', N'End Games', 70000, CAST(N'02:30:00' AS Time), N'Robert', N'Anthony Russo', N'CP2')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M4', N'Mắt Biếc', 70000, CAST(N'02:00:00' AS Time), N'Ngạn Simp', N'Victor Vũ', N'CP6')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M5', N'Bố Già', 60000, CAST(N'02:30:00' AS Time), N'Trấn Thành', N'Trấn Thành', N'CP3')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M6', N'Lật Mặt 6', 70000, CAST(N'01:30:00' AS Time), N'Lý Hải', N'Lý Hải', N'CP4')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M7', N'Hai Phượng', 60000, CAST(N'02:00:00' AS Time), N'Ngô Thanh Vân', N'Lê Văn Kiệt', N'CP2')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M8', N'Em Và Trịnh', 60000, CAST(N'02:00:00' AS Time), N'Lan Thy', N'Phan Gia Nhật Linh', N'CP1')
INSERT [dbo].[Movie] ([Movie_ID], [Movie_Title], [Movie_Cost], [Runtime], [Main_Actor], [Director], [Company_ID]) VALUES (N'M9', N'Guardians Galaxy', 55000, CAST(N'02:30:00' AS Time), N'Đàm Vĩnh Hưng', N'James Gunn', N'CP2')
GO
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (1, N'test', N'ST1', 1, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (2, N'test', N'ST1', 2, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (3, N'test', N'ST1', 3, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (4, N'test', N'ST1', 4, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (5, N'test', N'ST1', 5, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (6, N'test', N'ST1', 6, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (7, N'longvu', N'ST2', 1, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (8, N'test', N'ST1', 8, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (9, N'test', N'ST2', 2, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (10, N'test', N'ST2', 3, 80000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (11, N'test', N'ST5', 1, 78000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (12, N'test', N'ST5', 2, 62400)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (13, N'test', N'ST7', 27, 56000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (14, N'test', N'ST7', 28, 56000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (15, N'longvu', N'ST7', 26, 70000)
INSERT [dbo].[Reservation] ([Reservation_ID], [User_ID], [ShowTime_ID], [Seat], [Paid]) VALUES (16, N'longvu', N'ST7', 25, 70000)
GO
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (1, 10, N'Siêu phẩm')
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (2, 9, N'Chán quá')
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (3, 8, N'Hehehe')
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (4, 10, N'Siêu phẩm')
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (7, 4, N'Dở ẹc')
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (8, 10, N'Gà')
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (10, 8, N'Hehehe')
INSERT [dbo].[Review] ([Reservation_ID], [Rating_Point], [Comment]) VALUES (16, 10, N'Siêu phẩm')
GO
INSERT [dbo].[Room] ([Room_ID], [MaxSeats], [Screen_Resolution], [Audio_Quality]) VALUES (N'R1', 28, N'8K', N'Excellent')
INSERT [dbo].[Room] ([Room_ID], [MaxSeats], [Screen_Resolution], [Audio_Quality]) VALUES (N'R2', 28, N'4K', N'Good')
INSERT [dbo].[Room] ([Room_ID], [MaxSeats], [Screen_Resolution], [Audio_Quality]) VALUES (N'R3', 28, N'2K', N'Good')
INSERT [dbo].[Room] ([Room_ID], [MaxSeats], [Screen_Resolution], [Audio_Quality]) VALUES (N'R4', 28, N'FullHD', N'Normal')
INSERT [dbo].[Room] ([Room_ID], [MaxSeats], [Screen_Resolution], [Audio_Quality]) VALUES (N'R5', 28, N'4K', N'Excellent')
INSERT [dbo].[Room] ([Room_ID], [MaxSeats], [Screen_Resolution], [Audio_Quality]) VALUES (N'R6', 28, N'2K', N'Good')
INSERT [dbo].[Room] ([Room_ID], [MaxSeats], [Screen_Resolution], [Audio_Quality]) VALUES (N'R7', 28, N'4K', N'Excellent')
GO
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST1', N'M1', CAST(N'2023-10-05' AS Date), CAST(N'12:30:00' AS Time), CAST(N'14:00:00' AS Time), 7, 20000, 80000, N'R1')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST10', N'M12', CAST(N'2024-05-05' AS Date), CAST(N'08:00:00' AS Time), CAST(N'09:30:00' AS Time), 0, 8000, 58000, N'R4')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST2', N'M1', CAST(N'2025-01-01' AS Date), CAST(N'12:30:00' AS Time), CAST(N'14:00:00' AS Time), 3, 20000, 80000, N'R1')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST3', N'M2', CAST(N'2023-05-10' AS Date), CAST(N'07:00:00' AS Time), CAST(N'09:00:00' AS Time), 0, 16000, 56000, N'R2')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST4', N'M3', CAST(N'2023-07-07' AS Date), CAST(N'08:30:00' AS Time), CAST(N'11:00:00' AS Time), 0, 10000, 80000, N'R3')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST5', N'M4', CAST(N'2023-10-05' AS Date), CAST(N'09:30:00' AS Time), CAST(N'11:30:00' AS Time), 2, 8000, 78000, N'R4')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST6', N'M5', CAST(N'2023-10-05' AS Date), CAST(N'11:30:00' AS Time), CAST(N'14:00:00' AS Time), 0, 16000, 76000, N'R5')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST7', N'M1', CAST(N'2025-01-01' AS Date), CAST(N'12:30:00' AS Time), CAST(N'14:00:00' AS Time), 4, 10000, 70000, N'R3')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST8', N'M3', CAST(N'2024-01-01' AS Date), CAST(N'07:00:00' AS Time), CAST(N'09:30:00' AS Time), 0, 16000, 86000, N'R5')
INSERT [dbo].[ShowTime] ([ShowTime_ID], [Movie_ID], [Date], [Start_Time], [End_Time], [Current_Seats], [Quality_Cost], [Total_Cost], [Room_ID]) VALUES (N'ST9', N'M10', CAST(N'2024-01-01' AS Date), CAST(N'07:00:00' AS Time), CAST(N'09:30:00' AS Time), 0, 8000, 88000, N'R4')
GO
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'admin', N'Đàm Vĩnh Hưng', N'tranthanh@gmail.com', N'Hào Quang Rực Rỡ', N'09999999')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'longvu', N'Hoàng Long Vũ', N'hoanglongvu@gmail.com', N'S1 VVN', N'09282352412')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'lynkdoll0122', N'Huu Nhan', N'nhanhouunhan', N'42', N'091230912')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'test', N'tester', N'test@gmail.com', N'S1 VVN', N'125812512')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'User2', N'Nguyễn Văn B', N'123@gmail.com', N'S1 VVN', N'09999999')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'User3', N'Nguyễn Văn C', N'123@gmail.com', N'S1 VVN', N'09999999')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'User4', N'Nguyễn Văn D', N'123@gmail.com', N'S1 VVN', N'09999999')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'User5', N'Nguyễn Văn E', N'123@gmail.com', N'S1 VVN', N'09999999')
INSERT [dbo].[User_Information] ([User_ID], [Name], [Email], [Address], [Phone]) VALUES (N'User6', N'Nguyễn Văn F', N'123@gmail.com', N'S1 VVN', N'09999999')
GO
ALTER TABLE [dbo].[ShowTime] ADD  CONSTRAINT [DF_ShowTime_Current_Seats]  DEFAULT ((0)) FOR [Current_Seats]
GO
ALTER TABLE [dbo].[Admin]  WITH CHECK ADD  CONSTRAINT [FK_Admin_User_Information] FOREIGN KEY([User_ID])
REFERENCES [dbo].[User_Information] ([User_ID])
GO
ALTER TABLE [dbo].[Admin] CHECK CONSTRAINT [FK_Admin_User_Information]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_User_Information] FOREIGN KEY([User_ID])
REFERENCES [dbo].[User_Information] ([User_ID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_User_Information]
GO
ALTER TABLE [dbo].[Movie]  WITH CHECK ADD  CONSTRAINT [FK_Movie_Company] FOREIGN KEY([Company_ID])
REFERENCES [dbo].[Company] ([Company_ID])
GO
ALTER TABLE [dbo].[Movie] CHECK CONSTRAINT [FK_Movie_Company]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_ShowTime] FOREIGN KEY([ShowTime_ID])
REFERENCES [dbo].[ShowTime] ([ShowTime_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_ShowTime]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_User_Information] FOREIGN KEY([User_ID])
REFERENCES [dbo].[User_Information] ([User_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_User_Information]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_Review_Reservation] FOREIGN KEY([Reservation_ID])
REFERENCES [dbo].[Reservation] ([Reservation_ID])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Reservation]
GO
ALTER TABLE [dbo].[ShowTime]  WITH CHECK ADD  CONSTRAINT [FK_ShowTime_Movie] FOREIGN KEY([Movie_ID])
REFERENCES [dbo].[Movie] ([Movie_ID])
GO
ALTER TABLE [dbo].[ShowTime] CHECK CONSTRAINT [FK_ShowTime_Movie]
GO
ALTER TABLE [dbo].[ShowTime]  WITH CHECK ADD  CONSTRAINT [FK_ShowTime_Room] FOREIGN KEY([Room_ID])
REFERENCES [dbo].[Room] ([Room_ID])
GO
ALTER TABLE [dbo].[ShowTime] CHECK CONSTRAINT [FK_ShowTime_Room]
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddNewCompany]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[Sp_AddNewCompany]
    @Company_ID NVARCHAR(50),
    @Name NVARCHAR(50),
    @Email NVARCHAR(50),
    @Phone NVARCHAR(50),
    @Address NVARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Company where Name = @Name)
    BEGIN
        RAISERROR ('Company already exists', 16, 1);
        RETURN;
    END
    INSERT INTO Company(Company_ID, Name, Email, Phone, Address)
    VALUES (@Company_ID, @Name, @Email, @Phone, @Address)   
END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddNewCustomer]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Sp_AddNewCustomer]
    @User_ID NVARCHAR(50),
    @Password NVARCHAR(50),
    @Name NVARCHAR(50),
    @Email NVARCHAR(50),
    @Address NVARCHAR(50),
    @Phone NVARCHAR(50)
As
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION;
    INSERT INTO User_Information(User_ID, Name, Email, Address, Phone)
    VALUES (@User_ID, @Name, @Email, @Address, @Phone);

     IF EXISTS (SELECT 1 FROM Customer WHERE User_ID = @User_ID)
    BEGIN
        RAISERROR ('User_ID already exists', 16, 1);
        RETURN;
    END

    INSERT INTO Customer(User_ID,Password, Balance, Point, isVIP)
    VALUES (@User_ID, @Password, 100000, 0, 0);
    COMMIT TRANSACTION;

END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddNewMovie]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Sp_AddNewMovie]
    @Movie_ID NVarchar(50),
    @Movie_Title NVARCHAR(50),
    @Movie_Cost INT,
    @Runtime TIME(7),
    @Main_Actor NVARCHAR(50),
    @Director NVARCHAR(50),
    @Company_ID Nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Movie WHERE Movie_Title = @Movie_Title)
    BEGIN
        RAISERROR ('Movie_Title already exists', 16, 1);
        RETURN;
    END

    INSERT INTO Movie (Movie_ID, Movie_Title, Movie_Cost, Runtime, Main_Actor, Director, Company_ID)
    VALUES (@Movie_ID, @Movie_Title, @Movie_Cost, @Runtime, @Main_Actor, @Director, @Company_ID);
    
END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddNewRoom]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[Sp_AddNewRoom]
    @Room_ID NVARCHAR(50),
	@MaxSeats INT,
    @Screen_Resolution NVARCHAR(50),
    @Audio_Quality NVARCHAR(50)
AS
BEGIN
    INSERT INTO Room (Room_ID, MaxSeats, Screen_Resolution, Audio_Quality)
    VALUES (@Room_ID, @MaxSeats, @Screen_Resolution, @Audio_Quality)   
END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddNewShowTime]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Sp_AddNewShowTime]
    @ShowTime_ID Nvarchar(50),
    @Movie_ID NVarchar(50),
    @Date DATE,
    @Start_Time TIME(7),
    @Room_ID NVarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    --Thêm thông tin ShowTime mới vào bảng ShowTime
    INSERT INTO ShowTime(ShowTime_ID, Movie_ID, Date, Start_Time, Room_ID)
    VALUES (@ShowTime_ID, @Movie_ID, @Date, @Start_Time, @Room_ID);

END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddOrUpdateComment]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Sp_AddOrUpdateComment]
    @Reservation_ID INT,
    @Rating_Point INT,
    @Comment NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem Reservation_ID đã tồn tại trong bảng Reservation hay chưa
     IF EXISTS (SELECT 1 FROM Review WHERE Reservation_ID = @Reservation_ID)
    BEGIN
        UPDATE Review
        SET Rating_Point = @Rating_Point,
            Comment = @Comment
        WHERE Reservation_ID = @Reservation_ID
    END
    ELSE
    BEGIN
        -- Nếu Reservation_ID chưa tồn tại, thêm mới bản ghi với Rating_Point và Comment truyền vào
        INSERT INTO Review(Reservation_ID, Rating_Point, Comment)
        VALUES (@Reservation_ID, @Rating_Point, @Comment)
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddReservation]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Sp_AddReservation]
@ID nvarchar(50), @ShowID nvarchar(50), @Seat int
as
begin
	declare @Maxstt int
	
	select @Maxstt = MAX(Reservation_ID)
	from Reservation

	if (@Maxstt is null)
		set @Maxstt = 0

	set @Maxstt = @Maxstt + 1

	INSERT INTO Reservation(Reservation_ID,User_ID,ShowTime_ID,Seat)
	VALUES(@Maxstt,@ID,@ShowID,@Seat)
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_DelReservation]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Sp_DelReservation]
@ID int
as
begin
	ALTER TABLE Review NOCHECK CONSTRAINT FK_Review_Reservation
	declare @flag nvarchar(50)
	set @flag = 'false'
	IF EXISTS (select * from Review where Reservation_ID = @ID)
	begin
		set @flag = 'true'
		delete from Review where Reservation_ID  = @ID
	end
	Declare @Temp1 int
	Declare @Temp2 int
	declare @max int;
	set @Temp1 = @ID
	set @Temp2 = @ID
	Delete from Reservation where Reservation_ID = @ID
	select @max = max(Reservation_ID) from Reservation
	while @Temp1 <= @max
		begin
			set @Temp2 = @Temp2 + 1
			if(@flag = 'true')
			begin
				update Review
				set Reservation_ID = @Temp1
				where Reservation_ID = @Temp2
			end

			update Reservation
			set Reservation_ID = @Temp1
			where Reservation_ID = @Temp2
			set @Temp1 = @Temp1 + 1
		end
	ALTER TABLE Review WITH CHECK CHECK CONSTRAINT FK_Review_Reservation
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateCompany]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[Sp_UpdateCompany]
	@Company_ID NVARCHAR(50),
    @Name NVARCHAR(50),
    @Email NVARCHAR(50),
    @Phone NVARCHAR(50),
    @Address NVARCHAR(50)
AS
BEGIN
    update Company
	set
    Name = @Name,
    Email = @Email,
    Phone = @Phone,
    Address = @Address
	where Company_ID = @Company_ID
END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateMovie]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[Sp_UpdateMovie]
	@Movie_ID NVarchar(50),
    @Movie_Title NVARCHAR(50),
    @Movie_Cost INT,
    @Runtime TIME(7),
    @Main_Actor NVARCHAR(50),
    @Director NVARCHAR(50),
    @Company_ID Nvarchar(50)
AS
BEGIN
    update Movie
	set
	Movie_Title = @Movie_Title,
    Movie_Cost = @Movie_Cost,
    Runtime = @Runtime,
    Main_Actor = @Main_Actor,
    Director = @Director,
    Company_ID = @Company_ID
	where Movie_ID = @Movie_ID
END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateRoom]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[Sp_UpdateRoom]
	@Room_ID NVARCHAR(50),
	@MaxSeats INT,
    @Screen_Resolution NVARCHAR(50),
    @Audio_Quality NVARCHAR(50)
AS
BEGIN
    update Room
	set
	MaxSeats = @MaxSeats,
    Screen_Resolution = @Screen_Resolution,
    Audio_Quality = @Audio_Quality
	where Room_ID = @Room_ID
END;
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateShowTime]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[Sp_UpdateShowTime] 
	@ShowTime_ID Nvarchar(50),
    @Movie_ID NVarchar(50),
    @Date DATE,
    @Start_Time TIME(7),
    @Room_ID NVarchar(50)
AS
BEGIN
    update ShowTime
	set
	Movie_ID = @Movie_ID,
	Date = @Date,
	Start_Time = @Start_Time,
	Room_ID = @Room_ID
	where ShowTime_ID = @ShowTime_ID
END;
GO
/****** Object:  Trigger [dbo].[Tr_PassAdmin]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Tr_PassAdmin] ON [dbo].[Admin]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @password NVARCHAR(50);
	DECLARE @has_uppercase BIT;
	DECLARE @has_number BIT;
    
	SELECT @password = password FROM inserted;
	SELECT @has_uppercase = PATINDEX('%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%', @password);
	SELECT @has_number = PATINDEX('%[0-9]%', @password);
    
	IF (@has_uppercase > 0 AND @has_number > 0)
	BEGIN
		RETURN;
	END
	ELSE
	BEGIN
		RAISERROR ('Password must contain at least one uppercase letter and one number', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;

-- Kiểm tra customer có đủ điều kiện thành VIP hay không
GO
ALTER TABLE [dbo].[Admin] ENABLE TRIGGER [Tr_PassAdmin]
GO
/****** Object:  Trigger [dbo].[Tr_PassCustomer]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Tr_PassCustomer] ON [dbo].[Customer]
FOR INSERT
AS
BEGIN
	DECLARE @password NVARCHAR(50);
	DECLARE @has_uppercase BIT;
	DECLARE @has_number BIT;
    
	SELECT @password = password FROM inserted;
	SELECT @has_uppercase = PATINDEX('%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%', @password);
	SELECT @has_number = PATINDEX('%[0-9]%', @password);
    
	IF (@has_uppercase > 0 AND @has_number > 0)
	BEGIN
		RETURN;
	END
	ELSE
	BEGIN
		RAISERROR ('Password must contain at least one uppercase letter and one number', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;
GO
ALTER TABLE [dbo].[Customer] ENABLE TRIGGER [Tr_PassCustomer]
GO
/****** Object:  Trigger [dbo].[Tr_CheckBalance]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[Tr_CheckBalance] ON [dbo].[Reservation]
FOR INSERT 
AS
BEGIN	
	DECLARE @customer_balance int
	DECLARE @isVIP bit
	DECLARE @cost int

	SELECT @customer_balance = C.Balance, @cost = st.Total_Cost, @isVIP = C.isVIP
	FROM Customer C, inserted i, ShowTime st
	WHERE st.ShowTime_ID = i.ShowTime_ID and C.User_ID = i.User_ID

	if (@isVIP = 1)
		set @cost = @cost * 0.8
	IF(@customer_balance < @cost)
	BEGIN
		ROLLBACK TRANSACTION
		PRINT 'Account balance is not enough, please check again'
	END
END
GO
ALTER TABLE [dbo].[Reservation] ENABLE TRIGGER [Tr_CheckBalance]
GO
/****** Object:  Trigger [dbo].[Tr_DecreaseBalance]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[Tr_DecreaseBalance] ON [dbo].[Reservation]
AFTER INSERT
AS
BEGIN
    -- Start transaction
    BEGIN TRANSACTION

	declare @isVip bit
	declare @cost int
	declare @Reservation_ID int

	select @cost = A.Total_Cost, @Reservation_ID = Reservation_ID
	from ShowTime A inner join inserted B on A.ShowTime_ID = B.ShowTime_ID

	select @isVip = A.isVip
	from Customer A inner join inserted B on A.User_ID = B.User_ID

	if (@isVip = 1)
		set @cost = @cost * 0.8

	update Reservation
	set Paid = @cost
	where Reservation_ID = @Reservation_ID
    -- tinh gia tien cua reservation
    DECLARE @reservation_cost int;
    SET @reservation_cost = @cost

    -- giam tien balance voi user tuong ung
    UPDATE Customer
    SET Balance = Balance - @reservation_cost
    WHERE User_ID IN (
        SELECT User_ID
        FROM inserted
    );

    -- Commit transaction
    COMMIT TRANSACTION
END;
GO
ALTER TABLE [dbo].[Reservation] ENABLE TRIGGER [Tr_DecreaseBalance]
GO
/****** Object:  Trigger [dbo].[Tr_DecreaseSeats]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[Tr_DecreaseSeats] ON [dbo].[Reservation]
AFTER DELETE
AS
BEGIN
    UPDATE ShowTime 
    SET Current_Seats = Current_Seats - 1
    FROM deleted d
    WHERE ShowTime.ShowTime_ID = d.ShowTime_ID;
END;
GO
ALTER TABLE [dbo].[Reservation] ENABLE TRIGGER [Tr_DecreaseSeats]
GO
/****** Object:  Trigger [dbo].[Tr_IncreaseBalance]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[Tr_IncreaseBalance] ON [dbo].[Reservation]
AFTER DELETE
AS
BEGIN
    DECLARE @reservation_cost int;
    SELECT @reservation_cost = Paid
    FROM deleted;

    UPDATE Customer
    SET Balance = Balance + @reservation_cost
    WHERE User_ID IN (
        SELECT User_ID
        FROM deleted
    );
END;
GO
ALTER TABLE [dbo].[Reservation] ENABLE TRIGGER [Tr_IncreaseBalance]
GO
/****** Object:  Trigger [dbo].[Tr_IncreaseSeats]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[Tr_IncreaseSeats] ON [dbo].[Reservation]
AFTER INSERT
AS
BEGIN
    UPDATE ShowTime 
    SET Current_Seats = Current_Seats + 1
    FROM inserted i
    WHERE ShowTime.ShowTime_ID = i.ShowTime_ID;
END;
GO
ALTER TABLE [dbo].[Reservation] ENABLE TRIGGER [Tr_IncreaseSeats]
GO
/****** Object:  Trigger [dbo].[Tr_Point]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   trigger [dbo].[Tr_Point] on [dbo].[Reservation]
for insert, delete
as
begin
	begin transaction
	declare @User_ID nvarchar(50)

	select @User_ID = A.User_ID
	from inserted A

	update Customer
	set Point = Point + 10
	where User_ID = @User_ID

	declare @User_ID_Delete nvarchar(50)

	select @User_ID_Delete = A.User_ID
	from deleted A

	update Customer
	set Point = Point - 10
	where User_ID = @User_ID_Delete
	commit transaction
end
GO
ALTER TABLE [dbo].[Reservation] ENABLE TRIGGER [Tr_Point]
GO
/****** Object:  Trigger [dbo].[Tr_VIP]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   trigger [dbo].[Tr_VIP] on [dbo].[Reservation]
for insert, delete
as
begin
	declare @User_ID nvarchar(50)
	declare @Point int
	declare @isVip bit
	declare @User_ID_Del nvarchar(50)
	declare @Point_Del int
	declare @isVip_Del bit

	select @User_ID = A.User_ID
	from inserted A

	select @Point = A.Point, @isVip = A.isVIP
	from Customer A
	where A.User_ID = @User_ID

	select @User_ID_Del = A.User_ID
	from deleted A

	select @Point = A.Point, @isVip = A.isVIP
	from Customer A
	where A.User_ID = @User_ID_Del

	if (@Point >= 100 and @isVip = 0)
		begin
			update Customer
			set isVIP = 1
			where User_ID = @User_ID
		end
	else if (@Point <= 100 and @isVip = 1)
		begin
			update Customer
			set isVIP = 0
			where User_ID = @User_ID_Del
		end
end
GO
ALTER TABLE [dbo].[Reservation] ENABLE TRIGGER [Tr_VIP]
GO
/****** Object:  Trigger [dbo].[Tr_CalculateTimeCost]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   trigger [dbo].[Tr_CalculateTimeCost] on [dbo].[ShowTime]
for insert, update
as
begin
	declare @LEN time(7)
	declare @ID nvarchar(50)

	select @LEN = B.Runtime, @ID = A.ShowTime_ID
	from inserted A inner join Movie B
	on A.Movie_ID = B.Movie_ID

	update ShowTime
	set End_Time =cast(DATEADD(SECOND,datediff(second,0,@LEN),Start_Time)as time(7))
	where ShowTime_ID = @ID

	declare @Quality_Cost int
	declare @Screen_Resolution nvarchar(50)

	select @Screen_Resolution = r.Screen_Resolution
	FROM ShowTime s
    INNER JOIN Room r ON s.Room_ID = r.room_id
    INNER JOIN inserted i ON s.ShowTime_id = i.ShowTime_id

    SET @Quality_Cost = 
        CASE @Screen_Resolution 
            WHEN '8K' THEN 20000
            WHEN '4K' THEN 16000
            WHEN '2K' THEN 10000
            ELSE 8000
        END

    UPDATE ShowTime
    SET Total_Cost = @Quality_Cost + Movie.Movie_Cost, Quality_Cost = @Quality_Cost
    FROM ShowTime
    INNER JOIN Movie ON ShowTime.Movie_ID = Movie.Movie_ID
    INNER JOIN inserted i ON ShowTime.ShowTime_ID = i.ShowTime_ID
END
GO
ALTER TABLE [dbo].[ShowTime] ENABLE TRIGGER [Tr_CalculateTimeCost]
GO
/****** Object:  Trigger [dbo].[Tr_CheckDate]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[Tr_CheckDate]
ON [dbo].[ShowTime]
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @current_date DATETIME;
    SET @current_date = GETDATE();
	IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN ShowTime s
        ON i.Room_ID = s.Room_ID AND i.Date = s.Date
        WHERE i.ShowTime_ID	 <> s.ShowTime_ID
        AND ((i.Start_Time BETWEEN s.Start_Time AND s.End_Time)
             OR (i.End_Time BETWEEN s.Start_Time AND s.End_Time)
             OR (i.Start_Time <= s.Start_Time AND i.End_Time >= s.End_Time))
    )
    BEGIN
        RAISERROR ('The start time and end time must not overlap with existing showtimes!', 16, 1);
        ROLLBACK TRANSACTION;
    END
    IF EXISTS (
        SELECT 1 FROM inserted WHERE [Date] < @current_date
    )
    BEGIN
        RAISERROR ('The date must be greater than or equal to the current date!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
ALTER TABLE [dbo].[ShowTime] ENABLE TRIGGER [Tr_CheckDate]
GO
/****** Object:  Trigger [dbo].[Tr_UserIDCheck]    Script Date: 5/28/2023 5:29:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[Tr_UserIDCheck] ON [dbo].[User_Information]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @NoSpecial BIT;
	set @NoSpecial = 0

	IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE User_ID LIKE '%[%!@#$^&*(){}|~`\\/:;?+]%' OR User_ID LIKE '% %'
    )
    BEGIN
		set @NoSpecial = 1
    END
    
	IF (@NoSpecial != 1)
	BEGIN
		RETURN;
	END
	ELSE
	BEGIN
		RAISERROR ('User_ID must not contain space or special character', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;
GO
ALTER TABLE [dbo].[User_Information] ENABLE TRIGGER [Tr_UserIDCheck]
GO
USE [master]
GO
ALTER DATABASE [Cinema] SET  READ_WRITE 
GO
