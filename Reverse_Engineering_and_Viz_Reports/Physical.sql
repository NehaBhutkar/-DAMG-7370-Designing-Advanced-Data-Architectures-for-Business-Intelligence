/*
 * ER/Studio Data Architect SQL Code Generation
 * Project :      DATA MODEL
 *
 * Date Created : Tuesday, September 26, 2023 20:10:29
 * Target DBMS : Microsoft Azure SQL DB
 */

CREATE TYPE AccountNumber FROM nvarchar(15) NULL
go

CREATE TYPE Flag FROM bit NOT NULL
go

CREATE TYPE Name FROM nvarchar(50) NULL
go

CREATE TYPE NameStyle FROM bit NOT NULL
go

CREATE TYPE OrderNumber FROM nvarchar(25) NULL
go

CREATE TYPE Phone FROM nvarchar(25) NULL
go

/* 
 * TABLE: Address 
 */

CREATE TABLE Address(
    AddressID        int                 IDENTITY(1,1) NOT FOR REPLICATION,
    AddressLine1     nvarchar(60)        NOT NULL,
    AddressLine2     nvarchar(60)        NULL,
    City             nvarchar(30)        NOT NULL,
    StateProvince    Name                NOT NULL,
    CountryRegion    Name                NOT NULL,
    PostalCode       nvarchar(15)        NOT NULL,
    rowguid          uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate     datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_Address_AddressID PRIMARY KEY CLUSTERED (AddressID),
    CONSTRAINT AK_Address_rowguid  UNIQUE (rowguid)
)

go


IF OBJECT_ID('Address') IS NOT NULL
    PRINT '<<< CREATED TABLE Address >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Address >>>'
go

/* 
 * TABLE: BuildVersion 
 */

CREATE TABLE BuildVersion(
    SystemInformationID    tinyint         IDENTITY(1,1),
    [Database Version]     nvarchar(25)    NOT NULL,
    VersionDate            datetime        NOT NULL,
    ModifiedDate           datetime        DEFAULT (getdate()) NOT NULL
)

go


IF OBJECT_ID('BuildVersion') IS NOT NULL
    PRINT '<<< CREATED TABLE BuildVersion >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE BuildVersion >>>'
go

/* 
 * TABLE: Customer 
 */

CREATE TABLE Customer(
    CustomerID      int                 IDENTITY(1,1) NOT FOR REPLICATION,
    NameStyle       NameStyle           DEFAULT 0 NOT NULL,
    Title           nvarchar(8)         NULL,
    FirstName       Name                NOT NULL,
    MiddleName      Name                NULL,
    LastName        Name                NOT NULL,
    Suffix          nvarchar(10)        NULL,
    CompanyName     nvarchar(128)       NULL,
    SalesPerson     nvarchar(256)       NULL,
    EmailAddress    nvarchar(50)        NULL,
    Phone           Phone               NULL,
    rowguid         uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate    datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_Customer_CustomerID PRIMARY KEY CLUSTERED (CustomerID),
    CONSTRAINT AK_Customer_rowguid  UNIQUE (rowguid)
)

go


IF OBJECT_ID('Customer') IS NOT NULL
    PRINT '<<< CREATED TABLE Customer >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Customer >>>'
go

/* 
 * TABLE: CustomerAddress 
 */

CREATE TABLE CustomerAddress(
    CustomerID      int                 NOT NULL,
    AddressID       int                 NOT NULL,
    AddressType     Name                NOT NULL,
    rowguid         uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate    datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_CustomerAddress_CustomerID_AddressID PRIMARY KEY CLUSTERED (CustomerID, AddressID),
    CONSTRAINT AK_CustomerAddress_rowguid  UNIQUE (rowguid)
)

go


IF OBJECT_ID('CustomerAddress') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomerAddress >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomerAddress >>>'
go

/* 
 * TABLE: CustomerCredentials 
 */

CREATE TABLE CustomerCredentials(
    ID              int             NOT NULL,
    CreatedDate     datetime        NOT NULL,
    ModifiedDate    datetime        NOT NULL,
    CustomerID      int             NOT NULL,
    PasswordSalt    varchar(10)     NOT NULL,
    PasswordHash    varchar(128)    NOT NULL,
    CONSTRAINT PK14 PRIMARY KEY CLUSTERED (ID)
)

go


IF OBJECT_ID('CustomerCredentials') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomerCredentials >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomerCredentials >>>'
go

/* 
 * TABLE: ErrorLog 
 */

CREATE TABLE ErrorLog(
    ErrorLogID        int               IDENTITY(1,1),
    ErrorTime         datetime          DEFAULT (getdate()) NOT NULL,
    UserName          char(10)          NOT NULL,
    ErrorNumber       int               NOT NULL,
    ErrorSeverity     int               NULL,
    ErrorState        int               NULL,
    ErrorProcedure    nvarchar(126)     NULL,
    ErrorLine         int               NULL,
    ErrorMessage      nvarchar(4000)    NOT NULL,
    CONSTRAINT PK_ErrorLog_ErrorLogID PRIMARY KEY CLUSTERED (ErrorLogID)
)

go


IF OBJECT_ID('ErrorLog') IS NOT NULL
    PRINT '<<< CREATED TABLE ErrorLog >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE ErrorLog >>>'
go

/* 
 * TABLE: Product 
 */

CREATE TABLE Product(
    ProductID                 int                 IDENTITY(1,1),
    Name                      Name                NOT NULL,
    ProductNumber             nvarchar(25)        NOT NULL,
    Color                     nvarchar(15)        NULL,
    StandardCost              money               NOT NULL
                              CONSTRAINT CK_Product_StandardCost CHECK ([StandardCost]>=(0.00)),
    ListPrice                 money               NOT NULL
                              CONSTRAINT CK_Product_ListPrice CHECK ([ListPrice]>=(0.00)),
    Size                      nvarchar(5)         NULL,
    Weight                    decimal(8, 2)       NULL
                              CONSTRAINT CK_Product_Weight CHECK ([Weight]>(0.00)),
    ProductCategoryID         int                 NULL,
    ProductModelID            int                 NULL,
    SellStartDate             datetime            NOT NULL,
    SellEndDate               datetime            NULL,
    DiscontinuedDate          datetime            NULL,
    ThumbNailPhoto            varbinary(max)      NULL,
    ThumbnailPhotoFileName    nvarchar(50)        NULL,
    rowguid                   uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate              datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_Product_ProductID PRIMARY KEY CLUSTERED (ProductID),
    CONSTRAINT AK_Product_rowguid  UNIQUE (rowguid),
    CONSTRAINT AK_Product_ProductNumber  UNIQUE (ProductNumber),
    CONSTRAINT AK_Product_Name  UNIQUE (Name)
)

go


IF OBJECT_ID('Product') IS NOT NULL
    PRINT '<<< CREATED TABLE Product >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Product >>>'
go

/* 
 * TABLE: ProductCategory 
 */

CREATE TABLE ProductCategory(
    ProductCategoryID          int                 IDENTITY(1,1),
    ParentProductCategoryID    int                 NULL,
    Name                       Name                NOT NULL,
    rowguid                    uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate               datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_ProductCategory_ProductCategoryID PRIMARY KEY CLUSTERED (ProductCategoryID),
    CONSTRAINT AK_ProductCategory_rowguid  UNIQUE (rowguid),
    CONSTRAINT AK_ProductCategory_Name  UNIQUE (Name)
)

go


IF OBJECT_ID('ProductCategory') IS NOT NULL
    PRINT '<<< CREATED TABLE ProductCategory >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE ProductCategory >>>'
go

/* 
 * TABLE: ProductDescription 
 */

CREATE TABLE ProductDescription(
    ProductDescriptionID    int                 IDENTITY(1,1),
    Description             nvarchar(400)       NOT NULL,
    rowguid                 uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate            datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_ProductDescription_ProductDescriptionID PRIMARY KEY CLUSTERED (ProductDescriptionID),
    CONSTRAINT AK_ProductDescription_rowguid  UNIQUE (rowguid)
)

go


IF OBJECT_ID('ProductDescription') IS NOT NULL
    PRINT '<<< CREATED TABLE ProductDescription >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE ProductDescription >>>'
go

/* 
 * TABLE: ProductModel 
 */

CREATE TABLE ProductModel(
    ProductModelID        int                 IDENTITY(1,1),
    Name                  Name                NOT NULL,
    CatalogDescription    xml                 NULL,
    rowguid               uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate          datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_ProductModel_ProductModelID PRIMARY KEY CLUSTERED (ProductModelID),
    CONSTRAINT AK_ProductModel_rowguid  UNIQUE (rowguid),
    CONSTRAINT AK_ProductModel_Name  UNIQUE (Name)
)

go


IF OBJECT_ID('ProductModel') IS NOT NULL
    PRINT '<<< CREATED TABLE ProductModel >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE ProductModel >>>'
go

/* 
 * TABLE: ProductModelProductDescription 
 */

CREATE TABLE ProductModelProductDescription(
    ProductModelID          int                 NOT NULL,
    ProductDescriptionID    int                 NOT NULL,
    Culture                 nchar(6)            NOT NULL,
    rowguid                 uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate            datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_ProductModelProductDescription_ProductModelID_ProductDescriptionID_Culture PRIMARY KEY CLUSTERED (ProductModelID, ProductDescriptionID, Culture),
    CONSTRAINT AK_ProductModelProductDescription_rowguid  UNIQUE (rowguid)
)

go


IF OBJECT_ID('ProductModelProductDescription') IS NOT NULL
    PRINT '<<< CREATED TABLE ProductModelProductDescription >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE ProductModelProductDescription >>>'
go

/* 
 * TABLE: SalesOrderDetail 
 */

CREATE TABLE SalesOrderDetail(
    SalesOrderID          int                 NOT NULL,
    ID                    int                 NOT NULL,
    SalesOrderDetailID    int                 IDENTITY(1,1),
    OrderQty              smallint            NOT NULL
                          CONSTRAINT CK_SalesOrderDetail_OrderQty CHECK ([OrderQty]>(0)),
    ProductID             int                 NOT NULL,
    UnitPrice             money               NOT NULL
                          CONSTRAINT CK_SalesOrderDetail_UnitPrice CHECK ([UnitPrice]>=(0.00)),
    LineTotal             numeric(38, 6)      NOT NULL,
    MemberShipType        varchar(50)         NOT NULL,
    rowguid               uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate          datetime            DEFAULT (getdate()) NOT NULL,
    SeasonalDiscountID    int                 NOT NULL,
    CONSTRAINT PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID PRIMARY KEY CLUSTERED (SalesOrderID, SalesOrderDetailID),
    CONSTRAINT AK_SalesOrderDetail_rowguid  UNIQUE (rowguid)
)

go


IF OBJECT_ID('SalesOrderDetail') IS NOT NULL
    PRINT '<<< CREATED TABLE SalesOrderDetail >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE SalesOrderDetail >>>'
go

/* 
 * TABLE: SalesOrderHeader 
 */

CREATE TABLE SalesOrderHeader(
    SalesOrderID              int                 IDENTITY(1,1) NOT FOR REPLICATION,
    RevisionNumber            tinyint             DEFAULT 0 NOT NULL,
    OrderDate                 datetime            DEFAULT (getdate()) NOT NULL,
    DueDate                   datetime            NOT NULL,
    ShipDate                  datetime            NULL,
    Status                    tinyint             DEFAULT 1 NOT NULL
                              CONSTRAINT CK_SalesOrderHeader_Status CHECK ([Status]>=(0) AND [Status]<=(8)),
    OnlineOrderFlag           Flag                DEFAULT 1 NOT NULL,
    SalesOrderNumber          nvarchar(25)        NOT NULL,
    PurchaseOrderNumber       OrderNumber         NULL,
    AccountNumber             AccountNumber       NULL,
    CustomerID                int                 NOT NULL,
    ShipToAddressID           int                 NULL,
    BillToAddressID           int                 NULL,
    ShipMethod                nvarchar(50)        NOT NULL,
    CreditCardApprovalCode    varchar(15)         NULL,
    SubTotal                  money               DEFAULT 0.00 NOT NULL
                              CONSTRAINT CK_SalesOrderHeader_SubTotal CHECK ([SubTotal]>=(0.00)),
    TaxAmt                    money               DEFAULT 0.00 NOT NULL
                              CONSTRAINT CK_SalesOrderHeader_TaxAmt CHECK ([TaxAmt]>=(0.00)),
    Freight                   money               DEFAULT 0.00 NOT NULL
                              CONSTRAINT CK_SalesOrderHeader_Freight CHECK ([Freight]>=(0.00)),
    TotalDue                  money               NOT NULL,
    Comment                   nvarchar(max)       NULL,
    rowguid                   uniqueidentifier    ROWGUIDCOL DEFAULT (newid()) NOT NULL,
    ModifiedDate              datetime            DEFAULT (getdate()) NOT NULL,
    CONSTRAINT PK_SalesOrderHeader_SalesOrderID PRIMARY KEY CLUSTERED (SalesOrderID),
    CONSTRAINT AK_SalesOrderHeader_SalesOrderNumber  UNIQUE (SalesOrderNumber),
    CONSTRAINT AK_SalesOrderHeader_rowguid  UNIQUE (rowguid)
)

go


IF OBJECT_ID('SalesOrderHeader') IS NOT NULL
    PRINT '<<< CREATED TABLE SalesOrderHeader >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE SalesOrderHeader >>>'
go

/* 
 * TABLE: SeasonalDiscounts 
 */

CREATE TABLE SeasonalDiscounts(
    ID                 int              NOT NULL,
    SeasonName         varchar(50)      NOT NULL,
    DiscountPercent    numeric(2, 0)    NOT NULL,
    CreatedDate        date             NOT NULL,
    ModifiedDate       date             NOT NULL,
    CONSTRAINT PK15 PRIMARY KEY CLUSTERED (ID)
)

go


IF OBJECT_ID('SeasonalDiscounts') IS NOT NULL
    PRINT '<<< CREATED TABLE SeasonalDiscounts >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE SeasonalDiscounts >>>'
go

/* 
 * INDEX: IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion 
 */

CREATE INDEX IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion ON Address(AddressLine1, AddressLine2, City, StateProvince, PostalCode, CountryRegion)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Address') AND name='IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion')
    PRINT '<<< CREATED INDEX Address.IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Address.IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion >>>'
go

/* 
 * INDEX: IX_Address_StateProvince 
 */

CREATE INDEX IX_Address_StateProvince ON Address(StateProvince)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Address') AND name='IX_Address_StateProvince')
    PRINT '<<< CREATED INDEX Address.IX_Address_StateProvince >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Address.IX_Address_StateProvince >>>'
go

/* 
 * INDEX: IX_Customer_EmailAddress 
 */

CREATE INDEX IX_Customer_EmailAddress ON Customer(EmailAddress)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Customer') AND name='IX_Customer_EmailAddress')
    PRINT '<<< CREATED INDEX Customer.IX_Customer_EmailAddress >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Customer.IX_Customer_EmailAddress >>>'
go

/* 
 * INDEX: IX_SalesOrderDetail_ProductID 
 */

CREATE INDEX IX_SalesOrderDetail_ProductID ON SalesOrderDetail(ProductID)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('SalesOrderDetail') AND name='IX_SalesOrderDetail_ProductID')
    PRINT '<<< CREATED INDEX SalesOrderDetail.IX_SalesOrderDetail_ProductID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX SalesOrderDetail.IX_SalesOrderDetail_ProductID >>>'
go

/* 
 * INDEX: IX_SalesOrderHeader_CustomerID 
 */

CREATE INDEX IX_SalesOrderHeader_CustomerID ON SalesOrderHeader(CustomerID)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('SalesOrderHeader') AND name='IX_SalesOrderHeader_CustomerID')
    PRINT '<<< CREATED INDEX SalesOrderHeader.IX_SalesOrderHeader_CustomerID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX SalesOrderHeader.IX_SalesOrderHeader_CustomerID >>>'
go

/* 
 * TABLE: CustomerAddress 
 */

ALTER TABLE CustomerAddress ADD CONSTRAINT FK_CustomerAddress_Address_AddressID 
    FOREIGN KEY (AddressID)
    REFERENCES Address(AddressID)
go

ALTER TABLE CustomerAddress ADD CONSTRAINT FK_CustomerAddress_Customer_CustomerID 
    FOREIGN KEY (CustomerID)
    REFERENCES Customer(CustomerID)
go


/* 
 * TABLE: CustomerCredentials 
 */

ALTER TABLE CustomerCredentials ADD CONSTRAINT RefCustomer22 
    FOREIGN KEY (CustomerID)
    REFERENCES Customer(CustomerID)
go


/* 
 * TABLE: Product 
 */

ALTER TABLE Product ADD CONSTRAINT FK_Product_ProductCategory_ProductCategoryID 
    FOREIGN KEY (ProductCategoryID)
    REFERENCES ProductCategory(ProductCategoryID)
go

ALTER TABLE Product ADD CONSTRAINT FK_Product_ProductModel_ProductModelID 
    FOREIGN KEY (ProductModelID)
    REFERENCES ProductModel(ProductModelID)
go


/* 
 * TABLE: ProductCategory 
 */

ALTER TABLE ProductCategory ADD CONSTRAINT FK_ProductCategory_ProductCategory_ParentProductCategoryID_ProductCategoryID 
    FOREIGN KEY (ParentProductCategoryID)
    REFERENCES ProductCategory(ProductCategoryID)
go


/* 
 * TABLE: ProductModelProductDescription 
 */

ALTER TABLE ProductModelProductDescription ADD CONSTRAINT FK_ProductModelProductDescription_ProductDescription_ProductDescriptionID 
    FOREIGN KEY (ProductDescriptionID)
    REFERENCES ProductDescription(ProductDescriptionID)
go

ALTER TABLE ProductModelProductDescription ADD CONSTRAINT FK_ProductModelProductDescription_ProductModel_ProductModelID 
    FOREIGN KEY (ProductModelID)
    REFERENCES ProductModel(ProductModelID)
go


/* 
 * TABLE: SalesOrderDetail 
 */

ALTER TABLE SalesOrderDetail ADD CONSTRAINT RefSeasonalDiscounts21 
    FOREIGN KEY (SeasonalDiscountID)
    REFERENCES SeasonalDiscounts(ID)
go

ALTER TABLE SalesOrderDetail ADD CONSTRAINT FK_SalesOrderDetail_Product_ProductID 
    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID)
go

ALTER TABLE SalesOrderDetail ADD CONSTRAINT FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID 
    FOREIGN KEY (SalesOrderID)
    REFERENCES SalesOrderHeader(SalesOrderID) ON DELETE CASCADE
go


/* 
 * TABLE: SalesOrderHeader 
 */

ALTER TABLE SalesOrderHeader ADD CONSTRAINT FK_SalesOrderHeader_Address_BillTo_AddressID 
    FOREIGN KEY (BillToAddressID)
    REFERENCES Address(AddressID)
go

ALTER TABLE SalesOrderHeader ADD CONSTRAINT FK_SalesOrderHeader_Address_ShipTo_AddressID 
    FOREIGN KEY (ShipToAddressID)
    REFERENCES Address(AddressID)
go

ALTER TABLE SalesOrderHeader ADD CONSTRAINT FK_SalesOrderHeader_Customer_CustomerID 
    FOREIGN KEY (CustomerID)
    REFERENCES Customer(CustomerID)
go


