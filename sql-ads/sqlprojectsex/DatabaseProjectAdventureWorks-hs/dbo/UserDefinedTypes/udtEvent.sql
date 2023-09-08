CREATE TYPE [dbo].[udtEvent] AS TABLE (
    [RowID]                    INT              NOT NULL,
    [EventID]                  UNIQUEIDENTIFIER NOT NULL,
    [AutoID]                   INT              NOT NULL,
    [EventCategoryID]          INT              NOT NULL,
    [EventMessage]             NVARCHAR (100)   NULL,
    [City]                     NVARCHAR (50)    NULL,
    [OutsideTemperature]       DECIMAL (5, 2)   NULL,
    [EngineTemperature]        DECIMAL (5, 2)   NULL,
    [Speed]                    DECIMAL (5, 2)   NULL,
    [Fuel]                     INT              NULL,
    [EngineOil]                DECIMAL (5, 2)   NULL,
    [TirePressure]             DECIMAL (5, 2)   NULL,
    [Odometer]                 INT              NULL,
    [AcceleratorPedalPosition] INT              NULL,
    [ParkingBrakeStatus]       BIT              NULL,
    [HeadlampStatus]           BIT              NULL,
    [BrakePedalStatus]         BIT              NULL,
    [TransmissionGearPosition] INT              NULL,
    [IgnitionStatus]           BIT              NULL,
    [WindshieldWiperStatus]    BIT              NULL,
    [Abs]                      BIT              NULL,
    [PostalCode]               NVARCHAR (5)     NULL,
    [Timestamp]                DATETIME2 (7)    NULL,
    INDEX [IX_AutoID] ([AutoID]));


GO

