# Global Rule: UI/UX Craftsmanship (Anti-AI-Generic)

1. **Zero Emojis in User Interfaces**:
   Use precision SVG vector icons (Lucide, Heroicons, Radix Icons) instead of emoji characters.

2. **Reject AI Visual Clichés**:
   Avoid dark slate `#0f172a` backgrounds with glowing purple/cyan neon linear gradients. Design bespoke, context-appropriate palettes using OKLCH or tailored HSL color tokens.

3. **Spatial Rhythm & Typography**:
   - Strict 8px spatial grid (8, 16, 24, 32, 48px).
   - Distinctive typography pairings: display header + high-legibility body.
   - Strict WCAG AA contrast ratio compliance (minimum 4.5:1 for normal text).

4. **Modern CSS & Micro-Interactions**:
   - Tailwind CSS v4 CSS-first `@theme` variables.
   - Smooth 150-200ms cubic-bezier transitions.
   - Respect `prefers-reduced-motion`.
