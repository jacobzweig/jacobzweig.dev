import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import { site } from '../site.config';
import { getProjects, slugOf } from '../lib/projects';

export async function GET(context: APIContext) {
  const projects = await getProjects();
  return rss({
    title: site.name,
    description: site.description,
    site: context.site!,
    items: projects.map((p) => ({
      title: p.data.title,
      description: p.data.summary,
      pubDate: p.data.date,
      link: `/projects/${slugOf(p.id)}/`,
    })),
  });
}
