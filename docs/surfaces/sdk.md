# Antigravity Python SDK (`google-antigravity`)

The Antigravity Python SDK allows developers to embed agentic pair programming, tool interception, and reasoning orchestration into Python applications and automated CI pipelines.

---

## 1. Installation

```bash
pip install google-antigravity
```

---

## 2. Programmatic Agent Lifecycle

```python
import asyncio
import sys
from google.antigravity import Agent, LocalAgentConfig, CapabilitiesConfig

async def main():
    config = LocalAgentConfig(
        system_instructions="You are an expert Python architect enforcing Clean Architecture.",
        capabilities=CapabilitiesConfig(
            allow_file_write=True,
            allow_terminal_exec=True
        )
    )

    async with Agent(config) as agent:
        response = await agent.chat("Analyze repository and propose refactoring plan.")

        # Stream real-time reasoning deltas
        async for thought in response.thoughts:
            print(f"[Reasoning] {thought}")

        # Stream generated output tokens
        async for token in response:
            sys.stdout.write(token)
            sys.stdout.flush()

        # Intercept tool calls
        async for call in response.tool_calls:
            print(f"[Tool Call] {call.name} -> {call.args}")

if __name__ == "__main__":
    asyncio.run(main())
```
