-- import plugin safely
local setup, reactextract = pcall(require, "react-extract")
if not setup then
  return
end

-- configure/enable gitsigns
reactextract.setup()
