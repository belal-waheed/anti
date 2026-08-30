import fs from 'fs';
import path from 'path';

const SKILLS_DIR = 'C:\\Users\\bel\\.gemini\\config\\skills';

function parseFrontmatter(content) {
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return { frontmatter: null, body: content };
  const rawYaml = match[1];
  const body = content.slice(match[0].length).trim();
  
  const nameMatch = rawYaml.match(/^name:\s*(.+)$/m);
  const descMatch = rawYaml.match(/^description:\s*(?:>-\s*|\s*)([\s\S]*?)(?=\n[a-z0-9_-]+:|$)/m);

  return {
    frontmatter: {
      name: nameMatch ? nameMatch[1].trim().replace(/^['"]|['"]$/g, '') : null,
      description: descMatch ? descMatch[1].trim().replace(/\s+/g, ' ').replace(/^['"]|['"]$/g, '') : null
    },
    body
  };
}

function auditSkill(skillName, skillPath) {
  const skillMdPath = path.join(skillPath, 'SKILL.md');
  const issues = [];
  let score = 10.0;

  if (!fs.existsSync(skillMdPath)) {
    return { name: skillName, score: 0, issues: ['Missing SKILL.md file'] };
  }

  const content = fs.readFileSync(skillMdPath, 'utf8');
  const lines = content.split(/\r?\n/);
  const lineCount = lines.length;
  const { frontmatter, body } = parseFrontmatter(content);

  // 1. Frontmatter Checks
  if (!frontmatter) {
    issues.push('Missing YAML frontmatter (---)');
    score -= 3.0;
  } else {
    if (!frontmatter.name) {
      issues.push('Missing name field in frontmatter');
      score -= 1.5;
    } else if (frontmatter.name !== skillName) {
      issues.push(`Name mismatch: "${frontmatter.name}" vs folder "${skillName}"`);
      score -= 0.5;
    }

    if (!frontmatter.description) {
      issues.push('Missing description in frontmatter');
      score -= 2.0;
    } else {
      if (frontmatter.description.length < 20) {
        issues.push('Description too short (< 20 chars)');
        score -= 1.0;
      }
      if (!/(use|trigger|guide|standards|patterns|workflows|when|conventions)/i.test(frontmatter.description)) {
        issues.push('Description lacks explicit trigger condition');
        score -= 0.5;
      }
    }
  }

  // 2. Token Density & Length
  if (lineCount > 250) {
    const hasReferences = fs.existsSync(path.join(skillPath, 'references'));
    if (!hasReferences) {
      issues.push(`File too long (${lineCount} lines) without references/ subfolder`);
      score -= 1.5;
    }
  }

  // 3. Anti-Slop / Fluff Detection
  const fluffRegex = /\b(in this tutorial|welcome to|let's explore|what is [a-z0-9]+|as an ai)\b/i;
  if (fluffRegex.test(body)) {
    issues.push('Contains conversational / tutorial fluff');
    score -= 1.5;
  }

  // 4. Verification & Testing Check
  const hasVerification = /(verification|testing|test suite|validate|verify|assert|npm test|pytest|dotnet test|vitest|check)/i.test(body);
  if (!hasVerification) {
    issues.push('Missing explicit verification or testing instructions');
    score -= 1.0;
  }

  // 5. Negative Constraints / Anti-Patterns Check
  const hasNegativeConstraints = /(never|do not|avoid|anti-pattern|pitfalls|common mistakes|guardrails|don't)/i.test(body);
  if (!hasNegativeConstraints) {
    issues.push('Missing negative constraints / anti-pattern rules');
    score -= 0.5;
  }

  score = Math.max(0, Math.min(10, Math.round(score * 10) / 10));

  return { name: skillName, lineCount, score, issues };
}

function run() {
  if (!fs.existsSync(SKILLS_DIR)) {
    console.error(`Skills directory not found: ${SKILLS_DIR}`);
    process.exit(1);
  }

  const entries = fs.readdirSync(SKILLS_DIR, { withFileTypes: true });
  const skillDirs = entries.filter(e => e.isDirectory()).map(e => e.name);

  console.log(`\nAuditing ${skillDirs.length} skills in ${SKILLS_DIR}...\n`);
  console.log('| Skill Name                     | Lines | Score /10 | Status |');
  console.log('| :----------------------------- | :---: | :-------: | :----- |');

  let totalScore = 0;
  const flagged = [];

  for (const name of skillDirs) {
    const res = auditSkill(name, path.join(SKILLS_DIR, name));
    totalScore += res.score;
    const status = res.score >= 9.0 ? 'PASS' : res.score >= 7.0 ? 'WARN' : 'FAIL';
    console.log(`| ${res.name.padEnd(30)} | ${String(res.lineCount || 0).padStart(5)} | ${res.score.toFixed(1).padStart(9)} | ${status.padEnd(6)} |`);
    if (res.issues.length > 0) {
      flagged.push(res);
    }
  }

  const avg = (totalScore / skillDirs.length).toFixed(1);
  console.log(`\nAverage Score: ${avg} / 10.0\n`);

  if (flagged.length > 0) {
    console.log(`Issues Found (${flagged.length} skills flagged):`);
    for (const item of flagged) {
      console.log(`\n[${item.name}] (Score: ${item.score}/10)`);
      for (const iss of item.issues) {
        console.log(`  - ${iss}`);
      }
    }
  } else {
    console.log('All skills pass with 10/10 compliance!');
  }
}

run();
