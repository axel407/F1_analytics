import os
import sys
from pathlib import Path

import duckdb

ROOT = Path(__file__).parent
DB_PATH = ROOT / "f1.duckdb"
STAGING_DIR = ROOT / "sql" / "staging"
TESTS_DIR = ROOT / "sql" / "tests"


def build_staging(con):
    print("Building staging...")
    for path in sorted(STAGING_DIR.glob("*.sql")):
        con.execute(path.read_text())
        print(f"Done {path.stem}")


def run_tests(con):
    print("Running tests...")
    failures = 0
    for path in sorted(TESTS_DIR.glob("*.sql")):
        try:
            rows = con.execute(path.read_text()).fetchall()
        except duckdb.Error as e:
            print(f" ERROR {path.stem}: {e}")
            failures += 1
            continue

        if rows:
            print(f" FAIL {path.stem} ({len(rows)} rows)")
            for row in rows[:3]:
                print(f"        {row}")
            failures += 1
        else:
            print(f"  PASS {path.stem}")

    return failures


def main():
    os.chdir(ROOT)
    con = duckdb.connect(str(DB_PATH))

    try:
        build_staging(con)
        failures = run_tests(con)
    finally:
        con.close()

    print(f"\n{failures} test(s) failed" if failures else "\nAll tests passed")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
