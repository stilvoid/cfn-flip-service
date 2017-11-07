"""
cfn-flip-service
"""

import cfn_flip

CONTENT_TYPE_JSON = "application/json"
CONTENT_TYPE_YAML = "application/x-yaml"

def from_json(json):
    return {
        "headers": {
            "Content-Type": CONTENT_TYPE_YAML,
        },
        "body": cfn_flip.to_yaml(json),
    }

def from_yaml(yaml):
    return {
        "headers": {
            "Content-Type": CONTENT_TYPE_JSON,
        },
        "body": cfn_flip.to_json(yaml),
    }

def handler(event, context):
    content_type = event["headers"]["Content-Type"]

    if content_type == CONTENT_TYPE_JSON:
        return from_json(event["body"])
    elif content_type == CONTENT_TYPE_YAML:
        return from_yaml(event["body"])

    return {
        "statusCode": 400,
        "body": "Unknown Content-Type: {}".format(content_type)
    }
