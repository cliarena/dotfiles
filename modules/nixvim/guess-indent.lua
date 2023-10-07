local status_ok, GI = pcall(require, "guess-indent")
if not status_ok then
  return
end

GI.setup()
