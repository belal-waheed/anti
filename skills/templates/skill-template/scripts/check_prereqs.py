import sys
import shutil

required_tools = ["node", "python"]
missing = [tool for tool in required_tools if not shutil.which(tool)]

if missing:
    print(f"Error: Missing required tools: {', '.join(missing)}")
    sys.exit(1)

print("All prerequisite tools available.")
sys.exit(0)
