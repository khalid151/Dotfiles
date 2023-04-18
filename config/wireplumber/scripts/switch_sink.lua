local config = ... or {}

metadata_om = ObjectManager {
  Interest {
    type = "metadata",
    Constraint { "metadata.name", "=", "default" },
  }
}

metadata_om:activate()

local change_sink = function (node, sink)
  if node == nil or sink == nil then
    Log.warning("Could not create link")
    return
  end
  local metadata = metadata_om:lookup()
  Log.info(string.format("%s -> %s", node.properties["node.name"], sink.properties["node.name"]))
  metadata:set(node["bound-id"], "target.node", "Spa:Id", sink["bound-id"])
end

om = ObjectManager {
  Interest {
    type = "node",
    Constraint(config.match),
  }
}

sink_om = ObjectManager {
  Interest {
    type = "node",
    Constraint(config.sink),
  }
}

om:connect("object-added", function(om, node)
  local sink = sink_om:lookup()
  change_sink(node, sink)
end)

om:activate()
sink_om:activate()
