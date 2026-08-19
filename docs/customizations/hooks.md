# Lifecycle Hooks (`hooks.json`) Specification

Lifecycle hooks execute custom shell scripts or commands at deterministic phases of the agent loop.

---

## 1. Supported Events

| Event | Phase | Matcher Required | Scope |
| :--- | :--- | :--- | :--- |
| `PreToolUse` | Before a tool executes | Yes (regex on tool name) | Intercept, validate, override args, block |
| `PostToolUse` | After a tool finishes | Yes (regex on tool name) | Post-execution linting, formatting, auditing |
| `PreInvocation` | Before LLM model inference | No | Inject system prompts, ephemeral context |
| `PostInvocation` | After LLM model inference | No | Validate responses, force continuation |
| `Stop` | When agent attempts to stop | No | Check completion criteria, block exit |

---

## 2. Contract & JSON Payload Specification

Hook commands receive JSON on `stdin` and output JSON on `stdout`.
All keys in payloads use **camelCase**.

### Common Input Payload (stdin):
```json
{
  "conversationId": "71996160-d42b-473b-a937-80e1c992379c",
  "workspacePaths": ["/path/to/repo"],
  "transcriptPath": "/path/to/transcript.jsonl",
  "artifactDirectoryPath": "/path/to/artifacts",
  "modelName": "gemini-pro"
}
```

### `PreToolUse` Output Payload (stdout):
```json
{
  "decision": "allow", // "allow", "deny", "ask", "force_ask"
  "reason": "Passed automated security check.",
  "overwrite": {
    "CommandLine": "npm test -- --runInBand"
  }
}
```
