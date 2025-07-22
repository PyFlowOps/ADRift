# ADRift

Navigating Architectural Decisions with Ease.

```mermaid
---
title: ADRift Design Flow
---

flowchart TB;
    st[Streamlit] --> new-adr[New ADR] --> Approval
    Approval[Approval/Augment] -- blob --- database[(PostgresSQL)] -- Display --- st
    database --> md[Markdown File Export]

```

## Encryption

To encrypt the credentials and other values in the config files, you can run the
Makefile commands.

NOTE: Before running the commands, you will need to generate the keys.

```bash
bash scripts/encryption/create_keys.sh
```

Once the keys are created, we will need to run the `.sops.yaml` augmentation.