{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Your Name"; # TODO: Change this to your name
    userEmail = "your@email.com"; # TODO: Change this to your email
    
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;
      
      # Better diffs and merges
      diff.algorithm = "patience";
      merge.conflictstyle = "diff3";
      merge.tool = "vimdiff";
      
      # Performance improvements
      core.preloadindex = true;
      core.fscache = true;
      gc.auto = 256;
      
      # Colors
      color.ui = "auto";
      
      # Aliases
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
        pushf = "push --force-with-lease";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
        graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
    
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
    
    ignores = [
      # OS
      ".DS_Store"
      "Thumbs.db"
      
      # Editors
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"
      
      # Build artifacts
      "node_modules/"
      "dist/"
      "build/"
      "target/"
      ".next/"
      
      # Logs
      "*.log"
      "logs/"
      
      # Environment
      ".env"
      ".env.local"
      ".env.*.local"
    ];
  };
}
