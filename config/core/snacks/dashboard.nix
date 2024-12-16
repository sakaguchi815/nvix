{ helpers, ... }:
{
  plugins.snacks.settings.dashboard = {
    enabled = true;
    preset = {
      keys = [
        { icon = " "; key = "f"; desc = "Find File"; action = ":lua Snacks.dashboard.pick('files')"; }
        { icon = " "; key = "n"; desc = "New File"; action = ":ene | startinsert"; }
        { icon = " "; key = "g"; desc = "Find Text"; action = ":lua Snacks.dashboard.pick('live_grep')"; }
        { icon = " "; key = "r"; desc = "Recent Files"; action = ":lua Snacks.dashboard.pick('oldfiles')"; }
        { icon = " "; key = "c"; desc = "Config"; action = ":lua Snacks.dashboard.pick('files'; {cwd = vim.fn.stdpath('config')})"; }
        { icon = " "; key = "."; desc = "Last Session"; action = "<leader>q."; }
        { icon = " "; key = "q"; desc = "Quit"; action = ":qa"; }
      ];
      header = helpers.mkRaw #lua
        ''
          [[
          ███╗   ██╗██╗   ██╗██╗██╗  ██╗
          ████╗  ██║██║   ██║██║╚██╗██╔╝
          ██╔██╗ ██║██║   ██║██║ ╚███╔╝
          ██║╚██╗██║╚██╗ ██╔╝██║ ██╔██╗
          ██║ ╚████║ ╚████╔╝ ██║██╔╝ ██╗
          ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝  ╚═╝]]'';
    };

    sections = [
      { section = "header"; }
      { icon = " "; title = "Keymaps"; section = "keys"; indent = 2; padding = 1; }
      { icon = " "; title = "Recent Files"; section = "recent_files"; indent = 2; padding = 1; }
      { icon = " "; title = "Projects"; section = "projects"; indent = 2; padding = 1; }
      {
        pane = 2;
        icon = " ";
        desc = "Browse Repo";
        padding = 1;
        key = "b";
        action = helpers.mkRaw # lua
          ''
            function()
              Snacks.gitbrowse()
            end
          '';
      }
      (helpers.mkRaw ''
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              title = "Notifications",
              cmd = "gh notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "n",
              icon = " ",
              height = 3,
              enabled = true,
            },
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 3,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 10,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 10,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end
      '')
    ];
  };
}