"""
$ python update_record_ttl.py "qa.example.com" "mysql-core-batch-reader.qa.example.com." raise
Successfully updated TTL for mysql-core-batch-reader.qa.example.com. (Type: CNAME) to 60 seconds
"""

import argparse
import boto3

ZONE_NAME_TO_ID = {
    "qa.example.com": "ZXXXXXXXXXXXXX",
    "prod.example.com": "ZYYYYYYYYYYYYYY",
}


class RecordNotFoundError(Exception):
    pass


class MultipleRecordsFoundError(Exception):
    pass


def update_record_ttl(zone_id, record_name, new_ttl):

    route53 = boto3.client('route53')

    # Get the current record
    response = route53.list_resource_record_sets(
        HostedZoneId=zone_id,
        StartRecordName=record_name,
        MaxItems='2'
    )

    matching_records = [record for record in response['ResourceRecordSets'] if record['Name'] == record_name]

    if len(matching_records) == 0:
        raise RecordNotFoundError(f"Record {record_name} not found in zone {zone_id}")
    elif len(matching_records) > 1:
        raise MultipleRecordsFoundError(f"Multiple records found for {record_name} in zone {zone_id}")

    current_record = matching_records[0]

    # Update only the TTL
    current_record['TTL'] = new_ttl

    # Prepare the change batch
    change_batch = {
        'Changes': [
            {
                'Action': 'UPSERT',
                'ResourceRecordSet': current_record
            }
        ]
    }

    # Apply the change
    route53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch=change_batch
    )

    print(f"Successfully updated TTL for {record_name} (Type: {current_record['Type']}) to {new_ttl} seconds")


def raise_ttl(zone_id, record_name):
    update_record_ttl(zone_id, record_name, 60)


def lower_ttl(zone_id, record_name):
    update_record_ttl(zone_id, record_name, 5)


def get_zone_id_from_name(zone_name):
    if zone_name in ZONE_NAME_TO_ID:
        return ZONE_NAME_TO_ID[zone_name]
    else:
        raise ValueError(f"No Zone ID found for zone name: {zone_name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Update TTL for a Route 53 record")
    parser.add_argument("zone_name", help="The Route 53 zone name")
    parser.add_argument("record_name", help="The record name to update")
    parser.add_argument("action", choices=["raise", "lower"],
                        help="Action to perform: 'raise' sets TTL to 60s, 'lower' sets TTL to 5s")

    args = parser.parse_args()

    zone_id = get_zone_id_from_name(args.zone_name)

    if args.action == "raise":
        raise_ttl(zone_id, args.record_name)
    elif args.action == "lower":
        lower_ttl(zone_id, args.record_name)
