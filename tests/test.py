from google.cloud import bigquery

client = bigquery.Client()

query = """
SELECT "test connection" AS status
"""

query_job = client.query(query)
result = query_job.result()

for row in result:
    print(row.status)
