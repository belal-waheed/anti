# D3.js Comprehensive Chart Patterns Reference

## Error Bar Plot Pattern

```javascript
export function createErrorBarPlot(data, container) {
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

  // Axes
  svg.append("g")
    .attr("transform", `translate(0,${height})`)
    .call(d3.axisBottom(x));

  svg.append("g")
    .call(d3.axisLeft(y));
}
```

## Correlation Heatmap Pattern

```javascript
export function createCorrelationHeatmap(matrix, labels, container) {
  const size = 500;
  const cellSize = size / labels.length;
  const colorScale = d3.scaleSequential(d3.interpolateRdBu).domain([1, -1]);

  const svg = d3.select(container)
    .append("svg")
    .attr("width", size + 120)
    .attr("height", size + 120);

  const g = svg.append("g").attr("transform", "translate(100, 20)");

  labels.forEach((rowLabel, i) => {
    labels.forEach((colLabel, j) => {
      g.append("rect")
        .attr("x", j * cellSize)
        .attr("y", i * cellSize)
        .attr("width", cellSize - 1)
        .attr("height", cellSize - 1)
        .attr("fill", colorScale(matrix[i][j]));
    });
  });
}
```
