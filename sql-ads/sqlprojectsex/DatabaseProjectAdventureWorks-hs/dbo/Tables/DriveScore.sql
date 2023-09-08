CREATE TABLE [dbo].[DriveScore] (
    [DriveScoreID]      INT            NULL,
    [Rank]              INT            NULL,
    [Rating]            INT            NULL,
    [Trend]             DECIMAL (5, 2) NULL,
    [rank_change]       INT            NULL,
    [brake_score]       BIGINT         NULL,
    [fuel_score]        BIGINT         NULL,
    [weather_score]     BIGINT         NULL,
    [lane_change_score] BIGINT         NULL,
    [overall_score]     BIGINT         NULL,
    INDEX [GRAPH_UNIQUE_INDEX_AF7B5D5A2D274FCAAFBA8BB35E4295BB] UNIQUE NONCLUSTERED ($node_id)
) AS NODE;


GO

