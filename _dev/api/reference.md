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
>- **[License inspection API](#license-inspection-api)**
>- **[Device properties API](#device-properties-api)**
>- **[Command API](#command-api)**
>- **[Message history API](#message-history-api)**
>- **[Paginated messages API](#paginated-messages-api)**


## Project inspection API

Get summary information about a __iottly project__

__GET__ `project/<PROJECT_ID>/inspect`

### Response

- **200** OK
  - the response body will contain information on the specific project
  ```json
  {
    "id": "<the unique id of the project>",
    "name": "<the name of the project>",
    "projectgetagenturl": "<the download url of the agent specific to the project>",
    "agentfile": "<the agent installer filename>",
    "agentapihost": "<the project api hostname>",
    "board": "<the device type like Linux ARMv5>"
  }
  ```
- **401** Unauthorized - Client is not authenticated
- **403** Forbidden - Client does not have permission for the specified project
- **500** Server Error

### Example request
```shell
curl -H 'Authentication: bearer <API_KEY>' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/inspect
```


## License inspection API

Get summary information about the __license tokens__ available in your __iottly project__

__GET__ `project/<PROJECT_ID>/license/[<LICENSE_ID>]`

### Response


- **200** OK
  - the response body will contain information on the specific license or on all the licenses available
  ```json
  {
    "599f8661ae4efc9ab47ebfe76013bbae": {
      "status": "paired",
      "board": {
        "macaddress": "02:43:3d:0a:07:1f",
        "operatingstatus": "connected",
        "id": "9af78306-384e-4dbc-9d63-af21cc5496a8",
        "name": "board 1"
      }
    },
    "c11b659250ccf128e0bfee34f1b1ef64": {
      "status": "available",
      "board": {}
    },
    "1e01b0ae1820d23ec3bc246fda3f3a90": {
      "status": "available",
      "board": {}
    },
    "87adcfb4d719a0d1c86fdd1de07fed95": {
      "status": "available",
      "board": {}
    },
    "5f3b2ec15843943e873c0df2e919f7d9": {
      "status": "available",
      "board": {}
    }
  }
  ```
  - **401** Unauthorized - Client is not authenticated
  - **403** Forbidden - Client does not have permission for the specified project
  - **500** Server Error

### Example request
```shell
curl -H 'Authentication: bearer <API_KEY>' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/license
```

## Device properties API
### Device properties API - show

Get detailed information for each __device__ in your __iottly project__

__GET__ `project/<PROJECT_ID>/devices` for all devices

__GET__ `project/<PROJECT_ID>/device/<DEVICE_ID>/props` for one device

### Response


- **200** OK
  - the response body will contain information on the specific device or on all the devices in the project

  For all devices:
  ```json
  {
    "count": 2,
    "errors": null,
    "devices": [
      {
        "macaddress": "c8:3e:a7:01:5d:5f",
        "name": "Connect+",
        "installing": false,
        "pair_code": "",
        "fwsyncstatus": "sync",
        "operatingstatus": "connected",
        "token": "9597846beceaed8a874c77d11d4d2463",
        "agent_version": "1.7.4",
        "ID": "9a98b1e3-2934-47d8-8e92-992a8000e148",
        "deploymentgroup": "d598b9db-34b4-44bd-be02-3286db43043f"
      },
      {
        "macaddress": "b8:27:eb:ca:5e:ae",
        "name": "CORE",
        "installing": false,
        "pair_code": "",
        "fwsyncstatus": "sync",
        "operatingstatus": "connected",
        "token": "f7959c402db27ef973c636bafae8f11d",
        "agent_version": "1.7.4",
        "ID": "f0c84aa3-4506-4be1-b188-49bbc6e576ef",
        "deploymentgroup": "d598b9db-34b4-44bd-be02-3286db43043f"
      }
    ]
  }
  ```

  For one device:

  ```json
  {
    "macaddress": "c8:3e:a7:01:5d:5f",
    "name": "Connect+",
    "installing": false,
    "pair_code": "",
    "fwsyncstatus": "sync",
    "operatingstatus": "connected",
    "token": "9597846beceaed8a874c77d11d4d2463",
    "agent_version": "1.7.4",
    "ID": "9a98b1e3-2934-47d8-8e92-992a8000e148",
    "deploymentgroup": "d598b9db-34b4-44bd-be02-3286db43043f"
  }
  ```
  - **401** Unauthorized - Client is not authenticated
  - **403** Forbidden - Client does not have permission for the specified project
  - **500** Server Error

### Example request

All devices
```shell
curl -H 'Authentication: bearer <API_KEY>' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/devices
```
Single device
```shell
curl -H 'Authentication: bearer <API_KEY>' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/device/<DEVICE_ID>/props
```

### Device properties API - edit

Edit properties of one __device__ in your __iottly project__

__PUT__ `project/<PROJECT_ID>/device/<DEVICE_ID>/props`

### Response


- **200** OK
  - the response body will contain updated information on the specific device
  ```json
  {
    "macaddress": "c8:3e:a7:01:5d:5f",
    "name": "Connect",
    "deploymentgroup": "d598b9db-34b4-44bd-be02-3286db43043f",
    "installing": false,
    "pair_code": "",
    "fwsyncstatus": "sync",
    "operatingstatus": "connected",
    "token": "9597846beceaed8a874c77d11d4d2463",
    "ID": "9a98b1e3-2934-47d8-8e92-992a8000e148",
    "agent_version": "1.7.4"
  }
  ```
  - **400** Bad request - The request is malformed
  - **401** Unauthorized - Client is not authenticated
  - **403** Forbidden - Client does not have permission for the specified project
  - **500** Server Error

### Example request
```shell
curl -H 'Authentication: bearer <API_KEY>' -H 'Content-type: application/json' --data '{"name": "<DEVICE NAME>"}' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/device/<DEVICE_ID>/props
```

## Command API
Send a command to a device

__POST__ `/project/<PROJECT_ID>/device/<DEVICE_ID>/command`

### Request body

The endpoint takes a json formatted object with the keys:

- **cmd_type**: the command type (must be a message type declared in the project)
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
> __ATTENTION:__ Please note that each command option key in the values object should be prefixed by the command type followed by a dot.

### Response

- **200** OK
- **400** Client submitted invalid data, see error key in the response
- **401** Unauthorized - Client is not authenticated
- **403** Forbidden - Client does not have permission for the specified project or device
- **500** Server error


### Example request

```shell
curl -H 'Authentication: bearer <API_KEY>' -H 'Content-Type: application/json' --data '{"cmd_type": "echo", "values": {"echo.content": "hi there!"}}' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/device/<DEVICE_ID>/command
```

## Message history API

Get the messages sent by a device _(from the newest to the oldest)_

__GET__ `project/<PROJECT_ID>/messages/<DEVICE_ID>`

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
    - **payload**: contains the message as produced by the device, its content depends on the message type (_json object_)
    - **devicetimestamp**: the device timestamp of the message encoded as mongodb `jsonb Date type`

- **400** Client submitted invalid data, see error key in the response
- **401** Client is not authenticated
- **403** Client does not have permission for the specified project or device
- **500** Server Error


### Example request
```shell
curl -H 'Authentication: bearer <API_KEY>' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/messages/<DEVICE_ID>
```


## Paginated messages API
Get a specific number of messages sent by a device (_page by page and with the possibility of filtering them_)

__GET__ `project/<PROJECT_ID>/device/<DEVICE_ID>/messages/paginated`

### Request parameters

- **p**: page number to be retrieved
- **l**: the number of results in each page (_default 50, min 1, max 100_)
- **type**: filter messages by type, one of **all  userdefined \| iottlyagent**
- **from**: a timestamp represents the left limit for the desired temporal range (**left limit included**)
- **to**: a timestamp represents the right limit for the desired temporal range (**right limit excluded**)
- **sort**: one of **asc \| desc**, sort the results in ascending/descending temporal order (_default desc_)

### Response
- **200** OK
  - the response body contains the list of retrieved messages in json format
    ```json
    {
        "messages": [
          {
            "from": "3781de91-d446-4c64-825d-756dd60f2dab",
            "timestamp": "2018-07-27T17:50:04.968",
            "to": "59c19cacecc01400075f3bc9",
            "devicetimestamp": "2018-07-27T17:49:51",
            "type": "userdefined",
            "payload": {
                ...
            }
          },
          {
            "from": "3781de91-d446-4c64-825d-756dd60f2dab",
            "timestamp": "2018-07-27T17:50:04.967",
            "to": "59c19cacecc01400075f3bc9",
            "devicetimestamp": "2018-07-27T17:49:51",
            "type": "userdefined",
            "payload": {
                ...
            }
          }
        ]
     }

    ```  
    Each message has the following keys:
    - **from**: the UUID of the device that sent the message
    - **to**:  the ID of the project where the device is registered
    - **devicetimestamp**: the device timestamp of the message encoded as MongoDB `jsonb Date type`
    - **type**: one of *iottlyagent* \| *userdefined*. Used to distinguish messages from the iottly agent and from the user-defined firmware
    - **payload**: contains the message as produced by the device (_its content depends on the message type and is a json object)_

- **400** Invalid custom query
  - invalid query submitted by the client (_see the limit values of the parameters and its type_)
- **401** Client is not authenticated
- **403** Client does not have permission for the specified project
- **404** No messages retrieved with the specified parameters
- **500** Server Error


### Example request
```shell
curl -H 'Authentication: bearer <API_KEY>' https://api.cloud.iottly.com/v1.0/project/<PROJECT_ID>/device/<DEVICE_ID>/messages/paginated
```
