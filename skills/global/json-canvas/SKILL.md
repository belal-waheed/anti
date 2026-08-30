---
name: json-canvas
description: Schema specifications, coordinate layout algorithms, and generator patterns for Obsidian .canvas (JSON Canvas) files. Use when generating visual node maps, architecture flowcharts, mindmaps, or visual project boards in Obsidian.
---

# Obsidian JSON Canvas Generation & Layout Guide

Runbook for generating and modifying valid Obsidian `.canvas` files with collision-free coordinates.

## 1. JSON Canvas Specification (1.0)

A `.canvas` file is a JSON object containing `nodes` and `edges`:

```json
{
  "nodes": [
    {
      "id": "node_1",
      "type": "text",
      "text": "## API Gateway\n- Port: 8000",
      "x": 0,
      "y": 0,
      "width": 260,
      "height": 140,
      "color": "5"
    }
  ],
  "edges": [
    {
      "id": "edge_1",
      "fromNode": "node_1",
      "fromSide": "right",
      "toNode": "node_2",
      "toSide": "left",
      "label": "HTTP Forward"
    }
  ]
}
```

---

## 2. Node Types & Semantic Colors

- **Types:** `"text"` (markdown), `"file"` (vault note link), `"link"` (web URL), `"group"` (visual container).
- **Color Map:** `"1"`: Red/Alert, `"2"`: Orange/Next, `"3"`: Yellow/Note, `"4"`: Green/Done, `"5"`: Blue/Component, `"6"`: Purple/System.

---

## 3. Mathematical Coordinate Calculation

To prevent overlapping nodes, calculate coordinates iteratively:
```python
def calculate_node_positions(items, cols=3, width=280, height=160, gap=60):
    nodes = []
    for idx, item in enumerate(items):
        col, row = idx % cols, idx // cols
        nodes.append({
            "id": f"node_{idx + 1}",
            "type": "text",
            "text": item["text"],
            "x": col * (width + gap),
            "y": row * (height + gap),
            "width": width,
            "height": height,
            "color": item.get("color", "5")
        })
    return nodes
```

---

## 4. Verification & Testing

Validate `.canvas` file integrity:
1. **JSON Parsing & Schema Validation:**
   ```bash
   pwsh -NoProfile -Command "Get-Content 'D:/dev/obsidian/hola\board.canvas' | ConvertFrom-Json"
   ```
2. **Side Property Assertion:** Ensure all `fromSide` and `toSide` properties strictly equal `"top"`, `"bottom"`, `"left"`, or `"right"`.
3. **ID Uniqueness Check:** Verify zero duplicate `id` strings exist across nodes and edges.

---

## 5. Common Pitfalls & Negative Constraints

- **Never place nodes at identical coordinates:** Overlapping coordinates render nodes completely invisible in Obsidian.
- **Never use invalid side strings:** Values other than top, bottom, left, right will corrupt canvas rendering.
- **Never omit width and height:** All nodes require explicit numerical width and height dimensions.

