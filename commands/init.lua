local lfs = require("lfs")



local function read_file(path)
  local file, err = io.open(path, "r")
  if not file then
    error("Could not read template: " .. path .. ": " .. err)
  end
  local content = file:read("*a")  -- read entire file
  file:close()
  return content
end


local function write_file(path, contents)
  local file, err = io.open(path, "w")  -- "w" = write mode (overwrites)
  if not file then
    error("Failed to open file " .. path .. ": " .. err)
  end
  file:write(contents)
  file:close()
   --print("Created directory:", path)
end

local function add_templates(source, dest)
    -- Check if destination file already exists
    local test = io.open(dest, "r")
    if test then
        test:close()
        print("File already exists, skipping: " .. dest)
        return
    end

    -- Try to read the template file
    local content = ""
    local file = io.open(source, "r")
    if file then
        content = file:read("*a")
        file:close()
    else
        print("Template not found: " .. source .. " — creating empty file.")
    end

    -- Write new file only if it doesn't already exist
    local out, err = io.open(dest, "w")
    if not out then
        error("Failed to open file " .. dest .. ": " .. err)
    end
    out:write(content)
    out:close()
end

local function create_directory(path)
  local attr = lfs.attributes(path)
  if not attr then
    assert(lfs.mkdir(path), "Failed to create directory: " .. path)
    print("Created directory:", path)
  elseif attr.mode ~= "directory" then
    error(path .. " exists but is not a directory!")
  else
    print("Directory already exists:", path)
  end
end

-- local directories = {
--    content
-- }

local structure = {
  content = {
    pages = { "index.md", "about.md" },
    posts = { "post.md"}
  },
  static = {
    css = { "style.css", "theme.css" },
    js = { "script.js" },
    img = { },
    fonts = { },
  }
}

for root, folders in pairs(structure) do
   create_directory(root)

  for subdir, files in pairs(folders) do
    local path = root .. "/" .. subdir
    -- Create folder
   -- lfs.mkdir(path)
   print("Created directory:", path)
   create_directory(path)
    
    for _, file in ipairs(files) do
        local template_path = "templates/" .. file
        local file_path = path .. "/" .. file
        add_templates(template_path, file_path)
    end
  end
end


-- Example usage
-- ensure_directory("content")
-- ensure_directory("content/posts")
-- ensure_directory("static")
-- ensure_directory("static/js")
-- ensure_directory("static/css")
-- ensure_directory("static/img")
-- ensure_directory("static/fonts")
-- add_templates("templates/index.md", "content/index.md")
-- add_templates("templates/about.md", "content/about.md")
-- add_templates("templates/post.md", "content/posts/post.md")


