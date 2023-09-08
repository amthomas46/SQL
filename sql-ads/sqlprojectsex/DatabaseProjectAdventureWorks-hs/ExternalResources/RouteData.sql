CREATE EXTERNAL DATA SOURCE [RouteData]
    WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = N'https://azuresqlworkshopsa.blob.core.windows.net/bus',
    CREDENTIAL = [AzureBlobCredentials]
    );


GO

