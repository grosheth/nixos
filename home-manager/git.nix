let
  email = "salledelavager@gmail.com";
  name = "Salledelavage";
in {
  programs.git = {
    enable = true;
    delta = {
      enable = false;
    };
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
    };
    userEmail = email;
    userName = name;
  };
}
