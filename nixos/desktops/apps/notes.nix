{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Note-taking and Writing
    joplin-desktop # Note-taking and to-do application
    logseq # Privacy-first, open-source knowledge base
    obsidian # Knowledge base and note-taking app
    zettlr # Markdown editor for researchers and writers
  ];
}
