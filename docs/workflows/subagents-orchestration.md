# Subagent Orchestration & Delegation

Antigravity supports parallel autonomous subagents to execute long-running tasks or broad codebase surveys without cluttering the main conversation context.

---

## 1. Built-in Subagent Types

- **`research`**: Read-only agent equipped with search, file reading, and web lookup capabilities. Ideal for surveying massive codebases or external APIs.
- **`self`**: Clones the parent agent's configuration, full tool capabilities, and model for concurrent execution.
- **Custom Defined Agents (`define_subagent`)**: Dynamically creates specialized agents equipped with specific system prompts and tool permissions.

---

## 2. Reactive Lifecycle

Subagents run asynchronously in the background. The parent agent does not poll in a loop; the system triggers a reactive wakeup when a subagent finishes or sends a message.
