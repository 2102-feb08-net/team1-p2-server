CREATE TABLE Addresses(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	address1 NVARCHAR(1000) NOT NULL,
	address2 NVARCHAR(1000),
	city NVARCHAR(1000) NOT NULL,
	state NVARCHAR(1000) NOT NULL,
	zipcode NVARCHAR(1000) NOT NULL,
)

CREATE TABLE Users(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	addressid INT NOT NULL FOREIGN KEY REFERENCES Addresses(id),
	username NVARCHAR(255) NOT NULL,
	userpassword NVARCHAR(255) NOT NULL,
	email NVARCHAR(255) NOT NULL,
)

CREATE TABLE Genre(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	genre NVARCHAR(255) NOT NULL, 
)

CREATE TABLE Books(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	title NVARCHAR(255) NOT NULL, 
	author NVARCHAR(255) NOT NULL,
	isbn NVARCHAR(255) NOT NULL,
	genre int NOT NULL FOREIGN KEY REFERENCES Genre(id),
) 

CREATE TABLE Loan_Status(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	loanStatus NVARCHAR(255) NOT NULL,
)

CREATE TABLE Availability_Status(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	availabilityStatus NVARCHAR(255) NOT NULL,
)

CREATE TABLE Owned_Books(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	userid INT NOT NULL FOREIGN KEY REFERENCES Users(id),
	bookid INT NOT NULL FOREIGN KEY REFERENCES Books(id),
	condition NVARCHAR(255) NOT NULL, 
	availabilityStatusId int NOT NULL FOREIGN KEY REFERENCES Availability_Status(id),
)

CREATE TABLE Loans(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	userid INT NOT NULL FOREIGN KEY REFERENCES Users(id),
	owned_bookid INT NOT NULL FOREIGN KEY REFERENCES Owned_Books(id),
	message  NTEXT NOT NULL,
	loanStatusId INT NOT NULL FOREIGN KEY REFERENCES Loan_Status(id),
	ispublic BIT NOT NULL,
	dropoffdate DATETIME NOT NULL, 
	returneddate DATETIME NOT NULL, 
)

CREATE TABLE Loaned_Books(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	owned_bookid INT NOT NULL FOREIGN KEY REFERENCES Owned_Books(id),
	loanid INT NOT NULL FOREIGN KEY REFERENCES Loans(id),
)
