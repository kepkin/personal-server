import ipaddress
import sys

base = ipaddress.ip_address(sys.argv[1])

print(base +  int(sys.argv[2]))
