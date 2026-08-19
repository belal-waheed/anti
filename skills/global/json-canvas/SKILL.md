---
name: json-canvas
description: Schema specifications, coordinate layout algorithms, and generator patterns for Obsidian .canvas (JSON Canvas) files. Trigger when generating visual node maps, architecture flowcharts, mindmaps, or visual project boards in Obsidian.
---

# Obsidian JSON Canvas Generation & Layout Guide

## When to use this skill
Trigger whenever generating or modifying `.canvas` files (Obsidian JSON Canvas format) to visualize architecture, project mindmaps, or concept relationships.

---

## 1. JSON Canvas Specification (1.0)

A `.canvas` file is a JSON object containing an array of `nodes` and `edges`:

```json
{
  "nodes": [
    {
      "id": "node_1",
      "type": "text",
      "text": "## API Gateway\n- Port: 8000\n- Reverse proxy",
      "x": 0,
      "y": 0,
      "width": 260,
      "height": 140,
      "color": "1"
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

## 2. Standard Color Palettes & Node Types

### Node Types
- `"type": "text"`: Markdown text content inside `"text"`.
- `"type": "file"`: Embeds vault note inside `"file": "05-projects/app/_.md"`.
- `"type": "link"`: External web URL inside `"url"`.
- `"type": "group"`: Visual container grouping child nodes (`"label": "Backend Layer"`).

### Color Codes
- `"1"`: Red / Amber (Errors, Alerts, Critical Tasks)
- `"2"`: Orange (In Progress, `#next`)
- `"3"`: Yellow (Warning, Notes)
- `"4"`: Green (Completed, Success, `#now`)
- `"5"`: Cyan / Blue (Services, Core Components)
- `"6"`: Purple (Architecture, Metadata)

---

## 3. Mathematical Coordinate Layout Algorithm

To avoid node overlaps when auto-generating flowcharts, use a grid coordinate formula:

```python
def layout_grid(nodes_data: list[dict], cols: int = 3, card_w: int = 280, card_h: int = 160, gap_x: int = 60, gap_y: int = 60):
    canvas_nodes = []
    for idx, data in enumerate(nodes_data):
        col = idx % cols
        row = idx // cols
        
        pos_x = col * (card_w + gap_x)
        pos_y = row * (card_h + gap_y)
        
        canvas_nodes.append({
            "id": f"node_{idx + 1}",
            "type": "text",
            "text": data["text"],
            "x": pos_x,
            "y": pos_y,
            "width": card_w,
            "height": card_h,
            "color": data.get("color", "5")
        })
    return canvas_nodes
```

---

## Things to Avoid

- Avoid placing nodes at identical coordinates (causes visual stacking collision).
- Avoid invalid `fromSide` or `toSide` strings (only `"top"`, `"bottom"`, `"left"`, `"right"` are valid).
- Avoid non-unique node IDs within the same `.canvas` file.
