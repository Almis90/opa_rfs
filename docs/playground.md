<script setup>
import { withBase } from 'vitepress'
</script>

# Interactive playground

The example application contains a polished responsive showcase and a
laboratory for changing the extent, dimension, base value, breakpoint, factor,
and enabled state in real time.

<div class="demo-actions">
  <a :href="withBase('/demo/#/demo')" target="_blank" rel="noreferrer">Open showcase</a>
  <a :href="withBase('/demo/#/laboratory')" target="_blank" rel="noreferrer">Open laboratory</a>
</div>

<iframe
  class="demo-frame"
  :src="withBase('/demo/#/demo')"
  title="opa_rfs interactive Flutter demo"
  loading="lazy"
></iframe>

The demo is compiled as a self-contained Flutter Web release with WebAssembly
and an automatic JavaScript fallback.
