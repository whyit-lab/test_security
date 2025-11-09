# import requests

# api_url = 'http://localhost:3000/api/datasources'
# headers = {
#     'Accept': 'application/json',
#     'Content-Type': 'application/json',
#     'Authorization': 'Bearer eyJrIjoiT0tTcG1pUlY2RnVKZTFVaDFsNFZXdE9ZWmNrMkZYbk',
# }
# res = requests.get(api_url, headers=headers, verify=False)
# print(res)

# exaple call
# python3 delete_grafana_datasources.py -host dev1.whyit.co.kr:8082/grafana -user admin -password '' -match ''

import subprocess
import json
from pprint import pprint
import argparse

arg_parser = argparse.ArgumentParser(description='delete grafana datasources')
arg_parser.add_argument('-host', help='grafana ip:port')
arg_parser.add_argument('-user', help='grafana user id')
arg_parser.add_argument('-password', help='grafana user password')
arg_parser.add_argument('-match', help='datasource name pattern')
args = arg_parser.parse_args()

# print(args)

cmd = ['curl', '-s', f'http://{args.host}/api/datasources', '-u', f"{args.user}:'{args.password}'"]
print(' '.join(cmd))
result = subprocess.check_output(' '.join(cmd), shell=True, universal_newlines=True)
# pprint(result)
datasources = json.loads(result)

meraki_datasources = [e for e in datasources if e['name'].startswith(args.match)]
pprint(meraki_datasources)
for ds in meraki_datasources:
    ds_id = ds['id']
    print(ds_id)
    cmd = [
        f'curl -X "DELETE" "http://{args.host}/api/datasources/{ds_id}"',
        '-H "Content-Type: application/json" ',
        f"--user {args.user}:'{args.password}'",
    ]
    result = subprocess.check_output(' '.join(cmd), shell=True, universal_newlines=True)
    print(result)