CREATE TABLE [SalesLT].[Customer] (
    [CustomerID]   INT                                               IDENTITY (1, 1) NOT NULL,
    [NameStyle]    [dbo].[NameStyle]                                 CONSTRAINT [DF_Customer_NameStyle] DEFAULT ((0)) NOT NULL,
    [Title]        NVARCHAR (8)                                      NULL,
    [FirstName]    [dbo].[Name] MASKED WITH (FUNCTION = 'default()') NOT NULL,
    [MiddleName]   [dbo].[Name] MASKED WITH (FUNCTION = 'default()') NULL,
    [LastName]     [dbo].[Name] MASKED WITH (FUNCTION = 'default()') NOT NULL,
    [Suffix]       NVARCHAR (10)                                     NULL,
    [CompanyName]  NVARCHAR (128)                                    NULL,
    [SalesPerson]  NVARCHAR (256)                                    NULL,
    [EmailAddress] NVARCHAR (50)                                     NULL,
    [Phone]        [dbo].[Phone]                                     NULL,
    [PasswordHash] VARCHAR (128)                                     NOT NULL,
    [PasswordSalt] VARCHAR (10)                                      NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER                                  CONSTRAINT [DF_Customer_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate] DATETIME                                          CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [AK_Customer_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Customer].[FirstName]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = 'bf91e08c-f4f0-478a-b016-25164b2a65ff', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22f5-9659-15b24aeb125e', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Customer].[MiddleName]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = 'bf91e08c-f4f0-478a-b016-25164b2a65ff', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22f5-9659-15b24aeb125e', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Customer].[LastName]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = 'bf91e08c-f4f0-478a-b016-25164b2a65ff', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22f5-9659-15b24aeb125e', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Customer].[EmailAddress]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Customer].[Phone]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Customer].[PasswordHash]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [SalesLT].[Customer].[PasswordSalt]
    WITH (LABEL = 'Confidential', LABEL_ID = '05e6eaa1-075a-4fb4-a732-a92215a2444a', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO

CREATE NONCLUSTERED INDEX [IX_Customer_EmailAddress]
    ON [SalesLT].[Customer]([EmailAddress] ASC);


GO

