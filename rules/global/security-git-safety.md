# Global Rule: Security & Git Safety

1. **Zero Hardcoded Credentials**:
   Never check in API keys, secrets, database passwords, or auth tokens. Use environment variables and `.env.example` templates.

2. **Safe SQL & Data Protection**:
   Always use parameterized queries. Prevent SQL injection and N+1 query patterns.

3. **Git Boundary Recommendations**:
   Never run Git commands directly. Recommend clean commit boundaries and provide Conventional Commit messages for the user.
