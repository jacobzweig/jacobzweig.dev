export const site = {
  name: 'Jacob Zweig',
  url: 'https://jacobzweig.dev',
  description:
    'Projects by Jacob Zweig, a neuroscientist turned machine learning engineer who builds and tinkers in his free time. Written up so you can build your own.',
  github: 'https://github.com/jacobzweig',
  repo: 'jacobzweig/jacobzweig.dev',

  // Comments run on GitHub Discussions through giscus (https://giscus.app).
  // Each post gets a thread in the repo's Announcements category, which only
  // the owner and giscus can start, so the Discussions tab stays tidy.
  giscus: {
    repo: 'jacobzweig/jacobzweig.dev',
    repoId: 'R_kgDOVxSNyw',
    category: 'Announcements',
    categoryId: 'DIC_kwDOVxSNy84DLUFB',
  },

  // Visitor and download counts run on GoatCounter (https://www.goatcounter.com).
  // It sets no cookies and keeps no personal data, so there is no consent banner.
  // `goatcounter` is the site code: the "mycode" in mycode.goatcounter.com.
  // Leave it empty to switch counting off.
  analytics: {
    goatcounter: 'jacobzweig',
  },
};

// Things in progress that don't have a write-up yet. They show on the home
// page as capped wires. Delete the list to hide the section.
export const bench: { title: string; note: string }[] = [
  { title: 'Song-synced house lights', note: 'Sequencing the roofline to music. Still rehearsing.' },
  { title: 'Loudspeaker design optimizer', note: 'Letting a solver argue with me about cabinet volume.' },
];

export const wires = ['red', 'amber', 'green', 'blue', 'violet'] as const;
export type Wire = (typeof wires)[number];
