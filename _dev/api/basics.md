---
title: Iottly developer documentation - API basic concepts
---

# Basic concepts about the iottly API

## API Authentication

APIs are authenticated using a secret token in the header of HTTP requests.

Authentication to the APIs is performed via HTTP Basic Authentication.

A request to an API should have an `Authentication: bearer <YOUR API KEY>` header like the example below (using curl):

```bash
$ curl -H "Authentication: bearer <PUT HERE YOUR API KEY>" https://api.cloud.iottly.com/v1.0/<api_specific_handler>
{<api response>}
```

All the APIs are authenticated. Unauthenticated calls will return a `401` HTTP status code.

 > __IMPORTANT__: API tokens permit access to your data, DO NOT share them.

## API errors
Calls to the iottly API may fail in case of an error. In this case a relevant
__HTTP__ status code is returned.
A more human-friendly description of the error is available in the `error` field
of the returned json.

## Obtaining an API token
You can obtain an API token through the [iottly web interface](https://cloud.iottly.com).
From your project's dashboard toggle the project settings area by clicking the
__OPEN__ button in the top-right corner of the screen and then navigate to the 
__"Manage API keys"__ section.

![Manage API keys page](/images/api/api_panel.png)

In the "Manage API keys" panel you can:
- review your API keys,
- create a new key
- and delete the ones that you don't use anymore

![Create an API key](/images/api/createkey.png)

To __add a new key__ simply insert a description and press the "Create new API key" button.

> __Note__: Giving a meaningful description to your API keys will later simplify the management and revocation of the keys.
> 
> So for example key names like:
>  - "Analytics", "Reporting" or "Dashboard" are good choices if the key is going to be used by an application
>  - "John Smith", "Operator 1" or "Testing Lab" are good choice when the key is going to be used by people 

## Testing the created token

If you want to test the API communication you can use the `ping` handler.

```shell
$ curl -H "Authentication: bearer <PUT HERE YOUR API KEY>" https://api.cloud.iottly.com/v1.0/project/ping
```
You should receive a response like this:
```json
{"status": "pong"}
```
in this case the communication with the iottly API is working correctly, you're good to go!

If you receive an error calling the `ping` handler try checking your network connectivity 
(or proxy configuration if required), if the problem persist feel free to 
[ping us directly](mailto:iottly-support@tomorrowdata.io) and we’ll help you sort it out.
