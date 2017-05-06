---
title: Iottly API reference
---

# Welcome to Iottly API Documentation

## Core concepts

The three building blocks of Iottly are *projects*, *devices* and *deployment groups*. The *project* is the container that keeps things together, the *device* is a board (both real or virtual) where your code is running inside the *Iottly sandbox* and finally the *deployment group* which are a set of your boards where your code will be deployed.

To have more information on how deployment is handled in Iottly see this [document FIXME url](http://iottly.com/).

There are two main ways to interact with the Iottly platform: API and Webhooks.

## API Authentication

APIs are authenticated by including a secret token in the request. You can manage your tokens from the [Dashboard FIXMEURL](https://iottly.com/). Your API tokens permits access to your data, do not share them publically.

Authentication to the API is performed via HTTP Basic Authentication.

Assuming a token of `0123456789` a request with curl will look like this:

```
$ curl -H "Authentication: bearer 0123456789" https://iottly.com/v1.0/ping
{"status": "pong"}
```

 All the APIs are authenticated. Unauthenticated calls will return a 401 HTTP status code.

## API errors

API calls may fail and an error would be returned. A relevant HTTP status code would be set. A description of the error will be available as `error` in the JSON response payload.

## API reference

All the APIs accepts and returns JSON.

### Inspect a project

To inspect a project, i.e. the deployments groups and board associated to them send a GET request to the following API endpoint:

```
curl -H 'Content-Type: application/json' https://iottly.com/v1.0/project/<project id>/inspect
```

In this example our projectid `58f73b41c3cc4800078010c5` has just one board associated to the default *_orhpaned* deployment group:

```
{
    "deployment_groups": [
        {
            "status": "",
            "boards": [
                "a2792ce8-216f-477c-a5cc-4f7e9f407e29"
            ],
            "branch": "",
            "name": "_orphaned",
            "fwcode": {
                "codesections": [],
                "snippets": []
            },
            "current_revision": "",
            "id": "1fef341c-2b1d-42d3-ac9a-2da8d4ec4756"
        }
    ],
    "id": "58f73b41c3cc4800078010c5",
    "name": "My awesome project"
}
```

### Send a command to a device

In order to send messages to a device you have to send a POST request to the following API endpoint:

```
https://iottly.com/v1.0/project/<project id>/device/<device id>/command
```

The endpoint takes a JSON formatted object containing:

- *cmd_type*: the message name, as seen from the web interface
- *values*: an object containing the message options as configured in the web interface

We'll send an echo command which is available by default for each project using this payload: 

```
{
    "cmd_type": "echo",
    "values": {
        "echo.content": "hi there!"
    }
}
```

Please note that each message option name in values should be prefixed by the message name.

The following API call will send an *echo* command to the specified device.

```
$ curl -X POST -H 'Content-Type: application/json' -d '{"cmd_type": "echo", "values": {"echo.content": "hi there!"}}' https://iottly.com/v1.0/project/<project id>/device/<device id>/command
{
    "status": 200
}
```

#### HTTP status codes

- **200** Call succeded
- **400** Client submitted invalid data, see error key in the response
- **401** Client is not authenticated
- **403** Client does not have permission for the specified project or device
- **500** Something did go wrong

### Deploy firmware to devices

The following API will deploy your application to the specified deployment group. The API will deploy the branch associated to your deployment group.

```
$ curl -X POST https://iottly.com/v1.0/project/<project id>/deploymentgroups/<deployment group uuid>/flashfw
{
   "status": 200
}
```

#### HTTP status codes

- **200** Call succeded
- **401** Client is not authenticated
- **403** Client does not have permission for the specified project or device
- **500** Something did go wrong

### Read the message history of a device

The following API endpoint will return a list of messages sent to the specified device ordered from newer to older.

The endpoint takes two optional parameters sent as query string:

- *queryJson*: a JSON encoded MongoDB query, see below
- *numMessages*: the number of messages to retrieve, default 10, max 100

```
$ curl -H 'Content-Type: application/json' https://iottly.com/v1.0/project/<project id>/messages/<device id>
{
    "messages": [
        {...},
        {...},
        ...
    ],
    "status": 200
}
```

Each message is serialized in the following format:

* FIXME*: use a real one after https://github.com/tomorrowdata/iottly-web-ui/issues/10#issuecomment-285051534

```
{
    "messages": [
        {
            "_id": {
                "$oid": "58f73b5dc3cc4800078010ca"
            },
            "connectionstatus": "connected",
            "from": "a2792ce8-216f-477c-a5cc-4f7e9f407e29",
            "timestamp": {
                "$date": 1492597597019
            },
            "to": "58f73b41c3cc4800078010c5"
        }
    ],
    "status": 200
}
```

The message schema consists of the following key:

- type: possible values *iottlyagent* or *userdefined*. Used to distinguish messages from the Iottly platform from the user defined ones
- payload: contains the message as produced by the device, its content depends on the message
- devicetimestamp: the device timestamp of the message encoded as mongodb `jsonb Date type`, e.g. `{ "$date": 1485265750587 }`

#### Filtering syntax

Custom filtering is implemented using the python syntax for mongo query filters, see [mongo db documentation](https://docs.mongodb.com/manual/core/document/#document-query-filter) for all the available.

e.g. if we want to filter only the *echo* messages our call would be something like the following:

```
curl -b iottly_cookie -H 'Content-Type: application/json' https://iottly.com/v1.0/project/<project id>/messages/<device id>?queryJson=%7B%22echo%22%3A%20%7B%22%24exists%22%3A%20true%7D%7D
```

where the *queryJson* contains the url encoded representation of the following JSON:

```
{
    "echo": {
        "$exists": true
    }
}
```

#### Paginating results

*FIXME:* example does not work :(

Pagination can be implemented using the *queryJson* to filter the data by timestamp:

```
curl -b iottly_cookie -H 'Content-Type: application/json' https://iottly.com/v1.0/project/<project id>/messages/<device id>?queryJson=%7B%0D%0A%20%20%20%20%22timestamp%22%3A%20%7B%0D%0A%20%20%20%20%20%20%20%20%22%24lte%22%3A%20%7B%22%24date%22%3A%20%222017-04-19T10%3A47%3A58.133%22%7D%0D%0A%20%20%20%20%7D%0D%0A%7D
```

where the *queryJSON* contains the url encoded representation of the following JSON:

```
{
    "timestamp": {
        "$lte": {"$date": "2017-04-19T10:47:58.133Z"}
    }
}
```

#### HTTP status codes

- **200** Call succeded
- **400** Client submitted invalid data, see error key in the response
- **401** Client is not authenticated
- **403** Client does not have permission for the specified project or device
- **500** Something did go wrong

## Webhooks

The Iottly platform can send notification to external services of received messages via the Webhooks. Webhooks are configured from the Web UI. The Webhook urls are called as POST HTTP form urlencoded requests. The data sent consist of a *msg* key that contains the message encoded in JSON. Additional headers may be sent as configured in the Web UI.

### Support or Contact

Having trouble with the API? [contact support](mailto:iottly-support@tomorrowdata.io) and we’ll help you sort it out.
