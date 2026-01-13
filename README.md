# blue-green-database-switchover

Scripts for orchestrating zero-downtime blue/green database migrations using AWS RDS and Route 53.

## Origin Story
These scripts were originally developed for a MySQL 5.7 to 8.0 major version upgrade in production, but the strategy and tooling are applicable to any blue/green database migration scenario.

## Learn More

- **[Blog Post: How We Upgraded Our Core Database With Just 5 Minutes of Downtime](https://careers.chime.com/en/life-at-chime/engineering-at-chime/how-we-upgraded-our-core-database-with-just-5-minutes-of-downtime/)** - Detailed write-up of the migration strategy and execution
- **[Sequence Diagram](https://sequencediagram.org/index.html?presentationMode=readOnly#initialData=C4S2BsFMAICFwK6QPQHEBOlIDtoGUB3MAYwAsB7AN0nQChaAHAQ3VGJGe2GgEEImAzrQAmTYEwBGgmAGIJiGPCQARWCLGTp0GXkhMMWXAZyr14qQNnykcBQAV0IALaRTTYsHLpoASWwAzdCYAUWwAcxBsLDpmVhB2Tm4AJXIEYEgAVgBmenAQf0g8qIFgAE8oWxVYbWtIAC4AJjrRAVJIYVo8gqLIEvKYY2xVbV19TBxG5sE2jq7CyN6yiqVIB2dXarkFSZaZ+lomNPJsBCcJGmgARn3scnToKguV1TqAeQRvc-BH4WgAYS8GwANNB0AhsNhImFoABZUp4ACKABloBlaLd7o9vIMXn9vlEHv5KsDoAgGGEgsJ2tBPLD4cjoAAOdF3GBY4lrFy4-FsonPaoACn8THA4CkxAA1tBiIgSjQAJQszHUbx8cCCOpqwTQJxMbBMMK9GltaXHKIeEDHAQ08j-QGqAB0AB1sD5uAhLNbgARbcIQCVIh5oDhhAxyJFgNb-F5oEk9MJrZQBA7oAB1RzpZMuvxgEAi8ClEESO6kWPx61637psBGkNhiOg3rkcDUG3Ex37LXWgC0AD527A6sEAB6QYhpI1xpi-StpjMwBFIRxGvAIYjEXoCfwIUWlfYU1IMbR5MKkYAUyClfCQYBkssMPLEMSW3B-UhMSK0PyBELhBYXPtoBxQddEjUkj0wB94mfY5oBdQJyCcAc22A2h+WgQDgLqOMoKfUBYPOCJsCEb8glCIjogw-sVk5DY6lA6070gx8YNweD0EQoDxiGapaRoxwuTUYCqI5AS6Jwlj8NwQjIiELsRP5OoAS4SIkGtSBR3HUBwjLadoFnat7kXGgQBXNcNwELcdwLWgQ3oA87xkE8z1KQpvgIaAADURRAUR7kwPSfXQCVvmnEiAjIv8ogA-su3om9rSnX4cEoaBKBYNskuDbBQ3DLhoAAai4wxVAAcnUnL63ygVLHQSh4hgCQr1q+qN0VeTALi5RIAfchSmtFqGtoDrqIUF4MgABgAUkJXTfmM5drTCW0+LGwVbkbXDWOgdUwna-ge37LDJpm8giSyhbTKWlbbWEgUNIYEycAszbJJfHaDX29VDoHJTjm0tTg00tIoTnGtoEusz103bdd3oOz9w4xzXNFcgPMIEgKBVObwp-cj-28TqDvisCspStKMtpYDyuy3KGxqmhWsa5rGYar7tSJ766m63r+ugQaN2Gg6RKwkcxwnRL4whpcrvwcyYesq97uHR7l2wF7mOgqSPr2+ykaPGQvD1Q1Y2bMV3AlIXvowmRMGEYdipMQcR1V0z1aNYUQCgX4sswABHNTIy-CLfwomLeGJhi5uy1L0u8WkycqvLuAFABeAcabrZP2Z+rqeu+PmBcgegRt+sWtMnKWDPnaWnutVdocs2GbIxNlsdI0OCews3xSlYRjkgB14Zy+gO-x6LCf7FIJ2yEnJb0rOGyp7iyoqunquUAA5PBpXfcJIEVYO8aiyjOY1KPE9jynbUT9eU6L6Amv51m2qtjnYuJnmC4Gl-i+HjpW4PGxnFJK10UIr1gAAbjBpmaAy02z8loA5A2DBIhSgxsAMg7JDJGlTunZQaMVIuFHiHcep9RpVDnshBO8ZuyvGwC3VkQCnhrSHFwGg89hB0IYVeJw5AqRvx7LbdoDtFIuyeu7a0AAxD83sYEwDjAHRYQh0KYQgdhfOWt3q7WgP6RsAhmzUA6GPE+4csIwiYBKI0wkCAZkkBUWcJRyAMGtJrPCL4lRtwuKLYcYBOHcILDqfhxcTFh0nqbGeWQqE4NplVbgy8SrVBdAKLeO8yDGwPoIkScUYmL3yqkxsxAvC-D0ZgQIvQ9ilx8eLWBBiXDyNrotOWjcrJww6sI+2jseL0VAKKaA4i1YvRkV7akMTFGBy9KQJGp5oAOHIMOPcoSCYiWnukWeUc5kLNicncBiSaabKvMkgp6T9452ycTA52yGwFMwEU9AJTXGQHKa0doR9IphIUqwgA0l7cA1plLmiknJYWajEkaKKRCMcQcsmgqdkOYGsCsrV3BpDeu8sm6Kz1oebQRt96m1FL3GFHSHY+Nds9I0dSYDDLkWMyASiShCDeZ3CeIt1FR2EjQ6cAS9yAPZKLdh6B-H0MCXwgR7S7YkvUQMt2L1LgTWmtAaloya7jOUfQYSgF+LrBeBJLRsEdGlKbC2V5SyWWavsGJF4FirHWi1YJaAtiwD2JgI4zwLjXp6uwJ45h3g7V0RHH4ua3KgkCNNeQiJayokXyrjlBpeT4m2j9cMI529d4ZLOWfAQGi9LIvuPG6ANyxzFN0Y855lSQXEtEtqkCvTwD9JVhIoZsjlXg1VQy400zSwHJIcfD5gFVmZCjQlWZHEtn5tWkgWiq8R3zMOdgFJqaTmGgzR-Lmlz82FruQ8xsZaTWkNMeErCPzRT-LNFCl8wLrbmsnZawccYIWAsZTCihqxb3wpqZXHNsaYmouaRZVpjDlQXDDTQOo+LzaSmgP3KIQ8EYI32EAA)** - Visual representation of the exact order of steps

## Directory structure

```
$ tree nonprod
.
├── 1.read-switchover
│   └── 1.point_read_dns_endpoints_to_green.sh
├── 2.read-rollback
│   ├── backup-dns-rollback
│   │   ├── 1.point_read_dns_endpoints_to_blue.sh
│   │   └── 2.kill_connections_on_green_readers.sh
│   └── readme.md
├── 3.prep-write-switchover
│   └── 1.lower_ttl.sh
├── 4.write-switchover
│   ├── 1.set_blue_to_read_only.sh
│   ├── 2.make_green_writable.sh
│   ├── 3.point_write_dns_endpoints_to_green.sh
│   └── 4.kill_connections_on_blue.sh
├── 5.write-rollback
│   ├── 1.set_green_to_read_only.sh
│   ├── 2.make_blueprime_writable.sh
│   ├── 3.point_all_4_dns_to_blueprime.sh
│   └── 4.kill_connections_on_green.sh
├── 6.post-upgrade
│   └── 1.raise_ttl.sh
└── 7.post-rollback
    └── 1.raise_ttl.sh
```

## Run tests

python -m unittest

## Update TTL script

Example output:

```
$ python update_record_ttl.py "qa.example.com" "mysql-core-batch-reader.qa.example.com." raise
Successfully updated TTL for mysql-core-batch-reader.qa.example.com. (Type: CNAME) to 60 seconds
```

## Kill connections script

Example output:

```
$ python kill_connections.py --db-port 10012 --dry-run
Found 4 processes to kill
Dry run mode: No processes will be killed
Would kill process ID: 73821
Would kill process ID: 73818
Would kill process ID: 73815
Would kill process ID: 73816
```

```
$ python kill_connections.py --db-port 10012          
Found 4 processes to kill
Killed processes: [73816]
Killed processes: [73821, 73818, 73815]
All kill commands have been sent
```
