---
title: Iottly developer documentation - API reference
---

# API reference

All the APIs endpoint described in this document are reachable at:

```
api.cloud.iottly.com/v1.0/
```

All the API endpoints return json data in the response body.
POST and PUT request may send a json payload when required by the API, in this case
the caller should provide a `Content-Type: application/json` header.

> __Note:__ Remember that all the calls to the iottly API MUST BE authenticated using the procedure described [here]({{'dev/api/basics#api-authentication' | relative_url}})

__Table of content__
>- **[Project inspection API](#project-inspection-api)**
>- **[Command API](#command-api)**
>- **[Message history API](#message-history-api)**


## Project inspection API

Get summary information about a __iottly project__

__GET__ `project/<PROJECT ID>/inspect`

### Response

- **200** OK
  - the response body will contain information on the specific project
  ```json
  {
    "id": "58f73b41c3cc4800078010c5",
    "name": "My awesome project",
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
    ]
  }
  ```
- **401** Unauthorized - Client is not authenticated
- **403** Forbidden - Client does not have permission for the specified project or device
- **500** Server Error

### Example request
```shell
curl -H 'Authentication: bearer <API KEY>' https://api.cloud.iottly.com/v1.0/project/<PROJECT ID>/inspect
```


## Command API
Send a command to a device

__POST__ `/project/<PROJECT ID>/device/<DEVICE ID>/command`

### Request body

The endpoint takes a json formatted object with the keys:

- **cmd_type**: the command type (one between the message type declared in the project)
- **values**: an object containing the comamand options (the format is specific for each command, you can find the format for each command in the __console__ panel of the iottly web interface)

> __Example request payload__
```
{
    "cmd_type": "echo",
    "values": {
        "echo.content": "hi there!"
    }
}
```
>
> __ATTENTION:__ Please note that each command option key in the values object should be prefixed by the command type.

### Response

- **200** OK
- **400** Client submitted invalid data, see error key in the response
- **401** Unauthorized - Client is not authenticated
- **403** Forbidden - Client does not have permission for the specified project or device
- **500** Server error


### Example request

```shell
curl -H 'Authentication: bearer <API KEY>' -H 'Content-Type: application/json' --data '{"cmd_type": "echo", "values": {"echo.content": "hi there!"}}' https://api.cloud.iottly.com/v1.0/project/<PROJECT ID>/device/<DEVICE ID>/command
```


## Message history API

Get the messages sent by a device _(from the newest to the oldest)_

__GET__ `project/<PROJECT ID>/messages/<DEVICE ID>`

### Request parameters
The endpoint takes two optional parameters sent as query string:

- **queryJson**: a URL-encoded MongoDB query,  see [mongo db documentation](https://docs.mongodb.com/manual/core/document/#document-query-filter) for all the available filters.
- **numMessages**: the number of messages to retrieve. (_default_ 10, _max_ 100)

### Response

- **200** OK
  - the response body contains the list of retrieved messages in json format 
    ```json
    {
      "status": 200,
      "messages": [
        {
          "from": "3781de91-d446-4c64-825d-756dd60f2dab",
          "timestamp": {
            "$date": "2017-09-20T00:33:27.230Z"
          },
          "to": "59c19cacecc01400075f3bc9",
          "devicetimestamp": {
            "$date": "2017-09-20T00:33:27.000Z"
          },
          "_id": {
            "$oid": "59c1b7578ae27a000779b32c"
          },
          "type": "userdefined",
          "payload": {
            "ECHO": {
              "echo": {
                "content": "IOTTLY hello world!!!!"
              }
            }
          }
        },
        {
         "from": "3781de91-d446-4c64-825d-756dd60f2dab",
         "timestamp": {
           "$date": "2017-09-21T12:24:41.392Z"
         },
         "to": "59c19cacecc01400075f3bc9",
         "devicetimestamp": {
           "$date": "2017-09-19T22:39:44.000Z"
         },
         "_id": {
           "$oid": "59c3af898ae27a000779b334"
         },
         "type": "iottlyagent",
         "payload": {
           "connectionstatus": "connected"
         }
       },

      ]
    }
    ```
    Each message has the following keys:
    - **from**: the UUID of the device that sent the message
    - **type**: possible values *iottlyagent* or *userdefined*. Used to distinguish messages from the iottly agent and from the user-defined firmware
    - **payload**: contains the message as produced by the device, its content depends on the message typy (_json object_)
    - **devicetimestamp**: the device timestamp of the message encoded as mongodb `jsonb Date type`

- **400** Client submitted invalid data, see error key in the response
- **401** Client is not authenticated
- **403** Client does not have permission for the specified project or device
- **500** Server Error


### Example request
```shell
curl -H 'Authentication: bearer <API KEY>' https://api.cloud.iottly.com/v1.0/project/<project id>/messages/<device id>
```
