# jacobzweig.dev

Project write-ups. Astro, static output, no backend. Comments run on GitHub Discussions through giscus.

    npm install
    npm run dev      # http://localhost:4321, drafts visible
    npm run build    # production build in dist/, drafts excluded

## Add a project

1. Make a folder: `src/content/projects/<slug>/index.mdx`. Put photos next to it.
2. Fill in the frontmatter (see `govee-to-wled` for every field). `wire` picks the project's colour:
   red, amber, green, blue or violet. `draft: true` keeps it off the published site.
3. Write. These components are available in any post without importing them:
   - `<Figure src={img} alt="" caption="" wide />` (import the image at the top of the file; leave `src` off for a "photo needed" slot)
   - `<Bom items={[{ part, qty, price, href, note }]} />` parts list with a total
   - `<Pinout rows={[{ wire, color, signal, to, note }]} />` wire-by-wire table
   - `<Callout type="warning|note|tip" title="">`
   - `<Steps>` wraps `###` headings and numbers them
   - `<Todo>` a note to yourself, never published
4. Downloads go in `public/files/<slug>/` and are listed under `files:` in the frontmatter. Large CAD is better linked (MakerWorld, Printables, GitHub).

Site-wide text, the "on the bench" list and the giscus IDs are in `src/site.config.ts`. The About page is `src/pages/about.astro`.

## Visitor and download counts

Counting runs on [GoatCounter](https://www.goatcounter.com): no cookies, no consent banner. It is off
until `analytics.goatcounter` in `src/site.config.ts` holds the site code (the `mycode` in
`mycode.goatcounter.com`). Page views, referrers, browsers and countries then show on that dashboard.

Every link in a post's Files list reports a click event, named `download/<project>/<file>` for files
in `public/files/` and `link/<project>/<host>` for external ones. Those events are the download
counts. A file fetched by its direct URL, without a click on the post, is not counted, because
GitHub Pages keeps no server logs. Visits from `localhost` are never counted.

## Deploy

Pushing to `main` builds and publishes to GitHub Pages (`.github/workflows/deploy.yml`). `public/CNAME` sets the domain.
