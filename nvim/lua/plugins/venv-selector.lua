-- lua/plugins/venv-selector.lua
return {
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      options = {
        enable_cached_venvs = false,
        cached_venv_automatic_activation = false,
        notify_user_on_venv_activation = true,
      },
    },
  },
}
