"""
Regenerate reformed_filter.lua from ReformedCharactersMapping.csv and LookalikeMapping.csv
Includes both Reformed mappings and lookalike fallbacks for characters without Unicode support
"""

import csv

# Read the Reformed character mappings
mappings = {}
with open('ReformedCharactersMapping.csv', 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        mappings[row['Traditional']] = row['Reformed']

print(f"✓ Loaded {len(mappings)} character mappings from CSV")

# Read the lookalike mappings (for characters without Unicode support)
lookalikes = {}
with open('LookalikeMapping.csv', 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        lookalikes[row['Traditional']] = row['Lookalike']

print(f"✓ Loaded {len(lookalikes)} lookalike mappings from CSV")

# Archaic multi-character compounds to suppress entirely (exact match)
suppress_compounds = {
  # (currently empty - all cases covered by suppress_patterns below)
}

# Archaic substrings: suppress any candidate whose original text contains these
# This handles all compounds (e.g. 甚麼 covers 為甚麼, 甚麼事, 甚麼是, etc.)
suppress_patterns = [
  '甚麼',  # archaic "what" - appears as 甚庅 after conversion; 什庅 is correct
  '全愈',  # non-standard variant of 痊癒; suppress in favour of 痊瘉
]

# Define ALL archaic variants to skip (20 total)
archaic_variants = {
  # Original 7 (removed 裏 - it should convert to 裡)
  '牀', '羣', '脣', '峯', '綫', '緻', '佈',
    # User-identified 15
    '僞', '溼', '衆', '薰', '覈', '豔', '麪', '孃', '嬢', '醸', '譲', '壌', '让', '癡', '貍'
}

# Generate Lua code
lua_code = f"""-- Reformed Chinese character filter
-- Converts Traditional characters to Reformed equivalents
-- With optional lookalike fallbacks for characters without Unicode support

-- Archaic variants to skip entirely ({len(archaic_variants)} mappings)
-- These appear in dictionary but we want only the modern forms
local archaic_skip = {{
"""

# Add archaic variants with proper line breaks (max 10 per line)
archaic_list = sorted(archaic_variants)
for i in range(0, len(archaic_list), 10):
    chunk = archaic_list[i:i+10]
    lua_code += "  "
    lua_code += ", ".join(f'["{c}"] = true' for c in chunk)
    lua_code += ",\n"

lua_code += f"""}}

local suppress_compounds = {{
  -- Archaic multi-character compounds to suppress entirely ({len(suppress_compounds)} entries)
"""

for compound in sorted(suppress_compounds):
    lua_code += f'  ["{compound}"] = true,\n'

lua_code += f"""}}

local suppress_patterns = {{
  -- Archaic substrings: suppress any candidate containing these ({len(suppress_patterns)} entries)
"""

for pattern in suppress_patterns:
    lua_code += f'  "{pattern}",\n'

lua_code += f"""}}

local reformed_map = {{
  -- Reformed character mappings ({len(mappings)} characters)
"""

# Add reformed mappings with proper line breaks (max 3 per line for readability)
mapping_pairs = [(k, v) for k, v in sorted(mappings.items())]
for i in range(0, len(mapping_pairs), 3):
    chunk = mapping_pairs[i:i+3]
    lua_code += "  "
    lua_code += ", ".join(f'["{k}"] = "{v}"' for k, v in chunk)
    lua_code += ",\n"

lua_code += f"""}}

local lookalike_map = {{
  -- Lookalike mappings for characters without Unicode support
  -- ({len(lookalikes)} characters)
"""

# Add lookalike mappings with proper line breaks (max 3 per line)
lookalike_pairs = [(k, v) for k, v in sorted(lookalikes.items())]
for i in range(0, len(lookalike_pairs), 3):
    chunk = lookalike_pairs[i:i+3]
    lua_code += "  "
    lua_code += ", ".join(f'["{k}"] = "{v}"' for k, v in chunk)
    lua_code += ",\n"

lua_code += """}

local function reformed_filter(input, env)
  -- Check if lookalikes are enabled (default: true)
  local use_lookalikes = env.engine.context:get_option("use_lookalikes")
  if use_lookalikes == nil then
    use_lookalikes = true  -- Default to enabled
  end

  -- Check if lookalike indication is enabled (default: false)
  local indicate_lookalikes =
    env.engine.context:get_option("indicate_lookalikes")

  for cand in input:iter() do
    local text = cand.text

    -- Skip archaic and suppressed candidates (exact match + substring checks)
    local should_skip = archaic_skip[text] or suppress_compounds[text]
    if not should_skip then
      for _, pattern in ipairs(suppress_patterns) do
        if text:find(pattern, 1, true) then
          should_skip = true
          break
        end
      end
    end
    if not should_skip then
      -- Convert any Traditional/archaic chars to Reformed or Lookalike
      local reformed_text = ""

      for char in text:gmatch("[%z\\1-\\127\\194-\\244][\\128-\\191]*") do
        local new_char = char
        local is_lookalike = false

        -- First, try lookalike mapping if enabled
        if use_lookalikes and lookalike_map[char] then
          new_char = lookalike_map[char]
          is_lookalike = true
        -- Otherwise, try reformed mapping
        elseif reformed_map[char] then
          new_char = reformed_map[char]
        end

        reformed_text = reformed_text .. new_char

        -- Add indicator immediately after this lookalike character
        if is_lookalike and indicate_lookalikes then
          reformed_text = reformed_text .. "ᴸ"  -- Superscript L (U+1D38)
        end
      end

      -- Fix: luna_pinyin serves 愈 where Traditional uses 癒 (Simplified merged them).
      -- Reformed keeps 愈 (度/比較, e.g. 愈來愈、每況愈下) and 瘉 (康復) distinct.
      -- Explicitly convert known healing compounds where luna_pinyin has 愈 for 癒.
      local healing_compounds = {
        "愈復", "愈合", "愈合斑",
        "治愈", "治愈率", "治愈系",
        "痊愈", "病愈", "療愈",
        "不治而愈", "大病初愈", "霍然而愈"
      }
      for _, compound in ipairs(healing_compounds) do
        if reformed_text:find(compound, 1, true) then
          reformed_text = reformed_text:gsub(compound, (compound:gsub("愈", "瘉")))
        end
      end

      -- If text was converted, create shadow candidate
      if reformed_text ~= text then
        local shadow_cand =
          cand:to_shadow_candidate(cand.type, reformed_text, cand.comment)
        yield(shadow_cand)
      else
        yield(cand)
      end
    end
  end
end

return reformed_filter
"""

# Write the Lua file to all platform lua/ folders
platform_lua_dirs = [
    '../Android/lua/reformed_filter.lua',
    '../iOS/lua/reformed_filter.lua',
    '../macOS/lua/reformed_filter.lua',
    '../Windows/lua/reformed_filter.lua',
]
for path in platform_lua_dirs:
    with open(path, 'w', encoding='utf-8') as f:
        f.write(lua_code)

print(f"✓ Generated reformed_filter.lua with {len(mappings)} mappings "
      f"and {len(lookalikes)} lookalikes")
print("\nNext step: Deploy with setup script")
