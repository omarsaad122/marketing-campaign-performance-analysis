USE Marketing_Analytics;
GO

SELECT *
FROM dbo.Marketing_Campaigns;

SELECT COUNT(*) AS Total_Campaigns
FROM dbo.Marketing_Campaigns;

SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE WHEN Campaign_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,

    SUM(CASE WHEN Company IS NULL THEN 1 ELSE 0 END) AS Missing_Company,

    SUM(CASE WHEN Campaign_Type IS NULL THEN 1 ELSE 0 END) AS Missing_Campaign_Type,

    SUM(CASE WHEN Conversion_Rate IS NULL THEN 1 ELSE 0 END) AS Missing_Conversion_Rate,

    SUM(CASE WHEN Acquisition_Cost IS NULL THEN 1 ELSE 0 END) AS Missing_Acquisition_Cost,

    SUM(CASE WHEN ROI IS NULL THEN 1 ELSE 0 END) AS Missing_ROI,

    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Missing_Date

FROM dbo.Marketing_Campaigns;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Campaign_ID) AS Unique_Campaigns,
    COUNT(*) - COUNT(DISTINCT Campaign_ID) AS Duplicate_IDs
FROM dbo.Marketing_Campaigns;

SELECT

    MIN(Conversion_Rate) AS Min_Conversion_Rate,
    MAX(Conversion_Rate) AS Max_Conversion_Rate,

    MIN(ROI) AS Min_ROI,
    MAX(ROI) AS Max_ROI,

    MIN(Engagement_Score) AS Min_Engagement,
    MAX(Engagement_Score) AS Max_Engagement,

    SUM(CASE
        WHEN Conversion_Rate < 0 OR Conversion_Rate > 1
        THEN 1 ELSE 0
    END) AS Invalid_Conversion_Rate,

    SUM(CASE
        WHEN Engagement_Score < 1 OR Engagement_Score > 10
        THEN 1 ELSE 0
    END) AS Invalid_Engagement,

    SUM(CASE
        WHEN Clicks < 0 OR Impressions < 0
        THEN 1 ELSE 0
    END) AS Invalid_Clicks_Impressions,

    SUM(CASE
        WHEN TRY_CONVERT(FLOAT,
            REPLACE(REPLACE(Acquisition_Cost, '$', ''), ',', '')
        ) IS NULL
        THEN 1 ELSE 0
    END) AS Invalid_Acquisition_Cost

FROM dbo.Marketing_Campaigns;

SELECT TOP 10

    Campaign_ID,

    Acquisition_Cost AS Original_Cost,

    TRY_CONVERT(
        FLOAT,
        REPLACE(
            REPLACE(Acquisition_Cost, '$', ''),
            ',', ''
        )
    ) AS Clean_Cost

FROM dbo.Marketing_Campaigns;

USE Marketing_Analytics;
GO

CREATE OR ALTER VIEW dbo.vw_Marketing_Campaigns_Clean
AS
SELECT
    *,
    TRY_CONVERT(
        DECIMAL(18,2),
        REPLACE(
            REPLACE(Acquisition_Cost, '$', ''),
            ',', ''
        )
    ) AS Acquisition_Cost_Clean

FROM dbo.Marketing_Campaigns;
GO

SELECT TOP 10 *
FROM dbo.vw_Marketing_Campaigns_Clean;

SELECT
    Channel_Used,

    COUNT(*) AS Total_Campaigns,

    ROUND(AVG(ROI), 2) AS Avg_ROI,

    ROUND(AVG(Conversion_Rate) * 100, 2)
        AS Avg_Conversion_Percentage,

    ROUND(AVG(Acquisition_Cost_Clean), 2)
        AS Avg_Acquisition_Cost

FROM dbo.vw_Marketing_Campaigns_Clean

GROUP BY Channel_Used

ORDER BY Avg_ROI DESC;

SELECT

    Campaign_Type,

    COUNT(*) AS Total_Campaigns,

    ROUND(AVG(ROI), 2) AS Avg_ROI,

    ROUND(AVG(Conversion_Rate) * 100, 2)
        AS Avg_Conversion_Percentage,

    ROUND(AVG(Acquisition_Cost_Clean), 2)
        AS Avg_Acquisition_Cost

FROM dbo.vw_Marketing_Campaigns_Clean

GROUP BY Campaign_Type

ORDER BY Avg_ROI DESC;

SELECT

    Customer_Segment,

    COUNT(*) AS Total_Campaigns,

    ROUND(AVG(ROI), 2) AS Avg_ROI,

    ROUND(AVG(Conversion_Rate) * 100, 2)
        AS Avg_Conversion_Percentage,

    ROUND(AVG(Acquisition_Cost_Clean), 2)
        AS Avg_Acquisition_Cost

FROM dbo.vw_Marketing_Campaigns_Clean

GROUP BY Customer_Segment

ORDER BY Avg_ROI DESC;

SELECT

    Target_Audience,

    COUNT(*) AS Total_Campaigns,

    ROUND(AVG(ROI), 2) AS Avg_ROI,

    ROUND(AVG(Conversion_Rate) * 100, 2)
        AS Avg_Conversion_Percentage,

    ROUND(AVG(Acquisition_Cost_Clean), 2)
        AS Avg_Acquisition_Cost

FROM dbo.vw_Marketing_Campaigns_Clean

GROUP BY Target_Audience

ORDER BY Avg_Conversion_Percentage DESC;

SELECT

    Location,

    COUNT(*) AS Total_Campaigns,

    ROUND(AVG(ROI), 2) AS Avg_ROI,

    ROUND(AVG(Conversion_Rate) * 100, 2)
        AS Avg_Conversion_Percentage,

    ROUND(AVG(Acquisition_Cost_Clean), 2)
        AS Avg_Acquisition_Cost

FROM dbo.vw_Marketing_Campaigns_Clean

GROUP BY Location

ORDER BY Avg_ROI DESC;

SELECT

    YEAR([Date]) AS Campaign_Year,

    MONTH([Date]) AS Campaign_Month,

    COUNT(*) AS Total_Campaigns,

    ROUND(AVG(ROI), 2) AS Avg_ROI,

    ROUND(AVG(Conversion_Rate) * 100, 2)
        AS Avg_Conversion_Percentage,

    ROUND(AVG(Acquisition_Cost_Clean), 2)
        AS Avg_Acquisition_Cost

FROM dbo.vw_Marketing_Campaigns_Clean

GROUP BY
    YEAR([Date]),
    MONTH([Date])

ORDER BY
    Campaign_Year,
    Campaign_Month;