DROP TABLE Loan_Review;
DROP TABLE Wishlist;
DROP TABLE Loaned_Books;
DROP TABLE Loans;
DROP TABLE Owned_Books;
DROP TABLE Availability_Status;
DROP TABLE Condition_Status;
DROP TABLE Loan_Status;
DROP TABLE Genre;
DROP TABLE Books;
DROP TABLE Users;
DROP TABLE Addresses;

CREATE TABLE Addresses(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	address1 NVARCHAR(1000) NOT NULL,
	address2 NVARCHAR(1000) NULL,
	city NVARCHAR(1000) NOT NULL,
	state NVARCHAR(1000) NOT NULL,
	country NVARCHAR(1000) NULL,
	zipcode INT NOT NULL,
)

CREATE TABLE Users(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	authId NVARCHAR(1000) NOT NULL UNIQUE,
	username NVARCHAR(255) NOT NULL,
	email NVARCHAR(255) NOT NULL UNIQUE,
)

CREATE TABLE Books(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	title NVARCHAR(255) NOT NULL, 
	author NVARCHAR(255) NOT NULL,
	isbn BigINT NOT NULL CHECK (len(isbn) = 13),
	thumbnail NVARCHAR(1000) NULL,
) 

CREATE TABLE Genre(
	id INT NOT NULL PRIMARY KEY IDENTITY,
	bookId int NOT NULL FOREIGN KEY REFERENCES Books(id),
	genreName NVARCHAR(255) NOT NULL, 
)

CREATE TABLE Loan_Status(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	statusName NVARCHAR(255) NOT NULL,
)

CREATE TABLE Condition_Status(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	statusName NVARCHAR(255) NOT NULL,
)

CREATE TABLE Availability_Status(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	statusName NVARCHAR(255) NOT NULL,
)

CREATE TABLE Owned_Books(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	userId INT NOT NULL FOREIGN KEY REFERENCES Users(id),
	bookId INT NOT NULL FOREIGN KEY REFERENCES Books(id),
	conditionId INT NOT NULL FOREIGN KEY REFERENCES Condition_Status(id), 
	availabilityStatusId int NOT NULL FOREIGN KEY REFERENCES Availability_Status(id),
)

CREATE TABLE Loans(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	lenderId INT NOT NULL FOREIGN KEY REFERENCES Users(id),
	borrowerId INT NOT NULL FOREIGN KEY REFERENCES Users(id),
	message  NTEXT NULL,
	loanStatusId INT NOT NULL FOREIGN KEY REFERENCES Loan_Status(id),
	dropoffDate DATETIMEOFFSET NOT NULL, 
	returnedDate DATETIMEOFFSET NOT NULL, 
	addressId INT NOT NULL FOREIGN KEY REFERENCES Addresses(id),
)

CREATE TABLE Loaned_Books(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	ownedBookid INT NOT NULL FOREIGN KEY REFERENCES Owned_Books(id),
	loanId INT NOT NULL FOREIGN KEY REFERENCES Loans(id),
)

CREATE TABLE Wishlist(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	userId INT NOT NULL FOREIGN KEY REFERENCES Users(id),
	bookId INT NOT NULL FOREIGN KEY REFERENCES Books(id)
)

CREATE TABLE Loan_Review(
	id INT PRIMARY KEY IDENTITY NOT NULL,
	reviewerId INT NOT NULL FOREIGN KEY REFERENCES Users(id),
	loanId INT NOT NULL FOREIGN KEY REFERENCES Loans(id),
)

INSERT INTO Availability_Status (statusName) VALUES
	('Available'),
	('Checked Out'),
	('In Process'),
	('Unknown');

INSERT INTO Condition_Status (statusName) VALUES
	('Like New'),
	('Very Good'),
	('Good'),
	('Fair'),
	('Poor');

INSERT INTO Loan_Status (statusName) VALUES
	('Requested'),
	('Approved'),
	('Denied'),
	('Expired');

INSERT INTO addresses (address1, address2, city, state, zipcode) VALUES
	('98 Pyongyang Boulevard', null, 'Arlington', 'Texas',	42141),
	('913 Coacalco de Berriozbal Loop', null, 'Arlington', 'Texas',	42141),
	('1308 Arecibo Way', null, 'Arlington', 'Texas', 42141),
	('587 Benguela Manor', null, 'Arlington', 'Texas', 42141),
	('43 Vilnius Manor', null, 'Arlington', 'Texas', 42141),
	('660 Jedda Boulevard', null, 'Arlington', 'Texas',	42141),
	('782 Mosul Street', null, 'Arlington', 'Texas', 42141),
	('1427 Tabuk Place', null, 'Arlington', 'Texas', 42141),
	('770 Bydgoszcz Avenue', null, 'Dallas', 'Texas', 11067),
	('1666 Beni-Mellal Place', null, 'Dallas', 'Texas',	11067),
	('533 al-Ayn Boulevard', null, 'Dallas', 'Texas', 11067),
	('530 Lausanne Lane', null,	'Dallas', 'Texas', 11067),
	('32 Pudukkottai Lane', null, 'Dallas', 'Texas', 11067),
	('1866 al-Qatif Avenue', null, 'Dallas', 'Texas', 11067),
	('1135 Izumisano Parkway', null, 'Dallas', 'Texas',	11067),
	('1895 Zhezqazghan Drive', null, 'Dallas', 'Texas',	11067),
	('1894 Boa Vista Way', null, 'Dallas', 'Texas',	11067),
	('333 Goinia Way', null, 'Dallas', 'Texas',	11067),
	('369 Papeete Way', null, 'Dallas', 'Texas', 11067),
	('786 Matsue Way', null, 'Dallas', 'Texas',	11067),
	('1191 Sungai Petani Boulevard', null, 'Dallas', 'Texas', 11067),
	('793 Cam Ranh Avenue', 'Apartment B', 'Dallas', 'Texas', 11067),
	('1795 Santiago de Compostela Way', null, 'Dallas', 'Texas', 11067),
	('1214 Hanoi Way', null, 'Dallas', 'Texas',	11067),
	('401 Sucre Boulevard', null, 'Dallas', 'Texas', 11067),
	('682 Garden Grove Place', 'Apartment 103',	'Dallas', 'Texas', 11067),
	('1980 Kamjanets-Podilskyi Street', null, 'Dallas', 'Texas', 11067),
	('1936 Cuman Avenue', null,	'Dallas', 'Texas', 11067),
	('1485 Bratislava Place', null,	'Dallas', 'Texas', 11067),
	('1717 Guadalajara Lane', null,	'Dallas', 'Texas', 11067),
	('920 Kumbakonam Loop', null, 'Dallas', 'Texas', 11067),
	('1121 Loja Avenue', null, 'Dallas', 'Texas', 11067),
	('879 Newcastle Way', null,	'Dallas', 'Texas', 11067),
	('1309 Weifang Street', null, 'Dallas', 'Texas', 11067),
	('1944 Bamenda Way', null, 'Dallas', 'Texas', 11067);



INSERT INTO Users (authId, username, email) VALUES
	('google-oauth2|100283624593962851783', 'damionsilver', 'damion.silver18@gmail.com'),
	('google-oauth2|111098450821980045194', 'brysonewell', 'brysonewell@gmail.com'),
	('google-oauth2|110262058361545939921', 'johnwerner','jwerner547@gmail.com'),
	('auth0|6057ca1e8a24d70070efbc81', 'ashleybrown', '1thing.ashleyb@gmail.com');

INSERT INTO books (title, author, isbn, thumbnail) VALUES
	('The Fellowship of the Ring','J.R.R. Tolkien',9780547952017,'https://books.google.com/books/content?id=aWZzLPhY4o0C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Hobbit','J.R.R. Tolkien',9780008108281,'http://books.google.com/books/content?id=8SegnQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Of Mice and Men','John Steinbeck',9780140186420,'http://books.google.com/books/content?id=nE_Si_bv-W4C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Pride','Ibi Zoboi',9780062564078,'http://books.google.com/books/content?id=ZV9DDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Emma','Jane Austen',9780451526274,'http://books.google.com/books/content?id=iHy75F9qO_4C&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Save the Cat','Blake Snyder',9781615931712,'http://books.google.com/books/content?id=WgbknQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('The Last Book on the Left','Ben Kissel, Marcus Parks, Henry Zebrowski',9781328566225,'http://books.google.com/books/content?id=4siEDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Last Book in the Universe','Rodman Philbrick',9780545303873,'http://books.google.com/books/content?id=RibcDcX8ypkC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Leaders Eat Last','Simon Sinek',9781101623039,'http://books.google.com/books/content?id=bbeaAAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Last','Hanna Jameson',9781501198847,'http://books.google.com/books/content?id=vDxqDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('A Time to Kill','John Grisham',9780307576132,'http://books.google.com/books/content?id=RlmniRlFsU0C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Reckoning','John Grisham',9780525620938,'http://books.google.com/books/content?id=BJaaDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Rogue Lawyer','John Grisham',9780553393484,'http://books.google.com/books/content?id=tyuJDAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Broker','John Grisham',9780307575982,'http://books.google.com/books/content?id=C1HqphxkrboC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Rainbow Six','Tom Clancy',9780425170342,'http://books.google.com/books/content?id=_7jR_ifoeQoC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Lost Symbol','Dan Brown',9781400079148,'http://books.google.com/books/content?id=tCqI98qnVrcC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Encyclopedia Brown Gets His Man','Donald J. Sobol',9780142408919,'http://books.google.com/books/content?id=aFT5DwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('1984','George Orwell',9780547249643,'http://books.google.com/books/content?id=kotPYEqx7kMC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Farenheit 451','Ray Bradbury',9780671872298,'http://books.google.com/books/content?id=AU9YtwAACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Persuasion','Jane Austen',9781623957841,'http://books.google.com/books/content?id=7rQmCwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Essential New York Times Cookbook','Amanda Hesser',9780393247671,'http://books.google.com/books/content?id=QWrVBAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Cook Beautiful','Athena Calderone',9781683351085,'http://books.google.com/books/content?id=22NgDgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Cooked','Michael Pollan',9780141975634,'http://books.google.com/books/content?id=be2XOQ2sB_EC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Essentials of Italian Cooking','Marcella Hazan',9780307958303,'http://books.google.com/books/content?id=1FVLv7WS4C4C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('In Cold Blood','Truman Capote',9780812994384,'http://books.google.com/books/content?id=TH5uM_f0MRwC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Mindhunter','John E. Douglas, Mark Olshaker',9781501191961,'http://books.google.com/books/content?id=s2c6DwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Adnan''s Story','Rabia Chaudry',9781250087119,'http://books.google.com/books/content?id=BU4BCwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Chaos','Tom O''Neill',9780316477574,'http://books.google.com/books/content?id=zG92DwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Atomic Habits','James Clear',9780735211292,'http://books.google.com/books/content?id=XfFvDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Power of Positive Thinking','Norman Vincent Peale',9789388118576,'http://books.google.com/books/content?id=5bp1DwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('How to Win Friends and Influence People','Dale Carnegie',9781451621716,'http://books.google.com/books/content?id=1rW-QpIAs8UC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Four Agreements','Miguel Ruiz',9781934408018,'http://books.google.com/books/content?id=hzVxiw2DiOsC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Princess Saves Herself in this One','Amanda Lovelace',9781449486440,'http://books.google.com/books/content?id=bPV1DQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Milk and Honey','Rupi Kaur',9781449478650,'http://books.google.com/books/content?id=WoWfCgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Leaves of Grass','Walt Whitman',9780199727216,'http://books.google.com/books/content?id=3ECRp9xNojoC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Odyssey of Homer','Homerus',9780140268867,'http://books.google.com/books/content?id=biBRxQmHPLIC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('A People''s History of the United States','Howard Zinn',9781621578949,'http://books.google.com/books/content?id=N-apBAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Seventeen Seventy-six','David McCullough',9780743226721,'http://books.google.com/books/content?id=R1Jk-A4R5AYC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Genghis Khan and the Making of the Modern World','Jack Weatherford',9780609809648,'http://books.google.com/books/content?id=56_DNcoTnSAC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('SPQR: A History of Ancient Rome','Mary Beard',9781631491252,'http://books.google.com/books/content?id=yKL4CQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Becoming','Michelle Obama',9781524763138,'http://books.google.com/books/content?id=hi17DwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Diary of a Young Girl','Anne Frank',9780307807533,'http://books.google.com/books/content?id=EO-2vZseBf0C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Autobiography of Malcolm X','Malcolm X',9781101967805,'http://books.google.com/books/content?id=EtVfCgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Steve Jobs','Walter Isaacson',9781451648546,'http://books.google.com/books/content?id=8U2oAAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Ender''s Game','Orson Scott Card',9780765394866,'http://books.google.com/books/content?id=jaM7DwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Martian','Andy Weir',9780804139038,'http://books.google.com/books/content?id=MQeHAAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Starship Troopers','Robert Anson Heinlein',9780441783588,'http://books.google.com/books/content?id=rmEIDAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Snow Crash','Neal Stephenson',9780553898194,'http://books.google.com/books/content?id=RMd3GpIFxcUC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Bridgerton Collection, Volume 1','Julia Quinn',9780063045118,'http://books.google.com/books/content?id=bPjQDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Notebook','Nicholas Sparks',9780446930642,'http://books.google.com/books/content?id=Vv0og8FYLc8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Wuthering Heights','Emily Bronte',9781438114880,'http://books.google.com/books/content?id=fN0gOdKQZD4C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Alchemist','Paulo Coelho',9780062416216,'http://books.google.com/books/content?id=FzVjBgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Vanishing Half','Brit Bennet',9780525536291,'http://books.google.com/books/content?id=-vnoDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Where the Crawdads Sing','Delia Owens',9780735219113,'http://books.google.com/books/content?id=CGVDDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Goldfinch','Donna Tartt',9780349139630,'http://books.google.com/books/content?id=eN4lngEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('The Name of the Wind','Patrick Rothfuss',9780575087057,'http://books.google.com/books/content?id=BcG2dVRXKukC&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('A Game of Thrones','George R.R. Martin',9780553573404,'http://books.google.com/books/content?id=obkzuwEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('The Last Unicorn','William deBuys',9780316232883,'http://books.google.com/books/content?id=X_d9BAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Dracula','Bram Stoker',9798702225081,'http://books.google.com/books/content?id=8BAzzgEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('The Exorcist','William Peter Blatty',9780062094377,'http://books.google.com/books/content?id=80HZZsKobHYC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Shining','Stephen King',9780385528863,'http://books.google.com/books/content?id=8VnJLu3AvvQC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('House of Leaves','Mark Z. Danielewski',9780375420528,'http://books.google.com/books/content?id=qGA_3RGqTkQC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('All the Light We Cannot See','Anthony Doerr',9781501173219,'http://books.google.com/books/content?id=giaLDgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Wolf Hall','Hilary Mantel',9781429943284,'http://books.google.com/books/content?id=AUqkcy2G-N8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Pillars of the Earth','Ken Follett',9781101442197,'http://books.google.com/books/content?id=VB7IAgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Book Thief','Markus Zusak',9781784162122,'http://books.google.com/books/content?id=-eMuDQAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Legend: The Graphic Novel','Marie Lu',9780399171895,'http://books.google.com/books/content?id=8iaMDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Dune: The Graphic Novel, Book 1','Frank Herbert',9781647001827,'http://books.google.com/books/content?id=lH_TDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Great Gatsby','F. Scott Fitzgerald',9788027235667,'http://books.google.com/books/content?id=N1JODwAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Little Women','Louisa May Alcott',9780191605505,'http://books.google.com/books/content?id=v0iuYlsc8EIC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Adventures of Huckleberry Finn','Mark Twain',9781616411565,'http://books.google.com/books/content?id=SiFa-XvuQmAC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Catcher in the Rye','J.D. Salinger',9780848832919,'http://books.google.com/books/content?id=Bb91ngEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Moby Dick','Herman Melville',9781944529024,'http://books.google.com/books/content?id=uF3xCwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Scarlet Letter','Nathanial Hawthorne',9798707895401,'http://books.google.com/books/content?id=cG41zgEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Brave New World','Aldous Huxley',9781405882583,'http://books.google.com/books/content?id=zyePPwAACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Winnie-The-Pooh: The Honey Tree','A.A. Milne',9781717038135,'http://books.google.com/books/content?id=ZEs7zgEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('The House at Pooh Corner','A.A. Milne',9781405255820,'http://books.google.com/books/content?id=zZUBAQAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Goodnight Moon','Margaret Wise Brown',9780062662897,'http://books.google.com/books/content?id=dJNoDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Cat in the Hat','Dr. Seuss',9780385372015,'http://books.google.com/books/content?id=ia7xAwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Lorax','Dr. Seuss',9780385372022,'http://books.google.com/books/content?id=-6_xAwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Princess Bride','William Goldman',9780544173767,'http://books.google.com/books/content?id=ie1bAQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Total Power','Vince Flynn, Kyle Mills',9781501190674,'http://books.google.com/books/content?id=IFXGDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('The Sentinel','Lee Child, Andrew Child',9781984818478,'http://books.google.com/books/content?id=k7fNDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Pirate Latitudes','Michael Crichton',9781443400442,'http://books.google.com/books/content?id=U9bOjZlTWhEC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Harry Potter and the Goblet of Fire','J.K. Rowling',9781408834992,'http://books.google.com/books/content?id=1Vs9AwAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api'),
('Harry Potter and the Chamber of Secrets','J.K. Rowling',9781781100509,'http://books.google.com/books/content?id=5iTebBW-w7QC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api'),
('Harry Potter and the Order of the Phoenix','J.K. Rowling',9781781100530,'http://books.google.com/books/content?id=zpvysRGsBlwC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api');


INSERT INTO owned_books (userId, bookId, conditionId, availabilityStatusId) VALUES
	(1,1,1,1),
	(1,2,2,1),
	(1,3,3,1),
	(1,4,4,2),
	(1,5,5,2),
	(1,6,1,2),
	(1,7,2,3),
	(1,8,3,1),
	(1,9,4,1),
	(1,10,5,1),
	(1,11,1,2),
	(1,12,2,2),
	(1,13,3,2),
	(1,14,4,3),
	(1,15,5,1),
	(1,16,1,1),
	(1,17,2,1),
	(1,18,3,2),
	(1,19,4,2),
	(1,20,5,2),
	(1,21,1,3),
	(1,22,2,1),
	(1,23,3,1),
	(1,24,4,1),
	(1,25,5,2),
	(1,26,1,2),
	(1,27,2,3),
	(1,28,3,1),
	(1,29,4,1),
	(1,30,5,1),
	(1,31,1,2),
	(1,32,2,2),
	(1,33,3,3),
	(1,34,4,1),
	(1,35,5,1),
	(1,36,1,1),
	(1,37,2,2),
	(1,38,3,2),
	(1,39,4,3),
	(1,40,5,1),
	(1,41,1,1),
	(1,42,2,1),
	(1,43,3,2),
	(1,44,4,2),
	(1,45,5,3),
	(1,46,1,1),
	(1,47,2,1),
	(1,48,3,1),
	(1,49,4,2),
	(1,50,5,2),
	(1,51,1,3),
	(1,52,2,1),
	(1,53,3,1),
	(1,54,4,1),
	(1,55,5,2),
	(1,56,1,2),
	(1,57,2,3),
	(1,58,3,1),
	(1,59,4,1),
	(1,60,5,1),
	(1,61,1,2),
	(1,62,2,2),
	(1,63,3,3),
	(1,64,4,1),
	(1,65,5,1),
	(1,66,1,1),
	(1,67,2,2),
	(1,68,3,2),
	(1,69,4,3),
	(1,70,5,1),
	(1,71,1,1),
	(1,72,2,1),
	(1,73,3,2),
	(1,74,4,2),
	(1,75,5,3),
	(1,76,1,1),
	(1,77,2,1),
	(1,78,3,1),
	(1,79,4,2),
	(1,80,5,2),
	(1,81,1,3),
	(1,82,2,1),
	(1,83,3,1),
	(1,84,4,1),
	(1,85,5,2),
	(1,86,1,2),
	(1,87,2,3);


INSERT INTO Genre (bookId, genreName) VALUES
	(1, 'Action and Adventure'),
	(2, 'Children'),
	(3, 'Classics'),
	(4, 'Comic Book or Graphic Novel'),
	(5, 'Historical Fiction'),
	(6, 'Horror'),
	(7, 'Fantasy'),
	(8, 'Literary Fiction'),
	(9, 'Romance'),
	(10, 'Science Fiction'),
	(11, 'Suspense and Thrillers'),
	(12, 'Biographies and Autobiographies'),
	(13, 'History'),
	(14, 'Poetry'),
	(15, 'Self-Help'),
	(16, 'True Crime'),
	(17, 'Cookbook'),
	(11, 'Action and Adventure'),
	(25, 'Children'),
	(36, 'Classics'),
	(42, 'Comic Book or Graphic Novel'),
	(52, 'Historical Fiction'),
	(26, 'Horror'),
	(75, 'Fantasy'),
	(81, 'Literary Fiction'),
	(19, 'Romance'),
	(50, 'Science Fiction'),
	(21, 'Suspense and Thrillers'),
	(52, 'Biographies and Autobiographies'),
	(13, 'History'),
	(64, 'Poetry'),
	(17, 'Self-Help'),
	(26, 'True Crime'),
	(57, 'Cookbook'),
	(35, 'Action and Adventure'),
	(35, 'Children'),
	(66, 'Classics'),
	(32, 'Comic Book or Graphic Novel'),
	(22, 'Historical Fiction'),
	(26, 'Horror'),
	(45, 'Fantasy'),
	(80, 'Literary Fiction'),
	(59, 'Romance'),
	(57, 'Science Fiction');