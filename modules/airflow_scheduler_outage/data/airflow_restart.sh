

#!/bin/bash



# Stop the Airflow scheduler

sudo systemctl restart airflow-scheduler.service



# Wait for a few seconds to ensure the process has restarted

sleep 5



# Check the status of the Airflow scheduler to ensure it's running

sudo systemctl status airflow-scheduler.service