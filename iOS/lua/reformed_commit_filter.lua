-- Reformed Chinese commit filter
-- Transforms archaic variants to Reformed forms at commit time (when text is actually inserted)

local reformed_map = {
  -- Archaic to Reformed/Standard mappings (critical ones)
  ["爲"] = "為",
  ["衆"] = "众",
  ["豔"] = "艳",
  ["麪"] = "麺",
  ["佈"] = "布",
  ["僞"] = "偽",
  ["喫"] = "吃",
  ["纔"] = "才",
  ["峯"] = "峰",
  ["溼"] = "湿",
  ["牀"] = "床",
  ["綫"] = "線",
  ["緻"] = "致",
  ["羣"] = "群",
  ["脣"] = "唇",
  ["薰"] = "熏",
  ["裏"] = "里",
  ["覈"] = "核",
  ["讎"] = "仇",
}

local function commit_notifier(ctx)
  local commit_text = ctx:get_commit_text()

  if commit_text and commit_text ~= "" then
    -- Replace any archaic variants with Reformed forms
    local reformed_text = commit_text:gsub('.[\128-\191]*', function(char)
      return reformed_map[char] or char
    end)

    -- If text changed, update the commit text
    if reformed_text ~= commit_text then
      ctx:set_commit_text(reformed_text)
    end
  end
end

local function init(env)
  local engine = env.engine
  local context = engine.context

  context.commit_notifier:connect(commit_notifier)
end

return { init = init }
