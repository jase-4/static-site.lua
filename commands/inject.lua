local lunamark = require("lunamark")

local function markdown_to_html(md_text)
  local writer = lunamark.writer.html.new()
  local parse = lunamark.reader.markdown.new(writer, { smart = true })
  local html, _ = parse(md_text)
  return html
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then error("Could not open file: " .. path) end
  local content = f:read("*a")
  f:close()
  return content
end

local function render_page(template, title, body)
  local result = template
  result = result:gsub("{{%s*title%s*}}", title)
  result = result:gsub("{{%s*content%s*}}", body)
  return result
end

local function write_file(path, html)
  local f = io.open(path, "w")
  if not f then error("Could not write to file: " .. path) end
  f:write(html)
  f:close()
end

-- Load template and markdown content
local layout = read_file("templates/layout.html")
local page_md = read_file("content/pages/index.md")

-- Convert Markdown to HTML
local page_html = markdown_to_html(page_md)

-- Render full page
local final_html = render_page(layout, "Home", page_html)

-- Output to file
write_file("dist/index.html", final_html)
