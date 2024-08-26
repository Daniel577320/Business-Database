CREATE DATABASE RobbertBusdiens

ON
(	
	NAME = RobertBusdiens,
	FILENAME = 'C:\DBD_281\RobertBusdiens.mdf',
	SIZE = 20MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
)

LOG ON
(
	NAME = RBLogFile1,
	FILENAME = 'C:\DBD_281\RBLogFile.ldf',
	SIZE = 5MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10MB
)

--This section creates the login for the user
-------------------------------------------------------------
GO
	CREATE LOGIN rbuser
	WITH PASSWORD = 'rblogin'  --mixed authentication password is the same

--This section creates all the tables of the database
--------------------------------------------------------------
GO
	CREATE TABLE Clients
	(
		ClientID						INT			PRIMARY KEY,	 
		BusinessName			NVARCHAR(30)		NOT NULL,
		Province				NVARCHAR(30),
		Streek					NVARCHAR(30),
		PhoneNum_1				NVARCHAR(13),
		PhoneNum_2				NVARCHAR(13),
		PhoneNum_3				NVARCHAR(13),
		Fax_1					NVARCHAR(20),						
		Fax_2					NVARCHAR(20),
		Fax_3					NVARCHAR(20),
		Email					NVARCHAR(40),
		Address					NVARCHAR(40)
	)

	CREATE TABLE TripType
	(
		TripTypeID				INT					PRIMARY KEY,	
		TripName				NVARCHAR(80)		NOT NULL,		
		DescriptionOfTrip		NVARCHAR(80)
	)

	CREATE TABLE Destination
	(
		DestinationID			INT					PRIMARY KEY,	
		DestinationName			NVARCHAR(50)		NOT NULL,
		Area					NVARCHAR(30),						
		Distance				INT					NOT NULL
	)

	CREATE TABLE Quotation
	(
		BusTripID				INT					PRIMARY KEY,	
		ClientID				INT					FOREIGN KEY REFERENCES Clients(ClientID),						
		ContactPerson			NVARCHAR(30)		NOT NULL,						
		ContactNumber			NVARCHAR(13),
		TripTypeID				INT					FOREIGN KEY REFERENCES TripType(TripTypeID),
		StartDate				DATE,
		StartTime				TIME(7)				NOT NULL,
		EndDate					DATE,
		EndTime					TIME(7)				NOT NULL,
		TotalPickUpPoints		INT,								
		StartingPoint			NVARCHAR(30),						
		DestinationID			INT					FOREIGN KEY REFERENCES Destination(DestinationID),
		Accept					BIT					DEFAULT 0,		--This is to show whether or not the client has accepted the quotation
		Amount					INT
	
	)

	CREATE TABLE Busses
	(
		BusID					INT					PRIMARY KEY,	
		RegNo					NVARCHAR(8)			NOT NULL,
		BusName					NVARCHAR(30)		NOT NULL,
		Serviced				DATE,								
		KM						INT					NOT NULL,
		TotalPeople				INT					NOT NULL,
		LicenseRenew			DATE,
		Permit					DATE,							
	)
	
	CREATE TABLE Drivers
	(
		DriverID				INT					PRIMARY KEY,	
		Name					NVARCHAR(30)		NOT NULL,
		Surname					NVARCHAR(30)		NOT NULL,
		ID						NVARCHAR(13),
		Gender					NVARCHAR(10),
		LicenseRenew			DATE								
	)

	CREATE TABLE DestinationReport
	(
		DestinationID			INT					FOREIGN KEY REFERENCES Destination(DestinationID),	
		Report					NVARCHAR(40)						
	)

	CREATE TABLE BusType
	(
		BusTypeID				INT					PRIMARY KEY,	
		TotalPeople				INT					NOT NULL,
		BusTripID				INT					FOREIGN KEY REFERENCES Quotation(BusTripID),								
		Cost					INT,								
		BusID					INT 				FOREIGN KEY REFERENCES Busses(BusID),
		DriverID				INT					FOREIGN KEY REFERENCES Drivers(DriverID),
		Accept					BIT					DEFAULT 0		--Whether or no the quotation got accepted
	)	

--This section implements all the sample data to populate the database
----------------------------------------------------------------------

GO
	INSERT INTO Clients
	VALUES
		(0001, 'BoysHigh', 'Gauteng', 'Pretoria', '072 236 8765', '083 018 2165', NULL,'076-012-1921', NULL, NULL, 'info@boyshigh.co.za', '83 Pine Ave' ),
		(0002, 'GirlsHigh', 'North West', 'Brits', '0820499871', '083 903 0313', '073 151 8903', '021-874-0092', NULL, NULL, 'info@girlshigh.co.za', '94 Jacob Str' ),
		(0003, 'Oaks Retirment', 'Gauteng', 'Midrand', '0720891634', '083 165 6743', NULL, '071-890-0123', '073-786-0373', '083-308-9017', 'Oaks@gmail.com', '12 Oak Str')

	INSERT INTO TripType
	VALUES
		(1001, 'Boys High Rugby', 'Pick-up at 08:00 return at 16:00'),
		(1002, 'Girls High Hockey', 'Pick-up at 07:00 return at 13:00'),
		(1003, 'Retirement pick-up', 'Pick-up at 06:00 return at 18:00')

	INSERT INTO Destination
	VALUES
		(2001, 'Harties High', 'Hartebeespoort', 60),
		(2002, 'Kerksdorp High', 'Klerksdorp', 270),
		(2003, 'Gray Country Club', 'Hartebeespoort', 70)

	INSERT INTO Quotation
	VALUES
		(3001, 0001, 'Sarah Graham', '072 891 8543', 1001, '2023-04-05', '08:00','2023-04-05', '16:00', 1,'Boys High', 2001, 1, 1200),
		(3002, 0002, 'Jacob Green', '082 764 0982', 1002, '2023-04-06', '07:00', '2023-04-06', '13:00', 1, 'Girls High', 2002, 1, 1900),
		(3003, 003, 'Michael Santos', '083 323 8345', 1003, '2023-04-07', '06:00', '2023-04-07', '18:00', 1, 'French Toast', 2003, 0, 1200)

	INSERT INTO Busses
	VALUES
		(4001, 'htwyodir', 'Puma', '2022-08-19', 189762, 40, '2021-03-02, 2023-01-08'),
		(4002, 'uyrtqwe', 'Leopard', '2021-03-26', 212049, 40, '2022-04-18, 2023-01-08'),
		(4003, 'poqkdmre', 'Panda', '2022-10-15', 309859, 80, '2022-09-04, 2023-01-08')

	INSERT INTO Drivers
	VALUES
		(5001, 'Charles', 'Franklin', 8904237490493, 'Male', '2019-04-13'),
		(5002, 'Samuel', 'Jackson', 6410088470989, 'Male', '2020-08-28'),
		(5003, 'Franklin', 'Jacobs', 9708198090274, 'Male', '2021-03-29')

	INSERT INTO DestinationReport
	VALUES
		(2001, 'Take money for toll-booth'),
		(2002, 'Rather travel through Carolina'),
		(2003, 'None')

	INSERT INTO BusType
	VALUES
		(6001, 40, 3001, 1200, 4001, 5002, 1),
		(6002, 40, 3002, 1900, 4002, 5001, 1),
		(6003, 80, 3003, 1200, 4003, 5003, 0)

--This section contains all the procedures that will improve the ease of access for the business
------------------------------------------------------------------------------------------------

GO								--This stored procedure(sp) allows the user to see all the information of the client with the relevant id
	CREATE Proc procGetCustomer
		@custid INT
	AS
	SELECT *
	FROM Clients
	WHERE ClientID = @custid

GO								--This sp allows the user to see alot of the relevant information of the trip
	CREATE Proc procTripDetails
		@clientid INT
	AS
		SELECT BusinessName AS 'Business', StartDate, EndDate,StartingPoint, DestinationName, Distance, Amount, Accept AS 'Quotation Accepted', TripName
		FROM Clients
		INNER JOIN Quotation
		ON Clients.ClientID = Quotation.ClientID 
		INNER JOIN Destination
		ON Destination.DestinationID = Quotation.DestinationID
		INNER JOIN TripType
		ON TripType.TripTypeID = Quotation.TripTypeID

GO								--This procedure allows the user to add a new client to their database
	CREATE Proc procAddClient
		@clientid	INT,
		@name		NVARCHAR(40),
		@province	NVARCHAR(40),
		@area		NVARCHAR(40),
		@phone1		NVARCHAR(13),
		@phone2		NVARCHAR(13),
		@phone3		NVARCHAR(13),
		@fax1		NVARCHAR(20),
		@fax2		NVARCHAR(20),
		@fax3		NVARCHAR(20),
		@email		NVARCHAR(30),
		@address	NVARCHAR(40)
	AS
		INSERT INTO Clients
		Values(@clientid, @name, @province, @area, @phone1, @phone2, @phone3, @fax1, @fax2, @fax3, @email, @address)

GO							--This procedure allows the user to add a new quotation to the database
	CREATE Proc procAddQuotation
		@busid		INT,
		@clientid	INT,
		@conperson	NVARCHAR(40),
		@conno		NVARCHAR(13),
		@typetrip	INT,
		@sdate		DATE,
		@stime		TIME,
		@edate		DATE,
		@etime		TIME,
		@tpickup	INT,
		@spoint		NVARCHAR(40),
		@destid		INT,
		@accept		BIT,
		@amount		INT
	AS
		INSERT INTO Quotation
		VALUES(@busid, @clientid, @conperson, @conno, @typetrip, @sdate, @stime, @edate, @etime, @tpickup, @spoint, @destid, @accept, @amount)

GO							--This procedure allows the user to add a new bus to the database
	CREATE PROC procAddBus
		@busid		INT,
		@Regno		NVARCHAR(8),
		@bname		NVARCHAR(30),
		@service	DATE,
		@km			INT,
		@tpeople	INT,
		@renew		DATE,
		@permit		DATE

	AS
		INSERT INTO Busses
		VALUES(@busid, @Regno, @bname, @service, @km, @tpeople, @renew, @permit)

--This section shows all the views and some queries
---------------------------------------------------

GO	

	CREATE VIEW TotalDistancePerClient		--This view shows the user how far they have transported each client
	AS
		SELECT BusinessName, SUM(Distance * 2) AS 'Total Distance'
		FROM Clients
		INNER JOIN Quotation
		ON Clients.ClientID = Quotation.ClientID
		INNER JOIN Destination
		ON Destination.DestinationID = Quotation.DestinationID
		GROUP BY Clients.BusinessName
GO
	CREATE VIEW DriverTotalBus				--This shows how far each driver has driven each bus
	AS
		SELECT Name + Surname AS 'Driver Name', BusName, SUM(Distance * 2) AS 'Distance per bus'
		FROM Destination
		INNER JOIN Quotation
		ON Destination.DestinationID = Quotation.DestinationID
		INNER JOIN BusType
		ON Quotation.BusTripID = BusType.BusTripID
		INNER JOIN Busses
		ON Busses.BusID = Quotation.BusTripID
		INNER JOIN Drivers
		ON Drivers.DriverID = BusType.DriverID
		GROUP BY Drivers.Name, Drivers.Surname, Busses.BusName
GO
	CREATE VIEW TotalCustomer				--This view shows how many times each customer has made use of the business
	AS
		SELECT Clients.ClientID, BusinessName, ContactPerson, COUNT(BusTripID) AS 'Total Trips'
		FROM Clients
		INNER JOIN Quotation
		ON Clients.ClientID = Quotation.ClientID
		GROUP BY Clients.ClientID, Clients.BusinessName, Quotation.ContactPerson
GO
	CREATE VIEW BusDriver														--This view shows each driver that has driven the same bus atleast twice
	AS
		SELECT Drivers.DriverID, Name + Surname AS 'Driver Name', BusName, RegNo
		FROM Drivers
			INNER JOIN BusType
		ON Drivers.DriverID = BusType.DriverID
			INNER JOIN Busses
		ON Busses.BusID = BusType.BusID
		GROUP BY Drivers.DriverID, Drivers.Name, Drivers.Surname, Busses.BusName, Busses.RegNo
		HAVING COUNT(BusType.DriverID) > 2
	
GO
	SELECT BusinessName, ContactPerson, ContactNumber, StartDate, EndDate, TripName, DestinationName		--This query shows info of the trip and clients of each trip where the client hasn't accepted the quotation 
	FROM Clients
		INNER JOIN Quotation
	ON Clients.ClientID = Quotation.ClientID
		INNER JOIN TripType
	ON TripType.TripTypeID = Quotation.TripTypeID
		INNER JOIN Destination
	ON Destination.DestinationID = Quotation.DestinationID
	WHERE Quotation.Accept = 0
	GROUP BY BusinessName, Quotation.ContactPerson, Quotation.ContactNumber, Quotation.StartDate, Quotation.EndDate, TripType.TripName, Destination.DestinationName

	SELECT BusinessName, ContactPerson, ContactNumber, StartDate, EndDate, TripName, DestinationName		--This query shows info of the trip and clients of each trip where the client has accepted the quotation
	FROM Clients
		INNER JOIN Quotation
	ON Clients.ClientID = Quotation.ClientID
		INNER JOIN TripType
	ON TripType.TripTypeID = Quotation.TripTypeID
		INNER JOIN Destination
	ON Destination.DestinationID = Quotation.DestinationID
	WHERE Quotation.Accept = 1
	GROUP BY BusinessName, Quotation.ContactPerson, Quotation.ContactNumber, Quotation.StartDate, Quotation.EndDate, TripType.TripName, Destination.DestinationName

	

--This section is where the backup gets created

GO
	BACKUP DATABASE RobbertBusdiens
	TO DISK = 'C:\DBD_281\RobertBusdiensBackup.bak'
	WITH FORMAT,
		MEDIANAME = 'DatabaseBackup',
		NAME = 'Project Database Backup';
