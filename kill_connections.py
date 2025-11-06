import argparse
import sys
import mysql.connector
from multiprocessing import Pool

# Configuration
GET_PROCESS_BATCH_SIZE = 300
KILL_QUERY_BATCH_SIZE = 30
PARALLELISM = 10


def get_process_ids(db_port):
    """Get process IDs from the DB"""
    try:
        conn = mysql.connector.connect(host='127.0.0.1', port=db_port)
        cursor = conn.cursor()
        cursor.execute(f"""
        SELECT id
        FROM information_schema.processlist
        WHERE user NOT IN ('event_scheduler', 'rdsadmin', 'rdsproxyadmin', 'master', 'datadog', 'pt_heartbeat')
        AND id != CONNECTION_ID()
        LIMIT {GET_PROCESS_BATCH_SIZE}
        """)
        return [row[0] for row in cursor.fetchall()]
    except mysql.connector.Error as err:
        print(f"Error: {err}", file=sys.stderr)
        sys.exit(1)
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()


def kill_processes(args):
    """Kill processes with the given IDs"""
    ids, db_port = args
    try:
        conn = mysql.connector.connect(host='127.0.0.1', port=db_port)
        cursor = conn.cursor()
        for id in ids:
            cursor.execute(f"CALL mysql.rds_kill({id})")
        conn.commit()
        print(f"Killed processes: {ids}", file=sys.stderr)
    except mysql.connector.Error as err:
        print(f"Error: {err}", file=sys.stderr)
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()


def main(args):
    process_ids = get_process_ids(args.db_port)
    print(f"Found {len(process_ids)} processes to kill")

    if args.dry_run:
        print("Dry run mode: No processes will be killed")
        for pid in process_ids:
            print(f"Would kill process ID: {pid}")
    else:
        # Split process_ids into chunks of KILL_QUERY_BATCH_SIZE
        id_chunks = [process_ids[i:i + KILL_QUERY_BATCH_SIZE] for i in
                     range(0, len(process_ids), KILL_QUERY_BATCH_SIZE)]

        # Prepare arguments for kill_processes
        kill_args = [(chunk, args.db_port) for chunk in id_chunks]

        # Use multiprocessing to parallelize the kill_processes function
        with Pool(PARALLELISM) as pool:
            pool.map(kill_processes, kill_args)

        print("All kill commands have been sent")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Kill MySQL processes")
    parser.add_argument("--db-port", type=int, required=True, help="Database port number")
    parser.add_argument("--dry-run", action="store_true", help="Perform a dry run without actually killing processes")
    args = parser.parse_args()
    main(args)
