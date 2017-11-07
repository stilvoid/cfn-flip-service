"""
cfn-flip-service
"""

import cfn_flip

CONTENT_TYPE_JSON = "application/json"
CONTENT_TYPE_YAML = "application/x-yaml"

def from_json(json):
    try:
        yaml = cfn_flip.to_yaml(json)
    except Exception as e:
        return user_error(e.message)

    return {
        "headers": {
            "Content-Type": CONTENT_TYPE_YAML,
        },
        "body": yaml,
    }

def from_yaml(yaml):
    try:
        json = cfn_flip.to_json(yaml)
    except Exception as e:
        return user_error(e.message)

    return {
        "headers": {
            "Content-Type": CONTENT_TYPE_JSON,
        },
        "body": json,
    }

def user_error(message):
    return {
        "statusCode": 400,
        "body": message,
    }

def handler(event, context):
    print(event)
    
    if "content-type" not in event["headers"]:
        return user_error("Missing Content-Type header")

    if not event["body"]:
        return user_error("Missing body")
        
    content_type = event["headers"]["content-type"]
    
    if content_type == CONTENT_TYPE_JSON:
        return from_json(event["body"])
    elif content_type == CONTENT_TYPE_YAML:
        return from_yaml(event["body"])

    return user_error("Unknown Content-Type: {}".format(content_type))
