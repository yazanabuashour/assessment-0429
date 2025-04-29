def get_nested_value(obj: dict, path: str):
    current = obj
    for key in path.split("/"):
        if not isinstance(current, dict):
            raise TypeError("Expected dict")
        current = current[key]
    return current


if __name__ == "__main__":
    example1 = {"a": {"b": {"c": "d"}}}
    print(get_nested_value(example1, "a/b/c"))

    example2 = {"x": {"y": {"z": "a"}}}
    print(get_nested_value(example2, "x/y/z"))
