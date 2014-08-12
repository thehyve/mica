#!/usr/bin/env python
import sys 

def is_there_new_build(server, plan):
    import urllib, os.path
    from xml.dom import minidom
    latest_build_number_file_name = '.latest_build_number'
    if not os.path.isfile(latest_build_number_file_name):
        saved_build_number = None
    else:
        with open(latest_build_number_file_name, 'r') as latest_build_number_file:
            saved_build_number = latest_build_number_file.read()
    latest_build_info_url = "%s/rest/api/latest/result/%s/latest/" % (server, plan)
    latest_build_info_dom = minidom.parse(urllib.urlopen(latest_build_info_url))
    root_dom_element = latest_build_info_dom.documentElement
    if not root_dom_element.getAttribute('finished') == 'true':
        print 'Build in progress. Try to call another time.'
        sys.exit(1)
    latest_build_number = root_dom_element.getAttribute('number')
    if latest_build_number == saved_build_number:
        return False
    with open(latest_build_number_file_name, 'w') as latest_build_number_file:
        latest_build_number_file.write(latest_build_number)
    return True

if not len(sys.argv) == 3:
    print './is_there_new_build.py <bamboo server url> <bamboo plan>'
    print 'e.g. ./is_there_new_build.py https://ci.ctmmtrait.nl OC-MIC'
    sys.exit(1)

if is_there_new_build(sys.argv[1], sys.argv[2]):
    sys.exit(0)
else:
    sys.exit(1)