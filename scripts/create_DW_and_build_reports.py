# Calling this python script automates the entire DataWarehouse building process
import getpass
import subprocess
import time
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
mysql_password = getpass.getpass("Enter MySQL password: ")

# Order of layers
layers = ["bronze", "silver", "gold"]

# 1️⃣ Run initialization script first
init_script = BASE_DIR / "init_database.sql"
print(f"\n=== Running initialization: {init_script.name} ===")
start = time.time()

result = subprocess.run(
    ["mysql", "--local-infile=1", "-u", "root", f"-p{mysql_password}", "-e", f"SOURCE {init_script};"],
    capture_output=True,
    text=True
)

if result.returncode != 0:
    print("❌ ERROR in init_database.sql")
    print(result.stderr)
    exit(1)

print(f"✅ Initialization completed in {int(time.time() - start)} seconds")

# 2️⃣ Loop through Bronze, Silver, Gold layers

for layer in layers:
    layer_dir = BASE_DIR / layer
    sql_files = sorted(layer_dir.glob("*.sql"))  # sorted alphabetically
    
    print(f"\n=== Running {layer.upper()} layer scripts ===")
    
    for sql_file in sql_files:
        print(f"\nRunning {sql_file.name}")
        start = time.time()

        result = subprocess.run(
            ["mysql", "--local-infile=1", "-u", "root", f"-p{mysql_password}", "-e", f"SOURCE {sql_file};"],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            print("❌ ERROR:")
            print(result.stderr)
            exit(1)

        print(f"✅ Completed in {int(time.time() - start)} seconds")
        
# 3️⃣ Run Data Analysis / Reporting scripts
analysis_dir = BASE_DIR / "data_analysis"
analysis_scripts = [
    analysis_dir / "customer_report.sql",
    analysis_dir / "product_report.sql"
]

print(f"\n=== Running DATA ANALYSIS / REPORTING scripts ===")

for sql_file in analysis_scripts:
    if not sql_file.exists():
        print(f"❌ Missing analysis script: {sql_file.name}")
        exit(1)

    print(f"\nRunning {sql_file.name}")
    start = time.time()

    result = subprocess.run(
        ["mysql", "--local-infile=1", "-u", "root", f"-p{mysql_password}", "-e", f"SOURCE {sql_file};"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print("❌ ERROR:")
        print(result.stderr)
        exit(1)

    print(f"✅ Report created in {int(time.time() - start)} seconds")

print("\n🎉 Data Warehouse build + Data Analysis completed successfully!")
