{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Core settings
    clock24 = true;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    historyLimit = 10000;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      resurrect  # Save/restore sessions
      continuum  # Auto-save sessions
    ];

    extraConfig = ''
      # Prefix
      set -g prefix C-a
      unbind C-b
      bind-key C-a send-prefix

      # Base settings
      set -g pane-base-index 1
      set -g renumber-windows on
      set -g status-position top
      set -g focus-events on

      # Key bindings
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
      bind-key f run-shell "tmux neww tmux-sessionizer"
      
      # Pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Vi mode improvements
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # Simple, clean status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-left "#[fg=green][#S] "
      set -g status-right "#[fg=yellow]%H:%M #[fg=green]%d-%m"
      set -g window-status-current-style "fg=black,bg=green"
      
      # Pane borders
      set -g pane-border-style "fg=#444444"
      set -g pane-active-border-style "fg=green"

      # Session resurrection settings
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
