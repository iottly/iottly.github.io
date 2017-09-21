---
title: Iottly developer documentation - Webhooks
---
# Webhooks reference

The Iottly platform can send notifications of messages received from connected devices to external services using webhoks.

 Webhooks are configured from the Web UI. The Webhook urls are called as POST HTTP form urlencoded requests. The data sent consist of a *msg* key that contains the message encoded in JSON. Additional headers may be sent as configured in the Web UI.
