import unittest
from unittest.mock import patch, MagicMock
from update_record_ttl import update_record_ttl, MultipleRecordsFoundError, RecordNotFoundError


class TestUpdateRecordTTL(unittest.TestCase):

    @patch('boto3.client')
    def test_update_record_ttl_success(self, mock_boto3_client):
        # Mock Route 53 client
        mock_route53 = MagicMock()
        mock_boto3_client.return_value = mock_route53

        resource_record_set = {
            "Name": "example.com.",
            "Type": "CNAME",
            "TTL": 60,
            "ResourceRecords": [
                {
                    "Value": "main-green2.cluster-foo.us-east-1.rds.amazonaws.com"
                }
            ]
        }

        new_ttl = 600

        # Mock the list_resource_record_sets response
        mock_route53.list_resource_record_sets.return_value = {
            'ResourceRecordSets': [resource_record_set]
        }

        # Call the function
        update_record_ttl('Z1234567890', 'example.com.', new_ttl)

        # Assert list_resource_record_sets was called with correct parameters
        mock_route53.list_resource_record_sets.assert_called_once_with(
            HostedZoneId='Z1234567890',
            StartRecordName='example.com.',
            MaxItems='2'
        )

        # Assert change_resource_record_sets was called with correct parameters
        # (same params as before with only the TTL being different)
        mock_route53.change_resource_record_sets.assert_called_once_with(
            HostedZoneId='Z1234567890',
            ChangeBatch={
                'Changes': [
                    {
                        'Action': 'UPSERT',
                        'ResourceRecordSet': {
                            "Name": "example.com.",
                            "Type": "CNAME",
                            "TTL": new_ttl,
                            "ResourceRecords": [
                                {
                                    "Value": "main-green2.cluster-foo.us-east-1.rds.amazonaws.com"
                                }
                            ]
                        }
                    }
                ]
            }
        )

    @patch('boto3.client')
    def test_update_record_ttl_record_not_found(self, mock_boto3_client):
        # Mock Route 53 client
        mock_route53 = MagicMock()
        mock_boto3_client.return_value = mock_route53

        # Mock the list_resource_record_sets response with no matching records
        mock_route53.list_resource_record_sets.return_value = {
            'ResourceRecordSets': []
        }

        # Call the function and assert it raises RecordNotFoundError
        with self.assertRaises(RecordNotFoundError) as context:
            update_record_ttl('Z1234567890', 'nonexistent.com.', 600)

        self.assertEqual(str(context.exception), "Record nonexistent.com. not found in zone Z1234567890")

        # Assert change_resource_record_sets was not called
        mock_route53.change_resource_record_sets.assert_not_called()

    @patch('boto3.client')
    def test_update_record_ttl_multiple_records(self, mock_boto3_client):
        # Mock Route 53 client
        mock_route53 = MagicMock()
        mock_boto3_client.return_value = mock_route53

        # Mock the list_resource_record_sets response with multiple matching records
        mock_route53.list_resource_record_sets.return_value = {
            'ResourceRecordSets': [
                {'Name': 'example.com.', 'Type': 'A'},
                {'Name': 'example.com.', 'Type': 'AAAA'}
            ]
        }

        # Call the function and assert it raises MultipleRecordsFoundError
        with self.assertRaises(MultipleRecordsFoundError) as context:
            update_record_ttl('Z1234567890', 'example.com.', 600)

        self.assertEqual(str(context.exception), "Multiple records found for example.com. in zone Z1234567890")

        # Assert change_resource_record_sets was not called
        mock_route53.change_resource_record_sets.assert_not_called()


if __name__ == '__main__':
    unittest.main()
