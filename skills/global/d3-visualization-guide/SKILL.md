---
name: d3-visualization-guide
description: Guide and patterns for building interactive, publication-quality data visualizations with D3.js (scales, axes, error bar plots, heatmaps, tooltips, zoom, and SVG export).
---

# D3.js Visualization Guide

## When to use this
Building interactive, publication-quality data visualizations, custom charts, scientific plots, or vector graphics using D3.js in web applications.

## Steps
1. **Bind Data & Selections:** Use `d3.select` and data joins (`.data().join()`) to manipulate SVG elements.
2. **Setup Scales & Axes:** Define domains and ranges using linear, band, or sequential scales, and render responsive axes.
3. **Add Interactivity:** Attach event listeners for tooltips, zooming (`d3.zoom`), and pan behaviors.
4. **Enable Export:** Provide vector SVG export capability using `XMLSerializer` and Blobs.

### Data Binding and Selections

```javascript
// Load research/analytics data
const data = await d3.csv("experiment_results.csv", d => ({
  condition: d.condition,
  measurement: +d.measurement,
  error: +d.standard_error
}));

// Create SVG container
const svg = d3.select("#chart")
  .append("svg")
  .attr("width", 800)
  .attr("height", 500);

// Bind data using join
svg.selectAll("circle")
  .data(data)
  .join("circle")
  .attr("cx", d => xScale(d.condition))
  .attr("cy", d => yScale(d.measurement))
  .attr("r", 5)
  .attr("fill", "#3B82F6");
```

### Scales and Axes

```javascript
// Linear scale for continuous measurements
const yScale = d3.scaleLinear()
  .domain([0, d3.max(data, d => d.measurement)])
  .range([height - margin.bottom, margin.top]);

// Band scale for categorical conditions
const xScale = d3.scaleBand()
  .domain(data.map(d => d.condition))
  .range([margin.left, width - margin.right])
  .padding(0.3);

// Render axes
svg.append("g")
  .attr("transform", `translate(0,${height - margin.bottom})`)
  .call(d3.axisBottom(xScale));

svg.append("g")
  .attr("transform", `translate(${margin.left},0)`)
  .call(d3.axisLeft(yScale).tickFormat(d3.format(".2f")));
```

## Chart Patterns

### Error Bar Plot

```javascript
function createErrorBarPlot(data, container) {
  const margin = { top: 40, right: 30, bottom: 60, left: 70 };
  const width = 700 - margin.left - margin.right;
  const height = 450 - margin.top - margin.bottom;

  const svg = d3.select(container)
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", `translate(${margin.left},${margin.top})`);

  const x = d3.scaleBand()
    .domain(data.map(d => d.group))
    .range([0, width])
    .padding(0.4);

  const y = d3.scaleLinear()
    .domain([0, d3.max(data, d => d.mean + d.sem) * 1.15])
    .range([height, 0]);

  // Draw bars
  svg.selectAll(".bar")
    .data(data)
    .join("rect")
    .attr("class", "bar")
    .attr("x", d => x(d.group))
    .attr("y", d => y(d.mean))
    .attr("width", x.bandwidth())
    .attr("height", d => height - y(d.mean))
    .attr("fill", (d, i) => d3.schemeTableau10[i]);

  // Draw error bars
  svg.selectAll(".error-line")
    .data(data)
    .join("line")
    .attr("x1", d => x(d.group) + x.bandwidth() / 2)
    .attr("x2", d => x(d.group) + x.bandwidth() / 2)
    .attr("y1", d => y(d.mean - d.sem))
    .attr("y2", d => y(d.mean + d.sem))
    .attr("stroke", "#333")
    .attr("stroke-width", 1.5);

  // Error bar caps
  const capWidth = 10;
  ["top", "bottom"].forEach(pos => {
    svg.selectAll(`.cap-${pos}`)
      .data(data)
      .join("line")
      .attr("x1", d => x(d.group) + x.bandwidth() / 2 - capWidth)
      .attr("x2", d => x(d.group) + x.bandwidth() / 2 + capWidth)
      .attr("y1", d => y(d.mean + (pos === "top" ? d.sem : -d.sem)))
      .attr("y2", d => y(d.mean + (pos === "top" ? d.sem : -d.sem)))
      .attr("stroke", "#333")
      .attr("stroke-width", 1.5);
  });

  // Axes
  svg.append("g")
    .attr("transform", `translate(0,${height})`)
    .call(d3.axisBottom(x))
    .selectAll("text")
    .style("font-size", "12px");

  svg.append("g")
    .call(d3.axisLeft(y))
    .selectAll("text")
    .style("font-size", "12px");
}
```

### Correlation Heatmap

```javascript
function createCorrelationHeatmap(matrix, labels, container) {
  const size = 500;
  const cellSize = size / labels.length;

  const colorScale = d3.scaleSequential(d3.interpolateRdBu)
    .domain([1, -1]);

  const svg = d3.select(container)
    .append("svg")
    .attr("width", size + 120)
    .attr("height", size + 120);

  const g = svg.append("g")
    .attr("transform", "translate(100, 20)");

  // Cells
  labels.forEach((rowLabel, i) => {
    labels.forEach((colLabel, j) => {
      g.append("rect")
        .attr("x", j * cellSize)
        .attr("y", i * cellSize)
        .attr("width", cellSize - 1)
        .attr("height", cellSize - 1)
        .attr("fill", colorScale(matrix[i][j]))
        .append("title")
        .text(`${rowLabel} vs ${colLabel}: ${matrix[i][j].toFixed(3)}`);

      g.append("text")
        .attr("x", j * cellSize + cellSize / 2)
        .attr("y", i * cellSize + cellSize / 2)
        .attr("text-anchor", "middle")
        .attr("dominant-baseline", "central")
        .style("font-size", "10px")
        .text(matrix[i][j].toFixed(2));
    });
  });

  // Labels
  g.selectAll(".row-label")
    .data(labels)
    .join("text")
    .attr("x", -8)
    .attr("y", (d, i) => i * cellSize + cellSize / 2)
    .attr("text-anchor", "end")
    .attr("dominant-baseline", "central")
    .style("font-size", "11px")
    .text(d => d);
}
```

## Interactivity

### Tooltips

```javascript
const tooltip = d3.select("body").append("div")
  .attr("class", "tooltip")
  .style("position", "absolute")
  .style("background", "rgba(0,0,0,0.8)")
  .style("color", "#fff")
  .style("padding", "8px 12px")
  .style("border-radius", "4px")
  .style("font-size", "12px")
  .style("pointer-events", "none")
  .style("opacity", 0);

svg.selectAll("circle")
  .on("mouseover", (event, d) => {
    tooltip.transition().duration(200).style("opacity", 1);
    tooltip.html(`<strong>${d.sample_id}</strong><br/>Value: ${d.measurement.toFixed(3)}`)
      .style("left", (event.pageX + 12) + "px")
      .style("top", (event.pageY - 28) + "px");
  })
  .on("mouseout", () => {
    tooltip.transition().duration(300).style("opacity", 0);
  });
```

### Zoom and Pan

```javascript
const zoom = d3.zoom()
  .scaleExtent([1, 20])
  .on("zoom", (event) => {
    chartGroup.attr("transform", event.transform);
  });

svg.call(zoom);
```

## Exporting Vector Figures

```javascript
function exportSVG(svgElement, filename = "figure.svg") {
  const serializer = new XMLSerializer();
  const svgString = serializer.serializeToString(svgElement);
  const blob = new Blob([svgString], { type: "image/svg+xml" });
  const url = URL.createObjectURL(blob);

  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  link.click();
  URL.revokeObjectURL(url);
}
```

## Things to avoid
- Avoid manipulating DOM elements outside of D3 data joins when rendering chart elements.
- Avoid hardcoding scale ranges/domains; compute them dynamically from dataset extremes.
- Avoid missing event cleanup or tooltip leakages on component unmount.
