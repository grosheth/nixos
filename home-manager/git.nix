let
  email = "salledelavager@gmail.com";
  name = "Salledelavage";
in {
  programs = {
    delta = {
      enable = false;
    };
  };
  programs.git = {
    enable = true;
    settings = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
      user = {
        name = name;
        email = email;
      };
    };
  };
}
