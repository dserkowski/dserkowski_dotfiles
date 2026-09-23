#!/usr/bin/env python3
"""Sum Docker RAM usage for containers whose name contains a given text.

Example:
  ./sum_docker_stats_by_name.py resources-only
"""

import re
import subprocess
import sys
from decimal import Decimal

UNITS_TO_GIB = {
    "b": Decimal(1) / 1024**3,
    "kib": Decimal(1) / 1024**2,
    "kb": Decimal(1000) / 1024**3,
    "mib": Decimal(1) / 1024,
    "mb": Decimal(1000**2) / 1024**3,
    "gib": Decimal(1),
    "gb": Decimal(1000**3) / 1024**3,
    "tib": Decimal(1024),
    "tb": Decimal(1000**4) / 1024**3,
}
MEMORY_RE = re.compile(r"^\s*([0-9]+(?:\.[0-9]+)?)\s*([A-Za-z]+)")


def to_gib(memory_usage: str) -> Decimal:
    """Convert the used part of Docker's '<used> / <limit>' value to GiB."""
    match = MEMORY_RE.match(memory_usage.split("/", 1)[0])
    if not match:
        raise ValueError(f"Cannot parse memory usage: {memory_usage}")
    value, unit = Decimal(match.group(1)), match.group(2).lower()
    if unit not in UNITS_TO_GIB:
        raise ValueError(f"Unsupported memory unit: {unit}")
    return value * UNITS_TO_GIB[unit]


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: ./sum_docker_stats_by_name.py <name-contains>")

    needle = sys.argv[1]
    try:
        result = subprocess.run(
            ["docker", "stats", "--no-stream", "--format", "{{.Name}}\t{{.MemUsage}}"],
            check=True,
            text=True,
            capture_output=True,
        )
    except FileNotFoundError:
        raise SystemExit("Error: Docker is not installed or is not on PATH.")
    except subprocess.CalledProcessError as error:
        raise SystemExit(error.stderr.strip() or "Error: docker stats failed.")

    containers = []
    for row in result.stdout.splitlines():
        name, separator, memory_usage = row.partition("\t")
        if not separator or needle not in name:
            continue
        containers.append((name, to_gib(memory_usage)))

    total = sum((usage for _, usage in containers), Decimal())
    print(f"RAM usage total: {total:.2f} GB")
    print("Per container usage:")
    if containers:
        for name, usage in containers:
            print(f"{name} -> {usage:.2f} GB")
    else:
        print(f"No containers with name containing: {needle}")


if __name__ == "__main__":
    main()