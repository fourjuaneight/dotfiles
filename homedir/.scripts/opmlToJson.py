#!/usr/bin/env python3
import json
import sys
import xml.etree.ElementTree as ET

def opml_to_json(input_path, output_path=None):
    tree = ET.parse(input_path)
    root = tree.getroot()

    feeds = []
    for category in root.findall('./body/outline'):
        for item in category.findall('outline'):
            xml_url = item.get('xmlUrl')
            if xml_url:
                feeds.append({
                    'title': item.get('title') or item.get('text'),
                    'url': item.get('htmlUrl'),
                    'feed': xml_url,
                })

    result = json.dumps(feeds, indent=2)

    if output_path:
        with open(output_path, 'w') as f:
            f.write(result)
        print(f'Wrote {len(feeds)} feeds to {output_path}')
    else:
        print(result)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python opml2json.py <file.opml> [output.json]', file=sys.stderr)
        sys.exit(1)

    opml_to_json(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
