---
title: Iottly developer documentation - Webhooks
---
# Webhooks reference

The Iottly platform can send notifications of messages received from connected devices to external services using webhoks.

## Setup a webhook

 You can configure webhooks for your project through the [iottly web interface](https://cloud.iottly.com).
 From your project's dashboard toggle the project settings area by clicking the
 __OPEN__ button in the top-right corner of the screen and then navigate to the 
 __"Configure webhooks"__ section.

 ![Manage webhooks page](/images/api/webhookpanel.png)

 In the "Configure webhooks" panel you can:
 - view the active webhooks for your project,
 - set-up a new webhook
 - and delete the ones that you don't use anymore

 ![Setup a webhook](/images/api/createhook.png)

 To __set-up a new webhook__ simply insert:
 
- a __description__ of the purpose of the webhook
- the __url__ of your service
- a __list of HTTP headers__ that iottly will use when calling your service (up to 5 custom headers can be supplied)

and press "Save" when your are done.

> __Note:__ Right now you can set-up up to 5 webhooks in each project

## Webhooks in action

If you have configured one or more webhooks in your project, iottly will push a notification
to the __webhook url__ you have specified each time one of the devices attached to your project generate a message.

iottly will send an __HTTP POST request__ to the provided __webhook url__ with:

- the supplied __request headers__
- the message received as the request body (in json format)
    ```json
    {
      "msg": {
        //the message received from a device attached to the project
      }
    }
    ```
