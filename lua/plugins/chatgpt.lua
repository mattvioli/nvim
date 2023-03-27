local setup, chatgpt = pcall(require, "Comment")

if not setup then
	return
end

chatgpt.setup()
