--==================================================================
-- STEP 7: Create Natively compiled stored procedure: dbo.InsertEvent
--==================================================================
CREATE   PROCEDURE [dbo].[InsertEvent] 
	@Batch AS dbo.udtEvent READONLY,
	@BatchSize INT
	AS
	DECLARE @i INT = 1
	DECLARE @EventID uniqueidentifier
	DECLARE @AutoID int
	DECLARE @EventCategoryID int
	DECLARE @EventMessage nvarchar(100)
	DECLARE @City nvarchar(50)
	DECLARE @OutsideTemperature decimal(5, 2)
	DECLARE @EngineTemperature decimal(5, 2)
	DECLARE @Speed decimal(5, 2)
	DECLARE @Fuel int
	DECLARE @EngineOil decimal(5, 2)
	DECLARE @TirePressure decimal(5, 2)
	DECLARE @Odometer int
	DECLARE @AcceleratorPedalPosition int
	DECLARE @ParkingBrakeStatus bit
	DECLARE @HeadlampStatus bit
	DECLARE @BrakePedalStatus bit
	DECLARE @TransmissionGearPosition int
	DECLARE @IgnitionStatus bit
	DECLARE @WindshieldWiperStatus bit
	DECLARE @Abs bit
	DECLARE @PostalCode nvarchar(5)

	insert into dbo.Events (EventID, AutoID, EventCategoryID, EventMessage, City, OutsideTemperature, EngineTemperature, Speed, Fuel, EngineOil, TirePressure, Odometer, AcceleratorPedalPosition, ParkingBrakeStatus, HeadlampStatus, BrakePedalStatus, TransmissionGearPosition, IgnitionStatus, WindshieldWiperStatus, Abs, PostalCode)
	select EventID, AutoID, EventCategoryID, EventMessage, City, OutsideTemperature, EngineTemperature, Speed, Fuel, EngineOil, TirePressure, Odometer, AcceleratorPedalPosition, ParkingBrakeStatus
	, HeadlampStatus, BrakePedalStatus, TransmissionGearPosition, IgnitionStatus, WindshieldWiperStatus, [Abs], PostalCode
	from @Batch

	--WHILE (@i <= @BatchSize)
	--BEGIN	
	
	--	SELECT	@EventID = EventID,
	--			@AutoID = AutoID,
	--			@EventCategoryID = EventCategoryID,
	--			@EventMessage = EventMessage,
	--			@City = City,
	--			@OutsideTemperature = OutsideTemperature,
	--			@EngineTemperature = EngineTemperature,
	--			@Speed = Speed,
	--			@Fuel = Fuel,
	--			@EngineOil = EngineOil,
	--			@TirePressure = TirePressure,
	--			@Odometer = Odometer,
	--			@AcceleratorPedalPosition = AcceleratorPedalPosition,
	--			@ParkingBrakeStatus = ParkingBrakeStatus,
	--			@HeadlampStatus = HeadlampStatus,
	--			@BrakePedalStatus = BrakePedalStatus,
	--			@TransmissionGearPosition = TransmissionGearPosition,
	--			@IgnitionStatus = IgnitionStatus,
	--			@WindshieldWiperStatus = WindshieldWiperStatus,
	--			@Abs = Abs,		
	--			@PostalCode = PostalCode
	--	FROM	@Batch
	--	WHERE	RowID = @i
		
	----	UPDATE	dbo.Events 
	----	SET		EventID = @EventID,
	----			EventCategoryID = @EventCategoryID,
	----			EventMessage = @EventMessage,
	----			City = City,
	----			OutsideTemperature = @OutsideTemperature,
	----			EngineTemperature = @EngineTemperature,
	----			Speed = @Speed,
	----			Fuel = @Fuel,
	----			EngineOil = @EngineOil,
	----			TirePressure = @TirePressure,
	----			Odometer += 1,
	----			AcceleratorPedalPosition = @AcceleratorPedalPosition,
	----			ParkingBrakeStatus = @ParkingBrakeStatus,
	----			HeadlampStatus = @HeadlampStatus,
	----			BrakePedalStatus = @BrakePedalStatus,
	----			TransmissionGearPosition = @TransmissionGearPosition,
	----			IgnitionStatus = @IgnitionStatus,
	----			WindshieldWiperStatus = @WindshieldWiperStatus,
	----			Abs = @Abs,
	----			PostalCode = PostalCode
	----	WHERE	AutoID = @AutoID							
		
	----	IF(@@ROWCOUNT = 0)
	----	BEGIN
	--		INSERT INTO dbo.Events (EventID, AutoID, EventCategoryID, EventMessage, City, OutsideTemperature, EngineTemperature, Speed, Fuel, EngineOil, TirePressure, Odometer, AcceleratorPedalPosition, ParkingBrakeStatus, HeadlampStatus, BrakePedalStatus, TransmissionGearPosition, IgnitionStatus, WindshieldWiperStatus, Abs, PostalCode)
	--		VALUES (@EventID, @AutoID, @EventCategoryID, @EventMessage, @City, @OutsideTemperature, @EngineTemperature, @Speed, @Fuel, @EngineOil, @TirePressure, @Odometer, @AcceleratorPedalPosition, @ParkingBrakeStatus, @HeadlampStatus, @BrakePedalStatus, @TransmissionGearPosition, @IgnitionStatus, @WindshieldWiperStatus, @Abs, @PostalCode);			
	----	END 

	--	SET @i += 1
	--END	

GO

