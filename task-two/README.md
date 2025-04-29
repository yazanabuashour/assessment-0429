# Task Two

Get VMSS instance details.

## Setup

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Usage

```
python get_vmss_instance_info.py -g <resource-group> -s <vmss-name> -i <instance-id> --sub <subscription-id> [--view] [-k <key_path>]
```

## Examples. I ran these against the instance I created in Task One

```
python get_vmss_instance_info.py \
    --subscription-id "****************" \
    --resource-group "rg-assessment-3tier" \
    --vmss-name "assessment-vmss" \
    --instance-id "1" --key "sku/name"
```

Output

`"Standard_A1_v2"`

```
python get_vmss_instance_info.py \
    --subscription-id "***************" \
    --resource-group "rg-assessment-3tier" \
    --vmss-name "assessment-vmss" \
    --instance-id "1" --view -k vm_agent/statuses/0/code
```

Output

`"ProvisioningState/succeeded"`
