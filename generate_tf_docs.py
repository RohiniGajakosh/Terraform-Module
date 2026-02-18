import json
from pathlib import Path

input_file = Path("providers-schema.json")
output_dir = Path("tf-docs")
output_dir.mkdir(exist_ok=True)

data = json.loads(input_file.read_text())

provider_schemas = data.get("provider_schemas", {})

for provider_name, provider in provider_schemas.items():
    provider_file = output_dir / f"{provider_name}.md"
    lines = []
    lines.append(f"# Provider {provider_name}\n")

    prov_schema = provider.get("provider", {})
    block = prov_schema.get("block", {})
    attrs = block.get("attributes", {})
    if attrs:
        lines.append("## Provider arguments\n")
        lines.append("| Name | Required | Type | Description |\n")
        lines.append("|------|----------|------|-------------|\n")
        for name, spec in attrs.items():
            required = "yes" if spec.get("required") else "no"
            atype = spec.get("type")
            desc = (spec.get("description") or "").replace("\n", " ")
            lines.append(f"| {name} | {required} | {atype} | {desc} |\n")

    res_schemas = provider.get("resource_schemas", {})
    for res_name, res_schema in res_schemas.items():
        block = res_schema.get("block", {})
        attrs = block.get("attributes", {})
        lines.append(f"\n## Resource {res_name}\n")
        lines.append("| Name | Required | Computed | Type | Description |\n")
        lines.append("|------|----------|----------|------|-------------|\n")
        for name, spec in attrs.items():
            required = "yes" if spec.get("required") else "no"
            computed = "yes" if spec.get("computed") else "no"
            atype = spec.get("type")
            desc = (spec.get("description") or "").replace("\n", " ")
            lines.append(f"| {name} | {required} | {computed} | {atype} | {desc} |\n")

    ds_schemas = provider.get("data_source_schemas", {})
    for ds_name, ds_schema in ds_schemas.items():
        block = ds_schema.get("block", {})
        attrs = block.get("attributes", {})
        lines.append(f"\n## Data Source {ds_name}\n")
        lines.append("| Name | Required | Computed | Type | Description |\n")
        lines.append("|------|----------|----------|------|-------------|\n")
        for name, spec in attrs.items():
            required = "yes" if spec.get("required") else "no"
            computed = "yes" if spec.get("computed") else "no"
            atype = spec.get("type")
            desc = (spec.get("description") or "").replace("\n", " ")
            lines.append(f"| {name} | {required} | {computed} | {atype} | {desc} |\n")

    provider_file.write_text("".join(lines))

print("Docs generated in ./tf-docs/")