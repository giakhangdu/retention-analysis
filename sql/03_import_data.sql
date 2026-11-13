USE MavenFlix;
GO

SELECT COUNT(*) AS rows_before_import
FROM dbo.subscriptions;

BULK INSERT dbo.subscriptions
FROM '/var/opt/mssql/data/mavenflix_clean.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS
);

SELECT 
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(canceled_date) AS missing_canceled_date
FROM dbo.subscriptions;