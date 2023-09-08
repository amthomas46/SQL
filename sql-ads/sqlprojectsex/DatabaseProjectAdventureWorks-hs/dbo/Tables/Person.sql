CREATE TABLE [dbo].[Person] (
    [PersonID]      INT             IDENTITY (1, 1) NOT NULL,
    [FullName]      NVARCHAR (50)   NOT NULL,
    [PreferredName] NVARCHAR (50)   NULL,
    [DateOfBirth]   DATETIME2 (7)   NULL,
    [PhoneNumber]   NVARCHAR (20)   NULL,
    [FaxNumber]     NVARCHAR (20)   NULL,
    [EmailAddress]  NVARCHAR (256)  NULL,
    [Photo]         VARBINARY (MAX) NULL,
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonID] ASC),
    INDEX [GRAPH_UNIQUE_INDEX_8054B31D47BC41008C033282F86428FE] UNIQUE NONCLUSTERED ($node_id)
) AS NODE;


GO

