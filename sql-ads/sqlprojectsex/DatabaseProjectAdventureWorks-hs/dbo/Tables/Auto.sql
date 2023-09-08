CREATE TABLE [dbo].[Auto] (
    [AutoID]        INT           IDENTITY (1, 1) NOT NULL,
    [OwnerID]       INT           NOT NULL,
    [VIN]           NVARCHAR (20) NOT NULL,
    [Make]          NVARCHAR (30) NOT NULL,
    [Model]         NVARCHAR (30) NOT NULL,
    [Year]          INT           NOT NULL,
    [DriveTrain]    NVARCHAR (10) NULL,
    [EngineType]    NVARCHAR (30) NULL,
    [ExteriorColor] NVARCHAR (30) NULL,
    [InteriorColor] NVARCHAR (30) NULL,
    [Transmission]  NVARCHAR (30) NULL,
    CONSTRAINT [PK_Auto] PRIMARY KEY CLUSTERED ([AutoID] ASC),
    INDEX [GRAPH_UNIQUE_INDEX_DE85AB72B56643B39B9B8FE9C6E9717B] UNIQUE NONCLUSTERED ($node_id)
) AS NODE;


GO

