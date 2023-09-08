CREATE TABLE [dbo].[EventCategory] (
    [EventCategoryID]   INT           IDENTITY (1, 1) NOT NULL,
    [EventCategoryName] NVARCHAR (30) NOT NULL,
    CONSTRAINT [PK_EventCategory] PRIMARY KEY CLUSTERED ([EventCategoryID] ASC)
);


GO

