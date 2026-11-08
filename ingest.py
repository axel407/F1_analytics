import requests
import time
import json

from pathlib import Path

RAW_DIR = Path("data/raw")
ENDPOINTS = ["drivers", "laps", "stints", "pit", "session_result"]

BASE_URL = "https://api.openf1.org/v1"


def fetch(endpoint, params=None, max_retries=5):
    """Fetch the data from specific endpoint"""
    url = f"{BASE_URL}/{endpoint}"
    for attempt in range(max_retries):
        response = requests.get(url, params=params, timeout=30)

        if response.status_code == 429 or response.status_code >= 500:
            if attempt == max_retries - 1:
                break  # no attempts left, don't sleep for nothing

            # Prefer the server's Retry-After hint, else back off: 5, 10, 20, 40s
            retry_after = response.headers.get("Retry-After", "")
            wait = int(retry_after) if retry_after.isdigit() else 5 * 2**attempt
            print(
                f"{endpoint} {params}: HTTP {response.status_code}, retrying in {wait}s"
            )
            time.sleep(wait)
            continue

        if not response.ok:
            print(
                f"{endpoint} {params}: HTTP {response.status_code}: {response.text[:200]}"
            )

        response.raise_for_status()
        return response.json()

    raise RuntimeError(f"{endpoint} {params}: failed after {max_retries} attempts")


def get_sessions_by_year(
    year,
    session_name="Race",
):
    """fetch sessions keys by session name and year"""
    sessions = fetch("sessions", {"session_name": session_name, "year": year})
    session_keys = []
    for s in sessions:
        session_keys.append(s["session_key"])

    return session_keys


def write_json(path, data):
    """Write data to path as JSON, atomically (via a .tmp file + rename)."""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(".tmp")
    with open(tmp, "w") as f:
        json.dump(data, f)
    tmp.rename(path)


def save_data(endpoint, session_key):
    path = RAW_DIR / endpoint / f"{session_key}.json"
    if path.exists():
        return False

    path.parent.mkdir(parents=True, exist_ok=True)

    data = fetch(endpoint, {"session_key": session_key})

    tmp = path.with_suffix(".tmp")
    with open(tmp, "w") as f:
        json.dump(data, f)
    tmp.rename(path)

    return True


if __name__ == "__main__":
    laps = fetch("laps", {"session_key": 9472, "driver_number": 1})
    print(len(laps))
    print(laps[0])

    keys = get_sessions_by_year(2024)
    print(len(keys))
    print(keys)

    for i, session_key in enumerate(keys, start=1):
        print(f"[{i}/{len(keys)}] session {session_key}")
        for endpoint in ENDPOINTS:
            download = save_data(endpoint, session_key)
            if download:
                time.sleep(2)  # stay under the free tier's ~30 requests/minute
