{ pkgs, ... }:

{
  users.users.aquino = {
    description = "Vinicius Aquino";

    isNormalUser = true;
    extraGroups = [ "docker" "wheel" ];

    # Default - used for bootstrapping.
    password = "pw";
  };

  home-manager.users.aquino = {
    home = {
      packages = with pkgs; [
        tmux
        tmuxp
        tree
        htop
        wget
        unzip
        nmap
        gitRepo
      ];

      stateVersion = "23.05";
    };

    programs.bash.enable = true;

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;

      tmux.enableShellIntegration = true;
    };

    programs.git = {
      enable = true;

      delta = {
        enable = true;
        options.syntax-theme = "base16-256";
      };

      extraConfig = {
        core.sshCommand = "${pkgs.openssh}/bin/ssh -F ~/.ssh/config";
      };
    };

    programs.ssh = {
      extraConfig = ''
        Host *.ossystems.com.br
            HostkeyAlgorithms +ssh-rsa
            PubkeyAcceptedAlgorithms +ssh-rsa

        Host *.lab.ossystems
            ForwardAgent yes
            ForwardX11 yes
            ForwardX11Trusted yes
      '';
    };
  };
}
