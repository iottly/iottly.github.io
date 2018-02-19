---
title: Iottly support KB
---

# Upgrade agent from versions 1.5.x

To upgrade the agent from 1.5.x versions it is **strictly required** that you first apply the following snippet to the agent, carefully following this steps **prior to starting the upgrade of the agent version**:

1. paste this snippet __at the end of the global section__ in the "Management scripts" panel:
 ```
import os
from iottly.settings import settings
fixsetting = {
  'DEVICE_FULLAGENT_UPLOAD_DIR': settings.DEVICE_UPGRADE_UPLOAD_DIR
}
settings.__dict__.update(fixsetting)
```
2. click on save
3. click on "Flash over the air" and wait for it to be completed (green bars)
4. proceed with the agent uprade

### Support or Contact

Having trouble with these steps? [contact support](mailto:iottly-support@tomorrowdata.io) and we’ll help you sort it out.
