resource "google_network_services_tcp_route" "network_services_tcp_routes" {
  for_each = var.network_services_tcp_routes

  name            = each.value.name
  deletion_policy = each.value.deletion_policy
  description     = each.value.description
  gateways        = each.value.gateways
  labels          = each.value.labels
  meshes          = each.value.meshes
  project         = each.value.project

  dynamic "rules" {
    for_each = each.value.rules
    content {
      action {
        dynamic "destinations" {
          for_each = rules.value.action.destinations != null ? rules.value.action.destinations : []
          content {
            service_name = destinations.value.service_name
            weight       = destinations.value.weight
          }
        }
        idle_timeout         = rules.value.action.idle_timeout
        original_destination = rules.value.action.original_destination
      }
      dynamic "matches" {
        for_each = rules.value.matches != null ? rules.value.matches : []
        content {
          address = matches.value.address
          port    = matches.value.port
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

