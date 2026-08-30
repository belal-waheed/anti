import fs from 'node:fs';

function main() {
  try {
    const input = fs.readFileSync(0, 'utf-8');
    if (!input || !input.trim()) {
      process.stdout.write(JSON.stringify({ decision: 'allow' }));
      return;
    }

    const payload = JSON.parse(input);
    const toolCall = payload.toolCall;

    if (!toolCall || toolCall.name !== 'run_command' || !toolCall.args) {
      process.stdout.write(JSON.stringify({ decision: 'allow' }));
      return;
    }

    let commandLine = toolCall.args.CommandLine || '';

    const isPwsh = /^\s*(pwsh|powershell)(\.exe)?\b/i.test(commandLine);
    const hasNoProfile = /\s+(-noprofile|-nop)\b/i.test(commandLine);

    if (isPwsh && !hasNoProfile) {
      const modifiedCommand = commandLine.replace(
        /^\s*(pwsh|powershell)(\.exe)?\b/i,
        (match) => `${match} -NoProfile`
      );

      process.stdout.write(
        JSON.stringify({
          decision: 'allow',
          overwrite: {
            CommandLine: modifiedCommand,
          },
        })
      );
      return;
    }

    process.stdout.write(JSON.stringify({ decision: 'allow' }));
  } catch (err) {
    process.stdout.write(JSON.stringify({ decision: 'allow' }));
  }
}

main();
