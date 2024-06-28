{
  description = "towry De flakes";

  outputs = {self}: {
    templates = {
      zellij-dev = {
        path = ./zellij-dev;
        description = "zellij development env";
      };
      rust-workspace = {
        path = ./rust-workspace;
        description = "rust workspace project template";
      };
    };
  };
}
