Create procedure GetRequests
 as
 SELECT r.session_id
 , DB_NAME(s.database_id) [DB Name (session)]
 , s.host_name
 , s.nt_user_name
 , r.command
 , r.status
 , r.cpu_time
 , r.total_elapsed_time
 , r.logical_reads
 , r.command
 , wait_time
 , wait_type
 , wait_resource
 , blocking_session_id
 ,percent_complete
 , s.program_name
 , r.granted_query_memory
 , r.writes
 , r.reads [Request Reads]
 , r.page_server_reads as [PageServerReads]
 , s.reads [Session Reads]
 , s.logical_reads [Session Logical Reads]
 , (REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(qt.text, r.statement_start_offset / 2 + 1,
 (CASE WHEN r.statement_end_offset = -1
 THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
 ELSE r.statement_end_offset
 END - r.statement_start_offset) / 2), ' ', ''), CHAR(13),
 ''), CHAR(10), ''), CHAR(9), '')) AS statement_text
 , SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(qt.text, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9),
 ''), 1, 256) AS batch_text
 , qt.objectid
 --, qp.query_plan
 , DB_NAME(qt.dbid) [DB Name (object)]
 , r.plan_handle
 , r.sql_handle
 , r.query_hash, r.query_plan_hash
 , qt.objectid
 FROM sys.dm_exec_requests r
 LEFT OUTER JOIN sys.dm_exec_sessions s ON (s.session_id = r.session_id)
 OUTER APPLY sys.dm_exec_sql_text(sql_handle) AS qt
 --OUTER APPLY sys.dm_exec_query_plan(plan_handle) AS qp
 WHERE 1=1
 --AND r.session_id > 50
 AND [program_name] IS NOT NULL
 OR COMMAND like '%REDO%'
 ORDER BY r.session_id ASC

GO

