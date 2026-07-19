import { defineConfig } from 'vitepress'

const apiReference = 'https://almis90.github.io/opa_rfs/api/'

export default defineConfig({
  title: 'opa_rfs',
  description: 'Fluid responsive sizing for Flutter',
  base: '/opa_rfs/',
  cleanUrls: true,
  lastUpdated: true,
  ignoreDeadLinks: [/^\/api\//, /^\/demo\//],
  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/opa_rfs/logo.svg' }],
    ['meta', { name: 'theme-color', content: '#147d92' }],
  ],
  themeConfig: {
    logo: '/logo.svg',
    siteTitle: 'opa_rfs',
    search: {
      provider: 'local',
    },
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Playground', link: '/playground' },
      { text: 'API', link: apiReference },
      {
        text: '1.0.0',
        items: [
          { text: 'Changelog', link: 'https://github.com/Almis90/opa_rfs/blob/main/CHANGELOG.md' },
          { text: 'pub.dev', link: 'https://pub.dev/packages/opa_rfs' },
        ],
      },
    ],
    sidebar: [
      {
        text: 'Start here',
        items: [
          { text: 'Getting started', link: '/guide/getting-started' },
          { text: 'How it works', link: '/guide/how-it-works' },
          { text: 'Choosing an API', link: '/guide/choosing-an-api' },
        ],
      },
      {
        text: 'Guides',
        items: [
          { text: 'Configuration', link: '/guide/configuration' },
          { text: 'Typed values', link: '/guide/typed-values' },
          { text: 'Widgets', link: '/guide/widgets' },
          { text: 'Typography', link: '/guide/typography' },
          { text: 'Accessibility', link: '/guide/accessibility' },
        ],
      },
      {
        text: 'Explore',
        items: [
          { text: 'Interactive playground', link: '/playground' },
          { text: 'API reference', link: apiReference },
        ],
      },
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/Almis90/opa_rfs' },
    ],
    editLink: {
      pattern: 'https://github.com/Almis90/opa_rfs/edit/main/docs/:path',
      text: 'Edit this page on GitHub',
    },
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2026 Almis',
    },
    outline: [2, 3],
  },
})
