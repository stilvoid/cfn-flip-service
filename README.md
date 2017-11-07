# cfn-flip-service

A serverless API that converts CloudFormation templates between JSON and YAML formats

cfn-flip-service uses [cfn-flip](https://github.com/awslabs/aws-cfn-template-flip/) and provides an API for it.

## Usage

### Converting JSON templates to YAML

`POST` your template with the `Content-Type` header set to `application/json`. The response body will contain the reformatted template as YAML with a `Content-Type` of `application/x-yaml`

#### Example

    curl -X POST -H "Content-Type: application/json" -d "$(<my-cfn.template)" http://{endpoint}/

### Converting YAML templates to JSON

`POST` your template with the `Content-Type` header set to `application/x-yaml`. The response body will contain the reformatted template as JSON with a `Content-Type` of `application/json`

#### Example

    curl -X POST -H "Content-Type: application/x-yaml" -d "$(<my-cfn.template)" http://{endpoint}/

## Maintenance

You will need [python 3](https://www.python.org/) and [pip](https://pypi.python.org/pypi/pip/) installed.

Use the `install.sh` script to deploy or update the service.

Use the `uninstall.sh` script to remove the service from your account.
