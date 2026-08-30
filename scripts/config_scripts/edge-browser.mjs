#!/usr/bin/env node
/**
 * Global Microsoft Edge Automation & Debugging CLI
 * Universal headless browser utility for DOM inspection, screenshots, and visual debugging.
 */
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const EDGE_PATH = 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';

if (!fs.existsSync(EDGE_PATH)) {
  console.error('ERROR: Microsoft Edge not found at:', EDGE_PATH);
  process.exit(1);
}

const args = process.argv.slice(2);
const command = args[0];

function printUsage() {
  console.log(`
Usage: node edge-browser.mjs <command> [options]

Commands:
  screenshot <url> [outputPath] [width] [height]  Capture a rendered viewport screenshot
  dump <url>                                      Render page and dump complete HTML/DOM
  pdf <url> [outputPath]                          Render page to PDF document
  check <url>                                     Verify page accessibility and extract title

Examples:
  node edge-browser.mjs screenshot https://example.com ./screenshot.png 1280 800
  node edge-browser.mjs dump http://localhost:3000
  node edge-browser.mjs check https://example.com
`);
}

if (!command || command === '--help' || command === '-h') {
  printUsage();
  process.exit(0);
}

if (command === 'screenshot') {
  const url = args[1];
  if (!url) {
    console.error('ERROR: Missing URL for screenshot');
    process.exit(1);
  }
  const outputPath = path.resolve(args[2] || 'edge-screenshot.png');
  const width = args[3] || '1280';
  const height = args[4] || '800';

  console.log(`[Edge] Capturing screenshot of ${url} to ${outputPath} (${width}x${height})...`);

  const proc = spawn(EDGE_PATH, [
    '--headless=new',
    '--disable-gpu',
    `--screenshot=${outputPath}`,
    `--window-size=${width},${height}`,
    '--hide-scrollbars',
    url
  ], { windowsHide: true });

  proc.on('close', (code) => {
    if (code === 0 && fs.existsSync(outputPath)) {
      const stats = fs.statSync(outputPath);
      console.log(`SUCCESS: Screenshot saved to ${outputPath} (${stats.size} bytes)`);
    } else {
      console.error(`ERROR: Failed to capture screenshot. Exit code: ${code}`);
      process.exit(code || 1);
    }
  });
} else if (command === 'dump') {
  const url = args[1];
  if (!url) {
    console.error('ERROR: Missing URL for dump');
    process.exit(1);
  }

  const proc = spawn(EDGE_PATH, [
    '--headless=new',
    '--disable-gpu',
    '--dump-dom',
    url
  ], { windowsHide: true });

  let out = '';
  proc.stdout.on('data', d => out += d);
  proc.stderr.on('data', d => {});

  proc.on('close', (code) => {
    if (code === 0) {
      process.stdout.write(out);
    } else {
      console.error(`ERROR: Edge exited with code: ${code}`);
      process.exit(code || 1);
    }
  });
} else if (command === 'pdf') {
  const url = args[1];
  if (!url) {
    console.error('ERROR: Missing URL for pdf');
    process.exit(1);
  }
  const outputPath = path.resolve(args[2] || 'page.pdf');

  const proc = spawn(EDGE_PATH, [
    '--headless=new',
    '--disable-gpu',
    `--print-to-pdf=${outputPath}`,
    url
  ], { windowsHide: true });

  proc.on('close', (code) => {
    if (code === 0 && fs.existsSync(outputPath)) {
      console.log(`SUCCESS: PDF saved to ${outputPath}`);
    } else {
      console.error(`ERROR: Failed to generate PDF. Exit code: ${code}`);
      process.exit(code || 1);
    }
  });
} else if (command === 'check') {
  const url = args[1];
  if (!url) {
    console.error('ERROR: Missing URL for check');
    process.exit(1);
  }

  const proc = spawn(EDGE_PATH, [
    '--headless=new',
    '--disable-gpu',
    '--dump-dom',
    url
  ], { windowsHide: true });

  let out = '';
  proc.stdout.on('data', d => out += d);

  proc.on('close', (code) => {
    if (code === 0) {
      const titleMatch = out.match(/<title>(.*?)<\/title>/i);
      console.log(`SUCCESS: Page loaded successfully (${url})`);
      console.log(`Page Title: ${titleMatch ? titleMatch[1].trim() : 'N/A'}`);
      console.log(`Rendered HTML Size: ${out.length} bytes`);
    } else {
      console.error(`ERROR: Failed to check page. Exit code: ${code}`);
      process.exit(code || 1);
    }
  });
} else {
  console.error(`Unknown command: ${command}`);
  printUsage();
  process.exit(1);
}
