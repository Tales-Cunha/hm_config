{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "direnv" ];
      theme = "";  # Use starship
    };

    # Essential aliases (focused and minimal)
    shellAliases = {
      # Home Manager (essential)
      hm = "home-manager switch";
      hm-edit = "home-manager edit";
      hm-diff = "home-manager diff";

      # Git essentials (core workflow)
      gst = "git status";
      gaa = "git add --all";
      gc = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gco = "git checkout";
      gb = "git branch";
      gd = "git diff";
      glog = "git log --oneline --graph --decorate";

      # Modern replacements (one per tool)
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -la --icons";
      tree = "eza --tree --icons";
      cd = "z";
      ps = "procs";
      du = "dust";
      df = "duf";
      top = "btop";

      # Editor (tmux integration)
      v = "nvim";
      vim = "nvim";
      
      # Tmux workflow
      tms = "tmux-sessionizer";
      ta = "tmux attach-session -t";
      tl = "tmux list-sessions";
      
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # System info
      info = "neofetch";
    };

    initContent = ''
      # Essential ZSH options
      setopt AUTO_CD HIST_IGNORE_DUPS SHARE_HISTORY HIST_VERIFY
      setopt APPEND_HISTORY INC_APPEND_HISTORY HIST_IGNORE_SPACE
      setopt CORRECT CORRECT_ALL
      
      # History configuration
      export HISTSIZE=10000
      export SAVEHIST=10000
      export HISTFILE=~/.zsh_history

      # Vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # History search
      bindkey '^R' history-incremental-search-backward
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # Tool integrations
      eval "$(direnv hook zsh)"
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"

      # PATH
      export PATH=$HOME/.local/bin:$PATH
      
      # Load additional functions if they exist
      [[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh
    '';

    envExtra = ''
      export EDITOR="nvim"
      export VISUAL="nvim"
      export BAT_THEME="TwoDark"
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold yellow)";
      };
      directory = {
        truncation_length = 3;
        style = "bold blue";
      };
      git_branch = {
        style = "bold purple";
      };
      git_status = {
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
      };
      nodejs = {
        format = "via [⬢ $version](bold green) ";
      };
      rust = {
        format = "via [⚙️ $version](red bold) ";
      };
      python = {
        format = "via [🐍 $version](bold yellow) ";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # Additional ZSH functions (essential productivity helpers)
  xdg.configFile."zsh/functions.zsh".text = ''
    # Quick project finder (integrates with tmux-sessionizer)
    proj() {
      local dir
      dir=$(find ~/projects ~/work ~/personal -maxdepth 2 -type d -name "*$1*" 2>/dev/null | head -1)
      if [[ -n "$dir" ]]; then
        cd "$dir"
        # Auto-start tmux session if not in tmux
        if [[ -z "$TMUX" ]]; then
          tmux-sessionizer "$dir"
        fi
      else
        echo "Project not found: $1"
      fi
    }
    
    # Extract any archive (universal extractor)
    extract() {
      if [ -f $1 ] ; then
        case $1 in
          *.tar.bz2|*.tbz2) tar xjf $1     ;;
          *.tar.gz|*.tgz)   tar xzf $1     ;;
          *.bz2)            bunzip2 $1     ;;
          *.gz)             gunzip $1      ;;
          *.tar)            tar xf $1      ;;
          *.zip)            unzip $1       ;;
          *.7z)             7z x $1        ;;
          *)                echo "'$1' cannot be extracted via extract()" ;;
        esac
      else
        echo "'$1' is not a valid file"
      fi
    }
    
    # Make and change to directory (with tmux integration)
    mkcd() {
      mkdir -p "$1" && cd "$1"
      # If it's a project directory, offer to start tmux session
      if [[ "$1" =~ (project|work|dev) ]] && [[ -z "$TMUX" ]]; then
        read "response?Start tmux session for $1? (y/n): "
        if [[ "$response" =~ ^[Yy]$ ]]; then
          tmux-sessionizer "$(pwd)"
        fi
      fi
    }
  '';
}
