{
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      # Telemetry
      enableInstallTelemetry = false;
      enableAnalytics = false;

      # Display & Style
      markdown.codeBlockIndent = "";
      terminal.showTerminalProgress = true;
      outputPad = true;
      showCacheMissNotices = true;
      steeringMode = "all";

      # Models
      defaultProvider = "openrouter";
      defaultModel = "z-ai/glm-5.3-flash";
      defaultThinkingLevel = "medium";

      # Harness customization
      defaultProjectTrust = "always";
      packages = [
        "npm:pi-web-access"
      ];
      extensions = [
        "-builtin:codemode"
        "-builtin:tool-search"
        "-builtin:llama.cpp"
        "-builtin:mcp"
      ];
      compaction.enabled = false;
    };

    appendSystem = ''      **web_search.** Never summarize search output in your reply — cite the sources and read the ones that matter (`fetch_content` for specific URLs, `get_search_content` to re-read stored results). Use these defaults on every call; override only when the user explicitly asks or the task clearly demands it:

      - `numResults: 6`; raise to ~10 only for multi-source comparisons or literature sweeps.
      - `domainFilter` SEO-farm exclusions: `["-geeksforgeeks.org", "-w3schools.com", "-tutorialspoint.com", "-javatpoint.com", "-medium.com"]`. Add a positive filter only when a specific site is the known target.
      - Send 2–3 `queries` that differ in subtopic or phrasing, not just word order.
      - `recencyFilter` only for news or releases — it filters by publish date and hides canonical docs pages.
      - Avoid `includeContent: true`; fetch the specific sources instead.
      - If results are poor, rephrase the queries rather than escalating parameters.
    '';
  };

  home.sessionVariables.PI_CLIPBOARD_OSC52 = "1";
}
