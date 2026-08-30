---
name: d3-visualization-guide
description: Guide and patterns for building interactive, publication-quality data visualizations with D3.js (scales, axes, error bar plots, heatmaps, tooltips, zoom, and SVG export). Use when building custom charts, scientific figures, or SVG data maps.
---

# D3.js Visualization Guide

Runbook for constructing accessible, responsive data visualizations using D3.js.

## 1. Core Lifecycle & Data Binding

1. **Scales & Coordinate Mapping:** Compute domains dynamically using `d3.extent()` or `d3.max()`.
2. **Data Join:** Bind datasets using modern `svg.selectAll().data().join()`.
3. **Responsive Axes:** Render with `d3.axisBottom()` and `d3.axisLeft()`.
4. **Interactivity:** Attach isolated tooltip elements and zoom behaviors (`d3.zoom()`).
5. **Vector Export:** Serialize DOM to clean SVG using `XMLSerializer`.

```javascript
// Dynamic Scales Setup
const xScale = d3.scaleBand()
  .domain(data.map(d => d.group))
  .range([margin.left, width - margin.right])
  .padding(0.3);

const yScale = d3.scaleLinear()
  .domain([0, d3.max(data, d => d.value) * 1.1])
  .range([height - margin.bottom, margin.top]);

// Modern Data Join
svg.selectAll("rect.bar")
  .data(data)
  .join("rect")
  .attr("class", "bar")
  .attr("x", d => xScale(d.group))
  .attr("y", d => yScale(d.value))
  .attr("width", xScale.bandwidth())
  .attr("height", d => height - margin.bottom - yScale(d.value))
  .attr("fill", "#3B82F6");
```

---

## 2. Advanced Chart Templates

For complete implementations, consult:
- [Chart Patterns & Heatmaps](references/chart-patterns.md)

---

## 3. Tooltip & Interaction Standards

```javascript
const tooltip = d3.select("body").append("div")
  .attr("class", "d3-tooltip")
  .style("position", "absolute")
  .style("pointer-events", "none")
  .style("opacity", 0);

svg.selectAll(".bar")
  .on("mouseover", (event, d) => {
    tooltip.style("opacity", 1).html(`<strong>${d.group}</strong>: ${d.value}`);
  })
  .on("mousemove", (event) => {
    tooltip.style("left", `${event.pageX + 10}px`).style("top", `${event.pageY - 20}px`);
  })
  .on("mouseout", () => tooltip.style("opacity", 0));
```

---

## 4. Verification & Testing

Validate visualization correctness and memory safety:
1. **DOM Snapshot Testing:**
   ```bash
   npm test -- d3-chart.test.ts
   ```
2. **SVG ViewBox & Responsiveness:** Verify SVG contains valid `viewBox="0 0 W H"` attributes rather than static fixed pixel dimensions.
3. **Teardown Check:** Verify tooltips attached to `document.body` are removed on component unmount.

---

## 5. Common Pitfalls & Negative Constraints

- **Never manipulate SVG elements outside data joins:** Avoid manual `document.createElementNS` calls; use D3 selections.
- **Never hardcode scale domains:** Always derive domains from dataset extremes to prevent clipping.
- **Avoid tooltip orphan memory leaks:** Always clean up global tooltip elements when chart components unmount.
