DECLARE @Matter AS NVARCHAR(50) = '16113-0%AU%'
SELECT
    [pvt].[MatterID]
    ,[pvt].[Billing]
    ,[pvt].[Supervising]
    ,[pvt].[Handling]
    ,[pvt].[Foreign Paralegal]
    ,[pvt].[IDS Paralegal]
    ,[pvt].[US Paralegal]
FROM
    (
        SELECT
            [m].[MatterID]
            ,[mp].[AssignedType]
            ,[p].[Initials]
        FROM [dbo].[Matters]                         [m]
             INNER JOIN [dbo].[MattersProfessionals] [mp] ON [mp].[Matters] = [m].[Matters]
             INNER JOIN [dbo].[Professionals]         [p] ON [p].[Professionals] = [mp].[Professionals]
        WHERE [mp].[AssignedType] IN
              (
                  'Billing', 'Supervising', 'Handling', 'Foreign Paralegal', 'IDS Paralegal', 'US Paralegal'
              )
            AND [m].[MatterID] LIKE @Matter
    ) AS [mp]
PIVOT
    (
        MIN([mp].[Initials])
        FOR [mp].[AssignedType] IN
        (
            [Billing], [Supervising], [Handling], [Foreign Paralegal], [IDS Paralegal], [US Paralegal]
        )
    ) AS [pvt]
ORDER BY [pvt].[MatterID]