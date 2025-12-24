# Button styling guide

The repository snapshot currently only contains Git LFS pointer files, but once the Vue code is restored you can apply the new button styling defined in `button-style.css`.

## How to use
1. Import the stylesheet in your global entry point (e.g., `src/main.js`):
   ```js
   import './assets/button-style.css';
   ```
2. Apply the classes to your call-to-action buttons:
   ```vue
   <button class="cta-button">
     <span class="cta-button__icon">🍿</span>
     <span>立即购票</span>
   </button>

   <button class="cta-button cta-button--ghost">
     <span class="cta-button__icon">ℹ️</span>
     <span>了解详情</span>
   </button>
   ```

The `.cta-button` class adds a rounded pill appearance, shadows, and inline icon support to make actions more intuitive. Optional modifiers:
- `.cta-button--ghost`: subtle outline style for secondary actions.
- `.cta-button--danger`: attention-grabbing destructive style.
