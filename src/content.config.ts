import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';
import { wires } from './site.config';

const projects = defineCollection({
  loader: glob({ pattern: '**/index.{md,mdx}', base: './src/content/projects' }),
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      summary: z.string(),
      date: z.coerce.date(),
      updated: z.coerce.date().optional(),
      draft: z.boolean().default(false),
      wire: z.enum(wires).default('green'),
      cover: image().optional(),
      coverAlt: z.string().optional(),
      difficulty: z.string().optional(),
      time: z.string().optional(),
      cost: z.string().optional(),
      tools: z.array(z.string()).default([]),
      tags: z.array(z.string()).default([]),
      files: z
        .array(
          z.object({
            label: z.string(),
            href: z.string(),
            kind: z.string(), // "STEP", "3MF", "MakerWorld", "GitHub", "PDF"...
            size: z.string().optional(),
            note: z.string().optional(),
          }),
        )
        .default([]),
    }),
});

export const collections = { projects };
