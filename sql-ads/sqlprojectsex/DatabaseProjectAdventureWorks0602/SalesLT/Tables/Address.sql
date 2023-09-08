CREATE TABLE [SalesLT].[Address] (
    [AddressID]     INT              IDENTITY (1, 1) NOT NULL,
    [AddressLine1]  NVARCHAR (60)    NOT NULL,
    [AddressLine2]  NVARCHAR (60)    NULL,
    [City]          NVARCHAR (30)    NOT NULL,
    [StateProvince] [dbo].[Name]     NOT NULL,
    [CountryRegion] [dbo].[Name]     NOT NULL,
    [PostalCode]    NVARCHAR (15)    NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Address_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate]  DATETIME         CONSTRAINT [DF_Address_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED ([AddressID] ASC),
    CONSTRAINT [AK_Address_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Address].[AddressLine1]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Address].[AddressLine2]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Address].[City]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Address].[PostalCode]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO

CREATE NONCLUSTERED INDEX [IX_Address_StateProvince]
    ON [SalesLT].[Address]([StateProvince] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion]
    ON [SalesLT].[Address]([AddressLine1] ASC, [AddressLine2] ASC, [City] ASC, [StateProvince] ASC, [PostalCode] ASC, [CountryRegion] ASC);


GO

