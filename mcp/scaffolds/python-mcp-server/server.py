import asyncio
from mcp.server.fastmcp import FastMCP

# Initialize FastMCP server
mcp = FastMCP("demo-custom-server")

@mcp.tool()
def calculate_metrics(values: list[float]) -> dict:
    """Calculates statistical summary metrics for a list of numbers."""
    if not values:
        return {"error": "Empty dataset"}
    return {
        "count": len(values),
        "sum": sum(values),
        "mean": sum(values) / len(values),
        "min": min(values),
        "max": max(values)
    }

if __name__ == "__main__":
    mcp.run()
