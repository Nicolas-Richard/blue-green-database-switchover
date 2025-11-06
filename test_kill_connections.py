import unittest
from unittest.mock import patch, MagicMock
import kill_connections


class TestKillConnections(unittest.TestCase):

    @patch('mysql.connector.connect')
    def test_get_process_ids(self, mock_connect):
        # Mock the database connection and cursor
        mock_cursor = MagicMock()
        mock_connect.return_value.cursor.return_value = mock_cursor

        # Mock the fetchall method to return some test data
        mock_cursor.fetchall.return_value = [(1,), (2,), (3,)]

        result = kill_connections.get_process_ids(12345678)

        # Assert that the function returns the expected list of IDs
        self.assertEqual(result, [1, 2, 3])

        # Assert that the correct SQL query was executed
        expected_query = f"""
        SELECT id
        FROM information_schema.processlist
        WHERE user NOT IN ('event_scheduler', 'rdsadmin', 'rdsproxyadmin', 'master', 'datadog', 'pt_heartbeat')
        AND id != CONNECTION_ID()
        LIMIT {kill_connections.GET_PROCESS_BATCH_SIZE}
        """
        mock_cursor.execute.assert_called_once_with(expected_query)

        # Assert that the connection was made with the correct port
        mock_connect.assert_called_once_with(host='127.0.0.1', port=12345678)

    @patch('mysql.connector.connect')
    def test_kill_processes(self, mock_connect):
        # Mock the database connection and cursor
        mock_cursor = MagicMock()
        mock_connect.return_value.cursor.return_value = mock_cursor

        kill_connections.kill_processes(([1, 2, 3], 12345678))

        # Assert that rds_kill was called for each process ID
        calls = [unittest.mock.call(f"CALL mysql.rds_kill({pid})") for pid in [1, 2, 3]]
        mock_cursor.execute.assert_has_calls(calls, any_order=True)

        # Assert that commit was called once at the end
        mock_connect.return_value.commit.assert_called_once()

        # Assert that the connection was closed
        mock_connect.return_value.close.assert_called_once()

        # Assert that the connection was made with the correct port
        mock_connect.assert_called_once_with(host='127.0.0.1', port=12345678)

    @patch('kill_connections.get_process_ids')
    @patch('kill_connections.Pool')
    def test_main(self, mock_pool, mock_get_process_ids):
        # Create a mock args object
        args = MagicMock()
        args.dry_run = False
        args.db_port = 12345678

        # Mock get_process_ids to return a list of IDs
        mock_get_process_ids.return_value = list(range(1, 101))  # 100 process IDs

        # Create a mock for the pool's map function
        mock_map = MagicMock()
        mock_pool.return_value.__enter__.return_value.map = mock_map

        # Call the main function
        kill_connections.main(args)

        # Assert that Pool was created with the correct number of processes
        mock_pool.assert_called_once_with(kill_connections.PARALLELISM)

        # Assert that map was called once
        mock_map.assert_called_once()

        # Check the arguments passed to map
        call_args = mock_map.call_args[0]
        self.assertEqual(call_args[0], kill_connections.kill_processes)  # First arg should be the kill_processes function

        # Check that the second argument is a list of chunks
        chunks = list(call_args[1])
        self.assertEqual(len(chunks), 34)  # Should be 34 chunks of 3 each (KILL_QUERY_BATCH_SIZE), plus one chunk of 1

        # Check the content of the first and last chunks
        self.assertEqual(chunks[0], ([1, 2, 3], 12345678))
        self.assertEqual(chunks[-1], ([100], 12345678))

        # Assert that get_process_ids was called with the correct port
        mock_get_process_ids.assert_called_once_with(12345678)


if __name__ == '__main__':
    unittest.main()
