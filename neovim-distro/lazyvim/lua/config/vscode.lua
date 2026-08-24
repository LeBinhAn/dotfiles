-- lua/config/vscode.lua
if vim.g.vscode then
  local vscode = require("vscode")

  -- Map gcc để Toggle Comment dòng hiện tại (Normal mode)
  vim.keymap.set("n", "gcc", function()
    vscode.action("editor.action.commentLine")
  end, { desc = "Toggle comment line" })

  -- Map gc để Toggle Comment vùng đang chọn (Visual mode)
  vim.keymap.set("v", "gc", function()
    vscode.action("editor.action.commentLine")
  end, { desc = "Toggle comment selection" })

  -- 1. Bọc lại hàm nvim_win_set_cursor để không bao giờ quăng lỗi Crash
  local orig_set_cursor = vim.api.nvim_win_set_cursor
  vim.api.nvim_win_set_cursor = function(win, pos)
    local ok, err = pcall(orig_set_cursor, win, pos)
    if not ok then
      -- Nếu vị trí nằm ngoài buffer, tự động đưa con trỏ về dòng cuối cùng hợp lệ
      local line_count = vim.api.nvim_buf_line_count(0)
      local target_line = math.min(pos[1], line_count)
      target_line = math.max(1, target_line)
      pcall(orig_set_cursor, win, { target_line, 0 })
    end
  end

  -- 2. Tắt tính năng tự động nhảy con trỏ của Yanky khi dán trong VSCode
  -- (Yanky thường là thủ phạm chính gây lỗi này khi dán code)
  local ok_yanky, yanky = pcall(require, "yanky")
  if ok_yanky then
    yanky.setup({
      highlight = { on_put = false, on_yank = false },
      preserve_cursor_position = { enabled = false },
    })
  end

  -- 3. Đồng bộ lại Viewport khi chuyển tab VSCode
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    callback = function()
      vim.schedule(function()
        pcall(vim.cmd, "checktime")
      end)
    end,
  })
end
