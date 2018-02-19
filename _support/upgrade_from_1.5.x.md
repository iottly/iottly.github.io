---
title: Iottly support KB
---

# Upgrade agent from versions 1.5.x

To upgrade the agent from 1.5.x versions it is **strictly required** that you first apply the following snippet to the agent, carefully following this steps **prior to starting the upgrade of the agent version**:

1. navigate to the "Management Scripts" panel:
![Manage API keys page](/images/support/navigate_to_mgmtscripts.png)

2. select the "global" section
![Manage API keys page](/images/support/select_global_section.png)

3. copy this snippet:
 ```
import os
from iottly.settings import settings
fixsetting = {
  'DEVICE_FULLAGENT_UPLOAD_DIR': settings.DEVICE_UPGRADE_UPLOAD_DIR
}
settings.__dict__.update(fixsetting)
```

4. paste it  __at the end of the global section__:
![Manage API keys page](/images/support/paste_snippet.png)

5. click on "save"

6. click on "Flash over the air" and wait for it to be completed (green bars)

7. go back to the "Project settings panel" and safely proceed with the agent uprade


### Support or Contact

Having trouble with these steps? [contact support](mailto:iottly-support@tomorrowdata.io) and we’ll help you sort it out.
