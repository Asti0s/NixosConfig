**web_search.** Never summarize search output in your reply — cite the sources
and read the ones that matter (`fetch_content` for specific URLs,
`get_search_content` to re-read stored results). Use these defaults on every
call; override only when the user explicitly asks or the task clearly demands
it:

- `numResults: 6`; raise to ~10 only for multi-source comparisons or literature
  sweeps.
- `domainFilter` SEO-farm exclusions:
  `["-geeksforgeeks.org", "-w3schools.com", "-tutorialspoint.com", "-javatpoint.com", "-medium.com"]`.
  Add a positive filter only when a specific site is the known target.
- `recencyFilter` only for news or releases — it filters by publish date and
  hides canonical docs pages.
- Avoid `includeContent: true`; fetch the specific sources instead.
- If results are poor, rephrase the queries rather than escalating parameters.
