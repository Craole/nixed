{ pkgs }:
{
  # Install Material Theme and Material Icon Theme extensions
  extensions = [
    "Equinusocio.vsc-material-theme"
    "PKief.material-icon-theme"
  ];

  # Apply Material Theme and Material Icon Theme
  settings = {
    "workbench.colorTheme" = "Material Theme";
    "workbench.iconTheme" = "material-icon-theme";
  };
}
