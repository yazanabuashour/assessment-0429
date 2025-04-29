#!/usr/bin/env python3

import argparse
import json
import operator
import sys
from functools import reduce

from azure.core.exceptions import ResourceNotFoundError
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient


def _get_nested_item(data, keys):
    """Helper to traverse dicts."""
    try:
        return reduce(operator.getitem, keys, data)
    except (KeyError, TypeError, IndexError):
        return None


def fetch_vmss_instance_data(
    subscription_id, resource_group, vmss_name, instance_id, get_view=False
):
    """Fetches VMSS instance model or view data from Azure."""
    try:
        credential = DefaultAzureCredential()
        compute_client = ComputeManagementClient(credential, subscription_id)

        print(
            f"Fetching instance {'view' if get_view else 'model'} for "
            f"VMSS '{vmss_name}/{instance_id}' in RG '{resource_group}'...",
            file=sys.stderr,
        )

        if get_view:
            instance_obj = (
                compute_client.virtual_machine_scale_set_vms.get_instance_view(
                    resource_group_name=resource_group,
                    vm_scale_set_name=vmss_name,
                    instance_id=instance_id,
                )
            )
        else:
            instance_obj = compute_client.virtual_machine_scale_set_vms.get(
                resource_group_name=resource_group,
                vm_scale_set_name=vmss_name,
                instance_id=instance_id,
            )

        return instance_obj.as_dict()

    except ResourceNotFoundError:
        print(
            f"Error: VMSS instance '{instance_id}' not found in VMSS '{vmss_name}' "
            f"within resource group '{resource_group}'.",
            file=sys.stderr,
        )
        return None
    except Exception as e:
        print(f"An Azure API error occurred: {e}", file=sys.stderr)
        return None


def main():
    parser = argparse.ArgumentParser(
        description="Query Azure VM Scale Set Instance details.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""Example usage:
  Get full model:
    python get_vmss_instance_info.py -g MyRG -s MyVmss -i 0 --sub MySubId
  Get instance view:
    python get_vmss_instance_info.py -g MyRG -s MyVmss -i 1 --sub MySubId --view
  Get specific key from model:
    python get_vmss_instance_info.py -g MyRG -s MyVmss -i 0 --sub MySubId -k sku/name
  Get specific key from view:
    python get_vmss_instance_info.py -g MyRG -s MyVmss -i 0 --sub MySubId --view --key vm_agent/statuses
""",
    )
    parser.add_argument(
        "-g", "--resource-group", required=True, help="Resource Group name."
    )
    parser.add_argument("-s", "--vmss-name", required=True, help="VM Scale Set name.")
    parser.add_argument("-i", "--instance-id", required=True, help="VMSS Instance ID")
    parser.add_argument(
        "--sub",
        "--subscription-id",
        required=True,
        dest="subscription_id",
        help="Subscription ID.",
    )
    parser.add_argument(
        "-k",
        "--key",
        metavar="KEY_PATH",
        default=None,
    )
    parser.add_argument(
        "--view", action="store_true", help="Retrieve instance view (runtime status)."
    )

    args = parser.parse_args()

    instance_data = fetch_vmss_instance_data(
        args.subscription_id,
        args.resource_group,
        args.vmss_name,
        args.instance_id,
        get_view=args.view,
    )

    if instance_data is None:
        sys.exit(1)

    if args.key:
        key_parts = []
        for part in args.key.strip("/").split("/"):
            if part.isdigit():
                key_parts.append(int(part))
            else:
                key_parts.append(part)

        value = _get_nested_item(instance_data, key_parts)

        if value is not None:
            try:
                print(json.dumps(value, indent=2))
            except TypeError:
                print(str(value))
        else:
            data_type = "view" if args.view else "model"
            print(
                f"Error: Key path '{args.key}' not found in the instance {data_type}.",
                file=sys.stderr,
            )
            sys.exit(1)
    else:
        print(json.dumps(instance_data, indent=2, default=str))


if __name__ == "__main__":
    main()
